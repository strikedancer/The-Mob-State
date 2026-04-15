# Crew Wars Protocol

## Scope
Crew-vs-crew oorlogen met fases, scoring, war actions, anti-abuse controles, VIP-balancing, leaderboards, rewards en event-communicatie.

Scope-afbakening:
- Deze module dekt het war-event zelf: declareren, joinen, acties, scoring, afronding en rewards.
- Losse crew membership, ranks en HQ-progressie blijven onderdeel van `crew.md`.
- Losse PvP/hit contracts buiten een actieve war blijven onderdeel van `hitlist.md` en `crimes.md`.
- Discord-meldingen vallen onder Notifications/extern event transport en moeten via bestaande notificatieprincipes worden toegevoegd.

## Primary Frontend Entry
- client/lib/screens/crew_war_screen.dart
- client/lib/screens/crew_screen.dart
- client/lib/screens/dashboard_screen.dart

## Primary Backend Entry
- backend/src/routes/crewWars.ts
- backend/src/services/crewWarService.ts
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
- Crew Wars -> Admin (manual start/stop, moderation, abuse review, logs)

## Must Preserve
- Heldere war statusweergave: `preparing`, `active`, `lockdown`, `resolved`, `archived`.
- Duidelijke scheiding tussen individuele punten en crewpunten.
- Transparante puntopbouw voor kill, assist, defense, territory, loot en bonuses.
- Acties moeten traceerbaar blijven via war logs en admin-audit.
- Leaderboard en rewards moeten deterministisch herleidbaar zijn uit opgeslagen war actions.
- UI moet live spanning geven zonder kritieke acties of statusinfo op mobiel te verbergen.

## War Lifecycle Guardrails

### 1. Initiation
- Oorlog kan handmatig door admin, automatisch via scheduler of door crew leaders gestart worden.
- Crew leader flow vereist minimaal configureerbaar ledenaantal, war cooldown en optioneel inzet/entry cost.
- Één crew mag nooit een nieuwe war starten als cooldown, lock, sanction of onvoldoende leden actief is.

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
- Combo- en streakbonussen moeten cap-gedreven zijn en resetten bij death/timeout/farm detectie.
- Friendly fire, self-target loops, same-IP abuse, same-device clusters en repeated target farming leveren geen punten op.
- Herhaalde punten op hetzelfde target binnen een korte window moeten diminishing returns of volledige blokkade krijgen.

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
- Admin-gestarte wars en admin lifecycle-acties zoals `start_now` en `enter_lockdown` moeten exact dezelfde event-transports activeren als de reguliere war-flow; admin controls mogen geen stille bypass zijn voor push/inbox of Discord.
- Relevante Discord use-cases: war declared, war started, double points hour, territory swing, war ended, season rewards.

## Frontend Loading Guardrails
- War overview mag niet leegvallen als leaderboard of log-feed apart faalt.
- Gebruik partial rendering voor event header, timer, crew scores, personal stats en action log.
- Mobiele UI moet snelle toegang houden tot `join`, `attack`, `raid`, `stats` en `leaderboard`.

## QA Checklist
1. Admin war start werkt inclusief pre-war status.
2. Crew leader declare flow blokkeert correct bij onvoldoende leden of cooldown.
3. Kill/economy/territory/total war scoren volgens type-specifieke regels.
4. Anti-farm regels blokkeren punten voor repeated target abuse en same-IP scenario's.
5. VIP player en VIP crew bonuses respecteren caps en blijven zichtbaar in UI/logs.
6. Live leaderboard en persoonlijke stats verversen correct na action.
7. War end verdeelt rewards exact één keer en schrijft standings/logs correct weg.
8. Mobile en desktop layouts houden timers, scores en actieknoppen bruikbaar.
9. Notifications/inbox blijven werken; Discord failure mag war flow niet breken.
10. Minimaal Crew, Notifications, Dashboard en Admin mee testen als gekoppelde modules.

## i18n and Messaging
- Nieuwe war labels, war types, actions, errors, rewards, boosts en eventmeldingen moeten in NL en EN bestaan.
- War messaging moet consistent zijn tussen player UI, admin UI, push, inbox en toekomstige Discord copy.
- Als war flows player-behavior veranderen, moet Help & Uitleg voor crew/war modules worden bijgewerkt.

## When To Update This File
Update bij nieuwe war types, nieuwe VIP abilities, nieuwe action types, nieuwe anti-abuse regels, Discord uitbreidingen, season/reset logica of gewijzigde rewardstructuren.