-- Clean up test boat
DELETE FROM vehicle_inventory WHERE id = 33;

-- Set player rank higher for boat theft testing
UPDATE players SET rank = 15, money = 100000 WHERE id = 23;

-- Show current inventory
SELECT vi.id, vi.vehicleType, vi.vehicleId, vi.condition, vi.fuelLevel
FROM vehicle_inventory vi 
WHERE vi.playerId = 23
ORDER BY vi.id DESC;
