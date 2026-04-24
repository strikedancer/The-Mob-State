# Release Checklist

Gebruik dit bestand om wijzigingen te bundelen en later in 1 productie-deploy uit te rollen.

## Status
- Release mode: **Batched deploy**
- Laatste reset: 2026-04-24
- Vorige lijst gearchiveerd: `docs/operations/RELEASE_CHECKLIST_ARCHIVE_2026-04-24.md`

## Pending Changes (nog NIET live)

### Frontend
- _Nog geen open items._

### Documentation
- _Nog geen open items._

### Backend
- _Nog geen open items._

### Admin
- _Nog geen open items._

### Client (game)
- _Nog geen open items._

## Deploy Plan (wanneer we live gaan)

### 1) API deploy
1. Push wijzigingen naar GitHub.
2. SSH naar VPS, ga naar repo-root en run: `git pull`
3. Valideer compose: `docker compose --env-file .env.plesk -f docker-compose.plesk.yml config`
4. Rebuild relevante service(s).

### 2) Client/Admin deploy
1. Rebuild alleen doelservice met `--no-deps`.
2. Check logs direct na deploy.

### 3) Post-deploy checks
- [ ] Hard refresh/service worker cache check
- [ ] Kernflows smoke-test
- [ ] Admin logs check (geen runtime errors)
