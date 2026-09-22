import prisma from '../lib/prisma';
import { checkIfJailed } from './policeService';

export const JAIL_MATH_REWARD_SECONDS = 10;
/** Minimum gap between answer attempts (anti-spam / bot). */
export const JAIL_MATH_MIN_INTERVAL_MS = 2000;
const CHALLENGE_TTL_MS = 90_000;

type MathOp = '+' | '-' | '/';

type PendingChallenge = {
  answer: number;
  prompt: string;
  expiresAt: number;
};

const pendingByPlayer = new Map<number, PendingChallenge>();
const lastSubmitAtByPlayer = new Map<number, number>();

function randomInt(min: number, maxInclusive: number): number {
  return Math.floor(Math.random() * (maxInclusive - min + 1)) + min;
}

function generateProblem(): { prompt: string; answer: number; op: MathOp } {
  const roll = randomInt(0, 2);
  if (roll === 0) {
    const a = randomInt(2, 48);
    const b = randomInt(2, 48);
    return { prompt: `${a} + ${b}`, answer: a + b, op: '+' };
  }
  if (roll === 1) {
    const a = randomInt(12, 99);
    const b = randomInt(2, Math.min(40, a - 1));
    return { prompt: `${a} − ${b}`, answer: a - b, op: '-' };
  }
  const b = randomInt(2, 12);
  const quotient = randomInt(2, 15);
  const a = b * quotient;
  return { prompt: `${a} ÷ ${b}`, answer: quotient, op: '/' };
}

async function writeJailRemainingSeconds(
  playerId: number,
  remainingSeconds: number,
): Promise<void> {
  if (remainingSeconds <= 0) {
    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { jailRelease: null },
      });
      await tx.crimeAttempt.updateMany({
        where: { playerId, jailed: true },
        data: { jailed: false },
      });
    });
    return;
  }

  await prisma.player.update({
    where: { id: playerId },
    data: { jailRelease: new Date(Date.now() + remainingSeconds * 1000) },
  });
}

function storeNewChallenge(playerId: number): PendingChallenge {
  const problem = generateProblem();
  const pending: PendingChallenge = {
    answer: problem.answer,
    prompt: problem.prompt,
    expiresAt: Date.now() + CHALLENGE_TTL_MS,
  };
  pendingByPlayer.set(playerId, pending);
  return pending;
}

export async function getJailMathChallenge(playerId: number): Promise<{
  prompt: string;
  rewardSeconds: number;
  remainingSeconds: number;
}> {
  const remainingSeconds = await checkIfJailed(playerId);
  if (remainingSeconds <= 0) {
    pendingByPlayer.delete(playerId);
    throw Object.assign(new Error('NOT_JAILED'), { code: 'NOT_JAILED' });
  }

  const existing = pendingByPlayer.get(playerId);
  if (existing && existing.expiresAt > Date.now()) {
    return {
      prompt: existing.prompt,
      rewardSeconds: JAIL_MATH_REWARD_SECONDS,
      remainingSeconds,
    };
  }

  const pending = storeNewChallenge(playerId);
  return {
    prompt: pending.prompt,
    rewardSeconds: JAIL_MATH_REWARD_SECONDS,
    remainingSeconds,
  };
}

export async function submitJailMathAnswer(
  playerId: number,
  rawAnswer: unknown,
): Promise<{
  correct: boolean;
  prompt: string;
  rewardSeconds: number;
  remainingSeconds: number;
  reducedBySeconds: number;
  released: boolean;
}> {
  const remainingSeconds = await checkIfJailed(playerId);
  if (remainingSeconds <= 0) {
    pendingByPlayer.delete(playerId);
    throw Object.assign(new Error('NOT_JAILED'), { code: 'NOT_JAILED' });
  }

  const now = Date.now();
  const lastSubmit = lastSubmitAtByPlayer.get(playerId) ?? 0;
  if (now - lastSubmit < JAIL_MATH_MIN_INTERVAL_MS) {
    const retryAfterMs = JAIL_MATH_MIN_INTERVAL_MS - (now - lastSubmit);
    throw Object.assign(new Error('MATH_COOLDOWN'), {
      code: 'MATH_COOLDOWN',
      retryAfterSeconds: Math.max(1, Math.ceil(retryAfterMs / 1000)),
    });
  }
  lastSubmitAtByPlayer.set(playerId, now);

  const answer =
    typeof rawAnswer === 'number'
      ? rawAnswer
      : typeof rawAnswer === 'string'
        ? Number(rawAnswer.trim())
        : NaN;
  if (!Number.isFinite(answer) || !Number.isInteger(answer)) {
    throw Object.assign(new Error('INVALID_ANSWER'), { code: 'INVALID_ANSWER' });
  }

  let pending = pendingByPlayer.get(playerId);
  if (!pending || pending.expiresAt <= now) {
    pending = storeNewChallenge(playerId);
    return {
      correct: false,
      prompt: pending.prompt,
      rewardSeconds: JAIL_MATH_REWARD_SECONDS,
      remainingSeconds,
      reducedBySeconds: 0,
      released: false,
    };
  }

  if (answer !== pending.answer) {
    const next = storeNewChallenge(playerId);
    return {
      correct: false,
      prompt: next.prompt,
      rewardSeconds: JAIL_MATH_REWARD_SECONDS,
      remainingSeconds,
      reducedBySeconds: 0,
      released: false,
    };
  }

  const reducedBySeconds = Math.min(JAIL_MATH_REWARD_SECONDS, remainingSeconds);
  const nextRemaining = Math.max(0, remainingSeconds - JAIL_MATH_REWARD_SECONDS);
  await writeJailRemainingSeconds(playerId, nextRemaining);

  const next = storeNewChallenge(playerId);
  return {
    correct: true,
    prompt: next.prompt,
    rewardSeconds: JAIL_MATH_REWARD_SECONDS,
    remainingSeconds: nextRemaining,
    reducedBySeconds,
    released: nextRemaining <= 0,
  };
}
