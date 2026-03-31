# Score V2 Canonical Contract (Phase 1)

Status: Draft v1.0
Scope: Contract only. No runtime behavior changes in this phase.

## 1. Purpose

This contract aligns frontend, backend, and database payloads for scoring.
After cutover, Score V2 backend summaries become the authority for Total Score and Stars.

## 2. Design Principles

- One canonical score model across all roadmaps.
- One global scoring formula for fairness in this release.
- Idempotent writes to prevent duplicate awards.
- Event ledger plus summary tables for correctness and fast reads.
- Backward compatibility during transition.

## 3. Canonical Identifiers

- userId: UUID
- roadmapId: string
- moduleId: string
- nodeId: string
- nodeDepth: enum, module or submodule
- attemptId: UUID (required, unique per attempt)
- scoringVersion: string, default v1

## 4. Canonical Write Models

### 4.1 Score Attempt Write Request

Path intent: submit one submodule quiz attempt.

Fields:
- attemptId: string UUID, required
- userId: string UUID, required
- roadmapId: string, required
- moduleId: string, required
- nodeId: string, required
- nodeDepth: submodule, required for this endpoint
- quizScore: integer 0 to 100, required
- submittedAt: ISO datetime string, required
- scoringVersion: string, optional default v1
- metadata: object, optional

### 4.2 Module Completion Bonus Request

Path intent: award one-time parent module completion bonus.

Fields:
- userId: string UUID, required
- roadmapId: string, required
- moduleId: string, required
- completedAt: ISO datetime string, required
- scoringVersion: string, optional default v1

## 5. Canonical Read Models

### 5.1 User Score Summary Response

Fields:
- userId: string UUID
- totalScore: number
- totalStars: integer
- totalSubmodulePoints: number
- totalModuleBonusPoints: number
- updatedAt: ISO datetime string
- scoringVersion: string
- globalRank: integer or null
- roadmapSummaries: array

Roadmap summary item:
- roadmapId: string
- totalScore: number
- totalStars: integer
- rank: integer or null
- updatedAt: ISO datetime string

### 5.2 Global Leaderboard Entry

Fields:
- rank: integer
- userId: string UUID
- displayName: string
- totalScore: number
- totalStars: integer
- updatedAt: ISO datetime string

## 6. Global Scoring Formula (v1)

Constants:
- PASS_SCORE_MIN = 80
- SUBMODULE_MAX_POINTS = 2.0
- MODULE_COMPLETION_BONUS = 1.0

Submodule points:
- if quizScore < 80 then points = 0
- if quizScore >= 80 then points = round(((quizScore - 80) / 20) * SUBMODULE_MAX_POINTS, 2)

Module completion bonus:
- awarded once per userId + roadmapId + moduleId

Stars from totalScore:
- totalScore >= 750 => 4
- totalScore >= 450 => 3
- totalScore >= 250 => 2
- totalScore >= 100 => 1
- else => 0

## 7. Retake and Idempotency Rules

- attemptId is required and must be unique per user.
- Duplicate attemptId for same user is ignored and returns existing result.
- Retake policy is non-destructive by default:
  - If new computed points are higher than best points for that node, add only delta.
  - If lower or equal, no deduction and no delta addition.
- Module completion bonus can be awarded only once per user+roadmap+module.

## 8. API Contract (Versioned)

Recommended versioned paths:
- POST /api/v2/users/:userId/scores/attempts
- POST /api/v2/users/:userId/scores/modules/:moduleId/complete
- GET /api/v2/users/:userId/scores/summary
- GET /api/v2/leaderboards/global
- GET /api/v2/leaderboards/roadmaps/:roadmapId (future rollout)

Envelope:
- success: boolean
- data: object when success is true
- error: object when success is false
- version: string, v2

## 9. Validation Rules

Required checks:
- userId and attemptId are valid UUIDs.
- quizScore is integer in range 0..100.
- roadmapId, moduleId, nodeId are non-empty normalized strings.
- nodeDepth matches endpoint purpose.
- submittedAt and completedAt are valid ISO datetimes.

Error shape:
- code: string
- message: string
- details: array optional

## 10. Legacy Field Mapping (Transition)

Legacy and canonical mapping:
- total_xp (legacy) -> totalScore (canonical summary authority after cutover)
- level (legacy) -> derived display only, not score authority
- completed_components (legacy) -> completion source input, not score authority
- activity logs -> telemetry only, never score authority

During transition:
- Existing endpoints remain available.
- New v2 endpoints become source for dashboard once read flag is enabled.

## 11. Feature Flags

- SCORE_V2_WRITE_ENABLED
- SCORE_V2_READ_ENABLED
- SCORE_V2_LEADERBOARD_ENABLED
- VITE_SCORE_V2_WRITE_ENABLED
- VITE_SCORE_V2_READ_ENABLED
- VITE_SCORE_V2_LEADERBOARD_ENABLED

All defaults remain false in this phase.

## 12. Phase 1 Exit Criteria

- Contract document approved.
- Schema artifacts committed.
- Types available for frontend and backend integration.
- No runtime path switched in this phase.
