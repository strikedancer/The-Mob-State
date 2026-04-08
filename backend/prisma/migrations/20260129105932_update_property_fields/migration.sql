/*
  Warnings:

  - A unique constraint covering the columns `[propertyId]` on the table `properties` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `countryId` to the `properties` table without a default value. This is not possible if the table is not empty.
  - Added the required column `propertyId` to the `properties` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `crime_attempts` ADD COLUMN `appealedAt` DATETIME(3) NULL;

-- AlterTable
ALTER TABLE `players` ADD COLUMN `currentCountry` VARCHAR(50) NOT NULL DEFAULT 'netherlands',
    ADD COLUMN `fbiHeat` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `wantedLevel` INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `properties` ADD COLUMN `countryId` VARCHAR(50) NOT NULL,
    ADD COLUMN `propertyId` VARCHAR(100) NOT NULL,
    MODIFY `upgradeLevel` INTEGER NOT NULL DEFAULT 1;

-- CreateTable
CREATE TABLE `bank_accounts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `balance` INTEGER NOT NULL DEFAULT 0,
    `interestRate` DOUBLE NOT NULL DEFAULT 0.05,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `bank_accounts_playerId_key`(`playerId`),
    INDEX `bank_accounts_playerId_idx`(`playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `goodType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `inventory_playerId_idx`(`playerId`),
    UNIQUE INDEX `inventory_playerId_goodType_key`(`playerId`, `goodType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `aviation_licenses` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `licenseType` VARCHAR(50) NOT NULL DEFAULT 'basic',
    `purchasePrice` INTEGER NOT NULL,
    `issuedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `aviation_licenses_playerId_key`(`playerId`),
    INDEX `aviation_licenses_playerId_idx`(`playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `aircraft` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `aircraftType` VARCHAR(50) NOT NULL,
    `fuel` INTEGER NOT NULL DEFAULT 0,
    `maxFuel` INTEGER NOT NULL,
    `isBroken` BOOLEAN NOT NULL DEFAULT false,
    `totalFlights` INTEGER NOT NULL DEFAULT 0,
    `purchasePrice` INTEGER NOT NULL,
    `purchasedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `aircraft_playerId_idx`(`playerId`),
    INDEX `aircraft_aircraftType_idx`(`aircraftType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `action_cooldowns` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `actionType` VARCHAR(50) NOT NULL,
    `lastUsedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `action_cooldowns_playerId_idx`(`playerId`),
    INDEX `action_cooldowns_actionType_idx`(`actionType`),
    UNIQUE INDEX `action_cooldowns_playerId_actionType_key`(`playerId`, `actionType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `properties_countryId_idx` ON `properties`(`countryId`);

-- CreateIndex
CREATE UNIQUE INDEX `properties_propertyId_key` ON `properties`(`propertyId`);

-- AddForeignKey
ALTER TABLE `bank_accounts` ADD CONSTRAINT `bank_accounts_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `inventory` ADD CONSTRAINT `inventory_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `aviation_licenses` ADD CONSTRAINT `aviation_licenses_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `aircraft` ADD CONSTRAINT `aircraft_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
