-- Add Ferrari to testuser2
INSERT INTO vehicle_inventory (
  playerId, 
  vehicleType, 
  vehicleId, 
  stolenInCountry, 
  currentLocation, 
  `condition`, 
  fuelLevel, 
  marketListing, 
  stolenAt
)
SELECT 
  p.id,
  'car',
  'ferrari-f40',
  'netherlands',
  'netherlands',
  100,
  100,
  false,
  NOW()
FROM players p
WHERE p.username = 'testuser2';
