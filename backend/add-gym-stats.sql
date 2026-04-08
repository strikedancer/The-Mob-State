-- Add gym_stats table for strength training
CREATE TABLE IF NOT EXISTS `gym_stats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playerId` INT NOT NULL,
  `sessionsCompleted` INT NOT NULL DEFAULT 0,
  `strengthBonus` FLOAT NOT NULL DEFAULT 0.0,
  `lastTrainedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `gym_stats_playerId_key` (`playerId`),
  KEY `gym_stats_playerId_idx` (`playerId`),
  
  CONSTRAINT `gym_stats_playerId_fkey` 
    FOREIGN KEY (`playerId`) 
    REFERENCES `players` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
