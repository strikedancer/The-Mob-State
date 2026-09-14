import prisma from '../lib/prisma';

export async function ensureCrewDealSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_storage_deals (
      id INT NOT NULL AUTO_INCREMENT,
      initiatorCrewId INT NOT NULL,
      counterpartyCrewId INT NOT NULL,
      createdByPlayerId INT NOT NULL,
      status VARCHAR(20) NOT NULL,
      initiatorOfferJson LONGTEXT NOT NULL,
      counterpartyOfferJson LONGTEXT NULL,
      initiatorConfirmedAt DATETIME NULL,
      counterpartyConfirmedAt DATETIME NULL,
      expiresAt DATETIME NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_crew_deals_initiator_status (initiatorCrewId, status),
      INDEX idx_crew_deals_counterparty_status (counterpartyCrewId, status),
      INDEX idx_crew_deals_expires (expiresAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}
