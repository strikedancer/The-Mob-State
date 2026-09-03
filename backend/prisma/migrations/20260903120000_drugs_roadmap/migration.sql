-- Drugs roadmap: heat/raid pending, ready notify, darkweb autosale, premium, crew lots.

ALTER TABLE `players`
  ADD COLUMN `drugHeatShieldExpiresAt` DATETIME(3) NULL,
  ADD COLUMN `drugLowProfileUntil` DATETIME(3) NULL,
  ADD COLUMN `lastDrugHeatCoolAt` DATETIME(3) NULL,
  ADD COLUMN `lastDrugLowProfileAt` DATETIME(3) NULL;

ALTER TABLE `drug_production`
  ADD COLUMN `readyNotifiedAt` DATETIME(3) NULL,
  ADD COLUMN `raidPending` BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN `raidLossPercent` INTEGER NULL,
  ADD COLUMN `raidCashFine` INTEGER NULL,
  ADD COLUMN `raidDowntimeHours` INTEGER NULL;

CREATE INDEX `drug_production_raidPending_idx` ON `drug_production`(`raidPending`);

ALTER TABLE `drug_facilities`
  ADD COLUMN `autoSaleEnabled` BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN `downtimeUntil` DATETIME(3) NULL;

ALTER TABLE `drug_inventory`
  ADD COLUMN `ownProduction` BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE `nightclub_drug_inventory`
  ADD COLUMN `ownProduction` BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE `crew_drug_lots` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `crewId` INTEGER NOT NULL,
  `drugType` VARCHAR(50) NOT NULL,
  `quality` VARCHAR(2) NOT NULL DEFAULT 'C',
  `quantity` INTEGER NOT NULL DEFAULT 0,
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `crew_drug_lots_crewId_drugType_quality_key` (`crewId`, `drugType`, `quality`),
  INDEX `crew_drug_lots_crewId_idx` (`crewId`),
  CONSTRAINT `crew_drug_lots_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `credit_shop_items`
  MODIFY `effectType` ENUM('CASH_BUNDLE', 'HIT_PROTECTION', 'VEHICLE_REPAIR_FINISH', 'VEHICLE_TUNE_RESET', 'ACTION_COOLDOWN_RESET', 'EVENT_BOOST', 'DRUG_TEMP_SLOT', 'DRUG_HEAT_SHIELD') NOT NULL;

ALTER TABLE `player_credit_entitlements`
  MODIFY `effectType` ENUM('CASH_BUNDLE', 'HIT_PROTECTION', 'VEHICLE_REPAIR_FINISH', 'VEHICLE_TUNE_RESET', 'ACTION_COOLDOWN_RESET', 'EVENT_BOOST', 'DRUG_TEMP_SLOT', 'DRUG_HEAT_SHIELD') NOT NULL;

CREATE TABLE IF NOT EXISTS `runtime_config` (
  `configKey` VARCHAR(120) NOT NULL PRIMARY KEY,
  `configValue` VARCHAR(255) NOT NULL,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `runtime_config` (`configKey`, `configValue`)
VALUES
  ('DRUG_HEAT_CASH_COOL_COST_PER_POINT', '5000'),
  ('DRUG_HEAT_CASH_COOL_POINTS', '25'),
  ('DRUG_HEAT_LOW_PROFILE_HOURS', '4'),
  ('DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS', '8'),
  ('DRUG_RAID_DOWNTIME_HOURS', '4'),
  ('DRUG_RAID_CASH_FINE_PERCENT', '35'),
  ('DRUG_DARKWEB_AUTOSALE_FEE_PERCENT', '12'),
  ('DRUG_DARKWEB_AUTOSALE_HEAT', '4'),
  ('DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT', '10'),
  ('DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT', '8')
ON DUPLICATE KEY UPDATE `configKey` = `configKey`;
