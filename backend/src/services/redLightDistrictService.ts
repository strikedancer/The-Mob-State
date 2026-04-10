import prisma from '../lib/prisma';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';

// Upgrade Costs
const TIER_UPGRADE_COSTS = {
  1: 0,      // Basic (starting tier)
  2: 50000,  // Luxury upgrade: €50k
  3: 150000  // VIP upgrade: €150k
};

const SECURITY_UPGRADE_COST = 25000; // €25k per security level

// Tier Configuration
const TIER_CONFIG = {
  1: { name: 'Basic', gross: 75, rent: 20 },
  2: { name: 'Luxury', gross: 100, rent: 30 },
  3: { name: 'VIP', gross: 150, rent: 50 }
};

const DEFAULT_RED_LIGHT_DISTRICTS = [
  { countryCode: 'netherlands', purchasePrice: 750000, roomCount: 10 },
  { countryCode: 'belgium', purchasePrice: 650000, roomCount: 8 },
  { countryCode: 'germany', purchasePrice: 800000, roomCount: 10 },
  { countryCode: 'france', purchasePrice: 850000, roomCount: 10 },
  { countryCode: 'spain', purchasePrice: 700000, roomCount: 8 },
  { countryCode: 'italy', purchasePrice: 750000, roomCount: 8 },
  { countryCode: 'uk', purchasePrice: 900000, roomCount: 10 },
  { countryCode: 'switzerland', purchasePrice: 1150000, roomCount: 12 },
  { countryCode: 'usa', purchasePrice: 1000000, roomCount: 12 },
  { countryCode: 'mexico', purchasePrice: 600000, roomCount: 8 },
  { countryCode: 'colombia', purchasePrice: 650000, roomCount: 8 },
  { countryCode: 'brazil', purchasePrice: 700000, roomCount: 10 },
  { countryCode: 'argentina', purchasePrice: 650000, roomCount: 8 },
  { countryCode: 'japan', purchasePrice: 950000, roomCount: 10 },
  { countryCode: 'china', purchasePrice: 900000, roomCount: 10 },
  { countryCode: 'russia', purchasePrice: 750000, roomCount: 10 },
  { countryCode: 'turkey', purchasePrice: 600000, roomCount: 8 },
  { countryCode: 'united_arab_emirates', purchasePrice: 1200000, roomCount: 12 },
  { countryCode: 'south_africa', purchasePrice: 600000, roomCount: 8 },
  { countryCode: 'australia', purchasePrice: 850000, roomCount: 8 }
];

let districtSeedPromise: Promise<void> | null = null;

async function ensureDistrictSeedData() {
  if (districtSeedPromise) {
    await districtSeedPromise;
    return;
  }

  districtSeedPromise = (async () => {
    await prisma.redLightDistrict.createMany({
      data: DEFAULT_RED_LIGHT_DISTRICTS,
      skipDuplicates: true
    });
  })();

  try {
    await districtSeedPromise;
  } finally {
    districtSeedPromise = null;
  }
}

export const redLightDistrictService = {
  /**
   * Get red light district for a country
   */
  async getByCountry(countryCode: string) {
    await ensureDistrictSeedData();

    const district = await prisma.redLightDistrict.findUnique({
      where: { countryCode },
      include: {
        owner: {
          select: {
            id: true,
            username: true
          }
        },
        rooms: {
          include: {
            prostitute: {
              include: {
                player: {
                  select: {
                    id: true,
                    username: true
                  }
                }
              }
            }
          },
          orderBy: { roomNumber: 'asc' }
        }
      }
    });

    return district;
  },

  /**
   * Get red light district by ID
   */
  async getDistrictById(districtId: number) {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        owner: {
          select: {
            id: true,
            username: true
          }
        },
        rooms: {
          include: {
            prostitute: {
              include: {
                player: {
                  select: {
                    id: true,
                    username: true
                  }
                }
              }
            }
          },
          orderBy: { roomNumber: 'asc' }
        }
      }
    });

    return district;
  },

  /**
   * Get all districts owned by a player
   */
  async getPlayerDistricts(playerId: number) {
    const districts = await prisma.redLightDistrict.findMany({
      where: { ownerId: playerId },
      include: {
        rooms: {
          include: {
            prostitute: {
              include: {
                player: {
                  select: {
                    id: true,
                    username: true
                  }
                }
              }
            }
          }
        }
      }
    });

    return districts;
  },

  /**
   * Purchase a red light district
   */
  async purchaseDistrict(
    playerId: number,
    countryCode: string
  ): Promise<{ success: boolean; message: string; district?: any; newlyUnlockedAchievements?: any[] }> {
    await ensureDistrictSeedData();

    const district = await prisma.redLightDistrict.findUnique({
      where: { countryCode }
    });

    if (!district) {
      return { success: false, message: 'Red Light District niet gevonden in dit land' };
    }

    if (district.ownerId) {
      return { success: false, message: 'Dit Red Light District is al eigendom van iemand anders' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true }
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < district.purchasePrice) {
      return {
        success: false,
        message: `Je hebt €${district.purchasePrice.toLocaleString('nl-NL')} nodig om dit Red Light District te kopen`
      };
    }

    // Purchase district
    const updatedDistrict = await prisma.redLightDistrict.update({
      where: { id: district.id },
      data: {
        ownerId: playerId,
        purchasedAt: new Date()
      }
    });

    // Deduct money
    await prisma.player.update({
      where: { id: playerId },
      data: { money: { decrement: district.purchasePrice } }
    });

    // Create rooms for the district
    const roomPromises = [];
    for (let i = 1; i <= district.roomCount; i++) {
      roomPromises.push(
        prisma.redLightRoom.create({
          data: {
            redLightDistrictId: district.id,
            roomNumber: i
          }
        })
      );
    }
    await Promise.all(roomPromises);

    // Check for achievement unlocks and get newly unlocked ones
    let newlyUnlockedAchievements: any[] = [];
    try {
      const achievementResults = await checkAndUnlockAchievements(playerId);
      newlyUnlockedAchievements = achievementResults.map(r =>
        serializeAchievementForClient(r.achievement)
      );
    } catch (err) {
      console.error('[Achievement Check] Error after district purchase:', err);
    }

    return {
      success: true,
      message: `Je bent nu eigenaar van het Red Light District in ${countryCode}!`,
      district: updatedDistrict,
      newlyUnlockedAchievements
    };
  },

  /**
   * Get available rooms in a district
   */
  async getAvailableRooms(districtId: number) {
    const rooms = await prisma.redLightRoom.findMany({
      where: {
        redLightDistrictId: districtId,
        occupied: false
      },
      orderBy: { roomNumber: 'asc' }
    });

    return rooms;
  },

  /**
   * Calculate rental income for district owner
   */
  async calculateRentalIncome(districtId: number): Promise<number> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        rooms: {
          where: { occupied: true },
          include: { prostitute: true }
        }
      }
    });

    if (!district || !district.ownerId) {
      return 0;
    }

    const now = new Date();
    let totalIncome = 0;
    const RENT_PER_HOUR = 20;

    for (const room of district.rooms) {
      if (room.prostitute) {
        const hoursElapsed = (now.getTime() - room.lastEarningsAt.getTime()) / (1000 * 60 * 60);
        totalIncome += Math.floor(RENT_PER_HOUR * hoursElapsed);
      }
    }

    return totalIncome;
  },

  /**
   * Get district statistics
   */
  async getDistrictStats(districtId: number) {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        rooms: {
          include: {
            prostitute: {
              include: {
                player: {
                  select: {
                    id: true,
                    username: true
                  }
                }
              }
            }
          }
        }
      }
    });

    if (!district) {
      return null;
    }

    const occupiedRooms = district.rooms.filter(r => r.occupied).length;
    const availableRooms = district.rooms.filter(r => !r.occupied).length;
    const occupancyRate = (occupiedRooms / district.roomCount) * 100;

    // Calculate potential hourly income based on district tier
    const tierRent = district.tier === 3 ? 50 : district.tier === 2 ? 30 : 20;
    const hourlyIncome = occupiedRooms * tierRent;

    // Get unique tenants (players with prostitutes in this district)
    const tenants = new Set(
      district.rooms
        .filter(r => r.prostitute)
        .map(r => r.prostitute!.player.username)
    );

    return {
      districtId: district.id,
      countryCode: district.countryCode,
      totalRooms: district.roomCount,
      occupiedRooms,
      availableRooms,
      occupancyRate: Math.round(occupancyRate),
      hourlyIncome,
      tenantCount: tenants.size,
      tenants: Array.from(tenants)
    };
  },

  /**
   * Get all available districts (not owned)
   */
  async getAvailableDistricts() {
    await ensureDistrictSeedData();

    const districts = await prisma.redLightDistrict.findMany({
      where: { ownerId: null },
      orderBy: { purchasePrice: 'asc' }
    });

    return districts;
  },

  /**
   * Upgrade district tier (Basic -> Luxury -> VIP)
   */
  async upgradeTier(
    districtId: number,
    playerId: number
  ): Promise<{ success: boolean; message: string; newTier?: number }> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: { rooms: true }
    });

    if (!district) {
      return { success: false, message: 'District niet gevonden' };
    }

    if (district.ownerId !== playerId) {
      return { success: false, message: 'Je bent niet de eigenaar van dit district' };
    }

    if (district.tier >= 3) {
      return { success: false, message: 'District is al op maximale tier (VIP)' };
    }

    const newTier = district.tier + 1;
    const upgradeCost = TIER_UPGRADE_COSTS[newTier as keyof typeof TIER_UPGRADE_COSTS];

    // Check player money
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true }
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < upgradeCost) {
      return {
        success: false,
        message: `Je hebt €${upgradeCost.toLocaleString('nl-NL')} nodig voor deze upgrade`
      };
    }

    // Perform upgrade
    await prisma.$transaction(async (tx) => {
      // Deduct money
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } }
      });

      // Upgrade district
      await tx.redLightDistrict.update({
        where: { id: districtId },
        data: { tier: newTier }
      });

      // Upgrade all rooms
      await tx.redLightRoom.updateMany({
        where: { redLightDistrictId: districtId },
        data: { tier: newTier }
      });
    });

    const tierName = TIER_CONFIG[newTier as keyof typeof TIER_CONFIG].name;
    return {
      success: true,
      message: `District geüpgraded naar ${tierName}!`,
      newTier
    };
  },

  /**
   * Upgrade district security (0 -> 1 -> 2 -> 3)
   */
  async upgradeSecurity(
    districtId: number,
    playerId: number
  ): Promise<{ success: boolean; message: string; newSecurityLevel?: number }> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId }
    });

    if (!district) {
      return { success: false, message: 'District niet gevonden' };
    }

    if (district.ownerId !== playerId) {
      return { success: false, message: 'Je bent niet de eigenaar van dit district' };
    }

    if (district.securityLevel >= 3) {
      return { success: false, message: 'Security is al op maximaal niveau' };
    }

    // Check player money
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true }
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < SECURITY_UPGRADE_COST) {
      return {
        success: false,
        message: `Je hebt €${SECURITY_UPGRADE_COST.toLocaleString('nl-NL')} nodig voor deze upgrade`
      };
    }

    const newSecurityLevel = district.securityLevel + 1;

    // Perform upgrade
    await prisma.$transaction(async (tx) => {
      // Deduct money
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: SECURITY_UPGRADE_COST } }
      });

      // Upgrade security
      await tx.redLightDistrict.update({
        where: { id: districtId },
        data: { securityLevel: newSecurityLevel }
      });
    });

    return {
      success: true,
      message: `Security geüpgraded naar level ${newSecurityLevel}!`,
      newSecurityLevel
    };
  },

  /**
   * Get upgrade information for a district
   */
  async getUpgradeInfo(districtId: number) {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId }
    });

    if (!district) {
      return null;
    }

    const currentTier = district.tier;
    const currentSecurity = district.securityLevel;

    const canUpgradeTier = currentTier < 3;
    const canUpgradeSecurity = currentSecurity < 3;

    const nextTierCost = canUpgradeTier
      ? TIER_UPGRADE_COSTS[(currentTier + 1) as keyof typeof TIER_UPGRADE_COSTS]
      : null;

    const currentTierConfig = TIER_CONFIG[currentTier as keyof typeof TIER_CONFIG];
    const nextTierConfig = canUpgradeTier
      ? TIER_CONFIG[(currentTier + 1) as keyof typeof TIER_CONFIG]
      : null;

    return {
      districtId: district.id,
      countryCode: district.countryCode,
      tier: {
        current: currentTier,
        currentName: currentTierConfig.name,
        canUpgrade: canUpgradeTier,
        nextTier: canUpgradeTier ? currentTier + 1 : null,
        nextTierName: nextTierConfig?.name,
        upgradeCost: nextTierCost,
        currentEarnings: {
          gross: currentTierConfig.gross,
          rent: currentTierConfig.rent,
          net: currentTierConfig.gross - currentTierConfig.rent
        },
        nextEarnings: nextTierConfig ? {
          gross: nextTierConfig.gross,
          rent: nextTierConfig.rent,
          net: nextTierConfig.gross - nextTierConfig.rent
        } : null
      },
      security: {
        current: currentSecurity,
        canUpgrade: canUpgradeSecurity,
        nextLevel: canUpgradeSecurity ? currentSecurity + 1 : null,
        upgradeCost: canUpgradeSecurity ? SECURITY_UPGRADE_COST : null,
        raidReduction: `${currentSecurity * 3}%`
      }
    };
  }
};
