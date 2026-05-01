-- Vault monthly season + per-player attempts (idempotent for drift / replay).

CREATE TABLE IF NOT EXISTS `vault_seasons` (
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

CREATE TABLE IF NOT EXISTS `vault_attempts` (
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

SET @fk_player := (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'vault_attempts'
    AND CONSTRAINT_NAME = 'vault_attempts_playerId_fkey'
);
SET @sql_player := IF(@fk_player = 0,
  'ALTER TABLE `vault_attempts` ADD CONSTRAINT `vault_attempts_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt_player FROM @sql_player;
EXECUTE stmt_player;
DEALLOCATE PREPARE stmt_player;

SET @fk_season := (
  SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'vault_attempts'
    AND CONSTRAINT_NAME = 'vault_attempts_seasonId_fkey'
);
SET @sql_season := IF(@fk_season = 0,
  'ALTER TABLE `vault_attempts` ADD CONSTRAINT `vault_attempts_seasonId_fkey` FOREIGN KEY (`seasonId`) REFERENCES `vault_seasons`(`id`) ON DELETE CASCADE ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt_season FROM @sql_season;
EXECUTE stmt_season;
DEALLOCATE PREPARE stmt_season;
