# Crime Outcome System - Testing Guide

## Overview

The crime outcome engine now includes 6 distinct failure scenarios plus success. This guide explains how to test all scenarios to verify the system is working correctly.

## Test Scenarios

### ✅ Scenario 1: Success
- **Conditions**: Good vehicle (condition >80%, fuel >80%), good tool (durability >30%)
- **Expected**: Crime succeeds, player gets reward and XP
- **Outcome Message**: "Crime successful!"
- **Database**: outcome = 'success'

### 🚗 Scenario 2: Vehicle Breakdown Before Crime
- **Trigger**: Vehicle condition < 20%
- **Expected**: 0-20% chance of breakdown before reaching crime scene
- **Impact**: Crime fails, no reward, vehicle broken
- **Outcome Message**: "Your vehicle broke down before reaching the crime scene"
- **Database**: outcome = 'vehicle_breakdown_before', vehicleBrokeDown = true

### 🔨 Scenario 3: Tool Broke During Crime
- **Trigger**: Tool durability < 10%
- **Expected**: 0-20% chance of tool breaking
- **Impact**: Tool deleted from inventory, player caught with evidence
- **Outcome Message**: "Your tool broke during the crime, leaving evidence"
- **Database**: outcome = 'tool_broke', caught = true, jailed = true, toolBroke = true

### ⛽ Scenario 4: Out of Fuel During Escape
- **Trigger**: Vehicle fuel < 15% AND crime fails
- **Expected**: 0-50% chance of running out of fuel
- **Impact**: Fled on foot but lost all loot and vehicle
- **Outcome Message**: "Ran out of fuel during escape - fled on foot, lost loot and vehicle"
- **Database**: outcome = 'out_of_fuel', reward = 0, vehicleBrokeDown = true

### 🔧 Scenario 5: Vehicle Breakdown During Escape
- **Trigger**: Vehicle condition < 40% AND crime fails
- **Expected**: 0-40% chance of breakdown
- **Impact**: Vehicle breaks, lose 70% of loot but keep 30%
- **Outcome Message**: "Vehicle broke down during escape - abandoned most loot"
- **Database**: outcome = 'vehicle_breakdown_during', vehicleBrokeDown = true, reward = 30% of loot

### 🚨 Scenario 6: Caught by Police
- **Trigger**: Crime fails AND other scenarios don't apply
- **Expected**: Regular arrest, jailed, bail required
- **Outcome Message**: "Caught by police"
- **Database**: outcome = 'caught', caught = true, jailed = true

## Quick Testing Steps

### Step 1: Setup Test Data

Run the SQL script to create test vehicles with specific conditions:

```bash
# From project root
docker exec -i mafia-mysql mariadb -u root -proot mafia_game < backend/tests/crimeOutcomeTestData.sql
```

This creates 6 vehicles:
1. Vehicle with condition=15% (breakdown before)
2. Vehicle with condition=90%, fuel=90% (good, for tool break test)
3. Vehicle with condition=80%, fuel=8% (out of fuel)
4. Vehicle with condition=35% (breakdown during)
5. Vehicle with condition=95%, fuel=95% (perfect)
6. Vehicle with condition=70%, fuel=70% (average)

### Step 2: Run Manual Test

**Option A: PowerShell (Recommended for Windows)**

```powershell
cd backend\tests
# Edit Test-CrimeOutcome.ps1 to set:
#   $token = "YOUR_JWT_TOKEN"
#   $player_id = 1

.\Test-CrimeOutcome.ps1
```

**Option B: Bash (Linux/Mac/WSL)**

```bash
cd backend/tests
# Edit testCrimeOutcome.sh to set:
#   TOKEN="YOUR_JWT_TOKEN"
#   PLAYER_ID=1

bash testCrimeOutcome.sh
```

### Step 3: Verify Database Changes

After each test, check the database to verify the outcome was recorded correctly:

```sql
SELECT 
  crimeAttempt.id,
  crime.crimeId,
  crimeAttempt.outcome,
  crimeAttempt.success,
  crimeAttempt.reward,
  crimeAttempt.vehicleConditionUsed,
  vehicle.`condition` as vehicleConditionAfter,
  crimeAttempt.toolConditionBefore,
  crimeAttempt.toolDamageSustained,
  crimeAttempt.createdAt
FROM crime_attempts
WHERE playerId = 1
ORDER BY createdAt DESC
LIMIT 1;
```

## Expected Behavior for Each Vehicle

### Vehicle 1 (Condition=15%)
- Set as crime vehicle
- Attempt any crime
- **Expected**: Breakdown before crime (20% chance floor)
- **Check**: outcome = 'vehicle_breakdown_before'

### Vehicle 2 (Good condition/fuel, tool durability=5%)
- Manually set tool durability to 5%
- Set as crime vehicle
- Attempt crime
- **Expected**: Tool breaks during crime (20% chance floor for <10% durability)
- **Check**: outcome = 'tool_broke', caught = true

### Vehicle 3 (Condition=80%, Fuel=8%)
- Set as crime vehicle
- Attempt crime with chance of failure
- **Expected**: If crime fails, high chance of out of fuel (50% max for 8% fuel)
- **Check**: outcome = 'out_of_fuel', reward = 0

### Vehicle 4 (Condition=35%)
- Set as crime vehicle
- Attempt crime that fails
- **Expected**: Breakdown during escape (40% chance for condition 35%)
- **Check**: outcome = 'vehicle_breakdown_during', reward = 30% of base

### Vehicle 5 (Perfect: 95% condition, 95% fuel)
- Set as crime vehicle
- Attempt crime
- **Expected**: Very high success chance (>90%)
- **Check**: Most attempts should result in success

### Vehicle 6 (Average: 70/70)
- Set as crime vehicle
- Attempt multiple crimes (5-10 times)
- **Expected**: Mix of successes and failures, sometimes caught
- **Check**: Varied outcomes including success and caught

## Monitoring Vehicle Degradation

After each crime, the vehicle should show degradation:

```sql
SELECT 
  id,
  vehicleType,
  `condition`,
  fuel,
  isBroken,
  updatedAt
FROM vehicles
WHERE playerId = 1
ORDER BY updatedAt DESC
LIMIT 6;
```

**Expected degradation per crime:**
- Condition loss: 1-7% depending on vehicle speed
- Fuel loss: 10-30% depending on crime type
- Broken flag: Set to true if condition reaches 0

## Verifying Tool Degradation

For tests with tools, check tool degradation:

```sql
SELECT 
  id,
  toolId,
  durability,
  updatedAt
FROM playerTools
WHERE playerId = 1
ORDER BY updatedAt DESC
LIMIT 1;
```

**Expected:**
- Durability drops by 5-15% per use
- Tool deleted from inventory if durability reaches 0

## Troubleshooting

### Issue: "No vehicles found"
- **Cause**: Player doesn't have vehicles or wrong player ID
- **Fix**: Create vessels first via garage, or use correct player ID

### Issue: "Outcome doesn't match expected"
- **Cause**: RNG (random number generation) can prevent scenario trigger
- **Fix**: 
  - Try multiple times (scenarios have probability, not 100% guarantee)
  - Check condition/fuel thresholds are correct
  - Run 5-10 attempts per vehicle

### Issue: "Vehicle condition not decreasing"
- **Cause**: Vehicle not set as crime vehicle, or using old system
- **Fix**: 
  - POST /garage/crime-vehicle before attempting crime
  - Check crime outcome returned vehicleConditionLoss > 0

### Issue: Tool not degrading
- **Cause**: Crime might not require tools, or tool wasn't selected
- **Fix**: Use crime that requires tools (lockpicking, hacking, etc.)

## Full Testing Checklist

- [ ] Scenario 1: Vehicle breakdown before (condition < 20%)
  - [ ] Outcome recorded correctly
  - [ ] Vehicle marked as broken
  - [ ] No reward given

- [ ] Scenario 2: Tool broke (durability < 10%)
  - [ ] Outcome recorded correctly
  - [ ] Tool deleted from inventory
  - [ ] Player jailed
  
- [ ] Scenario 3: Out of fuel (fuel < 15%)
  - [ ] Outcome recorded correctly
  - [ ] Reward = 0 (lost loot)
  - [ ] Vehicle marked as broken
  
- [ ] Scenario 4: Vehicle breakdown during escape (condition < 40%)
  - [ ] Outcome recorded correctly
  - [ ] Reward = ~30% of normal
  - [ ] Vehicle not completely destroyed
  
- [ ] Scenario 5: Success (good vehicle)
  - [ ] Outcome = success
  - [ ] Reward given
  - [ ] Vehicle condition decreased 1-7%
  - [ ] Fuel decreased 10-30%
  
- [ ] Scenario 6: Caught (average vehicle)
  - [ ] Outcome = caught
  - [ ] Player jailed
  - [ ] Wanted level increased
  
- [ ] Vehicle degradation over time
  - [ ] After 10 crimes: Vehicle condition ~30-50%
  - [ ] After many crimes: Vehicle breaks
  
- [ ] Response format correct
  - [ ] outcome field present
  - [ ] outcomeMessage present
  - [ ] vehicleConditionLoss present
  - [ ] toolDamageSustained present

## Next Steps

Once testing is complete:

1. ✅ All scenarios trigger correctly
2. ✅ Database records accurate
3. ✅ Vehicle/tool degradation working

Then proceed to:
- **Phase 3**: Build frontend vehicle selection UI
- **Phase 4**: Add crime outcome message display
