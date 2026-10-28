-- Stage 5 extension only. NEVER rerun Stage 2 CREATE TABLE migration.
-- Preserve user-corrected nutrition facts and optional estimated micronutrients.
begin;
alter table public.logs
  add column if not exists vision_details jsonb;
alter table public.logs
  drop constraint if exists logs_vision_details_shape;
alter table public.logs
  add constraint logs_vision_details_shape check (
    vision_details is null or jsonb_typeof(vision_details) = 'object'
  );
-- Existing RLS policies continue to restrict the row owner.
grant insert (vision_details) on public.logs to authenticated;
grant update (vision_details) on public.logs to authenticated;
-- Private daily AI usage counter. The app cannot read or alter this table.
create table if not exists private.vision_usage_daily (
  user_id uuid not null references auth.users(id) on delete cascade,
  usage_day date not null,
  calls integer not null check (calls between 0 and 10),
  primary key (user_id, usage_day)
);

-- Atomically reserve one request for the JWT owner, up to 10 per UTC day.
create or replace function public.reserve_vision_request()
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
  insert into private.vision_usage_daily as quota (user_id, usage_day, calls)
  values (owner_id, (now() at time zone 'UTC')::date, 1)
  on conflict (user_id, usage_day)
  do update set calls = quota.calls + 1
  where quota.calls < 10
  returning calls into consumed;
  return consumed is not null;
end;
$$;
revoke all on function public.reserve_vision_request() from public, anon;
grant execute on function public.reserve_vision_request() to authenticated;
commit;
