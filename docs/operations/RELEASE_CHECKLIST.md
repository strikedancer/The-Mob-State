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

## Mollie E2E (live payment)

Code + webhook-route staan live (`POST /subscriptions/webhook`, `MOLLIE_API_KEY`, `MOLLIE_WEBHOOK_URL`). Een echte kaartbetaling blijft een handmatige check:

1. VPS env: `MOLLIE_API_KEY` en `MOLLIE_WEBHOOK_URL=https://api.themobstate.com/subscriptions/webhook` gezet.
2. Dashboard Mollie: webhook-URL bereikbaar (geen 401/404 op POST).
3. In-game: Premium → Event Pass of Player VIP → checkout opent Mollie.
4. Test/live betaling afronden; na return landt de speler op Premium & Credits.
5. Backend-log: `[Mollie webhook]` fulfilled, geen dubbele grant bij herhaalde webhook.
6. Admin/player: VIP of Event Pass premium_unlocked = 1.

Zonder geldige key of publieke webhook blijft dit item open. Geen testkaart in git zetten.
