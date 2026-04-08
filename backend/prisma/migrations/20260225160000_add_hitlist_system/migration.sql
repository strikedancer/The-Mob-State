-- Add Hit List System
CREATE TABLE `hit_list` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `targetId` INT NOT NULL,
  `placedById` INT NOT NULL,
  `bounty` INT NOT NULL,
  `counterBounty` INT,
  `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completedAt` DATETIME,
  `completedBy` INT,
  `createdAtMs` BIGINT,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`targetId`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`placedById`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`completedBy`) REFERENCES `players`(`id`) ON DELETE SET NULL,
  
  INDEX `idx_targetId` (`targetId`),
  INDEX `idx_placedById` (`placedById`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add Player Security Table
CREATE TABLE `player_security` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `playerId` INT NOT NULL UNIQUE,
  `bodyguards` INT NOT NULL DEFAULT 0,
  `armor` INT NOT NULL DEFAULT 0,
  `armorType` VARCHAR(50),
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add Hit List fields to players table if they don't already exist
ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `killCount` INT NOT NULL DEFAULT 0;
ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `isHunted` BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `hitCount` INT NOT NULL DEFAULT 0;
