-- Add lastHospitalVisit column for hospital cooldown tracking
ALTER TABLE `players` ADD COLUMN `lastHospitalVisit` DATETIME NULL AFTER `jailRelease`;
