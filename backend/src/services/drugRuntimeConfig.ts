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
  wholesaleMinGrams: number;
  wholesaleSpreadBps: number;
  wholesaleVolumeBonusBpsPerKg: number;
  wholesaleVolumeBonusCapBps: number;
  wholesaleScarcityWindowH: number;
  wholesaleScarcityCapBps: number;
  wholesaleFbiHeatPerKg: number;
  wholesaleDrugHeat: number;
};

export const DRUG_RUNTIME_SETTING_DEFAULTS: Record<string, string> = {
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
  DRUG_WHOLESALE_MIN_GRAMS: '250',
  DRUG_WHOLESALE_SPREAD_BPS: '1500',
  DRUG_WHOLESALE_VOLUME_BONUS_BPS_PER_KG: '200',
  DRUG_WHOLESALE_VOLUME_BONUS_CAP_BPS: '600',
  DRUG_WHOLESALE_SCARCITY_WINDOW_H: '24',
  DRUG_WHOLESALE_SCARCITY_CAP_BPS: '1000',
  DRUG_WHOLESALE_FBI_HEAT_PER_KG: '2',
  DRUG_WHOLESALE_DRUG_HEAT: '4',
};

export const DRUG_RUNTIME_SETTING_KEYS = Object.keys(DRUG_RUNTIME_SETTING_DEFAULTS);

const DEFAULTS = DRUG_RUNTIME_SETTING_DEFAULTS;

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
    wholesaleMinGrams: read('DRUG_WHOLESALE_MIN_GRAMS', 250),
    wholesaleSpreadBps: read('DRUG_WHOLESALE_SPREAD_BPS', 1500),
    wholesaleVolumeBonusBpsPerKg: read('DRUG_WHOLESALE_VOLUME_BONUS_BPS_PER_KG', 200),
    wholesaleVolumeBonusCapBps: read('DRUG_WHOLESALE_VOLUME_BONUS_CAP_BPS', 600),
    wholesaleScarcityWindowH: read('DRUG_WHOLESALE_SCARCITY_WINDOW_H', 24),
    wholesaleScarcityCapBps: read('DRUG_WHOLESALE_SCARCITY_CAP_BPS', 1000),
    wholesaleFbiHeatPerKg: read('DRUG_WHOLESALE_FBI_HEAT_PER_KG', 2),
    wholesaleDrugHeat: read('DRUG_WHOLESALE_DRUG_HEAT', 4),
  };
}

export async function getDrugRuntimeConfigView() {
  const keys = DRUG_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma
    .$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    )
    .catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const values: Record<string, string> = { ...DRUG_RUNTIME_SETTING_DEFAULTS };
  for (const row of rows) {
    values[row.configKey] = String(row.configValue ?? values[row.configKey] ?? '');
  }
  return {
    defaults: DRUG_RUNTIME_SETTING_DEFAULTS,
    values,
    keys,
  };
}

export async function updateDrugRuntimeConfig(updates: Record<string, string | number>) {
  const normalized: Record<string, string> = {};
  for (const [key, value] of Object.entries(updates)) {
    if (!DRUG_RUNTIME_SETTING_KEYS.includes(key)) {
      throw new Error(`INVALID_RUNTIME_KEY:${key}`);
    }
    const asString = String(value ?? '').trim();
    const asNumber = Number(asString);
    if (!Number.isFinite(asNumber)) {
      throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
    }
    normalized[key] = asString;
  }

  for (const [key, value] of Object.entries(normalized)) {
    await prisma.$executeRawUnsafe(
      `
        INSERT INTO runtime_config (configKey, configValue)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)
      `,
      key,
      value,
    );
  }
  return getDrugRuntimeConfigView();
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
