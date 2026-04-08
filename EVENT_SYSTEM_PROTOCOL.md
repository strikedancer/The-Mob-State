# Event System Protocol

## Goal

Bouw een centraal, uitbreidbaar event-platform voor de game in plaats van losse hardcoded events per systeem.

Het platform moet:

1. Lopende, aankomende en afgelopen events centraal beheren.
2. Ondersteunen dat events invloed hebben op bestaande systemen zoals voertuigen, crimes, crypto, drugs, smuggling, prostitution en combat.
3. Ondersteunen dat events individueel of via schema's gestart, gestopt, gepauzeerd en aangepast kunnen worden vanuit admin.
4. Een duidelijke speler-UX bieden via dashboard banners, een aparte events-pagina, live timers, leaderboards en reward-overzichten.
5. Volledig multi-language zijn voor spelerteksten en admin labels waar relevant.

---

## Waarom Een Apart Event Systeem

De huidige situatie is gefragmenteerd:

1. Sommige events zijn hardcoded in een specifiek domein, zoals politievoertuigen in de voertuig-logica.
2. VIP-events hebben hun eigen tabel en flow.
3. World events worden vooral gebruikt als logging/feed, niet als centraal event-orchestratie-systeem.

Dat werkt voor enkele losse features, maar niet voor:

1. Competitieve events met ranglijsten.
2. Tijdelijke wereldmodifiers.
3. Admin-gedreven planning en configuratie.
4. Complexe rewards.
5. Samengestelde events of chain-events.
6. Event bosses of interactieve wereldobjecten zoals politie-aanvallen of een politieheli.

Conclusie:

Ja, dit moet een apart, generiek event-systeem worden.

---

## Kernprincipes

1. Event-definitie los van event-uitvoering.
2. Event-UI los van event-logica.
3. Event-progressie los van bestaande gameplay-tabellen, maar wel gekoppeld via adapters/hooks.
4. Rewards declaratief configureerbaar in admin.
5. Scheduling en overrides via admin, niet hardcoded in service-files.
6. Alle spelerteksten via i18n keys en vertaalbare contentvelden.
7. Event-impact moet uitlegbaar zijn in UI: wat is actief, wat verandert, hoe lang nog, wat levert het op.

---

## Hoofdarchitectuur

Het systeem bestaat uit 6 lagen.

### 1. Event Templates

Herbruikbare definities van eventtypes.

Voorbeelden:

1. `vehicle_police_spawn`
2. `crypto_market_surge`
3. `vehicle_theft_competition`
4. `drug_production_challenge`
5. `smuggling_to_country_competition`
6. `pimping_quota_event`
7. `high_police_presence`
8. `drug_heatwave_raid_event`
9. `police_helicopter_hunt`
10. `police_force_boss`

Een template beschrijft:

1. Type event.
2. Welke systemen het raakt.
3. Welke configuratievelden nodig zijn.
4. Welke UI-componenten gebruikt worden.
5. Welke metrics/progress bijgehouden worden.
6. Welke reward-typen toegestaan zijn.

### 2. Event Schedules

Planning voor automatische activatie.

Voorbeelden:

1. Elke 3 uur 45 minuten actief.
2. Elke zaterdag 20:00 UTC.
3. Random binnen een venster met minimum cooldown.
4. Handmatig gestart vanuit admin.

### 3. Live Events

Een concrete actieve of geplande instantie van een template.

Bevat runtime state zoals:

1. Status: draft, scheduled, active, paused, completed, cancelled.
2. Start- en eindtijd.
3. Config snapshot.
4. Live modifiers.
5. Reward snapshot.
6. Boss state of world-state indien relevant.

### 4. Event Progress Tracking

Voor individuele en globale progressie.

Voorbeelden:

1. Aantal gestolen auto's per speler.
2. Gram cocaïne geproduceerd tijdens event.
3. Aantal smokkelruns naar land X.
4. Damage dealt aan politie-eenheid.
5. Totale community progress voor een cooperative event.

### 5. Event Rewards Engine

Declaratief systeem dat rewards kan uitdelen op basis van:

1. Deelname.
2. Top X ranking.
3. Percentage thresholds.
4. Boss kill of community completion.
5. Random drop tables.

### 6. Event Presentation Layer

Voor spelerweergave:

1. Dashboard banner.
2. Events overzichtspagina.
3. Detailpagina per event.
4. Leaderboard panels.
5. CTA banners in relevante schermen.
6. Result/reward dialogs.

---

## Aanbevolen Datamodel

Nieuwe generieke tabellen naast bestaande `WorldEvent` logging.

### EventTemplate

Doel: herbruikbare blueprint.

Velden:

1. `key`
2. `category`
3. `eventType`
4. `titleNl`
5. `titleEn`
6. `shortDescriptionNl`
7. `shortDescriptionEn`
8. `descriptionNl`
9. `descriptionEn`
10. `icon`
11. `bannerImage`
12. `configSchemaJson`
13. `uiSchemaJson`
14. `isActive`

### EventSchedule

Doel: automatische planning.

Velden:

1. `templateId`
2. `scheduleType` met waarden zoals `cron`, `interval`, `manual`, `random_window`
3. `intervalMinutes`
4. `durationMinutes`
5. `cronExpression`
6. `startWindowUtc`
7. `endWindowUtc`
8. `cooldownMinutes`
9. `enabled`
10. `weight`

### LiveEvent

Doel: runtime eventinstantie.

Velden:

1. `id`
2. `templateId`
3. `status`
4. `startedAt`
5. `endsAt`
6. `resolvedAt`
7. `configJson`
8. `stateJson`
9. `announcementJson`
10. `scopeJson`
11. `createdByAdminId`

### LiveEventModifier

Doel: wereldmodifiers per actief event.

Voorbeelden:

1. `crime_success_multiplier`
2. `vehicle_theft_success_multiplier`
3. `vehicle_police_spawn_enabled`
4. `drug_raid_chance_multiplier`
5. `crypto_volatility_multiplier`
6. `smuggling_profit_multiplier`

Velden:

1. `liveEventId`
2. `targetSystem`
3. `modifierKey`
4. `operation` met waarden als `multiply`, `add`, `override`, `enable`
5. `value`
6. `conditionsJson`

### EventParticipantProgress

Doel: progressie per speler of crew.

Velden:

1. `liveEventId`
2. `playerId`
3. `crewId`
4. `progressJson`
5. `score`
6. `rank`
7. `qualified`
8. `lastContributionAt`

### EventLeaderboardSnapshot

Doel: opslag van periodieke/toplist snapshots.

Velden:

1. `liveEventId`
2. `boardType`
3. `snapshotAt`
4. `entriesJson`

### EventRewardRule

Doel: configureerbare rewarddefinities.

Velden:

1. `liveEventId`
2. `triggerType` met waarden zoals `participation`, `rank_range`, `threshold`, `community_complete`, `boss_kill`
3. `triggerConfigJson`
4. `rewardsJson`

### EventRewardClaim

Doel: uitbetaling en audit trail.

Velden:

1. `liveEventId`
2. `playerId`
3. `rewardRuleId`
4. `grantedRewardsJson`
5. `claimedAt`
6. `deliveryStatus`

### EventBossState

Nodig voor interactieve events zoals politie-aanvallen of helikopter events.

Velden:

1. `liveEventId`
2. `bossType`
3. `currentHealth`
4. `maxHealth`
5. `phase`
6. `stateJson`
7. `defeatedAt`

---

## Event Types

### 1. Modifier Events

Wereldwijde modifiers die bestaande gameplay moeilijker of makkelijker maken.

Voorbeelden:

1. Meer politie op straat.
2. Meer invallen bij drugsproductie.
3. Extra crypto-volatiliteit.
4. Meer kans op politievoertuigen.

### 2. Competition Events

Spelers strijden om score binnen een tijdvenster.

Voorbeelden:

1. Steel de meeste auto's in 2 uur.
2. Produceer de meeste meth van kwaliteit X.
3. Smokkel het meeste volume naar land Y.
4. Pimp het hoogste aantal prostituees in 90 minuten.

### 3. Cooperative Events

De community werkt samen aan een globale doelstelling.

Voorbeelden:

1. Lever samen 500.000 gram drugs.
2. Schakel samen een politieheli uit.
3. Bereik 1.000 succesvolle voertuigstelen wereldwijd.

### 4. Boss / Assault Events

Spelers vallen een gedeelde target aan.

Voorbeelden:

1. Politie-eenheid met health bar.
2. Politieheli die warmte zoekt.
3. Special taskforce die tijdelijk crimes onderdrukt.

### 5. Composite Events

Meerdere onderdelen actief tegelijk.

Voorbeeld:

1. Meer politie op straat.
2. Lagere vehicle theft success chance.
3. Boss entity aanwezig.
4. Als boss verslagen wordt stopt de modifier vroegtijdig.

Dit type is belangrijk voor jouw idee dat spelers een event actief kunnen beeindigen.

---

## Integratie Met Bestaande Systemen

### Vehicles

Moet ondersteunen:

1. Event-only voertuigen.
2. Tijdelijke availability pools.
3. Theft difficulty modifiers.
4. Competition score op steals, type-specifiek of rarity-specifiek.
5. Rewards zoals full tuned legendary vehicle.

### Crimes

Moet ondersteunen:

1. Success chance modifiers.
2. Reward modifiers.
3. Increased police pressure.
4. Event objectives per crime type.

### Crypto

Moet ondersteunen:

1. Tijdelijke volatility modifiers.
2. Special coins of market spikes.
3. Competitive profit/loss leaderboards.

### Drugs

Moet ondersteunen:

1. Productiequota op type en kwaliteit.
2. Extra raid chance.
3. Scanner/heli mechanics.
4. Delivery or stockpile goals.

### Smuggling

Moet ondersteunen:

1. Destination-specific events.
2. Cargo-type specific targets.
3. Bonus payouts.
4. Route risk modifiers.

### Prostitution

Moet ondersteunen:

1. Tijdelijke pimp quotas.
2. District/event combinations.
3. Per-player rankings.
4. VIP/event overlap rules.

### Combat / Weapons / Ammo

Nodig voor interactieve events.

Moet ondersteunen:

1. Damage contribution tracking.
2. Ammo usage against event targets.
3. Weapon restrictions of bonuses.
4. Shared health bars.

---

## Reward System

Rewards moeten niet hardcoded in services zitten, maar configureerbaar zijn.

Ondersteunde reward types:

1. Geld.
2. XP.
3. Respect/reputation.
4. Drugs.
5. Ammo.
6. Tools.
7. Weapons.
8. Vehicle reward.
9. Tuned vehicle reward.
10. Crypto reward.
11. Temporary booster.
12. Cosmetic badge/title.

### Voor voertuigrewards

Admin moet kunnen instellen:

1. Exact voertuig.
2. Condition.
3. Fuel.
4. Tuning stats.
5. Locked/unlocked state.

### Voor drugsrewards

Admin moet kunnen instellen:

1. Drug type.
2. Quantity.
3. Quality/purity.
4. Destination or tagged source indien relevant.

### Voor ranglijstrewards

Admin moet kunnen instellen:

1. Top 1.
2. Top 2.
3. Top 3.
4. Top 10.
5. Participation rewards.
6. Threshold rewards.

### Belangrijke regel

Rewards moeten altijd via een server-side fulfillment service worden toegekend met audit logging en idempotency, zodat dubbel claimen of mislukte uitbetaling veilig afgehandeld wordt.

---

## Speler UX

### Dashboard

Voeg een dedicated event-blok toe op dashboard.

Toon:

1. Hoogste prioriteit actieve event.
2. Timer.
3. Korte omschrijving.
4. CTA knop: bekijken / meedoen.
5. Event reward teaser.

### Global Event Banner

Gebruik een banner voor high-priority events.

Voorbeelden:

1. Meer politie op straat.
2. Politieheli actief.
3. Community boss event.

### Nieuwe Events Pagina

Maak een aparte pagina met tabs:

1. Actief.
2. Aankomend.
3. Mijn progress.
4. Leaderboards.
5. Beloningen.
6. Event historie.

### Event Detail Pagina

Toon:

1. Uitleg van event.
2. Eindtijd.
3. Regels.
4. Jouw progress.
5. Globale progress.
6. Leaderboard.
7. Prijzen.
8. Relevante CTA naar gekoppeld systeem.

Voorbeeld:

Bij een smuggling event direct een knop naar smuggling screen.

### Inline Context Banners

In relevante schermen zoals garage, marina, drugs, crypto, prostitution en crimes een compacte event banner tonen als een actief event dat systeem raakt.

---

## Admin UX

De admin-app moet een volledig event-beheer tab krijgen.

### Event Templates Tab

Admin kan:

1. Template aanmaken.
2. Titles en descriptions per taal beheren.
3. Eventtype kiezen.
4. Config schema invullen.
5. Previewen.

### Live Events Tab

Admin kan:

1. Event handmatig starten.
2. Pauzeren.
3. Hervatten.
4. Stoppen.
5. Duur aanpassen.
6. Communicatie/banners aanpassen.

### Scheduling Tab

Admin kan:

1. Intervallen aanpassen.
2. Actieve vensters aanpassen.
3. Cron schema's beheren.
4. Cooldowns tussen events instellen.
5. Priority en exclusiviteit instellen.

### Rewards Builder

Admin kan reward rules declaratief samenstellen.

Bijvoorbeeld:

1. Top 1 krijgt voertuig X met tuning Y.
2. Top 2 krijgt 10.000 gram coke kwaliteit A.
3. Top 3 krijgt geld + ammo.
4. Alle deelnemers boven score Z krijgen booster.

### Leaderboard Controls

Admin kan:

1. Ranking metric kiezen.
2. Tie-breaker instellen.
3. Visibility bepalen.
4. Crew of player rankings kiezen.

### Audit & Safety

Elke admin-actie loggen:

1. Wie wijzigde wat.
2. Oude en nieuwe config.
3. Wanneer rewards zijn uitgekeerd.
4. Event lifecycle transitions.

---

## Multi-Language Regels

Alles wat spelers zien moet via i18n of vertaalbare databasevelden lopen.

### Verplicht tweetalig

1. Event title.
2. Short description.
3. Long description.
4. Objective text.
5. Reward text.
6. Banner copy.
7. Admin preview texts.

### Niet opslaan als rauwe spelertekst in business logic

Business logic gebruikt:

1. `eventKey`
2. `templateKey`
3. `objectiveKey`
4. `rewardDescriptor`

UI vertaalt dat met locale-aware rendering.

---

## Protocol Koppelingen

Deze file is de hoofd-specificatie voor het event-platform.

Bij implementatie moeten ook domeinprotocollen worden bijgewerkt waar events in inhaken, minimaal:

1. Vehicle theft / garage / marina flows.
2. Crime balancing rules.
3. Drug production and raid rules.
4. Smuggling progression and rewards.
5. Prostitution and VIP event overlap.
6. Dashboard UX rules.
7. Admin operational protocol.

---

## Premium / In-App Aankopen

Event-gerelateerde aankopen zijn mogelijk, maar moeten fair en begrensd zijn.

Goede premium categorieen:

1. Extra event reward claim slot.
2. Korte persoonlijke cooldown reduction binnen caps.
3. Kleine participation boost.
4. Extra event notification slot.
5. Extra leaderboard history panel.

Voorzichtig mee omgaan:

1. Geen directe pay-to-win top ranking without cap.
2. Geen premium-only eindbaas damage multipliers zonder tegengewicht.
3. Geen premium rewards die competitieve events volledig scheef trekken.

Aanbevolen model:

1. Premium boosts zijn tijdelijk.
2. Premium boosts hebben harde caps.
3. Event leaderboards kunnen aparte `boosted` en `base` metrics bijhouden indien nodig.

---

## Aanvullende Verbeterideeën

### 1. Event Affixes

Voeg affixes toe die random varianten maken zonder nieuwe code per event.

Voorbeelden:

1. `double_rewards`
2. `high_risk`
3. `country_locked`
4. `legendary_only`
5. `crew_enabled`

### 2. Chain Events

Een event kan een volgend event triggeren.

Voorbeeld:

1. Politie intensifieert controles.
2. Politieheli verschijnt.
3. Spelers vallen heli aan.
4. Bij winst start bonus-loot event.

### 3. Community Milestones

Tijdens een live event extra drempels tonen.

Voorbeelden:

1. Bij 25 procent unlockt bonus.
2. Bij 50 procent extra reward pool.
3. Bij 100 procent community crate.

### 4. Spectator / Feed Layer

Belangrijke events mogen zichtbaar zijn in wereldfeed met samenvattingen.

Voorbeelden:

1. `event.started`
2. `event.milestone_reached`
3. `event.boss_damaged`
4. `event.completed`
5. `event.reward_granted`

### 5. Anti-Abuse Controls

Nodig voor competitive events.

1. Rate checks.
2. Fraud scoring.
3. Suspicious contribution logs.
4. Reward hold until validation for extreme outliers.

---

## Technische Aanpak

### Niet doen

1. Nog meer losse event logic in bestaande services hardcoden.
2. Event copy direct in backend responses schrijven.
3. Rewards rechtstreeks vanuit UI triggeren.

### Wel doen

1. Event engine service bouwen.
2. Event modifiers via adapters op domeinservices toepassen.
3. Event page en dashboard widgets bouwen op centrale event API.
4. Admin event management via dedicated endpoints en forms.

---

## Gefaseerde Implementatie

### Phase 1

Fundament leggen.

1. Prisma modellen voor templates, schedules, live events, progress, rewards.
2. Event engine service.
3. Admin CRUD voor templates en live events.
4. Player API voor actieve/aankomende events.
5. Dashboard banner en events pagina skeleton.

### Phase 2

Huidige events migreren.

1. Police vehicle event migreren naar template + schedule.
2. Crypto event gedrag migreren naar centrale engine.
3. Bestaande hardcoded banners vervangen door generieke event UI.

### Phase 3

Competition events.

1. Vehicle theft leaderboard event.
2. Drug production target event.
3. Smuggling destination event.
4. Prostitution quota event.

### Phase 4

Interactive events.

1. High police presence modifier.
2. Police assault target with health bar.
3. Police helicopter hunt.

### Phase 5

Premium and advanced ops.

1. Event boosters.
2. Community milestones.
3. Chain/composite events.
4. Advanced admin preview and simulations.

---

## Eerste Concrete Implementatievolgorde

De beste eerste slice is:

1. `EventTemplate`
2. `EventSchedule`
3. `LiveEvent`
4. `EventParticipantProgress`
5. `EventRewardRule`
6. centrale player API `/game-events`
7. admin tab voor templates + live events
8. dashboard banner + events overview page
9. migratie van police vehicle event naar nieuwe engine

Dat is klein genoeg om beheersbaar te blijven en groot genoeg om daarna alle andere events op hetzelfde framework te laten landen.

---

## Definitieve Richting

Ja, het event-systeem moet een eigen subsystem worden met:

1. centrale event engine
2. aparte events pagina
3. dashboard banner/summary
4. admin beheer
5. multi-language content
6. configureerbare rewards
7. leaderboards
8. support voor modifier, competition, boss en composite events

Alle nieuwe events moeten vanaf nu in dit systeem ontworpen worden in plaats van als losse one-off logica.