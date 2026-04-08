-- CreateTable
CREATE TABLE `job_attempts` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `jobId` VARCHAR(50) NOT NULL,
    `earnings` INTEGER NOT NULL,
    `xpGained` INTEGER NOT NULL,
    `completedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `job_attempts_playerId_idx`(`playerId`),
    INDEX `job_attempts_playerId_jobId_idx`(`playerId`, `jobId`),
    INDEX `job_attempts_completedAt_idx`(`completedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `job_attempts` ADD CONSTRAINT `job_attempts_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
