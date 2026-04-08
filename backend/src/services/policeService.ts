import prisma from '../lib/prisma';
import config from '../config';
import { activityService } from './activityService';

/**
 * Police Service
 * Manages wanted levels, arrests, and bail system
 */

interface ArrestResult {
  arrested: boolean;
  wantedLevel: number;
  bail?: number;
  jailTime?: number;
}

/**
 * Check if player should be arrested based on wanted level and police ratio
 * Police ratio: 1 cop per X players (default 10)
 * Arrest chance increases with wanted level
 */
export async function checkArrest(playerId: number): Promise<ArrestResult> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { wantedLevel: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // If wanted level is 0, no arrest
  if (player.wantedLevel === 0) {
    return {
      arrested: false,
      wantedLevel: 0,
    };
  }

  // Calculate arrest chance based on wanted level
  // Formula: arrestChance = min(wantedLevel / policeRatio, 90%)
  const arrestChance = Math.min((player.wantedLevel / config.policeRatio) * 100, 90);
  const roll = Math.random() * 100;

  if (roll < arrestChance) {
    // Player gets arrested
    const jailTime = calculateJailTime(player.wantedLevel);
    const bail = calculateBail(player.wantedLevel);

    return {
      arrested: true,
      wantedLevel: player.wantedLevel,
      bail,
      jailTime,
    };
  }

  return {
    arrested: false,
    wantedLevel: player.wantedLevel,
  };
}

/**
 * Calculate jail time based on wanted level
 * Formula: jailTime (minutes) = wantedLevel * 10
 */
function calculateJailTime(wantedLevel: number): number {
  return Math.max(wantedLevel * 10, 5); // Minimum 5 minutes
}

/**
 * Calculate bail amount based on wanted level
 * Formula: bail = wantedLevel * 1000
 */
export function calculateBail(wantedLevel: number): number {
  return wantedLevel * 1000;
}

/**
 * Pay bail to get out of jail
 */
export async function payBail(playerId: number): Promise<void> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { id: true, money: true, wantedLevel: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const bail = calculateBail(player.wantedLevel);

  if (player.money < bail) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Pay bail: deduct money, reduce wanted level by 50%, and release from jail
  const newWantedLevel = Math.floor(player.wantedLevel / 2);

  await prisma.$transaction(async (tx: any) => {
    // Update player stats and clear jailRelease
    await tx.player.update({
      where: { id: playerId },
      data: {
        money: { decrement: bail },
        wantedLevel: newWantedLevel,
        jailRelease: null, // Release from jail
      },
    });

    // Release from jail by setting jailed to false
    await tx.crimeAttempt.updateMany({
      where: {
        playerId,
        jailed: true,
      },
      data: {
        jailed: false,
      },
    });
  });

  await activityService.logActivity(
    playerId,
    'BAIL_PAID',
    `Paid bail of €${bail.toLocaleString()}`,
    {
      authority: 'Police',
      bail,
      wantedLevelBefore: player.wantedLevel,
      wantedLevelAfter: newWantedLevel,
    },
    true
  );
}

/**
 * Increase wanted level when player fails a crime
 */
export async function increaseWantedLevel(playerId: number, amount: number): Promise<number> {
  const updated = await prisma.player.update({
    where: { id: playerId },
    data: {
      wantedLevel: { increment: amount },
    },
    select: { wantedLevel: true },
  });

  return updated.wantedLevel;
}

/**
 * Decrease wanted level over time (passive decay)
 * Called by tick service
 */
export async function decayWantedLevel(playerId: number): Promise<number> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { wantedLevel: true, username: true },
  });

  if (!player || player.wantedLevel === 0) {
    return 0;
  }

  // Decay 1 wanted level per tick
  const newWantedLevel = Math.max(player.wantedLevel - 1, 0);

  await prisma.player.update({
    where: { id: playerId },
    data: { wantedLevel: newWantedLevel },
  });

  console.log(`🚔 Wanted level decay: ${player.username} ${player.wantedLevel} → ${newWantedLevel}`);

  return newWantedLevel;
}

/**
 * Check if player is currently in jail
 * Returns remaining jail time in minutes, or 0 if not jailed
 */
/**
 * Check if player is jailed and return remaining seconds
 * @returns remaining seconds (not minutes!)
 */
export async function checkIfJailed(playerId: number): Promise<number> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { jailRelease: true },
  });

  if (player?.jailRelease && player.jailRelease > new Date()) {
    const remainingMs = player.jailRelease.getTime() - Date.now();
    return Math.max(0, Math.floor(remainingMs / 1000));
  }

  // Get the most recent jail attempt
  const latestJailAttempt = await prisma.crimeAttempt.findFirst({
    where: {
      playerId,
      jailed: true,
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      createdAt: true,
      jailTime: true,
    },
  });

  if (!latestJailAttempt) {
    return 0; // Not jailed
  }

  // Calculate release time: createdAt + jailTime (in minutes)
  const releaseTime = new Date(
    latestJailAttempt.createdAt.getTime() + latestJailAttempt.jailTime * 60 * 1000
  );

  const now = new Date();

  // If release time is in the future, player is still jailed
  if (releaseTime > now) {
    const remainingMs = releaseTime.getTime() - now.getTime();
    const remainingSeconds = Math.floor(remainingMs / 1000);

    await prisma.player.update({
      where: { id: playerId },
      data: { jailRelease: releaseTime },
    });
    
    return remainingSeconds;
  }

  if (player?.jailRelease) {
    await prisma.player.update({
      where: { id: playerId },
      data: { jailRelease: null },
    });
  }

  return 0; // Jail time expired
}

/**
 * Jail a player (create crime attempt with jailed=true)
 */
export async function jailPlayer(playerId: number, jailTime: number): Promise<void> {
  const now = new Date();
  const jailRelease = new Date(now.getTime() + jailTime * 60 * 1000);

  await prisma.$transaction(async (tx: any) => {
    await tx.crimeAttempt.create({
      data: {
        playerId,
        crimeId: 'police_arrest',
        success: false,
        reward: 0,
        xpGained: 0,
        jailed: true,
        jailTime,
      },
    });

    await tx.player.update({
      where: { id: playerId },
      data: { jailRelease },
    });
  });

  await activityService.logActivity(
    playerId,
    'ARREST',
    `Arrested by police for ${jailTime} minutes`,
    {
      authority: 'Police',
      jailTime,
      jailedUntil: jailRelease.toISOString(),
    },
    true
  );
}

export async function getJailedPrisoners(viewerId: number): Promise<
  Array<{
    playerId: number;
    username: string;
    rank: number;
    wantedLevel: number;
    remainingSeconds: number;
    bailCost: number;
  }>
> {
  const rawIds = await prisma.$queryRaw<Array<{ playerId: number }>>`
    SELECT DISTINCT playerId
    FROM crime_attempts
    WHERE jailed = 1
    ORDER BY createdAt DESC
    LIMIT 250
  `;

  const uniqueIds = [...new Set(rawIds.map((row) => Number(row.playerId)).filter((id) => id !== viewerId))];
  if (uniqueIds.length === 0) {
    return [];
  }

  const players = await prisma.player.findMany({
    where: { id: { in: uniqueIds } },
    select: {
      id: true,
      username: true,
      rank: true,
      wantedLevel: true,
    },
  });

  const withRemaining = await Promise.all(
    players.map(async (player) => {
      const remainingSeconds = await checkIfJailed(player.id);
      return {
        player,
        remainingSeconds,
      };
    })
  );

  return withRemaining
    .filter((entry) => entry.remainingSeconds > 0)
    .map((entry) => ({
      playerId: entry.player.id,
      username: entry.player.username,
      rank: entry.player.rank,
      wantedLevel: entry.player.wantedLevel,
      remainingSeconds: entry.remainingSeconds,
      bailCost: calculateBail(entry.player.wantedLevel),
    }))
    .sort((a, b) => a.remainingSeconds - b.remainingSeconds);
}

export async function buyOutPrisoner(
  buyerId: number,
  targetId: number
): Promise<{
  amount: number;
  targetUsername: string;
}> {
  if (buyerId === targetId) {
    throw new Error('CANNOT_BUYOUT_SELF');
  }

  const remainingTime = await checkIfJailed(targetId);
  if (remainingTime <= 0) {
    throw new Error('TARGET_NOT_JAILED');
  }

  const [buyer, target] = await Promise.all([
    prisma.player.findUnique({
      where: { id: buyerId },
      select: { id: true, money: true, username: true },
    }),
    prisma.player.findUnique({
      where: { id: targetId },
      select: { id: true, username: true, wantedLevel: true },
    }),
  ]);

  if (!buyer) {
    throw new Error('BUYER_NOT_FOUND');
  }

  if (!target) {
    throw new Error('TARGET_NOT_FOUND');
  }

  const bail = calculateBail(target.wantedLevel);
  if (buyer.money < bail) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  await prisma.$transaction(async (tx: any) => {
    await tx.player.update({
      where: { id: buyerId },
      data: {
        money: { decrement: bail },
      },
    });

    await tx.player.update({
      where: { id: targetId },
      data: {
        wantedLevel: Math.floor(target.wantedLevel / 2),
        jailRelease: null,
      },
    });

    await tx.crimeAttempt.updateMany({
      where: {
        playerId: targetId,
        jailed: true,
      },
      data: {
        jailed: false,
      },
    });

    await tx.worldEvent.create({
      data: {
        eventKey: 'prison.buyout_success',
        playerId: buyerId,
        params: {
          targetId,
          bail,
        },
      },
    });
  });

  return {
    amount: bail,
    targetUsername: target.username,
  };
}

/**
 * Attempt jailbreak - rescue a jailed player
 * Returns: { success: boolean, rescuerCaught: boolean, message: string }
 */
export async function attemptJailbreak(
  rescuerId: number,
  jailedPlayerId: number,
  crewId?: number
): Promise<{
  success: boolean;
  rescuerCaught: boolean;
  rescuerJailTime?: number;
  message: string;
}> {
  // Check if rescuer is in jail
  const rescuerJailTime = await checkIfJailed(rescuerId);
  if (rescuerJailTime > 0) {
    throw new Error('RESCUER_JAILED');
  }

  // Check if target is actually in jail
  const targetJailTime = await checkIfJailed(jailedPlayerId);
  if (targetJailTime === 0) {
    throw new Error('TARGET_NOT_JAILED');
  }

  // Get rescuer's wanted level (affects success chance)
  const rescuer = await prisma.player.findUnique({
    where: { id: rescuerId },
    select: { wantedLevel: true, rank: true },
  });

  if (!rescuer) {
    throw new Error('RESCUER_NOT_FOUND');
  }

  // Calculate success chance
  // Tuned for better gameplay feel:
  // Base: 45%
  // +3% per rank level
  // Wanted penalties: -10 (>5), -20 (>10)
  // Crew bonus: +15%
  let successChance = 45;
  successChance += rescuer.rank * 3;

  if (rescuer.wantedLevel > 10) {
    successChance -= 20;
  } else if (rescuer.wantedLevel > 5) {
    successChance -= 10;
  }

  // Crew bonus: +15% if in same crew
  if (crewId) {
    // Verify both are in same crew
    const crewMembers = await prisma.crewMember.findMany({
      where: {
        crewId,
        playerId: { in: [rescuerId, jailedPlayerId] },
      },
    });

    if (crewMembers.length === 2) {
      successChance += 15;
    }
  }

  // Clamp between 20% and 95%
  successChance = Math.max(20, Math.min(successChance, 95));

  // Roll for success
  const roll = Math.random() * 100;
  const success = roll < successChance;

  let rescuerCaught = false;
  let rescuerNewJailTime = 0;

  if (success) {
    // Success! Free the jailed player by setting their jail time to expired
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
    await prisma.crimeAttempt.updateMany({
      where: {
        playerId: jailedPlayerId,
        jailed: true,
      },
      data: {
        createdAt: oneHourAgo,
        jailTime: 1, // Expired
      },
    });

    // Record successful jailbreak
    await prisma.$executeRaw`
      INSERT INTO jailbreak_attempts (rescuerId, jailedPlayerId, success, crewId)
      VALUES (${rescuerId}, ${jailedPlayerId}, ${success}, ${crewId || null})
    `;

    await prisma.player.update({
      where: { id: jailedPlayerId },
      data: { jailRelease: null },
    });

    await prisma.worldEvent.create({
      data: {
        eventKey: 'prison.jailbreak_success',
        playerId: rescuerId,
        params: {
          targetId: jailedPlayerId,
          crewId: crewId ?? null,
        },
      },
    });

    return {
      success: true,
      rescuerCaught: false,
      message: 'Jailbreak successful! Player freed!',
    };
  } else {
    // Failed! 60% chance rescuer gets caught too
    const catchRoll = Math.random() * 100;
    rescuerCaught = catchRoll < 60;

    if (rescuerCaught) {
      // Rescuer gets jailed for attempting jailbreak (30-60 minutes)
      rescuerNewJailTime = Math.floor(Math.random() * 31) + 30;
      await jailPlayer(rescuerId, rescuerNewJailTime);

      // Increase rescuer's wanted level
      await increaseWantedLevel(rescuerId, 10);
    }

    // Record failed jailbreak
    await prisma.$executeRaw`
      INSERT INTO jailbreak_attempts (rescuerId, jailedPlayerId, success, crewId)
      VALUES (${rescuerId}, ${jailedPlayerId}, ${success}, ${crewId || null})
    `;

    return {
      success: false,
      rescuerCaught,
      rescuerJailTime: rescuerCaught ? rescuerNewJailTime : undefined,
      message: rescuerCaught
        ? `Jailbreak failed! You got caught and jailed for ${rescuerNewJailTime} minutes!`
        : 'Jailbreak failed! You escaped but the player is still jailed.',
    };
  }
}
