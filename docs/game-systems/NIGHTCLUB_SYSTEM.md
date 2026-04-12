# 🎉 NIGHTCLUB DRUG SALES SYSTEM - COMPLETE DOCUMENTATION

## OVERVIEW

Het nachtclub drugsverkoopsysteem is een diepgaande economische mechanica waar spelers:
- **Drugs opslaan** in hun nachtclub vanuit persoonlijke inventaris
- **Automatische verkoop** aan random bezoekers gebaseerd op drukteniveau + vraag
- **DJ's huren** voor ambiance boost en crowd aantrekking
- **Beveiliging huren** per nachtschift voor diefstalpreventie
- **Thefts/robberies** riskeren gebaseerd op veiligheid + druk
- **Events organiseren** voor speciale occasions en boost

---

## ARCHITECTURE

### Database Schema

```prisma
NightclubVenue          - Central hub per nightclub
├── NightclubDJ         - DJ Database (10 initialized)
├── NightclubDJShift    - DJ shift bookings
├── NightclubSecurity   - Security guard database (10 initialized)
├── NightclubSecurityShift - Security shift bookings
├── NightclubDrugInventory - Drugs stored in venue
├── NightclubSale       - Individual transaction records
├── NightclubTheft      - Robbery/theft events
└── NightclubEvent      - Special events (rave, foam party, etc.)
```

### Key Models

**NightclubVenue**
```typescript
id: Int                    // Primary key
propertyId: Int           // Links to nightclub property
playerId: Int             // Owner
country: String           // Location
currentDJId: Int?         // Currently hired DJ
djContractEndsAt: DateTime? // When DJ shift ends
crowdSize: Int            // 0-100% capacity
crowdVibe: String         // 'chill' | 'normal' | 'wild' | 'raging'
totalRevenueAllTime: BigInt
totalRevenuePeriod: Int
```

**NightclubDJ**
```typescript
id: Int
djName: String
skillLevel: Int           // 1-5 (affects crowd boost)
baseCostPerHour: Int      // €5000-10000
reputation: Float         // 0.1-1.0
specialty: String         // 'house', 'techno', 'hip_hop', etc.
isAvailable: Boolean
```

**NightclubSecurity**
```typescript
id: Int
guardName: String
skillLevel: Int           // 1-5 (affects theft prevention)
baseCostPerHour: Int      // €2500-5000
reputation: Float
specialty: String         // 'patrol', 'door', 'plainclothes'
isAvailable: Boolean
```

---

## GAMEPLAY MECHANICS

### 1️⃣ CROWD DYNAMICS

**Base Calculation:**
```
Current Crowd Size = Previous Size ± Regen/Decay
  + DJ Boost (if active): +20% + (skillLevel * 15%)
  + Event Bonus (if active): +15%
  + Time of Day: +5% during peak hours (22:00-02:00)
  - Natural Decay: -1% per minute (without DJ)
```

**Crowd Vibe Progression:**
```
chill → normal → wild → raging
```
- DJ presence improves vibe
- Events improve vibe
- Time naturally degrades vibe without DJ
- Vibe determines drug demand patterns

**Drug Demand by Vibe:**
```yaml
raging:    cocaine: 0.8, mdma: 0.9, meth: 0.6, weed: 0.3
wild:      cocaine: 0.6, mdma: 0.7, weed: 0.5, mushrooms: 0.4
normal:    weed: 0.6, mdma: 0.4, cocaine: 0.3
chill:     weed: 0.4, alcohol: 0.5
```

### 2️⃣ DJ SYSTEM

**Hiring Process:**
1. Get available DJs: `GET /nightclub/dj/available`
2. Select DJ, hours, start time
3. Cost: `baseCostPerHour × hoursCount`
4. DJ hired for specified duration

**DJ Effects:**
- **Crowd Boost:** `0.8 + (skillLevel × 0.15)` = 1.0x to 1.75x multiplier
- **Vibe Shift:** Can improve current vibe (chill→normal, etc.)
- **Revenue Impact:** Higher vibe = higher prices + more buyers

**Available DJs (Initialized):**
| Name | Level | Cost/h | Bonus | Specialty |
|------|-------|--------|-------|-----------|
| Marco Cristobal | 5 | €8000 | 1.75x | Deep House |
| DJ Tiësto | 5 | €10000 | 1.75x | House |
| Sasha | 4 | €6500 | 1.6x | Techno |
| Richie Hawtin | 5 | €9500 | 1.75x | Techno |
| Armin van Buuren | 5 | €10000 | 1.75x | Progressive |

### 3️⃣ SECURITY SYSTEM

**Hiring Process:**
1. Get available guards: `GET /nightclub/security/available`
2. Select guard for date
3. Cost: `baseCostPerHour × 8` (11 PM - 7 AM shift)
4. Active that night only

**Security Effects:**
- **Theft Reduction:** `(skillLevel × 0.15) + 0.35` = 35% to 95%
- **Base Theft Prevention:** Reduces random robbery chance
- **Active Timeframe:** 20:00-04:00 (8 hour night shift)

**Available Guards (Initialized):**
| Name | Level | Cost/Night | Reduction | Specialty |
|------|-------|------------|-----------|-----------|
| Marco Rossi | 5 | €40000 | 95% | Plainclothes |
| Ivan Sokolov | 5 | €38400 | 95% | Patrol |
| Tommy Tank | 4 | €30400 | 75% | Door |
| Dimitri | 5 | €41600 | 95% | Door |

### 4️⃣ DRUG SALES ENGINE (Automatic)

**Sales Generation (per minute):**
```
Number of Buyers = floor(crowdSize / 10)
```

For each potential buyer:
1. **Drug Selection:** Random based on crowd vibe demand
2. **Quality Distribution:** Usually D-C quality (80%), sometimes B (15%), rare A/S (5%)
3. **Quantity:** 0.5g - 3g random
4. **Price Calculation:**
   ```
   Quality Multiplier = 1.0 (D) → 1.2 (C) → 1.5 (B) → 2.0 (A) → 2.8 (S)
   Vibe Multiplier = 0.9 (chill) → 1.0 (normal) → 1.3 (wild) → 1.6 (raging)
   
   margin = qualityMult × vibeMult
   playerPrice = basePrice × margin
   ```

5. **Transaction:** Money → Player, Drugs → Inventory Reduction

**Example Sale:**
```
Base Price: cocaine €150/g
Quality: B (1.5x), Crowd Vibe: wild (1.3x)
Player Price: 150 × 1.5 × 1.3 = €292/g
Sale Volume: 2g @ €292/g = €584 revenue
```

### 5️⃣ THEFT & ROBBERY SYSTEM

**Theft triggers:**
- Random chance per minute based on:
  - Crowd size: Higher crowd = more opportunistic theft
  - Active security: Reduces chance by their skillLevel%
  - Theft type varies by crowd level

**Theft Events:**
```yaml
crowdSize > 80:    type='customer_theft'    (casual customer steals)
crowdSize ≤ 80:    type='employee_heist'    (organized inside job)
```

**Theft Impact:**
- Drugs randomly removed from inventory
- Owner receives theft notification
- Theft logged with value lost
- Security training reduces future risk

---

## API ENDPOINTS

### DJ Management

**GET `/nightclub/dj/available`**
Returns list of available DJs with all stats

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Marco Cristobal",
      "skillLevel": 5,
      "specialty": "deep_house",
      "costPerHour": 8000,
      "costPerDay": 64000,
      "costPerWeek": 448000,
      "reputation": 0.98,
      "crowdBoostMultiplier": 1.75,
      "image": "..."
    }
  ]
}
```

**POST `/nightclub/:venueId/dj/hire`**
Hire a DJ for specified hours

```json
{
  "djId": 1,
  "hoursCount": 8,
  "startTime": "2026-03-30T22:00:00Z"
}
```

### Security Management

**GET `/nightclub/security/available`**
Returns list of available security guards

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Marco Rossi",
      "skillLevel": 5,
      "specialty": "plainclothes",
      "costPerHour": 5000,
      "costPerShift": 40000,
      "reputation": 0.95,
      "theftReductionPercentage": 95,
      "image": "..."
    }
  ]
}
```

**POST `/nightclub/:venueId/security/hire`**
Hire security for night shift

```json
{
  "guardId": 1,
  "shiftDate": "2026-03-30"
}
```

### Drug Management

**POST `/nightclub/:venueId/drugs/store`**
Store drugs from player inventory into nightclub

```json
{
  "drugType": "cocaine",
  "quality": "B",
  "quantity": 100
}
```

Response:
```json
{
  "success": true,
  "message": "✅ 100g cocaine (B) opgeslagen in nachtclub!"
}
```

### Venue Statistics

**GET `/nightclub/:venueId/stats`**
Get full venue statistics and reports

```json
{
  "success": true,
  "data": {
    "id": 1,
    "crowdSize": 65,
    "crowdVibe": "wild",
    "isOpen": true,
    "inventoryValue": 45000,
    "itemsInStock": 3,
    "revenueAllTime": 125000,
    "revenueToday": 8500,
    "djActive": "Yes",
    "djHoursRemaining": 4,
    "inventory": [
      { "drugType": "cocaine", "quality": "B", "quantity": 50, "basePrice": 225 },
      { "drugType": "mdma", "quality": "C", "quantity": 75, "basePrice": 90 }
    ],
    "recentSales": [
      {
        "drugType": "cocaine",
        "quality": "B",
        "quantitySold": 2,
        "unitPrice": 292,
        "totalRevenue": 584,
        "crowdSize": 65,
        "crowdVibe": "wild"
      }
    ],
    "thefts": []
  }
}
```

---

## STRATEGIC ELEMENTS

### Financial Strategy

**Revenue Optimization:**
1. **Buy quality drugs** → Higher prices → Better margins
2. **Hire top DJ** → Bigger crowd → More sales volume
3. **Good vibe** → Premium pricing multiplier
4. **Security guards** → Theft prevention = higher profits

**Cost Management:**
```
Daily Operating Cost = DJ Hours × Cost + Security Cost
Example: 8hr DJ (€8000) + 1 Security (€40000) = €48000/day
```

### Risk vs. Reward

```
NO DJ, NO SECURITY
├─ Cost: €0
├─ Crowd: Decays
├─ Theft Chance: HIGH (up to 30% per minute)
└─ Expected Revenue: LOW

FULL SUPPORT (Top DJ + Security)
├─ Cost: €88000/day
├─ Crowd: FULL (100%)
├─ Theft Chance: 5-10%
└─ Expected Revenue: HIGH (€200k+ per day)
```

### Time of Day

```
19:00-21:00: Quiet start (+0% bonus)
22:00-02:00: PEAK HOURS (+5% crowd, +30% demand)
03:00-06:00: Closing time (-5% crowd decay, +20% theft)
07:00-18:00: Closed (No sales, no theft risk)
```

### Competition Elements

- Rival players can scope out nightclub activities
- High revenue attracts attention from crime organizations
- Police might raid high-profile venues
- Gang cooperation needed for protection

---

## BACKGROUND JOBS (To Implement)

These run automatically but need cron setup:

**`processAutomagicSales()`**
- Called every minute
- Generates random sales based on crowd state
- Handles pricing dynamically

**`processTheftsAndRisks()`**
- Called every 2 minutes
- Checks theft probability
- Executes robbery events

**`updateCrowdState()`**
- Called every minute
- Recalculates vibe/crowd size
- Decay if no DJ active

---

## FUTURE EXPANSION IDEAS

1. **Rival Nightclubs:** Compete for DJs, customers, territory
2. **Nightclub Leveling:** Renovation → Better capacity/atmosphere
3. **VIP Sections:** Premium areas with higher-value transactions
4. **Resident DJ System:** Exclusive DJs for established venues
5. **Drug Synergy:** Certain drug+vibe combos more profitable
6. **Promotional Events:** Owner can invest in marketing for crowd boost
7. **Entertainment Acts:** Hire performers, strippers, comedians
8. **Midnight Races:** Host racing events from nightclub
9. **Political System:** Payoffs to avoid raids
10. **Reputation System:** Reviews affect crowd quality

---

## CONFIGURATION CONSTANTS (In Service)

```typescript
BASE_CROWD_REGEN_RATE = 2          // +2% per minute
BASE_CROWD_DECAY_RATE = 1           // -1% per minute (no DJ)
MIN_MARGIN = 0.8                    // 80% minimum markup
MAX_MARGIN = 3.0                    // 300% maximum markup
```

---

## STATUS & NEXT STEPS

✅ **COMPLETED:**
- Database schema (8 models)
- NightclubService with full logic
- DJ + Security management
- Automatic sales engine
- Theft/robbery system
- API endpoints (6 routes)
- DJ & Security seed data (10 each)

⏳ **TODO:**
- Flutter UI integration
- Cron job setup for background processing
- Police raid mechanics
- Rival nightclub system
- Admin management interface

---

**Version:** 1.0
**Last Updated:** 2026-03-30
**Status:** Production Ready (Backend)
