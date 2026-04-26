# Live game events (player)

## Scope

- Preset `GameEventTemplate` + `GameEventSchedule` (`interval`) seeds via `ensureGameEventPresets()` on backend startup.
- `runEventScheduler` (cron) starts `active` `GameLiveEvent` instances, attaches default `GameEventRewardRule` rows, resolves on `endsAt`, then `processPendingRewardDeliveries` applies `cash` / `xp` / `premiumCredits` from claims.
- **Categories** wired in gameplay: `crime`, `drugs`, `smuggling`, `vehicles` — only one active preset per category to avoid double score from `recordContribution`.
- **Event Pass** (Mollie one-time, key `event_pass_7d`): `EVENT_BOOST` entitlement + small credit bonus; `balance-economy.md` / `payments.md` apply.
- **Push (FCM)**: bij start en einde van een actief live event stuurt de server een **gelokaliseerde push** (NL/EN) naar spelers die in **Instellingen → Spelerevents** push aan hebben staan (`push_game_events`, standaard **aan**). Zie `gameEventNotificationService` + `playerNotificationPreferenceService`.
- **Dashboard (client)**: web dashboard home laadt `/game-events/overview` en toont actieve events compact (zonder het overige dashboard te breken).

## Operator checklist (deploy & runtime)

1. **Backend (her)start** na code- of configwijziging, zodat `ensureGameEventPresets()` draait en templates/schema’s in de DB staan.
2. **Cron** moet draaien (zelfde als rest van de game); `runEventScheduler` start en beëindigt rondes en triggert reward delivery.
3. **Mollie** (`MOLLIE_API_KEY`, webhook-URL) voor Event Pass; zie `payments.md`.
4. **Firebase (optioneel)** voor push: zonder geldige service account meldingen in logs; spelers met devices krijgen wel pushes.
5. **VPS** (indien productie online de bron is): `git pull`, `docker compose …` rebuild/restart volgens `PROTOCOL_MASTER` PuTTY/Docker runbook; geen secrets in getrackte compose.

## Cross-module

- `payments.md` — Mollie product, webhook, idempotency
- `balance-economy.md` — reward sizes, no pay-to-win
- `dashboard.md` — live events op home (client) + `notifications.md` — push-broadcasts
- `Help & Uitleg` — NL/EN in `help_content.dart` (Premium & Credits, Event Pass)

## Admin

- Preset list with single toggle: template + schedule; advanced CRUD under optional checkbox in `admin` `App.tsx`.
