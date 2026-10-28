-- NutriBuddy / Adim 10.16: Read-only checks.
-- Run each query separately in SQL Editor; never invoke the award RPC here.

-- 1. Confirm schema and secure created_at privileges. All four permissions: false.
SELECT
  t.tablo,
  pg_catalog.has_column_privilege(
    'authenticated', ('public.' || t.tablo)::regclass,
    'created_at', 'INSERT'
  ) AS can_insert_created_at,
  pg_catalog.has_column_privilege(
    'authenticated', ('public.' || t.tablo)::regclass,
    'created_at', 'UPDATE'
  ) AS can_update_created_at
FROM (VALUES ('logs'), ('water_entries')) t(tablo)
ORDER BY t.tablo;

-- 2. Confirm source code uses created_at for reward_day for BOTH record types.
-- Expect both TRUE. Other occurrences of logged_at/recorded_at are intentional:
-- they retain the 90-day event window and the original streak calculation.
WITH f AS (
  SELECT pg_catalog.pg_get_functiondef(
    'public.claim_buddy_rewards()'::regprocedure
  ) AS def
)
SELECT
  pg_catalog.strpos(def, '(l.created_at AT TIME ZONE ''UTC'')::date AS day_utc') > 0
    AS ogun_odul_gunu_sunucu_tarihi,
  pg_catalog.strpos(def, '(w.created_at AT TIME ZONE ''UTC'')::date AS day_utc') > 0
    AS su_odul_gunu_sunucu_tarihi
FROM f;

-- 3. Check ledger historical counts and no NULL day/slot.
SELECT source_kind AS odul_turu,
       count(*) AS toplam_odul,
       count(*) FILTER (WHERE reward_day IS NULL OR daily_slot IS NULL) AS eksik_gun_slot
FROM public.buddy_reward_claims
GROUP BY source_kind
ORDER BY source_kind;

-- 4. No limit excess and no duplicate slots.
WITH daily AS (
  SELECT user_id, source_kind, reward_day,
    count(*) AS n, count(DISTINCT daily_slot) AS distinct_n
  FROM public.buddy_reward_claims
  GROUP BY user_id, source_kind, reward_day
)
SELECT
  count(*) FILTER (
    WHERE (source_kind='meal' AND n > 3)
       OR (source_kind='water' AND n > 8)
  ) AS limit_asimi,
  count(*) FILTER (WHERE n <> distinct_n) AS tekrar_slot
FROM daily;

-- 5. Illustration ONLY, not a real award / no data modification.
-- Two offline events on different days, synced today, consume today's reward slots.
WITH examples AS (
  SELECT now() - interval '7 days' AS user_event_time, now() AS server_created_at
  UNION ALL
  SELECT now() - interval '2 days', now()
)
SELECT
  count(DISTINCT (user_event_time AT TIME ZONE 'UTC')::date) AS farkli_gunluk_gunu,
  count(DISTINCT (server_created_at AT TIME ZONE 'UTC')::date) AS odul_gunu
FROM examples;
