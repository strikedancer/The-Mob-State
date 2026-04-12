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
import { checkAndUnlockAchievements, serializeAchievementForClient } from '../services/achievementService';
import { existsCached } from '../services/redisClient';

const router = Router();
const PROSTITUTE_RECRUITMENT_COOLDOWN_SECONDS = 5 * 60;
const PRISON_ACTION_COOLDOWN_SECONDS = 30;

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
      params: {},
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
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get jail status
router.get('/jail-status', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const remainingTime = await policeService.checkIfJailed(req.player!.id);

    return res.status(200).json({
      jailed: remainingTime > 0,
      remainingTime,
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

    const cooldownRemaining = await getPrisonActionCooldownRemaining(
      playerId,
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

    // Get player data for bail calculation
    const player = await playerService.getPlayer(playerId);
    const bail = policeService.calculateBail(player.wantedLevel || 0);

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
    await policeService.payBail(playerId);
    await markPrisonActionCooldown(playerId, 'prison.cooldown.bail');

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
      Math.floor((nowMs - new Date(lastSeenAt).getTime()) / 1000),
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
    if (
      error instanceof Prisma.PrismaClientKnownRequestError &&
      error.code === 'P2002'
    ) {
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
        newlyUnlockedAchievements = achievementResults.map(r =>
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
      newlyUnlockedAchievements = achievementResults.map(r =>
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
    const playersWithLevel = players.map(player => ({
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

    console.log(`[PlayerService] Updated language for ${updatedPlayer.username}: ${updatedPlayer.preferredLanguage}`);

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

    // Get cooldowns
    const cooldowns = await getPlayerCooldowns(playerId);

    const toRemainingSeconds = (nextAllowedAt: Date | null): number => {
      if (!nextAllowedAt) return 0;
      return Math.max(0, Math.ceil((nextAllowedAt.getTime() - Date.now()) / 1000));
    };

    const [shootingStats, gymStats, drugInventoryAgg, nightclubVenueCount, nightclubRevenueAgg, nightclubSeasonState] = await Promise.all([
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
    ]);

    const cooldownPlayer = await prisma.player.findUnique({
      where: { id: playerId },
      select: { lastProstituteRecruitment: true, lastHospitalVisit: true },
    });

    cooldowns.shooting_range = toRemainingSeconds(
      shootingStats?.lastTrainedAt
        ? new Date(shootingStats.lastTrainedAt.getTime() + 60 * 60 * 1000)
        : null,
    );

    cooldowns.gym = toRemainingSeconds(
      gymStats?.lastTrainedAt
        ? new Date(gymStats.lastTrainedAt.getTime() + 60 * 60 * 1000)
        : null,
    );

    cooldowns.prostitute_recruit = toRemainingSeconds(
      cooldownPlayer?.lastProstituteRecruitment
        ? new Date(
            cooldownPlayer.lastProstituteRecruitment.getTime() +
              PROSTITUTE_RECRUITMENT_COOLDOWN_SECONDS * 1000,
          )
        : null,
    );

    cooldowns.hospital = toRemainingSeconds(
      cooldownPlayer?.lastHospitalVisit
        ? new Date(
            cooldownPlayer.lastHospitalVisit.getTime() +
              config.hospitalCooldownMinutes * 60 * 1000,
          )
        : null,
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

    const selectedCrimeWeapon = await weaponSelectionService.getSelectedCrimeWeapon(
      playerId,
    );

    // Get jail status
    const jailStatus = await policeService.checkIfJailed(playerId);

    // Get bank balance
    const bankAccount = await prisma.bankAccount.findUnique({
      where: { playerId },
    });

    return res.status(200).json({
      event: 'dashboard.stats',
      params: {},
      stats: {
        crimeAttempts,
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
        bankBalance: bankAccount?.balance || 0,
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
