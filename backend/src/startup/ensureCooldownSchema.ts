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
  const exists = await columnExists(tableName, columnName);
  if (exists) return;

  await prisma.$executeRawUnsafe(alterSql);
  console.log(`[StartupSchema] Added ${tableName}.${columnName}`);
}

export async function ensureCooldownSchema(): Promise<void> {
  await ensureColumn(
    'action_cooldowns',
    'cooldownSeconds',
    'ALTER TABLE action_cooldowns ADD COLUMN cooldownSeconds INT NULL AFTER lastUsedAt'
  );

  await ensureColumn(
    'action_cooldowns',
    'lastNotifiedAt',
    'ALTER TABLE action_cooldowns ADD COLUMN lastNotifiedAt DATETIME NULL AFTER cooldownSeconds'
  );
}