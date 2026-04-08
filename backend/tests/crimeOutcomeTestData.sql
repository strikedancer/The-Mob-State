-- Crime Outcome System - Test Data Setup
-- This script creates test vehicles with specific conditions for testing all 6 scenarios

-- First, find your player ID (adjust as needed)
SELECT 'Your Player ID:' AS info, id, username, rank, money FROM players LIMIT 1;

-- Create test vehicles with different conditions (Scenario 1 - Breakdown Before)
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'Civic',
  75,
  40,
  70,
  60,
  15,    -- VERY LOW CONDITION (< 20% = breakdown before crime)
  100,
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Scenario 2: Tool Broke During Crime (vehicle is fine)
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'Corolla',
  60,
  50,
  60,
  50,
  90,    -- GOOD CONDITION
  90,    -- GOOD FUEL
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Scenario 3: Out of Fuel During Escape
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'Focus',
  70,
  45,
  65,
  55,
  80,    -- DECENT CONDITION
  8,     -- VERY LOW FUEL (< 15% = out of fuel)
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Scenario 4: Vehicle Breakdown During Escape
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'Beetle',
  50,
  40,
  60,
  40,
  35,    -- LOW CONDITION (< 40% = breakdown during escape)
  90,    -- GOOD FUEL
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Scenario 5: Success with Perfect Vehicle
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'BMW',
  90,    -- FAST
  80,    -- ARMORED
  85,    -- STEALTHY
  70,    -- GOOD CARGO
  95,    -- EXCELLENT CONDITION
  95,    -- FULL FUEL
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Scenario 6: Average Vehicle (for caught scenario)
INSERT INTO vehicles (playerId, vehicleType, speed, armor, stealth, cargo, `condition`, fuel, maxFuel, isBroken, createdAt, updatedAt)
VALUES (
  (SELECT id FROM players LIMIT 1),
  'Jetta',
  70,
  60,
  70,
  60,
  70,    -- AVERAGE CONDITION
  70,    -- AVERAGE FUEL
  100,
  FALSE,
  NOW(),
  NOW()
);

-- Verify vehicles were created
SELECT 'Created Test Vehicles:' AS info;
SELECT 
  id,
  vehicleType,
  CONCAT(vehicles.condition, '%') AS vehicle_condition,
  CONCAT(fuel, '/', maxFuel) AS fuel_level,
  CASE 
    WHEN vehicles.condition < 20 THEN 'Breakdown Before'
    WHEN fuel < 15 THEN 'Out of Fuel'
    WHEN vehicles.condition < 40 THEN 'Breakdown During'
    WHEN vehicles.condition > 90 AND fuel > 90 THEN 'Perfect'
    ELSE 'Average'
  END AS scenario
FROM vehicles 
WHERE playerId = (SELECT id FROM players LIMIT 1)
ORDER BY id DESC
LIMIT 6;

-- Create test tools with low durability (for Scenario 2)
-- First, find available tools
SELECT 'Available Tools:' AS info;
SELECT DISTINCT toolId, name FROM tools LIMIT 5;

-- Set tool durability low for testing (< 10% = breaks)
-- This depends on your player's tools, so run this after:
-- UPDATE playerTools SET durability = 5 WHERE playerId = YOUR_PLAYER_ID AND toolId = 'lockpick' LIMIT 1;

-- Query to check all crime attempts for testing
SELECT 'Recent Crime Attempts (ordered newest first):' AS info;
SELECT 
  id,
  crimeId,
  outcome,
  success,
  reward,
  `condition` as vehicleCondition,
  outcomeFail,
  toolConditionBefore,
  toolDamageSustained,
  createdAt
FROM crime_attempts
WHERE playerId = (SELECT id FROM players LIMIT 1)
ORDER BY createdAt DESC
LIMIT 10;

-- Check vehicle condition/fuel changes after crimes
SELECT 'Vehicle Status After Crimes:' AS info;
SELECT 
  v.id,
  v.vehicleType,
  CONCAT(v.`condition`, '%') AS `condition`,
  CONCAT(v.fuel, '/', v.maxFuel) AS fuel,
  v.isBroken,
  v.updatedAt
FROM vehicles v
WHERE v.playerId = (SELECT id FROM players LIMIT 1)
ORDER BY v.updatedAt DESC
LIMIT 6;
