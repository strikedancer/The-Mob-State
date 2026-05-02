-- CreateTable
CREATE TABLE `player_portraits` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `playerId` INTEGER NOT NULL,
    `imagePath` VARCHAR(255) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `player_portraits_playerId_idx`(`playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `player_portraits` ADD CONSTRAINT `player_portraits_playerId_fkey` FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE `players` ADD COLUMN `activePortraitId` INTEGER NULL;

-- CreateIndex
CREATE UNIQUE INDEX `players_activePortraitId_key` ON `players`(`activePortraitId`);

-- AddForeignKey
ALTER TABLE `players` ADD CONSTRAINT `players_activePortraitId_fkey` FOREIGN KEY (`activePortraitId`) REFERENCES `player_portraits`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
