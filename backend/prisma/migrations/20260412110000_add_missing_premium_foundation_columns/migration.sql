-- Migration: add_missing_premium_foundation_columns
-- Adds columns and tables from add-mollie-premium-foundation.sql that were never
-- applied as a Prisma migration (drift repair for production).

-- AlterTable: players – add premiumCredits and hitProtectionExpiresAt
ALTER TABLE `players`
  ADD COLUMN IF NOT EXISTS `premiumCredits` INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `hitProtectionExpiresAt` DATETIME(3) NULL;

-- AlterTable: premium_one_time_offers – add extra Mollie/credit columns
ALTER TABLE `premium_one_time_offers`
  ADD COLUMN IF NOT EXISTS `descriptionNl` TEXT NULL,
  ADD COLUMN IF NOT EXISTS `descriptionEn` TEXT NULL,
  ADD COLUMN IF NOT EXISTS `creditAmount` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `rewardKey` VARCHAR(64) NULL,
  ADD COLUMN IF NOT EXISTS `durationHours` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `rewardValue` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `metadataJson` LONGTEXT NULL;

-- AlterTable: premium_one_time_offers – expand rewardType ENUM
ALTER TABLE `premium_one_time_offers`
  MODIFY COLUMN `rewardType` ENUM('money', 'ammo', 'credits', 'event_boost') NOT NULL;

-- CreateTable: premium_payment_transactions
CREATE TABLE IF NOT EXISTS `premium_payment_transactions` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `productKey` VARCHAR(64) NULL,
  `checkoutType` ENUM('PLAYER_VIP', 'CREW_VIP', 'ONE_TIME') NOT NULL,
  `provider` ENUM('MOLLIE') NOT NULL DEFAULT 'MOLLIE',
  `status` ENUM('OPEN', 'PENDING', 'PAID', 'CANCELED', 'EXPIRED', 'FAILED') NOT NULL DEFAULT 'OPEN',
  `providerPaymentId` VARCHAR(64) NULL,
  `providerCustomerId` VARCHAR(64) NULL,
  `providerSubscriptionId` VARCHAR(64) NULL,
  `amountCurrency` VARCHAR(10) NOT NULL DEFAULT 'EUR',
  `amountValue` VARCHAR(16) NOT NULL,
  `description` VARCHAR(255) NULL,
  `metadataJson` LONGTEXT NULL,
  `paidAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

  UNIQUE INDEX `premium_payment_transactions_providerPaymentId_key`(`providerPaymentId`),
  INDEX `premium_payment_transactions_playerId_checkoutType_status_idx`(`playerId`, `checkoutType`, `status`),
  INDEX `premium_payment_transactions_productKey_status_idx`(`productKey`, `status`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable: player_credit_transactions
CREATE TABLE IF NOT EXISTS `player_credit_transactions` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `delta` INTEGER NOT NULL,
  `balanceAfter` INTEGER NOT NULL,
  `reasonType` ENUM('PURCHASE', 'REDEEM', 'REFUND', 'ADMIN_ADJUSTMENT') NOT NULL,
  `reasonKey` VARCHAR(64) NULL,
  `metadataJson` LONGTEXT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  INDEX `player_credit_transactions_playerId_createdAt_idx`(`playerId`, `createdAt`),
  INDEX `player_credit_transactions_reasonType_createdAt_idx`(`reasonType`, `createdAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable: credit_shop_items
CREATE TABLE IF NOT EXISTS `credit_shop_items` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(64) NOT NULL,
  `titleNl` VARCHAR(120) NOT NULL,
  `titleEn` VARCHAR(120) NOT NULL,
  `descriptionNl` TEXT NULL,
  `descriptionEn` TEXT NULL,
  `creditCost` INTEGER NOT NULL,
  `effectType` ENUM('CASH_BUNDLE', 'HIT_PROTECTION', 'VEHICLE_REPAIR_FINISH', 'VEHICLE_TUNE_RESET', 'ACTION_COOLDOWN_RESET', 'EVENT_BOOST') NOT NULL,
  `moneyAmount` INTEGER NULL,
  `durationHours` INTEGER NULL,
  `actionType` VARCHAR(50) NULL,
  `metadataJson` LONGTEXT NULL,
  `isActive` BOOLEAN NOT NULL DEFAULT true,
  `sortOrder` INTEGER NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

  UNIQUE INDEX `credit_shop_items_key_key`(`key`),
  INDEX `credit_shop_items_isActive_sortOrder_idx`(`isActive`, `sortOrder`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable: player_credit_entitlements
CREATE TABLE IF NOT EXISTS `player_credit_entitlements` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `catalogItemId` INTEGER NULL,
  `key` VARCHAR(64) NOT NULL,
  `effectType` ENUM('CASH_BUNDLE', 'HIT_PROTECTION', 'VEHICLE_REPAIR_FINISH', 'VEHICLE_TUNE_RESET', 'ACTION_COOLDOWN_RESET', 'EVENT_BOOST') NOT NULL,
  `status` ENUM('ACTIVE', 'CONSUMED', 'EXPIRED') NOT NULL DEFAULT 'ACTIVE',
  `durationHours` INTEGER NULL,
  `startedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expiresAt` DATETIME(3) NULL,
  `metadataJson` LONGTEXT NULL,

  INDEX `player_credit_entitlements_playerId_status_expiresAt_idx`(`playerId`, `status`, `expiresAt`),
  INDEX `player_credit_entitlements_catalogItemId_fkey`(`catalogItemId`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey: premium_payment_transactions → players
ALTER TABLE `premium_payment_transactions`
  ADD CONSTRAINT `premium_payment_transactions_playerId_fkey`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey: player_credit_transactions → players
ALTER TABLE `player_credit_transactions`
  ADD CONSTRAINT `player_credit_transactions_playerId_fkey`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey: player_credit_entitlements → players
ALTER TABLE `player_credit_entitlements`
  ADD CONSTRAINT `player_credit_entitlements_playerId_fkey`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey: player_credit_entitlements → credit_shop_items
ALTER TABLE `player_credit_entitlements`
  ADD CONSTRAINT `player_credit_entitlements_catalogItemId_fkey`
  FOREIGN KEY (`catalogItemId`) REFERENCES `credit_shop_items`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
