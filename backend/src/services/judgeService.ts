import prisma from '../lib/prisma';
import crimesData from '../../content/crimes.json';
import * as policeService from './policeService';

interface JudgeProfile {
  id: number;
  name: string;
  corruptibility: number;
  appointedYear: number;
  specialty: string;
}

interface CriminalRecordItem {
  crimeAttemptId: number;
  crimeId: string;
  crimeName: string;
  jailTime: number;
  createdAt: Date;
  appealed: boolean;
}

export interface AppealResult {
  success: boolean;
  originalSentence: number;
  newSentence?: number;
  newBalance: number;
  cost: number;
  reason: string;
}

const JUDGES: JudgeProfile[] = [
  {
    id: 1,
    name: 'Rechter van der Berg',
    corruptibility: 35,
    specialty: 'Geweldsmisdrijven',
    appointedYear: 2015,
  },
  {
    id: 2,
    name: 'Rechter Jansen',
    corruptibility: 65,
    specialty: 'Financiele Delicten',
    appointedYear: 2018,
  },
  {
    id: 3,
    name: 'Rechter de Vries',
    corruptibility: 20,
    specialty: 'Drugsgerelateerde Zaken',
    appointedYear: 2010,
  },
  {
    id: 4,
    name: 'Rechter Bakker',
    corruptibility: 80,
    specialty: 'Witte Boordencriminaliteit',
    appointedYear: 2020,
  },
  {
    id: 5,
    name: 'Rechter Visser',
    corruptibility: 45,
    specialty: 'Georganiseerde Misdaad',
    appointedYear: 2012,
  },
];

const crimeNameById = new Map(
  (crimesData.crimes || []).map((crime) => [crime.id, crime.name])
);

function getJudgeForAttempt(crimeAttemptId: number): JudgeProfile {
  return JUDGES[crimeAttemptId % JUDGES.length] as JudgeProfile;
}

function getCrimeName(crimeId: string): string {
  return crimeNameById.get(crimeId) || crimeId;
}

function calculateReleaseTime(createdAt: Date, jailTimeMinutes: number): Date {
  return new Date(createdAt.getTime() + jailTimeMinutes * 60 * 1000);
}

async function getLatestJailedAttempt(playerId: number) {
  return prisma.crimeAttempt.findFirst({
    where: {
      playerId,
      jailed: true,
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      id: true,
      playerId: true,
      crimeId: true,
      jailTime: true,
      appealedAt: true,
      createdAt: true,
      jailed: true,
    },
  });
}

export async function getCurrentSentence(playerId: number) {
  const remainingSeconds = await policeService.checkIfJailed(playerId);
  if (remainingSeconds <= 0) {
    return null;
  }

  const crimeAttempt = await getLatestJailedAttempt(playerId);
  if (!crimeAttempt) {
    return null;
  }

  const judge = getJudgeForAttempt(crimeAttempt.id);

  return {
    sentence: {
      crimeAttemptId: crimeAttempt.id,
      crimeId: crimeAttempt.crimeId,
      crime: getCrimeName(crimeAttempt.crimeId),
      sentenceMinutes: crimeAttempt.jailTime,
      remainingMinutes: Math.max(1, Math.ceil(remainingSeconds / 60)),
      judge,
      appealed: !!crimeAttempt.appealedAt,
      arrestedAt: crimeAttempt.createdAt.toISOString(),
    },
  };
}

export async function getCriminalRecord(playerId: number): Promise<{
  totalConvictions: number;
  recentCrimes: CriminalRecordItem[];
}> {
  const [totalConvictions, attempts] = await Promise.all([
    prisma.crimeAttempt.count({
      where: {
        playerId,
        jailed: true,
      },
    }),
    prisma.crimeAttempt.findMany({
      where: {
        playerId,
        jailed: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
      take: 20,
      select: {
        id: true,
        crimeId: true,
        jailTime: true,
        createdAt: true,
        appealedAt: true,
      },
    }),
  ]);

  return {
    totalConvictions,
    recentCrimes: attempts.map((attempt) => ({
      crimeAttemptId: attempt.id,
      crimeId: attempt.crimeId,
      crimeName: getCrimeName(attempt.crimeId),
      jailTime: attempt.jailTime,
      createdAt: attempt.createdAt,
      appealed: !!attempt.appealedAt,
    })),
  };
}

export async function appealSentence(
  playerId: number,
  crimeAttemptId: number
): Promise<AppealResult> {
  const [attempt, player] = await Promise.all([
    prisma.crimeAttempt.findUnique({
      where: { id: crimeAttemptId },
      select: {
        id: true,
        playerId: true,
        jailTime: true,
        appealedAt: true,
        createdAt: true,
        jailed: true,
      },
    }),
    prisma.player.findUnique({
      where: { id: playerId },
      select: {
        money: true,
        wantedLevel: true,
        fbiHeat: true,
      },
    }),
  ]);

  if (!attempt) {
    throw new Error('CRIME_ATTEMPT_NOT_FOUND');
  }

  if (attempt.playerId !== playerId) {
    throw new Error('NOT_YOUR_CRIME');
  }

  if (!attempt.jailed) {
    throw new Error('NOT_JAILED');
  }

  const currentRelease = calculateReleaseTime(attempt.createdAt, attempt.jailTime);
  if (currentRelease <= new Date()) {
    throw new Error('SENTENCE_ALREADY_SERVED');
  }

  if (attempt.appealedAt) {
    throw new Error('ALREADY_APPEALED');
  }

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const appealCost = Math.min(Math.max(attempt.jailTime * 100, 2000), 50000);
  if (player.money < appealCost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const priorConvictions = await prisma.crimeAttempt.count({
    where: {
      playerId,
      jailed: true,
      id: {
        not: crimeAttemptId,
      },
    },
  });

  let successChance = 0.35;
  if (priorConvictions === 0) {
    successChance += 0.2;
  } else if (priorConvictions >= 5) {
    successChance -= 0.2;
  }

  if (player.wantedLevel > 20) {
    successChance -= 0.1;
  }
  if (player.fbiHeat > 10) {
    successChance -= 0.15;
  }

  successChance = Math.max(0.1, Math.min(0.7, successChance));
  const success = Math.random() < successChance;

  const updatedPlayer = await prisma.player.update({
    where: { id: playerId },
    data: {
      money: {
        decrement: appealCost,
      },
    },
    select: {
      money: true,
    },
  });

  await prisma.crimeAttempt.update({
    where: { id: crimeAttemptId },
    data: {
      appealedAt: new Date(),
    },
  });

  if (!success) {
    return {
      success: false,
      originalSentence: attempt.jailTime,
      newBalance: updatedPlayer.money,
      cost: appealCost,
      reason: 'Appeal denied. Original sentence upheld.',
    };
  }

  const reductionPercent = 0.2 + Math.random() * 0.2;
  const newSentence = Math.max(1, Math.floor(attempt.jailTime * (1 - reductionPercent)));
  const newRelease = calculateReleaseTime(attempt.createdAt, newSentence);

  await prisma.$transaction(async (tx) => {
    await tx.crimeAttempt.update({
      where: { id: crimeAttemptId },
      data: {
        jailTime: newSentence,
      },
    });

    await tx.player.update({
      where: { id: playerId },
      data: {
        jailRelease: newRelease,
      },
    });
  });

  return {
    success: true,
    originalSentence: attempt.jailTime,
    newSentence,
    newBalance: updatedPlayer.money,
    cost: appealCost,
    reason: 'Appeal granted. Sentence has been reduced.',
  };
}

export async function bribeJudgeForAttempt(
  playerId: number,
  crimeAttemptId: number,
  bribeAmount: number
): Promise<{ success: boolean; newBalance: number }> {
  if (bribeAmount < 50000) {
    throw new Error('BRIBE_TOO_LOW');
  }

  const [attempt, player] = await Promise.all([
    prisma.crimeAttempt.findUnique({
      where: { id: crimeAttemptId },
      select: {
        id: true,
        playerId: true,
        jailTime: true,
        createdAt: true,
        jailed: true,
      },
    }),
    prisma.player.findUnique({
      where: { id: playerId },
      select: {
        money: true,
      },
    }),
  ]);

  if (!attempt) {
    throw new Error('CRIME_ATTEMPT_NOT_FOUND');
  }

  if (attempt.playerId !== playerId) {
    throw new Error('NOT_YOUR_CRIME');
  }

  if (!attempt.jailed) {
    throw new Error('NOT_JAILED');
  }

  const currentRelease = calculateReleaseTime(attempt.createdAt, attempt.jailTime);
  if (currentRelease <= new Date()) {
    throw new Error('SENTENCE_ALREADY_SERVED');
  }

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < bribeAmount) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const judge = getJudgeForAttempt(crimeAttemptId);
  const bribeBonus = Math.max(0, ((bribeAmount - 50000) / 150000) * 40);
  const totalChance = Math.min(90, judge.corruptibility + bribeBonus);
  const success = Math.random() * 100 < totalChance;

  const updatedPlayer = await prisma.player.update({
    where: { id: playerId },
    data: {
      money: {
        decrement: bribeAmount,
      },
    },
    select: {
      money: true,
    },
  });

  if (success) {
    await prisma.$transaction(async (tx) => {
      await tx.crimeAttempt.update({
        where: { id: crimeAttemptId },
        data: {
          jailed: false,
        },
      });

      await tx.player.update({
        where: { id: playerId },
        data: {
          jailRelease: null,
        },
      });
    });
  }

  return {
    success,
    newBalance: updatedPlayer.money,
  };
}
