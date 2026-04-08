-- CreateTable
CREATE TABLE `property_drug_storage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `propertyId` INTEGER NOT NULL,
    `drugType` VARCHAR(50) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 0,
    `storedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `property_drug_storage_propertyId_idx`(`propertyId`),
    UNIQUE INDEX `property_drug_storage_propertyId_drugType_key`(`propertyId`, `drugType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable if not exists for PropertyStorageCapacity
CREATE TABLE IF NOT EXISTS `property_storage_capacity` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `property_type` VARCHAR(50) NOT NULL,
    `max_slots` INTEGER NOT NULL,
    `description` VARCHAR(255),
    PRIMARY KEY (`id`),
    UNIQUE KEY `property_type` (`property_type`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `property_drug_storage` ADD CONSTRAINT `property_drug_storage_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `properties`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Update PropertyStorageCapacity with drug storage limits
INSERT INTO `property_storage_capacity` (`property_type`, `max_slots`, `description`) 
VALUES 
  ('warehouse', 500, 'Large warehouse for bulk drug storage'),
  ('house', 100, 'Residential property with hidden stash'),
  ('safehouse', 200, 'Secure location for contraband storage')
ON DUPLICATE KEY UPDATE 
  `max_slots` = VALUES(`max_slots`),
  `description` = VALUES(`description`);
