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

export async function ensureCrewVipFundSchema(): Promise<void> {
  if (!(await columnExists('crews', 'vipFundCents'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE crews ADD COLUMN vipFundCents INT NOT NULL DEFAULT 0'
    );
    console.log('[StartupSchema] Added crews.vipFundCents');
  }

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_vip_donations (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      playerId INT NOT NULL,
      amountCents INT NOT NULL,
      monthsGranted INT NOT NULL DEFAULT 0,
      molliePaymentId VARCHAR(64) NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY crew_vip_donations_molliePaymentId_key (molliePaymentId),
      INDEX idx_crew_vip_donations_crew (crewId, createdAt),
      INDEX idx_crew_vip_donations_player (playerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}
