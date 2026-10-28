-- NutriBuddy Stage 8: trusted, idempotent reward claims and catalog RPCs.
-- Apply after stage 2, 5 and 6 migrations. Do not rerun the initial schema.
begin;

create table if not exists public.buddy_reward_claims (
  user_id uuid not null references public.users(id) on delete cascade,
  source_kind text not null check (source_kind in ('meal','water')),
  source_id uuid not null,
  xp integer not null check (xp >= 0),
  gold integer not null check (gold >= 0),
  awarded_at timestamptz not null default now(),
  primary key (user_id, source_kind, source_id)
);

alter table public.buddy_reward_claims enable row level security;
revoke all on public.buddy_reward_claims from public, anon, authenticated;
-- The rewards ledger is exclusively changed by trusted functions.

insert into public.items (sku, name, slot, asset_key, gold_price, active)
values
  ('buddy_leaf_hat', 'Yaprak şapka', 'hat', 'hat_leaf', 12, true),
  ('buddy_sun_glasses', 'Güneş gözlüğü', 'glasses', 'glasses_sun', 18, true),
  ('buddy_green_scarf', 'Yeşil atkı', 'accessory', 'scarf_green', 25, true)
on conflict (sku) do nothing;

create or replace function public.claim_buddy_rewards()
returns table (earned_xp int, earned_gold int, total_xp int, total_gold int, current_level int, current_streak int)
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := (select auth.uid());
  v_xp int := 0;
  v_gold int := 0;
  v_new_xp int := 0;
  v_new_gold int := 0;
  v_total_xp int;
  v_total_gold int;
  v_level int;
  v_streak int := 0;
  v_days date[];
  v_anchor date;
  v_day date;
  v_today date := (now() at time zone 'utc')::date;
begin
  if v_user is null then
    raise exception 'authentication_required' using errcode = '28000';
  end if;

  -- Serializes competing calls for the same account.
  insert into public.pets(user_id) values (v_user)
    on conflict (user_id) do nothing;
  perform 1 from public.pets where user_id = v_user for update;

  -- Credit at most three distinct valid meal logs per UTC calendar day.
  with candidates as (
    select l.id,
      row_number() over (
        partition by (l.logged_at at time zone 'UTC')::date
        order by l.logged_at, l.id
      ) as day_rank
    from public.logs l
    where l.user_id = v_user and l.is_deleted = false
      and l.logged_at >= now() - interval '90 days'
      and l.logged_at <= now() + interval '1 minute'
  ), inserted as (
    insert into public.buddy_reward_claims(user_id, source_kind, source_id, xp, gold)
    select v_user, 'meal', c.id, 20, 4
    from candidates c where c.day_rank <= 3
    on conflict do nothing
    returning xp, gold
  ) select coalesce(sum(xp), 0)::int, coalesce(sum(gold), 0)::int
    into v_xp, v_gold from inserted;

  -- Credit at most eight moderate water entries per UTC calendar day.
  -- No rewards for huge single-glass entries or repeated synchronization.
  with candidates as (
    select w.id,
      row_number() over (
        partition by (w.recorded_at at time zone 'UTC')::date
        order by w.recorded_at, w.id
      ) as day_rank
    from public.water_entries w
    where w.user_id = v_user and w.is_deleted = false
      and w.amount_ml between 100 and 1000
      and w.recorded_at >= now() - interval '90 days'
      and w.recorded_at <= now() + interval '1 minute'
  ), inserted as (
    insert into public.buddy_reward_claims(user_id, source_kind, source_id, xp, gold)
    select v_user, 'water', c.id, 5, 1
    from candidates c where c.day_rank <= 8
    on conflict do nothing
    returning xp, gold
  ) select coalesce(sum(xp), 0)::int, coalesce(sum(gold), 0)::int
    into v_new_xp, v_new_gold from inserted;

  v_xp := v_xp + v_new_xp;
  v_gold := v_gold + v_new_gold;

  -- Positive streak only; inactive days never decrease earned XP or gold.
  select array_agg(d order by d desc) into v_days from (
    select distinct (logged_at at time zone 'UTC')::date d
    from public.logs where user_id = v_user and is_deleted = false
    union
    select distinct (recorded_at at time zone 'UTC')::date d
    from public.water_entries where user_id = v_user and is_deleted = false
  ) x where d <= v_today;

  if v_days is not null and array_length(v_days, 1) > 0 then
    v_anchor := v_days[1];
    if v_anchor >= v_today - 1 then
      foreach v_day in array v_days loop
        if v_day = v_anchor - v_streak then
          v_streak := v_streak + 1;
        else
          exit;
        end if;
      end loop;
    end if;
  end if;

  update public.pets p set
    xp = p.xp + v_xp,
    gold = p.gold + v_gold,
    level = 1 + floor(sqrt((p.xp + v_xp)::numeric / 100.0))::int,
    streak_days = v_streak,
    mood = case when v_xp > 0 then 'happy' else 'neutral' end
  where p.user_id = v_user
  returning p.xp, p.gold, p.level
    into v_total_xp, v_total_gold, v_level;

  return query select v_xp, v_gold, v_total_xp, v_total_gold,
                      v_level, v_streak;
end;
$$;

create or replace function public.buy_buddy_item(p_item_id uuid)
returns void language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := (select auth.uid());
  v_price integer;
  v_balance integer;
begin
  if v_user is null then
    raise exception 'authentication_required' using errcode = '28000';
  end if;
  select i.gold_price into v_price from public.items i
    where i.id = p_item_id and i.active = true;
  if not found then
    raise exception 'item_unavailable';
  end if;

  select p.gold into v_balance from public.pets p
    where p.user_id = v_user for update;
  if not found then
    raise exception 'pet_not_found';
  end if;
  if exists (select 1 from public.user_items
             where user_id = v_user and item_id = p_item_id) then
    raise exception 'item_already_owned';
  end if;
  if v_balance < v_price then
    raise exception 'insufficient_gold';
  end if;
  update public.pets set gold = gold - v_price where user_id = v_user;
  insert into public.user_items(user_id, item_id, equipped)
    values (v_user, p_item_id, false);
end;
$$;

create or replace function public.equip_buddy_item(p_item_id uuid)
returns void language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := (select auth.uid());
  v_slot text;
begin
  if v_user is null then
    raise exception 'authentication_required' using errcode = '28000';
  end if;
  select i.slot into v_slot from public.user_items ui
    join public.items i on i.id = ui.item_id
    where ui.user_id = v_user and ui.item_id = p_item_id and i.active = true;
  if not found then raise exception 'item_not_owned'; end if;

  update public.user_items ui set equipped = false
    from public.items i
    where ui.item_id = i.id and ui.user_id = v_user and i.slot = v_slot;
  update public.user_items set equipped = true
    where user_id = v_user and item_id = p_item_id;
end;
$$;

revoke all on function public.claim_buddy_rewards() from public, anon;
revoke all on function public.buy_buddy_item(uuid) from public, anon;
revoke all on function public.equip_buddy_item(uuid) from public, anon;
grant execute on function public.claim_buddy_rewards() to authenticated;
grant execute on function public.buy_buddy_item(uuid) to authenticated;
grant execute on function public.equip_buddy_item(uuid) to authenticated;

commit;
