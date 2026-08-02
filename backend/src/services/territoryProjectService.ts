import prisma from '../lib/prisma';

export const PROJECT_TYPE_SAFEHOUSE = 'safehouse_network';

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
  contributeProgress: number;
  contributeCooldownSeconds: number;
  sabotageHpDamage: number;
  supplyRepairHp: number;
  supplyBuildProgress: number;
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

function mapProjectRow(row: ProjectRow, incomeBonusPercent: number): TerritoryRegionProject {
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
    incomeBonusPercent: row.status === 'active' || row.status === 'damaged'
      ? Math.max(0, incomeBonusPercent)
      : 0,
  };
}

export async function getProjectsByRegionKeys(
  regionKeys: string[],
  incomeBonusPercent: number,
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
    acc[row.regionKey] = mapProjectRow(row, incomeBonusPercent);
    return acc;
  }, {});
}

export async function getActiveIncomeBonusByRegionKeys(
  regionKeys: string[],
  incomeBonusPercent: number,
): Promise<Record<string, number>> {
  if (regionKeys.length === 0 || incomeBonusPercent <= 0) return {};
  const placeholders = regionKeys.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; status: string }>>(
    `SELECT regionKey, status FROM territory_region_projects
     WHERE regionKey IN (${placeholders}) AND status IN ('active', 'damaged')
       AND projectType = ?`,
    ...regionKeys,
    PROJECT_TYPE_SAFEHOUSE,
  );
  return rows.reduce<Record<string, number>>((acc, row) => {
    // Damaged projects still pay a reduced bonus (half).
    acc[row.regionKey] = row.status === 'damaged'
      ? Math.floor(incomeBonusPercent / 2)
      : incomeBonusPercent;
    return acc;
  }, {});
}

export async function startSafehouseProject(params: {
  crewId: number;
  regionKey: string;
  hqGlobalLevel: number;
  config: TerritoryProjectConfig;
  currentCountry: string | null | undefined;
  assertInCountry: (currentCountry: string | null | undefined, regionCountryCode: string) => void;
}): Promise<TerritoryRegionProject> {
  const { crewId, regionKey, hqGlobalLevel, config, currentCountry, assertInCountry } = params;

  if (hqGlobalLevel < config.safehouseMinHqLevel) {
    throw new Error('PROJECT_HQ_LEVEL_REQUIRED');
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
      PROJECT_TYPE_SAFEHOUSE,
      regionKey,
    );
  } else {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_region_projects
         (regionKey, ownerCrewId, projectType, status, progress, hp, maxHp)
       VALUES (?, ?, ?, 'building', 0, 100, 100)`,
      regionKey,
      crewId,
      PROJECT_TYPE_SAFEHOUSE,
    );
  }

  const rows = await prisma.$queryRawUnsafe<ProjectRow[]>(
    'SELECT * FROM territory_region_projects WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  if (!rows[0]) throw new Error('PROJECT_NOT_FOUND');
  return mapProjectRow(rows[0], config.safehouseIncomeBonusPercent);
}

export async function contributeSafehouseProject(params: {
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
  return mapProjectRow(updated[0], config.safehouseIncomeBonusPercent);
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
