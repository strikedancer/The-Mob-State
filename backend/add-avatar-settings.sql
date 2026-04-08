-- Add avatar and settings fields to players table

ALTER TABLE `players` 
ADD COLUMN `avatar` VARCHAR(100) NULL DEFAULT 'default_1' AFTER `currentCountry`,
ADD COLUMN `isVip` BOOLEAN DEFAULT FALSE AFTER `avatar`,
ADD COLUMN `vipExpiresAt` DATETIME NULL AFTER `isVip`,
ADD COLUMN `lastAvatarChange` DATETIME NULL AFTER `vipExpiresAt`,
ADD COLUMN `lastUsernameChange` DATETIME NULL AFTER `lastAvatarChange`,
ADD COLUMN `allowMessages` BOOLEAN DEFAULT TRUE AFTER `lastUsernameChange`,
ADD COLUMN `reputation` INT DEFAULT 0 AFTER `allowMessages`;
