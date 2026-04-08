-- AlterTable
ALTER TABLE `players` ADD COLUMN `travelingTo` VARCHAR(50) NULL,
ADD COLUMN `travelRoute` JSON NULL,
ADD COLUMN `currentTravelLeg` INTEGER NOT NULL DEFAULT 0,
ADD COLUMN `travelStartedAt` DATETIME(3) NULL;

-- CreateIndex
CREATE INDEX `players_travelingTo_idx` ON `players`(`travelingTo`);

-- CreateIndex
CREATE INDEX `players_currentTravelLeg_idx` ON `players`(`currentTravelLeg`);
