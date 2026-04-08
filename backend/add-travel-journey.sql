-- Add travel journey tracking fields to players table
ALTER TABLE `players` 
ADD COLUMN `travelingTo` VARCHAR(50) NULL COMMENT 'Destination country if in transit',
ADD COLUMN `travelRoute` JSON NULL COMMENT 'Array of country IDs in route order',
ADD COLUMN `currentTravelLeg` INT DEFAULT 0 COMMENT 'Current leg index (0 = not traveling)',
ADD COLUMN `travelStartedAt` DATETIME NULL COMMENT 'When the journey started',
ADD INDEX `idx_travelingTo` (`travelingTo`),
ADD INDEX `idx_currentTravelLeg` (`currentTravelLeg`);
