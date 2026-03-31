# Score V2 Phase 2 Apply Guide

This phase introduces database foundation only.
No app routes are switched yet.

## What you need to do in Supabase

Yes, there is one manual DB step in this phase.

1. Open Supabase SQL Editor for your project.
2. Run the full script from [database/score_v2_phase2_schema.sql](database/score_v2_phase2_schema.sql).
3. Confirm success (no errors) and run verification queries from the bottom of that file.

## Expected model after migration

Global score authority remains in existing table:
- public.user_game_data (extended with score columns)

New tables created:
- public.user_score_events
- public.user_score_module_bonus_awards
- public.user_roadmap_score_summary
- public.score_v2_config

Views created:
- public.v_score_v2_global_leaderboard
- public.v_score_v2_roadmap_leaderboard

## Why this is safe now

- All Score V2 feature flags are still default false.
- Existing progress and leaderboard APIs remain unchanged.
- This migration only prepares storage and ranking views.
- No table deletions are performed here.

## Quick verification checklist

1. Run:
   - SELECT to_regclass('public.user_score_events');
   - SELECT to_regclass('public.user_score_module_bonus_awards');
   - SELECT to_regclass('public.user_roadmap_score_summary');
   - SELECT to_regclass('public.score_v2_config');
2. Check new columns on user_game_data:
   - SELECT column_name FROM information_schema.columns WHERE table_name = 'user_game_data' AND column_name IN ('total_score','total_stars','total_submodule_points','total_module_bonus_points','scoring_version');
2. Check config row exists:
   - SELECT scope, pass_score_min, submodule_max_points, module_completion_bonus, is_active FROM public.score_v2_config;
3. Ensure views compile:
   - SELECT * FROM public.v_score_v2_global_leaderboard LIMIT 1;
   - SELECT * FROM public.v_score_v2_roadmap_leaderboard LIMIT 1;

## Rollback note

If needed, disable usage by leaving all Score V2 flags false.
No runtime read/write path depends on these tables yet in this phase.

## Important note for your cleanup plan

- Do not drop old tables yet.
- First complete backend Score V2 endpoints and cutover behind flags.
- After successful verification, we will do a targeted drop/deprecate pass.
