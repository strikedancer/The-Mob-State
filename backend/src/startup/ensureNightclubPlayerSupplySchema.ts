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

export async function ensureNightclubPlayerSupplySchema(): Promise<void> {
  if (!(await columnExists('nightclub_venues', 'playerSupplyEnabled'))) {
    await prisma.$executeRawUnsafe(
      'ALTER TABLE nightclub_venues ADD COLUMN playerSupplyEnabled TINYINT(1) NOT NULL DEFAULT 0 AFTER isOpen',
    );
    console.log('[StartupSchema] Added nightclub_venues.playerSupplyEnabled');
  }

  const defaults: Record<string, string> = {
    NIGHTCLUB_PLAYER_SUPPLY_ENABLED: '1',
    NIGHTCLUB_PLAYER_SUPPLY_PRICE_PERCENT: '55',
    NIGHTCLUB_PLAYER_SUPPLY_MIN_GRAMS: '50',
    NIGHTCLUB_PLAYER_SUPPLY_MAX_GRAMS: '5000',
  };
  for (const [key, value] of Object.entries(defaults)) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO runtime_config (configKey, configValue)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE configKey = configKey`,
      key,
      value,
    );
  }
}
