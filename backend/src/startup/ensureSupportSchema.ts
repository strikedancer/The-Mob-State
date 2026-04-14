import prisma from '../lib/prisma';

async function columnExists(tableName: string, columnName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND COLUMN_NAME = ${columnName}
  `;

  return Number(rows?.[0]?.count ?? 0) > 0;
}

async function indexExists(tableName: string, indexName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND INDEX_NAME = ${indexName}
  `;

  return Number(rows?.[0]?.count ?? 0) > 0;
}

async function ensureColumn(tableName: string, columnName: string, alterSql: string): Promise<void> {
  const exists = await columnExists(tableName, columnName);
  if (exists) return;

  await prisma.$executeRawUnsafe(alterSql);
  console.log(`[StartupSchema] Added ${tableName}.${columnName}`);
}

async function ensureIndex(tableName: string, indexName: string, createSql: string): Promise<void> {
  const exists = await indexExists(tableName, indexName);
  if (exists) return;

  await prisma.$executeRawUnsafe(createSql);
  console.log(`[StartupSchema] Added index ${indexName} on ${tableName}`);
}

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

  await ensureColumn(
    'support_tickets',
    'closedAt',
    'ALTER TABLE support_tickets ADD COLUMN closedAt DATETIME NULL AFTER updatedAt'
  );
  await ensureColumn(
    'support_tickets',
    'closedByAdminId',
    'ALTER TABLE support_tickets ADD COLUMN closedByAdminId INT NULL AFTER closedAt'
  );
  await ensureColumn(
    'support_tickets',
    'lastPlayerMessageAt',
    'ALTER TABLE support_tickets ADD COLUMN lastPlayerMessageAt DATETIME NULL AFTER closedByAdminId'
  );
  await ensureColumn(
    'support_tickets',
    'lastAdminMessageAt',
    'ALTER TABLE support_tickets ADD COLUMN lastAdminMessageAt DATETIME NULL AFTER lastPlayerMessageAt'
  );

  await ensureIndex(
    'support_tickets',
    'idx_support_tickets_player',
    'CREATE INDEX idx_support_tickets_player ON support_tickets(playerId)'
  );
  await ensureIndex(
    'support_tickets',
    'idx_support_tickets_status',
    'CREATE INDEX idx_support_tickets_status ON support_tickets(status)'
  );
  await ensureIndex(
    'support_tickets',
    'idx_support_tickets_updated',
    'CREATE INDEX idx_support_tickets_updated ON support_tickets(updatedAt)'
  );

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

  await ensureColumn(
    'support_ticket_messages',
    'adminId',
    'ALTER TABLE support_ticket_messages ADD COLUMN adminId INT NULL AFTER playerId'
  );
  await ensureColumn(
    'support_ticket_messages',
    'isInternal',
    'ALTER TABLE support_ticket_messages ADD COLUMN isInternal TINYINT(1) NOT NULL DEFAULT 0 AFTER message'
  );

  await ensureIndex(
    'support_ticket_messages',
    'idx_support_ticket_messages_ticket',
    'CREATE INDEX idx_support_ticket_messages_ticket ON support_ticket_messages(ticketId)'
  );
  await ensureIndex(
    'support_ticket_messages',
    'idx_support_ticket_messages_created',
    'CREATE INDEX idx_support_ticket_messages_created ON support_ticket_messages(createdAt)'
  );

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS support_ticket_todos (
      id INT NOT NULL AUTO_INCREMENT,
      ticketId INT NULL,
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

  await prisma.$executeRawUnsafe(
    'ALTER TABLE support_ticket_todos MODIFY COLUMN ticketId INT NULL'
  );

  await ensureColumn(
    'support_ticket_todos',
    'assignedAdminId',
    'ALTER TABLE support_ticket_todos ADD COLUMN assignedAdminId INT NULL AFTER createdByAdminId'
  );
  await ensureColumn(
    'support_ticket_todos',
    'resolvedByAdminId',
    'ALTER TABLE support_ticket_todos ADD COLUMN resolvedByAdminId INT NULL AFTER assignedAdminId'
  );
  await ensureColumn(
    'support_ticket_todos',
    'updatedAt',
    'ALTER TABLE support_ticket_todos ADD COLUMN updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER createdAt'
  );
  await ensureColumn(
    'support_ticket_todos',
    'resolvedAt',
    'ALTER TABLE support_ticket_todos ADD COLUMN resolvedAt DATETIME NULL AFTER updatedAt'
  );

  await ensureIndex(
    'support_ticket_todos',
    'idx_support_ticket_todos_ticket',
    'CREATE INDEX idx_support_ticket_todos_ticket ON support_ticket_todos(ticketId)'
  );
  await ensureIndex(
    'support_ticket_todos',
    'idx_support_ticket_todos_status',
    'CREATE INDEX idx_support_ticket_todos_status ON support_ticket_todos(status)'
  );
  await ensureIndex(
    'support_ticket_todos',
    'idx_support_ticket_todos_updated',
    'CREATE INDEX idx_support_ticket_todos_updated ON support_ticket_todos(updatedAt)'
  );

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS support_ticket_attachments (
      id INT NOT NULL AUTO_INCREMENT,
      ticketId INT NOT NULL,
      playerId INT NOT NULL,
      originalName VARCHAR(255) NOT NULL,
      mimeType VARCHAR(120) NOT NULL,
      fileSize INT NOT NULL,
      data LONGBLOB NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_support_ticket_attachments_ticket (ticketId),
      INDEX idx_support_ticket_attachments_player (playerId),
      INDEX idx_support_ticket_attachments_created (createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await ensureIndex(
    'support_ticket_attachments',
    'idx_support_ticket_attachments_ticket',
    'CREATE INDEX idx_support_ticket_attachments_ticket ON support_ticket_attachments(ticketId)'
  );
  await ensureIndex(
    'support_ticket_attachments',
    'idx_support_ticket_attachments_player',
    'CREATE INDEX idx_support_ticket_attachments_player ON support_ticket_attachments(playerId)'
  );
  await ensureIndex(
    'support_ticket_attachments',
    'idx_support_ticket_attachments_created',
    'CREATE INDEX idx_support_ticket_attachments_created ON support_ticket_attachments(createdAt)'
  );

  console.log('[StartupSchema] Support ticket schema check complete');
}
