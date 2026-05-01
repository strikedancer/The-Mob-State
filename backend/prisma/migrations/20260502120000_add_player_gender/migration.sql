-- Player gender (registration): male | female. Nullable for existing accounts.
ALTER TABLE `players` ADD COLUMN `gender` VARCHAR(10) NULL AFTER `avatar`;
