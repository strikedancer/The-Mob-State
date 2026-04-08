-- CreateTable
CREATE TABLE `crime_attempts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `crimeId` VARCHAR(50) NOT NULL,
    `success` BOOLEAN NOT NULL,
    `reward` INTEGER NOT NULL DEFAULT 0,
    `xpGained` INTEGER NOT NULL DEFAULT 0,
    `jailed` BOOLEAN NOT NULL DEFAULT false,
    `jailTime` INTEGER NOT NULL DEFAULT 0,
    `vehicleId` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crime_attempts_playerId_idx`(`playerId`),
    INDEX `crime_attempts_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `crime_attempts` ADD CONSTRAINT `crime_attempts_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
