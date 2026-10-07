CREATE TABLE IF NOT EXISTS `player_death_snapshots` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `playerId` INT NOT NULL,
  `hitId` INT NULL,
  `killerId` INT NULL,
  `placedById` INT NULL,
  `bounty` INT NOT NULL DEFAULT 0,
  `vipProtectionApplied` BOOLEAN NOT NULL DEFAULT false,
  `summary` TEXT NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `restoredAt` DATETIME(3) NULL,
  `restoredByAdminId` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `player_death_snapshots_playerId_createdAt_idx` (`playerId`, `createdAt`),
  INDEX `player_death_snapshots_restoredAt_idx` (`restoredAt`),
  CONSTRAINT `player_death_snapshots_playerId_fkey`
    FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
