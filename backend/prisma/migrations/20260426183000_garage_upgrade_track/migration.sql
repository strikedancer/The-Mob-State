-- Separate garage upgrade tracks: car vs motorcycle (independent levels/capacity).

ALTER TABLE `garage_upgrades` ADD COLUMN `track` VARCHAR(20) NOT NULL DEFAULT 'car';

CREATE INDEX `garage_upgrades_garageId_track_idx` ON `garage_upgrades`(`garageId`, `track`);
