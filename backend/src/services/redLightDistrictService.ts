import prisma from '../lib/prisma';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';
import { increaseFBIHeat } from './fbiService';
import { isVipStatusActive } from './vipBenefitsService';
import {
  RLD_COUNTRY_SLUGS,
  RLD_EXPANSION_COSTS,
  RLD_EXPANSION_MAX,
  RLD_OCCUPANCY_FULL,
  RLD_OCCUPANCY_FULL_HEAT,
  RLD_PENTHOUSE_TIER,
  RLD_SECURITY_COSTS,
  RLD_SECURITY_MAX,
  RLD_MAX_ROOMS,
  RLD_START_ROOMS,
  RLD_TIER_MAX,
  RLD_TIER_UPGRADE_COSTS,
  expansionTargetRooms,
  getTierConfig,
  occupancyRaidBonus,
  occupancyRate,
  occupancyRentMultiplier,
  rldOccupancyCapacity,
} from './rldConfig';

const DEFAULT_RED_LIGHT_DISTRICTS = [
  { countryCode: 'netherlands', purchasePrice: 750000, roomCount: RLD_START_ROOMS },
  { countryCode: 'belgium', purchasePrice: 650000, roomCount: RLD_START_ROOMS },
  { countryCode: 'germany', purchasePrice: 800000, roomCount: RLD_START_ROOMS },
  { countryCode: 'france', purchasePrice: 850000, roomCount: RLD_START_ROOMS },
  { countryCode: 'spain', purchasePrice: 700000, roomCount: RLD_START_ROOMS },
  { countryCode: 'italy', purchasePrice: 750000, roomCount: RLD_START_ROOMS },
  { countryCode: 'uk', purchasePrice: 900000, roomCount: RLD_START_ROOMS },
  { countryCode: 'switzerland', purchasePrice: 1150000, roomCount: RLD_START_ROOMS },
  { countryCode: 'usa', purchasePrice: 1000000, roomCount: RLD_START_ROOMS },
  { countryCode: 'mexico', purchasePrice: 600000, roomCount: RLD_START_ROOMS },
  { countryCode: 'colombia', purchasePrice: 650000, roomCount: RLD_START_ROOMS },
  { countryCode: 'brazil', purchasePrice: 700000, roomCount: RLD_START_ROOMS },
  { countryCode: 'argentina', purchasePrice: 650000, roomCount: RLD_START_ROOMS },
  { countryCode: 'japan', purchasePrice: 950000, roomCount: RLD_START_ROOMS },
  { countryCode: 'china', purchasePrice: 900000, roomCount: RLD_START_ROOMS },
  { countryCode: 'russia', purchasePrice: 750000, roomCount: RLD_START_ROOMS },
  { countryCode: 'turkey', purchasePrice: 600000, roomCount: RLD_START_ROOMS },
  { countryCode: 'united_arab_emirates', purchasePrice: 1200000, roomCount: RLD_START_ROOMS },
  { countryCode: 'south_africa', purchasePrice: 600000, roomCount: RLD_START_ROOMS },
  { countryCode: 'australia', purchasePrice: 850000, roomCount: RLD_START_ROOMS },
];

let districtSeedPromise: Promise<void> | null = null;

const DISTRICT_INCLUDE = {
  owner: {
    select: { id: true, username: true },
  },
  contestChallenger: {
    select: { id: true, username: true },
  },
  rooms: {
    include: {
      prostitute: {
        include: {
          player: {
            select: { id: true, username: true },
          },
        },
      },
    },
    orderBy: { roomNumber: 'asc' as const },
  },
};

async function ensureDistrictSeedData() {
  if (districtSeedPromise) {
    await districtSeedPromise;
    return;
  }

  districtSeedPromise = (async () => {
    await prisma.redLightDistrict.createMany({
      data: DEFAULT_RED_LIGHT_DISTRICTS,
      skipDuplicates: true,
    });
  })();

  try {
    await districtSeedPromise;
  } finally {
    districtSeedPromise = null;
  }
}

async function createMissingRooms(
  districtId: number,
  targetCount: number,
  tier: number
): Promise<number> {
  const cappedTarget = Math.min(RLD_MAX_ROOMS, Math.max(0, targetCount));
  const existing = await prisma.redLightRoom.findMany({
    where: { redLightDistrictId: districtId },
    select: { roomNumber: true },
    orderBy: { roomNumber: 'desc' },
  });
  const have = existing.length;
  if (have >= cappedTarget) return have;
  let nextNumber = (existing[0]?.roomNumber ?? 0) + 1;
  const toCreate = cappedTarget - have;
  await prisma.redLightRoom.createMany({
    data: Array.from({ length: toCreate }, (_, i) => ({
      redLightDistrictId: districtId,
      roomNumber: nextNumber + i,
      tier,
    })),
  });
  await prisma.redLightDistrict.update({
    where: { id: districtId },
    data: { roomCount: cappedTarget },
  });
  return cappedTarget;
}

const ASSIGNABLE_ROOM_INCLUDE = {
  prostitute: true,
  redLightDistrict: {
    select: {
      id: true,
      ownerId: true,
      countryCode: true,
    },
  },
} as const;

/** Grow one empty room when the country district is full of workers, up to RLD_MAX_ROOMS. */
export async function ensureAssignableRldRoom(districtId: number, tier: number) {
  const empty = await prisma.redLightRoom.findFirst({
    where: {
      redLightDistrictId: districtId,
      occupied: false,
      prostitute: null,
    },
    orderBy: { roomNumber: 'asc' },
    include: ASSIGNABLE_ROOM_INCLUDE,
  });
  if (empty) return empty;

  const have = await prisma.redLightRoom.count({ where: { redLightDistrictId: districtId } });
  if (have >= RLD_MAX_ROOMS) return null;

  await createMissingRooms(districtId, have + 1, tier);
  return prisma.redLightRoom.findFirst({
    where: {
      redLightDistrictId: districtId,
      occupied: false,
      prostitute: null,
    },
    orderBy: { roomNumber: 'desc' },
    include: ASSIGNABLE_ROOM_INCLUDE,
  });
}

export function serializeContest(district: {
  contestStatus?: string | null;
  contestChallengerId?: number | null;
  contestAttackerScore?: number | null;
  contestDefenderScore?: number | null;
  contestHoldCount?: number | null;
  contestStake?: number | null;
  contestPrepAt?: Date | null;
  contestActiveAt?: Date | null;
  contestLockdownAt?: Date | null;
  contestResolveAt?: Date | null;
  contestCooldownUntil?: Date | null;
  contestChallenger?: { id: number; username: string } | null;
}) {
  const status = district.contestStatus || 'idle';
  return {
    status,
    challengerId: district.contestChallengerId ?? null,
    challengerName: district.contestChallenger?.username ?? null,
    attackerScore: district.contestAttackerScore ?? 0,
    defenderScore: district.contestDefenderScore ?? 0,
    holdCount: district.contestHoldCount ?? 0,
    stake: district.contestStake ?? 0,
    prepAt: district.contestPrepAt?.toISOString() ?? null,
    activeAt: district.contestActiveAt?.toISOString() ?? null,
    lockdownAt: district.contestLockdownAt?.toISOString() ?? null,
    resolveAt: district.contestResolveAt?.toISOString() ?? null,
    cooldownUntil: district.contestCooldownUntil?.toISOString() ?? null,
    isLive: status === 'preparing' || status === 'active' || status === 'lockdown',
  };
}

export const redLightDistrictService = {
  async getByCountry(countryCode: string) {
    await ensureDistrictSeedData();

    return prisma.redLightDistrict.findUnique({
      where: { countryCode },
      include: DISTRICT_INCLUDE,
    });
  },

  async getDistrictById(districtId: number) {
    return prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: DISTRICT_INCLUDE,
    });
  },

  async getPlayerDistricts(playerId: number) {
    return prisma.redLightDistrict.findMany({
      where: { ownerId: playerId },
      include: DISTRICT_INCLUDE,
    });
  },

  async purchaseDistrict(
    playerId: number,
    countryCode: string
  ): Promise<{
    success: boolean;
    message: string;
    district?: any;
    newlyUnlockedAchievements?: any[];
  }> {
    await ensureDistrictSeedData();

    const district = await prisma.redLightDistrict.findUnique({
      where: { countryCode },
      include: { rooms: { select: { id: true } } },
    });

    if (!district) {
      return { success: false, message: 'Red Light District niet gevonden in dit land' };
    }

    if (district.ownerId) {
      return { success: false, message: 'Dit Red Light District is al eigendom van iemand anders' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < district.purchasePrice) {
      return {
        success: false,
        message: `Je hebt €${district.purchasePrice.toLocaleString('nl-NL')} nodig om dit Red Light District te kopen`,
      };
    }

    const existingRooms = district.rooms.length;
    const startRooms = existingRooms > 0 ? existingRooms : RLD_START_ROOMS;

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: district.purchasePrice } },
      });
      await tx.redLightDistrict.update({
        where: { id: district.id },
        data: {
          ownerId: playerId,
          purchasedAt: new Date(),
          roomCount: startRooms,
          expansionLevel: district.expansionLevel || 0,
          contestStatus: 'idle',
          contestChallengerId: null,
          contestAttackerScore: 0,
          contestDefenderScore: 0,
          contestHoldCount: 0,
          contestStake: 0,
        },
      });
    });

    if (existingRooms === 0) {
      await createMissingRooms(district.id, RLD_START_ROOMS, district.tier || 1);
    }

    const updatedDistrict = await prisma.redLightDistrict.findUnique({
      where: { id: district.id },
    });

    let newlyUnlockedAchievements: any[] = [];
    try {
      const achievementResults = await checkAndUnlockAchievements(playerId);
      newlyUnlockedAchievements = achievementResults.map((r) =>
        serializeAchievementForClient(r.achievement)
      );
    } catch (err) {
      console.error('[Achievement Check] Error after district purchase:', err);
    }

    return {
      success: true,
      message: `Je bent nu eigenaar van het Red Light District in ${countryCode}!`,
      district: updatedDistrict,
      newlyUnlockedAchievements,
    };
  },

  async getAvailableRooms(districtId: number) {
    return prisma.redLightRoom.findMany({
      where: {
        redLightDistrictId: districtId,
        occupied: false,
      },
      orderBy: { roomNumber: 'asc' },
    });
  },

  async calculateRentalIncome(districtId: number): Promise<number> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        rooms: {
          where: { occupied: true },
          include: { prostitute: true },
        },
      },
    });

    if (!district || !district.ownerId) {
      return 0;
    }

    const now = new Date();
    const occupied = district.rooms.length;
    const rate = occupancyRate(occupied, rldOccupancyCapacity(district.roomCount));
    const rentMult = occupancyRentMultiplier(rate);
    const tierRent = getTierConfig(district.tier).rent;
    let totalIncome = 0;

    for (const room of district.rooms) {
      if (!room.prostitute) continue;
      if (room.sabotagedUntil && room.sabotagedUntil > now) continue;
      const hoursElapsed = (now.getTime() - room.lastEarningsAt.getTime()) / (1000 * 60 * 60);
      const guardMult =
        room.guardUntil && room.guardUntil > now ? 0.5 : 1;
      totalIncome += Math.floor(tierRent * hoursElapsed * rentMult * guardMult);
    }

    return totalIncome;
  },

  async getDistrictStats(districtId: number) {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        rooms: {
          include: {
            prostitute: {
              include: {
                player: {
                  select: { id: true, username: true },
                },
              },
            },
          },
        },
        contestChallenger: { select: { id: true, username: true } },
      },
    });

    if (!district) {
      return null;
    }

    const occupiedRooms = district.rooms.filter((r) => r.occupied).length;
    const totalRooms = rldOccupancyCapacity(district.rooms.length || district.roomCount);
    const availableRooms = Math.max(0, totalRooms - occupiedRooms);
    const rate = occupancyRate(occupiedRooms, totalRooms);
    const tierRent = getTierConfig(district.tier).rent;
    const hourlyIncome = Math.floor(
      occupiedRooms * tierRent * occupancyRentMultiplier(rate)
    );

    const tenants = new Set(
      district.rooms
        .filter((r) => r.prostitute)
        .map((r) => r.prostitute!.player.username)
    );

    return {
      districtId: district.id,
      countryCode: district.countryCode,
      totalRooms,
      occupiedRooms,
      availableRooms,
      occupancyRate: Math.round(rate),
      occupancyBusy: rate >= 70,
      occupancyFull: rate >= 100,
      occupancyRentMultiplier: occupancyRentMultiplier(rate),
      occupancyRaidBonus: occupancyRaidBonus(rate),
      hourlyIncome,
      tenantCount: tenants.size,
      tenants: Array.from(tenants),
      contest: serializeContest(district),
      expansionLevel: district.expansionLevel ?? 0,
    };
  },

  async getAvailableDistricts() {
    await ensureDistrictSeedData();

    return prisma.redLightDistrict.findMany({
      where: { ownerId: null },
      orderBy: { purchasePrice: 'asc' },
    });
  },

  async upgradeTier(
    districtId: number,
    playerId: number
  ): Promise<{ success: boolean; message: string; newTier?: number }> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
    });

    if (!district) {
      return { success: false, message: 'District niet gevonden' };
    }

    if (district.ownerId !== playerId) {
      return { success: false, message: 'Je bent niet de eigenaar van dit district' };
    }

    if (district.tier >= RLD_TIER_MAX) {
      return { success: false, message: 'District is al op maximale inkomsten-tier (Penthouse)' };
    }

    const newTier = district.tier + 1;
    if (newTier === RLD_PENTHOUSE_TIER) {
      const playerVip = await prisma.player.findUnique({
        where: { id: playerId },
        select: { isVip: true, vipExpiresAt: true, money: true },
      });
      if (!playerVip) {
        return { success: false, message: 'Speler niet gevonden' };
      }
      if (!isVipStatusActive(playerVip)) {
        return {
          success: false,
          message: 'Penthouse is alleen voor actieve VIP-leden',
        };
      }
    }

    const upgradeCost = RLD_TIER_UPGRADE_COSTS[newTier];
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < upgradeCost) {
      return {
        success: false,
        message: `Je hebt €${upgradeCost.toLocaleString('nl-NL')} nodig voor deze upgrade`,
      };
    }

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } },
      });
      await tx.redLightDistrict.update({
        where: { id: districtId },
        data: { tier: newTier },
      });
      await tx.redLightRoom.updateMany({
        where: { redLightDistrictId: districtId },
        data: { tier: newTier },
      });
    });

    const tierName = getTierConfig(newTier).nameNl;
    return {
      success: true,
      message: `District geüpgraded naar ${tierName}!`,
      newTier,
    };
  },

  async upgradeSecurity(
    districtId: number,
    playerId: number
  ): Promise<{ success: boolean; message: string; newSecurityLevel?: number }> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
    });

    if (!district) {
      return { success: false, message: 'District niet gevonden' };
    }

    if (district.ownerId !== playerId) {
      return { success: false, message: 'Je bent niet de eigenaar van dit district' };
    }

    if (district.securityLevel >= RLD_SECURITY_MAX) {
      return { success: false, message: 'Beveiliging is al op maximaal niveau' };
    }

    const upgradeCost = RLD_SECURITY_COSTS[district.securityLevel] ?? 25000;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < upgradeCost) {
      return {
        success: false,
        message: `Je hebt €${upgradeCost.toLocaleString('nl-NL')} nodig voor deze upgrade`,
      };
    }

    const newSecurityLevel = district.securityLevel + 1;

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } },
      });
      await tx.redLightDistrict.update({
        where: { id: districtId },
        data: { securityLevel: newSecurityLevel },
      });
    });

    return {
      success: true,
      message: `Beveiliging geüpgraded naar level ${newSecurityLevel}!`,
      newSecurityLevel,
    };
  },

  async upgradeExpansion(
    districtId: number,
    playerId: number
  ): Promise<{ success: boolean; message: string; newExpansionLevel?: number; roomCount?: number }> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: { rooms: { select: { id: true } } },
    });

    if (!district) {
      return { success: false, message: 'District niet gevonden' };
    }

    if (district.ownerId !== playerId) {
      return { success: false, message: 'Je bent niet de eigenaar van dit district' };
    }

    if (district.expansionLevel >= RLD_EXPANSION_MAX) {
      return { success: false, message: 'Dit district heeft al het maximum aantal kamers via upgrades' };
    }

    const nextLevel = district.expansionLevel + 1;
    const upgradeCost = RLD_EXPANSION_COSTS[district.expansionLevel] ?? 500000;
    const targetRooms = Math.max(district.rooms.length, expansionTargetRooms(nextLevel));

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < upgradeCost) {
      return {
        success: false,
        message: `Je hebt €${upgradeCost.toLocaleString('nl-NL')} nodig voor extra kamers`,
      };
    }

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } },
      });
      await tx.redLightDistrict.update({
        where: { id: districtId },
        data: {
          expansionLevel: nextLevel,
          roomCount: targetRooms,
        },
      });
    });

    await createMissingRooms(districtId, targetRooms, district.tier || 1);
    const added = targetRooms - district.rooms.length;

    return {
      success: true,
      message:
        added > 0
          ? `Twee extra kamers gebouwd. Totaal ${targetRooms} kamers.`
          : `Kamer-upgrade voltooid (niveau ${nextLevel}).`,
      newExpansionLevel: nextLevel,
      roomCount: targetRooms,
    };
  },

  async getUpgradeInfo(districtId: number) {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: { rooms: { select: { occupied: true } } },
    });

    if (!district) {
      return null;
    }

    const currentTier = district.tier;
    const currentSecurity = district.securityLevel;
    const expansionLevel = district.expansionLevel ?? 0;
    const currentRooms = district.rooms.length || district.roomCount;
    const canUpgradeTier = currentTier < RLD_TIER_MAX;
    const canUpgradeSecurity = currentSecurity < RLD_SECURITY_MAX;
    const canUpgradeExpansion = expansionLevel < RLD_EXPANSION_MAX;
    const nextTier = canUpgradeTier ? currentTier + 1 : null;
    const nextTierNeedsVip = nextTier === RLD_PENTHOUSE_TIER;
    const currentTierConfig = getTierConfig(currentTier);
    const nextTierConfig = nextTier ? getTierConfig(nextTier) : null;
    const nextRooms = canUpgradeExpansion
      ? Math.max(currentRooms, expansionTargetRooms(expansionLevel + 1))
      : currentRooms;

    return {
      districtId: district.id,
      countryCode: district.countryCode,
      tier: {
        current: currentTier,
        currentName: currentTierConfig.nameNl,
        currentKey: currentTierConfig.key,
        canUpgrade: canUpgradeTier,
        nextTier,
        nextTierName: nextTierConfig?.nameNl,
        nextTierKey: nextTierConfig?.key,
        nextTierNeedsVip,
        upgradeCost: nextTier ? RLD_TIER_UPGRADE_COSTS[nextTier] : null,
        currentEarnings: {
          gross: currentTierConfig.gross,
          rent: currentTierConfig.rent,
          net: currentTierConfig.gross - currentTierConfig.rent,
        },
        nextEarnings: nextTierConfig
          ? {
              gross: nextTierConfig.gross,
              rent: nextTierConfig.rent,
              net: nextTierConfig.gross - nextTierConfig.rent,
            }
          : null,
      },
      security: {
        current: currentSecurity,
        canUpgrade: canUpgradeSecurity,
        nextLevel: canUpgradeSecurity ? currentSecurity + 1 : null,
        upgradeCost: canUpgradeSecurity ? RLD_SECURITY_COSTS[currentSecurity] : null,
        raidReduction: `${currentSecurity * 3}%`,
      },
      expansion: {
        current: expansionLevel,
        currentRooms,
        canUpgrade: canUpgradeExpansion,
        nextLevel: canUpgradeExpansion ? expansionLevel + 1 : null,
        nextRooms: canUpgradeExpansion ? nextRooms : null,
        extraRooms: canUpgradeExpansion ? Math.max(0, nextRooms - currentRooms) : 0,
        upgradeCost: canUpgradeExpansion ? RLD_EXPANSION_COSTS[expansionLevel] : null,
        maxRooms: RLD_MAX_ROOMS,
      },
    };
  },

  async processOccupancyHeat(): Promise<number> {
    const owned = await prisma.redLightDistrict.findMany({
      where: { ownerId: { not: null } },
      include: { rooms: { select: { occupied: true } } },
    });
    const now = new Date();
    const hourAgo = new Date(now.getTime() - 60 * 60 * 1000);
    let heated = 0;

    for (const district of owned) {
      if (!district.ownerId) continue;
      const occupied = district.rooms.filter((r) => r.occupied).length;
      const total = rldOccupancyCapacity(district.rooms.length || district.roomCount);
      const rate = occupancyRate(occupied, total);
      if (rate < RLD_OCCUPANCY_FULL) continue;
      if (district.lastOccupancyHeatAt && district.lastOccupancyHeatAt > hourAgo) continue;
      await increaseFBIHeat(district.ownerId, RLD_OCCUPANCY_FULL_HEAT);
      await prisma.redLightDistrict.update({
        where: { id: district.id },
        data: { lastOccupancyHeatAt: now },
      });
      heated += 1;
    }

    return heated;
  },
};

export const RLD_COUNTRY_LIST = RLD_COUNTRY_SLUGS;
