import prisma from '../lib/prisma';

// Raid Configuration
const BASE_RAID_CHANCE = 0.10; // 10% base chance per hour if FBI heat > 50
const FBI_HEAT_THRESHOLD = 50; // Minimum FBI heat for raids
const FBI_HEAT_MULTIPLIER = 0.005; // +0.5% chance per FBI heat point above threshold
const SECURITY_REDUCTION = 0.03; // -3% raid chance per security level
const BUST_DURATION_HOURS = 4; // Prostitutes busted for 4 hours

export const policeRaidService = {
  /**
   * Calculate raid chance based on FBI heat and security
   */
  calculateRaidChance(fbiHeat: number, securityLevel: number = 0): number {
    if (fbiHeat < FBI_HEAT_THRESHOLD) {
      return 0;
    }

    const heatBonus = (fbiHeat - FBI_HEAT_THRESHOLD) * FBI_HEAT_MULTIPLIER;
    const securityReduction = securityLevel * SECURITY_REDUCTION;
    
    const raidChance = Math.max(0, BASE_RAID_CHANCE + heatBonus - securityReduction);
    
    return Math.min(1, raidChance); // Cap at 100%
  },

  /**
   * Check if a raid should occur for a player
   */
  shouldRaidOccur(fbiHeat: number, securityLevel: number = 0): boolean {
    const raidChance = this.calculateRaidChance(fbiHeat, securityLevel);
    return Math.random() < raidChance;
  },

  /**
   * Execute a police raid on a player's prostitutes
   * Raids can target street prostitutes and/or red light districts
   */
  async executeRaid(playerId: number): Promise<{
    success: boolean;
    raidOccurred: boolean;
    prostitutesAffected: number;
    districtsRaided: string[];
    message: string;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { fbiHeat: true }
    });

    if (!player) {
      return {
        success: false,
        raidOccurred: false,
        prostitutesAffected: 0,
        districtsRaided: [],
        message: 'Speler niet gevonden'
      };
    }

    // Get all prostitutes
    const prostitutes = await prisma.prostitute.findMany({
      where: { 
        playerId,
        isBusted: false // Only raid prostitutes who aren't already busted
      },
      include: {
        redLightRoom: {
          include: {
            redLightDistrict: true
          }
        }
      }
    });

    if (prostitutes.length === 0) {
      return {
        success: true,
        raidOccurred: false,
        prostitutesAffected: 0,
        districtsRaided: [],
        message: 'Geen prostituees om te raden'
      };
    }

    const now = new Date();
    const bustedUntil = new Date(now.getTime() + BUST_DURATION_HOURS * 60 * 60 * 1000);
    
    let prostitutesAffected = 0;
    const districtsRaided = new Set<string>();

    // Raid street prostitutes (higher chance)
    const streetProstitutes = prostitutes.filter(p => p.location === 'street');
    for (const prostitute of streetProstitutes) {
      // 70% chance to bust each street prostitute
      if (Math.random() < 0.7) {
        await prisma.prostitute.update({
          where: { id: prostitute.id },
          data: {
            isBusted: true,
            bustedUntil: bustedUntil
          }
        });
        prostitutesAffected++;
      }
    }

    // Raid red light districts (lower chance, affected by security)
    const redlightProstitutes = prostitutes.filter(p => p.location === 'redlight' && p.redLightRoom);
    for (const prostitute of redlightProstitutes) {
      const district = prostitute.redLightRoom!.redLightDistrict;
      const securityLevel = district.securityLevel || 0;
      
      // Base 30% chance, reduced by security
      const bustChance = Math.max(0.05, 0.3 - (securityLevel * 0.07));
      
      if (Math.random() < bustChance) {
        await prisma.prostitute.update({
          where: { id: prostitute.id },
          data: {
            isBusted: true,
            bustedUntil: bustedUntil
          }
        });
        prostitutesAffected++;
        districtsRaided.add(district.countryCode);
      }
    }

    const message = prostitutesAffected > 0
      ? `Politie raid! ${prostitutesAffected} prostituee(s) gearresteerd voor ${BUST_DURATION_HOURS} uur!`
      : 'Politie raid kwam, maar niemand werd gearresteerd!';

    return {
      success: true,
      raidOccurred: true,
      prostitutesAffected,
      districtsRaided: Array.from(districtsRaided),
      message
    };
  },

  /**
   * Check and potentially execute raids for a player
   * This should be called periodically (e.g., every hour via cron)
   */
  async checkAndExecuteRaid(playerId: number): Promise<{
    raidOccurred: boolean;
    prostitutesAffected: number;
    districtsRaided: string[];
    message?: string;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { fbiHeat: true }
    });

    if (!player) {
      return {
        raidOccurred: false,
        prostitutesAffected: 0,
        districtsRaided: []
      };
    }

    // Get max security level from owned districts
    const districts = await prisma.redLightDistrict.findMany({
      where: { ownerId: playerId },
      select: { securityLevel: true }
    });

    const maxSecurity = districts.length > 0
      ? Math.max(...districts.map(d => d.securityLevel || 0))
      : 0;

    // Determine if raid should occur
    if (this.shouldRaidOccur(player.fbiHeat, maxSecurity)) {
      const result = await this.executeRaid(playerId);
      return {
        raidOccurred: result.raidOccurred,
        prostitutesAffected: result.prostitutesAffected,
        districtsRaided: result.districtsRaided,
        message: result.message
      };
    }

    return {
      raidOccurred: false,
      prostitutesAffected: 0,
      districtsRaided: []
    };
  },

  /**
   * Get raid statistics for a player
   */
  async getRaidStats(playerId: number) {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { fbiHeat: true }
    });

    if (!player) {
      return null;
    }

    const districts = await prisma.redLightDistrict.findMany({
      where: { ownerId: playerId },
      select: { securityLevel: true, countryCode: true }
    });

    const maxSecurity = districts.length > 0
      ? Math.max(...districts.map(d => d.securityLevel || 0))
      : 0;

    const raidChance = this.calculateRaidChance(player.fbiHeat, maxSecurity);

    // Count busted prostitutes
    const bustedProstitutes = await prisma.prostitute.count({
      where: {
        playerId,
        isBusted: true,
        bustedUntil: { gte: new Date() }
      }
    });

    return {
      fbiHeat: player.fbiHeat,
      raidChance: Math.round(raidChance * 100), // As percentage
      maxSecurity,
      districtCount: districts.length,
      bustedProstitutes
    };
  }
};
