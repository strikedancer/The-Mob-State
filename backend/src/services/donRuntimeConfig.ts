import prisma from '../lib/prisma';

export const DON_RUNTIME_SETTING_DEFAULTS: Record<string, string> = {
  DON_ENABLED: '1',
  DON_MIN_RANK: '7',
  DON_COLLECT_COOLDOWN_SECONDS: '14400',
  DON_ABANDON_SECONDS: '259200',
  DON_SQUEEZE_DURATION_SECONDS: '14400',
  DON_SQUEEZE_TRIBUTE_PERCENT: '150',
  DON_SQUEEZE_WANTED: '4',
  DON_SQUEEZE_FLEE_PERCENT: '18',
  DON_CONTEST_SECONDS: '3600',
  DON_MAX_RACKETS_PER_PLAYER: '8',
  DON_LOAN_MAX_ACTIVE: '3',
  DON_LOAN_MIN_PRINCIPAL: '2000',
  DON_LOAN_MAX_PRINCIPAL: '50000',
  DON_LOAN_DURATION_SECONDS: '259200',
  DON_LOAN_NPC_DEFAULT_PERCENT: '15',
  DON_LOAN_COLLECT_PERCENT: '70',
  DON_OFFICIAL_HOURS: '24',
  DON_JUDGE_APPEAL_BONUS_PERCENT: '8',
  DON_COMMISSIONER_WANTED_MULT: '80',
  DON_ALDERMAN_PAYOUT_BONUS_PERCENT: '15',
  DON_CONTRACT_OFFBOOKS_PERCENT: '12',
};

export const DON_RUNTIME_SETTING_KEYS = Object.keys(DON_RUNTIME_SETTING_DEFAULTS);

type DonRuntimeConfig = {
  enabled: boolean;
  minRank: number;
  collectCooldownSeconds: number;
  abandonSeconds: number;
  squeezeDurationSeconds: number;
  squeezeTributePercent: number;
  squeezeWanted: number;
  squeezeFleePercent: number;
  contestSeconds: number;
  maxRacketsPerPlayer: number;
  loanMaxActive: number;
  loanMinPrincipal: number;
  loanMaxPrincipal: number;
  loanDurationSeconds: number;
  loanNpcDefaultPercent: number;
  loanCollectPercent: number;
  officialHours: number;
  judgeAppealBonusPercent: number;
  commissionerWantedMult: number;
  aldermanPayoutBonusPercent: number;
  contractOffbooksPercent: number;
};

let cache: { value: DonRuntimeConfig; expiresAt: number } | null = null;
const TTL_MS = 60_000;

function num(map: Record<string, string>, key: string, fallback: number): number {
  const parsed = Number.parseInt(map[key] ?? '', 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function build(map: Record<string, string>): DonRuntimeConfig {
  return {
    enabled: (map.DON_ENABLED ?? '1') !== '0',
    minRank: num(map, 'DON_MIN_RANK', 7),
    collectCooldownSeconds: num(map, 'DON_COLLECT_COOLDOWN_SECONDS', 14400),
    abandonSeconds: num(map, 'DON_ABANDON_SECONDS', 259200),
    squeezeDurationSeconds: num(map, 'DON_SQUEEZE_DURATION_SECONDS', 14400),
    squeezeTributePercent: num(map, 'DON_SQUEEZE_TRIBUTE_PERCENT', 150),
    squeezeWanted: num(map, 'DON_SQUEEZE_WANTED', 4),
    squeezeFleePercent: num(map, 'DON_SQUEEZE_FLEE_PERCENT', 18),
    contestSeconds: num(map, 'DON_CONTEST_SECONDS', 3600),
    maxRacketsPerPlayer: num(map, 'DON_MAX_RACKETS_PER_PLAYER', 8),
    loanMaxActive: num(map, 'DON_LOAN_MAX_ACTIVE', 3),
    loanMinPrincipal: num(map, 'DON_LOAN_MIN_PRINCIPAL', 2000),
    loanMaxPrincipal: num(map, 'DON_LOAN_MAX_PRINCIPAL', 50000),
    loanDurationSeconds: num(map, 'DON_LOAN_DURATION_SECONDS', 259200),
    loanNpcDefaultPercent: num(map, 'DON_LOAN_NPC_DEFAULT_PERCENT', 15),
    loanCollectPercent: num(map, 'DON_LOAN_COLLECT_PERCENT', 70),
    officialHours: num(map, 'DON_OFFICIAL_HOURS', 24),
    judgeAppealBonusPercent: num(map, 'DON_JUDGE_APPEAL_BONUS_PERCENT', 8),
    commissionerWantedMult: num(map, 'DON_COMMISSIONER_WANTED_MULT', 80),
    aldermanPayoutBonusPercent: num(map, 'DON_ALDERMAN_PAYOUT_BONUS_PERCENT', 15),
    contractOffbooksPercent: num(map, 'DON_CONTRACT_OFFBOOKS_PERCENT', 12),
  };
}

export async function getDonRuntimeConfig(): Promise<DonRuntimeConfig> {
  const now = Date.now();
  if (cache && cache.expiresAt > now) {
    return cache.value;
  }

  const map: Record<string, string> = { ...DON_RUNTIME_SETTING_DEFAULTS };
  try {
    const placeholders = DON_RUNTIME_SETTING_KEYS.map(() => '?').join(', ');
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...DON_RUNTIME_SETTING_KEYS
    );
    for (const row of rows) {
      map[row.configKey] = row.configValue;
    }
  } catch {
    // runtime_config may be missing in fresh local DBs
  }

  const value = build(map);
  cache = { value, expiresAt: now + TTL_MS };
  return value;
}

export function invalidateDonRuntimeConfigCache(): void {
  cache = null;
}
