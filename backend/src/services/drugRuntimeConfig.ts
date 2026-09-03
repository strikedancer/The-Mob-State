import prisma from '../lib/prisma';

export type DrugRuntimeConfig = {
  cashCoolCostPerPoint: number;
  cashCoolPoints: number;
  lowProfileHours: number;
  lowProfileCooldownHours: number;
  raidDowntimeHours: number;
  raidCashFinePercent: number;
  darkwebFeePercent: number;
  darkwebHeat: number;
  darkwebSharePercent: number;
  nightclubOwnProdBonusPercent: number;
};

const DEFAULTS: Record<string, string> = {
  DRUG_HEAT_CASH_COOL_COST_PER_POINT: '5000',
  DRUG_HEAT_CASH_COOL_POINTS: '25',
  DRUG_HEAT_LOW_PROFILE_HOURS: '4',
  DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS: '8',
  DRUG_RAID_DOWNTIME_HOURS: '4',
  DRUG_RAID_CASH_FINE_PERCENT: '35',
  DRUG_DARKWEB_AUTOSALE_FEE_PERCENT: '12',
  DRUG_DARKWEB_AUTOSALE_HEAT: '4',
  DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT: '10',
  DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT: '8',
};

function parseIntSafe(value: string | undefined, fallback: number): number {
  const n = Number.parseInt(String(value ?? ''), 10);
  return Number.isFinite(n) ? n : fallback;
}

export async function getDrugRuntimeConfig(): Promise<DrugRuntimeConfig> {
  const keys = Object.keys(DEFAULTS);
  let rows: Array<{ configKey: string; configValue: string }> = [];
  try {
    rows = await prisma.$queryRawUnsafe(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${keys.map(() => '?').join(',')})`,
      ...keys
    );
  } catch {
    rows = [];
  }

  const map = new Map(rows.map((row) => [row.configKey, row.configValue]));
  const read = (key: keyof typeof DEFAULTS, fallback: number) =>
    parseIntSafe(map.get(key) ?? DEFAULTS[key], fallback);

  return {
    cashCoolCostPerPoint: read('DRUG_HEAT_CASH_COOL_COST_PER_POINT', 5000),
    cashCoolPoints: read('DRUG_HEAT_CASH_COOL_POINTS', 25),
    lowProfileHours: read('DRUG_HEAT_LOW_PROFILE_HOURS', 4),
    lowProfileCooldownHours: read('DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS', 8),
    raidDowntimeHours: read('DRUG_RAID_DOWNTIME_HOURS', 4),
    raidCashFinePercent: read('DRUG_RAID_CASH_FINE_PERCENT', 35),
    darkwebFeePercent: read('DRUG_DARKWEB_AUTOSALE_FEE_PERCENT', 12),
    darkwebHeat: read('DRUG_DARKWEB_AUTOSALE_HEAT', 4),
    darkwebSharePercent: read('DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT', 10),
    nightclubOwnProdBonusPercent: read('DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT', 8),
  };
}

export const DRUG_COUNTRY_LABELS: Record<string, { nl: string; en: string }> = {
  netherlands: { nl: 'Nederland', en: 'Netherlands' },
  belgium: { nl: 'België', en: 'Belgium' },
  germany: { nl: 'Duitsland', en: 'Germany' },
  france: { nl: 'Frankrijk', en: 'France' },
  uk: { nl: 'Verenigd Koninkrijk', en: 'United Kingdom' },
  italy: { nl: 'Italië', en: 'Italy' },
  spain: { nl: 'Spanje', en: 'Spain' },
  switzerland: { nl: 'Zwitserland', en: 'Switzerland' },
  usa: { nl: 'USA', en: 'USA' },
  mexico: { nl: 'Mexico', en: 'Mexico' },
  colombia: { nl: 'Colombia', en: 'Colombia' },
  brazil: { nl: 'Brazilië', en: 'Brazil' },
  argentina: { nl: 'Argentinië', en: 'Argentina' },
  japan: { nl: 'Japan', en: 'Japan' },
  china: { nl: 'China', en: 'China' },
  russia: { nl: 'Rusland', en: 'Russia' },
  turkey: { nl: 'Turkije', en: 'Turkey' },
  united_arab_emirates: { nl: 'VAE', en: 'UAE' },
  south_africa: { nl: 'Zuid-Afrika', en: 'South Africa' },
  australia: { nl: 'Australië', en: 'Australia' },
};

export function drugCountryLabel(country: string, language: 'nl' | 'en' = 'nl'): string {
  return DRUG_COUNTRY_LABELS[country]?.[language] ?? country;
}
