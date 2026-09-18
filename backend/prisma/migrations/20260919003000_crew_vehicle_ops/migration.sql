ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `speed_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `stealth_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `armor_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `tune_cooldown_until` DATETIME NULL;
ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `repair_completes_at` DATETIME NULL;
ALTER TABLE `crew_car_inventory` ADD COLUMN IF NOT EXISTS `repair_cost` INT NULL;

ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `speed_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `stealth_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `armor_level` INT NOT NULL DEFAULT 0;
ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `tune_cooldown_until` DATETIME NULL;
ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `repair_completes_at` DATETIME NULL;
ALTER TABLE `crew_boat_inventory` ADD COLUMN IF NOT EXISTS `repair_cost` INT NULL;
