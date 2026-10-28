-- NutriBuddy / Stage 2 — initial relational model and RLS.
-- Apply once to a NEW Supabase project, preferably through migrations.
-- Public users intentionally differs from Supabase-managed auth.users.
begin;

create schema if not exists private;

create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text check (display_name is null or char_length(display_name) <= 100),
  sex_for_calculation text check (sex_for_calculation in ('male', 'female') or sex_for_calculation is null),
  birth_date date,
  height_cm numeric(5,1) check (height_cm between 50 and 250),
  weight_kg numeric(6,2) check (weight_kg between 10 and 500),
  target_weight_kg numeric(6,2) check (target_weight_kg between 10 and 500),
  goal text check (goal in ('lose', 'gain', 'recomposition', 'maintain') or goal is null),
  activity_level text check (activity_level in ('sedentary', 'light', 'moderate', 'active', 'very_active') or activity_level is null),
  allergies text[] not null default '{}',
  chronic_conditions text[] not null default '{}',
  timezone text not null default 'UTC',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  revision bigint not null default 1
);

create table public.logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  logged_at timestamptz not null,
  name text not null check (char_length(name) between 1 and 200),
  meal_type text not null default 'other' check (meal_type in ('breakfast','lunch','dinner','snack','other')),
  source text not null default 'manual' check (source in ('manual','vision','ai_recipe')),
  calories_kcal integer not null default 0 check (calories_kcal between 0 and 20000),
  protein_g numeric(9,2) not null default 0 check (protein_g between 0 and 2000),
  carbs_g numeric(9,2) not null default 0 check (carbs_g between 0 and 2000),
  fat_g numeric(9,2) not null default 0 check (fat_g between 0 and 2000),
  fiber_g numeric(9,2) not null default 0 check (fiber_g between 0 and 2000),
  is_estimate boolean not null default true,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  revision bigint not null default 1
);

create table public.pets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users(id) on delete cascade,
  mood text not null default 'neutral' check (mood in ('neutral','happy','sad','energetic')),
  xp integer not null default 0 check (xp >= 0),
  gold integer not null default 0 check (gold >= 0),
  level integer not null default 1 check (level >= 1),
  streak_days integer not null default 0 check (streak_days >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  revision bigint not null default 1
);

create table public.items (
  id uuid primary key default gen_random_uuid(),
  sku text not null unique check (char_length(sku) between 1 and 80),
  name text not null check (char_length(name) between 1 and 100),
  slot text not null check (slot in ('hat','glasses','outfit','accessory')),
  asset_key text not null,
  gold_price integer not null check (gold_price >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.user_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  item_id uuid not null references public.items(id) on delete restrict,
  acquired_at timestamptz not null default now(),
  equipped boolean not null default false,
  unique (user_id, item_id)
);

create table public.weight_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  weight_kg numeric(6,2) not null check (weight_kg between 10 and 500),
  recorded_at timestamptz not null,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  revision bigint not null default 1
);

create table public.water_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  amount_ml integer not null check (amount_ml between 1 and 5000),
  recorded_at timestamptz not null,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  revision bigint not null default 1
);

create index logs_user_logged_at_idx on public.logs(user_id, logged_at desc);
create index weight_user_recorded_idx on public.weight_entries(user_id, recorded_at desc);
create index water_user_recorded_idx on public.water_entries(user_id, recorded_at desc);
create index inventory_user_idx on public.user_items(user_id);

-- Updating a row increases its server revision. Clients cannot write revision.
create function private.bump_record_revision()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  new.revision := old.revision + 1;
  return new;
end;
$$;

create trigger users_bump_revision before update on public.users
for each row execute function private.bump_record_revision();
create trigger logs_bump_revision before update on public.logs
for each row execute function private.bump_record_revision();
create trigger pets_bump_revision before update on public.pets
for each row execute function private.bump_record_revision();
create trigger weight_bump_revision before update on public.weight_entries
for each row execute function private.bump_record_revision();
create trigger water_bump_revision before update on public.water_entries
for each row execute function private.bump_record_revision();

-- SECURITY DEFINER is used only in an unexposed schema for an Auth trigger.
-- No user-supplied metadata is copied into health fields.
create function private.on_auth_user_created()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.users (id) values (new.id);
  insert into public.pets (user_id) values (new.id);
  return new;
end;
$$;

create trigger nutri_buddy_auth_user_created
  after insert on auth.users
  for each row execute function private.on_auth_user_created();

revoke all on function private.on_auth_user_created() from public, anon, authenticated;
revoke all on function private.bump_record_revision() from public, anon, authenticated;

-- RLS: deny anonymous clients and isolate each authenticated user's rows.
alter table public.users enable row level security;
alter table public.logs enable row level security;
alter table public.pets enable row level security;
alter table public.items enable row level security;
alter table public.user_items enable row level security;
alter table public.weight_entries enable row level security;
alter table public.water_entries enable row level security;

revoke all on public.users, public.logs, public.pets, public.items,
  public.user_items, public.weight_entries, public.water_entries
  from anon, authenticated;

grant select on public.users, public.logs, public.pets, public.items,
  public.user_items, public.weight_entries, public.water_entries to authenticated;

grant update (display_name, sex_for_calculation, birth_date, height_cm,
  weight_kg, target_weight_kg, goal, activity_level, allergies,
  chronic_conditions, timezone) on public.users to authenticated;

grant insert (id, user_id, logged_at, name, meal_type, source, calories_kcal,
  protein_g, carbs_g, fat_g, fiber_g, is_estimate, is_deleted)
  on public.logs to authenticated;
grant update (logged_at, name, meal_type, source, calories_kcal,
  protein_g, carbs_g, fat_g, fiber_g, is_estimate, is_deleted)
  on public.logs to authenticated;

grant insert (id, user_id, weight_kg, recorded_at, is_deleted)
  on public.weight_entries to authenticated;
grant update (weight_kg, recorded_at, is_deleted)
  on public.weight_entries to authenticated;

grant insert (id, user_id, amount_ml, recorded_at, is_deleted)
  on public.water_entries to authenticated;
grant update (amount_ml, recorded_at, is_deleted)
  on public.water_entries to authenticated;

-- Pets, shop catalog and inventory are read-only from the client.
-- XP, currency, rewards and purchases require trusted server operations (Stage 8).
create policy users_read_own on public.users for select to authenticated
  using (id = (select auth.uid()));
create policy users_update_own on public.users for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

create policy logs_read_own on public.logs for select to authenticated
  using (user_id = (select auth.uid()));
create policy logs_insert_own on public.logs for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy logs_update_own on public.logs for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy pets_read_own on public.pets for select to authenticated
  using (user_id = (select auth.uid()));
create policy items_read_active on public.items for select to authenticated
  using (active = true);
create policy user_items_read_own on public.user_items for select to authenticated
  using (user_id = (select auth.uid()));

create policy weight_read_own on public.weight_entries for select to authenticated
  using (user_id = (select auth.uid()));
create policy weight_insert_own on public.weight_entries for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy weight_update_own on public.weight_entries for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy water_read_own on public.water_entries for select to authenticated
  using (user_id = (select auth.uid()));
create policy water_insert_own on public.water_entries for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy water_update_own on public.water_entries for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

commit;
