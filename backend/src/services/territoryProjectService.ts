import prisma from '../lib/prisma';

export const PROJECT_TYPE_SAFEHOUSE = 'safehouse_network';
export const PROJECT_TYPE_SURVEILLANCE = 'surveillance_grid';
export const PROJECT_TYPE_ARMS_CACHE = 'arms_cache';

export const TERRITORY_PROJECT_TYPES = [
  PROJECT_TYPE_SAFEHOUSE,
  PROJECT_TYPE_SURVEILLANCE,
  PROJECT_TYPE_ARMS_CACHE,
] as const;

export type TerritoryProjectType = (typeof TERRITORY_PROJECT_TYPES)[number];

export type TerritoryProjectCatalogEntry = {
  projectType: TerritoryProjectType;
  requiredTags: string[];
  minHqLevel: number;
  incomeBonusPercent: number;
  intelScanBonusPoints: number;
  raidBonusPoints: number;
  defenseBonusPoints: number;
};

export function isTerritoryProjectType(value: string): value is TerritoryProjectType {
  return (TERRITORY_PROJECT_TYPES as readonly string[]).includes(value);
}

export type TerritoryProjectStatus = 'building' | 'active' | 'damaged' | 'destroyed';

export type TerritoryRegionProject = {
  id: number;
  regionKey: string;
  ownerCrewId: number;
  projectType: string;
  status: TerritoryProjectStatus;
  progress: number;
  hp: number;
  maxHp: number;
  lastContributeAt: Date | null;
  incomeBonusPercent: number;
};

export type TerritoryProjectConfig = {
  safehouseMinHqLevel: number;
  safehouseIncomeBonusPercent: number;
  surveillanceMinHqLevel: number;
  surveillanceIntelBonusPoints: number;
  surveillanceIntelCooldownPercent: number;
  armsCacheMinHqLevel: number;
  armsCacheRaidBonusPoints: number;
  armsCacheDefenseBonusPoints: number;
  contributeProgress: number;
  contributeCooldownSeconds: number;
  sabotageHpDamage: number;
  supplyRepairHp: number;
  supplyBuildProgress: number;
};

export type TerritoryProjectOption = {
  projectType: TerritoryProjectType;
  minHqLevel: number;
  allowed: boolean;
  lockedByHq: boolean;
  lockedByTags: boolean;
};

export type ContestProjectEffect = {
  projectId: number;
  projectType: string;
  previousStatus: TerritoryProjectStatus;
  status: TerritoryProjectStatus;
  progress: number;
  hp: number;
  maxHp: number;
  effect: 'sabotaged' | 'repaired' | 'advanced' | 'none';
};

type ProjectRow = {
  id: number;
  regionKey: string;
  ownerCrewId: number;
  projectType: string;
  status: string;
  progress: number;
  hp: number;
  maxHp: number;
  lastContributeAt: Date | null;
};

function toNumeric(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

function normalizeStatus(raw: string): TerritoryProjectStatus {
  if (raw === 'active' || raw === 'damaged' || raw === 'destroyed' || raw === 'building') {
    return raw;
  }
  return 'building';
}

function catalogForConfig(config: TerritoryProjectConfig): TerritoryProjectCatalogEntry[] {
  return [
    {
      projectType: PROJECT_TYPE_SAFEHOUSE,
      requiredTags: [],
      minHqLevel: Math.max(0, Math.floor(config.safehouseMinHqLevel)),
      incomeBonusPercent: Math.max(0, Math.floor(config.safehouseIncomeBonusPercent)),
      intelScanBonusPoints: 0,
      raidBonusPoints: 0,
      defenseBonusPoints: 0,
    },
    {
      projectType: PROJECT_TYPE_SURVEILLANCE,
      requiredTags: ['harbor', 'airhub', 'capital'],
      minHqLevel: Math.max(0, Math.floor(config.surveillanceMinHqLevel)),
      incomeBonusPercent: 0,
      intelScanBonusPoints: Math.max(0, Math.floor(config.surveillanceIntelBonusPoints)),
      raidBonusPoints: 0,
      defenseBonusPoints: 0,
    },
    {
      projectType: PROJECT_TYPE_ARMS_CACHE,
      requiredTags: ['industry', 'border'],
      minHqLevel: Math.max(0, Math.floor(config.armsCacheMinHqLevel)),
      incomeBonusPercent: 0,
      intelScanBonusPoints: 0,
      raidBonusPoints: Math.max(0, Math.floor(config.armsCacheRaidBonusPoints)),
      defenseBonusPoints: Math.max(0, Math.floor(config.armsCacheDefenseBonusPoints)),
    },
  ];
}

export function getProjectCatalogEntry(
  projectType: string,
  config: TerritoryProjectConfig,
): TerritoryProjectCatalogEntry | null {
  return catalogForConfig(config).find((entry) => entry.projectType === projectType) ?? null;
}

function regionHasRequiredTags(strategicTags: string[], requiredTags: string[]): boolean {
  if (requiredTags.length === 0) return true;
  const tags = strategicTags.map((tag) => tag.toLowerCase());
  return requiredTags.some((required) => tags.includes(required.toLowerCase()));
}

export function listProjectOptions(params: {
  strategicTags: string[];
  hqGlobalLevel: number;
  config: TerritoryProjectConfig;
}): TerritoryProjectOption[] {
  return catalogForConfig(params.config).map((entry) => {
    const lockedByTags = !regionHasRequiredTags(params.strategicTags, entry.requiredTags);
    const lockedByHq = params.hqGlobalLevel < entry.minHqLevel;
    return {
      projectType: entry.projectType,
      minHqLevel: entry.minHqLevel,
      lockedByHq,
      lockedByTags,
      allowed: !lockedByHq && !lockedByTags,
    };
  });
}

function incomeBonusForProject(row: ProjectRow, config: TerritoryProjectConfig): number {
  if (row.projectType !== PROJECT_TYPE_SAFEHOUSE) return 0;
  const percent = Math.max(0, Math.floor(config.safehouseIncomeBonusPercent));
  const status = normalizeStatus(row.status);
  if (status === 'active') return percent;
  if (status === 'damaged') return Math.floor(percent / 2);
  return 0;
}

function mapProjectRow(row: ProjectRow, config: TerritoryProjectConfig): TerritoryRegionProject {
  return {
    id: toNumeric(row.id),
    regionKey: row.regionKey,
    ownerCrewId: toNumeric(row.ownerCrewId),
    projectType: row.projectType,
    status: normalizeStatus(row.status),
    progress: clamp(toNumeric(row.progress), 0, 100),
    hp: Math.max(0, toNumeric(row.hp)),
    maxHp: Math.max(1, toNumeric(row.maxHp)),
    lastContributeAt: row.lastContributeAt ?? null,
    incomeBonusPercent: incomeBonusForProject(row, config),
  };
}

export function buildProjectActionBonuses(
  project: TerritoryRegionProject | null,
  config: TerritoryProjectConfig,
): Array<{ actionType: string; bonusPoints: number; labelNl: string; labelEn: string }> {
  if (!project || (project.status !== 'active' && project.status !== 'damaged')) return [];
  const entry = getProjectCatalogEntry(project.projectType, config);
  if (!entry) return [];
  const damagedFactor = project.status === 'damaged' ? 0.5 : 1;
  const bonuses: Array<{ actionType: string; bonusPoints: number; labelNl: string; labelEn: string }> = [];
  const intel = Math.max(0, Math.floor(entry.intelScanBonusPoints * damagedFactor));
  const raid = Math.max(0, Math.floor(entry.raidBonusPoints * damagedFactor));
  const defense = Math.max(0, Math.floor(entry.defenseBonusPoints * damagedFactor));
  if (intel > 0) {
    bonuses.push({
      actionType: 'intel_scan',
      bonusPoints: intel,
      labelNl: 'Surveillance-netwerk',
      labelEn: 'Surveillance grid',
    });
  }
  if (raid > 0) {
    bonuses.push({
      actionType: 'raid',
      bonusPoints: raid,
      labelNl: 'Wapenopslag',
      labelEn: 'Arms cache',
    });
  }
  if (defense > 0) {
    bonuses.push({
      actionType: 'defense',
      bonusPoints: defense,
      labelNl: 'Wapenopslag',
      labelEn: 'Arms cache',
    });
  }
  return bonuses;
}

export function intelCooldownSecondsForRegion(
  baseCooldownSeconds: number,
  project: TerritoryRegionProject | null,
  config: TerritoryProjectConfig,
): number {
  const base = Math.max(0, Math.floor(baseCooldownSeconds));
  if (!project || project.projectType !== PROJECT_TYPE_SURVEILLANCE) return base;
  if (project.status !== 'active' && project.status !== 'damaged') return base;
  const percent = Math.min(100, Math.max(25, Math.floor(config.surveillanceIntelCooldownPercent)));
  return Math.max(0, Math.floor((base * percent) / 100));
}

export async function getProjectsByRegionKeys(
  regionKeys: string[],
  config: TerritoryProjectConfig,
): Promise<Record<string, TerritoryRegionProject>> {
  if (regionKeys.length === 0) return {};
  const placeholders = regionKeys.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<ProjectRow[]>(
    `SELECT id, regionKey, ownerCrewId, projectType, status, progress, hp, maxHp, lastContributeAt
     FROM territory_region_projects
     WHERE regionKey IN (${placeholders})`,
    ...regionKeys,
  );
  return rows.reduce<Record<string, TerritoryRegionProject>>((acc, row) => {
    acc[row.regionKey] = mapProjectRow(row, config);
    return acc;
  }, {});
}

export async function getActiveIncomeBonusByRegionKeys(
  regionKeys: string[],
  config: TerritoryProjectConfig,
): Promise<Record<string, number>> {
  if (regionKeys.length === 0 || config.safehouseIncomeBonusPercent <= 0) return {};
  const placeholders = regionKeys.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; status: string }>>(
    `SELECT regionKey, status FROM territory_region_projects
     WHERE regionKey IN (${placeholders}) AND status IN ('active', 'damaged')
       AND projectType = ?`,
    ...regionKeys,
    PROJECT_TYPE_SAFEHOUSE,
  );
  return rows.reduce<Record<string, number>>((acc, row) => {
    acc[row.regionKey] = row.status === 'damaged'
      ? Math.floor(config.safehouseIncomeBonusPercent / 2)
      : config.safehouseIncomeBonusPercent;
    return acc;
  }, {});
}

export async function startRegionProject(params: {
  crewId: number;
  regionKey: string;
  projectType: string;
  hqGlobalLevel: number;
  strategicTags: string[];
  config: TerritoryProjectConfig;
  currentCountry: string | null | undefined;
  assertInCountry: (currentCountry: string | null | undefined, regionCountryCode: string) => void;
}): Promise<TerritoryRegionProject> {
  const {
    crewId,
    regionKey,
    projectType: rawType,
    hqGlobalLevel,
    strategicTags,
    config,
    currentCountry,
    assertInCountry,
  } = params;

  if (!isTerritoryProjectType(rawType)) {
    throw new Error('PROJECT_INVALID_TYPE');
  }
  const projectType = rawType;
  const catalog = getProjectCatalogEntry(projectType, config);
  if (!catalog) throw new Error('PROJECT_INVALID_TYPE');

  if (hqGlobalLevel < catalog.minHqLevel) {
    throw new Error('PROJECT_HQ_LEVEL_REQUIRED');
  }
  if (!regionHasRequiredTags(strategicTags, catalog.requiredTags)) {
    throw new Error('PROJECT_TAG_MISMATCH');
  }

  const regions = await prisma.$queryRawUnsafe<Array<{ regionKey: string; countryCode: string }>>(
    'SELECT regionKey, countryCode FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    regionKey,
  );
  if (!regions[0]) throw new Error('REGION_NOT_FOUND');
  assertInCountry(currentCountry, regions[0].countryCode);

  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    'SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  if (toNumeric(control[0]?.ownerCrewId) !== crewId) {
    throw new Error('PROJECT_NOT_OWNER');
  }

  const existing = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE regionKey = ? LIMIT 1',
    regionKey,
  );

  if (existing[0]) {
    const status = normalizeStatus(existing[0].status);
    if (status !== 'destroyed') {
      throw new Error('PROJECT_ALREADY_EXISTS');
    }
    await prisma.$executeRawUnsafe(
      `UPDATE territory_region_projects
       SET ownerCrewId = ?, projectType = ?, status = 'building', progress = 0, hp = 100, maxHp = 100,
           lastContributeAt = NULL, updatedAt = NOW()
       WHERE regionKey = ?`,
      crewId,
      projectType,
      regionKey,
    );
  } else {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_region_projects
         (regionKey, ownerCrewId, projectType, status, progress, hp, maxHp)
       VALUES (?, ?, ?, 'building', 0, 100, 100)`,
      regionKey,
      crewId,
      projectType,
    );
  }

  const rows = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  if (!rows[0]) throw new Error('PROJECT_NOT_FOUND');
  return mapProjectRow(rows[0], config);
}

/** @deprecated Use startRegionProject — kept as alias for older call sites. */
export async function startSafehouseProject(params: {
  crewId: number;
  regionKey: string;
  hqGlobalLevel: number;
  config: TerritoryProjectConfig;
  currentCountry: string | null | undefined;
  assertInCountry: (currentCountry: string | null | undefined, regionCountryCode: string) => void;
  strategicTags?: string[];
}): Promise<TerritoryRegionProject> {
  return startRegionProject({
    ...params,
    projectType: PROJECT_TYPE_SAFEHOUSE,
    strategicTags: params.strategicTags ?? [],
  });
}

export async function contributeRegionProject(params: {
  crewId: number;
  regionKey: string;
  config: TerritoryProjectConfig;
  currentCountry: string | null | undefined;
  assertInCountry: (currentCountry: string | null | undefined, regionCountryCode: string) => void;
}): Promise<TerritoryRegionProject> {
  const { crewId, regionKey, config, currentCountry, assertInCountry } = params;

  const regions = await prisma.$queryRawUnsafe<Array<{ regionKey: string; countryCode: string }>>(
    'SELECT regionKey, countryCode FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    regionKey,
  );
  if (!regions[0]) throw new Error('REGION_NOT_FOUND');
  assertInCountry(currentCountry, regions[0].countryCode);

  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    'SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  if (toNumeric(control[0]?.ownerCrewId) !== crewId) {
    throw new Error('PROJECT_NOT_OWNER');
  }

  const rows = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const project = rows[0];
  if (!project) throw new Error('PROJECT_NOT_FOUND');
  if (toNumeric(project.ownerCrewId) !== crewId) throw new Error('PROJECT_NOT_OWNER');

  const status = normalizeStatus(project.status);
  if (status === 'destroyed') throw new Error('PROJECT_DESTROYED');
  if (status === 'active') throw new Error('PROJECT_ALREADY_ACTIVE');

  const now = Date.now();
  if (project.lastContributeAt) {
    const elapsed = now - new Date(project.lastContributeAt).getTime();
    if (elapsed < config.contributeCooldownSeconds * 1000) {
      throw new Error('PROJECT_CONTRIBUTE_COOLDOWN');
    }
  }

  let nextProgress = clamp(toNumeric(project.progress) + config.contributeProgress, 0, 100);
  let nextHp = Math.max(0, toNumeric(project.hp));
  let nextStatus: TerritoryProjectStatus = status;

  if (status === 'damaged') {
    nextHp = clamp(nextHp + config.supplyRepairHp, 0, toNumeric(project.maxHp) || 100);
    nextStatus = nextHp >= (toNumeric(project.maxHp) || 100) ? 'active' : 'damaged';
  } else if (status === 'building') {
    if (nextProgress >= 100) {
      nextProgress = 100;
      nextStatus = 'active';
      nextHp = toNumeric(project.maxHp) || 100;
    } else {
      nextStatus = 'building';
    }
  }

  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_projects
     SET progress = ?, hp = ?, status = ?, lastContributeAt = NOW(), updatedAt = NOW()
     WHERE id = ?`,
    nextProgress,
    nextHp,
    nextStatus,
    project.id,
  );

  const updated = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE id = ? LIMIT 1',
    project.id,
  );
  if (!updated[0]) throw new Error('PROJECT_NOT_FOUND');
  return mapProjectRow(updated[0], config);
}

/** @deprecated Use contributeRegionProject */
export async function contributeSafehouseProject(params: {
  crewId: number;
  regionKey: string;
  config: TerritoryProjectConfig;
  currentCountry: string | null | undefined;
  assertInCountry: (currentCountry: string | null | undefined, regionCountryCode: string) => void;
}): Promise<TerritoryRegionProject> {
  return contributeRegionProject(params);
}

export async function applyContestActionToProject(params: {
  regionKey: string;
  actionType: string;
  actorCrewId: number;
  defenderCrewId: number | null;
  config: TerritoryProjectConfig;
}): Promise<ContestProjectEffect | null> {
  const { regionKey, actionType, actorCrewId, defenderCrewId, config } = params;
  if (actionType !== 'sabotage' && actionType !== 'supply_run') return null;

  const rows = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const project = rows[0];
  if (!project) return null;

  const previousStatus = normalizeStatus(project.status);
  if (previousStatus === 'destroyed') return null;

  let progress = clamp(toNumeric(project.progress), 0, 100);
  let hp = Math.max(0, toNumeric(project.hp));
  const maxHp = Math.max(1, toNumeric(project.maxHp));
  let status = previousStatus;
  let effect: ContestProjectEffect['effect'] = 'none';

  if (actionType === 'sabotage') {
    // Attackers damage the defending owner's project.
    if (defenderCrewId == null || toNumeric(project.ownerCrewId) !== defenderCrewId) {
      return null;
    }
    hp = Math.max(0, hp - config.sabotageHpDamage);
    if (hp <= 0) {
      status = 'destroyed';
      progress = 0;
      hp = 0;
    } else if (status === 'active' || status === 'damaged') {
      status = 'damaged';
    }
    effect = 'sabotaged';
  } else if (actionType === 'supply_run') {
    // Only the owning defender can repair/advance via contest supply runs.
    if (actorCrewId !== toNumeric(project.ownerCrewId)) return null;
    if (status === 'building') {
      progress = clamp(progress + config.supplyBuildProgress, 0, 100);
      if (progress >= 100) {
        progress = 100;
        status = 'active';
        hp = maxHp;
      }
      effect = 'advanced';
    } else if (status === 'damaged') {
      hp = clamp(hp + config.supplyRepairHp, 0, maxHp);
      status = hp >= maxHp ? 'active' : 'damaged';
      effect = 'repaired';
    } else {
      return null;
    }
  }

  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_projects
     SET progress = ?, hp = ?, status = ?, updatedAt = NOW()
     WHERE id = ?`,
    progress,
    hp,
    status,
    project.id,
  );

  return {
    projectId: toNumeric(project.id),
    projectType: project.projectType,
    previousStatus,
    status,
    progress,
    hp,
    maxHp,
    effect,
  };
}
