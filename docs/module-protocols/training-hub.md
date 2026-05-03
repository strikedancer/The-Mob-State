# Training hub protocol

## Scope

Single Flutter entry that combines **gym** (strength bonus, `/gym`) and **shooting range** (accuracy bonus, `/shooting-range`). Player-facing help topic id: `training-hub`.

## Primary frontend entry

- `client/lib/screens/training_hub_screen.dart`

### Hub UX (player-facing)

- **Header:** gradient hero with title/subtitle, optional **combo chip** when `trainingComboReadiness.active` is true (shows `bonusFraction` as a crime success bonus percentage).
- **Refresh:** reloads `GET /training/status` (and related state). Prefer **silent refresh** (no full-page blocking spinner) when the user taps refresh while already on the hub.
- **“Open crimes” / misdaden:** optional `onOpenCrimes` callback (e.g. web dashboard embed) jumps to the crimes section so active bonuses are visible there too.
- **“More info & options”:** `ExpansionTile` with short copy on combo rules, separate cooldowns/caps, and hitlist note (range progress feeds server hitlist logic).
- **Icons:** use web-safe Material icons only (see Change rules).

Legacy wrappers (same UI):

- `client/lib/screens/gym_screen.dart`
- `client/lib/screens/shooting_range_screen.dart`

## Backend

- `backend/src/routes/gym.ts`, `backend/src/services/gymService.ts` — train + status (unchanged contract).
- `backend/src/routes/shootingRange.ts`, `backend/src/services/shootingRangeService.ts` — train + status (unchanged contract).
- **`GET /training/status`** — `backend/src/routes/training.ts`: one authenticated round-trip returning `{ success, gym, shootingRange, trainingComboReadiness }` with the same gym/shooting objects as each module’s status endpoint (no nested `status` key). `trainingComboReadiness` is `{ active, bonusFraction }` for same-UTC-day gym+range combo (see `trainingComboReadiness.ts` + `balance-economy.md`). Used by `TrainingHubScreen` and the crimes screen bonus strip.
- Player cooldown payload still exposes `cooldowns.gym` and `cooldowns.shooting_range` separately.

## Change rules

- **Flutter web icons:** dashboard sidebar, mobile menu and the hub header must use Material icons whose glyphs ship in the default bundled web font (e.g. `Icons.fitness_center` / `Icons.gps_fixed`). Avoid `Icons.adjust` on web hub badges (often missing in the default font) and newer icons that render as empty squares (e.g. `Icons.sports_martial_arts` in some builds).
- Preserve separate cooldowns and caps per track; do not merge timers without an explicit design pass.
- Keep Dutch and English copy in sync for any user-visible change; follow `PROTOCOL_MASTER.md` for ARB merge / parity / push-inbox split.
- Update `scripts/_help_topics_extracted.json` and run `node scripts/apply_help_topics_l10n.mjs` when help text for this topic changes.

## QA

- Wide layout: both columns scroll as one page; narrow: stacked sections.
- Train success and failure paths for **both** APIs (gym uses `params.reason`; shooting range uses top-level `error`).
- VIP shorter cooldown still applies to both tracks.
