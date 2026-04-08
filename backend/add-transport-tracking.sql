-- Add transport tracking fields to vehicle_inventory table
ALTER TABLE `vehicle_inventory` 
ADD COLUMN `transportStatus` VARCHAR(20) NULL COMMENT 'NULL=available, shipping, flying, driving',
ADD COLUMN `transportArrivalTime` DATETIME NULL COMMENT 'When transport completes';
