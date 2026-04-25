import prisma from '../lib/prisma';
import { timeProvider } from '../utils/timeProvider';
import { notificationService } from './notificationService';
import { applyVipTimeoutReductionSeconds, isVipStatusActive } from './vipBenefitsService';

/**
 * Cooldown Service
 * Manages action cooldowns to prevent spamming
 */

interface CooldownConfig {
  crime: number; // seconds (base fallback)
  job: number;
  school: number;
  travel: number;
  heist: number;
  appeal: number;
  vehicle_theft: number;
  motorcycle_theft: number;
  boat_theft: number;
  vehicle_hotspot_op: number;
  motorcycle_hotspot_op: number;
  boat_hotspot_op: number;
  vehicle_crew_op: number;
  motorcycle_crew_op: number;
  boat_crew_op: number;
  vehicle_crew_match: number;
  motorcycle_crew_match: number;
  boat_crew_match: number;
  vehicle_chop_contract: number;
  motorcycle_chop_contract: number;
  boat_chop_contract: number;
  vehicle_counter_intercept: number;
  motorcycle_counter_intercept: number;
  boat_counter_intercept: number;
  vehicle_ops_contract: number;
  motorcycle_ops_contract: number;
  boat_ops_contract: number;
  ammo: number;
}

const NOTIFY_ACTIONS = new Set<keyof CooldownConfig>([
  'crime',
  'job',
  'vehicle_theft',
  'motorcycle_theft',
  'boat_theft',
]);

// Default cooldown periods (in seconds)
// Designed for long-term retention (months of gameplay)
const COOLDOWN_PERIODS: CooldownConfig = {
  crime: 90, // 1.5 minutes between crimes
  job: 900, // 15 minutes between jobs
  school: 90, // dynamic via education flow, 90s fallback
  travel: 3600, // 1 hour per travel leg
  heist: 21600, // 6 hours between heists
  appeal: 14400, // 4 hours between appeals
  vehicle_theft: 300, // 5 minutes between auto thefts
  motorcycle_theft: 240, // 4 minutes between motorcycle thefts
  boat_theft: 600, // 10 minutes between boat thefts
  vehicle_hotspot_op: 1800, // 30 minutes
  motorcycle_hotspot_op: 1500, // 25 minutes
  boat_hotspot_op: 2400, // 40 minutes
  vehicle_crew_op: 2700, // 45 minutes
  motorcycle_crew_op: 2400, // 40 minutes
  boat_crew_op: 3300, // 55 minutes
  vehicle_crew_match: 3600, // 60 minutes
  motorcycle_crew_match: 3300, // 55 minutes
  boat_crew_match: 4200, // 70 minutes
  vehicle_chop_contract: 14400, // 4 hours
  motorcycle_chop_contract: 12600, // 3.5 hours
  boat_chop_contract: 18000, // 5 hours
  vehicle_counter_intercept: 7200, // 2 hours
  motorcycle_counter_intercept: 6600, // 1h50
  boat_counter_intercept: 8400, // 2h20
  vehicle_ops_contract: 10800, // 3 hours
  motorcycle_ops_contract: 9600, // 2h40
  boat_ops_contract: 12600, // 3h30
  ammo: 3600, // 1 hour between ammo purchases
};

/**
 * Calculate dynamic cooldown for a crime based on max reward
 * @param maxReward - Maximum reward amount for the crime
 * @returns Cooldown in seconds
 */
export function calculateCrimeCooldown(maxReward: number): number {
  // Dynamic scaling based on reward tiers
  // €0-500: 90 sec (small crimes like pickpocket, shoplift)
  // €500-2000: 5 min (medium crimes like car theft)
  // €2000-10000: 15 min (large crimes like burglary)
  // €10000-30000: 30 min (major crimes like jewelry heist)
  // €30000+: 1 hour (top tier crimes like bank robbery)

  if (maxReward <= 500) {
    return 90; // 1.5 minutes
  } else if (maxReward <= 2000) {
    return 300; // 5 minutes
  } else if (maxReward <= 10000) {
    return 900; // 15 minutes
  } else if (maxReward <= 30000) {
    return 1800; // 30 minutes
  } else {
    return 3600; // 1 hour
  }
}

/**
 * Calculate dynamic cooldown for a job based on max earnings.
 * Higher-paying jobs take longer to repeat.
 *
 * @param maxEarnings - Maximum payout for the job
 * @returns Cooldown in seconds
 */
export function calculateJobCooldown(maxEarnings: number): number {
  // Reward-based progression pacing for legal jobs.
  // Keep loops endless, but make higher payout actions slower.
  if (maxEarnings <= 200) {
    return 180; // 3 minutes
  } else if (maxEarnings <= 500) {
    return 300; // 5 minutes
  } else if (maxEarnings <= 1000) {
    return 480; // 8 minutes
  } else if (maxEarnings <= 2000) {
    return 720; // 12 minutes
  } else if (maxEarnings <= 4000) {
    return 1020; // 17 minutes
  }

  return 1320; // 22 minutes
}

/**
 * Check if an action is on cooldown
 * @param playerId - Player ID
 * @param actionType - Type of action (crime, job, travel, etc.)
 * @param customCooldown - Optional custom cooldown period (e.g., for dynamic crime cooldowns)
 * @returns Remaining cooldown in seconds, or 0 if no cooldown
 */
export async function checkCooldown(
  playerId: number,
  actionType: keyof CooldownConfig,
  customCooldown?: number
): Promise<number> {
  const cooldown = await prisma.actionCooldown.findUnique({
    where: {
      playerId_actionType: {
        playerId,
        actionType,
      },
    },
    select: {
      lastUsedAt: true,
      cooldownSeconds: true,
    },
  });

  if (!cooldown) {
    return 0; // No cooldown record = action available
  }

  const now = timeProvider.now();
  const cooldownPeriod = customCooldown ?? cooldown.cooldownSeconds ?? COOLDOWN_PERIODS[actionType];
  const elapsedSeconds = Math.floor((now.getTime() - cooldown.lastUsedAt.getTime()) / 1000);
  const remainingSeconds = Math.max(0, cooldownPeriod - elapsedSeconds);

  return remainingSeconds;
}

/**
 * Get cooldown information for an action
 * @param playerId - Player ID
 * @param actionType - Type of action
 * @returns Cooldown info object or null if no active cooldown
 */
export async function getCooldown(
  playerId: number,
  actionType: keyof CooldownConfig
): Promise<{ remainingSeconds: number; actionType: string } | null> {
  const remainingSeconds = await checkCooldown(playerId, actionType);

  if (remainingSeconds > 0) {
    return {
      remainingSeconds,
      actionType,
    };
  }

  return null;
}

/**
 * Set cooldown for an action (called after successful action)
 * @param playerId - Player ID
 * @param actionType - Type of action
 * @param customCooldown - Optional custom cooldown period (e.g., for dynamic crime cooldowns)
 * @returns Cooldown info with remainingSeconds
 */
export async function setCooldown(
  playerId: number,
  actionType: keyof CooldownConfig,
  customCooldown?: number
): Promise<{ remainingSeconds: number; actionType: string }> {
  const now = timeProvider.now();
  const baseCooldownPeriod = customCooldown ?? COOLDOWN_PERIODS[actionType];
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      isVip: true,
      vipExpiresAt: true,
    },
  });
  const cooldownPeriod = applyVipTimeoutReductionSeconds(
    baseCooldownPeriod,
    isVipStatusActive(player, now)
  );

  await prisma.actionCooldown.upsert({
    where: {
      playerId_actionType: {
        playerId,
        actionType,
      },
    },
    update: {
      lastUsedAt: now,
      cooldownSeconds: cooldownPeriod,
      lastNotifiedAt: null,
      updatedAt: now,
    },
    create: {
      playerId,
      actionType,
      lastUsedAt: now,
      cooldownSeconds: cooldownPeriod,
      lastNotifiedAt: null,
    },
  });

  if (NOTIFY_ACTIONS.has(actionType)) {
    setTimeout(() => {
      processCooldownExpiryNotification(playerId, actionType).catch(() => {});
    }, cooldownPeriod * 1000);
  }

  return {
    remainingSeconds: cooldownPeriod,
    actionType,
  };
}

/**
 * Clear all cooldowns for a player (admin/testing only)
 * @param playerId - Player ID
 */
export async function clearPlayerCooldowns(playerId: number): Promise<void> {
  await prisma.actionCooldown.deleteMany({
    where: { playerId },
  });
}

/**
 * Get all active cooldowns for a player
 * @param playerId - Player ID
 * @returns Map of action types to remaining seconds
 */
export async function getPlayerCooldowns(playerId: number): Promise<Record<string, number>> {
  const cooldowns = await prisma.actionCooldown.findMany({
    where: { playerId },
    select: {
      actionType: true,
      lastUsedAt: true,
      cooldownSeconds: true,
    },
  });

  const now = timeProvider.now();
  const result: Record<string, number> = {};

  for (const cooldown of cooldowns) {
    const actionType = cooldown.actionType as keyof CooldownConfig;
    const cooldownPeriod = cooldown.cooldownSeconds ?? COOLDOWN_PERIODS[actionType];

    if (!cooldownPeriod) continue; // Skip unknown action types

    const elapsedSeconds = Math.floor((now.getTime() - cooldown.lastUsedAt.getTime()) / 1000);
    const remainingSeconds = Math.max(0, cooldownPeriod - elapsedSeconds);

    if (remainingSeconds > 0) {
      result[actionType] = remainingSeconds;
    }
  }

  return result;
}

export async function processCooldownExpiryNotification(
  playerId: number,
  actionType: keyof CooldownConfig
): Promise<boolean> {
  if (!NOTIFY_ACTIONS.has(actionType)) {
    return false;
  }

  const cooldown = await prisma.actionCooldown.findUnique({
    where: {
      playerId_actionType: {
        playerId,
        actionType,
      },
    },
    select: {
      lastUsedAt: true,
      cooldownSeconds: true,
      lastNotifiedAt: true,
    },
  });

  if (!cooldown) {
    return false;
  }

  const cooldownSeconds = cooldown.cooldownSeconds ?? COOLDOWN_PERIODS[actionType];
  const dueAt = new Date(cooldown.lastUsedAt.getTime() + cooldownSeconds * 1000);
  const now = timeProvider.now();

  if (dueAt.getTime() > now.getTime()) {
    return false;
  }

  if (cooldown.lastNotifiedAt && cooldown.lastNotifiedAt.getTime() >= dueAt.getTime()) {
    return false;
  }

  const updateResult = await prisma.actionCooldown.updateMany({
    where: {
      playerId,
      actionType,
      OR: [{ lastNotifiedAt: null }, { lastNotifiedAt: { lt: dueAt } }],
    },
    data: {
      lastNotifiedAt: now,
    },
  });

  if (updateResult.count === 0) {
    return false;
  }

  await notificationService.sendCooldownExpiredNotification(playerId, actionType);
  return true;
}

export async function processPendingCooldownExpiryNotifications(): Promise<number> {
  const cooldowns = await prisma.actionCooldown.findMany({
    where: {
      actionType: { in: Array.from(NOTIFY_ACTIONS) },
    },
    select: {
      playerId: true,
      actionType: true,
    },
  });

  let sentCount = 0;

  for (const cooldown of cooldowns) {
    const sent = await processCooldownExpiryNotification(
      cooldown.playerId,
      cooldown.actionType as keyof CooldownConfig
    );
    if (sent) {
      sentCount += 1;
    }
  }

  return sentCount;
}
