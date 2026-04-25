import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { activityService } from './activityService';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';
import { translationService } from './translationService';

interface CrowdState {
  size: number; // 0-100 (percentage)
  vibe: 'chill' | 'normal' | 'wild' | 'raging';
  demand: { [drugType: string]: number }; // Drug demand based on vibe
}

interface DJConfig {
  id: number;
  djName: string;
  skillLevel: number;
  baseCostPerHour: number;
  crowdBoost: number; // 1.0 = no effect, 1.5 = 50% better
  vibeShift?: 'chill' | 'normal' | 'wild';
}

const DEFAULT_NIGHTCLUB_DJS = [
  {
    djName: 'DJ Voltage',
    skillLevel: 2,
    baseCostPerHour: 6000,
    reputation: 0.55,
    isAvailable: true,
    profileImage: null,
    specialty: 'house',
  },
  {
    djName: 'Mister Midnight',
    skillLevel: 3,
    baseCostPerHour: 9000,
    reputation: 0.68,
    isAvailable: true,
    profileImage: null,
    specialty: 'techno',
  },
  {
    djName: 'Neon Rosa',
    skillLevel: 4,
    baseCostPerHour: 13000,
    reputation: 0.8,
    isAvailable: true,
    profileImage: null,
    specialty: 'latin',
  },
  {
    djName: 'Cobra Beats',
    skillLevel: 5,
    baseCostPerHour: 18000,
    reputation: 0.94,
    isAvailable: true,
    profileImage: null,
    specialty: 'festival',
  },
] as const;

const DEFAULT_NIGHTCLUB_SECURITY_GUARDS = [
  {
    guardName: 'Brick Malone',
    skillLevel: 2,
    baseCostPerHour: 3500,
    reputation: 0.56,
    isAvailable: true,
    profileImage: null,
    specialty: 'door',
  },
  {
    guardName: 'Vera Lock',
    skillLevel: 3,
    baseCostPerHour: 5000,
    reputation: 0.69,
    isAvailable: true,
    profileImage: null,
    specialty: 'vip',
  },
  {
    guardName: 'Titan Noor',
    skillLevel: 4,
    baseCostPerHour: 7000,
    reputation: 0.82,
    isAvailable: true,
    profileImage: null,
    specialty: 'anti-theft',
  },
  {
    guardName: 'Helix Stone',
    skillLevel: 5,
    baseCostPerHour: 9500,
    reputation: 0.95,
    isAvailable: true,
    profileImage: null,
    specialty: 'tactical',
  },
] as const;

let nightclubStaffSeedPromise: Promise<void> | null = null;

class NightclubService {
  private readonly BASE_CROWD_REGEN_RATE = 2; // 2% per minute
  private readonly BASE_CROWD_DECAY_RATE = 1; // 1% per minute
  private readonly MIN_MARGIN = 0.8; // 80% margin without markup
  private readonly MAX_MARGIN = 3.0; // 300% margin with high quality/vibe
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
  private readonly RESIDENT_CONTRACT_DISCOUNT = 0.12;
  private readonly UPGRADE_EVENT_PREFIX = 'upgrade_';
  private readonly SUPPLIER_EVENT_PREFIX = 'supplier_contract_';
  private readonly PROMOTER_EVENT_PREFIX = 'promoter_profile_';
  private readonly HEAT_EVENT_PREFIX = 'heat_cooldown_';
  private readonly SMUGGLING_EVENT_PREFIX = 'smuggling_route_';
  private readonly COUNTER_INTEL_EVENT_PREFIX = 'counter_intel_';
  private readonly UPGRADE_COSTS: Record<'sound_rig' | 'vip_lounge' | 'surveillance', number[]> = {
    sound_rig: [60000, 125000, 240000],
    vip_lounge: [85000, 165000, 300000],
    surveillance: [70000, 145000, 270000],
  };
  private readonly SUPPLIER_CONTRACTS: Record<
    'street' | 'cartel' | 'clean',
    { nl: string; en: string; durationHours: number; cost: number; reliability: number; stockBoost: number }
  > = {
    street: {
      nl: 'Street Connect',
      en: 'Street Connect',
      durationHours: 48,
      cost: 55000,
      reliability: 0.62,
      stockBoost: 12,
    },
    cartel: {
      nl: 'Cartel Pipeline',
      en: 'Cartel Pipeline',
      durationHours: 72,
      cost: 110000,
      reliability: 0.86,
      stockBoost: 26,
    },
    clean: {
      nl: 'Clean Front Supplier',
      en: 'Clean Front Supplier',
      durationHours: 60,
      cost: 85000,
      reliability: 0.76,
      stockBoost: 18,
    },
  };
  private readonly PROMOTER_PROFILES: Record<
    'street_hype' | 'vip_whisper' | 'tourist_hunter',
    { nl: string; en: string; durationHours: number; cost: number; crowdBoost: number; spendBoost: number }
  > = {
    street_hype: {
      nl: 'Street Hype Team',
      en: 'Street Hype Team',
      durationHours: 24,
      cost: 45000,
      crowdBoost: 8,
      spendBoost: 0.04,
    },
    vip_whisper: {
      nl: 'VIP Whisper Circle',
      en: 'VIP Whisper Circle',
      durationHours: 24,
      cost: 70000,
      crowdBoost: 5,
      spendBoost: 0.12,
    },
    tourist_hunter: {
      nl: 'Tourist Hunter Crew',
      en: 'Tourist Hunter Crew',
      durationHours: 24,
      cost: 52000,
      crowdBoost: 6,
      spendBoost: 0.06,
    },
  };
  private readonly SMUGGLING_ROUTES: Record<
    'harbor' | 'airstrip' | 'borderline',
    {
      nl: string;
      en: string;
      cost: number;
      risk: number;
      minGrams: number;
      maxGrams: number;
      quality: 'C' | 'B' | 'A';
    }
  > = {
    harbor: {
      nl: 'Harbor run',
      en: 'Harbor run',
      cost: 60000,
      risk: 0.22,
      minGrams: 45,
      maxGrams: 110,
      quality: 'C',
    },
    airstrip: {
      nl: 'Airstrip drop',
      en: 'Airstrip drop',
      cost: 95000,
      risk: 0.35,
      minGrams: 70,
      maxGrams: 160,
      quality: 'B',
    },
    borderline: {
      nl: 'Borderline convoy',
      en: 'Borderline convoy',
      cost: 130000,
      risk: 0.44,
      minGrams: 100,
      maxGrams: 220,
      quality: 'A',
    },
  };

  private readonly EVENT_TEMPLATES: Record<
    string,
    { nl: string; en: string; hours: number; investment: number; expectedVisitors: number }
  > = {
    deep_house_night: {
      nl: 'Deep House Night',
      en: 'Deep House Night',
      hours: 6,
      investment: 40000,
      expectedVisitors: 18,
    },
    vip_gala: {
      nl: 'VIP Gala',
      en: 'VIP Gala',
      hours: 8,
      investment: 90000,
      expectedVisitors: 35,
    },
    street_takeover: {
      nl: 'Street Takeover',
      en: 'Street Takeover',
      hours: 5,
      investment: 55000,
      expectedVisitors: 24,
    },
  };

  private async ensureStaffSeedData(): Promise<void> {
    if (nightclubStaffSeedPromise) {
      await nightclubStaffSeedPromise;
      return;
    }

    nightclubStaffSeedPromise = (async () => {
      const [djCount, securityCount] = await Promise.all([
        prisma.nightclubDJ.count(),
        prisma.nightclubSecurity.count(),
      ]);

      if (djCount === 0) {
        await prisma.nightclubDJ.createMany({
          data: [...DEFAULT_NIGHTCLUB_DJS],
        });
      }

      if (securityCount === 0) {
        await prisma.nightclubSecurity.createMany({
          data: [...DEFAULT_NIGHTCLUB_SECURITY_GUARDS],
        });
      }
    })();

    try {
      await nightclubStaffSeedPromise;
    } finally {
      nightclubStaffSeedPromise = null;
    }
  }

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
  ): Promise<
    Array<{
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
    }>
  > {
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

    const winners: Array<{
      rank: number;
      playerId: number;
      venueId: number;
      rewardAmount: number;
    }> = [];

    if (existingRewards === 0) {
      const leaderboard = await this.buildSeasonLeaderboard(
        state.seasonStartAt,
        state.seasonEndAt,
        10
      );

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

    const [currentLeaderboard, rewardHistory, playerRewardsTotal, latestPlayerReward] =
      await Promise.all([
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

  private async clearExpiredDjContract(venueId: number): Promise<void> {
    await prisma.nightclubVenue.updateMany({
      where: {
        id: venueId,
        currentDJId: { not: null },
        djContractEndsAt: { lt: new Date() },
      },
      data: {
        currentDJId: null,
        djContractStartsAt: null,
        djContractEndsAt: null,
      },
    });
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

  private async getOwnedVenueOrNull(playerId: number, venueId: number) {
    const venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
      select: {
        id: true,
        playerId: true,
        country: true,
        crowdSize: true,
        crowdVibe: true,
        currentDJId: true,
        djContractEndsAt: true,
        totalRevenueAllTime: true,
        marketingSpend: true,
      },
    });
    if (!venue || venue.playerId !== playerId) return null;
    return venue;
  }

  private async getVenueUpgradeLevels(venueId: number): Promise<{
    sound_rig: number;
    vip_lounge: number;
    surveillance: number;
  }> {
    const events = await prisma.nightclubEvent.findMany({
      where: {
        venueId,
        eventType: {
          in: [
            `${this.UPGRADE_EVENT_PREFIX}sound_rig`,
            `${this.UPGRADE_EVENT_PREFIX}vip_lounge`,
            `${this.UPGRADE_EVENT_PREFIX}surveillance`,
          ],
        },
      },
      select: { eventType: true },
    });

    const levels = {
      sound_rig: 0,
      vip_lounge: 0,
      surveillance: 0,
    };

    for (const row of events) {
      if (row.eventType === `${this.UPGRADE_EVENT_PREFIX}sound_rig`) levels.sound_rig += 1;
      if (row.eventType === `${this.UPGRADE_EVENT_PREFIX}vip_lounge`) levels.vip_lounge += 1;
      if (row.eventType === `${this.UPGRADE_EVENT_PREFIX}surveillance`) levels.surveillance += 1;
    }

    return {
      sound_rig: Math.min(3, levels.sound_rig),
      vip_lounge: Math.min(3, levels.vip_lounge),
      surveillance: Math.min(3, levels.surveillance),
    };
  }

  private buildUpgradeSnapshot(input: {
    levels: {
      sound_rig: number;
      vip_lounge: number;
      surveillance: number;
    };
    staffAssigned: number;
    staffCap: number;
  }) {
    const soundLevel = Math.max(1, Math.min(3, input.levels.sound_rig || 1));
    const vipLoungeLevel = Math.max(1, Math.min(3, input.levels.vip_lounge || 1));
    const surveillanceLevel = Math.max(1, Math.min(3, input.levels.surveillance || 1));

    const soundNextCost =
      soundLevel >= 3 ? null : this.UPGRADE_COSTS.sound_rig[Math.max(0, soundLevel - 1)];
    const vipNextCost =
      vipLoungeLevel >= 3 ? null : this.UPGRADE_COSTS.vip_lounge[Math.max(0, vipLoungeLevel - 1)];
    const surveillanceNextCost =
      surveillanceLevel >= 3
        ? null
        : this.UPGRADE_COSTS.surveillance[Math.max(0, surveillanceLevel - 1)];

    return {
      soundRig: {
        level: soundLevel,
        key: 'sound_rig',
        nextCost: soundNextCost,
        effect: `+${(soundLevel * 6).toFixed(0)}% crowd stability`,
      },
      vipLounge: {
        level: vipLoungeLevel,
        key: 'vip_lounge',
        nextCost: vipNextCost,
        effect: `+${(vipLoungeLevel * 5).toFixed(0)}% high-spend visitors`,
      },
      surveillance: {
        level: surveillanceLevel,
        key: 'surveillance',
        nextCost: surveillanceNextCost,
        effect: `-${(surveillanceLevel * 7).toFixed(0)}% theft chance`,
      },
      staffing: {
        assigned: input.staffAssigned,
        cap: input.staffCap,
      },
    };
  }

  private buildOperationAlerts(input: {
    hasDj: boolean;
    djEndsAt: Date | null;
    inventoryItems: number;
    recentTheftsCount: number;
    crowdSize: number;
    staffAssigned: number;
    staffCap: number;
  }) {
    const now = Date.now();
    const alerts: Array<{
      key: string;
      severity: 'low' | 'medium' | 'high';
      message: string;
      quickAction: string;
    }> = [];

    if (!input.hasDj) {
      alerts.push({
        key: 'dj_missing',
        severity: 'high',
        message: 'Geen actieve DJ. Crowd en vibe zullen sneller dalen.',
        quickAction: 'hire_resident_dj',
      });
    } else if (input.djEndsAt && input.djEndsAt.getTime() - now < 2 * 60 * 60 * 1000) {
      alerts.push({
        key: 'dj_expiring',
        severity: 'medium',
        message: 'DJ-contract verloopt binnen 2 uur.',
        quickAction: 'extend_resident_dj',
      });
    }

    if (input.inventoryItems <= 0) {
      alerts.push({
        key: 'stock_empty',
        severity: 'high',
        message: 'Nightclub voorraad is leeg. Omzet valt stil.',
        quickAction: 'restock_drugs',
      });
    }

    if (input.recentTheftsCount >= 3) {
      alerts.push({
        key: 'theft_risk',
        severity: 'high',
        message: 'Meerdere recente diefstallen gedetecteerd.',
        quickAction: 'boost_security',
      });
    }

    if (input.staffCap > 0 && input.staffAssigned / input.staffCap >= 0.9) {
      alerts.push({
        key: 'staff_saturation',
        severity: 'medium',
        message: 'Personeel bijna volledig bezet. Morale-risico neemt toe.',
        quickAction: 'rotate_staff',
      });
    }

    if (input.crowdSize < 35) {
      alerts.push({
        key: 'low_crowd',
        severity: 'medium',
        message: 'Bezoekersaantal is laag; plan event of promotie.',
        quickAction: 'plan_event',
      });
    }

    return alerts;
  }

  private pickSeverity(value: number, lowCutoff: number, highCutoff: number): 'low' | 'medium' | 'high' {
    if (value >= highCutoff) return 'high';
    if (value >= lowCutoff) return 'medium';
    return 'low';
  }

  private buildDynamicCalendarSnapshot() {
    const day = new Date().getUTCDay();
    const themes = [
      { key: 'street_takeover', nl: 'Street Friday', en: 'Street Friday', demandBoostPct: 8 },
      { key: 'deep_house_night', nl: 'Deep Pulse', en: 'Deep Pulse', demandBoostPct: 6 },
      { key: 'vip_gala', nl: 'High Society', en: 'High Society', demandBoostPct: 10 },
      { key: 'deep_house_night', nl: 'Basement Echo', en: 'Basement Echo', demandBoostPct: 5 },
      { key: 'street_takeover', nl: 'Neon Run', en: 'Neon Run', demandBoostPct: 7 },
      { key: 'vip_gala', nl: 'Saturday Black', en: 'Saturday Black', demandBoostPct: 12 },
      { key: 'deep_house_night', nl: 'Recovery Set', en: 'Recovery Set', demandBoostPct: 4 },
    ];
    const today = themes[day];
    const tomorrow = themes[(day + 1) % themes.length];
    return {
      today,
      tomorrow,
      recommendedEventType: today.key,
      demandBoostPct: today.demandBoostPct,
    };
  }

  private buildStaffTraitsSnapshot(params: {
    assignedStaff: number;
    staffCap: number;
    morale: number;
    fatigue: number;
    crowdSize: number;
    recentTheftsCount: number;
  }) {
    const occupancy = params.staffCap > 0 ? params.assignedStaff / params.staffCap : 0;
    const traits = [
      {
        key: 'discipline',
        nl: occupancy > 0.85 ? 'Overwerkt team' : 'Gedisciplineerd team',
        en: occupancy > 0.85 ? 'Overworked team' : 'Disciplined team',
        effectNl: occupancy > 0.85 ? 'Meer fouten bij piekuren' : 'Snellere response op incidenten',
        effectEn: occupancy > 0.85 ? 'More mistakes during peak hours' : 'Faster incident responses',
      },
      {
        key: 'energy',
        nl: params.fatigue > 1.1 || params.morale < 0.9 ? 'Vermoeid ritme' : 'Hoge energie',
        en: params.fatigue > 1.1 || params.morale < 0.9 ? 'Fatigued rhythm' : 'High energy',
        effectNl:
          params.fatigue > 1.1 || params.morale < 0.9
            ? 'Lagere servicekwaliteit'
            : 'Betere crowd-retentie',
        effectEn:
          params.fatigue > 1.1 || params.morale < 0.9
            ? 'Lower service quality'
            : 'Improved crowd retention',
      },
      {
        key: 'street_pressure',
        nl: params.recentTheftsCount >= 2 ? 'Onder druk' : 'Stabiele vloer',
        en: params.recentTheftsCount >= 2 ? 'Under pressure' : 'Stable floor',
        effectNl: params.recentTheftsCount >= 2 ? 'Diefstalrisico stijgt' : 'Minder opportunistische thefts',
        effectEn: params.recentTheftsCount >= 2 ? 'Theft risk increases' : 'Fewer opportunistic thefts',
      },
      {
        key: 'crowd_handling',
        nl: params.crowdSize >= 75 ? 'Piekmodus' : 'Rustige flow',
        en: params.crowdSize >= 75 ? 'Peak mode' : 'Calm flow',
        effectNl: params.crowdSize >= 75 ? 'Hogere omzet maar hogere stress' : 'Lagere omzet, stabiele uitvoering',
        effectEn: params.crowdSize >= 75 ? 'Higher revenue but more stress' : 'Lower revenue, stable execution',
      },
    ];
    return traits;
  }

  private async buildOperationsTimeline(venueId: number) {
    const [sales, thefts, events, djShifts, securityShifts] = await Promise.all([
      prisma.nightclubSale.findMany({
        where: { venueId },
        orderBy: { saleTime: 'desc' },
        take: 6,
        select: { saleTime: true, totalRevenue: true, drugType: true, quality: true, quantitySold: true },
      }),
      prisma.nightclubTheft.findMany({
        where: { venueId },
        orderBy: { occurredAt: 'desc' },
        take: 4,
        select: { occurredAt: true, valueLost: true, theftType: true, drugType: true },
      }),
      prisma.nightclubEvent.findMany({
        where: { venueId },
        orderBy: { startsAt: 'desc' },
        take: 6,
        select: { startsAt: true, eventName: true, eventType: true, investment: true, expectedVisitors: true },
      }),
      prisma.nightclubDJShift.findMany({
        where: { venueId },
        orderBy: { shiftStartAt: 'desc' },
        take: 3,
        include: { dj: { select: { djName: true } } },
      }),
      prisma.nightclubSecurityShift.findMany({
        where: { venueId },
        orderBy: { shiftStartAt: 'desc' },
        take: 3,
        include: { guard: { select: { guardName: true } } },
      }),
    ]);

    const rows: Array<{
      at: Date;
      type: string;
      severity: 'low' | 'medium' | 'high';
      labelNl: string;
      labelEn: string;
      meta: Record<string, any>;
    }> = [];

    for (const sale of sales) {
      rows.push({
        at: sale.saleTime,
        type: 'sale',
        severity: this.pickSeverity(sale.totalRevenue, 600, 1800),
        labelNl: `Sale ${sale.drugType} (${sale.quality})`,
        labelEn: `Sale ${sale.drugType} (${sale.quality})`,
        meta: {
          revenue: sale.totalRevenue,
          grams: sale.quantitySold,
        },
      });
    }

    for (const theft of thefts) {
      rows.push({
        at: theft.occurredAt,
        type: 'theft',
        severity: this.pickSeverity(theft.valueLost, 1200, 4000),
        labelNl: `Incident: ${theft.theftType}`,
        labelEn: `Incident: ${theft.theftType}`,
        meta: {
          valueLost: theft.valueLost,
          drugType: theft.drugType,
        },
      });
    }

    for (const event of events) {
      rows.push({
        at: event.startsAt,
        type: 'event',
        severity: 'low',
        labelNl: `Event: ${event.eventName}`,
        labelEn: `Event: ${event.eventName}`,
        meta: {
          eventType: event.eventType,
          investment: event.investment,
          expectedVisitors: event.expectedVisitors,
        },
      });
    }

    for (const shift of djShifts) {
      rows.push({
        at: shift.shiftStartAt,
        type: 'dj_shift',
        severity: 'low',
        labelNl: `DJ shift gestart: ${shift.dj?.djName ?? 'DJ'}`,
        labelEn: `DJ shift started: ${shift.dj?.djName ?? 'DJ'}`,
        meta: {
          shiftEndAt: shift.shiftEndAt,
        },
      });
    }

    for (const shift of securityShifts) {
      rows.push({
        at: shift.shiftStartAt,
        type: 'security_shift',
        severity: 'low',
        labelNl: `Security actief: ${shift.guard?.guardName ?? 'Guard'}`,
        labelEn: `Security active: ${shift.guard?.guardName ?? 'Guard'}`,
        meta: {
          shiftEndAt: shift.shiftEndAt,
          theftReduction: shift.theftReduction,
        },
      });
    }

    return rows
      .sort((a, b) => b.at.getTime() - a.at.getTime())
      .slice(0, 16)
      .map((row) => ({
        ...row,
        at: row.at,
      }));
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
          crowdSize: 30, // Start with 30% crowd
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

    await Promise.all(venues.map((venue) => this.clearExpiredDjContract(venue.id)));

    const refreshedVenues = await prisma.nightclubVenue.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
    });

    return refreshedVenues.map((v) => ({
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
  ): Promise<{
    success: boolean;
    message: string;
    venueId?: number;
    newlyUnlockedAchievements?: any[];
  }> {
    const language = await this.getPlayerLanguage(playerId);
    const property = await prisma.property.findUnique({
      where: { id: propertyId },
      select: { id: true, playerId: true, countryId: true, propertyType: true },
    });

    if (!property || property.playerId !== playerId) {
      return {
        success: false,
        message: this.localize(language, 'Eigendom niet gevonden', 'Property not found'),
      };
    }

    if (property.propertyType !== 'nightclub') {
      return {
        success: false,
        message: this.localize(
          language,
          'Dit eigendom is geen nachtclub',
          'This property is not a nightclub'
        ),
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
    await this.ensureStaffSeedData();

    const djs = await prisma.nightclubDJ.findMany({
      where: {
        OR: [{ isAvailable: true }, { isAvailable: null }],
      },
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
      crowdBoostMultiplier: 0.8 + dj.skillLevel * 0.15, // 1.0-1.75x boost
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
    let venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue || venue.playerId !== playerId) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    await this.clearExpiredDjContract(venueId);
    venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue || venue.playerId !== playerId) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player)
      return {
        success: false,
        message: this.localize(language, 'Speler niet gevonden', 'Player not found'),
      };

    const dj = await prisma.nightclubDJ.findUnique({ where: { id: djId } });
    if (!dj)
      return {
        success: false,
        message: this.localize(language, 'DJ niet gevonden', 'DJ not found'),
      };

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

  async hireResidentDJContract(
    playerId: number,
    venueId: number,
    djId: number,
    days: number
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const safeDays = Math.max(1, Math.min(14, days));
    const hoursCount = safeDays * 24;

    let venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });

    if (!venue || venue.playerId !== playerId) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    await this.clearExpiredDjContract(venueId);
    venue = await prisma.nightclubVenue.findUnique({
      where: { id: venueId },
    });
    if (!venue || venue.playerId !== playerId) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    if (venue.currentDJId) {
      return {
        success: false,
        message: this.localize(
          language,
          'Je hebt al een actieve DJ. Wacht tot het huidige contract eindigt.',
          'You already have an active DJ. Wait for the current contract to end.'
        ),
      };
    }

    const [player, dj] = await Promise.all([
      prisma.player.findUnique({ where: { id: playerId } }),
      prisma.nightclubDJ.findUnique({ where: { id: djId } }),
    ]);
    if (!player)
      return {
        success: false,
        message: this.localize(language, 'Speler niet gevonden', 'Player not found'),
      };
    if (!dj)
      return {
        success: false,
        message: this.localize(language, 'DJ niet gevonden', 'DJ not found'),
      };

    const baseCost = (dj.baseCostPerHour ?? 0) * hoursCount;
    const discountedCost = Math.max(
      0,
      Math.floor(baseCost * (1 - this.RESIDENT_CONTRACT_DISCOUNT))
    );
    if (player.money < discountedCost) {
      return {
        success: false,
        message: this.localize(
          language,
          `Resident contract kost €${discountedCost.toLocaleString()}. Onvoldoende cash.`,
          `Resident contract costs €${discountedCost.toLocaleString()}. Not enough cash.`
        ),
      };
    }

    const startAt = new Date();
    const endAt = new Date(startAt.getTime() + hoursCount * 60 * 60 * 1000);

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: discountedCost } },
      }),
      prisma.nightclubVenue.update({
        where: { id: venueId },
        data: {
          currentDJId: djId,
          djContractStartsAt: startAt,
          djContractEndsAt: endAt,
        },
      }),
      prisma.nightclubDJShift.create({
        data: {
          venueId,
          djId,
          shiftStartAt: startAt,
          shiftEndAt: endAt,
          costPaid: discountedCost,
          crowdBoost: (0.8 + (dj.skillLevel ?? 1) * 0.15) * 1.08,
          vibeBoost: 'resident_contract',
        },
      }),
    ]);

    await activityService.logActivity(
      playerId,
      'NIGHTCLUB_RESIDENT_DJ',
      this.localize(
        language,
        `Resident DJ contract gestart (${safeDays} dagen) met ${dj.djName}.`,
        `Resident DJ contract started (${safeDays} days) with ${dj.djName}.`
      ),
      { venueId, djId, days: safeDays, discount: this.RESIDENT_CONTRACT_DISCOUNT },
      false
    );

    return {
      success: true,
      message: this.localize(
        language,
        `Resident DJ ${dj.djName} actief voor ${safeDays} dagen (12% contractkorting).`,
        `Resident DJ ${dj.djName} active for ${safeDays} days (12% contract discount).`
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
    await this.ensureStaffSeedData();

    const guards = await prisma.nightclubSecurity.findMany({
      where: {
        OR: [{ isAvailable: true }, { isAvailable: null }],
      },
      orderBy: { skillLevel: 'desc' },
    });

    return guards.map((guard) => ({
      id: guard.id,
      name: guard.guardName,
      skillLevel: guard.skillLevel,
      specialty: guard.specialty,
      costPerHour: guard.baseCostPerHour,
      costPerShift: guard.baseCostPerHour * 8, // Night shift (20:00-04:00)
      reputation: guard.reputation,
      theftReductionPercentage: guard.skillLevel * 15 + 20, // 35%-95%
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
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player)
      return {
        success: false,
        message: this.localize(language, 'Speler niet gevonden', 'Player not found'),
      };

    const guard = await prisma.nightclubSecurity.findUnique({ where: { id: guardId } });
    if (!guard)
      return {
        success: false,
        message: this.localize(language, 'Beveiliging niet gevonden', 'Security guard not found'),
      };

    const costPerShift = guard.baseCostPerHour * 8; // 8 hours

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
    shiftEnd.setHours(28, 0, 0, 0); // 04:00 next day

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
          theftReduction: guard.skillLevel * 0.15 + 0.35, // 0.35-0.95
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

  async scheduleEvent(
    playerId: number,
    venueId: number,
    eventType: string,
    startsAt: Date
  ): Promise<{ success: boolean; message: string; newlyUnlockedAchievements?: any[] }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const template = this.EVENT_TEMPLATES[eventType];
    if (!template) {
      return {
        success: false,
        message: this.localize(language, 'Ongeldig event type', 'Invalid event type'),
      };
    }

    const start = new Date(startsAt);
    const end = new Date(start.getTime() + template.hours * 60 * 60 * 1000);
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < template.investment) {
      return {
        success: false,
        message: this.localize(
          language,
          `Event investering is €${template.investment.toLocaleString()}. Onvoldoende cash.`,
          `Event investment is €${template.investment.toLocaleString()}. Not enough cash.`
        ),
      };
    }

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: template.investment } },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType,
          eventName: this.localize(language, template.nl, template.en),
          startsAt: start,
          endsAt: end,
          expectedVisitors: template.expectedVisitors,
          investment: template.investment,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `Event gepland: ${template.nl}.`,
        `Event scheduled: ${template.en}.`
      ),
      newlyUnlockedAchievements: await this.buildAchievementPayloads(playerId),
    };
  }

  async investInMarketing(
    playerId: number,
    venueId: number,
    amount: number
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }
    const safeAmount = Math.max(10000, Math.min(500000, Math.floor(amount)));
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < safeAmount) {
      return {
        success: false,
        message: this.localize(
          language,
          'Onvoldoende cash voor marketing',
          'Insufficient cash for marketing'
        ),
      };
    }

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: safeAmount } },
      }),
      prisma.nightclubVenue.update({
        where: { id: venueId },
        data: {
          marketingSpend: { increment: safeAmount },
          crowdSize: { increment: Math.max(2, Math.floor(safeAmount / 50000)) },
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `Marketingboost actief (+€${safeAmount.toLocaleString()} investering).`,
        `Marketing boost active (+€${safeAmount.toLocaleString()} investment).`
      ),
    };
  }

  async activateSupplierContract(
    playerId: number,
    venueId: number,
    contractType: 'street' | 'cartel' | 'clean'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const contract = this.SUPPLIER_CONTRACTS[contractType];
    if (!contract) {
      return {
        success: false,
        message: this.localize(language, 'Onbekend supplier contract', 'Unknown supplier contract'),
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < contract.cost) {
      return {
        success: false,
        message: this.localize(language, 'Onvoldoende cash voor supplier contract', 'Not enough cash for supplier contract'),
      };
    }

    const startsAt = new Date();
    const endsAt = new Date(startsAt.getTime() + contract.durationHours * 60 * 60 * 1000);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: contract.cost } },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.SUPPLIER_EVENT_PREFIX}${contractType}`,
          eventName: this.localize(language, contract.nl, contract.en),
          startsAt,
          endsAt,
          expectedVisitors: contract.stockBoost,
          investment: contract.cost,
          eventSuccess: true,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `${contract.nl} geactiveerd (${contract.durationHours}u).`,
        `${contract.en} activated (${contract.durationHours}h).`
      ),
    };
  }

  async hirePromoterProfile(
    playerId: number,
    venueId: number,
    profileType: 'street_hype' | 'vip_whisper' | 'tourist_hunter'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const profile = this.PROMOTER_PROFILES[profileType];
    if (!profile) {
      return {
        success: false,
        message: this.localize(language, 'Onbekend promoter profiel', 'Unknown promoter profile'),
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < profile.cost) {
      return {
        success: false,
        message: this.localize(language, 'Onvoldoende cash voor promoter', 'Not enough cash for promoter'),
      };
    }

    const startsAt = new Date();
    const endsAt = new Date(startsAt.getTime() + profile.durationHours * 60 * 60 * 1000);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: profile.cost } },
      }),
      prisma.nightclubVenue.update({
        where: { id: venueId },
        data: {
          crowdSize: { increment: profile.crowdBoost },
        },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.PROMOTER_EVENT_PREFIX}${profileType}`,
          eventName: this.localize(language, profile.nl, profile.en),
          startsAt,
          endsAt,
          expectedVisitors: profile.crowdBoost,
          investment: profile.cost,
          eventSuccess: true,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        `${profile.nl} actief: crowd boost +${profile.crowdBoost}%.`,
        `${profile.en} active: crowd boost +${profile.crowdBoost}%.`
      ),
    };
  }

  async runHeatCooldown(
    playerId: number,
    venueId: number
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const activeCooldown = await prisma.nightclubEvent.findFirst({
      where: {
        venueId,
        eventType: { startsWith: this.HEAT_EVENT_PREFIX },
        endsAt: { gte: new Date() },
      },
    });
    if (activeCooldown) {
      return {
        success: false,
        message: this.localize(language, 'Heat-cooldown is al actief', 'Heat cooldown already active'),
      };
    }

    const cost = 65000;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < cost) {
      return {
        success: false,
        message: this.localize(language, 'Onvoldoende cash voor heat cooldown', 'Not enough cash for heat cooldown'),
      };
    }

    const startsAt = new Date();
    const endsAt = new Date(startsAt.getTime() + 6 * 60 * 60 * 1000);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: cost } },
      }),
      prisma.nightclubVenue.update({
        where: { id: venueId },
        data: {
          crowdSize: { decrement: 5 },
        },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.HEAT_EVENT_PREFIX}stealth_window`,
          eventName: this.localize(language, 'Stealth Window', 'Stealth Window'),
          startsAt,
          endsAt,
          expectedVisitors: 0,
          investment: cost,
          eventSuccess: true,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        'Heat-cooldown gestart: lager raid-risico voor 6 uur.',
        'Heat cooldown started: lower raid risk for 6 hours.'
      ),
    };
  }

  async runSmugglingRoute(
    playerId: number,
    venueId: number,
    routeType: 'harbor' | 'airstrip' | 'borderline'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const route = this.SMUGGLING_ROUTES[routeType];
    if (!route) {
      return {
        success: false,
        message: this.localize(language, 'Ongeldige route', 'Invalid route'),
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < route.cost) {
      return {
        success: false,
        message: this.localize(language, 'Onvoldoende cash voor route', 'Not enough cash for route'),
      };
    }

    const seized = Math.random() < route.risk;
    const grams = seized
      ? 0
      : route.minGrams + Math.floor(Math.random() * (route.maxGrams - route.minGrams + 1));
    const pool = ['cocaine', 'mdma', 'weed', 'meth', 'heroin'];
    const drugType = pool[Math.floor(Math.random() * pool.length)];
    const startsAt = new Date();
    const endsAt = new Date(startsAt.getTime() + 2 * 60 * 60 * 1000);

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: route.cost } },
      });

      if (!seized && grams > 0) {
        await tx.nightclubDrugInventory.upsert({
          where: {
            venueId_drugType_quality: {
              venueId,
              drugType,
              quality: route.quality,
            },
          },
          update: {
            quantity: { increment: grams },
          },
          create: {
            venueId,
            drugType,
            quality: route.quality,
            quantity: grams,
            basePrice: this.getDrugBasePrice(drugType),
          },
        });
      }

      await tx.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.SMUGGLING_EVENT_PREFIX}${routeType}`,
          eventName: this.localize(language, route.nl, route.en),
          startsAt,
          endsAt,
          expectedVisitors: grams,
          investment: route.cost,
          eventSuccess: !seized,
          revenue: 0,
        },
      });
    });

    if (seized) {
      return {
        success: true,
        message: this.localize(
          language,
          'Smuggling route onderschept. Lading kwijt, crew blijft onzichtbaar.',
          'Smuggling route intercepted. Cargo lost, crew stays hidden.'
        ),
      };
    }

    return {
      success: true,
      message: this.localize(
        language,
        `Smuggling route gelukt: +${grams}g ${drugType} (${route.quality}).`,
        `Smuggling route succeeded: +${grams}g ${drugType} (${route.quality}).`
      ),
    };
  }

  async runCounterIntelSweep(
    playerId: number,
    venueId: number
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const cost = 50000;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < cost) {
      return {
        success: false,
        message: this.localize(language, 'Onvoldoende cash voor counter-intel', 'Not enough cash for counter-intel'),
      };
    }

    const startsAt = new Date();
    const endsAt = new Date(startsAt.getTime() + 12 * 60 * 60 * 1000);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: cost } },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.COUNTER_INTEL_EVENT_PREFIX}sweep`,
          eventName: this.localize(language, 'Counter-Intel Sweep', 'Counter-Intel Sweep'),
          startsAt,
          endsAt,
          expectedVisitors: 0,
          investment: cost,
          eventSuccess: true,
        },
      }),
    ]);

    return {
      success: true,
      message: this.localize(
        language,
        'Counter-intel sweep actief: rival sabotage wordt afgezwakt.',
        'Counter-intel sweep active: rival sabotage impact is reduced.'
      ),
    };
  }

  async applyUpgrade(
    playerId: number,
    venueId: number,
    upgradeType: 'sound_rig' | 'vip_lounge' | 'surveillance'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const levels = await this.getVenueUpgradeLevels(venueId);
    const currentLevel = levels[upgradeType];
    if (currentLevel >= 3) {
      return {
        success: false,
        message: this.localize(
          language,
          'Upgrade zit al op max level',
          'Upgrade is already max level'
        ),
      };
    }

    const cost = this.UPGRADE_COSTS[upgradeType][currentLevel];
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });
    if (!player || player.money < cost) {
      return {
        success: false,
        message: this.localize(
          language,
          `Onvoldoende cash voor upgrade (â‚¬${cost.toLocaleString()})`,
          `Not enough cash for upgrade (â‚¬${cost.toLocaleString()})`
        ),
      };
    }

    const nextLevel = currentLevel + 1;
    const readableLabel =
      upgradeType === 'sound_rig'
        ? this.localize(language, 'Sound Rig', 'Sound Rig')
        : upgradeType === 'vip_lounge'
          ? this.localize(language, 'VIP Lounge', 'VIP Lounge')
          : this.localize(language, 'Surveillance', 'Surveillance');

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: cost } },
      }),
      prisma.nightclubEvent.create({
        data: {
          venueId,
          eventType: `${this.UPGRADE_EVENT_PREFIX}${upgradeType}`,
          eventName: `Upgrade ${readableLabel} Lv${nextLevel}`,
          startsAt: new Date(),
          endsAt: new Date(),
          expectedVisitors: 0,
          investment: cost,
          actualVisitors: 0,
          eventSuccess: true,
          revenue: 0,
        },
      }),
    ]);

    await activityService.logActivity(
      playerId,
      'NIGHTCLUB_UPGRADE_PURCHASE',
      this.localize(
        language,
        `Upgrade gekocht: ${readableLabel} Lv${nextLevel} (â‚¬${cost.toLocaleString()})`,
        `Upgrade purchased: ${readableLabel} Lv${nextLevel} (â‚¬${cost.toLocaleString()})`
      ),
      { venueId, upgradeType, nextLevel, cost },
      false
    );

    return {
      success: true,
      message: this.localize(
        language,
        `${readableLabel} geÃ¼pgraded naar level ${nextLevel}.`,
        `${readableLabel} upgraded to level ${nextLevel}.`
      ),
    };
  }

  async respondToIncident(
    playerId: number,
    venueId: number,
    actionType: 'bribe' | 'lockdown' | 'counterintel'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const venue = await this.getOwnedVenueOrNull(playerId, venueId);
    if (!venue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const recentTheft = await prisma.nightclubTheft.findFirst({
      where: {
        venueId,
        occurredAt: { gte: new Date(Date.now() - 12 * 60 * 60 * 1000) },
      },
      orderBy: { occurredAt: 'desc' },
    });

    if (!recentTheft) {
      return {
        success: false,
        message: this.localize(
          language,
          'Geen recent incident gevonden',
          'No recent incident found'
        ),
      };
    }

    if (actionType === 'bribe') {
      const cost = Math.max(10000, Math.floor(recentTheft.valueLost * 0.35));
      const player = await prisma.player.findUnique({
        where: { id: playerId },
        select: { money: true },
      });
      if (!player || player.money < cost) {
        return {
          success: false,
          message: this.localize(
            language,
            'Onvoldoende cash om om te kopen',
            'Not enough cash to bribe'
          ),
        };
      }
      await prisma.$transaction([
        prisma.player.update({
          where: { id: playerId },
          data: { money: { decrement: cost } },
        }),
        prisma.nightclubVenue.update({
          where: { id: venueId },
          data: { crowdSize: { increment: 4 } },
        }),
      ]);
      return {
        success: true,
        message: this.localize(
          language,
          'Omkoping gelukt: panic geneutraliseerd.',
          'Bribe succeeded: panic neutralized.'
        ),
      };
    }

    if (actionType === 'lockdown') {
      await prisma.nightclubVenue.update({
        where: { id: venueId },
        data: { crowdSize: { decrement: 5 } },
      });
      return {
        success: true,
        message: this.localize(
          language,
          'Lockdown geactiveerd: minder bezoekers, lager direct risico.',
          'Lockdown enabled: fewer visitors, lower immediate risk.'
        ),
      };
    }

    await prisma.nightclubVenue.update({
      where: { id: venueId },
      data: { marketingSpend: { increment: 5000 } },
    });
    return {
      success: true,
      message: this.localize(
        language,
        'Counter-intel gestart: security leert van het incident.',
        'Counter-intel launched: security adapts from the incident.'
      ),
    };
  }

  async searchRivalNightclubs(
    requesterPlayerId: number,
    nameQuery: string,
    limit = 8
  ): Promise<
    Array<{ ownerName: string; venueId: number; country: string; score: number; crowdSize: number }>
  > {
    const query = nameQuery.trim();
    if (query.length < 2) return [];
    const rows = await prisma.nightclubVenue.findMany({
      where: {
        playerId: { not: requesterPlayerId },
        player: {
          username: { contains: query },
        },
      },
      include: {
        player: {
          select: { username: true },
        },
      },
      orderBy: { totalRevenueAllTime: 'desc' },
      take: Math.max(1, Math.min(limit, 25)),
    });

    return rows.map((row) => ({
      ownerName: row.player.username,
      venueId: row.id,
      country: row.country,
      score: Number(row.totalRevenueAllTime ?? 0),
      crowdSize: row.crowdSize ?? 0,
    }));
  }

  async executeRivalAction(
    playerId: number,
    ownVenueId: number,
    targetName: string,
    actionType: 'sabotage' | 'promo_war'
  ): Promise<{ success: boolean; message: string }> {
    const language = await this.getPlayerLanguage(playerId);
    const ownVenue = await this.getOwnedVenueOrNull(playerId, ownVenueId);
    if (!ownVenue) {
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
    }

    const target = await prisma.nightclubVenue.findFirst({
      where: {
        playerId: { not: playerId },
        player: {
          username: {
            equals: targetName.trim(),
          },
        },
      },
      include: {
        player: { select: { id: true, username: true } },
      },
      orderBy: { totalRevenueAllTime: 'desc' },
    });

    if (!target) {
      return {
        success: false,
        message: this.localize(
          language,
          'Doelwit niet gevonden. Zoek op exacte spelersnaam.',
          'Target not found. Search by exact player name.'
        ),
      };
    }

    const baseCost = actionType === 'sabotage' ? 70000 : 45000;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, username: true },
    });
    if (!player || player.money < baseCost) {
      return {
        success: false,
        message: this.localize(
          language,
          'Onvoldoende cash voor rival action',
          'Not enough cash for rival action'
        ),
      };
    }

    const ownCrowdGain = actionType === 'sabotage' ? 5 : 8;
    const targetCrowdLoss = actionType === 'sabotage' ? 7 : 4;

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: baseCost } },
      }),
      prisma.nightclubVenue.update({
        where: { id: ownVenueId },
        data: { crowdSize: { increment: ownCrowdGain } },
      }),
      prisma.nightclubVenue.update({
        where: { id: target.id },
        data: { crowdSize: { decrement: targetCrowdLoss } },
      }),
    ]);

    await directMessageService.sendSystemMessage(
      target.player.id,
      this.localize(
        language,
        `⚠️ Rival pressure: club van ${player.username} voert ${actionType === 'sabotage' ? 'sabotage' : 'promo-oorlog'} tegen je.`,
        `⚠️ Rival pressure: club of ${player.username} initiated ${actionType === 'sabotage' ? 'sabotage' : 'promo war'} against you.`
      )
    );

    return {
      success: true,
      message: this.localize(
        language,
        actionType === 'sabotage'
          ? `Sabotage uitgevoerd tegen ${target.player.username}.`
          : `Promo-oorlog gestart tegen ${target.player.username}.`,
        actionType === 'sabotage'
          ? `Sabotage executed against ${target.player.username}.`
          : `Promo war started against ${target.player.username}.`
      ),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CROWD MANAGEMENT & DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /**
   * Calculate current crowd state based on DJ, security, time, and events
   */
  private async calculateCrowdState(venueId: number): Promise<CrowdState> {
    const upgradeLevels = await this.getVenueUpgradeLevels(venueId);
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
          take: 8,
        },
      },
    });

    if (!venue) throw new Error('Venue not found');

    let size = venue.crowdSize;
    let vibe: 'chill' | 'normal' | 'wild' | 'raging' = venue.crowdVibe as any;

    // DJ effect
    if (venue.djShifts.length > 0) {
      const djShift = venue.djShifts[0];
      size = Math.min(100, size + 20); // DJ adds 20% crowd
      vibe = this.improveVibe(vibe);
    }

    // Event effects (base + profile-specific modifiers)
    if (venue.events.length > 0) {
      size = Math.min(100, size + 15);
      vibe = this.improveVibe(vibe);

      for (const event of venue.events) {
        const eventType = event.eventType ?? '';
        if (eventType.startsWith(this.PROMOTER_EVENT_PREFIX)) {
          size = Math.min(100, size + 4);
        }
        if (eventType.startsWith(this.SUPPLIER_EVENT_PREFIX)) {
          size = Math.min(100, size + 2);
        }
        if (eventType.startsWith(this.HEAT_EVENT_PREFIX)) {
          size = Math.max(8, size - 2);
        }
      }
    }

    // Upgrade effect: Sound rig improves crowd retention and vibe floor.
    if (upgradeLevels.sound_rig > 0) {
      size = Math.min(100, size + upgradeLevels.sound_rig * 2);
      if (upgradeLevels.sound_rig >= 2 && vibe === 'chill') {
        vibe = 'normal';
      }
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
    const upgradeLevels = await this.getVenueUpgradeLevels(venueId);
    const securityReduction = await this.getCurrentSecurityReduction(venueId);
    const staffingLimits = await this.getStaffingLimits(venue.playerId);
    const prostitutionBoost = await this.getActiveProstituteBoost(
      venueId,
      crowdState.vibe,
      securityReduction,
      staffingLimits.isVipActive
    );
    const numBuyers = Math.floor((crowdState.size / 10) * prostitutionBoost.salesBoost); // ~10% of crowd buys

    for (let i = 0; i < numBuyers; i++) {
      // Prefer in-demand drugs that are actually in stock.
      const demandedStockedTypes = Object.keys(crowdState.demand).filter(
        (dt) =>
          crowdState.demand[dt] > Math.random() &&
          venueInventory.some((inv) => inv.drugType === dt && inv.quantity > 0)
      );

      let drugType: string | null = null;
      if (demandedStockedTypes.length > 0) {
        drugType = demandedStockedTypes[Math.floor(Math.random() * demandedStockedTypes.length)];
      } else {
        // Fallback: some buyers still purchase from available stock even when current vibe-demand doesn't align.
        const stockedTypes = [
          ...new Set(venueInventory.filter((inv) => inv.quantity > 0).map((inv) => inv.drugType)),
        ];
        if (stockedTypes.length === 0 || Math.random() > 0.35) continue;
        drugType = stockedTypes[Math.floor(Math.random() * stockedTypes.length)];
      }

      if (!drugType) continue;

      const candidateInventory = venueInventory.filter(
        (inv) => inv.drugType === drugType && inv.quantity > 0
      );
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
      const unitPrice = Math.floor(
        inventory.basePrice * Math.min(this.MAX_MARGIN, Math.max(this.MIN_MARGIN, margin))
      );
      const vipLoungeMultiplier = 1 + upgradeLevels.vip_lounge * 0.04;
      const boostedUnitPrice = Math.floor(
        unitPrice * prostitutionBoost.priceBoost * vipLoungeMultiplier
      );
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
      const upgradeLevels = await this.getVenueUpgradeLevels(venue.id);
      const [heatCooldownActive, counterIntelActive] = await Promise.all([
        prisma.nightclubEvent.findFirst({
          where: {
            venueId: venue.id,
            eventType: { startsWith: this.HEAT_EVENT_PREFIX },
            endsAt: { gte: new Date() },
          },
          select: { id: true },
        }),
        prisma.nightclubEvent.findFirst({
          where: {
            venueId: venue.id,
            eventType: { startsWith: this.COUNTER_INTEL_EVENT_PREFIX },
            endsAt: { gte: new Date() },
          },
          select: { id: true },
        }),
      ]);

      // Base theft chance: 15% per minute in raging environment
      let theftChance = 0.15 * (crowdState.size / 100);

      // Security reduces chance
      if (securityShift) {
        theftChance *= 1 - securityShift.theftReduction;
      }
      if (upgradeLevels.surveillance > 0) {
        theftChance *= 1 - upgradeLevels.surveillance * 0.08;
      }
      if (heatCooldownActive) {
        theftChance *= 0.84;
      }
      if (counterIntelActive) {
        theftChance *= 0.78;
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
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
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
    await this.clearExpiredDjContract(venueId);

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
          estimatedAvgSaleRevenue:
            estimatedSalesCount > 0 ? Math.floor(estimatedRevenue / estimatedSalesCount) : 0,
        };
      })
    );

    const countryLeaderboardPreview = await this.getTopNightclubs(5, venue.country);
    const totalInventoryValue = venue.inventory.reduce(
      (sum, item) => sum + item.quantity * item.basePrice,
      0
    );
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
    const staffAssigned = venue.prostitutes.length;
    const moraleRaw =
      1.05 -
      (staffAssigned / Math.max(1, staffingLimits.staffCap)) * 0.18 +
      (activeDjShift ? 0.08 : -0.05);
    const morale = Number(Math.max(0.6, Math.min(1.25, moraleRaw)).toFixed(2));
    const fatigue = Number((1.35 - morale).toFixed(2));
    const upgradeLevels = await this.getVenueUpgradeLevels(venueId);
    const upgradeTree = this.buildUpgradeSnapshot({
      levels: upgradeLevels,
      staffAssigned,
      staffCap: staffingLimits.staffCap,
    });
    const eventTemplates = Object.entries(this.EVENT_TEMPLATES).map(([key, tpl]) => ({
      key,
      labelNl: tpl.nl,
      labelEn: tpl.en,
      durationHours: tpl.hours,
      investment: tpl.investment,
      expectedVisitors: tpl.expectedVisitors,
    }));
    const alerts = this.buildOperationAlerts({
      hasDj: activeDjShift != null,
      djEndsAt: venue.djContractEndsAt ?? null,
      inventoryItems: venue.inventory.filter((inv) => (inv.quantity ?? 0) > 0).length,
      recentTheftsCount: venue.thefts.filter((t) => {
        const at = t.occurredAt ? new Date(t.occurredAt).getTime() : 0;
        return at >= Date.now() - 24 * 60 * 60 * 1000;
      }).length,
      crowdSize: crowdState.size,
      staffAssigned,
      staffCap: staffingLimits.staffCap,
    });
    const [
      activeSupplierEvent,
      activePromoterEvent,
      activeHeatCooldownEvent,
      activeCounterIntelEvent,
      latestSmugglingEvent,
      timeline,
    ] = await Promise.all([
      prisma.nightclubEvent.findFirst({
        where: {
          venueId,
          eventType: { startsWith: this.SUPPLIER_EVENT_PREFIX },
          endsAt: { gte: now },
        },
        orderBy: { startsAt: 'desc' },
      }),
      prisma.nightclubEvent.findFirst({
        where: {
          venueId,
          eventType: { startsWith: this.PROMOTER_EVENT_PREFIX },
          endsAt: { gte: now },
        },
        orderBy: { startsAt: 'desc' },
      }),
      prisma.nightclubEvent.findFirst({
        where: {
          venueId,
          eventType: { startsWith: this.HEAT_EVENT_PREFIX },
          endsAt: { gte: now },
        },
        orderBy: { startsAt: 'desc' },
      }),
      prisma.nightclubEvent.findFirst({
        where: {
          venueId,
          eventType: { startsWith: this.COUNTER_INTEL_EVENT_PREFIX },
          endsAt: { gte: now },
        },
        orderBy: { startsAt: 'desc' },
      }),
      prisma.nightclubEvent.findFirst({
        where: {
          venueId,
          eventType: { startsWith: this.SMUGGLING_EVENT_PREFIX },
        },
        orderBy: { startsAt: 'desc' },
      }),
      this.buildOperationsTimeline(venueId),
    ]);
    const supplierKey =
      activeSupplierEvent?.eventType?.replace(this.SUPPLIER_EVENT_PREFIX, '') ?? null;
    const supplierMeta = supplierKey
      ? this.SUPPLIER_CONTRACTS[supplierKey as 'street' | 'cartel' | 'clean'] ?? null
      : null;
    const promoterKey =
      activePromoterEvent?.eventType?.replace(this.PROMOTER_EVENT_PREFIX, '') ?? null;
    const promoterMeta = promoterKey
      ? this.PROMOTER_PROFILES[
          promoterKey as 'street_hype' | 'vip_whisper' | 'tourist_hunter'
        ] ?? null
      : null;
    const smugglingKey =
      latestSmugglingEvent?.eventType?.replace(this.SMUGGLING_EVENT_PREFIX, '') ?? null;
    const smugglingMeta = smugglingKey
      ? this.SMUGGLING_ROUTES[smugglingKey as 'harbor' | 'airstrip' | 'borderline'] ?? null
      : null;
    const recentThefts24h = venue.thefts.filter((t) => {
      const at = t.occurredAt ? new Date(t.occurredAt).getTime() : 0;
      return at >= Date.now() - 24 * 60 * 60 * 1000;
    }).length;
    const promoterSpendBoost = promoterMeta?.spendBoost ?? 0;
    const vipClientShare = Math.max(
      4,
      Math.min(
        48,
        Math.round(
          8 +
            upgradeLevels.vip_lounge * 7 +
            (promoterKey === 'vip_whisper' ? 10 : 0) +
            (staffingLimits.isVipActive ? 6 : 0)
        )
      )
    );
    const baseHeat = Math.round(
      crowdState.size * 0.22 +
        Math.min(45, revenuesToday / 1400) +
        recentThefts24h * 5 +
        (activeDjShift ? 4 : 0)
    );
    const heatValue = Math.max(0, baseHeat - (activeHeatCooldownEvent ? 18 : 0));
    const raidRiskPct = Math.max(
      4,
      Math.min(
        85,
        Math.round(
          heatValue * 0.6 +
            (100 - (securityReduction * 100)) * 0.18 -
            upgradeLevels.surveillance * 7 -
            (activeCounterIntelEvent ? 10 : 0)
        )
      )
    );
    const reputationScore = Math.max(
      0,
      Math.min(
        1000,
        Math.round(
          300 +
            Math.min(300, Number(venue.totalRevenueAllTime ?? 0) / 8000) +
            crowdState.size * 2 -
            recentThefts24h * 18 +
            upgradeLevels.sound_rig * 24
        )
      )
    );
    const reputationTier =
      reputationScore >= 820
        ? 'legend'
        : reputationScore >= 650
          ? 'elite'
          : reputationScore >= 480
            ? 'rising'
            : 'underground';
    const calendar = this.buildDynamicCalendarSnapshot();
    const staffTraits = this.buildStaffTraitsSnapshot({
      assignedStaff: staffAssigned,
      staffCap: staffingLimits.staffCap,
      morale,
      fatigue,
      crowdSize: crowdState.size,
      recentTheftsCount: recentThefts24h,
    });

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
      djActive: activeDjShift != null,
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
      operations: {
        residentDj: {
          isActive: activeDjShift != null,
          contractEndsAt: venue.djContractEndsAt,
          discountPct: Math.floor(this.RESIDENT_CONTRACT_DISCOUNT * 100),
        },
        events: venue.events,
        eventTemplates,
        morale: {
          morale,
          fatigue,
          assignedStaff: staffAssigned,
          staffCap: staffingLimits.staffCap,
        },
        upgrades: upgradeTree,
        alerts,
        expansion: {
          policeHeat: {
            value: heatValue,
            severity: this.pickSeverity(heatValue, 40, 70),
            raidRiskPct,
            cooldownActive: activeHeatCooldownEvent != null,
            cooldownEndsAt: activeHeatCooldownEvent?.endsAt ?? null,
            cooldownCost: 65000,
          },
          supplierContracts: {
            activeKey: supplierKey,
            activeNameNl: supplierMeta?.nl ?? null,
            activeNameEn: supplierMeta?.en ?? null,
            reliability: supplierMeta?.reliability ?? 0.5,
            stockBoost: supplierMeta?.stockBoost ?? 0,
            contractEndsAt: activeSupplierEvent?.endsAt ?? null,
            options: Object.entries(this.SUPPLIER_CONTRACTS).map(([key, value]) => ({
              key,
              labelNl: value.nl,
              labelEn: value.en,
              durationHours: value.durationHours,
              cost: value.cost,
              reliability: value.reliability,
              stockBoost: value.stockBoost,
            })),
          },
          promoters: {
            activeKey: promoterKey,
            activeNameNl: promoterMeta?.nl ?? null,
            activeNameEn: promoterMeta?.en ?? null,
            crowdBoost: promoterMeta?.crowdBoost ?? 0,
            spendBoost: promoterMeta?.spendBoost ?? 0,
            profileEndsAt: activePromoterEvent?.endsAt ?? null,
            options: Object.entries(this.PROMOTER_PROFILES).map(([key, value]) => ({
              key,
              labelNl: value.nl,
              labelEn: value.en,
              durationHours: value.durationHours,
              cost: value.cost,
              crowdBoost: value.crowdBoost,
              spendBoost: value.spendBoost,
            })),
          },
          dynamicCalendar: {
            today: calendar.today,
            tomorrow: calendar.tomorrow,
            recommendedEventType: calendar.recommendedEventType,
            demandBoostPct: calendar.demandBoostPct,
          },
          vipClientele: {
            sharePct: vipClientShare,
            spendMultiplier: Number((1 + upgradeLevels.vip_lounge * 0.06 + promoterSpendBoost).toFixed(2)),
            requiresVipLoungeLevel: 2,
            currentVipLoungeLevel: upgradeLevels.vip_lounge,
          },
          staffTraits,
          smuggling: {
            lastRouteKey: smugglingKey,
            lastRouteNameNl: smugglingMeta?.nl ?? null,
            lastRouteNameEn: smugglingMeta?.en ?? null,
            lastRunAt: latestSmugglingEvent?.startsAt ?? null,
            lastRunSuccess: latestSmugglingEvent?.eventSuccess ?? null,
            options: Object.entries(this.SMUGGLING_ROUTES).map(([key, value]) => ({
              key,
              labelNl: value.nl,
              labelEn: value.en,
              cost: value.cost,
              riskPct: Math.round(value.risk * 100),
              minGrams: value.minGrams,
              maxGrams: value.maxGrams,
              quality: value.quality,
            })),
          },
          reputationSeason: {
            score: reputationScore,
            tier: reputationTier,
            seasonProgressPct: Math.max(
              0,
              Math.min(100, Math.round(((Number(venue.totalRevenueAllTime ?? 0) % 1000000) / 1000000) * 100))
            ),
          },
          counterIntel: {
            active: activeCounterIntelEvent != null,
            endsAt: activeCounterIntelEvent?.endsAt ?? null,
            mitigationPct: activeCounterIntelEvent ? 18 : 0,
            actionCost: 50000,
          },
          timeline,
        },
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
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
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
      return {
        success: false,
        message: this.localize(language, 'Prostituee niet gevonden', 'Crew member not found'),
      };
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

    if (
      prostitute.location === 'nightclub' &&
      prostitute.nightclubVenueId &&
      prostitute.nightclubVenueId !== venueId
    ) {
      return {
        success: false,
        message: this.localize(
          language,
          'Deze prostituee werkt al in een andere nachtclub',
          'This crew member is already working in another nightclub'
        ),
      };
    }

    await prisma.$transaction(async (tx) => {
      if (prostitute.redLightRoomId) {
        await tx.redLightRoom.update({
          where: { id: prostitute.redLightRoomId },
          data: { occupied: false },
        });
      }

      await tx.prostitute.update({
        where: { id: prostituteId },
        data: {
          location: 'nightclub',
          redLightRoomId: null,
          nightclubVenueId: venueId,
          nightclubAssignedAt: new Date(),
          lastEarningsAt: new Date(),
        },
      });

      await tx.nightclubProstituteAssignment.create({
        data: {
          playerId,
          venueId,
          prostituteId,
          isActive: true,
        },
      });
    });

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
      return {
        success: false,
        message: this.localize(language, 'Nachtclub niet gevonden', 'Nightclub not found'),
      };
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
