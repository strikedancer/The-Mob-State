# Training hub protocol

## Scope

Single Flutter entry that combines **gym** (strength bonus, `/gym`) and **shooting range** (accuracy bonus, `/shooting-range`). Player-facing help topic id: `training-hub`.

## Primary frontend entry

- `client/lib/screens/training_hub_screen.dart`

Legacy wrappers (same UI):

- `client/lib/screens/gym_screen.dart`
- `client/lib/screens/shooting_range_screen.dart`

## Backend

- `backend/src/routes/gym.ts`, `backend/src/services/gymService.ts` — train + status (unchanged contract).
- `backend/src/routes/shootingRange.ts`, `backend/src/services/shootingRangeService.ts` — train + status (unchanged contract).
- **`GET /training/status`** — `backend/src/routes/training.ts`: one authenticated round-trip returning `{ success, gym, shootingRange }` with the same objects as each module’s status endpoint (no nested `status` key). Used by `TrainingHubScreen` and the crimes screen bonus strip.
- Player cooldown payload still exposes `cooldowns.gym` and `cooldowns.shooting_range` separately.

## Change rules

- Preserve separate cooldowns and caps per track; do not merge timers without an explicit design pass.
- Keep Dutch and English copy in sync for any user-visible change; follow `PROTOCOL_MASTER.md` for ARB merge / parity / push-inbox split.
- Update `scripts/_help_topics_extracted.json` and run `node scripts/apply_help_topics_l10n.mjs` when help text for this topic changes.

## QA

- Wide layout: both columns scroll as one page; narrow: stacked sections.
- Train success and failure paths for **both** APIs (gym uses `params.reason`; shooting range uses top-level `error`).
- VIP shorter cooldown still applies to both tracks.
