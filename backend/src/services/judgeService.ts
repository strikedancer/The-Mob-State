import prisma from '../lib/prisma';
import crimesData from '../../content/crimes.json';
import * as policeService from './policeService';
import { educationService } from './educationService';
import { worldEventService } from './worldEventService';

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
  originalJailTime: number;
  createdAt: Date;
  appealed: boolean;
  status: 'active' | 'served';
  history: CriminalRecordHistoryItem[];
}

interface CriminalRecordHistoryItem {
  type: 'conviction' | 'appeal_granted' | 'appeal_denied' | 'bribe_failed';
  createdAt: Date;
  originalSentence?: number;
  newSentence?: number;
  amount?: number;
}

interface TrialEventDetail {
  eventKey: TrialEventKey;
  createdAt: Date;
  crimeAttemptId: number;
  originalSentence?: number;
  newSentence?: number;
  amount?: number;
}

type TrialEventKey =
  | 'trial.appeal_granted'
  | 'trial.appeal_denied'
  | 'trial.bribe_success'
  | 'trial.bribe_failed'
  | 'trial.record_expunged';

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

const TRIAL_EVENT_KEYS: TrialEventKey[] = [
  'trial.appeal_granted',
  'trial.appeal_denied',
  'trial.bribe_success',
  'trial.bribe_failed',
  'trial.record_expunged',
];

function getJudgeForAttempt(crimeAttemptId: number): JudgeProfile {
  return JUDGES[crimeAttemptId % JUDGES.length] as JudgeProfile;
}

function getCrimeName(crimeId: string): string {
  return crimeNameById.get(crimeId) || crimeId;
}

function calculateReleaseTime(createdAt: Date, jailTimeMinutes: number): Date {
  return new Date(createdAt.getTime() + jailTimeMinutes * 60 * 1000);
}

function parseOptionalNumber(value: unknown): number | undefined {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value;
  }

  if (typeof value === 'string') {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) {
      return parsed;
    }
  }

  return undefined;
}

function parseTrialEvent(params: string, eventKey: string, createdAt: Date): TrialEventDetail | null {
  if (!TRIAL_EVENT_KEYS.includes(eventKey as TrialEventKey)) {
    return null;
  }

  let parsedParams: unknown = {};
  try {
    parsedParams = JSON.parse(params);
  } catch {
    return null;
  }

  if (!parsedParams || typeof parsedParams !== 'object') {
    return null;
  }

  const payload = parsedParams as Record<string, unknown>;
  const crimeAttemptId = parseOptionalNumber(payload.crimeAttemptId);
  if (!crimeAttemptId) {
    return null;
  }

  return {
    eventKey: eventKey as TrialEventKey,
    createdAt,
    crimeAttemptId,
    originalSentence: parseOptionalNumber(payload.originalSentence),
    newSentence: parseOptionalNumber(payload.newSentence),
    amount: parseOptionalNumber(payload.amount),
  };
}

async function getTrialEventsByAttempt(playerId: number, attemptIds: number[]): Promise<Map<number, TrialEventDetail[]>> {
  const eventsByAttempt = new Map<number, TrialEventDetail[]>();

  if (attemptIds.length === 0) {
    return eventsByAttempt;
  }

  const knownAttemptIds = new Set(attemptIds);
  const events = await prisma.worldEvent.findMany({
    where: {
      playerId,
      eventKey: {
        in: TRIAL_EVENT_KEYS,
      },
    },
    orderBy: {
      createdAt: 'asc',
    },
    select: {
      eventKey: true,
      params: true,
      createdAt: true,
    },
  });

  for (const event of events) {
    const parsedEvent = parseTrialEvent(event.params, event.eventKey, event.createdAt);
    if (!parsedEvent || !knownAttemptIds.has(parsedEvent.crimeAttemptId)) {
      continue;
    }

    const attemptEvents = eventsByAttempt.get(parsedEvent.crimeAttemptId) ?? [];
    attemptEvents.push(parsedEvent);
    eventsByAttempt.set(parsedEvent.crimeAttemptId, attemptEvents);
  }

  return eventsByAttempt;
}

async function getLatestRecordExpungementAt(playerId: number): Promise<Date | null> {
  const expungement = await prisma.worldEvent.findFirst({
    where: {
      playerId,
      eventKey: 'trial.record_expunged',
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      createdAt: true,
    },
  });

  return expungement?.createdAt ?? null;
}

async function getVisibleConvictionAttempts(
  playerId: number,
  excludeAttemptId?: number
) {
  const expungedAt = await getLatestRecordExpungementAt(playerId);
  const attempts = await prisma.crimeAttempt.findMany({
    where: {
      playerId,
      jailTime: {
        gt: 0,
      },
      ...(excludeAttemptId
        ? {
            id: {
              not: excludeAttemptId,
            },
          }
        : {}),
      ...(expungedAt
        ? {
            createdAt: {
              gt: expungedAt,
            },
          }
        : {}),
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      id: true,
      crimeId: true,
      jailTime: true,
      createdAt: true,
      appealedAt: true,
      jailed: true,
    },
  });

  const trialEventsByAttempt = await getTrialEventsByAttempt(
    playerId,
    attempts.map((attempt) => attempt.id)
  );
  const clearedAttemptIds = getClearedAttemptIds(trialEventsByAttempt);
  const visibleAttempts = attempts.filter((attempt) => !clearedAttemptIds.has(attempt.id));

  return {
    visibleAttempts,
    trialEventsByAttempt,
    expungedAt,
  };
}

function getClearedAttemptIds(eventsByAttempt: Map<number, TrialEventDetail[]>): Set<number> {
  const clearedAttemptIds = new Set<number>();

  for (const [attemptId, events] of eventsByAttempt.entries()) {
    if (events.some((event) => event.eventKey === 'trial.bribe_success')) {
      clearedAttemptIds.add(attemptId);
    }
  }

  return clearedAttemptIds;
}

function buildHistory(
  createdAt: Date,
  currentJailTime: number,
  events: TrialEventDetail[]
): { history: CriminalRecordHistoryItem[]; originalJailTime: number } {
  const appealGranted = events.find((event) => event.eventKey === 'trial.appeal_granted');
  const appealDenied = events.find((event) => event.eventKey === 'trial.appeal_denied');
  const originalJailTime =
    appealGranted?.originalSentence ?? appealDenied?.originalSentence ?? currentJailTime;

  const history: CriminalRecordHistoryItem[] = [
    {
      type: 'conviction',
      createdAt,
      originalSentence: originalJailTime,
    },
  ];

  for (const event of events) {
    if (event.eventKey === 'trial.appeal_granted') {
      history.push({
        type: 'appeal_granted',
        createdAt: event.createdAt,
        originalSentence: event.originalSentence,
        newSentence: event.newSentence ?? currentJailTime,
      });
      continue;
    }

    if (event.eventKey === 'trial.appeal_denied') {
      history.push({
        type: 'appeal_denied',
        createdAt: event.createdAt,
        originalSentence: event.originalSentence ?? currentJailTime,
      });
      continue;
    }

    if (event.eventKey === 'trial.bribe_failed') {
      history.push({
        type: 'bribe_failed',
        createdAt: event.createdAt,
        amount: event.amount,
      });
    }
  }

  return {
    history,
    originalJailTime,
  };
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
  const { visibleAttempts, trialEventsByAttempt } = await getVisibleConvictionAttempts(playerId);

  return {
    totalConvictions: visibleAttempts.length,
    recentCrimes: visibleAttempts.slice(0, 20).map((attempt) => {
      const { history, originalJailTime } = buildHistory(
        attempt.createdAt,
        attempt.jailTime,
        trialEventsByAttempt.get(attempt.id) ?? []
      );

      return {
        crimeAttemptId: attempt.id,
        crimeId: attempt.crimeId,
        crimeName: getCrimeName(attempt.crimeId),
        jailTime: attempt.jailTime,
        originalJailTime,
        createdAt: attempt.createdAt,
        appealed: !!attempt.appealedAt,
        status:
          attempt.jailed && calculateReleaseTime(attempt.createdAt, attempt.jailTime) > new Date()
            ? 'active'
            : 'served',
        history,
      };
    }),
  };
}

export async function appealSentence(
  playerId: number,
  crimeAttemptId: number
): Promise<AppealResult> {
  const [attempt, player, educationProfile] = await Promise.all([
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
    educationService.getPlayerEducationProfile(playerId),
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

  const { visibleAttempts: priorConvictionAttempts } = await getVisibleConvictionAttempts(
    playerId,
    crimeAttemptId
  );
  const priorConvictions = priorConvictionAttempts.length;

  // Law education track: every level adds +5% appeal success chance (max +25% at level 5)
  const lawLevel = educationProfile.tracks['law']?.level ?? 0;
  const lawBonus = Math.min(lawLevel * 0.05, 0.25);

  let successChance = 0.35 + lawBonus;
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

  successChance = Math.max(0.1, Math.min(0.85, successChance));
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

export async function getVisibleCriminalRecordCount(playerId: number): Promise<number> {
  const { visibleAttempts } = await getVisibleConvictionAttempts(playerId);
  return visibleAttempts.length;
}

export async function expungeCriminalRecord(playerId: number): Promise<number> {
  const { visibleAttempts } = await getVisibleConvictionAttempts(playerId);
  const clearedCount = visibleAttempts.length;

  if (clearedCount <= 0) {
    return 0;
  }

  await worldEventService.createEvent('trial.record_expunged', {
    playerId,
    clearedCount,
  }, playerId);

  return clearedCount;
}
