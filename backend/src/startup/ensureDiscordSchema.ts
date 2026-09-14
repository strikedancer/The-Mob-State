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

export async function ensureDiscordSchema(): Promise<void> {
  if (!(await columnExists('players', 'discordId'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE players ADD COLUMN discordId VARCHAR(32) NULL',
    );
    console.log('[StartupSchema] Added players.discordId');
  }
  if (!(await indexExists('players', 'Player_discordId_key'))) {
    await prisma.$executeRawUnsafe(
      'CREATE UNIQUE INDEX Player_discordId_key ON players (discordId)',
    );
    console.log('[StartupSchema] Added unique index Player_discordId_key');
  }
}
