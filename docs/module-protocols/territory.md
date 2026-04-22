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
  - `backend/src/startup/ensureTerritorySchema.ts` — country seed uitgebreid zodat meerdere landen direct zichtbaar zijn via `/territory/countries`, en regio-seed vult nu alle ondersteunde landen zodat niet-NL kaarten dezelfde interactieve regioflow hebben als Nederland
  - `backend/src/services/territoryService.ts` + `backend/src/routes/territory.ts` — map viewing blijft cross-country toegestaan, maar contest-start, verdedigen en territory-acties zijn nu expliciet beperkt tot het land waar de speler via Travel echt aanwezig is
  - NL correctie: Nederland gebruikt nu primair `netherlandsLow.svg` (backend `svgAssetKey = netherlandsLow` + frontend NL fallback naar `netherlandsLow.svg`)
  - Interactieve map UX: de Territory SVG is vergroot, regio-paden zijn direct klikbaar via path hit-testing op `svgElementId`, tonen een tooltip met gebiedsnaam en openen nu een responsive modal-bottom-sheet met gebiedsinformatie en aanvalsacties; losse regiokaarten onder de SVG zijn verwijderd zodat de map-tab één duidelijke interactiestroom houdt
  - Mobiele kaartnavigatie: de SVG-kaart ondersteunt nu directe pinch-zoom en pan zonder extra plus/min/reset-overlay, zodat kleine regio's op telefoons beter aantikbaar blijven en ingezoomde kaartdelen versleept kunnen worden zonder de bestaande modalflow te breken
  - Scroll/hover verfijning: de volledige map-tab volgt nu 1 primaire verticale scrollflow, en SVG-regio's krijgen hover-darkening plus expliciete zichtbare grenslijnen (`stroke`) voor betere afbakening
  - Renderer fallback verbreed: SVG styling draait nu over alle pad-elementen van de kaart (niet alleen backend-gemapte regio's), zodat grenslijnen en hover-darkening ook zichtbaar blijven bij gedeeltelijke `svgElementId` mismatch tussen seed-data en bron-SVG
  - Zuid-Afrika toegevoegd aan de asset/country set: `za` is nu gekoppeld aan `southAfricaLow.svg` (backend seed + frontend fallback)
- Bug fixes: ✅
  - Territory screen notification calls gecorrigeerd naar `showTopRightFromSnackBar` pattern (was ongedefinieerde `showTopRightNotification` helper)
  - Territory web buildfix: ontbrekende interactieve SVG helpertypes (`_SvgMapParseResult`, `_SvgRegionShape`) toegevoegd zodat compile op web release/Docker niet faalt
  - Territory hover buildfix: expliciete Flutter pointer event import toegevoegd zodat `PointerHoverEvent` compileert in web release/Docker builds
  - Territory NL SVG id remap: backend seed gebruikt nu de echte `netherlandsLow.svg` ids (`NL-GR`, `NL-FR`, etc.) en update bestaande `territory_regions` rows ook op `svgElementId`, zodat kleur, hover en grenslijnen weer op de juiste gebieden landen
  - Territory usability fix: screen leest nu bestaande crewstatus via `GET /crews/mine`, blokkeert aanvallen met duidelijke NL/EN uitleg voor spelers zonder crew, en backend synchroniseert contest lifecycle automatisch van `preparing -> active -> lockdown -> resolved` op reads/actions zodat contests niet vast blijven staan
  - Territory crew-resolution fix: action-routes valideren crew membership nu via de echte crew-membership lookup in plaats van een ontbrekende `req.player.crewId`, zodat crew leaders en leden geen valse `error.not_in_crew` meer krijgen op aanvallen/verdedigen
  - Territory desktop layout fix: in brede layouts staat de uitleg/legend links en de SVG-kaart rechts; mobiel en tablet blijven onder elkaar renderen
  - Crew War koppeling: Territory War en Total War gebruiken nu echte Territory-regio\'s als claim-doelen in de War Room metadata, zodat crew wars geen losstaande placeholder-gebieden meer tonen
  - Territory desktop icon compat-fix: Territory gebruikt op desktop/web nu `Icons.language` voor de sidebar-entry en landselector, omdat die in deze Flutter-web shell aantoonbaar wel rendert waar `public/public_rounded` leeg wegviel
  - Territory contest UX-fix: de regio-modal toont nu contest timers (acties starten, acties sluiten, contest eindigt), cooldown per actie en de opbrengstklasse van het gebied; actieve contest-acties zijn bovendien role-based opgesplitst zodat aanvallers geen verdediging meer zien en verdedigers geen aanvalsacties
  - Territory contest state/timer fix: bestaande contests met missende `activeAt`/`lockdownAt`/`resolveAt` worden nu automatisch aangevuld vanuit `startedAt` + runtime-config, zodat regio-modals geen `Onbekend`-timers meer tonen; de open modal volgt bovendien direct verse mapdata na starten/verdedigen zodat spelers niet pas na weg-navigeren de actuele gevechtsstatus zien
  - Territory modal preview-fix: de gebiedsmodal rendert nu ook een compacte preview van alleen het aangeklikte SVG-gebied via het bestaande regio-path, zodat spelers in de popup direct visueel zien welk gebied geselecteerd is zonder de volledige landkaart opnieuw te tonen; brede layouts tonen deze preview rechts naast de stats, smallere layouts stapelen hem onder de titel
  - Territory income visibility + crewleader summary: gecontroleerde regio's keren nu server-authoritative passieve crew-bank inkomsten uit op basis van runtime-config per `valueTier`, loggen die payouts in `territory_reward_log`, tonen in de regio-modal echte bedragen per payout/per uur/per dag, en leveren in het crewleader-dashboard een samenvatting voor gebieden, landen, huidig inkomen en totaal verdiend territory-geld
  - Territory live-refresh fix: bij contest-start en verdedigen wordt de open regio-modal nu altijd direct ververst; als de eerste call fout terugkomt maar de contest al is aangemaakt, ziet de speler meteen de actuele conteststatus in plaats van pas na weg-navigeren. De modal berekent timerfallbacks bovendien lokaal vanuit `startedAt` + runtime-config als een timestamp in de payload nog ontbreekt
  - Territory live resolve fix: contest resolve dwingt punten nu eerst naar echte nummers voordat capture-percentages worden berekend, zodat neutrale regio's met alleen attacker-acties niet meer onterecht `winnerCrewId = NULL` eindigen; territory draait daarnaast nu ook via een minuut-cron zodat afhandeling en meldingen niet afhankelijk blijven van een latere map/overview read, en contest start/capture/loss versturen nu behalve push ook een inboxbericht
  - Territory admin/live API serialisatie-fix: `overview` en `leaderboard` normaliseren aggregate velden zoals `COUNT(...)` nu expliciet naar gewone numbers voordat Express JSON rendert, zodat admin/system logs geen `Do not know how to serialize a BigInt` meer krijgen op territory responses
  - Territory contest-start response-fix: ook de nieuw aangemaakte `contestId` uit `LAST_INSERT_ID()` wordt nu genormaliseerd naar een gewone number voordat de success-response teruggaat, zodat een eerste klik op `Aanvallen` niet stil een 500 geeft terwijl de contest al is gestart
  - Territory live start-fix: contest-start haalt de nieuw aangemaakte row nu via `LAST_INSERT_ID()` op in plaats van een exacte `startedAt` timestamp-match; hierdoor rollen starts op MariaDB `DATETIME`-kolommen zonder milliseconden niet meer stil terug. De attacker-actie `raid` gebruikt in de UI bovendien weer de correcte lowercase backend-action key
  - Territory strategische regio-laag: regio-seed bewaart nu echte `strategicTagsJson` en `neighborsJson` voor Nederland, mapdata exposeert strategische rollen plus buursteun, en contest-actions krijgen nu regio- en adjacency-afhankelijke bonuspunten zodat havens, hoofdsteden, industrie- en grensregio's ook echt verschillend spelen
  - Territory aftermath-laag: gewonnen `territory_war` en `total_war` kunnen nu tijdelijke `territory_region_effects` schrijven op echte Territory-regio's, zodat Theater-/doelregio's en aangrenzende vijandelijke regio's tijdelijk extra oorlogsdruk tonen zonder persistente `stability` permanent te vervuilen
- SVG stabiele region IDs: ✅ geïmplementeerd
  - `backend/src/startup/ensureTerritorySchema.ts` — regio-seed valideert nu verplichte namen, unieke `regionKey` waarden en unieke `countryCode + svgElementId` mappings voordat de bootstrap schrijft, zodat de database-mapping rond stabiele SVG ids niet stil kan driften
- Admin frontend territory sectie: ✅ geïmplementeerd
  - `backend/src/routes/territory.ts` + `backend/src/services/territoryService.ts` — admin overview endpoint toegevoegd voor territory moderatie, contest-overzicht, seizoenen, regio-eigendom en leaderboard
  - `admin/src/components/TerritoryAdminPanel.tsx` + `admin/src/App.tsx` + `admin/src/services/adminService.ts` — admin tab voor Territory toegevoegd met region assign/reset, contest resolve, season start/close en live overzicht van contests/regio's

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
- Territory-inkomsten en totale territory-opbrengst moeten backend-authoritative zijn; UI mag geen tiertekst of geschatte placeholder-bedragen tonen wanneer echte serverwaarden beschikbaar zijn.
- Territory-passive income naar de crew-bank moet dezelfde cash-storage cap respecteren als normale crew deposits; volle cashopslag betekent geen verdere Territory-bijschrijving totdat er weer ruimte is.
- NL en EN copy synchroon voor alle nieuwe labels, flows, errors, meldingen en push/inbox events.
- UI blijft bruikbaar op mobiel/tablet/desktop met 1 primaire verticale scrollflow onder sticky headers.

## Cross-Module Dependencies
- Territory -> Crew (roles, permissions, membership, crew identity)
- Territory -> Crew Wars (optionele modifiers, season overlap, anti-snowball)
- Territory -> Dashboard (live ownership samenvatting, hot contests)
- Territory -> Crew economy (crew bank inkomsten en leader-statistieken)
- Territory -> Notifications (contest alerts, ownership changes, season rewards)
- Territory -> Travel (land-specifieke maps en country scope)
- Territory -> Admin (settings, moderation, logs, force actions)
- Territory -> Achievements (optional milestones per region/season)

## Must Preserve
- Duidelijke ownership per regio (welke crew controleert).
- Duidelijke contest status (idle, contested, lockdown, resolved).
- Duidelijke crew-gate in de UI: spelers zonder crew krijgen uitleg in plaats van een kale `not_in_crew` backendfout.
- Cross-country browse blijft toegestaan, maar territory-acties mogen alleen in de huidige Travel-locatie van de speler.
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
- `strategicTags` (harbor, border, capital, industry, logistics)
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
- Resolve-berekeningen moeten expliciet numeriek normaliseren op SQL aggregate-waarden (`SUM`, `COUNT`, bigint/decimal strings), zodat attacker-only contests niet stil als `no winner` eindigen door string-concatenatie of impliciete typecoercion.
- Bij retries/idempotency: contest resolve en reward payout exact-once semantics.
- Querys op region ownership moeten consistent zijn tussen map endpoint en leaderboard endpoint.
- Als `strategicTagsJson` of `neighborsJson` gebruikt worden voor scoring of action previews, moeten map endpoint, action response en modalinfo dezelfde bronwaarden gebruiken zodat UI-preview en server-authoritative punttoekenning niet uit elkaar lopen.
- Tijdelijke war-aftermath effecten mogen geen permanente mutatie op `territory_control.stability` zijn zolang stability geen autonome recovery-flow heeft; tijdelijke druk hoort in een aparte effectlaag met `startsAt`/`endsAt` te leven.

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
- `TERRITORY_PASSIVE_INCOME_INTERVAL_MINUTES`
- `TERRITORY_PASSIVE_INCOME_TIER_1_CASH`
- `TERRITORY_PASSIVE_INCOME_TIER_2_CASH`
- `TERRITORY_PASSIVE_INCOME_TIER_3_CASH`
- `TERRITORY_PASSIVE_INCOME_TIER_4_CASH`

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
- `GET /player/dashboard-stats` bevat voor crewleaders ook territory economy samenvattingen uit gecontroleerde regio's en `territory_reward_log`

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
- Mobiele kaartinteractie moet zoom/pan ondersteunen zodra regio's anders te klein worden voor betrouwbare touch input; pinch-zoom of een functioneel equivalent met resetpad is verplicht voor dichtbebouwde landenkaarten.
- Interactieve SVG-regio taps openen de primaire gebiedsdetails in een responsive modal/bottom-sheet; parallelle losse regiolijsten of duplicate actiekaarten onder de kaart gelden niet als done zodra directe kaartinteractie beschikbaar is.
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
- Territory resolve moet ook zonder actieve speler-read binnen maximaal circa 1 minuut verwerkt worden; tijdgestuurde contest-eindes mogen niet uitsluitend afhangen van map/overview/action requests.
- Fire-and-forget dispatch; gameplay transactie mag niet falen door notificatieproblemen.
- Copy parity NL/EN verplicht in UI + push + inbox.

## Multi-Country Rollout Guardrails
- Alle ondersteunde landen mogen browseable zijn zodra regio-seed + map validation compleet zijn.
- Nieuwe landen via admin-country onboarding flow met SVG mapping import en validation.
- Geen nieuwe country activatie zonder succesvolle map validation en smoke tests.
- Gameplay-acties in Territory moeten altijd valideren tegen de huidige Travel-locatie; alleen map-view endpoints mogen landoverschrijdend blijven.

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
10. Multi-country browse: alle enabled landen renderen interactieve regio's; action endpoints blokkeren correct buiten de huidige Travel-locatie.

## When To Update This File
Update bij nieuwe action types, scoring model veranderingen, nieuwe admin moderation actions, season wijzigingen, anti-abuse regels, of onboardingflow voor extra landen.