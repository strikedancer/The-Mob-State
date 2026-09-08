ALTER TABLE `crew_members`
  ADD COLUMN IF NOT EXISTS `capoCountry` VARCHAR(50) NULL;

CREATE TABLE `don_rackets` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `businessKey` VARCHAR(40) NOT NULL,
  `countryCode` VARCHAR(50) NOT NULL,
  `regionKey` VARCHAR(64) NULL,
  `ownerPlayerId` INTEGER NULL,
  `squeezeUntil` DATETIME(3) NULL,
  `lastCollectAt` DATETIME(3) NULL,
  `tributeToCrew` BOOLEAN NOT NULL DEFAULT false,
  `contestUntil` DATETIME(3) NULL,
  `contestPlayerId` INTEGER NULL,
  `claimedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `don_rackets_businessKey_countryCode_key`(`businessKey`, `countryCode`),
  INDEX `don_rackets_ownerPlayerId_idx`(`ownerPlayerId`),
  INDEX `don_rackets_countryCode_idx`(`countryCode`),
  CONSTRAINT `don_rackets_ownerPlayerId_fkey` FOREIGN KEY (`ownerPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `don_rackets_contestPlayerId_fkey` FOREIGN KEY (`contestPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `don_loans` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `lenderId` INTEGER NOT NULL,
  `borrowerPlayerId` INTEGER NULL,
  `npcKey` VARCHAR(40) NULL,
  `principal` INTEGER NOT NULL,
  `interestBps` INTEGER NOT NULL,
  `dueAt` DATETIME(3) NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `don_loans_lenderId_idx`(`lenderId`),
  INDEX `don_loans_borrowerPlayerId_idx`(`borrowerPlayerId`),
  INDEX `don_loans_status_dueAt_idx`(`status`, `dueAt`),
  CONSTRAINT `don_loans_lenderId_fkey` FOREIGN KEY (`lenderId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `don_loans_borrowerPlayerId_fkey` FOREIGN KEY (`borrowerPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `don_officials` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `countryCode` VARCHAR(50) NOT NULL,
  `office` VARCHAR(20) NOT NULL,
  `patronPlayerId` INTEGER NULL,
  `paidUntil` DATETIME(3) NULL,
  `bidAmount` INTEGER NOT NULL DEFAULT 0,
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `don_officials_countryCode_office_key`(`countryCode`, `office`),
  INDEX `don_officials_patronPlayerId_idx`(`patronPlayerId`),
  CONSTRAINT `don_officials_patronPlayerId_fkey` FOREIGN KEY (`patronPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `don_contracts` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `countryCode` VARCHAR(50) NOT NULL,
  `contractKey` VARCHAR(40) NOT NULL,
  `bidderPlayerId` INTEGER NULL,
  `crewId` INTEGER NULL,
  `startsAt` DATETIME(3) NULL,
  `endsAt` DATETIME(3) NULL,
  `payout` INTEGER NOT NULL DEFAULT 0,
  `status` VARCHAR(20) NOT NULL,
  `greedy` BOOLEAN NOT NULL DEFAULT false,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `don_contracts_countryCode_status_idx`(`countryCode`, `status`),
  INDEX `don_contracts_bidderPlayerId_idx`(`bidderPlayerId`),
  CONSTRAINT `don_contracts_bidderPlayerId_fkey` FOREIGN KEY (`bidderPlayerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
