-- Collection showrooms lock a vehicle out of the garage without deleting it.
ALTER TABLE `vehicle_inventory`
  ADD COLUMN `showroomPropertyId` INTEGER NULL,
  ADD COLUMN `showroomPlacedAt` DATETIME(3) NULL;

CREATE INDEX `vehicle_inventory_showroomPropertyId_idx`
  ON `vehicle_inventory`(`showroomPropertyId`);

ALTER TABLE `vehicle_inventory`
  ADD CONSTRAINT `vehicle_inventory_showroomPropertyId_fkey`
  FOREIGN KEY (`showroomPropertyId`) REFERENCES `properties`(`id`)
  ON DELETE SET NULL ON UPDATE CASCADE;
