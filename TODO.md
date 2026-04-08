# The Mob State - Master TODO Checklist

**Keep this file open during development. Check items as you complete them.**

---

## Phase 0: Project Setup & Infrastructure

### ✅ 0.1 Initialize Backend
- [x] Create backend folder
- [x] Initialize npm project
- [x] Install core dependencies (express, cors, dotenv, zod)
- [x] Install dev dependencies (typescript, ts-node-dev)
- [x] Initialize TypeScript config

**Files Expected:**
- `backend/package.json`
- `backend/tsconfig.json`

**Verify:**
```powershell
cd backend
npm run dev
```
**Expected:** Server starts without errors

**Common Failure:** Port already in use → Stop XAMPP Apache or change port in config

---

### ✅ 0.2 Backend Skeleton + Health Endpoint
**What:** Create basic Express app with /health endpoint, error middleware, time provider

**Files Expected:**
- `backend/src/index.ts` - main entry point
- `backend/src/app.ts` - Express app setup
- `backend/src/config/index.ts` - configuration loader
- `backend/src/middleware/errorHandler.ts` - global error handler
- `backend/src/utils/timeProvider.ts` - injectable clock for deterministic testing
- `backend/src/routes/health.ts` - health check route

**Verify:**
```powershell
cd backend
npm run dev
curl http://localhost:3000/health
```
**Expected:** `{"status":"ok","timestamp":"..."}`

**Common Failure:** TypeScript errors → Check tsconfig.json has `"moduleResolution": "node"` and `"esModuleInterop": true`

---

### ✅ 0.3 Database Setup (Prisma + MariaDB)
**What:** Install Prisma, create schema with Player model, run first migration

**Files Expected:**
- `backend/prisma/schema.prisma` - database schema
- `backend/prisma/migrations/` - migration files
- `backend/.env` - database connection string
- `backend/src/lib/prisma.ts` - Prisma Client with MariaDB adapter

**Verify:**
```powershell
cd backend
npx prisma migrate dev --name init
npx ts-node -r dotenv/config test-database.ts
```
**Expected:** All database tests passed (CRUD operations work)

**Note:** Prisma Studio has compatibility issues with Prisma 7 MariaDB adapter. Use phpMyAdmin (http://localhost/phpmyadmin) or test-database.ts instead.

**Common Failure:** Connection refused → Ensure MariaDB is running in XAMPP, check DATABASE_URL in .env

---

### ✅ 0.4 Add Scripts to package.json
**What:** Add dev, build, start, lint, format, test, check scripts

**Files Expected:**
- `backend/package.json` - updated with scripts
- `backend/eslint.config.mjs` - ESLint config (ESLint 9 flat config)
- `backend/.prettierrc` - Prettier config

**Verify:**
```powershell
cd backend
npm run check
```
**Expected:** All checks pass (typecheck, lint, format:check)

**Common Failure:** ESLint not found → `npm i -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser prettier`

---

## Phase 1: Core Player Systems

### ✅ 1.1 Player Model & Authentication
**What:** Extend Player model with username, password hash, stats (health, hunger, thirst, money, rank)

**Files Expected:**
- `backend/prisma/schema.prisma` - updated Player model
- `backend/src/services/authService.ts` - registration, login, JWT
- `backend/src/routes/auth.ts` - /auth/register, /auth/login
- `backend/src/middleware/authenticate.ts` - JWT verification middleware

**Verify:**
```powershell
curl -X POST http://localhost:3000/auth/register -H "Content-Type: application/json" -d "{\"username\":\"test\",\"password\":\"test123\"}"
```
**Expected:** `{"token":"...","player":{...}}`

**Common Failure:** bcrypt errors on Windows → Use `bcrypt` package, not `bcryptjs`

---

### ✅ 1.2 Hunger & Thirst System
**What:** Add tick mechanism that depletes hunger/thirst over time, death if both reach 0

**Files Expected:**
- `backend/src/services/tickService.ts` - runs every N minutes
- `backend/src/services/playerService.ts` - applyHungerThirstTick, checkDeath
- `backend/prisma/schema.prisma` - add hunger, thirst, lastTickAt to Player

**Verify:**
```powershell
# In dev console or test:
# Set player hunger=10, wait tick interval, check hunger decreased
```
**Expected:** Hunger/thirst decrease by config amount per tick

**Common Failure:** Tick runs twice → Use singleton pattern for tickService

---

### ✅ 1.3 Injury & Hospital System
**What:** Players can be injured (health < 100), must visit hospital to heal

**Files Expected:**
- `backend/src/routes/hospital.ts` - POST /hospital/heal
- `backend/src/services/hospitalService.ts` - heal logic, cost calculation
- `backend/prisma/schema.prisma` - add health field to Player

**Verify:**
```powershell
curl -X POST http://localhost:3000/hospital/heal -H "Authorization: Bearer <token>"
```
**Expected:** `{"event":"hospital.healed","params":{"healthRestored":50,"cost":1000}}`

**Common Failure:** Negative money → Check player has enough money before healing

---

## Phase 2: World Events & Real-time Updates

### ✅ 2.1 WorldEvents Table & Feed
**What:** Create WorldEvents table to log all game events (crimes, deaths, etc.)

**Files Expected:**
- `backend/prisma/schema.prisma` - WorldEvent model
- `backend/src/services/worldEventService.ts` - createEvent, getRecentEvents
- `backend/src/routes/events.ts` - GET /events (paginated)

**Verify:**
```powershell
curl http://localhost:3000/events?limit=10
```
**Expected:** JSON array of recent events with eventKey + params

**Common Failure:** Missing index → Add `@@index([createdAt])` to WorldEvent

---

### ✅ 2.2 Server-Sent Events (SSE) for Live Feed
**What:** Add SSE endpoint so clients can subscribe to live world events

**Files Expected:**
- `backend/src/routes/events.ts` - GET /events/stream (SSE)
- `backend/src/services/eventBroadcaster.ts` - manages SSE connections

**Verify:**
```powershell
curl -N http://localhost:3000/events/stream
```
**Expected:** Keeps connection open, sends events in SSE format

**Common Failure:** Connection closes immediately → Ensure headers set correctly (`Content-Type: text/event-stream`, `Cache-Control: no-cache`)

---

### ⏭️ 2.3 Alternative: WebSocket Support (Optional - Skipped)
**What:** Add WebSocket support as alternative to SSE for mobile clients

**Note:** SSE is sufficient for current requirements. WebSocket can be added later if needed for mobile clients.

---

## Phase 3: Vehicles & Transportation

### ✅ 3.1 Vehicle Model & Ownership
**What:** Create Vehicle table, link to Player, add buy/sell logic

**Files Expected:**
- `backend/prisma/schema.prisma` - Vehicle model
- `backend/src/routes/vehicles.ts` - GET /vehicles, POST /vehicles/buy
- `backend/src/services/vehicleService.ts` - buy, sell, transfer logic
- `backend/content/vehicles.json` - vehicle definitions (speed, cost, fuel capacity)

**Verify:**
```powershell
curl http://localhost:3000/vehicles
curl -X POST http://localhost:3000/vehicles/buy -H "Authorization: Bearer <token>" -d "{\"vehicleType\":\"sedan\"}"
```
**Expected:** Player owns vehicle, money deducted

**Common Failure:** Duplicate purchase → Check if player already owns max vehicles

---

### ✅ 3.2 Fuel System & Refueling
**What:** Vehicles consume fuel when traveling, players must refuel

**Files Expected:**
- `backend/prisma/schema.prisma` - add fuel field to Vehicle
- `backend/src/routes/vehicles.ts` - POST /vehicles/:id/refuel
- `backend/src/services/vehicleService.ts` - refuel logic

**Verify:**
```powershell
curl -X POST http://localhost:3000/vehicles/123/refuel -H "Authorization: Bearer <token>" -d "{\"amount\":50}"
```
**Expected:** Fuel increased, money deducted

**Common Failure:** Overfill → Cap fuel at vehicle capacity

---

### ✅ 3.3 Vehicle Breakdown & Escape Mechanics
**What:** Vehicles can break down randomly during crimes, must repair

**Files Expected:**
- `backend/src/services/crimeService.ts` - breakdown chance during escape
- `backend/src/routes/vehicles.ts` - POST /vehicles/:id/repair
- `backend/prisma/schema.prisma` - add isBroken field to Vehicle

**Verify:**
```powershell
# Test: Attempt crime, check if vehicle breaks
```
**Expected:** Vehicle marked broken on failure, repair costs money

**Common Failure:** RNG not deterministic → Use seeded random in tests

**Note:** Breakdown mechanics during crimes will be implemented in Phase 4 when crime system is added. For now, repair system is fully functional and tested.

---

## Phase 4: Content-Driven Actions

### ✅ 4.1 Crime Actions (30 types)
**What:** Create content pack with 30 crime types (pickpocket, robbery, heist, etc.)

**Files Expected:**
- `backend/content/crimes.json` - 30 crime definitions (risk, reward, xp, required level)
- `backend/src/routes/crimes.ts` - POST /crimes/:crimeId/attempt
- `backend/src/services/crimeService.ts` - attempt logic, success/fail calculation
- `backend/prisma/schema.prisma` - CrimeAttempt model

**Verify:**
```powershell
curl -X POST http://localhost:3000/crimes/pickpocket/attempt -H "Authorization: Bearer <token>"
```
**Expected:** `{"event":"crime.success","params":{"money":500,"xp":10}}` or failure event

**Verified:**
- ✅ 30 crime types with Dutch names (Zakkenrollen → Casino Overval)
- ✅ Level-based progression (minLevel 1-25)
- ✅ Vehicle integration (18/30 crimes require vehicle)
- ✅ Fuel consumption (1 per attempt)
- ✅ Vehicle breakdown on failure (0%-50% chance)
- ✅ Jail mechanics (50% catch on failure, 3-300 min)
- ✅ XP rewards (5-1000 XP based on difficulty)
- ✅ Success rates (15%-80%)
- ✅ All 7 error scenarios (INVALID_CRIME_ID, LEVEL_TOO_LOW, VEHICLE_REQUIRED, VEHICLE_NOT_FOUND, NOT_VEHICLE_OWNER, VEHICLE_BROKEN, NO_FUEL)
- ✅ Crime history tracking
- ✅ Available crimes filter by player rank
- ✅ World events broadcast for successes/failures

**Common Failure:** Hardcoded values → Ensure all crime stats loaded from JSON

---

### ✅ 4.2 Job Actions (24 types)
**What:** Create content pack with 24 job types (legal income, low risk)

**Files Expected:**
- `backend/content/jobs.json` - 24 job definitions
- `backend/src/routes/jobs.ts` - POST /jobs/:jobId/work
- `backend/src/services/jobService.ts` - work logic, cooldown
- `backend/prisma/schema.prisma` - JobAttempt model

**Verify:**
```powershell
curl -X POST http://localhost:3000/jobs/taxi-driver/work -H "Authorization: Bearer <token>"
```
**Expected:** `{"event":"job.completed","params":{"earnings":200}}`

**Verified:**
- ✅ 24 job types (Krant Bezorgen → Piloot)
- ✅ Level-based progression (minLevel 1-25)
- ✅ Random earnings (min-max range per job)
- ✅ XP rewards (5-300 XP)
- ✅ Cooldown systeem (30-480 minuten per job)
- ✅ Available jobs filter by player rank
- ✅ Job history tracking
- ✅ Error handling (INVALID_JOB_ID, LEVEL_TOO_LOW, ON_COOLDOWN)
- ✅ World events broadcast voor completed jobs

**Common Failure:** Cooldown bypass → Store lastJobAt timestamp per job type

---

### ✅ 4.3 Action Cooldowns & Energy System
**What:** Add cooldown tracking, optional energy cost per action

**Files Expected:**
- `backend/prisma/schema.prisma` - ActionCooldown model ✅
- `backend/src/services/cooldownService.ts` - check, set cooldowns ✅
- `backend/src/middleware/checkCooldown.ts` - middleware to enforce ✅

**Verify:**
```powershell
# Attempt same crime twice rapidly
```
**Expected:** Second attempt fails with cooldown error

**Verified:**
- ✅ ActionCooldown database model with unique(playerId, actionType) constraint
- ✅ cooldownService with checkCooldown(), setCooldown(), clearPlayerCooldowns()
- ✅ calculateCrimeCooldown() - Dynamic cooldowns based on crime reward
- ✅ Dynamic crime cooldowns (reward-based):
  - €0-500: 5 minutes (pickpocket, shoplift)
  - €500-2000: 10 minutes (car theft, burglary)
  - €2000-10000: 30 minutes (armed robbery, smuggling)
  - €10000-30000: 1 hour (jewelry heist, art theft)
  - €30000+: 2 hours (bank robbery, casino heist)
- ✅ Static cooldowns for other actions:
  - Job: 30 minutes (max 48/day)
  - Travel: 2 hours (max 12/day)
  - Heist: 6 hours (max 4/day)
  - Appeal: 4 hours (max 6/day)
- ✅ Designed for months of progression (prevents burnout within 1 month)
- ✅ error.cooldown event with remainingSeconds parameter
- ✅ Frontend event renderer for Dutch & English cooldown messages
- ✅ TimeProvider integration for deterministic testing
- ✅ Tested: Dynamic cooldown enforcement working correctly

**Common Failure:** Time drift → Use timeProvider for all time checks ✅ IMPLEMENTED

---

### ✅ 4.4 XP Loss Mechanics (Risk/Reward System)
**What:** Add XP penalties for failures to slow progression and add real consequences

**Implementation Points:**

**Crime Failures:**
- Failed crime: Lose 10-25% of XP that would have been gained
- Caught & jailed: Lose additional 5% of current level's XP
- Vehicle broken: Lose 2-5% repair cost in XP
- Example: Crime gives 100 XP on success → Lose 10-25 XP on failure

**Judge Sentencing:**
- Convicted (appeal denied): Lose 1-3% of total XP
- Harsh sentence (>2 hours jail): Lose additional 50-100 XP
- Repeat offender (3+ convictions): Lose 5% of total XP
- Example: Player at 10,000 XP → Loses 100-300 XP on conviction

**Job Failures:**
- Failed job: Lose 5-10% of potential earnings as XP penalty
- Lower risk than crimes (jobs are "safer")

**Heist Failures:**
- Failed heist: Each crew member loses 50-200 XP
- Sabotage detected: Saboteur loses 500 XP + crew trust

**Files to Modify:**
- `backend/src/services/crimeService.ts` - Add XP loss on failure
- `backend/src/services/judgeService.ts` - Add XP penalty on sentencing
- `backend/src/services/jobService.ts` - Add XP loss on job failure
- `backend/src/services/heistService.ts` - Add XP penalty for failed heists
- `backend/src/services/playerService.ts` - Add loseXP(playerId, amount) function

**Configuration:**
```typescript
const XP_LOSS_CONFIG = {
  crimeFailed: { min: 0.10, max: 0.25 },      // 10-25% of potential XP gain
  crimeJailed: 0.05,                           // 5% of level XP
  judgeConvicted: { min: 0.01, max: 0.03 },   // 1-3% of total XP
  judgeHarshSentence: { min: 50, max: 100 },  // Flat XP loss
  repeatOffender: 0.05,                        // 5% of total XP
  jobFailed: { min: 0.05, max: 0.10 },        // 5-10% of potential earnings as XP
  heistFailed: { min: 50, max: 200 },         // Flat XP loss per crew member
  sabotageCaught: 500,                         // Large penalty for saboteurs
};
```

**Verify:**
```powershell
# Test crime failure XP loss
curl -X POST http://localhost:3000/crimes/robbery/attempt -H "Authorization: Bearer <token>"
# Check player XP decreased on failure

# Test judge sentencing XP loss
curl -X POST http://localhost:3000/trial/appeal -H "Authorization: Bearer <token>"
# Check XP loss on appeal denial
```

**Expected:**
- Crime failure: `{"event":"crime.failed","params":{"xpLost":15}}`
- Judge conviction: `{"event":"trial.sentenced","params":{"xpLost":200}}`
- Prevent XP going below 0 (can't de-level from current rank)

**Game Design Benefits:**
- ✅ Slows progression significantly (XP loss = more actions needed)
- ✅ Real consequences for risky behavior
- ✅ Encourages strategic play (when to take risks)
- ✅ Extends game lifespan (months → years of content)
- ✅ Creates tension: High reward crimes = high XP loss risk
- ✅ Rewards skilled play (success rate matters more)

**Common Failure:** XP can go negative → Cap at 0, prevent rank decrease

---

## Phase 5: Properties & Businesses

### ✅ 5.1 Property Model & Claimable System
**What:** Create Property table with UNIQUE claimable properties per country

**Enhanced Features:**
- **Claimable Properties**: Casino (1 per country), Warehouse (5 per country), etc.
- **Unlimited Properties**: Houses (unlimited, anyone can buy)
- **Land-Specific**: Properties tied to countries, can't transfer
- **Auto-Forfeit**: Lose property if dead OR jailed >24 hours
- **Ownership Check**: API returns `available: true/false, ownedBy: playerId?`

**Database Schema:**
```typescript
// Property ownership table
model PlayerProperty {
  id              Int      @id @default(autoincrement())
  playerId        Int
  propertyId      String   // "casino_nl", "warehouse_3_us"
  countryId       String
  upgradeLevel    Int      @default(1)
  lastIncomeAt    DateTime @default(now())
  purchasedAt     DateTime @default(now())
  
  @@unique([propertyId]) // Only ONE owner per casino/warehouse
}
```

**Properties.json Structure:**
```json
{
  "properties": [
    {
      "id": "casino",
      "name": "Casino",
      "image": "casino.png",
      "type": "unique_per_country",
      "maxOwners": 1,
      "basePrice": 500000,
      "baseIncome": 5000,
      "features": ["minigames", "player_gambling"]
    },
    {
      "id": "warehouse",
      "name": "Warehouse",
      "type": "limited_per_country",
      "maxOwners": 5,
      "basePrice": 150000,
      "baseIncome": 2000,
      "features": ["storage"]
    },
    {
      "id": "house",
      "name": "House",
      "type": "unlimited",
      "basePrice": 50000,
      "baseIncome": 500
    }
  ]
}
```

**Files Expected:**
- `backend/prisma/schema.prisma` - PlayerProperty model with uniqueness constraint
- `backend/content/properties.json` - property definitions with ownership limits
- `backend/src/routes/properties.ts` - GET /properties/available/:countryId (shows claimable)
- `backend/src/routes/properties.ts` - POST /properties/claim/:propertyId
- `backend/src/services/propertyService.ts` - checkAvailability(), claimProperty()

**API Endpoints:**
- `GET /properties/available/:countryId` - List properties with ownership status
- `POST /properties/claim/:propertyId` - Claim available property
- `GET /properties/mine` - List player's owned properties
- `POST /properties/:id/forfeit` - Manually forfeit property

**Verify:**
```powershell
# Check available properties in NL
curl http://localhost:3000/properties/available/NL

# Expected: { "casino": { "available": false, "ownedBy": 30 }, "warehouse_1": { "available": true } }

# Claim casino
curl -X POST http://localhost:3000/properties/claim/casino_NL -H "Authorization: Bearer <token>"
```

**Common Failure:** Multiple ownership → Enforce @@unique constraint on propertyId

---

### ✅ 5.2 Business Upgrades & Income
**What:** Properties generate passive income, can be upgraded

**Files Expected:**
- `backend/prisma/schema.prisma` - add upgradeLevel, lastIncomeAt to PlayerProperty
- `backend/src/services/propertyService.ts` - collectIncome, upgrade logic
- `backend/src/routes/properties.ts` - POST /properties/:id/collect, /upgrade

**Verify:**
```powershell
curl -X POST http://localhost:3000/properties/123/collect -H "Authorization: Bearer <token>"
```
**Expected:** Income added to player money

**Common Failure:** Double collection → Update lastIncomeAt atomically

---

### ✅ 5.3 Casino Mini-Games Backend 🎰
**What:** Server-side casino game logic (slot machine, blackjack, roulette)

**Game Mechanics:**
- **Slot Machine**: 3 reels, 7 symbols, match 3 = win (multipliers: 2x-100x)
- **Blackjack**: Player vs dealer, hit/stand/double, dealer hits on <17
- **Roulette**: 37 numbers (0-36), red/black bets (1:1), number bets (35:1)
- **House Edge**: Owner receives 10% of all bets (win or lose)
- **RNG**: Crypto-secure random with seed logging (anti-cheat)

**Files Expected:**
- `backend/src/services/casinoService.ts` - playSlots(), playBlackjack(), playRoulette()
- `backend/src/routes/casino.ts` - POST /casino/:propertyId/slots, /blackjack, /roulette
- `backend/prisma/schema.prisma` - CasinoTransaction model (player, bet, result, ownerCut)

**API Structure:**
```typescript
POST /casino/:casinoId/slots
Body: { betAmount: 1000 }
Response: { 
  result: ["🍒", "🍒", "🍒"], 
  won: true, 
  payout: 10000, 
  ownerCut: 100 
}
```

**Verify:**
```powershell
# Play slots at casino owned by player 30
curl -X POST http://localhost:3000/casino/casino_NL/slots -H "Authorization: Bearer <token>" -d '{"betAmount":1000}'

# Expected: { "result": [...], "payout": 0-100000, "ownerCut": 100 }
```

**Verified:**
- ✅ CasinoTransaction database model with playerId, casinoId, ownerId, gameType, betAmount, payout, ownerCut
- ✅ Crypto-secure RNG using Node.js randomBytes (16-byte seed logging)
- ✅ Slot machine with 7 symbols (🍒 🍋 🍊 🍇 💎 🔔 7️⃣) and multipliers (2x-100x)
- ✅ Blackjack with hit/stand actions, dealer hits on <17, natural blackjack detection
- ✅ European roulette (0-36) with number bets (35:1) and color/range bets (1:1)
- ✅ 10% house edge deducted from all bets, paid to casino owner
- ✅ Transaction atomicity (player debit, owner credit, payout, logging)
- ✅ World events broadcast for big wins (100x slots, straight number roulette)
- ✅ Casino history endpoint (GET /casino/:casinoId/history)
- ✅ Minimum bet €10 enforcement
- ✅ Error handling for CASINO_NOT_FOUND, NOT_A_CASINO, INSUFFICIENT_FUNDS

**Common Failure:** Client-side RNG → MUST be server-side to prevent cheating ✅ IMPLEMENTED

---

### ✅ 5.4 Property Auto-Forfeit System
**What:** Players lose property if dead or jailed >24 hours

**Implementation:**
- **Tick Service Check**: Every 5 minutes, scan PlayerProperty table
- **Death Check**: If player.health <= 0, forfeit all properties
- **Jail Check**: If player in jail >24 hours, forfeit all properties
- **Notification**: Send event to owner (property.forfeited)
- **Re-availability**: Property becomes claimable again

**Files Expected:**
- `backend/src/services/tickService.ts` - propertyForfeitCheck()
- `backend/src/services/propertyService.ts` - forfeitProperty(playerId)

**Verify:**
```powershell
# Set player health to 0 (death)
UPDATE players SET health = 0 WHERE id = 30;

# Wait for tick (5 min) or trigger manually
node trigger-tick.ts

# Check properties
SELECT * FROM player_properties WHERE playerId = 30;

# Expected: No results (all forfeited)
```

**Verified:**
- ✅ Added `jailRelease` DateTime field to Player model in schema.prisma
- ✅ Created database migration for jailRelease column
- ✅ Implemented `forfeitAllProperties(playerId)` in propertyService
- ✅ Implemented `checkPlayerForfeiture(playerId)` - checks death and >24h jail
- ✅ Integrated into tickService `checkPropertyForfeitures()` - runs every tick
- ✅ Death check: health <= 0 triggers forfeit
- ✅ Jail check: jailRelease >24 hours from now triggers forfeit
- ✅ World event broadcast on forfeit (property.forfeited)
- ✅ Transaction handling (delete from properties table)
- ✅ Forfeit statistics tracking in tick logs

**Common Failure:** None - system works automatically via tick service

---

### ✅ 5.5 Overlay Keys in Property API
**What:** Return overlay image keys for UI rendering (damaged, upgraded, etc.)

**Files Expected:**
- `backend/src/routes/properties.ts` - include overlayKeys in response
- `backend/src/services/propertyService.ts` - getPropertyOverlays() function

**Verify:**
```powershell
curl http://localhost:3000/properties/mine -H "Authorization: Bearer <token>"
```
**Expected:** Each property has `overlayKeys: ["upgraded_lvl2", "income_ready"]`

**Verified:**
- ✅ Added `getPropertyOverlays()` private method in propertyService
- ✅ Overlay keys included in `getOwnedProperties()` response
- ✅ `new` overlay for properties < 1 hour old
- ✅ `upgraded_lvl{N}` overlay for upgraded properties (level > 1)
- ✅ `income_ready` overlay when income can be collected (lastIncomeAt > incomeInterval)
- ✅ Multiple overlays supported (e.g., ["upgraded_lvl2", "income_ready"])
- ✅ Returns empty array [] when no overlays apply
- ✅ All 5 test cases passed (new, upgraded, income ready, multiple, none)

**Common Failure:** None - returns empty array if no overlays apply

---

## Phase 6: Crews & Collaborative Crime

### ✅ 6.1 Crew Model & Creation
**What:** Players can create/join crews, crew has shared bank

**Files Expected:**
- `backend/prisma/schema.prisma` - Crew, CrewMember models
- `backend/src/routes/crews.ts` - POST /crews/create, /crews/:id/join
- `backend/src/services/crewService.ts` - CRUD logic

**Verify:**
```powershell
curl -X POST http://localhost:3000/crews/create -H "Authorization: Bearer <token>" -d "{\"name\":\"TheBosses\"}"
```
**Expected:** Crew created, player is leader

**Common Failure:** Name collision → Enforce unique crew names

---

### ✅ 6.2 Trust System & Sabotage
**What:** Crew members have trust score, low trust can sabotage heists

**Files Expected:**
- `backend/prisma/schema.prisma` - add trustScore to CrewMember
- `backend/src/services/crewService.ts` - adjustTrust, checkSabotage

**Verify:**
```powershell
# Test: Set trust low, attempt heist
```
**Expected:** Sabotage chance increases with low trust

**Common Failure:** Negative trust → Clamp trust between 0-100

---

### ✅ 6.3 Crew Heists
**What:** Multi-player heists require crew, split rewards

**Files Expected:**
- `backend/content/heists.json` - heist definitions (required members, payout)
- `backend/src/routes/heists.ts` - POST /heists/:id/start
- `backend/src/services/heistService.ts` - coordination logic

**Verify:**
```powershell
curl -X POST http://localhost:3000/heists/bank-heist/start -H "Authorization: Bearer <leader_token>"
```
**Expected:** All crew members get event, rewards split

**Common Failure:** Race condition → Use transaction to update all members

---

### ✅ 6.4 Crew Liquidations (Public)
**What:** Crews can be liquidated by rivals, assets seized, shown in world feed

**Files Expected:**
- `backend/src/routes/crews.ts` - POST /crews/:id/liquidate
- `backend/src/services/crewService.ts` - liquidate logic, create public event

**Verify:**
```powershell
curl -X POST http://localhost:3000/crews/123/liquidate -H "Authorization: Bearer <attacker_token>"
curl http://localhost:3000/events
```
**Expected:** Event "crew.liquidated" appears in feed

**Common Failure:** Attacker not strong enough → Check power/level requirements

---

## Phase 7: Law Enforcement & Justice

### ✅ 7.1 Police System with Wanted Ratio
**What:** Failed crimes increase wanted level, police arrest if ratio exceeded

**Implementation Details:**
- Wanted level increases by +5 on crime failure (configurable via WANTED_LEVEL_INCREASE_ON_CRIME_FAIL)
- Arrest probability = min((wantedLevel / policeRatio) * 100, 90%) - capped at 90%
- Police ratio = 10 players per cop (configurable via POLICE_RATIO)
- Bail cost = wantedLevel * €1000
- Jail time = wantedLevel * 10 minutes (min 30)
- Wanted level decays by 1 per tick (configurable via WANTED_LEVEL_DECAY_PER_TICK)
- World events: 'police.arrested', 'police.bail_paid'

**Files Expected:**
- `backend/prisma/schema.prisma` - add wantedLevel to Player ✅
- `backend/src/services/policeService.ts` - checkArrest, calculateBail, payBail, jailPlayer ✅
- `backend/src/config/index.ts` - police ratio setting, decay, increase ✅
- `backend/src/routes/police.ts` - POST /pay-bail, GET /wanted-status ✅
- `backend/src/services/crimeService.ts` - integrate wanted level tracking ✅
- `backend/src/services/tickService.ts` - passive wanted level decay ✅
- `backend/test-police.js` - comprehensive test suite ✅

**Verify:**
```powershell
cd backend
node test-police.js
```
**Expected:** Player jailed after crime failures, wanted level increases, bail system works

**Tested:** ✅ All 6 test scenarios pass (wanted tracking, arrest chance, bail, integration)

**Common Failure:** Wanted level never decreases → Fixed with decay in tickService

---

### ✅ 7.2 FBI & Federal Crimes
**What:** High-level crimes trigger FBI, higher penalties, separate from police system

**Implementation Details:**
- FBI heat increases by +10 on federal crime failure (vs +5 for police)
- FBI arrest formula: min((fbiHeat / 5) * 100, 95%) - capped at 95% (vs police 90%)
- FBI ratio = 5 players per FBI agent (vs police 10:1) - more aggressive
- Federal bail = fbiHeat * €3000 (3x higher than police €1000)
- Federal jail time = fbiHeat * 20 minutes (2x longer, min 60)
- FBI heat decays by 0.5 per tick (slower than police decay of 1)
- Federal bail reduces heat by 40% (vs police 50%) - FBI is less forgiving
- No double jeopardy: Federal crimes trigger FBI only, not both systems
- 6 federal crimes marked with `isFederal: true`:
  - bank_robbery, casino_heist, kidnapping
  - counterfeit_money, identity_theft, rob_armored_truck

**Files Expected:**
- `backend/src/services/fbiService.ts` - federal crime tracking, arrest logic ✅
- `backend/content/crimes.json` - add isFederal flag to 6 high-level crimes ✅
- `backend/src/routes/fbi.ts` - POST /pay-bail, GET /status ✅
- `backend/src/config/index.ts` - FBI ratio, decay, increase settings ✅
- `backend/src/services/crimeService.ts` - FBI heat on federal crime failure ✅
- `backend/src/services/tickService.ts` - FBI heat decay (0.5 per tick) ✅
- `backend/prisma/schema.prisma` - add fbiHeat field to Player ✅
- `backend/test-fbi-highlevel.js` - comprehensive FBI test suite ✅

**Verify:**
```powershell
cd backend
node setup-fbi-test-player.sql | mysql -u root mafia_game  # Create high-level player
node test-fbi-highlevel.js
```
**Expected:** FBI heat increases on federal crime failures, FBI arrests separate from police, federal bail 3x higher

**Tested:** ✅ All 8 test scenarios pass:
- FBI heat tracking (10 heat accumulated)
- Federal arrest by FBI (95% chance at heat 10)
- Federal bail payment (€30,000 → heat reduced 40%)
- Separation from police (wanted=0, FBI heat=10)

**Common Failure:** Double jeopardy → Fixed: Federal crimes only trigger FBI, not both systems

---

### ✅ 7.3 Judges & Sentencing Guidelines
**What:** Judges determine sentence length based on guidelines, can be bribed

**Implementation Details:**
- Sentencing guidelines for all 30 crimes with min/max ranges
- Sentence modifiers:
  - First Offense: -50% sentence
  - Repeat Offender (3+ crimes): +50% sentence & fine
  - High Wanted Level (50+): +30% sentence & fine
  - High FBI Heat (20+): +50% sentence & fine
- Bribery system:
  - Base success chance: 30%
  - Minimum bribe: €5,000
  - Success chance reduced by: wanted (-0.5%/level) + FBI heat (-1%/heat)
  - High bribes increase chance (up to +20% for €100k+)
  - Success: -50% sentence reduction
  - Failure consequences: +60 min jail, 2x fine, +10 wanted level
  - Success chance capped: 5% minimum, 80% maximum
- Criminal record tracking (last 10 convictions)

**Files Expected:**
- `backend/src/services/judgeService.ts` - sentencing logic, bribe calculations ✅
- `backend/content/sentencing.json` - crime → min/max sentence + fine mapping ✅
- `backend/src/routes/trial.ts` - POST /sentence, /bribe, GET /record ✅
- `backend/test-judges.js` - comprehensive judge system tests ✅

**Verify:**
```powershell
cd backend
node test-judges.js
```
**Expected:** Sentences calculated with modifiers, bribes can succeed or fail with consequences

**Tested:** ✅ All 8 test scenarios pass:
- Sentencing for low-level crimes (pickpocket: 15-21 min)
- Sentencing for federal crimes (bank_robbery: 451-492 min)
- Sentence modifiers applied (repeat offender: +50%)
- Minimum bribe enforcement (€5,000)
- Bribe failure consequences (+60 min, 2x fine, +10 wanted)
- Criminal record tracking (3 convictions shown)

**Common Failure:** Bribe always works → Fixed: Success chance affected by wanted/FBI heat, can be as low as 5%

---

### ✅ 7.4 Appeals System
**What:** Players can appeal sentence once, costs money

**Files Created:**
- `backend/src/routes/trial.ts` - POST /trial/appeal ✅
- `backend/prisma/schema.prisma` - appealedAt field ✅
- `backend/src/services/judgeService.ts` - appealSentence() ✅
- `backend/add-appeal-tracking.sql` - DB migration ✅
- `backend/test-appeals.js` - Full test suite ✅

**Implementation:**
- **Appeal Cost:** jailTime × €100 (min €2,000, max €50,000)
- **Success Calculation:** 40% base chance with modifiers:
  * First offense: +20% (total 60%)
  * Repeat offender (5+ crimes): -20%
  * Wanted level ≥20: -10%
  * FBI heat ≥10: -15%
  * Final range: 10%-70%
- **Success Result:** 20-40% sentence reduction
- **Failure Result:** Money lost, sentence unchanged
- **Once Only:** appealedAt timestamp prevents duplicate appeals

**Verified:**
```powershell
node test-appeals.js  # All 8 tests pass (100% success rate)
```
**Tested:** ✅ All 8 test scenarios pass:
- Valid appeal (granted or denied based on RNG)
- Duplicate appeal rejection (ALREADY_APPEALED error)
- Invalid crime ID rejection
- Missing crime ID rejection
- Appeal cost calculation (€2k-€50k range)
- Success chance modifiers (10%-70% range)

**Common Failure:** Multiple appeals → Fixed: appealedAt tracking prevents re-appeal

---

## Phase 8: Banking & Economy

### ✅ 8.1 Bank Model & Deposits
**What:** Players can deposit money in banks for safety, earns interest

**Files Created:**
- `backend/prisma/schema.prisma` - BankAccount model ✅
- `backend/src/routes/bank.ts` - POST /deposit, /withdraw, GET /balance, /account ✅
- `backend/src/services/bankService.ts` - deposit, withdraw, interest logic ✅
- `backend/add-bank-accounts.sql` - DB migration ✅
- `backend/test-bank.js` - Full test suite ✅

**Implementation Details:**
- **BankAccount Model:**
  * Unique per player (one account per player)
  * Balance: Stores deposited money safely
  * Interest rate: 5% daily (configurable)
  * Auto-created on first access
- **Deposit System:**
  * Validates sufficient cash before deposit
  * Transfers money from player.money to bankAccount.balance
  * Atomic transaction (both updates succeed or fail together)
- **Withdrawal System:**
  * Validates sufficient bank balance
  * Transfers money from bankAccount.balance to player.money
  * Atomic transaction
- **Interest Accrual:**
  * Applied every tick (configurable interval)
  * Formula: Math.floor(balance × 0.05)
  * Logged in tick service output
- **Validation:**
  * Amount must be positive integer
  * Sufficient funds checked (cash for deposit, balance for withdrawal)
  * Auto-creates account if doesn't exist

**API Endpoints:**
```typescript
POST /bank/deposit   - Deposit cash into bank
POST /bank/withdraw  - Withdraw cash from bank
GET /bank/balance    - Get current balance
GET /bank/account    - Get full account info (balance, rate, interest)
```

**Verify:**
```powershell
node test-bank.js  # All 10 tests pass (100% success rate)
```
**Tested:** ✅ All 10 test scenarios pass:
- Login and account auto-creation
- Deposit money (€10,000)
- Withdraw money (€5,000)
- Get account info with interest calculation
- Insufficient cash rejection
- Insufficient balance rejection
- Invalid amounts rejection (negative, zero, decimal, string)
- Multiple transactions (deposit €1k + €2k, withdraw €500)
- Interest calculation (5% daily rate)

**Common Failure:** Negative balance → Fixed: Check player has sufficient cash before deposit

---

### ✅ 8.2 Bank Robberies Impacting Depositors
**What:** Players can rob banks, depositors lose money proportionally

**Files Created:**
- `backend/src/services/bankRobberyService.ts` - Robbery logic, loss distribution ✅
- `backend/test-bank-robbery.js` - Full test suite ✅
- Modified: `backend/src/services/heistService.ts` - Integration with bank_heist ✅

**Implementation Details:**
- **Bank Robbery Trigger:** When "bank_heist" (from heists.json) succeeds, bankRobberyService is called
- **Proportional Loss Distribution:**
  * Calculate total deposits across all bank accounts
  * Stolen percentage = min(heistPayout / totalDeposits, 1.0)
  * Each depositor loses: floor(balance × stolenPercentage)
  * Formula ensures proportional sharing of losses
- **Balance Protection:**
  * Losses capped at account balance (no negative balances)
  * Empty accounts (balance = 0) are skipped
- **World Events:**
  * `bank.robbery_occurred` - Public event with total stolen, depositor count, percentage
  * `bank.depositor_loss` - Individual event for each affected depositor (private)
  * Events include: previousBalance, newBalance, lossAmount, lossPercentage
- **Integration:**
  * Automatically triggered after successful bank_heist
  * Logged in console: "💰 Bank heist impacted X depositors (€Y stolen)"
  * No changes to heist rewards (robbers still get their payout)

**Loss Calculation Example:**
```
Total deposits: €100,000
Heist payout: €150,000 (bank_heist basePayout)
Stolen %: min(150k / 100k, 1.0) = 100% (capped)

Depositor A (€60,000 balance):
- Loss: floor(60,000 × 1.0) = €60,000
- New balance: €0

Depositor B (€40,000 balance):
- Loss: floor(40,000 × 1.0) = €40,000
- New balance: €0
```

**With Smaller Heist:**
```
Total deposits: €500,000
Heist payout: €150,000
Stolen %: 150k / 500k = 0.3 (30%)

Depositor A (€300,000):
- Loss: floor(300,000 × 0.3) = €90,000
- New balance: €210,000

Depositor B (€200,000):
- Loss: floor(200,000 × 0.3) = €60,000
- New balance: €140,000
```

**Verify:**
```powershell
node test-bank-robbery.js  # All 9 tests pass (100% success rate)
```

**Tested:** ✅ All 9 test scenarios pass:
- Setup depositor with bank balance
- Ensure sufficient deposits exist
- Record initial balances
- Proportional loss calculation (0.23% for €150k heist on €65M deposits)
- Large robbery capping (losses limited to 100% of balance)
- World events created for bank operations
- Account info retrieval
- Balance integrity (all non-negative)
- Service endpoint availability

**Common Failure:** Negative depositor balance → Fixed: Cap losses at account balance

---

## Phase 9: International Trade & Contraband

### ✅ 9.1 Country Model (8 Countries)
**What:** Create 8 countries with different prices, travel costs

**Files Created:**
- `backend/content/countries.json` - 8 country definitions ✅
- `backend/prisma/schema.prisma` - currentCountry field added to Player ✅
- `backend/src/services/travelService.ts` - Travel business logic ✅
- `backend/src/routes/travel.ts` - Travel API endpoints ✅
- `backend/add-current-country.sql` - DB migration ✅
- `backend/test-travel-simple.js` - Full test suite ✅

**Implementation Details:**
- **8 Countries:**
  * Netherlands (home base, €0 travel cost)
  * Belgium (€500)
  * Germany (€750)
  * France (€1,000)
  * Spain (€1,500)
  * Italy (€1,750)
  * UK (€1,250)
  * Switzerland (€2,000)
- **Trade Bonuses Per Country:**
  * Each country has unique multipliers for 5 contraband types (0.6x - 1.5x)
  * Example: Switzerland pays 1.5x for diamonds and electronics
  * Example: UK only pays 0.6x for weapons
  * Enables trade arbitrage gameplay (buy low, travel, sell high)
- **Travel System:**
  * Players start in Netherlands (default)
  * POST /travel/:countryId to travel (deducts cost from cash)
  * GET /travel/current to check location
  * GET /travel/countries to list all available countries
  * Validation: Sufficient money, valid country, not already there
- **World Events:**
  * `travel.arrived` - Player traveled to new country
  * Includes: fromCountry, toCountry, travelCost

**API Endpoints:**
```typescript
POST /travel/:countryId  - Travel to specified country
GET /travel/current      - Get current location
GET /travel/countries    - List all countries (unauthenticated)
```

**Verify:**
```powershell
node test-travel-simple.js  # All 8 tests pass (100% success rate)
```

**Tested:** ✅ All 8 test scenarios pass:
- Login successful
- Get all 8 countries
- Get current country (default: netherlands)
- Travel to Belgium (€500 cost)
- Already in country rejection (ALREADY_IN_COUNTRY error)
- Travel to Germany (€750 cost)
- Invalid country rejection (INVALID_COUNTRY error)
- Verify current country after travels (correctly updated to Germany)

**Common Failure:** Invalid country → Fixed: Validate against countries.json before travel

---

### ✅ 9.2 Trade System (Abstract Contraband/Alcohol)
**What:** Players buy/sell abstract goods between countries for profit

**Files Created:**
- `backend/content/tradableGoods.json` - 5 contraband types ✅
- `backend/prisma/schema.prisma` - Inventory model ✅
- `backend/src/services/tradeService.ts` - Buy/sell logic ✅
- `backend/src/routes/trade.ts` - Trade API endpoints ✅
- `backend/add-inventory.sql` - DB migration ✅
- `backend/test-trade.js` - Full test suite ✅

**Implementation Details:**
- **5 Contraband Types:**
  * Bloemen (Flowers): €100 base, max 1000 units
  * Elektronica (Electronics): €500 base, max 500 units
  * Diamanten (Diamonds): €2000 base, max 100 units
  * Wapens (Weapons): €1500 base, max 200 units
  * Farmaceutica (Pharmaceuticals): €800 base, max 300 units
- **Country-Specific Pricing:**
  * Base price × trade bonus from countries.json
  * Example: Flowers in Netherlands = €100 × 0.9 = €90
  * Example: Flowers in Belgium = €100 × 1.0 = €100
  * Example: Diamonds in Switzerland = €2000 × 1.5 = €3000
  * Enables trade arbitrage: Buy low in one country, travel, sell high in another
- **Inventory System:**
  * Each player has unique inventory per good type
  * Tracks quantity owned
  * Maximum capacity per good (prevents hoarding)
  * Auto-created on first purchase
  * Deleted when quantity reaches 0
- **Buy System:**
  * Validates sufficient money
  * Checks inventory capacity
  * Deducts money, adds to inventory (atomic transaction)
  * Creates trade.bought world event
- **Sell System:**
  * Validates sufficient inventory
  * Adds money, removes from inventory (atomic transaction)
  * Creates trade.sold world event
- **Price Calculation:**
  * Uses player's current country location
  * Multiplies basePrice by country's tradeBonus
  * Prices update when player travels
  * Encourages strategic trading across borders

**Trade Arbitrage Example:**
```
1. Start in Netherlands (flowers €90)
2. Buy 100 flowers for €9,000
3. Travel to Belgium (€500 cost)
4. Sell 100 flowers for €10,000 (Belgium price: €100)
5. Net profit: €10,000 - €9,000 - €500 = €500
```

**API Endpoints:**
```typescript
GET /trade/goods       - List all tradable goods
GET /trade/prices      - Get current prices in player's country
GET /trade/inventory   - Get player's inventory
POST /trade/buy        - Buy goods (goodType, quantity)
POST /trade/sell       - Sell goods (goodType, quantity)
```

**Verify:**
```powershell
node test-trade.js  # All 12 tests pass (100% success rate)
```

**Tested:** ✅ All 12 test scenarios pass:
- Login successful
- Get all 5 tradable goods
- Get prices in current country (with trade bonuses applied)
- Buy flowers in Netherlands (€90 per unit)
- Get inventory (shows owned items)
- Buy expensive electronics (€650 per unit in Netherlands)
- Sell flowers in Netherlands
- Insufficient money rejection (can't afford massive diamond purchase)
- Insufficient inventory rejection (can't sell more than owned)
- Invalid good type rejection (contraband_unicorns doesn't exist)
- Price differences between countries (€90 NL vs €100 Belgium for flowers)
- Inventory limit enforcement (can't exceed maxInventory)

**Common Failure:** Price manipulation → Fixed: Validate prices server-side from content

---

### ✅ 9.3 Weapons & Ammunition System
**What:** Expand weapons from abstract tradable good to functional arsenal with specific types and ammo

**Status:** COMPLETE - See PHASE9.3_COMPLETION_REPORT.md

**Weapon Types & Stats:**
```json
{
  "weapons": [
    {
      "id": "knife",
      "name": "Mes",
      "type": "melee",
      "damage": 15,
      "intimidation": 20,
      "requiresAmmo": false,
      "price": 50,
      "requiredRank": 1,
      "suitableFor": ["pickpocket", "mugging", "shoplift"]
    },
    {
      "id": "pistol",
      "name": "Pistool (9mm)",
      "type": "handgun",
      "damage": 40,
      "intimidation": 60,
      "requiresAmmo": true,
      "ammoType": "9mm",
      "magazineCapacity": 15,
      "ammoPerCrime": 3,
      "price": 500,
      "requiredRank": 5,
      "suitableFor": ["robbery", "carjacking", "burglary"]
    },
    {
      "id": "shotgun",
      "name": "Shotgun",
      "type": "shotgun",
      "damage": 75,
      "intimidation": 85,
      "requiresAmmo": true,
      "ammoType": "12gauge",
      "magazineCapacity": 8,
      "ammoPerCrime": 5,
      "price": 1200,
      "requiredRank": 10,
      "suitableFor": ["armed_robbery", "store_heist", "kidnapping"]
    },
    {
      "id": "smg",
      "name": "Automatisch Wapen (MP5)",
      "type": "automatic",
      "damage": 60,
      "intimidation": 90,
      "requiresAmmo": true,
      "ammoType": "9mm",
      "magazineCapacity": 30,
      "ammoPerCrime": 10,
      "price": 3500,
      "requiredRank": 15,
      "suitableFor": ["gang_war", "drug_deal", "arms_dealing"]
    },
    {
      "id": "assault_rifle",
      "name": "Aanvalsgeweer (AK-47)",
      "type": "rifle",
      "damage": 85,
      "intimidation": 95,
      "requiresAmmo": true,
      "ammoType": "762mm",
      "magazineCapacity": 30,
      "ammoPerCrime": 15,
      "price": 8000,
      "requiredRank": 20,
      "suitableFor": ["bank_robbery", "jewelry_heist", "casino_heist"]
    },
    {
      "id": "sniper_rifle",
      "name": "Sluipschuttersgeweer",
      "type": "sniper",
      "damage": 100,
      "intimidation": 75,
      "requiresAmmo": true,
      "ammoType": "308",
      "magazineCapacity": 5,
      "ammoPerCrime": 2,
      "price": 15000,
      "requiredRank": 25,
      "suitableFor": ["assassination", "political_hit"]
    }
  ]
}
```

**Ammunition System:**
```json
{
  "ammo": [
    {
      "type": "9mm",
      "name": "9mm Patronen",
      "pricePerRound": 1,
      "boxSize": 50,
      "maxInventory": 1000
    },
    {
      "type": "12gauge",
      "name": "12 Gauge Shotgun Shells",
      "pricePerRound": 2,
      "boxSize": 25,
      "maxInventory": 500
    },
    {
      "type": "762mm",
      "name": "7.62mm Patronen",
      "pricePerRound": 3,
      "boxSize": 100,
      "maxInventory": 1000
    },
    {
      "type": "308",
      "name": ".308 Winchester",
      "pricePerRound": 5,
      "boxSize": 20,
      "maxInventory": 500
    }
  ]
}
```

**Crime Weapon Requirements:**
Update crimes.json with weapon requirements:
```json
{
  "id": "pickpocket",
  "name": "Zakkenrollen",
  "weaponRequired": false,
  "optionalWeapon": "knife",
  "weaponBonus": {
    "successChance": 0.1,
    "intimidation": true
  }
}
```

```json
{
  "id": "armed_robbery",
  "name": "Gewapende Overval",
  "weaponRequired": true,
  "acceptedWeaponTypes": ["handgun", "shotgun", "automatic"],
  "minDamage": 40,
  "minIntimidation": 60,
  "ammoRequired": 3
}
```

```json
{
  "id": "bank_robbery",
  "name": "Bank Overval",
  "weaponRequired": true,
  "acceptedWeaponTypes": ["automatic", "rifle"],
  "minDamage": 60,
  "minIntimidation": 85,
  "ammoRequired": 15,
  "recommendedWeapon": "assault_rifle"
}
```

```json
{
  "id": "assassination",
  "name": "Moord Op Bestelling",
  "weaponRequired": true,
  "requiredWeaponType": "sniper",
  "minDamage": 100,
  "ammoRequired": 2
}
```

**Database Schema:**
```prisma
model WeaponInventory {
  id        Int      @id @default(autoincrement())
  playerId  Int
  weaponId  String   // Reference to weapons.json
  quantity  Int      @default(1)
  condition Int      @default(100)  // Weapons degrade
  
  player    Player   @relation(fields: [playerId], references: [id], onDelete: Cascade)
  
  @@unique([playerId, weaponId])
  @@map("weapon_inventory")
}

model AmmoInventory {
  id        Int      @id @default(autoincrement())
  playerId  Int
  ammoType  String   // 9mm, 12gauge, etc.
  quantity  Int      @default(0)
  
  player    Player   @relation(fields: [playerId], references: [id], onDelete: Cascade)
  
  @@unique([playerId, ammoType])
  @@map("ammo_inventory")
}
```

**Crime Logic Enhancement:**
- Check if weapon required and player has one
- Verify weapon type matches requirements (handgun for robbery, sniper for assassination)
- Check minimum damage/intimidation stats
- Verify sufficient ammunition for crime
- Consume ammo on crime attempt (success or failure)
- Degrade weapon condition (0.1-1% per use)
- Success chance bonus for correct weapon type (+10-20%)
- Intimidation reduces jail time if caught (-10-30%)
- Broken weapons (condition < 10%) cannot be used

**Error Messages:**
- `WEAPON_REQUIRED`: "Je hebt een wapen nodig voor deze misdaad"
- `WRONG_WEAPON_TYPE`: "Dit wapen type is niet geschikt (vereist: {types})"
- `WEAPON_TOO_WEAK`: "Dit wapen is te zwak (min damage: {min})"
- `NOT_INTIMIDATING_ENOUGH`: "Dit wapen intimideert niet genoeg (min: {min})"
- `NO_AMMO`: "Je hebt geen munitie meer ({ammoType})"
- `INSUFFICIENT_AMMO`: "Je hebt niet genoeg munitie (nodig: {required}, hebt: {current})"
- `WEAPON_BROKEN`: "Dit wapen is kapot en moet gerepareerd worden"

**API Endpoints:**
```typescript
// Weapons
GET /weapons                           - List all weapon types
GET /weapons/inventory                 - Get player's weapons
POST /weapons/buy/:weaponId            - Buy weapon from black market
POST /weapons/sell/:inventoryId        - Sell weapon
POST /weapons/repair/:inventoryId      - Repair weapon (costs money)

// Ammo
GET /ammo/types                        - List all ammo types
GET /ammo/inventory                    - Get player's ammo counts
POST /ammo/buy                         - Buy ammo (ammoType, boxes)
POST /ammo/sell                        - Sell excess ammo
```

**Gameplay Benefits:**
- ✅ Weapons are functional items, not just trade goods
- ✅ Different crimes require different weapons
- ✅ Ammo creates ongoing expense (realism + money sink)
- ✅ Weapon condition degradation encourages maintenance
- ✅ Strategic weapon choice affects success rate
- ✅ High-end crimes require expensive weapons
- ✅ Creates weapon market demand
- ✅ Adds progression: knife → pistol → rifle → sniper
- ✅ Ammo management adds tactical depth
- ✅ Players must plan ammo purchases before crime sprees

**Files Expected:**
- `backend/content/weapons.json` - weapon definitions
- `backend/content/ammo.json` - ammo types
- `backend/src/services/weaponService.ts` - weapon inventory logic
- `backend/src/services/ammoService.ts` - ammo management
- `backend/src/routes/weapons.ts` - weapon API
- `backend/src/routes/ammo.ts` - ammo API
- `backend/prisma/migrations/add_weapons_ammo.sql`

---

## Phase 10: Aviation Endgame

### ✅ 10.1 Aircraft Model & Licensing
**What:** High-level players can buy aircraft, requires license

**Files Created:**
- `backend/content/aircraft.json` - 6 aircraft types ✅
- `backend/prisma/schema.prisma` - Aircraft, AviationLicense models ✅
- `backend/src/services/aviationService.ts` - License and aircraft purchase logic ✅
- `backend/src/routes/aviation.ts` - Aviation API endpoints ✅
- `backend/add-aviation.sql` - DB migration ✅
- `backend/test-aviation.js` - Full test suite ✅

**Implementation Details:**
- **3 License Types:**
  * Basic: €100,000 (min rank 20) - Required for light aircraft
  * Commercial: €500,000 (min rank 30) - Required for business jets
  * Cargo: €1,000,000 (min rank 40) - Required for cargo aircraft
  * One license per player (covers all aircraft types)
  * Cannot buy aircraft without license
- **6 Aircraft Types:**
  * Cessna 172 Skyhawk: €250,000 (rank 20) - Light aircraft, 1000 km range
  * Beechcraft King Air 350: €750,000 (rank 25) - Turboprop, 2500 km range
  * Cessna Citation X: €2,000,000 (rank 30) - Business jet, 5000 km range
  * Gulfstream G650: €5,000,000 (rank 35) - Luxury jet, 12000 km range
  * Boeing 737-800F Cargo: €8,000,000 (rank 40) - Cargo jet, 6000 km range
  * Antonov An-225 Mriya: €25,000,000 (rank 50) - Super heavy cargo, 15000 km range
- **Aircraft Properties:**
  * Fuel capacity (200-10000 liters)
  * Max range (1000-15000 km)
  * Cargo capacity (100-25000 units)
  * Speed multiplier (1.5x-3.5x travel speed)
  * Repair cost (€25k-€2.5M)
  * Starts with 0 fuel (must refuel before flight)
  * Tracks total flights
  * Can break down (isBroken flag)
- **License Purchase:**
  * Validates rank requirement
  * Validates sufficient money
  * One-time purchase (cannot buy duplicate)
  * Creates aviation.license_purchased world event
- **Aircraft Purchase:**
  * Requires valid license
  * Validates rank requirement (per aircraft)
  * Validates sufficient money
  * Players can own multiple aircraft
  * Creates aviation.aircraft_purchased world event

**Aircraft Progression:**
```
Rank 20: Buy basic license (€100k) → Cessna 172 (€250k)
Rank 25: Beechcraft King Air 350 (€750k)
Rank 30: Buy commercial license (€500k) → Citation X (€2M)
Rank 35: Gulfstream G650 (€5M)
Rank 40: Buy cargo license (€1M) → Boeing 737 Cargo (€8M)
Rank 50: Antonov An-225 (€25M) - Ultimate endgame aircraft
```

**API Endpoints:**
```typescript
GET /aviation/aircraft       - List all aircraft types
GET /aviation/licenses       - Get license pricing and requirements
GET /aviation/my-license     - Get player's license
GET /aviation/my-aircraft    - Get player's aircraft
POST /aviation/buy-license   - Purchase license (licenseType)
POST /aviation/buy-aircraft  - Purchase aircraft (aircraftType)
```

**Verify:**
```powershell
node test-aviation.js  # All 13 tests pass (100% success rate)
```

**Tested:** ✅ All 13 test scenarios pass:
- Login successful (rank 25 player)
- Get all 6 aircraft types
- Get 3 license types with pricing
- Check no license initially
- Insufficient money handling (optional check)
- Buy basic aviation license (€100,000)
- Verify license was purchased
- Duplicate license rejection (ALREADY_HAS_LICENSE)
- No license check (skipped - already have license)
- Buy Cessna 172 (€250,000)
- Get my aircraft (shows 0/200 fuel, 0 flights)
- Invalid aircraft type rejection (spaceship doesn't exist)
- Rank too low rejection (Antonov requires rank 50)

**Common Failure:** Buy without license → Fixed: Check license before allowing purchase

---

### ✅ 10.2 Global Flight Caps & Restrictions
**What:** Limit total flights per day to prevent abuse

**Files Created:**
- `backend/src/config/index.ts` - maxFlightsPerDay: 100 (global limit) ✅
- `backend/src/services/aviationService.ts` - getTodaysFlightCount(), flight cap enforcement ✅

**Implementation Details:**
- **Daily Flight Cap:** 100 flights per day (global limit across all players)
- **Cap Enforcement:**
  * getTodaysFlightCount() aggregates all aircraft.totalFlights since midnight
  * Checked before every flight in flyToDestination()
  * Returns FLIGHT_CAP_REACHED error when limit exceeded
- **Flight Tracking:**
  * Aircraft.totalFlights incremented after each successful flight
  * Used for daily cap calculation (sum of today's flights)
  * Persists across server restarts
- **Configuration:**
  * `config.maxFlightsPerDay = 100` - Adjustable global limit
  * Cap applies to all players combined (prevents system-wide abuse)

**Verify:**
```powershell
# Included in test-flights.js
```
**Expected:** Flight rejected when daily cap reached (FLIGHT_CAP_REACHED)

**Tested:** ✅ Cap enforcement logic verified

---

### ✅ 10.3 Public Flight Alerts
**What:** All flights shown in world feed for transparency

**Files Created:**
- `backend/src/services/aviationService.ts` - Public flight events ✅
- `backend/src/routes/aviation.ts` - POST /aviation/refuel/:id, POST /aviation/fly/:id ✅
- `backend/test-flights.js` - Full flight system test suite ✅

**Implementation Details:**
- **Flight System:**
  * **Refueling:**
    - Cost: €50 per liter (FUEL_COST_PER_LITER)
    - Validates player owns aircraft, aircraft not broken
    - Cannot exceed maxFuel capacity
    - Returns ALREADY_FULL if tank full
    - Creates aviation.refueled event (private to player)
  * **Flying:**
    - Fuel consumption: Fixed 100 liters per flight (simplified model)
    - Validates sufficient fuel (100L minimum)
    - Validates destination is valid country (from countries.json)
    - Rejects if already at destination
    - Updates player.currentCountry to destination
    - Increments aircraft.totalFlights for cap tracking
    - Creates PUBLIC aviation.flight event (playerId=null)
- **Public Transparency:**
  * Every flight creates public world event visible to ALL players
  * Event includes:
    - Player name
    - Aircraft type and name
    - From country
    - To country
    - Fuel used
  * playerId set to `null` for public visibility
  * Prevents secret operations and maintains fair play
- **API Endpoints:**
  ```typescript
  POST /aviation/refuel/:aircraftId   - Refuel aircraft (amount)
  POST /aviation/fly/:aircraftId      - Fly to destination (destination)
  ```

**Verify:**
```powershell
node test-flights.js  # All 11 tests pass (100% success rate)
```

**Tested:** ✅ All 11 test scenarios pass:
- Refuel aircraft with 100 liters (€5,000)
- Reject refuel with invalid amount (negative, non-integer)
- Reject refuel for non-existent aircraft
- Reject refuel when tank is full (ALREADY_FULL)
- Fly to Belgium (100L fuel consumed, location updated)
- Reject flight with insufficient fuel (<100L)
- Reject flight to current location (ALREADY_AT_DESTINATION)
- Reject flight to invalid destination (atlantis)
- Flight creates public aviation.flight event (playerId=null)
- Location updates after flight (currentCountry changed)
- Daily flight cap prevents excessive flights (logic verified)

**Flight Economics:**
```
Refuel cost: €50/liter
Flight consumption: 100 liters
Cost per flight: €5,000 (fuel only, doesn't include aircraft purchase)
Example: Cessna 172 (200L tank) = 2 flights per tank = €10,000 to fill
```

**Common Failure:** Events not visible → Fixed: Set playerId=null for public events

---

## Phase 11: Flutter Client (Web + Android)

### ✅ 11.1 Flutter Project Setup
**What:** Initialize Flutter project, configure for web + Android

**Status:** ✅ COMPLETED
- Flutter 3.38.7 project initialized
- Web and Android platforms configured
- Dependencies: provider, http, flutter_secure_storage, intl, json_annotation

**Files Created:**
- `client/pubspec.yaml`
- `client/lib/main.dart`
- `client/web/index.html`
- `client/analysis_options.yaml`

**Verified:** ✅ App runs on Chrome (port 8080)

---

### ✅ 11.2 API Client & Authentication  
**What:** HTTP client to call backend, store JWT token

**Status:** ✅ COMPLETED
- ApiClient with automatic token injection
- AuthService with login/register/logout
- Secure token storage using flutter_secure_storage
- Player model with JSON serialization

**Files Created:**
- `client/lib/services/api_client.dart` - HTTP wrapper with auth headers
- `client/lib/services/auth_service.dart` - login, register, token storage  
- `client/lib/models/player.dart` - Player model with nullable fields
- `client/lib/models/player.g.dart` - Generated JSON serialization
- `client/lib/providers/auth_provider.dart` - State management with ChangeNotifier
- `client/lib/config/app_config.dart` - API base URL configuration

**Verified:** ✅ Login works, token stored, authenticated API calls succeed

**Fixes Applied:**
- Made Player fields optional (wantedLevel, fbiHeat, currentCountry, dates) to handle partial backend responses
- Added updatePlayerStats() method to AuthProvider for real-time stat updates without full API refresh

---

### ✅ 11.3 I18n Setup (NL + EN)
**What:** Add flutter_localizations, create ARB files for Dutch and English

**Status:** ✅ COMPLETED  
- Custom AppLocalizations implementation (workaround for flutter_gen limitations)
- Dutch (NL) and English (EN) translations
- Locale switching support

**Files Created:**
- `client/lib/l10n/l10n.dart` - Custom AppLocalizations with manual string definitions
- `client/l10n.yaml` - Configuration file

**Verified:** ✅ Translations work, language switching functional

**Note:** Used custom implementation instead of flutter_gen due to build complexity

---

### ✅ 11.4 Event Rendering (eventKey + params)
**What:** Parse server events (eventKey + params), render localized strings

**Status:** ✅ COMPLETED
- EventRenderer service with EN/NL translations
- Handles 40+ event types: auth, crime, job, travel, bank, property, crew, heist, hospital, police, FBI, errors
- Dynamic parameter interpolation

**Files Created:**
- `client/lib/services/event_renderer.dart` - renderEvent(eventKey, params, locale) → localized string

**Event Types Implemented:**
- **Auth**: login, registered, logout
- **Crime**: success, failed, jailed (with reward, xpGained, crimeName params)
- **Job**: completed, error (with earnings, xpGained, cooldown params)  
- **Travel**: departed, arrived (with destination, cost params)
- **Bank**: deposit, withdraw
- **Property**: purchased, sold, rented, upgraded
- **Crew**: created, joined, left, promoted, kicked
- **Heist**: started, success, failed
- **Hospital**: healed
- **Police**: arrested, released, bailed
- **FBI**: investigated, cleared
- **Errors**: generic error handling

**Verified:** ✅ All events render correctly with localized strings and parameter substitution

**Fixes Applied:**
- Fixed crime event to use 'reward' and 'xpGained' params (not 'money' and 'xp')
- Added job.error handling for INVALID_JOB_ID, LEVEL_TOO_LOW, ON_COOLDOWN
- Added job.completed event (backend sends this instead of job.success)

---

### ✅ 11.5 UI Screens (Dashboard, Crime, Jobs, Travel, Crew)
**What:** Build main app screens with navigation

**Status:** ✅ COMPLETED
- All core screens implemented with Material Design
- Real-time stat updates via Provider
- Event-based feedback with SnackBars
- Responsive layouts

**Files Created:**
- `client/lib/screens/login_screen.dart` - Login/Register with form validation
- `client/lib/screens/dashboard_screen.dart` - Main hub with player stats, navigation buttons
- `client/lib/screens/crime_screen.dart` - Crime list with rank filtering, vehicle requirements, federal warnings
- `client/lib/screens/jobs_screen.dart` - Job list with cooldown display, earnings preview  
- `client/lib/screens/travel_screen.dart` - Country list with cost display, current location highlighting
- `client/lib/screens/crew_screen.dart` - Placeholder "Coming soon" screen
- `client/lib/main.dart` - App entry with AuthWrapper (shows LoginScreen or DashboardScreen)

**Models Created:**
- `client/lib/models/crime.dart` - Crime model with @JsonKey annotations for field mapping
- `client/lib/models/job.dart` - Job model with minPay/maxPay, cooldown
- `client/lib/models/country.dart` - Country model with custom fromJson for null safety

**Verified:** ✅ All screens functional, navigation works, data loads from API

**Fixes Applied:**
- Updated Crime model: minLevel→requiredRank, minReward→minPay, maxReward→maxPay, added baseSuccessChance, jailTime, breakdownChance
- Updated Job model: minLevel→requiredRank, minEarnings→minPay, maxEarnings→maxPay, added cooldownMinutes
- Updated Country model: travelCost→flightCost, custom fromJson with null fallbacks
- Fixed API endpoints: POST /crimes/:id/attempt, POST /jobs/:id/work
- Fixed travel response parsing (uses 'message' field directly, not 'event' structure)
- Added IntExtensions.toLocaleString() for number formatting with thousand separators

**API Integration:**
- Crimes: GET /crimes/available, POST /crimes/:crimeId/attempt
- Jobs: GET /jobs/available, POST /jobs/:jobId/work
- Travel: GET /travel/countries, POST /travel/:countryId
- All endpoints tested and working

---

### ✅ 11.6 Real-time Events (SSE or WebSocket)
**What:** Subscribe to server events, update UI live

**Status:** ✅ COMPLETED
- SSE client with automatic reconnection (exponential backoff)
- Event provider for state management
- Live event feed widget with real-time updates
- Integration with dashboard screen

**Files Created:**
- `client/lib/services/event_stream_service.dart` - SSE client that connects to `/events/stream`, handles SSE protocol, parses `data: {json}` format, provides Stream<Map<String, dynamic>>
- `client/lib/providers/event_provider.dart` - EventProvider (ChangeNotifier) that subscribes to EventStreamService, stores last 100 events, broadcasts to widgets
- `client/lib/widgets/event_feed.dart` - EventFeed widget that displays live events with icons, timestamps, EventRenderer for localized messages

**Implementation Details:**
- **EventStreamService**: Uses http.Client to create persistent SSE connection, transforms utf8 stream into JSON events, handles connection errors with exponential backoff (1s → 2s → 4s → ... max 30s), max 10 reconnect attempts
- **EventProvider**: Singleton pattern via Provider, stores WorldEvent list (newest first), limits to 100 events, notifies listeners on new events
- **EventFeed**: ListView with event icons (crime→warning, job→work, travel→flight, etc.), relative timestamps ("Just now", "5 minutes ago"), connection status indicator (wifi icon green/grey)
- **Dashboard Integration**: Connects to SSE on mount, displays last 10 events in card, shows connection status

**Verified:** ✅ Events appear in real-time without refresh

**Testing:**
```powershell
# Terminal 1: Start backend
cd backend
npm run dev

# Terminal 2: Trigger test event
npx tsx trigger-test-event.ts

# Expected: Event appears in dashboard feed within 1 second
```

**Features:**
- ✅ Real-time event streaming via SSE
- ✅ Automatic reconnection with exponential backoff
- ✅ Event history (last 100 events)
- ✅ Localized event rendering (EN/NL)
- ✅ Visual connection status indicator
- ✅ Event type icons and colors
- ✅ Relative timestamps ("5 minutes ago")

**Common Issues:**
- Connection not established → Check backend is running on port 3000
- Events not appearing → Check browser DevTools console for SSE errors
- Old events → EventProvider keeps last 100 events, use clearEvents() to reset

---

### ✅ 11.6.5 Cooldown Overlay UI ⏳
**What:** Full-screen overlay showing cooldown timer (similar to jail overlay) with cartoon and countdown

**Status:** ✅ COMPLETED

**Purpose:** 
- Show when action is on cooldown (crime, job, travel, heist, appeal)
- Display remaining time with live countdown
- Prevent spam with visual feedback
- Match jail overlay UX pattern

**Features:**
- **Full-Screen Overlay**: Modal overlay covering entire screen
- **Countdown Timer**: Live countdown in MM:SS or HH:MM:SS format
- **Action Type Display**: Show which action is on cooldown ("Crime Cooldown", "Job Cooldown", etc.)
- **Cartoon Image**: Themed cartoon matching cooldown type:
  - Crime cooldown → cartoon character waiting/bored
  - Job cooldown → character resting/tired
  - Travel cooldown → character at airport/waiting
  - Heist cooldown → character planning/preparing
- **Auto-Dismiss**: Overlay disappears when cooldown expires
- **Manual Dismiss**: Button to close overlay (doesn't skip cooldown)
- **Live Updates**: Timer refreshes every second

**Cooldown Types:**
- ⚠️ **Crime**: 5min - 2hr (dynamic based on reward)
- 💼 **Job**: 30 minutes
- ✈️ **Travel**: 2 hours
- 💰 **Heist**: 6 hours
- ⚖️ **Appeal**: 4 hours

**Design:**
- Similar structure to `jail_overlay.dart`
- Centered card with rounded corners
- Large timer display (48px font)
- Action icon + name
- Cartoon image (300x300px)
- Countdown in bold red text
- "Come back later" message
- Dismiss button (returns to previous screen)

**Files Expected:**
- `client/lib/widgets/cooldown_overlay.dart` - Overlay widget with timer logic
- `client/lib/models/cooldown_info.dart` - Model with actionType, remainingSeconds, expiresAt
- `client/assets/images/cooldowns/crime_wait.png` - Crime cooldown cartoon
- `client/assets/images/cooldowns/job_rest.png` - Job cooldown cartoon
- `client/assets/images/cooldowns/travel_airport.png` - Travel cooldown cartoon
- `client/assets/images/cooldowns/heist_planning.png` - Heist cooldown cartoon
- `client/assets/images/cooldowns/appeal_waiting.png` - Appeal cooldown cartoon

**Implementation:**
```dart
// Usage example
if (response.statusCode == 429) {
  final remainingSeconds = response.data['params']['remainingSeconds'];
  final actionType = response.data['params']['actionType'] ?? 'crime';
  
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CooldownOverlay(
        actionType: actionType,
        remainingSeconds: remainingSeconds,
      ),
    ),
  );
}
```

**Timer Logic:**
```dart
class CooldownOverlay extends StatefulWidget {
  final String actionType; // 'crime', 'job', 'travel', 'heist', 'appeal'
  final int remainingSeconds;
  
  @override
  _CooldownOverlayState createState() => _CooldownOverlayState();
}

class _CooldownOverlayState extends State<CooldownOverlay> {
  late int _secondsLeft;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.remainingSeconds;
    _startCountdown();
  }
  
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        Navigator.of(context).pop(); // Auto-dismiss
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }
  
  String _formatTime() {
    final hours = _secondsLeft ~/ 3600;
    final minutes = (_secondsLeft % 3600) ~/ 60;
    final seconds = _secondsLeft % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

**Cartoon Images:**
- Style: Hand-drawn mafia cartoon style
- Size: 300x300px PNG with transparency
- Theme: Character showing waiting/boredom/preparation
- Examples:
  - Crime: Gangster tapping watch impatiently
  - Job: Worker sleeping on desk
  - Travel: Character at airport reading newspaper
  - Heist: Crew around table with blueprints

**Verify:**
- Attempt crime while on cooldown (should show overlay)
- Timer counts down correctly (updates every second)
- Auto-dismiss when timer reaches 0:00
- Manual dismiss button works (overlay closes)
- Correct cartoon displays for each action type
- Time format changes based on duration (minutes vs hours)

**Files Created:**
- ✅ `client/lib/models/cooldown_info.dart` - Model with actionType, remainingSeconds, expiresAt
- ✅ `client/lib/widgets/cooldown_overlay.dart` - Full-screen overlay with timer widget
- ✅ Updated `client/lib/screens/crime_screen.dart` - Integration with cooldown overlay

**Implementation Details:**
- **CooldownInfo Model**: Stores action type, remaining seconds, expiration time
  - getActionName(locale): Returns localized action name (NL/EN)
  - getImagePath(): Returns cartoon image path (placeholder for now)
  - getIcon(): Returns emoji icon for action type
  
- **CooldownOverlay Widget**: 
  - Full-screen modal with centered card
  - Live countdown timer (updates every second)
  - Auto-dismiss when timer expires
  - Manual dismiss button
  - Icon placeholder (will use cartoon images later)
  - Time formatting: HH:MM:SS for hours, MM:SS for minutes
  - Localized messages (NL/EN)

- **Crime Screen Integration**:
  - Checks for error.cooldown event key
  - Extracts remainingSeconds from response params
  - Navigates to CooldownOverlay as fullscreen dialog
  - Prevents spam by showing visual feedback

**Verified:** ✅ 
- App compiles and runs on Chrome (port 8080)
- Backend running on port 3000
- Cooldown overlay shows when attempting crime while on cooldown
- Timer counts down correctly (1 second intervals)
- Auto-dismisses when reaching 0:00
- Manual dismiss button works
- Localized for Dutch and English

**Next Steps:**
- Add cartoon images to `client/assets/images/cooldowns/` folder
- Integrate overlay into jobs screen
- Integrate overlay into travel screen
- Integrate overlay into heist screen
- Integrate overlay into appeal screen

**Integration Points:**
- ✅ Crime screen: Check cooldown before attempt, show overlay on 429 error
- ☐ Job screen: Check cooldown before work, show overlay on 429 error
- ☐ Travel screen: Check cooldown before travel, show overlay on 429 error
- ☐ Heist screen: Check cooldown before heist, show overlay on 429 error
- ☐ Appeal screen: Check cooldown before appeal, show overlay on 429 error

---

### ✅ 11.7 Property Management UI 🏠
**What:** Build property screen for buying/upgrading houses, businesses, income collection

**Status:** COMPLETE - Property UI implemented with buy/upgrade/collect functionality

**Features:**
- **Available Properties View**: Grid of claimable properties with cartoon images
- **My Properties View**: Owned properties with upgrade levels, income stats
- **Land-Specific Businesses**: Casino (1 per country), Warehouse, Nightclub, etc.
- **Claim/Buy Property**: Purchase available property (if not owned by another player)
- **Upgrade Property**: Increase income generation, unlock features
- **Collect Income**: Button to collect passive income (hourly/daily)
- **Property Loss**: Auto-forfeit if dead or jailed >24 hours

**Property Types:**
- 🏠 **House**: Small passive income, cheap, unlimited per country
- 🏪 **Warehouse**: Store tradable goods, medium income
- 🎰 **Casino**: 1 per country, high income + mini-games (players can gamble)
- 🏨 **Hotel**: Tourist income based on country traffic
- 🏭 **Factory**: Produces tradable goods automatically

**Files Expected:**
- `client/lib/screens/property_screen.dart` - main property UI
- `client/lib/models/property.dart` - Property model
- `client/lib/widgets/property_card.dart` - displays property image + stats
- `client/assets/images/properties/` - cartoon images (house, casino, warehouse, etc.)

**Verify:**
- View available properties in current country
- Buy property (money deducted, property claimed)
- Upgrade property (level increases, income boost)
- Collect income (money added to wallet)

---

### ✅ 11.8 Casino Mini-Games 🎰
**What:** Interactive casino where players gamble, owner gets cut of profits

**Mini-Games:**
- ✅ 🎰 **Slot Machine**: Spin, match symbols, win multiplier (2x-100x)
- ✅ 🃏 **Blackjack**: Play against dealer, 2.5x payout for blackjack
- ✅ 🎡 **Roulette**: Bet on red/black/even/odd, 2x payout, number 35x
- ✅ 🎲 **Dice Roll**: High/low betting, 2x payout, exact total 6x

**Mechanics:**
- **Player Perspective**: Visit casino lobby, choose game, place bet
- **Generic Casino**: Standalone games without property requirement (for testing)
- **Crypto-Secure RNG**: Uses randomBytes for fair results
- **Animations**: Spinning reels, rolling dice, rotating wheel
- **Win/Loss Dialogs**: Show results with payout breakdown

**Backend:**
- Casino games run on server (anti-cheat)
- Generic endpoints: /casino/slots/spin, /blackjack/play, /roulette/spin, /dice/roll
- Property-based endpoints also exist for casino properties
- Balance updates with profit/loss tracking

**Files Created:**
- ✅ `client/lib/screens/casino_screen.dart` - casino lobby with game grid
- ✅ `client/lib/screens/games/slot_machine_screen.dart` - 3 reels, paytable
- ✅ `client/lib/screens/games/blackjack_screen.dart` - cards display
- ✅ `client/lib/screens/games/roulette_screen.dart` - spinning wheel
- ✅ `client/lib/screens/games/dice_screen.dart` - 2 dice with symbols
- ✅ `backend/src/routes/casino.ts` - generic game endpoints
- ✅ `backend/src/services/casinoService.ts` - game logic already existed

**Verified:**
- ✅ All 4 games work correctly
- ✅ Money deducted/added based on results
- ✅ Animations play smoothly
- ✅ Win/loss dialogs display correct amounts

---

### ☐ 11.9 Trade Market UI 🔫💊
**What:** Build market screen for buying/selling tradable goods (wapens, drugs, etc.)

**Features:**
- **Market Listings**: Display goods for sale with prices (varies by country)
- **Buy Goods**: Purchase up to inventory limit, price depends on country multipliers
- **Sell Goods**: Sell at current market price (profit from arbitrage)
- **Price Fluctuations**: Prices change based on demand (backend tick system)
- **Country Multipliers**: Some countries pay more for certain goods
  - Example: Wapens worth 1.8x in USA, 0.6x in UK
- **Inventory View**: Show owned goods with quantity, purchase price, current value

**Tradable Goods:**
- 🔫 Wapens (Weapons): €1500 base
- 💊 Drugs: €800 base
- 💎 Diamonds: €5000 base
- 🚬 Sigaretten: €200 base

**Files Expected:**
- `client/lib/screens/trade_screen.dart` - market UI
- `client/lib/models/tradable_good.dart` - Good model
- `client/assets/images/goods/` - cartoon images (gun, pills, diamond, etc.)

**Verify:**
- View market prices in current country
- Buy goods (money deducted, inventory updated)
- Travel to different country
- Sell goods at higher price (profit!)

---

### ☐ 11.10 Court & Judge System UI ⚖️
**What:** Build court screen for appealing sentences, bribing judges

**Features:**
- **Active Sentence View**: Show current jail time, crime, judge assigned
- **Appeal Sentence**: Request reduction (costs €10k, success chance based on judge corruptibility)
- **Bribe Judge**: Pay €50k-200k to reduce sentence or dismiss charges
- **Judge Info**: Display judge name, corruptibility level, success rate
- **Appeal History**: Log of past appeals (approved/denied)

**Mechanics:**
- **Automatic Judge Assignment**: When arrested, random judge assigned from pool
- **Corruptibility**: Ranges from 10% (honest) to 90% (corrupt)
- **Bribe Success**: Higher bribe = higher success chance (max 90%)
- **Sentence Reduction**: If appeal succeeds, jail time reduced by 50%

**Files Expected:**
- `client/lib/screens/court_screen.dart` - main court UI
- `client/lib/models/judge.dart` - Judge model
- `client/lib/widgets/appeal_dialog.dart` - confirmation dialog with success estimate

**Backend:**
- Already implemented in Phase 7.3 ✅
- Routes: GET /judges, POST /judges/appeal/:attemptId, POST /judges/bribe/:attemptId

**Verify:**
- Get arrested (jail time assigned)
- View assigned judge
- Appeal sentence (50% reduction if success)
- Bribe judge (high chance of dismissal)

---

### ☐ 11.11 Hospital UI 🏥
**What:** Build hospital screen for healing injuries

**Features:**
- **Health Status**: Display current health % with visual health bar
- **Injury Types**: Show injury description (gunshot, beaten, car crash)
- **Heal Options**:
  - Full Heal: €10,000 (restore to 100%)
  - Partial Heal: €5,000 (restore 50%)
  - Free Clinic: Free, restore 20%, 24h cooldown
- **Death Prevention**: Auto-redirect to hospital if health < 10%
- **Cost Calculator**: Show exact cost based on health missing

**Mechanics:**
- **Health < 50%**: Warning notification "Visit hospital!"
- **Health < 10%**: Critical alert, can't do crimes/jobs
- **Death at 0%**: Lose properties, respawn with 50% health
- **Insurance**: Optional €1000/week, covers 50% of heal costs

**Files Expected:**
- `client/lib/screens/hospital_screen.dart` - main hospital UI
- `client/lib/widgets/health_bar.dart` - visual health indicator
- `client/assets/images/hospital.png` - cartoon hospital building

**Backend:**
- Already implemented in Phase 1.3 ✅
- Route: POST /hospital/heal

**Verify:**
- Get injured (health drops to 40%)
- Visit hospital screen
- Choose "Full Heal" option
- Health restored to 100%, money deducted

---

## Phase 12: Vehicle Trading & Garage System 🚗⚓

### ✅ 12.1 Database Schema - Garage & Marina
**What:** Extend database with vehicle inventory, garages, marinas

**Database Tables:**
- `garages` - playerId, capacity (upgradeable), location (countryId)
- `marinas` - playerId, capacity (upgradeable), location (countryId)
- `vehicle_inventory` - id, playerId, vehicleType (car/boat), vehicleId (from vehicles.json), stolenInCountry, currentLocation, condition (%), fuelLevel (%)
- `garage_upgrades` - garageId, upgradeLevel, capacityBonus, upgradeCost
- `marina_upgrades` - marinaId, upgradeLevel, capacityBonus, upgradeCost

**Files Expected:**
- `backend/prisma/migrations/add_vehicle_inventory.sql`
- `backend/prisma/schema.prisma` - updated with new models

**Verify:**
```sql
SELECT * FROM garages WHERE playerId = 1;
SELECT * FROM vehicle_inventory WHERE playerId = 1;
```

---

### ✅ 12.2 Vehicle Content Data
**What:** Extend vehicles.json with vehicle types, stats, and crime requirements

**Vehicle Types & Stats:**
```json
{
  "cars": [
    {
      "id": "toyota_corolla",
      "name": "Toyota Corolla",
      "type": "standard",
      "image": "toyota_corolla.png",
      "stats": {
        "speed": 60,           // 0-100 scale
        "armor": 10,           // 0-100 scale
        "cargo": 30,           // 0-100 scale
        "stealth": 70          // 0-100 scale (conspicuousness)
      },
      "availableInCountries": ["NL", "BE", "DE"],
      "baseValue": 15000,
      "marketValue": {
        "NL": 15000,
        "BE": 16000,
        "DE": 14500,
        "US": 22000
      },
      "fuelCapacity": 50,
      "requiredRank": 1
    },
    {
      "id": "sports_car",
      "name": "Ferrari 458",
      "type": "speed",
      "image": "ferrari.png",
      "stats": {
        "speed": 95,
        "armor": 15,
        "cargo": 10,
        "stealth": 30          // Very conspicuous
      },
      "baseValue": 250000,
      "requiredRank": 15
    },
    {
      "id": "armored_suv",
      "name": "Gepantserde Mercedes G-Klasse",
      "type": "armored",
      "image": "armored_suv.png",
      "stats": {
        "speed": 50,
        "armor": 90,           // Bulletproof
        "cargo": 40,
        "stealth": 20          // Very conspicuous
      },
      "baseValue": 500000,
      "requiredRank": 20
    },
    {
      "id": "delivery_van",
      "name": "Mercedes Sprinter",
      "type": "cargo",
      "image": "van.png",
      "stats": {
        "speed": 40,
        "armor": 5,
        "cargo": 95,           // Large cargo space
        "stealth": 80          // Looks normal
      },
      "baseValue": 35000,
      "requiredRank": 8
    },
    {
      "id": "old_sedan",
      "name": "Oude Volkswagen Golf",
      "type": "stealth",
      "image": "old_car.png",
      "stats": {
        "speed": 45,
        "armor": 5,
        "cargo": 25,
        "stealth": 95          // Completely inconspicuous
      },
      "baseValue": 3000,
      "requiredRank": 1
    }
  ],
  "boats": [
    {
      "id": "speedboat",
      "name": "Miami Speedboat",
      "type": "speed",
      "image": "speedboat.png",
      "stats": {
        "speed": 90,
        "armor": 10,
        "cargo": 20,
        "stealth": 40
      },
      "baseValue": 85000,
      "requiredRank": 12
    }
  ]
}
```

**Crime Vehicle Requirements:**
Update crimes.json to include vehicle requirements:
```json
{
  "id": "bank_robbery",
  "name": "Bank Overval",
  "requiredVehicle": true,
  "vehicleRequirements": {
    "minSpeed": 70,        // Need fast getaway car
    "minArmor": 40,        // Bulletproof helpful
    "preferredTypes": ["speed", "armored"]
  }
}
```

```json
{
  "id": "smuggling",
  "name": "Smokkel",
  "requiredVehicle": true,
  "vehicleRequirements": {
    "minCargo": 60,        // Need cargo space
    "minStealth": 50,      // Don't be conspicuous
    "preferredTypes": ["cargo", "stealth"]
  }
}
```

```json
{
  "id": "arms_dealing",
  "name": "Wapenhandel",
  "requiredVehicle": true,
  "vehicleRequirements": {
    "minCargo": 70,        // Lots of weapons
    "minArmor": 30,        // Protection from rivals
    "preferredTypes": ["cargo", "armored"]
  }
}
```

**Crime Logic Enhancement:**
- Check vehicle stats match requirements
- Success chance bonus if using preferred vehicle type
- Speed affects escape chance (higher speed = better escape)
- Armor reduces damage on failed escape
- Cargo capacity determines how much you can steal
- Stealth affects detection chance (higher stealth = less likely caught)

**Error Messages:**
- `VEHICLE_TOO_SLOW`: "Dit voertuig is te langzaam voor deze misdaad"
- `VEHICLE_NO_ARMOR`: "Je hebt een gepantserd voertuig nodig"
- `VEHICLE_NO_CARGO`: "Je hebt een voertuig met meer laadruimte nodig"
- `VEHICLE_TOO_CONSPICUOUS`: "Dit voertuig valt te veel op"

**Files Expected:**
- `backend/content/vehicles.json` - vehicle definitions with stats
- `backend/content/crimes.json` - updated with vehicleRequirements
- `client/assets/images/vehicles/` - vehicle images

**Gameplay Benefits:**
- ✅ Strategic vehicle choice matters
- ✅ Different crimes require different vehicles
- ✅ Players build vehicle collection for various crimes
- ✅ High-end crimes require expensive specialized vehicles
- ✅ Adds depth to vehicle stealing mechanics
- ✅ Creates vehicle trading market demand

---

### ✅ 12.3 Backend - Vehicle Inventory API
**What:** Routes for stealing, storing, viewing, selling vehicles

**API Endpoints:**
- `POST /vehicles/steal/:vehicleId` - Steal vehicle (success chance based on rank), add to inventory
- `GET /vehicles/inventory` - Get player's stolen vehicles
- `GET /garage/status` - Get garage capacity, current vehicles stored
- `POST /garage/upgrade` - Upgrade garage capacity (costs money)
- `GET /marina/status` - Get marina capacity, boats stored
- `POST /marina/upgrade` - Upgrade marina capacity
- `POST /vehicles/sell/:inventoryId` - Sell vehicle on black market (price = marketValue × condition)
- `POST /vehicles/transport/:inventoryId` - Ship/fly vehicle to another country (costs money/time)

**Services:**
- `backend/src/services/vehicleService.ts` - stealVehicle(), sellVehicle(), calculateMarketPrice()
- `backend/src/services/garageService.ts` - getGarageStatus(), upgradeGarage(), storeVehicle()

**Files Expected:**
- `backend/src/routes/vehicles.ts`
- `backend/src/routes/garage.ts`
- `backend/src/routes/marina.ts`

---

### ✅ 12.4 Backend - Black Market & Transport
**What:** Implement vehicle market and inter-country transport

**Features:**
- **Black Market**: Buy/sell vehicles with dynamic pricing based on:
  - Country (rare vehicles worth more abroad)
  - Condition (damaged vehicles worth less)
  - Market demand (fluctuates daily)
- **Transport Options**:
  - **Shipping**: €5000, 24 hours delay (boats only)
  - **Flight Transport**: €15000, instant (cars only, small planes)
  - **Drive/Sail**: Free, uses fuel, risk of police interception

**API Endpoints:**
- `GET /market/vehicles` - List vehicles for sale (by other players or NPC)
- `POST /market/buy/:listingId` - Buy vehicle from market
- `POST /market/list/:inventoryId` - List your vehicle for sale (set price)
- `POST /transport/ship/:inventoryId/:destinationCountry` - Ship vehicle (24h delay)
- `POST /transport/fly/:inventoryId/:destinationCountry` - Fly vehicle (instant, expensive)

---

### ✅ 12.5 Flutter UI - Garage Screen
**What:** Build garage management screen

**Features:**
- **Grid view** of stolen vehicles with images
- **Vehicle cards** showing:
  - Image (from assets)
  - Name, condition %, fuel %
  - Market value in current country
  - Actions: Sell, Transport, Repair
- **Garage capacity** indicator (e.g., "5 / 10 vehicles")
- **Upgrade button** with cost and new capacity

**Files Expected:**
- `client/lib/screens/garage_screen.dart`
- `client/lib/models/vehicle.dart`
- `client/lib/widgets/vehicle_card.dart` - displays vehicle image + stats

**Verify:**
- View stolen vehicles
- Upgrade garage capacity
- Sell vehicle on black market

---

### ✅ 12.6 Flutter UI - Marina Screen
**What:** Build marina management screen (same as garage but for boats)

**Features:**
- Grid view of stolen boats
- Boat cards with images, condition, value
- Marina capacity indicator
- Upgrade functionality

**Files Expected:**
- `client/lib/screens/marina_screen.dart`
- Same vehicle_card.dart widget (reusable for cars + boats)

---

### ✅ 12.7 Flutter UI - Black Market Screen
**What:** Build marketplace for buying/selling vehicles

**Features:**
- **Listings view**: Cards showing vehicles for sale
  - Seller name
  - Vehicle image, name, condition
  - Asking price
  - "Buy Now" button
- **Your Listings**: Manage your vehicles for sale
  - Edit price
  - Delist vehicle
- **Filters**: Country, vehicle type, price range

**Files Expected:**
- `client/lib/screens/black_market_screen.dart`
- `client/lib/models/market_listing.dart`

---

### ✅ 12.8 Vehicle Transport & Country Arbitrage
**What:** Implement transport system, price differences per country

**Mechanics:**
- **Steal in Country A** (cheap market)
- **Transport to Country B** (expensive market)
- **Sell for profit** (arbitrage)

**Example Flow:**
1. Steal Toyota Corolla in Netherlands (€15k value)
2. Fly it to USA (€15k transport cost)
3. Sell in USA for €22k
4. Profit: €22k - €15k transport = €7k

**UI Features:**
- Transport dialog showing:
  - Current location
  - Destination selector
  - Transport method (ship/fly)
  - Cost + delivery time
  - Expected profit calculator

**Files Expected:**
- `client/lib/widgets/transport_dialog.dart`

---

## Phase 13: Asset Loading & Overlays

### ✅ 13.1 Image Assets & Overlays
**What:** Load images with overlays (e.g., vehicle damaged, property upgraded)

**Files Expected:**
- `client/assets/images/vehicles/` - base vehicle images
- `client/assets/images/overlays/` - damaged, upgraded, locked overlays
- `client/lib/widgets/overlay_image.dart` - composites base + overlay PNGs

**Verify:**
```dart
OverlayImage(base: 'toyota_corolla.png', overlays: ['damaged.png'])
```
**Expected:** Composite image rendered correctly

**Common Failure:** Overlay misalignment → Ensure all images same dimensions

---

## Phase 14: Admin Dashboard

### ☐ 14.1 Admin Project Setup (React/Vue/Svelte)
**What:** Initialize admin dashboard project (your choice of framework)

**Files Expected:**
- `admin/package.json`
- `admin/src/App.tsx` (or .jsx/.vue/.svelte)

**Verify:**
```powershell
cd admin
npm run dev
```
**Expected:** Admin app runs on localhost:5173 (or similar)

**Common Failure:** Port conflict → Change vite.config port

---

### ☐ 14.2 Admin Authentication & RBAC
**What:** Admin login, role-based access control (super admin, moderator, viewer)

**Files Expected:**
- `backend/prisma/schema.prisma` - Admin, Role models
- `backend/src/routes/admin-auth.ts` - admin login endpoint
- `admin/src/services/authService.ts` - admin login

**Verify:**
```powershell
# Login as admin, check role permissions
```
**Expected:** Super admin can access all, moderator limited

**Common Failure:** JWT same as player → Use different secret or issuer claim

---

### ☐ 14.3 Audit Log System
**What:** Log all admin actions (ban player, edit config, etc.)

**Files Expected:**
- `backend/prisma/schema.prisma` - AuditLog model
- `backend/src/middleware/auditLog.ts` - logs admin actions
- `admin/src/pages/AuditLogs.tsx` - view logs

**Verify:**
```powershell
# Perform admin action, check audit log table
```
**Expected:** Action logged with timestamp, admin ID, action type

**Common Failure:** Missing context → Include IP, user agent in log

---

### ☐ 14.4 Admin Features (Ban, Edit Player, Config Editor)
**What:** Build admin UI for player management and config editing

**Files Expected:**
- `admin/src/pages/Players.tsx` - search, ban, edit players
- `admin/src/pages/Config.tsx` - edit backend config (JSON editor)
- `backend/src/routes/admin.ts` - admin endpoints

**Verify:**
```powershell
# Ban player via admin UI, check player cannot login
```
**Expected:** Player banned, receives error on login attempt

**Common Failure:** Config not reloaded → Restart backend or implement hot reload

---

## Phase 15: Performance & Hardening

### ☐ 13.1 Database Indexes
**What:** Add indexes to frequently queried fields

**Files Expected:**
- `backend/prisma/schema.prisma` - add `@@index` directives
- `backend/prisma/migrations/` - new migration with indexes

**Verify:**
```powershell
npx prisma migrate dev --name add-indexes
# Run query analysis in MariaDB
EXPLAIN SELECT * FROM Player WHERE username = 'test';
```
**Expected:** Query uses index, no full table scan

**Common Failure:** Index not used → Check column order in composite indexes

---

### ✅ 13.2 Redis Caching (Optional)
**What:** Add Redis for session storage, rate limiting, leaderboard

**Files Expected:**
- `backend/src/services/redisClient.ts` - Redis connection
- `backend/src/middleware/rateLimit.ts` - Redis-backed rate limiter

**Verify:**
```powershell
# Exceed rate limit
curl http://localhost:3000/crimes/pickpocket/attempt (repeat rapidly)
```
**Expected:** 429 Too Many Requests after limit

**Common Failure:** Redis not running → Start Redis server or use Docker

---

### ✅ 13.3 Background Job Queue (Bull/BullMQ)
**What:** Offload heavy tasks (tick processing, notifications) to queue

**Files Expected:**
- `backend/src/queues/tickQueue.ts` - tick job processor
- `backend/package.json` - add `bull` or `bullmq`

**Verify:**
```powershell
# Trigger heavy task, check queue processes it
```
**Expected:** Task completes in background, main thread unblocked

**Common Failure:** Worker not started → Start queue worker process

---

### ☐ 13.4 Load Testing & Profiling
**What:** Test with Artillery or k6, identify bottlenecks

**Files Expected:**
- `backend/tests/load/scenario.yml` - Artillery test scenario

**Verify:**
```powershell
artillery run backend/tests/load/scenario.yml
```
**Expected:** RPS target met, p95 latency acceptable

**Common Failure:** Database connection pool exhausted → Increase pool size

---

## Phase 14: Docker Deployment

### ☐ 14.1 Dockerfiles (Backend, Client, Admin)
**What:** Create Dockerfiles for each app

**Files Expected:**
- `backend/Dockerfile`
- `client/Dockerfile` (multi-stage: build Flutter web, serve with nginx)
- `admin/Dockerfile`

**Verify:**
```powershell
docker build -t mafia-backend ./backend
docker run -p 3000:3000 mafia-backend
```
**Expected:** Backend starts in container

**Common Failure:** Missing .env → Pass env vars via docker run -e or .env file

---

### ☐ 14.2 Docker Compose (Dev)
**What:** Compose file for local dev with hot reload

**Files Expected:**
- `docker-compose.dev.yml` - backend, mariadb, redis (optional)

**Verify:**
```powershell
docker-compose -f docker-compose.dev.yml up
```
**Expected:** All services start, backend connects to DB

**Common Failure:** Volume mount issues on Windows → Use named volumes or WSL

---

### ☐ 14.3 Docker Compose (Production)
**What:** Production compose with nginx reverse proxy

**Files Expected:**
- `docker-compose.prod.yml` - backend, client, admin, nginx, mariadb
- `nginx/nginx.conf` - reverse proxy config

**Verify:**
```powershell
docker-compose -f docker-compose.prod.yml up -d
curl http://localhost
```
**Expected:** Nginx serves client, proxies /api to backend

**Common Failure:** CORS errors → Configure nginx to add CORS headers

---

### ☐ 14.4 Deploy to Strato VPS
**What:** SSH to VPS, pull code, run docker-compose

**Files Expected:**
- `DEPLOY.md` - deployment instructions
- `.env.production` - production env vars (not committed)

**Verify:**
```bash
ssh user@your-vps-ip
cd /opt/mafia_game
git pull
docker-compose -f docker-compose.prod.yml up -d --build
```
**Expected:** App live at VPS IP/domain

**Common Failure:** Port 80/443 blocked → Configure VPS firewall

---

## Phase 15: Testing & QA

### ☐ 15.1 Unit Tests (Backend Services)
**What:** Test core services with Jest/Vitest

**Files Expected:**
- `backend/src/services/__tests__/playerService.test.ts`
- `backend/src/services/__tests__/crimeService.test.ts`

**Verify:**
```powershell
cd backend
npm test
```
**Expected:** All tests pass

**Common Failure:** Database in test → Use in-memory DB or test database

---

### ☐ 15.2 Integration Tests (API Endpoints)
**What:** Test full request/response cycle

**Files Expected:**
- `backend/src/__tests__/integration/auth.test.ts`
- `backend/src/__tests__/integration/crimes.test.ts`

**Verify:**
```powershell
npm run test:integration
```
**Expected:** All endpoints return correct status/data

**Common Failure:** Port conflict → Use random port for test server

---

### ☐ 15.3 E2E Tests (Flutter Integration Tests)
**What:** Test client flows (login, crime, travel)

**Files Expected:**
- `client/integration_test/app_test.dart`

**Verify:**
```powershell
cd client
flutter test integration_test
```
**Expected:** All user flows complete successfully

**Common Failure:** Timeout → Increase test timeout for slow network

---

### ☐ 15.4 Deterministic Testing with Time Provider
**What:** Inject time provider in tests to control time

**Files Expected:**
- `backend/src/utils/timeProvider.ts` - interface with mock implementation
- `backend/src/__tests__/utils/mockTimeProvider.ts`

**Verify:**
```typescript
// In test:
mockTime.setTime(new Date('2026-01-01T00:00:00Z'));
// Run tick, check hunger decreased correctly
```
**Expected:** Tests produce same result every run

**Common Failure:** Real Date used → Ensure all services use injected timeProvider

---

## Phase 16: Android Build & Production Release 📱

### ☐ 16.1 Android Configuration
**What:** Configure Android build settings, permissions, signing

**Files Expected:**
- `client/android/app/build.gradle` - updated with version code/name, minSdk, targetSdk
- `client/android/app/src/main/AndroidManifest.xml` - permissions (INTERNET, etc.)
- `client/android/key.properties` - keystore configuration (DO NOT COMMIT!)

**Permissions Needed:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**Verify:**
```powershell
cd client
flutter doctor -v
```
**Expected:** Android toolchain installed, no issues

**Common Failure:** SDK not found → Set ANDROID_HOME environment variable

---

### ☐ 16.2 Generate Keystore for Signing
**What:** Create keystore for release APK signing

**Commands:**
```powershell
keytool -genkey -v -keystore C:\xampp\htdocs\mafia_game\client\android\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Files Created:**
- `client/android/upload-keystore.jks` - **KEEP SECURE, DO NOT COMMIT**
- `client/android/key.properties` - references keystore

**Example key.properties:**
```
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=../upload-keystore.jks
```

**Add to .gitignore:**
```
android/upload-keystore.jks
android/key.properties
```

---

### ☐ 16.3 Build Release APK
**What:** Build signed release APK

**Commands:**
```powershell
cd client
flutter build apk --release
```

**Files Generated:**
- `client/build/app/outputs/flutter-apk/app-release.apk`

**Verify:**
```powershell
# Check APK size (should be optimized)
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Expected:** APK size < 50MB, installs successfully on device

**Common Failures:**
- APK too large → Enable shrinking/obfuscation in build.gradle
- Install fails → Check device allows unknown sources

---

### ☐ 16.4 Build App Bundle (for Google Play)
**What:** Build Android App Bundle (AAB) for Play Store submission

**Commands:**
```powershell
cd client
flutter build appbundle --release
```

**Files Generated:**
- `client/build/app/outputs/bundle/release/app-release.aab`

**Verify:**
- Upload to Google Play Console Internal Testing
- Test on multiple devices via Internal Testing

**Expected:** AAB uploads successfully, no warnings

**Common Failure:** AAB validation errors → Check AndroidManifest, permissions

---

### ☐ 16.5 iOS Build (Optional)
**What:** Build iOS IPA for TestFlight/App Store

**Requirements:**
- MacOS with Xcode
- Apple Developer Account ($99/year)

**Commands:**
```bash
cd client
flutter build ios --release
```

**Files Expected:**
- `client/build/ios/iphoneos/Runner.app`

**Verify:**
- Upload to TestFlight
- Test on physical iOS device

**Common Failure:** Code signing → Configure team in Xcode

---

### ☐ 16.6 Production Deployment Checklist
**What:** Final checks before going live

**Backend:**
- [ ] Environment set to `production` in .env
- [ ] Database backups automated
- [ ] SSL certificate installed (HTTPS)
- [ ] Rate limiting enabled
- [ ] Logging configured (Winston/Pino)
- [ ] API keys secured (not in code)
- [ ] CORS configured for production domain
- [ ] Health check endpoint monitored

**Client:**
- [ ] API_BASE_URL points to production server (not localhost)
- [ ] Error tracking enabled (Sentry/Crashlytics)
- [ ] Analytics configured (Firebase/Mixpanel)
- [ ] Privacy policy URL added
- [ ] Terms of service URL added
- [ ] App version incremented

**Security:**
- [ ] SQL injection tested (use prepared statements)
- [ ] XSS prevention (sanitize inputs)
- [ ] CSRF tokens on state-changing endpoints
- [ ] Password hashing verified (bcrypt with salt)
- [ ] JWT secret changed from default
- [ ] Admin endpoints protected with authentication

**Play Store Listing:**
- [ ] App name, description, screenshots prepared
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500)
- [ ] Content rating questionnaire completed
- [ ] Privacy policy hosted and linked

---

## Completion Checklist

After completing all phases:

- [ ] All backend endpoints documented in OpenAPI/Swagger
- [ ] All content JSON files validated with schemas
- [ ] All Flutter screens tested on web + Android
- [ ] Admin dashboard tested with all roles
- [ ] Load test passes with 100+ concurrent users
- [ ] Docker deployment tested on local + VPS
- [ ] I18n complete for NL + EN
- [ ] All TODO items checked off
- [ ] Code reviewed (if team project)
- [ ] Security audit (check for SQL injection, XSS, CSRF)

---

**KEEP THIS FILE UPDATED AS YOU WORK!**
