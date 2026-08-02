import prisma from '../lib/prisma';

const DEEP_ECONOMY_CONFIG_DEFAULTS: Record<string, string> = {
  LAUNDER_ENABLED: '1',
  LAUNDER_FEE_PERCENT: '12',
  LAUNDER_MIN_AMOUNT: '10000',
  LAUNDER_MAX_AMOUNT: '5000000',
  LAUNDER_DURATION_MINUTES: '30',
  LAUNDER_COOLDOWN_SECONDS: '900',
  LAUNDER_SEIZE_CHANCE_PER_HEAT: '0.4',
  LAUNDER_HEAT_REDUCTION_ON_SUCCESS: '2',
  STOCK_MARKET_ENABLED: '1',
  STOCK_MARKET_TICK_SECONDS: '60',
  STOCK_MARKET_MAX_POSITIONS: '10',
  PROPERTY_DEVELOP_ENABLED: '1',
  PROPERTY_DEVELOP_MAX_LEVEL: '5',
  PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE: '25',
  PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL: '8',
  PROPERTY_DEVELOP_COOLDOWN_SECONDS: '3600',
};

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

async function seedRuntimeConfigDefaults(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS runtime_config (
      configKey VARCHAR(120) NOT NULL PRIMARY KEY,
      configValue VARCHAR(255) NOT NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  for (const [key, value] of Object.entries(DEEP_ECONOMY_CONFIG_DEFAULTS)) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO runtime_config (configKey, configValue)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE configKey = configKey`,
      key,
      value,
    );
  }
}

export async function ensureDeepEconomySchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS launder_jobs (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      amountIn INT NOT NULL,
      feeAmount INT NOT NULL,
      amountOut INT NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'processing',
      seizeChancePercent DECIMAL(8,3) NOT NULL DEFAULT 0,
      startedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      completesAt DATETIME NOT NULL,
      completedAt DATETIME NULL,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_launder_player_status (playerId, status),
      INDEX idx_launder_completes (completesAt, status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS stock_assets (
      symbol VARCHAR(16) NOT NULL,
      nameEn VARCHAR(80) NOT NULL,
      nameNl VARCHAR(80) NOT NULL,
      basePrice DECIMAL(14,4) NOT NULL,
      currentPrice DECIMAL(14,4) NOT NULL,
      volatility DECIMAL(8,4) NOT NULL DEFAULT 1.5,
      enabled TINYINT(1) NOT NULL DEFAULT 1,
      lastTickAt DATETIME NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (symbol)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS stock_holdings (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      symbol VARCHAR(16) NOT NULL,
      quantity INT NOT NULL DEFAULT 0,
      avgCost DECIMAL(14,4) NOT NULL DEFAULT 0,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_stock_holding (playerId, symbol),
      INDEX idx_stock_holdings_player (playerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS stock_trades (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      symbol VARCHAR(16) NOT NULL,
      side VARCHAR(8) NOT NULL,
      quantity INT NOT NULL,
      price DECIMAL(14,4) NOT NULL,
      totalCash INT NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_stock_trades_player (playerId, createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  await ensureColumn(
    'properties',
    'developmentLevel',
    'ALTER TABLE properties ADD COLUMN developmentLevel INT NOT NULL DEFAULT 0 AFTER upgradeLevel',
  );
  await ensureColumn(
    'properties',
    'lastDevelopAt',
    'ALTER TABLE properties ADD COLUMN lastDevelopAt DATETIME NULL AFTER developmentLevel',
  );

  const stocks = [
    { symbol: 'TMS', nameEn: 'The Mob State Holdings', nameNl: 'The Mob State Holdings', price: 100, vol: 1.2 },
    { symbol: 'NRD', nameEn: 'North Dock Logistics', nameNl: 'North Dock Logistiek', price: 42, vol: 1.8 },
    { symbol: 'GLC', nameEn: 'Goldline Casinos', nameNl: 'Goldline Casino\'s', price: 75, vol: 2.1 },
    { symbol: 'HBR', nameEn: 'Harbor Freight Co', nameNl: 'Haven Freight Co', price: 28, vol: 2.4 },
    { symbol: 'VIP', nameEn: 'Velvet Inner Circle', nameNl: 'Velvet Inner Circle', price: 160, vol: 1.5 },
  ];

  for (const stock of stocks) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO stock_assets (symbol, nameEn, nameNl, basePrice, currentPrice, volatility, enabled, lastTickAt)
       VALUES (?, ?, ?, ?, ?, ?, 1, NOW())
       ON DUPLICATE KEY UPDATE
         nameEn = VALUES(nameEn),
         nameNl = VALUES(nameNl),
         volatility = VALUES(volatility),
         enabled = 1`,
      stock.symbol,
      stock.nameEn,
      stock.nameNl,
      stock.price,
      stock.price,
      stock.vol,
    );
  }

  await seedRuntimeConfigDefaults();
  console.log('[StartupSchema] Deep economy schema check complete');
}
