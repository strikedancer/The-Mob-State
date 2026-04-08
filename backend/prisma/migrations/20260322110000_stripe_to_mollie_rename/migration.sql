-- Rename Stripe fields to Mollie fields
ALTER TABLE `players` ADD COLUMN `mollieCustomerId` VARCHAR(255) NULL AFTER `emailVerified`;
ALTER TABLE `crews` ADD COLUMN `mollieSubscriptionId` VARCHAR(255) NULL AFTER `id`;
