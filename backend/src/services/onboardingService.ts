import prisma from '../lib/prisma';

export const ONBOARDING_KEYS = {
  crime: 'onboarding.crime_done',
  cashOrJob: 'onboarding.cash_or_job',
  crew: 'onboarding.crew_joined',
  complete: 'onboarding.complete',
} as const;

export type OnboardingStep = 'crime' | 'cash_or_job' | 'crew' | 'done';

type OnboardingStatus = {
  completed: boolean;
  nextStep: OnboardingStep;
  ctaRoute: string;
  titleNl: string;
  titleEn: string;
  bodyNl: string;
  bodyEn: string;
  steps: {
    crimeDone: boolean;
    cashOrJobDone: boolean;
    crewJoined: boolean;
  };
};

const STEP_COPY: Record<
  OnboardingStep,
  { ctaRoute: string; titleNl: string; titleEn: string; bodyNl: string; bodyEn: string }
> = {
  crime: {
    ctaRoute: '/crimes',
    titleNl: 'Doe je eerste misdaad',
    titleEn: 'Do your first crime',
    bodyNl: 'Verdien cash en XP. Start met een simpele klus.',
    bodyEn: 'Earn cash and XP. Start with a simple job.',
  },
  cash_or_job: {
    ctaRoute: '/jobs',
    titleNl: 'Claim je dagdoel of werk 1 keer',
    titleEn: 'Claim your daily goal or work once',
    bodyNl: 'Pak je beloning of doe een legale job voor extra cash.',
    bodyEn: 'Grab your reward or do a legal job for extra cash.',
  },
  crew: {
    ctaRoute: '/crew',
    titleNl: 'Zoek of maak een crew',
    titleEn: 'Find or create a crew',
    bodyNl: 'Open crews kun je meteen joinen. Samen verdien je meer.',
    bodyEn: 'Open crews can be joined instantly. You earn more together.',
  },
  done: {
    ctaRoute: '/dashboard',
    titleNl: 'Klaar',
    titleEn: 'Done',
    bodyNl: 'Je start is compleet.',
    bodyEn: 'Your start is complete.',
  },
};

async function hasEvent(playerId: number, eventKey: string): Promise<boolean> {
  const row = await prisma.worldEvent.findFirst({
    where: { playerId, eventKey },
    select: { id: true },
  });
  return Boolean(row);
}

async function markEvent(playerId: number, eventKey: string): Promise<void> {
  const exists = await hasEvent(playerId, eventKey);
  if (exists) return;
  await prisma.worldEvent.create({
    data: {
      eventKey,
      params: JSON.stringify({ source: 'onboarding' }),
      playerId,
    },
  });
}

async function inferAndMark(playerId: number): Promise<{
  crimeDone: boolean;
  cashOrJobDone: boolean;
  crewJoined: boolean;
  completed: boolean;
}> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { rank: true },
  });

  const [crimeEvent, cashEvent, crewEvent, completeEvent, crimeCount, jobCount, membership] =
    await Promise.all([
      hasEvent(playerId, ONBOARDING_KEYS.crime),
      hasEvent(playerId, ONBOARDING_KEYS.cashOrJob),
      hasEvent(playerId, ONBOARDING_KEYS.crew),
      hasEvent(playerId, ONBOARDING_KEYS.complete),
      prisma.crimeAttempt.count({
        where: { playerId, NOT: { crimeId: 'police_arrest' } },
      }),
      prisma.jobAttempt.count({
        where: { playerId, completedAt: { not: null } },
      }),
      prisma.crewMember.findUnique({
        where: { playerId },
        select: { id: true },
      }),
    ]);

  let crimeDone = crimeEvent || crimeCount > 0;
  let cashOrJobDone = cashEvent || jobCount > 0 || crimeCount > 0;
  let crewJoined = crewEvent || Boolean(membership);
  let completed = completeEvent;

  if ((player?.rank ?? 1) >= 3 && crimeDone && crewJoined) {
    completed = true;
  }

  if (crimeDone && !crimeEvent) await markEvent(playerId, ONBOARDING_KEYS.crime);
  if (cashOrJobDone && !cashEvent) await markEvent(playerId, ONBOARDING_KEYS.cashOrJob);
  if (crewJoined && !crewEvent) await markEvent(playerId, ONBOARDING_KEYS.crew);
  if (crimeDone && cashOrJobDone && crewJoined) {
    completed = true;
    if (!completeEvent) await markEvent(playerId, ONBOARDING_KEYS.complete);
  }

  return { crimeDone, cashOrJobDone, crewJoined, completed };
}

export const onboardingService = {
  async markCrime(playerId: number): Promise<void> {
    await markEvent(playerId, ONBOARDING_KEYS.crime);
    await markEvent(playerId, ONBOARDING_KEYS.cashOrJob);
  },

  async markJob(playerId: number): Promise<void> {
    await markEvent(playerId, ONBOARDING_KEYS.cashOrJob);
  },

  async markCrew(playerId: number): Promise<void> {
    await markEvent(playerId, ONBOARDING_KEYS.crew);
    const status = await inferAndMark(playerId);
    if (status.crimeDone && status.cashOrJobDone && status.crewJoined) {
      await markEvent(playerId, ONBOARDING_KEYS.complete);
    }
  },

  async getStatus(playerId: number): Promise<OnboardingStatus> {
    const steps = await inferAndMark(playerId);
    let nextStep: OnboardingStep = 'done';
    if (!steps.crimeDone) nextStep = 'crime';
    else if (!steps.cashOrJobDone) nextStep = 'cash_or_job';
    else if (!steps.crewJoined) nextStep = 'crew';

    const copy = STEP_COPY[nextStep];
    return {
      completed: steps.completed || nextStep === 'done',
      nextStep,
      ctaRoute: copy.ctaRoute,
      titleNl: copy.titleNl,
      titleEn: copy.titleEn,
      bodyNl: copy.bodyNl,
      bodyEn: copy.bodyEn,
      steps: {
        crimeDone: steps.crimeDone,
        cashOrJobDone: steps.cashOrJobDone,
        crewJoined: steps.crewJoined,
      },
    };
  },
};
