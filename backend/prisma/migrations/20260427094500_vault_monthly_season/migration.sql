-- CreateTable
CREATE TABLE `vault_seasons` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `seasonKey` VARCHAR(10) NOT NULL,
  `startsAt` DATETIME(3) NOT NULL,
  `endsAt` DATETIME(3) NOT NULL,
  `codeHash` VARCHAR(128) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  UNIQUE INDEX `vault_seasons_seasonKey_key`(`seasonKey`),
  INDEX `vault_seasons_startsAt_idx`(`startsAt`),
  INDEX `vault_seasons_endsAt_idx`(`endsAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vault_attempts` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `seasonId` INTEGER NOT NULL,
  `playerId` INTEGER NOT NULL,
  `stakeTier` INTEGER NOT NULL,
  `guess` VARCHAR(8) NULL,
  `isCorrect` BOOLEAN NOT NULL DEFAULT false,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  INDEX `vault_attempts_playerId_seasonId_createdAt_idx`(`playerId`, `seasonId`, `createdAt`),
  INDEX `vault_attempts_seasonId_isCorrect_idx`(`seasonId`, `isCorrect`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `vault_attempts` ADD CONSTRAINT `vault_attempts_playerId_fkey`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vault_attempts` ADD CONSTRAINT `vault_attempts_seasonId_fkey`
  FOREIGN KEY (`seasonId`) REFERENCES `vault_seasons`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

