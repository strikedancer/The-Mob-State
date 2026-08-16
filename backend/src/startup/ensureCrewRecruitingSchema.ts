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

export async function ensureCrewRecruitingSchema(): Promise<void> {
  await ensureColumn(
    'crews',
    'recruitingOpen',
    'ALTER TABLE crews ADD COLUMN recruitingOpen TINYINT(1) NOT NULL DEFAULT 1'
  );
  await ensureColumn(
    'crews',
    'autoAccept',
    'ALTER TABLE crews ADD COLUMN autoAccept TINYINT(1) NOT NULL DEFAULT 0'
  );

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_weekly_goal_claims (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      weekKey VARCHAR(16) NOT NULL,
      goalKey VARCHAR(64) NOT NULL,
      claimedByPlayerId INT NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_weekly_goal (crewId, weekKey, goalKey),
      INDEX idx_crew_weekly_goal_crew (crewId, weekKey)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}
