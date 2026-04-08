import prisma from '../lib/prisma';
import { timeProvider } from '../utils/timeProvider';

/**
 * Cooldown Service
 * Manages action cooldowns to prevent spamming
 */

interface CooldownConfig {
  crime: number;     // seconds (base fallback)
  job: number;
  travel: number;
  heist: number;
  appeal: number;
  vehicle_theft: number;
  boat_theft: number;
  ammo: number;
}

// Default cooldown periods (in seconds)
// Designed for long-term retention (months of gameplay)
const COOLDOWN_PERIODS: CooldownConfig = {
  crime: 90,         // 1.5 minutes between crimes
  job: 900,          // 15 minutes between jobs
  travel: 3600,      // 1 hour per travel leg
  heist: 21600,      // 6 hours between heists (max 4 heists/day)
  appeal: 14400,     // 4 hours between appeals (max 6 appeals/day)
  vehicle_theft: 300, // 5 minutes between auto thefts
  boat_theft: 600,   // 10 minutes between boat thefts
  ammo: 3600,        // 1 hour between ammo purchases
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
    return 90;         // 1.5 minutes
  } else if (maxReward <= 2000) {
    return 300;        // 5 minutes
  } else if (maxReward <= 10000) {
    return 900;        // 15 minutes
  } else if (maxReward <= 30000) {
    return 1800;       // 30 minutes
  } else {
    return 3600;       // 1 hour
  }
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
    },
  });

  if (!cooldown) {
    return 0; // No cooldown record = action available
  }

  const now = timeProvider.now();
  const cooldownPeriod = customCooldown ?? COOLDOWN_PERIODS[actionType];
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

  await prisma.actionCooldown.upsert({
    where: {
      playerId_actionType: {
        playerId,
        actionType,
      },
    },
    update: {
      lastUsedAt: now,
      updatedAt: now,
    },
    create: {
      playerId,
      actionType,
      lastUsedAt: now,
    },
  });
  
  // Return the cooldown period as remainingSeconds (use custom if provided)
  const cooldownPeriod = customCooldown ?? COOLDOWN_PERIODS[actionType];
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
    },
  });

  const now = timeProvider.now();
  const result: Record<string, number> = {};

  for (const cooldown of cooldowns) {
    const actionType = cooldown.actionType as keyof CooldownConfig;
    const cooldownPeriod = COOLDOWN_PERIODS[actionType];
    
    if (!cooldownPeriod) continue; // Skip unknown action types

    const elapsedSeconds = Math.floor((now.getTime() - cooldown.lastUsedAt.getTime()) / 1000);
    const remainingSeconds = Math.max(0, cooldownPeriod - elapsedSeconds);

    if (remainingSeconds > 0) {
      result[actionType] = remainingSeconds;
    }
  }

  return result;
}
