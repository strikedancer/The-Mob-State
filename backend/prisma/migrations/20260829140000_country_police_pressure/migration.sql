-- Country police pressure (shared world state per travel country).

CREATE TABLE IF NOT EXISTS `country_police_state` (
  `countryCode` VARCHAR(50) NOT NULL,
  `pressure` INT NOT NULL DEFAULT 15,
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `lastActivityAt` DATETIME(3) NULL,
  `coolUntil` DATETIME(3) NULL,
  PRIMARY KEY (`countryCode`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `country_police_player_hourly` (
  `playerId` INT NOT NULL,
  `countryCode` VARCHAR(50) NOT NULL,
  `hourKey` VARCHAR(16) NOT NULL,
  `gained` INT NOT NULL DEFAULT 0,
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`playerId`, `countryCode`, `hourKey`),
  INDEX `idx_country_police_hourly_hour` (`hourKey`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
