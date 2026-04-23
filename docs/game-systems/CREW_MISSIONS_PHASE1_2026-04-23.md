# Crew Missions - Phase 1 Specificatie (2026-04-23)

Dit document zet **Phase 1** voor Crew Missions concreet vast:
- 6 missies (direct implementeerbaar)
- exacte timer/cooldown/reward/fail-ratio
- credits skip-prijsmodel
- NL/EN UI-keys
- image set + prompts (Codex/ChatGPT/Leonardo)

## Doel van Phase 1

- Meer co-op content voor crews zonder pay-to-win.
- Sterke herhaalbaarheid met variatie en role-bonussen.
- Geen harde dagcap; actieve spelers mogen sneller vorderen.
- Balans via risico, tijd en soft diminishing, niet via harde blokkades.

## Unlocks en gates

- Crew Missions tab zichtbaar vanaf: `crew HQ global level >= 1`
- Tier 1 missies: direct beschikbaar
- Tier 2 missies: `HQ global level >= 5` en minimaal 2 online crewleden
- Tier 3 missies: `HQ global level >= 9` en minimaal 3 online crewleden

## Role model (Phase 1)

Rollen:
- Planner
- Enforcer
- Logistics
- Tech

Role bonus (per unieke rol bezet):
- +3% success chance
- -2% mission duration

Cap:
- Max +12% success
- Max -8% duration

## Missiecatalogus (6 missies)

## Tier 1

### 1) Safehouse Supply Run
- key: `safehouse_supply_run`
- basisduur: `8m`
- cooldown na missie: `10m`
- basis success chance: `74%`
- fail penalty: `-8% crew cash reward equivalent` (resource verlies)
- reward bij succes:
  - crew cash: `€45,000 - €70,000`
  - crew xp: `55`
  - personal contribution xp: `28`

### 2) Street Intel Sweep
- key: `street_intel_sweep`
- basisduur: `9m`
- cooldown na missie: `11m`
- basis success chance: `70%`
- fail penalty: `-10% crew cash reward equivalent`
- reward bij succes:
  - crew cash: `€52,000 - €82,000`
  - crew xp: `62`
  - personal contribution xp: `32`

## Tier 2

### 3) Armory Smuggle Chain
- key: `armory_smuggle_chain`
- basisduur: `16m`
- cooldown na missie: `18m`
- basis success chance: `62%`
- fail penalty: `-14% crew cash reward equivalent`
- reward bij succes:
  - crew cash: `€100,000 - €150,000`
  - crew xp: `105`
  - personal contribution xp: `52`

### 4) Port Hijack Window
- key: `port_hijack_window`
- basisduur: `18m`
- cooldown na missie: `20m`
- basis success chance: `58%`
- fail penalty: `-16% crew cash reward equivalent`
- reward bij succes:
  - crew cash: `€118,000 - €178,000`
  - crew xp: `122`
  - personal contribution xp: `60`

## Tier 3

### 5) Casino Ledger Raid
- key: `casino_ledger_raid`
- basisduur: `30m`
- cooldown na missie: `28m`
- basis success chance: `52%`
- fail penalty: `-20% crew cash reward equivalent`
- reward bij succes:
  - crew cash: `€230,000 - €340,000`
  - crew xp: `220`
  - personal contribution xp: `105`

### 6) Federal Convoy Break
- key: `federal_convoy_break`
- basisduur: `34m`
- cooldown na missie: `32m`
- basis success chance: `48%`
- fail penalty: `-24% crew cash reward equivalent`
- reward bij succes:
  - crew cash: `€290,000 - €430,000`
  - crew xp: `265`
  - personal contribution xp: `130`

## Partial completion regels

- Partial threshold: `>= 60% objective progress`
- Partial payout:
  - `65%` van cash reward
  - `70%` van crew xp
  - `100%` van contribution xp (voor actieve deelnemers)

## Reward split (team)

- 65% gelijk verdeeld over actieve deelnemers.
- 35% contribution-weighted.

Minimale bijdrage voor full payout:
- `contributionScore >= 0.55 * teamAverage`

Onder minimum:
- speler krijgt max `55%` van zijn normale persoonlijke payout.

## Credits versnellen (cooldown skip)

Formule:
- `credits = ceil(remainingMinutes * tierRate)`

Tier rates:
- Tier 1: `5 credits/min`
- Tier 2: `6 credits/min`
- Tier 3: `7 credits/min`

Extra regels:
- Geen kosten als er geen actieve cooldown is.
- Min skipkost: `6 credits`
- Max skipkost per missie: `240 credits`
- Skip geeft **geen** bonus op rewards of success chance.

## Anti-spam / diminishing

Sessie-window:
- `90 minuten`

Herhaling van dezelfde missie in dat window:
- 1e run: `100% rewards`
- 2e run: `93% rewards`
- 3e run: `86% rewards`
- 4e+ run: `80% rewards floor`

Herstel:
- Na 90 minuten zonder die missie: multiplier terug naar 100%.

## Runtime config keys (voor admin tuning)

- `CREW_MISSION_T1_CREDITS_PER_MINUTE` (default `5`)
- `CREW_MISSION_T2_CREDITS_PER_MINUTE` (default `6`)
- `CREW_MISSION_T3_CREDITS_PER_MINUTE` (default `7`)
- `CREW_MISSION_REPEAT_WINDOW_MINUTES` (default `90`)
- `CREW_MISSION_REPEAT_2_MULTIPLIER` (default `0.93`)
- `CREW_MISSION_REPEAT_3_MULTIPLIER` (default `0.86`)
- `CREW_MISSION_REPEAT_4_MULTIPLIER` (default `0.80`)

## NL/EN UI-keys (Phase 1 minimum)

- `crewMissions.title`
  - nl: `Crew Missies`
  - en: `Crew Missions`
- `crewMissions.status.ready`
  - nl: `Klaar`
  - en: `Ready`
- `crewMissions.status.inProgress`
  - nl: `Bezig`
  - en: `In Progress`
- `crewMissions.status.cooldown`
  - nl: `Cooldown`
  - en: `Cooldown`
- `crewMissions.action.start`
  - nl: `Start missie`
  - en: `Start mission`
- `crewMissions.action.speedUp`
  - nl: `Versnel`
  - en: `Speed up`
- `crewMissions.reward.crewCash`
  - nl: `Crew cash`
  - en: `Crew cash`
- `crewMissions.reward.crewXp`
  - nl: `Crew XP`
  - en: `Crew XP`

## Image set (Phase 1)

Per missie:
- 1 card image
- 1 scene image

Totaal:
- 12 images

Opslag:
- `runtime/client-images/crew_missions/cards/`
- `runtime/client-images/crew_missions/scenes/`

Client paden:
- `images/crew_missions/cards/<mission_key>.png`
- `images/crew_missions/scenes/<mission_key>.png`

## Prompt templates (Leonardo/Codex/ChatGPT)

### Card prompt template
`Cinematic neo-noir mafia game card art, mission "<MISSION_NAME>", top-down urban composition, dramatic warm lighting, high contrast, clean focal subject, no text overlay, premium game UI style, 16:9, ultra-detailed, realistic digital painting`

### Scene prompt template
`In-game mission scene for mafia strategy RPG, "<MISSION_NAME>", gritty city atmosphere, realistic materials, dynamic action moment, readable composition for mobile and desktop, no logos no text, dark amber color grading, 16:9`

### Mission prompt seeds
- Safehouse Supply Run: back-alley safehouse, van unloading contraband crates.
- Street Intel Sweep: surveillance team scanning city blocks at night.
- Armory Smuggle Chain: covert weapon convoy crossing industrial docks.
- Port Hijack Window: container terminal takeover under floodlights.
- Casino Ledger Raid: hidden office vault behind casino floor.
- Federal Convoy Break: armored convoy ambush on elevated highway.

## Technische implementatievolgorde (Phase 1)

1. Datamodel + routes:
- mission templates
- active runs
- cooldown state
- contribution ledger

2. Crew UI:
- mission list cards
- start flow
- in-progress state
- result modal

3. Credits skip flow:
- tooltip met exacte prijs
- confirm dialog
- server-side validate active cooldown

4. Notifications:
- mission started
- mission completed/failed
- cooldown ready

5. Admin telemetry:
- start/success/fail ratios
- payout per minute
- skip usage
- anomaly flags

## Backend skeleton status (live basis)

Beschikbare basis-endpoints:
- `GET /crew-missions/overview`
- `GET /crew-missions/templates`
- `POST /crew-missions/start`
- `POST /crew-missions/runs/:id/resolve`
- `POST /crew-missions/runs/:id/claim`
- `POST /crew-missions/runs/:id/speedup`
- `GET /admin/crew-missions/telemetry`
- `GET /admin/crew-missions/runtime-config`
- `PUT /admin/crew-missions/runtime-config`

Schema bootstrap:
- `ensureCrewMissionSchema` maakt mission tables automatisch aan bij backend startup.

## Client integration status (Crew tab)

Gekoppeld in `crew_screen.dart`:
- Nieuwe tab `Crew Missions` (tussen War Room en Crews).
- Overzicht via `/crew-missions/overview`.
- Template-cards met mission image + fallback icon.
- Active run actions:
  - start (leader/co-leader)
  - resolve (leader/co-leader zodra timer klaar is)
  - claim rewards
  - speedup cooldown met credits
- Recente runs zichtbaar in dezelfde tab.

Opmerking:
- Speedup-kosten worden server-side berekend en afgedwongen.
- In Phase 1 UI tonen we nog geen vooraf berekende prijsbadge op de knop.
- Help-content (Crew topic) is bijgewerkt voor de nieuwe Crew Missions-tab en actions.

## Acceptatiecriteria (Phase 1 done)

- Alle 6 missies speelbaar.
- NL + EN labels volledig aanwezig.
- Rewardsplit en contribution werken volgens spec.
- Credits skip prijs volgt formule en toont correcte kosten vooraf.
- Geen pay-to-win reward advantage.
- Image cards/scenes laden op web/mobile met icon fallback.
- Admin telemetry toont live Phase 1 data.
