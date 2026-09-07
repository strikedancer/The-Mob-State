-- Facebook Login: unique nullable Facebook user id on players.
ALTER TABLE `players`
  ADD COLUMN `facebookId` VARCHAR(32) NULL;

CREATE UNIQUE INDEX `players_facebookId_key` ON `players`(`facebookId`);
