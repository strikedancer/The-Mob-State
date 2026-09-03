-- Casino 2.0 house loop: floors, staff, raid timestamp.

ALTER TABLE `casino_ownerships`
  ADD COLUMN `floorLevel` INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN `lastRaidAt` DATETIME(3) NULL,
  ADD COLUMN `heatAccrued` INTEGER NOT NULL DEFAULT 0;

CREATE TABLE `casino_staff_catalog` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `staffKey` VARCHAR(60) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `nameNl` VARCHAR(80) NOT NULL,
  `nameEn` VARCHAR(80) NOT NULL,
  `skillLevel` INTEGER NOT NULL DEFAULT 1,
  `salaryPerTick` INTEGER NOT NULL DEFAULT 2500,
  `rakeBonusBps` INTEGER NOT NULL DEFAULT 0,
  `maxBetBonusPct` INTEGER NOT NULL DEFAULT 0,
  `raidDefenseBps` INTEGER NOT NULL DEFAULT 0,
  `payoutCutBps` INTEGER NOT NULL DEFAULT 0,
  `fbiHeatOnBet` INTEGER NOT NULL DEFAULT 0,
  `isActive` BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `casino_staff_catalog_staffKey_key` (`staffKey`),
  INDEX `casino_staff_catalog_role_isActive_idx` (`role`, `isActive`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `casino_staff_hires` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `casinoId` VARCHAR(100) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `catalogId` INTEGER NOT NULL,
  `hiredAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `casino_staff_hires_casinoId_role_key` (`casinoId`, `role`),
  INDEX `casino_staff_hires_catalogId_idx` (`catalogId`),
  CONSTRAINT `casino_staff_hires_casinoId_fkey` FOREIGN KEY (`casinoId`) REFERENCES `casino_ownerships`(`casinoId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `casino_staff_hires_catalogId_fkey` FOREIGN KEY (`catalogId`) REFERENCES `casino_staff_catalog`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `casino_staff_catalog`
  (`staffKey`, `role`, `nameNl`, `nameEn`, `skillLevel`, `salaryPerTick`, `rakeBonusBps`, `maxBetBonusPct`, `raidDefenseBps`, `payoutCutBps`, `fbiHeatOnBet`, `isActive`)
VALUES
  ('dealer_lucia', 'dealer', 'Lucia De Hand', 'Lucia the Hand', 2, 4000, 80, 0, 0, 250, 1, 1),
  ('dealer_viktor', 'dealer', 'Viktor High-Limit', 'Viktor High-Limit', 3, 7000, 140, 0, 0, 400, 2, 1),
  ('security_marco', 'security', 'Marco de Deur', 'Marco the Door', 2, 3500, 0, 0, 1500, 0, 0, 1),
  ('security_irina', 'security', 'Irina Vault', 'Irina Vault', 3, 6000, 0, 0, 2800, 0, 0, 1),
  ('promoter_nico', 'promoter', 'Nico Neon', 'Nico Neon', 2, 3000, 0, 25, 0, 0, 1, 1),
  ('promoter_sofia', 'promoter', 'Sofia Velvet', 'Sofia Velvet', 3, 5500, 20, 40, 0, 0, 2, 1)
ON DUPLICATE KEY UPDATE `nameNl` = VALUES(`nameNl`);

INSERT INTO `runtime_config` (`configKey`, `configValue`)
VALUES
  ('CASINO_FLOOR_MAX_BET_1', '500'),
  ('CASINO_FLOOR_MAX_BET_2', '2500'),
  ('CASINO_FLOOR_MAX_BET_3', '10000'),
  ('CASINO_RAKE_BPS_1', '200'),
  ('CASINO_RAKE_BPS_2', '350'),
  ('CASINO_RAKE_BPS_3', '500'),
  ('CASINO_FLOOR_UPGRADE_2', '250000'),
  ('CASINO_FLOOR_UPGRADE_3', '1000000'),
  ('CASINO_RAID_DRAIN_PCT', '18'),
  ('CASINO_SECURITY_DRAIN_REDUCTION_BPS', '10000')
ON DUPLICATE KEY UPDATE `configKey` = `configKey`;
