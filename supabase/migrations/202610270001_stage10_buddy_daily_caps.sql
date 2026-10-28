-- NutriBuddy / Adim 10.6: Prevent daily Buddy reward reset by deleting/recreating logs.
-- Apply ONCE, after stage 8. Designed for the currently confirmed schema.
-- Atomic: any failed historical backfill or constraint rolls back the whole migration.
-- Does NOT delete reward rows or alter users' XP, gold, inventory or meal/water records.
BEGIN;

-- Reward date + consumed daily slot persist even if the source record is later deleted.
ALTER TABLE public.buddy_reward_claims
  ADD COLUMN reward_day date,
  ADD COLUMN daily_slot integer;

-- Backfill historical claims using the CURRENT stored UTC date of each source.
-- If sources are missing, the following NOT NULL assertions fail and roll back.
WITH source_dates AS (
  SELECT
    c.user_id,
    c.source_kind,
    c.source_id,
    CASE
      WHEN c.source_kind = 'meal'
        THEN (l.logged_at AT TIME ZONE 'UTC')::date
      ELSE (w.recorded_at AT TIME ZONE 'UTC')::date
    END AS day_utc
  FROM public.buddy_reward_claims AS c
  LEFT JOIN public.logs AS l
    ON c.source_kind = 'meal'
   AND l.id = c.source_id
   AND l.user_id = c.user_id
  LEFT JOIN public.water_entries AS w
    ON c.source_kind = 'water'
   AND w.id = c.source_id
   AND w.user_id = c.user_id
), numbered AS (
  SELECT
    user_id,
    source_kind,
    source_id,
    day_utc,
    row_number() OVER (
      PARTITION BY user_id, source_kind, day_utc
      ORDER BY source_id
    )::integer AS slot_number
  FROM source_dates
)
UPDATE public.buddy_reward_claims AS c
SET
  reward_day = n.day_utc,
  daily_slot = n.slot_number
FROM numbered AS n
WHERE c.user_id = n.user_id
  AND c.source_kind = n.source_kind
  AND c.source_id = n.source_id;

-- Fail closed on missing sources or legacy over-limit dates; migration is rolled back.
ALTER TABLE public.buddy_reward_claims
  ALTER COLUMN reward_day SET NOT NULL,
  ALTER COLUMN daily_slot SET NOT NULL,
  ADD CONSTRAINT buddy_reward_claims_slot_range_check
    CHECK (
      (source_kind = 'meal'  AND daily_slot BETWEEN 1 AND 3)
      OR
      (source_kind = 'water' AND daily_slot BETWEEN 1 AND 8)
    ),
  ADD CONSTRAINT buddy_reward_claims_daily_slot_key
    UNIQUE (user_id, source_kind, reward_day, daily_slot);

-- The RPC keeps its original name, signature, account lock, reward amounts,
-- level/streak calculation and output shape. It now assigns only UNUSED slots.
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

  -- Meals: at most three consumed slots per user / UTC source date.
  WITH candidates AS (
    SELECT
      l.id AS source_id,
      (l.logged_at AT TIME ZONE 'UTC')::date AS day_utc,
      l.logged_at AS event_time
    FROM public.logs AS l
    WHERE l.user_id = v_user
      AND l.is_deleted = false
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
        PARTITION BY day_utc ORDER BY event_time, source_id
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

  -- Water: at most eight consumed slots per user / UTC source date.
  WITH candidates AS (
    SELECT
      w.id AS source_id,
      (w.recorded_at AT TIME ZONE 'UTC')::date AS day_utc,
      w.recorded_at AS event_time
    FROM public.water_entries AS w
    WHERE w.user_id = v_user
      AND w.is_deleted = false
      AND w.amount_ml BETWEEN 100 AND 1000
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
        PARTITION BY day_utc ORDER BY event_time, source_id
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

-- Ensure the RPC remains callable by authenticated users but not anonymous clients.
REVOKE ALL ON FUNCTION public.claim_buddy_rewards() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_buddy_rewards() TO authenticated;

COMMIT;
