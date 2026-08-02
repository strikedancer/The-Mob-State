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

async function ensureColumn(tableName: string, columnName: string, alterSql: string): Promise<void> {
  if (await columnExists(tableName, columnName)) return;
  await prisma.$executeRawUnsafe(alterSql);
  console.log(`[StartupSchema] Added ${tableName}.${columnName}`);
}

export async function ensureVipPrestigeSchema(): Promise<void> {
  await ensureColumn(
    'players',
    'vipLifetimeDays',
    'ALTER TABLE players ADD COLUMN vipLifetimeDays INT NOT NULL DEFAULT 0',
  );
  await ensureColumn(
    'crews',
    'vipLifetimeDays',
    'ALTER TABLE crews ADD COLUMN vipLifetimeDays INT NOT NULL DEFAULT 0',
  );
}
