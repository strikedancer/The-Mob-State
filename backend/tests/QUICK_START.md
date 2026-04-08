# Crime Outcome Testing - Quick Start

## 🚀 Get Started in 5 Minutes

### 1️⃣ Create Test Vehicles in Database

Open a PowerShell and run:

```powershell
cd c:\xampp\htdocs\mafia_game

docker exec -i mafia-mysql mariadb -u root -proot mafia_game < backend/tests/crimeOutcomeTestData.sql
```

This creates 6 test vehicles with different conditions.

### 2️⃣ Get Your JWT Token

1. Start the game (Flutter app)
2. Log in to your account
3. Open browser DevTools (F12) → Application → LocalStorage
4. Find the key with your JWT token (looks like `eyJ0...`)
5. Copy the full token

### 3️⃣ Run a Quick Test

Open PowerShell and run:

```powershell
$API = "http://localhost:3000"
$TOKEN = "YOUR_JWT_TOKEN_HERE"  # Paste your token
$PLAYER_ID = 1  # Your player ID

# Get your vehicles
$headers = @{"Authorization"="Bearer $TOKEN"}
$vehicles = Invoke-RestMethod -Uri "$API/garage/vehicles" -Headers $headers

# Show first 3 vehicles
$vehicles | Select @{N='ID';E={$_.id}}, @{N='Type';E={$_.vehicleType}}, @{N='Condition';E={"$($_.condition)%"}}, @{N='Fuel';E={"$($_.fuel)/$($_.maxFuel)"}} | Select -First 3

# Pick first vehicle
$vehicleId = $vehicles[0].id

# Set as crime vehicle
Invoke-RestMethod -Uri "$API/garage/crime-vehicle" -Method Post -Headers $headers `
  -Body (@{vehicleId=$vehicleId} | ConvertTo-Json) -ContentType "application/json"

# Attempt a crime
$body = @{crimeId="robbery"} | ConvertTo-Json
$result = Invoke-RestMethod -Uri "$API/crimes/attempt" -Method Post -Headers $headers `
  -Body $body -ContentType "application/json"

# Show result
$result | Select outcome, success, reward, outcomeMessage, vehicleConditionLoss, toolDamageSustained | ConvertTo-Json
```

### 4️⃣ Check What Happened

```powershell
$result.outcome  # Shows: success, caught, out_of_fuel, vehicle_breakdown_before, vehicle_breakdown_during, tool_broke

$result.outcomeMessage  # Shows detailed message

$result.vehicleConditionLoss  # Shows condition loss %

$result.toolDamageSustained  # Shows tool damage %
```

## Test Cases by Vehicle Created

| # | Vehicle | Condition | Fuel | Purpose | Expected Outcome |
|----|---------|-----------|------|---------|-----------------|
| 1 | Civic | 15% | 100% | Breakdown before crime | `vehicle_breakdown_before` |
| 2 | Corolla | 90% | 90% | Tool broke (low durability) | `tool_broke` |
| 3 | Focus | 80% | 8% | Out of fuel | `out_of_fuel` |
| 4 | Beetle | 35% | 90% | Breakdown during escape | `vehicle_breakdown_during` |
| 5 | BMW | 95% | 95% | Success (perfect) | `success` |
| 6 | Jetta | 70% | 70% | Average (control) | `success` or `caught` |

## Quick Test: Try Each Scenario

```powershell
$API = "http://localhost:3000"
$TOKEN = "YOUR_JWT_TOKEN_HERE"
$headers = @{"Authorization"="Bearer $TOKEN"}

# Scenario 1: Set vehicle 1 (condition 15%)
# Expect: vehicle_breakdown_before (20% chance)
# Run 5 times to likely see it trigger

For ($i = 1; $i -le 5; $i++) {
    $vehicles = Invoke-RestMethod -Uri "$API/garage/vehicles" -Headers $headers
    $vid = $vehicles[0].id  # First vehicle
    
    Invoke-RestMethod -Uri "$API/garage/crime-vehicle" -Method Post -Headers $headers `
      -Body (@{vehicleId=$vid} | ConvertTo-Json) -ContentType "application/json" | Out-Null
    
    $result = Invoke-RestMethod -Uri "$API/crimes/attempt" -Method Post -Headers $headers `
      -Body (@{crimeId="robbery"} | ConvertTo-Json) -ContentType "application/json"
    
    Write-Host "Attempt $i: $($result.outcome)"
}
```

## Verify Database Changes

After running tests, check the database:

```powershell
# See recent crime attempts
$mysqlCmd = "SELECT outcome, success, reward, vehicleConditionUsed, toolDamageSustained FROM crime_attempts WHERE playerId = 1 ORDER BY createdAt DESC LIMIT 5;"

docker exec -i mafia-mysql mariadb -u root -proot mafia_game -e "$mysqlCmd"

# See vehicle conditions after degradation
$mysqlCmd = "SELECT vehicleType, condition, fuel, isBroken FROM vehicles WHERE playerId = 1 ORDER BY updatedAt DESC LIMIT 6;"

docker exec -i mafia-mysql mariadb -u root -proot mafia_game -e "$mysqlCmd"
```

## Troubleshooting

### ❌ "Outcome is always 'success'"
- **Cause**: Vehicle condition/fuel might be too good
- **Fix**: Try vehicle #1 (15% condition) or #3 (8% fuel) multiple times

### ❌ "Same outcome every time"
- **Cause**: RNG probability not hit, or vehicle not being set
- **Fix**: 
  - Check that `outcome` changes in response
  - Post /garage/crime-vehicle before each attempt
  - Run 5-10 attempts per scenario

### ❌ "Error: Invalid token"
- **Cause**: JWT token expired or invalid
- **Fix**: Log out and log back in to get fresh token

### ❌ "No vehicles found"
- **Cause**: Test vehicles not created, or wrong player
- **Fix**: Run the SQL setup script again

## Success Checklist

After testing, you should see:

- [ ] ✅ All 6 test vehicles created in database
- [ ] ✅ Crime attempts show varied outcomes (not always success)
- [ ] ✅ Vehicle condition decreases after crimes
- [ ] ✅ Vehicle fuel decreases after crimes
- [ ] ✅ Tools degrade after crimes
- [ ] ✅ At least one `vehicle_breakdown_before` outcome
- [ ] ✅ At least one `out_of_fuel` outcome
- [ ] ✅ At least one `vehicle_breakdown_during` outcome
- [ ] ✅ Some `success` outcomes with good vehicles
- [ ] ✅ Some `caught` outcomes

## Next: Frontend UI

Once testing is complete, the next phase is building:
- Vehicle selection dropdown in crime screen
- Vehicle stats display (condition bar, fuel bar)
- Repair/refuel buttons
- Crime outcome message display
