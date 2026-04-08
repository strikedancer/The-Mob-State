-- Manual migration: Add CasinoTransaction table
CREATE TABLE IF NOT EXISTS `casino_transactions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playerId` INT NOT NULL,
  `casinoId` VARCHAR(100) NOT NULL,
  `ownerId` INT NOT NULL,
  `gameType` VARCHAR(50) NOT NULL,
  `betAmount` INT NOT NULL,
  `payout` INT NOT NULL DEFAULT 0,
  `ownerCut` INT NOT NULL DEFAULT 0,
  `result` JSON NOT NULL,
  `rngSeed` VARCHAR(255) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  INDEX `casino_transactions_playerId_idx` (`playerId`),
  INDEX `casino_transactions_casinoId_idx` (`casinoId`),
  INDEX `casino_transactions_ownerId_idx` (`ownerId`),
  INDEX `casino_transactions_createdAt_idx` (`createdAt`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
