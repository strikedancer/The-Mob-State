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

export async function ensureProstitutionSchema(): Promise<void> {
  await ensureColumn(
    'prostitutes',
    'housingTier',
    'ALTER TABLE prostitutes ADD COLUMN housingTier INT NOT NULL DEFAULT 1 AFTER bustedUntil'
  );
  await ensureColumn(
    'prostitutes',
    'housingRentPerDay',
    'ALTER TABLE prostitutes ADD COLUMN housingRentPerDay INT NOT NULL DEFAULT 35 AFTER housingTier'
  );
  await ensureColumn(
    'prostitutes',
    'housingPaidUntil',
    'ALTER TABLE prostitutes ADD COLUMN housingPaidUntil DATETIME NULL AFTER housingRentPerDay'
  );
  await ensureColumn(
    'prostitutes',
    'lastWorkedAt',
    'ALTER TABLE prostitutes ADD COLUMN lastWorkedAt DATETIME NULL AFTER housingPaidUntil'
  );
  await ensureColumn(
    'prostitutes',
    'nightclubVenueId',
    'ALTER TABLE prostitutes ADD COLUMN nightclubVenueId INT NULL AFTER redLightRoomId'
  );
  await ensureColumn(
    'prostitutes',
    'nightclubAssignedAt',
    'ALTER TABLE prostitutes ADD COLUMN nightclubAssignedAt DATETIME NULL AFTER nightclubVenueId'
  );

  await ensureIndex(
    'prostitutes',
    'idx_prostitutes_housing_paid_until',
    'CREATE INDEX idx_prostitutes_housing_paid_until ON prostitutes(housingPaidUntil)'
  );
  await ensureIndex(
    'prostitutes',
    'idx_prostitutes_last_worked_at',
    'CREATE INDEX idx_prostitutes_last_worked_at ON prostitutes(lastWorkedAt)'
  );
  await ensureIndex(
    'prostitutes',
    'idx_prostitutes_nightclubVenueId',
    'CREATE INDEX idx_prostitutes_nightclubVenueId ON prostitutes(nightclubVenueId)'
  );

  // Backfill existing records so upkeep/recruit flows have valid baseline values.
  await prisma.$executeRawUnsafe(`
    UPDATE prostitutes
    SET
      housingTier = CASE WHEN variant BETWEEN 6 AND 10 THEN 2 ELSE 1 END,
      housingRentPerDay = CASE WHEN variant BETWEEN 6 AND 10 THEN 60 ELSE 35 END,
      housingPaidUntil = COALESCE(housingPaidUntil, DATE_ADD(COALESCE(lastEarningsAt, NOW()), INTERVAL 7 DAY)),
      lastWorkedAt = COALESCE(lastWorkedAt, lastEarningsAt, recruitedAt, NOW())
    WHERE housingPaidUntil IS NULL OR lastWorkedAt IS NULL
  `);

  console.log('[StartupSchema] Prostitution schema check complete');
}
