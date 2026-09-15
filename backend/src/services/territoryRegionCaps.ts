export type TerritoryRegionCapInput = {
  hqGlobalLevel: number;
  memberCount: number;
  baseMaxRegions: number;
  hqLevelsPerSlot: number;
  hqRegionCapPerLevel: number;
  hqRegionCapBonusCap: number;
  memberRegionBase: number;
  memberRegionPer: number;
  memberRegionBonusCap: number;
  regionHardCap: number;
};

export type TerritoryRegionCapResult = {
  hqSlots: number;
  memberSlots: number;
  hqRegionBonus: number;
  memberRegionBonus: number;
  effectiveMaxRegions: number;
  nextHqLevel: number | null;
  nextMemberCount: number | null;
};

function safeInt(value: number, fallback = 0): number {
  if (!Number.isFinite(value)) return fallback;
  return Math.max(0, Math.floor(value));
}

function hqRegionBonus(input: TerritoryRegionCapInput): number {
  const bonusCap = safeInt(input.hqRegionCapBonusCap);
  const level = safeInt(input.hqGlobalLevel);
  const levelsPerSlot = safeInt(input.hqLevelsPerSlot);
  if (levelsPerSlot >= 1) {
    return Math.min(bonusCap, Math.floor(level / levelsPerSlot));
  }
  const perLevel = Number(input.hqRegionCapPerLevel);
  if (!Number.isFinite(perLevel) || perLevel <= 0 || level <= 0) return 0;
  return Math.min(bonusCap, Math.max(0, Math.floor(level * perLevel)));
}

function memberRegionBonus(input: TerritoryRegionCapInput): number {
  const bonusCap = safeInt(input.memberRegionBonusCap);
  const per = Math.max(1, safeInt(input.memberRegionPer, 5));
  const base = safeInt(input.memberRegionBase, 5);
  const extra = Math.max(0, safeInt(input.memberCount) - base);
  return Math.min(bonusCap, Math.floor(extra / per));
}

function nextHqThreshold(input: TerritoryRegionCapInput, currentBonus: number): number | null {
  const bonusCap = safeInt(input.hqRegionCapBonusCap);
  if (currentBonus >= bonusCap) return null;
  const levelsPerSlot = safeInt(input.hqLevelsPerSlot);
  if (levelsPerSlot >= 1) {
    return (currentBonus + 1) * levelsPerSlot;
  }
  const perLevel = Number(input.hqRegionCapPerLevel);
  if (!Number.isFinite(perLevel) || perLevel <= 0) return null;
  return Math.ceil((currentBonus + 1) / perLevel);
}

function nextMemberThreshold(input: TerritoryRegionCapInput, currentBonus: number): number | null {
  const bonusCap = safeInt(input.memberRegionBonusCap);
  if (currentBonus >= bonusCap) return null;
  const per = Math.max(1, safeInt(input.memberRegionPer, 5));
  const base = safeInt(input.memberRegionBase, 5);
  return base + (currentBonus + 1) * per;
}

export function computeTerritoryRegionCaps(input: TerritoryRegionCapInput): TerritoryRegionCapResult {
  const baseMaxRegions = Math.max(1, safeInt(input.baseMaxRegions, 5));
  const hardCap = Math.max(baseMaxRegions, safeInt(input.regionHardCap, 10));
  const hqBonus = hqRegionBonus(input);
  const memberBonus = memberRegionBonus(input);
  const hqSlots = baseMaxRegions + hqBonus;
  const memberSlots = Math.max(1, safeInt(input.memberRegionBase, 5)) + memberBonus;
  const effectiveMaxRegions = Math.min(hqSlots, memberSlots, hardCap);

  return {
    hqSlots,
    memberSlots,
    hqRegionBonus: hqBonus,
    memberRegionBonus: memberBonus,
    effectiveMaxRegions,
    nextHqLevel: nextHqThreshold(input, hqBonus),
    nextMemberCount: nextMemberThreshold(input, memberBonus),
  };
}

export function canStartNewRegionContest(ownedRegions: number, effectiveMaxRegions: number): boolean {
  return safeInt(ownedRegions) < Math.max(0, safeInt(effectiveMaxRegions));
}

export function garrisonMaxActiveForRegionCap(
  baseMaxActive: number,
  extraAtRegionCap: number,
  effectiveMaxRegions: number,
): number {
  const base = Math.max(1, safeInt(baseMaxActive, 2));
  const extraAt = safeInt(extraAtRegionCap);
  if (extraAt > 0 && safeInt(effectiveMaxRegions) >= extraAt) {
    return base + 1;
  }
  return base;
}
