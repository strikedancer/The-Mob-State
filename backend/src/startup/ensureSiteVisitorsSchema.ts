import prisma from '../lib/prisma';

export async function ensureSiteVisitorsSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS site_visitors (
      ip VARCHAR(45) NOT NULL,
      hits INT NOT NULL DEFAULT 1,
      firstSeen DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      lastSeen DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      PRIMARY KEY (ip),
      KEY site_visitors_lastSeen_idx (lastSeen)
    ) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  `);
}
