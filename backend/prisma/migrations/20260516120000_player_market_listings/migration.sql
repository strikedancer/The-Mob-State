-- Unified player marketplace (non-vehicle lots). Vehicles remain on vehicle_inventory.
CREATE TABLE `player_market_listings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `sellerId` INT NOT NULL,
    `kind` VARCHAR(32) NOT NULL,
    `refId` INT NOT NULL,
    `price` INT NOT NULL,
    `status` VARCHAR(16) NOT NULL DEFAULT 'active',
    `countryCode` VARCHAR(50) NULL,
    `buyerId` INT NULL,
    `soldAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`),
    INDEX `player_market_listings_status_country_idx`(`status`, `countryCode`),
    INDEX `player_market_listings_seller_status_idx`(`sellerId`, `status`),
    INDEX `player_market_listings_kind_ref_status_idx`(`kind`, `refId`, `status`),

    CONSTRAINT `player_market_listings_sellerId_fkey` FOREIGN KEY (`sellerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `player_market_listings_buyerId_fkey` FOREIGN KEY (`buyerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
