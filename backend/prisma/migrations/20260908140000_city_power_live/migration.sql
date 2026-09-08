INSERT INTO `runtime_config` (`configKey`, `configValue`)
VALUES ('COUNTRY_POLICE_PRESSURE_ENABLED', '1')
ON DUPLICATE KEY UPDATE `configValue` = '1';

CREATE TABLE `midnight_race_meetings` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `countryCode` VARCHAR(50) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `startsAt` DATETIME(3) NOT NULL,
  `endsAt` DATETIME(3) NOT NULL,
  `hostVenueId` INTEGER NULL,
  `hostPlayerId` INTEGER NULL,
  `rakeBps` INTEGER NOT NULL DEFAULT 800,
  `prizePool` INTEGER NOT NULL DEFAULT 0,
  `rakePaid` INTEGER NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `midnight_race_meetings_countryCode_status_endsAt_idx`(`countryCode`, `status`, `endsAt`),
  INDEX `midnight_race_meetings_hostPlayerId_idx`(`hostPlayerId`),
  CONSTRAINT `midnight_race_meetings_hostVenueId_fkey` FOREIGN KEY (`hostVenueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `midnight_race_meetings_hostPlayerId_fkey` FOREIGN KEY (`hostPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `midnight_race_entries` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `meetingId` INTEGER NOT NULL,
  `playerId` INTEGER NOT NULL,
  `vehicleInventoryId` INTEGER NOT NULL,
  `vehicleId` VARCHAR(100) NOT NULL,
  `stake` INTEGER NOT NULL,
  `fixing` BOOLEAN NOT NULL DEFAULT false,
  `speedScore` INTEGER NOT NULL DEFAULT 0,
  `finishPlace` INTEGER NULL,
  `payout` INTEGER NOT NULL DEFAULT 0,
  `status` VARCHAR(20) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `midnight_race_entries_meetingId_playerId_key`(`meetingId`, `playerId`),
  INDEX `midnight_race_entries_playerId_idx`(`playerId`),
  CONSTRAINT `midnight_race_entries_meetingId_fkey` FOREIGN KEY (`meetingId`) REFERENCES `midnight_race_meetings`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `midnight_race_entries_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `midnight_race_bets` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `meetingId` INTEGER NOT NULL,
  `entryId` INTEGER NOT NULL,
  `bettorId` INTEGER NOT NULL,
  `amount` INTEGER NOT NULL,
  `payout` INTEGER NOT NULL DEFAULT 0,
  `status` VARCHAR(20) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  INDEX `midnight_race_bets_meetingId_bettorId_idx`(`meetingId`, `bettorId`),
  INDEX `midnight_race_bets_entryId_idx`(`entryId`),
  CONSTRAINT `midnight_race_bets_meetingId_fkey` FOREIGN KEY (`meetingId`) REFERENCES `midnight_race_meetings`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `midnight_race_bets_entryId_fkey` FOREIGN KEY (`entryId`) REFERENCES `midnight_race_entries`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `midnight_race_bets_bettorId_fkey` FOREIGN KEY (`bettorId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
