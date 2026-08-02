import prisma from '../lib/prisma';

const WEEK_MINUTES = 7 * 24 * 60;

/** Eén key per `category` zodat dezelfde actie niet dubbel telt (recordContribution = alle actieve met zelfde category). */
export const PRESET_GAME_EVENT_KEYS = [
  'weekly_vehicle_theft_hunt',
  'smuggling_surge',
  'lab_output_challenge',
  'street_crime_spree',
] as const;

type PresetRow = {
  key: (typeof PRESET_GAME_EVENT_KEYS)[number];
  category: 'vehicles' | 'smuggling' | 'drugs' | 'crime';
  eventType: string;
  titleNl: string;
  titleEn: string;
  shortDescriptionNl: string;
  shortDescriptionEn: string;
  intervalMinutes: number;
  durationMinutes: number;
  cooldownMinutes: number;
  /** 0 = first eligible cron run may start immediately; 1 = ~1 day later, etc. */
  staggerDayOffset: number;
};

const PRESET_ROWS: PresetRow[] = [
  {
    key: 'weekly_vehicle_theft_hunt',
    category: 'vehicles',
    eventType: 'contribution',
    titleNl: 'Wekelijkse Diefstaljacht',
    titleEn: 'Weekly Theft Hunt',
    shortDescriptionNl: 'Steel zoveel mogelijk voertuigen tijdens het event.',
    shortDescriptionEn: 'Steal as many vehicles as you can during the event window.',
    intervalMinutes: WEEK_MINUTES,
    durationMinutes: 2880,
    cooldownMinutes: 0,
    staggerDayOffset: 0,
  },
  {
    key: 'smuggling_surge',
    category: 'smuggling',
    eventType: 'contribution',
    titleNl: 'Smokkelgolf',
    titleEn: 'Smuggling Surge',
    shortDescriptionNl: 'Beweeg zoveel mogelijk smokkel in deze ronde.',
    shortDescriptionEn: 'Move the most smuggled contraband this round.',
    intervalMinutes: WEEK_MINUTES,
    durationMinutes: 2880,
    cooldownMinutes: 0,
    staggerDayOffset: 1,
  },
  {
    key: 'lab_output_challenge',
    category: 'drugs',
    eventType: 'contribution',
    titleNl: 'Lab-output Uitdaging',
    titleEn: 'Lab Output Challenge',
    shortDescriptionNl: 'Produceer de meeste productie tijdens het event.',
    shortDescriptionEn: 'Produce the most output while the event is live.',
    intervalMinutes: WEEK_MINUTES,
    durationMinutes: 2880,
    cooldownMinutes: 0,
    staggerDayOffset: 2,
  },
  {
    key: 'street_crime_spree',
    category: 'crime',
    eventType: 'contribution',
    titleNl: 'Straat Crime Spree',
    titleEn: 'Street Crime Spree',
    shortDescriptionNl: 'Pleg zoveel mogelijk misdaden in het actieve venster.',
    shortDescriptionEn: 'Complete as many crimes as possible in the live window.',
    intervalMinutes: WEEK_MINUTES,
    durationMinutes: 2880,
    cooldownMinutes: 0,
    staggerDayOffset: 3,
  },
];

function lastTriggeredForStagger(
  now: Date,
  intervalMinutes: number,
  staggerDayOffset: number
): Date {
  const intervalMs = intervalMinutes * 60 * 1000;
  const dayMs = 24 * 60 * 60 * 1000;
  return new Date(now.getTime() - intervalMs + staggerDayOffset * dayMs);
}

export function getDefaultRewardRulesForTemplateKey(
  _templateKey: string
): Array<{
  triggerType: string;
  triggerConfigJson: Record<string, unknown>;
  rewardsJson: Record<string, unknown>;
  sortOrder: number;
  isActive: boolean;
}> {
  return [
    {
      triggerType: 'rank_range',
      triggerConfigJson: { minRank: 1, maxRank: 1 },
      rewardsJson: {
        cash: 50_000,
        premiumCredits: 8,
        xp: 800,
        items: [{ itemKey: 'event_chip_gold', quantity: 1 }],
      },
      sortOrder: 0,
      isActive: true,
    },
    {
      triggerType: 'rank_range',
      triggerConfigJson: { minRank: 2, maxRank: 3 },
      rewardsJson: {
        cash: 25_000,
        premiumCredits: 4,
        xp: 500,
        items: [{ itemKey: 'event_chip_silver', quantity: 1 }],
      },
      sortOrder: 1,
      isActive: true,
    },
    {
      triggerType: 'rank_range',
      triggerConfigJson: { minRank: 4, maxRank: 10 },
      rewardsJson: {
        cash: 10_000,
        premiumCredits: 2,
        xp: 200,
        items: [{ itemKey: 'event_chip_bronze', quantity: 1 }],
      },
      sortOrder: 2,
      isActive: true,
    },
  ];
}

/**
 * Idempotent: upserts vaste templates + één interval-schema per template.
 * Bestaande schedules blijven qua lastTriggered staan (operator kan handmatig resetten in DB indien nodig).
 */
export async function ensureGameEventPresets(): Promise<void> {
  const now = new Date();

  for (const def of PRESET_ROWS) {
    const template = await prisma.gameEventTemplate.upsert({
      where: { key: def.key },
      create: {
        key: def.key,
        category: def.category,
        eventType: def.eventType,
        titleNl: def.titleNl,
        titleEn: def.titleEn,
        shortDescriptionNl: def.shortDescriptionNl,
        shortDescriptionEn: def.shortDescriptionEn,
        isActive: true,
      },
      update: {
        category: def.category,
        eventType: def.eventType,
        titleNl: def.titleNl,
        titleEn: def.titleEn,
        shortDescriptionNl: def.shortDescriptionNl,
        shortDescriptionEn: def.shortDescriptionEn,
      },
    });

    const existing = await prisma.gameEventSchedule.findFirst({
      where: { templateId: template.id },
    });

    if (!existing) {
      await prisma.gameEventSchedule.create({
        data: {
          templateId: template.id,
          scheduleType: 'interval',
          intervalMinutes: def.intervalMinutes,
          durationMinutes: def.durationMinutes,
          cooldownMinutes: def.cooldownMinutes,
          enabled: true,
          weight: 1,
          lastTriggeredAt: lastTriggeredForStagger(
            now,
            def.intervalMinutes,
            def.staggerDayOffset
          ),
        },
      });
    }
  }
}
