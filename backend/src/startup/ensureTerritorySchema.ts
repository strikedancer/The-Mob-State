import prisma from '../lib/prisma';
import { territoryAutoRegionSeeds } from './territoryRegionSeeds';

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
  const exists = await columnExists(tableName, columnName);
  if (exists) {
    return;
  }

  await prisma.$executeRawUnsafe(alterSql);
  console.log(`[StartupSchema] Added ${tableName}.${columnName}`);
}

// ---------------------------------------------------------------------------
// Territory system – startup schema bootstrap
// All territory runtime settings are seeded into runtime_config (admin-only).
// ---------------------------------------------------------------------------

const TERRITORY_CONFIG_DEFAULTS: Record<string, string> = {
  TERRITORY_ENABLED: '1',
  TERRITORY_DEFAULT_COUNTRY: 'nl',
  TERRITORY_CONTEST_PREP_MINUTES: '30',
  TERRITORY_CONTEST_ACTIVE_MINUTES: '120',
  TERRITORY_CONTEST_LOCKDOWN_MINUTES: '15',
  TERRITORY_ACTION_COOLDOWN_SECONDS: '900',
  TERRITORY_ACTION_DAILY_CAP: '0',
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
  TERRITORY_PASSIVE_INCOME_INTERVAL_MINUTES: '60',
  TERRITORY_PASSIVE_INCOME_TIER_1_CASH: '25000',
  TERRITORY_PASSIVE_INCOME_TIER_2_CASH: '50000',
  TERRITORY_PASSIVE_INCOME_TIER_3_CASH: '90000',
  TERRITORY_PASSIVE_INCOME_TIER_4_CASH: '140000',
  TERRITORY_WAR_AFTERMATH_HOURS: '6',
  TERRITORY_WAR_AFTERMATH_TARGET_ATTACK_BONUS: '3',
  TERRITORY_WAR_AFTERMATH_ADJACENT_ATTACK_BONUS: '1',
  TERRITORY_WAR_AFTERMATH_TARGET_STABILITY_PENALTY: '20',
  TERRITORY_WAR_AFTERMATH_ADJACENT_STABILITY_PENALTY: '10',
  TERRITORY_HQ_REGION_CAP_PER_LEVEL: '0.2',
  TERRITORY_HQ_REGION_CAP_BONUS_CAP: '3',
  TERRITORY_HQ_CONTEST_CAP_PER_LEVEL: '0.1',
  TERRITORY_HQ_CONTEST_CAP_BONUS_CAP: '2',
  TERRITORY_HQ_ACTION_POINT_BONUS_PER_LEVEL: '0.12',
  TERRITORY_HQ_ACTION_POINT_BONUS_CAP: '2',
  TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_PER_LEVEL: '0.1',
  TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_CAP: '2',
  TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL: '0.18',
  TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL: '0.16',
  TERRITORY_CAR_STORAGE_RAID_BONUS_PER_LEVEL: '0.15',
  TERRITORY_BOAT_STORAGE_SUPPLY_BONUS_PER_LEVEL: '0.15',
  TERRITORY_DRUG_STORAGE_SABOTAGE_BONUS_PER_LEVEL: '0.15',
  TERRITORY_BUILDING_ACTION_BONUS_CAP: '3',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_PATROL: '0',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_INTEL_SCAN: '2',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SABOTAGE: '6',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SUPPLY_RUN: '2',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_RAID: '8',
  TERRITORY_ACTION_UNLOCK_HQ_LEVEL_DEFENSE: '4',
  TERRITORY_PROJECT_SAFEHOUSE_MIN_HQ_LEVEL: '4',
  TERRITORY_PROJECT_SAFEHOUSE_INCOME_BONUS_PERCENT: '10',
  TERRITORY_PROJECT_SURVEILLANCE_MIN_HQ_LEVEL: '5',
  TERRITORY_PROJECT_SURVEILLANCE_INTEL_BONUS_POINTS: '2',
  TERRITORY_PROJECT_SURVEILLANCE_INTEL_COOLDOWN_PERCENT: '75',
  TERRITORY_PROJECT_ARMS_CACHE_MIN_HQ_LEVEL: '6',
  TERRITORY_PROJECT_ARMS_CACHE_RAID_BONUS_POINTS: '2',
  TERRITORY_PROJECT_ARMS_CACHE_DEFENSE_BONUS_POINTS: '2',
  TERRITORY_PROJECT_CONTRIBUTE_PROGRESS: '20',
  TERRITORY_PROJECT_CONTRIBUTE_COOLDOWN_SECONDS: '900',
  TERRITORY_PROJECT_SABOTAGE_HP_DAMAGE: '20',
  TERRITORY_PROJECT_SUPPLY_REPAIR_HP: '15',
  TERRITORY_PROJECT_SUPPLY_BUILD_PROGRESS: '15',
  TERRITORY_REGION_EVENT_ENABLED: '1',
  TERRITORY_REGION_EVENT_ROTATION_HOURS: '12',
  TERRITORY_REGION_EVENT_ACTIVE_COUNT: '2',
  TERRITORY_REGION_EVENT_ATTACK_BONUS_POINTS: '2',
  TERRITORY_REGION_EVENT_INCOME_PENALTY_PERCENT: '15',
};

type TerritorySeedRegion = {
  countryCode: string;
  key: string;
  nl: string;
  en: string;
  svg: string;
  tier: number;
  strategicTags?: string[];
  neighbors?: string[];
};

function normalizeTerritoryRegionKey(svgElementId: string): string {
  return svgElementId
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 60);
}

function sanitizeSeedName(name: string): string {
  return name
    .trim()
    .replace(/\s+/g, ' ')
    .replace(/[’']/g, "'")
    .replace(/[^\x20-\x7E]/g, '');
}

function buildAutoRegions(countryCode: string, svgAssetKey: string): TerritorySeedRegion[] {
  const seeds = territoryAutoRegionSeeds[svgAssetKey] ?? [];
  return seeds.map((seed) => {
    const safeName = sanitizeSeedName(seed.name) || seed.svg;
    return {
      countryCode,
      key: normalizeTerritoryRegionKey(seed.svg),
      nl: safeName,
      en: safeName,
      svg: seed.svg,
      tier: 2,
      strategicTags: [],
      neighbors: [],
    };
  });
}

function normalizeSeedList(values: string[] | undefined): string[] {
  if (!values || values.length == 0) return [];
  return [...new Set(values.map((value) => value.trim()).filter(Boolean))];
}

function validateTerritorySeedRegions(regions: TerritorySeedRegion[]): void {
  const seenRegionKeys = new Set<string>();
  const seenCountrySvgIds = new Set<string>();

  for (const region of regions) {
    if (!region.countryCode.trim() || !region.key.trim() || !region.svg.trim()) {
      throw new Error(`Invalid territory seed metadata for ${region.countryCode}:${region.key || region.svg}`);
    }

    if (!region.nl.trim() || !region.en.trim()) {
      throw new Error(`Missing territory seed name for ${region.countryCode}:${region.key}`);
    }

    if (seenRegionKeys.has(region.key)) {
      throw new Error(`Duplicate territory region key detected: ${region.key}`);
    }
    seenRegionKeys.add(region.key);

    const countrySvgKey = `${region.countryCode}:${region.svg}`.toLowerCase();
    if (seenCountrySvgIds.has(countrySvgKey)) {
      throw new Error(`Duplicate territory SVG mapping detected: ${countrySvgKey}`);
    }
    seenCountrySvgIds.add(countrySvgKey);
  }
}

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

  // Territory must stay enabled in all environments.
  await prisma.$executeRawUnsafe(
    `INSERT INTO runtime_config (configKey, configValue)
     VALUES ('TERRITORY_ENABLED', '1')
     ON DUPLICATE KEY UPDATE configValue = '1'`,
  );
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
      lastIncomeAt DATETIME NULL,
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

  // ── Temporary Region Effects ─────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_region_effects (
      id INT NOT NULL AUTO_INCREMENT,
      regionKey VARCHAR(60) NOT NULL,
      effectType VARCHAR(32) NOT NULL,
      sourceType VARCHAR(32) NOT NULL DEFAULT 'crew_war',
      sourceId INT NULL,
      favoredCrewId INT NULL,
      affectedCrewId INT NULL,
      metadataJson LONGTEXT NULL,
      startsAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      endsAt DATETIME NOT NULL,
      resolvedAt DATETIME NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_territory_region_effects_region (regionKey),
      INDEX idx_territory_region_effects_type (effectType),
      INDEX idx_territory_region_effects_source (sourceType, sourceId),
      INDEX idx_territory_region_effects_active (endsAt, resolvedAt)
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

  // ── Region projects (Fase C) ─────────────────────────────────────────────
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_region_projects (
      id INT NOT NULL AUTO_INCREMENT,
      regionKey VARCHAR(60) NOT NULL,
      ownerCrewId INT NOT NULL,
      projectType VARCHAR(40) NOT NULL DEFAULT 'safehouse_network',
      status VARCHAR(20) NOT NULL DEFAULT 'building',
      progress INT NOT NULL DEFAULT 0,
      hp INT NOT NULL DEFAULT 100,
      maxHp INT NOT NULL DEFAULT 100,
      lastContributeAt DATETIME NULL,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_region_project (regionKey),
      INDEX idx_territory_projects_owner (ownerCrewId),
      INDEX idx_territory_projects_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await ensureColumn(
    'territory_control',
    'lastIncomeAt',
    'ALTER TABLE territory_control ADD COLUMN lastIncomeAt DATETIME NULL AFTER lastDecayAt',
  );

  await ensureColumn(
    'territory_control',
    'ownedSince',
    'ALTER TABLE territory_control ADD COLUMN ownedSince DATETIME NULL AFTER lastIncomeAt',
  );

  await prisma.$executeRawUnsafe(
    'UPDATE territory_control SET lastIncomeAt = COALESCE(lastIncomeAt, NOW())',
  );

  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET ownedSince = COALESCE(ownedSince, lastIncomeAt, updatedAt, NOW())
     WHERE ownerCrewId IS NOT NULL AND ownedSince IS NULL`,
  );

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS territory_crew_stats (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      seasonKey VARCHAR(64) NOT NULL,
      regionsWon INT NOT NULL DEFAULT 0,
      regionsDefended INT NOT NULL DEFAULT 0,
      regionsLost INT NOT NULL DEFAULT 0,
      contestsPlayed INT NOT NULL DEFAULT 0,
      holdSecondsTotal BIGINT NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_territory_crew_stats (crewId, seasonKey),
      INDEX idx_territory_crew_stats_season (seasonKey)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  // ── Seed supported countries ──────────────────────────────────────────────
  const countries = [
    { code: 'nl', nl: 'Nederland', en: 'Netherlands', svgAssetKey: 'netherlandsLow' },
    { code: 'be', nl: 'Belgie', en: 'Belgium', svgAssetKey: 'belgium' },
    { code: 'ar', nl: 'Argentinie', en: 'Argentina', svgAssetKey: 'argentinaLow' },
    { code: 'au', nl: 'Australie', en: 'Australia', svgAssetKey: 'australiaLow' },
    { code: 'br', nl: 'Brazilie', en: 'Brazil', svgAssetKey: 'brazilLow' },
    { code: 'cn', nl: 'China', en: 'China', svgAssetKey: 'chinaLow' },
    { code: 'co', nl: 'Colombia', en: 'Colombia', svgAssetKey: 'colombiaLow' },
    { code: 'fr', nl: 'Frankrijk', en: 'France', svgAssetKey: 'franceLow' },
    { code: 'de', nl: 'Duitsland', en: 'Germany', svgAssetKey: 'germanyLow' },
    { code: 'it', nl: 'Italie', en: 'Italy', svgAssetKey: 'italyLow' },
    { code: 'jp', nl: 'Japan', en: 'Japan', svgAssetKey: 'japanLow' },
    { code: 'mx', nl: 'Mexico', en: 'Mexico', svgAssetKey: 'mexicoLow' },
    { code: 'ru', nl: 'Rusland', en: 'Russia', svgAssetKey: 'russiaLow' },
    { code: 'es', nl: 'Spanje', en: 'Spain', svgAssetKey: 'spainLow' },
    { code: 'ch', nl: 'Zwitserland', en: 'Switzerland', svgAssetKey: 'switzerlandLow' },
    { code: 'tr', nl: 'Turkije', en: 'Turkey', svgAssetKey: 'turkeyLow' },
    { code: 'za', nl: 'Zuid-Afrika', en: 'South Africa', svgAssetKey: 'southAfricaLow' },
    { code: 'gb', nl: 'Verenigd Koninkrijk', en: 'United Kingdom', svgAssetKey: 'ukLow' },
    { code: 'us', nl: 'Verenigde Staten', en: 'United States', svgAssetKey: 'usaLow' },
  ];

  for (const country of countries) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_countries (countryCode, displayNameNl, displayNameEn, svgAssetKey, enabled)
       VALUES (?, ?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE
         displayNameNl = VALUES(displayNameNl),
         displayNameEn = VALUES(displayNameEn),
         svgAssetKey = VALUES(svgAssetKey),
         enabled = 1`,
      country.code,
      country.nl,
      country.en,
      country.svgAssetKey,
    );
  }

  // ── Seed regions ──────────────────────────────────────────────────────────
  const nlRegions = [
    {
      countryCode: 'nl', key: 'nl-groningen', nl: 'Groningen', en: 'Groningen', svg: 'NL-GR', tier: 2,
      strategicTags: ['harbor', 'border'], neighbors: ['nl-friesland', 'nl-drenthe'],
    },
    {
      countryCode: 'nl', key: 'nl-friesland', nl: 'Friesland', en: 'Friesland', svg: 'NL-FR', tier: 1,
      strategicTags: ['harbor'], neighbors: ['nl-groningen', 'nl-drenthe', 'nl-flevoland', 'nl-noord-holland'],
    },
    {
      countryCode: 'nl', key: 'nl-drenthe', nl: 'Drenthe', en: 'Drenthe', svg: 'NL-DR', tier: 1,
      strategicTags: ['border'], neighbors: ['nl-groningen', 'nl-friesland', 'nl-overijssel'],
    },
    {
      countryCode: 'nl', key: 'nl-overijssel', nl: 'Overijssel', en: 'Overijssel', svg: 'NL-OV', tier: 2,
      strategicTags: ['industry', 'border'], neighbors: ['nl-drenthe', 'nl-flevoland', 'nl-gelderland'],
    },
    {
      countryCode: 'nl', key: 'nl-flevoland', nl: 'Flevoland', en: 'Flevoland', svg: 'NL-FL', tier: 1,
      strategicTags: ['logistics'], neighbors: ['nl-friesland', 'nl-overijssel', 'nl-gelderland', 'nl-utrecht', 'nl-noord-holland'],
    },
    {
      countryCode: 'nl', key: 'nl-gelderland', nl: 'Gelderland', en: 'Gelderland', svg: 'NL-GE', tier: 2,
      strategicTags: ['industry', 'border'], neighbors: ['nl-overijssel', 'nl-flevoland', 'nl-utrecht', 'nl-zuid-holland', 'nl-noord-brabant', 'nl-limburg'],
    },
    {
      countryCode: 'nl', key: 'nl-utrecht', nl: 'Utrecht', en: 'Utrecht', svg: 'NL-UT', tier: 3,
      strategicTags: ['capital', 'logistics'], neighbors: ['nl-flevoland', 'nl-gelderland', 'nl-noord-holland', 'nl-zuid-holland', 'nl-noord-brabant'],
    },
    {
      countryCode: 'nl', key: 'nl-noord-holland', nl: 'Noord-Holland', en: 'North Holland', svg: 'NL-NH', tier: 3,
      strategicTags: ['capital', 'harbor'], neighbors: ['nl-friesland', 'nl-flevoland', 'nl-utrecht', 'nl-zuid-holland'],
    },
    {
      countryCode: 'nl', key: 'nl-zuid-holland', nl: 'Zuid-Holland', en: 'South Holland', svg: 'NL-ZH', tier: 3,
      strategicTags: ['capital', 'harbor', 'industry'], neighbors: ['nl-noord-holland', 'nl-utrecht', 'nl-gelderland', 'nl-zeeland', 'nl-noord-brabant'],
    },
    {
      countryCode: 'nl', key: 'nl-zeeland', nl: 'Zeeland', en: 'Zeeland', svg: 'NL-ZE', tier: 1,
      strategicTags: ['harbor'], neighbors: ['nl-zuid-holland', 'nl-noord-brabant'],
    },
    {
      countryCode: 'nl', key: 'nl-noord-brabant', nl: 'Noord-Brabant', en: 'North Brabant', svg: 'NL-NB', tier: 2,
      strategicTags: ['industry', 'logistics'], neighbors: ['nl-zeeland', 'nl-zuid-holland', 'nl-utrecht', 'nl-gelderland', 'nl-limburg'],
    },
    {
      countryCode: 'nl', key: 'nl-limburg', nl: 'Limburg', en: 'Limburg', svg: 'NL-LI', tier: 2,
      strategicTags: ['border', 'logistics'], neighbors: ['nl-gelderland', 'nl-noord-brabant'],
    },
  ].map((region) => ({
    ...region,
    strategicTags: normalizeSeedList(region.strategicTags),
    neighbors: normalizeSeedList(region.neighbors),
  })) satisfies TerritorySeedRegion[];

  const autoRegions = countries.flatMap((country) => {
    if (country.code === 'nl') {
      return [] as TerritorySeedRegion[];
    }
    return buildAutoRegions(country.code, country.svgAssetKey);
  });

  const allRegions = [...nlRegions, ...autoRegions];

  validateTerritorySeedRegions(allRegions);

  for (const r of allRegions) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_regions (countryCode, regionKey, nameNl, nameEn, svgElementId, valueTier, strategicTagsJson, neighborsJson, enabled)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE
         countryCode = VALUES(countryCode),
         nameNl = VALUES(nameNl),
         nameEn = VALUES(nameEn),
         svgElementId = VALUES(svgElementId),
         strategicTagsJson = VALUES(strategicTagsJson),
         neighborsJson = VALUES(neighborsJson),
         valueTier = VALUES(valueTier),
         enabled = VALUES(enabled)`,
      r.countryCode,
      r.key,
      r.nl,
      r.en,
      r.svg,
      r.tier,
      JSON.stringify(normalizeSeedList(r.strategicTags)),
      JSON.stringify(normalizeSeedList(r.neighbors)),
    );

    // Ensure a control row exists for each region (neutral by default)
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_control (regionKey, ownerCrewId, controlJson, stability, lastIncomeAt, ownedSince)
       VALUES (?, NULL, '{}', 100, NOW(), NULL)
       ON DUPLICATE KEY UPDATE regionKey = regionKey`,
      r.key,
    );
  }

  // ── Runtime config defaults ───────────────────────────────────────────────
  await seedRuntimeConfigDefaults();

  // ── Ensure current season ─────────────────────────────────────────────────
  await ensureCurrentTerritorySeason();

  try {
    const { backfillTerritoryCrewStatsFromContestsIfEmpty } = await import('../services/territoryCrewStatsService');
    await backfillTerritoryCrewStatsFromContestsIfEmpty();
  } catch (error) {
    console.warn('[StartupSchema] Territory crew stats backfill skipped:', error);
  }

  console.log('[StartupSchema] Territory schema check complete');
}

export async function ensureCurrentTerritorySeason(): Promise<void> {
  const now = new Date();
  const startsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));
  const endsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));
  const seasonKey = `${startsAt.getUTCFullYear()}-${String(startsAt.getUTCMonth() + 1).padStart(2, '0')}`;
  const rewardConfigJson = JSON.stringify({
    expansionTopCash: [500000, 250000, 100000],
    defenseTopCash: [400000, 200000, 100000],
    warFrontlineTopCash: [300000, 150000, 75000],
  });

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_seasons (seasonKey, status, startsAt, endsAt, rewardConfigJson)
     VALUES (?, 'active', ?, ?, ?)
     ON DUPLICATE KEY UPDATE
       rewardConfigJson = COALESCE(rewardConfigJson, VALUES(rewardConfigJson))`,
    seasonKey,
    startsAt,
    endsAt,
    rewardConfigJson,
  );
}
