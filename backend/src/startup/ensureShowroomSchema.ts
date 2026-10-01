import prisma from '../lib/prisma';

async function columnExists(tableName: string, columnName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: bigint | number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND COLUMN_NAME = ${columnName}
  `;
  return Number(rows?.[0]?.count ?? 0) > 0;
}

/**
 * Showroom "cat" papers flag on exhibited vehicles.
 * Production often skips prisma migrate deploy — keep ensure-pattern.
 */
export async function ensureShowroomSchema(): Promise<void> {
  if (!(await columnExists('vehicle_inventory', 'showroomCatted'))) {
    await prisma.$executeRawUnsafe(
      `ALTER TABLE vehicle_inventory ADD COLUMN showroomCatted TINYINT(1) NOT NULL DEFAULT 0`,
    );
    console.log('[StartupSchema] Added vehicle_inventory.showroomCatted');
  }
}
