# Vehicle & Tool Crime System Implementation - Complete

## ✅ Completed Systems

### 1. Database Schema (✅ DONE)
**Tables Updated:**
- `vehicles` table expanded with:
  - `speed` (INT, 1-100): Affects escape success
  - `armor` (INT, 1-100): Protection during crimes
  - `stealth` (INT, 1-100): Lower detection rate
  - `cargo` (INT, 1-100): More loot capacity (but more suspicious)
  - `condition` (FLOAT, 0-100%): Affects reliability, degrades over time
  - `updatedAt` (TIMESTAMP): Track last modification

- `player_selected_vehicles` table (NEW):
  - Links player to their crime vehicle
  - `playerId`, `vehicleId`, `selectedFor`, `selectedAt`

**`crime_attempts` table expanded:**
  - `usedToolId`: Which tool was used
  - `outcome`: success/caught/fled/vehicleBreakdown/toolBroke/outOfFuel
  - `outcomeFail`: Detailed failure JSON
  - `lootStolen`: Actual loot (may differ from reward)
  - `cargoUsed`: How much cargo was needed
  - `vehicleConditionUsed`: Vehicle condition at crime time
  - `vehicleSpeedBonus`, `vehicleCargoBonus`, `vehicleStealthBonus`: Multipliers
  - `toolConditionBefore`, `toolDamageSustained`: Tool tracking

**Migration applied:** ✅ via Docker MariaDB

---

### 2. Backend Services (✅ DONE)

#### **Crime Outcome Engine** (`crimeOutcomeEngine.ts`)
- **Multiple failure scenarios:**
  1. ✅ **SUCCESS** - Normal completion
  2. 🚨 **CAUGHT** - Arrested by police
  3. ⚠️ **FLED_NO_LOOT** - Escaped without loot
  4. ⛽ **OUT_OF_FUEL** - Tank empty during escape (lose vehicle + loot)
  5. 🔧 **VEHICLE_BREAKDOWN** - Car breaks down (lose most loot)
  6. 🔨 **TOOL_BROKE** - Tool failed during crime
  7. 🚗 **VEHICLE_BREAKDOWN_BEFORE** - Car breaks before reaching crime

- **Success chance calculation:**
  - Base chance from crime definition
  - Rank bonus (+0.5% per rank above requirement)
  - Vehicle modifiers:
    - Speed: ±10% (faster = better escape)
    - Stealth: ±12.5% (less detection)
    - Cargo: ±5% penalty (more cargo = more suspicious)
    - Condition: Up to -30% if below 60%
    - Fuel: Up to -30% if below 30%
  - Tool condition: ±5%, with -30% penalty below 20% durability

- **Loot calculation:**
  - Base loot from min/max range
  - Cargo multiplier: 0.7x to 1.3x (high cargo = more loot)

#### **Vehicle & Tool Service** (`vehicleToolService.ts`)
- `degradeTool()`: Apply durability loss, delete if broken
- `degradeVehicle()`: Apply condition/fuel loss
- `getPlayerCrimeVehicle()`: Get selected vehicle for crimes
- `setPlayerCrimeVehicle()`: Select vehicle for crime use
- `repairVehicle()`: Repair condition ($500 per 1%)
- `refuelVehicle()`: Add fuel ($2 per liter)

#### **Garage Routes** (`garage.ts`)
- `GET /garage/crime-vehicle`: Get selected vehicle
- `POST  /garage/crime-vehicle`: Set vehicle for crimes
- `GET /garage/vehicles`: List all player vehicles with stats
- `POST /garage/repair/:vehicleId`: Repair vehicle (costs money)
- `POST /garage/refuel/:vehicleId`: Refuel vehicle (costs money)

---

### 3. Localization (✅ DONE)

**Added to `app_en.arb` & `app_nl.arb`:**
```json
// Outcome messages
"crimeOutcomeSuccess": "Crime successful!" / "Misdaad geslaagd!"
"crimeOutcomeCaught": "Caught by police" / "Gepakt door de politie"
"crimeOutcomeVehicleBreakdownBefore": "Your vehicle broke down before reaching the crime scene"
"crimeOutcomeVehicleBreakdownDuring": "Vehicle broke down during escape - abandoned most loot"
"crimeOutcomeOutOfFuel": "Ran out of fuel during escape - fled on foot, lost loot and vehicle"
"crimeOutcomeToolBroke": "Your tool broke during the crime, leaving evidence"
"crimeOutcomeFledNoLoot": "Fled the scene without loot"

// Vehicle stats
"vehicleCondition": "Condition" / "Conditie"
"vehicleFuel": "Fuel" / "Brandstof"
"vehicleSpeed": "Speed" / "Snelheid"
"vehicleArmor": "Armor" / "Pantser"
"vehicleStealth": "Stealth" / "Stealth"
"vehicleCargo": "Cargo" / "Lading"
"vehicleRepair": "Repair" / "Repareren"
"vehicleRefuel": "Refuel" / "Tanken"
"selectCrimeVehicle": "Select Vehicle for Crimes" / "Selecteer Voertuig voor Misdaden"
"noVehicleSelected": "No vehicle selected" / "Geen voertuig geselecteerd"
```

**Flutter localization generated:** ✅ via `flutter gen-l10n`

---

## 📋 Integration Status

### Backend ✅
- Database schema: **READY**
- Crime outcome engine: **READY**
- Vehicle/tool degradation: **READY**
- Garage API endpoints: **READY**
- Localization: **READY**

### ⚠️ **Not Yet Integrated:**
The **crime outcome engine is NOT yet wired into `crimeService.ts`**. The current crime system still uses the old logic. To fully activate:

1. **Import outcome engine in `crimeService.ts`:**
   ```typescript
   import { processCrimeAttempt, CrimeOutcome } from '../utils/crimeOutcomeEngine';
   import { getPlayerCrimeVehicle, getPlayerTool, degradeTool, degradeVehicle } from '../services/vehicleToolService';
   ```

2. **Replace `attemptCrime()` logic:**
   - Fetch player's selected vehicle via `getPlayerCrimeVehicle()`
   - Fetch player's tool via `getPlayerTool()` if required
   - Call `processCrimeAttempt(crime, playerRank, vehicle, tool)`
   - Handle outcome scenarios
   - Apply degradation via `degradeTool()` / `degradeVehicle()`
   - Save outcome to `crime_attempts` table with all new fields

3. **Update crime response to include:**
   ```json
   {
     "outcome": "out_of_fuel",
     "message": "Ran out of fuel...",
     "vehicleConditionLoss": 12.5,
     "toolDamageSustained": 8,
     "lootStolen": 5000,
     "cargoUsed": 5
   }
   ```

### Frontend ⚠️
**Not yet implemented:**
- Vehicle selection UI in garage screen
- Vehicle stats display (speed/armor/stealth/cargo bars)
- Repair/refuel buttons
- Crime outcome message display
- Tool durability warnings

---

## 🎯 Next Steps for Full Integration

### Phase 1: Wire Crime Outcome Engine
1. Modify `crimeService.ts` `attemptCrime()` to use outcome engine
2. Test all scenarios:
   - ✅ Success with loot
   - 🚨 Caught (normal fail)
   - ⛽ Out of fuel scenario
   - 🔧 Vehicle breakdown
   - 🔨 Tool broke
3. Verify database saves all outcome data

### Phase 2: Frontend Vehicle Selection
1. Create `GarageVehicleSelector` widget
2. Display vehicle stats with progress bars
3. Add "Select for Crimes" button
4. Show current selected vehicle on crime screen

### Phase 3: Repair/Refuel UI
1. Add repair button (show cost: $500 per 1%)
2. Add refuel button (show cost: $2 per liter)
3. Show vehicle condition warnings (red if <30%)
4. Show fuel warnings (red if <20%)

### Phase 4: Crime Outcome Messages
1. Parse outcome enum from API response
2. Show localized message based on outcome
3. Display statistics:
   - "Je auto verloor 15% conditie"
   - "Je gereedschap nam 8% schade"
   - "Je tank is 25 liter lager"

### Phase 5: Tool Warnings
1. Show tool durability on crime cards
2. Warn if tool durability <30% (orange)
3. Block crime if tool durability <10% (red)

---

## 🧪 Testing Scenarios

### Scenario 1: Low Fuel Escape Failure
- Vehicle fuel: 10%
- Crime attempt → High chance of OUT_OF_FUEL outcome
- Expected: "Ran out of fuel during escape - fled on foot, lost loot and vehicle"
- Verification: Vehicle marked as lost, no reward, XP penalty

### Scenario 2: Vehicle Breakdown Mid-Crime
- Vehicle condition: 25%
- Crime attempt → High chance of VEHICLE_BREAKDOWN outcome
- Expected: "Vehicle broke down during escape - abandoned most loot"
- Verification: Only 30% of loot received, vehicle condition drops to 0

### Scenario 3: Tool Breaks
- Tool durability: 5%
- Crime attempt → High chance of TOOL_BROKE outcome
- Expected: "Your tool broke during the crime, leaving evidence"
- Verification: Tool deleted from inventory, player caught

### Scenario 4: Perfect Conditions
- Vehicle: 95% condition, 90% fuel, high speed/stealth
- Tool: 100% durability
- Crime attempt → Very high success chance
- Expected: SUCCESS outcome with full loot

### Scenario 5: Cargo Bonus
- Vehicle with 90 cargo capacity
- Crime: Burglary (high value)
- Expected: Loot multiplier ~1.24x (more than base vehicle)
- Verification: lootStolen > base maxReward

---

## 📊 Database Fields Reference

### vehicles
```sql
id, playerId, vehicleType, 
speed (1-100), armor (1-100), stealth (1-100), cargo (1-100),
condition (0-100%), fuel (0-maxFuel), maxFuel, isBroken, 
createdAt, updatedAt
```

### crime_attempts
```sql
id, playerId, crimeId, success, reward, xpGained, jailed, jailTime,
vehicleId, usedToolId,
outcome, outcomeFail, lootStolen, cargoUsed,
vehicleConditionUsed, vehicleSpeedBonus, vehicleCargoBonus, vehicleStealthBonus,
toolConditionBefore, toolDamageSustained,
createdAt
```

### player_selected_vehicles
``sql
id, playerId, vehicleId, selectedFor, selectedAt
```

---

## 🚀 Backend Status
- ✅ Database migrated successfully
- ✅ All TypeScript services compiled
- ✅ Garage routes registered
- ✅ Backend restarted and running

## 📱 Frontend Status
- ✅ Localization strings added
- ⚠️ UI components NOT yet built
- ⚠️ Crime outcome engine NOT integrated yet

---

**System is 70% complete** - Backend infrastructure ready, needs frontend integration + crime service wiring.
