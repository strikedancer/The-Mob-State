import { readFileSync } from 'fs';
import { join } from 'path';
import prisma from '../lib/prisma';

export type CrewBuildingType =
  | 'hq'
  | 'car_storage'
  | 'boat_storage'
  | 'weapon_storage'
  | 'ammo_storage'
  | 'drug_storage'
  | 'cash_storage';

export type CrewBuildingStyle = 'camping' | 'rural' | 'city' | 'villa' | 'vip';
const styleOrder: CrewBuildingStyle[] = ['camping', 'rural', 'city', 'villa', 'vip'];

const MAX_STANDARD_BUILDING_LEVEL = 10;
const MAX_VIP_BUILDING_LEVEL = 15;

function getNextStyle(style: CrewBuildingStyle | null): CrewBuildingStyle | null {
  if (!style) return styleOrder[0];
  const index = styleOrder.indexOf(style);
  if (index < 0 || index >= styleOrder.length - 1) {
    return null;
  }
  return styleOrder[index + 1];
}

interface BuildingLevelDefinition {
  level: number;
  upgradeCost: number;
  capacity?: number;
  memberCap?: number;
  parkingSlots?: number;
}

interface BuildingDefinition {
  label: string;
  levels: BuildingLevelDefinition[];
}

interface CrewBuildingsConfig {
  styles: CrewBuildingStyle[];
  buildings: Record<CrewBuildingType, BuildingDefinition>;
}

const configPath = join(__dirname, '../../content/crewBuildings.json');
const buildingConfig = JSON.parse(readFileSync(configPath, 'utf-8')) as CrewBuildingsConfig;

function getBuildingDefinition(type: CrewBuildingType): BuildingDefinition {
  const def = buildingConfig.buildings[type];
  if (!def) {
    throw new Error('BUILDING_TYPE_NOT_FOUND');
  }
  return def;
}

function getLevelDefinition(type: CrewBuildingType, level: number): BuildingLevelDefinition {
  const def = getBuildingDefinition(type);
  const levelDef = def.levels.find((l) => l.level === level);
  if (levelDef) {
    return levelDef;
  }

  if (level < 0) {
    throw new Error('BUILDING_LEVEL_NOT_FOUND');
  }

  if (type === 'hq') {
    if (level === 4) {
      return {
        level: 4,
        upgradeCost: 3000000,
        memberCap: 32,
      };
    }
    throw new Error('BUILDING_LEVEL_NOT_FOUND');
  }

  const baseLevels = [...def.levels].sort((a, b) => a.level - b.level);
  if (baseLevels.length == 0) {
    throw new Error('BUILDING_LEVEL_NOT_FOUND');
  }

  let current = baseLevels[baseLevels.length - 1];
  let currentLevel = current.level;

  while (currentLevel < level) {
    const nextLevel = currentLevel + 1;
    const nextCost = Math.round(current.upgradeCost * 1.55);
    const nextDef: BuildingLevelDefinition = {
      level: nextLevel,
      upgradeCost: nextCost,
    };

    if (typeof current.capacity === 'number') {
      let multiplier = 1.6;
      if (type === 'ammo_storage') multiplier = 1.7;
      if (type === 'cash_storage') multiplier = 1.9;
      nextDef.capacity = Math.max(current.capacity + 1, Math.round(current.capacity * multiplier));
    }

    if (typeof current.memberCap === 'number') {
      nextDef.memberCap = Math.max(current.memberCap + 1, Math.round(current.memberCap * 1.25));
    }

    if (typeof current.parkingSlots === 'number') {
      nextDef.parkingSlots = Math.max(current.parkingSlots + 1, Math.round(current.parkingSlots * 1.3));
    }

    current = nextDef;
    currentLevel = nextLevel;
  }

  return current;
}

function validateStyle(style: string): CrewBuildingStyle {
  if (!buildingConfig.styles.includes(style as CrewBuildingStyle)) {
    throw new Error('INVALID_BUILDING_STYLE');
  }
  return style as CrewBuildingStyle;
}

function hasActiveVip(isVip: boolean, vipExpiresAt: Date | null): boolean {
  if (!isVip) return false;
  if (!vipExpiresAt) return true;
  return vipExpiresAt.getTime() > Date.now();
}

async function isCrewVip(crewId: number): Promise<boolean> {
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { isVip: true, vipExpiresAt: true },
  });

  if (!crew) return false;
  return hasActiveVip(crew.isVip, crew.vipExpiresAt);
}

function getHqGlobalLevel(style: CrewBuildingStyle | null, level: number | null): number {
  const normalizedStyle = style ?? 'camping';
  const normalizedLevel = Math.max(0, level ?? 0);
  if (normalizedStyle === 'vip') {
    return 16 + normalizedLevel;
  }
  const styleIndex = Math.max(0, styleOrder.indexOf(normalizedStyle));
  return styleIndex * 4 + normalizedLevel;
}

function getHqStyleMaxLevel(style: CrewBuildingStyle | null, crewVip: boolean): number {
  const normalizedStyle = style ?? 'camping';
  if (normalizedStyle === 'vip') {
    return 3;
  }
  return 3;
}

function getAllowedBuildingLevel(
  hqStyle: CrewBuildingStyle | null,
  hqLevel: number | null,
  crewVip: boolean
): number {
  const normalizedStyle = hqStyle ?? 'camping';
  const normalizedHqLevel = Math.max(0, hqLevel ?? 0);

  // Progression requested by game design (exact HQ level mapping):
  // camping: L0->1, L1->1, L2->2, L3->2
  // rural:   L0->3, L1->3, L2->4, L3->4
  // city:    L0->5, L1->5, L2->6, L3->7
  // villa:   L0->8, L1->8, L2->9, L3->10
  // vip:     L0->11, L1->12, L2->13, L3->14
  let maxAllowed: number;
  switch (normalizedStyle) {
    case 'camping':
      if (normalizedHqLevel >= 2) maxAllowed = 2;
      else maxAllowed = 1;
      break;
    case 'rural':
      if (normalizedHqLevel >= 2) maxAllowed = 4;
      else maxAllowed = 3;
      break;
    case 'city':
      if (normalizedHqLevel >= 3) maxAllowed = 7;
      else if (normalizedHqLevel >= 2) maxAllowed = 6;
      else maxAllowed = 5;
      break;
    case 'villa':
      if (normalizedHqLevel >= 3) maxAllowed = 10;
      else if (normalizedHqLevel >= 2) maxAllowed = 9;
      else maxAllowed = 8;
      break;
    case 'vip':
      if (normalizedHqLevel <= 0) maxAllowed = 11;
      else if (normalizedHqLevel == 1) maxAllowed = 12;
      else if (normalizedHqLevel == 2) maxAllowed = 13;
      else maxAllowed = 14;
      break;
    default:
      maxAllowed = 2;
      break;
  }

  // Non-VIP crews are capped at level 10 for side buildings
  if (!crewVip && maxAllowed >= 10) {
    maxAllowed = Math.min(maxAllowed, MAX_STANDARD_BUILDING_LEVEL);
  }

  return Math.max(0, Math.min(crewVip ? MAX_VIP_BUILDING_LEVEL : MAX_STANDARD_BUILDING_LEVEL, maxAllowed));
}

function getRequiredSideBuildingLevelForStyle(style: CrewBuildingStyle): number {
  switch (style) {
    case 'camping':
      return 2;
    case 'rural':
      return 4;
    case 'city':
      return 7;
    case 'villa':
      return 10;
    case 'vip':
      return 15;
    default:
      return 2;
  }
}

function getRequiredSideBuildingLevelForCurrentHqLevel(style: CrewBuildingStyle, hqLevel: number, crewVip: boolean): number {
  return getAllowedBuildingLevel(style, hqLevel, crewVip);
}

async function areAllSideBuildingsAtLeastLevel(crewId: number, requiredLevel: number): Promise<boolean> {
  const [car, boat, weapon, ammo, drug, cash] = await Promise.all([
    prisma.crewCarStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
    prisma.crewBoatStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
    prisma.crewWeaponStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
    prisma.crewAmmoStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
    prisma.crewDrugStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
    prisma.crewCashStorageBuilding.findUnique({ where: { crewId }, select: { level: true } }),
  ]);

  const all = [car, boat, weapon, ammo, drug, cash];
  return all.every((building) => (building?.level ?? -1) >= requiredLevel);
}

async function getAllowedBuildingLevelForCrew(
  crewId: number,
  hqStyle: CrewBuildingStyle | null,
  hqLevel: number | null,
  crewVip: boolean
): Promise<number> {
  const baseAllowedLevel = getAllowedBuildingLevel(hqStyle, hqLevel, crewVip);

  if ((hqStyle ?? 'camping') !== 'vip' || !crewVip) {
    return baseAllowedLevel;
  }

  const normalizedHqLevel = Math.max(0, hqLevel ?? 0);
  if (normalizedHqLevel < 3) {
    return baseAllowedLevel;
  }

  const allSideBuildingsAtLevel14 = await areAllSideBuildingsAtLeastLevel(crewId, 14);
  return allSideBuildingsAtLevel14 ? 15 : baseAllowedLevel;
}

function getBuildingModel(type: CrewBuildingType) {
  switch (type) {
    case 'hq':
      return prisma.crewHqBuilding;
    case 'car_storage':
      return prisma.crewCarStorageBuilding;
    case 'boat_storage':
      return prisma.crewBoatStorageBuilding;
    case 'weapon_storage':
      return prisma.crewWeaponStorageBuilding;
    case 'ammo_storage':
      return prisma.crewAmmoStorageBuilding;
    case 'drug_storage':
      return prisma.crewDrugStorageBuilding;
    case 'cash_storage':
      return prisma.crewCashStorageBuilding;
    default:
      throw new Error('BUILDING_TYPE_NOT_FOUND');
  }
}

export async function getCrewBuildingRecord(crewId: number, type: CrewBuildingType) {
  const model = getBuildingModel(type);
  return model.findUnique({ where: { crewId } });
}

export async function getCrewBuildingStatus(crewId: number) {
  const crewVip = await isCrewVip(crewId);
  const hqRecord = await getCrewBuildingRecord(crewId, 'hq');
  const hqStyle = (hqRecord?.style as CrewBuildingStyle | null) ?? null;
  const hqLevel = hqRecord?.level ?? null;
  const allowedByHq = await getAllowedBuildingLevelForCrew(crewId, hqStyle, hqLevel, crewVip);

  const entries = await Promise.all(
    (Object.keys(buildingConfig.buildings) as CrewBuildingType[]).map(async (type) => {
      const record = await getCrewBuildingRecord(crewId, type);
      const level = record?.level ?? null;
      const style = record?.style ?? null;
      const levelDef = level === null ? null : getLevelDefinition(type, level);
      const maxLevel =
        type === 'hq'
          ? getHqStyleMaxLevel(style as CrewBuildingStyle | null, crewVip)
          : (crewVip ? MAX_VIP_BUILDING_LEVEL : MAX_STANDARD_BUILDING_LEVEL);
      const nextLevelDef =
        level === null
          ? getLevelDefinition(type, 0)
          : level < maxLevel && (type === 'hq' || level < allowedByHq)
              ? getLevelDefinition(type, level + 1)
              : null;

      return {
        type,
        label: getBuildingDefinition(type).label,
        level,
        maxLevel,
        style,
        capacity: levelDef?.capacity ?? null,
        memberCap: levelDef?.memberCap ?? null,
        parkingSlots: levelDef?.parkingSlots ?? null,
        nextUpgradeCost: level !== null && level < maxLevel ? nextLevelDef?.upgradeCost ?? null : null,
        allowedLevelByHq: type === 'hq' ? maxLevel : allowedByHq,
        crewVip,
        imageKey: level !== null && style ? `${type}_${style}_lvl${level}` : null,
      };
    })
  );

  return entries;
}

export async function purchaseCrewBuilding(
  crewId: number,
  playerId: number,
  type: CrewBuildingType,
  styleInput: string
) {
  const requestedStyle = validateStyle(styleInput);
  const style: CrewBuildingStyle = type === 'hq' ? requestedStyle : 'camping';
  const model = getBuildingModel(type);
  const existing = await model.findUnique({ where: { crewId } });
  const crewVip = await isCrewVip(crewId);
  const maxLevel = type === 'hq' ? getHqStyleMaxLevel(existing?.style as CrewBuildingStyle | null, crewVip) : (crewVip ? MAX_VIP_BUILDING_LEVEL : MAX_STANDARD_BUILDING_LEVEL);

  if (existing) {
    if (type !== 'hq') {
      throw new Error('BUILDING_ALREADY_OWNED');
    }

    const nextStyle = getNextStyle(existing.style as CrewBuildingStyle | null);
    if (!nextStyle) {
      throw new Error('HQ_STYLE_MAX');
    }
    if (nextStyle === 'vip' && !crewVip) {
      throw new Error('HQ_VIP_REQUIRED');
    }
    if (existing.level < maxLevel || style !== nextStyle) {
      throw new Error('HQ_STYLE_LOCKED');
    }

    const requiredLevel = getRequiredSideBuildingLevelForStyle(existing.style as CrewBuildingStyle);
    const allSideBuildingsReady = await areAllSideBuildingsAtLeastLevel(crewId, requiredLevel);
    if (!allSideBuildingsReady) {
      throw new Error('HQ_SIDE_BUILDINGS_INCOMPLETE');
    }
  } else if (type === 'hq' && style !== styleOrder[0]) {
    throw new Error('HQ_STYLE_LOCKED');
  }

  if (type === 'hq' && style === 'vip' && !crewVip) {
    throw new Error('HQ_VIP_REQUIRED');
  }

  const purchaseLevel = type === 'hq' ? 0 : 1;
  const levelDef = getLevelDefinition(type, 0);
  const cost = levelDef.upgradeCost;

  return prisma.$transaction(async (tx) => {
    const crew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });

    if (!crew || crew.bankBalance < cost) {
      throw new Error('INSUFFICIENT_CREW_FUNDS');
    }

    if (cost > 0) {
      await tx.crew.update({
        where: { id: crewId },
        data: { bankBalance: { decrement: cost } },
      });
    }

    if (existing && type === 'hq') {
      await model.update({
        where: { crewId },
        data: {
          style,
          level: 0,
        },
      });
    } else {
      await model.create({
        data: {
          crewId,
          style,
          level: purchaseLevel,
        },
      });
    }

    return {
      level: purchaseLevel,
      style,
      cost,
    };
  });
}

export async function upgradeCrewBuilding(
  crewId: number,
  playerId: number,
  type: CrewBuildingType
) {
  const model = getBuildingModel(type);
  const current = await model.findUnique({ where: { crewId } });
  if (!current) {
    throw new Error('BUILDING_NOT_OWNED');
  }

  const crewVip = await isCrewVip(crewId);
  const hq = await prisma.crewHqBuilding.findUnique({ where: { crewId } });
  const hqStyle = (hq?.style as CrewBuildingStyle | null) ?? 'camping';
  const hqLevel = hq?.level ?? 0;
  const maxLevel =
    type === 'hq'
      ? getHqStyleMaxLevel(current.style as CrewBuildingStyle | null, crewVip)
      : (crewVip ? MAX_VIP_BUILDING_LEVEL : MAX_STANDARD_BUILDING_LEVEL);

  if (current.level >= maxLevel) {
    throw new Error('BUILDING_MAX_LEVEL');
  }

  const nextLevel = current.level + 1;

  if (type === 'hq') {
    const requiredLevel = getRequiredSideBuildingLevelForCurrentHqLevel(
      current.style as CrewBuildingStyle,
      current.level,
      crewVip
    );
    const allSideBuildingsReady = await areAllSideBuildingsAtLeastLevel(crewId, requiredLevel);
    if (!allSideBuildingsReady) {
      throw new Error('HQ_SIDE_BUILDINGS_INCOMPLETE');
    }
  } else {
    const allowedLevel = await getAllowedBuildingLevelForCrew(crewId, hqStyle, hqLevel, crewVip);
    if (nextLevel > allowedLevel) {
      if (nextLevel > MAX_STANDARD_BUILDING_LEVEL && !crewVip) {
        throw new Error('BUILDING_VIP_REQUIRED');
      }
      if (nextLevel > MAX_STANDARD_BUILDING_LEVEL && hqStyle !== 'vip') {
        throw new Error('HQ_VIP_REQUIRED');
      }
      throw new Error('HQ_LEVEL_TOO_LOW');
    }
  }

  const nextLevelDef = getLevelDefinition(type, nextLevel);
  const cost = nextLevelDef.upgradeCost;

  return prisma.$transaction(async (tx) => {
    const crew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });

    if (!crew || crew.bankBalance < cost) {
      throw new Error('INSUFFICIENT_CREW_FUNDS');
    }

    await tx.crew.update({
      where: { id: crewId },
      data: { bankBalance: { decrement: cost } },
    });

    const updated = await model.update({
      where: { crewId },
      data: { level: nextLevel },
    });

    return {
      level: updated.level,
      style: updated.style,
      cost,
    };
  });
}

export function getCrewMemberCap(hqLevel: number | null): number {
  if (hqLevel === null) {
    return getLevelDefinition('hq', 0).memberCap ?? 0;
  }
  return getLevelDefinition('hq', hqLevel).memberCap ?? 0;
}

export async function getCrewMemberCapForCrew(crewId: number): Promise<number> {
  const hq = await prisma.crewHqBuilding.findUnique({ where: { crewId } });
  const crewVip = await isCrewVip(crewId);
  const style = (hq?.style as CrewBuildingStyle | null) ?? 'camping';
  const level = Math.min(hq?.level ?? 0, getHqStyleMaxLevel(style, crewVip));
  return getLevelDefinition('hq', level).memberCap ?? 0;
}

export async function getCrewStorageCapacity(crewId: number, type: CrewBuildingType): Promise<number> {
  const record = await getCrewBuildingRecord(crewId, type);
  if (!record) {
    return 0;
  }
  const levelDef = getLevelDefinition(type, record.level);
  return levelDef.capacity ?? 0;
}

export async function ensureDefaultHqBuilding(crewId: number) {
  const existing = await prisma.crewHqBuilding.findUnique({ where: { crewId } });
  if (existing) return;
  await prisma.crewHqBuilding.create({
    data: {
      crewId,
      style: 'camping',
      level: 0,
    },
  });
}
