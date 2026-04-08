-- CreateTable
CREATE TABLE `crews` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `bankBalance` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `crews_name_key`(`name`),
    INDEX `crews_name_idx`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `crew_members` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `crewId` INTEGER NOT NULL,
    `playerId` INTEGER NOT NULL,
    `role` VARCHAR(20) NOT NULL,
    `joinedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `crew_members_playerId_idx`(`playerId`),
    INDEX `crew_members_crewId_idx`(`crewId`),
    UNIQUE INDEX `crew_members_crewId_playerId_key`(`crewId`, `playerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `crew_members` ADD CONSTRAINT `crew_members_crewId_fkey` FOREIGN KEY (`crewId`) REFERENCES `crews`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
