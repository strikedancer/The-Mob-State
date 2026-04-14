-- Migration: add_support_ticket_system
-- Formalizes the support ticket system in the Prisma migration chain.
-- Safe for existing production databases that may already have partial tables.

CREATE TABLE IF NOT EXISTS `support_tickets` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'open',
  `priority` VARCHAR(20) NOT NULL DEFAULT 'normal',
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `closedAt` DATETIME(3) NULL,
  `closedByAdminId` INTEGER NULL,
  `lastPlayerMessageAt` DATETIME(3) NULL,
  `lastAdminMessageAt` DATETIME(3) NULL,

  INDEX `idx_support_tickets_player`(`playerId`),
  INDEX `idx_support_tickets_status`(`status`),
  INDEX `idx_support_tickets_updated`(`updatedAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `support_tickets`
  ADD COLUMN IF NOT EXISTS `closedAt` DATETIME(3) NULL,
  ADD COLUMN IF NOT EXISTS `closedByAdminId` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `lastPlayerMessageAt` DATETIME(3) NULL,
  ADD COLUMN IF NOT EXISTS `lastAdminMessageAt` DATETIME(3) NULL;

CREATE INDEX IF NOT EXISTS `idx_support_tickets_player` ON `support_tickets`(`playerId`);
CREATE INDEX IF NOT EXISTS `idx_support_tickets_status` ON `support_tickets`(`status`);
CREATE INDEX IF NOT EXISTS `idx_support_tickets_updated` ON `support_tickets`(`updatedAt`);

CREATE TABLE IF NOT EXISTS `support_ticket_messages` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `ticketId` INTEGER NOT NULL,
  `senderType` VARCHAR(20) NOT NULL,
  `playerId` INTEGER NULL,
  `adminId` INTEGER NULL,
  `message` TEXT NOT NULL,
  `isInternal` BOOLEAN NOT NULL DEFAULT false,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  INDEX `idx_support_ticket_messages_ticket`(`ticketId`),
  INDEX `idx_support_ticket_messages_created`(`createdAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `support_ticket_messages`
  ADD COLUMN IF NOT EXISTS `adminId` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `isInternal` BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS `idx_support_ticket_messages_ticket` ON `support_ticket_messages`(`ticketId`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_messages_created` ON `support_ticket_messages`(`createdAt`);

CREATE TABLE IF NOT EXISTS `support_ticket_todos` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `ticketId` INTEGER NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'open',
  `createdByAdminId` INTEGER NOT NULL,
  `assignedAdminId` INTEGER NULL,
  `resolvedByAdminId` INTEGER NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `resolvedAt` DATETIME(3) NULL,

  INDEX `idx_support_ticket_todos_ticket`(`ticketId`),
  INDEX `idx_support_ticket_todos_status`(`status`),
  INDEX `idx_support_ticket_todos_updated`(`updatedAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `support_ticket_todos`
  ADD COLUMN IF NOT EXISTS `assignedAdminId` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `resolvedByAdminId` INTEGER NULL,
  ADD COLUMN IF NOT EXISTS `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS `resolvedAt` DATETIME(3) NULL;

CREATE INDEX IF NOT EXISTS `idx_support_ticket_todos_ticket` ON `support_ticket_todos`(`ticketId`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_todos_status` ON `support_ticket_todos`(`status`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_todos_updated` ON `support_ticket_todos`(`updatedAt`);