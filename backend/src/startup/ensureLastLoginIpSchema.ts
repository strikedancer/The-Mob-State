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

export async function ensureLastLoginIpSchema(): Promise<void> {
  if (!(await columnExists('players', 'lastLoginIp'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE players ADD COLUMN lastLoginIp VARCHAR(45) NULL',
    );
    console.log('[StartupSchema] Added players.lastLoginIp');
  }

  if (!(await columnExists('players', 'lastLoginIpAt'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE players ADD COLUMN lastLoginIpAt DATETIME(3) NULL',
    );
    console.log('[StartupSchema] Added players.lastLoginIpAt');
  }
}
