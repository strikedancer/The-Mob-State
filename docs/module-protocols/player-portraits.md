# Player Portraits (Selfie → Gangster) Protocol

## Scope
Premium-credit sink: players upload a selfie; the backend generates a film-noir gangster-style portrait via Leonardo (Character Reference), stores PNGs under the runtime client-images mount, and exposes a per-player library with active selection.

## Primary Backend
- `backend/src/constants/playerPortrait.ts` — credit cost (`100`), max portraits, Leonardo model constants, **portrait style ids** (`classic_noir`, `street_casual`, `sharp_suit`, `velvet_charm`), and `buildGangsterPortraitPrompts(gender, style)` so Leonardo prompts respect **account gender** (`Player.gender`, from registration) and the player’s chosen look. Invalid or missing `portraitStyle` in multipart defaults to `classic_noir`.
- `backend/src/services/playerPortraitLeonardo.ts` — init-image upload + v1 generation + polling.
- `backend/src/services/playerPortraitService.ts` — filesystem paths, Prisma transactions (deduct credits only after successful save).
- `backend/src/routes/settings.ts` — `GET/POST/DELETE /settings/portraits*`, multipart `POST .../portraits/from-selfie`.

## Primary Frontend
- `client/lib/screens/settings_screen.dart` — library grid, consent + cost flows, selfie upload.
- `client/lib/utils/avatar_helper.dart` — `activePortraitPath` resolves to `/images/...` via `WebAssetHelper`.

## Data Model
- `PlayerPortrait` (`player_portraits`): `imagePath` relative to `/images/` (e.g. `player_avatars/<playerId>/<uuid>.png`); optional `styleKey` stores the style id used at generation (moderation / support).
- `Player.activePortraitId` — when set, UI shows custom portrait; preset `avatar` remains the fallback preset key when custom is cleared.

## Economy
- **100 premium credits** charged only when the portrait row and PNG are committed (failed Leonardo run = no charge). See [balance-economy.md](balance-economy.md).

## Ops / Deploy
- Generated files live under `runtime/client-images/` on the host, mounted in Docker as **`/client/images`** on the **backend** container (`IMAGE_LIBRARY_ROOT_PATH`). The portrait service **must** write via that env path (`playerPortraitService.ts`); do not rely on a repo-relative `runtime/` path inside the container or files will not appear under `/images/` for the Flutter client.
- Nginx serves `/images/*` from that mount (`docs/operations/DEPLOY.md`).
- Requires `LEONARDO_API_KEY` in backend environment (`PROTOCOL_MASTER.md` — never commit keys). If that key is missing, wrong, or revoked, Leonardo responds with **401/403** on their API: the backend maps that to `error.portrait_generation_unavailable` (503) — this is **not** the player’s session JWT failing.
- Leonardo **REST v1** `/generations` expects **`negative_prompt`** (snake_case). With **alchemy + photoReal**, **`presetStyle: CINEMATIC`** is not in the allowed style list (use e.g. **`PHOTOGRAPHY`**) — otherwise Leonardo often returns **400**.

## Privacy
- Selfie exists only in memory during the request; not persisted after generation.
- Player must accept consent checkbox before upload (ToS alignment).

## Admin moderation (guideline violations)
- Staff can list and delete stored custom portraits without the player’s session: `GET /admin/players/:playerId/portraits`, `DELETE /admin/players/:playerId/portraits/:portraitId` (moderator+; **VIEWER** cannot delete). Optional query `?reason=` is recorded with the audit entry (`DELETE_PLAYER_PORTRAIT`). Admin UI: player → **Manage** tab → **Custom portretten (selfie)** with thumbnails and delete per tile. Follows the same admin-auth and audit conventions as other moderation endpoints in `PROTOCOL_MASTER.md`.

## Client UX
- During selfie→portrait generation, show a **non-dismissible** wait dialog (spinner + message) so players know the request is still running.
- In the avatar picker, each custom portrait tile has a **visible delete** control (not only long-press) plus a short hint: tap portrait to select, trash to remove (`DELETE /settings/portraits/:id`).
- Before upload, the player picks a **portrait look** (chips). `GET /settings` includes `portraitStyleIds` for the client allowlist; the multipart field `portraitStyle` selects the preset. **Velvet / evening glamour** stays **classy and PG-appropriate** (extra negative-prompt guards); all styles follow general game and ToS expectations in `PROTOCOL_MASTER.md`.

## QA
1. Insufficient credits → `error.insufficient_credits`.
2. Successful generation → new row, balance −100, new portrait selected active.
3. Preset avatar change clears `activePortraitId` (preset visible).
4. Friends/messages/hitlist show `activePortraitPath` when present.
