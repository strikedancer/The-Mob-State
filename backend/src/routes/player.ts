import { Router, Response } from 'express';
import { Prisma } from '@prisma/client';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { playerService } from '../services/playerService';
import * as policeService from '../services/policeService';
import { getRankTitle } from '../utils/rankSystem';
import { getPlayerCooldowns } from '../services/cooldownService';
import prisma from '../lib/prisma';
import config from '../config';
import { weaponService } from '../services/weaponService';
import { vehicleService } from '../services/vehicleService';
import { weaponSelectionService } from '../services/weaponSelectionService';
import {
  checkAndUnlockAchievements,
  serializeAchievementForClient,
} from '../services/achievementService';
import { existsCached } from '../services/redisClient';
import * as crewWarService from '../services/crewWarService';
import * as territoryService from '../services/territoryService';
import {
  applyVipTimeoutReductionMs,
  applyVipTimeoutReductionSeconds,
  isVipStatusActive,
} from '../services/vipBenefitsService';

function emptyCrewWarHub() {
  return {
    myCrewId: null,
    canDeclare: false,
    currentWar: null,
    availableTargets: [],
    seasonLeaderboard: [],
    recentWars: [],
  };
}

const router = Router();
const PROSTITUTE_RECRUITMENT_COOLDOWN_SECONDS = 5 * 60;
const PRISON_ACTION_COOLDOWN_SECONDS = 30;
let profileLikesTableReady = false;
let profileLikesTablePromise: Promise<void> | null = null;

async function ensureProfileLikesTable(): Promise<void> {
  if (profileLikesTableReady) {
    return;
  }

  if (profileLikesTablePromise) {
    return profileLikesTablePromise;
  }

  profileLikesTablePromise = prisma
    .$executeRawUnsafe(
      `
    CREATE TABLE IF NOT EXISTS profile_likes (
      id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      sourcePlayerId INT NOT NULL,
      targetPlayerId INT NOT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      CONSTRAINT fk_profile_likes_source FOREIGN KEY (sourcePlayerId) REFERENCES players(id) ON DELETE CASCADE,
      CONSTRAINT fk_profile_likes_target FOREIGN KEY (targetPlayerId) REFERENCES players(id) ON DELETE CASCADE,
      UNIQUE KEY profile_likes_source_target_unique (sourcePlayerId, targetPlayerId),
      INDEX idx_profile_likes_target (targetPlayerId),
      INDEX idx_profile_likes_source (sourcePlayerId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `
    )
    .then(() => {
      profileLikesTableReady = true;
    });

  return profileLikesTablePromise;
}

async function getPrisonActionCooldownRemaining(
  playerId: number,
  eventKey: string
): Promise<number> {
  const latestAction = await prisma.worldEvent.findFirst({
    where: {
      playerId,
      eventKey,
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      createdAt: true,
    },
  });

  if (!latestAction) {
    return 0;
  }

  const elapsedSeconds = Math.floor((Date.now() - latestAction.createdAt.getTime()) / 1000);
  return Math.max(0, PRISON_ACTION_COOLDOWN_SECONDS - elapsedSeconds);
}

async function markPrisonActionCooldown(playerId: number, eventKey: string): Promise<void> {
  await prisma.worldEvent.create({
    data: {
      playerId,
      eventKey,
      params: JSON.stringify({}),
    },
  });
}

// Get current player info
router.get('/me', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const player = await playerService.getPlayer(req.player!.id);

    return res.status(200).json({
      event: 'player.info',
      params: {},
      player,
    });
  } catch (error) {
    console.error('[PlayerRoute] Failed to load /player/me', {
      playerId: req.player?.id,
      username: req.player?.username,
      error,
    });
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get jail status
router.get('/jail-status', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const remainingTime = await policeService.checkIfJailed(playerId);
    const player = await playerService.getPlayer(playerId);
    const bailAmount =
      remainingTime > 0
        ? policeService.calculateJailBail(player.wantedLevel || 0, remainingTime)
        : 0;

    return res.status(200).json({
      jailed: remainingTime > 0,
      remainingTime,
      bailAmount,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Pay bail to get out of jail
router.post('/pay-bail', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;

    // Check if player is in jail
    const jailTime = await policeService.checkIfJailed(playerId);
    if (jailTime === 0) {
      return res.status(400).json({
        event: 'error.not_jailed',
        params: {},
      });
    }

    // Get player data for bail calculation
    const player = await playerService.getPlayer(playerId);
    const bail = policeService.calculateJailBail(player.wantedLevel || 0, jailTime);

    if (player.money < bail) {
      return res.status(400).json({
        event: 'error.insufficient_funds',
        params: {
          required: bail,
          available: player.money,
        },
      });
    }

    // Pay bail
    await policeService.payBail(playerId, jailTime);

    // Get updated player data
    const updatedPlayer = await playerService.getPlayer(playerId);

    return res.status(200).json({
      event: 'bail.paid',
      params: {
        amount: bail,
      },
      player: {
        money: updatedPlayer.money,
        wantedLevel: updatedPlayer.wantedLevel,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          event: 'error.insufficient_funds',
          params: {},
        });
      }
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get player profile by ID
router.get('/:playerId/profile', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    await ensureProfileLikesTable();

    const playerId = parseInt(req.params.playerId as string, 10);
    const viewerId = req.player!.id;

    if (Number.isNaN(playerId) || playerId <= 0) {
      return res.status(400).json({
        event: 'error.invalid_player_id',
        params: {},
      });
    }

    let player;
    try {
      player = await playerService.getPlayer(playerId);
    } catch (error) {
      if (error instanceof Error && error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
      throw error;
    }

    // Get crew info if player is in a crew (via crewMembership)
    let crewName = null;
    let crewRole = null;

    const crewMembership = await prisma.crewMember.findUnique({
      where: { playerId: playerId },
      include: { crew: true },
    });

    if (crewMembership) {
      crewName = crewMembership.crew.name;
      crewRole = crewMembership.role;
    }

    let likesCount = 0;
    let existingLike: { id: number } | null = null;
    let bankBalance = 0;
    let prostitutesCount = 0;
    let propertiesCount = 0;
    let isOnlineNow = false;
    try {
      const profileMeta = await Promise.all([
        prisma.profileLike.count({ where: { targetPlayerId: playerId } }),
        prisma.profileLike.findUnique({
          where: {
            sourcePlayerId_targetPlayerId: {
              sourcePlayerId: viewerId,
              targetPlayerId: playerId,
            },
          },
          select: { id: true },
        }),
        prisma.bankAccount.findUnique({
          where: { playerId },
          select: { balance: true },
        }),
        prisma.prostitute.count({ where: { playerId } }),
        prisma.property.count({ where: { playerId } }),
        existsCached(`online:${playerId}`),
      ]);

      likesCount = profileMeta[0];
      existingLike = profileMeta[1];
      bankBalance = profileMeta[2]?.balance ?? 0;
      prostitutesCount = profileMeta[3];
      propertiesCount = profileMeta[4];
      isOnlineNow = profileMeta[5];
    } catch (metaError) {
      console.error('⚠️ Profile meta fallback in /player/:playerId/profile:', metaError);
    }

    const nowMs = Date.now();
    const lastSeenAt = player.lastTickAt ?? player.updatedAt ?? player.createdAt;
    const secondsSinceLastSeen = Math.max(
      0,
      Math.floor((nowMs - new Date(lastSeenAt).getTime()) / 1000)
    );

    if (!isOnlineNow) {
      isOnlineNow = secondsSinceLastSeen <= 300;
    }

    const isAlive = (player.health ?? 0) > 0;

    const rankInfo = getRankTitle(player.rank);

    return res.status(200).json({
      username: player.username,
      avatar: player.avatar || 'default_1',
      level: player.rank,
      rank: player.rank,
      rankTitle: rankInfo.title,
      rankIcon: rankInfo.icon,
      reputation: player.reputation || 0,
      isVip: player.isVip || false,
      vip: player.isVip || false,
      isAlive,
      status: isAlive ? 'alive' : 'dead',
      isOnlineNow,
      secondsSinceLastSeen,
      lastSeenAt,
      startDate: player.createdAt,
      cashMoney: player.money || 0,
      bankMoney: bankBalance,
      prostitutesCount,
      propertiesCount,
      likesCount,
      viewerHasLiked: !!existingLike,
      crewName,
      crewRole,
    });
  } catch (error) {
    console.error('❌ Error in /player/:playerId/profile:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/:playerId/profile/like', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    await ensureProfileLikesTable();

    const targetPlayerId = parseInt(req.params.playerId as string, 10);
    const sourcePlayerId = req.player!.id;

    if (Number.isNaN(targetPlayerId) || targetPlayerId <= 0) {
      return res.status(400).json({
        event: 'error.invalid_player_id',
        params: {},
      });
    }

    if (sourcePlayerId === targetPlayerId) {
      return res.status(400).json({
        event: 'error.cannot_like_self',
        params: {},
      });
    }

    const targetPlayer = await prisma.player.findUnique({
      where: { id: targetPlayerId },
      select: { id: true },
    });

    if (!targetPlayer) {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    await prisma.profileLike.create({
      data: {
        sourcePlayerId,
        targetPlayerId,
      },
    });

    const likesCount = await prisma.profileLike.count({
      where: { targetPlayerId },
    });

    return res.status(200).json({
      success: true,
      liked: true,
      likesCount,
    });
  } catch (error) {
    if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
      const targetPlayerId = parseInt(req.params.playerId as string, 10);
      const likesCount = await prisma.profileLike.count({
        where: { targetPlayerId },
      });

      return res.status(409).json({
        success: false,
        liked: false,
        event: 'error.profile_already_liked',
        likesCount,
      });
    }

    console.error('❌ Error in /player/:playerId/profile/like:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Attempt jailbreak - rescue another player
router.post('/jailbreak/:targetId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const rescuerId = req.player!.id;
    const targetId = parseInt(req.params.targetId as string, 10);
    const { crewId } = req.body;

    const cooldownRemaining = await getPrisonActionCooldownRemaining(
      rescuerId,
      'prison.cooldown.jailbreak'
    );
    if (cooldownRemaining > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType: 'prison_jailbreak',
          remainingSeconds: cooldownRemaining,
          message: `Wait ${cooldownRemaining} seconds before attempting another jailbreak`,
        },
      });
    }

    if (rescuerId === targetId) {
      return res.status(400).json({
        event: 'error.cannot_rescue_self',
        params: {},
      });
    }

    const result = await policeService.attemptJailbreak(
      rescuerId,
      targetId,
      crewId ? parseInt(crewId, 10) : undefined
    );
    await markPrisonActionCooldown(rescuerId, 'prison.cooldown.jailbreak');

    let newlyUnlockedAchievements: any[] = [];
    if (result.success) {
      try {
        const achievementResults = await checkAndUnlockAchievements(rescuerId);
        newlyUnlockedAchievements = achievementResults.map((r) =>
          serializeAchievementForClient(r.achievement)
        );
      } catch (err) {
        console.error('[Achievement Check] Error after jailbreak:', err);
      }
    }

    const eventKey = result.success
      ? 'jailbreak.success'
      : result.rescuerCaught
        ? 'jailbreak.caught'
        : 'jailbreak.failed';

    return res.status(200).json({
      event: eventKey,
      params: {
        success: result.success,
        rescuerCaught: result.rescuerCaught,
        rescuerJailTime: result.rescuerJailTime,
        message: result.message,
      },
      newlyUnlockedAchievements,
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'RESCUER_JAILED') {
        return res.status(400).json({
          event: 'error.rescuer_jailed',
          params: {},
        });
      }
      if (error.message === 'TARGET_NOT_JAILED') {
        return res.status(400).json({
          event: 'error.target_not_jailed',
          params: {},
        });
      }
      if (error.message === 'RESCUER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/prison/escape', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;

    const cooldownRemaining = await getPrisonActionCooldownRemaining(
      playerId,
      'prison.cooldown.escape'
    );
    if (cooldownRemaining > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType: 'prison_escape',
          remainingSeconds: cooldownRemaining,
          message: `Wait ${cooldownRemaining} seconds before attempting another escape`,
        },
      });
    }

    const result = await policeService.attemptSelfEscape(playerId);
    await markPrisonActionCooldown(playerId, 'prison.cooldown.escape');

    return res.status(200).json({
      event: result.success ? 'prison.escape_success' : 'prison.escape_failed',
      params: {
        remainingSeconds: result.remainingSeconds,
        penaltySeconds: result.penaltySeconds,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'NOT_JAILED') {
        return res.status(400).json({
          event: 'error.not_jailed',
          params: {},
        });
      }
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/prisoners', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const viewerId = req.player!.id;

    const [viewer, prisoners] = await Promise.all([
      playerService.getPlayer(viewerId),
      policeService.getJailedPrisoners(viewerId),
    ]);

    return res.status(200).json({
      event: 'prison.list',
      params: {
        count: prisoners.length,
      },
      viewerId,
      viewerMoney: viewer.money,
      prisoners,
    });
  } catch (error) {
    console.error('[Prison] Error loading prisoners:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/prison/buyout/:targetId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const buyerId = req.player!.id;
    const targetId = parseInt(req.params.targetId as string, 10);

    const cooldownRemaining = await getPrisonActionCooldownRemaining(
      buyerId,
      'prison.cooldown.bail'
    );
    if (cooldownRemaining > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType: 'prison_bail',
          remainingSeconds: cooldownRemaining,
          message: `Wait ${cooldownRemaining} seconds before paying bail again`,
        },
      });
    }

    if (!targetId || Number.isNaN(targetId)) {
      return res.status(400).json({
        event: 'error.invalid_target',
        params: {},
      });
    }

    const result = await policeService.buyOutPrisoner(buyerId, targetId);
    await markPrisonActionCooldown(buyerId, 'prison.cooldown.bail');

    let newlyUnlockedAchievements: any[] = [];
    try {
      const achievementResults = await checkAndUnlockAchievements(buyerId);
      newlyUnlockedAchievements = achievementResults.map((r) =>
        serializeAchievementForClient(r.achievement)
      );
    } catch (err) {
      console.error('[Achievement Check] Error after prison buyout:', err);
    }

    return res.status(200).json({
      event: 'prison.buyout_success',
      params: {
        amount: result.amount,
        targetUsername: result.targetUsername,
      },
      newlyUnlockedAchievements,
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'TARGET_NOT_JAILED') {
        return res.status(400).json({
          event: 'error.target_not_jailed',
          params: {},
        });
      }
      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          event: 'error.insufficient_funds',
          params: {},
        });
      }
      if (error.message === 'CANNOT_BUYOUT_SELF') {
        return res.status(400).json({
          event: 'error.cannot_buyout_self',
          params: {},
        });
      }
      if (error.message === 'TARGET_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
    }

    console.error('[Prison] Buyout error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get list of all players (for target selection)
router.get('/list', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const players = await prisma.player.findMany({
      where: {
        id: {
          not: req.player!.id, // Exclude current player
        },
      },
      select: {
        id: true,
        username: true,
        rank: true,
        xp: true,
      },
      orderBy: {
        username: 'asc',
      },
    });

    // Map rank to level for frontend compatibility
    const playersWithLevel = players.map((player) => ({
      ...player,
      level: player.rank, // In this game, rank IS the level
    }));

    return res.status(200).json({
      success: true,
      players: playersWithLevel,
    });
  } catch (error) {
    console.error('[PlayerService] List players error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Update player language preference
router.put('/language', authenticate, async (req: AuthRequest, res: Response) => {
  console.log('[PUT /player/language] Received request');
  console.log('[PUT /player/language] Body:', req.body);
  console.log('[PUT /player/language] Player:', req.player?.username);

  try {
    const { language } = req.body;

    // Validate language
    if (!language || !['en', 'nl'].includes(language)) {
      console.log('[PUT /player/language] Invalid language:', language);
      return res.status(400).json({
        event: 'error.invalid_language',
        params: {},
      });
    }

    // Update player language
    const updatedPlayer = await prisma.player.update({
      where: { id: req.player!.id },
      data: { preferredLanguage: language },
      select: {
        id: true,
        username: true,
        preferredLanguage: true,
      },
    });

    console.log(
      `[PlayerService] Updated language for ${updatedPlayer.username}: ${updatedPlayer.preferredLanguage}`
    );

    return res.status(200).json({
      event: 'language.updated',
      params: {},
      player: updatedPlayer,
    });
  } catch (error) {
    console.error('[PlayerService] Language update error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get dashboard statistics
router.get('/dashboard-stats', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    console.log('[Dashboard] Fetching stats for player:', playerId);
    const now = new Date();
    const last24hStart = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    const prev24hStart = new Date(now.getTime() - 48 * 60 * 60 * 1000);
    const last7dStart = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    // Get cooldowns
    const cooldowns = await getPlayerCooldowns(playerId);
    const parseNumber = (value: unknown): number => {
      if (typeof value === 'number' && Number.isFinite(value)) {
        return Math.trunc(value);
      }
      if (typeof value === 'bigint') {
        return Number(value);
      }
      if (typeof value === 'string') {
        const parsed = Number(value);
        return Number.isFinite(parsed) ? Math.trunc(parsed) : 0;
      }
      if (value && typeof value === 'object') {
        const parsed = Number((value as { toString: () => string }).toString());
        return Number.isFinite(parsed) ? Math.trunc(parsed) : 0;
      }
      return 0;
    };

    const toRemainingSeconds = (nextAllowedAt: Date | null): number => {
      if (!nextAllowedAt) return 0;
      return Math.max(0, Math.ceil((nextAllowedAt.getTime() - Date.now()) / 1000));
    };
    const parseFloatNumber = (value: unknown): number => {
      if (typeof value === 'number' && Number.isFinite(value)) {
        return value;
      }
      if (typeof value === 'bigint') {
        return Number(value);
      }
      if (typeof value === 'string') {
        const parsed = Number(value);
        return Number.isFinite(parsed) ? parsed : 0;
      }
      if (value && typeof value === 'object') {
        const parsed = Number((value as { toString: () => string }).toString());
        return Number.isFinite(parsed) ? parsed : 0;
      }
      return 0;
    };

    const [
      shootingStats,
      gymStats,
      drugInventoryAgg,
      nightclubVenueCount,
      nightclubRevenueAgg,
      nightclubSeasonState,
      crewWarHub,
      playerCore,
      breakoutCount,
      hitsPlacedCount,
      travelCount,
      crewMembership,
      unreadDirectMessagesCount,
      supportTicketsNeedingReply,
      worldEventsLast24hCount,
      activeDrugProductionsCount,
      nextDrugProduction,
      activeNightclubEventsCount,
      nextNightclubEvent,
      crimeIncomeLast24hAgg,
      crimeIncomePrev24hAgg,
      jobIncomeLast24hAgg,
      jobIncomePrev24hAgg,
      nightclubIncomeLast24hAgg,
      nightclubIncomePrev24hAgg,
      propertiesPurchasedLast24hAgg,
      propertiesPurchasedPrev24hAgg,
      crimeAttemptsLast7d,
      jobAttemptsLast7d,
      vehicleTheftsLast7d,
      travelCountLast7d,
      propertiesOwnedAgg,
      vehicleInventoryRows,
      cryptoHoldingRows,
    ] = await Promise.all([
      prisma.shootingRangeStats.findUnique({
        where: { playerId },
        select: { lastTrainedAt: true },
      }),
      prisma.gymStats.findUnique({
        where: { playerId },
        select: { lastTrainedAt: true },
      }),
      prisma.drugInventory.aggregate({
        where: { playerId },
        _sum: { quantity: true },
      }),
      prisma.nightclubVenue.count({
        where: { playerId },
      }),
      prisma.nightclubVenue.aggregate({
        where: { playerId },
        _sum: { totalRevenueAllTime: true },
      }),
      prisma.nightclubSeasonState.findUnique({
        where: { seasonKey: 'weekly-nightclub-season' },
        select: { seasonEndAt: true },
      }),
      crewWarService.getWarHubForPlayer(playerId).catch((error) => {
        console.error('[Dashboard] Crew war hub failed during dashboard stats load:', {
          playerId,
          error,
        });
        return emptyCrewWarHub();
      }),
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          killCount: true,
          money: true,
          rank: true,
          xp: true,
          wantedLevel: true,
          fbiHeat: true,
        },
      }),
      prisma.worldEvent.count({
        where: { playerId, eventKey: 'prison.escape_success' },
      }),
      prisma.hitList.count({
        where: { placedById: playerId },
      }),
      prisma.worldEvent.count({
        where: {
          playerId,
          eventKey: {
            in: ['travel.arrived', 'travel.journey_complete'],
          },
        },
      }),
      prisma.crewMember.findUnique({
        where: { playerId },
        select: { crewId: true, role: true },
      }),
      prisma.directMessage.count({
        where: {
          receiverId: playerId,
          read: false,
        },
      }),
      prisma.supportTicket.findMany({
        where: {
          playerId,
          status: {
            notIn: ['resolved', 'closed', 'archived'],
          },
          lastAdminMessageAt: {
            not: null,
          },
        },
        select: {
          id: true,
          lastAdminMessageAt: true,
          lastPlayerMessageAt: true,
        },
      }),
      prisma.worldEvent.count({
        where: {
          playerId,
          createdAt: { gte: last24hStart },
        },
      }),
      prisma.drugProduction.count({
        where: {
          playerId,
          completed: false,
          finishesAt: { gt: now },
        },
      }),
      prisma.drugProduction.findFirst({
        where: {
          playerId,
          completed: false,
          finishesAt: { gt: now },
        },
        orderBy: { finishesAt: 'asc' },
        select: { finishesAt: true },
      }),
      prisma.nightclubEvent.count({
        where: {
          venue: { playerId },
          startsAt: { lte: now },
          endsAt: { gt: now },
        },
      }),
      prisma.nightclubEvent.findFirst({
        where: {
          venue: { playerId },
          startsAt: { gt: now },
        },
        orderBy: { startsAt: 'asc' },
        select: { startsAt: true },
      }),
      prisma.crimeAttempt.aggregate({
        where: {
          playerId,
          createdAt: { gte: last24hStart },
        },
        _sum: { reward: true },
      }),
      prisma.crimeAttempt.aggregate({
        where: {
          playerId,
          createdAt: { gte: prev24hStart, lt: last24hStart },
        },
        _sum: { reward: true },
      }),
      prisma.jobAttempt.aggregate({
        where: {
          playerId,
          completedAt: { gte: last24hStart },
        },
        _sum: { earnings: true },
      }),
      prisma.jobAttempt.aggregate({
        where: {
          playerId,
          completedAt: { gte: prev24hStart, lt: last24hStart },
        },
        _sum: { earnings: true },
      }),
      prisma.nightclubSale.aggregate({
        where: {
          venue: { playerId },
          saleTime: { gte: last24hStart },
        },
        _sum: { totalRevenue: true },
      }),
      prisma.nightclubSale.aggregate({
        where: {
          venue: { playerId },
          saleTime: { gte: prev24hStart, lt: last24hStart },
        },
        _sum: { totalRevenue: true },
      }),
      prisma.property.aggregate({
        where: {
          playerId,
          purchasedAt: { gte: last24hStart },
        },
        _sum: { purchasePrice: true },
      }),
      prisma.property.aggregate({
        where: {
          playerId,
          purchasedAt: { gte: prev24hStart, lt: last24hStart },
        },
        _sum: { purchasePrice: true },
      }),
      prisma.crimeAttempt.count({
        where: {
          playerId,
          createdAt: { gte: last7dStart },
        },
      }),
      prisma.jobAttempt.count({
        where: {
          playerId,
          completedAt: { gte: last7dStart },
        },
      }),
      prisma.vehicleInventory.count({
        where: {
          playerId,
          stolenAt: { gte: last7dStart },
        },
      }),
      prisma.worldEvent.count({
        where: {
          playerId,
          eventKey: {
            in: ['travel.arrived', 'travel.journey_complete'],
          },
          createdAt: { gte: last7dStart },
        },
      }),
      prisma.property.aggregate({
        where: { playerId },
        _count: { id: true },
        _sum: { purchasePrice: true },
      }),
      prisma.vehicleInventory.findMany({
        where: { playerId },
        select: {
          vehicleId: true,
          condition: true,
          askingPrice: true,
          marketListing: true,
          transportStatus: true,
        },
      }),
      prisma.crypto_holdings.findMany({
        where: { player_id: playerId },
        select: {
          asset_symbol: true,
          quantity: true,
        },
      }),
    ]);

    const territoryLeaderStats =
      crewMembership?.role === 'leader'
        ? await territoryService.getCrewEconomySummary(crewMembership.crewId).catch((error) => {
            console.error(
              '[Dashboard] Territory crew summary failed during dashboard stats load:',
              {
                playerId,
                crewId: crewMembership.crewId,
                error,
              }
            );
            return null;
          })
        : null;

    const vehicleOpsEntries = await Promise.all(
      (['car', 'motorcycle', 'boat'] as const).map(async (vehicleType) => {
        try {
          const intelligence = await vehicleService.getVehicleOpsIntelligence(playerId, vehicleType);
          return [vehicleType, intelligence] as const;
        } catch (error) {
          console.error('[Dashboard] Vehicle Ops intelligence failed during dashboard stats load:', {
            playerId,
            vehicleType,
            error,
          });
          return [vehicleType, null] as const;
        }
      })
    );

    const summarizeVehicleOps = (intelligence: Record<string, any> | null) => {
      if (!intelligence) {
        return null;
      }

      const hotspot = (Array.isArray(intelligence.hotspots)
        ? intelligence.hotspots[0]
        : null) as Record<string, any> | null;
      const crewOp = (intelligence.crewOp ?? {}) as Record<string, any>;
      const chopContract = (intelligence.chopContract ?? {}) as Record<string, any>;
      const contractsBoard = (intelligence.contractsBoard ?? {}) as Record<string, any>;
      const crewMatchmaking = (intelligence.crewMatchmaking ?? {}) as Record<string, any>;
      const counterIntercept = (intelligence.counterIntercept ?? {}) as Record<string, any>;
      const categoryHeat = (intelligence.categoryHeat ?? {}) as Record<string, any>;
      const opsReputation = (intelligence.opsReputation ?? {}) as Record<string, any>;
      const contrabandInsurance = (intelligence.contrabandInsurance ?? {}) as Record<string, any>;
      const regionalBlacklist = (intelligence.regionalBlacklist ?? {}) as Record<string, any>;
      const partsMarket = (intelligence.partsMarket ?? {}) as Record<string, any>;
      const seasonCurrent = (crewMatchmaking.current ?? {}) as Record<string, any>;
      const openClaims = Array.isArray(contrabandInsurance.openClaims)
        ? contrabandInsurance.openClaims
        : [];
      const contracts = Array.isArray(contractsBoard.contracts) ? contractsBoard.contracts : [];

      return {
        heatCurrent: parseNumber(categoryHeat.current),
        heatLevel: (categoryHeat.level ?? 'LOW').toString(),
        reputationValue: parseNumber(opsReputation.value),
        reputationLevel: parseNumber(opsReputation.level),
        partsTrend: (partsMarket.trend ?? 'flat').toString(),
        blacklistActive: regionalBlacklist.active === true,
        crewAvailable: crewOp.available === true,
        crewName: crewOp.crewName?.toString() ?? null,
        contractsAvailable: contracts.length,
        openInsuranceClaims: openClaims.length,
        seasonPoints: parseNumber(seasonCurrent.points),
        seasonWins: parseNumber(seasonCurrent.wins),
        seasonLosses: parseNumber(seasonCurrent.losses),
        cooldowns: {
          hotspot: parseNumber(hotspot?.cooldownRemainingSeconds),
          crew: parseNumber(crewOp.cooldownRemainingSeconds),
          crewMatch: parseNumber(crewMatchmaking.cooldownRemainingSeconds),
          chop: parseNumber(chopContract.cooldownRemainingSeconds),
          contract: parseNumber(contractsBoard.cooldownRemainingSeconds),
          counter: parseNumber(counterIntercept.cooldownRemainingSeconds),
        },
      };
    };

    const vehicleOpsByType = Object.fromEntries(
      vehicleOpsEntries.map(([vehicleType, intelligence]) => [
        vehicleType,
        summarizeVehicleOps(intelligence as Record<string, any> | null),
      ])
    ) as {
      car: ReturnType<typeof summarizeVehicleOps>;
      motorcycle: ReturnType<typeof summarizeVehicleOps>;
      boat: ReturnType<typeof summarizeVehicleOps>;
    };

    const cooldownPlayer = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        lastProstituteRecruitment: true,
        lastHospitalVisit: true,
        isVip: true,
        vipExpiresAt: true,
      },
    });
    const vipCooldownActive = isVipStatusActive(cooldownPlayer);
    const trainingCooldownMs = applyVipTimeoutReductionMs(60 * 60 * 1000, vipCooldownActive);
    const prostituteRecruitCooldownSeconds = applyVipTimeoutReductionSeconds(
      PROSTITUTE_RECRUITMENT_COOLDOWN_SECONDS,
      vipCooldownActive
    );
    const hospitalCooldownMs = applyVipTimeoutReductionMs(
      config.hospitalCooldownMinutes * 60 * 1000,
      vipCooldownActive
    );

    cooldowns.shooting_range = toRemainingSeconds(
      shootingStats?.lastTrainedAt
        ? new Date(shootingStats.lastTrainedAt.getTime() + trainingCooldownMs)
        : null
    );

    cooldowns.gym = toRemainingSeconds(
      gymStats?.lastTrainedAt
        ? new Date(gymStats.lastTrainedAt.getTime() + trainingCooldownMs)
        : null
    );

    cooldowns.prostitute_recruit = toRemainingSeconds(
      cooldownPlayer?.lastProstituteRecruitment
        ? new Date(
            cooldownPlayer.lastProstituteRecruitment.getTime() +
              prostituteRecruitCooldownSeconds * 1000
          )
        : null
    );

    cooldowns.hospital = toRemainingSeconds(
      cooldownPlayer?.lastHospitalVisit
        ? new Date(cooldownPlayer.lastHospitalVisit.getTime() + hospitalCooldownMs)
        : null
    );

    cooldowns.nightclub = toRemainingSeconds(nightclubSeasonState?.seasonEndAt ?? null);

    console.log('[Dashboard] Cooldowns:', JSON.stringify(cooldowns));

    // Get crime attempts count
    const crimeAttempts = await prisma.crimeAttempt.count({
      where: { playerId },
    });

    // Get successful crimes count
    const successfulCrimes = await prisma.crimeAttempt.count({
      where: {
        playerId,
        success: true,
      },
    });

    // Get job attempts count
    const jobAttempts = await prisma.jobAttempt.count({
      where: { playerId },
    });

    // Get vehicle theft counts (auto stelen)
    const vehicleThieves = await prisma.vehicleInventory.count({
      where: {
        playerId,
        vehicleType: 'car',
      },
    });

    // Get boat theft counts (boot stelen)
    const boatThieves = await prisma.vehicleInventory.count({
      where: {
        playerId,
        vehicleType: 'boat',
      },
    });

    // Get prostitution distribution stats
    const [streetProstitutes, redLightProstitutes] = await Promise.all([
      prisma.prostitute.count({
        where: {
          playerId,
          location: 'street',
        },
      }),
      prisma.prostitute.count({
        where: {
          playerId,
          OR: [{ location: 'redlight' }, { redLightRoomId: { not: null } }],
        },
      }),
    ]);

    // Get player ammo count
    const ammoInventory = await prisma.ammoInventory.findMany({
      where: { playerId },
    });
    const totalAmmo = ammoInventory.reduce((sum, item) => sum + item.quantity, 0);
    const drugsTotalQuantity = Number(drugInventoryAgg._sum.quantity ?? 0);
    const nightclubRevenueAllTime = Number(nightclubRevenueAgg._sum.totalRevenueAllTime ?? 0n);
    const killCount = Number(playerCore?.killCount ?? 0);
    const cashBalance = Number(playerCore?.money ?? 0);
    const wantedLevel = Number(playerCore?.wantedLevel ?? 0);
    const fbiHeat = Number(playerCore?.fbiHeat ?? 0);

    const supportNeedsReplyCount = supportTicketsNeedingReply.filter((ticket) => {
      if (!ticket.lastAdminMessageAt) {
        return false;
      }
      if (!ticket.lastPlayerMessageAt) {
        return true;
      }
      return ticket.lastAdminMessageAt.getTime() > ticket.lastPlayerMessageAt.getTime();
    }).length;

    const crimeIncomeLast24h = Number(crimeIncomeLast24hAgg._sum.reward ?? 0);
    const crimeIncomePrev24h = Number(crimeIncomePrev24hAgg._sum.reward ?? 0);
    const jobIncomeLast24h = Number(jobIncomeLast24hAgg._sum.earnings ?? 0);
    const jobIncomePrev24h = Number(jobIncomePrev24hAgg._sum.earnings ?? 0);
    const nightclubIncomeLast24h = Number(nightclubIncomeLast24hAgg._sum.totalRevenue ?? 0);
    const nightclubIncomePrev24h = Number(nightclubIncomePrev24hAgg._sum.totalRevenue ?? 0);
    const propertySpendLast24h = Number(propertiesPurchasedLast24hAgg._sum.purchasePrice ?? 0);
    const propertySpendPrev24h = Number(propertiesPurchasedPrev24hAgg._sum.purchasePrice ?? 0);
    const grossIncomeLast24h = crimeIncomeLast24h + jobIncomeLast24h + nightclubIncomeLast24h;
    const grossIncomePrev24h = crimeIncomePrev24h + jobIncomePrev24h + nightclubIncomePrev24h;
    const netCashflowLast24h = grossIncomeLast24h - propertySpendLast24h;
    const netCashflowPrev24h = grossIncomePrev24h - propertySpendPrev24h;
    const cashflowTrendPercent =
      netCashflowPrev24h === 0
        ? netCashflowLast24h === 0
          ? 0
          : 100
        : Math.round(((netCashflowLast24h - netCashflowPrev24h) / Math.abs(netCashflowPrev24h)) * 100);

    const vehiclePortfolio = vehicleInventoryRows.reduce(
      (acc, vehicle) => {
        const def = vehicleService.getVehicleById(vehicle.vehicleId);
        const baseValue = def?.baseValue ?? 0;
        const estimatedValue = Math.round((baseValue * Math.max(0, vehicle.condition ?? 100)) / 100);
        acc.estimatedValue += Math.max(estimatedValue, parseNumber(vehicle.askingPrice));
        if (vehicle.marketListing) {
          acc.listedCount += 1;
        }
        if (vehicle.transportStatus) {
          acc.inTransitCount += 1;
        }
        return acc;
      },
      {
        totalCount: vehicleInventoryRows.length,
        listedCount: 0,
        inTransitCount: 0,
        estimatedValue: 0,
      }
    );

    const cryptoSymbols = Array.from(new Set(cryptoHoldingRows.map((holding) => holding.asset_symbol)));
    const cryptoAssets =
      cryptoSymbols.length > 0
        ? await prisma.crypto_assets.findMany({
            where: {
              symbol: { in: cryptoSymbols },
            },
            select: {
              symbol: true,
              current_price: true,
            },
          })
        : [];
    const cryptoPriceMap = new Map(
      cryptoAssets.map((asset) => [asset.symbol, parseFloatNumber(asset.current_price)])
    );
    const cryptoPortfolioValue = cryptoHoldingRows.reduce((sum, holding) => {
      const qty = parseFloatNumber(holding.quantity);
      const price = cryptoPriceMap.get(holding.asset_symbol) ?? 0;
      return sum + qty * price;
    }, 0);
    const propertyPortfolioValue = Number(propertiesOwnedAgg._sum.purchasePrice ?? 0);

    // Get player weapons
    const weapons = await prisma.weaponInventory.findMany({
      where: { playerId },
    });

    // Get selected vehicle for crimes (car or boat)
    const selectedVehicle = await prisma.playerSelectedVehicle.findUnique({
      where: { playerId },
      include: { vehicle: true },
    });

    const activeVehicle = selectedVehicle?.vehicle
      ? await prisma.vehicleInventory.findFirst({
          where: {
            playerId,
            vehicleId: selectedVehicle.vehicle.vehicleType,
            transportStatus: null,
          },
          orderBy: { stolenAt: 'desc' },
        })
      : null;

    const selectedCrimeWeapon = await weaponSelectionService.getSelectedCrimeWeapon(playerId);

    const currentCrewWar = crewWarHub.currentWar;
    const myCrewId = crewWarHub.myCrewId;
    const currentStanding =
      currentCrewWar && myCrewId
        ? (currentCrewWar.standings.find((standing: any) => standing.crewId === myCrewId) ?? null)
        : null;
    const opponentCrew =
      currentCrewWar && myCrewId
        ? currentCrewWar.attackerCrewId === myCrewId
          ? currentCrewWar.defenderCrew
          : currentCrewWar.attackerCrew
        : null;
    const seasonRankEntry =
      myCrewId != null
        ? (crewWarHub.seasonLeaderboard.find((entry: any) => entry.crewId === myCrewId) ?? null)
        : null;
    const phaseEndsAt = currentCrewWar
      ? currentCrewWar.status === 'preparing'
        ? currentCrewWar.activeFrom
        : currentCrewWar.status === 'active'
          ? (currentCrewWar.lockDownFrom ?? currentCrewWar.endTime)
          : currentCrewWar.endTime
      : null;
    const crewWarPhaseEndsInSeconds = phaseEndsAt
      ? Math.max(0, Math.ceil((new Date(phaseEndsAt).getTime() - Date.now()) / 1000))
      : 0;

    // Get jail status
    const jailStatus = await policeService.checkIfJailed(playerId);

    // Get bank balance
    const bankAccount = await prisma.bankAccount.findUnique({
      where: { playerId },
    });
    const bankBalance = Number(bankAccount?.balance ?? 0);
    const activeCooldownCount = Object.values(cooldowns).filter((value) => value > 0).length;
    const longestCooldownSeconds = Object.values(cooldowns).reduce(
      (max, value) => (value > max ? value : max),
      0
    );
    const nextDrugProductionEndsInSeconds = nextDrugProduction?.finishesAt
      ? toRemainingSeconds(nextDrugProduction.finishesAt)
      : 0;
    const nextNightclubEventStartsInSeconds = nextNightclubEvent?.startsAt
      ? toRemainingSeconds(nextNightclubEvent.startsAt)
      : 0;
    const riskScore = Math.min(
      100,
      Math.max(0, Math.round(wantedLevel * 0.6 + fbiHeat * 0.4 + activeCooldownCount * 1.5))
    );
    const netWorth =
      cashBalance + bankBalance + propertyPortfolioValue + vehiclePortfolio.estimatedValue + cryptoPortfolioValue;

    return res.status(200).json({
      event: 'dashboard.stats',
      params: {},
      stats: {
        crimeAttempts,
        breakoutCount,
        killCount,
        hitsPlacedCount,
        successfulCrimes,
        jobAttempts,
        vehicleThieves,
        boatThieves,
        streetProstitutes,
        redLightProstitutes,
        totalAmmo,
        drugsTotalQuantity,
        nightclubVenues: nightclubVenueCount,
        nightclubRevenueAllTime,
        travelCount,
        weapons: weapons.map((w) => {
          const weaponDefinition = weaponService.getWeaponDefinition(w.weaponId);
          return {
            id: w.id,
            name: weaponDefinition?.name ?? w.weaponId,
            condition: w.condition,
          };
        }),
        selectedWeaponName: selectedCrimeWeapon?.name ?? null,
        activeVehicle: activeVehicle
          ? {
              id: activeVehicle.id,
              name:
                vehicleService.getVehicleById(activeVehicle.vehicleId)?.name ??
                activeVehicle.vehicleId,
              type: activeVehicle.vehicleType,
              location: activeVehicle.currentLocation,
              fuel: activeVehicle.fuelLevel,
            }
          : null,
        jailed: jailStatus > 0,
        jailTimeRemaining: jailStatus,
        bankBalance,
        economy: {
          cashBalance,
          bankBalance,
          cryptoPortfolioValue: Math.round(cryptoPortfolioValue),
          propertyPortfolioValue,
          vehiclePortfolioValue: vehiclePortfolio.estimatedValue,
          netWorth: Math.round(netWorth),
        },
        economy24h: {
          crimeIncome: crimeIncomeLast24h,
          jobIncome: jobIncomeLast24h,
          nightclubIncome: nightclubIncomeLast24h,
          propertySpend: propertySpendLast24h,
          grossIncome: grossIncomeLast24h,
          netCashflow: netCashflowLast24h,
          trendVsPreviousPct: cashflowTrendPercent,
        },
        activity7d: {
          crimeAttempts: crimeAttemptsLast7d,
          jobAttempts: jobAttemptsLast7d,
          vehicleThefts: vehicleTheftsLast7d,
          travels: travelCountLast7d,
        },
        operations: {
          activeCooldownCount,
          longestCooldownSeconds,
          activeDrugProductionsCount,
          nextDrugProductionEndsInSeconds,
          activeNightclubEventsCount,
          nextNightclubEventStartsInSeconds,
          activeVehicleCount: vehiclePortfolio.totalCount,
          listedVehicleCount: vehiclePortfolio.listedCount,
          inTransitVehicleCount: vehiclePortfolio.inTransitCount,
        },
        notifications: {
          unreadDirectMessages: unreadDirectMessagesCount,
          supportNeedsReply: supportNeedsReplyCount,
          eventsLast24h: worldEventsLast24hCount,
        },
        risk: {
          wantedLevel,
          fbiHeat,
          score: riskScore,
        },
        crewWar: {
          hasActiveWar: Boolean(currentCrewWar),
          canDeclare: crewWarHub.canDeclare === true,
          status: currentCrewWar?.status ?? null,
          warType: currentCrewWar?.warType ?? null,
          opponentCrewName: opponentCrew?.name ?? null,
          myCrewPoints: currentStanding?.totalPoints ?? 0,
          myCrewRank: currentStanding?.rank ?? null,
          seasonRank: seasonRankEntry?.rank ?? null,
          availableTargetsCount: Array.isArray(crewWarHub.availableTargets)
            ? crewWarHub.availableTargets.length
            : 0,
          phaseEndsInSeconds: crewWarPhaseEndsInSeconds,
        },
        territoryLeaderStats,
        vehicleOps: {
          hasCrew: Boolean(crewMembership),
          crewRole: crewMembership?.role ?? null,
          car: vehicleOpsByType.car,
          motorcycle: vehicleOpsByType.motorcycle,
          boat: vehicleOpsByType.boat,
        },
        cooldowns,
      },
    });
  } catch (error) {
    console.error('[Dashboard] Error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
