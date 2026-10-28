-- NutriBuddy / Adim 10.16: Reliable server-created reward day.
-- Prerequisite: 202610270001_stage10_buddy_daily_caps.sql has been applied.
-- No table changes, no update/delete on user records or reward ledger.
-- Replaces only public.claim_buddy_rewards() implementation (same signature).
-- Run once in Supabase SQL Editor; keep this migration in source control.
-- Notes:
--   * History/diary dates continue to use logs.logged_at / water_entries.recorded_at.
--   * New reward claims use server-assigned logs.created_at /
--     water_entries.created_at as reward_day, capped by existing UNIQUE/CHECK.
--   * Previously awarded ledger entries, balances, inventory remain unchanged.
--   * Past offline entries synced in one UTC day share that day's reward cap.
--   * Timestamps are trusted for rewards only because authenticated cannot
--     INSERT/UPDATE created_at on these tables (confirmed in security review).
BEGIN;

-- Refuse to deploy if the prerequisite day/slot constraints were removed.
DO $block$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.buddy_reward_claims'::regclass
      AND conname = 'buddy_reward_claims_daily_slot_key'
  ) OR NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.buddy_reward_claims'::regclass
      AND conname = 'buddy_reward_claims_slot_range_check'
  ) THEN
    RAISE EXCEPTION 'prerequisite_daily_reward_constraints_missing';
  END IF;

  IF pg_catalog.has_column_privilege('authenticated', 'public.logs', 'created_at', 'INSERT')
     OR pg_catalog.has_column_privilege('authenticated', 'public.logs', 'created_at', 'UPDATE')
     OR pg_catalog.has_column_privilege('authenticated', 'public.water_entries', 'created_at', 'INSERT')
     OR pg_catalog.has_column_privilege('authenticated', 'public.water_entries', 'created_at', 'UPDATE') THEN
    RAISE EXCEPTION 'created_at_must_remain_server_controlled';
  END IF;
END;
$block$;

CREATE OR REPLACE FUNCTION public.claim_buddy_rewards()
RETURNS TABLE (
  earned_xp integer,
  earned_gold integer,
  total_xp integer,
  total_gold integer,
  current_level integer,
  current_streak integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
  v_user uuid := (SELECT auth.uid());
  v_xp integer := 0;
  v_gold integer := 0;
  v_new_xp integer := 0;
  v_new_gold integer := 0;
  v_total_xp integer;
  v_total_gold integer;
  v_level integer;
  v_streak integer := 0;
  v_days date[];
  v_anchor date;
  v_day date;
  v_today date := (now() AT TIME ZONE 'UTC')::date;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING errcode = '28000';
  END IF;

  -- Serialize competing reward RPCs for the same account.
  INSERT INTO public.pets (user_id)
    VALUES (v_user)
    ON CONFLICT (user_id) DO NOTHING;
  PERFORM 1 FROM public.pets
    WHERE user_id = v_user FOR UPDATE;

  -- Meals: award by immutable server-created UTC date, NOT editable logged_at.
  -- Preserve the meal timestamp for diary/charts.  Backdated offline entries
  -- synced together consume only the server day's three reward slots.
  WITH candidates AS (
    SELECT
      l.id AS source_id,
      (l.created_at AT TIME ZONE 'UTC')::date AS day_utc,
      l.created_at AS created_time
    FROM public.logs AS l
    WHERE l.user_id = v_user
      AND l.is_deleted = false
      AND l.created_at >= now() - interval '90 days'
      AND l.logged_at >= now() - interval '90 days'
      AND l.logged_at <= now() + interval '1 minute'
      AND NOT EXISTS (
        SELECT 1 FROM public.buddy_reward_claims AS r
        WHERE r.user_id = v_user AND r.source_kind = 'meal'
          AND r.source_id = l.id
      )
  ), ranked_candidates AS (
    SELECT source_id, day_utc,
      row_number() OVER (
        PARTITION BY day_utc ORDER BY created_time, source_id
      ) AS candidate_rank
    FROM candidates
  ), free_slots AS (
    SELECT d.day_utc, s.slot,
      row_number() OVER (
        PARTITION BY d.day_utc ORDER BY s.slot
      ) AS available_rank
    FROM (SELECT DISTINCT day_utc FROM ranked_candidates) AS d
    CROSS JOIN pg_catalog.generate_series(1, 3) AS s(slot)
    WHERE NOT EXISTS (
      SELECT 1 FROM public.buddy_reward_claims AS r
      WHERE r.user_id = v_user AND r.source_kind = 'meal'
        AND r.reward_day = d.day_utc AND r.daily_slot = s.slot
    )
  ), inserted AS (
    INSERT INTO public.buddy_reward_claims
      (user_id, source_kind, source_id, xp, gold, reward_day, daily_slot)
    SELECT v_user, 'meal', c.source_id, 20, 4, c.day_utc, s.slot
    FROM ranked_candidates AS c
    JOIN free_slots AS s
      ON s.day_utc = c.day_utc
     AND s.available_rank = c.candidate_rank
    ON CONFLICT DO NOTHING
    RETURNING xp, gold
  )
  SELECT coalesce(sum(xp), 0)::integer, coalesce(sum(gold), 0)::integer
    INTO v_xp, v_gold FROM inserted;

  -- Water: award by immutable server-created UTC date, NOT editable recorded_at.
  -- Preserve the water timestamp for diary/charts.  Backdated offline entries
  -- synced together consume only the server day's eight reward slots.
  WITH candidates AS (
    SELECT
      w.id AS source_id,
      (w.created_at AT TIME ZONE 'UTC')::date AS day_utc,
      w.created_at AS created_time
    FROM public.water_entries AS w
    WHERE w.user_id = v_user
      AND w.is_deleted = false
      AND w.amount_ml BETWEEN 100 AND 1000
      AND w.created_at >= now() - interval '90 days'
      AND w.recorded_at >= now() - interval '90 days'
      AND w.recorded_at <= now() + interval '1 minute'
      AND NOT EXISTS (
        SELECT 1 FROM public.buddy_reward_claims AS r
        WHERE r.user_id = v_user AND r.source_kind = 'water'
          AND r.source_id = w.id
      )
  ), ranked_candidates AS (
    SELECT source_id, day_utc,
      row_number() OVER (
        PARTITION BY day_utc ORDER BY created_time, source_id
      ) AS candidate_rank
    FROM candidates
  ), free_slots AS (
    SELECT d.day_utc, s.slot,
      row_number() OVER (
        PARTITION BY d.day_utc ORDER BY s.slot
      ) AS available_rank
    FROM (SELECT DISTINCT day_utc FROM ranked_candidates) AS d
    CROSS JOIN pg_catalog.generate_series(1, 8) AS s(slot)
    WHERE NOT EXISTS (
      SELECT 1 FROM public.buddy_reward_claims AS r
      WHERE r.user_id = v_user AND r.source_kind = 'water'
        AND r.reward_day = d.day_utc AND r.daily_slot = s.slot
    )
  ), inserted AS (
    INSERT INTO public.buddy_reward_claims
      (user_id, source_kind, source_id, xp, gold, reward_day, daily_slot)
    SELECT v_user, 'water', c.source_id, 5, 1, c.day_utc, s.slot
    FROM ranked_candidates AS c
    JOIN free_slots AS s
      ON s.day_utc = c.day_utc
     AND s.available_rank = c.candidate_rank
    ON CONFLICT DO NOTHING
    RETURNING xp, gold
  )
  SELECT coalesce(sum(xp), 0)::integer, coalesce(sum(gold), 0)::integer
    INTO v_new_xp, v_new_gold FROM inserted;

  v_xp := v_xp + v_new_xp;
  v_gold := v_gold + v_new_gold;

  -- Preserve the original streak formula and behavior.
  SELECT array_agg(d ORDER BY d DESC) INTO v_days
  FROM (
    SELECT DISTINCT (logged_at AT TIME ZONE 'UTC')::date AS d
    FROM public.logs WHERE user_id = v_user AND is_deleted = false
    UNION
    SELECT DISTINCT (recorded_at AT TIME ZONE 'UTC')::date AS d
    FROM public.water_entries WHERE user_id = v_user AND is_deleted = false
  ) AS x WHERE d <= v_today;

  IF v_days IS NOT NULL AND array_length(v_days, 1) > 0 THEN
    v_anchor := v_days[1];
    IF v_anchor >= v_today - 1 THEN
      FOREACH v_day IN ARRAY v_days LOOP
        IF v_day = v_anchor - v_streak THEN
          v_streak := v_streak + 1;
        ELSE
          EXIT;
        END IF;
      END LOOP;
    END IF;
  END IF;

  UPDATE public.pets AS p SET
    xp = p.xp + v_xp,
    gold = p.gold + v_gold,
    level = 1 + floor(sqrt((p.xp + v_xp)::numeric / 100.0))::integer,
    streak_days = v_streak,
    mood = CASE WHEN v_xp > 0 THEN 'happy' ELSE 'neutral' END
  WHERE p.user_id = v_user
  RETURNING p.xp, p.gold, p.level
    INTO v_total_xp, v_total_gold, v_level;

  RETURN QUERY SELECT v_xp, v_gold, v_total_xp, v_total_gold,
                      v_level, v_streak;
END;
$function$;

-- Keep the known least-privilege access shape for this privileged RPC.
REVOKE ALL ON FUNCTION public.claim_buddy_rewards() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_buddy_rewards() TO authenticated;

COMMIT;
