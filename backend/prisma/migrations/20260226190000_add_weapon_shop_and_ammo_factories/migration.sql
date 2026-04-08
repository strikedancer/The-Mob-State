-- Create ammo_inventory table if it doesn't exist
CREATE TABLE IF NOT EXISTS `ammo_inventory` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `playerId` INT NOT NULL,
  `ammoType` VARCHAR(50) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 0,
  `quality` FLOAT NOT NULL DEFAULT 1.0,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY `uniq_player_ammo` (`playerId`, `ammoType`),
  INDEX `idx_playerId` (`playerId`),
  CONSTRAINT `fk_ammo_inventory_player` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ammo quality in player inventory
ALTER TABLE `ammo_inventory` ADD COLUMN IF NOT EXISTS `quality` FLOAT NOT NULL DEFAULT 1.0;

-- Ammo factories (one per country)
CREATE TABLE `ammo_factories` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `countryId` VARCHAR(50) NOT NULL UNIQUE,
  `ownerId` INT NULL,
  `level` INT NOT NULL DEFAULT 1,
  `qualityLevel` INT NOT NULL DEFAULT 1,
  `lastProducedAt` DATETIME NULL,
  `lastActiveAt` DATETIME NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_ownerId` (`ownerId`),
  CONSTRAINT `fk_ammo_factory_owner` FOREIGN KEY (`ownerId`) REFERENCES `players`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Country ammo market stock
CREATE TABLE `ammo_market_stock` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `countryId` VARCHAR(50) NOT NULL,
  `ammoType` VARCHAR(50) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 0,
  `quality` FLOAT NOT NULL DEFAULT 1.0,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY `uniq_country_ammo` (`countryId`, `ammoType`),
  INDEX `idx_country` (`countryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shooting range stats
CREATE TABLE `shooting_range_stats` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `playerId` INT NOT NULL UNIQUE,
  `sessionsCompleted` INT NOT NULL DEFAULT 0,
  `accuracyBonus` FLOAT NOT NULL DEFAULT 0.0,
  `lastTrainedAt` DATETIME NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_playerId` (`playerId`),
  CONSTRAINT `fk_shooting_range_player` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
