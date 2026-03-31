-- Score V2 Supabase Checklist (non-destructive)
-- Run this after score_v2_phase2_schema.sql

-- 1) Object existence
SELECT to_regclass('public.user_score_events') AS user_score_events;
SELECT to_regclass('public.user_score_module_bonus_awards') AS user_score_module_bonus_awards;
SELECT to_regclass('public.user_roadmap_score_summary') AS user_roadmap_score_summary;
SELECT to_regclass('public.score_v2_config') AS score_v2_config;
SELECT to_regclass('public.v_score_v2_global_leaderboard') AS v_score_v2_global_leaderboard;
SELECT to_regclass('public.v_score_v2_roadmap_leaderboard') AS v_score_v2_roadmap_leaderboard;

-- 2) Confirm user_game_data extensions
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'user_game_data'
  AND column_name IN (
    'total_score',
    'total_stars',
    'total_submodule_points',
    'total_module_bonus_points',
    'scoring_version'
  )
ORDER BY column_name;

-- 3) Config row
SELECT id, scope, roadmap_id, pass_score_min, submodule_max_points, module_completion_bonus, scoring_version, is_active
FROM public.score_v2_config
ORDER BY created_at DESC;

-- 4) Policy sanity on new tables
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN (
    'user_score_events',
    'user_score_module_bonus_awards',
    'user_roadmap_score_summary',
    'score_v2_config'
  )
ORDER BY tablename, policyname;

-- 5) Row count snapshot for cleanup planning (safe read)
SELECT 'profiles' AS table_name, COUNT(*)::BIGINT AS row_count FROM public.profiles
UNION ALL SELECT 'user_game_data', COUNT(*)::BIGINT FROM public.user_game_data
UNION ALL SELECT 'user_achievements', COUNT(*)::BIGINT FROM public.user_achievements
UNION ALL SELECT 'user_roadmap_progress', COUNT(*)::BIGINT FROM public.user_roadmap_progress
UNION ALL SELECT 'user_activity_log', COUNT(*)::BIGINT FROM public.user_activity_log
UNION ALL SELECT 'parsed_resumes', COUNT(*)::BIGINT FROM public.parsed_resumes
UNION ALL SELECT 'resume_edit_history', COUNT(*)::BIGINT FROM public.resume_edit_history
UNION ALL SELECT 'subscriptions', COUNT(*)::BIGINT FROM public.subscriptions
UNION ALL SELECT 'certificates', COUNT(*)::BIGINT FROM public.certificates
UNION ALL SELECT 'ai_chats', COUNT(*)::BIGINT FROM public.ai_chats
UNION ALL SELECT 'ai_messages', COUNT(*)::BIGINT FROM public.ai_messages
UNION ALL SELECT 'jobs', COUNT(*)::BIGINT FROM public.jobs
UNION ALL SELECT 'user_survey_responses', COUNT(*)::BIGINT FROM public.user_survey_responses
UNION ALL SELECT 'user_score_events', COUNT(*)::BIGINT FROM public.user_score_events
UNION ALL SELECT 'user_score_module_bonus_awards', COUNT(*)::BIGINT FROM public.user_score_module_bonus_awards
UNION ALL SELECT 'user_roadmap_score_summary', COUNT(*)::BIGINT FROM public.user_roadmap_score_summary;
