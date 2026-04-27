/**
 * Phase 12: Garage & Marina Management Service
 * Handles storage facilities for cars and boats
 */

import prisma from '../lib/prisma';

type GarageVehicleType = 'car' | 'motorcycle' | 'road';

export type GarageUpgradeRow = {
  track: string;
  upgradeLevel: number;
  capacityBonus: number;
};

export const GARAGE_MOTORCYCLE_BASE_SLOTS = 2;

const normalizeGarageVehicleType = (value?: string): GarageVehicleType => {
  const normalized = (value ?? '').toString().trim().toLowerCase();
  if (normalized === 'motorcycle' || normalized === 'motor' || normalized === 'bike') {
    return 'motorcycle';
  }
  if (normalized === 'road' || normalized === 'all') {
    return 'road';
  }
  return 'car';
};

export const normalizeGarageUpgradeTrack = (track?: string | null): 'car' | 'motorcycle' => {
  const t = (track ?? 'car').toString().trim().toLowerCase();
  return t === 'motorcycle' ? 'motorcycle' : 'car';
};

export function pickLatestUpgradeForTrack(
  upgrades: GarageUpgradeRow[],
  target: 'car' | 'motorcycle',
): GarageUpgradeRow | undefined {
  const filtered = upgrades.filter((u) => normalizeGarageUpgradeTrack(u.track) === target);
  if (filtered.length === 0) return undefined;
  return filtered.reduce((a, b) => (a.upgradeLevel >= b.upgradeLevel ? a : b));
}

export function computeGarageSlotTotals(garage: {
  capacity: number;
  upgrades: GarageUpgradeRow[];
}): {
  carTotalCapacity: number;
  motorcycleTotalCapacity: number;
  roadTotalCapacity: number;
  carUpgradeLevel: number;
  motorcycleUpgradeLevel: number;
} {
  const carUp = pickLatestUpgradeForTrack(garage.upgrades, 'car');
  const motoUp = pickLatestUpgradeForTrack(garage.upgrades, 'motorcycle');
  const carBonus = carUp?.capacityBonus ?? 0;
  const motoBonus = motoUp?.capacityBonus ?? 0;
  const carTotalCapacity = garage.capacity + carBonus;
  const motorcycleTotalCapacity = GARAGE_MOTORCYCLE_BASE_SLOTS + motoBonus;
  return {
    carTotalCapacity,
    motorcycleTotalCapacity,
    roadTotalCapacity: carTotalCapacity + motorcycleTotalCapacity,
    carUpgradeLevel: carUp?.upgradeLevel ?? 0,
    motorcycleUpgradeLevel: motoUp?.upgradeLevel ?? 0,
  };
}

const CAR_UPGRADE_COSTS = [0, 50000, 100000, 200000, 400000, 800000];

const GARAGE_CAR_UPGRADE_REQUIRED_RANKS = [0, 5, 7, 10, 12, 15]; // target level -> rank
const GARAGE_MOTORCYCLE_UPGRADE_REQUIRED_RANKS = [0, 7, 10, 12, 15, 18]; // target level -> rank
const MARINA_UPGRADE_REQUIRED_RANKS = [0, 10, 12, 15, 18, 20]; // target level -> rank

function requiredRankForGarageUpgrade(
  track: 'car' | 'motorcycle',
  targetLevel: number,
): number {
  const list =
    track === 'motorcycle'
      ? GARAGE_MOTORCYCLE_UPGRADE_REQUIRED_RANKS
      : GARAGE_CAR_UPGRADE_REQUIRED_RANKS;
  return list[targetLevel] ?? list[list.length - 1] ?? 0;
}

function requiredRankForMarinaUpgrade(targetLevel: number): number {
  return MARINA_UPGRADE_REQUIRED_RANKS[targetLevel] ??
    MARINA_UPGRADE_REQUIRED_RANKS[MARINA_UPGRADE_REQUIRED_RANKS.length - 1] ??
    0;
}

export const garageService = {
  /**
   * Get or create garage for player in a location
   */
  async getGarageStatus(playerId: number, location: string, vehicleType?: string) {
    let garage = await prisma.garage.findFirst({
      where: {
        playerId,
        location,
      },
      include: {
        upgrades: true,
      },
    });

    if (!garage) {
      garage = await prisma.garage.create({
        data: {
          playerId,
          location,
          capacity: 5,
        },
        include: {
          upgrades: true,
        },
      });
    }

    const caps = computeGarageSlotTotals(garage);
    const selectedType = normalizeGarageVehicleType(vehicleType);

    const storedVehicles = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        currentLocation: location,
        vehicleType: { in: ['car', 'motorcycle'] },
      },
    });

    const carStoredCount = storedVehicles.filter((v) => v.vehicleType === 'car').length;
    const motorcycleStoredCount = storedVehicles.filter((v) => v.vehicleType === 'motorcycle')
      .length;

    const selectedStoredCount =
      selectedType === 'motorcycle'
        ? motorcycleStoredCount
        : selectedType === 'road'
          ? carStoredCount + motorcycleStoredCount
          : carStoredCount;
    const selectedTotalCapacity =
      selectedType === 'motorcycle'
        ? caps.motorcycleTotalCapacity
        : selectedType === 'road'
          ? caps.roadTotalCapacity
          : caps.carTotalCapacity;

    const currentUpgradeLevelForSelection =
      selectedType === 'motorcycle' ? caps.motorcycleUpgradeLevel : caps.carUpgradeLevel;

    const nextLevelForSelection = Math.min(5, currentUpgradeLevelForSelection + 1);
    const nextUpgradeRequiredRank =
      currentUpgradeLevelForSelection >= 5
        ? null
        : requiredRankForGarageUpgrade(
            selectedType === 'motorcycle' ? 'motorcycle' : 'car',
            nextLevelForSelection,
          );

    return {
      garageId: garage.id,
      capacity: selectedStoredCount,
      totalCapacity: selectedTotalCapacity,
      currentUpgradeLevel: currentUpgradeLevelForSelection,
      currentCarUpgradeLevel: caps.carUpgradeLevel,
      currentMotorcycleUpgradeLevel: caps.motorcycleUpgradeLevel,
      nextUpgradeRequiredRank,
      storedCount: selectedStoredCount,
      selectedVehicleType: selectedType,
      carStoredCount,
      motorcycleStoredCount,
      carTotalCapacity: caps.carTotalCapacity,
      motorcycleTotalCapacity: caps.motorcycleTotalCapacity,
      roadStoredCount: carStoredCount + motorcycleStoredCount,
      roadTotalCapacity: caps.roadTotalCapacity,
      storedVehicles,
    };
  },

  /**
   * Upgrade garage capacity for one track: car or motorcycle (independent levels, max 5 each).
   */
  async upgradeGarage(
    playerId: number,
    location: string,
    garageTrack: 'car' | 'motorcycle' = 'car',
  ): Promise<{
    newLevel: number;
    capacityBonus: number;
    upgradeCost: number;
    newMoney: number;
    garageTrack: 'car' | 'motorcycle';
  }> {
    let garage = await prisma.garage.findFirst({
      where: { playerId, location },
      include: { upgrades: true },
    });

    if (!garage) {
      garage = await prisma.garage.create({
        data: { playerId, location, capacity: 5 },
        include: { upgrades: true },
      });
    }

    const caps = computeGarageSlotTotals(garage);
    const currentLevel =
      garageTrack === 'motorcycle' ? caps.motorcycleUpgradeLevel : caps.carUpgradeLevel;

    if (currentLevel >= 5) {
      throw new Error('MAX_UPGRADE_LEVEL');
    }

    const newLevel = currentLevel + 1;
    const capacityBonus = garageTrack === 'motorcycle' ? newLevel * 3 : newLevel * 5;
    const upgradeCost = CAR_UPGRADE_COSTS[newLevel];

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, rank: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const requiredRank = requiredRankForGarageUpgrade(garageTrack, newLevel);
    if ((player.rank ?? 0) < requiredRank) {
      throw new Error(`RANK_REQUIRED:${requiredRank}`);
    }

    if (player.money < upgradeCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const result = await prisma.$transaction(async (tx) => {
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money - upgradeCost,
        },
      });

      await tx.garageUpgrade.create({
        data: {
          garageId: garage.id,
          upgradeLevel: newLevel,
          capacityBonus,
          upgradeCost,
          track: garageTrack,
        },
      });

      return {
        newLevel,
        capacityBonus,
        upgradeCost,
        newMoney: updatedPlayer.money,
        garageTrack,
      };
    });

    return result;
  },

  /**
   * Get or create marina for player in a location
   */
  async getMarinaStatus(playerId: number, location: string) {
    let marina = await prisma.marina.findFirst({
      where: {
        playerId,
        location,
      },
      include: {
        upgrades: {
          orderBy: {
            upgradeLevel: 'desc',
          },
          take: 1,
        },
      },
    });

    if (!marina) {
      marina = await prisma.marina.create({
        data: {
          playerId,
          location,
          capacity: 3,
        },
        include: {
          upgrades: true,
        },
      });
    }

    const upgradeBonus =
      marina.upgrades.length > 0 ? marina.upgrades[0].capacityBonus : 0;
    const totalCapacity = marina.capacity + upgradeBonus;

    const storedBoats = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        currentLocation: location,
        vehicleType: 'boat',
      },
    });

    const currentUpgradeLevel = marina.upgrades.length > 0 ? marina.upgrades[0].upgradeLevel : 0;
    const nextLevel = Math.min(5, currentUpgradeLevel + 1);
    const nextUpgradeRequiredRank =
      currentUpgradeLevel >= 5 ? null : requiredRankForMarinaUpgrade(nextLevel);

    return {
      marinaId: marina.id,
      capacity: storedBoats.length,
      totalCapacity,
      currentUpgradeLevel,
      nextUpgradeRequiredRank,
      storedCount: storedBoats.length,
      storedBoats,
    };
  },

  /**
   * Upgrade marina capacity
   */
  async upgradeMarina(
    playerId: number,
    location: string,
  ): Promise<{
    newLevel: number;
    capacityBonus: number;
    upgradeCost: number;
    newMoney: number;
  }> {
    const status = await this.getMarinaStatus(playerId, location);
    const currentLevel = status.currentUpgradeLevel;

    if (currentLevel >= 5) {
      throw new Error('MAX_UPGRADE_LEVEL');
    }

    const newLevel = currentLevel + 1;

    const upgradeCosts = [0, 75000, 150000, 300000, 600000, 1200000];
    const upgradeCost = upgradeCosts[newLevel];

    const capacityBonus = newLevel * 3;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, rank: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const requiredRank = requiredRankForMarinaUpgrade(newLevel);
    if ((player.rank ?? 0) < requiredRank) {
      throw new Error(`RANK_REQUIRED:${requiredRank}`);
    }

    if (player.money < upgradeCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const result = await prisma.$transaction(async (tx) => {
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money - upgradeCost,
        },
      });

      await tx.marinaUpgrade.create({
        data: {
          marinaId: status.marinaId,
          upgradeLevel: newLevel,
          capacityBonus,
          upgradeCost,
        },
      });

      return {
        newLevel,
        capacityBonus,
        upgradeCost,
        newMoney: updatedPlayer.money,
      };
    });

    return result;
  },
};
