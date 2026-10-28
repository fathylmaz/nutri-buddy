-- NutriBuddy Adim 10.6 — safe, read-only verification.
-- After the migration, all 3 queries must succeed. No changes to user records.

-- 1. Historical awards, backfilled dates/slots, maximum assigned slot per kind.
SELECT
  source_kind AS odul_turu,
  count(*) AS toplam_odul,
  count(*) FILTER (WHERE reward_day IS NULL OR daily_slot IS NULL)
    AS bos_gun_veya_slot,
  max(daily_slot) AS en_yuksek_slot
FROM public.buddy_reward_claims
GROUP BY source_kind
ORDER BY source_kind;

-- 2. No user / day has duplicate slots or more than the permitted total.
WITH per_day AS (
  SELECT user_id, source_kind, reward_day,
    count(*) AS reward_count,
    count(DISTINCT daily_slot) AS distinct_slots
  FROM public.buddy_reward_claims
  GROUP BY user_id, source_kind, reward_day
)
SELECT
  count(*) FILTER (
    WHERE (source_kind = 'meal'  AND reward_count > 3)
       OR (source_kind = 'water' AND reward_count > 8)
  ) AS limit_asimi,
  count(*) FILTER (WHERE reward_count <> distinct_slots)
    AS tekrar_eden_slot
FROM per_day;

-- 3. Structural checks and privilege review. Both constraints should exist.
SELECT conname AS kisit_adi, pg_catalog.pg_get_constraintdef(oid) AS tanim
FROM pg_catalog.pg_constraint
WHERE conrelid = 'public.buddy_reward_claims'::regclass
  AND conname IN (
    'buddy_reward_claims_daily_slot_key',
    'buddy_reward_claims_slot_range_check'
  )
ORDER BY conname;
