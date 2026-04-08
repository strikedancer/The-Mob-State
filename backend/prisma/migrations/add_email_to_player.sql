-- Add email and emailVerified fields to Player table
ALTER TABLE `Player` 
ADD COLUMN `email` VARCHAR(255) NULL AFTER `passwordHash`,
ADD COLUMN `emailVerified` BOOLEAN NOT NULL DEFAULT FALSE AFTER `email`;
