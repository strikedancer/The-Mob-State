import dotenv from 'dotenv';

dotenv.config();

interface Config {
  nodeEnv: string;
  port: number;
  databaseUrl: string;
  jwtSecret: string;
  jwtExpiresIn: string;
  appBaseUrl: string;
  apiBaseUrl: string;
  allowedOrigins: string[];
  tickIntervalMinutes: number;
  hospitalHealCost: number;
  hospitalHealAmount: number;
  hospitalCooldownMinutes: number;
  passiveHealingPerTick: number;
  vehicleSellPriceMultiplier: number;
  policeRatio: number;
  wantedLevelDecayPerTick: number;
  wantedLevelIncreaseOnCrimeFail: number;
  fbiRatio: number;
  fbiHeatDecayPerTick: number;
  fbiHeatIncreaseOnFederalCrimeFail: number;
  maxFlightsPerDay: number;
  // Crime & Job settings
  crimeFuelCost: number;
  crimeJailChance: number;
  xpPerRank: number;
  // XP Loss settings
  xpLoss: {
    crimeFailed: { min: number; max: number };
    crimeJailed: number;
    judgeConvicted: { min: number; max: number };
    judgeHarshSentence: { min: number; max: number };
    judgeRepeatOffender: number;
    jobFailed: { min: number; max: number };
    heistFailed: { min: number; max: number };
    heistSabotage: number;
  };
}

const config: Config = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  databaseUrl: process.env.DATABASE_URL || '',
  jwtSecret: process.env.JWT_SECRET || '',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '7d',
  appBaseUrl: process.env.APP_BASE_URL || 'http://localhost:5173',
  apiBaseUrl: process.env.API_BASE_URL || 'http://localhost:3000',
  allowedOrigins: process.env.ALLOWED_ORIGINS?.split(',') || [],
  tickIntervalMinutes: parseFloat(process.env.TICK_INTERVAL_MINUTES || '5'),
  hospitalHealCost: parseInt(process.env.HOSPITAL_HEAL_COST || '10000', 10),
  hospitalHealAmount: parseInt(process.env.HOSPITAL_HEAL_AMOUNT || '30', 10),
  hospitalCooldownMinutes: parseInt(process.env.HOSPITAL_COOLDOWN_MINUTES || '60', 10),
  passiveHealingPerTick: parseInt(process.env.PASSIVE_HEALING_PER_TICK || '5', 10),
  vehicleSellPriceMultiplier: parseFloat(process.env.VEHICLE_SELL_PRICE_MULTIPLIER || '0.5'),
  policeRatio: parseInt(process.env.POLICE_RATIO || '10', 10),
  wantedLevelDecayPerTick: parseInt(process.env.WANTED_LEVEL_DECAY_PER_TICK || '1', 10),
  wantedLevelIncreaseOnCrimeFail: parseInt(
    process.env.WANTED_LEVEL_INCREASE_ON_CRIME_FAIL || '5',
    10
  ),
  fbiRatio: parseInt(process.env.FBI_RATIO || '5', 10),
  fbiHeatDecayPerTick: parseFloat(process.env.FBI_HEAT_DECAY_PER_TICK || '0.5'),
  fbiHeatIncreaseOnFederalCrimeFail: parseInt(
    process.env.FBI_HEAT_INCREASE_ON_FEDERAL_CRIME_FAIL || '10',
    10
  ),
  maxFlightsPerDay: parseInt(process.env.MAX_FLIGHTS_PER_DAY || '100', 10),
  // Crime & Job settings
  crimeFuelCost: parseInt(process.env.CRIME_FUEL_COST || '1', 10),
  crimeJailChance: parseFloat(process.env.CRIME_JAIL_CHANCE || '0.5'),
  xpPerRank: parseInt(process.env.XP_PER_RANK || '1000', 10), // Deprecated: use getXPForRank() instead
  // XP Loss settings
  xpLoss: {
    crimeFailed: { min: 0.10, max: 0.25 },      // 10-25% of potential XP gain
    crimeJailed: 0.05,                           // 5% of level XP
    judgeConvicted: { min: 0.01, max: 0.03 },   // 1-3% of total XP
    judgeHarshSentence: { min: 50, max: 100 },  // Flat XP loss
    judgeRepeatOffender: 0.05,                   // 5% of total XP
    jobFailed: { min: 0.05, max: 0.10 },        // 5-10% of potential earnings
    heistFailed: { min: 50, max: 200 },         // Flat XP loss per crew member
    heistSabotage: 500,                          // Flat XP loss for saboteur
  },
};

// Validate critical config
if (!config.jwtSecret && config.nodeEnv === 'production') {
  throw new Error('JWT_SECRET is required in production');
}

const XP_BASE_PER_RANK = 1000;
const XP_GROWTH_EARLY = 0.07;
const XP_GROWTH_MID = 0.05;
const XP_GROWTH_LATE = 0.035;

function getXpGrowthRateForRank(rank: number): number {
  if (rank <= 60) {
    return XP_GROWTH_EARLY;
  }

  if (rank <= 150) {
    return XP_GROWTH_MID;
  }

  return XP_GROWTH_LATE;
}

/**
 * Shared XP progression curve for all players.
 * Returns total XP required to reach a target rank.
 */
export function getXPForRank(targetRank: number): number {
  if (!Number.isFinite(targetRank) || targetRank <= 1) {
    return 0;
  }

  let totalXP = 0;
  let xpForNextRank = XP_BASE_PER_RANK;

  for (let rank = 1; rank < targetRank; rank++) {
    totalXP += xpForNextRank;
    const growthRate = getXpGrowthRateForRank(rank);
    xpForNextRank = Math.ceil(xpForNextRank * (1 + growthRate));
  }

  return totalXP;
}

/**
 * Get player rank from total XP (reverse calculation)
 */
export function getRankFromXP(totalXP: number): number {
  if (!Number.isFinite(totalXP) || totalXP <= 0) {
    return 1;
  }

  let rank = 1;
  let xpRemaining = totalXP;
  let xpForNextRank = XP_BASE_PER_RANK;

  while (xpRemaining >= xpForNextRank) {
    xpRemaining -= xpForNextRank;
    const growthRate = getXpGrowthRateForRank(rank);
    xpForNextRank = Math.ceil(xpForNextRank * (1 + growthRate));
    rank++;
  }

  return rank;
}

export default config;
