-- Read-only structural checks; run manually from SQL Editor after migration.
-- Full RLS cross-user integration tests will require authenticated test sessions.
with targets as (
  select unnest(array[
    'users','logs','pets','items','user_items','weight_entries','water_entries'
  ]) as table_name
)
select t.table_name, c.relrowsecurity as rls_enabled,
       count(p.polname) as policy_count
from targets t
join pg_namespace n on n.nspname = 'public'
join pg_class c on c.relnamespace = n.oid and c.relname = t.table_name
left join pg_policy p on p.polrelid = c.oid
group by t.table_name, c.relrowsecurity
order by t.table_name;

-- Expected: exactly 7 tables, all with rls_enabled = true.
-- Anonymous role must not have direct table privileges.
select table_name,
  has_table_privilege('anon', format('public.%I',table_name), 'SELECT') as anon_can_select
from (values ('users'),('logs'),('pets'),('items'),('user_items'),
  ('weight_entries'),('water_entries')) v(table_name);
