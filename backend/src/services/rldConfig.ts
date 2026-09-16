/** Shared Red Light District balance: rooms, tiers, heat, steal, contest. */

export const RLD_START_ROOMS = 4;
export const RLD_EXPANSION_MAX = 8;
export const RLD_ROOMS_PER_EXPANSION = 2;
export const RLD_SECURITY_MAX = 5;
export const RLD_TIER_MAX = 5;
export const RLD_PENTHOUSE_TIER = 5;

export const RLD_EXPANSION_COSTS = [40000, 65000, 95000, 140000, 190000, 260000, 360000, 500000];

export const RLD_SECURITY_COSTS = [25000, 40000, 60000, 90000, 130000];

export const RLD_TIER_UPGRADE_COSTS: Record<number, number> = {
  2: 50000,
  3: 150000,
  4: 350000,
  5: 750000,
};

export const RLD_TIER_CONFIG: Record<
  number,
  { key: string; nameNl: string; nameEn: string; gross: number; rent: number }
> = {
  1: { key: 'basic', nameNl: 'Basic', nameEn: 'Basic', gross: 75, rent: 20 },
  2: { key: 'lounge', nameNl: 'Lounge', nameEn: 'Lounge', gross: 100, rent: 30 },
  3: { key: 'luxury', nameNl: 'Luxury', nameEn: 'Luxury', gross: 130, rent: 42 },
  4: { key: 'prestige', nameNl: 'Prestige', nameEn: 'Prestige', gross: 170, rent: 58 },
  5: { key: 'penthouse', nameNl: 'Penthouse', nameEn: 'Penthouse', gross: 220, rent: 80 },
};

export const RLD_COUNTRY_SLUGS = [
  'netherlands',
  'belgium',
  'germany',
  'france',
  'spain',
  'italy',
  'uk',
  'switzerland',
  'usa',
  'mexico',
  'colombia',
  'brazil',
  'argentina',
  'japan',
  'china',
  'russia',
  'turkey',
  'united_arab_emirates',
  'south_africa',
  'australia',
] as const;

export const RLD_OCCUPANCY_BUSY = 70;
export const RLD_OCCUPANCY_FULL = 100;
export const RLD_OCCUPANCY_BUSY_RENT_MULT = 1.15;
export const RLD_OCCUPANCY_FULL_HEAT = 3;
export const RLD_OCCUPANCY_BUSY_RAID_BONUS = 0.05;
export const RLD_OCCUPANCY_FULL_RAID_BONUS = 0.08;
export const RLD_EVENT_RAID_BONUS = 0.04;

export const RLD_GUARD_HOURS = 8;
export const RLD_GUARD_HOURS_VIP = 12;
export const RLD_GUARD_COOLDOWN_HOURS = 4;
export const RLD_GUARD_COST = 5000;
export const RLD_GUARD_EARNINGS_MULT = 0.5;

export const RLD_STEAL_COST = 15000;
export const RLD_STEAL_COOLDOWN_HOURS = 7;
export const RLD_STEAL_HEAT = 6;
export const RLD_STEAL_WANTED = 4;
export const RLD_RECLAIM_COST = 8000;
export const RLD_RECLAIM_HEAT = 3;
export const RLD_HOT_HOURS = 12;
export const RLD_FAIL_BUST_CHANCE = 0.28;
export const RLD_FAIL_WORKER_BUST_CHANCE = 0.12;
export const RLD_EVENT_FAIL_BUST_CHANCE = 0.45;
export const RLD_BUST_HOURS = 3;

export const RLD_CONTEST_MIN_RANK = 4;
export const RLD_CONTEST_STAKE = 100000;
export const RLD_CONTEST_PREP_MS = 15 * 60 * 1000;
export const RLD_CONTEST_ACTIVE_MS = 60 * 60 * 1000;
export const RLD_CONTEST_LOCKDOWN_MS = 10 * 60 * 1000;
export const RLD_CONTEST_COOLDOWN_MS = 48 * 60 * 60 * 1000;
export const RLD_CONTEST_HOLD_COST = 25000;
export const RLD_CONTEST_HOLD_HEAT = 8;
export const RLD_CONTEST_HOLD_MAX = 3;
export const RLD_CONTEST_HOLD_MAX_VIP = 4;
export const RLD_CONTEST_SABOTAGE_COST = 20000;
export const RLD_CONTEST_STEAL_POINTS = 15;
export const RLD_CONTEST_SABOTAGE_POINTS = 20;
export const RLD_CONTEST_HOLD_POINTS = 25;
export const RLD_CONTEST_SECURITY_POINTS = 5;
export const RLD_CONTEST_VIP_DEFENSE_POINTS = 10;

export const RLD_WORK_SHIFT_HOURS = 8;

export type RldEventCatalogEntry = {
  eventKey: string;
  eventType: string;
  vipOnly: boolean;
  durationHours: number;
  bonusMultiplier: number;
  minLevelRequired: number;
  maxParticipants: number;
  titleNl: string;
  titleEn: string;
  descriptionNl: string;
  descriptionEn: string;
};

export const RLD_EVENT_CATALOG: RldEventCatalogEntry[] = [
  {
    eventKey: 'tourist_night',
    eventType: 'tourist_night',
    vipOnly: false,
    durationHours: 2,
    bonusMultiplier: 1.4,
    minLevelRequired: 1,
    maxParticipants: 20,
    titleNl: 'Toeristennacht',
    titleEn: 'Tourist night',
    descriptionNl: 'Korte drukte in de straten. Extra geld, extra aandacht.',
    descriptionEn: 'A short crowded night. Extra cash, extra heat.',
  },
  {
    eventKey: 'harbor_shift',
    eventType: 'harbor_shift',
    vipOnly: false,
    durationHours: 4,
    bonusMultiplier: 1.6,
    minLevelRequired: 3,
    maxParticipants: 12,
    titleNl: 'Havenploeg',
    titleEn: 'Harbor shift',
    descriptionNl: 'Vier uur havenwerk. Alleen vanaf level 3.',
    descriptionEn: 'Four hours at the docks. Level 3 and up.',
  },
  {
    eventKey: 'city_festival',
    eventType: 'city_festival',
    vipOnly: false,
    durationHours: 6,
    bonusMultiplier: 1.5,
    minLevelRequired: 1,
    maxParticipants: 30,
    titleNl: 'Stadsfeest',
    titleEn: 'City festival',
    descriptionNl: 'Lange avond in de stad. Meer klanten, meer politie.',
    descriptionEn: 'A long city night. More clients, more police.',
  },
  {
    eventKey: 'private_salon',
    eventType: 'private_salon',
    vipOnly: true,
    durationHours: 3,
    bonusMultiplier: 2.2,
    minLevelRequired: 5,
    maxParticipants: 8,
    titleNl: 'Privésalon',
    titleEn: 'Private salon',
    descriptionNl: 'VIP-salon. Minder plekken, hoger tarief.',
    descriptionEn: 'VIP salon. Fewer seats, higher rate.',
  },
  {
    eventKey: 'yacht_party',
    eventType: 'yacht_party',
    vipOnly: true,
    durationHours: 4,
    bonusMultiplier: 2.5,
    minLevelRequired: 8,
    maxParticipants: 4,
    titleNl: 'Jachtfeest',
    titleEn: 'Yacht party',
    descriptionNl: 'Privéfeest op het water. Maximaal vier deelnemers.',
    descriptionEn: 'Private party on the water. Four seats only.',
  },
];

const ISO2_TO_SLUG: Record<string, string> = {
  NL: 'netherlands',
  BE: 'belgium',
  DE: 'germany',
  FR: 'france',
  ES: 'spain',
  IT: 'italy',
  GB: 'uk',
  UK: 'uk',
  CH: 'switzerland',
  US: 'usa',
  MX: 'mexico',
  CO: 'colombia',
  BR: 'brazil',
  AR: 'argentina',
  JP: 'japan',
  CN: 'china',
  RU: 'russia',
  TR: 'turkey',
  AE: 'united_arab_emirates',
  ZA: 'south_africa',
  AU: 'australia',
};

export function normalizeRldCountry(code: string | null | undefined): string {
  const raw = (code ?? '').trim();
  if (!raw) return '';
  if (raw.length === 2) {
    return ISO2_TO_SLUG[raw.toUpperCase()] ?? raw.toLowerCase();
  }
  return raw.toLowerCase();
}

export function expansionTargetRooms(expansionLevel: number): number {
  const level = Math.max(0, Math.min(RLD_EXPANSION_MAX, expansionLevel));
  return RLD_START_ROOMS + level * RLD_ROOMS_PER_EXPANSION;
}

export function impliedExpansionLevel(roomCount: number): number {
  if (roomCount <= RLD_START_ROOMS) return 0;
  return Math.min(
    RLD_EXPANSION_MAX,
    Math.ceil((roomCount - RLD_START_ROOMS) / RLD_ROOMS_PER_EXPANSION)
  );
}

export function occupancyRate(occupied: number, total: number): number {
  if (total <= 0) return 0;
  return (occupied / total) * 100;
}

export function occupancyRaidBonus(rate: number): number {
  if (rate >= RLD_OCCUPANCY_FULL) return RLD_OCCUPANCY_FULL_RAID_BONUS;
  if (rate >= RLD_OCCUPANCY_BUSY) return RLD_OCCUPANCY_BUSY_RAID_BONUS;
  return 0;
}

export function occupancyRentMultiplier(rate: number): number {
  if (rate >= RLD_OCCUPANCY_BUSY) return RLD_OCCUPANCY_BUSY_RENT_MULT;
  return 1;
}

export function getTierConfig(tier: number) {
  return RLD_TIER_CONFIG[tier] ?? RLD_TIER_CONFIG[1];
}

export function isWorkerOnShift(lastWorkedAt: Date | null | undefined, now = new Date()): boolean {
  if (!lastWorkedAt) return false;
  const elapsed = now.getTime() - lastWorkedAt.getTime();
  return elapsed >= 0 && elapsed < RLD_WORK_SHIFT_HOURS * 60 * 60 * 1000;
}

export function isWorkerResting(lastWorkedAt: Date | null | undefined, now = new Date()): boolean {
  if (!lastWorkedAt) return false;
  const elapsed = now.getTime() - lastWorkedAt.getTime();
  const workMs = RLD_WORK_SHIFT_HOURS * 60 * 60 * 1000;
  return elapsed >= workMs && elapsed < workMs * 2;
}
