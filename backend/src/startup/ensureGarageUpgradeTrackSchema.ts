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

async function indexExists(tableName: string, indexName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: bigint | number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND INDEX_NAME = ${indexName}
  `;

  return Number(rows?.[0]?.count ?? 0) > 0;
}

/**
 * Zorgt dat garage-upgrades een aparte track (car | motorcycle) hebben.
 * Vangt productie zonder prisma migrate deploy af (zie ensure-patroon).
 */
export async function ensureGarageUpgradeTrackSchema(): Promise<void> {
  const hasTrack = await columnExists('garage_upgrades', 'track');
  if (!hasTrack) {
    await prisma.$executeRawUnsafe(
      `ALTER TABLE garage_upgrades ADD COLUMN track VARCHAR(20) NOT NULL DEFAULT 'car'`,
    );
    console.log('[StartupSchema] Added garage_upgrades.track');
  }

  const idxName = 'garage_upgrades_garageId_track_idx';
  if (!(await indexExists('garage_upgrades', idxName))) {
    await prisma.$executeRawUnsafe(
      `CREATE INDEX ${idxName} ON garage_upgrades(garageId, track)`,
    );
    console.log(`[StartupSchema] Created index ${idxName}`);
  }
}
