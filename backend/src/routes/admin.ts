import express from 'express';
import prisma from '../lib/prisma';
import { auditLog } from '../middleware/auditLog';
import { adminAuthMiddleware, requireAdminRole, type AdminRequest } from '../middleware/adminAuth';
import { z } from 'zod';
import fs from 'fs/promises';
import path from 'path';
import { AdminRole, Prisma } from '@prisma/client';
import bcrypt from 'bcryptjs';
import {
  getCronStatus,
  checkExpiredEvents,
  updateLeaderboards,
  resetWeeklyLeaderboard,
  cleanupOldRivalries,
} from '../services/cronService';
import { getRankFromXP, getXPForRank } from '../config';
import { notificationService } from '../services/notificationService';
import { existsCached, isRedisConnected } from '../services/redisClient';
import { queueService } from '../queues/queueService';

const router = express.Router();

type ActivitySort = 'date_desc' | 'date_asc' | 'type_asc' | 'type_desc';
type ActivityDateRange = '24h' | '7d' | '30d' | 'all';

const getRangeStartForActivities = (range: ActivityDateRange): Date | null => {
  const now = Date.now();
  if (range === '24h') return new Date(now - 24 * 60 * 60 * 1000);
  if (range === '7d') return new Date(now - 7 * 24 * 60 * 60 * 1000);
  if (range === '30d') return new Date(now - 30 * 24 * 60 * 60 * 1000);
  return null;
};

const parseActivityDetails = (details: unknown): Record<string, unknown> | null => {
  if (!details) return null;
  if (typeof details === 'string') {
    try {
      const parsed = JSON.parse(details);
      if (parsed && typeof parsed === 'object') return parsed as Record<string, unknown>;
      return null;
    } catch {
      return null;
    }
  }
  if (typeof details === 'object') {
    return details as Record<string, unknown>;
  }
  return null;
};

const parseWorldEventParams = (params: unknown): Record<string, unknown> => {
  if (!params) return {};
  if (typeof params === 'string') {
    try {
      const parsed = JSON.parse(params);
      if (parsed && typeof parsed === 'object') {
        return parsed as Record<string, unknown>;
      }
      return {};
    } catch {
      return {};
    }
  }
  if (typeof params === 'object') {
    return params as Record<string, unknown>;
  }
  return {};
};

const getActivityMoneyAmount = (details: unknown): number => {
  const parsed = parseActivityDetails(details);
  if (!parsed) return 0;
  const reward = parsed.reward;
  const earnings = parsed.earnings;
  if (typeof reward === 'number') return reward;
  if (typeof earnings === 'number') return earnings;
  return 0;
};

const getActivityXpAmount = (details: unknown): number => {
  const parsed = parseActivityDetails(details);
  if (!parsed) return 0;
  const xp = parsed.xpGained;
  return typeof xp === 'number' ? xp : 0;
};

const toCsvValue = (value: unknown): string => {
  const text = value === null || value === undefined ? '' : String(value);
  return `"${text.replace(/"/g, '""')}"`;
};

// Apply admin authentication to all routes
router.use(adminAuthMiddleware);

// Validation schemas
const banPlayerSchema = z.object({
  playerId: z.number().int().positive(),
  reason: z.string().min(5).max(500),
  duration: z.number().int().positive().optional(), // Duration in hours, undefined = permanent
});

const editPlayerSchema = z.object({
  playerId: z.number().int().positive(),
  updates: z.object({
    money: z.coerce.number().int().optional(),
    health: z.coerce.number().min(0).max(100).optional(),
    rank: z.coerce.number().int().min(1).optional(),
    currentCountry: z.string().optional(),
  }),
});

const grantVipSchema = z.object({
  username: z.string().min(1),
  days: z.number().int().positive().max(365).default(7),
});

const playerManageSchema = z.object({
  playerId: z.number().int().positive(),
  reason: z.string().min(5).max(500).optional(),
  set: z.object({
    money: z.number().int().optional(),
    rank: z.number().int().min(1).optional(),
    xp: z.number().int().min(0).optional(),
    health: z.number().int().min(0).max(100).optional(),
    currentCountry: z.string().min(2).optional(),
  }).optional(),
  add: z.object({
    money: z.number().int().optional(),
    xp: z.number().int().optional(),
  }).optional(),
  vip: z.object({
    enabled: z.boolean(),
    days: z.number().int().positive().max(365).optional(),
  }).optional(),
  ammo: z.object({
    ammoType: z.string().min(2).max(50),
    quantity: z.number().int().positive(),
  }).optional(),
  tool: z.object({
    toolId: z.string().min(2).max(50),
    quantity: z.number().int().positive().default(1),
    durability: z.number().int().min(1).max(100).default(100),
    location: z.string().min(1).max(50).default('carried'),
  }).optional(),
});

const bulkPlayerActionSchema = z.object({
  playerIds: z.array(z.number().int().positive()).min(1).max(200),
  action: z.enum(['warn', 'ban_temp', 'add_money']),
  reason: z.string().min(5).max(500),
  durationHours: z.number().int().min(1).max(24 * 365).optional(),
  amount: z.number().int().positive().optional(),
});

const vehicleStatsSchema = z.object({
  speed: z.number().int().min(0).max(100),
  armor: z.number().int().min(0).max(100),
  cargo: z.number().int().min(0).max(100),
  stealth: z.number().int().min(0).max(100),
});

const vehicleSchema = z.object({
  id: z.string().min(2),
  name: z.string().min(1),
  type: z.string().min(1),
  image: z.string().min(1).optional(),
  imageNew: z.string().min(1),
  imageDirty: z.string().min(1),
  imageDamaged: z.string().min(1),
  stats: vehicleStatsSchema,
  description: z.string().min(1),
  availableInCountries: z.array(z.string().min(1)).min(1),
  baseValue: z.number().int().positive(),
  marketValue: z.record(z.number().int().positive()),
  fuelCapacity: z.number().int().positive(),
  requiredRank: z.number().int().min(1),
  rarity: z.enum(['common', 'uncommon', 'rare', 'epic', 'legendary']).default('common'),
});

const addVehicleSchema = z.object({
  category: z.enum(['cars', 'boats']),
  vehicle: vehicleSchema,
});

const aircraftSchema = z.object({
  id: z.string().min(2),
  name: z.string().min(1),
  type: z.string().min(1),
  description: z.string().min(1),
  price: z.number().int().positive(),
  minRank: z.number().int().min(1),
  maxRange: z.number().int().positive(),
  fuelCapacity: z.number().int().positive(),
  fuelCostPerKm: z.number().int().positive(),
  repairCost: z.number().int().positive(),
  speedMultiplier: z.number().positive(),
  cargoCapacity: z.number().int().positive(),
  image: z.string().optional(),
});

const toolSchema = z.object({
  id: z.string().min(2).regex(/^[a-z0-9_]+$/),
  name: z.string().min(1),
  type: z.string().min(1),
  basePrice: z.number().int().positive(),
  maxDurability: z.number().int().positive(),
  loseChance: z.number().min(0).max(1),
  wearPerUse: z.number().int().min(0).max(100),
  requiredFor: z.array(z.string()).default([]),
  image: z.string().optional(),
});

const crimeSchema = z.object({
  id: z.string().min(2).regex(/^[a-z0-9_]+$/),
  name: z.string().min(1),
  description: z.string().min(1),
  minLevel: z.number().int().min(1),
  baseSuccessChance: z.number().min(0).max(1),
  minReward: z.number().int().positive(),
  maxReward: z.number().int().positive(),
  xpReward: z.number().int().positive(),
  minXpReward: z.number().int().positive().optional(),
  maxXpReward: z.number().int().positive().optional(),
  jailTime: z.number().int().positive(),
  requiredVehicle: z.boolean(),
  requiredVehicleType: z.enum(['car', 'boat', 'aircraft']).nullable().optional(),
  breakdownChance: z.number().min(0).max(1),
  requiredTools: z.array(z.string()).optional(),
  requiredWeapon: z.boolean().optional(),
  isFederal: z.boolean().optional(),
}).passthrough();

const updatePremiumOfferSchema = z.object({
  titleNl: z.string().min(1).max(120),
  titleEn: z.string().min(1).max(120),
  imageUrl: z.string().max(500).nullable().optional(),
  priceEurCents: z.number().int().positive(),
  rewardType: z.enum(['money', 'ammo']),
  moneyAmount: z.number().int().positive().nullable().optional(),
  ammoType: z.string().min(1).max(50).nullable().optional(),
  ammoQuantity: z.number().int().positive().nullable().optional(),
  isActive: z.boolean(),
  showPopupOnOpen: z.boolean().default(false),
  sortOrder: z.number().int().min(0),
});

const createPremiumOfferSchema = z.object({
  key: z.string().min(2).max(64).regex(/^[a-z0-9_\-]+$/),
  titleNl: z.string().min(1).max(120),
  titleEn: z.string().min(1).max(120),
  imageUrl: z.string().max(500).nullable().optional(),
  priceEurCents: z.number().int().positive(),
  rewardType: z.enum(['money', 'ammo']),
  moneyAmount: z.number().int().positive().nullable().optional(),
  ammoType: z.string().min(1).max(50).nullable().optional(),
  ammoQuantity: z.number().int().positive().nullable().optional(),
  isActive: z.boolean().default(true),
  showPopupOnOpen: z.boolean().default(false),
  sortOrder: z.number().int().min(0).default(0),
  notifyAllPlayers: z.boolean().default(false),
});

const createAdminSchema = z.object({
  username: z.string().min(3).max(50).regex(/^[a-zA-Z0-9_\-.]+$/),
  password: z.string().min(8).max(128),
  role: z.nativeEnum(AdminRole).default(AdminRole.VIEWER),
});

const updateAdminSchema = z.object({
  role: z.nativeEnum(AdminRole).optional(),
  isActive: z.boolean().optional(),
  password: z.string().min(8).max(128).optional(),
}).refine((payload) => payload.role !== undefined || payload.isActive !== undefined || payload.password !== undefined, {
  message: 'At least one field must be provided',
});

const vehiclesFilePath = path.join(__dirname, '../../content/vehicles.json');
const aircraftFilePath = path.join(__dirname, '../../content/aircraft.json');
const toolsFilePath = path.join(__dirname, '../../data/tools.json');
const crimesFilePath = path.join(__dirname, '../../content/crimes.json');

type VehiclesFile = {
  cars: Array<z.infer<typeof vehicleSchema>>;
  boats: Array<z.infer<typeof vehicleSchema>>;
};

const readVehiclesFile = async (): Promise<VehiclesFile> => {
  const content = await fs.readFile(vehiclesFilePath, 'utf-8');
  const parsed = JSON.parse(content);
  return {
    cars: Array.isArray(parsed.cars) ? parsed.cars : [],
    boats: Array.isArray(parsed.boats) ? parsed.boats : [],
  };
};

const writeVehiclesFile = async (vehicles: VehiclesFile): Promise<void> => {
  await fs.writeFile(vehiclesFilePath, `${JSON.stringify(vehicles, null, 2)}\n`, 'utf-8');
};

type AircraftDef = z.infer<typeof aircraftSchema>;

const readAircraftFile = async (): Promise<AircraftDef[]> => {
  const content = await fs.readFile(aircraftFilePath, 'utf-8');
  const parsed = JSON.parse(content);
  return Array.isArray(parsed) ? parsed : [];
};

const writeAircraftFile = async (list: AircraftDef[]): Promise<void> => {
  await fs.writeFile(aircraftFilePath, `${JSON.stringify(list, null, 2)}\n`, 'utf-8');
};

type ToolDef = z.infer<typeof toolSchema>;

const readToolsFile = async (): Promise<ToolDef[]> => {
  const content = await fs.readFile(toolsFilePath, 'utf-8');
  const parsed = JSON.parse(content);
  return Array.isArray(parsed.tools) ? parsed.tools : [];
};

const writeToolsFile = async (tools: ToolDef[]): Promise<void> => {
  await fs.writeFile(toolsFilePath, `${JSON.stringify({ tools }, null, 2)}\n`, 'utf-8');
};

type CrimeDef = z.infer<typeof crimeSchema>;

const readCrimesFile = async (): Promise<CrimeDef[]> => {
  const content = await fs.readFile(crimesFilePath, 'utf-8');
  const parsed = JSON.parse(content);
  return Array.isArray(parsed.crimes) ? parsed.crimes : [];
};

const writeCrimesFile = async (crimes: CrimeDef[]): Promise<void> => {
  await fs.writeFile(crimesFilePath, `${JSON.stringify({ crimes }, null, 2)}\n`, 'utf-8');
};

/**
 * GET /api/admin/stats
 * Get dashboard statistics
 */
router.get('/stats', async (_req, res) => {
  try {
    const [totalPlayers, activePlayers, bannedPlayers] = await Promise.all([
      prisma.player.count(),
      prisma.player.count({
        where: {
          updatedAt: {
            gte: new Date(Date.now() - 24 * 60 * 60 * 1000), // Last 24h
          },
        },
      }),
      prisma.player.count({
        where: {
          isBanned: true,
        },
      }),
    ]);

    res.json({
      totalPlayers,
      activePlayers,
      bannedPlayers,
    });
  } catch (error) {
    console.error('Admin stats error:', error);
    res.status(500).json({ error: 'Failed to fetch stats' });
  }
});

router.get('/dashboard-overview', async (_req, res) => {
  try {
    const now = Date.now();
    const oneDayAgo = new Date(now - 24 * 60 * 60 * 1000);
    const sevenDaysAgo = new Date(now - 7 * 24 * 60 * 60 * 1000);
    const cronStatus = getCronStatus();
    const redisOk = isRedisConnected();
    const queueOk = queueService.isAvailable();
    const cronLastExecutions = Object.values(cronStatus.lastExecutions || {});
    const cronFresh = cronLastExecutions.some((value: any) => {
      const date = value instanceof Date ? value : new Date(value);
      return !Number.isNaN(date.getTime()) && now - date.getTime() <= 15 * 60 * 1000;
    });

    const [recentAuditLogs, recentSystemErrors, activePlayers, recentRegistrations, riskyPlayers] = await Promise.all([
      prisma.auditLog.findMany({
        orderBy: { createdAt: 'desc' },
        take: 8,
        include: {
          admin: {
            select: {
              username: true,
            },
          },
        },
      }),
      prisma.worldEvent.findMany({
        where: {
          eventKey: 'system.error',
          createdAt: { gte: oneDayAgo },
        },
        orderBy: { createdAt: 'desc' },
        take: 8,
        select: {
          id: true,
          eventKey: true,
          params: true,
          createdAt: true,
        },
      }),
      prisma.player.findMany({
        where: { updatedAt: { gte: sevenDaysAgo } },
        select: { updatedAt: true, createdAt: true },
      }),
      prisma.player.findMany({
        where: { createdAt: { gte: sevenDaysAgo } },
        select: { createdAt: true },
      }),
      prisma.player.findMany({
        orderBy: [{ wantedLevel: 'desc' }, { fbiHeat: 'desc' }, { money: 'desc' }],
        take: 12,
        select: {
          id: true,
          username: true,
          money: true,
          rank: true,
          health: true,
          isBanned: true,
          wantedLevel: true,
          fbiHeat: true,
          updatedAt: true,
          currentCountry: true,
        },
      }),
    ]);

    const alerts: Array<{ severity: 'danger' | 'warning' | 'info'; title: string; description: string }> = [];
    if (!redisOk) {
      alerts.push({ severity: 'warning', title: 'Redis degraded', description: 'Caching and presence tracking are unavailable.' });
    }
    if (!queueOk) {
      alerts.push({ severity: 'warning', title: 'Queue unavailable', description: 'Background jobs are disabled because Redis queue is unavailable.' });
    }
    if (!cronFresh) {
      alerts.push({ severity: 'warning', title: 'Cron stale', description: 'No recent cron execution was detected in the last 15 minutes.' });
    }
    if (recentSystemErrors.length > 0) {
      alerts.push({ severity: 'danger', title: 'Recent system errors', description: `${recentSystemErrors.length} system errors were captured in the last 24 hours.` });
    }
    if (alerts.length === 0) {
      alerts.push({ severity: 'info', title: 'No active alerts', description: 'All critical platform checks look healthy right now.' });
    }

    const activityFeed = [
      ...recentAuditLogs.map((entry) => ({
        id: `audit-${entry.id}`,
        type: 'audit',
        title: `${entry.action}${entry.targetId ? ` #${entry.targetId}` : ''}`,
        description: entry.admin ? `Admin ${entry.admin.username}` : 'Admin action',
        createdAt: entry.createdAt,
      })),
      ...recentSystemErrors.map((entry) => {
        const eventParams = parseWorldEventParams(entry.params);
        return {
        id: `error-${entry.id}`,
        type: 'system',
        title: 'System error',
        description: String(eventParams.message || eventParams.details || 'Runtime error'),
        createdAt: entry.createdAt,
      }}),
    ]
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
      .slice(0, 10);

    const dayKeys = Array.from({ length: 7 }, (_, index) => {
      const date = new Date(now - (6 - index) * 24 * 60 * 60 * 1000);
      return date.toISOString().slice(0, 10);
    });

    const buildSeries = (dates: string[]) => {
      const map = new Map<string, number>();
      dayKeys.forEach((key) => map.set(key, 0));
      dates.forEach((date) => {
        if (map.has(date)) {
          map.set(date, (map.get(date) || 0) + 1);
        }
      });
      return dayKeys.map((date) => ({ date, value: map.get(date) || 0 }));
    };

    const trends = {
      activePlayers: buildSeries(activePlayers.map((player) => player.updatedAt.toISOString().slice(0, 10))),
      registrations: buildSeries(recentRegistrations.map((player) => player.createdAt.toISOString().slice(0, 10))),
      adminActions: buildSeries(recentAuditLogs.map((entry) => entry.createdAt.toISOString().slice(0, 10))),
    };

    const riskPlayers = riskyPlayers
      .map((player) => ({
        ...player,
        riskScore:
          player.wantedLevel * 4 +
          player.fbiHeat * 2 +
          (player.isBanned ? 8 : 0) +
          (player.health < 35 ? 2 : 0) +
          (player.money >= 5_000_000 ? 2 : 0),
      }))
      .sort((a, b) => b.riskScore - a.riskScore)
      .slice(0, 5);

    return res.json({
      alerts,
      activityFeed,
      trends,
      riskPlayers,
      quickStats: {
        systemErrors24h: recentSystemErrors.length,
        adminActions24h: recentAuditLogs.filter((entry) => entry.createdAt >= oneDayAgo).length,
      },
    });
  } catch (error) {
    console.error('Admin dashboard overview error:', error);
    return res.status(500).json({ error: 'Failed to fetch dashboard overview' });
  }
});

/**
 * GET /api/admin/players
 * Get all players with pagination
 */
router.get('/players', async (req, res) => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 20;
    const skip = (page - 1) * limit;
    const search = String(req.query.search || '').trim();

    const where: Prisma.PlayerWhereInput = search
      ? {
          OR: [
            { username: { contains: search, mode: 'insensitive' } },
            ...(Number.isFinite(Number(search)) ? [{ id: Number(search) }] : []),
          ],
        }
      : {};

    const [players, total] = await Promise.all([
      prisma.player.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          username: true,
          money: true,
          rank: true,
          health: true,
          currentCountry: true,
          avatar: true,
          createdAt: true,
          updatedAt: true,
        },
      }),
      prisma.player.count({ where }),
    ]);

    const onlineFlags = await Promise.all(
      players.map(p => existsCached(`online:${p.id}`))
    );

    const playersWithOnline = players.map((p, i) => ({
      ...p,
      isOnline: onlineFlags[i],
    }));

    res.json({
      players: playersWithOnline,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    });
  } catch (error) {
    console.error('Admin get players error:', error);
    res.status(500).json({ error: 'Failed to fetch players' });
  }
});

/**
 * GET /api/admin/players/:playerId/overview
 * Get detailed player profile, statistics, assets, activity and projections
 */
router.get('/players/:playerId/overview', async (req, res) => {
  try {
    const playerId = Number(req.params.playerId);
    if (!Number.isFinite(playerId) || playerId <= 0) {
      return res.status(400).json({ error: 'Invalid player id' });
    }

    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);

    let [
      player,
      crimeAggregate,
      crimeSuccess,
      crimeFailed,
      crimeJailed,
      crimeLast7,
      jobAggregate,
      jobLast7,
      totalFlights,
      properties,
      playerTools,
      inventory,
      vehicleInventory,
      ammoInventory,
      weaponInventory,
      recentActivities,
      recentCrimes,
      recentJobs,
      travelActivitiesLast7,
      bankAccount,
      casinoAsPlayer,
      casinoAsOwner,
      casinoAsPlayerTotals,
      casinoAsOwnerTotals,
      premiumFulfillments,
    ] = await Promise.all([
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          id: true,
          username: true,
          email: true,
          money: true,
          rank: true,
          xp: true,
          health: true,
          currentCountry: true,
          isVip: true,
          vipExpiresAt: true,
          isBanned: true,
          bannedUntil: true,
          banReason: true,
          wantedLevel: true,
          fbiHeat: true,
          reputation: true,
          killCount: true,
          hitCount: true,
          inventory_slots_used: true,
          max_inventory_slots: true,
          createdAt: true,
          updatedAt: true,
        },
      }),
      prisma.crimeAttempt.aggregate({
        where: { playerId },
        _count: { _all: true },
        _sum: { reward: true, xpGained: true, jailTime: true, lootStolen: true },
      }),
      prisma.crimeAttempt.count({ where: { playerId, success: true } }),
      prisma.crimeAttempt.count({ where: { playerId, success: false } }),
      prisma.crimeAttempt.count({ where: { playerId, jailed: true } }),
      prisma.crimeAttempt.aggregate({
        where: { playerId, createdAt: { gte: sevenDaysAgo } },
        _count: { _all: true },
        _sum: { reward: true, xpGained: true },
      }),
      prisma.jobAttempt.aggregate({
        where: { playerId },
        _count: { _all: true },
        _sum: { earnings: true, xpGained: true },
      }),
      prisma.jobAttempt.aggregate({
        where: { playerId, completedAt: { gte: sevenDaysAgo } },
        _count: { _all: true },
        _sum: { earnings: true, xpGained: true },
      }),
      prisma.aircraft.aggregate({ where: { playerId }, _sum: { totalFlights: true } }),
      prisma.property.findMany({
        where: { playerId },
        orderBy: { purchasedAt: 'desc' },
        select: {
          id: true,
          propertyId: true,
          countryId: true,
          propertyType: true,
          purchasePrice: true,
          upgradeLevel: true,
          purchasedAt: true,
        },
      }),
      prisma.playerTools.findMany({
        where: { playerId },
        include: {
          tool: {
            select: {
              name: true,
              type: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.inventory.findMany({
        where: { playerId },
        orderBy: [{ quantity: 'desc' }, { goodType: 'asc' }],
        take: 50,
      }),
      prisma.vehicleInventory.findMany({
        where: { playerId },
        orderBy: { stolenAt: 'desc' },
      }),
      prisma.ammoInventory.findMany({ where: { playerId }, orderBy: { quantity: 'desc' } }),
      prisma.weaponInventory.findMany({ where: { playerId }, orderBy: { quantity: 'desc' } }),
      prisma.playerActivity.findMany({
        where: { playerId },
        orderBy: { createdAt: 'desc' },
        take: 40,
      }),
      prisma.crimeAttempt.findMany({
        where: { playerId },
        orderBy: { createdAt: 'desc' },
        take: 20,
        select: {
          id: true,
          crimeId: true,
          success: true,
          reward: true,
          xpGained: true,
          jailed: true,
          outcome: true,
          createdAt: true,
        },
      }),
      prisma.jobAttempt.findMany({
        where: { playerId },
        orderBy: { completedAt: 'desc' },
        take: 20,
        select: {
          id: true,
          jobId: true,
          earnings: true,
          xpGained: true,
          completedAt: true,
        },
      }),
      prisma.playerActivity.count({
        where: { playerId, activityType: 'TRAVEL', createdAt: { gte: sevenDaysAgo } },
      }),
      prisma.bankAccount.findUnique({
        where: { playerId },
        select: {
          balance: true,
          interestRate: true,
          updatedAt: true,
        },
      }),
      prisma.casinoTransaction.findMany({
        where: { playerId },
        orderBy: { createdAt: 'desc' },
        take: 40,
        select: {
          id: true,
          casinoId: true,
          gameType: true,
          betAmount: true,
          payout: true,
          ownerCut: true,
          createdAt: true,
        },
      }),
      prisma.casinoTransaction.findMany({
        where: { ownerId: playerId },
        orderBy: { createdAt: 'desc' },
        take: 40,
        select: {
          id: true,
          playerId: true,
          casinoId: true,
          gameType: true,
          betAmount: true,
          payout: true,
          ownerCut: true,
          createdAt: true,
        },
      }),
      prisma.casinoTransaction.aggregate({
        where: { playerId },
        _sum: {
          betAmount: true,
          payout: true,
        },
      }),
      prisma.casinoTransaction.aggregate({
        where: { ownerId: playerId },
        _sum: {
          ownerCut: true,
          betAmount: true,
          payout: true,
        },
      }),
      prisma.stripePaymentFulfillment.findMany({
        where: { playerId },
        orderBy: { fulfilledAt: 'desc' },
        take: 30,
        select: {
          id: true,
          stripeSessionId: true,
          productKey: true,
          fulfilledAt: true,
        },
      }),
    ]);

    if (!player) {
      return res.status(404).json({ error: 'Player not found' });
    }

    const correctedRank = getRankFromXP(player.xp);
    if (correctedRank !== player.rank) {
      player = await prisma.player.update({
        where: { id: player.id },
        data: { rank: correctedRank },
      });
    }

    const dailyIncome = ((crimeLast7._sum.reward || 0) + (jobLast7._sum.earnings || 0)) / 7;
    const dailyXp = ((crimeLast7._sum.xpGained || 0) + (jobLast7._sum.xpGained || 0)) / 7;
    const nextRankXpTarget = getXPForRank(player.rank + 1);
    const xpToNextRank = Math.max(0, nextRankXpTarget - player.xp);

    res.json({
      player,
      stats: {
        crimes: {
          total: crimeAggregate._count._all,
          success: crimeSuccess,
          failed: crimeFailed,
          jailed: crimeJailed,
          totalReward: crimeAggregate._sum.reward || 0,
          totalXp: crimeAggregate._sum.xpGained || 0,
          totalJailTime: crimeAggregate._sum.jailTime || 0,
          totalLoot: crimeAggregate._sum.lootStolen || 0,
        },
        jobs: {
          total: jobAggregate._count._all,
          totalEarnings: jobAggregate._sum.earnings || 0,
          totalXp: jobAggregate._sum.xpGained || 0,
        },
        flights: {
          total: totalFlights._sum.totalFlights || 0,
        },
      },
      projections: {
        crimesPerDay: Number((crimeLast7._count._all / 7).toFixed(2)),
        jobsPerDay: Number((jobLast7._count._all / 7).toFixed(2)),
        travelsPerDay: Number((travelActivitiesLast7 / 7).toFixed(2)),
        avgDailyIncome: Number(dailyIncome.toFixed(0)),
        avgDailyXp: Number(dailyXp.toFixed(0)),
        xpToNextRank,
        estimatedDaysToNextRank: dailyXp > 0 ? Number((xpToNextRank / dailyXp).toFixed(1)) : null,
      },
      assets: {
        properties,
        tools: playerTools,
        inventory,
        vehicles: vehicleInventory,
        ammo: ammoInventory,
        weapons: weaponInventory,
      },
      history: {
        recentActivities,
        recentCrimes,
        recentJobs,
      },
      financial: {
        bankAccount,
        casinoAsPlayer,
        casinoAsOwner,
        casinoAsPlayerTotals: {
          totalBet: casinoAsPlayerTotals._sum.betAmount || 0,
          totalPayout: casinoAsPlayerTotals._sum.payout || 0,
          netResult: (casinoAsPlayerTotals._sum.payout || 0) - (casinoAsPlayerTotals._sum.betAmount || 0),
        },
        casinoAsOwnerTotals: {
          totalOwnerCut: casinoAsOwnerTotals._sum.ownerCut || 0,
          totalBet: casinoAsOwnerTotals._sum.betAmount || 0,
          totalPayout: casinoAsOwnerTotals._sum.payout || 0,
        },
        premiumFulfillments,
      },
    });
  } catch (error) {
    console.error('Admin player overview error:', error);
    res.status(500).json({ error: 'Failed to fetch player overview' });
  }
});

/**
 * GET /api/admin/players/:playerId/recent-activities
 * Server-side paginated and filtered player activity feed with summary metrics
 */
router.get('/players/:playerId/recent-activities', async (req, res) => {
  try {
    const playerId = Number(req.params.playerId);
    if (!Number.isFinite(playerId) || playerId <= 0) {
      return res.status(400).json({ error: 'Invalid player id' });
    }

    const page = Math.max(1, Number.parseInt(req.query.page as string, 10) || 1);
    const limit = Math.min(50, Math.max(1, Number.parseInt(req.query.limit as string, 10) || 10));
    const dateRangeRaw = String(req.query.dateRange || '7d');
    const dateRange: ActivityDateRange = ['24h', '7d', '30d', 'all'].includes(dateRangeRaw)
      ? (dateRangeRaw as ActivityDateRange)
      : '7d';
    const typeFilter = String(req.query.typeFilter || 'all').trim();
    const search = String(req.query.search || '').trim();
    const sortRaw = String(req.query.sort || 'date_desc');
    const sort: ActivitySort = ['date_desc', 'date_asc', 'type_asc', 'type_desc'].includes(sortRaw)
      ? (sortRaw as ActivitySort)
      : 'date_desc';

    const rangeStart = getRangeStartForActivities(dateRange);

    const where: Prisma.PlayerActivityWhereInput = {
      playerId,
      ...(rangeStart ? { createdAt: { gte: rangeStart } } : {}),
      ...(typeFilter !== 'all' ? { activityType: typeFilter } : {}),
      ...(search
        ? {
            OR: [
              { activityType: { contains: search, mode: 'insensitive' } },
              { description: { contains: search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const orderBy: Prisma.PlayerActivityOrderByWithRelationInput[] =
      sort === 'date_asc'
        ? [{ createdAt: 'asc' }]
        : sort === 'date_desc'
          ? [{ createdAt: 'desc' }]
          : sort === 'type_asc'
            ? [{ activityType: 'asc' }, { createdAt: 'desc' }]
            : [{ activityType: 'desc' }, { createdAt: 'desc' }];

    const skip = (page - 1) * limit;

    const [items, total, allFilteredForSummary, groupedTypes] = await Promise.all([
      prisma.playerActivity.findMany({
        where,
        orderBy,
        skip,
        take: limit,
      }),
      prisma.playerActivity.count({ where }),
      prisma.playerActivity.findMany({
        where,
        select: {
          createdAt: true,
          details: true,
        },
      }),
      prisma.playerActivity.groupBy({
        by: ['activityType'],
        where,
        orderBy: {
          activityType: 'asc',
        },
      }),
    ]);

    const summary = allFilteredForSummary.reduce(
      (acc, row) => {
        acc.totalMoney += getActivityMoneyAmount(row.details);
        acc.totalXp += getActivityXpAmount(row.details);
        return acc;
      },
      { totalMoney: 0, totalXp: 0 },
    );

    const trendMap = new Map<string, { date: string; count: number; money: number; xp: number }>();
    allFilteredForSummary.forEach((row) => {
      const dateKey = row.createdAt.toISOString().slice(0, 10);
      const current = trendMap.get(dateKey) || { date: dateKey, count: 0, money: 0, xp: 0 };
      current.count += 1;
      current.money += getActivityMoneyAmount(row.details);
      current.xp += getActivityXpAmount(row.details);
      trendMap.set(dateKey, current);
    });

    const trend = Array.from(trendMap.values())
      .sort((a, b) => a.date.localeCompare(b.date))
      .slice(-14);

    return res.json({
      items,
      total,
      page,
      totalPages: Math.max(1, Math.ceil(total / limit)),
      availableTypes: groupedTypes.map((entry) => entry.activityType).filter(Boolean),
      summary,
      trend,
    });
  } catch (error) {
    console.error('Admin recent activities error:', error);
    return res.status(500).json({ error: 'Failed to fetch recent activities' });
  }
});

router.get('/players/:playerId/recent-activities/export', async (req, res) => {
  try {
    const playerId = Number(req.params.playerId);
    if (!Number.isFinite(playerId) || playerId <= 0) {
      return res.status(400).json({ error: 'Invalid player id' });
    }

    const dateRangeRaw = String(req.query.dateRange || '7d');
    const dateRange: ActivityDateRange = ['24h', '7d', '30d', 'all'].includes(dateRangeRaw)
      ? (dateRangeRaw as ActivityDateRange)
      : '7d';
    const typeFilter = String(req.query.typeFilter || 'all').trim();
    const search = String(req.query.search || '').trim();
    const sortRaw = String(req.query.sort || 'date_desc');
    const sort: ActivitySort = ['date_desc', 'date_asc', 'type_asc', 'type_desc'].includes(sortRaw)
      ? (sortRaw as ActivitySort)
      : 'date_desc';

    const rangeStart = getRangeStartForActivities(dateRange);
    const where: Prisma.PlayerActivityWhereInput = {
      playerId,
      ...(rangeStart ? { createdAt: { gte: rangeStart } } : {}),
      ...(typeFilter !== 'all' ? { activityType: typeFilter } : {}),
      ...(search
        ? {
            OR: [
              { activityType: { contains: search, mode: 'insensitive' } },
              { description: { contains: search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const orderBy: Prisma.PlayerActivityOrderByWithRelationInput[] =
      sort === 'date_asc'
        ? [{ createdAt: 'asc' }]
        : sort === 'date_desc'
          ? [{ createdAt: 'desc' }]
          : sort === 'type_asc'
            ? [{ activityType: 'asc' }, { createdAt: 'desc' }]
            : [{ activityType: 'desc' }, { createdAt: 'desc' }];

    const rows = await prisma.playerActivity.findMany({
      where,
      orderBy,
      take: 10000,
      select: {
        id: true,
        activityType: true,
        description: true,
        details: true,
        createdAt: true,
      },
    });

    const header = ['id', 'type', 'description', 'money', 'xp', 'createdAt'];
    const lines = rows.map((row) => [
      toCsvValue(row.id),
      toCsvValue(row.activityType),
      toCsvValue(row.description),
      toCsvValue(getActivityMoneyAmount(row.details)),
      toCsvValue(getActivityXpAmount(row.details)),
      toCsvValue(row.createdAt.toISOString()),
    ].join(','));

    const csv = [header.join(','), ...lines].join('\n');
    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', `attachment; filename="player_${playerId}_recent_activities.csv"`);
    return res.send(csv);
  } catch (error) {
    console.error('Admin recent activities export error:', error);
    return res.status(500).json({ error: 'Failed to export recent activities' });
  }
});

router.post(
  '/players/bulk-action',
  auditLog({ action: 'BULK_PLAYER_ACTION', targetType: 'Player' }),
  async (req: AdminRequest, res) => {
    try {
      const { playerIds, action, reason, durationHours, amount } = bulkPlayerActionSchema.parse(req.body);
      const adminRole = req.admin?.role;

      if (!adminRole || adminRole === AdminRole.VIEWER) {
        return res.status(403).json({ error: 'FORBIDDEN', message: 'Viewer role cannot perform bulk actions' });
      }

      if (action === 'add_money' && adminRole === AdminRole.MODERATOR && (amount || 0) > 200000) {
        return res.status(403).json({ error: 'FORBIDDEN', message: 'Moderator can add max 200,000 per player' });
      }

      let affected = 0;
      const requestId = `bulk-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

      if (action === 'ban_temp') {
        const until = new Date(Date.now() + (durationHours || 24) * 60 * 60 * 1000);
        const result = await prisma.player.updateMany({
          where: { id: { in: playerIds } },
          data: {
            isBanned: true,
            bannedUntil: until,
            banReason: reason,
          },
        });
        affected = result.count;
      }

      if (action === 'add_money') {
        if (!amount || amount <= 0) {
          return res.status(400).json({ error: 'Amount is required for add_money action' });
        }
        const result = await prisma.player.updateMany({
          where: { id: { in: playerIds } },
          data: {
            money: { increment: amount },
          },
        });
        affected = result.count;
      }

      if (action === 'warn') {
        await prisma.worldEvent.create({
          data: {
            eventKey: 'admin.bulk_warning',
            params: {
              playerIds,
              reason,
              adminId: req.admin?.id,
              requestId,
            },
          },
        });
        affected = playerIds.length;
      }

      res.locals.auditLogDetails = {
        action,
        playerIds,
        reason,
        durationHours: durationHours ?? null,
        amount: amount ?? null,
        affected,
        requestId,
      };

      return res.json({
        message: 'Bulk action executed',
        action,
        affected,
        requestId,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin bulk action error:', error);
      return res.status(500).json({ error: 'Failed to execute bulk action' });
    }
  }
);

/**
 * POST /api/admin/players/manage
 * Apply admin actions to a player (set/add stats, VIP, ammo, tools)
 */
router.post(
  '/players/manage',
  auditLog({ action: 'MANAGE_PLAYER', targetType: 'Player' }),
  async (req: AdminRequest, res) => {
    try {
      const { playerId, reason, set, add, vip, ammo, tool } = playerManageSchema.parse(req.body);
      const adminRole = req.admin?.role;
      if (!adminRole || adminRole === AdminRole.VIEWER) {
        return res.status(403).json({ error: 'FORBIDDEN', message: 'Viewer role cannot manage players' });
      }

      const player = await prisma.player.findUnique({ where: { id: playerId } });
      if (!player) {
        return res.status(404).json({ error: 'Player not found' });
      }

      if (adminRole === AdminRole.MODERATOR) {
        if (set?.rank !== undefined || vip !== undefined) {
          return res.status(403).json({ error: 'FORBIDDEN', message: 'Moderator cannot change rank or VIP state' });
        }
      }

      const setMoney = set?.money;
      const setRank = set?.rank;
      const setXp = set?.xp;
      const addMoney = add?.money;
      const addXp = add?.xp;
      const isCriticalChange =
        (typeof setMoney === 'number' && Math.abs(setMoney - player.money) >= 500000) ||
        (typeof addMoney === 'number' && Math.abs(addMoney) >= 500000) ||
        (typeof setRank === 'number' && setRank !== player.rank) ||
        (typeof setXp === 'number' && Math.abs(setXp - player.xp) >= 10000) ||
        (typeof addXp === 'number' && Math.abs(addXp) >= 10000) ||
        (vip?.enabled !== undefined && vip.enabled !== player.isVip);

      if (isCriticalChange && (!reason || reason.trim().length < 5)) {
        return res.status(400).json({ error: 'Reason is required for critical changes (min. 5 characters)' });
      }

      if (typeof addMoney === 'number' && Math.abs(addMoney) > 2000000) {
        return res.status(400).json({ error: 'add.money exceeds hard limit (2,000,000)' });
      }
      if (typeof setMoney === 'number' && Math.abs(setMoney - player.money) > 5000000) {
        return res.status(400).json({ error: 'set.money delta exceeds hard limit (5,000,000)' });
      }
      if (typeof addXp === 'number' && Math.abs(addXp) > 50000) {
        return res.status(400).json({ error: 'add.xp exceeds hard limit (50,000)' });
      }
      if (typeof setXp === 'number' && Math.abs(setXp - player.xp) > 100000) {
        return res.status(400).json({ error: 'set.xp delta exceeds hard limit (100,000)' });
      }

      if (adminRole === AdminRole.MODERATOR) {
        if (typeof addMoney === 'number' && Math.abs(addMoney) > 200000) {
          return res.status(403).json({ error: 'FORBIDDEN', message: 'Moderator add.money limit is 200,000' });
        }
        if (typeof setMoney === 'number' && Math.abs(setMoney - player.money) > 500000) {
          return res.status(403).json({ error: 'FORBIDDEN', message: 'Moderator set.money delta limit is 500,000' });
        }
      }

      const requestId = `manage-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
      const beforeSnapshot = {
        money: player.money,
        rank: player.rank,
        xp: player.xp,
        health: player.health,
        currentCountry: player.currentCountry,
        isVip: player.isVip,
        vipExpiresAt: player.vipExpiresAt,
      };

      const playerUpdateData: Record<string, any> = {};

      if (set) {
        if (set.money !== undefined) playerUpdateData.money = set.money;
        if (set.rank !== undefined) playerUpdateData.rank = set.rank;
        if (set.xp !== undefined) playerUpdateData.xp = set.xp;
        if (set.health !== undefined) playerUpdateData.health = set.health;
        if (set.currentCountry !== undefined) playerUpdateData.currentCountry = set.currentCountry;
      }

      if (add?.money !== undefined) {
        playerUpdateData.money = (playerUpdateData.money ?? player.money) + add.money;
      }

      if (add?.xp !== undefined) {
        playerUpdateData.xp = Math.max(0, (playerUpdateData.xp ?? player.xp) + add.xp);
      }

      if (vip) {
        playerUpdateData.isVip = vip.enabled;
        playerUpdateData.vipExpiresAt = vip.enabled
          ? new Date(Date.now() + (vip.days ?? 7) * 24 * 60 * 60 * 1000)
          : null;
      }

      const result = await prisma.$transaction(async (tx) => {
        const updatedPlayer = Object.keys(playerUpdateData).length > 0
          ? await tx.player.update({ where: { id: playerId }, data: playerUpdateData })
          : player;

        if (ammo) {
          await tx.ammoInventory.upsert({
            where: { playerId_ammoType: { playerId, ammoType: ammo.ammoType } },
            update: { quantity: { increment: ammo.quantity } },
            create: {
              playerId,
              ammoType: ammo.ammoType,
              quantity: ammo.quantity,
            },
          });
        }

        if (tool) {
          const existingTool = await tx.playerTools.findFirst({
            where: {
              playerId,
              toolId: tool.toolId,
              location: tool.location,
            },
          });

          if (existingTool) {
            await tx.playerTools.update({
              where: { id: existingTool.id },
              data: {
                quantity: { increment: tool.quantity },
                durability: Math.max(existingTool.durability, tool.durability),
              },
            });
          } else {
            await tx.playerTools.create({
              data: {
                playerId,
                toolId: tool.toolId,
                quantity: tool.quantity,
                durability: tool.durability,
                location: tool.location,
              },
            });
          }
        }

        return updatedPlayer;
      });

      res.locals.auditLogDetails = {
        requestId,
        reason: reason || null,
        adminRole,
        before: beforeSnapshot,
        after: {
          money: result.money,
          rank: result.rank,
          xp: result.xp,
          health: result.health,
          currentCountry: result.currentCountry,
          isVip: result.isVip,
          vipExpiresAt: result.vipExpiresAt,
        },
        requestedChanges: { set, add, vip, ammo, tool },
      };

      res.json({
        message: 'Player management action completed',
        reason: reason || null,
        requestId,
        player: {
          id: result.id,
          username: result.username,
          money: result.money,
          rank: result.rank,
          xp: result.xp,
          health: result.health,
          currentCountry: result.currentCountry,
          isVip: result.isVip,
          vipExpiresAt: result.vipExpiresAt,
        },
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin manage player error:', error);
      res.status(500).json({ error: 'Failed to manage player' });
    }
  }
);

/**
 * GET /api/admin/audit-logs
 * Get audit logs with pagination
 */
router.get('/audit-logs', async (req, res) => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 50;
    const skip = (page - 1) * limit;

    const [logs, total] = await Promise.all([
      prisma.auditLog.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          admin: {
            select: {
              username: true,
              role: true,
            },
          },
        },
      }),
      prisma.auditLog.count(),
    ]);

    res.json({
      logs,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    });
  } catch (error) {
    console.error('Admin get audit logs error:', error);
    res.status(500).json({ error: 'Failed to fetch audit logs' });
  }
});

/**
 * GET /api/admin/system-logs
 * Get runtime system error logs (captured from backend console/process errors)
 */
router.get('/system-logs', async (req, res) => {
  try {
    const page = parseInt(req.query.page as string, 10) || 1;
    const limit = Math.min(200, parseInt(req.query.limit as string, 10) || 50);
    const skip = (page - 1) * limit;

    const [logs, total] = await Promise.all([
      prisma.worldEvent.findMany({
        where: {
          eventKey: 'system.error',
        },
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          eventKey: true,
          params: true,
          createdAt: true,
        },
      }),
      prisma.worldEvent.count({
        where: {
          eventKey: 'system.error',
        },
      }),
    ]);

    const normalizedLogs = logs.map((entry) => ({
      ...entry,
      params: parseWorldEventParams(entry.params),
    }));

    return res.json({
      logs: normalizedLogs,
      total,
      page,
      totalPages: Math.max(1, Math.ceil(total / limit)),
    });
  } catch (error) {
    console.error('Admin get system logs error:', error);
    return res.status(500).json({ error: 'Failed to fetch system logs' });
  }
});

/**
 * GET /api/admin/admins
 * List all admin accounts
 */
router.get('/admins', requireAdminRole(AdminRole.SUPER_ADMIN), async (_req, res) => {
  try {
    const admins = await prisma.admin.findMany({
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        username: true,
        role: true,
        isActive: true,
        createdAt: true,
        lastLoginAt: true,
      },
    });

    return res.json({ admins });
  } catch (error) {
    console.error('Admin list admins error:', error);
    return res.status(500).json({ error: 'Failed to fetch admins' });
  }
});

/**
 * POST /api/admin/admins
 * Create a new admin account
 */
router.post(
  '/admins',
  requireAdminRole(AdminRole.SUPER_ADMIN),
  auditLog({ action: 'CREATE_ADMIN', targetType: 'Admin' }),
  async (req: AdminRequest, res) => {
    try {
      const input = createAdminSchema.parse(req.body);

      const existing = await prisma.admin.findUnique({
        where: { username: input.username },
        select: { id: true },
      });

      if (existing) {
        return res.status(409).json({ error: 'Username already exists' });
      }

      const passwordHash = await bcrypt.hash(input.password, 12);
      const admin = await prisma.admin.create({
        data: {
          username: input.username,
          passwordHash,
          role: input.role,
          isActive: true,
        },
        select: {
          id: true,
          username: true,
          role: true,
          isActive: true,
          createdAt: true,
          lastLoginAt: true,
        },
      });

      return res.status(201).json({
        message: 'Admin created successfully',
        admin,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }

      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        return res.status(409).json({ error: 'Username already exists' });
      }

      console.error('Admin create admin error:', error);
      return res.status(500).json({ error: 'Failed to create admin' });
    }
  }
);

/**
 * PATCH /api/admin/admins/:adminId
 * Update admin account (role/active/password)
 */
router.patch(
  '/admins/:adminId',
  requireAdminRole(AdminRole.SUPER_ADMIN),
  auditLog({ action: 'UPDATE_ADMIN', targetType: 'Admin' }),
  async (req: AdminRequest, res) => {
    try {
      const adminId = Number(req.params.adminId);
      if (!Number.isFinite(adminId) || adminId <= 0) {
        return res.status(400).json({ error: 'Invalid admin id' });
      }

      const input = updateAdminSchema.parse(req.body);

      const targetAdmin = await prisma.admin.findUnique({
        where: { id: adminId },
        select: { id: true, role: true, isActive: true },
      });

      if (!targetAdmin) {
        return res.status(404).json({ error: 'Admin not found' });
      }

      if (req.admin?.id === adminId && input.isActive === false) {
        return res.status(400).json({ error: 'Cannot deactivate your own admin account' });
      }

      const roleAfterUpdate = input.role ?? targetAdmin.role;
      const activeAfterUpdate = input.isActive ?? targetAdmin.isActive;

      const reducingSuperPrivileges =
        targetAdmin.role === AdminRole.SUPER_ADMIN &&
        (!activeAfterUpdate || roleAfterUpdate !== AdminRole.SUPER_ADMIN);

      if (reducingSuperPrivileges) {
        const activeSuperAdmins = await prisma.admin.count({
          where: {
            role: AdminRole.SUPER_ADMIN,
            isActive: true,
          },
        });

        if (activeSuperAdmins <= 1) {
          return res.status(400).json({ error: 'At least one active SUPER_ADMIN is required' });
        }
      }

      const updateData: Prisma.AdminUpdateInput = {};
      if (input.role !== undefined) {
        updateData.role = input.role;
      }
      if (input.isActive !== undefined) {
        updateData.isActive = input.isActive;
      }
      if (input.password !== undefined) {
        updateData.passwordHash = await bcrypt.hash(input.password, 12);
      }

      const updatedAdmin = await prisma.admin.update({
        where: { id: adminId },
        data: updateData,
        select: {
          id: true,
          username: true,
          role: true,
          isActive: true,
          createdAt: true,
          lastLoginAt: true,
        },
      });

      return res.json({
        message: 'Admin updated successfully',
        admin: updatedAdmin,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }

      console.error('Admin update admin error:', error);
      return res.status(500).json({ error: 'Failed to update admin' });
    }
  }
);

/**
 * POST /api/admin/players/ban
 * Ban a player
 */
router.post(
  '/players/ban',
  auditLog({ action: 'BAN_PLAYER', targetType: 'Player' }),
  async (req, res) => {
    try {
      const { playerId, reason, duration } = banPlayerSchema.parse(req.body);

      // Check if player exists
      const player = await prisma.player.findUnique({
        where: { id: playerId },
      });

      if (!player) {
        return res.status(404).json({ error: 'Player not found' });
      }

      // Calculate ban expiry
      const bannedUntil = duration
        ? new Date(Date.now() + duration * 60 * 60 * 1000)
        : null; // null = permanent

      // Update player with ban info
      const updatedPlayer = await prisma.player.update({
        where: { id: playerId },
        data: {
          isBanned: true,
          bannedUntil,
          banReason: reason,
        },
      });

      res.json({
        message: 'Player banned successfully',
        player: {
          id: updatedPlayer.id,
          username: updatedPlayer.username,
          isBanned: updatedPlayer.isBanned,
          bannedUntil: updatedPlayer.bannedUntil,
          banReason: updatedPlayer.banReason,
        },
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin ban player error:', error);
      res.status(500).json({ error: 'Failed to ban player' });
    }
  }
);

/**
 * POST /api/admin/players/unban
 * Unban a player
 */
router.post(
  '/players/unban',
  auditLog({ action: 'UNBAN_PLAYER', targetType: 'Player' }),
  async (req, res) => {
    try {
      const playerId = parseInt(req.body.playerId);
      
      const updatedPlayer = await prisma.player.update({
        where: { id: playerId },
        data: {
          isBanned: false,
          bannedUntil: null,
          banReason: null,
        },
      });

      res.json({
        message: 'Player unbanned successfully',
        player: {
          id: updatedPlayer.id,
          username: updatedPlayer.username,
          isBanned: updatedPlayer.isBanned,
        },
      });
    } catch (error) {
      console.error('Admin unban player error:', error);
      res.status(500).json({ error: 'Failed to unban player' });
    }
  }
);

/**
 * POST /api/admin/players/edit
 * Edit player stats
 */
router.post(
  '/players/edit',
  auditLog({ action: 'EDIT_PLAYER', targetType: 'Player' }),
  async (req, res) => {
    try {
      const { playerId, updates } = editPlayerSchema.parse(req.body);

      // Check if player exists
      const player = await prisma.player.findUnique({
        where: { id: playerId },
      });

      if (!player) {
        return res.status(404).json({ error: 'Player not found' });
      }

      // Update player
      const updatedPlayer = await prisma.player.update({
        where: { id: playerId },
        data: updates,
      });

      res.json({
        message: 'Player updated successfully',
        player: {
          id: updatedPlayer.id,
          username: updatedPlayer.username,
          ...updates,
        },
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin edit player error:', error);
      res.status(500).json({ error: 'Failed to edit player' });
    }
  }
);

/**
 * GET /api/admin/config
 * Get current backend configuration
 */
router.get('/config', async (req, res) => {
  try {
    // Read the .env file
    const envPath = path.join(__dirname, '../../.env');
    const envContent = await fs.readFile(envPath, 'utf-8');
    
    // Parse .env file into key-value pairs
    const envVars: Record<string, string> = {};
    envContent.split('\n').forEach(line => {
      const trimmed = line.trim();
      if (trimmed && !trimmed.startsWith('#')) {
        const [key, ...valueParts] = trimmed.split('=');
        if (key) {
          envVars[key.trim()] = valueParts.join('=').trim();
        }
      }
    });

    res.json({
      env: envVars,
      configPath: envPath,
    });
  } catch (error) {
    console.error('Admin get config error:', error);
    res.status(500).json({ error: 'Failed to fetch config' });
  }
});

/**
 * PUT /api/admin/config
 * Update backend configuration
 */
router.put(
  '/config',
  auditLog({ action: 'UPDATE_CONFIG', targetType: 'Config' }),
  async (req, res) => {
    try {
      const { updates } = req.body;

      if (!updates || typeof updates !== 'object') {
        return res.status(400).json({ error: 'Invalid updates object' });
      }

      // Read current .env file
      const envPath = path.join(__dirname, '../../.env');
      const envContent = await fs.readFile(envPath, 'utf-8');

      // Parse and update
      const lines = envContent.split('\n');
      const existingKeys = new Set<string>();

      const updatedLines = lines.map(line => {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          const [key] = trimmed.split('=');
          if (key && updates[key.trim()] !== undefined) {
            existingKeys.add(key.trim());
            return `${key.trim()}=${updates[key.trim()]}`;
          }
          if (key) {
            existingKeys.add(key.trim());
          }
        }
        return line;
      });

      // Support creating new keys via admin panel when they are not present yet.
      for (const [key, value] of Object.entries(updates as Record<string, string>)) {
        if (!existingKeys.has(key)) {
          updatedLines.push(`${key}=${value}`);
        }
      }

      // Write back to .env file
      await fs.writeFile(envPath, updatedLines.join('\n'), 'utf-8');

      res.json({
        message: 'Config updated successfully',
        warning: 'Server restart required for changes to take effect',
        updated: Object.keys(updates),
      });
    } catch (error) {
      console.error('Admin update config error:', error);
      res.status(500).json({ error: 'Failed to update config' });
    }
  }
);

/**
 * GET /api/admin/premium-offers
 * Get one-time premium offers used by in-game premium checkout
 */
router.get('/premium-offers', async (_req, res) => {
  try {
    const offers = await prisma.premiumOneTimeOffer.findMany({
      orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
    });

    res.json({ offers });
  } catch (error) {
    console.error('Admin get premium offers error:', error);
    res.status(500).json({ error: 'Failed to fetch premium offers' });
  }
});

/**
 * POST /api/admin/premium-offers
 * Create one-time premium offer
 */
router.post(
  '/premium-offers',
  requireAdminRole(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR),
  auditLog({ action: 'CREATE_PREMIUM_OFFER', targetType: 'PremiumOneTimeOffer' }),
  async (req, res) => {
    try {
      const input = createPremiumOfferSchema.parse(req.body);

      const data = {
        key: input.key,
        titleNl: input.titleNl,
        titleEn: input.titleEn,
        imageUrl: input.imageUrl ?? null,
        priceEurCents: input.priceEurCents,
        rewardType: input.rewardType,
        moneyAmount: input.rewardType === 'money' ? (input.moneyAmount ?? null) : null,
        ammoType: input.rewardType === 'ammo' ? (input.ammoType ?? null) : null,
        ammoQuantity: input.rewardType === 'ammo' ? (input.ammoQuantity ?? null) : null,
        isActive: input.isActive,
        showPopupOnOpen: input.showPopupOnOpen,
        sortOrder: input.sortOrder,
      };

      if (input.rewardType === 'money' && !data.moneyAmount) {
        return res.status(400).json({ error: 'moneyAmount is required for money rewards' });
      }
      if (input.rewardType === 'ammo' && (!data.ammoType || !data.ammoQuantity)) {
        return res.status(400).json({ error: 'ammoType and ammoQuantity are required for ammo rewards' });
      }

      const offer = await prisma.premiumOneTimeOffer.create({ data });

      if (input.notifyAllPlayers) {
        const players = await prisma.player.findMany({ select: { id: true } });
        await Promise.all(
          players.map((p) =>
            notificationService.sendToPlayer(
              p.id,
              input.titleEn,
              `New premium offer available now for €${(input.priceEurCents / 100).toFixed(2)}`,
              { type: 'premium_offer', offerKey: input.key }
            )
          )
        );
      }

      res.status(201).json({ message: 'Premium offer created', offer });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin create premium offer error:', error);
      res.status(500).json({ error: 'Failed to create premium offer' });
    }
  }
);

/**
 * PUT /api/admin/premium-offers/:id
 * Update one-time premium offer (price/reward/active state)
 */
router.put(
  '/premium-offers/:id',
  requireAdminRole(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR),
  auditLog({ action: 'UPDATE_PREMIUM_OFFER', targetType: 'PremiumOneTimeOffer' }),
  async (req, res) => {
    try {
      const id = Number(req.params.id);
      if (!Number.isFinite(id) || id <= 0) {
        return res.status(400).json({ error: 'Invalid offer id' });
      }

      const input = updatePremiumOfferSchema.parse(req.body);

      const data = {
        titleNl: input.titleNl,
        titleEn: input.titleEn,
        imageUrl: input.imageUrl ?? null,
        priceEurCents: input.priceEurCents,
        rewardType: input.rewardType,
        moneyAmount: input.rewardType === 'money' ? (input.moneyAmount ?? null) : null,
        ammoType: input.rewardType === 'ammo' ? (input.ammoType ?? null) : null,
        ammoQuantity: input.rewardType === 'ammo' ? (input.ammoQuantity ?? null) : null,
        isActive: input.isActive,
        showPopupOnOpen: input.showPopupOnOpen,
        sortOrder: input.sortOrder,
      };

      if (input.rewardType === 'money' && !data.moneyAmount) {
        return res.status(400).json({ error: 'moneyAmount is required for money rewards' });
      }
      if (input.rewardType === 'ammo' && (!data.ammoType || !data.ammoQuantity)) {
        return res.status(400).json({ error: 'ammoType and ammoQuantity are required for ammo rewards' });
      }

      const offer = await prisma.premiumOneTimeOffer.update({
        where: { id },
        data,
      });

      res.json({ message: 'Premium offer updated', offer });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin update premium offer error:', error);
      res.status(500).json({ error: 'Failed to update premium offer' });
    }
  }
);

/**
 * DELETE /api/admin/premium-offers/:id
 * Delete one-time premium offer
 */
router.delete(
  '/premium-offers/:id',
  requireAdminRole(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR),
  auditLog({ action: 'DELETE_PREMIUM_OFFER', targetType: 'PremiumOneTimeOffer' }),
  async (req, res) => {
    try {
      const id = Number(req.params.id);
      if (!Number.isFinite(id) || id <= 0) {
        return res.status(400).json({ error: 'Invalid offer id' });
      }

      await prisma.premiumOneTimeOffer.delete({ where: { id } });
      return res.json({ message: 'Premium offer deleted' });
    } catch (error) {
      console.error('Admin delete premium offer error:', error);
      return res.status(500).json({ error: 'Failed to delete premium offer' });
    }
  }
);

/**
 * GET /api/admin/cron/status
 * Get status of all cron jobs
 */
router.get('/cron/status', async (_req, res) => {
  try {
    const status = getCronStatus();
    res.json(status);
  } catch (error) {
    console.error('Admin cron status error:', error);
    res.status(500).json({ error: 'Failed to fetch cron status' });
  }
});

/**
 * POST /api/admin/cron/trigger/:jobName
 * Manually trigger a cron job for testing
 */
router.post(
  '/cron/trigger/:jobName',
  auditLog({ action: 'TRIGGER_CRON', targetType: 'CronJob' }),
  async (req, res) => {
    try {
      const { jobName } = req.params;

      let result: any;
      switch (jobName) {
        case 'expiredEvents':
          await checkExpiredEvents();
          result = { job: 'checkExpiredEvents', status: 'completed' };
          break;
        case 'updateLeaderboards':
          await updateLeaderboards();
          result = { job: 'updateLeaderboards', status: 'completed' };
          break;
        case 'resetWeeklyLeaderboard':
          await resetWeeklyLeaderboard();
          result = { job: 'resetWeeklyLeaderboard', status: 'completed' };
          break;
        case 'cleanupRivalries':
          await cleanupOldRivalries();
          result = { job: 'cleanupOldRivalries', status: 'completed' };
          break;
        default:
          return res.status(400).json({
            error: 'Invalid job name',
            validJobs: [
              'expiredEvents',
              'updateLeaderboards',
              'resetWeeklyLeaderboard',
              'cleanupRivalries',
            ],
          });
      }

      res.json({
        success: true,
        message: `Cron job ${jobName} triggered successfully`,
        result,
      });
    } catch (error) {
      console.error('Admin trigger cron error:', error);
      res.status(500).json({ error: 'Failed to trigger cron job' });
    }
  }
);

/**
 * POST /api/admin/players/vip/grant
 * Grant VIP status to a player
 */
router.post(
  '/players/vip/grant',
  auditLog({ action: 'GRANT_VIP', targetType: 'Player' }),
  async (req, res) => {
    try {
      const { username, days } = grantVipSchema.parse(req.body);

      // Find player by username
      const player = await prisma.player.findUnique({
        where: { username },
        select: { id: true, username: true, isVip: true, vipExpiresAt: true },
      });

      if (!player) {
        return res.status(404).json({ error: 'Player not found' });
      }

      // Calculate expiration date
      const vipExpiresAt = new Date(Date.now() + days * 24 * 60 * 60 * 1000);

      // Update player with VIP status
      const updatedPlayer = await prisma.player.update({
        where: { id: player.id },
        data: {
          isVip: true,
          vipExpiresAt,
        },
      });

      res.json({
        success: true,
        message: `VIP granted to ${username} for ${days} days`,
        player: {
          id: updatedPlayer.id,
          username: updatedPlayer.username,
          isVip: updatedPlayer.isVip,
          vipExpiresAt: updatedPlayer.vipExpiresAt,
        },
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin grant VIP error:', error);
      res.status(500).json({ error: 'Failed to grant VIP' });
    }
  }
);

/**
 * POST /api/admin/players/vip/revoke
 * Revoke VIP status from a player
 */
router.post(
  '/players/vip/revoke',
  auditLog({ action: 'REVOKE_VIP', targetType: 'Player' }),
  async (req, res) => {
    try {
      const { username } = req.body;

      if (!username) {
        return res.status(400).json({ error: 'Username is required' });
      }

      // Find player
      const player = await prisma.player.findUnique({
        where: { username },
      });

      if (!player) {
        return res.status(404).json({ error: 'Player not found' });
      }

      // Revoke VIP
      const updatedPlayer = await prisma.player.update({
        where: { id: player.id },
        data: {
          isVip: false,
          vipExpiresAt: null,
        },
      });

      res.json({
        success: true,
        message: `VIP revoked from ${username}`,
        player: {
          id: updatedPlayer.id,
          username: updatedPlayer.username,
          isVip: updatedPlayer.isVip,
          vipExpiresAt: updatedPlayer.vipExpiresAt,
        },
      });
    } catch (error) {
      console.error('Admin revoke VIP error:', error);
      res.status(500).json({ error: 'Failed to revoke VIP' });
    }
  }
);

/**
 * GET /api/admin/players/vip/list
 * Get all VIP players
 */
router.get('/players/vip/list', async (_req, res) => {
  try {
    const vipPlayers = await prisma.player.findMany({
      where: {
        isVip: true,
      },
      select: {
        id: true,
        username: true,
        isVip: true,
        vipExpiresAt: true,
        createdAt: true,
      },
      orderBy: {
        vipExpiresAt: 'asc',
      },
    });

    // Separate active and expired VIP
    const now = new Date();
    const active = vipPlayers.filter(
      p => !p.vipExpiresAt || p.vipExpiresAt > now
    );
    const expired = vipPlayers.filter(
      p => p.vipExpiresAt && p.vipExpiresAt <= now
    );

    res.json({
      success: true,
      total: vipPlayers.length,
      active: active.length,
      expired: expired.length,
      players: {
        active,
        expired,
      },
    });
  } catch (error) {
    console.error('Admin list VIP error:', error);
    res.status(500).json({ error: 'Failed to list VIP players' });
  }
});

/**
 * GET /api/admin/vehicles
 * Get all vehicle definitions from content file
 */
router.get('/vehicles', async (_req, res) => {
  try {
    const vehicles = await readVehiclesFile();

    res.json({
      success: true,
      cars: vehicles.cars,
      boats: vehicles.boats,
      counts: {
        cars: vehicles.cars.length,
        boats: vehicles.boats.length,
      },
    });
  } catch (error) {
    console.error('Admin get vehicles error:', error);
    res.status(500).json({ error: 'Failed to fetch vehicles' });
  }
});

/**
 * POST /api/admin/vehicles
 * Add a vehicle definition to cars or boats
 */
router.post(
  '/vehicles',
  auditLog({ action: 'ADD_VEHICLE', targetType: 'Vehicle' }),
  async (req, res) => {
    try {
      const { category, vehicle } = addVehicleSchema.parse(req.body);
      const normalizedVehicle = {
        ...vehicle,
        image: vehicle.image?.trim() || vehicle.imageNew,
      };
      const vehicles = await readVehiclesFile();
      const allVehicles = [...vehicles.cars, ...vehicles.boats];

      const exists = allVehicles.some((entry) => entry.id === normalizedVehicle.id);
      if (exists) {
        return res.status(400).json({ error: `Vehicle with id \"${normalizedVehicle.id}\" already exists` });
      }

      vehicles[category].push(normalizedVehicle);
      await writeVehiclesFile(vehicles);

      res.json({
        success: true,
        message: `Vehicle ${normalizedVehicle.name} toegevoegd aan ${category}`,
        vehicle: normalizedVehicle,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: 'Invalid input', details: error.errors });
      }
      console.error('Admin add vehicle error:', error);
      res.status(500).json({ error: 'Failed to add vehicle' });
    }
  }
);

/**
 * DELETE /api/admin/vehicles/:category/:vehicleId
 * Remove a vehicle definition from cars or boats
 */
router.delete(
  '/vehicles/:category/:vehicleId',
  auditLog({ action: 'DELETE_VEHICLE', targetType: 'Vehicle' }),
  async (req, res) => {
    try {
      const categoryParam = req.params.category;
      const vehicleId = req.params.vehicleId;

      if (categoryParam !== 'cars' && categoryParam !== 'boats') {
        return res.status(400).json({ error: 'Category must be cars or boats' });
      }

      const vehicles = await readVehiclesFile();
      const beforeCount = vehicles[categoryParam].length;
      vehicles[categoryParam] = vehicles[categoryParam].filter((vehicle) => vehicle.id !== vehicleId);

      if (vehicles[categoryParam].length === beforeCount) {
        return res.status(404).json({ error: 'Vehicle not found' });
      }

      await writeVehiclesFile(vehicles);

      res.json({
        success: true,
        message: `Vehicle ${vehicleId} verwijderd uit ${categoryParam}`,
      });
    } catch (error) {
      console.error('Admin delete vehicle error:', error);
      res.status(500).json({ error: 'Failed to delete vehicle' });
    }
  }
);

// ─── AIRCRAFT ────────────────────────────────────────────────────────────────

router.get('/aircraft', async (_req, res) => {
  try {
    const list = await readAircraftFile();
    res.json({ success: true, aircraft: list });
  } catch (error) {
    console.error('Admin get aircraft error:', error);
    res.status(500).json({ error: 'Failed to fetch aircraft' });
  }
});

router.post(
  '/aircraft',
  auditLog({ action: 'ADD_AIRCRAFT', targetType: 'Aircraft' }),
  async (req, res) => {
    try {
      const aircraft = aircraftSchema.parse(req.body);
      const list = await readAircraftFile();
      if (list.some((a) => a.id === aircraft.id)) {
        return res.status(400).json({ error: `Aircraft with id "${aircraft.id}" already exists` });
      }
      list.push(aircraft);
      await writeAircraftFile(list);
      res.json({ success: true, aircraft });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin add aircraft error:', error);
      res.status(500).json({ error: 'Failed to add aircraft' });
    }
  }
);

router.put(
  '/aircraft/:aircraftId',
  auditLog({ action: 'UPDATE_AIRCRAFT', targetType: 'Aircraft' }),
  async (req, res) => {
    try {
      const { aircraftId } = req.params;
      const updates = aircraftSchema.partial().parse(req.body);
      const list = await readAircraftFile();
      const idx = list.findIndex((a) => a.id === aircraftId);
      if (idx === -1) return res.status(404).json({ error: 'Aircraft not found' });
      list[idx] = { ...list[idx], ...updates };
      await writeAircraftFile(list);
      res.json({ success: true, aircraft: list[idx] });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin update aircraft error:', error);
      res.status(500).json({ error: 'Failed to update aircraft' });
    }
  }
);

router.delete(
  '/aircraft/:aircraftId',
  auditLog({ action: 'DELETE_AIRCRAFT', targetType: 'Aircraft' }),
  async (req, res) => {
    try {
      const { aircraftId } = req.params;
      const list = await readAircraftFile();
      const before = list.length;
      const filtered = list.filter((a) => a.id !== aircraftId);
      if (filtered.length === before) return res.status(404).json({ error: 'Aircraft not found' });
      await writeAircraftFile(filtered);
      res.json({ success: true, message: `Aircraft ${aircraftId} verwijderd` });
    } catch (error) {
      console.error('Admin delete aircraft error:', error);
      res.status(500).json({ error: 'Failed to delete aircraft' });
    }
  }
);

// ─── TOOLS ───────────────────────────────────────────────────────────────────

router.get('/tools', async (_req, res) => {
  try {
    const tools = await readToolsFile();
    res.json({ success: true, tools });
  } catch (error) {
    console.error('Admin get tools error:', error);
    res.status(500).json({ error: 'Failed to fetch tools' });
  }
});

router.post(
  '/tools',
  auditLog({ action: 'ADD_TOOL', targetType: 'Tool' }),
  async (req, res) => {
    try {
      const tool = toolSchema.parse(req.body);
      const tools = await readToolsFile();
      if (tools.some((t) => t.id === tool.id)) {
        return res.status(400).json({ error: `Tool with id "${tool.id}" already exists` });
      }
      tools.push(tool);
      await writeToolsFile(tools);
      res.json({ success: true, tool });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin add tool error:', error);
      res.status(500).json({ error: 'Failed to add tool' });
    }
  }
);

router.put(
  '/tools/:toolId',
  auditLog({ action: 'UPDATE_TOOL', targetType: 'Tool' }),
  async (req, res) => {
    try {
      const { toolId } = req.params;
      const updates = toolSchema.partial().parse(req.body);
      const tools = await readToolsFile();
      const idx = tools.findIndex((t) => t.id === toolId);
      if (idx === -1) return res.status(404).json({ error: 'Tool not found' });
      tools[idx] = { ...tools[idx], ...updates };
      await writeToolsFile(tools);
      res.json({ success: true, tool: tools[idx] });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin update tool error:', error);
      res.status(500).json({ error: 'Failed to update tool' });
    }
  }
);

router.delete(
  '/tools/:toolId',
  auditLog({ action: 'DELETE_TOOL', targetType: 'Tool' }),
  async (req, res) => {
    try {
      const { toolId } = req.params;
      const tools = await readToolsFile();
      const before = tools.length;
      const filtered = tools.filter((t) => t.id !== toolId);
      if (filtered.length === before) return res.status(404).json({ error: 'Tool not found' });
      await writeToolsFile(filtered);
      res.json({ success: true, message: `Tool ${toolId} verwijderd` });
    } catch (error) {
      console.error('Admin delete tool error:', error);
      res.status(500).json({ error: 'Failed to delete tool' });
    }
  }
);

// ─── CRIMES ──────────────────────────────────────────────────────────────────

router.get('/crimes', async (_req, res) => {
  try {
    const crimes = await readCrimesFile();
    res.json({ success: true, crimes });
  } catch (error) {
    console.error('Admin get crimes error:', error);
    res.status(500).json({ error: 'Failed to fetch crimes' });
  }
});

router.post(
  '/crimes',
  auditLog({ action: 'ADD_CRIME', targetType: 'Crime' }),
  async (req, res) => {
    try {
      const crime = crimeSchema.parse(req.body);
      const crimes = await readCrimesFile();
      if (crimes.some((c) => c.id === crime.id)) {
        return res.status(400).json({ error: `Crime with id "${crime.id}" already exists` });
      }
      crimes.push(crime);
      await writeCrimesFile(crimes);
      res.json({ success: true, crime });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin add crime error:', error);
      res.status(500).json({ error: 'Failed to add crime' });
    }
  }
);

router.put(
  '/crimes/:crimeId',
  auditLog({ action: 'UPDATE_CRIME', targetType: 'Crime' }),
  async (req, res) => {
    try {
      const { crimeId } = req.params;
      const updates = crimeSchema.partial().parse(req.body);
      const crimes = await readCrimesFile();
      const idx = crimes.findIndex((c) => c.id === crimeId);
      if (idx === -1) return res.status(404).json({ error: 'Crime not found' });
      crimes[idx] = { ...crimes[idx], ...updates };
      await writeCrimesFile(crimes);
      res.json({ success: true, crime: crimes[idx] });
    } catch (error) {
      if (error instanceof z.ZodError) return res.status(400).json({ error: 'Invalid input', details: error.errors });
      console.error('Admin update crime error:', error);
      res.status(500).json({ error: 'Failed to update crime' });
    }
  }
);

router.delete(
  '/crimes/:crimeId',
  auditLog({ action: 'DELETE_CRIME', targetType: 'Crime' }),
  async (req, res) => {
    try {
      const { crimeId } = req.params;
      const crimes = await readCrimesFile();
      const before = crimes.length;
      const filtered = crimes.filter((c) => c.id !== crimeId);
      if (filtered.length === before) return res.status(404).json({ error: 'Crime not found' });
      await writeCrimesFile(filtered);
      res.json({ success: true, message: `Crime ${crimeId} verwijderd` });
    } catch (error) {
      console.error('Admin delete crime error:', error);
      res.status(500).json({ error: 'Failed to delete crime' });
    }
  }
);

export default router;
