import prisma from '../lib/prisma';

/** Optional crew income share columns on crew_members. */
export async function ensureCrewIncomeShareSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    ALTER TABLE crew_members
      ADD COLUMN IF NOT EXISTS incomeShareEnabled TINYINT(1) NOT NULL DEFAULT 0,
      ADD COLUMN IF NOT EXISTS lifetimeContribution BIGINT NOT NULL DEFAULT 0
  `).catch(async () => {
    // MariaDB without IF NOT EXISTS on ADD COLUMN — check then add.
    const cols = await prisma.$queryRawUnsafe<Array<{ Field: string }>>(
      `SHOW COLUMNS FROM crew_members`,
    );
    const names = new Set(cols.map((c) => c.Field));
    if (!names.has('incomeShareEnabled')) {
      await prisma.$executeRawUnsafe(
        `ALTER TABLE crew_members ADD COLUMN incomeShareEnabled TINYINT(1) NOT NULL DEFAULT 0`,
      );
    }
    if (!names.has('lifetimeContribution')) {
      await prisma.$executeRawUnsafe(
        `ALTER TABLE crew_members ADD COLUMN lifetimeContribution BIGINT NOT NULL DEFAULT 0`,
      );
    }
  });
}
