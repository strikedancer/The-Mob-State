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
}
