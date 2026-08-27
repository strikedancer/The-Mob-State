import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { translationService } from './translationService';
import {
  formatJobIntelInboxMessage,
  type JobIntelPayload,
} from '../i18n/jobFlavorI18n';
import type { SupportedPlayerLanguage } from '../config/supportedLanguages';

const INTEL_JOB_IDS = new Set([
  'taxi_driver',
  'security_guard',
  'bartender',
  'pizza_delivery',
  'truck_driver',
]);

type FlavorDef = {
  key: string;
  weight: number;
  tipBonusPercent?: number;
  bonusXp?: number;
};

const SUCCESS_GENERIC: FlavorDef[] = [
  { key: 'jobFlavorRegularShift', weight: 4 },
  { key: 'jobFlavorOvertimeShift', weight: 3, tipBonusPercent: 12 },
  { key: 'jobFlavorCashTip', weight: 3, tipBonusPercent: 15 },
  { key: 'jobFlavorBigClient', weight: 2, tipBonusPercent: 10, bonusXp: 5 },
];

const SUCCESS_BY_JOB: Record<string, FlavorDef[]> = {
  pizza_delivery: [
    { key: 'jobFlavorUnderCounterTip', weight: 4, tipBonusPercent: 18 },
  ],
  bartender: [
    { key: 'jobFlavorUnderCounterTip', weight: 4, tipBonusPercent: 16 },
  ],
  taxi_driver: [
    { key: 'jobFlavorTaxiNightFare', weight: 4, tipBonusPercent: 14 },
  ],
  security_guard: [
    { key: 'jobFlavorSecuritySideGig', weight: 4, tipBonusPercent: 10 },
  ],
  warehouse_worker: [
    { key: 'jobFlavorWarehouseFind', weight: 3, tipBonusPercent: 8 },
  ],
};

const FAILURE_GENERIC: FlavorDef[] = [
  { key: 'jobFlavorClientStiffed', weight: 4 },
  { key: 'jobFlavorBossCaughtSlacking', weight: 3 },
  { key: 'jobFlavorRegisterShort', weight: 3 },
  { key: 'jobFlavorEquipmentFailure', weight: 2 },
  { key: 'jobFlavorShiftCutShort', weight: 3 },
];

export type JobFlavorOutcome = {
  flavorKey: string | null;
  tipBonusPercent: number;
  bonusXp: number;
  intel: JobIntelPayload | null;
};

function pickWeighted(pool: FlavorDef[]): FlavorDef | null {
  if (pool.length === 0) return null;
  const total = pool.reduce((sum, item) => sum + item.weight, 0);
  let roll = Math.random() * total;
  for (const item of pool) {
    roll -= item.weight;
    if (roll <= 0) return item;
  }
  return pool[pool.length - 1] ?? null;
}

function mergeFlavorPools(...pools: FlavorDef[][]): FlavorDef[] {
  const merged = new Map<string, FlavorDef>();
  for (const pool of pools) {
    for (const item of pool) {
      const existing = merged.get(item.key);
      if (!existing) {
        merged.set(item.key, { ...item });
        continue;
      }
      merged.set(item.key, {
        ...existing,
        weight: existing.weight + item.weight,
        tipBonusPercent: item.tipBonusPercent ?? existing.tipBonusPercent,
        bonusXp: item.bonusXp ?? existing.bonusXp,
      });
    }
  }
  return [...merged.values()];
}

async function getPlayerLanguage(playerId: number): Promise<SupportedPlayerLanguage> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return translationService.getPlayerLanguage(player ?? {});
}

async function fetchIntelDrop(
  playerId: number,
  language: SupportedPlayerLanguage,
  currentCountry: string | null,
): Promise<JobIntelPayload | null> {
  const roll = Math.random();
  const candidates: Array<() => Promise<JobIntelPayload | null>> = [
    async () => {
      const contests = await prisma.$queryRawUnsafe<
        Array<{ regionKey: string; nameNl: string; nameEn: string; status: string }>
      >(
        `SELECT tr.regionKey, tr.nameNl, tr.nameEn, c.status
         FROM territory_contests c
         JOIN territory_regions tr ON tr.regionKey = c.regionKey
         WHERE c.status NOT IN ('resolved', 'cancelled')
         ORDER BY c.startedAt DESC
         LIMIT 12`,
      );
      if (contests.length === 0) return null;
      const pick = contests[Math.floor(Math.random() * contests.length)]!;
      const regionName = language === 'nl' ? pick.nameNl : pick.nameEn;
      return {
        type: 'territory_contest',
        regionName,
        contestStatus: pick.status,
      };
    },
    async () => {
      const regions = await prisma.$queryRawUnsafe<
        Array<{ nameNl: string; nameEn: string; valueTier: number }>
      >(
        `SELECT tr.nameNl, tr.nameEn, tr.valueTier
         FROM territory_regions tr
         WHERE tr.enabled = 1 AND tr.valueTier >= 2
         ORDER BY RAND()
         LIMIT 8`,
      );
      if (regions.length === 0) return null;
      const pick = regions[Math.floor(Math.random() * regions.length)]!;
      return {
        type: 'territory_hotspot',
        regionName: language === 'nl' ? pick.nameNl : pick.nameEn,
        valueTier: Number(pick.valueTier),
      };
    },
    async () => {
      const event = await prisma.gameLiveEvent.findFirst({
        where: {
          status: 'active',
          endsAt: { gt: new Date() },
        },
        include: { template: true },
        orderBy: { endsAt: 'asc' },
      });
      if (!event?.template) return null;
      const title =
        language === 'nl'
          ? event.template.titleNl || event.template.titleEn
          : event.template.titleEn || event.template.titleNl;
      if (!title) return null;
      return { type: 'live_event', eventTitle: title };
    },
    async () => {
      const hit = await prisma.hitList.findFirst({
        where: { status: 'ACTIVE', bounty: { gte: 5000 } },
        include: { target: { select: { username: true } } },
        orderBy: { bounty: 'desc' },
      });
      if (!hit?.target?.username) return null;
      return {
        type: 'hitlist_chatter',
        targetName: hit.target.username,
        bounty: hit.bounty,
      };
    },
    async () => {
      const regions = await prisma.$queryRawUnsafe<
        Array<{ nameNl: string; nameEn: string }>
      >(
        `SELECT tr.nameNl, tr.nameEn
         FROM territory_regions tr
         WHERE tr.enabled = 1
         ORDER BY RAND()
         LIMIT 6`,
      );
      if (regions.length === 0) return null;
      const pick = regions[Math.floor(Math.random() * regions.length)]!;
      return {
        type: 'police_whisper',
        regionName: language === 'nl' ? pick.nameNl : pick.nameEn,
      };
    },
  ];

  // Shuffle attempt order so intel types stay varied.
  for (let i = candidates.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [candidates[i], candidates[j]] = [candidates[j]!, candidates[i]!];
  }

  const startIndex = Math.floor(roll * candidates.length);
  for (let offset = 0; offset < candidates.length; offset += 1) {
    const attempt = candidates[(startIndex + offset) % candidates.length];
    if (!attempt) continue;
    const intel = await attempt();
    if (intel) {
      void currentCountry;
      return intel;
    }
  }
  return null;
}

export const jobFlavorService = {
  async rollOutcome(input: {
    playerId: number;
    jobId: string;
    maxPay: number;
    success: boolean;
    currentCountry: string | null;
  }): Promise<JobFlavorOutcome> {
    const base: JobFlavorOutcome = {
      flavorKey: null,
      tipBonusPercent: 0,
      bonusXp: 0,
      intel: null,
    };

    if (input.success) {
      const flavorChance = 0.42;
      if (Math.random() >= flavorChance) {
        // Still allow intel-only rolls below.
      } else {
        const pool = mergeFlavorPools(
          SUCCESS_GENERIC,
          SUCCESS_BY_JOB[input.jobId] ?? [],
        );
        const picked = pickWeighted(pool);
        if (picked) {
          base.flavorKey = picked.key;
          base.tipBonusPercent = picked.tipBonusPercent ?? 0;
          base.bonusXp = picked.bonusXp ?? 0;
        }
      }

      if (INTEL_JOB_IDS.has(input.jobId) && Math.random() < 0.17) {
        const language = await getPlayerLanguage(input.playerId);
        base.intel = await fetchIntelDrop(
          input.playerId,
          language,
          input.currentCountry,
        );
        if (base.intel && !base.flavorKey) {
          base.flavorKey = 'jobFlavorIntelPickup';
        }
      }
      return base;
    }

    if (Math.random() < 0.55) {
      const picked = pickWeighted(FAILURE_GENERIC);
      if (picked) {
        base.flavorKey = picked.key;
      }
    }
    return base;
  },

  async deliverIntelInbox(playerId: number, intel: JobIntelPayload): Promise<void> {
    const language = await getPlayerLanguage(playerId);
    const message = formatJobIntelInboxMessage(language, intel);
    await directMessageService.sendSystemMessage(playerId, message, {
      sendPush: false,
      senderName: language === 'nl' ? 'Straatintel' : 'Street Intel',
    });
  },
};
