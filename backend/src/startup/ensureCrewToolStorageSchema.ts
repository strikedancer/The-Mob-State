import prisma from '../lib/prisma';

export async function ensureCrewToolStorageSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_tool_storage_buildings (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      style VARCHAR(32) NOT NULL DEFAULT 'camping',
      level INT NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_tool_storage_crew (crewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_tool_inventory (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      toolId VARCHAR(50) NOT NULL,
      durability INT NOT NULL DEFAULT 100,
      addedByPlayerId INT NOT NULL,
      addedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_crew_tool_crew (crewId),
      INDEX idx_crew_tool_crew_tool (crewId, toolId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await ensureCrewToolWithdrawColumns();
}

/** Leader/co-leader gate for taking a crew tool into a personal backpack. */
async function ensureCrewToolWithdrawColumns(): Promise<void> {
  const add = async (sql: string) => {
    await prisma.$executeRawUnsafe(sql).catch(() => undefined);
  };
  await add(
    `ALTER TABLE crews ADD COLUMN toolWithdrawMode VARCHAR(20) NOT NULL DEFAULT 'rank'`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN toolWithdrawMinRank INT NOT NULL DEFAULT 1`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN toolWithdrawMinDays INT NOT NULL DEFAULT 7`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN toolWithdrawIncomePercent INT NOT NULL DEFAULT 5`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN toolWithdrawEnabled TINYINT(1) NOT NULL DEFAULT 1`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN ammoWithdrawEnabled TINYINT(1) NOT NULL DEFAULT 1`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN partsWithdrawEnabled TINYINT(1) NOT NULL DEFAULT 1`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN weaponWithdrawEnabled TINYINT(1) NOT NULL DEFAULT 1`,
  );
  await add(
    `ALTER TABLE crews ADD COLUMN vehicleWithdrawEnabled TINYINT(1) NOT NULL DEFAULT 1`,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE crews
     SET toolWithdrawEnabled = 0, toolWithdrawMode = 'rank'
     WHERE toolWithdrawMode = 'off'`,
  ).catch(() => undefined);
}
