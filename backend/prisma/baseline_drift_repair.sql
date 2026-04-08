-- DropForeignKey
ALTER TABLE `drug_inventory` DROP FOREIGN KEY `drug_inventory_playerId_fkey`;

-- DropIndex
DROP INDEX `drug_inventory_playerId_drugType_key` ON `drug_inventory`;

-- AlterTable
ALTER TABLE `crews` MODIFY `vipExpiresAt` datetime(3) NULL;

-- AlterTable
ALTER TABLE `crime_attempts` ADD COLUMN `cargoUsed` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `lootStolen` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `outcome` VARCHAR(50) NOT NULL DEFAULT 'success',
    ADD COLUMN `outcomeFail` TEXT NULL,
    ADD COLUMN `toolConditionBefore` INTEGER NULL,
    ADD COLUMN `toolDamageSustained` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `usedToolId` VARCHAR(50) NULL,
    ADD COLUMN `vehicleCargoBonus` DOUBLE NOT NULL DEFAULT 1,
    ADD COLUMN `vehicleConditionUsed` DOUBLE NULL,
    ADD COLUMN `vehicleSpeedBonus` DOUBLE NOT NULL DEFAULT 1,
    ADD COLUMN `vehicleStealthBonus` DOUBLE NOT NULL DEFAULT 1;

-- AlterTable
ALTER TABLE `drug_inventory` ADD COLUMN `quality` VARCHAR(2) NOT NULL DEFAULT 'C';

-- AlterTable
ALTER TABLE `drug_production` ADD COLUMN `facilityId` INTEGER NULL,
    ADD COLUMN `quality` VARCHAR(2) NOT NULL DEFAULT 'C',
    ADD COLUMN `qualityMultiplier` DOUBLE NOT NULL DEFAULT 1;

-- AlterTable
ALTER TABLE `players` ADD COLUMN `autoCollectDrugs` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `drugHeat` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `lastDrugActionAt` DATETIME(0) NULL,
    ADD COLUMN `lastProstituteRecruitment` DATETIME(3) NULL;

-- AlterTable
ALTER TABLE `vehicles` ADD COLUMN `armor` INTEGER NOT NULL DEFAULT 50,
    ADD COLUMN `cargo` INTEGER NOT NULL DEFAULT 50,
    ADD COLUMN `condition` DOUBLE NOT NULL DEFAULT 100,
    ADD COLUMN `speed` INTEGER NOT NULL DEFAULT 50,
    ADD COLUMN `stealth` INTEGER NOT NULL DEFAULT 50,
    ADD COLUMN `updatedAt` DATETIME(3) NOT NULL;

-- CreateTable
CREATE TABLE `crypto_assets` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `symbol` VARCHAR(12) NOT NULL,
    `name` VARCHAR(80) NOT NULL,
    `base_price` DECIMAL(24, 8) NOT NULL,
    `current_price` DECIMAL(24, 8) NOT NULL,
    `volatility` DECIMAL(10, 4) NOT NULL,
    `trend_bias` DECIMAL(10, 4) NOT NULL DEFAULT 0.0000,
    `icon_key` VARCHAR(50) NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_assets_symbol`(`symbol` ASC),
    INDEX `idx_crypto_assets_updated_at`(`updated_at` ASC),
    UNIQUE INDEX `symbol`(`symbol` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_holdings` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `asset_symbol` VARCHAR(12) NOT NULL,
    `quantity` DECIMAL(24, 8) NOT NULL DEFAULT 0.00000000,
    `avg_buy_price` DECIMAL(24, 8) NOT NULL DEFAULT 0.00000000,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_holdings_player`(`player_id` ASC),
    INDEX `idx_crypto_holdings_symbol`(`asset_symbol` ASC),
    UNIQUE INDEX `uniq_crypto_holdings_player_asset`(`player_id` ASC, `asset_symbol` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_leaderboard_rewards` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `week_start_at` DATETIME(0) NOT NULL,
    `week_end_at` DATETIME(0) NOT NULL,
    `rank` INTEGER NOT NULL,
    `player_id` INTEGER NOT NULL,
    `reward_money` DECIMAL(24, 2) NOT NULL,
    `realized_profit` DECIMAL(24, 2) NOT NULL,
    `traded_volume` DECIMAL(24, 2) NOT NULL,
    `trade_count` INTEGER NOT NULL,
    `paid_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_lb_rewards_player`(`player_id` ASC, `paid_at` ASC),
    UNIQUE INDEX `uniq_crypto_lb_week_player`(`week_start_at` ASC, `player_id` ASC),
    UNIQUE INDEX `uniq_crypto_lb_week_rank`(`week_start_at` ASC, `rank` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_leaderboard_state` (
    `id` TINYINT NOT NULL,
    `week_start_at` DATETIME(0) NOT NULL,
    `week_end_at` DATETIME(0) NOT NULL,
    `last_processed_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_market_state` (
    `id` TINYINT NOT NULL,
    `current_regime` VARCHAR(12) NOT NULL DEFAULT 'SIDEWAYS',
    `last_regime_change_at` DATETIME(0) NULL,
    `last_news_at` DATETIME(0) NULL,
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_mission_progress` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `mission_key` VARCHAR(80) NOT NULL,
    `mission_type` VARCHAR(16) NOT NULL,
    `period_key` VARCHAR(20) NOT NULL,
    `progress_value` DECIMAL(24, 8) NOT NULL DEFAULT 0.00000000,
    `target_value` DECIMAL(24, 8) NOT NULL,
    `reward_money` DECIMAL(24, 2) NOT NULL DEFAULT 0.00,
    `completed_at` DATETIME(0) NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_mission_player_period`(`player_id` ASC, `period_key` ASC),
    UNIQUE INDEX `uniq_crypto_mission_player_key_period`(`player_id` ASC, `mission_key` ASC, `period_key` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_orders` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `asset_symbol` VARCHAR(12) NOT NULL,
    `order_type` VARCHAR(20) NOT NULL,
    `side` VARCHAR(10) NOT NULL,
    `quantity` DECIMAL(24, 8) NOT NULL,
    `target_price` DECIMAL(24, 8) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    `filled_price` DECIMAL(24, 8) NULL,
    `failure_reason` VARCHAR(120) NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_orders_open`(`status` ASC, `asset_symbol` ASC),
    INDEX `idx_crypto_orders_player`(`player_id` ASC),
    INDEX `idx_crypto_orders_symbol`(`asset_symbol` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_price_history` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `asset_symbol` VARCHAR(12) NOT NULL,
    `price` DECIMAL(24, 8) NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_price_history_symbol_time`(`asset_symbol` ASC, `created_at` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crypto_transactions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `asset_symbol` VARCHAR(12) NOT NULL,
    `side` VARCHAR(8) NOT NULL,
    `quantity` DECIMAL(24, 8) NOT NULL,
    `price` DECIMAL(24, 8) NOT NULL,
    `total_value` DECIMAL(24, 8) NOT NULL,
    `realized_profit` DECIMAL(24, 8) NOT NULL DEFAULT 0.00000000,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_crypto_transactions_created_at`(`created_at` ASC),
    INDEX `idx_crypto_transactions_player`(`player_id` ASC),
    INDEX `idx_crypto_transactions_symbol`(`asset_symbol` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drug_facilities` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `country` VARCHAR(50) NULL DEFAULT 'netherlands',
    `facilityType` VARCHAR(30) NOT NULL,
    `slots` INTEGER NOT NULL DEFAULT 1,
    `purchasedAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `drug_facilities_playerId_country_facilityType_key`(`playerId` ASC, `country` ASC, `facilityType` ASC),
    INDEX `drug_facilities_playerId_idx`(`playerId` ASC),
    INDEX `idx_facilities_country`(`country` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drug_facility_upgrades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `facilityId` INTEGER NOT NULL,
    `upgradeType` VARCHAR(50) NOT NULL,
    `level` INTEGER NOT NULL DEFAULT 1,
    `upgradedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `drug_facility_upgrades_facilityId_idx`(`facilityId` ASC),
    UNIQUE INDEX `drug_facility_upgrades_facilityId_upgradeType_key`(`facilityId` ASC, `upgradeType` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `event_participations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `eventId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `prostituteId` INTEGER NOT NULL,
    `earnings` DOUBLE NOT NULL DEFAULT 0,
    `status` VARCHAR(20) NOT NULL DEFAULT 'active',
    `participatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `completedAt` DATETIME(3) NULL,

    INDEX `event_participations_eventId_fkey`(`eventId` ASC),
    INDEX `event_participations_playerId_eventId_idx`(`playerId` ASC, `eventId` ASC),
    UNIQUE INDEX `event_participations_prostituteId_eventId_key`(`prostituteId` ASC, `eventId` ASC),
    INDEX `event_participations_status_idx`(`status` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `gym_stats` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `sessionsCompleted` INTEGER NOT NULL DEFAULT 0,
    `strengthBonus` DOUBLE NOT NULL DEFAULT 0,
    `lastTrainedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `gym_stats_playerId_idx`(`playerId` ASC),
    UNIQUE INDEX `gym_stats_playerId_key`(`playerId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_dj_shifts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `djId` INTEGER NOT NULL,
    `shiftStartAt` DATETIME(0) NOT NULL,
    `shiftEndAt` DATETIME(0) NOT NULL,
    `costPaid` INTEGER NOT NULL,
    `crowdBoost` FLOAT NULL DEFAULT 1,
    `vibeBoost` VARCHAR(20) NULL,

    INDEX `djId`(`djId` ASC),
    INDEX `venueId`(`venueId` ASC, `shiftStartAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_djs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `djName` VARCHAR(100) NOT NULL,
    `skillLevel` INTEGER NULL DEFAULT 1,
    `baseCostPerHour` INTEGER NULL DEFAULT 5000,
    `reputation` FLOAT NULL DEFAULT 0.5,
    `isAvailable` BOOLEAN NULL DEFAULT true,
    `profileImage` VARCHAR(255) NULL,
    `specialty` VARCHAR(50) NULL,

    INDEX `skillLevel`(`skillLevel` ASC, `isAvailable` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_drug_inventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quality` VARCHAR(2) NULL DEFAULT 'C',
    `quantity` INTEGER NULL DEFAULT 0,
    `basePrice` INTEGER NOT NULL,
    `storedAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updatedAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `venueId`(`venueId` ASC, `drugType` ASC, `quality` ASC),
    INDEX `venueId_2`(`venueId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_events` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `eventType` VARCHAR(50) NOT NULL,
    `eventName` VARCHAR(100) NOT NULL,
    `startsAt` DATETIME(0) NOT NULL,
    `endsAt` DATETIME(0) NOT NULL,
    `expectedVisitors` INTEGER NULL DEFAULT 0,
    `investment` INTEGER NULL DEFAULT 0,
    `actualVisitors` INTEGER NULL,
    `eventSuccess` BOOLEAN NULL,
    `revenue` INTEGER NULL DEFAULT 0,

    INDEX `venueId`(`venueId` ASC, `startsAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_prostitute_assignments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `venueId` INTEGER NOT NULL,
    `prostituteId` INTEGER NOT NULL,
    `assignedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `releasedAt` DATETIME(0) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    INDEX `idx_npa_player_venue`(`playerId` ASC, `venueId` ASC),
    INDEX `idx_npa_prostitute`(`prostituteId` ASC),
    INDEX `idx_npa_venue_active`(`venueId` ASC, `isActive` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_sales` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quality` VARCHAR(2) NOT NULL,
    `quantitySold` INTEGER NOT NULL,
    `unitPrice` INTEGER NOT NULL,
    `totalRevenue` INTEGER NOT NULL,
    `crowdSize` INTEGER NOT NULL,
    `crowdVibe` VARCHAR(30) NOT NULL,
    `saleTime` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `crowdVibe`(`crowdVibe` ASC),
    INDEX `venueId`(`venueId` ASC, `saleTime` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_season_rewards` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `seasonKey` VARCHAR(40) NOT NULL,
    `weekStartAt` DATETIME(0) NOT NULL,
    `weekEndAt` DATETIME(0) NOT NULL,
    `rank` INTEGER NOT NULL,
    `venueId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `rewardAmount` INTEGER NOT NULL,
    `score` BIGINT NOT NULL DEFAULT 0,
    `weeklyRevenue` BIGINT NOT NULL DEFAULT 0,
    `weeklyTheftLoss` BIGINT NOT NULL DEFAULT 0,
    `paidAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `fk_nightclub_season_rewards_venue`(`venueId` ASC),
    INDEX `idx_nightclub_season_key_week`(`seasonKey` ASC, `weekStartAt` ASC),
    INDEX `idx_nightclub_season_player_paid`(`playerId` ASC, `paidAt` ASC),
    UNIQUE INDEX `uq_nightclub_season_rank`(`weekStartAt` ASC, `rank` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_season_state` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `seasonKey` VARCHAR(40) NOT NULL,
    `seasonStartAt` DATETIME(0) NOT NULL,
    `seasonEndAt` DATETIME(0) NOT NULL,
    `lastProcessedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `createdAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updatedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `seasonKey`(`seasonKey` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_security_guards` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `guardName` VARCHAR(100) NOT NULL,
    `skillLevel` INTEGER NULL DEFAULT 1,
    `baseCostPerHour` INTEGER NULL DEFAULT 3000,
    `reputation` FLOAT NULL DEFAULT 0.5,
    `isAvailable` BOOLEAN NULL DEFAULT true,
    `profileImage` VARCHAR(255) NULL,
    `specialty` VARCHAR(50) NULL,

    INDEX `skillLevel`(`skillLevel` ASC, `isAvailable` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_security_shifts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `guardId` INTEGER NOT NULL,
    `shiftStartAt` DATETIME(0) NOT NULL,
    `shiftEndAt` DATETIME(0) NOT NULL,
    `costPaid` INTEGER NOT NULL,
    `theftReduction` FLOAT NULL DEFAULT 0.2,
    `incidentCount` INTEGER NULL DEFAULT 0,

    INDEX `guardId`(`guardId` ASC),
    INDEX `venueId`(`venueId` ASC, `shiftStartAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_thefts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `venueId` INTEGER NOT NULL,
    `theftType` VARCHAR(30) NOT NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quality` VARCHAR(2) NOT NULL,
    `quantityStolen` INTEGER NOT NULL,
    `valueLost` INTEGER NOT NULL,
    `preventionChance` FLOAT NULL DEFAULT 0,
    `occurredAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `theftType`(`theftType` ASC),
    INDEX `venueId`(`venueId` ASC, `occurredAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nightclub_venues` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `propertyId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `country` VARCHAR(50) NOT NULL,
    `currentDJId` INTEGER NULL,
    `djContractStartsAt` DATETIME(0) NULL,
    `djContractEndsAt` DATETIME(0) NULL,
    `crowdSize` INTEGER NULL DEFAULT 0,
    `crowdVibe` VARCHAR(30) NULL DEFAULT 'chill',
    `lastUpdateAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `totalRevenueAllTime` BIGINT NULL DEFAULT 0,
    `totalRevenuePeriod` INTEGER NULL DEFAULT 0,
    `lastRevenueCalc` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `marketingSpend` INTEGER NULL DEFAULT 0,
    `isOpen` BOOLEAN NULL DEFAULT true,
    `createdAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updatedAt` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `country`(`country` ASC),
    UNIQUE INDEX `currentDJId`(`currentDJId` ASC),
    INDEX `currentDJId_2`(`currentDJId` ASC),
    INDEX `playerId`(`playerId` ASC),
    UNIQUE INDEX `propertyId`(`propertyId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_notification_preferences` (
    `player_id` INTEGER NOT NULL,
    `push_crypto_trade` BOOLEAN NOT NULL DEFAULT true,
    `push_crypto_price_alert` BOOLEAN NOT NULL DEFAULT true,
    `push_crypto_order` BOOLEAN NOT NULL DEFAULT true,
    `push_crypto_mission` BOOLEAN NOT NULL DEFAULT true,
    `inapp_crypto_trade` BOOLEAN NOT NULL DEFAULT true,
    `inapp_crypto_price_alert` BOOLEAN NOT NULL DEFAULT true,
    `inapp_crypto_order` BOOLEAN NOT NULL DEFAULT true,
    `inapp_crypto_mission` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `push_crypto_leaderboard` BOOLEAN NOT NULL DEFAULT true,
    `inapp_crypto_leaderboard` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`player_id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_selected_vehicles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `vehicleId` INTEGER NOT NULL,
    `selectedFor` VARCHAR(50) NOT NULL DEFAULT 'robbery',
    `selectedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `player_selected_vehicles_playerId_idx`(`playerId` ASC),
    UNIQUE INDEX `player_selected_vehicles_playerId_key`(`playerId` ASC),
    INDEX `player_selected_vehicles_vehicleId_idx`(`vehicleId` ASC),
    UNIQUE INDEX `player_selected_vehicles_vehicleId_key`(`vehicleId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `player_vehicle_parts` (
    `player_id` INTEGER NOT NULL,
    `car_parts` INTEGER NOT NULL DEFAULT 0,
    `motorcycle_parts` INTEGER NOT NULL DEFAULT 0,
    `boat_parts` INTEGER NOT NULL DEFAULT 0,
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`player_id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `prostitutes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `variant` INTEGER NOT NULL DEFAULT 1,
    `recruitedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `lastEarningsAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `location` VARCHAR(20) NOT NULL DEFAULT 'street',
    `redLightRoomId` INTEGER NULL,
    `experience` INTEGER NOT NULL DEFAULT 0,
    `level` INTEGER NOT NULL DEFAULT 1,
    `isBusted` BOOLEAN NOT NULL DEFAULT false,
    `bustedUntil` DATETIME(3) NULL,
    `nightclubVenueId` INTEGER NULL,
    `nightclubAssignedAt` DATETIME(0) NULL,

    INDEX `idx_prostitutes_nightclubVenueId`(`nightclubVenueId` ASC),
    INDEX `prostitutes_location_idx`(`location` ASC),
    INDEX `prostitutes_playerId_idx`(`playerId` ASC),
    UNIQUE INDEX `prostitutes_redLightRoomId_key`(`redLightRoomId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `prostitution_achievements` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `achievementType` VARCHAR(50) NOT NULL,
    `achievementData` LONGTEXT NULL,
    `unlockedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `prostitution_achievements_playerId_achievementType_key`(`playerId` ASC, `achievementType` ASC),
    INDEX `prostitution_achievements_playerId_unlockedAt_idx`(`playerId` ASC, `unlockedAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `prostitution_leaderboards` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `period` VARCHAR(20) NOT NULL,
    `periodStart` DATE NOT NULL,
    `totalEarnings` DOUBLE NOT NULL DEFAULT 0,
    `totalProstitutes` INTEGER NOT NULL DEFAULT 0,
    `totalDistricts` INTEGER NOT NULL DEFAULT 0,
    `highestLevel` INTEGER NOT NULL DEFAULT 1,
    `rankPosition` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `prostitution_leaderboards_period_periodStart_rankPosition_idx`(`period` ASC, `periodStart` ASC, `rankPosition` ASC),
    INDEX `prostitution_leaderboards_period_periodStart_totalEarnings_idx`(`period` ASC, `periodStart` ASC, `totalEarnings` ASC),
    UNIQUE INDEX `prostitution_leaderboards_playerId_period_periodStart_key`(`playerId` ASC, `period` ASC, `periodStart` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `prostitution_protection_insurance` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `weeklyCost` INTEGER NOT NULL DEFAULT 25000,
    `damageReduction` DOUBLE NOT NULL DEFAULT 0.3,
    `activeUntil` DATETIME(3) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `prostitution_protection_insurance_activeUntil_idx`(`activeUntil` ASC),
    UNIQUE INDEX `prostitution_protection_insurance_playerId_key`(`playerId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `prostitution_rivalries` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `rivalPlayerId` INTEGER NOT NULL,
    `rivalryScore` INTEGER NOT NULL DEFAULT 0,
    `startedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `lastAttackAt` DATETIME(3) NULL,

    INDEX `prostitution_rivalries_playerId_idx`(`playerId` ASC),
    UNIQUE INDEX `prostitution_rivalries_playerId_rivalPlayerId_key`(`playerId` ASC, `rivalPlayerId` ASC),
    INDEX `prostitution_rivalries_rivalPlayerId_idx`(`rivalPlayerId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `red_light_districts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `countryCode` VARCHAR(50) NOT NULL,
    `ownerId` INTEGER NULL,
    `purchasePrice` INTEGER NOT NULL DEFAULT 500000,
    `purchasedAt` DATETIME(3) NULL,
    `roomCount` INTEGER NOT NULL DEFAULT 8,
    `tier` INTEGER NOT NULL DEFAULT 1,
    `securityLevel` INTEGER NOT NULL DEFAULT 0,

    INDEX `red_light_districts_countryCode_idx`(`countryCode` ASC),
    UNIQUE INDEX `red_light_districts_countryCode_key`(`countryCode` ASC),
    INDEX `red_light_districts_ownerId_idx`(`ownerId` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `red_light_rooms` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `redLightDistrictId` INTEGER NOT NULL,
    `roomNumber` INTEGER NOT NULL,
    `occupied` BOOLEAN NOT NULL DEFAULT false,
    `lastEarningsAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `tier` INTEGER NOT NULL DEFAULT 1,

    INDEX `red_light_rooms_redLightDistrictId_idx`(`redLightDistrictId` ASC),
    UNIQUE INDEX `red_light_rooms_redLightDistrictId_roomNumber_key`(`redLightDistrictId` ASC, `roomNumber` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sabotage_actions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `attackerId` INTEGER NOT NULL,
    `victimId` INTEGER NOT NULL,
    `actionType` VARCHAR(50) NOT NULL,
    `success` BOOLEAN NOT NULL DEFAULT false,
    `cost` DOUBLE NOT NULL,
    `impactDescription` TEXT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `sabotage_actions_actionType_idx`(`actionType` ASC),
    INDEX `sabotage_actions_attackerId_createdAt_idx`(`attackerId` ASC, `createdAt` ASC),
    INDEX `sabotage_actions_victimId_createdAt_idx`(`victimId` ASC, `createdAt` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `smuggling_shipments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `category` VARCHAR(20) NOT NULL,
    `item_key` VARCHAR(100) NOT NULL,
    `item_label` VARCHAR(120) NOT NULL,
    `quantity` INTEGER NOT NULL,
    `unit_tag` VARCHAR(20) NOT NULL DEFAULT 'unit',
    `origin_country` VARCHAR(50) NOT NULL,
    `destination_country` VARCHAR(50) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'in_transit',
    `metadata_json` LONGTEXT NULL,
    `seizure_chance` DECIMAL(6, 4) NOT NULL DEFAULT 0.0500,
    `shipping_fee` INTEGER NOT NULL DEFAULT 0,
    `eta_at` DATETIME(0) NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `delivered_at` DATETIME(0) NULL,
    `claimed_at` DATETIME(0) NULL,
    `crew_id` INTEGER NULL,
    `channel` VARCHAR(20) NOT NULL DEFAULT 'package',
    `network_scope` VARCHAR(20) NOT NULL DEFAULT 'personal',

    INDEX `idx_smuggling_player_category`(`player_id` ASC, `category` ASC),
    INDEX `idx_smuggling_player_eta`(`player_id` ASC, `eta_at` ASC),
    INDEX `idx_smuggling_player_status_country`(`player_id` ASC, `status` ASC, `destination_country` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_repair_jobs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `vehicle_inventory_id` INTEGER NOT NULL,
    `repair_cost` INTEGER NOT NULL,
    `from_condition` INTEGER NOT NULL,
    `target_condition` INTEGER NOT NULL DEFAULT 100,
    `status` VARCHAR(20) NOT NULL DEFAULT 'in_progress',
    `started_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `completes_at` DATETIME(0) NOT NULL,
    `completed_at` DATETIME(0) NULL,

    INDEX `idx_vehicle_repair_jobs_player_status`(`player_id` ASC, `status` ASC),
    INDEX `idx_vehicle_repair_jobs_vehicle_status`(`vehicle_inventory_id` ASC, `status` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vehicle_tuning_upgrades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `player_id` INTEGER NOT NULL,
    `vehicle_inventory_id` INTEGER NOT NULL,
    `speed_level` INTEGER NOT NULL DEFAULT 0,
    `stealth_level` INTEGER NOT NULL DEFAULT 0,
    `armor_level` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `tune_cooldown_until` DATETIME(0) NULL,

    INDEX `idx_vehicle_tuning_player`(`player_id` ASC),
    UNIQUE INDEX `uq_vehicle_tuning_vehicle`(`vehicle_inventory_id` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vip_events` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `eventType` VARCHAR(50) NOT NULL,
    `countryCode` VARCHAR(2) NOT NULL,
    `startTime` DATETIME(3) NOT NULL,
    `endTime` DATETIME(3) NOT NULL,
    `bonusMultiplier` DOUBLE NOT NULL DEFAULT 2,
    `minLevelRequired` INTEGER NOT NULL DEFAULT 1,
    `maxParticipants` INTEGER NOT NULL DEFAULT 50,
    `currentParticipants` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `vip_events_countryCode_startTime_endTime_idx`(`countryCode` ASC, `startTime` ASC, `endTime` ASC),
    INDEX `vip_events_eventType_idx`(`eventType` ASC),
    PRIMARY KEY (`id` ASC)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `drug_inventory_playerId_drugType_quality_key` ON `drug_inventory`(`playerId` ASC, `drugType` ASC, `quality` ASC);

-- CreateIndex
CREATE INDEX `drug_production_facilityId_idx` ON `drug_production`(`facilityId` ASC);

-- AddForeignKey
ALTER TABLE `crypto_holdings` ADD CONSTRAINT `fk_crypto_holdings_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `crypto_leaderboard_rewards` ADD CONSTRAINT `fk_crypto_lb_rewards_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `crypto_mission_progress` ADD CONSTRAINT `fk_crypto_mission_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `crypto_orders` ADD CONSTRAINT `fk_crypto_orders_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `crypto_transactions` ADD CONSTRAINT `fk_crypto_transactions_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `event_participations` ADD CONSTRAINT `event_participations_eventId_fkey` FOREIGN KEY (`eventId`) REFERENCES `vip_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `event_participations` ADD CONSTRAINT `event_participations_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `event_participations` ADD CONSTRAINT `event_participations_prostituteId_fkey` FOREIGN KEY (`prostituteId`) REFERENCES `prostitutes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `gym_stats` ADD CONSTRAINT `gym_stats_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `nightclub_dj_shifts` ADD CONSTRAINT `nightclub_dj_shifts_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_dj_shifts` ADD CONSTRAINT `nightclub_dj_shifts_ibfk_2` FOREIGN KEY (`djId`) REFERENCES `nightclub_djs`(`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_drug_inventory` ADD CONSTRAINT `nightclub_drug_inventory_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_events` ADD CONSTRAINT `nightclub_events_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_prostitute_assignments` ADD CONSTRAINT `fk_npa_player` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_prostitute_assignments` ADD CONSTRAINT `fk_npa_prostitute` FOREIGN KEY (`prostituteId`) REFERENCES `prostitutes`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_prostitute_assignments` ADD CONSTRAINT `fk_npa_venue` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_sales` ADD CONSTRAINT `nightclub_sales_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_season_rewards` ADD CONSTRAINT `fk_nightclub_season_rewards_player` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_season_rewards` ADD CONSTRAINT `fk_nightclub_season_rewards_venue` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_security_shifts` ADD CONSTRAINT `nightclub_security_shifts_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_security_shifts` ADD CONSTRAINT `nightclub_security_shifts_ibfk_2` FOREIGN KEY (`guardId`) REFERENCES `nightclub_security_guards`(`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_thefts` ADD CONSTRAINT `nightclub_thefts_ibfk_1` FOREIGN KEY (`venueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_venues` ADD CONSTRAINT `nightclub_venues_ibfk_1` FOREIGN KEY (`propertyId`) REFERENCES `properties`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_venues` ADD CONSTRAINT `nightclub_venues_ibfk_2` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `nightclub_venues` ADD CONSTRAINT `nightclub_venues_ibfk_3` FOREIGN KEY (`currentDJId`) REFERENCES `nightclub_djs`(`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `player_notification_preferences` ADD CONSTRAINT `fk_notification_preferences_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `player_selected_vehicles` ADD CONSTRAINT `player_selected_vehicles_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `player_selected_vehicles` ADD CONSTRAINT `player_selected_vehicles_vehicleId_fkey` FOREIGN KEY (`vehicleId`) REFERENCES `vehicles`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitutes` ADD CONSTRAINT `fk_prostitutes_nightclubVenueId` FOREIGN KEY (`nightclubVenueId`) REFERENCES `nightclub_venues`(`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `prostitutes` ADD CONSTRAINT `prostitutes_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitutes` ADD CONSTRAINT `prostitutes_redLightRoomId_fkey` FOREIGN KEY (`redLightRoomId`) REFERENCES `red_light_rooms`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitution_achievements` ADD CONSTRAINT `prostitution_achievements_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitution_leaderboards` ADD CONSTRAINT `prostitution_leaderboards_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitution_protection_insurance` ADD CONSTRAINT `prostitution_protection_insurance_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitution_rivalries` ADD CONSTRAINT `prostitution_rivalries_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `prostitution_rivalries` ADD CONSTRAINT `prostitution_rivalries_rivalPlayerId_fkey` FOREIGN KEY (`rivalPlayerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `red_light_districts` ADD CONSTRAINT `red_light_districts_ownerId_fkey` FOREIGN KEY (`ownerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `red_light_rooms` ADD CONSTRAINT `red_light_rooms_redLightDistrictId_fkey` FOREIGN KEY (`redLightDistrictId`) REFERENCES `red_light_districts`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sabotage_actions` ADD CONSTRAINT `sabotage_actions_attackerId_fkey` FOREIGN KEY (`attackerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sabotage_actions` ADD CONSTRAINT `sabotage_actions_victimId_fkey` FOREIGN KEY (`victimId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
