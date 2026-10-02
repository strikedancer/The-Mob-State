import prisma from '../lib/prisma';

export async function ensureHitlistDailyContractSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS hitlist_daily_contracts (
      contractDate DATE NOT NULL,
      hitId INT NULL,
      targetPlayerId INT NOT NULL,
      bonusCash INT NOT NULL DEFAULT 25000,
      status VARCHAR(20) NOT NULL DEFAULT 'open',
      completedBy INT NULL,
      completedAt DATETIME NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (contractDate),
      KEY idx_hitlist_daily_contracts_hit (hitId),
      KEY idx_hitlist_daily_contracts_target (targetPlayerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}
