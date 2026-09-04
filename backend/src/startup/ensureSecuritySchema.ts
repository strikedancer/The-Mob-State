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

export async function ensureSecuritySchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS player_security (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      bodyguards INT NOT NULL DEFAULT 0,
      bodyguardUpkeepDueAt DATETIME NULL,
      armor INT NOT NULL DEFAULT 0,
      armorCondition INT NOT NULL DEFAULT 100,
      armorType VARCHAR(50) NULL,
      PRIMARY KEY (id),
      UNIQUE KEY uniq_player_security_player (playerId),
      INDEX idx_player_security_player (playerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await ensureColumn(
    'player_security',
    'bodyguardUpkeepDueAt',
    'ALTER TABLE player_security ADD COLUMN bodyguardUpkeepDueAt DATETIME NULL AFTER bodyguards'
  );
  await ensureColumn(
    'player_security',
    'armorCondition',
    'ALTER TABLE player_security ADD COLUMN armorCondition INT NOT NULL DEFAULT 100 AFTER armor'
  );
  await ensureColumn(
    'player_security',
    'bodyguardsStreet',
    'ALTER TABLE player_security ADD COLUMN bodyguardsStreet INT NOT NULL DEFAULT 0 AFTER bodyguards'
  );
  await ensureColumn(
    'player_security',
    'bodyguardsElite',
    'ALTER TABLE player_security ADD COLUMN bodyguardsElite INT NOT NULL DEFAULT 0 AFTER bodyguardsStreet'
  );

  await prisma.$executeRawUnsafe(`
    UPDATE player_security
    SET armorCondition = 100
    WHERE armorCondition IS NULL OR armorCondition <= 0
  `);

  await prisma.$executeRawUnsafe(`
    UPDATE player_security
    SET bodyguardUpkeepDueAt = DATE_ADD(NOW(), INTERVAL 24 HOUR)
    WHERE bodyguards > 0 AND bodyguardUpkeepDueAt IS NULL
  `);

  await prisma.$executeRawUnsafe(`
    UPDATE player_security
    SET bodyguardUpkeepDueAt = NULL
    WHERE bodyguards <= 0
  `);

  await ensureColumn(
    'hit_list',
    'lastCombatAt',
    'ALTER TABLE hit_list ADD COLUMN lastCombatAt DATETIME NULL AFTER status'
  );
}