# Player Portraits (Selfie → Gangster) Protocol

## Scope
Premium-credit sink: players upload a selfie; the backend generates a film-noir gangster-style portrait via Leonardo (Character Reference), stores PNGs under the runtime client-images mount, and exposes a per-player library with active selection.

## Primary Backend
- `backend/src/constants/playerPortrait.ts` — credit cost (`100`), max portraits, Leonardo model constants.
- `backend/src/services/playerPortraitLeonardo.ts` — init-image upload + v1 generation + polling.
- `backend/src/services/playerPortraitService.ts` — filesystem paths, Prisma transactions (deduct credits only after successful save).
- `backend/src/routes/settings.ts` — `GET/POST/DELETE /settings/portraits*`, multipart `POST .../portraits/from-selfie`.

## Primary Frontend
- `client/lib/screens/settings_screen.dart` — library grid, consent + cost flows, selfie upload.
- `client/lib/utils/avatar_helper.dart` — `activePortraitPath` resolves to `/images/...` via `WebAssetHelper`.

## Data Model
- `PlayerPortrait` (`player_portraits`): `imagePath` relative to `/images/` (e.g. `player_avatars/<playerId>/<uuid>.png`).
- `Player.activePortraitId` — when set, UI shows custom portrait; preset `avatar` remains the fallback preset key when custom is cleared.

## Economy
- **100 premium credits** charged only when the portrait row and PNG are committed (failed Leonardo run = no charge). See [balance-economy.md](balance-economy.md).

## Ops / Deploy
- Generated files live under `runtime/client-images/` (same pattern as other external images). Nginx serves `/images/*` from that mount (`docs/operations/DEPLOY.md`).
- Requires `LEONARDO_API_KEY` in backend environment (`PROTOCOL_MASTER.md` — never commit keys).

## Privacy
- Selfie exists only in memory during the request; not persisted after generation.
- Player must accept consent checkbox before upload (ToS alignment).

## QA
1. Insufficient credits → `error.insufficient_credits`.
2. Successful generation → new row, balance −100, new portrait selected active.
3. Preset avatar change clears `activePortraitId` (preset visible).
4. Friends/messages/hitlist show `activePortraitPath` when present.
