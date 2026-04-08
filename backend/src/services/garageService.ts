/**
 * Phase 12: Garage & Marina Management Service
 * Handles storage facilities for cars and boats
 */

import prisma from '../lib/prisma';

export const garageService = {
  /**
   * Get or create garage for player in a location
   */
  async getGarageStatus(playerId: number, location: string) {
    // Try to find existing garage
    let garage = await prisma.garage.findFirst({
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

    // Create garage if it doesn't exist
    if (!garage) {
      garage = await prisma.garage.create({
        data: {
          playerId,
          location,
          capacity: 5, // Default capacity
        },
        include: {
          upgrades: true,
        },
      });
    }

    // Calculate total capacity (base + upgrades)
    const upgradeBonus =
      garage.upgrades.length > 0 ? garage.upgrades[0].capacityBonus : 0;
    const totalCapacity = garage.capacity + upgradeBonus;

    // Get vehicles stored in this garage
    const storedVehicles = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        currentLocation: location,
        vehicleType: { in: ['car', 'motorcycle'] },
      },
    });

    return {
      garageId: garage.id,
      capacity: storedVehicles.length,
      totalCapacity,
      currentUpgradeLevel: garage.upgrades.length > 0 ? garage.upgrades[0].upgradeLevel : 0,
      storedCount: storedVehicles.length,
      storedVehicles,
    };
  },

  /**
   * Upgrade garage capacity
   */
  async upgradeGarage(
    playerId: number,
    location: string
  ): Promise<{
    newLevel: number;
    capacityBonus: number;
    upgradeCost: number;
    newMoney: number;
  }> {
    // Get garage status
    const status = await this.getGarageStatus(playerId, location);
    const currentLevel = status.currentUpgradeLevel;

    // Max level is 5
    if (currentLevel >= 5) {
      throw new Error('MAX_UPGRADE_LEVEL');
    }

    const newLevel = currentLevel + 1;

    // Calculate upgrade cost (increases with level)
    const upgradeCosts = [0, 50000, 100000, 200000, 400000, 800000]; // Levels 0-5
    const upgradeCost = upgradeCosts[newLevel];

    // Calculate capacity bonus (each level adds +5 capacity)
    const capacityBonus = newLevel * 5;

    // Check player money
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    if (player.money < upgradeCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    // Use transaction
    const result = await prisma.$transaction(async (tx) => {
      // Deduct money
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money - upgradeCost,
        },
      });

      // Create upgrade record
      await tx.garageUpgrade.create({
        data: {
          garageId: status.garageId,
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

  /**
   * Get or create marina for player in a location
   */
  async getMarinaStatus(playerId: number, location: string) {
    // Try to find existing marina
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

    // Create marina if it doesn't exist
    if (!marina) {
      marina = await prisma.marina.create({
        data: {
          playerId,
          location,
          capacity: 3, // Default capacity
        },
        include: {
          upgrades: true,
        },
      });
    }

    // Calculate total capacity (base + upgrades)
    const upgradeBonus =
      marina.upgrades.length > 0 ? marina.upgrades[0].capacityBonus : 0;
    const totalCapacity = marina.capacity + upgradeBonus;

    // Get boats stored in this marina
    const storedBoats = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        currentLocation: location,
        vehicleType: 'boat',
      },
    });

    return {
      marinaId: marina.id,
      capacity: storedBoats.length,
      totalCapacity,
      currentUpgradeLevel: marina.upgrades.length > 0 ? marina.upgrades[0].upgradeLevel : 0,
      storedCount: storedBoats.length,
      storedBoats,
    };
  },

  /**
   * Upgrade marina capacity
   */
  async upgradeMarina(
    playerId: number,
    location: string
  ): Promise<{
    newLevel: number;
    capacityBonus: number;
    upgradeCost: number;
    newMoney: number;
  }> {
    // Get marina status
    const status = await this.getMarinaStatus(playerId, location);
    const currentLevel = status.currentUpgradeLevel;

    // Max level is 5
    if (currentLevel >= 5) {
      throw new Error('MAX_UPGRADE_LEVEL');
    }

    const newLevel = currentLevel + 1;

    // Calculate upgrade cost (increases with level)
    const upgradeCosts = [0, 75000, 150000, 300000, 600000, 1200000]; // Levels 0-5 (more expensive than garage)
    const upgradeCost = upgradeCosts[newLevel];

    // Calculate capacity bonus (each level adds +3 capacity)
    const capacityBonus = newLevel * 3;

    // Check player money
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    if (player.money < upgradeCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    // Use transaction
    const result = await prisma.$transaction(async (tx) => {
      // Deduct money
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money - upgradeCost,
        },
      });

      // Create upgrade record
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
