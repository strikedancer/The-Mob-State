-- Add transportDestination column to vehicle_inventory table
ALTER TABLE `vehicle_inventory` 
ADD COLUMN `transportDestination` VARCHAR(50) NULL AFTER `transportArrivalTime`;
