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

async function columnIsNullable(tableName: string, columnName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ isNullable: string }>>`
    SELECT IS_NULLABLE AS isNullable
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND COLUMN_NAME = ${columnName}
    LIMIT 1
  `;
  return String(rows?.[0]?.isNullable ?? '').toUpperCase() === 'YES';
}

export async function ensureStaffRoleSchema(): Promise<void> {
  if (!(await columnExists('players', 'staffRole'))) {
    await prisma.$executeRawUnsafe(
      "ALTER TABLE players ADD COLUMN staffRole VARCHAR(8) NOT NULL DEFAULT 'NONE'",
    );
    console.log('[StartupSchema] Added players.staffRole');
  }

  if (await columnExists('audit_logs', 'adminId')) {
    if (!(await columnIsNullable('audit_logs', 'adminId'))) {
      await prisma.$executeRawUnsafe('ALTER TABLE audit_logs MODIFY adminId INT NULL');
      console.log('[StartupSchema] Made audit_logs.adminId nullable');
    }
  }

  if (!(await columnExists('audit_logs', 'actorPlayerId'))) {
    await prisma.$executeRawUnsafe('ALTER TABLE audit_logs ADD COLUMN actorPlayerId INT NULL');
    console.log('[StartupSchema] Added audit_logs.actorPlayerId');
  }

  if (!(await columnExists('audit_logs', 'actorStaffRole'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE audit_logs ADD COLUMN actorStaffRole VARCHAR(8) NULL',
    );
    console.log('[StartupSchema] Added audit_logs.actorStaffRole');
  }
}
