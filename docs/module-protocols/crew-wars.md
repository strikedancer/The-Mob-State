# Crew Wars Protocol

## Scope
Crew-vs-crew oorlogen met fases, scoring, war actions, anti-abuse controles, VIP-balancing, leaderboards, rewards en event-communicatie.

Scope-afbakening:
- Deze module dekt het war-event zelf: declareren, joinen, acties, scoring, afronding en rewards.
- Losse crew membership, ranks en HQ-progressie blijven onderdeel van `crew.md`.
- Losse PvP/hit contracts buiten een actieve war blijven onderdeel van `hitlist.md` en `crimes.md`.
- Discord-meldingen vallen onder Notifications/extern event transport en moeten via bestaande notificatieprincipes worden toegevoegd.

## Primary Frontend Entry
- client/lib/screens/crew_screen.dart
- client/lib/screens/dashboard_screen.dart

## Primary Backend Entry
- backend/src/routes/crewWars.ts
- Primary Backend Entry: `backend/src/services/crewWarService.ts` (runtime keys `CREW_WAR_*`)
- Admin: `admin/src/components/CrewWarsAdminPanel.tsx` (`GET/PUT /admin/crew-wars/runtime-config`)
- backend/src/services/crewWarRaidService.ts
- backend/src/services/crewDealService.ts
- backend/src/routes/crewDeals.ts
- backend/src/services/notificationService.ts
- backend/src/services/discordWebhookService.ts
- backend/src/routes/admin.ts
- Prisma modellen: war, warParticipant, warAction, crewWarStanding, warSeason

## Change Rules
- Preserve core fairness: free spelers moeten competitief kunnen blijven zonder VIP-verplichting.
- VIP geeft efficiency en extra tactische opties, maar geen onbeperkte of niet-counterbare dominantie.
- War scoring, abuse-detectie en reward-verdeling moeten server-side leidend zijn.
- Live status, cooldowns en leaderboard-posities moeten na iedere relevante actie correct verversen.
- Nieuwe war-acties mogen bestaande combat-, crew- of economy-loops niet stilzwijgend breken.

## Cross-Module Dependencies
- Crew Wars -> Crew (members, leader permissions, crew status, crew bank, crew roles)
- Crew Wars -> Hitlist (combat data, kill context, PvP risico's, defense states)
- Crew Wars -> Crimes (damage, assists, hostile actions, anti-farming guardrails)
- Crew Wars -> Dashboard (live event samenvatting, countdowns, top rankings)
- Crew Wars -> Notifications (push, inbox, cooldown/event alerts, future Discord transport)
- Crew Wars -> Payments (VIP player and VIP crew entitlements)
- Crew Wars -> Achievements (season rewards, war titles, unlockables)
- Crew Wars -> Admin (`CrewWarsAdminPanel`: declare/moderation, season KPIs, leaderboard, logs)
- Crew Wars -> Territory (territory war targetselectie moet uit echte territory-regio\'s komen; generieke placeholder-targets gelden niet als done)

## Must Preserve
- Heldere war statusweergave: `preparing`, `active`, `lockdown`, `resolved`, `archived`.
- Duidelijke scheiding tussen individuele punten en crewpunten.
- Transparante puntopbouw voor kill, assist, defense, territory, loot en bonuses.
- Acties moeten traceerbaar blijven via war logs en admin-audit.
- Leaderboard en rewards moeten deterministisch herleidbaar zijn uit opgeslagen war actions.
- UI moet live spanning geven zonder kritieke acties of statusinfo op mobiel te verbergen.
- Het leden-minimum om een war te declareren is runtime (`CREW_WAR_MIN_MEMBERS` in Admin → Crew Wars), niet hardcoded. Code-default is **1** voor de startpopulatie; later via admin terug naar 3 of hoger. War Room toont het live getal.
- Andere war-pacing (voorbereiding, actieve duur, lockdown, cooldown) hoort bij dezelfde runtime-console.
- Territory War en Total War moeten hun claimbare gebieden tonen met echte Territory-regio-identiteit (regionKey + NL/EN naam), niet met abstracte labels zoals `docks` of `harbor`.
- Territory-targets moeten, zodra strategische Territory-metadata beschikbaar is, dezelfde bronwaarden meenemen voor `strategicTags`, claimbonus, tick-waarde en adjacency-context in zowel war-selectie, war scoring als War Room UI; Crew Wars mag geen los tweede waarderingsmodel naast Territory introduceren.
- War metadata bevat `theaterRegionKey` (theater-doel) + territory targets; dashboard exposeert theater + hot regions. Wars geven **geen** permanente ownership-skip — ownership blijft via Territory contests/resolve.
- `declareWar` / `adminDeclareWar` schrijven `theaterRegionKey` + NL/EN-naam bij Territory War / Total War (hoogste `warPriorityScore`). War Room toont het theater; bestaande wars zonder key worden bij read backfilled.
- Discord crew-war embeds tonen het theater wanneer bekend.
- Post-war aftermath schrijft typed region effects (`siege_momentum` / `region_fatigue`); `total_war` gebruikt een sterkere multiplier. Effective stability uit aftermath verlaagt capture-drempel tijdelijk.
- War Room toont crew-namen (niet ruwe IDs), gelokaliseerde rollen/acties en fase-countdowns. Offensieve actieknoppen zijn alleen klikbaar tijdens `active`; `lockdown` toont een afrondingsbanner. `territory_claim` is alleen zichtbaar bij Territory War / Total War.
- Hub-payload bevat `declareBlockReason` (`not_leader` | `in_war` | `not_enough_members` | `on_cooldown` | null) plus `myCrewCooldownUntil`. `declareWar` blokkeert resolved/archived wars die nog `cooldownUntil` in de toekomst hebben, voor beide crews.
- Een gewonnen `territory_war` of `total_war` mag tijdelijke druk terugschrijven naar echte Territory-regio's, maar die nasleep moet time-boxed zijn en via een aparte Territory effectlaag lopen in plaats van via permanente damage op ownership of stability. Verliezende crew krijgt `territory_frontline_pressure` notificatie.
- Metadata parsing voor war hubs en territory targets moet op standaard JavaScript array-methodes gebaseerd zijn en tolerant blijven voor legacy of lege metadata; een parsefout in war metadata mag gekoppelde dashboard/player responses niet 500 laten gaan.

## War Lifecycle Guardrails

### 1. Initiation
- Oorlog kan handmatig door admin, automatisch via scheduler of door crew leaders gestart worden.
- Crew leader flow vereist minimaal configureerbaar ledenaantal, war cooldown en optioneel inzet/entry cost.
- Één crew mag nooit een nieuwe war starten als cooldown, lock, sanction of onvoldoende leden actief is.
- `GET /crew-wars/hub` markeert doelcrews met `inCooldown` op basis van resolved/archived wars met toekomstige `cooldownUntil` (niet op basis van de nog lopende war zelf). De War Room disablet die doelen en toont waarom declare geblokkeerd is.

### 2. Phases
- `preparing`: 5-30 minuten voorbereiding, join/lock van deelnemers, aankondigingen.
- `active`: hoofdvenster van 24-72 uur met live scoring en toegestane war actions.
- `lockdown`: laatste minuten zonder nieuwe offensieve acties, alleen afronden/reconcilen.
- `resolved`: winnaars, rewards en logs berekend; geen nieuwe acties meer.

### 3. War Types
- `kill_war`: focus op kills, assists, streaks en VIP/leader bonusdoelen.
- `economy_war`: punten op basis van gestolen of verdedigd geld, met caps en anti-farm regels.
- `territory_war`: punten per gebied per interval, met claim/contest timers.
- `total_war`: gecombineerde ruleset met strengste anti-abuse checks en hoogste visibility.

## Scoring & Balance Guardrails
- Basispunten moeten per war type configureerbaar zijn.
- Kill, assist, defense, territory tick en economy loot moeten als losse action records opgeslagen worden.
- Territory claim- en tick-punten mogen strategisch variëren per doelregio, maar de bonusberekening moet server-side deterministisch blijven en uit opgeslagen territory target metadata herleidbaar zijn.
- Combo- en streakbonussen moeten cap-gedreven zijn en resetten bij death/timeout/farm detectie.
- Friendly fire, self-target loops, same-IP abuse, same-device clusters en repeated target farming leveren geen punten op.
- Herhaalde punten op hetzelfde target met dezelfde actie (zoals Doden) binnen 30 minuten: na 2 treffers volgt een blok. Een mug of raid telt niet als Doden. Spelertekst mag geen jargon als “anti-farm” of “boerderijblok” gebruiken.

## VIP Integration Guardrails

### VIP Players
- Toegestane voordelen: beperkte puntenbonus, extra war action budget, kortere cooldowns, premium actions.
- Premium acties zoals `precision_hit` en `intel_scan` moeten usage caps hebben per uur of per war.
- Geen enkele VIP bonus mag stacked worden tot een gegarandeerde kill-loop of oncounterbare snowball.

### VIP Crews
- VIP crew voordelen mogen team utility bieden, zoals tijdelijke shield/boost windows of snellere territory capture.
- Parallelle wars alleen toestaan als crew-status, member count en anti-abuse regels dat toelaten.
- VIP crew boost moet gelogd, zichtbaar en eindig zijn; nooit permanent passief actief.

## Action Types
- `attack_kill`
- `attack_mug`
- `attack_sabotage`
- `defense_success`
- `intel_scan`
- `raid`
- `crew_shield`
- `war_boost`
- `territory_claim`
- `territory_tick`

### Raid loot, sabotage and peacetime deals
- `raid` steals from the **enemy crew storage** during an active war only (not peacetime, not personal inventory). The actor picks one loot type: cash, car/moto, boat, weapons, ammo, drugs or trade goods. Take is partial, must fit attacker storage, or the action fails. A successful `crew_shield` in the last 75 minutes reduces loot (~40%). Cash cap stays €75k / 8% of bank.
- `attack_sabotage` can drop **one side building** (not HQ) by one level per building per war, never below level 1. Surplus over the new cap stays; deposits block until they rebuild. Shield can block the level drop but still awards the action. Building visual style follows the new level tier. The sabotage lookup must use `input.warId` (a bare `warId` identifier 500s the War Room action).
- Crew storage deals (`/crew-deals`) are **peacetime escrow**: leader/co-leader only. Goods leave storage immediately, the other crew adds their side, both confirm, then swap. Cancel, ~2h timeout or no capacity rolls everything back.

Elke action vereist:
- attacker/actor id
- target id of target crew/territory
- war id
- action type
- result enum
- points delta
- economy delta (indien relevant)
- abuse flags / moderation flags
- timestamp

## Backend Contract Guardrails

### Suggested Tables
```sql
war
- id
- type
- status
- initiatedByPlayerId
- initiatedByCrewId
- defendingCrewId
- startTime
- activeFrom
- lockDownFrom
- endTime
- cooldownUntil
- entryStake
- createdAt

war_participant
- id
- warId
- playerId
- crewId
- role
- joinedAt
- points
- kills
- deaths
- assists
- damageDone
- damageTaken
- lootStolen
- abuseFlagCount

war_action
- id
- warId
- attackerId
- attackerCrewId
- targetId
- targetCrewId
- territoryId
- actionType
- result
- pointsAwarded
- moneyDelta
- metadataJson
- createdAt

crew_war_standing
- id
- warId
- crewId
- totalPoints
- totalKills
- totalDeaths
- totalLoot
- territoriesHeld
- rank

war_season
- id
- seasonKey
- startsAt
- endsAt
- status
- rewardConfigJson
```

- Alle score-mutaties moeten transaction-safe zijn.
- Reward-uitkering mag nooit dubbel gebeuren bij retry of race condition.
- Anti-abuse flags moeten auditbaar blijven voor admin review.
- Leaderboard queries moeten server-side sortable en consistent zijn voor web/mobile/admin.

## Notifications, Discord & Messaging
- Start, countdown, lock-down, winner en personal milestone meldingen moeten NL/EN consistent zijn.
- War notifications mogen hoofdflows niet blokkeren; failures blijven fire-and-forget.
- Discord-integratie mag alleen een extra transportlaag zijn bovenop bestaande war events; game state mag nooit afhankelijk zijn van een Discord webhook.
- Discord berichten moeten per event-type configureerbaar zijn, rate-limited en veilig bij webhook failure.

### Discord onboarding (env)

Optional fire-and-forget transport. Backend: `backend/src/services/discordWebhookService.ts`.

1. Create a Discord incoming webhook in the staff/ops channel.
2. Set on the VPS (`.env.plesk` / compose env), then recreate the backend container:

```
CREW_WAR_DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
CREW_WAR_DISCORD_ENABLED_EVENTS=war_declared,war_started,war_lockdown,war_resolved
CREW_WAR_DISCORD_MIN_INTERVAL_MS=15000
```

3. Empty `CREW_WAR_DISCORD_WEBHOOK_URL` = transport off. Game wars still run.
4. Templates: `backend/.env.example` and `.env.docker.example`. Compose must pass the three keys through (see `docker-compose.plesk.yml`).
5. Do not put a real webhook URL in git.
6. Player-facing patch notes use a **different** webhook (`DISCORD_UPDATES_WEBHOOK_URL` on public `#updates`). Never point Crew Wars events at that channel. See `discord.md`.
- Admin-gestarte wars en admin lifecycle-acties zoals `start_now` en `enter_lockdown` moeten exact dezelfde event-transports activeren als de reguliere war-flow; admin controls mogen geen stille bypass zijn voor push/inbox of Discord.
- Bij `declared`, `started`, `lockdown` en `resolved` moeten alle betrokken crew members, inclusief leaders, een consistente push/inbox-notificatie kunnen ontvangen; automatische lifecycle-transities mogen die member-notificaties niet overslaan.
- Discord-berichten in `#crew-wars` tonen **crew-namen** (geen `attackerCrewId`), war-type in het Nederlands, en bij einde de **winnaar + stand**. `war_resolved` gaat mee zodra de war eindigt; de game-tick synct open wars zodat dat niet wacht tot iemand de War Room opent.

## Frontend Loading Guardrails
- War overview mag niet leegvallen als leaderboard of log-feed apart faalt.
- Gebruik partial rendering voor event header, timer, crew scores, personal stats en action log.
- Mobiele UI moet snelle toegang houden tot `join`, `attack`, `raid`, `stats` en `leaderboard`.

## QA Checklist
1. Admin war start werkt inclusief pre-war status.
2. Crew leader declare flow blokkeert correct bij onvoldoende leden (live `CREW_WAR_MIN_MEMBERS`) of cooldown.
2a. War Room: lockdown toont geen klikbare attack-knoppen; preparing toont start-countdown + join; recente wars tonen crew-namen.
3. Kill/economy/territory/total war scoren volgens type-specifieke regels.
4. Anti-farm regels blokkeren punten voor repeated target abuse en same-IP scenario's.
5. VIP player en VIP crew bonuses respecteren caps en blijven zichtbaar in UI/logs.
6. Live leaderboard en persoonlijke stats verversen correct na action.
7. War end verdeelt rewards exact één keer en schrijft standings/logs correct weg.
8. Mobile en desktop layouts houden timers, scores en actieknoppen bruikbaar.
9. Notifications/inbox blijven werken; Discord failure mag war flow niet breken. Discord `#crew-wars` toont namen + winnaar, geen ruwe IDs.
11. Raid asks for a loot type, fails when the attacker has no room, and never takes personal inventory.
12. Sabotage cannot drop HQ or go below level 1, and the same building cannot drop twice in one war.
13. Crew deals lock goods on create/counter, require both officer confirms, and return goods on cancel/timeout/no capacity.

## i18n and Messaging
- Nieuwe war labels, war types, actions, errors, rewards, boosts en eventmeldingen moeten in NL en EN bestaan.
- War messaging moet consistent zijn tussen player UI, admin UI, push, inbox en toekomstige Discord copy.
- Als war flows player-behavior veranderen, moet Help & Uitleg voor crew/war modules worden bijgewerkt.

## When To Update This File
Update bij nieuwe war types, nieuwe VIP abilities, nieuwe action types, nieuwe anti-abuse regels, Discord uitbreidingen, season/reset logica of gewijzigde rewardstructuren.