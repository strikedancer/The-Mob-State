-- Expand support workflow (tickets, messages, todos, todo comments).
-- Idempotent: production DBs may already include some columns (drift / partial apply).

ALTER TABLE `support_tickets`
  ADD COLUMN IF NOT EXISTS `sourceModule` VARCHAR(80) NULL AFTER `priority`,
  ADD COLUMN IF NOT EXISTS `referenceCode` VARCHAR(120) NULL AFTER `sourceModule`,
  ADD COLUMN IF NOT EXISTS `metadataJson` LONGTEXT NULL AFTER `referenceCode`,
  ADD COLUMN IF NOT EXISTS `assignedAdminId` INT NULL AFTER `metadataJson`,
  ADD COLUMN IF NOT EXISTS `firstResponseAt` DATETIME NULL AFTER `updatedAt`,
  ADD COLUMN IF NOT EXISTS `resolvedAt` DATETIME NULL AFTER `firstResponseAt`,
  ADD COLUMN IF NOT EXISTS `archivedAt` DATETIME NULL AFTER `resolvedAt`,
  ADD COLUMN IF NOT EXISTS `archivedByAdminId` INT NULL AFTER `archivedAt`;

CREATE INDEX IF NOT EXISTS `idx_support_tickets_assigned_admin` ON `support_tickets`(`assignedAdminId`);
CREATE INDEX IF NOT EXISTS `idx_support_tickets_priority` ON `support_tickets`(`priority`);

ALTER TABLE `support_ticket_messages`
  ADD COLUMN IF NOT EXISTS `messageType` VARCHAR(30) NOT NULL DEFAULT 'public_reply' AFTER `senderType`;

ALTER TABLE `support_ticket_todos`
  ADD COLUMN IF NOT EXISTS `priority` VARCHAR(20) NOT NULL DEFAULT 'normal' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `moduleKey` VARCHAR(80) NULL AFTER `priority`,
  ADD COLUMN IF NOT EXISTS `dueAt` DATETIME NULL AFTER `moduleKey`;

CREATE INDEX IF NOT EXISTS `idx_support_ticket_todos_assigned_admin` ON `support_ticket_todos`(`assignedAdminId`);
CREATE INDEX IF NOT EXISTS `idx_support_ticket_todos_due_at` ON `support_ticket_todos`(`dueAt`);

CREATE TABLE IF NOT EXISTS `support_ticket_todo_comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `todoId` INT NOT NULL,
  `adminId` INT NOT NULL,
  `comment` TEXT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_support_ticket_todo_comments_todo` (`todoId`),
  INDEX `idx_support_ticket_todo_comments_created` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
