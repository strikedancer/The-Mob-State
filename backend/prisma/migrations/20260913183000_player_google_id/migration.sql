-- Google Sign-In: unique nullable Google subject id on players.
ALTER TABLE `players`
  ADD COLUMN `googleId` VARCHAR(64) NULL;

CREATE UNIQUE INDEX `players_googleId_key` ON `players`(`googleId`);
