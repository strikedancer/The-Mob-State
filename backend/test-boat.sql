INSERT INTO vehicle_inventory (playerId, vehicleType, vehicleId, stolenInCountry, currentLocation, `condition`, fuelLevel) 
VALUES (23, 'boat', 'fishing_boat', 'netherlands', 'netherlands', 85, 65);

SELECT vi.id, vi.vehicleType, vi.vehicleId, vi.condition, vi.fuelLevel, vi.stolenInCountry 
FROM vehicle_inventory vi 
WHERE vi.playerId = 23 
ORDER BY vi.id DESC;
