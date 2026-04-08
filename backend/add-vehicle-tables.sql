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

    INDEX `vehicle_inventory_playerId_idx`(`playerId`),
    INDEX `vehicle_inventory_vehicleType_idx`(`vehicleType`),
    INDEX `vehicle_inventory_currentLocation_idx`(`currentLocation`),
    INDEX `vehicle_inventory_marketListing_idx`(`marketListing`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

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
