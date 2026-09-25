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

export async function ensureCrimeAttemptCountrySchema(): Promise<void> {
  if (!(await columnExists('crime_attempts', 'countryId'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE crime_attempts ADD COLUMN countryId VARCHAR(50) NULL',
    );
    console.log('[StartupSchema] Added crime_attempts.countryId');
  }

  if (!(await indexExists('crime_attempts', 'crime_attempts_playerId_countryId_idx'))) {
    await prisma.$executeRawUnsafe(
      'CREATE INDEX crime_attempts_playerId_countryId_idx ON crime_attempts (playerId, countryId)',
    );
    console.log('[StartupSchema] Added crime_attempts (playerId, countryId) index');
  }
}
