import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { activityService } from './activityService';
import {
  checkAndUnlockAchievements,
  serializeAchievementForClient,
} from './achievementService';
import { translationService } from './translationService';

interface CrowdState {
  size: number;           // 0-100 (percentage)
  vibe: 'chill' | 'normal' | 'wild' | 'raging';
  demand: { [drugType: string]: number };  // Drug demand based on vibe
}

interface DJConfig {
  id: number;
  djName: string;
  skillLevel: number;
  baseCostPerHour: number;
  crowdBoost: number;    // 1.0 = no effect, 1.5 = 50% better
  vibeShift?: 'chill' | 'normal' | 'wild';
}

class NightclubService {
  private readonly BASE_CROWD_REGEN_RATE = 2;      // 2% per minute
  private readonly BASE_CROWD_DECAY_RATE = 1;       // 1% per minute
  private readonly MIN_MARGIN = 0.8;                 // 80% margin without markup
  private readonly MAX_MARGIN = 3.0;                 // 300% margin with high quality/vibe
  private readonly BASE_STAFF_CAP = 5;
  private readonly VIP_EXTRA_STAFF_CAP = 2;
  private readonly COUNTRY_STAFF_CAP: Record<string, number> = {
    netherlands: 5,
    belgium: 5,
    germany: 6,
    france: 6,
    uk: 6,
    usa: 7,
  };
  private readonly SEASON_KEY = 'weekly-nightclub-season';
  private readonly SEASON_REWARD_BY_RANK: Record<number, number> = {
    1: 500000,
    2: 250000,
    3: 125000,
    4: 50000,
    5: 35000,
    6: 25000,
    7: 20000,
    8: 15000,
    9: 10000,
    10: 7500,
  };

  private async getPlayerLanguage(playerId: number): Promise<'nl' | 'en'> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { preferredLanguage: true },
    });

    return translationService.getPlayerLanguage({
      preferredLanguage: player?.preferredLanguage,
    });
  }

  private localize(language: 'nl' | 'en', nl: string, en: string): string {
    return language === 'nl' ? nl : en;
  }

  private async buildAchievementPayloads(playerId: number): Promise<any[]> {
    try {
      const achievementResults = await checkAndUnlockAchievements(playerId);
      return achievementResults.map(({ achievement }) =>
        serializeAchievementForClient(achievement)
      );
    } catch (error) {
      console.error('[Nightclub] Achievement check failed:', error);
      return [];
    }
  }

  private getSeasonWindow(date: Date): { start: Date; end: Date } {
    const start = new Date(date);
    const day = start.getUTCDay();
    const offset = day === 0 ? -6 : 1 - day;
    start.setUTCDate(start.getUTCDate() + offset);
    start.setUTCHours(0, 0, 0, 0);
    const end = new Date(start);
    end.setUTCDate(end.getUTCDate() + 7);
    return { start, end };
  }

  private async buildSeasonLeaderboard(
    seasonStartAt: Date,
    seasonEndAt: Date,
    limit = 10
  ): Promise<Array<{
    rank: number;
    venueId: number;
    playerId: number;
    ownerUsername: string;
    country: string;
    weeklyRevenue: number;
    weeklyTheftLoss: number;
    crowdSize: number;
    staffCount: number;
    score: number;
  }>> {
    const venues = await prisma.nightclubVenue.findMany({
      include: {
        player: {
          select: { id: true, username: true },
        },
      },
    });

    const scored = await Promise.all(
      venues.map(async (venue) => {
        const [salesAgg, theftAgg, staffCount] = await Promise.all([
          prisma.nightclubSale.aggregate({
            where: {
              venueId: venue.id,
              saleTime: {
                gte: seasonStartAt,
                lt: seasonEndAt,
              },
            },
            _sum: { totalRevenue: true },
          }),
          prisma.nightclubTheft.aggregate({
            where: {
              venueId: venue.id,
              occurredAt: {
                gte: seasonStartAt,
                lt: seasonEndAt,
              },
            },
            _sum: { valueLost: true },
          }),
          prisma.prostitute.count({
            where: {
              nightclubVenueId: venue.id,
              location: 'nightclub',
              isBusted: false,
            },
          }),
        ]);

        const weeklyRevenue = salesAgg._sum.totalRevenue ?? 0;
        const weeklyTheftLoss = theftAgg._sum.valueLost ?? 0;
        const score = Math.round(
          weeklyRevenue * 1.2 - weeklyTheftLoss * 0.45 + venue.crowdSize * 110 + staffCount * 220
        );

        return {
          venueId: venue.id,
          playerId: venue.playerId,
          ownerUsername: venue.player.username,
          country: venue.country,
          weeklyRevenue,
          weeklyTheftLoss,
          crowdSize: venue.crowdSize,
          staffCount,
          score,
        };
      })
    );

    return scored
      .sort((a, b) => b.score - a.score)
      .slice(0, Math.max(1, Math.min(limit, 50)))
      .map((entry, index) => ({
        rank: index + 1,
        ...entry,
      }));
  }

  async processWeeklySeasonIfNeeded(): Promise<{
    processed: boolean;
    seasonStartAt: Date;
    seasonEndAt: Date;
    winners: Array<{ rank: number; playerId: number; venueId: number; rewardAmount: number }>;
  }> {
    const now = new Date();
    const currentWindow = this.getSeasonWindow(now);

    let state = await prisma.nightclubSeasonState.findUnique({
      where: { seasonKey: this.SEASON_KEY },
    });

    if (!state) {
      state = await prisma.nightclubSeasonState.create({
        data: {
          seasonKey: this.SEASON_KEY,
          seasonStartAt: currentWindow.start,
          seasonEndAt: currentWindow.end,
        },
      });
      return {
        processed: false,
        seasonStartAt: state.seasonStartAt,
        seasonEndAt: state.seasonEndAt,
        winners: [],
      };
    }

    if (now < state.seasonEndAt) {
      return {
        processed: false,
        seasonStartAt: state.seasonStartAt,
        seasonEndAt: state.seasonEndAt,
        winners: [],
      };
    }

    const existingRewards = await prisma.nightclubSeasonReward.count({
      where: {
        seasonKey: this.SEASON_KEY,
        weekStartAt: state.seasonStartAt,
      },
    });

    const winners: Array<{ rank: number; playerId: number; venueId: number; rewardAmount: number }> = [];

    if (existingRewards === 0) {
      const leaderboard = await this.buildSeasonLeaderboard(state.seasonStartAt, state.seasonEndAt, 10);

      for (const entry of leaderboard) {
        const rewardAmount = this.SEASON_REWARD_BY_RANK[entry.rank] ?? 0;
        if (rewardAmount <= 0) continue;

        const language = await this.getPlayerLanguage(entry.playerId);

        await prisma.$transaction([
          prisma.player.update({
            where: { id: entry.playerId },
            data: { money: { increment: rewardAmount } },
          }),
          prisma.nightclubSeasonReward.create({
            data: {
              seasonKey: this.SEASON_KEY,
              weekStartAt: state.seasonStartAt,
              weekEndAt: state.seasonEndAt,
              rank: entry.rank,
              venueId: entry.venueId,
              playerId: entry.playerId,
              rewardAmount,
              score: BigInt(entry.score),
              weeklyRevenue: BigInt(entry.weeklyRevenue),
              weeklyTheftLoss: BigInt(entry.weeklyTheftLoss),
            },
          }),
        ]);

        winners.push({
          rank: entry.rank,
          playerId: entry.playerId,
          venueId: entry.venueId,
          rewardAmount,
        });

        const rewardMessage = [
          this.localize(language, 'Nightclub Season Uitbetaling', 'Nightclub Season Payout'),
          '',
          this.localize(
            language,
            `Je nightclub eindigde op plek #${entry.rank} in de wekelijkse season ranking.`,
            `Your nightclub finished in position #${entry.rank} in the weekly season ranking.`
          ),
          this.localize(
            language,
            `Beloning: €${rewardAmount.toLocaleString()}`,
            `Reward: €${rewardAmount.toLocaleString()}`
          ),
          this.localize(
            language,
            `Weekomzet: €${entry.weeklyRevenue.toLocaleString()}`,
            `Weekly revenue: €${entry.weeklyRevenue.toLocaleString()}`
          ),
          this.localize(
            language,
            `Diefstalverlies: €${entry.weeklyTheftLoss.toLocaleString()}`,
            `Theft loss: €${entry.weeklyTheftLoss.toLocaleString()}`
          ),
          '',
          this.localize(
            language,
            'Blijf draaien om volgende week hoger te eindigen.',
            'Keep the club moving to climb higher next week.'
          ),
        ].join('\n');

        await directMessageService.sendSystemMessage(entry.playerId, rewardMessage);
        await activityService.logActivity(
          entry.playerId,
          'NIGHTCLUB_SEASON_REWARD',
          this.localize(
            language,
            `Nightclub season uitbetaling ontvangen: #${entry.rank} voor €${rewardAmount.toLocaleString()}`,
            `Nightclub season payout received: #${entry.rank} for €${rewardAmount.toLocaleString()}`
          ),
          {
            seasonKey: this.SEASON_KEY,
            rank: entry.rank,
            rewardAmount,
            venueId: entry.venueId,
            weeklyRevenue: entry.weeklyRevenue,
            weeklyTheftLoss: entry.weeklyTheftLoss,
          },
          false
        );
      }
    }

    const nextWindow = this.getSeasonWindow(now);
    const updated = await prisma.nightclubSeasonState.update({
      where: { seasonKey: this.SEASON_KEY },
      data: {
        seasonStartAt: nextWindow.start,
        seasonEndAt: nextWindow.end,
        lastProcessedAt: now,
      },
    });

    return {
      processed: true,
      seasonStartAt: updated.seasonStartAt,
      seasonEndAt: updated.seasonEndAt,
      winners,
    };
  }

  async getSeasonSummary(playerId: number): Promise<any> {
    const now = new Date();
    const currentWindow = this.getSeasonWindow(now);

    let state = await prisma.nightclubSeasonState.findUnique({
      where: { seasonKey: this.SEASON_KEY },
    });

    if (!state) {
      state = await prisma.nightclubSeasonState.create({
        data: {
          seasonKey: this.SEASON_KEY,
          seasonStartAt: currentWindow.start,
          seasonEndAt: currentWindow.end,
        },
      });
    }

    const [currentLeaderboard, rewardHistory, playerRewardsTotal, latestPlayerReward] = await Promise.all([
      this.buildSeasonLeaderboard(state.seasonStartAt, state.seasonEndAt, 10),
      prisma.nightclubSeasonReward.findMany({
        where: { seasonKey: this.SEASON_KEY },
        orderBy: [{ weekStartAt: 'desc' }, { rank: 'asc' }],
        take: 20,
        include: {
          player: {
            select: { username: true },
          },
        },
      }),
      prisma.nightclubSeasonReward.aggregate({
        where: { seasonKey: this.SEASON_KEY, playerId },
        _sum: { rewardAmount: true },
      }),
      prisma.nightclubSeasonReward.findFirst({
        where: { seasonKey: this.SEASON_KEY, playerId },
        orderBy: [{ paidAt: 'desc' }, { rank: 'asc' }],
      }),
    ]);

    return {
      seasonKey: this.SEASON_KEY,
      seasonStartAt: state.seasonStartAt,
      seasonEndAt: state.seasonEndAt,
      rewardTable: this.SEASON_REWARD_BY_RANK,
      currentLeaderboard,
      recentRewards: rewardHistory.map((r) => ({
        rank: r.rank,
        playerId: r.playerId,
        username: r.player.username,
        rewardAmount: r.rewardAmount,
        weekStartAt: r.weekStartAt,
        weekEndAt: r.weekEndAt,
        paidAt: r.paidAt,
      })),
      yourTotalSeasonRewards: playerRewardsTotal._sum.rewardAmount ?? 0,
      latestPlayerReward: latestPlayerReward
        ? {
            rank: latestPlayerReward.rank,
            rewardAmount: latestPlayerReward.rewardAmount,
            score: Number(latestPlayerReward.score),
            weeklyRevenue: Number(latestPlayerReward.weeklyRevenue),
            weeklyTheftLoss: Number(latestPlayerReward.weeklyTheftLoss),
            weekStartAt: latestPlayerReward.weekStartAt,
            weekEndAt: latestPlayerReward.weekEndAt,
            paidAt: latestPlayerReward.paidAt,
          }
        : null,
    };
  }

  private hasActiveVip(player: { isVip: boolean; vipExpiresAt: Date | null }): boolean {
    return player.isVip && (!player.vipExpiresAt || player.vipExpiresAt > new Date());
  }

  private async getCurrentSecurityReduction(venueId: number): Promise<number> {
    const now = new Date();
    const activeShift = await prisma.nightclubSecurityShift.findFirst({
      where: {
        venueId,
        shiftStartAt: { lte: now },
        shiftEndAt: { gte: now },
      },
      orderBy: { shiftStartAt: 'desc' },
      select: { theftReduction: true },
    });

    return activeShift?.theftReduction ?? 0;
  }

  private async getStaffingLimits(playerId: number): Promise<{
    staffCap: number;
    isVipActive: boolean;
    countryBaseCap: number;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { isVip: true, vipExpiresAt: true, currentCountry: true },
    });

    const isVipActive = player ? this.hasActiveVip(player) : false;
    const countryBaseCap = player
      ? (this.COUNTRY_STAFF_CAP[player.currentCountry] ?? this.BASE_STAFF_CAP)
      : this.BASE_STAFF_CAP;

    return {
      staffCap: countryBaseCap + (isVipActive ? this.VIP_EXTRA_STAFF_CAP : 0),
      isVipActive,
      countryBaseCap,
    };
  }

  private async getActiveProstituteBoost(
    venueId: number,
    crowdVibe: CrowdState['vibe'],
    securityReduction: number,
    isVipActive: boolean
  ): Promise<{
    assignedCount: number;
    vipAssignedCount: number;
    avgLevel: number;
    salesBoost: number;
    priceBoost: number;
    vibeFactor: number;
    securityFactor: number;
    vipFactor: number;
    vipStaffFactor: number;
  }> {
    const assigned = await prisma.prostitute.findMany({
      where: {
        nightclubVenueId: venueId,
        location: 'nightclub',
        isBusted: false,
      },
      select: { id: true, level: true, variant: true },
    });

    if (assigned.length === 0) {
      return {
        assignedCount: 0,
        vipAssignedCount: 0,
        avgLevel: 0,
        salesBoost: 1,
        priceBoost: 1,
        vibeFactor: 1,
        securityFactor: 1,
        vipFactor: 1,
        vipStaffFactor: 1,
      };
    }

    const avgLevel = assigned.reduce((sum, p) => sum + p.level, 0) / assigned.length;
    const vipAssignedCount = assigned.filter((p) => p.variant >= 6 && p.variant <= 10).length;
    const vibeFactors: Record<CrowdState['vibe'], number> = {
      chill: 0.9,
      normal: 1,
      wild: 1.1,
      raging: 1.2,
    };

    const vibeFactor = vibeFactors[crowdVibe] ?? 1;
    const securityFactor = securityReduction >= 0.7 ? 1.06 : securityReduction >= 0.35 ? 1.0 : 0.9;
    const vipFactor = isVipActive ? 1.12 : 1;
    const vipStaffFactor = Math.min(1.2, 1 + vipAssignedCount * 0.04);

    const rawSalesBoost =
      (1 + assigned.length * 0.035 + avgLevel * 0.012) *
      vibeFactor *
      securityFactor *
      vipFactor *
      vipStaffFactor;
    const rawPriceBoost =
      (1 + assigned.length * 0.018 + avgLevel * 0.01) *
      vibeFactor *
      (0.95 + securityReduction * 0.15) *
      vipFactor *
      vipStaffFactor;

    const salesBoost = Math.min(1.75, Math.max(1, rawSalesBoost));
    const priceBoost = Math.min(1.5, Math.max(1, rawPriceBoost));

    return {
      assignedCount: assigned.length,
      vipAssignedCount,
      avgLevel,
      salesBoost,
      priceBoost,
      vibeFactor,
      securityFactor,
      vipFactor,
      vipStaffFactor,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION & SETUP
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Set up a nightclub venue when player buys nightclub
   */
  async setupNightclub(
    playerId: number,
    propertyId: number,
    country: string
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    try {
      const language = await this.getPlayerLanguage(playerId);
      const venue = await prisma.nightclubVenue.create({
        data: {
          propertyId,
          playerId,
          country,
          crowdSize: 30,          // Start with 30% crowd
          crowdVibe: 'chill',
        },
      });

      return {
        success: true,
        message: this.localize(
          language,
          '🎉 Nachtclub geopend! Huur een DJ en beveiliging om het draaiende te houden.',
          '🎉 Nightclub opened! Hire a DJ and security to keep it running.'
        ),
        newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
      };
    } catch (err) {
      const language = await this.getPlayerLanguage(playerId);
      return {
        success: false,
        message: this.localize(
          language,
          `Fout bij setup: ${(err as any).message}`,
          `Setup error: ${(err as any).message}`
        ),
      };
    }
  }

  async getPlayerVenues(playerId: number): Promise<any[]> {
    const venues = await prisma.nightclubVenue.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
    });

    return venues.map((v) => ({
      id: v.id,
      propertyId: v.propertyId,
      country: v.country,
      isOpen: v.isOpen,
      crowdSize: v.crowdSize,
      crowdVibe: v.crowdVibe,
      totalRevenueAllTime: Number(v.totalRevenueAllTime ?? 0),
      currentDJId: v.currentDJId,
      djContractEndsAt: v.djContractEndsAt,
    }));
  }

  async getPlayerCountry(playerId: number): Promise<string | null> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    return player?.currentCountry ?? null;
  }

  async setupNightclubForProperty(
    playerId: number,
    propertyId: number
  ): Promise<{ success: boolean; message: string; venueId?: number; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const property = await prisma.property.findUnique({
      where: { id: propertyId },
      select: { id: true, playerId: true, countryId: true, propertyType: true },
    });

    if (!property || property.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Eigendom niet gevonden', 'Property not found') };
    }

    if (property.propertyType !== 'nightclub') {
      return {
        success: false,
        message: this.localize(language, 'Dit eigendom is geen nachtclub', 'This property is not a nightclub'),
      };
    }

    const existing = await prisma.nightclubVenue.findUnique({
      where: { propertyId: property.id },
      select: { id: true },
    });

    if (existing) {
      return {
        success: true,
        message: this.localize(language, 'Nachtclub was al actief', 'Nightclub was already active'),
        venueId: existing.id,
      };
    }

    const venue = await prisma.nightclubVenue.create({
      data: {
        propertyId: property.id,
        playerId,
        country: property.countryId,
        crowdSize: 30,
        crowdVibe: 'chill',
      },
      select: { id: true },
    });

    return {
      success: true,
      message: this.localize(language, 'Nachtclub geactiveerd', 'Nightclub activated'),
      venueId: venue.id,
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // DJ MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Get all available DJs
   */
  async getAvailableDJs(): Promise<any[]> {
    const djs = await prisma.nightclubDJ.findMany({
      where: { isAvailable: true },
      orderBy: { skillLevel: 'desc' },
    });

    return djs.map((dj) => ({
      id: dj.id,
      name: dj.djName,
      skillLevel: dj.skillLevel,
      specialty: dj.specialty,
      costPerHour: dj.baseCostPerHour,
      costPerDay: dj.baseCostPerHour * 8,
      costPerWeek: dj.baseCostPerHour * 8 * 7,
      reputation: dj.reputation,
      crowdBoostMultiplier: 0.8 + dj.skillLevel * 0.15,  // 1.0-1.75x boost
      image: dj.profileImage,
    }));
  }

  /**
   * Hire a DJ for a shift
   */
  async hireDJ(
    playerId: number,
    venueId: number,
    djId: number,
    hoursCount: number,
    djStartsAt: Date
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue || venue.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found') };
    }

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) return { success: false, message: this.localize(language, 'Speler niet gevonden', 'Player not found') };

    const dj = await prisma.nightclubDJ.findUnique({ where: { id: djId } });
    if (!dj) return { success: false, message: this.localize(language, 'DJ niet gevonden', 'DJ not found') };

    // Check if player already has DJ booked
    if (venue.currentDJId) {
      return {
        success: false,
        message: this.localize(
          language,
          'Je hebt al een DJ geboekt. Wacht totdat zijn shift afloopt.',
          'You already have a DJ booked. Wait until the current shift ends.'
        ),
      };
    }

    const totalCost = dj.baseCostPerHour * hoursCount;

    if (player.money < totalCost) {
      return {
        success: false,
        message: this.localize(
          language,
          `DJ kost €${totalCost.toLocaleString()} voor ${hoursCount}u. Je hebt genoeg geld nodig.`,
          `DJ costs €${totalCost.toLocaleString()} for ${hoursCount}h. You need enough cash.`
        ),
      };
    }

    const shiftEndsAt = new Date(djStartsAt.getTime() + hoursCount * 60 * 60 * 1000);

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: totalCost } },
      }),
      prisma.nightclubVenue.update({
        where: { id: venueId },
        data: {
          currentDJId: djId,
          djContractStartsAt: djStartsAt,
          djContractEndsAt: shiftEndsAt,
        },
      }),
      prisma.nightclubDJShift.create({
        data: {
          venueId,
          djId,
          shiftStartAt: djStartsAt,
          shiftEndAt: shiftEndsAt,
          costPaid: totalCost,
          crowdBoost: 0.8 + dj.skillLevel * 0.15,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `🎧 ${dj.djName} ingehuurd voor ${hoursCount}u. Shift start om ${djStartsAt.toLocaleTimeString('nl-NL')}.`,
        `🎧 ${dj.djName} hired for ${hoursCount}h. Shift starts at ${djStartsAt.toLocaleTimeString('en-US')}.`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // SECURITY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Get all available security guards
   */
  async getAvailableSecurityGuards(): Promise<any[]> {
    const guards = await prisma.nightclubSecurity.findMany({
      where: { isAvailable: true },
      orderBy: { skillLevel: 'desc' },
    });

    return guards.map((guard) => ({
      id: guard.id,
      name: guard.guardName,
      skillLevel: guard.skillLevel,
      specialty: guard.specialty,
      costPerHour: guard.baseCostPerHour,
      costPerShift: guard.baseCostPerHour * 8,  // Night shift (20:00-04:00)
      reputation: guard.reputation,
      theftReductionPercentage: guard.skillLevel * 15 + 20,  // 35%-95%
      image: guard.profileImage,
    }));
  }

  /**
   * Hire security for a night shift (20:00-04:00)
   */
  async hireSecurityGuard(
    playerId: number,
    venueId: number,
    guardId: number,
    shiftDate: Date
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue || venue.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found') };
    }

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) return { success: false, message: this.localize(language, 'Speler niet gevonden', 'Player not found') };

    const guard = await prisma.nightclubSecurity.findUnique({ where: { id: guardId } });
    if (!guard) return { success: false, message: this.localize(language, 'Beveiliging niet gevonden', 'Security guard not found') };

    const costPerShift = guard.baseCostPerHour * 8;  // 8 hours

    if (player.money < costPerShift) {
      return {
        success: false,
        message: this.localize(
          language,
          `Beveiliging kost €${costPerShift.toLocaleString()} per nacht. Je hebt genoeg geld nodig.`,
          `Security costs €${costPerShift.toLocaleString()} per night. You need enough cash.`
        ),
      };
    }

    // Start shift at 20:00, end at 04:00
    const shiftStart = new Date(shiftDate);
    shiftStart.setHours(20, 0, 0, 0);
    const shiftEnd = new Date(shiftStart);
    shiftEnd.setHours(28, 0, 0, 0);  // 04:00 next day

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: costPerShift } },
      }),
      prisma.nightclubSecurityShift.create({
        data: {
          venueId,
          guardId,
          shiftStartAt: shiftStart,
          shiftEndAt: shiftEnd,
          costPaid: costPerShift,
          theftReduction: (guard.skillLevel * 0.15 + 0.35),  // 0.35-0.95
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `🛡️ ${guard.guardName} ingepland van ${shiftStart.toLocaleTimeString('nl-NL')} tot ${shiftEnd.toLocaleTimeString('nl-NL')}.`,
        `🛡️ ${guard.guardName} scheduled from ${shiftStart.toLocaleTimeString('en-US')} to ${shiftEnd.toLocaleTimeString('en-US')}.`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CROWD MANAGEMENT & DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Calculate current crowd state based on DJ, security, time, and events
   */
  private async calculateCrowdState(venueId: number): Promise<CrowdState> {
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      include: {
        currentDJ: true,
        djShifts: {
          where: {
            shiftStartAt: { lte: new Date() },
            shiftEndAt: { gte: new Date() },
          },
          take: 1,
        },
        securityShifts: {
          where: {
            shiftStartAt: { lte: new Date() },
            shiftEndAt: { gte: new Date() },
          },
          take: 1,
        },
        events: {
          where: {
            startsAt: { lte: new Date() },
            endsAt: { gte: new Date() },
          },
          take: 1,
        },
      },
    });

    if (!venue) throw new Error('Venue not found');

    let size = venue.crowdSize;
    let vibe: 'chill' | 'normal' | 'wild' | 'raging' = venue.crowdVibe as any;

    // DJ effect
    if (venue.djShifts.length > 0) {
      const djShift = venue.djShifts[0];
      size = Math.min(100, size + 20);  // DJ adds 20% crowd
      vibe = this.improveVibe(vibe);
    }

    // Event effect
    if (venue.events.length > 0) {
      size = Math.min(100, size + 15);
      vibe = this.improveVibe(vibe);
    }

    // Time of day effect (peak hours 22:00-02:00)
    const hour = new Date().getHours();
    if (hour >= 22 || hour < 2) {
      size = Math.min(100, size + 5);
    }

    // Decay without DJ
    if (venue.djShifts.length === 0) {
      size = Math.max(10, size - this.BASE_CROWD_DECAY_RATE);
      vibe = this.degradeVibe(vibe);
    }

    // Drug demand based on vibe
    const demand: { [key: string]: number } = {};
    if (vibe === 'raging') {
      demand['cocaine'] = 0.8;
      demand['mdma'] = 0.9;
      demand['meth'] = 0.6;
      demand['weed'] = 0.3;
    } else if (vibe === 'wild') {
      demand['cocaine'] = 0.6;
      demand['mdma'] = 0.7;
      demand['weed'] = 0.5;
      demand['magic_mushrooms'] = 0.4;
    } else if (vibe === 'normal') {
      demand['weed'] = 0.6;
      demand['cocaine'] = 0.3;
      demand['mdma'] = 0.4;
    } else {
      demand['weed'] = 0.4;
      demand['alcohol'] = 0.5;
    }

    return { size, vibe, demand };
  }

  private improveVibe(vibe: string): 'chill' | 'normal' | 'wild' | 'raging' {
    const sequence = ['chill', 'normal', 'wild', 'raging'];
    const next = sequence.indexOf(vibe) + 1;
    return (sequence[Math.min(next, 3)] as any) || 'raging';
  }

  private degradeVibe(vibe: string): 'chill' | 'normal' | 'wild' | 'raging' {
    const sequence = ['chill', 'normal', 'wild', 'raging'];
    const prev = sequence.indexOf(vibe) - 1;
    return (sequence[Math.max(prev, 0)] as any) || 'chill';
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // DRUG SALES ENGINE (Automatic)
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Process automatic drug sales every minute
   * Called by a background job or cron
   */
  async processAutomagicSales(): Promise<void> {
    const venues = await prisma.nightclubVenue.findMany({
      where: { isOpen: true },
      include: {
        inventory: true,
      },
    });

    for (const venue of venues) {
      await this.generateRandomSales(venue.id);
    }
  }

 /**
   * Generate random drug sales for a venue
   */
  private async generateRandomSales(venueId: number): Promise<void> {
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue) return;

    const venueInventory = await prisma.nightclubDrugInventory.findMany({
      where: {
        venueId,
        quantity: { gt: 0 },
      },
    });

    if (venueInventory.length === 0) return;

    const crowdState = await this.calculateCrowdState(venueId);
    const securityReduction = await this.getCurrentSecurityReduction(venueId);
    const staffingLimits = await this.getStaffingLimits(venue.playerId);
    const prostitutionBoost = await this.getActiveProstituteBoost(
      venueId,
      crowdState.vibe,
      securityReduction,
      staffingLimits.isVipActive
    );
    const numBuyers = Math.floor((crowdState.size / 10) * prostitutionBoost.salesBoost);  // ~10% of crowd buys

    for (let i = 0; i < numBuyers; i++) {
      // Prefer in-demand drugs that are actually in stock.
      const demandedStockedTypes = Object.keys(crowdState.demand).filter(
        (dt) => crowdState.demand[dt] > Math.random() && venueInventory.some((inv) => inv.drugType === dt && inv.quantity > 0)
      );

      let drugType: string | null = null;
      if (demandedStockedTypes.length > 0) {
        drugType = demandedStockedTypes[Math.floor(Math.random() * demandedStockedTypes.length)];
      } else {
        // Fallback: some buyers still purchase from available stock even when current vibe-demand doesn't align.
        const stockedTypes = [...new Set(venueInventory.filter((inv) => inv.quantity > 0).map((inv) => inv.drugType))];
        if (stockedTypes.length === 0 || Math.random() > 0.35) continue;
        drugType = stockedTypes[Math.floor(Math.random() * stockedTypes.length)];
      }

      if (!drugType) continue;

      const candidateInventory = venueInventory.filter((inv) => inv.drugType === drugType && inv.quantity > 0);
      if (candidateInventory.length === 0) continue;
      const inventory = candidateInventory[Math.floor(Math.random() * candidateInventory.length)];

      // Sell from the actual stocked quality variant.
      const quality = inventory.quality;

      // Quantity: 0.5g - 3g
      const quantitySold = Math.min(inventory.quantity, Math.floor(Math.random() * 5) + 1);

      if (quantitySold <= 0) continue;

      // Price calculation:
      // Base margin + quality bonus + vibe bonus - theft risk
      const qualityMultipliers = { D: 1.0, C: 1.2, B: 1.5, A: 2.0, S: 2.8 };
      const vibeMultipliers = { chill: 0.9, normal: 1.0, wild: 1.3, raging: 1.6 };
      const margin =
        (qualityMultipliers[quality as keyof typeof qualityMultipliers] ?? 1) *
        (vibeMultipliers[crowdState.vibe] ?? 1);
      const unitPrice = Math.floor(inventory.basePrice * Math.min(this.MAX_MARGIN, Math.max(this.MIN_MARGIN, margin)));
      const boostedUnitPrice = Math.floor(unitPrice * prostitutionBoost.priceBoost);
      const totalRevenue = boostedUnitPrice * quantitySold;

      // Record the sale
      await prisma.$transaction([
        prisma.nightclubSale.create({
          data: {
            venueId,
            drugType,
            quality,
            quantitySold,
            unitPrice: boostedUnitPrice,
            totalRevenue,
            crowdSize: crowdState.size,
            crowdVibe: crowdState.vibe,
          },
        }),
        prisma.nightclubDrugInventory.update({
          where: { id: inventory.id },
          data: { quantity: { decrement: quantitySold } },
        }),
        prisma.nightclubVenue.update({
          where: { id: venueId },
          data: {
            totalRevenueAllTime: { increment: totalRevenue },
            totalRevenuePeriod: { increment: totalRevenue },
          },
        }),
        // Add money to venue owner
        prisma.player.update({
          where: { id: venue.playerId },
          data: { money: { increment: totalRevenue } },
        }),
      ]);

      // Keep local inventory state in sync for this tick run.
      inventory.quantity -= quantitySold;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // THEFT & RISK SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Process potential thefts/robberies
   */
  async processTheftsAndRisks(): Promise<void> {
    const venues = await prisma.nightclubVenue.findMany({
      where: { isOpen: true },
      include: {
        inventory: true,
        securityShifts: {
          where: {
            shiftStartAt: { lte: new Date() },
            shiftEndAt: { gte: new Date() },
          },
          take: 1,
        },
      },
    });

    for (const venue of venues) {
      const crowdState = await this.calculateCrowdState(venue.id);
      const securityShift = venue.securityShifts[0];

      // Base theft chance: 15% per minute in raging environment
      let theftChance = 0.15 * (crowdState.size / 100);

      // Security reduces chance
      if (securityShift) {
        theftChance *= (1 - securityShift.theftReduction);
      }

      if (Math.random() < theftChance && venue.inventory.length > 0) {
        await this.executeTheft(venue.id, crowdState, securityShift?.theftReduction ?? 0);
      }
    }
  }

  /**
   * Execute a theft event
   */
  private async executeTheft(
    venueId: number,
    crowdState: CrowdState,
    securityReduction: number
  ): Promise<void> {
    const inventory = await prisma.nightclubDrugInventory.findMany({
      where: { venueId },
    });

    if (inventory.length === 0) return;

    // Random item to steal
    const stolen = inventory[Math.floor(Math.random() * inventory.length)];
    const quantity = Math.min(Math.floor(Math.random() * 10) + 1, stolen.quantity);

    const theftType = crowdState.size > 80 ? 'customer_theft' : 'employee_heist';
    const valueLost = quantity * stolen.basePrice;

    await prisma.$transaction([
      prisma.nightclubTheft.create({
        data: {
          venueId,
          theftType,
          drugType: stolen.drugType,
          quality: stolen.quality,
          quantityStolen: quantity,
          valueLost,
          preventionChance: securityReduction,
        },
      }),
      prisma.nightclubDrugInventory.update({
        where: { id: stolen.id },
        data: { quantity: { decrement: quantity } },
      }),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // DRUG STORAGE & TRANSFERS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Store drugs in nightclub from player inventory
   */
  async storeDrugsInNightclub(
    playerId: number,
    venueId: number,
    drugType: string,
    quality: string,
    quantity: number
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await prisma.nightclubVenue.findUnique({ where: { id: venueId } });
    if (!venue || venue.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found') };
    }

    const playerInventory = await prisma.drugInventory.findFirst({
      where: { playerId, drugType, quality },
    });

    if (!playerInventory || playerInventory.quantity < quantity) {
      return {
        success: false,
        message: this.localize(
          language,
          `Je hebt niet genoeg ${drugType} (${quality})`,
          `You do not have enough ${drugType} (${quality})`
        ),
      };
    }

    // Get base price from drug definition
    const basePrice = this.getDrugBasePrice(drugType);

    await prisma.$transaction([
      prisma.drugInventory.update({
        where: { id: playerInventory.id },
        data: { quantity: { decrement: quantity } },
      }),
      prisma.nightclubDrugInventory.upsert({
        where: { venueId_drugType_quality: { venueId, drugType, quality } },
        create: {
          venueId,
          drugType,
          quality,
          quantity,
          basePrice,
        },
        update: {
          quantity: { increment: quantity },
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `✅ ${quantity}g ${drugType} (${quality}) opgeslagen in je nightclub.`,
        `✅ ${quantity}g ${drugType} (${quality}) stored in your nightclub.`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  /**
   * Get venue statistics for UI
   */
  async getVenueStats(venueId: number): Promise<any> {
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      include: {
        inventory: true,
        djShifts: {
          orderBy: { shiftStartAt: 'desc' },
          take: 5,
          include: {
            dj: {
              select: {
                id: true,
                djName: true,
              },
            },
          },
        },
        securityShifts: {
          orderBy: { shiftStartAt: 'desc' },
          take: 5,
          include: {
            guard: {
              select: {
                id: true,
                guardName: true,
              },
            },
          },
        },
        sales: { orderBy: { saleTime: 'desc' }, take: 20 },
        thefts: { orderBy: { occurredAt: 'desc' }, take: 10 },
        events: { orderBy: { startsAt: 'desc' }, take: 5 },
        prostitutes: {
          where: { location: 'nightclub' },
          select: {
            id: true,
            name: true,
            level: true,
            variant: true,
            nightclubAssignedAt: true,
            isBusted: true,
            bustedUntil: true,
          },
        },
      },
    });

    if (!venue) return null;

    const crowdState = await this.calculateCrowdState(venueId);
    const securityReduction = await this.getCurrentSecurityReduction(venueId);
    const staffingLimits = await this.getStaffingLimits(venue.playerId);
    const prostitutionBoost = await this.getActiveProstituteBoost(
      venueId,
      crowdState.vibe,
      securityReduction,
      staffingLimits.isVipActive
    );
    const assignmentHistoryRaw = await prisma.nightclubProstituteAssignment.findMany({
      where: { venueId },
      orderBy: [{ assignedAt: 'desc' }, { id: 'desc' }],
      take: 20,
      select: {
        id: true,
        assignedAt: true,
        releasedAt: true,
        isActive: true,
        prostitute: {
          select: {
            id: true,
            name: true,
            level: true,
            variant: true,
          },
        },
      },
    });

    const assignmentHistory = await Promise.all(
      assignmentHistoryRaw.map(async (entry) => {
        const rangeEnd = entry.releasedAt ?? new Date();
        const revenueAgg = await prisma.nightclubSale.aggregate({
          where: {
            venueId,
            saleTime: {
              gte: entry.assignedAt,
              lte: rangeEnd,
            },
          },
          _sum: { totalRevenue: true },
          _count: { _all: true },
        });

        const estimatedRevenue = revenueAgg._sum.totalRevenue ?? 0;
        const estimatedSalesCount = revenueAgg._count._all ?? 0;

        return {
          ...entry,
          estimatedRevenue,
          estimatedSalesCount,
          estimatedAvgSaleRevenue: estimatedSalesCount > 0 ? Math.floor(estimatedRevenue / estimatedSalesCount) : 0,
        };
      })
    );

    const countryLeaderboardPreview = await this.getTopNightclubs(5, venue.country);
    const totalInventoryValue = venue.inventory.reduce((sum, item) => sum + item.quantity * item.basePrice, 0);
    const salesToday = venue.sales.filter(
      (s) => new Date(s.saleTime).toDateString() === new Date().toDateString()
    );
    const revenuesToday = salesToday.reduce((sum, s) => sum + s.totalRevenue, 0);
    const now = new Date();
    const activeDjShift =
      venue.djShifts.find((shift) => shift.shiftStartAt <= now && shift.shiftEndAt >= now) ??
      venue.djShifts.find((shift) => shift.shiftEndAt >= now) ??
      null;
    const activeSecurityShift =
      venue.securityShifts.find((shift) => shift.shiftStartAt <= now && shift.shiftEndAt >= now) ??
      venue.securityShifts.find((shift) => shift.shiftEndAt >= now) ??
      null;

    return {
      id: venue.id,
      crowdSize: crowdState.size,
      crowdVibe: crowdState.vibe,
      isOpen: venue.isOpen,
      inventoryValue: totalInventoryValue,
      itemsInStock: venue.inventory.length,
      revenueAllTime: Number(venue.totalRevenueAllTime ?? 0),
      revenueToday: revenuesToday,
      lastUpdate: venue.lastUpdateAt,
      djActive: venue.currentDJId != null,
      djHoursRemaining: venue.djContractEndsAt
        ? Math.max(0, Math.floor((venue.djContractEndsAt.getTime() - Date.now()) / 3600000))
        : 0,
      djShifts: venue.djShifts,
      securityShifts: venue.securityShifts,
      activeDj: activeDjShift
        ? {
            djId: activeDjShift.djId,
            djName: activeDjShift.dj?.djName ?? null,
            shiftStartAt: activeDjShift.shiftStartAt,
            shiftEndAt: activeDjShift.shiftEndAt,
          }
        : null,
      activeSecurity: activeSecurityShift
        ? {
            guardId: activeSecurityShift.guardId,
            guardName: activeSecurityShift.guard?.guardName ?? null,
            shiftStartAt: activeSecurityShift.shiftStartAt,
            shiftEndAt: activeSecurityShift.shiftEndAt,
          }
        : null,
      inventory: venue.inventory,
      recentSales: salesToday.slice(0, 10),
      thefts: venue.thefts.slice(0, 5),
      prostitution: {
        assignedCount: prostitutionBoost.assignedCount,
        vipAssignedCount: prostitutionBoost.vipAssignedCount,
        staffCap: staffingLimits.staffCap,
        countryBaseCap: staffingLimits.countryBaseCap,
        isVipBoostActive: staffingLimits.isVipActive,
        avgLevel: Number(prostitutionBoost.avgLevel.toFixed(2)),
        salesBoost: Number(prostitutionBoost.salesBoost.toFixed(2)),
        priceBoost: Number(prostitutionBoost.priceBoost.toFixed(2)),
        vibeFactor: Number(prostitutionBoost.vibeFactor.toFixed(2)),
        securityFactor: Number(prostitutionBoost.securityFactor.toFixed(2)),
        vipFactor: Number(prostitutionBoost.vipFactor.toFixed(2)),
        vipStaffFactor: Number(prostitutionBoost.vipStaffFactor.toFixed(2)),
        staff: venue.prostitutes,
        history: assignmentHistory,
      },
      leaderboardPreview: countryLeaderboardPreview,
    };
  }

  async getTopNightclubs(limit = 10, country?: string): Promise<any[]> {
    const venues = await prisma.nightclubVenue.findMany({
      where: country ? { country } : undefined,
      include: {
        player: {
          select: {
            id: true,
            username: true,
            rank: true,
          },
        },
        sales: {
          where: {
            saleTime: {
              gte: new Date(Date.now() - 24 * 60 * 60 * 1000),
            },
          },
          select: {
            totalRevenue: true,
          },
        },
      },
      take: Math.max(1, Math.min(limit, 50)),
      orderBy: {
        totalRevenueAllTime: 'desc',
      },
    });

    const withScore = await Promise.all(
      venues.map(async (venue) => {
        const revenue24h = venue.sales.reduce((sum, sale) => sum + sale.totalRevenue, 0);
        const staffCount = await prisma.prostitute.count({
          where: {
            nightclubVenueId: venue.id,
            location: 'nightclub',
            isBusted: false,
          },
        });

        const score = Math.round(
          revenue24h * 1.4 +
          Number(venue.totalRevenueAllTime) * 0.12 +
          venue.crowdSize * 120 +
          staffCount * 300
        );

        return {
          venueId: venue.id,
          country: venue.country,
          ownerId: venue.playerId,
          ownerUsername: venue.player?.username ?? 'unknown',
          ownerRank: venue.player?.rank ?? 1,
          crowdSize: venue.crowdSize,
          crowdVibe: venue.crowdVibe,
          staffCount,
          revenue24h,
          revenueAllTime: Number(venue.totalRevenueAllTime),
          score,
        };
      })
    );

    return withScore
      .sort((a, b) => b.score - a.score)
      .slice(0, Math.max(1, Math.min(limit, 50)))
      .map((entry, index) => ({
        rank: index + 1,
        ...entry,
      }));
  }

  async getAssignableProstitutes(playerId: number, venueId: number): Promise<any[]> {
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      select: { id: true, playerId: true },
    });

    if (!venue || venue.playerId !== playerId) {
      return [];
    }

    const prostitutes = await prisma.prostitute.findMany({
      where: {
        playerId,
        isBusted: false,
        location: 'street',
      },
      orderBy: [{ location: 'asc' }, { level: 'desc' }, { recruitedAt: 'desc' }],
      select: {
        id: true,
        name: true,
        level: true,
        variant: true,
        location: true,
        nightclubVenueId: true,
        nightclubAssignedAt: true,
      },
    });

    return prostitutes;
  }

  async assignProstituteToVenue(
    playerId: number,
    venueId: number,
    prostituteId: number
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      select: { id: true, playerId: true },
    });

    if (!venue || venue.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found') };
    }

    const prostitute = await prisma.prostitute.findFirst({
      where: { id: prostituteId, playerId },
      select: {
        id: true,
        name: true,
        location: true,
        redLightRoomId: true,
        nightclubVenueId: true,
        isBusted: true,
        bustedUntil: true,
      },
    });

    if (!prostitute) {
      return { success: false, message: this.localize(language, 'Prostituee niet gevonden', 'Crew member not found') };
    }

    if (prostitute.isBusted && prostitute.bustedUntil && prostitute.bustedUntil > new Date()) {
      return {
        success: false,
        message: this.localize(
          language,
          'Deze prostituee is tijdelijk busted en niet inzetbaar',
          'This crew member is temporarily busted and cannot be assigned'
        ),
      };
    }

    if (prostitute.location === 'redlight' || prostitute.redLightRoomId) {
      return {
        success: false,
        message: this.localize(
          language,
          'Prostituees in Red Light District kun je niet naar de nachtclub verplaatsen',
          'Crew members in a Red Light District cannot be moved to the nightclub'
        ),
      };
    }

    if (prostitute.location === 'nightclub' && prostitute.nightclubVenueId === venueId) {
      return {
        success: true,
        message: this.localize(
          language,
          `${prostitute.name} werkt al in deze nachtclub`,
          `${prostitute.name} is already working in this nightclub`
        ),
      };
    }

    const staffingLimits = await this.getStaffingLimits(playerId);
    const activeStaffCount = await prisma.prostitute.count({
      where: {
        playerId,
        location: 'nightclub',
        nightclubVenueId: venueId,
      },
    });

    if (activeStaffCount >= staffingLimits.staffCap) {
      return {
        success: false,
        message: this.localize(
          language,
          `Maximaal ${staffingLimits.staffCap} nightclub staff bereikt${staffingLimits.isVipActive ? ' (VIP limiet)' : ' voor dit land'}`,
          `Maximum nightclub staff of ${staffingLimits.staffCap} reached${staffingLimits.isVipActive ? ' (VIP limit)' : ' for this country'}`
        ),
      };
    }

    if (prostitute.location === 'nightclub' && prostitute.nightclubVenueId && prostitute.nightclubVenueId !== venueId) {
      return {
        success: false,
        message: this.localize(
          language,
          'Deze prostituee werkt al in een andere nachtclub',
          'This crew member is already working in another nightclub'
        ),
      };
    }

    await prisma.$transaction([
      prisma.prostitute.update({
        where: { id: prostituteId },
        data: {
          location: 'nightclub',
          nightclubVenueId: venueId,
          nightclubAssignedAt: new Date(),
          lastEarningsAt: new Date(),
        },
      }),
      prisma.nightclubProstituteAssignment.create({
        data: {
          playerId,
          venueId,
          prostituteId,
          isActive: true,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `${prostitute.name} toegewezen aan je nightclub crew`,
        `${prostitute.name} assigned to your nightclub crew`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  async unassignProstituteFromVenue(
    playerId: number,
    venueId: number,
    prostituteId: number
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      select: { id: true, playerId: true },
    });

    if (!venue || venue.playerId !== playerId) {
      return { success: false, message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found') };
    }

    const prostitute = await prisma.prostitute.findFirst({
      where: {
        id: prostituteId,
        playerId,
        location: 'nightclub',
        nightclubVenueId: venueId,
      },
      select: { id: true, name: true },
    });

    if (!prostitute) {
      return {
        success: false,
        message: this.localize(
          language,
          'Deze prostituee werkt niet in deze nachtclub',
          'This crew member is not working in this nightclub'
        ),
      };
    }

    await prisma.$transaction([
      prisma.prostitute.update({
        where: { id: prostituteId },
        data: {
          location: 'street',
          nightclubVenueId: null,
          nightclubAssignedAt: null,
          lastEarningsAt: new Date(),
        },
      }),
      prisma.nightclubProstituteAssignment.updateMany({
        where: {
          playerId,
          venueId,
          prostituteId,
          isActive: true,
        },
        data: {
          isActive: false,
          releasedAt: new Date(),
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `${prostitute.name} terug naar de straat gestuurd`,
        `${prostitute.name} sent back to the street`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  private getDrugBasePrice(drugType: string): number {
    const prices: { [key: string]: number } = {
      weed: 50,
      cocaine: 150,
      mdma: 120,
      meth: 180,
      magic_mushrooms: 90,
      heroin: 200,
    };
    return prices[drugType] || 100;
  }
}

export default new NightclubService();
