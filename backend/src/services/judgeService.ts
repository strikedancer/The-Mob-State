import prisma from '../lib/prisma';
import crimesData from '../../content/crimes.json';
import * as policeService from './policeService';
import { educationService } from './educationService';
import { worldEventService } from './worldEventService';
import { donService } from './donService';
import { getDonRuntimeConfig } from './donRuntimeConfig';
import * as cooldownService from './cooldownService';
import { timeProvider } from '../utils/timeProvider';
import {
  computeExpungePetitionCost,
  computeExpungePetitionOdds,
  type ExpungePetitionOddsBreakdown,
} from './expungePetitionMath';
import {
  getCourtRuntimeConfig,
  getExpungePetitionMathConfigFromCourt,
  type CourtRuntimeConfig,
} from './courtRuntimeConfig';

export {
  computeExpungePetitionCost,
  computeExpungePetitionOdds,
  EXPUNGE_PETITION_COOLDOWN_SECONDS,
} from './expungePetitionMath';
export { getCourtRuntimeConfig } from './courtRuntimeConfig';
export type { CourtRuntimeConfig } from './courtRuntimeConfig';

type JudgeSpecialtyKey = 'violence' | 'financial' | 'drugs' | 'white_collar' | 'organized';

interface JudgeProfile {
  id: number;
  name: string;
  nameKey: string;
  specialtyKey: JudgeSpecialtyKey;
  specialty: JudgeSpecialtyKey;
  corruptibility: number;
  appointedYear: number;
}

export interface AppealOddsBreakdown {
  lawLevel: number;
  lawBonusPercent: number;
  priorConvictions: number;
  priorConvictionModifierPercent: number;
  wantedLevel: number;
  wantedPenaltyApplied: boolean;
  wantedPenaltyPercent: number;
  fbiHeat: number;
  fbiPenaltyApplied: boolean;
  fbiPenaltyPercent: number;
  successChance: number;
  successPercent: number;
}

interface CriminalRecordItem {
  crimeAttemptId: number;
  crimeId: string;
  crimeName: string;
  sourceCrimeId: string | null;
  sourceCrimeName: string | null;
  arrestReason: string | null;
  countryId: string | null;
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

export interface ExpungePetitionQuote {
  countryId: string | null;
  convictionCount: number;
  cost: number;
  lastArrestAt: string | null;
  cooldownRemainingSeconds: number;
  canSubmit: boolean;
  blockReason: 'NO_CRIMINAL_RECORD' | 'COOLDOWN' | 'INSUFFICIENT_MONEY' | null;
  odds: ExpungePetitionOddsBreakdown;
}

export interface ExpungePetitionResult {
  success: boolean;
  cost: number;
  convictionCount: number;
  clearedCount: number;
  newBalance: number;
  successPercent: number;
  cooldownSeconds: number;
}

const JUDGES: JudgeProfile[] = [
  {
    id: 1,
    name: 'van der Berg',
    nameKey: 'van_der_berg',
    specialtyKey: 'violence',
    specialty: 'violence',
    corruptibility: 35,
    appointedYear: 2015,
  },
  {
    id: 2,
    name: 'Jansen',
    nameKey: 'jansen',
    specialtyKey: 'financial',
    specialty: 'financial',
    corruptibility: 65,
    appointedYear: 2018,
  },
  {
    id: 3,
    name: 'de Vries',
    nameKey: 'de_vries',
    specialtyKey: 'drugs',
    specialty: 'drugs',
    corruptibility: 20,
    appointedYear: 2010,
  },
  {
    id: 4,
    name: 'Bakker',
    nameKey: 'bakker',
    specialtyKey: 'white_collar',
    specialty: 'white_collar',
    corruptibility: 80,
    appointedYear: 2020,
  },
  {
    id: 5,
    name: 'Visser',
    nameKey: 'visser',
    specialtyKey: 'organized',
    specialty: 'organized',
    corruptibility: 45,
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

export function computeAppealOdds(input: {
  lawLevel: number;
  priorConvictions: number;
  wantedLevel: number;
  fbiHeat: number;
  donJudgeBonusPercent?: number;
  court?: CourtRuntimeConfig;
}): AppealOddsBreakdown {
  const court = input.court;
  const basePercent = court?.appealBasePercent ?? 35;
  const lawPerLevel = court?.appealLawBonusPerLevelPercent ?? 5;
  const lawCap = court?.appealLawBonusCapPercent ?? 25;
  const wantedThreshold = court?.appealWantedThreshold ?? 20;
  const wantedPenalty = court?.appealWantedPenaltyPercent ?? 10;
  const fbiThreshold = court?.appealFbiThreshold ?? 10;
  const fbiPenalty = court?.appealFbiPenaltyPercent ?? 15;
  const minPercent = court?.appealMinPercent ?? 10;
  const maxPercent = court?.appealMaxPercent ?? 85;
  const donBonusCap = court?.donJudgeAppealBonusPercent ?? 8;

  const lawLevel = Math.max(0, Math.min(5, Math.floor(input.lawLevel)));
  const lawBonusPercent = Math.min(lawLevel * lawPerLevel, lawCap);
  let successPercent = basePercent + lawBonusPercent;

  let priorConvictionModifierPercent = 0;
  if (input.priorConvictions === 0) {
    priorConvictionModifierPercent = 20;
  } else if (input.priorConvictions >= 5) {
    priorConvictionModifierPercent = -20;
  }
  successPercent += priorConvictionModifierPercent;
  successPercent += Math.max(
    0,
    Math.min(donBonusCap, Number(input.donJudgeBonusPercent ?? 0)),
  );

  const wantedPenaltyApplied = input.wantedLevel > wantedThreshold;
  const fbiPenaltyApplied = input.fbiHeat > fbiThreshold;
  if (wantedPenaltyApplied) {
    successPercent -= wantedPenalty;
  }
  if (fbiPenaltyApplied) {
    successPercent -= fbiPenalty;
  }

  successPercent = Math.max(minPercent, Math.min(maxPercent, successPercent));

  return {
    lawLevel,
    lawBonusPercent: Math.round(lawBonusPercent),
    priorConvictions: input.priorConvictions,
    priorConvictionModifierPercent: Math.round(priorConvictionModifierPercent),
    wantedLevel: input.wantedLevel,
    wantedPenaltyApplied,
    wantedPenaltyPercent: wantedPenaltyApplied ? wantedPenalty : 0,
    fbiHeat: input.fbiHeat,
    fbiPenaltyApplied,
    fbiPenaltyPercent: fbiPenaltyApplied ? fbiPenalty : 0,
    successChance: successPercent / 100,
    successPercent: Math.round(successPercent),
  };
}

function serializeAppealOdds(odds: AppealOddsBreakdown) {
  return {
    lawLevel: odds.lawLevel,
    lawBonusPercent: odds.lawBonusPercent,
    priorConvictions: odds.priorConvictions,
    priorConvictionModifierPercent: odds.priorConvictionModifierPercent,
    wantedLevel: odds.wantedLevel,
    wantedPenaltyApplied: odds.wantedPenaltyApplied,
    wantedPenaltyPercent: odds.wantedPenaltyPercent,
    fbiHeat: odds.fbiHeat,
    fbiPenaltyApplied: odds.fbiPenaltyApplied,
    fbiPenaltyPercent: odds.fbiPenaltyPercent,
    successPercent: odds.successPercent,
  };
}

function getCrimeName(crimeId: string): string {
  const known = crimeNameById.get(crimeId);
  if (known) return known;
  switch (crimeId) {
    case 'police_arrest':
      return 'Police arrest';
    case 'federal_arrest':
      return 'Federal arrest';
    case 'arrest_vehicle_theft':
      return 'Police arrest (vehicle theft)';
    case 'arrest_black_money':
      return 'Police arrest (dirty money)';
    case 'arrest_jailbreak':
      return 'Police arrest (jailbreak attempt)';
    case 'arrest_red_light':
      return 'Police arrest (red-light district)';
    case 'arrest_prostitution':
      return 'Police arrest (prostitution)';
    case 'travel_leg':
      return 'Travel arrest';
    default:
      break;
  }
  if (crimeId.startsWith('crew_mission:')) {
    const key = crimeId.slice('crew_mission:'.length).replace(/_/g, ' ');
    return key ? `Crew mission (${key})` : 'Crew mission';
  }
  return crimeId;
}

function parseArrestMeta(outcomeFail: string | null | undefined): {
  arrestReason: string | null;
  sourceCrimeId: string | null;
} {
  if (!outcomeFail) return { arrestReason: null, sourceCrimeId: null };
  try {
    const parsed = JSON.parse(outcomeFail) as Record<string, unknown>;
    return {
      arrestReason: typeof parsed.arrestReason === 'string' ? parsed.arrestReason : null,
      sourceCrimeId: typeof parsed.sourceCrimeId === 'string' ? parsed.sourceCrimeId : null,
    };
  } catch {
    return { arrestReason: null, sourceCrimeId: null };
  }
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

type RecordScope = 'local' | 'worldwide';

interface RecordQueryOptions {
  excludeAttemptId?: number;
  scope?: RecordScope;
  countryId?: string | null;
}

interface ExpungeMarker {
  createdAt: Date;
  source: string | null;
  countryId: string | null;
}

function normalizeCountryId(value: string | null | undefined): string | null {
  const trimmed = typeof value === 'string' ? value.trim() : '';
  return trimmed.length > 0 ? trimmed : null;
}

function parseExpungeMarker(params: string, createdAt: Date): ExpungeMarker | null {
  let parsed: unknown = {};
  try {
    parsed = JSON.parse(params);
  } catch {
    return null;
  }
  if (!parsed || typeof parsed !== 'object') return null;
  const payload = parsed as Record<string, unknown>;
  return {
    createdAt,
    source: typeof payload.source === 'string' ? payload.source : null,
    countryId: normalizeCountryId(
      typeof payload.countryId === 'string' ? payload.countryId : null,
    ),
  };
}

function isGlobalExpunge(marker: ExpungeMarker): boolean {
  if (marker.source === 'amnesty' || marker.source === 'crime') return true;
  return !marker.countryId;
}

function expungeHidesAttempt(
  marker: ExpungeMarker,
  attemptCreatedAt: Date,
  attemptCountryId: string | null,
): boolean {
  if (marker.createdAt.getTime() <= attemptCreatedAt.getTime()) return false;
  if (isGlobalExpunge(marker)) return true;
  if (!attemptCountryId) return true;
  return marker.countryId === attemptCountryId;
}

function expungeAppliesToLocalCountry(
  marker: ExpungeMarker,
  countryId: string | null,
): boolean {
  if (isGlobalExpunge(marker)) return true;
  if (!countryId) return true;
  return marker.countryId === countryId;
}

async function loadExpungeMarkers(playerId: number): Promise<ExpungeMarker[]> {
  const events = await prisma.worldEvent.findMany({
    where: {
      playerId,
      eventKey: 'trial.record_expunged',
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      params: true,
      createdAt: true,
    },
    take: 200,
  });
  return events
    .map((event) => parseExpungeMarker(event.params, event.createdAt))
    .filter((marker): marker is ExpungeMarker => marker != null);
}

async function getLatestLocalExpungementAt(
  playerId: number,
  countryId: string | null,
): Promise<Date | null> {
  const markers = await loadExpungeMarkers(playerId);
  const match = markers.find((marker) => expungeAppliesToLocalCountry(marker, countryId));
  return match?.createdAt ?? null;
}

async function getVisibleConvictionAttempts(
  playerId: number,
  options?: number | RecordQueryOptions,
) {
  const query: RecordQueryOptions =
    typeof options === 'number' ? { excludeAttemptId: options } : options ?? {};
  const scope: RecordScope = query.scope ?? 'worldwide';
  const countryId = normalizeCountryId(query.countryId);
  const excludeAttemptId = query.excludeAttemptId;
  const markers = await loadExpungeMarkers(playerId);

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
      outcomeFail: true,
      countryId: true,
    },
  });

  const trialEventsByAttempt = await getTrialEventsByAttempt(
    playerId,
    attempts.map((attempt) => attempt.id),
  );
  const clearedAttemptIds = getClearedAttemptIds(trialEventsByAttempt);
  const visibleAttempts = attempts.filter((attempt) => {
    if (clearedAttemptIds.has(attempt.id)) return false;
    const attemptCountryId = normalizeCountryId(attempt.countryId);
    if (scope === 'local') {
      if (countryId && attemptCountryId && attemptCountryId !== countryId) {
        return false;
      }
    }
    if (markers.some((marker) => expungeHidesAttempt(marker, attempt.createdAt, attemptCountryId))) {
      return false;
    }
    return true;
  });

  return {
    visibleAttempts,
    trialEventsByAttempt,
    expungedAt: markers[0]?.createdAt ?? null,
  };
}

function toRecordItem(
  attempt: {
    id: number;
    crimeId: string;
    jailTime: number;
    createdAt: Date;
    appealedAt: Date | null;
    jailed: boolean;
    outcomeFail: string | null;
    countryId: string | null;
  },
  events: TrialEventDetail[],
): CriminalRecordItem {
  const { history, originalJailTime } = buildHistory(
    attempt.createdAt,
    attempt.jailTime,
    events,
  );
  const meta = parseArrestMeta(attempt.outcomeFail);
  const sourceCrimeId = meta.sourceCrimeId;
  const sourceCrimeName = sourceCrimeId ? getCrimeName(sourceCrimeId) : null;

  return {
    crimeAttemptId: attempt.id,
    crimeId: attempt.crimeId,
    crimeName: getCrimeName(attempt.crimeId),
    sourceCrimeId,
    sourceCrimeName,
    arrestReason: meta.arrestReason,
    countryId: normalizeCountryId(attempt.countryId),
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
      outcomeFail: true,
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

  const [educationProfile, player, donJudgeBonusPercent, court] =
    await Promise.all([
      educationService.getPlayerEducationProfile(playerId),
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          wantedLevel: true,
          fbiHeat: true,
          currentCountry: true,
        },
      }),
      donService.getJudgeAppealBonusPercent(playerId),
      getCourtRuntimeConfig(),
    ]);
  const prior = await getVisibleConvictionAttempts(playerId, {
    excludeAttemptId: crimeAttempt.id,
    scope: 'local',
    countryId: player?.currentCountry,
  });

  const appealOdds = computeAppealOdds({
    lawLevel: educationProfile.tracks['law']?.level ?? 0,
    priorConvictions: prior.visibleAttempts.length,
    wantedLevel: Number(player?.wantedLevel ?? 0),
    fbiHeat: Number(player?.fbiHeat ?? 0),
    donJudgeBonusPercent,
    court,
  });

  const meta = parseArrestMeta(crimeAttempt.outcomeFail);
  const sourceCrimeId = meta.sourceCrimeId;
  const sourceCrimeName = sourceCrimeId ? getCrimeName(sourceCrimeId) : null;

  return {
    sentence: {
      crimeAttemptId: crimeAttempt.id,
      crimeId: crimeAttempt.crimeId,
      crime: getCrimeName(crimeAttempt.crimeId),
      sourceCrimeId,
      sourceCrimeName,
      arrestReason: meta.arrestReason,
      sentenceMinutes: crimeAttempt.jailTime,
      remainingMinutes: Math.max(1, Math.ceil(remainingSeconds / 60)),
      judge: getJudgeForAttempt(crimeAttempt.id),
      appealed: !!crimeAttempt.appealedAt,
      arrestedAt: crimeAttempt.createdAt.toISOString(),
      appealOdds: serializeAppealOdds(appealOdds),
    },
  };
}

export async function getCriminalRecord(playerId: number): Promise<{
  countryId: string | null;
  totalConvictions: number;
  recentCrimes: CriminalRecordItem[];
  fbiFile: {
    totalConvictions: number;
    recentCrimes: CriminalRecordItem[];
  };
}> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  const countryId = player?.currentCountry ?? null;
  const [local, worldwide] = await Promise.all([
    getVisibleConvictionAttempts(playerId, { scope: 'local', countryId }),
    getVisibleConvictionAttempts(playerId, { scope: 'worldwide' }),
  ]);

  return {
    countryId,
    totalConvictions: local.visibleAttempts.length,
    recentCrimes: local.visibleAttempts
      .slice(0, 20)
      .map((attempt) => toRecordItem(attempt, local.trialEventsByAttempt.get(attempt.id) ?? [])),
    fbiFile: {
      totalConvictions: worldwide.visibleAttempts.length,
      recentCrimes: worldwide.visibleAttempts
        .slice(0, 20)
        .map((attempt) =>
          toRecordItem(attempt, worldwide.trialEventsByAttempt.get(attempt.id) ?? []),
        ),
    },
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
        currentCountry: true,
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

  const court = await getCourtRuntimeConfig();
  const appealCost = Math.min(
    Math.max(attempt.jailTime * court.appealCostPerMinute, court.appealCostMin),
    court.appealCostMax,
  );
  if (player.money < appealCost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const { visibleAttempts: priorConvictionAttempts } = await getVisibleConvictionAttempts(
    playerId,
    {
      excludeAttemptId: crimeAttemptId,
      scope: 'local',
      countryId: player.currentCountry,
    },
  );
  const priorConvictions = priorConvictionAttempts.length;
  const donJudgeBonusPercent = await donService.getJudgeAppealBonusPercent(playerId);

  const appealOdds = computeAppealOdds({
    lawLevel: educationProfile.tracks['law']?.level ?? 0,
    priorConvictions,
    wantedLevel: Number(player.wantedLevel ?? 0),
    fbiHeat: Number(player.fbiHeat ?? 0),
    donJudgeBonusPercent,
    court,
  });
  const success = Math.random() < appealOdds.successChance;

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
    // Same physical release as bail/escape: clear every active jail row.
    // checkIfJailed reconstructs from leftover jailed=true attempts and would
    // immediately re-lock the player (crime outcomes also write a duplicate
    // police_arrest / federal_arrest row). Criminal-record wipe stays scoped
    // to this attempt via trial.bribe_success.
    await prisma.$transaction(async (tx) => {
      await tx.crimeAttempt.updateMany({
        where: {
          playerId,
          jailed: true,
        },
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
  const { visibleAttempts } = await getVisibleConvictionAttempts(playerId, { scope: 'worldwide' });
  return visibleAttempts.length;
}

async function getExpungePetitionDonFlags(playerId: number, currentCountry: string | null) {
  const empty = { hasJudge: false, hasCommissioner: false, hasAlderman: false };
  if (!currentCountry) return empty;
  const cfg = await getDonRuntimeConfig();
  if (!cfg.enabled) return empty;
  const [judge, commissioner, alderman] = await Promise.all([
    donService.getActiveOfficial(playerId, currentCountry, 'judge'),
    donService.getActiveOfficial(playerId, currentCountry, 'commissioner'),
    donService.getActiveOfficial(playerId, currentCountry, 'alderman'),
  ]);
  return {
    hasJudge: !!judge,
    hasCommissioner: !!commissioner,
    hasAlderman: !!alderman,
  };
}

function hoursSince(date: Date | null, now: Date): number | null {
  if (!date) return null;
  return Math.max(0, (now.getTime() - date.getTime()) / (1000 * 60 * 60));
}

export async function getExpungePetitionQuote(playerId: number): Promise<ExpungePetitionQuote> {
  const now = timeProvider.now();
  const [player, cooldownRemainingSeconds] = await Promise.all([
    prisma.player.findUnique({
      where: { id: playerId },
      select: {
        money: true,
        reputation: true,
        currentCountry: true,
      },
    }),
    cooldownService.checkCooldown(playerId, 'expunge_petition'),
  ]);

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const countryId = player.currentCountry ?? null;
  const { visibleAttempts } = await getVisibleConvictionAttempts(playerId, {
    scope: 'local',
    countryId,
  });
  const lastLocalWipeAt = await getLatestLocalExpungementAt(playerId, countryId);
  const mathCorrect = await policeService.countJailMathCorrectSince(
    playerId,
    lastLocalWipeAt ?? new Date(0),
  );

  const court = await getCourtRuntimeConfig();
  const mathConfig = getExpungePetitionMathConfigFromCourt(court);
  const convictionCount = visibleAttempts.length;
  const lastArrestAt = visibleAttempts[0]?.createdAt ?? null;
  const donFlags = await getExpungePetitionDonFlags(playerId, player.currentCountry);
  const odds = computeExpungePetitionOdds(
    {
      convictionCount,
      hoursSinceLastArrest: hoursSince(lastArrestAt, now),
      reputation: Number(player.reputation ?? 0),
      mathCorrect,
      ...donFlags,
    },
    mathConfig,
  );
  const cost = computeExpungePetitionCost(convictionCount, mathConfig);
  let blockReason: ExpungePetitionQuote['blockReason'] = null;
  if (convictionCount <= 0) {
    blockReason = 'NO_CRIMINAL_RECORD';
  } else if (cooldownRemainingSeconds > 0) {
    blockReason = 'COOLDOWN';
  } else if (player.money < cost) {
    blockReason = 'INSUFFICIENT_MONEY';
  }

  return {
    countryId,
    convictionCount,
    cost,
    lastArrestAt: lastArrestAt ? lastArrestAt.toISOString() : null,
    cooldownRemainingSeconds,
    canSubmit: blockReason == null,
    blockReason,
    odds,
  };
}

export async function submitExpungePetition(playerId: number): Promise<ExpungePetitionResult> {
  const quote = await getExpungePetitionQuote(playerId);
  if (quote.blockReason === 'NO_CRIMINAL_RECORD') {
    throw new Error('NO_CRIMINAL_RECORD');
  }
  if (quote.blockReason === 'COOLDOWN') {
    const error = new Error('COOLDOWN');
    (error as Error & { remainingSeconds?: number }).remainingSeconds = quote.cooldownRemainingSeconds;
    throw error;
  }
  if (quote.blockReason === 'INSUFFICIENT_MONEY') {
    throw new Error('INSUFFICIENT_MONEY');
  }

  let updatedPlayer: { money: number };
  try {
    updatedPlayer = await prisma.player.update({
      where: {
        id: playerId,
        money: {
          gte: quote.cost,
        },
      },
      data: {
        money: {
          decrement: quote.cost,
        },
      },
      select: {
        money: true,
      },
    });
  } catch {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const court = await getCourtRuntimeConfig();
  const cooldown = await cooldownService.setCooldown(
    playerId,
    'expunge_petition',
    court.expungeCooldownSeconds,
  );
  const success = Math.random() < quote.odds.successChance;
  let clearedCount = 0;

  if (success) {
    clearedCount = await expungeCriminalRecord(playerId, 'petition', quote.countryId);
  } else {
    await worldEventService.createEvent(
      'trial.expunge_petition_failed',
      {
        playerId,
        cost: quote.cost,
        convictionCount: quote.convictionCount,
        successPercent: quote.odds.successPercent,
      },
      playerId
    );
  }

  return {
    success,
    cost: quote.cost,
    convictionCount: quote.convictionCount,
    clearedCount,
    newBalance: updatedPlayer.money,
    successPercent: quote.odds.successPercent,
    cooldownSeconds: cooldown.remainingSeconds,
  };
}

export async function expungeCriminalRecord(
  playerId: number,
  source: 'crime' | 'petition' | 'amnesty' = 'crime',
  countryId?: string | null,
): Promise<number> {
  const scopedCountryId = source === 'petition' ? normalizeCountryId(countryId) : null;
  const { visibleAttempts } = await getVisibleConvictionAttempts(
    playerId,
    source === 'petition'
      ? { scope: 'local', countryId: scopedCountryId }
      : { scope: 'worldwide' },
  );
  const clearedCount = visibleAttempts.length;

  if (clearedCount <= 0) {
    return 0;
  }

  await worldEventService.createEvent(
    'trial.record_expunged',
    {
      playerId,
      clearedCount,
      source,
      ...(scopedCountryId ? { countryId: scopedCountryId } : {}),
    },
    playerId
  );

  return clearedCount;
}

export async function expungeAllCriminalRecordsAmnesty(): Promise<{
  playersCleared: number;
  recordsCleared: number;
}> {
  const rows = await prisma.$queryRaw<Array<{ playerId: number }>>`
    SELECT DISTINCT playerId
    FROM crime_attempts
    WHERE jailTime > 0
  `;

  const events: Array<{ eventKey: string; params: string; playerId: number }> = [];
  let recordsCleared = 0;

  for (const row of rows) {
    const playerId = Number(row.playerId);
    if (!Number.isFinite(playerId) || playerId <= 0) continue;
    const { visibleAttempts } = await getVisibleConvictionAttempts(playerId, {
      scope: 'worldwide',
    });
    if (visibleAttempts.length <= 0) continue;
    events.push({
      eventKey: 'trial.record_expunged',
      params: JSON.stringify({
        playerId,
        clearedCount: visibleAttempts.length,
        source: 'amnesty',
      }),
      playerId,
    });
    recordsCleared += visibleAttempts.length;
  }

  if (events.length > 0) {
    await prisma.worldEvent.createMany({ data: events });
  }

  return {
    playersCleared: events.length,
    recordsCleared,
  };
}
