# Live game events (player)

## Scope

- Preset `GameEventTemplate` + `GameEventSchedule` (`interval`) seeds via `ensureGameEventPresets()` on backend startup.
- **Weekly** presets (48h windows, 7-day interval, staggered): vehicles / smuggling / drugs / crime / trade.
- **Monthly Empire Showdown** (`monthly_empire_showdown`, category `allround`): 7-day live window every ~30 days; receives score from **all** gameplay categories via `recordContribution` (OR `allround`). Top ranks grant rare vehicle / weapons / ammo / parts (cash fallback if garage/world-cap blocks).
- `runEventScheduler` (cron) starts `active` `GameLiveEvent` instances, attaches default `GameEventRewardRule` rows, resolves on `endsAt`, then `processPendingRewardDeliveries` applies `cash` / `xp` / `premiumCredits` and optional catalogue `items[]` (→ `player_event_items`) from claims.
- **Extended rewards** (via `eventRewardFulfillmentService`): `ammo[]`, `tools[]`, `weapons[]`, `vehicles[]` (world-cap + garage/marina checks; cash fallback if blocked), `vehicleParts` `{ car, motorcycle, boat }`. Category presets seed modest ammo/parts/tools for weekly rounds.
- **Categories** wired in gameplay: `crime`, `drugs`, `smuggling`, `vehicles`, **`trade`** — only one active preset per category to avoid double score from `recordContribution`.
- **Event Pass** (`season_pass_monthly`, Mollie one-time €7.99): **56 category goals** per `YYYY-MM` month (crimes, vehicles, smuggling, drugs, cash earned, XP, plus 6 prostitution-recruit goals at levels 51–56). Free column = event prize; premium column = pass bonus (requires unlock). Per-category stats in `player_season_pass` (`stat_*` columns, including `stat_prostitution`). Progress hooks: successful crime / vehicle steal / smuggling **send** / drug **collect** (grams) / prostitution **recruit** via `gameEventService.recordContribution` → `addSeasonPassProgress`; money/XP also from crimes/jobs. API: `/season-pass/status`, `/season-pass/claim`. **Claim must be one DB transaction** (insert claim row + deliver cash/XP/credits/items/extended rewards). If delivery fails the claim row rolls back so the player can retry; never mark claimed before payout. After a successful claim, a status-reload failure must still return HTTP 200 with the granted rewards. UI: scrollable goal list on Events screen (mobile stacks goal + two claim tiles so Claim is tappable; overview load failure must not hide the Event Pass panel). Season Pass status load failure shows retry (`MobileLoadError`), not a hidden panel. Buy tile on Premium. The old 7-day `event_pass_7d` pack is deactivated.
- **Push (FCM)**: bij start en einde van een actief live event stuurt de server een **gelokaliseerde push** (NL/EN) naar spelers die in **Instellingen → Spelerevents** push aan hebben staan (`push_game_events`, standaard **aan**). Zie `gameEventNotificationService` + `playerNotificationPreferenceService`.
- **Dashboard (client)**: web dashboard home laadt `/game-events/overview` en toont actieve events compact (zonder het overige dashboard te breken).
- **Live event rail**: ronde category-avatars rechts op het web dashboard (verborgen op Events-sectie). Onder elke avatar een live resterende-tijd-badge (`endsAt`). Tap opent een **popup** met titel, status, countdown, start/eind, korte beschrijving, top-prijs en knop naar Events. Rode badge rechtsboven = aantal claimbare Event Pass-beloningen voor die categorie (money/xp orphan-claimables op de eerste avatar als er geen allround/trade-event is).
- **Live leaderboard**: `GET /game-events/:id` toont top-10 op **score** tijdens `active` (ranks worden pas bij resolve weggeschreven); viewer buiten top-10 blijft meegenomen met berekende plaats.
- **Overview UI**: `GET /game-events/overview` levert `active`, `upcoming` (echte `scheduled` live rows) én **`upcomingPreview`** (volgende interval-starts uit enabled schedules voor templates die nu niet live zijn). De Flutter-pagina toont category-themed kaarten met bestaande achtergrond-art, countdown, top-prijs teaser en prijzenpot in de detail-dialog.

## Preset: Contraband Rush (`contraband_rush`, category `trade`)

- Seeded via `gameEventPresets.ts` (`staggerDayOffset: 4` in de wekelijkse rotatie).
- **Scoring** (`gameEventTradeContribution.ts`):
  - **Verkoop** handelswaren (`/trade/sell`): punten op basis van gerealiseerde winst (`floor(profit/200)`) + volume (`floor(earnings/1000)`); minimaal 1 punt bij positieve verkoop.
  - **Claim** gesmokkelde trade-shipment (`smugglingService`, category `trade`): 1 punt per eenheid.
  - **Kopen** telt niet mee. Smuggling-quotes (drugs/tools/etc.) blijven onder category `smuggling` (Smuggling Surge).
- Client: `localized_game_event_template.dart` + ARB keys `gameEventTmplContrabandRush*`.

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

## Backend (Prisma) invariant

- `configJson` / `stateJson` / reward `triggerConfigJson` / `rewardsJson` en soortgelijke velden in het event-model zijn in het schema `String` (`@db.LongText`), geen native `Json` type. `gameEventService` moet dus objecten **serialiseren** (`JSON.stringify` / `toJsonString`) vóór `create` / `update`, en bij uitlezen waar nodig **parsen** — anders: `PrismaClientValidationError` (“Expected String or Null, provided Object”) bij o.a. `prisma.gameLiveEvent.create` met `rewardRules.create`.
