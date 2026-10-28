-- Stage 6 only. Run AFTER stages 2 and 5. Does not erase existing logs.
begin;

alter table public.logs
  add column if not exists recipe_details jsonb;
alter table public.logs
  drop constraint if exists logs_recipe_details_shape;
alter table public.logs
  add constraint logs_recipe_details_shape check (
    recipe_details is null or jsonb_typeof(recipe_details) = 'object'
  );
grant insert (recipe_details) on public.logs to authenticated;
grant update (recipe_details) on public.logs to authenticated;

-- Private per-user UTC daily count for recipe generations (15 calls/day).
create table if not exists private.recipe_usage_daily (
  user_id uuid not null references auth.users(id) on delete cascade,
  usage_day date not null,
  calls integer not null check (calls between 0 and 15),
  primary key (user_id, usage_day)
);

create or replace function public.reserve_recipe_request()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  consumed integer;
  owner_id uuid := (select auth.uid());
begin
  if owner_id is null then return false; end if;
  insert into private.recipe_usage_daily as quota (user_id, usage_day, calls)
  values (owner_id, (now() at time zone 'UTC')::date, 1)
  on conflict (user_id, usage_day)
  do update set calls = quota.calls + 1
  where quota.calls < 15
  returning calls into consumed;
  return consumed is not null;
end;
$$;
revoke all on function public.reserve_recipe_request() from public, anon;
grant execute on function public.reserve_recipe_request() to authenticated;
commit;
