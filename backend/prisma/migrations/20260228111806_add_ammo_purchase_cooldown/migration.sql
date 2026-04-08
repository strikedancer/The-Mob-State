/*
  Warnings:

  - You are about to drop the column `createdAt` on the `ammo_inventory` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `ammo_inventory` table. All the data in the column will be lost.
  - You are about to drop the column `createdAtMs` on the `hit_list` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `hit_list` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `player_security` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `player_security` table. All the data in the column will be lost.
  - You are about to alter the column `hunger` on the `players` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Double`.
  - You are about to alter the column `thirst` on the `players` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Double`.
  - A unique constraint covering the columns `[playerId]` on the table `crew_members` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE `ammo_factories` DROP FOREIGN KEY `fk_ammo_factory_owner`;

-- DropForeignKey
ALTER TABLE `ammo_inventory` DROP FOREIGN KEY `fk_ammo_inventory_player`;

-- DropForeignKey
ALTER TABLE `hit_list` DROP FOREIGN KEY `hit_list_ibfk_1`;

-- DropForeignKey
ALTER TABLE `hit_list` DROP FOREIGN KEY `hit_list_ibfk_2`;

-- DropForeignKey
ALTER TABLE `hit_list` DROP FOREIGN KEY `hit_list_ibfk_3`;

-- DropForeignKey
ALTER TABLE `player_security` DROP FOREIGN KEY `player_security_ibfk_1`;

-- DropForeignKey
ALTER TABLE `shooting_range_stats` DROP FOREIGN KEY `fk_shooting_range_player`;

-- DropIndex
DROP INDEX `completedBy` ON `hit_list`;

-- DropIndex
DROP INDEX `players_currentTravelLeg_idx` ON `players`;

-- DropIndex
DROP INDEX `players_travelingTo_idx` ON `players`;

-- AlterTable
ALTER TABLE `ammo_factories` MODIFY `lastProducedAt` DATETIME(3) NULL,
    MODIFY `lastActiveAt` DATETIME(3) NULL,
    MODIFY `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    MODIFY `updatedAt` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `ammo_inventory` DROP COLUMN `createdAt`,
    DROP COLUMN `updatedAt`,
    MODIFY `quality` DOUBLE NOT NULL DEFAULT 1.0;

-- AlterTable
ALTER TABLE `ammo_market_stock` MODIFY `quality` DOUBLE NOT NULL DEFAULT 1.0,
    MODIFY `updatedAt` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `hit_list` DROP COLUMN `createdAtMs`,
    DROP COLUMN `updatedAt`,
    MODIFY `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    MODIFY `completedAt` DATETIME(3) NULL;

-- AlterTable
ALTER TABLE `inventory` ADD COLUMN `condition` INTEGER NOT NULL DEFAULT 100,
    ADD COLUMN `purchasePrice` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `purchasedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable
ALTER TABLE `player_security` DROP COLUMN `createdAt`,
    DROP COLUMN `updatedAt`;

-- AlterTable
ALTER TABLE `players` ADD COLUMN `allowMessages` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `avatar` VARCHAR(100) NULL DEFAULT 'default_1',
    ADD COLUMN `banReason` TEXT NULL,
    ADD COLUMN `bannedUntil` DATETIME(3) NULL,
    ADD COLUMN `email` VARCHAR(255) NULL,
    ADD COLUMN `emailFriendAccepted` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `emailFriendRequest` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `emailVerified` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `intensiveCareUntil` DATETIME(3) NULL,
    ADD COLUMN `inventory_slots_used` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `isBanned` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `isVip` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `jailRelease` DATETIME(3) NULL,
    ADD COLUMN `lastAmmoPurchaseAt` DATETIME(3) NULL,
    ADD COLUMN `lastAvatarChange` DATETIME(3) NULL,
    ADD COLUMN `lastHospitalVisit` DATETIME(3) NULL,
    ADD COLUMN `lastUsernameChange` DATETIME(3) NULL,
    ADD COLUMN `max_inventory_slots` INTEGER NOT NULL DEFAULT 5,
    ADD COLUMN `notifyFriendAccepted` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `notifyFriendRequest` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `preferredLanguage` VARCHAR(5) NOT NULL DEFAULT 'nl',
    ADD COLUMN `reputation` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `resetPasswordToken` VARCHAR(255) NULL,
    ADD COLUMN `resetPasswordTokenExpiry` DATETIME(3) NULL,
    ADD COLUMN `verificationToken` VARCHAR(255) NULL,
    ADD COLUMN `verificationTokenExpiry` DATETIME(3) NULL,
    ADD COLUMN `vipExpiresAt` DATETIME(3) NULL,
    MODIFY `hunger` DOUBLE NOT NULL DEFAULT 100,
    MODIFY `thirst` DOUBLE NOT NULL DEFAULT 100;

-- AlterTable
ALTER TABLE `properties` MODIFY `playerId` INTEGER NULL;

-- AlterTable
ALTER TABLE `property_storage_capacity` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    MODIFY `description` TEXT NULL;

-- AlterTable
ALTER TABLE `shooting_range_stats` MODIFY `accuracyBonus` DOUBLE NOT NULL DEFAULT 0.0,
    MODIFY `lastTrainedAt` DATETIME(3) NULL,
    MODIFY `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    MODIFY `updatedAt` DATETIME(3) NOT NULL;

-- CreateTable
CREATE TABLE `player_backpacks` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `backpackId` VARCHAR(50) NOT NULL,
    `purchasedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `player_backpacks_playerId_key`(`playerId`),
    INDEX `player_backpacks_playerId_idx`(`playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `friendships` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `requesterId` INTEGER NOT NULL,
    `addresseeId` INTEGER NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `friendships_requesterId_idx`(`requesterId`),
    INDEX `friendships_addresseeId_idx`(`addresseeId`),
    INDEX `friendships_status_idx`(`status`),
    UNIQUE INDEX `friendships_requesterId_addresseeId_key`(`requesterId`, `addresseeId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `direct_messages` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `senderId` INTEGER NOT NULL,
    `receiverId` INTEGER NOT NULL,
    `message` TEXT NOT NULL,
    `read` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `direct_messages_senderId_idx`(`senderId`),
    INDEX `direct_messages_receiverId_idx`(`receiverId`),
    INDEX `direct_messages_read_idx`(`read`),
    INDEX `direct_messages_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_messages` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `message` TEXT NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crew_messages_crewId_idx`(`crewId`),
    INDEX `crew_messages_playerId_idx`(`playerId`),
    INDEX `crew_messages_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_join_requests` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `crew_join_requests_crewId_idx`(`crewId`),
    INDEX `crew_join_requests_playerId_idx`(`playerId`),
    INDEX `crew_join_requests_status_idx`(`status`),
    UNIQUE INDEX `crew_join_requests_crewId_playerId_key`(`crewId`, `playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_heist_attempts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `heistId` VARCHAR(50) NOT NULL,
    `success` BOOLEAN NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crew_heist_attempts_crewId_idx`(`crewId`),
    INDEX `crew_heist_attempts_heistId_idx`(`heistId`),
    INDEX `crew_heist_attempts_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_hq_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_hq_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_car_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_car_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_boat_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_boat_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_weapon_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_weapon_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_ammo_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_ammo_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_drug_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_drug_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_cash_storage_buildings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `style` ENUM('camping', 'rural', 'city', 'villa') NOT NULL DEFAULT 'camping',
    `level` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `crew_cash_storage_buildings_crewId_key`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_car_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `vehicleId` VARCHAR(100) NOT NULL,
    `condition` INTEGER NOT NULL DEFAULT 100,
    `fuelLevel` INTEGER NOT NULL DEFAULT 100,
    `stolenInCountry` VARCHAR(50) NULL,
    `addedByPlayerId` INTEGER NOT NULL,
    `addedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crew_car_inventory_crewId_idx`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_boat_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `vehicleId` VARCHAR(100) NOT NULL,
    `condition` INTEGER NOT NULL DEFAULT 100,
    `fuelLevel` INTEGER NOT NULL DEFAULT 100,
    `stolenInCountry` VARCHAR(50) NULL,
    `addedByPlayerId` INTEGER NOT NULL,
    `addedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crew_boat_inventory_crewId_idx`(`crewId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_weapon_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `weaponId` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `averageCondition` INTEGER NOT NULL DEFAULT 100,
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `crew_weapon_inventory_crewId_idx`(`crewId`),
    UNIQUE INDEX `crew_weapon_inventory_crewId_weaponId_key`(`crewId`, `weaponId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_ammo_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `ammoType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `crew_ammo_inventory_crewId_idx`(`crewId`),
    UNIQUE INDEX `crew_ammo_inventory_crewId_ammoType_key`(`crewId`, `ammoType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_drug_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `goodType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,
    `averagePurchasePrice` INTEGER NOT NULL DEFAULT 0,
    `averageCondition` INTEGER NOT NULL DEFAULT 100,
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `crew_drug_inventory_crewId_idx`(`crewId`),
    UNIQUE INDEX `crew_drug_inventory_crewId_goodType_key`(`crewId`, `goodType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `casino_ownerships` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `casinoId` VARCHAR(100) NOT NULL,
    `ownerId` INTEGER NOT NULL,
    `purchasePrice` INTEGER NOT NULL,
    `bankroll` INTEGER NOT NULL DEFAULT 0,
    `totalReceived` INTEGER NOT NULL DEFAULT 0,
    `totalPaidOut` INTEGER NOT NULL DEFAULT 0,
    `lastLowBalanceNotification` DATETIME(3) NULL,
    `purchasedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `casino_ownerships_casinoId_key`(`casinoId`),
    INDEX `casino_ownerships_ownerId_idx`(`ownerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `casino_transactions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `casinoId` VARCHAR(100) NOT NULL,
    `ownerId` INTEGER NOT NULL,
    `gameType` VARCHAR(50) NOT NULL,
    `betAmount` INTEGER NOT NULL,
    `payout` INTEGER NOT NULL DEFAULT 0,
    `ownerCut` INTEGER NOT NULL DEFAULT 0,
    `result` JSON NOT NULL,
    `rngSeed` VARCHAR(255) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `casino_transactions_playerId_idx`(`playerId`),
    INDEX `casino_transactions_casinoId_idx`(`casinoId`),
    INDEX `casino_transactions_ownerId_idx`(`ownerId`),
    INDEX `casino_transactions_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `weapon_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `weaponId` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `condition` INTEGER NOT NULL DEFAULT 100,
    `purchasedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `weapon_inventory_playerId_idx`(`playerId`),
    UNIQUE INDEX `weapon_inventory_playerId_weaponId_key`(`playerId`, `weaponId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `garages` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `capacity` INTEGER NOT NULL DEFAULT 5,
    `location` VARCHAR(50) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `garages_playerId_idx`(`playerId`),
    UNIQUE INDEX `garages_playerId_location_key`(`playerId`, `location`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `garage_upgrades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `garageId` INTEGER NOT NULL,
    `upgradeLevel` INTEGER NOT NULL DEFAULT 1,
    `capacityBonus` INTEGER NOT NULL DEFAULT 5,
    `upgradeCost` INTEGER NOT NULL,
    `upgradedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `garage_upgrades_garageId_idx`(`garageId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `marinas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `capacity` INTEGER NOT NULL DEFAULT 3,
    `location` VARCHAR(50) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `marinas_playerId_idx`(`playerId`),
    UNIQUE INDEX `marinas_playerId_location_key`(`playerId`, `location`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `marina_upgrades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `marinaId` INTEGER NOT NULL,
    `upgradeLevel` INTEGER NOT NULL DEFAULT 1,
    `capacityBonus` INTEGER NOT NULL DEFAULT 3,
    `upgradeCost` INTEGER NOT NULL,
    `upgradedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `marina_upgrades_marinaId_idx`(`marinaId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `vehicleType` VARCHAR(20) NOT NULL,
    `vehicleId` VARCHAR(100) NOT NULL,
    `stolenInCountry` VARCHAR(50) NOT NULL,
    `currentLocation` VARCHAR(50) NOT NULL,
    `condition` INTEGER NOT NULL DEFAULT 100,
    `fuelLevel` INTEGER NOT NULL DEFAULT 100,
    `marketListing` BOOLEAN NOT NULL DEFAULT false,
    `askingPrice` INTEGER NULL,
    `stolenAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `transportStatus` VARCHAR(20) NULL,
    `transportArrivalTime` DATETIME(3) NULL,
    `transportDestination` VARCHAR(50) NULL,

    INDEX `vehicle_inventory_playerId_idx`(`playerId`),
    INDEX `vehicle_inventory_vehicleType_idx`(`vehicleType`),
    INDEX `vehicle_inventory_currentLocation_idx`(`currentLocation`),
    INDEX `vehicle_inventory_marketListing_idx`(`marketListing`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `admins` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `passwordHash` VARCHAR(255) NOT NULL,
    `role` ENUM('SUPER_ADMIN', 'MODERATOR', 'VIEWER') NOT NULL DEFAULT 'VIEWER',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `lastLoginAt` DATETIME(3) NULL,

    UNIQUE INDEX `admins_username_key`(`username`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `adminId` INTEGER NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    `targetType` VARCHAR(50) NULL,
    `targetId` VARCHAR(100) NULL,
    `details` TEXT NULL,
    `ipAddress` VARCHAR(45) NULL,
    `userAgent` VARCHAR(255) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `audit_logs_adminId_idx`(`adminId`),
    INDEX `audit_logs_action_idx`(`action`),
    INDEX `audit_logs_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_devices` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `deviceToken` VARCHAR(500) NOT NULL,
    `deviceType` ENUM('android', 'ios', 'web') NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `player_devices_deviceToken_key`(`deviceToken`(255)),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_activities` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `activityType` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `details` JSON NOT NULL,
    `isPublic` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `player_activities_playerId_createdAt_idx`(`playerId`, `createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crime_tools` (
    `id` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `basePrice` INTEGER NOT NULL,
    `maxDurability` INTEGER NOT NULL,
    `loseChance` DOUBLE NOT NULL,
    `wearPerUse` INTEGER NOT NULL,
    `requiredFor` JSON NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_tools` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `toolId` VARCHAR(50) NOT NULL,
    `durability` INTEGER NOT NULL,
    `location` VARCHAR(50) NOT NULL DEFAULT 'carried',
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `player_tools_playerId_idx`(`playerId`),
    INDEX `player_tools_playerId_location_idx`(`playerId`, `location`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `npc_players` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `npcType` ENUM('MATIG', 'GEMIDDELD', 'CONTINU') NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `lastActivityAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `totalCrimes` INTEGER NOT NULL DEFAULT 0,
    `totalJobs` INTEGER NOT NULL DEFAULT 0,
    `totalMoneyEarned` BIGINT NOT NULL DEFAULT 0,
    `totalXpEarned` INTEGER NOT NULL DEFAULT 0,
    `totalArrests` INTEGER NOT NULL DEFAULT 0,
    `totalJailTime` INTEGER NOT NULL DEFAULT 0,
    `crimesPerHour` DOUBLE NOT NULL DEFAULT 0,
    `jobsPerHour` DOUBLE NOT NULL DEFAULT 0,
    `simulatedOnlineHours` DOUBLE NOT NULL DEFAULT 0,

    UNIQUE INDEX `npc_players_playerId_key`(`playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `npc_activity_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `npcId` INTEGER NOT NULL,
    `activityType` VARCHAR(50) NOT NULL,
    `details` JSON NOT NULL,
    `success` BOOLEAN NOT NULL,
    `moneyEarned` INTEGER NOT NULL DEFAULT 0,
    `xpEarned` INTEGER NOT NULL DEFAULT 0,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `npc_activity_logs_npcId_timestamp_idx`(`npcId`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tool_loadouts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `tool_loadouts_player_id_idx`(`player_id`),
    INDEX `tool_loadouts_player_id_is_active_idx`(`player_id`, `is_active`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `loadout_tools` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `loadout_id` INTEGER NOT NULL,
    `tool_id` VARCHAR(50) NOT NULL,
    `slot_position` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `loadout_tools_loadout_id_idx`(`loadout_id`),
    UNIQUE INDEX `loadout_tools_loadout_id_tool_id_key`(`loadout_id`, `tool_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `inventory_upgrades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `upgrade_type` VARCHAR(50) NOT NULL,
    `bonus_slots` INTEGER NOT NULL,
    `purchased_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `inventory_upgrades_player_id_idx`(`player_id`),
    UNIQUE INDEX `inventory_upgrades_player_id_upgrade_type_key`(`player_id`, `upgrade_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tool_transfers` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `tool_id` VARCHAR(50) NOT NULL,
    `from_location` VARCHAR(50) NOT NULL,
    `to_location` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `durability` INTEGER NULL,
    `transferred_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `tool_transfers_player_id_idx`(`player_id`),
    INDEX `tool_transfers_transferred_at_idx`(`transferred_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drug_production` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `propertyId` INTEGER NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL,
    `startedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `finishesAt` DATETIME(3) NOT NULL,
    `completed` BOOLEAN NOT NULL DEFAULT false,
    `collected` BOOLEAN NOT NULL DEFAULT false,

    INDEX `drug_production_playerId_idx`(`playerId`),
    INDEX `drug_production_finishesAt_idx`(`finishesAt`),
    INDEX `drug_production_completed_idx`(`completed`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drug_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,

    INDEX `drug_inventory_playerId_idx`(`playerId`),
    UNIQUE INDEX `drug_inventory_playerId_drugType_key`(`playerId`, `drugType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `production_materials` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `materialId` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,

    INDEX `production_materials_playerId_idx`(`playerId`),
    UNIQUE INDEX `production_materials_playerId_materialId_key`(`playerId`, `materialId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `crew_members_playerId_key` ON `crew_members`(`playerId`);

-- CreateIndex
CREATE INDEX `player_security_playerId_idx` ON `player_security`(`playerId`);

-- AddForeignKey
ALTER TABLE `player_backpacks` ADD CONSTRAINT `player_backpacks_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_members` ADD CONSTRAINT `crew_members_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `friendships` ADD CONSTRAINT `friendships_requesterId_fkey` FOREIGN KEY (`requesterId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `friendships` ADD CONSTRAINT `friendships_addresseeId_fkey` FOREIGN KEY (`addresseeId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `direct_messages` ADD CONSTRAINT `direct_messages_senderId_fkey` FOREIGN KEY (`senderId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `direct_messages` ADD CONSTRAINT `direct_messages_receiverId_fkey` FOREIGN KEY (`receiverId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_messages` ADD CONSTRAINT `crew_messages_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_messages` ADD CONSTRAINT `crew_messages_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_join_requests` ADD CONSTRAINT `crew_join_requests_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_join_requests` ADD CONSTRAINT `crew_join_requests_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_heist_attempts` ADD CONSTRAINT `crew_heist_attempts_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_hq_buildings` ADD CONSTRAINT `crew_hq_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_car_storage_buildings` ADD CONSTRAINT `crew_car_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_boat_storage_buildings` ADD CONSTRAINT `crew_boat_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_weapon_storage_buildings` ADD CONSTRAINT `crew_weapon_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_ammo_storage_buildings` ADD CONSTRAINT `crew_ammo_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_drug_storage_buildings` ADD CONSTRAINT `crew_drug_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_cash_storage_buildings` ADD CONSTRAINT `crew_cash_storage_buildings_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_car_inventory` ADD CONSTRAINT `crew_car_inventory_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_boat_inventory` ADD CONSTRAINT `crew_boat_inventory_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_weapon_inventory` ADD CONSTRAINT `crew_weapon_inventory_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_ammo_inventory` ADD CONSTRAINT `crew_ammo_inventory_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `crew_drug_inventory` ADD CONSTRAINT `crew_drug_inventory_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `casino_ownerships` ADD CONSTRAINT `casino_ownerships_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `weapon_inventory` ADD CONSTRAINT `weapon_inventory_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ammo_inventory` ADD CONSTRAINT `ammo_inventory_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ammo_factories` ADD CONSTRAINT `ammo_factories_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `shooting_range_stats` ADD CONSTRAINT `shooting_range_stats_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `garages` ADD CONSTRAINT `garages_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `garage_upgrades` ADD CONSTRAINT `garage_upgrades_garageId_fkey` FOREIGN KEY (`garageId`) REFERENCES `garages`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `marinas` ADD CONSTRAINT `marinas_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `marina_upgrades` ADD CONSTRAINT `marina_upgrades_marinaId_fkey` FOREIGN KEY (`marinaId`) REFERENCES `marinas`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vehicle_inventory` ADD CONSTRAINT `vehicle_inventory_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `audit_logs` ADD CONSTRAINT `audit_logs_adminId_fkey` FOREIGN KEY (`adminId`) REFERENCES `admins`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_devices` ADD CONSTRAINT `player_devices_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_activities` ADD CONSTRAINT `player_activities_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_tools` ADD CONSTRAINT `player_tools_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_tools` ADD CONSTRAINT `player_tools_toolId_fkey` FOREIGN KEY (`toolId`) REFERENCES `crime_tools`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `npc_activity_logs` ADD CONSTRAINT `npc_activity_logs_npcId_fkey` FOREIGN KEY (`npcId`) REFERENCES `npc_players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tool_loadouts` ADD CONSTRAINT `tool_loadouts_player_id_fkey` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `loadout_tools` ADD CONSTRAINT `loadout_tools_loadout_id_fkey` FOREIGN KEY (`loadout_id`) REFERENCES `tool_loadouts`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `inventory_upgrades` ADD CONSTRAINT `inventory_upgrades_player_id_fkey` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tool_transfers` ADD CONSTRAINT `tool_transfers_player_id_fkey` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drug_production` ADD CONSTRAINT `drug_production_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drug_production` ADD CONSTRAINT `drug_production_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `properties`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drug_inventory` ADD CONSTRAINT `drug_inventory_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `production_materials` ADD CONSTRAINT `production_materials_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `hit_list` ADD CONSTRAINT `hit_list_targetId_fkey` FOREIGN KEY (`targetId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `hit_list` ADD CONSTRAINT `hit_list_placedById_fkey` FOREIGN KEY (`placedById`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `hit_list` ADD CONSTRAINT `hit_list_completedBy_fkey` FOREIGN KEY (`completedBy`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_security` ADD CONSTRAINT `player_security_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- RedefineIndex
CREATE UNIQUE INDEX `ammo_factories_countryId_key` ON `ammo_factories`(`countryId`);
DROP INDEX `countryId` ON `ammo_factories`;

-- RedefineIndex
CREATE INDEX `ammo_factories_ownerId_idx` ON `ammo_factories`(`ownerId`);
DROP INDEX `idx_ownerId` ON `ammo_factories`;

-- RedefineIndex
CREATE INDEX `ammo_inventory_playerId_idx` ON `ammo_inventory`(`playerId`);
DROP INDEX `idx_playerId` ON `ammo_inventory`;

-- RedefineIndex
CREATE UNIQUE INDEX `ammo_inventory_playerId_ammoType_key` ON `ammo_inventory`(`playerId`, `ammoType`);
DROP INDEX `uniq_player_ammo` ON `ammo_inventory`;

-- RedefineIndex
CREATE INDEX `ammo_market_stock_countryId_idx` ON `ammo_market_stock`(`countryId`);
DROP INDEX `idx_country` ON `ammo_market_stock`;

-- RedefineIndex
CREATE UNIQUE INDEX `ammo_market_stock_countryId_ammoType_key` ON `ammo_market_stock`(`countryId`, `ammoType`);
DROP INDEX `uniq_country_ammo` ON `ammo_market_stock`;

-- RedefineIndex
CREATE INDEX `hit_list_placedById_idx` ON `hit_list`(`placedById`);
DROP INDEX `idx_placedById` ON `hit_list`;

-- RedefineIndex
CREATE INDEX `hit_list_status_idx` ON `hit_list`(`status`);
DROP INDEX `idx_status` ON `hit_list`;

-- RedefineIndex
CREATE INDEX `hit_list_targetId_idx` ON `hit_list`(`targetId`);
DROP INDEX `idx_targetId` ON `hit_list`;

-- RedefineIndex
CREATE UNIQUE INDEX `player_security_playerId_key` ON `player_security`(`playerId`);
DROP INDEX `playerId` ON `player_security`;

-- RedefineIndex
CREATE UNIQUE INDEX `property_storage_capacity_property_type_key` ON `property_storage_capacity`(`property_type`);
DROP INDEX `property_type` ON `property_storage_capacity`;

-- RedefineIndex
CREATE INDEX `shooting_range_stats_playerId_idx` ON `shooting_range_stats`(`playerId`);
DROP INDEX `idx_playerId` ON `shooting_range_stats`;

-- RedefineIndex
CREATE UNIQUE INDEX `shooting_range_stats_playerId_key` ON `shooting_range_stats`(`playerId`);
DROP INDEX `playerId` ON `shooting_range_stats`;
