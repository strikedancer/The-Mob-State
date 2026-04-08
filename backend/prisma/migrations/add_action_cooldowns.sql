-- Add action_cooldowns table for cooldown tracking
CREATE TABLE IF NOT EXISTS `action_cooldowns` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playerId` INT NOT NULL,
  `actionType` VARCHAR(50) NOT NULL,
  `lastUsedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `action_cooldowns_playerId_actionType_key` (`playerId`, `actionType`),
  INDEX `action_cooldowns_playerId_idx` (`playerId`),
  INDEX `action_cooldowns_actionType_idx` (`actionType`),
  
  CONSTRAINT `action_cooldowns_playerId_fkey` 
    FOREIGN KEY (`playerId`) 
    REFERENCES `players`(`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
