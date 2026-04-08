-- Add PlayerActivity table
CREATE TABLE IF NOT EXISTS `player_activities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playerId` INT NOT NULL,
  `activityType` VARCHAR(50) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `details` JSON NOT NULL,
  `isPublic` BOOLEAN NOT NULL DEFAULT true,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  INDEX `player_activities_playerId_createdAt_idx` (`playerId`, `createdAt`),
  CONSTRAINT `player_activities_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
