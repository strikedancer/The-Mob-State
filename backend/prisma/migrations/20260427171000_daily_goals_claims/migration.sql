-- CreateTable
CREATE TABLE IF NOT EXISTS `player_daily_goal_claims` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `dateKey` VARCHAR(10) NOT NULL,
  `goalKey` VARCHAR(40) NOT NULL,
  `claimedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  PRIMARY KEY (`id`),
  UNIQUE KEY `player_daily_goal_claims_playerId_dateKey_goalKey_key` (`playerId`, `dateKey`, `goalKey`),
  KEY `player_daily_goal_claims_playerId_dateKey_idx` (`playerId`, `dateKey`),
  KEY `player_daily_goal_claims_dateKey_idx` (`dateKey`),
  CONSTRAINT `player_daily_goal_claims_playerId_fkey`
    FOREIGN KEY (`playerId`) REFERENCES `players` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

