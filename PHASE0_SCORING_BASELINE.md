# Phase 0 - Scoring Baseline and Guardrails

This document freezes the current scoring behavior before Score V2 implementation.
It is intentionally implementation-agnostic and records what is true today.

## 1. Current Baseline (As-Is)

### Frontend score authority (today)
- Runtime authority is local state in GameTest context and localStorage cache.
- Backend sync hooks are present but commented out in the game context.
- Dashboard Total Score and Stars are rendered from frontend context values.

### Backend score authority (today)
- User progress API reads/writes XP-style data in `user_game_data`.
- Leaderboard route ranks by `total_xp` descending.
- Achievements are stored in `user_achievements`.

### Active progress/score routes (today)
- `GET /api/user/:userId/progress`
- `POST /api/user/:userId/progress`
- `POST /api/user/:userId/sync`
- `GET /api/leaderboard`

### Active activity routes (today)
- `POST /api/user/:userId/activity/log`
- `GET /api/user/:userId/activity/heatmap`
- `GET /api/user/:userId/activity/stats`

## 2. Known Baseline Risks

- Frontend score model and backend XP model are not aligned.
- Dashboard values can diverge from backend values.
- Retry/double-submit protection for score events is not enforced at API contract level.
- Current sync strategy is simple conflict resolution by higher XP and is not event-ledger based.

## 3. Target Source of Truth (Decision for Score V2)

- Source of truth after cutover: backend score summary derived from backend score events.
- Frontend localStorage remains cache/fallback only, never final authority.
- Activity logs remain telemetry and must not be used to compute authoritative scores.

## 4. Feature Flag Strategy (No-Op in Phase 0)

Use independent flags so rollout can be staged safely:

- `SCORE_V2_WRITE_ENABLED`
- `SCORE_V2_READ_ENABLED`
- `SCORE_V2_LEADERBOARD_ENABLED`
- `VITE_SCORE_V2_WRITE_ENABLED`
- `VITE_SCORE_V2_READ_ENABLED`
- `VITE_SCORE_V2_LEADERBOARD_ENABLED`

Default all flags to `false`.

Rollout order:
1. Enable write flag in non-production.
2. Validate event + summary consistency.
3. Enable read flag for dashboard.
4. Enable leaderboard flag after rank validation.

## 5. Rollback Triggers

Rollback immediately if any of these occur:
- Duplicate score awards for one attempt ID.
- Dashboard total mismatch versus backend summary after refresh.
- Leaderboard instability or clearly incorrect ordering.
- Elevated 4xx/5xx rates on score-related endpoints.
- Reconciliation mismatch between event ledger and summaries.

## 6. Rollback Checklist

1. Set all Score V2 flags to `false`.
2. Revert dashboard reads to legacy path.
3. Stop Score V2 write path (preserve inserted events for forensic review).
4. Capture failing request IDs and user IDs.
5. Export diff report between legacy totals and v2 summaries.
6. Announce rollback status and next ETA in team channel.

## 7. Phase 0 Completion Criteria

- Baseline behavior documented.
- Target source of truth documented.
- Feature flags defined and default-off.
- Rollback triggers and checklist documented.
- No runtime behavior change introduced.
