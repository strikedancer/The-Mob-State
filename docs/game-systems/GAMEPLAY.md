# Mafia Game - Gameplay Handleiding

## ðŸ“‹ Inhoudsopgave
- [Basis Mechanics](#basis-mechanics)
- [Crime Systeem](#crime-systeem)
- [Wanted Level & Politie](#wanted-level--politie)
- [FBI & Federal Crimes](#fbi--federal-crimes)
- [Health & Hospital Systeem](#health--hospital-systeem)
- [Jobs Systeem](#jobs-systeem)
- [Properties](#properties)
- [Crews & Heists](#crews--heists)
- [Crew Missions](#crew-missions)
- [Bank Systeem](#bank-systeem)
- [Travel & Countries](#travel--countries)
- [Territory](#territory)
- [Trade Market](#trade-market)
- [Aviation](#aviation)
- [Casino](#casino)
- [Weapons & Ammo](#weapons--ammo)
- [Hitlist & Moordslooptochten](#hitlist--moordslooptochten)
- [Security & Bescherming](#security--bescherming)
- [Premium & Credits](#premium--credits)

---

## Premium & Credits

- De Premium/Credits shop gebruikt alleen actieve backend-catalogusoffers.
- Legacy aanbiedingen met oude prijsstelling (zoals 1000 credits voor EUR 1.99) horen niet meer zichtbaar of afrekenbaar te zijn.

---

## Dashboard

- Het dashboard gebruikt een noir/gold game-stijl met duidelijke panelen voor navigatie, status en quick actions.
- Visual polish mag nooit ten koste gaan van leesbaarheid: statistieken, timers en actieknoppen moeten op mobiel/tablet/desktop direct scanbaar blijven.
- Dashboard-baseline bevat economy-overzicht (cash/bank/crypto/assets/net worth), 24u cashflowtrend, 7d activiteit, operations-timers en notificatie/risico-indicatoren.
- Nieuwe gameplaymodules of uitbreidingen met timers/rewards/notificaties moeten dashboard-coverage en helptekst in dezelfde wijziging meenemen.

### Live spelerevents

- Preset-terugkerende competitievensters (o.a. crime, drugs, smuggling, vehicles) worden door de server op een **interval** gepland; binnen het actieve venster telt je actie in die categorie mee voor de ranglijst; aan het eind volgen beloningen (o.a. cash, XP, kleine premium credits) volgens de regels in `docs/module-protocols/events.md`.
- In **Instellingen** kun je onder **Spelerevents** pushmeldingen bij start/einde van een ronde **per speler** aan- of uitzetten (standaard aan). In **Premium** bestaat optioneel **Event Pass (7 dagen)** (echt geld) voor +event-score en bonus credits, zonder directe combat pay-to-win.
- Volledig operator-/deploy-pad: `docs/module-protocols/PROTOCOL_MASTER.md` (verwijst naar `events.md`).
- Technische afspraak server↔DB voor live events (JSON in tekstkolommen): `docs/module-protocols/events.md` (sectie *Backend (Prisma) invariant*).

---

## School

- Op mobiel worden School-tracks en unlock-kaarten in auto-hoogte weergegeven zodat volledige kaartinhoud altijd zichtbaar blijft (geen afgekapt onderste deel).

---

## Hitlist Notificaties

- Wanneer iemand je op de moordlijst zet, hoort direct zowel een inbox-bericht als een pushmelding binnen te komen met bounty-bedrag en afzender.
- Arrest-/hulpmeldingen voor vrienden en crew gebruiken consistente authority-labels per taal (NL: `politie`, EN: `police`, plus `FBI` waar relevant).

---

## Reizen

- Bij een directe route (1 etappe) wordt de reis na de cooldown meteen als afgerond behandeld. De speler krijgt dan niet alsnog een extra stap met "Verder" of "Reis annuleren".
- Vliegen gebruikt een cooldown van 60 minuten per etappe. Deze cooldown kan tijdens een actieve timer met credits direct worden gereset.

---

## Basis Mechanics

### Speler Stats
- **Money**: Je huidige contant geld
- **Health**: Je gezondheid (0-100 HP)
- **Hunger**: Je honger level (0-100)
- **Thirst**: Je dorst level (0-100)
- **Rank**: Je ervaring rank
- **XP**: Experience points
- **Wanted Level**: Hoe graag de politie je wil pakken (0-100)
- **FBI Heat**: Federale aandacht level (0-100)
- **Current Country**: Land waar je je nu bevindt

### Tick Systeem
Elke **5 minuten** gebeurt er automatisch:
- **Hunger**: -2 punten
- **Thirst**: -3 punten
- **Passive Healing**: +5 HP (alleen als HP > 0 en < 100)
- **Death**: Als hunger of thirst 0 bereikt, ga je dood
- **FBI Heat Decay**: -1 punt per tick (alleen als FBI Heat < 10)
- **Bank Interest**: Rente wordt toegevoegd aan je bank account

### Drugs & prestaties (server)
- Prestaties die op drugproductie (o.a. aantal voltooide batches, hoeveelheid per type) zijn gebaseerd, worden door de server **verwerkt wanneer productie klaar is of wanneer je ophaalt** (incl. VIP auto-ophalen), zodat je ze niet pas krijgt door later een ander scherm (zoals nachtclub) te openen. Zie `docs/module-protocols/drugs.md`.

---

## Crime Systeem

### Hoe Crimes Werken
1. Selecteer een crime
2. Success chance wordt berekend op basis van:
   - Base success chance van de crime
   - Je rank level
   - Of je het vereiste vehicle hebt
3. Bij succes:
   - Ontvang reward money
   - Ontvang XP
   - **Health damage**: 5-15 HP per crime attempt
   - Wanted level stijgt met 1-2 punten
4. Bij falen:
   - Geen reward
   - Wel XP (verminderd)
   - **Health damage**: 5-15 HP
   - Wanted level stijgt met 2-4 punten
5. Na elke crime: arrest check door politie/FBI

### Crime Cooldowns
- **Pickpocket/Shoplift/Steal Bike**: 30 seconden
- **Burglary/Car Theft/Mugging**: 1 minuut
- **Armed Robbery/Drug Deal**: 2 minuten
- **Bank Robbery/Kidnapping**: 5 minuten
- **Heists**: Variabel (zie Heists sectie)

### Crime Balans (Sessie)
- Er geldt geen harde dagcap op crimes.
- Bij veel herhalingen in een kort sessieblok kan de uitbetaling per poging licht afnemen (soft diminishing returns).
- Cooldown blijft leidend; de loop blijft oneindig speelbaar.

### Wanted Level
- **Range**: 0-100
- **Increases bij**:
  - Crime success: +1 tot +2
  - Crime failure: +2 tot +4
  - FBI crimes: +3 tot +5
- **Decreases bij**:
  - Natural decay: -0.5 per 5 minuten (alleen < 10)
  - Politie bribe succesvol: -1 tot -5
  - Tijd in jail: Reset naar 0

### Crime Categories

#### Beginner Crimes (Level 1)
- **Zakkenrollen** (Pickpocket)
  - Success chance: 70%
  - Reward: â‚¬50-â‚¬200
  - XP: 10
  - Jail time bij arrest: 5 minuten

- **Winkeldiefstal** (Shoplift)
  - Success chance: 65%
  - Reward: â‚¬100-â‚¬300
  - XP: 15
  - Jail time bij arrest: 10 minuten

#### Medium Crimes (Level 5-10)
- **Inbraak** (Burglary)
  - Success chance: 55%
  - Reward: â‚¬300-â‚¬800
  - XP: 25
  - Jail time bij arrest: 15 minuten
  - Vehicle required: Nee

- **Auto Diefstal** (Car Theft)
  - Success chance: 50%
  - Reward: â‚¬500-â‚¬1,500
  - XP: 30
  - Jail time bij arrest: 20 minuten
  - Vehicle required: Ja
  - Breakdown chance: 15%

#### Advanced Crimes (Level 15+)
- **Gewapende Overval** (Armed Robbery)
  - Success chance: 45%
  - Reward: â‚¬1,000-â‚¬3,000
  - XP: 40
  - Jail time bij arrest: 30 minuten
  - Vehicle required: Ja

- **Bank Robbery**
  - Success chance: 30%
  - Reward: â‚¬5,000-â‚¬15,000
  - XP: 75
  - Jail time bij arrest: 60 minuten
  - Vehicle required: Ja
  - Breakdown chance: 25%

---

## Wanted Level & Politie

### Arrest Mechanics

#### Arrest Chance Formule
```
arrestChance = min((wantedLevel / policeRatio) * 100, 90%)
policeRatio = 20 (default config)

Voorbeeld:
- Wanted level 5: (5/20)*100 = 25% arrest chance
- Wanted level 10: (10/20)*100 = 50% arrest chance
- Wanted level 18+: 90% arrest chance (maximum)
```

#### Jail Time Berekening
```
jailTime = max(wantedLevel * 10, 5) minuten

Voorbeelden:
- Wanted level 1: 5 minuten (minimum)
- Wanted level 5: 50 minuten
- Wanted level 10: 100 minuten
```

#### Bail Amount
```
bail = wantedLevel * â‚¬1,000

Voorbeelden:
- Wanted level 5: â‚¬5,000 bail
- Wanted level 10: â‚¬10,000 bail
```

### Politie Bribe
- **Cost**: â‚¬500-â‚¬2,000 (afhankelijk van wanted level)
- **Success chance**: 40-60%
- **Bij succes**: 
  - Wanted level -1 tot -5
  - Geen arrest deze keer
- **Bij falen**:
  - Geld verloren
  - Arrest + extra jail time (10 minuten)

### Jail Escape
- **Wie kan helpen**: Andere spelers (niet in jail)
- **Success chance**: 30-50% (afhankelijk van helper rank)
- **Bij succes**: 
  - Target vrij
  - Helper â‚¬500-â‚¬2,000 reward
- **Bij falen**:
  - Helper gaat ook naar jail (30-60 minuten)
  - Target blijft in jail

---

## FBI & Federal Crimes

### FBI Heat System
- **Range**: 0-100
- **Activatie**: FBI wordt actief bij heat >= 50
- **Decay**: -1 per 5 minuten (alleen als < 10)

### Federal Arrest
- **Arrest chance**: min((fbiHeat / 30) * 100, 95%)
- **Federal jail time**: fbiHeat * 15 minuten
- **Federal bail**: fbiHeat * â‚¬5,000

### Witness Protection (FBI Deal)
- **Beschikbaar bij**: FBI Heat > 20
- **Kosten**: â‚¬10,000-â‚¬50,000
- **Effect**: 
  - FBI Heat volledig gereset
  - Wanted level -50%
  - Nieuwe identiteit (optioneel)

---

## Health & Hospital Systeem

### Health Mechanics
- **Maximum HP**: 100
- **Health damage**: 5-15 HP per crime
- **Passive healing**: +5 HP per 5 minuten (alleen als HP > 0)
- **Death**: Bij 0 HP â†’ Intensive Care (ICU)

### Hospital Behandeling

#### Normale Behandeling
- **Kosten**: â‚¬10,000
- **Healing**: +30 HP (max 100)
- **Cooldown**: 60 minuten
- **Beschikbaar**: Altijd (ook bij 0 HP)

#### Emergency Room (EHBO)
- **Kosten**: GRATIS
- **Healing**: +20 HP
- **Cooldown**: Geen
- **Beschikbaar**: Alleen als HP < 10

### Intensive Care (ICU)
- **Trigger**: Health bereikt 0 HP
- **Duur**: 180 minuten (3 uur)
- **Effect**: 
  - Alle acties geblokkeerd
  - Full-screen overlay met countdown timer
  - Automatisch vrijgelaten na 3 uur
  - Start met 10 HP na vrijlating
- **Info**: Je ligt bewusteloos, kan niks doen
- **Recovery**: Na 3 uur kan je direct emergency room gebruiken

### Health Management Tips
1. **Preventie**: Monitor je HP constant
2. **Emergency Room**: Gebruik gratis EHBO bij < 10 HP
3. **Passive Healing**: Wacht 5 minuten tussen crimes voor +5 HP
4. **Paid Treatment**: â‚¬10k voor +30 HP (1x per uur)
5. **Vermijd ICU**: 3 uur lockout is lang!

---

## Territory

### Territory Kaarten & Landregels
- Je kunt alle ondersteunde Territory-landen bekijken via de interactieve kaart, niet alleen Nederland.
- Elke regio toont ownership, stability, control en contestinformatie zodra je de regio opent.
- Nederlandse Territory-regio's hebben nu ook strategische rollen zoals haven, hoofdstad, industrie, grensregio of logistiek knooppunt. Die rol beÃ¯nvloedt welke contest-actions in dat gebied extra punten opleveren.
- Als jouw crew al aangrenzende regio's bezit, krijg je in contests extra buursteun. Daardoor zijn aangesloten gebieden makkelijker te verdedigen en waardevoller als samenhangend blok dan als losse eilanden.
- De regio-modal toont nu niet alleen payout en status, maar ook de strategische rol, het aantal aangrenzende eigen regio's en welke actiebonussen daar actief zijn.
- `Actiebonussen` in de Territory-modal gelden alleen voor contestpunten per actie (bijv. raid/patrol/defense) en niet voor de passieve â‚¬-uitbetaling van het gebied.
- De Territory-modal toont per actie ook de formule `basis + bonus = totaal contestpunten`, zodat de impact van actiebonussen direct zichtbaar is zonder verwarring met cash payout.
- Naast regio- en war-pressure bonussen kunnen Territory-actiebonussen nu ook komen uit crew progression: HQ global level, crew mission level en bijgebouwen (weapon/ammo/car/boat/drug storage).
- Contest-limieten voor tegelijk actieve aanvallen en max. gebieden per crew kunnen nu beperkt opschalen met HQ global level (server-authoritative runtime tuning).
- Geavanceerde Territory-acties kunnen per actietype een minimaal HQ-level vereisen; in de regio-modal zie je dit direct als `vereist HQ level X` voordat je klikt.
- Territory heeft standaard geen harde dagcap meer op acties (`TERRITORY_ACTION_DAILY_CAP = 0`); pacing blijft onder controle via cooldown + anti-farm.
- Territory-passive income kan nooit meer in de crew-bank storten dan de huidige cashopslag-capaciteit. Is de crew-bank vol, dan stopt Territory met bijschrijven tot er weer ruimte is.
- Na een gewonnen **Territory War** of **Total War** kunnen doelregio's tijdelijk **war pressure** krijgen. In de Territory-modal zie je dan extra oorlogsdruk, effectieve stabiliteit en hoe lang die tijdelijke nasleep nog actief blijft.
- **Belangrijke regel**: bekijken mag in elk land, maar aanvallen, verdedigen en andere Territory-contestacties werken alleen in het land waar je speler zich op dat moment echt bevindt.
- Voorbeeld: zit je in Nederland en open je de kaart van BelgiÃ«, dan kun je Belgische regio's wel inspecteren maar niet aanvallen of aan een Belgische contest meedoen totdat je eerst naar BelgiÃ« reist.
- Territory blijft crew-gebonden: zonder crew kun je geen neutrale of vijandige regio's aanvallen.
- Op mobiel ondersteunt de Territory-kaart pinch-zoom en pannen zodat kleine regio's bruikbaar blijven.

---

## Jobs Systeem

### Jobs Balans (Sessie)
- Er geldt geen harde dagcap op jobs.
- Bij veel herhalingen in een kort sessieblok kan de uitbetaling per job licht afnemen (soft diminishing returns).
- Hogere payout-jobs houden langere cooldowns dan lagere payout-jobs.

### Job Types
- **Warehouse Worker**: â‚¬100-â‚¬300/shift, XP: 5
- **Delivery Driver**: â‚¬200-â‚¬500/shift, XP: 10
- **Security Guard**: â‚¬300-â‚¬700/shift, XP: 15
- **Accountant**: â‚¬500-â‚¬1,200/shift, XP: 25
- **Manager**: â‚¬800-â‚¬2,000/shift, XP: 40

### Job Requirements
- **Health**: Minimum 10 HP
- **Hunger**: Minimum 20
- **Thirst**: Minimum 20
- **Not in Jail**: Geen active jail sentence
- **Not in ICU**: Niet op intensive care
- **Cooldown**: 10 minuten tussen jobs

### Job Success
- **Always succeeds** (100% success rate)
- Legal income (geen wanted level increase)
- Veilige manier om geld te verdienen
- Minder lucratief dan crimes

---

## Properties

### Property Types

#### Low-End Properties
- **Garage**: â‚¬50,000 - Income: â‚¬100/tick
- **Small Apartment**: â‚¬75,000 - Income: â‚¬150/tick
- **Store**: â‚¬100,000 - Income: â‚¬200/tick

#### Mid-Range Properties
- **Large Apartment**: â‚¬250,000 - Income: â‚¬500/tick
- **Restaurant**: â‚¬400,000 - Income: â‚¬800/tick
- **Warehouse**: â‚¬600,000 - Income: â‚¬1,200/tick

#### High-End Properties
- **Office Building**: â‚¬1,000,000 - Income: â‚¬2,500/tick
- **Nightclub**: â‚¬1,500,000 - Income: â‚¬4,000/tick
- **Casino**: â‚¬3,000,000 - Income: â‚¬8,000/tick
- **Mansion**: â‚¬5,000,000 - Income: â‚¬15,000/tick

### Property Mechanics
- **Income**: Elke tick (5 minuten) krijg je income
- **Ownership**: Onbeperkt aantal properties
- **Investment**: Passief inkomen systeem
- **ROI**: Verschillende return on investment per property

### Property Liquidation
- **Sell price**: 70% van aankoopprijs
- **Example**: Casino kopen â‚¬3M â†’ verkopen â‚¬2.1M
- **No cooldown**: Direct verkopen mogelijk

---

## Crews & Heists

### Crew System

#### Crew Creation
- **Cost**: â‚¬10,000
- **Max members**: 10 spelers
- **Leader permissions**: 
  - Invite/kick members
  - Start heists
  - Disband crew

#### Crew Benefits
- **Heists**: Toegang tot grote heists
- **Shared rewards**: Verdeeld tussen crew members
- **Teamwork bonus**: +10% success chance per extra member (max +30%)
- **HQ progression**: HQ-levels lopen door als globale reeks (L0 t/m L19) met oplopende upgradekosten zonder reset per stijltier. Als een stijltier op max staat en bijgebouwen voldoen aan de vereiste levels, gaat de volgende upgrade direct naar het volgende globale level.
- **HQ & Upgrades visuals**: bijgebouw-afbeeldingen volgen altijd de level-tier van het bijgebouw zelf (niet de actuele HQ-stijl), zodat visuals en levelstatus consistent blijven.

### Crew Wars
- Crew Wars lopen via de **War Room** in het crew-scherm. Alleen leaders kunnen een war declareren en beide crews hebben minimaal 3 leden nodig.
- **Territory War** en **Total War** gebruiken echte Territory-regio's als claimdoelen. Die war-doelen hebben nu ook strategische waarde: claimbonus, tick-punten en tags zoals haven, hoofdstad, industrie of logistiek.
- War-targets worden niet meer alleen gekozen op regio-waarde, maar ook op strategische tags en aangrenzende druk van aanvaller en verdediger. Daardoor ontstaan in Territory Wars logischere frontlinies.
- Een geclaimde war-regio levert tijdens de war periodieke `territory_tick` punten op. Strategisch sterkere regio's leveren meer tick-punten dan gewone gebieden.
- In de War Room zie je per war-regio nu direct wie het gebied houdt en hoeveel claim-/tick-waarde het doel heeft, zodat crews hun calls beter kunnen plannen.
- Wint een crew zo'n war, dan laat dat tijdelijk sporen na in echte Territory-regio's rond het front. Daardoor kan de winnaar kort druk doorzetten op die regio's zonder dat de onderliggende Territory-stabiliteit permanent kapot blijft.

### Heists

#### Small Bank Heist
- **Required crew size**: 2 spelers
- **Base success**: 40%
- **Potential reward**: â‚¬10,000-â‚¬30,000
- **XP**: 100 per speler
- **Cooldown**: 30 minuten

#### Jewelry Store Heist
- **Required crew size**: 3 spelers
- **Base success**: 35%
- **Potential reward**: â‚¬20,000-â‚¬50,000
- **XP**: 150 per speler
- **Cooldown**: 45 minuten

#### Casino Heist
- **Required crew size**: 4 spelers
- **Base success**: 25%
- **Potential reward**: â‚¬50,000-â‚¬150,000
- **XP**: 300 per speler
- **Cooldown**: 2 uur

#### Federal Reserve Heist
- **Required crew size**: 5 spelers
- **Base success**: 15%
- **Potential reward**: â‚¬100,000-â‚¬500,000
- **XP**: 500 per speler
- **Cooldown**: 6 uur
- **FBI Heat**: +20 bij poging

### Heist Mechanics
- **Preparation**: Leader start de heist
- **All members must be online**: Anders failure
- **Success calculation**: Base % + teamwork bonus - wanted level penalty
- **Failure consequences**: 
  - Jail time voor alle leden
  - Wanted level +5
  - Geen reward

---

## Crew Missions

### Overzicht
- Crew Missions zijn co-op operations voor crews met role-based teamwork.
- Er zijn 3 tiers (quick, coordinated, high-stakes) en geen harde dagcap.
- Progression blijft non-pay-to-win: credits kunnen alleen tijd versnellen, niet power of reward multipliers toevoegen.

### Phase 1
- Phase 1 bevat 6 missies met exacte timers, rewards, fail-risico en cooldown skip-pricing.
- Volledige specificatie: [CREW_MISSIONS_PHASE1_2026-04-23.md](CREW_MISSIONS_PHASE1_2026-04-23.md).

### Uitbreiding (bank-lijn + clearing house)
- Zes extra crew missions (geen tweede casino-missie naast **Casino Ledger Raid**): night deposit, skim-netwerk, pantserroute, dochterbank-kluis, reservekluis en clearing house settlement-run.
- Beloningen blijven uit de crew-mission economy (server); er wordt geen geld rechtstreeks uit andere spelers hun banksaldo gehaald.
- Catalogus en getallen: [CREW_MISSIONS_EXPANSION_2026-04-26.md](CREW_MISSIONS_EXPANSION_2026-04-26.md). Afbeeldingen: `backend/scripts/generate_crew_missions_images_leonardo.py` (Leonardo API).

### Crew Mission XP & Level
- Crew Missions geven naast persoonlijke XP ook **crew mission XP** aan de crew.
- Deze XP bouwt een **crew mission level** op (zichtbaar in de Crew Missions-tab).
- Hoger crew mission level geeft een kleine bonus op mission crew-cash rewards.
- Deze bonus is utility/progression en blijft bewust beperkt (geen direct pay-to-win gevechtsvoordeel).

### Credits skip logica (missions)
- Mission cooldown skip rekent op resterende tijd met tier-rate per minuut.
- Er wordt geen credits-kost berekend als er geen actieve cooldown is.
- Skip wijzigt nooit success chance of payout multiplier.

## Bank Systeem

### Bank Account
- **Opening**: Gratis, automatisch beschikbaar
- **Maximum balance**: Onbeperkt
- **Interest rate**: 0.5% per tick (5 minuten)
- **Compounding**: Elke tick wordt rente toegevoegd

### Transacties

#### Deposit (Storten)
- **Minimum**: â‚¬1
- **Maximum**: Je huidige cash
- **Fee**: Geen kosten
- **Instant**: Direct verwerkt

#### Withdraw (Opnemen)
- **Minimum**: â‚¬1
- **Maximum**: Je bank balance
- **Fee**: Geen kosten
- **Instant**: Direct verwerkt

### Interest Berekening
```
interest = balance * 0.005 (0.5%)

Per tick: â‚¬10,000 â†’ â‚¬50 rente
Per uur (12 ticks): â‚¬10,000 â†’ â‚¬600 rente
Per dag (288 ticks): â‚¬10,000 â†’ â‚¬14,400 rente
```

### Bank Robbery (Crime)
- **Target**: Random andere speler met > â‚¬10,000
- **Success chance**: 30%
- **Steal amount**: 10-30% van target balance
- **Consequences**: High wanted level increase
- **Cooldown**: 10 minuten

---

## Travel & Countries

### Available Countries
- **Netherlands** (Start land)
- **Belgium**
- **Germany**
- **France**
- **United Kingdom**
- **Spain**
- **Italy**
- **Switzerland**
- **USA**
- **Mexico**
- **Colombia**
- **Brazil**

### Travel Costs
- **Neighboring countries**: â‚¬500-â‚¬2,000
- **Europe â†’ Americas**: â‚¬5,000-â‚¬10,000
- **Long distance**: â‚¬10,000-â‚¬20,000

### Travel Requirements
- **Not in jail**: Kan niet reizen vanuit jail
- **Not in ICU**: Kan niet reizen tijdens intensive care
- **Sufficient money**: Reiskosten beschikbaar
- **Health**: Minimum 20 HP

### Country Benefits
- **Different crime rewards**: Sommige crimes meer waard
- **Trade opportunities**: Verschillende goods per land
- **Hiding from police**: Wanted level effect verminderd (toekomstig)

---

## Trade Market

### Tradable Goods
Elk land heeft unieke goods:
- **Diamonds** (Zuid-Afrika)
- **Drugs** (Colombia)
- **Weapons** (USA)
- **Art** (Frankrijk)
- **Electronics** (Japan)
- **Alcohol** (Schotland)

### Trade Mechanics

#### Buying
- **Price**: Base price Ã— market fluctuation
- **Quantity**: Onbeperkt (als je geld hebt)
- **Inventory**: Opgeslagen in je inventory
- **Location locked**: Kan alleen kopen in specifiek land

#### Selling
- **Price**: Base price Ã— market fluctuation
- **Location**: Verkopen in ander land dan kopen
- **Profit margins**: 20-300% mogelijk
- **Inventory**: Direct verkocht

### Market Fluctuation
- **Range**: 0.5x tot 2.0x base price
- **Changes**: Elke tick (5 minuten)
- **Risk**: Prijzen kunnen dalen tijdens reis

### Trade Risk Factors

#### Police Seizure
- **Chance**: Based on wanted level
- **Formula**: `min(wantedLevel * 2, 80)%`
- **Loss**: Alle goods geconfisceerd
- **Jail time**: +30 minuten

#### FBI Raid (International Trade)
- **Chance**: Based on FBI heat + goods value
- **Formula**: `min(fbiHeat + (value / 10000), 90)%`
- **Loss**: Alle goods + geld
- **Federal jail**: 60-180 minuten

#### Customs Inspection
- **Chance**: 10% base
- **Bribe option**: â‚¬1,000-â‚¬5,000
- **If caught**: 50% goods loss

---

## Aviation

### Aircraft Types

#### Small Plane
- **Cost**: â‚¬100,000
- **Capacity**: 2 passengers
- **Range**: 1,000 km
- **Speed**: Fast travel (instant)

#### Private Jet
- **Cost**: â‚¬500,000
- **Capacity**: 8 passengers
- **Range**: 5,000 km
- **Speed**: Very fast (instant)
- **Luxury bonus**: +10% trade profits

#### Cargo Plane
- **Cost**: â‚¬1,000,000
- **Capacity**: 50 passengers
- **Range**: 10,000 km
- **Trade bonus**: 2x inventory capacity

### Flight Mechanics
- **Ownership**: Permanently owned
- **Free travel**: Geen ticket kosten
- **Fuel**: Included (no separate cost)
- **Maintenance**: Automatisch

---

## Casino

- Casino-games openen binnen de bestaande game-content (dashboard shell) en niet als losse fullpage route buiten de hoofdlayout.
- Casino hub en closed state moeten mobiel/tablet/desktop een robuuste verticale scrollflow houden.
- Casino minigames moeten mobiel/tablet/desktop in Ã©Ã©n viewport speelbaar blijven: kernactie, inzet en status zichtbaar zonder verplichte verticale scroll.

### Games Available

#### Blackjack
- **Bet range**: â‚¬100-â‚¬10,000
- **House edge**: ~1% (with perfect play)
- **Rules**: Standard blackjack
- **Dealer stands**: Soft 17

#### Slots
- **Bet range**: â‚¬10-â‚¬1,000
- **Jackpot**: Progressive (starts â‚¬10,000)
- **Payout**: 75-95% RTP
- **Bonuses**: Free spins mogelijk

#### Roulette
- **Bet range**: â‚¬50-â‚¬5,000
- **Bet types**: 
  - Single number (35:1)
  - Red/Black (1:1)
  - Dozen (2:1)
  - Column (2:1)

### Casino Limits
- **Maximum win per session**: â‚¬100,000
- **Maximum loss per session**: Je totale geld
- **Cooldown**: Geen cooldown
- **Cheating detection**: Banned bij verdachte patronen

---

## Weapons & Ammo

### Weapon Types

#### Pistol
- **Cost**: â‚¬500
- **Ammo capacity**: 15 rounds
- **Damage**: Low
- **Crime bonus**: +5% armed robbery success

#### Shotgun
- **Cost**: â‚¬1,500
- **Ammo capacity**: 8 rounds
- **Damage**: High
- **Crime bonus**: +10% bank robbery success

#### Rifle
- **Cost**: â‚¬3,000
- **Ammo capacity**: 30 rounds
- **Damage**: Very high
- **Crime bonus**: +15% heist success

### Ammo System
- **Pistol ammo**: â‚¬10 per round
- **Shotgun ammo**: â‚¬25 per round
- **Rifle ammo**: â‚¬50 per round
- **Auto-consume**: Gebruikt tijdens gewapende crimes
- **Restock**: Kopen bij weapon shop

---

## Hitlist & Moordslooptochten

### Basismechanica

**Hit Plaatsen:**
- Betaal bounty (â‚¬50K - â‚¬50M)
- Geld wordt onmiddellijk afgetrokken
- Target is voortaan "HUNTED"
- Hit verschijnt op globale lijst

**Detective Inhuren:**
- Kosten: â‚¬25K (24h), â‚¬50K (6h), â‚¬100K (1h)
- Je leert target's land + regio
- Geldig 3 uur lang
- Kan niet twee tegelijk op zelfde target

**Murder Attempt:**
- Beide spelers moeten in hetzelfde land zijn
- Combat-based (weapon + ammo â†’ damage)
- Attacker Power vs Target Defense
- Winner krijgt bounty, loser krijgt -5 reputation

### Counter-Bounty System

Target kan **hoger bedrag** plaatsen:
- Minimaal: Original +â‚¬10K
- Effect: **Attacker en defender verwisselen rollen!**
- Originele plaatser is NU het doelwit
- Kan chain-escalate (bijv. â‚¬100K â†’ â‚¬200K â†’ â‚¬300K)

**Voorbeeld:**
```
Alice: â‚¬200K hit op Bob
Bob: â‚¬300K counter-hit

â†’ NU is Alice het doelwit (â‚¬300K bounty)
```

### Bounty Escalation

**Automatisch na 72 uur:**
- Bounty stijgt +5%
- Daarna +3% per dag
- Cap op 50% totaal
- Notification aan alle partijen

### Beschermingsopties

**Bodyguards (â‚¬10K/stuk)**
- +10 defense per bodyguard
- Verhoogt win chance

**Armor Types**
- Kevlar (â‚¬25K, +15 defense)
- Combat (â‚¬50K, +30 defense, duurtste)
- Tactical (â‚¬100K, +50 defense, rare)
- Slijtage: -5% per 24 uur

**Premium Protection (Betaalde Dienst - â‚¬4.99 voor 24 uur)**
- ENKEL MET ECHT GELD (niet in-game geld!)
- Volledige immuniteit tegen aanvallen
- Toon "PREMIUM PROTECTED" indicator in profiel
- Automatisch verval na 24h
- 7-dag cooldown tussen purchases
- 100% refund als niet gebruikt

**Hit Insurance (â‚¬200K/maand)**
- Auto-payout van bounty (jij sterft niet)
- Insurance betaalt attacker (ik overleef)
- Max 3 maanden vooruitbetaald

**Witness Protection (â‚¬300K voor 48h)**
- Verdwijn voor 48 uur
- Niet aanvalbaar
- Kan stilletjes geld verdienen
- Naam verdwijnt van hitlist

### Crew Hits

**Hoe werkt:**
- Crew A zet hit op Crew B (â‚¬500K - â‚¬50M)
- Target: Heel crew (alle members)
- Completion: 3+ members dood OF leader dood
- Bounty: Verdeeld onder killers

### Aanval Mislukking Penalties

**Attacker loses:**
- â‚¬25K herstelskosten
- -5 reputatie
- Target krijgt notification wie aanviel

**Gevolgen mislukking:**
- 24h cooldown voor volgende poging
- Reputatie negatief (spelers zien je als "schutter")

### Timing & Cooldowns
- **Attack cooldown**: 24h na fail
- **Same target cooldown**: 6h na success
- **Change country**: 2h (reistijd)
- **Max active hits**: 5 per speler

---

## Security & Bescherming

### Bodyguard System
- **Kosten**: â‚¬10,000 per bodyguard
- **Effect**: +10 defense per guard
- **Schaal**: Unlimited (maar DIM returns)
- **Maintenance**: Betaal maandelijks (automation)

### Armor

#### Kevlar Armor
- **Cost**: â‚¬25,000
- **Defense**: +15
- **Durability**: 100%
- **Wear rate**: -5% per 24h
- **Repair cost**: â‚¬5,000

#### Combat Armor
- **Cost**: â‚¬50,000
- **Defense**: +30
- **Durability**: 100%
- **Wear rate**: -5% per 24h
- **Repair cost**: â‚¬10,000

#### Tactical Armor
- **Cost**: â‚¬100,000
- **Defense**: +50
- **Durability**: 100%
- **Wear rate**: -7% per 24h (sneller slijt)
- **Repair cost**: â‚¬15,000

### Protection Modes

#### Safe House
- **Cost**: Gratis 1h, â‚¬10K/h daarna
- **Effect**: Veilig (niet aanvalbaar), maar can't do crimes
- **Max**: 6h per dag
- **Use case**: Hide when hunted + pasief geld verdienen

#### Premium Protection (Betaalde Dienst)
- **Cost**: â‚¬4.99 (ECHT GELD - betaalde dienst, niet in-game geld!)
- **Effect**: IMMUNE tegen ALLE aanvallen
- **Duration**: 24 uur
- **Cooldown**: 7 dagen tussen purchases
- **Refund**: 100% als < 1 minuut gebruikt
- **Use case**: Emergency escape bij critical hits

#### Hit Insurance
- **Cost**: â‚¬200,000/maand
- **Auto-payout**: Insurance betaalt bounty
- **Benefit**: Jij sterft niet, speler bevonden betaald
- **Claim**: Unlimited per maand
- **Use case**: Passive protection zonder timing

#### Witness Protection
- **Cost**: â‚¬300,000 voor 48h
- **Effect**: Verdwijn uit game (offline mode)
- **Activity**: Stillete money earn (jobs, properties)
- **Visibility**: Naam hidden, kunnen niet aangevallen
- **Use case**: Extreme situation (many hits active)

### Recommended Strategy

**Casual Player (Low Bounty Risk):**
- Bodyguards: 2-3 (â‚¬20K-â‚¬30K)
- Kevlar Armor: 1
- Safe House: When hunted

**Mid-Tier Player (Medium Bounty Risk):**
- Bodyguards: 5-10 (â‚¬50K-â‚¬100K)
- Combat Armor (â‚¬50K)
- Hit Insurance: â‚¬200K/month
- Premium Protection: When needed

**High-Stakes Player (Mega Bounty Risk):**
- Bodyguards: 20+ (â‚¬200K+)
- Tactical Armor (â‚¬100K)
- Hit Insurance + Witness Protection
- Premium Protection on standby

---

## Tips & Strategies

### Beginner Strategy
1. **Start met jobs**: Verdien eerste â‚¬10,000 safe
2. **Koop garage**: Eerste property voor passief inkomen
3. **Low-level crimes**: Pickpocket/shoplift voor XP
4. **Monitor health**: Gebruik emergency room bij < 10 HP
5. **Avoid jail**: Laag wanted level houden
6. **Stay off hitlist**: Don't mess with high-rank players early

### Mid-Game Strategy
1. **Properties**: Investeer in meerdere properties
2. **Bank account**: Stort geld voor rente
3. **Higher crimes**: Car theft, burglary
4. **Join crew**: Doe heists voor grote rewards
5. **Trade**: Koop cheap goods, verkoop duur

### Advanced Strategy
1. **Property empire**: Meerdere high-end properties
2. **International trade**: Buy low, sell high
3. **Aircraft**: Koop plane voor snelle trade routes
4. **Heist master**: Organize federal reserve heists
5. **Risk management**: Balance crimes vs jail time

### Avoid Deze Fouten
1. âŒ **Alle geld cash houden**: Bank rente is gratis geld
2. âŒ **Health negeren**: ICU kost 3 uur lockout
3. âŒ **Te hoog wanted level**: 90% arrest chance bij 18+
4. âŒ **Geen cooldowns checken**: Verspilde clicks
5. âŒ **Solo high-level heists**: Crew needed voor succes

---

## Formules & Berekeningen

## Premium & Credits

- Spelers hebben een aparte `Premium & Credits` pagina in het side menu; web/PWA checkouts horen daarna terug te landen in die ingesloten game-sectie.
- Dit scherm toont Player VIP, Crew VIP, creditbundels, je actuele creditsaldo en de actieve credit-items.
- Player VIP is persoonlijk. Crew VIP werkt alleen als je in een crew zit en ondersteunt crew-perks en VIP-gated upgrades.
- VIP- en credit-checkouts openen de betaalpagina en keren daarna terug naar `Premium & Credits` in de game-shell, zodat de speler direct de uitkomst, vernieuwde VIP-status en bijgewerkte credits ziet.
- Credit-items gebruiken wallet-credits in plaats van euro's. Admin beheert live welke items actief zijn, wat ze kosten en welk effecttype ze gebruiken.
- Mogelijke credit-effecten zijn onder meer cash bundles, hit protection, cooldown resets, event boosts en context-gebonden voertuigacties.
- VIP-prijzen en credit-kosten zijn runtime-config/admin-gestuurd en dus niet langer vaste clientwaarden.
- Cooldown reset-items gebruiken een dynamische prijs (`effectiveCreditCost`): hoe waardevoller de actie en hoe meer resterende cooldown, hoe hoger de credit-kost.
- Die dynamische prijs moet wel in balans blijven: korte cooldowns krijgen een lagere, niet-straffende credit-kost en langere/high-value acties schalen geleidelijk op.
- Cooldown reset-items zijn alleen inwisselbaar bij een actieve cooldown; zonder actieve timer blijft het item zichtbaar maar geblokkeerd.
- Player VIP geeft 10% kortere actie-timeouts/cooldowns op gameplay-actions; gevangenistijd (`jailRelease`) blijft ongewijzigd.
- Player VIP krijgt wekelijks 100 premium credits (ledger-traceerbaar via credit-transacties).
- Kill-reset met actieve Player VIP: contant geld reset naar â‚¬500.000, rank wordt gehalveerd, bank/crypto/opleidingen/achievements blijven behouden; assets, inventory en drugsvoorraad worden gewist.
- Kill-reset zonder actieve Player VIP: volledige progression reset naar baseline (incl. bank/crypto/opleidingen/achievements).
- Op ondersteunde timeout-schermen (crime, jobs, school, voertuig- en bootdiefstal) staat een directe `versnel met credits` knop, zodat spelers een actieve cooldown contextueel kunnen resetten zonder eerst naar `Premium & Credits` te navigeren.
- Voor school geldt: een credit-speedup reset alleen de cooldowntimer; XP wordt verdiend bij de trainingsactie zelf. Na reset start je direct een nieuwe training voor extra XP.
- Bij beschadigde voertuigen in Garage/Marina staat op de voertuigkaart een contextuele credits-knop voor instant repair; als reparatie nog niet loopt wordt die eerst gestart en meteen daarna afgerond.
- De instant-repair knop gebruikt een gecombineerd icoon (steeksleutel + bliksem) om de actie visueel duidelijk te maken zonder extra tekstdruk op de kaart.
- Tijdelijke premium boosts zijn bewust non pay-to-win en capped: kleine utility bonussen voor crime success/payout, hitlist attack/defense en event contribution, zonder event-reward tiers te overrulen.

### Vehicle Ops Expansion (2026-Q2)
- Vehicle Ops bevat nu naast hotspot/crew/chop ook:
  - Counter-Intercept missies (retaliatie op recente intercepts)
  - Crew Matchmaking met seizoensladder per voertuigtype
  - Country modifiers (inflatie/corruptie/havenstaking) die payout en risico dynamisch beïnvloeden
  - Contracts board met standard/high-risk contracts en weekly legendary contracts
  - Insurance claim review + dispute flow (contest met bonus of afwijzingsrisico)
- Alle flows blijven soft-capped via cooldown + risk loops (geen hard daily cap).
- Ops-telemetry is uitgebreid met vehicle-type en region map-layers voor admin balancing.
- Voertuigschermen respecteren actieve taalinstelling volledig: in NL-modus tonen opslabels en meldingen geen Engelse fallbackteksten.
- Ops-paneel toont live cooldown countdowns per actie en ververst deze automatisch.
- Cooldowns worden in Vehicle Ops enkel in de actiekaarten als primaire bron getoond om dubbele info en visuele ruis te vermijden.
- De gecombineerde Vehicle Heist-pagina gebruikt één primaire categorie-selector (Auto/Motor/Boot lane cards) en toont geen tweede redundante tab-rij met dezelfde categorieën.
- Per categoriekaart zijn quick actions voor stelen en opslag-upgrade direct beschikbaar.
- Per categoriekaart staat nu ook capaciteit per type (gebruikt/totaal + upgrade level) als primaire informatiebron.
- Gestolen voertuigen in embedded Garage/Marina renderen responsief als card-grid (mobiel 1 kolom, tablet/desktop meerdere kolommen).
- Embedded voertuigkaarten gebruiken natuurlijke hoogte (geen onnodige lege onderruimte door geforceerde hoge gridcellen).
- Op brede schermen schaalt het embedded overzicht door naar maximaal 4 kaarten naast elkaar.
- Kolommen schalen dynamisch op kaartbreedte, zodat 4 kaarten ook op laptopweergaves met zijpanelen haalbaar blijven.
- In deze Vehicle Heist-view is de aparte capaciteitsbalk boven de voertuigen verwijderd om dubbele informatie te voorkomen.
- Crew-only ops-acties (Crew Op/Crew Match) blijven verborgen of gelockt voor spelers zonder crew, met expliciete unlock-hint.
- Ops-beloningen worden bij succes direct als contant geld uitgekeerd; het actie-overzicht toont per knop de verwachte payout-context.
- Dashboard bevat nu een Vehicle Ops-blok per auto/motor/boot met live cooldownchips (Hotspot/Crew/Crew-duel/Chop/Contract/Tegenactie), heat/reputatie en contract/claim/seizoenssamenvatting.

### Arrest Chances
```javascript
// Police arrest
arrestChance = min((wantedLevel / 20) * 100, 90)

// FBI arrest  
arrestChance = min((fbiHeat / 30) * 100, 95)
```

### Jail Times
```javascript
// Police jail
jailTime = max(wantedLevel * 10, 5) minuten

// FBI jail
jailTime = fbiHeat * 15 minuten
```

### Bail Costs
```javascript
// Police bail
bail = wantedLevel * â‚¬1,000

// FBI bail
bail = fbiHeat * â‚¬5,000
```

### Bank Interest
```javascript
// Per tick (5 min)
interest = balance * 0.005

// Annual rate (equivalent)
annual_rate â‰ˆ 500% (compounding every 5 min)
```

### Crime Success
```javascript
baseChance = crime.baseSuccessChance
rankBonus = player.rank * 0.01
vehicleBonus = hasRequiredVehicle ? 0.1 : 0

finalChance = min(baseChance + rankBonus + vehicleBonus, 0.95)
```

### Health Damage
```javascript
// Per crime attempt
damage = random(5, 15) HP

// Passive healing per tick
healing = 5 HP (if health > 0 && health < 100)
```

---

## Game Balance

### Income Sources (per uur)
- **Jobs**: â‚¬1,200-â‚¬6,000/uur (safe)
- **Low crimes**: â‚¬3,000-â‚¬10,000/uur (medium risk)
- **High crimes**: â‚¬20,000-â‚¬100,000/uur (high risk)
- **Properties**: â‚¬500-â‚¬50,000/uur (passive)
- **Bank interest**: Variabel (compound growth)
- **Heists**: â‚¬50,000-â‚¬500,000 (high risk, cooldown)
- **Trade**: â‚¬10,000-â‚¬200,000 (moderate risk)

### Time Sinks
- **Jail time**: 5-180 minuten
- **ICU**: 180 minuten (3 uur)
- **Crime cooldowns**: 30 sec - 5 min
- **Job cooldowns**: 10 minuten
- **Heist cooldowns**: 30 min - 6 uur
- **Hospital cooldown**: 60 minuten

### Risk vs Reward
- **Laag risico**: Jobs, low-level crimes, properties
- **Medium risico**: Medium crimes, trade, small heists
- **Hoog risico**: Bank robbery, federal reserve, high-value trade

---

## Changelog & Updates

### Current Version Features
- âœ… Crime system with health damage
- âœ… Wanted level & police arrests
- âœ… FBI heat system
- âœ… Health, hunger, thirst mechanics
- âœ… Hospital with emergency room
- âœ… Intensive Care (ICU) system
- âœ… Jobs system
- âœ… Properties & passive income
- âœ… Crews & heists
- âœ… Bank accounts with interest
- âœ… International travel
- âœ… Trade market with risks
- âœ… Aviation system
- âœ… Casino (blackjack, slots, roulette)
- âœ… Weapons & ammo system
- âœ… VIP quick-buy in Drug Production (one-click missing materials with cost confirmation modal)

### Planned Features
- â³ Court & Judge system
- â³ Gang wars
- â³ Drug production facilities
- â³ Money laundering
- â³ Stock market
- â³ Real estate development

---

## Support & Community

Voor vragen, bugs, of suggesties:
- GitHub Issues: [Link]
- Discord: [Link]
- Wiki: [Link]

**Laatst bijgewerkt**: 30 januari 2026

