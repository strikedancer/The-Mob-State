import prisma from '../lib/prisma';

async function tableExists(tableName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
  `;
  return Number(rows?.[0]?.count ?? 0) > 0;
}

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

export async function ensureGlobalChatSchema(): Promise<void> {
  if (!(await tableExists('global_chat_messages'))) {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE global_chat_messages (
        id INT NOT NULL AUTO_INCREMENT,
        playerId INT NULL,
        discordUserId VARCHAR(32) NULL,
        discordMessageId VARCHAR(32) NULL,
        displayName VARCHAR(64) NOT NULL,
        source VARCHAR(16) NOT NULL,
        message TEXT NOT NULL,
        stickerId VARCHAR(40) NULL,
        imageUrl VARCHAR(160) NULL,
        filtered TINYINT(1) NOT NULL DEFAULT 0,
        deletedAt DATETIME NULL,
        createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        UNIQUE KEY GlobalChatMessage_discordMessageId_key (discordMessageId),
        INDEX global_chat_messages_createdAt_idx (createdAt),
        INDEX global_chat_messages_playerId_idx (playerId)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('[StartupSchema] Created global_chat_messages');
  } else if (!(await columnExists('global_chat_messages', 'imageUrl'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE global_chat_messages ADD COLUMN imageUrl VARCHAR(160) NULL AFTER stickerId',
    );
    console.log('[StartupSchema] Added global_chat_messages.imageUrl');
  }

  if (!(await tableExists('global_chat_mutes'))) {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE global_chat_mutes (
        id INT NOT NULL AUTO_INCREMENT,
        playerId INT NOT NULL,
        mutedUntil DATETIME NULL,
        reason VARCHAR(255) NULL,
        createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        UNIQUE KEY GlobalChatMute_playerId_key (playerId)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('[StartupSchema] Created global_chat_mutes');
  }

  if (!(await tableExists('global_chat_reports'))) {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE global_chat_reports (
        id INT NOT NULL AUTO_INCREMENT,
        messageId INT NOT NULL,
        reporterId INT NOT NULL,
        createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        INDEX global_chat_reports_messageId_idx (messageId),
        INDEX global_chat_reports_createdAt_idx (createdAt)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('[StartupSchema] Created global_chat_reports');
  }
}
