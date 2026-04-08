# Mafia Game - Gameplay Handleiding

## 📋 Inhoudsopgave
- [Basis Mechanics](#basis-mechanics)
- [Crime Systeem](#crime-systeem)
- [Wanted Level & Politie](#wanted-level--politie)
- [FBI & Federal Crimes](#fbi--federal-crimes)
- [Health & Hospital Systeem](#health--hospital-systeem)
- [Jobs Systeem](#jobs-systeem)
- [Properties](#properties)
- [Crews & Heists](#crews--heists)
- [Bank Systeem](#bank-systeem)
- [Travel & Countries](#travel--countries)
- [Trade Market](#trade-market)
- [Aviation](#aviation)
- [Casino](#casino)
- [Weapons & Ammo](#weapons--ammo)

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
  - Reward: €50-€200
  - XP: 10
  - Jail time bij arrest: 5 minuten

- **Winkeldiefstal** (Shoplift)
  - Success chance: 65%
  - Reward: €100-€300
  - XP: 15
  - Jail time bij arrest: 10 minuten

#### Medium Crimes (Level 5-10)
- **Inbraak** (Burglary)
  - Success chance: 55%
  - Reward: €300-€800
  - XP: 25
  - Jail time bij arrest: 15 minuten
  - Vehicle required: Nee

- **Auto Diefstal** (Car Theft)
  - Success chance: 50%
  - Reward: €500-€1,500
  - XP: 30
  - Jail time bij arrest: 20 minuten
  - Vehicle required: Ja
  - Breakdown chance: 15%

#### Advanced Crimes (Level 15+)
- **Gewapende Overval** (Armed Robbery)
  - Success chance: 45%
  - Reward: €1,000-€3,000
  - XP: 40
  - Jail time bij arrest: 30 minuten
  - Vehicle required: Ja

- **Bank Robbery**
  - Success chance: 30%
  - Reward: €5,000-€15,000
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
bail = wantedLevel * €1,000

Voorbeelden:
- Wanted level 5: €5,000 bail
- Wanted level 10: €10,000 bail
```

### Politie Bribe
- **Cost**: €500-€2,000 (afhankelijk van wanted level)
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
  - Helper €500-€2,000 reward
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
- **Federal bail**: fbiHeat * €5,000

### Witness Protection (FBI Deal)
- **Beschikbaar bij**: FBI Heat > 20
- **Kosten**: €10,000-€50,000
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
- **Death**: Bij 0 HP → Intensive Care (ICU)

### Hospital Behandeling

#### Normale Behandeling
- **Kosten**: €10,000
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
4. **Paid Treatment**: €10k voor +30 HP (1x per uur)
5. **Vermijd ICU**: 3 uur lockout is lang!

---

## Jobs Systeem

### Job Types
- **Warehouse Worker**: €100-€300/shift, XP: 5
- **Delivery Driver**: €200-€500/shift, XP: 10
- **Security Guard**: €300-€700/shift, XP: 15
- **Accountant**: €500-€1,200/shift, XP: 25
- **Manager**: €800-€2,000/shift, XP: 40

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
- **Garage**: €50,000 - Income: €100/tick
- **Small Apartment**: €75,000 - Income: €150/tick
- **Store**: €100,000 - Income: €200/tick

#### Mid-Range Properties
- **Large Apartment**: €250,000 - Income: €500/tick
- **Restaurant**: €400,000 - Income: €800/tick
- **Warehouse**: €600,000 - Income: €1,200/tick

#### High-End Properties
- **Office Building**: €1,000,000 - Income: €2,500/tick
- **Nightclub**: €1,500,000 - Income: €4,000/tick
- **Casino**: €3,000,000 - Income: €8,000/tick
- **Mansion**: €5,000,000 - Income: €15,000/tick

### Property Mechanics
- **Income**: Elke tick (5 minuten) krijg je income
- **Ownership**: Onbeperkt aantal properties
- **Investment**: Passief inkomen systeem
- **ROI**: Verschillende return on investment per property

### Property Liquidation
- **Sell price**: 70% van aankoopprijs
- **Example**: Casino kopen €3M → verkopen €2.1M
- **No cooldown**: Direct verkopen mogelijk

---

## Crews & Heists

### Crew System

#### Crew Creation
- **Cost**: €10,000
- **Max members**: 10 spelers
- **Leader permissions**: 
  - Invite/kick members
  - Start heists
  - Disband crew

#### Crew Benefits
- **Heists**: Toegang tot grote heists
- **Shared rewards**: Verdeeld tussen crew members
- **Teamwork bonus**: +10% success chance per extra member (max +30%)

### Heists

#### Small Bank Heist
- **Required crew size**: 2 spelers
- **Base success**: 40%
- **Potential reward**: €10,000-€30,000
- **XP**: 100 per speler
- **Cooldown**: 30 minuten

#### Jewelry Store Heist
- **Required crew size**: 3 spelers
- **Base success**: 35%
- **Potential reward**: €20,000-€50,000
- **XP**: 150 per speler
- **Cooldown**: 45 minuten

#### Casino Heist
- **Required crew size**: 4 spelers
- **Base success**: 25%
- **Potential reward**: €50,000-€150,000
- **XP**: 300 per speler
- **Cooldown**: 2 uur

#### Federal Reserve Heist
- **Required crew size**: 5 spelers
- **Base success**: 15%
- **Potential reward**: €100,000-€500,000
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

## Bank Systeem

### Bank Account
- **Opening**: Gratis, automatisch beschikbaar
- **Maximum balance**: Onbeperkt
- **Interest rate**: 0.5% per tick (5 minuten)
- **Compounding**: Elke tick wordt rente toegevoegd

### Transacties

#### Deposit (Storten)
- **Minimum**: €1
- **Maximum**: Je huidige cash
- **Fee**: Geen kosten
- **Instant**: Direct verwerkt

#### Withdraw (Opnemen)
- **Minimum**: €1
- **Maximum**: Je bank balance
- **Fee**: Geen kosten
- **Instant**: Direct verwerkt

### Interest Berekening
```
interest = balance * 0.005 (0.5%)

Per tick: €10,000 → €50 rente
Per uur (12 ticks): €10,000 → €600 rente
Per dag (288 ticks): €10,000 → €14,400 rente
```

### Bank Robbery (Crime)
- **Target**: Random andere speler met > €10,000
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
- **Neighboring countries**: €500-€2,000
- **Europe → Americas**: €5,000-€10,000
- **Long distance**: €10,000-€20,000

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
- **Price**: Base price × market fluctuation
- **Quantity**: Onbeperkt (als je geld hebt)
- **Inventory**: Opgeslagen in je inventory
- **Location locked**: Kan alleen kopen in specifiek land

#### Selling
- **Price**: Base price × market fluctuation
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
- **Bribe option**: €1,000-€5,000
- **If caught**: 50% goods loss

---

## Aviation

### Aircraft Types

#### Small Plane
- **Cost**: €100,000
- **Capacity**: 2 passengers
- **Range**: 1,000 km
- **Speed**: Fast travel (instant)

#### Private Jet
- **Cost**: €500,000
- **Capacity**: 8 passengers
- **Range**: 5,000 km
- **Speed**: Very fast (instant)
- **Luxury bonus**: +10% trade profits

#### Cargo Plane
- **Cost**: €1,000,000
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

### Games Available

#### Blackjack
- **Bet range**: €100-€10,000
- **House edge**: ~1% (with perfect play)
- **Rules**: Standard blackjack
- **Dealer stands**: Soft 17

#### Slots
- **Bet range**: €10-€1,000
- **Jackpot**: Progressive (starts €10,000)
- **Payout**: 75-95% RTP
- **Bonuses**: Free spins mogelijk

#### Roulette
- **Bet range**: €50-€5,000
- **Bet types**: 
  - Single number (35:1)
  - Red/Black (1:1)
  - Dozen (2:1)
  - Column (2:1)

### Casino Limits
- **Maximum win per session**: €100,000
- **Maximum loss per session**: Je totale geld
- **Cooldown**: Geen cooldown
- **Cheating detection**: Banned bij verdachte patronen

---

## Weapons & Ammo

### Weapon Types

#### Pistol
- **Cost**: €500
- **Ammo capacity**: 15 rounds
- **Damage**: Low
- **Crime bonus**: +5% armed robbery success

#### Shotgun
- **Cost**: €1,500
- **Ammo capacity**: 8 rounds
- **Damage**: High
- **Crime bonus**: +10% bank robbery success

#### Rifle
- **Cost**: €3,000
- **Ammo capacity**: 30 rounds
- **Damage**: Very high
- **Crime bonus**: +15% heist success

### Ammo System
- **Pistol ammo**: €10 per round
- **Shotgun ammo**: €25 per round
- **Rifle ammo**: €50 per round
- **Auto-consume**: Gebruikt tijdens gewapende crimes
- **Restock**: Kopen bij weapon shop

---

## Tips & Strategies

### Beginner Strategy
1. **Start met jobs**: Verdien eerste €10,000 safe
2. **Koop garage**: Eerste property voor passief inkomen
3. **Low-level crimes**: Pickpocket/shoplift voor XP
4. **Monitor health**: Gebruik emergency room bij < 10 HP
5. **Avoid jail**: Laag wanted level houden

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
1. ❌ **Alle geld cash houden**: Bank rente is gratis geld
2. ❌ **Health negeren**: ICU kost 3 uur lockout
3. ❌ **Te hoog wanted level**: 90% arrest chance bij 18+
4. ❌ **Geen cooldowns checken**: Verspilde clicks
5. ❌ **Solo high-level heists**: Crew needed voor succes

---

## Formules & Berekeningen

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
bail = wantedLevel * €1,000

// FBI bail
bail = fbiHeat * €5,000
```

### Bank Interest
```javascript
// Per tick (5 min)
interest = balance * 0.005

// Annual rate (equivalent)
annual_rate ≈ 500% (compounding every 5 min)
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
- **Jobs**: €1,200-€6,000/uur (safe)
- **Low crimes**: €3,000-€10,000/uur (medium risk)
- **High crimes**: €20,000-€100,000/uur (high risk)
- **Properties**: €500-€50,000/uur (passive)
- **Bank interest**: Variabel (compound growth)
- **Heists**: €50,000-€500,000 (high risk, cooldown)
- **Trade**: €10,000-€200,000 (moderate risk)

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
- ✅ Crime system with health damage
- ✅ Wanted level & police arrests
- ✅ FBI heat system
- ✅ Health, hunger, thirst mechanics
- ✅ Hospital with emergency room
- ✅ Intensive Care (ICU) system
- ✅ Jobs system
- ✅ Properties & passive income
- ✅ Crews & heists
- ✅ Bank accounts with interest
- ✅ International travel
- ✅ Trade market with risks
- ✅ Aviation system
- ✅ Casino (blackjack, slots, roulette)
- ✅ Weapons & ammo system

### Planned Features
- ⏳ Court & Judge system
- ⏳ Gang wars
- ⏳ Drug production facilities
- ⏳ Money laundering
- ⏳ Stock market
- ⏳ Real estate development

---

## Support & Community

Voor vragen, bugs, of suggesties:
- GitHub Issues: [Link]
- Discord: [Link]
- Wiki: [Link]

**Laatst bijgewerkt**: 30 januari 2026
