-- Run in Supabase SQL Editor after stage9 migration and indexing.
-- SQL Editor typically runs as privileged postgres: results here do not
-- independently prove RLS. Validate RLS with TWO test accounts in the app.
select count(*) as source_count,
  count(embedding) as indexed_count
from public.dietitian_knowledge;
-- Expected after index-dietitian-knowledge: 8 sources, 8 vectors.
select source_key, title, extensions.vector_dims(embedding) as dimensions
from public.dietitian_knowledge
where embedding is not null order by source_key;
-- Expected each indexed vector: 768 dimensions.
select tablename, rowsecurity from pg_tables
where schemaname='public' and tablename in
  ('dietitian_knowledge','dietitian_conversations','dietitian_messages');
-- Expected rowsecurity true for all 3.
-- Confirm authenticated doesn't have direct privileges on knowledge/message inserts.
select
  has_table_privilege('authenticated','public.dietitian_knowledge','SELECT')
    as direct_knowledge_read_allowed,
  has_table_privilege('authenticated','public.dietitian_messages','INSERT')
    as direct_message_insert_allowed;
-- Both should be false.
