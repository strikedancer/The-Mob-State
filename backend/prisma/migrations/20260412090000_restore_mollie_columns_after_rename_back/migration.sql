-- Restore Mollie columns expected by current Prisma schema and runtime code.
-- Safe on existing databases because IF NOT EXISTS is used.

ALTER TABLE `players`
  ADD COLUMN IF NOT EXISTS `mollieCustomerId` VARCHAR(255) NULL AFTER `emailVerified`;

ALTER TABLE `players`
  ADD COLUMN IF NOT EXISTS `mollieSubscriptionId` VARCHAR(255) NULL AFTER `mollieCustomerId`;

ALTER TABLE `crews`
  ADD COLUMN IF NOT EXISTS `mollieSubscriptionId` VARCHAR(255) NULL AFTER `id`;
