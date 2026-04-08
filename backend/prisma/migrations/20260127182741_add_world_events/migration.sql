-- CreateTable
CREATE TABLE `world_events` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `eventKey` VARCHAR(100) NOT NULL,
    `params` JSON NOT NULL,
    `playerId` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `world_events_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
