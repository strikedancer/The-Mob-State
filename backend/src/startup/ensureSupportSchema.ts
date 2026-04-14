import prisma from '../lib/prisma';

export async function ensureSupportSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS support_tickets (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      category VARCHAR(50) NOT NULL,
      subject VARCHAR(255) NOT NULL,
      status VARCHAR(30) NOT NULL DEFAULT 'open',
      priority VARCHAR(20) NOT NULL DEFAULT 'normal',
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      closedAt DATETIME NULL,
      closedByAdminId INT NULL,
      lastPlayerMessageAt DATETIME NULL,
      lastAdminMessageAt DATETIME NULL,
      PRIMARY KEY (id),
      INDEX idx_support_tickets_player (playerId),
      INDEX idx_support_tickets_status (status),
      INDEX idx_support_tickets_updated (updatedAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS support_ticket_messages (
      id INT NOT NULL AUTO_INCREMENT,
      ticketId INT NOT NULL,
      senderType VARCHAR(20) NOT NULL,
      playerId INT NULL,
      adminId INT NULL,
      message TEXT NOT NULL,
      isInternal TINYINT(1) NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_support_ticket_messages_ticket (ticketId),
      INDEX idx_support_ticket_messages_created (createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS support_ticket_todos (
      id INT NOT NULL AUTO_INCREMENT,
      ticketId INT NOT NULL,
      title VARCHAR(255) NOT NULL,
      description TEXT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'open',
      createdByAdminId INT NOT NULL,
      assignedAdminId INT NULL,
      resolvedByAdminId INT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      resolvedAt DATETIME NULL,
      PRIMARY KEY (id),
      INDEX idx_support_ticket_todos_ticket (ticketId),
      INDEX idx_support_ticket_todos_status (status),
      INDEX idx_support_ticket_todos_updated (updatedAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  console.log('[StartupSchema] Support ticket schema check complete');
}
