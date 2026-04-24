# Crew Missions Protocol

## Scope
Co-op crew missies met gezamenlijke objectives, role-based taken, risicofases, rewards en cooldown pacing.

Phase 1 baseline: `docs/game-systems/CREW_MISSIONS_PHASE1_2026-04-23.md`

Dit protocol is leidend voor:
- missie-types en mission-flow
- teamrollen en deelname-eisen
- reward-verdeling en progression-impact
- balans tussen actieve spelers en casual spelers
- image/content pipeline voor mission cards en mission scenes

## Primary Frontend Entry
- `client/lib/screens/crew_screen.dart` (tab of subsection `Crew Missions`)
- Eventueel dedicated screen: `client/lib/screens/crew_missions_screen.dart`

## Primary Backend Entry
- `backend/src/routes/crewMissions.ts`
- `backend/src/services/crewMissionService.ts`
- `backend/src/services/crewMissionBalanceService.ts`
- `backend/src/services/notificationService.ts` (mission alerts/results)
- `backend/src/startup/ensureCrewMissionSchema.ts`

## Backend API Skeleton (Phase 2)

Player endpoints:
- `GET /crew-missions/overview`
- `GET /crew-missions/templates`
- `POST /crew-missions/start`
- `POST /crew-missions/runs/:id/resolve`
- `POST /crew-missions/runs/:id/claim`
- `GET /crew-missions/runs/:id/speedup-quote`
- `POST /crew-missions/runs/:id/speedup`

Admin endpoints:
- `GET /admin/crew-missions/telemetry`
- `GET /admin/crew-missions/runtime-config`
- `PUT /admin/crew-missions/runtime-config`

## Client UI Status (Phase 3 Basis)

Geactiveerd in:
- `client/lib/screens/crew_screen.dart` als extra tab `Crew Missions`

Beschikbaar in de tab:
- mission-overview load (`GET /crew-missions/overview`)
- templates met image-first cards + icon fallback
- role-assign dialog bij start (planner/enforcer/logistics/tech per crewlid)
- active run card met status en timer
- acties: `start`, `resolve`, `claim`, `speedup`
- speedup quote + confirm-dialog met exacte creditsprijs vooraf
- recente runs lijst

UX/i18n baseline:
- alle nieuwe labels/buttons/statussen in NL + EN
- responsive layout via `SingleChildScrollView` + `Wrap` cards
- permissiehint voor non-leader/co-leader zichtbaar in UI
- `Help & Uitleg` crew-topic bijgewerkt zodat de nieuwe Crew Missions-tab en flow ook in NL/EN documentatie staat.

## Notification Status (Phase 4 Basis)

Ingebouwd voor Crew Missions:
- push + in-app event bij mission start
- push + in-app event bij mission result (success/partial/fail)
- push + in-app event bij cooldown ready
- cooldown-ready dispatch via persistente cron-scan (`processPendingCrewMissionCooldownReadyNotifications`) i.p.v. alleen in-memory timer

## Cross-Module Dependencies
- Crew Missions -> Crew (leden, leader/officer permissies, HQ gates)
- Crew Missions -> Crimes/Jobs (action templates en risk profiles)
- Crew Missions -> Territory (region modifiers, adjacency bonuses)
- Crew Missions -> Travel (cross-country transport missions)
- Crew Missions -> Inventory/Tools/Weapons (loadouts, consumables, mission requirements)
- Crew Missions -> Payments/Premium (utility boosts, nooit pay-to-win power)
- Crew Missions -> Notifications (start/reminder/result)
- Crew Missions -> Admin (monitoring, exploit flags, balancing)

## Mission Catalog (Baseline)

Gebruik minimaal 3 moeilijkheidslagen met oplopende coördinatie.

### Tier 1 - Quick Ops (5-12 min)
- `Safehouse Supply Run`
- `Street Intel Sweep`
- `Courier Intercept`

Doel:
- Lage instap, korte loops, meerdere keren per sessie speelbaar.

### Tier 2 - Coordinated Ops (12-25 min)
- `Armory Smuggle Chain`
- `Port Hijack Window`
- `City Vault Prep`

Doel:
- Team timing belangrijk, 2-4 actieve deelnemers aanbevolen.

### Tier 3 - High-Stakes Operations (25-45 min)
- `Casino Ledger Raid`
- `Territory Blackout Push`
- `Federal Convoy Break`

Doel:
- Hoge risk/reward, duidelijke fail states, sterk crewgevoel.

## Role Model (Verplicht)

Iedere missie ondersteunt minimaal deze rollen:
- `Planner` (kan missie starten en route kiezen)
- `Enforcer` (combat/risk phase bonus)
- `Logistics` (travel/time/material bonus)
- `Tech` (intel/hack/precision bonus)

Regels:
- 1 speler mag meerdere rollen invullen als crew klein is.
- Grotere crews krijgen role-efficiency bonus, niet mandatory role locks.
- Leader mag mission templates instellen; officers mogen runs starten.

## Progression and Gating Rules

- Geen hard daily cap.
- Missies gebruiken soft pacing via cooldowns en oplopende risk.
- Actieve spelers mogen sneller vorderen, maar met diminishing returns bij spam.
- Core unlocks via crew progress, niet via betaalmuur.
- Premium mag alleen utility geven (bijv. extra reroll of planning slot), nooit exclusieve top reward power.

## Reward Model (Balance-First)

Per missie-resultaat:
- Crew cash
- Crew XP/progress points
- Persoonlijke bijdrage XP
- Kans op bonus loot/materialen

Verdeling:
- Basis reward voor alle deelnemers
- Prestatiebonus op contribution score
- Anti-carry guardrail: minimale deelname vereist voor volle payout

Fail/partial outcomes:
- Geen all-or-nothing
- Partial extraction = partial rewards
- Complete fail kan resources kosten, maar geen hard punitive death spiral

## Cooldown and Pacing Framework

Cooldown per tier:
- Tier 1: kort
- Tier 2: medium
- Tier 3: lang

Belangrijk:
- Cooldown timeouts worden geprijsd via dezelfde economy-ratio als andere action loops.
- Geen vaste credit-prijs los van resterende tijd.
- `credits per minuut` moet consistent zijn met crimes/jobs/vehicle/school skip-logica.

## Anti-Abuse Guardrails

- Detecteer repeat farming van dezelfde missie met identieke samenstelling.
- Apply diminishing multiplier bij korte interval spam.
- Log anomaly events naar admin (`crew_mission_anomaly`).
- Beloningsclaims idempotent maken (geen double-claim race).

## UX and Content Rules

- Mission cards altijd image-first + icon fallback.
- Duidelijke status badges: `Ready`, `In Progress`, `Cooldown`, `Locked`.
- Result screen toont:
  - mission score
  - team contribution
  - reward split
  - volgende beschikbare window
- Alle nieuwe teksten NL + EN synchroon.

## Image Pipeline (Codex/ChatGPT/Leonardo)

Toegestane generatiebronnen:
- Codex image generation
- ChatGPT image generation
- Leonardo.ai API

Opslagregels:
- Mission images extern opslaan onder runtime mount:
  - `runtime/client-images/crew_missions/cards/`
  - `runtime/client-images/crew_missions/scenes/`
- Client pad via web-safe route:
  - `images/crew_missions/cards/<mission_key>.png`
  - `images/crew_missions/scenes/<mission_key>.png`

Bestandsconventies:
- `crew_mission_<mission_key>_card_v1.png`
- `crew_mission_<mission_key>_scene_v1.png`

Visual direction:
- Mob/city/noir stijl consistent met bestaande game.
- Geen generieke stock-look.
- Goed leesbare focus op objective (bijv. convoy, vault, harbor, casino backroom).

## Admin and Telemetry Requirements

Admin moet minimaal kunnen zien:
- Mission start/completion rate
- Success/fail/partial ratio per mission
- Gemiddelde duration
- Reward per minute per tier
- Credit skip usage per tier
- Top anomaly flags

Verplicht endpointset:
- `/api/admin/crew-missions/telemetry`
- `/api/admin/crew-missions/runtime-config`

## QA Checklist

1. Start, complete en fail minstens 1 missie per tier.
2. Controleer role-assign flow met 1, 2 en 4 spelers.
3. Controleer reward-split en contribution-waardes.
4. Controleer cooldown gedrag + credit skip pricing op remaining time.
5. Controleer mission images op web/mobile inclusief fallback.
6. Controleer NL/EN parity van alle mission UI teksten.
7. Controleer notifications/inbox op start, reminder en result.
8. Controleer admin telemetry op live data na tests.
9. Controleer dat mission economy geen pay-to-win escalatie veroorzaakt.

## Must Preserve

- Core progression blijft skill/activiteit-gedreven.
- Geen mission loop mag economy of bestaande loops (crimes/jobs/crew wars) breken.
- Geen premium purchase mag mission success direct garanderen.
- Spelers zonder premium moeten alle mission tiers kunnen spelen.

## When To Update This File

Update dit protocol bij:
- nieuw mission type of nieuwe tier
- wijziging in reward model
- wijziging in cooldown/credit skip model
- nieuwe image pipeline of runtime image structuur
- nieuwe admin telemetry of anti-abuse regels
