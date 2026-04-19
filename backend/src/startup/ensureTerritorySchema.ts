import prisma from '../lib/prisma';

// ---------------------------------------------------------------------------
// Territory system – startup schema bootstrap
// All territory runtime settings are seeded into runtime_config (admin-only).
// ---------------------------------------------------------------------------

const TERRITORY_CONFIG_DEFAULTS: Record<string, string> = {
  TERRITORY_ENABLED: '0',
  TERRITORY_DEFAULT_COUNTRY: 'nl',
  TERRITORY_CONTEST_PREP_MINUTES: '30',
  TERRITORY_CONTEST_ACTIVE_MINUTES: '120',
  TERRITORY_CONTEST_LOCKDOWN_MINUTES: '15',
  TERRITORY_ACTION_COOLDOWN_SECONDS: '900',
  TERRITORY_ACTION_DAILY_CAP: '20',
  TERRITORY_CAPTURE_THRESHOLD_PERCENT: '60',
  TERRITORY_DECAY_PER_HOUR: '2',
  TERRITORY_DECAY_GRACE_MINUTES: '60',
  TERRITORY_MAX_REGIONS_PER_CREW: '5',
  TERRITORY_MAX_CONCURRENT_CONTESTS_PER_CREW: '2',
  TERRITORY_PRIME_TIME_START_HOUR_UTC: '17',
  TERRITORY_PRIME_TIME_END_HOUR_UTC: '23',
  TERRITORY_ANTI_FARM_WINDOW_SECONDS: '1800',
  TERRITORY_ANTI_FARM_REPEAT_TARGET_CAP: '3',
  TERRITORY_REWARD_CASH_MULTIPLIER_PERCENT: '110',
  TERRITORY_REWARD_XP_MULTIPLIER_PERCENT: '110',
};

async function seedRuntimeConfigDefaults(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS runtime_config (
      configKey VARCHAR(120) NOT NULL PRIMARY KEY,
      configValue VARCHAR(255) NOT NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  for (const [key, value] of Object.entries(TERRITORY_CONFIG_DEFAULTS)) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO runtime_config (configKey, configValue)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE configKey = configKey`,
      key,
      value,
    );
  }
}

export async function ensureTerritorySchema(): Promise<void> {
  // ── Countries ────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_countries (
      id INT NOT NULL AUTO_INCREMENT,
      countryCode VARCHAR(10) NOT NULL,
      displayNameNl VARCHAR(100) NOT NULL,
      displayNameEn VARCHAR(100) NOT NULL,
      svgAssetKey VARCHAR(120) NOT NULL,
      enabled TINYINT(1) NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_country_code (countryCode)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Regions ──────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_regions (
      id INT NOT NULL AUTO_INCREMENT,
      countryCode VARCHAR(10) NOT NULL,
      regionKey VARCHAR(60) NOT NULL,
      nameNl VARCHAR(100) NOT NULL,
      nameEn VARCHAR(100) NOT NULL,
      svgElementId VARCHAR(120) NOT NULL,
      valueTier TINYINT(1) NOT NULL DEFAULT 1,
      strategicTagsJson LONGTEXT NULL,
      neighborsJson LONGTEXT NULL,
      enabled TINYINT(1) NOT NULL DEFAULT 1,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_region_key (regionKey),
      INDEX idx_territory_regions_country (countryCode),
      INDEX idx_territory_regions_svg (svgElementId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Control ───────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_control (
      id INT NOT NULL AUTO_INCREMENT,
      regionKey VARCHAR(60) NOT NULL,
      ownerCrewId INT NULL,
      controlJson LONGTEXT NULL,
      stability INT NOT NULL DEFAULT 100,
      lastDecayAt DATETIME NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_control_region (regionKey),
      INDEX idx_territory_control_owner (ownerCrewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Contests ──────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_contests (
      id INT NOT NULL AUTO_INCREMENT,
      regionKey VARCHAR(60) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'preparing',
      attackerCrewId INT NOT NULL,
      defenderCrewId INT NULL,
      startedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      activeAt DATETIME NULL,
      lockdownAt DATETIME NULL,
      resolveAt DATETIME NULL,
      resolvedAt DATETIME NULL,
      winnerCrewId INT NULL,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_territory_contests_region (regionKey),
      INDEX idx_territory_contests_attacker (attackerCrewId),
      INDEX idx_territory_contests_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Actions ───────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_actions (
      id INT NOT NULL AUTO_INCREMENT,
      contestId INT NOT NULL,
      actorId INT NOT NULL,
      actorCrewId INT NOT NULL,
      regionKey VARCHAR(60) NOT NULL,
      actionType VARCHAR(32) NOT NULL,
      pointsDelta INT NOT NULL DEFAULT 0,
      stabilityDelta INT NOT NULL DEFAULT 0,
      abuseFlagged TINYINT(1) NOT NULL DEFAULT 0,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_territory_actions_contest (contestId),
      INDEX idx_territory_actions_actor (actorId),
      INDEX idx_territory_actions_crew (actorCrewId),
      INDEX idx_territory_actions_created (createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Seasons ───────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_seasons (
      id INT NOT NULL AUTO_INCREMENT,
      seasonKey VARCHAR(64) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'active',
      startsAt DATETIME NOT NULL,
      endsAt DATETIME NOT NULL,
      rewardConfigJson LONGTEXT NULL,
      rewardsDistributedAt DATETIME NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_season_key (seasonKey),
      INDEX idx_territory_seasons_status (status),
      INDEX idx_territory_seasons_starts (startsAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Reward log ────────────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_reward_log (
      id INT NOT NULL AUTO_INCREMENT,
      seasonKey VARCHAR(64) NOT NULL,
      crewId INT NOT NULL,
      playerId INT NULL,
      rewardType VARCHAR(32) NOT NULL,
      cashAmount INT NOT NULL DEFAULT 0,
      xpAmount INT NOT NULL DEFAULT 0,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_territory_reward_season (seasonKey),
      INDEX idx_territory_reward_crew (crewId),
      INDEX idx_territory_reward_player (playerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Seed NL country ───────────────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    INSERT INTO territory_countries (countryCode, displayNameNl, displayNameEn, svgAssetKey, enabled)
    VALUES ('nl', 'Nederland', 'Netherlands', 'cafuego-Nederland', 0)
    ON DUPLICATE KEY UPDATE countryCode = countryCode
  `);

  // ── Seed NL provinces ─────────────────────────────────────────────────────
  const nlRegions = [
    { key: 'nl-groningen',     nl: 'Groningen',     en: 'Groningen',      svg: 'path-groningen',     tier: 2 },
    { key: 'nl-friesland',     nl: 'Friesland',     en: 'Friesland',      svg: 'path-friesland',     tier: 1 },
    { key: 'nl-drenthe',       nl: 'Drenthe',       en: 'Drenthe',        svg: 'path-drenthe',       tier: 1 },
    { key: 'nl-overijssel',    nl: 'Overijssel',    en: 'Overijssel',     svg: 'path-overijssel',    tier: 2 },
    { key: 'nl-flevoland',     nl: 'Flevoland',     en: 'Flevoland',      svg: 'path-flevoland',     tier: 1 },
    { key: 'nl-gelderland',    nl: 'Gelderland',    en: 'Gelderland',     svg: 'path-gelderland',    tier: 2 },
    { key: 'nl-utrecht',       nl: 'Utrecht',       en: 'Utrecht',        svg: 'path-utrecht',       tier: 3 },
    { key: 'nl-noord-holland', nl: 'Noord-Holland', en: 'North Holland',  svg: 'path-noord-holland', tier: 3 },
    { key: 'nl-zuid-holland',  nl: 'Zuid-Holland',  en: 'South Holland',  svg: 'path-zuid-holland',  tier: 3 },
    { key: 'nl-zeeland',       nl: 'Zeeland',       en: 'Zeeland',        svg: 'path-zeeland',       tier: 1 },
    { key: 'nl-noord-brabant', nl: 'Noord-Brabant', en: 'North Brabant',  svg: 'path-noord-brabant', tier: 2 },
    { key: 'nl-limburg',       nl: 'Limburg',       en: 'Limburg',        svg: 'path-limburg',       tier: 2 },
  ];

  for (const r of nlRegions) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_regions (countryCode, regionKey, nameNl, nameEn, svgElementId, valueTier, enabled)
       VALUES ('nl', ?, ?, ?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE regionKey = regionKey`,
      r.key, r.nl, r.en, r.svg, r.tier,
    );

    // Ensure a control row exists for each region (neutral by default)
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_control (regionKey, ownerCrewId, controlJson, stability)
       VALUES (?, NULL, '{}', 100)
       ON DUPLICATE KEY UPDATE regionKey = regionKey`,
      r.key,
    );
  }

  // ── Runtime config defaults ───────────────────────────────────────────────
  await seedRuntimeConfigDefaults();

  // ── Ensure current season ─────────────────────────────────────────────────
  await ensureCurrentTerritorySeason();

  console.log('[StartupSchema] Territory schema check complete');
}

export async function ensureCurrentTerritorySeason(): Promise<void> {
  const now = new Date();
  const startsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));
  const endsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));
  const seasonKey = `${startsAt.getUTCFullYear()}-${String(startsAt.getUTCMonth() + 1).padStart(2, '0')}`;

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_seasons (seasonKey, status, startsAt, endsAt)
     VALUES (?, 'active', ?, ?)
     ON DUPLICATE KEY UPDATE seasonKey = seasonKey`,
    seasonKey,
    startsAt,
    endsAt,
  );
}
