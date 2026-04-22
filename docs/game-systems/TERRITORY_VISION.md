# Territory Vision

## Doel

Deze visie beschrijft de "beste versie" van Territory voor deze game: niet alleen een losse map-control loop, maar een kernsysteem dat Crew, Crew Wars, Dashboard, Travel en Crew HQ zichtbaar met elkaar verbindt.

Deze file is een ontwerpdocument, geen live featurecontract. Implementatie-details en harde guardrails blijven in:
- `docs/module-protocols/territory.md`
- `docs/module-protocols/crew-wars.md`
- `docs/module-protocols/crew.md`
- `docs/module-protocols/PROTOCOL_MASTER.md`

## Huidige Basis

Wat al live aanwezig is:
- Territory heeft echte regio's, multi-country maps, ownership, contests, seasons, anti-abuse en passieve crew-income.
- Territory is al gekoppeld aan Crew membership, Crew economy, Travel, Dashboard, Notifications en Admin.
- Crew Wars gebruikt al echte Territory-regio's als war targets voor `territory_war` en `total_war`.
- Crew leaders zien al territory economy samenvattingen in dashboard-statistieken.

Wat nog grotendeels ontbreekt:
- strategisch verschillende regio-identiteiten
- diepe koppeling tussen Crew HQ progression en Territory power
- echte nasleep tussen Crew Wars en Territory control
- langdurige regionale investeringen, sabotage en map-meta

## North Star

De gewenste eindstaat is:
- Territory is de persistente geopolitieke laag van de game.
- Crew Wars is de tijdelijke conflictlaag bovenop die map.
- Crew HQ bepaalt hoe goed een crew territorium kan organiseren, verdedigen en uitbuiten.
- Dashboard toont niet alleen bezit, maar ook spanning, dreiging en momentum.

Kort samengevat:
- Territory bepaalt wat waardevol is.
- Crew Wars bepaalt waar de escalatie zit.
- Crew HQ bepaalt hoeveel controle en logistiek een crew echt aankan.

## Design Pijlers

### 1. Regio's moeten verschillend voelen

Elke regio hoort meer te zijn dan alleen een income-tier.

Aanbevolen uitbreiding:
- `strategicTags` echt gameplay-relevant maken
- regio-types zoals `harbor`, `capital`, `industry`, `border`, `airhub`
- per type een herkenbare gameplayfunctie

Voorbeelden:
- `harbor`: bonus op smuggling, marina- of transportflows
- `capital`: hogere season prestige of leaderboard weight
- `industry`: hogere crew bank income of snellere territory project build speed
- `border`: snellere contest prep of lagere sabotage-cost
- `airhub`: travel- of aviation-gerelateerde intel bonus

Resultaat:
- crews vechten dan niet alleen voor "meer regio's", maar voor specifieke strategische assets.

### 2. Map control moet netwerkwaarde hebben

Ownership van losse regio's is minder interessant dan ownership van een samenhangend gebied.

Aanbevolen uitbreiding:
- adjacency en supply lines als echte mechanic
- bonus voor aaneengesloten clusters
- penalty voor geïsoleerde pockets
- frontline-regio's extra contest pressure

Voorbeelden:
- aaneengesloten regio-keten geeft stability bonus
- geïsoleerde regio verliest sneller stability
- contest start krijgt bonus als aanvaller vanuit aangrenzende regio komt
- defense krijgt bonus als defender regionale meerderheid in hetzelfde land heeft

Resultaat:
- Territory wordt een leesbare strategiekaart in plaats van een lijst losse doelen.

### 3. Crew HQ moet Territory echt sturen

Crew HQ en storage/progression moeten niet los staan van map-control.

Aanbevolen koppelingen:
- HQ-level bepaalt max gelijktijdige Territory contests
- HQ-level bepaalt max aantal beheersbare regio's bovenop globale caps
- speciale crew buildings geven territory modifiers
- storage/logistics upgrades verkorten cooldowns of verbeteren recovery

Voorbeelden van nieuwe crew-territory projecten:
- `Intel Center`: lagere cooldown op `intel_scan` en betere contest visibility
- `Logistics Depot`: hogere daily action cap of lagere anti-farm penalty op legitieme teamplay
- `Safehouse Network`: snellere stability recovery in eigen regio's
- `Arms Cache`: beperkte bonus op `raid` of `defense`

Resultaat:
- Crew HQ voelt als operationeel commandocentrum in plaats van alleen crew-management scherm.

### 4. Crew Wars moet Territory kunnen verstoren, niet gratis overschrijven

Crew Wars en Territory moeten elkaar versterken zonder dat het ene systeem het andere plat slaat.

Ontwerpregel:
- Crew War winst mag Territory beïnvloeden, maar niet gratis permanente ownership geven.

Aanbevolen effecten van war-uitkomsten:
- `territory_war` winst geeft tijdelijke instability op gekoppelde regio's
- `total_war` winst geeft korte attack window bonus op gekoppelde war-targets
- verlies geeft tijdelijke defense- of morale-debuff op frontline-regio's
- war momentum vertaalt zich naar tijdelijke Territory modifiers, niet directe map rewrite

Voorbeelden:
- 12 uur `reduced_stability_recovery`
- 12 uur `faster_contest_prep`
- 1 dag `elevated_region_heat` waardoor regio vaker aangevallen wordt

Resultaat:
- Crew Wars voelt als echte escalatie van geopolitiek conflict, niet als los event-minigame.

### 5. Territory moet teamrollen stimuleren

Nu draait Territory vooral op algemene deelname. De betere versie geeft verschillende rollen waarde.

Aanbevolen teamrollen:
- scout: intel en reveal
- raider: aanvalspunten en sabotage
- defender: shield, patrol en stability boosts
- logistician: support runs en recovery buffs

Dat hoeft niet direct een nieuw klassensysteem te zijn. Het kan ook via:
- action-specialisatie
- daily caps per action family
- crew perks per roltype

Resultaat:
- crew-coördinatie wordt belangrijker dan alleen volume klikken.

## Beste Crew War Koppelingen

### War Theater

Elke `territory_war` kiest naast targets ook één hoofdregio als theater.

Dat theater bepaalt:
- war branding in UI
- hoofdmeldingen in dashboard/notifications
- waar tijdelijke war-nasleep na resolve landt

Waarom dit sterk is:
- spelers begrijpen dan direct waar de oorlog "om gaat".

### Territory Pressure During War

Tijdens actieve war:
- war-control op territory targets levert `territory_tick` punten op
- claimen in war verandert tijdelijk `war control`, niet meteen echte territory ownership
- na war-resolve wordt gekeken of de winnaar een tijdelijk follow-up voordeel krijgt in de echte territory contest-flow

Hiermee blijven de systemen gescheiden, maar logisch verbonden.

### War Outcome Effects

Aanbevolen post-war effecten:
- winnaar krijgt `siege momentum`
- verliezer krijgt `region fatigue`
- beide zijn tijdsgebonden en admin-auditbaar

Voorbeeldmatrix:
- `territory_war` win: +contest prep speed op theater-regio en aangrenzende regio's
- `total_war` loss: +stability decay op theater-regio's
- `economy_war` win: bonus op income denial of sabotage potency

### Shared Seasonal Recognition

Voeg combinatie-awards toe over Territory en Crew Wars:
- meest verdedigde regio
- gevaarlijkste frontline crew
- sterkste expansion crew
- beste territory defenders van het seizoen

Resultaat:
- Territory en Crew Wars worden samen zichtbaar op Dashboard en in season identity.

## Extra Territory Features Die Echt Waarde Toevoegen

### Territory Projects

Crew leaders investeren crew bank money in regio-specifieke projecten.

Mogelijke projecten:
- surveillance grid
- propaganda office
- smuggling route
- weapons cache
- emergency medics

Eigenschappen:
- duur
- build-time
- upkeep
- sabotageable
- zichtbaar in admin audit

### Regional Events

Maak de map dynamischer met regionale modifiers:
- havenstaking
- politie-offensief
- corrupt officials
- border crisis
- black-market boom

Eigenschappen:
- tijdelijk
- country- of region-scoped
- zichtbaar in Territory overview en Dashboard

### Frontline Alerts

Niet alleen push bij capture/loss, maar ook bij oplopende dreiging:
- regio onder hoge druk
- supply line doorbroken
- war theater geëscaleerd
- income regio is instabiel

### Public Map Drama

Dashboard kan publieke Territory spanning tonen:
- hottest contested regions
- recent captures
- crews on the rise
- current war theaters

Dat maakt Territory veel zichtbaarder buiten het eigen scherm.

## Data- en Systeemimpact

Onderstaande uitbreidingen zijn de meest logische backend-uitbreidingen.

### Territory tabellen

Waarschijnlijke nieuwe tabellen of uitbreidingen:
- `territory_region_projects`
- `territory_region_modifiers`
- `territory_supply_links` of adjacency-derived snapshots
- `territory_conflict_effects`
- uitbreidingen op `territory_regions` voor echte `strategicTags`

### Crew / Crew HQ

Waarschijnlijke koppelingen:
- HQ/project unlocks naar Territory capabilities
- crew building bonuses die territory runtime-config deels overriden binnen caps
- betere crew dashboard aggregaties voor frontline/income/heat

### Crew Wars

Waarschijnlijke metadata-uitbreidingen:
- `warTheaterRegionKey`
- `warAftermathEffect`
- `frontlinePressure`
- tijdelijke mapping van war outcome naar territory modifiers

## Rollout Volgorde

### Fase A: Lage complexiteit, hoge spelwaarde

1. `strategicTags` echt laten meetellen
2. Dashboard uitbreiden met frontline/hot region info
3. War theater introduceren in Crew Wars UI + metadata

### Fase B: Middelgrote systeemkoppeling

1. tijdelijke war-aftermath modifiers op Territory
2. adjacency/supply line bonuses
3. extra notifications voor frontline pressure

### Fase C: Diepe progression-koppeling

1. Crew HQ upgrades koppelen aan Territory caps/modifiers
2. territory projects per regio
3. sabotage en denial loops op projecten

### Fase D: Seizoen/meta-laag

1. gecombineerde territory + war seasonal awards
2. region event rotatie
3. public drama widgets op dashboard/home

## Aanbevolen Eerste Build

Als er maar één concrete uitbreiding gebouwd wordt, dan is dit de beste volgorde:

1. voeg echte `strategicTags` effecten toe
2. voeg `war theater` toe aan territory war / total war
3. voeg tijdelijke post-war territory modifiers toe

Waarom juist deze drie:
- ze bouwen direct voort op bestaande code
- ze maken beide systemen begrijpelijker
- ze voegen spanning toe zonder direct zware economy-herbouw

## Guardrails

Deze visie moet binnen de bestaande protocolregels blijven:
- Territory ownership blijft server-authoritative
- Crew War uitkomsten mogen geen gratis permanente ownership skip geven
- anti-abuse, audit trail en admin moderation blijven verplicht
- nieuwe player-facing copy moet NL/EN-pariteit houden
- Help & Uitleg moet pas mee worden aangepast zodra gedrag echt verandert

## Samenvatting

De beste versie van Territory is:
- een strategische map met echte regionale identiteit
- een persistente laag onder Crew Wars
- een logisch verlengstuk van Crew HQ progression
- een zichtbare bron van spanning, prestige en crew-economie

De kernverschuiving is:
- van "crew bezit regio's"
- naar "crew runt een geopolitiek netwerk met frontlines, logistiek, war theaters en HQ-gestuurde macht".