import prisma from '../lib/prisma';

export async function ensureCrewTradeStorageSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_trade_storage_buildings (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      style VARCHAR(32) NOT NULL DEFAULT 'camping',
      level INT NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_trade_storage_crew (crewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_trade_inventory (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      goodType VARCHAR(50) NOT NULL,
      quantity INT NOT NULL DEFAULT 0,
      averagePurchasePrice INT NOT NULL DEFAULT 0,
      averageCondition INT NOT NULL DEFAULT 100,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_trade_good (crewId, goodType),
      INDEX idx_crew_trade_crew (crewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}
