-- Migration: support_ticket_attachments_and_global_todos
-- Adds ticket attachments and makes support todos usable as a central list.

ALTER TABLE `support_ticket_todos`
  MODIFY COLUMN `ticketId` INTEGER NULL;

CREATE TABLE IF NOT EXISTS `support_ticket_attachments` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `ticketId` INTEGER NOT NULL,
  `playerId` INTEGER NOT NULL,
  `originalName` VARCHAR(255) NOT NULL,
  `mimeType` VARCHAR(120) NOT NULL,
  `fileSize` INTEGER NOT NULL,
  `data` LONGBLOB NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  INDEX `idx_support_ticket_attachments_ticket`(`ticketId`),
  INDEX `idx_support_ticket_attachments_player`(`playerId`),
  INDEX `idx_support_ticket_attachments_created`(`createdAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE INDEX IF NOT EXISTS `idx_support_ticket_attachments_ticket` ON `support_ticket_attachments`(`ticketId`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_attachments_player` ON `support_ticket_attachments`(`playerId`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_attachments_created` ON `support_ticket_attachments`(`createdAt`);