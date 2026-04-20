# Territory Protocol

## Implementatiestatus
- Fase 1 (backend + Flutter): ✅ geïmplementeerd
  - `backend/src/startup/ensureTerritorySchema.ts` — DB schema + NL regio seed + runtime_config defaults
  - `backend/src/services/territoryService.ts` — game logic (contests, actions, anti-abuse, resolve, notifications)
  - `backend/src/routes/territory.ts` — player endpoints + admin moderation endpoints
  - `backend/src/app.ts` / `index.ts` — route en startup bootstrap geregistreerd
  - `client/lib/services/territory_service.dart` — Flutter API service
  - `client/lib/screens/territory_screen.dart` — responsive UI (desktop split / tablet stacked / mobiel bottom sheet)
- Fase 2 (UI navigation): ✅ geïmplementeerd
  - `client/lib/main.dart` — route `/territory` registered
  - `client/lib/screens/dashboard_screen.dart` — menu item met kaart-icoon in navigatie-grid én web-sidebar
  - `client/lib/data/help_content.dart` — help entry met NL/EN beschrijving
- Fase 3 (visual map): ✅ geïmplementeerd
  - `client/lib/screens/dashboard_screen.dart` — expliciet sidebar-icoon voor Territory (`Icons.public_rounded`)
  - `client/assets/images/maps/cafuego-Nederland.svg` — NL kaart asset gekoppeld aan Territory
  - `client/lib/screens/territory_screen.dart` — SVG kaart render + dynamische inkleuring per `svgElementId` op basis van ownership/contest status
  - `client/lib/screens/territory_screen.dart` — kaart-legend met crew-naam ↔ kleur voor snelle interpretatie van ownership op desktop/tablet/mobiel
- Fase 4 (multi-country assets): ✅ geïmplementeerd
  - `client/assets/images/maps/*.svg` — batch pool van landkaarten toegevoegd (o.a. be, de, fr, us, uk)
  - `client/lib/screens/territory_screen.dart` — map asset loading nu dynamisch per land via `country.svgAssetKey` met country-code fallback en country selector in de appbar
  - `backend/src/startup/ensureTerritorySchema.ts` — country seed uitgebreid zodat meerdere landen direct zichtbaar zijn via `/territory/countries`
  - NL correctie: Nederland gebruikt nu primair `netherlandsLow.svg` (backend `svgAssetKey = netherlandsLow` + frontend NL fallback naar `netherlandsLow.svg`)
  - Interactieve map UX: de Territory SVG is vergroot, regio-paden zijn direct klikbaar via path hit-testing op `svgElementId`, tonen een tooltip met gebiedsnaam en openen meteen het detailpaneel; detail-content blijft scrollbaar op desktop/tablet
  - Scroll/hover verfijning: de volledige map-tab volgt nu 1 primaire verticale scrollflow, en SVG-regio's krijgen hover-darkening plus expliciete zichtbare grenslijnen (`stroke`) voor betere afbakening
  - Renderer fallback verbreed: SVG styling draait nu over alle pad-elementen van de kaart (niet alleen backend-gemapte regio's), zodat grenslijnen en hover-darkening ook zichtbaar blijven bij gedeeltelijke `svgElementId` mismatch tussen seed-data en bron-SVG
  - Zuid-Afrika toegevoegd aan de asset/country set: `za` is nu gekoppeld aan `southAfricaLow.svg` (backend seed + frontend fallback)
- Bug fixes: ✅
  - Territory screen notification calls gecorrigeerd naar `showTopRightFromSnackBar` pattern (was ongedefinieerde `showTopRightNotification` helper)
  - Territory web buildfix: ontbrekende interactieve SVG helpertypes (`_SvgMapParseResult`, `_SvgRegionShape`) toegevoegd zodat compile op web release/Docker niet faalt
  - Territory hover buildfix: expliciete Flutter pointer event import toegevoegd zodat `PointerHoverEvent` compileert in web release/Docker builds
  - Territory NL SVG id remap: backend seed gebruikt nu de echte `netherlandsLow.svg` ids (`NL-GR`, `NL-FR`, etc.) en update bestaande `territory_regions` rows ook op `svgElementId`, zodat kleur, hover en grenslijnen weer op de juiste gebieden landen
- SVG stabiele region IDs: ⏳ gepland (mapping via database svgElementId)
- Admin Vue-frontend territory sectie: ⏳ gepland

## Scope
Crew-territoriumcontrole per land met kaartweergave (SVG), contest lifecycle, invloedspunten, seizoenen, rewards, anti-abuse, notificaties en admin-moderatie.

Scope-afbakening:
- Territory is persistent map-control progression.
- Crew Wars blijft event-war systeem met tijdelijke war fases.
- Territory en Crew Wars mogen elkaar versterken, maar Territory werkt ook los van actieve wars.

## Primary Frontend Entry
- client/lib/screens/territory_screen.dart (nieuw)
- client/lib/screens/crew_screen.dart (territory tab/entry)
- client/lib/screens/dashboard_screen.dart (territory samenvatting)
- client/lib/services/territory_service.dart (nieuw)

## Primary Backend Entry
- backend/src/routes/territory.ts (nieuw)
- backend/src/services/territoryService.ts (nieuw)
- backend/src/startup/ensureTerritorySchema.ts (nieuw)
- backend/src/routes/admin.ts (runtime settings + moderation)

## Change Rules
- Preserve core fairness: free crews moeten competitief kunnen blijven zonder VIP-lock.
- Territory scoring en ownership wijzigingen zijn server-authoritative.
- NL en EN copy synchroon voor alle nieuwe labels, flows, errors, meldingen en push/inbox events.
- UI blijft bruikbaar op mobiel/tablet/desktop met 1 primaire verticale scrollflow onder sticky headers.

## Cross-Module Dependencies
- Territory -> Crew (roles, permissions, membership, crew identity)
- Territory -> Crew Wars (optionele modifiers, season overlap, anti-snowball)
- Territory -> Dashboard (live ownership samenvatting, hot contests)
- Territory -> Notifications (contest alerts, ownership changes, season rewards)
- Territory -> Travel (land-specifieke maps en country scope)
- Territory -> Admin (settings, moderation, logs, force actions)
- Territory -> Achievements (optional milestones per region/season)

## Must Preserve
- Duidelijke ownership per regio (welke crew controleert).
- Duidelijke contest status (idle, contested, lockdown, resolved).
- Deterministische score-opbouw en resolve-regels.
- Volledige audit trail van acties en ownership mutaties.
- Map rendering met duidelijke fallback als SVG/region mapping deels faalt.

## Core Domain Model

### Countries
- `countryCode`: bv. `nl`, `be`, `de`
- `displayNameNl`, `displayNameEn`
- `svgAssetKey` (referentie naar map asset)
- `enabled`

### Regions
- `regionKey` (stabile sleutel, bv. `nl-groningen`)
- `nameNl`, `nameEn`
- `svgElementId` (id in SVG)
- `valueTier` (economy waarde)
- `strategicTags` (harbor, border, capital, industry)
- `neighborsJson` (adjacency)

### Control
- `ownerCrewId` (nullable bij neutral)
- `controlPercent` per crew/regio
- `stability`
- `updatedAt`

### Contest
- `status`: `preparing`, `active`, `lockdown`, `resolved`, `cancelled`
- `attackerCrewId`, `defenderCrewId`
- `startedAt`, `lockdownAt`, `resolveAt`

### Actions
- `actionType`: `patrol`, `intel_scan`, `sabotage`, `supply_run`, `raid`, `defense`
- `pointsDelta`, `stabilityDelta`, `metadataJson`
- `antiAbuseFlags`

### Season
- `seasonKey`, `startsAt`, `endsAt`, `status`
- `rewardConfigJson`

## Backend Contract Guardrails
- Geen file-based gameplay settings voor territory.
- Alle territory settings zijn runtime-config keys in database (`runtime_config`) en beheerbaar via admin.
- Resolve-momenten moeten transaction-safe zijn (geen dubbele ownership switch door race conditions).
- Bij retries/idempotency: contest resolve en reward payout exact-once semantics.
- Querys op region ownership moeten consistent zijn tussen map endpoint en leaderboard endpoint.

## Runtime Settings (Admin-Only, Database)
Gebruik `runtime_config` (via admin config API) voor alle territory tuning.

Always-on regel:
- `TERRITORY_ENABLED` blijft forceren op `1` (startup seed + runtime guard) en wordt niet gebruikt als schakelaar om territory uit te zetten.

Verplichte keys:
- `TERRITORY_ENABLED` (forced `1`)
- `TERRITORY_DEFAULT_COUNTRY` (bv. `nl`)
- `TERRITORY_CONTEST_PREP_MINUTES`
- `TERRITORY_CONTEST_ACTIVE_MINUTES`
- `TERRITORY_CONTEST_LOCKDOWN_MINUTES`
- `TERRITORY_ACTION_COOLDOWN_SECONDS`
- `TERRITORY_ACTION_DAILY_CAP`
- `TERRITORY_CAPTURE_THRESHOLD_PERCENT`
- `TERRITORY_DECAY_PER_HOUR`
- `TERRITORY_DECAY_GRACE_MINUTES`
- `TERRITORY_MAX_REGIONS_PER_CREW`
- `TERRITORY_MAX_CONCURRENT_CONTESTS_PER_CREW`
- `TERRITORY_PRIME_TIME_START_HOUR_UTC`
- `TERRITORY_PRIME_TIME_END_HOUR_UTC`
- `TERRITORY_ANTI_FARM_WINDOW_SECONDS`
- `TERRITORY_ANTI_FARM_REPEAT_TARGET_CAP`
- `TERRITORY_REWARD_CASH_MULTIPLIER_PERCENT`
- `TERRITORY_REWARD_XP_MULTIPLIER_PERCENT`

Harde regel:
- Nieuwe territory setting keys worden eerst in admin runtime config toegevoegd en gevalideerd, nooit als hardcoded JSON settings file.

## API Surface (Minimum)
- `GET /territory/countries`
- `GET /territory/map/:countryCode`
- `GET /territory/overview`
- `POST /territory/contest/start`
- `POST /territory/action`
- `POST /territory/contest/defend`
- `GET /territory/crew/:crewId`
- `GET /territory/leaderboard`

Admin moderation:
- `POST /admin/territory/contest/resolve`
- `POST /admin/territory/region/assign`
- `POST /admin/territory/region/reset`
- `POST /admin/territory/season/start`
- `POST /admin/territory/season/close`

## Frontend UX Guardrails (Responsive)
- Desktop: kaart + side panel split.
- Tablet: kaart boven, details/acties onder in collapsible panel.
- Mobiel: map card + bottom sheet details + actieknoppen binnen één scrollflow.
- Geen hover-only critical actions; alle hoofdacties expliciet tappable.
- SVG load failures tonen graceful fallback met regio-lijstweergave.

## SVG / Mapping Guardrails
- Elke regio gebruikt stabiele `svgElementId` mapping in database.
- Geen business logic op willekeurige `path####` ids zonder mapping-laag.
- Land onboarding vereist validator:
  1. alle `svgElementId` bestaan in SVG,
  2. geen duplicates,
  3. NL/EN region names compleet,
  4. neighbor graph valide.

## Anti-Abuse Guardrails
- Repeated target diminishing returns binnen anti-farm window.
- Cooldown en daily cap per speler én per crew.
- Contest acties vereisen minimum aantal unieke deelnemers voor ownership swap.
- Flagging voor verdachte patronen (zelfde IP/device clusters) naar admin audit.

## Notifications & Messaging
- Push/inbox events: contest started, contest under attack, region captured, region lost, season reward.
- Fire-and-forget dispatch; gameplay transactie mag niet falen door notificatieproblemen.
- Copy parity NL/EN verplicht in UI + push + inbox.

## Multi-Country Rollout Guardrails
- Fase 1: alleen `nl` enabled.
- Nieuwe landen via admin-country onboarding flow met SVG mapping import en validation.
- Geen nieuwe country activatie zonder succesvolle map validation en smoke tests.

## QA Checklist
1. Happy flow: crew start contest -> build influence -> capture region.
2. Failure flow: cooldown/cap/permission block met duidelijke feedback.
3. Refresh/nav: ownership en contest status blijven consistent.
4. Mobile/tablet/desktop map usability en action bereikbaarheid.
5. Backend logs: geen runtime errors tijdens contest/resolve.
6. Admin moderation actions zichtbaar en auditbaar.
7. NL/EN parity op labels, errors, status, push/inbox.
8. Dashboard en Crew screen tonen territory state consistent.
9. Settings wijziging via admin config werkt direct (runtime) waar toegestaan.
10. NL-only launch: alleen Nederland map actief, andere landen disabled zonder regressie.

## When To Update This File
Update bij nieuwe action types, scoring model veranderingen, nieuwe admin moderation actions, season wijzigingen, anti-abuse regels, of onboardingflow voor extra landen.