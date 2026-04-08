/**
 * FBI Service - Federal Crime Investigation System
 * Tracks FBI heat for federal crimes, separate from local police
 */

import prisma from '../lib/prisma';
import config from '../config';
import { activityService } from './activityService';

export interface FBIArrestResult {
  arrested: boolean;
  fbiHeat: number;
  federalBail?: number;
  federalJailTime?: number;
}

/**
 * Check if player gets arrested by FBI based on their FBI heat
 * FBI arrest chance is higher and caps at 95% (vs police 90%)
 * Formula: min((fbiHeat / 5) * 100, 95%)
 */
export async function checkFBIArrest(playerId: number): Promise<FBIArrestResult> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { id: true, fbiHeat: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.fbiHeat === 0) {
    return {
      arrested: false,
      fbiHeat: 0,
    };
  }

  // FBI is more effective: 1 FBI agent per 5 heat (vs police 1:10)
  const fbiRatio = config.fbiRatio || 5;
  const arrestChance = Math.min((player.fbiHeat / fbiRatio) * 100, 95);
  const arrestRoll = Math.random() * 100;

  const arrested = arrestRoll < arrestChance;

  if (arrested) {
    const federalBail = calculateFederalBail(player.fbiHeat);
    const federalJailTime = calculateFederalJailTime(player.fbiHeat);

    return {
      arrested: true,
      fbiHeat: player.fbiHeat,
      federalBail,
      federalJailTime,
    };
  }

  return {
    arrested: false,
    fbiHeat: player.fbiHeat,
  };
}

/**
 * Calculate federal bail amount
 * Federal bail is 3x higher than local police bail
 * Formula: fbiHeat * €3000
 */
export function calculateFederalBail(fbiHeat: number): number {
  return fbiHeat * 3000;
}

/**
 * Calculate federal jail time
 * Federal sentences are 2x longer than local police
 * Formula: fbiHeat * 20 minutes (min 60 minutes)
 */
export function calculateFederalJailTime(fbiHeat: number): number {
  return Math.max(fbiHeat * 20, 60);
}

/**
 * Pay federal bail to reduce FBI heat
 * Federal bail reduces heat by 40% (vs police 50%)
 */
export async function payFederalBail(playerId: number): Promise<void> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { id: true, money: true, fbiHeat: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.fbiHeat === 0) {
    throw new Error('NO_FBI_HEAT');
  }

  const federalBail = calculateFederalBail(player.fbiHeat);

  if (player.money < federalBail) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const newFbiHeat = Math.floor(player.fbiHeat * 0.6);

  await prisma.$transaction(async (tx) => {
    // Deduct bail from player
    await tx.player.update({
      where: { id: playerId },
      data: {
        money: { decrement: federalBail },
        fbiHeat: newFbiHeat, // Reduce by 40%
      },
    });
  });

  await activityService.logActivity(
    playerId,
    'FEDERAL_BAIL_PAID',
    `Paid federal bail of €${federalBail.toLocaleString()}`,
    {
      authority: 'FBI',
      bail: federalBail,
      fbiHeatBefore: player.fbiHeat,
      fbiHeatAfter: newFbiHeat,
    },
    true
  );
}

/**
 * Increase FBI heat when federal crime fails
 */
export async function increaseFBIHeat(playerId: number, amount: number): Promise<void> {
  await prisma.player.update({
    where: { id: playerId },
    data: {
      fbiHeat: { increment: amount },
    },
  });
}

/**
 * Decay FBI heat over time (slower than police wanted level)
 * FBI heat decays by 1 every 2 ticks (10 minutes) by default
 */
export async function decayFBIHeat(playerId: number): Promise<void> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { fbiHeat: true, username: true },
  });

  if (!player || player.fbiHeat === 0) {
    return;
  }

  const decayAmount = config.fbiHeatDecayPerTick || 0.5;
  const newFbiHeat = Math.max(player.fbiHeat - decayAmount, 0);

  await prisma.player.update({
    where: { id: playerId },
    data: { fbiHeat: newFbiHeat },
  });

  console.log(`🔥 FBI heat decay: ${player.username} ${player.fbiHeat} → ${newFbiHeat}`);
}

/**
 * Jail player for federal crime
 * Creates a crime attempt record with federal=true flag
 */
export async function jailPlayerFederal(playerId: number, jailTime: number): Promise<void> {
  await prisma.crimeAttempt.create({
    data: {
      playerId,
      crimeId: 'federal_arrest',
      success: false,
      reward: 0,
      xpGained: 0,
      jailed: true,
      jailTime,
      createdAt: new Date(),
    },
  });

  await activityService.logActivity(
    playerId,
    'ARREST',
    `Arrested by FBI for ${jailTime} minutes`,
    {
      authority: 'FBI',
      jailTime,
    },
    true
  );
}

/**
 * Get FBI investigation status for a player
 */
export async function getFBIStatus(
  playerId: number
): Promise<{ fbiHeat: number; federalBail: number; arrestChance: number }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { fbiHeat: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const fbiRatio = config.fbiRatio || 5;
  const arrestChance = Math.min((player.fbiHeat / fbiRatio) * 100, 95);
  const federalBail = calculateFederalBail(player.fbiHeat);

  return {
    fbiHeat: player.fbiHeat,
    federalBail,
    arrestChance: Math.round(arrestChance),
  };
}
