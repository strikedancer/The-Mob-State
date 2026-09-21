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

  await ensureColumn(
    'prostitutes',
    'stolenFromPlayerId',
    'ALTER TABLE prostitutes ADD COLUMN stolenFromPlayerId INT NULL AFTER nightclubAssignedAt'
  );
  await ensureColumn(
    'prostitutes',
    'hotUntil',
    'ALTER TABLE prostitutes ADD COLUMN hotUntil DATETIME NULL AFTER stolenFromPlayerId'
  );
  await ensureIndex(
    'prostitutes',
    'idx_prostitutes_hotUntil',
    'CREATE INDEX idx_prostitutes_hotUntil ON prostitutes(hotUntil)'
  );

  const hadCountryColumn = await columnExists('prostitutes', 'country');
  await ensureColumn(
    'prostitutes',
    'country',
    "ALTER TABLE prostitutes ADD COLUMN country VARCHAR(50) NOT NULL DEFAULT 'netherlands' AFTER location"
  );
  await ensureIndex(
    'prostitutes',
    'idx_prostitutes_country',
    'CREATE INDEX idx_prostitutes_country ON prostitutes(country)'
  );

  // Keep placed workers aligned with their venue country.
  await prisma.$executeRawUnsafe(`
    UPDATE prostitutes p
    INNER JOIN red_light_rooms r ON r.id = p.redLightRoomId
    INNER JOIN red_light_districts d ON d.id = r.redLightDistrictId
    SET p.country = d.countryCode
    WHERE p.redLightRoomId IS NOT NULL
      AND d.countryCode IS NOT NULL
      AND d.countryCode <> ''
      AND p.country <> d.countryCode
  `);
  await prisma.$executeRawUnsafe(`
    UPDATE prostitutes p
    INNER JOIN nightclub_venues v ON v.id = p.nightclubVenueId
    SET p.country = v.country
    WHERE p.nightclubVenueId IS NOT NULL
      AND v.country IS NOT NULL
      AND v.country <> ''
      AND p.country <> v.country
  `);

  // First deploy of the column: pin street workers to their owner's current country.
  if (!hadCountryColumn) {
    await prisma.$executeRawUnsafe(`
      UPDATE prostitutes p
      INNER JOIN players pl ON pl.id = p.playerId
      SET p.country = pl.currentCountry
      WHERE p.location = 'street'
        AND p.redLightRoomId IS NULL
        AND p.nightclubVenueId IS NULL
        AND pl.currentCountry IS NOT NULL
        AND pl.currentCountry <> ''
    `);
    console.log('[StartupSchema] Backfilled prostitutes.country for street workers');
  }

  await ensureColumn(
    'red_light_districts',
    'expansionLevel',
    'ALTER TABLE red_light_districts ADD COLUMN expansionLevel INT NOT NULL DEFAULT 0 AFTER securityLevel'
  );
  await ensureColumn(
    'red_light_districts',
    'contestStatus',
    "ALTER TABLE red_light_districts ADD COLUMN contestStatus VARCHAR(20) NOT NULL DEFAULT 'idle' AFTER expansionLevel"
  );
  await ensureColumn(
    'red_light_districts',
    'contestChallengerId',
    'ALTER TABLE red_light_districts ADD COLUMN contestChallengerId INT NULL AFTER contestStatus'
  );
  await ensureColumn(
    'red_light_districts',
    'contestAttackerScore',
    'ALTER TABLE red_light_districts ADD COLUMN contestAttackerScore INT NOT NULL DEFAULT 0 AFTER contestChallengerId'
  );
  await ensureColumn(
    'red_light_districts',
    'contestDefenderScore',
    'ALTER TABLE red_light_districts ADD COLUMN contestDefenderScore INT NOT NULL DEFAULT 0 AFTER contestAttackerScore'
  );
  await ensureColumn(
    'red_light_districts',
    'contestHoldCount',
    'ALTER TABLE red_light_districts ADD COLUMN contestHoldCount INT NOT NULL DEFAULT 0 AFTER contestDefenderScore'
  );
  await ensureColumn(
    'red_light_districts',
    'contestStake',
    'ALTER TABLE red_light_districts ADD COLUMN contestStake INT NOT NULL DEFAULT 0 AFTER contestHoldCount'
  );
  await ensureColumn(
    'red_light_districts',
    'contestPrepAt',
    'ALTER TABLE red_light_districts ADD COLUMN contestPrepAt DATETIME NULL AFTER contestStake'
  );
  await ensureColumn(
    'red_light_districts',
    'contestActiveAt',
    'ALTER TABLE red_light_districts ADD COLUMN contestActiveAt DATETIME NULL AFTER contestPrepAt'
  );
  await ensureColumn(
    'red_light_districts',
    'contestLockdownAt',
    'ALTER TABLE red_light_districts ADD COLUMN contestLockdownAt DATETIME NULL AFTER contestActiveAt'
  );
  await ensureColumn(
    'red_light_districts',
    'contestResolveAt',
    'ALTER TABLE red_light_districts ADD COLUMN contestResolveAt DATETIME NULL AFTER contestLockdownAt'
  );
  await ensureColumn(
    'red_light_districts',
    'contestCooldownUntil',
    'ALTER TABLE red_light_districts ADD COLUMN contestCooldownUntil DATETIME NULL AFTER contestResolveAt'
  );
  await ensureColumn(
    'red_light_districts',
    'lastOccupancyHeatAt',
    'ALTER TABLE red_light_districts ADD COLUMN lastOccupancyHeatAt DATETIME NULL AFTER contestCooldownUntil'
  );
  await ensureIndex(
    'red_light_districts',
    'idx_rld_contest_status',
    'CREATE INDEX idx_rld_contest_status ON red_light_districts(contestStatus)'
  );

  await ensureColumn(
    'red_light_rooms',
    'guardUntil',
    'ALTER TABLE red_light_rooms ADD COLUMN guardUntil DATETIME NULL AFTER tier'
  );
  await ensureColumn(
    'red_light_rooms',
    'guardCooldownUntil',
    'ALTER TABLE red_light_rooms ADD COLUMN guardCooldownUntil DATETIME NULL AFTER guardUntil'
  );
  await ensureColumn(
    'red_light_rooms',
    'sabotagedUntil',
    'ALTER TABLE red_light_rooms ADD COLUMN sabotagedUntil DATETIME NULL AFTER guardCooldownUntil'
  );

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS rld_steal_cooldowns (
      id INT NOT NULL AUTO_INCREMENT,
      attackerId INT NOT NULL,
      districtId INT NOT NULL,
      \`until\` DATETIME NOT NULL,
      PRIMARY KEY (id),
      UNIQUE KEY rld_steal_attacker_district (attackerId, districtId),
      KEY idx_rld_steal_until (\`until\`),
      CONSTRAINT fk_rld_steal_attacker FOREIGN KEY (attackerId) REFERENCES players(id) ON DELETE CASCADE,
      CONSTRAINT fk_rld_steal_district FOREIGN KEY (districtId) REFERENCES red_light_districts(id) ON DELETE CASCADE
    )
  `);

  await ensureColumn(
    'vip_events',
    'vipOnly',
    'ALTER TABLE vip_events ADD COLUMN vipOnly TINYINT(1) NOT NULL DEFAULT 0 AFTER currentParticipants'
  );
  await ensureColumn(
    'vip_events',
    'eventKey',
    'ALTER TABLE vip_events ADD COLUMN eventKey VARCHAR(50) NULL AFTER vipOnly'
  );

  try {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE vip_events MODIFY COLUMN countryCode VARCHAR(50) NOT NULL'
    );
  } catch (error) {
    console.warn('[StartupSchema] vip_events.countryCode widen skipped:', error);
  }

  await prisma.$executeRawUnsafe(`
    UPDATE red_light_districts d
    SET expansionLevel = LEAST(
      8,
      GREATEST(
        0,
        CEIL((GREATEST((SELECT COUNT(*) FROM red_light_rooms r WHERE r.redLightDistrictId = d.id), d.roomCount) - 4) / 2.0)
      )
    )
    WHERE expansionLevel = 0
  `);

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
