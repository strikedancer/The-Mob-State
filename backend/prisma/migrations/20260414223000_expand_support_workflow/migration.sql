ALTER TABLE support_tickets
  ADD COLUMN sourceModule VARCHAR(80) NULL AFTER priority,
  ADD COLUMN referenceCode VARCHAR(120) NULL AFTER sourceModule,
  ADD COLUMN metadataJson LONGTEXT NULL AFTER referenceCode,
  ADD COLUMN assignedAdminId INT NULL AFTER metadataJson,
  ADD COLUMN firstResponseAt DATETIME NULL AFTER updatedAt,
  ADD COLUMN resolvedAt DATETIME NULL AFTER firstResponseAt,
  ADD COLUMN archivedAt DATETIME NULL AFTER resolvedAt,
  ADD COLUMN archivedByAdminId INT NULL AFTER archivedAt;

CREATE INDEX idx_support_tickets_assigned_admin ON support_tickets(assignedAdminId);
CREATE INDEX idx_support_tickets_priority ON support_tickets(priority);

ALTER TABLE support_ticket_messages
  ADD COLUMN messageType VARCHAR(30) NOT NULL DEFAULT 'public_reply' AFTER senderType;

ALTER TABLE support_ticket_todos
  ADD COLUMN priority VARCHAR(20) NOT NULL DEFAULT 'normal' AFTER status,
  ADD COLUMN moduleKey VARCHAR(80) NULL AFTER priority,
  ADD COLUMN dueAt DATETIME NULL AFTER moduleKey;

CREATE INDEX idx_support_ticket_todos_assigned_admin ON support_ticket_todos(assignedAdminId);
CREATE INDEX idx_support_ticket_todos_due_at ON support_ticket_todos(dueAt);

CREATE TABLE support_ticket_todo_comments (
  id INT NOT NULL AUTO_INCREMENT,
  todoId INT NOT NULL,
  adminId INT NOT NULL,
  comment TEXT NOT NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_support_ticket_todo_comments_todo (todoId),
  INDEX idx_support_ticket_todo_comments_created (createdAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
