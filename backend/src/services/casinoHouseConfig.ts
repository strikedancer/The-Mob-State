import prisma from '../lib/prisma';

export const CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS = {
  CASINO_FLOOR_MAX_BET_1: '500',
  CASINO_FLOOR_MAX_BET_2: '2500',
  CASINO_FLOOR_MAX_BET_3: '10000',
  CASINO_RAKE_BPS_1: '200',
  CASINO_RAKE_BPS_2: '350',
  CASINO_RAKE_BPS_3: '500',
  CASINO_FLOOR_UPGRADE_2: '250000',
  CASINO_FLOOR_UPGRADE_3: '1000000',
  CASINO_RAID_DRAIN_PCT: '18',
  CASINO_SECURITY_DRAIN_REDUCTION_BPS: '10000',
} as const;

export const CASINO_HOUSE_RUNTIME_SETTING_KEYS = Object.keys(
  CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS,
);

export type CasinoStaffRole = 'dealer' | 'security' | 'promoter';

export type CasinoHouseRules = {
  floorLevel: number;
  maxBet: number;
  rakeBps: number;
  raidDrainPct: number;
  securityScaleBps: number;
  raidDefenseBps: number;
  payoutCutBps: number;
  fbiHeatOnBet: number;
  nextFloorCost: number | null;
  staff: Array<{
    role: CasinoStaffRole;
    catalogId: number;
    staffKey: string;
    nameNl: string;
    nameEn: string;
    salaryPerTick: number;
    rakeBonusBps: number;
    maxBetBonusPct: number;
    raidDefenseBps: number;
    payoutCutBps: number;
    fbiHeatOnBet: number;
  }>;
};

const STAFF_SEED: Array<{
  staffKey: string;
  role: CasinoStaffRole;
  nameNl: string;
  nameEn: string;
  skillLevel: number;
  salaryPerTick: number;
  rakeBonusBps: number;
  maxBetBonusPct: number;
  raidDefenseBps: number;
  payoutCutBps: number;
  fbiHeatOnBet: number;
}> = [
  {
    staffKey: 'dealer_lucia',
    role: 'dealer',
    nameNl: 'Lucia De Hand',
    nameEn: 'Lucia the Hand',
    skillLevel: 2,
    salaryPerTick: 4000,
    rakeBonusBps: 80,
    maxBetBonusPct: 0,
    raidDefenseBps: 0,
    payoutCutBps: 250,
    fbiHeatOnBet: 1,
  },
  {
    staffKey: 'dealer_viktor',
    role: 'dealer',
    nameNl: 'Viktor High-Limit',
    nameEn: 'Viktor High-Limit',
    skillLevel: 3,
    salaryPerTick: 7000,
    rakeBonusBps: 140,
    maxBetBonusPct: 0,
    raidDefenseBps: 0,
    payoutCutBps: 400,
    fbiHeatOnBet: 2,
  },
  {
    staffKey: 'security_marco',
    role: 'security',
    nameNl: 'Marco de Deur',
    nameEn: 'Marco the Door',
    skillLevel: 2,
    salaryPerTick: 3500,
    rakeBonusBps: 0,
    maxBetBonusPct: 0,
    raidDefenseBps: 1500,
    payoutCutBps: 0,
    fbiHeatOnBet: 0,
  },
  {
    staffKey: 'security_irina',
    role: 'security',
    nameNl: 'Irina Vault',
    nameEn: 'Irina Vault',
    skillLevel: 3,
    salaryPerTick: 6000,
    rakeBonusBps: 0,
    maxBetBonusPct: 0,
    raidDefenseBps: 2800,
    payoutCutBps: 0,
    fbiHeatOnBet: 0,
  },
  {
    staffKey: 'promoter_nico',
    role: 'promoter',
    nameNl: 'Nico Neon',
    nameEn: 'Nico Neon',
    skillLevel: 2,
    salaryPerTick: 3000,
    rakeBonusBps: 0,
    maxBetBonusPct: 25,
    raidDefenseBps: 0,
    payoutCutBps: 0,
    fbiHeatOnBet: 1,
  },
  {
    staffKey: 'promoter_sofia',
    role: 'promoter',
    nameNl: 'Sofia Velvet',
    nameEn: 'Sofia Velvet',
    skillLevel: 3,
    salaryPerTick: 5500,
    rakeBonusBps: 20,
    maxBetBonusPct: 40,
    raidDefenseBps: 0,
    payoutCutBps: 0,
    fbiHeatOnBet: 2,
  },
];

let cfgCache: { value: Record<string, number>; expiresAt: number } | null = null;
const CFG_TTL_MS = 30_000;

function toInt(raw: string | undefined, fallback: number): number {
  const n = Number(raw);
  return Number.isFinite(n) ? Math.trunc(n) : fallback;
}

export function invalidateCasinoHouseConfigCache(): void {
  cfgCache = null;
}

export async function loadCasinoHouseRuntime(): Promise<Record<string, number>> {
  const now = Date.now();
  if (cfgCache && cfgCache.expiresAt > now) {
    return cfgCache.value;
  }

  const keys = CASINO_HOUSE_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma
    .$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    )
    .catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const value: Record<string, number> = {};
  for (const key of keys) {
    const def = CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS[
      key as keyof typeof CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS
    ];
    const row = rows.find((item) => item.configKey === key);
    value[key] = toInt(row?.configValue ?? def, Number(def));
  }
  cfgCache = { value, expiresAt: now + CFG_TTL_MS };
  return value;
}

export async function ensureCasinoStaffCatalog(): Promise<void> {
  for (const seed of STAFF_SEED) {
    await prisma.casinoStaffCatalog.upsert({
      where: { staffKey: seed.staffKey },
      create: seed,
      update: {
        nameNl: seed.nameNl,
        nameEn: seed.nameEn,
        skillLevel: seed.skillLevel,
        salaryPerTick: seed.salaryPerTick,
        rakeBonusBps: seed.rakeBonusBps,
        maxBetBonusPct: seed.maxBetBonusPct,
        raidDefenseBps: seed.raidDefenseBps,
        payoutCutBps: seed.payoutCutBps,
        fbiHeatOnBet: seed.fbiHeatOnBet,
        isActive: true,
      },
    });
  }
}

export async function getCasinoHouseRules(casinoId: string): Promise<CasinoHouseRules | null> {
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    include: {
      staffHires: {
        include: { catalog: true },
      },
    },
  });
  if (!ownership) return null;

  const cfg = await loadCasinoHouseRuntime();
  const floorLevel = Math.min(3, Math.max(1, ownership.floorLevel || 1));
  const baseMaxBet = cfg[`CASINO_FLOOR_MAX_BET_${floorLevel}`] ?? 500;
  const baseRake = cfg[`CASINO_RAKE_BPS_${floorLevel}`] ?? 200;

  const staff = ownership.staffHires.map((hire) => ({
    role: hire.role as CasinoStaffRole,
    catalogId: hire.catalogId,
    staffKey: hire.catalog.staffKey,
    nameNl: hire.catalog.nameNl,
    nameEn: hire.catalog.nameEn,
    salaryPerTick: hire.catalog.salaryPerTick,
    rakeBonusBps: hire.catalog.rakeBonusBps,
    maxBetBonusPct: hire.catalog.maxBetBonusPct,
    raidDefenseBps: hire.catalog.raidDefenseBps,
    payoutCutBps: hire.catalog.payoutCutBps,
    fbiHeatOnBet: hire.catalog.fbiHeatOnBet,
  }));

  const rakeBonus = staff.reduce((sum, item) => sum + item.rakeBonusBps, 0);
  const maxBetBonusPct = staff.reduce((sum, item) => sum + item.maxBetBonusPct, 0);
  const raidDefenseBps = staff.reduce((sum, item) => sum + item.raidDefenseBps, 0);
  const payoutCutBps = staff.reduce((sum, item) => sum + item.payoutCutBps, 0);
  const fbiHeatOnBet = staff.reduce((sum, item) => sum + item.fbiHeatOnBet, 0);

  const nextFloorCost =
    floorLevel === 1
      ? cfg.CASINO_FLOOR_UPGRADE_2
      : floorLevel === 2
        ? cfg.CASINO_FLOOR_UPGRADE_3
        : null;

  return {
    floorLevel,
    maxBet: Math.max(10, Math.floor(baseMaxBet * (1 + maxBetBonusPct / 100))),
    rakeBps: Math.min(1200, Math.max(0, baseRake + rakeBonus)),
    raidDrainPct: cfg.CASINO_RAID_DRAIN_PCT,
    securityScaleBps: Math.max(1, cfg.CASINO_SECURITY_DRAIN_REDUCTION_BPS || 10000),
    raidDefenseBps,
    payoutCutBps: Math.min(1500, Math.max(0, payoutCutBps)),
    fbiHeatOnBet,
    nextFloorCost,
    staff,
  };
}

export function effectiveRaidDrainPct(rules: CasinoHouseRules): number {
  const scale = Math.max(1, rules.securityScaleBps || 10000);
  const reduction = rules.raidDefenseBps / scale;
  return Math.max(4, rules.raidDrainPct * (1 - reduction));
}
