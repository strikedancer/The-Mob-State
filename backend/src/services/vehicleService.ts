/**
 * Phase 12: Vehicle Trading & Garage System
 * Handles vehicle stealing, inventory management, and black market trading
 */

import prisma from '../lib/prisma';
import { Prisma } from '@prisma/client';
import { getRankFromXP } from '../config';
import vehiclesData from '../../content/vehicles.json';
import { checkCooldown, setCooldown } from './cooldownService';
import { checkArrest, checkIfJailed } from './policeService';
import { activityService } from './activityService';
import { notificationService } from './notificationService';
import { applyReputationAction } from './reputationService';
import { economyBalanceService } from './economyBalanceService';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';
import { getGarageCapacities } from './garageService';

const COUNTRY_ALIASES: Record<string, string> = {
  united_kingdom: 'uk',
};

const EXTENDED_COUNTRIES = new Set([
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
]);

const normalizeCountryId = (countryId: string): string => {
  return COUNTRY_ALIASES[countryId] ?? countryId;
};

// Debug: log vehicle data structure on import
console.log(
  '[VehicleService Init] Cars:',
  vehiclesData.cars?.length ?? 0,
  'Boats:',
  vehiclesData.boats?.length ?? 0
);
if (!vehiclesData.cars || !vehiclesData.boats) {
  console.error(
    '[VehicleService Init] WARNING: vehicles.json structure issue! Cars array exists:',
    !!vehiclesData.cars,
    'Boats array exists:',
    !!vehiclesData.boats
  );
}

export interface VehicleStats {
  speed: number;
  armor: number;
  cargo: number;
  stealth: number;
}

export interface Vehicle {
  id: string;
  name: string;
  type: string;
  image: string;
  imageNew?: string;
  imageDirty?: string;
  imageDamaged?: string;
  stats: VehicleStats;
  description: string;
  availableInCountries: string[];
  baseValue: number;
  marketValue: Record<string, number>;
  fuelCapacity: number;
  requiredRank: number;
  vehicleCategory?: 'car' | 'boat' | 'motorcycle';
  rarity?: string;
  maxGameAvailability?: number;
  currentWorldCount?: number;
  remainingWorldAvailability?: number;
  eventOnly?: boolean;
}

export interface PoliceVehicleEventStatus {
  active: boolean;
  activeCategory: 'car' | 'boat' | 'motorcycle' | null;
  remainingSeconds: number;
  startsInSeconds: number;
}

type RepairJobRow = {
  id: number;
  player_id: number;
  vehicle_inventory_id: number;
  repair_cost: number;
  from_condition: number;
  target_condition: number;
  status: string;
  started_at: Date;
  completes_at: Date;
  completed_at: Date | null;
};

type VehicleCountRow = {
  vehicleId: string;
  total: bigint | number;
};

type PlayerVehiclePartsRow = {
  player_id: number;
  car_parts: number | bigint;
  motorcycle_parts: number | bigint;
  boat_parts: number | bigint;
};

type PlayerVehicleHeatRow = {
  player_id: number;
  car_heat: number | bigint;
  motorcycle_heat: number | bigint;
  boat_heat: number | bigint;
  updated_at: Date;
};

type PlayerVehicleOpsProfileRow = {
  player_id: number;
  car_rep: number | bigint;
  motorcycle_rep: number | bigint;
  boat_rep: number | bigint;
  insurance_vehicle_type: string | null;
  insurance_tier: string | null;
  insurance_expires_at: Date | null;
  updated_at: Date;
};

type VehicleOpsType = 'car' | 'motorcycle' | 'boat';

type VehicleOpsSeasonRow = {
  season_key: string;
  player_id: number;
  vehicle_type: string;
  points: number | bigint;
  wins: number | bigint;
  losses: number | bigint;
  updated_at: Date;
};

type VehicleOpsInsuranceClaimRow = {
  id: number;
  player_id: number;
  vehicle_type: string;
  claim_type: string;
  status: string;
  payout_amount: number | bigint;
  risk_score: number | bigint;
  context_json: string | null;
  created_at: Date;
  updated_at: Date;
};

type VehicleTuningRow = {
  id: number;
  player_id: number;
  vehicle_inventory_id: number;
  speed_level: number | bigint;
  stealth_level: number | bigint;
  armor_level: number | bigint;
  tune_cooldown_until: Date | null;
};

let repairJobsReady = false;
let tuneTablesReady = false;
let vehicleHeatTableReady = false;
let vehicleOpsProfileReady = false;
let vehicleOpsSeasonReady = false;
let vehicleOpsInsuranceClaimReady = false;

const TUNE_MAX_LEVEL = 10;
const STANDARD_CONCURRENT_REPAIR_LIMIT = 1;
const VIP_CONCURRENT_REPAIR_LIMIT = 2;
const STANDARD_CONCURRENT_TUNE_LIMIT = 1;
const VIP_CONCURRENT_TUNE_LIMIT = 5;
const TUNE_UPGRADE_COOLDOWN_SECONDS_BY_TYPE: Record<'car' | 'boat' | 'motorcycle', number> = {
  car: 180,
  motorcycle: 120,
  boat: 240,
};

const rarityMultiplierMap: Record<string, number> = {
  common: 1,
  uncommon: 1.2,
  rare: 1.5,
  epic: 2,
  legendary: 3,
};

const partsYieldDivisorMap: Record<'car' | 'boat' | 'motorcycle', number> = {
  car: 12000,
  motorcycle: 9000,
  boat: 18000,
};

const tunePartsBaseMap: Record<'car' | 'boat' | 'motorcycle', number> = {
  car: 6,
  motorcycle: 5,
  boat: 8,
};

const tuneStatMultiplierMap: Record<'speed' | 'stealth' | 'armor', number> = {
  speed: 1.0,
  stealth: 1.1,
  armor: 1.2,
};

const tuneMoneyBaseMap: Record<'car' | 'boat' | 'motorcycle', number> = {
  car: 14000,
  motorcycle: 11000,
  boat: 20000,
};

const tuneMoneyStatMultiplierMap: Record<'speed' | 'stealth' | 'armor', number> = {
  speed: 1.0,
  stealth: 1.15,
  armor: 1.3,
};

const tuneStatBonusPerLevelMap: Record<'speed' | 'stealth' | 'armor', number> = {
  speed: 0.03,
  stealth: 0.035,
  armor: 0.04,
};

const calculateVehicleTheftXp = (
  vehicle: Vehicle,
  vehicleType: 'car' | 'boat' | 'motorcycle'
): number => {
  const baseXpByType: Record<'car' | 'boat' | 'motorcycle', number> = {
    car: 16,
    motorcycle: 14,
    boat: 20,
  };

  const rarityMultiplierByTier: Record<string, number> = {
    common: 1.0,
    uncommon: 1.2,
    rare: 1.5,
    epic: 1.9,
    legendary: 2.4,
  };

  const rarity = rarityForVehicle(vehicle);
  const rarityMultiplier = rarityMultiplierByTier[rarity] ?? 1.0;
  const valueBonus = Math.min(90, Math.floor(vehicle.baseValue / 25000));
  const rawXp = Math.round((baseXpByType[vehicleType] + valueBonus) * rarityMultiplier);

  return Math.max(10, rawXp);
};

const normalizeVehicleType = (
  vehicleType: string | null | undefined
): 'car' | 'boat' | 'motorcycle' => {
  const normalized = (vehicleType ?? '').toString().trim().toLowerCase();
  if (['boat', 'boats', 'boot', 'ship', 'yacht'].includes(normalized)) return 'boat';
  if (['motorcycle', 'motorcycles', 'motor', 'motorbike', 'bike'].includes(normalized))
    return 'motorcycle';
  return 'car';
};

const normalizeOpsVehicleType = (vehicleType: string | null | undefined): VehicleOpsType => {
  const normalized = normalizeVehicleType(vehicleType);
  return normalized;
};

const formatOpsVehicleLabel = (vehicleType: VehicleOpsType, language: 'nl' | 'en'): string => {
  if (language === 'nl') {
    if (vehicleType === 'motorcycle') return 'motor';
    if (vehicleType === 'boat') return 'boot';
    return 'auto';
  }
  if (vehicleType === 'motorcycle') return 'motorcycle';
  if (vehicleType === 'boat') return 'boat';
  return 'car';
};

const isEventOnlyVehicle = (vehicle: Vehicle): boolean => {
  return Boolean(vehicle.eventOnly);
};

const getPoliceVehicleEventStatusForTime = (now: Date): PoliceVehicleEventStatus => {
  const minutes = now.getUTCHours() * 60 + now.getUTCMinutes();
  const cycleMinutes = 180;
  const activeMinutes = 45;
  const minuteInCycle = minutes % cycleMinutes;

  if (minuteInCycle < activeMinutes) {
    const remaining = (activeMinutes - minuteInCycle - 1) * 60 + (60 - now.getUTCSeconds());
    return {
      active: true,
      // null during active windows means the event applies to all vehicle categories.
      activeCategory: null,
      remainingSeconds: Math.max(1, remaining),
      startsInSeconds: 0,
    };
  }

  const startsInSeconds = (cycleMinutes - minuteInCycle - 1) * 60 + (60 - now.getUTCSeconds());
  return {
    active: false,
    activeCategory: null,
    remainingSeconds: 0,
    startsInSeconds: Math.max(1, startsInSeconds),
  };
};

const getDynamicPolicePatternForTime = (
  now: Date
): {
  code: 'standard' | 'port_lockdown' | 'bike_sweep' | 'city_grid';
  nameNl: string;
  nameEn: string;
  riskMultiplierByType: Record<VehicleOpsType, number>;
  summaryNl: string;
  summaryEn: string;
} => {
  const utcDay = now.getUTCDay();
  const utcHour = now.getUTCHours();

  if (utcDay === 5 || utcDay === 6) {
    return {
      code: 'bike_sweep',
      nameNl: 'Weekend Bike Sweep',
      nameEn: 'Weekend Bike Sweep',
      riskMultiplierByType: { car: 1.04, motorcycle: 1.16, boat: 1.02 },
      summaryNl: 'In het weekend controleert politie extra op motorverkeer.',
      summaryEn: 'On weekends, police focus more on motorcycle traffic.',
    };
  }

  if (utcHour >= 4 && utcHour < 9) {
    return {
      code: 'port_lockdown',
      nameNl: 'Haven Lockdown',
      nameEn: 'Port Lockdown',
      riskMultiplierByType: { car: 1.03, motorcycle: 1.02, boat: 1.18 },
      summaryNl: 'Vroege uren hebben strikte havencontroles voor boten.',
      summaryEn: 'Early hours have strict port checks for boats.',
    };
  }

  if (utcHour >= 16 && utcHour < 21) {
    return {
      code: 'city_grid',
      nameNl: 'City Grid Patrols',
      nameEn: 'City Grid Patrols',
      riskMultiplierByType: { car: 1.14, motorcycle: 1.1, boat: 1.0 },
      summaryNl: 'Spitsblokkades maken stadsdiefstal risicovoller.',
      summaryEn: 'Rush-hour roadblocks make city theft riskier.',
    };
  }

  return {
    code: 'standard',
    nameNl: 'Standaard Patroon',
    nameEn: 'Standard Pattern',
    riskMultiplierByType: { car: 1, motorcycle: 1, boat: 1 },
    summaryNl: 'Normale politiepatronen zonder extra druk.',
    summaryEn: 'Normal police patterns without extra pressure.',
  };
};

const classifyHeatLevel = (heat: number): 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL' => {
  if (heat >= 80) return 'CRITICAL';
  if (heat >= 55) return 'HIGH';
  if (heat >= 30) return 'MEDIUM';
  return 'LOW';
};

const getHeatSuccessPenalty = (heat: number): number => {
  return Math.min(0.22, Math.max(0, heat) * 0.0025);
};

const hotspotActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_hotspot_op' | 'motorcycle_hotspot_op' | 'boat_hotspot_op' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_hotspot_op';
  if (vehicleType === 'boat') return 'boat_hotspot_op';
  return 'vehicle_hotspot_op';
};

const crewActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_crew_op' | 'motorcycle_crew_op' | 'boat_crew_op' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_crew_op';
  if (vehicleType === 'boat') return 'boat_crew_op';
  return 'vehicle_crew_op';
};

const chopActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_chop_contract' | 'motorcycle_chop_contract' | 'boat_chop_contract' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_chop_contract';
  if (vehicleType === 'boat') return 'boat_chop_contract';
  return 'vehicle_chop_contract';
};

const crewMatchActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_crew_match' | 'motorcycle_crew_match' | 'boat_crew_match' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_crew_match';
  if (vehicleType === 'boat') return 'boat_crew_match';
  return 'vehicle_crew_match';
};

const counterInterceptActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_counter_intercept' | 'motorcycle_counter_intercept' | 'boat_counter_intercept' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_counter_intercept';
  if (vehicleType === 'boat') return 'boat_counter_intercept';
  return 'vehicle_counter_intercept';
};

const opsContractActionTypeForVehicle = (
  vehicleType: VehicleOpsType
): 'vehicle_ops_contract' | 'motorcycle_ops_contract' | 'boat_ops_contract' => {
  if (vehicleType === 'motorcycle') return 'motorcycle_ops_contract';
  if (vehicleType === 'boat') return 'boat_ops_contract';
  return 'vehicle_ops_contract';
};

const getVehicleOpsSeasonKey = (now: Date): string => {
  const quarter = Math.floor(now.getUTCMonth() / 3) + 1;
  return `${now.getUTCFullYear()}-Q${quarter}`;
};

const getPartsMarketPrices = (
  now: Date,
  heatByType: Record<VehicleOpsType, number>
): Record<VehicleOpsType, number> => {
  const minuteFactor = Math.sin((now.getUTCMinutes() / 60) * Math.PI * 2);
  const base: Record<VehicleOpsType, number> = {
    car: 1450,
    motorcycle: 1180,
    boat: 2350,
  };

  const quote: Record<VehicleOpsType, number> = {
    car: 0,
    motorcycle: 0,
    boat: 0,
  };
  (['car', 'motorcycle', 'boat'] as VehicleOpsType[]).forEach((type) => {
    const heatPremium = 1 + Math.min(0.2, heatByType[type] * 0.002);
    const wave = 1 + minuteFactor * 0.08;
    quote[type] = Math.max(300, Math.round(base[type] * heatPremium * wave));
  });
  return quote;
};

const getChopContractForVehicleType = (
  vehicleType: VehicleOpsType,
  now: Date
): {
  contractId: string;
  rewardMoney: number;
  expiresAt: Date;
  minCondition: number;
  requiredCount: number;
} => {
  const halfDaySlot = `${now.getUTCFullYear()}-${now.getUTCMonth() + 1}-${now.getUTCDate()}-${now.getUTCHours() < 12 ? 'A' : 'B'}`;
  const expiresAt = new Date(
    Date.UTC(
      now.getUTCFullYear(),
      now.getUTCMonth(),
      now.getUTCDate(),
      now.getUTCHours() < 12 ? 12 : 24,
      0,
      0,
      0
    )
  );

  if (vehicleType === 'motorcycle') {
    return {
      contractId: `chop-${vehicleType}-${halfDaySlot}`,
      rewardMoney: 34000,
      expiresAt,
      minCondition: 30,
      requiredCount: 1,
    };
  }
  if (vehicleType === 'boat') {
    return {
      contractId: `chop-${vehicleType}-${halfDaySlot}`,
      rewardMoney: 62000,
      expiresAt,
      minCondition: 40,
      requiredCount: 1,
    };
  }
  return {
    contractId: `chop-${vehicleType}-${halfDaySlot}`,
    rewardMoney: 42000,
    expiresAt,
    minCondition: 35,
    requiredCount: 1,
  };
};

const isHotspotInterceptionWindow = (now: Date): boolean => {
  const minute = now.getUTCMinutes();
  const hour = now.getUTCHours();
  return hour % 2 === 0 && minute < 20;
};

const getRegionalBlacklistEvent = (
  vehicleType: VehicleOpsType,
  countryId: string,
  now: Date
): {
  active: boolean;
  eventCode: string | null;
  reasonNl: string | null;
  reasonEn: string | null;
  endsAt: string | null;
} => {
  const country = normalizeCountryId((countryId || '').toLowerCase());
  const hour = now.getUTCHours();
  const day = now.getUTCDay();
  const nextHour = new Date(now);
  nextHour.setUTCMinutes(0, 0, 0);
  nextHour.setUTCHours(hour + 1);

  if (
    vehicleType === 'boat' &&
    ['netherlands', 'belgium', 'france'].includes(country) &&
    hour >= 5 &&
    hour < 9
  ) {
    return {
      active: true,
      eventCode: 'PORT_LOCKDOWN',
      reasonNl: 'Regionale havenblokkade: boottargets tijdelijk gesloten.',
      reasonEn: 'Regional port lockdown: boat targets are temporarily closed.',
      endsAt: nextHour.toISOString(),
    };
  }

  if (
    vehicleType === 'motorcycle' &&
    ['germany', 'united_kingdom', 'spain', 'italy'].includes(country) &&
    (day === 5 || day === 6) &&
    hour >= 19 &&
    hour < 23
  ) {
    return {
      active: true,
      eventCode: 'WEEKEND_BIKE_SWEEP',
      reasonNl: 'Weekend bike sweep: motorraids tijdelijk geblokkeerd.',
      reasonEn: 'Weekend bike sweep: motorcycle raids temporarily blocked.',
      endsAt: nextHour.toISOString(),
    };
  }

  if (
    vehicleType === 'car' &&
    ['usa', 'mexico', 'brazil'].includes(country) &&
    hour >= 16 &&
    hour < 18
  ) {
    return {
      active: true,
      eventCode: 'CITY_GRID_LOCK',
      reasonNl: 'City grid lockdown: autodiefstal tijdelijk geblokkeerd.',
      reasonEn: 'City grid lockdown: car theft temporarily blocked.',
      endsAt: nextHour.toISOString(),
    };
  }

  return {
    active: false,
    eventCode: null,
    reasonNl: null,
    reasonEn: null,
    endsAt: null,
  };
};

const getCountryOpsModifiers = (
  countryId: string,
  vehicleType: VehicleOpsType,
  now: Date
): {
  countryId: string;
  modifierCode: string;
  nameNl: string;
  nameEn: string;
  payoutMultiplier: number;
  riskDelta: number;
  partsPriceMultiplier: number;
} => {
  const country = normalizeCountryId((countryId || '').toLowerCase());
  const hour = now.getUTCHours();
  const day = now.getUTCDay();

  if (
    vehicleType === 'boat' &&
    ['netherlands', 'belgium', 'france'].includes(country) &&
    hour < 10
  ) {
    return {
      countryId: country,
      modifierCode: 'HARBOR_STRIKE',
      nameNl: 'Havenstaking',
      nameEn: 'Harbor Strike',
      payoutMultiplier: 1.18,
      riskDelta: 0.06,
      partsPriceMultiplier: 1.2,
    };
  }

  if (['colombia', 'mexico', 'brazil'].includes(country) && day >= 1 && day <= 5) {
    return {
      countryId: country,
      modifierCode: 'CORRUPTION_WAVE',
      nameNl: 'Corruptiegolf',
      nameEn: 'Corruption Wave',
      payoutMultiplier: 1.12,
      riskDelta: 0.04,
      partsPriceMultiplier: 1.08,
    };
  }

  if (['germany', 'united_kingdom', 'italy'].includes(country) && hour >= 15 && hour <= 20) {
    return {
      countryId: country,
      modifierCode: 'INFLATION_SPIKE',
      nameNl: 'Inflatiepiek',
      nameEn: 'Inflation Spike',
      payoutMultiplier: 1.07,
      riskDelta: 0.01,
      partsPriceMultiplier: 1.14,
    };
  }

  return {
    countryId: country,
    modifierCode: 'BASELINE',
    nameNl: 'Stabiel Klimaat',
    nameEn: 'Stable Climate',
    payoutMultiplier: 1,
    riskDelta: 0,
    partsPriceMultiplier: 1,
  };
};

const getVehicleOpsContractsBoard = (
  vehicleType: VehicleOpsType,
  now: Date,
  repLevel: number,
  countryId: string
): Array<{
  contractId: string;
  tier: 'standard' | 'high_risk' | 'legendary';
  titleNl: string;
  titleEn: string;
  rewardMoney: number;
  failChance: number;
  minRepLevel: number;
  expiresAt: string;
  countryTag: string;
}> => {
  const daySlot = `${now.getUTCFullYear()}-${now.getUTCMonth() + 1}-${now.getUTCDate()}`;
  const weekSlot = `${now.getUTCFullYear()}-W${Math.ceil((now.getUTCDate() + now.getUTCDay()) / 7)}`;
  const country = normalizeCountryId((countryId || '').toLowerCase()) || 'global';
  const nextDay = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1, 0, 0, 0, 0)
  );
  const nextWeek = new Date(
    Date.UTC(
      now.getUTCFullYear(),
      now.getUTCMonth(),
      now.getUTCDate() + (7 - now.getUTCDay()),
      0,
      0,
      0,
      0
    )
  );

  const baseReward = vehicleType === 'boat' ? 52000 : vehicleType === 'motorcycle' ? 28000 : 36000;
  const rareReward = vehicleType === 'boat' ? 88000 : vehicleType === 'motorcycle' ? 51000 : 64000;
  const legendaryReward =
    vehicleType === 'boat' ? 180000 : vehicleType === 'motorcycle' ? 120000 : 145000;

  const board = [
    {
      contractId: `ops-standard-${vehicleType}-${country}-${daySlot}`,
      tier: 'standard' as const,
      titleNl: 'Standaard Routecontract',
      titleEn: 'Standard Route Contract',
      rewardMoney: baseReward,
      failChance: 0.2,
      minRepLevel: 0,
      expiresAt: nextDay.toISOString(),
      countryTag: country,
    },
    {
      contractId: `ops-highrisk-${vehicleType}-${country}-${daySlot}`,
      tier: 'high_risk' as const,
      titleNl: 'High-Risk Overname',
      titleEn: 'High-Risk Takeover',
      rewardMoney: rareReward,
      failChance: 0.3,
      minRepLevel: 1,
      expiresAt: nextDay.toISOString(),
      countryTag: country,
    },
  ];

  const legendaryEligible = repLevel >= 2 && (now.getUTCDay() === 5 || now.getUTCDay() === 6);
  if (legendaryEligible) {
    board.push({
      contractId: `ops-legendary-${vehicleType}-${weekSlot}`,
      tier: 'legendary',
      titleNl: 'Legendarische Zwarte Route',
      titleEn: 'Legendary Black Route',
      rewardMoney: legendaryReward,
      failChance: 0.36,
      minRepLevel: 2,
      expiresAt: nextWeek.toISOString(),
      countryTag: 'global',
    });
  }

  return board;
};

const getVehicleOpsRepLevel = (rep: number): number => {
  if (rep >= 550) return 4;
  if (rep >= 300) return 3;
  if (rep >= 120) return 2;
  if (rep >= 40) return 1;
  return 0;
};

const getOpsRepPerks = (vehicleType: VehicleOpsType, level: number, isNl: boolean): string[] => {
  const packs: Record<VehicleOpsType, string[][]> = {
    car: [
      [],
      [isNl ? 'Level 1: +2% hotspot payout auto' : 'Level 1: +2% car hotspot payout'],
      [isNl ? 'Level 2: -3% faalkans auto hotspot' : 'Level 2: -3% car hotspot fail chance'],
      [isNl ? 'Level 3: +5% chop contract payout auto' : 'Level 3: +5% car chop contract payout'],
      [isNl ? 'Level 4: +4% diefstalslagingskans auto' : 'Level 4: +4% car theft success chance'],
    ],
    motorcycle: [
      [],
      [isNl ? 'Level 1: +2% hotspot payout motor' : 'Level 1: +2% motorcycle hotspot payout'],
      [
        isNl
          ? 'Level 2: -3% faalkans motor hotspot'
          : 'Level 2: -3% motorcycle hotspot fail chance',
      ],
      [
        isNl
          ? 'Level 3: +5% chop contract payout motor'
          : 'Level 3: +5% motorcycle chop contract payout',
      ],
      [
        isNl
          ? 'Level 4: +4% diefstalslagingskans motor'
          : 'Level 4: +4% motorcycle theft success chance',
      ],
    ],
    boat: [
      [],
      [isNl ? 'Level 1: +2% hotspot payout boot' : 'Level 1: +2% boat hotspot payout'],
      [isNl ? 'Level 2: -3% faalkans boot hotspot' : 'Level 2: -3% boat hotspot fail chance'],
      [isNl ? 'Level 3: +5% chop contract payout boot' : 'Level 3: +5% boat chop contract payout'],
      [isNl ? 'Level 4: +4% diefstalslagingskans boot' : 'Level 4: +4% boat theft success chance'],
    ],
  };

  const perks: string[] = [];
  for (let i = 1; i <= Math.min(4, level); i += 1) {
    perks.push(...packs[vehicleType][i]);
  }
  return perks;
};

const getCrewRoleOpsBonus = (
  role: string | null | undefined
): {
  roleCode: string;
  roleNameNl: string;
  roleNameEn: string;
  failChanceDelta: number;
  payoutMultiplier: number;
} => {
  const normalized = (role ?? '').toLowerCase();
  if (normalized.includes('leader')) {
    return {
      roleCode: 'leader',
      roleNameNl: 'Leader',
      roleNameEn: 'Leader',
      failChanceDelta: -0.03,
      payoutMultiplier: 1.06,
    };
  }
  if (normalized.includes('co') || normalized.includes('captain')) {
    return {
      roleCode: 'captain',
      roleNameNl: 'Captain',
      roleNameEn: 'Captain',
      failChanceDelta: -0.02,
      payoutMultiplier: 1.04,
    };
  }
  if (normalized.includes('strateg') || normalized.includes('planner')) {
    return {
      roleCode: 'planner',
      roleNameNl: 'Planner',
      roleNameEn: 'Planner',
      failChanceDelta: -0.025,
      payoutMultiplier: 1.03,
    };
  }
  return {
    roleCode: 'operative',
    roleNameNl: 'Operative',
    roleNameEn: 'Operative',
    failChanceDelta: 0,
    payoutMultiplier: 1,
  };
};

const rarityForVehicle = (vehicle: Vehicle): string => {
  if (vehicle.rarity) return vehicle.rarity;

  if (vehicle.baseValue <= 15000) return 'common';
  if (vehicle.baseValue <= 60000) return 'uncommon';
  if (vehicle.baseValue <= 150000) return 'rare';
  if (vehicle.baseValue <= 400000) return 'epic';
  return 'legendary';
};

const maxAvailabilityForVehicle = (vehicle: Vehicle): number => {
  if (vehicle.maxGameAvailability) return vehicle.maxGameAvailability;

  const rarity = rarityForVehicle(vehicle);
  const isBoat = vehicle.vehicleCategory === 'boat';
  const isMotorcycle = vehicle.vehicleCategory === 'motorcycle';

  switch (rarity) {
    case 'common':
      return isBoat ? 24 : isMotorcycle ? 50 : 60;
    case 'uncommon':
      return isBoat ? 16 : isMotorcycle ? 34 : 40;
    case 'rare':
      return isBoat ? 10 : isMotorcycle ? 20 : 22;
    case 'epic':
      return isBoat ? 6 : isMotorcycle ? 11 : 12;
    case 'legendary':
      return isBoat ? 3 : 5;
    default:
      return isBoat ? 12 : isMotorcycle ? 24 : 30;
  }
};

const repairDurationSecondsForVehicle = (vehicle: Vehicle, currentCondition: number): number => {
  const damagePercent = Math.max(0, 100 - currentCondition);
  const isBoat = vehicle.vehicleCategory === 'boat';
  const isMotorcycle = vehicle.vehicleCategory === 'motorcycle';
  const baseSeconds = isBoat ? 20 * 60 : isMotorcycle ? 8 * 60 : 12 * 60;
  const damageSeconds = damagePercent * (isBoat ? 120 : isMotorcycle ? 70 : 90);
  const valueSeconds = Math.min(
    6 * 60 * 60,
    Math.floor(vehicle.baseValue / (isBoat ? 120 : isMotorcycle ? 260 : 200))
  );

  return Math.max(
    isBoat ? 30 * 60 : isMotorcycle ? 10 * 60 : 15 * 60,
    Math.min(12 * 60 * 60, Math.round(baseSeconds + damageSeconds + valueSeconds))
  );
};

async function ensureRepairJobsTable() {
  if (repairJobsReady) return;

  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS vehicle_repair_jobs (
      id INT NOT NULL AUTO_INCREMENT,
      player_id INT NOT NULL,
      vehicle_inventory_id INT NOT NULL,
      repair_cost INT NOT NULL,
      from_condition INT NOT NULL,
      target_condition INT NOT NULL DEFAULT 100,
      status VARCHAR(20) NOT NULL DEFAULT 'in_progress',
      started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      completes_at DATETIME NOT NULL,
      completed_at DATETIME NULL,
      PRIMARY KEY (id),
      INDEX idx_vehicle_repair_jobs_player_status (player_id, status),
      INDEX idx_vehicle_repair_jobs_vehicle_status (vehicle_inventory_id, status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;

  repairJobsReady = true;
}

async function ensureTuneTables() {
  if (tuneTablesReady) return;

  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS player_vehicle_parts (
      player_id INT NOT NULL,
      car_parts INT NOT NULL DEFAULT 0,
      motorcycle_parts INT NOT NULL DEFAULT 0,
      boat_parts INT NOT NULL DEFAULT 0,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (player_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;

  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS vehicle_tuning_upgrades (
      id INT NOT NULL AUTO_INCREMENT,
      player_id INT NOT NULL,
      vehicle_inventory_id INT NOT NULL,
      speed_level INT NOT NULL DEFAULT 0,
      stealth_level INT NOT NULL DEFAULT 0,
      armor_level INT NOT NULL DEFAULT 0,
      created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_vehicle_tuning_vehicle (vehicle_inventory_id),
      INDEX idx_vehicle_tuning_player (player_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;

  // Backward compatibility: older databases may have these tables without new columns.
  const ensureColumnExists = async (tableName: string, columnName: string, columnSql: string) => {
    const rows = await prisma.$queryRaw<Array<{ total: bigint | number }>>`
      SELECT COUNT(*) AS total
      FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = ${tableName}
        AND COLUMN_NAME = ${columnName}
    `;
    const total = Number(rows[0]?.total ?? 0);
    if (total === 0) {
      await prisma.$executeRawUnsafe(
        `ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${columnSql}`
      );
    }
  };

  await ensureColumnExists('player_vehicle_parts', 'car_parts', 'INT NOT NULL DEFAULT 0');
  await ensureColumnExists('player_vehicle_parts', 'motorcycle_parts', 'INT NOT NULL DEFAULT 0');
  await ensureColumnExists('player_vehicle_parts', 'boat_parts', 'INT NOT NULL DEFAULT 0');

  await ensureColumnExists('vehicle_tuning_upgrades', 'speed_level', 'INT NOT NULL DEFAULT 0');
  await ensureColumnExists('vehicle_tuning_upgrades', 'stealth_level', 'INT NOT NULL DEFAULT 0');
  await ensureColumnExists('vehicle_tuning_upgrades', 'armor_level', 'INT NOT NULL DEFAULT 0');
  await ensureColumnExists('vehicle_tuning_upgrades', 'tune_cooldown_until', 'DATETIME NULL');

  tuneTablesReady = true;
}

async function ensurePlayerPartsRow(playerId: number) {
  await ensureTuneTables();
  await prisma.$executeRaw`
    INSERT INTO player_vehicle_parts (player_id, car_parts, motorcycle_parts, boat_parts)
    VALUES (${playerId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;
}

async function ensureVehicleHeatTable() {
  if (vehicleHeatTableReady) return;

  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS player_vehicle_heat (
      player_id INT NOT NULL,
      car_heat INT NOT NULL DEFAULT 0,
      motorcycle_heat INT NOT NULL DEFAULT 0,
      boat_heat INT NOT NULL DEFAULT 0,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (player_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;

  vehicleHeatTableReady = true;
}

async function ensurePlayerVehicleHeatRow(playerId: number) {
  await ensureVehicleHeatTable();
  await prisma.$executeRaw`
    INSERT INTO player_vehicle_heat (player_id, car_heat, motorcycle_heat, boat_heat)
    VALUES (${playerId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;
}

async function ensureVehicleOpsProfileTable() {
  if (vehicleOpsProfileReady) return;

  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS player_vehicle_ops_profile (
      player_id INT NOT NULL,
      car_rep INT NOT NULL DEFAULT 0,
      motorcycle_rep INT NOT NULL DEFAULT 0,
      boat_rep INT NOT NULL DEFAULT 0,
      insurance_vehicle_type VARCHAR(20) NULL,
      insurance_tier VARCHAR(20) NULL,
      insurance_expires_at DATETIME NULL,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (player_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;

  vehicleOpsProfileReady = true;
}

async function ensurePlayerVehicleOpsProfileRow(playerId: number) {
  await ensureVehicleOpsProfileTable();
  await prisma.$executeRaw`
    INSERT INTO player_vehicle_ops_profile (
      player_id,
      car_rep,
      motorcycle_rep,
      boat_rep,
      insurance_vehicle_type,
      insurance_tier,
      insurance_expires_at
    )
    VALUES (${playerId}, 0, 0, 0, NULL, NULL, NULL)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;
}

async function getPlayerVehicleOpsProfile(playerId: number): Promise<{
  carRep: number;
  motorcycleRep: number;
  boatRep: number;
  insuranceVehicleType: string | null;
  insuranceTier: string | null;
  insuranceExpiresAt: Date | null;
}> {
  await ensurePlayerVehicleOpsProfileRow(playerId);

  const rows = await prisma.$queryRaw<PlayerVehicleOpsProfileRow[]>`
    SELECT player_id, car_rep, motorcycle_rep, boat_rep,
           insurance_vehicle_type, insurance_tier, insurance_expires_at, updated_at
    FROM player_vehicle_ops_profile
    WHERE player_id = ${playerId}
    LIMIT 1
  `;
  const row = rows[0];
  return {
    carRep: Number(row?.car_rep ?? 0),
    motorcycleRep: Number(row?.motorcycle_rep ?? 0),
    boatRep: Number(row?.boat_rep ?? 0),
    insuranceVehicleType: row?.insurance_vehicle_type ?? null,
    insuranceTier: row?.insurance_tier ?? null,
    insuranceExpiresAt: row?.insurance_expires_at ? new Date(row.insurance_expires_at) : null,
  };
}

async function addVehicleOpsRep(playerId: number, vehicleType: VehicleOpsType, amount: number) {
  const safeAmount = Math.max(0, Math.floor(amount));
  if (safeAmount <= 0) return;
  await ensurePlayerVehicleOpsProfileRow(playerId);

  if (vehicleType === 'boat') {
    await prisma.$executeRaw`
      UPDATE player_vehicle_ops_profile
      SET boat_rep = LEAST(9999, boat_rep + ${safeAmount})
      WHERE player_id = ${playerId}
    `;
    return;
  }
  if (vehicleType === 'motorcycle') {
    await prisma.$executeRaw`
      UPDATE player_vehicle_ops_profile
      SET motorcycle_rep = LEAST(9999, motorcycle_rep + ${safeAmount})
      WHERE player_id = ${playerId}
    `;
    return;
  }
  await prisma.$executeRaw`
    UPDATE player_vehicle_ops_profile
    SET car_rep = LEAST(9999, car_rep + ${safeAmount})
    WHERE player_id = ${playerId}
  `;
}

async function ensureVehicleOpsSeasonTable() {
  if (vehicleOpsSeasonReady) return;
  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS player_vehicle_ops_season (
      season_key VARCHAR(16) NOT NULL,
      player_id INT NOT NULL,
      vehicle_type VARCHAR(20) NOT NULL,
      points INT NOT NULL DEFAULT 1000,
      wins INT NOT NULL DEFAULT 0,
      losses INT NOT NULL DEFAULT 0,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (season_key, player_id, vehicle_type),
      INDEX idx_vehicle_ops_season_board (season_key, vehicle_type, points),
      INDEX idx_vehicle_ops_season_player (player_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;
  vehicleOpsSeasonReady = true;
}

async function ensureVehicleOpsSeasonRow(
  playerId: number,
  vehicleType: VehicleOpsType,
  seasonKey: string
) {
  await ensureVehicleOpsSeasonTable();
  await prisma.$executeRaw`
    INSERT INTO player_vehicle_ops_season (
      season_key,
      player_id,
      vehicle_type,
      points,
      wins,
      losses
    )
    VALUES (${seasonKey}, ${playerId}, ${vehicleType}, 1000, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;
}

async function getVehicleOpsSeasonStats(
  playerId: number,
  vehicleType: VehicleOpsType,
  seasonKey: string
) {
  await ensureVehicleOpsSeasonRow(playerId, vehicleType, seasonKey);
  const rows = await prisma.$queryRaw<VehicleOpsSeasonRow[]>`
    SELECT season_key, player_id, vehicle_type, points, wins, losses, updated_at
    FROM player_vehicle_ops_season
    WHERE season_key = ${seasonKey}
      AND player_id = ${playerId}
      AND vehicle_type = ${vehicleType}
    LIMIT 1
  `;
  const row = rows[0];
  return {
    seasonKey,
    points: Number(row?.points ?? 1000),
    wins: Number(row?.wins ?? 0),
    losses: Number(row?.losses ?? 0),
  };
}

async function updateVehicleOpsSeasonStats(
  playerId: number,
  vehicleType: VehicleOpsType,
  seasonKey: string,
  deltaPoints: number,
  deltaWins: number,
  deltaLosses: number
) {
  await ensureVehicleOpsSeasonRow(playerId, vehicleType, seasonKey);
  await prisma.$executeRaw`
    UPDATE player_vehicle_ops_season
    SET points = GREATEST(0, points + ${deltaPoints}),
        wins = GREATEST(0, wins + ${deltaWins}),
        losses = GREATEST(0, losses + ${deltaLosses})
    WHERE season_key = ${seasonKey}
      AND player_id = ${playerId}
      AND vehicle_type = ${vehicleType}
  `;
}

async function getVehicleOpsSeasonTop(
  vehicleType: VehicleOpsType,
  seasonKey: string,
  limit: number
): Promise<
  Array<{
    playerId: number;
    username: string;
    points: number;
    wins: number;
    losses: number;
  }>
> {
  await ensureVehicleOpsSeasonTable();
  const rows = await prisma.$queryRaw<
    Array<{
      player_id: number;
      username: string;
      points: number | bigint;
      wins: number | bigint;
      losses: number | bigint;
    }>
  >`
    SELECT s.player_id, p.username, s.points, s.wins, s.losses
    FROM player_vehicle_ops_season s
    INNER JOIN players p ON p.id = s.player_id
    WHERE s.season_key = ${seasonKey}
      AND s.vehicle_type = ${vehicleType}
    ORDER BY s.points DESC, s.wins DESC, s.updated_at ASC
    LIMIT ${Math.max(1, Math.min(25, Math.floor(limit)))}
  `;
  return rows.map((row) => ({
    playerId: row.player_id,
    username: row.username,
    points: Number(row.points ?? 0),
    wins: Number(row.wins ?? 0),
    losses: Number(row.losses ?? 0),
  }));
}

async function ensureVehicleOpsInsuranceClaimsTable() {
  if (vehicleOpsInsuranceClaimReady) return;
  await prisma.$executeRaw`
    CREATE TABLE IF NOT EXISTS player_vehicle_ops_insurance_claims (
      id INT NOT NULL AUTO_INCREMENT,
      player_id INT NOT NULL,
      vehicle_type VARCHAR(20) NOT NULL,
      claim_type VARCHAR(40) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'REVIEW',
      payout_amount INT NOT NULL DEFAULT 0,
      risk_score INT NOT NULL DEFAULT 0,
      context_json TEXT NULL,
      created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_vehicle_ops_claims_player (player_id, status, created_at),
      INDEX idx_vehicle_ops_claims_vehicle (vehicle_type, status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `;
  vehicleOpsInsuranceClaimReady = true;
}

async function createVehicleInsuranceClaim(params: {
  playerId: number;
  vehicleType: VehicleOpsType;
  claimType: string;
  payoutAmount: number;
  riskScore: number;
  context: Record<string, unknown>;
}): Promise<number> {
  await ensureVehicleOpsInsuranceClaimsTable();
  const result = await prisma.$executeRaw`
    INSERT INTO player_vehicle_ops_insurance_claims (
      player_id,
      vehicle_type,
      claim_type,
      status,
      payout_amount,
      risk_score,
      context_json
    ) VALUES (
      ${params.playerId},
      ${params.vehicleType},
      ${params.claimType},
      'REVIEW',
      ${Math.max(0, Math.floor(params.payoutAmount))},
      ${Math.max(0, Math.floor(params.riskScore))},
      ${JSON.stringify(params.context)}
    )
  `;
  return Number(result ?? 0);
}

async function getOpenVehicleInsuranceClaims(playerId: number, vehicleType: VehicleOpsType) {
  await ensureVehicleOpsInsuranceClaimsTable();
  const rows = await prisma.$queryRaw<VehicleOpsInsuranceClaimRow[]>`
    SELECT id, player_id, vehicle_type, claim_type, status, payout_amount, risk_score, context_json, created_at, updated_at
    FROM player_vehicle_ops_insurance_claims
    WHERE player_id = ${playerId}
      AND vehicle_type = ${vehicleType}
      AND status = 'REVIEW'
    ORDER BY created_at DESC
    LIMIT 5
  `;
  return rows.map((row) => ({
    id: Number(row.id),
    claimType: row.claim_type,
    status: row.status,
    payoutAmount: Number(row.payout_amount ?? 0),
    riskScore: Number(row.risk_score ?? 0),
    createdAt:
      row.created_at instanceof Date
        ? row.created_at.toISOString()
        : new Date(row.created_at).toISOString(),
  }));
}

async function getPlayerVehicleHeatSnapshot(playerId: number): Promise<{
  car: number;
  motorcycle: number;
  boat: number;
}> {
  await ensurePlayerVehicleHeatRow(playerId);

  const rows = await prisma.$queryRaw<PlayerVehicleHeatRow[]>`
    SELECT player_id, car_heat, motorcycle_heat, boat_heat, updated_at
    FROM player_vehicle_heat
    WHERE player_id = ${playerId}
    LIMIT 1
  `;
  const row = rows[0];
  const now = Date.now();
  const updatedAtMs = row?.updated_at ? new Date(row.updated_at).getTime() : now;
  const elapsedHours = Math.max(0, Math.floor((now - updatedAtMs) / (60 * 60 * 1000)));
  const decayPerHour = 6;

  const baseCar = Number(row?.car_heat ?? 0);
  const baseMotorcycle = Number(row?.motorcycle_heat ?? 0);
  const baseBoat = Number(row?.boat_heat ?? 0);

  const car = Math.max(0, baseCar - elapsedHours * decayPerHour);
  const motorcycle = Math.max(0, baseMotorcycle - elapsedHours * decayPerHour);
  const boat = Math.max(0, baseBoat - elapsedHours * decayPerHour);

  if (elapsedHours > 0 && (car !== baseCar || motorcycle !== baseMotorcycle || boat !== baseBoat)) {
    await prisma.$executeRaw`
      UPDATE player_vehicle_heat
      SET car_heat = ${car},
          motorcycle_heat = ${motorcycle},
          boat_heat = ${boat},
          updated_at = UTC_TIMESTAMP()
      WHERE player_id = ${playerId}
    `;
  }

  return { car, motorcycle, boat };
}

async function increasePlayerVehicleHeat(
  playerId: number,
  vehicleType: VehicleOpsType,
  amount: number
) {
  const safeAmount = Math.max(0, Math.floor(amount));
  if (safeAmount <= 0) return;

  const snapshot = await getPlayerVehicleHeatSnapshot(playerId);
  const nextCar = vehicleType === 'car' ? Math.min(100, snapshot.car + safeAmount) : snapshot.car;
  const nextMotorcycle =
    vehicleType === 'motorcycle'
      ? Math.min(100, snapshot.motorcycle + safeAmount)
      : snapshot.motorcycle;
  const nextBoat =
    vehicleType === 'boat' ? Math.min(100, snapshot.boat + safeAmount) : snapshot.boat;

  await prisma.$executeRaw`
    UPDATE player_vehicle_heat
    SET car_heat = ${nextCar},
        motorcycle_heat = ${nextMotorcycle},
        boat_heat = ${nextBoat},
        updated_at = UTC_TIMESTAMP()
    WHERE player_id = ${playerId}
  `;
}

async function getPlayerPartsInventory(
  playerId: number
): Promise<{ car: number; motorcycle: number; boat: number }> {
  await ensurePlayerPartsRow(playerId);

  const rows = await prisma.$queryRaw<PlayerVehiclePartsRow[]>`
    SELECT player_id, car_parts, motorcycle_parts, boat_parts
    FROM player_vehicle_parts
    WHERE player_id = ${playerId}
    LIMIT 1
  `;

  const row = rows[0];
  return {
    car: Number(row?.car_parts ?? 0),
    motorcycle: Number(row?.motorcycle_parts ?? 0),
    boat: Number(row?.boat_parts ?? 0),
  };
}

async function getVehicleTuningMap(
  playerId: number,
  inventoryIds: number[]
): Promise<
  Map<
    number,
    {
      speed: number;
      stealth: number;
      armor: number;
      tuneCooldownUntil: Date | null;
    }
  >
> {
  await ensureTuneTables();
  if (inventoryIds.length === 0) return new Map();

  const rows = await prisma.$queryRaw<VehicleTuningRow[]>`
    SELECT id, player_id, vehicle_inventory_id, speed_level, stealth_level, armor_level, tune_cooldown_until
    FROM vehicle_tuning_upgrades
    WHERE player_id = ${playerId}
      AND vehicle_inventory_id IN (${Prisma.join(inventoryIds)})
  `;

  return new Map(
    rows.map((row) => [
      row.vehicle_inventory_id,
      {
        speed: Number(row.speed_level ?? 0),
        stealth: Number(row.stealth_level ?? 0),
        armor: Number(row.armor_level ?? 0),
        tuneCooldownUntil: row.tune_cooldown_until ? new Date(row.tune_cooldown_until) : null,
      },
    ])
  );
}

async function getVehicleTuningLevels(
  playerId: number,
  inventoryId: number
): Promise<{ speed: number; stealth: number; armor: number }> {
  const tuningMap = await getVehicleTuningMap(playerId, [inventoryId]);
  return tuningMap.get(inventoryId) ?? { speed: 0, stealth: 0, armor: 0 };
}

const getTuneCooldownRemainingSeconds = (cooldownUntil: Date | null | undefined): number => {
  if (!cooldownUntil) return 0;
  const remainingMs = cooldownUntil.getTime() - Date.now();
  return Math.max(0, Math.ceil(remainingMs / 1000));
};

const getTotalTuneLevel = (levels: { speed: number; stealth: number; armor: number }): number => {
  return (levels.speed ?? 0) + (levels.stealth ?? 0) + (levels.armor ?? 0);
};

const getTuneValueMultiplier = (levels: {
  speed: number;
  stealth: number;
  armor: number;
}): number => {
  const totalLevel = getTotalTuneLevel(levels);
  return 1 + totalLevel * 0.03;
};

const getTunedStats = (
  baseStats: VehicleStats,
  levels: { speed: number; stealth: number; armor: number }
): VehicleStats => {
  return {
    speed: Math.round(
      (baseStats.speed ?? 0) * (1 + (levels.speed ?? 0) * tuneStatBonusPerLevelMap.speed)
    ),
    stealth: Math.round(
      (baseStats.stealth ?? 0) * (1 + (levels.stealth ?? 0) * tuneStatBonusPerLevelMap.stealth)
    ),
    armor: Math.round(
      (baseStats.armor ?? 0) * (1 + (levels.armor ?? 0) * tuneStatBonusPerLevelMap.armor)
    ),
    cargo: baseStats.cargo,
  };
};

const calculatePartsYield = (vehicle: Vehicle, condition: number): number => {
  const vehicleType = normalizeVehicleType(vehicle.vehicleCategory);
  const divisor = partsYieldDivisorMap[vehicleType];
  const rarity = rarityForVehicle(vehicle);
  const rarityMultiplier = rarityMultiplierMap[rarity] ?? 1;
  const conditionMultiplier = 0.6 + (Math.max(0, Math.min(100, condition)) / 100) * 0.4;
  const baseYield = Math.max(1, Math.floor(vehicle.baseValue / divisor));
  return Math.max(1, Math.ceil(baseYield * rarityMultiplier * conditionMultiplier));
};

const calculateLegacyPartsYield = (
  vehicleType: 'car' | 'boat' | 'motorcycle',
  condition: number,
  baseValue: number
): number => {
  const divisor = partsYieldDivisorMap[vehicleType];
  const conditionMultiplier = 0.6 + (Math.max(0, Math.min(100, condition)) / 100) * 0.4;
  const baseYield = Math.max(1, Math.floor(baseValue / divisor));
  return Math.max(1, Math.ceil(baseYield * conditionMultiplier));
};

const getTuneUpgradeCost = (
  _vehicle: Vehicle,
  vehicleType: 'car' | 'boat' | 'motorcycle',
  stat: 'speed' | 'stealth' | 'armor',
  currentLevel: number
): { nextLevel: number; partsCost: number; moneyCost: number } => {
  const nextLevel = currentLevel + 1;
  const statMultiplier = tuneStatMultiplierMap[stat];
  const baseParts = tunePartsBaseMap[vehicleType];
  const partsCost = Math.ceil(baseParts * statMultiplier * Math.pow(nextLevel, 1.35));
  const baseMoney = tuneMoneyBaseMap[vehicleType];
  const moneyStatMultiplier = tuneMoneyStatMultiplierMap[stat];
  const moneyCost = Math.ceil(baseMoney * moneyStatMultiplier * Math.pow(nextLevel, 1.4));
  return { nextLevel, partsCost, moneyCost };
};

async function processCompletedRepairJobs(playerId?: number) {
  await ensureRepairJobsTable();
  const dueJobs =
    playerId == null
      ? await prisma.$queryRaw<RepairJobRow[]>`
        SELECT *
        FROM vehicle_repair_jobs
        WHERE status = 'in_progress'
          AND completes_at <= UTC_TIMESTAMP()
      `
      : await prisma.$queryRaw<RepairJobRow[]>`
        SELECT *
        FROM vehicle_repair_jobs
        WHERE player_id = ${playerId}
          AND status = 'in_progress'
          AND completes_at <= UTC_TIMESTAMP()
      `;

  if (dueJobs.length === 0) return;

  const inventoryIds = dueJobs.map((job) => job.vehicle_inventory_id);
  const vehiclesByInventoryId = new Map(
    (
      await prisma.vehicleInventory.findMany({
        where: { id: { in: inventoryIds } },
        select: {
          id: true,
          playerId: true,
          vehicleId: true,
          vehicleType: true,
        },
      })
    ).map((vehicle) => [vehicle.id, vehicle])
  );

  const completedJobs: Array<{
    playerId: number;
    vehicleName: string;
    vehicleType: 'car' | 'boat' | 'motorcycle';
    vehicleInventoryId: number;
  }> = [];

  for (const job of dueJobs) {
    const markedCompleted = await prisma.$transaction(async (tx) => {
      const updatedRows = await tx.$executeRaw`
        UPDATE vehicle_repair_jobs
        SET status = 'completed', completed_at = UTC_TIMESTAMP()
        WHERE id = ${job.id}
          AND status = 'in_progress'
      `;

      if (Number(updatedRows ?? 0) <= 0) {
        return false;
      }

      await tx.vehicleInventory.update({
        where: { id: job.vehicle_inventory_id },
        data: { condition: job.target_condition },
      });

      return true;
    });

    if (!markedCompleted) {
      continue;
    }

    const vehicleInventory = vehiclesByInventoryId.get(job.vehicle_inventory_id);
    if (!vehicleInventory) {
      continue;
    }

    const definition = vehicleService.getVehicleById(vehicleInventory.vehicleId);
    const normalizedVehicleType = normalizeVehicleType(vehicleInventory.vehicleType);

    completedJobs.push({
      playerId: vehicleInventory.playerId,
      vehicleName: definition?.name ?? 'Vehicle',
      vehicleType: normalizedVehicleType,
      vehicleInventoryId: vehicleInventory.id,
    });
  }

  if (completedJobs.length === 0) {
    return;
  }

  await Promise.all(
    completedJobs.map(async (job) => {
      try {
        await notificationService.sendVehicleRepairCompletedNotification(
          job.playerId,
          job.vehicleName,
          job.vehicleType,
          job.vehicleInventoryId
        );
      } catch {
        // Fire-and-forget: notification failures may not block repair completion.
      }
    })
  );
}

async function getActiveRepairJobs(playerId: number): Promise<Map<number, RepairJobRow>> {
  await ensureRepairJobsTable();
  await processCompletedRepairJobs(playerId);

  const rows = await prisma.$queryRaw<RepairJobRow[]>`
    SELECT *
    FROM vehicle_repair_jobs
    WHERE player_id = ${playerId}
      AND status = 'in_progress'
  `;

  return new Map(rows.map((row) => [row.vehicle_inventory_id, row]));
}

async function hasRepairInProgress(playerId: number, vehicleInventoryId: number): Promise<boolean> {
  await ensureRepairJobsTable();
  const rows = await prisma.$queryRaw<RepairJobRow[]>`
    SELECT *
    FROM vehicle_repair_jobs
    WHERE player_id = ${playerId}
      AND vehicle_inventory_id = ${vehicleInventoryId}
      AND status = 'in_progress'
    LIMIT 1
  `;

  return rows.length > 0;
}

async function getActiveRepairJobCount(playerId: number): Promise<number> {
  await ensureRepairJobsTable();
  await processCompletedRepairJobs(playerId);

  const rows = await prisma.$queryRaw<Array<{ total: bigint | number }>>`
    SELECT COUNT(*) AS total
    FROM vehicle_repair_jobs
    WHERE player_id = ${playerId}
      AND status = 'in_progress'
  `;

  return Number(rows[0]?.total ?? 0);
}

async function getActiveTuneCooldownCount(playerId: number): Promise<number> {
  await ensureTuneTables();

  const rows = await prisma.$queryRaw<Array<{ total: bigint | number }>>`
    SELECT COUNT(*) AS total
    FROM vehicle_tuning_upgrades
    WHERE player_id = ${playerId}
      AND tune_cooldown_until IS NOT NULL
      AND tune_cooldown_until > UTC_TIMESTAMP()
  `;

  return Number(rows[0]?.total ?? 0);
}

const isPlayerVipActive = (player: { isVip: boolean; vipExpiresAt: Date | null }): boolean => {
  return Boolean(player.isVip) && (!player.vipExpiresAt || player.vipExpiresAt > new Date());
};

const getConcurrentRepairLimit = (isVipActive: boolean): number => {
  return isVipActive ? VIP_CONCURRENT_REPAIR_LIMIT : STANDARD_CONCURRENT_REPAIR_LIMIT;
};

const getConcurrentTuneLimit = (isVipActive: boolean): number => {
  return isVipActive ? VIP_CONCURRENT_TUNE_LIMIT : STANDARD_CONCURRENT_TUNE_LIMIT;
};

export async function processDueVehicleRepairCompletions(): Promise<number> {
  await ensureRepairJobsTable();

  const rows = await prisma.$queryRaw<Array<{ total: bigint | number }>>`
    SELECT COUNT(*) AS total
    FROM vehicle_repair_jobs
    WHERE status = 'in_progress'
      AND completes_at <= UTC_TIMESTAMP()
  `;

  const dueCount = Number(rows[0]?.total ?? 0);
  if (dueCount <= 0) {
    return 0;
  }

  await processCompletedRepairJobs();
  return dueCount;
}

async function getWorldVehicleCounts(): Promise<Map<string, number>> {
  const rows = await prisma.$queryRaw<VehicleCountRow[]>`
    SELECT vehicleId, SUM(total) AS total
    FROM (
      SELECT vehicleId, COUNT(*) AS total FROM vehicle_inventory GROUP BY vehicleId
      UNION ALL
      SELECT vehicleId, COUNT(*) AS total FROM crew_car_inventory GROUP BY vehicleId
      UNION ALL
      SELECT vehicleId, COUNT(*) AS total FROM crew_boat_inventory GROUP BY vehicleId
    ) grouped
    GROUP BY vehicleId
  `;

  return new Map(rows.map((row) => [row.vehicleId, Number(row.total)]));
}

async function getWorldCountForVehicle(vehicleId: string): Promise<number> {
  const counts = await getWorldVehicleCounts();
  return counts.get(vehicleId) ?? 0;
}

const withVehicleMeta = (
  vehicle: Vehicle,
  vehicleCategory: 'car' | 'boat' | 'motorcycle',
  worldCount = 0
): Vehicle => {
  const normalized: Vehicle = {
    ...vehicle,
    vehicleCategory,
  };
  const rarity = rarityForVehicle(normalized);
  const maxGameAvailability = maxAvailabilityForVehicle({ ...normalized, rarity });

  return {
    ...normalized,
    rarity,
    maxGameAvailability,
    currentWorldCount: worldCount,
    remainingWorldAvailability: Math.max(0, maxGameAvailability - worldCount),
  };
};

export const vehicleService = {
  /**
   * Get all available vehicles (cars and boats)
   */
  getAvailableVehicles(): { cars: Vehicle[]; boats: Vehicle[]; motorcycles: Vehicle[] } {
    console.log('[getAvailableVehicles] Full data:', {
      carsCount: vehiclesData.cars?.length,
      boatsCount: vehiclesData.boats?.length,
      motorcyclesCount: (vehiclesData as any).motorcycles?.length ?? 0,
      carsKeys: vehiclesData.cars ? Object.keys(vehiclesData.cars[0] || {}) : [],
      boatsKeys: vehiclesData.boats ? Object.keys(vehiclesData.boats[0] || {}) : [],
    });

    return {
      cars: (vehiclesData.cars as unknown as Vehicle[]).map((vehicle) =>
        withVehicleMeta(vehicle, 'car')
      ),
      boats: (vehiclesData.boats as unknown as Vehicle[]).map((vehicle) =>
        withVehicleMeta(vehicle, 'boat')
      ),
      motorcycles: (((vehiclesData as any).motorcycles ?? []) as Vehicle[]).map((vehicle) =>
        withVehicleMeta(vehicle, 'motorcycle')
      ),
    };
  },

  /**
   * Get vehicle definition by ID
   */
  getVehicleById(vehicleId: string): Vehicle | undefined {
    const allVehicles = [
      ...vehiclesData.cars,
      ...vehiclesData.boats,
      ...(((vehiclesData as any).motorcycles ?? []) as any[]),
    ] as unknown as Vehicle[];
    const normalizedVehicleId = (vehicleId ?? '').toString().trim().toLowerCase();
    const vehicle = allVehicles.find(
      (v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId
    );
    if (!vehicle) return undefined;
    const isCar = (vehiclesData.cars as unknown as Vehicle[]).some(
      (v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId
    );
    const isBoat = (vehiclesData.boats as unknown as Vehicle[]).some(
      (v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId
    );
    return withVehicleMeta(vehicle, isCar ? 'car' : isBoat ? 'boat' : 'motorcycle');
  },

  /**
   * Get vehicles available in a specific country
   */
  async getVehiclesInCountry(countryId: string): Promise<Vehicle[]> {
    const normalizedCountry = normalizeCountryId(countryId);
    const isExtendedCountry = EXTENDED_COUNTRIES.has(normalizedCountry);
    const worldCounts = await getWorldVehicleCounts();
    const policeEventStatus = getPoliceVehicleEventStatusForTime(new Date());

    const canExposeVehicle = (vehicle: Vehicle, category: 'car' | 'boat' | 'motorcycle') => {
      if (!isEventOnlyVehicle(vehicle)) return true;
      const categoryAllowed =
        policeEventStatus.activeCategory == null || policeEventStatus.activeCategory === category;
      return policeEventStatus.active && categoryAllowed;
    };

    const cars = (vehiclesData.cars as unknown as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'car')) return false;
        const lock = getRegionalBlacklistEvent('car', normalizedCountry, new Date());
        if (lock.active) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'car', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0);

    const boats = (vehiclesData.boats as unknown as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'boat')) return false;
        const lock = getRegionalBlacklistEvent('boat', normalizedCountry, new Date());
        if (lock.active) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'boat', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0);

    const motorcycles = (((vehiclesData as any).motorcycles ?? []) as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'motorcycle')) return false;
        const lock = getRegionalBlacklistEvent('motorcycle', normalizedCountry, new Date());
        if (lock.active) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'motorcycle', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0);

    return [...cars, ...motorcycles, ...boats];
  },

  getPoliceVehicleEventStatus(): PoliceVehicleEventStatus {
    return getPoliceVehicleEventStatusForTime(new Date());
  },

  async getVehicleOpsIntelligence(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const now = new Date();
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, currentCountry: true },
    });
    if (!player) throw new Error('PLAYER_NOT_FOUND');
    const heatSnapshot = await getPlayerVehicleHeatSnapshot(playerId);
    const profile = await getPlayerVehicleOpsProfile(playerId);
    const heatByType: Record<VehicleOpsType, number> = {
      car: heatSnapshot.car,
      motorcycle: heatSnapshot.motorcycle,
      boat: heatSnapshot.boat,
    };
    const selectedHeat = heatByType[vehicleType];
    const policePattern = getDynamicPolicePatternForTime(now);
    const partsMarketPrices = getPartsMarketPrices(now, heatByType);
    const hotspotCooldown = await checkCooldown(playerId, hotspotActionTypeForVehicle(vehicleType));
    const crewCooldown = await checkCooldown(playerId, crewActionTypeForVehicle(vehicleType));
    const crewMatchCooldown = await checkCooldown(
      playerId,
      crewMatchActionTypeForVehicle(vehicleType)
    );
    const counterInterceptCooldown = await checkCooldown(
      playerId,
      counterInterceptActionTypeForVehicle(vehicleType)
    );
    const opsContractCooldown = await checkCooldown(
      playerId,
      opsContractActionTypeForVehicle(vehicleType)
    );
    const chopCooldown = await checkCooldown(playerId, chopActionTypeForVehicle(vehicleType));
    const [stealCooldownCar, stealCooldownMotorcycle, stealCooldownBoat] = await Promise.all([
      checkCooldown(playerId, 'vehicle_theft'),
      checkCooldown(playerId, 'motorcycle_theft'),
      checkCooldown(playerId, 'boat_theft'),
    ]);
    const chopContract = getChopContractForVehicleType(vehicleType, now);
    const blacklist = getRegionalBlacklistEvent(vehicleType, player.currentCountry ?? '', now);
    const crewMember = await prisma.crewMember.findUnique({
      where: { playerId },
      include: {
        crew: {
          include: {
            members: {
              select: { playerId: true },
            },
          },
        },
      },
    });
    const crewSize = crewMember?.crew?.members?.length ?? 0;
    const roleBonus = getCrewRoleOpsBonus(crewMember?.role);
    const repValue =
      vehicleType === 'motorcycle'
        ? profile.motorcycleRep
        : vehicleType === 'boat'
          ? profile.boatRep
          : profile.carRep;
    const repLevel = getVehicleOpsRepLevel(repValue);
    const seasonKey = getVehicleOpsSeasonKey(now);
    const seasonStats = await getVehicleOpsSeasonStats(playerId, vehicleType, seasonKey);
    const seasonTop = await getVehicleOpsSeasonTop(vehicleType, seasonKey, 10);
    const countryModifier = getCountryOpsModifiers(player.currentCountry ?? '', vehicleType, now);
    const contractsBoard = getVehicleOpsContractsBoard(
      vehicleType,
      now,
      repLevel,
      player.currentCountry ?? ''
    );
    const openInsuranceClaims = await getOpenVehicleInsuranceClaims(playerId, vehicleType);
    const theftSuccessBonus = repLevel >= 4 ? 0.04 : 0;
    const hotspotPayoutBonus = repLevel >= 1 ? 0.02 : 0;
    const hotspotFailReduction = repLevel >= 2 ? 0.03 : 0;
    const chopPayoutBonus = repLevel >= 3 ? 0.05 : 0;
    const insuranceActive =
      profile.insuranceVehicleType === vehicleType &&
      profile.insuranceExpiresAt != null &&
      profile.insuranceExpiresAt.getTime() > now.getTime();

    return {
      vehicleType,
      generatedAt: now.toISOString(),
      hotspots: [
        {
          id: `hotspot-${vehicleType}-primary`,
          nameNl:
            vehicleType === 'motorcycle'
              ? 'Smalle Steeg Raid'
              : vehicleType === 'boat'
                ? 'Dokkade Intercept'
                : 'Binnenstad Boost',
          nameEn:
            vehicleType === 'motorcycle'
              ? 'Narrow Alley Raid'
              : vehicleType === 'boat'
                ? 'Dockside Intercept'
                : 'Inner City Boost',
          rewardMin: vehicleType === 'motorcycle' ? 9000 : vehicleType === 'boat' ? 18000 : 11000,
          rewardMax: vehicleType === 'motorcycle' ? 21000 : vehicleType === 'boat' ? 39000 : 28000,
          cooldownSeconds:
            vehicleType === 'motorcycle' ? 1500 : vehicleType === 'boat' ? 2400 : 1800,
          cooldownRemainingSeconds: hotspotCooldown,
          riskMultiplier: Number(
            (policePattern.riskMultiplierByType[vehicleType] * (1 + selectedHeat / 140)).toFixed(3)
          ),
          interceptionWindowActive: isHotspotInterceptionWindow(now),
          payoutBonusPct: Math.round(hotspotPayoutBonus * 100),
          failReductionPct: Math.round(hotspotFailReduction * 100),
        },
      ],
      categoryHeat: {
        current: selectedHeat,
        level: classifyHeatLevel(selectedHeat),
        decayPerHour: 6,
        nextHourEstimate: Math.max(0, selectedHeat - 6),
      },
      policePattern: {
        code: policePattern.code,
        nameNl: policePattern.nameNl,
        nameEn: policePattern.nameEn,
        summaryNl: policePattern.summaryNl,
        summaryEn: policePattern.summaryEn,
        riskMultiplier: policePattern.riskMultiplierByType[vehicleType],
      },
      partsMarket: {
        prices: {
          car: Math.max(
            300,
            Math.round(partsMarketPrices.car * countryModifier.partsPriceMultiplier)
          ),
          motorcycle: Math.max(
            300,
            Math.round(partsMarketPrices.motorcycle * countryModifier.partsPriceMultiplier)
          ),
          boat: Math.max(
            300,
            Math.round(partsMarketPrices.boat * countryModifier.partsPriceMultiplier)
          ),
        },
        trend:
          partsMarketPrices[vehicleType] >=
          (vehicleType === 'boat' ? 2350 : vehicleType === 'motorcycle' ? 1180 : 1450)
            ? 'up'
            : 'down',
        refreshInSeconds: Math.max(30, 60 - now.getUTCSeconds()),
      },
      crewOp: {
        available: !!crewMember,
        requiresCrew: !crewMember,
        crewName: crewMember?.crew?.name ?? null,
        crewSize,
        playerRoleCode: roleBonus.roleCode,
        playerRoleNameNl: roleBonus.roleNameNl,
        playerRoleNameEn: roleBonus.roleNameEn,
        roleFailReductionPct: Math.round(Math.max(0, -roleBonus.failChanceDelta) * 100),
        rolePayoutBonusPct: Math.round(Math.max(0, roleBonus.payoutMultiplier - 1) * 100),
        cooldownRemainingSeconds: crewCooldown,
        rewardPersonalMin:
          vehicleType === 'boat' ? 21000 : vehicleType === 'motorcycle' ? 12000 : 15000,
        rewardPersonalMax:
          vehicleType === 'boat' ? 42000 : vehicleType === 'motorcycle' ? 26000 : 32000,
        crewBankSharePct: 30,
      },
      chopContract: {
        id: chopContract.contractId,
        vehicleType,
        vehicleTypeLabelNl: formatOpsVehicleLabel(vehicleType, 'nl'),
        vehicleTypeLabelEn: formatOpsVehicleLabel(vehicleType, 'en'),
        requiredCount: chopContract.requiredCount,
        minCondition: chopContract.minCondition,
        rewardMoney: chopContract.rewardMoney,
        expiresAt: chopContract.expiresAt.toISOString(),
        cooldownRemainingSeconds: chopCooldown,
      },
      opsReputation: {
        value: repValue,
        level: repLevel,
        perksNl: getOpsRepPerks(vehicleType, repLevel, true),
        perksEn: getOpsRepPerks(vehicleType, repLevel, false),
        unlockBonuses: {
          theftSuccessBonusPct: Math.round(theftSuccessBonus * 100),
          hotspotPayoutBonusPct: Math.round(hotspotPayoutBonus * 100),
          hotspotFailReductionPct: Math.round(hotspotFailReduction * 100),
          chopPayoutBonusPct: Math.round(chopPayoutBonus * 100),
        },
      },
      regionalBlacklist: blacklist,
      countryModifier: {
        code: countryModifier.modifierCode,
        nameNl: countryModifier.nameNl,
        nameEn: countryModifier.nameEn,
        payoutMultiplier: countryModifier.payoutMultiplier,
        riskDeltaPct: Math.round(countryModifier.riskDelta * 100),
        partsPriceMultiplier: countryModifier.partsPriceMultiplier,
      },
      hotspotInterception: {
        activeWindow: isHotspotInterceptionWindow(now),
        summaryNl: 'Tijdens actieve windows kan een rival speler je hotspot payout onderscheppen.',
        summaryEn:
          'During active windows, a rival player can intercept part of your hotspot payout.',
      },
      contrabandInsurance: {
        active: insuranceActive,
        tier: insuranceActive ? profile.insuranceTier : null,
        vehicleType: insuranceActive ? profile.insuranceVehicleType : null,
        expiresAt: insuranceActive ? (profile.insuranceExpiresAt?.toISOString() ?? null) : null,
        offers: [
          {
            tier: 'basic',
            durationHours: 12,
            price: vehicleType === 'boat' ? 22000 : vehicleType === 'motorcycle' ? 14000 : 17000,
            failCoveragePct: 30,
          },
          {
            tier: 'pro',
            durationHours: 24,
            price: vehicleType === 'boat' ? 46000 : vehicleType === 'motorcycle' ? 29000 : 36000,
            failCoveragePct: 50,
          },
        ],
        openClaims: openInsuranceClaims,
      },
      contractsBoard: {
        cooldownRemainingSeconds: opsContractCooldown,
        contracts: contractsBoard,
      },
      crewMatchmaking: {
        cooldownRemainingSeconds: crewMatchCooldown,
        seasonKey,
        current: seasonStats,
        top: seasonTop,
      },
      counterIntercept: {
        cooldownRemainingSeconds: counterInterceptCooldown,
        summaryNl: 'Counter-intercept laat je recent verlies deels terughalen bij rival ops.',
        summaryEn: 'Counter-intercept lets you recover part of recent losses from rival ops.',
      },
      laneTheftCooldowns: {
        car: stealCooldownCar,
        motorcycle: stealCooldownMotorcycle,
        boat: stealCooldownBoat,
      },
    };
  },

  async runVehicleHotspotOp(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = hotspotActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'HOTSPOT_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, currentCountry: true, wantedLevel: true, money: true },
    });
    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }
    const blacklist = getRegionalBlacklistEvent(
      vehicleType,
      player.currentCountry ?? '',
      new Date()
    );
    if (blacklist.active) {
      return {
        success: false,
        message: 'REGIONAL_BLACKLIST_ACTIVE',
        reasonNl: blacklist.reasonNl,
        reasonEn: blacklist.reasonEn,
        endsAt: blacklist.endsAt,
      };
    }

    const remainingJailTime = await checkIfJailed(playerId);
    if (remainingJailTime > 0) {
      return {
        success: false,
        message: 'PLAYER_JAILED',
        remainingJailTime,
      };
    }

    const countryModifier = getCountryOpsModifiers(
      player.currentCountry ?? '',
      vehicleType,
      new Date()
    );
    const heat = await getPlayerVehicleHeatSnapshot(playerId);
    const profile = await getPlayerVehicleOpsProfile(playerId);
    const repValue =
      vehicleType === 'motorcycle'
        ? profile.motorcycleRep
        : vehicleType === 'boat'
          ? profile.boatRep
          : profile.carRep;
    const repLevel = getVehicleOpsRepLevel(repValue);
    const hotspotPayoutBonus = repLevel >= 1 ? 0.02 : 0;
    const hotspotFailReduction = repLevel >= 2 ? 0.03 : 0;
    const insuranceActive =
      profile.insuranceVehicleType === vehicleType &&
      profile.insuranceExpiresAt != null &&
      profile.insuranceExpiresAt.getTime() > Date.now();
    const insuranceCoveragePct =
      insuranceActive && profile.insuranceTier === 'pro' ? 0.5 : insuranceActive ? 0.3 : 0;
    const selectedHeat =
      vehicleType === 'motorcycle'
        ? heat.motorcycle
        : vehicleType === 'boat'
          ? heat.boat
          : heat.car;
    const pattern = getDynamicPolicePatternForTime(new Date());
    const baseRisk = vehicleType === 'boat' ? 0.36 : vehicleType === 'motorcycle' ? 0.27 : 0.3;
    const heatRisk = Math.min(0.2, selectedHeat * 0.003);
    const patternRisk = Math.max(0, pattern.riskMultiplierByType[vehicleType] - 1);
    const failChance = Math.min(
      0.9,
      Math.max(
        0.05,
        baseRisk + heatRisk + patternRisk + countryModifier.riskDelta - hotspotFailReduction
      )
    );
    const success = Math.random() > failChance;

    await setCooldown(playerId, cooldownType);

    if (!success) {
      await increasePlayerVehicleHeat(playerId, vehicleType, 8);
      const insurancePayout =
        insuranceCoveragePct > 0
          ? Math.round(
              (vehicleType === 'boat' ? 28000 : vehicleType === 'motorcycle' ? 15000 : 19000) *
                insuranceCoveragePct
            )
          : 0;
      if (insurancePayout > 0) {
        await createVehicleInsuranceClaim({
          playerId,
          vehicleType,
          claimType: 'HOTSPOT_FAIL',
          payoutAmount: insurancePayout,
          riskScore: Math.round(failChance * 100),
          context: {
            country: player.currentCountry ?? null,
            riskDelta: countryModifier.riskDelta,
            pattern: pattern.code,
          },
        });
      }
      const updatedOnFail = await prisma.player.update({
        where: { id: playerId },
        data: {
          money: insurancePayout > 0 ? { increment: insurancePayout } : undefined,
          wantedLevel: Math.min(100, Math.round((player.wantedLevel ?? 0) + 3)),
        },
        select: { money: true },
      });
      await activityService.logActivity(
        playerId,
        'VEHICLE_OPS_HOTSPOT',
        `Hotspot ${vehicleType} failed`,
        {
          success: false,
          vehicleType,
          insurancePayout,
          failChance,
          country: player.currentCountry ?? null,
          modifierCode: countryModifier.modifierCode,
        },
        true
      );
      return {
        success: false,
        message: 'HOTSPOT_FAILED',
        insurancePayout,
        newMoney: updatedOnFail.money,
        cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
        riskLevel: failChance,
      };
    }

    const rewardMin = vehicleType === 'boat' ? 18000 : vehicleType === 'motorcycle' ? 9000 : 11000;
    const rewardMax = vehicleType === 'boat' ? 39000 : vehicleType === 'motorcycle' ? 21000 : 28000;
    const baseReward = rewardMin + Math.floor(Math.random() * (rewardMax - rewardMin + 1));
    let rewardMoney = Math.round(
      baseReward * (1 + hotspotPayoutBonus) * countryModifier.payoutMultiplier
    );
    let interceptedByPlayerId: number | null = null;
    let interceptedAmount = 0;
    if (isHotspotInterceptionWindow(new Date()) && Math.random() < 0.2) {
      const candidates = await prisma.player.findMany({
        where: {
          id: { not: playerId },
          currentCountry: player.currentCountry ?? undefined,
          isBanned: false,
        },
        select: { id: true },
        take: 50,
      });
      if (candidates.length > 0) {
        const actorCrew = await prisma.crewMember.findUnique({
          where: { playerId },
          select: { crewId: true },
        });
        let eligible = candidates.map((c) => c.id);
        if (actorCrew?.crewId) {
          const sameCrewRows = await prisma.crewMember.findMany({
            where: {
              crewId: actorCrew.crewId,
              playerId: { in: eligible },
            },
            select: { playerId: true },
          });
          const sameCrewIds = new Set(sameCrewRows.map((r) => r.playerId));
          eligible = eligible.filter((id) => !sameCrewIds.has(id));
        }
        if (eligible.length > 0) {
          interceptedByPlayerId = eligible[Math.floor(Math.random() * eligible.length)];
          interceptedAmount = Math.max(1, Math.round(rewardMoney * 0.25));
          rewardMoney = Math.max(1, rewardMoney - interceptedAmount);
        }
      }
    }

    const txActions: Promise<unknown>[] = [
      prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: rewardMoney } },
        select: { money: true },
      }),
    ];
    if (interceptedByPlayerId != null && interceptedAmount > 0) {
      txActions.push(
        prisma.player.update({
          where: { id: interceptedByPlayerId },
          data: { money: { increment: interceptedAmount } },
        })
      );
    }
    const [updatedPlayer] = (await prisma.$transaction(txActions)) as Array<{ money: number }>;
    await increasePlayerVehicleHeat(playerId, vehicleType, 5);
    await addVehicleOpsRep(playerId, vehicleType, 18);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_HOTSPOT',
      `Hotspot ${vehicleType} success`,
      {
        success: true,
        vehicleType,
        rewardMoney,
        interceptedByPlayerId,
        interceptedAmount,
        hotspotPayoutBonusPct: Math.round(hotspotPayoutBonus * 100),
        country: player.currentCountry ?? null,
        modifierCode: countryModifier.modifierCode,
      },
      true
    );
    if (interceptedByPlayerId != null && interceptedAmount > 0) {
      await activityService.logActivity(
        interceptedByPlayerId,
        'VEHICLE_OPS_INTERCEPT',
        `Intercepted hotspot payout (${formatOpsVehicleLabel(vehicleType, 'en')})`,
        {
          success: true,
          vehicleType,
          interceptedFromPlayerId: playerId,
          amount: interceptedAmount,
          country: player.currentCountry ?? null,
        },
        false
      );
    }

    return {
      success: true,
      message: 'HOTSPOT_SUCCESS',
      rewardMoney,
      interceptedByPlayerId,
      interceptedAmount,
      newMoney: updatedPlayer.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
    };
  },

  async runVehicleCrewOp(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = crewActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'CREW_OP_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const crewMember = await prisma.crewMember.findUnique({
      where: { playerId },
      include: {
        crew: {
          include: {
            members: { select: { playerId: true } },
          },
        },
      },
    });
    if (!crewMember?.crew) {
      return {
        success: false,
        message: 'CREW_REQUIRED',
      };
    }
    const playerRow = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    const blacklist = getRegionalBlacklistEvent(
      vehicleType,
      playerRow?.currentCountry ?? '',
      new Date()
    );
    if (blacklist.active) {
      return {
        success: false,
        message: 'REGIONAL_BLACKLIST_ACTIVE',
        reasonNl: blacklist.reasonNl,
        reasonEn: blacklist.reasonEn,
        endsAt: blacklist.endsAt,
      };
    }
    const roleBonus = getCrewRoleOpsBonus(crewMember.role);
    const profile = await getPlayerVehicleOpsProfile(playerId);
    const countryModifier = getCountryOpsModifiers(
      playerRow?.currentCountry ?? '',
      vehicleType,
      new Date()
    );
    const repValue =
      vehicleType === 'motorcycle'
        ? profile.motorcycleRep
        : vehicleType === 'boat'
          ? profile.boatRep
          : profile.carRep;
    const repLevel = getVehicleOpsRepLevel(repValue);

    await setCooldown(playerId, cooldownType);

    const crewSize = Math.max(1, crewMember.crew.members.length);
    const rewardMin = vehicleType === 'boat' ? 30000 : vehicleType === 'motorcycle' ? 17000 : 22000;
    const rewardMax = vehicleType === 'boat' ? 62000 : vehicleType === 'motorcycle' ? 34000 : 47000;
    const rawReward = rewardMin + Math.floor(Math.random() * (rewardMax - rewardMin + 1));
    const scaledReward = Math.round(
      rawReward *
        Math.min(1.35, 1 + (crewSize - 1) * 0.05) *
        roleBonus.payoutMultiplier *
        (repLevel >= 1 ? 1.02 : 1) *
        countryModifier.payoutMultiplier
    );
    const crewBankShare = Math.round(scaledReward * 0.3);
    const personalShare = scaledReward - crewBankShare;

    const failChance = Math.max(
      0.08,
      0.32 -
        Math.min(0.12, (crewSize - 1) * 0.02) +
        roleBonus.failChanceDelta +
        countryModifier.riskDelta
    );
    const success = Math.random() > failChance;

    if (!success) {
      await increasePlayerVehicleHeat(playerId, vehicleType, 7);
      await activityService.logActivity(
        playerId,
        'VEHICLE_OPS_CREW',
        `Crew op ${vehicleType} failed`,
        {
          success: false,
          vehicleType,
          roleCode: roleBonus.roleCode,
          country: playerRow?.currentCountry ?? null,
          modifierCode: countryModifier.modifierCode,
        },
        true
      );
      return {
        success: false,
        message: 'CREW_OP_FAILED',
        cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
      };
    }

    const [updatedPlayer] = await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: personalShare } },
        select: { money: true },
      }),
      prisma.crew.update({
        where: { id: crewMember.crewId },
        data: { bankBalance: { increment: crewBankShare } },
      }),
    ]);
    await increasePlayerVehicleHeat(playerId, vehicleType, 4);
    await addVehicleOpsRep(playerId, vehicleType, 15);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_CREW',
      `Crew op ${vehicleType} success`,
      {
        success: true,
        vehicleType,
        personalShare,
        crewBankShare,
        roleCode: roleBonus.roleCode,
        country: playerRow?.currentCountry ?? null,
        modifierCode: countryModifier.modifierCode,
      },
      true
    );

    return {
      success: true,
      message: 'CREW_OP_SUCCESS',
      personalShare,
      crewBankShare,
      roleCode: roleBonus.roleCode,
      roleNameNl: roleBonus.roleNameNl,
      roleNameEn: roleBonus.roleNameEn,
      newMoney: updatedPlayer.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
      crewName: crewMember.crew.name,
    };
  },

  async buyVehiclePartsFromOpsMarket(playerId: number, requestedType: string, quantity: number) {
    const partsType = normalizeOpsVehicleType(requestedType);
    const safeQuantity = Math.max(1, Math.min(100, Math.floor(quantity)));
    const heatSnapshot = await getPlayerVehicleHeatSnapshot(playerId);
    const prices = getPartsMarketPrices(new Date(), {
      car: heatSnapshot.car,
      motorcycle: heatSnapshot.motorcycle,
      boat: heatSnapshot.boat,
    });
    const unitPrice = prices[partsType];
    const totalCost = unitPrice * safeQuantity;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, money: true, currentCountry: true },
    });
    if (!player) throw new Error('PLAYER_NOT_FOUND');
    if ((player.money ?? 0) < totalCost) {
      return {
        success: false,
        message: 'INSUFFICIENT_FUNDS',
        unitPrice,
        totalCost,
      };
    }

    await ensurePlayerPartsRow(playerId);
    const [updatedPlayer] = await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: {
          money: { decrement: totalCost },
        },
        select: { money: true },
      }),
      (async () => {
        if (partsType === 'boat') {
          await prisma.$executeRaw`
            UPDATE player_vehicle_parts
            SET boat_parts = boat_parts + ${safeQuantity}
            WHERE player_id = ${playerId}
          `;
        } else if (partsType === 'motorcycle') {
          await prisma.$executeRaw`
            UPDATE player_vehicle_parts
            SET motorcycle_parts = motorcycle_parts + ${safeQuantity}
            WHERE player_id = ${playerId}
          `;
        } else {
          await prisma.$executeRaw`
            UPDATE player_vehicle_parts
            SET car_parts = car_parts + ${safeQuantity}
            WHERE player_id = ${playerId}
          `;
        }
      })(),
    ]);

    const parts = await getPlayerPartsInventory(playerId);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_PARTS',
      `Bought ${safeQuantity} ${partsType} parts`,
      {
        success: true,
        vehicleType: partsType,
        quantity: safeQuantity,
        unitPrice,
        totalCost,
        country: player.currentCountry ?? null,
      },
      false
    );
    return {
      success: true,
      message: 'PARTS_PURCHASED',
      unitPrice,
      quantity: safeQuantity,
      totalCost,
      newMoney: updatedPlayer.money,
      parts,
      partsType,
    };
  },

  async claimVehicleChopContract(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = chopActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'CHOP_CONTRACT_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const contract = getChopContractForVehicleType(vehicleType, new Date());
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    const blacklist = getRegionalBlacklistEvent(
      vehicleType,
      player?.currentCountry ?? '',
      new Date()
    );
    if (blacklist.active) {
      return {
        success: false,
        message: 'REGIONAL_BLACKLIST_ACTIVE',
        reasonNl: blacklist.reasonNl,
        reasonEn: blacklist.reasonEn,
        endsAt: blacklist.endsAt,
      };
    }
    const candidate = await prisma.vehicleInventory.findFirst({
      where: {
        playerId,
        vehicleType,
        marketListing: false,
        transportStatus: null,
        repairInProgress: false,
        condition: {
          gte: contract.minCondition,
        },
      },
      orderBy: [{ condition: 'asc' }, { id: 'asc' }],
    });

    if (!candidate) {
      return {
        success: false,
        message: 'NO_ELIGIBLE_VEHICLE',
        minCondition: contract.minCondition,
      };
    }

    await setCooldown(playerId, cooldownType);
    const [updatedPlayer] = await prisma.$transaction([
      prisma.vehicleInventory.delete({
        where: { id: candidate.id },
      }),
      prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: contract.rewardMoney } },
        select: { money: true },
      }),
    ]);

    await increasePlayerVehicleHeat(playerId, vehicleType, 4);
    await addVehicleOpsRep(playerId, vehicleType, 12);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_CHOP',
      `Claimed chop contract for ${vehicleType}`,
      {
        success: true,
        vehicleType,
        rewardMoney: contract.rewardMoney,
        removedInventoryId: candidate.id,
        country: player?.currentCountry ?? null,
      },
      true
    );

    return {
      success: true,
      message: 'CHOP_CONTRACT_CLAIMED',
      rewardMoney: contract.rewardMoney,
      removedInventoryId: candidate.id,
      newMoney: updatedPlayer.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
    };
  },

  async purchaseContrabandInsurance(playerId: number, requestedType: string, tier: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const normalizedTier = (tier || '').toLowerCase() === 'pro' ? 'pro' : 'basic';
    const price =
      normalizedTier === 'pro'
        ? vehicleType === 'boat'
          ? 46000
          : vehicleType === 'motorcycle'
            ? 29000
            : 36000
        : vehicleType === 'boat'
          ? 22000
          : vehicleType === 'motorcycle'
            ? 14000
            : 17000;
    const durationHours = normalizedTier === 'pro' ? 24 : 12;
    const now = new Date();
    const expiresAt = new Date(now.getTime() + durationHours * 60 * 60 * 1000);

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, currentCountry: true },
    });
    if (!player) throw new Error('PLAYER_NOT_FOUND');
    if ((player.money ?? 0) < price) {
      return {
        success: false,
        message: 'INSUFFICIENT_FUNDS',
        price,
      };
    }

    await ensurePlayerVehicleOpsProfileRow(playerId);
    const [updatedPlayer] = await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: price } },
        select: { money: true },
      }),
      prisma.$executeRaw`
        UPDATE player_vehicle_ops_profile
        SET insurance_vehicle_type = ${vehicleType},
            insurance_tier = ${normalizedTier},
            insurance_expires_at = ${expiresAt}
        WHERE player_id = ${playerId}
      `,
    ]);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_INSURANCE',
      `Purchased ${normalizedTier} insurance for ${vehicleType}`,
      {
        success: true,
        vehicleType,
        tier: normalizedTier,
        price,
        expiresAt: expiresAt.toISOString(),
        country: player.currentCountry ?? null,
      },
      false
    );

    return {
      success: true,
      message: 'INSURANCE_PURCHASED',
      price,
      tier: normalizedTier,
      vehicleType,
      expiresAt: expiresAt.toISOString(),
      newMoney: updatedPlayer.money,
    };
  },

  async runVehicleCounterIntercept(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = counterInterceptActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'COUNTER_INTERCEPT_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, currentCountry: true },
    });
    if (!player) throw new Error('PLAYER_NOT_FOUND');

    const recentInterceptLogs = await prisma.playerActivity.findMany({
      where: {
        activityType: 'VEHICLE_OPS_INTERCEPT',
        createdAt: {
          gte: new Date(Date.now() - 48 * 60 * 60 * 1000),
        },
      },
      select: {
        playerId: true,
        details: true,
      },
      orderBy: { createdAt: 'desc' },
      take: 200,
    });

    let rivalTargetId: number | null = null;
    for (const log of recentInterceptLogs) {
      try {
        const parsed =
          typeof log.details === 'string'
            ? ((JSON.parse(log.details || '{}') as Record<string, unknown>) ?? {})
            : {};
        const interceptedFrom = Number(parsed.interceptedFromPlayerId ?? 0);
        const interceptedType = String(parsed.vehicleType ?? 'car');
        if (
          interceptedFrom === playerId &&
          normalizeOpsVehicleType(interceptedType) === vehicleType
        ) {
          rivalTargetId = log.playerId;
          break;
        }
      } catch {
        continue;
      }
    }

    if (!rivalTargetId) {
      return {
        success: false,
        message: 'NO_RECENT_INTERCEPT_TARGET',
      };
    }

    await setCooldown(playerId, cooldownType);

    const countryModifier = getCountryOpsModifiers(
      player.currentCountry ?? '',
      vehicleType,
      new Date()
    );
    const successChance = Math.max(0.2, Math.min(0.82, 0.56 - countryModifier.riskDelta));
    const success = Math.random() <= successChance;
    if (!success) {
      await increasePlayerVehicleHeat(playerId, vehicleType, 6);
      await activityService.logActivity(
        playerId,
        'VEHICLE_OPS_COUNTER_INTERCEPT',
        `Counter-intercept ${vehicleType} failed`,
        {
          success: false,
          vehicleType,
          rivalTargetId,
          country: player.currentCountry ?? null,
        },
        true
      );
      return {
        success: false,
        message: 'COUNTER_INTERCEPT_FAILED',
        cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
      };
    }

    const stolenBack = Math.round(
      (vehicleType === 'boat' ? 36000 : vehicleType === 'motorcycle' ? 21000 : 28000) *
        countryModifier.payoutMultiplier
    );
    const [updatedActor] = (await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: stolenBack } },
        select: { money: true },
      }),
      prisma.player.update({
        where: { id: rivalTargetId },
        data: { money: { decrement: Math.min(stolenBack, 25000) } },
      }),
    ])) as Array<{ money: number }>;

    await increasePlayerVehicleHeat(playerId, vehicleType, 3);
    await addVehicleOpsRep(playerId, vehicleType, 12);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_COUNTER_INTERCEPT',
      `Counter-intercept ${vehicleType} success`,
      {
        success: true,
        vehicleType,
        rivalTargetId,
        rewardMoney: stolenBack,
        country: player.currentCountry ?? null,
      },
      true
    );

    return {
      success: true,
      message: 'COUNTER_INTERCEPT_SUCCESS',
      rivalTargetId,
      rewardMoney: stolenBack,
      newMoney: updatedActor.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
    };
  },

  async runVehicleCrewMatch(playerId: number, requestedType: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = crewMatchActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'CREW_MATCH_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const actorCrew = await prisma.crewMember.findUnique({
      where: { playerId },
      include: { crew: { include: { members: { select: { playerId: true } } } } },
    });
    if (!actorCrew?.crew) {
      return {
        success: false,
        message: 'CREW_REQUIRED',
      };
    }
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    const seasonKey = getVehicleOpsSeasonKey(new Date());
    const actorStats = await getVehicleOpsSeasonStats(playerId, vehicleType, seasonKey);
    const actorPoints = actorStats.points;

    const candidates = await prisma.crewMember.findMany({
      where: {
        playerId: { not: playerId },
      },
      include: {
        player: {
          select: {
            id: true,
            username: true,
            currentCountry: true,
            isBanned: true,
          },
        },
      },
      take: 120,
    });
    const actorCrewId = actorCrew.crewId;
    const eligible = candidates.filter(
      (row) =>
        row.crewId !== actorCrewId &&
        row.player?.isBanned !== true &&
        row.player?.currentCountry === (player?.currentCountry ?? null)
    );
    if (eligible.length === 0) {
      return {
        success: false,
        message: 'NO_CREW_MATCH_OPPONENT',
      };
    }

    const sampled = eligible[Math.floor(Math.random() * eligible.length)];
    const rivalPlayerId = sampled.playerId;
    const rivalName = sampled.player?.username ?? `Player ${rivalPlayerId}`;
    const rivalStats = await getVehicleOpsSeasonStats(rivalPlayerId, vehicleType, seasonKey);

    await setCooldown(playerId, cooldownType);
    const countryModifier = getCountryOpsModifiers(
      player?.currentCountry ?? '',
      vehicleType,
      new Date()
    );
    const diff = Math.max(-350, Math.min(350, rivalStats.points - actorPoints));
    const baseChance = 0.5 + diff / 1600;
    const successChance = Math.max(0.18, Math.min(0.84, baseChance - countryModifier.riskDelta));
    const win = Math.random() <= successChance;

    const winnerDelta = win ? 26 : -18;
    const loserDelta = win ? -18 : 24;
    await updateVehicleOpsSeasonStats(
      playerId,
      vehicleType,
      seasonKey,
      winnerDelta,
      win ? 1 : 0,
      win ? 0 : 1
    );
    await updateVehicleOpsSeasonStats(
      rivalPlayerId,
      vehicleType,
      seasonKey,
      loserDelta,
      win ? 0 : 1,
      win ? 1 : 0
    );

    const rewardMoney = win
      ? Math.round(
          (vehicleType === 'boat' ? 34000 : vehicleType === 'motorcycle' ? 19000 : 26000) *
            countryModifier.payoutMultiplier
        )
      : Math.round(
          (vehicleType === 'boat' ? 9000 : vehicleType === 'motorcycle' ? 6000 : 7500) *
            countryModifier.payoutMultiplier
        );
    const updatedPlayer = await prisma.player.update({
      where: { id: playerId },
      data: { money: { increment: rewardMoney } },
      select: { money: true },
    });
    await addVehicleOpsRep(playerId, vehicleType, win ? 16 : 8);
    await increasePlayerVehicleHeat(playerId, vehicleType, win ? 4 : 6);

    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_CREW_MATCH',
      `Crew match ${vehicleType} ${win ? 'won' : 'lost'}`,
      {
        success: win,
        vehicleType,
        seasonKey,
        rivalPlayerId,
        rivalName,
        rewardMoney,
        country: player?.currentCountry ?? null,
      },
      true
    );

    return {
      success: true,
      message: win ? 'CREW_MATCH_WON' : 'CREW_MATCH_LOST',
      seasonKey,
      rivalPlayerId,
      rivalName,
      rewardMoney,
      pointsDelta: winnerDelta,
      newMoney: updatedPlayer.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
      leaderboard: await getVehicleOpsSeasonTop(vehicleType, seasonKey, 10),
    };
  },

  async runVehicleOpsContract(playerId: number, requestedType: string, contractId?: string) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    const cooldownType = opsContractActionTypeForVehicle(vehicleType);
    const cooldownRemainingSeconds = await checkCooldown(playerId, cooldownType);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: 'OPS_CONTRACT_COOLDOWN',
        cooldownRemainingSeconds,
      };
    }

    const now = new Date();
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    const profile = await getPlayerVehicleOpsProfile(playerId);
    const repValue =
      vehicleType === 'motorcycle'
        ? profile.motorcycleRep
        : vehicleType === 'boat'
          ? profile.boatRep
          : profile.carRep;
    const repLevel = getVehicleOpsRepLevel(repValue);
    const board = getVehicleOpsContractsBoard(
      vehicleType,
      now,
      repLevel,
      player?.currentCountry ?? ''
    );
    const contract = board.find((item) => item.contractId === contractId) ?? board[0];
    if (!contract) {
      return {
        success: false,
        message: 'NO_CONTRACT_AVAILABLE',
      };
    }
    if (repLevel < contract.minRepLevel) {
      return {
        success: false,
        message: 'OPS_CONTRACT_REP_REQUIRED',
        minRepLevel: contract.minRepLevel,
      };
    }

    const countryModifier = getCountryOpsModifiers(player?.currentCountry ?? '', vehicleType, now);
    const failChance = Math.max(
      0.06,
      Math.min(0.92, contract.failChance + countryModifier.riskDelta)
    );
    const success = Math.random() > failChance;
    await setCooldown(playerId, cooldownType);

    if (!success) {
      await increasePlayerVehicleHeat(
        playerId,
        vehicleType,
        contract.tier === 'legendary' ? 11 : 8
      );
      await activityService.logActivity(
        playerId,
        'VEHICLE_OPS_CONTRACT',
        `Ops contract ${contract.contractId} failed`,
        {
          success: false,
          vehicleType,
          contractId: contract.contractId,
          tier: contract.tier,
          country: player?.currentCountry ?? null,
        },
        true
      );
      return {
        success: false,
        message: 'OPS_CONTRACT_FAILED',
        contractId: contract.contractId,
        cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
      };
    }

    const rewardMoney = Math.round(contract.rewardMoney * countryModifier.payoutMultiplier);
    const updatedPlayer = await prisma.player.update({
      where: { id: playerId },
      data: { money: { increment: rewardMoney } },
      select: { money: true },
    });
    await addVehicleOpsRep(
      playerId,
      vehicleType,
      contract.tier === 'legendary' ? 30 : contract.tier === 'high_risk' ? 20 : 14
    );
    await increasePlayerVehicleHeat(playerId, vehicleType, contract.tier === 'legendary' ? 7 : 4);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_CONTRACT',
      `Ops contract ${contract.contractId} completed`,
      {
        success: true,
        vehicleType,
        contractId: contract.contractId,
        tier: contract.tier,
        rewardMoney,
        country: player?.currentCountry ?? null,
      },
      true
    );

    return {
      success: true,
      message: 'OPS_CONTRACT_COMPLETED',
      contractId: contract.contractId,
      tier: contract.tier,
      rewardMoney,
      newMoney: updatedPlayer.money,
      cooldownRemainingSeconds: await checkCooldown(playerId, cooldownType),
    };
  },

  async resolveVehicleInsuranceClaim(
    playerId: number,
    requestedType: string,
    claimId: number,
    action: string
  ) {
    const vehicleType = normalizeOpsVehicleType(requestedType);
    await ensureVehicleOpsInsuranceClaimsTable();
    const rows = await prisma.$queryRaw<VehicleOpsInsuranceClaimRow[]>`
      SELECT id, player_id, vehicle_type, claim_type, status, payout_amount, risk_score, context_json, created_at, updated_at
      FROM player_vehicle_ops_insurance_claims
      WHERE id = ${claimId}
        AND player_id = ${playerId}
        AND vehicle_type = ${vehicleType}
      LIMIT 1
    `;
    const claim = rows[0];
    if (!claim) {
      return {
        success: false,
        message: 'CLAIM_NOT_FOUND',
      };
    }
    if (claim.status !== 'REVIEW') {
      return {
        success: false,
        message: 'CLAIM_ALREADY_RESOLVED',
      };
    }

    const normalizedAction = (action || '').toLowerCase() === 'contest' ? 'contest' : 'accept';
    if (normalizedAction === 'accept') {
      await prisma.$executeRaw`
        UPDATE player_vehicle_ops_insurance_claims
        SET status = 'SETTLED'
        WHERE id = ${claimId}
      `;
      return {
        success: true,
        message: 'CLAIM_SETTLED',
      };
    }

    const riskScore = Number(claim.risk_score ?? 0);
    const winChance = Math.max(0.15, Math.min(0.75, 0.62 - riskScore / 220));
    const won = Math.random() <= winChance;
    const payoutAmount = Number(claim.payout_amount ?? 0);
    const bonus = won ? Math.round(payoutAmount * 0.2) : 0;
    const fine = won ? 0 : Math.round(Math.min(payoutAmount * 0.12, 15000));

    await prisma.$transaction([
      prisma.$executeRaw`
        UPDATE player_vehicle_ops_insurance_claims
        SET status = ${won ? 'APPROVED' : 'REJECTED'}
        WHERE id = ${claimId}
      `,
      prisma.player.update({
        where: { id: playerId },
        data: {
          money: won ? { increment: bonus } : { decrement: fine },
        },
      }),
    ]);

    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_INSURANCE_DISPUTE',
      `Insurance dispute ${won ? 'approved' : 'rejected'} (${vehicleType})`,
      {
        success: won,
        vehicleType,
        claimId,
        bonus,
        fine,
      },
      false
    );

    return {
      success: true,
      message: won ? 'CLAIM_CONTEST_APPROVED' : 'CLAIM_CONTEST_REJECTED',
      bonus,
      fine,
    };
  },

  /**
   * Steal a vehicle
   */
  async stealVehicle(
    playerId: number,
    vehicleId: string
  ): Promise<{
    success: boolean;
    message: string;
    vehicle?: any;
    arrested?: boolean;
    jailTime?: number;
    bail?: number;
    wantedLevel?: number;
    xpGained?: number;
    newXp?: number;
    newRank?: number;
    reputation?: number;
    newlyUnlockedAchievements?: any[];
    arrestedAfterTheft?: boolean;
    vehicleConfiscated?: boolean;
    cooldownRemainingSeconds?: number;
    sessionPayoutMultiplier?: number;
    sessionAttemptsInWindow?: number;
    sessionWindowMinutes?: number;
  }> {
    console.log(`\n====== [STEAL FUNCTION START] vehicleId="${vehicleId}" ======`);

    // Get player data
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        id: true,
        rank: true,
        xp: true,
        currentCountry: true,
        wantedLevel: true,
        health: true,
      },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const remainingJailTime = await checkIfJailed(playerId);
    if (remainingJailTime > 0) {
      return {
        success: false,
        message: `Je zit nog ${Math.ceil(remainingJailTime / 60)} minuten in de gevangenis.`,
      };
    }

    // Check health
    if (player.health <= 0) {
      return {
        success: false,
        message: 'Je bent dood! Je kunt geen voertuigen stelen.',
      };
    }

    // Determine vehicle type - simple and unambiguous
    const carMatch = vehiclesData.cars.find((c: any) => c.id === vehicleId);
    const boatMatch = vehiclesData.boats.find((b: any) => b.id === vehicleId);
    const motorcycleMatch = (((vehiclesData as any).motorcycles ?? []) as any[]).find(
      (m: any) => m.id === vehicleId
    );

    console.log(
      `[DETECT] carMatch: ${carMatch ? carMatch.name : 'NO'}, boatMatch: ${boatMatch ? boatMatch.name : 'NO'}`
    );

    let vehicleType: 'car' | 'boat' | 'motorcycle';
    let vehicleDef: any;

    if (carMatch && !boatMatch && !motorcycleMatch) {
      vehicleType = 'car';
      vehicleDef = carMatch;
    } else if (boatMatch && !carMatch && !motorcycleMatch) {
      vehicleType = 'boat';
      vehicleDef = boatMatch;
    } else if (motorcycleMatch && !carMatch && !boatMatch) {
      vehicleType = 'motorcycle';
      vehicleDef = motorcycleMatch;
    } else if ((carMatch ? 1 : 0) + (boatMatch ? 1 : 0) + (motorcycleMatch ? 1 : 0) > 1) {
      console.error(`CRITICAL: vehicleId "${vehicleId}" found in BOTH arrays!`);
      return {
        success: false,
        message: 'Database error: voertuig in twee categorieën',
      };
    } else {
      return {
        success: false,
        message: 'Dit voertuig bestaat niet',
      };
    }

    console.log(`[DETECT RESULT] type=${vehicleType}, name=${vehicleDef.name}\n`);

    if (isEventOnlyVehicle(vehicleDef)) {
      const policeEventStatus = getPoliceVehicleEventStatusForTime(new Date());
      const categoryMatches =
        policeEventStatus.activeCategory == null ||
        policeEventStatus.activeCategory === vehicleType;
      if (!policeEventStatus.active || !categoryMatches) {
        return {
          success: false,
          message: 'Dit speciale politievoertuig is alleen tijdens actieve events te stelen.',
        };
      }
    }

    const regionalBlacklist = getRegionalBlacklistEvent(
      vehicleType,
      player.currentCountry ?? '',
      new Date()
    );
    if (regionalBlacklist.active) {
      return {
        success: false,
        message: regionalBlacklist.reasonNl ?? 'Regionale blokkade actief voor dit voertuigtype.',
      };
    }

    const opsProfile = await getPlayerVehicleOpsProfile(playerId);
    const opsRepValue =
      vehicleType === 'motorcycle'
        ? opsProfile.motorcycleRep
        : vehicleType === 'boat'
          ? opsProfile.boatRep
          : opsProfile.carRep;
    const opsRepLevel = getVehicleOpsRepLevel(opsRepValue);
    const theftRepBonus = opsRepLevel >= 4 ? 0.04 : 0;
    const theftInsuranceActive =
      opsProfile.insuranceVehicleType === vehicleType &&
      opsProfile.insuranceExpiresAt != null &&
      opsProfile.insuranceExpiresAt.getTime() > Date.now();
    const theftInsuranceCoverage =
      theftInsuranceActive && opsProfile.insuranceTier === 'pro'
        ? 0.25
        : theftInsuranceActive
          ? 0.15
          : 0;

    const logVehicleTheftActivity = async (
      description: string,
      details: Record<string, unknown>
    ) => {
      try {
        await activityService.logActivity(playerId, 'VEHICLE_THEFT', description, details, true);
      } catch (error) {
        console.error('[VehicleService] Failed to log vehicle theft activity', error);
      }
    };

    const applyVehicleArrest = async (jailTime: number, confiscatedInventoryId?: number) => {
      const now = new Date();
      const jailReleaseTime = new Date(now.getTime() + jailTime * 60 * 1000);

      await prisma.$transaction(async (tx) => {
        if (confiscatedInventoryId != null) {
          await tx.vehicleInventory.deleteMany({
            where: {
              id: confiscatedInventoryId,
              playerId,
            },
          });
        }

        await tx.crimeAttempt.create({
          data: {
            playerId,
            crimeId: 'police_arrest',
            success: false,
            reward: 0,
            xpGained: 0,
            jailed: true,
            jailTime,
          },
        });

        await tx.player.update({
          where: { id: playerId },
          data: {
            jailRelease: jailReleaseTime,
            wantedLevel: 0,
          },
        });
      });

      await activityService.logActivity(
        playerId,
        'ARREST',
        `Arrested during vehicle theft for ${jailTime} minutes`,
        {
          authority: 'Police',
          source: 'VEHICLE_THEFT',
          jailTime,
          jailedUntil: jailReleaseTime.toISOString(),
        },
        true
      );

      void notificationService.sendArrestAwaitingHelpNotifications(
        playerId,
        jailTime,
        'Police',
        'VEHICLE_THEFT'
      );
    };

    // Check rank requirements
    if (vehicleType === 'car' && player.rank < 5) {
      return {
        success: false,
        message: "Je moet minimaal rank 5 zijn om auto's te stelen",
      };
    }

    if (vehicleType === 'boat' && player.rank < 10) {
      return {
        success: false,
        message: 'Je moet minimaal rank 10 zijn om boten te stelen',
      };
    }

    if (vehicleType === 'motorcycle' && player.rank < 7) {
      return {
        success: false,
        message: 'Je moet minimaal rank 7 zijn om motoren te stelen',
      };
    }

    // Check cooldown
    const cooldownType =
      vehicleType === 'car'
        ? 'vehicle_theft'
        : vehicleType === 'boat'
          ? 'boat_theft'
          : 'motorcycle_theft';
    const cooldownRemaining = await checkCooldown(playerId, cooldownType);
    if (cooldownRemaining > 0) {
      const minutes = Math.ceil(cooldownRemaining / 60);
      const vehicleTypeName =
        vehicleType === 'car' ? 'auto' : vehicleType === 'boat' ? 'boot' : 'motor';
      return {
        success: false,
        message: `Je moet nog ${minutes} minuten wachten voordat je weer een ${vehicleTypeName} kunt stelen`,
        cooldownRemainingSeconds: cooldownRemaining,
      };
    }

    const diminishingContext = await economyBalanceService.getDiminishingContext(
      playerId,
      'vehicle_theft'
    );
    const sessionPayoutMultiplier = diminishingContext.multiplier;

    const vehicleWithMeta = withVehicleMeta(vehicleDef, vehicleType);
    const worldCount = await getWorldCountForVehicle(vehicleId);
    const maxGameAvailability = maxAvailabilityForVehicle(vehicleWithMeta);

    if (worldCount >= maxGameAvailability) {
      return {
        success: false,
        message:
          vehicleType === 'car'
            ? 'Dit voertuigtype is momenteel overal al opgebruikt. Probeer later of steel een ander model.'
            : 'Dit boottype is momenteel overal al opgebruikt. Probeer later of steel een ander model.',
      };
    }

    // Check garage/marina capacity BEFORE stealing
    if (vehicleType === 'car' || vehicleType === 'motorcycle') {
      // Check garage capacity
      const garage = await prisma.garage.findFirst({
        where: {
          playerId,
          location: player.currentCountry!,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });

      if (!garage) {
        return {
          success: false,
          message: 'Je hebt geen garage in dit land',
        };
      }

      const capacityBonus = garage.upgrades[0]?.capacityBonus || 0;
      const carTotalCapacity = garage.capacity + capacityBonus;
      const { motorcycleTotalCapacity } = getGarageCapacities(carTotalCapacity);

      const currentVehicleCountForType = await prisma.vehicleInventory.count({
        where: {
          playerId,
          currentLocation: player.currentCountry!,
          vehicleType,
        },
      });

      const selectedTotalCapacity =
        vehicleType === 'motorcycle' ? motorcycleTotalCapacity : carTotalCapacity;

      if (currentVehicleCountForType >= selectedTotalCapacity) {
        const storageLabel = vehicleType === 'motorcycle' ? 'motorstalling' : 'garage';
        const typeLabel = vehicleType === 'motorcycle' ? 'motor' : 'auto';
        return {
          success: false,
          message: `Je ${storageLabel} is vol voor ${typeLabel}s! Capaciteit: ${currentVehicleCountForType}/${selectedTotalCapacity}`,
        };
      }
    } else {
      // Check marina capacity
      const marina = await prisma.marina.findFirst({
        where: {
          playerId,
          location: player.currentCountry!,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });

      if (!marina) {
        return {
          success: false,
          message: 'Je hebt geen haven in dit land',
        };
      }

      const capacityBonus = marina.upgrades[0]?.capacityBonus || 0;
      const totalCapacity = marina.capacity + capacityBonus;

      const currentBoats = await prisma.vehicleInventory.count({
        where: {
          playerId,
          currentLocation: player.currentCountry!,
          vehicleType: 'boat',
        },
      });

      if (currentBoats >= totalCapacity) {
        return {
          success: false,
          message: `Je haven is vol! Capaciteit: ${currentBoats}/${totalCapacity}`,
        };
      }
    }

    // Calculate success chance based on vehicle rarity/price
    // Cheaper vehicles = easier to steal, expensive vehicles = harder
    let successChance = 0.7; // Base 70% for average vehicles

    if (vehicleDef.baseValue < 10000) {
      // Very cheap vehicles (< €10k): 75-85% success
      successChance = 0.75 + Math.random() * 0.1;
    } else if (vehicleDef.baseValue < 30000) {
      // Cheap vehicles (€10k-30k): 60-75% success
      successChance = 0.6 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 75000) {
      // Mid-range vehicles (€30k-75k): 45-60% success
      successChance = 0.45 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 150000) {
      // Expensive vehicles (€75k-150k): 30-45% success
      successChance = 0.3 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 300000) {
      // Very expensive vehicles (€150k-300k): 20-30% success
      successChance = 0.2 + Math.random() * 0.1;
    } else if (vehicleDef.baseValue < 500000) {
      // Ultra rare supercars (€300k-500k): 10-18% success
      successChance = 0.1 + Math.random() * 0.08;
    } else if (vehicleDef.baseValue < 700000) {
      // Exotic supercars (€500k-700k): 5-10% success
      successChance = 0.05 + Math.random() * 0.05;
    } else if (vehicleDef.baseValue < 1000000) {
      // Rare hypercars (€700k-1M): 3-7% success
      successChance = 0.03 + Math.random() * 0.04;
    } else if (vehicleDef.baseValue < 2000000) {
      // Extreme hypercars (€1M-2M): 1.5-4% success
      successChance = 0.015 + Math.random() * 0.025;
    } else {
      // Legendary vehicles (€2M+): 0.1-1.5% success
      successChance = 0.001 + Math.random() * 0.014;
    }

    // Small rank bonus (max +10%)
    const rankBonus = Math.min(0.1, player.rank * 0.005);
    successChance = Math.min(0.95, successChance + rankBonus);

    // Per-category heat and dynamic police patterns make repeated activity riskier.
    const heatSnapshot = await getPlayerVehicleHeatSnapshot(playerId);
    const selectedHeat =
      vehicleType === 'motorcycle'
        ? heatSnapshot.motorcycle
        : vehicleType === 'boat'
          ? heatSnapshot.boat
          : heatSnapshot.car;
    const policePattern = getDynamicPolicePatternForTime(new Date());
    const heatPenalty = getHeatSuccessPenalty(selectedHeat);
    const patternPenalty = Math.max(
      0,
      (policePattern.riskMultiplierByType[vehicleType] - 1) * 0.18
    );
    successChance = Math.max(0.01, successChance - heatPenalty - patternPenalty + theftRepBonus);

    const success = Math.random() < successChance;

    if (!success) {
      await increasePlayerVehicleHeat(playerId, vehicleType, 7);
      const insurancePayout =
        theftInsuranceCoverage > 0
          ? Math.round((vehicleDef.baseValue as number) * theftInsuranceCoverage * 0.18)
          : 0;
      if (insurancePayout > 0) {
        await createVehicleInsuranceClaim({
          playerId,
          vehicleType,
          claimType: 'THEFT_FAIL',
          payoutAmount: insurancePayout,
          riskScore: Math.round((1 - successChance) * 100),
          context: {
            country: player.currentCountry ?? null,
            vehicleId,
            vehicleName: vehicleDef.name,
          },
        });
      }
      // Failed steal - increase wanted level
      const updatedPlayer = await prisma.player.update({
        where: { id: playerId },
        data: {
          money: insurancePayout > 0 ? { increment: insurancePayout } : undefined,
          wantedLevel: Math.min(5, (player.wantedLevel || 0) + 1),
        },
        select: { wantedLevel: true, money: true },
      });

      // Set cooldown even on failed theft
      await setCooldown(playerId, cooldownType);

      // Check if player gets arrested after failed steal
      const arrestResult = await checkArrest(playerId);

      if (arrestResult.arrested) {
        await applyVehicleArrest(arrestResult.jailTime!);

        const newReputation = await applyReputationAction(playerId, 'vehicle_theft_arrest', false);

        await logVehicleTheftActivity(
          `Mislukte voertuigdiefstal: opgepakt tijdens poging (${vehicleDef.name})`,
          {
            vehicleId,
            vehicleName: vehicleDef.name,
            vehicleType,
            success: false,
            arrested: true,
            jailTime: arrestResult.jailTime,
            bail: arrestResult.bail,
          }
        );

        return {
          success: false,
          message: `Je werd opgepakt! ${arrestResult.jailTime} minuten gevangenisstraf. Borgsom: €${arrestResult.bail}`,
          arrested: true,
          jailTime: arrestResult.jailTime,
          bail: arrestResult.bail,
          wantedLevel: 0,
          reputation: newReputation,
        };
      }

      const newReputation = await applyReputationAction(playerId, 'vehicle_theft', false);

      await logVehicleTheftActivity(
        `Mislukte voertuigdiefstal: gesnapt tijdens poging (${vehicleDef.name})`,
        {
          vehicleId,
          vehicleName: vehicleDef.name,
          vehicleType,
          success: false,
          arrested: false,
          wantedLevel: updatedPlayer.wantedLevel,
        }
      );
      await activityService.logActivity(
        playerId,
        'VEHICLE_OPS_THEFT',
        `Vehicle theft ${vehicleType} failed`,
        {
          success: false,
          vehicleType,
          insurancePayout,
          opsRepLevel,
          country: player.currentCountry ?? null,
        },
        true
      );

      return {
        success: false,
        message:
          insurancePayout > 0
            ? `Je werd gesnapt tijdens de poging! Wanted level verhoogd. Insurance payout: €${insurancePayout}.`
            : 'Je werd gesnapt tijdens de poging! Wanted level verhoogd.',
        arrested: false,
        wantedLevel: updatedPlayer.wantedLevel,
        reputation: newReputation,
      };
    }

    // Success - create vehicle inventory entry
    const stolenVehicle = await prisma.vehicleInventory.create({
      data: {
        playerId,
        vehicleType,
        vehicleId,
        stolenInCountry: player.currentCountry!,
        currentLocation: player.currentCountry!,
        condition: Math.floor(Math.random() * 40) + 60, // Random 60-100% condition
        fuelLevel: Math.floor(Math.random() * 30) + 20, // Random 20-50% fuel
        marketListing: false,
      },
    });

    // Small wanted level increase even on success
    await increasePlayerVehicleHeat(playerId, vehicleType, 4);
    const postSuccessPlayer = await prisma.player.update({
      where: { id: playerId },
      data: {
        wantedLevel: Math.min(5, (player.wantedLevel || 0) + 1),
      },
      select: { wantedLevel: true },
    });

    // Set cooldown after successful theft
    await setCooldown(playerId, cooldownType);

    // Check if player gets arrested even after successful steal (lower chance)
    const arrestResult = await checkArrest(playerId);

    if (arrestResult.arrested) {
      // Player got arrested during the getaway, so the stolen vehicle is seized.
      await applyVehicleArrest(arrestResult.jailTime!, stolenVehicle.id);

      const postArrestReputation = await applyReputationAction(
        playerId,
        'vehicle_theft_arrest',
        false
      );

      await logVehicleTheftActivity(
        `Voertuig gestolen, maar direct opgepakt (${vehicleDef.name})`,
        {
          vehicleId,
          vehicleName: vehicleDef.name,
          vehicleType,
          success: false,
          arrestedAfterTheft: true,
          vehicleConfiscated: true,
          jailTime: arrestResult.jailTime,
          bail: arrestResult.bail,
        }
      );

      return {
        success: false,
        message: `Je werd opgepakt tijdens de ontsnapping. De ${vehicleDef.name} is direct in beslag genomen. ${arrestResult.jailTime} min gevangenis. Borgsom: €${arrestResult.bail}`,
        arrested: true,
        arrestedAfterTheft: true,
        vehicleConfiscated: true,
        jailTime: arrestResult.jailTime,
        bail: arrestResult.bail,
        wantedLevel: 0,
        reputation: postArrestReputation,
      };
    }

    const baseTheftXp = calculateVehicleTheftXp(vehicleWithMeta, vehicleType);
    const theftXpGained = economyBalanceService.applySoftDiminishing(
      baseTheftXp,
      sessionPayoutMultiplier,
      4
    );

    const xpUpdate = await prisma.player.update({
      where: { id: playerId },
      data: {
        xp: { increment: theftXpGained },
      },
      select: {
        xp: true,
        rank: true,
      },
    });

    const computedRank = getRankFromXP(xpUpdate.xp);
    let newRank = xpUpdate.rank;
    if (computedRank > xpUpdate.rank) {
      const rankUpdate = await prisma.player.update({
        where: { id: playerId },
        data: { rank: computedRank },
        select: { rank: true },
      });
      newRank = rankUpdate.rank;
    }

    const newReputation = await applyReputationAction(playerId, 'vehicle_theft', true);
    await addVehicleOpsRep(playerId, vehicleType, 9);
    await activityService.logActivity(
      playerId,
      'VEHICLE_OPS_THEFT',
      `Vehicle theft ${vehicleType} success`,
      {
        success: true,
        vehicleType,
        opsRepLevel,
        country: player.currentCountry ?? null,
      },
      true
    );

    const newlyUnlockedAchievements = (await checkAndUnlockAchievements(playerId)).map(
      ({ achievement }) => serializeAchievementForClient(achievement)
    );

    await logVehicleTheftActivity(`Succesvolle voertuigdiefstal: ${vehicleDef.name}`, {
      vehicleId,
      vehicleName: vehicleDef.name,
      vehicleType,
      success: true,
      xpGained: theftXpGained,
      baseXpGained: baseTheftXp,
      sessionPayoutMultiplier,
      newXp: xpUpdate.xp,
      newRank,
    });

    return {
      success: true,
      message: `Je hebt succesvol een ${vehicleDef.name} gestolen! -5 honger, -5 dorst`,
      wantedLevel: postSuccessPlayer.wantedLevel,
      xpGained: theftXpGained,
      newXp: xpUpdate.xp,
      newRank,
      reputation: newReputation,
      newlyUnlockedAchievements,
      sessionPayoutMultiplier,
      sessionAttemptsInWindow: diminishingContext.attemptsInWindow,
      sessionWindowMinutes: diminishingContext.sessionWindowMinutes,
      vehicle: {
        ...stolenVehicle,
        definition: vehicleDef,
      },
    };
  },

  /**
   * Get player's vehicle inventory
   */
  async getPlayerInventory(playerId: number) {
    // First, process any vehicles that have arrived
    await this.processArrivedVehicles(playerId);
    const activeRepairJobs = await getActiveRepairJobs(playerId);

    const inventory = await prisma.vehicleInventory.findMany({
      where: { playerId },
      orderBy: {
        stolenAt: 'desc',
      },
    });

    let tuningMap = new Map<number, { speed: number; stealth: number; armor: number }>();
    try {
      tuningMap = await getVehicleTuningMap(
        playerId,
        inventory.map((item) => item.id)
      );
    } catch (error) {
      // Keep inventory endpoint functional even if tuning metadata query fails.
      console.error('[VehicleService] getPlayerInventory tuningMap failed:', error);
    }

    // Add vehicle definitions
    return inventory.map((item) => {
      const definition = this.getVehicleById(item.vehicleId);
      const repairJob = activeRepairJobs.get(item.id);
      const tuningLevels = tuningMap.get(item.id) ?? { speed: 0, stealth: 0, armor: 0 };
      const tunedStats = definition?.stats
        ? getTunedStats(definition.stats, tuningLevels)
        : undefined;
      const tunedDefinition = definition
        ? {
            ...definition,
            stats: tunedStats ?? definition.stats,
          }
        : definition;

      return {
        ...item,
        definition: tunedDefinition,
        tuningLevels,
        tunedValueMultiplier: getTuneValueMultiplier(tuningLevels),
        repairInProgress: !!repairJob,
        repairStatus: repairJob?.status ?? null,
        repairStartedAt: repairJob?.started_at ?? null,
        repairCompletesAt: repairJob?.completes_at ?? null,
        repairCost: repairJob?.repair_cost ?? null,
        repairTargetCondition: repairJob?.target_condition ?? null,
      };
    });
  },

  /**
   * Process vehicles that have arrived at their destination
   */
  async processArrivedVehicles(playerId: number) {
    const now = new Date();

    // Find vehicles in transit that have arrived
    const arrivedVehicles = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        transportStatus: { not: null },
        transportArrivalTime: { lte: now },
        transportDestination: { not: null }, // Only process if destination is set
      },
    });

    if (arrivedVehicles.length === 0) {
      return;
    }

    // Update all arrived vehicles
    await prisma.$transaction(
      arrivedVehicles.map((vehicle) =>
        prisma.vehicleInventory.update({
          where: { id: vehicle.id },
          data: {
            currentLocation: vehicle.transportDestination!,
            transportStatus: null,
            transportArrivalTime: null,
            transportDestination: null,
          },
        })
      )
    );
  },

  /**
   * Calculate market price for a vehicle
   */
  calculateMarketPrice(
    vehicle: Vehicle,
    country: string,
    condition: number,
    tuningLevels?: { speed: number; stealth: number; armor: number }
  ): number {
    const basePrice = vehicle.marketValue[country] || vehicle.baseValue;
    const conditionMultiplier = condition / 100;
    const randomVariation = 0.9 + Math.random() * 0.2; // ±10% random variation
    const tuneMultiplier = tuningLevels ? getTuneValueMultiplier(tuningLevels) : 1;

    return Math.floor(basePrice * conditionMultiplier * randomVariation * tuneMultiplier);
  },

  /**
   * Sell a vehicle on the black market
   */
  async sellVehicle(
    playerId: number,
    inventoryId: number
  ): Promise<{
    sellPrice: number;
    newMoney: number;
  }> {
    const inventoryItem = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!inventoryItem) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (inventoryItem.playerId !== playerId) {
      throw new Error('NOT_OWNER');
    }

    if (await hasRepairInProgress(playerId, inventoryId)) {
      throw new Error('VEHICLE_REPAIR_IN_PROGRESS');
    }

    // Check if vehicle is in transit
    if (inventoryItem.transportStatus) {
      throw new Error('VEHICLE_IN_TRANSIT');
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const vehicleType = normalizeVehicleType(inventoryItem.vehicleType);
    const vehicleDef = this.getVehicleById(inventoryItem.vehicleId);
    const fallbackBaseValueByType: Record<'car' | 'boat' | 'motorcycle', number> = {
      car: 30000,
      motorcycle: 22000,
      boat: 50000,
    };
    const baseValue = vehicleDef?.baseValue ?? fallbackBaseValueByType[vehicleType];

    const tuningLevels = await getVehicleTuningLevels(playerId, inventoryId);

    // Calculate sell price
    const sellPrice = this.calculateMarketPrice(
      vehicleDef,
      player.currentCountry!,
      inventoryItem.condition,
      tuningLevels
    );

    // Use transaction
    const result = await prisma.$transaction(async (tx) => {
      // Delete vehicle from inventory
      await tx.vehicleInventory.delete({
        where: { id: inventoryId },
      });

      await tx.$executeRaw`
        DELETE FROM vehicle_tuning_upgrades
        WHERE player_id = ${playerId}
          AND vehicle_inventory_id = ${inventoryId}
      `;

      // Add money to player
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: {
            increment: sellPrice,
          },
        },
      });

      return {
        sellPrice,
        newMoney: updatedPlayer.money,
      };
    });

    return result;
  },

  /**
   * Scrap a vehicle for salvage value
   */
  async scrapVehicle(
    playerId: number,
    inventoryId: number
  ): Promise<{
    scrapPrice: number;
    newMoney: number;
    partsGained: number;
    partsType: 'car' | 'boat' | 'motorcycle';
    parts: { car: number; motorcycle: number; boat: number };
  }> {
    const inventoryItem = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!inventoryItem) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (inventoryItem.playerId !== playerId) {
      throw new Error('NOT_OWNER');
    }

    if (await hasRepairInProgress(playerId, inventoryId)) {
      throw new Error('VEHICLE_REPAIR_IN_PROGRESS');
    }

    if (inventoryItem.transportStatus) {
      throw new Error('VEHICLE_IN_TRANSIT');
    }

    const vehicleType = normalizeVehicleType(inventoryItem.vehicleType);
    const vehicleDef = this.getVehicleById(inventoryItem.vehicleId);
    const fallbackBaseValueByType: Record<'car' | 'boat' | 'motorcycle', number> = {
      car: 30000,
      motorcycle: 22000,
      boat: 50000,
    };
    const baseValue = vehicleDef?.baseValue ?? fallbackBaseValueByType[vehicleType];

    let facilityUpgradeLevel = 0;
    if (inventoryItem.vehicleType === 'boat') {
      const marina = await prisma.marina.findFirst({
        where: {
          playerId,
          location: inventoryItem.currentLocation ?? undefined,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });
      facilityUpgradeLevel = marina?.upgrades[0]?.upgradeLevel ?? 0;
    } else {
      const garage = await prisma.garage.findFirst({
        where: {
          playerId,
          location: inventoryItem.currentLocation ?? undefined,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });
      facilityUpgradeLevel = garage?.upgrades[0]?.upgradeLevel ?? 0;
    }

    const conditionMultiplier = Math.max(0.1, (inventoryItem.condition || 0) / 100);
    const chopShopMultiplier = 1 + Math.min(0.2, facilityUpgradeLevel * 0.02);
    const tuningLevels = await getVehicleTuningLevels(playerId, inventoryId);
    const tuneMultiplier = getTuneValueMultiplier(tuningLevels);
    const scrapPrice = Math.floor(
      baseValue * 0.35 * conditionMultiplier * chopShopMultiplier * tuneMultiplier
    );
    const partsGained = vehicleDef
      ? calculatePartsYield(vehicleDef, inventoryItem.condition ?? 100)
      : calculateLegacyPartsYield(vehicleType, inventoryItem.condition ?? 100, baseValue);

    const result = await prisma.$transaction(async (tx) => {
      await tx.vehicleInventory.delete({ where: { id: inventoryId } });
      await tx.$executeRaw`
        DELETE FROM vehicle_tuning_upgrades
        WHERE player_id = ${playerId}
          AND vehicle_inventory_id = ${inventoryId}
      `;

      await tx.$executeRaw`
        INSERT INTO player_vehicle_parts (player_id, car_parts, motorcycle_parts, boat_parts)
        VALUES (${playerId}, 0, 0, 0)
        ON DUPLICATE KEY UPDATE player_id = player_id
      `;

      if (vehicleType === 'boat') {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET boat_parts = boat_parts + ${partsGained}
          WHERE player_id = ${playerId}
        `;
      } else if (vehicleType === 'motorcycle') {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET motorcycle_parts = motorcycle_parts + ${partsGained}
          WHERE player_id = ${playerId}
        `;
      } else {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET car_parts = car_parts + ${partsGained}
          WHERE player_id = ${playerId}
        `;
      }

      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: {
            increment: scrapPrice,
          },
        },
      });

      return {
        scrapPrice,
        newMoney: updatedPlayer.money,
        partsGained,
        partsType: vehicleType,
      };
    });

    const parts = await getPlayerPartsInventory(playerId);
    return {
      ...result,
      parts,
    };
  },

  /**
   * Transport vehicle to another country
   */
  async transportVehicle(
    playerId: number,
    inventoryId: number,
    destinationCountry: string
  ): Promise<{
    transportCost: number;
    newMoney: number;
  }> {
    throw new Error('USE_SMUGGLING_HUB');
  },

  /**
   * Check if player has vehicle matching crime requirements
   */
  async checkVehicleRequirements(
    playerId: number,
    requirements: {
      minSpeed?: number;
      minArmor?: number;
      minCargo?: number;
      minStealth?: number;
      preferredTypes?: string[];
    }
  ): Promise<{
    hasVehicle: boolean;
    bestVehicle?: any;
    bonus: number;
  }> {
    const inventory = await this.getPlayerInventory(playerId);

    if (inventory.length === 0) {
      return { hasVehicle: false, bonus: 0 };
    }

    // Filter vehicles that meet requirements
    const suitableVehicles = inventory.filter((item) => {
      const def = item.definition;
      if (!def) return false;

      const meetsSpeed = !requirements.minSpeed || def.stats.speed >= requirements.minSpeed;
      const meetsArmor = !requirements.minArmor || def.stats.armor >= requirements.minArmor;
      const meetsCargo = !requirements.minCargo || def.stats.cargo >= requirements.minCargo;
      const meetsStealth = !requirements.minStealth || def.stats.stealth >= requirements.minStealth;

      return meetsSpeed && meetsArmor && meetsCargo && meetsStealth;
    });

    if (suitableVehicles.length === 0) {
      return { hasVehicle: false, bonus: 0 };
    }

    // Find best vehicle (with preferred type bonus)
    let bestVehicle = suitableVehicles[0];
    let bestScore = 0;

    for (const vehicle of suitableVehicles) {
      const def = vehicle.definition!;
      let score = def.stats.speed + def.stats.armor + def.stats.cargo + def.stats.stealth;

      // Bonus for preferred types
      if (requirements.preferredTypes?.includes(def.type)) {
        score += 50;
      }

      if (score > bestScore) {
        bestScore = score;
        bestVehicle = vehicle;
      }
    }

    // Calculate bonus (0-20% based on vehicle quality)
    const bonus = Math.floor(bestScore / 20); // Max ~20% bonus for perfect vehicle

    return {
      hasVehicle: true,
      bestVehicle,
      bonus,
    };
  },

  /**
   * Refuel a vehicle
   */
  async refuelVehicle(
    playerId: number,
    vehicleId: number,
    fuelAmount: number
  ): Promise<{
    fuelAdded: number;
    totalCost: number;
    newFuel: number;
    newMoney: number;
  }> {
    const FUEL_COST_PER_LITER = 2; // €2 per liter

    // Get vehicle
    const vehicle = await prisma.vehicleInventory.findFirst({
      where: {
        id: vehicleId,
        playerId,
      },
    });

    if (!vehicle) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (await hasRepairInProgress(playerId, vehicleId)) {
      throw new Error('VEHICLE_REPAIR_IN_PROGRESS');
    }

    // Get vehicle definition
    const vehicleDef = this.getVehicleById(vehicle.vehicleId);
    if (!vehicleDef) {
      throw new Error('VEHICLE_DEFINITION_NOT_FOUND');
    }

    // Check if vehicle needs fuel
    if (!vehicleDef.fuelCapacity) {
      throw new Error('VEHICLE_NO_FUEL_NEEDED');
    }

    // Calculate how much fuel can be added
    // Convert fuelLevel from percentage to liters for calculation
    const fuelPercentage = vehicle.fuelLevel || 0;
    const currentFuelLiters = (fuelPercentage / 100) * vehicleDef.fuelCapacity;
    const maxFuelToAdd = vehicleDef.fuelCapacity - currentFuelLiters;

    if (maxFuelToAdd <= 0) {
      throw new Error('FUEL_TANK_FULL');
    }

    // Use requested amount or max capacity
    const actualFuelToAdd = Math.min(fuelAmount, maxFuelToAdd);

    if (actualFuelToAdd <= 0) {
      throw new Error('INVALID_AMOUNT');
    }

    const totalCost = Math.ceil(actualFuelToAdd * FUEL_COST_PER_LITER);

    // Get player
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    if (player.money < totalCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    // Calculate new fuel as percentage
    const newFuelLiters = currentFuelLiters + actualFuelToAdd;
    const newFuelPercentage = (newFuelLiters / vehicleDef.fuelCapacity) * 100;

    // If we're filling up with the full tank amount, ensure fuel is exactly 100%
    const finalFuelPercentage =
      actualFuelToAdd >= maxFuelToAdd ? 100 : Math.min(100, Math.round(newFuelPercentage));

    console.log(
      `[Refuel] Vehicle ${vehicleId}: ${fuelPercentage}% + ${actualFuelToAdd}L = ${finalFuelPercentage}% (capacity: ${vehicleDef.fuelCapacity}L)`
    );

    // Update vehicle fuel and player money
    const [updatedVehicle, updatedPlayer] = await prisma.$transaction([
      prisma.vehicleInventory.update({
        where: { id: vehicleId },
        data: {
          fuelLevel: finalFuelPercentage,
        },
      }),
      prisma.player.update({
        where: { id: playerId },
        data: {
          money: player.money - totalCost,
        },
      }),
    ]);

    return {
      fuelAdded: actualFuelToAdd,
      totalCost,
      newFuel: updatedVehicle.fuelLevel || 0,
      newMoney: updatedPlayer.money,
    };
  },

  /**
   * Repair a vehicle
   */
  async repairVehicle(
    playerId: number,
    vehicleId: number
  ): Promise<{
    repairCost: number;
    newMoney: number;
    newCondition: number;
    repairDurationSeconds: number;
    repairCompletesAt: Date;
  }> {
    await ensureRepairJobsTable();

    // Get vehicle
    const vehicle = await prisma.vehicleInventory.findFirst({
      where: {
        id: vehicleId,
        playerId,
      },
    });

    if (!vehicle) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (await hasRepairInProgress(playerId, vehicleId)) {
      throw new Error('VEHICLE_REPAIR_IN_PROGRESS');
    }

    // Get vehicle definition
    const vehicleDef = this.getVehicleById(vehicle.vehicleId);
    if (!vehicleDef) {
      throw new Error('VEHICLE_DEFINITION_NOT_FOUND');
    }

    // Check if vehicle needs repair
    const currentCondition = vehicle.condition ?? 100;
    if (currentCondition >= 100) {
      throw new Error('VEHICLE_NOT_BROKEN');
    }

    // Calculate repair cost (% of vehicle value based on damage)
    const damagePercent = 100 - currentCondition;
    const repairCost = Math.ceil((vehicleDef.baseValue * damagePercent) / 100);

    // Get player
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const isVipActive = isPlayerVipActive(player);
    const maxConcurrentRepairs = getConcurrentRepairLimit(isVipActive);
    const activeRepairJobsCount = await getActiveRepairJobCount(playerId);
    if (activeRepairJobsCount >= maxConcurrentRepairs) {
      throw new Error(
        `REPAIR_CONCURRENCY_LIMIT_REACHED:${maxConcurrentRepairs}:${activeRepairJobsCount}:${isVipActive ? 1 : 0}`
      );
    }

    if (player.money < repairCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    let facilityUpgradeLevel = 0;
    if (vehicle.vehicleType === 'boat') {
      const marina = await prisma.marina.findFirst({
        where: {
          playerId,
          location: vehicle.currentLocation ?? player.currentCountry ?? undefined,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });
      facilityUpgradeLevel = marina?.upgrades[0]?.upgradeLevel ?? 0;
    } else {
      const garage = await prisma.garage.findFirst({
        where: {
          playerId,
          location: vehicle.currentLocation ?? player.currentCountry ?? undefined,
        },
        include: {
          upgrades: {
            orderBy: { upgradeLevel: 'desc' },
            take: 1,
          },
        },
      });
      facilityUpgradeLevel = garage?.upgrades[0]?.upgradeLevel ?? 0;
    }

    const baseRepairSeconds = repairDurationSecondsForVehicle(vehicleDef, currentCondition);
    const reductionFactor = Math.max(0.65, 1 - facilityUpgradeLevel * 0.04);
    const repairDurationSeconds = Math.max(5 * 60, Math.round(baseRepairSeconds * reductionFactor));
    const repairCompletesAt = new Date(Date.now() + repairDurationSeconds * 1000);

    const [, updatedPlayer] = await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: {
          money: player.money - repairCost,
        },
      }),
      prisma.$executeRaw`
        INSERT INTO vehicle_repair_jobs (
          player_id,
          vehicle_inventory_id,
          repair_cost,
          from_condition,
          target_condition,
          status,
          started_at,
          completes_at
        ) VALUES (
          ${playerId},
          ${vehicleId},
          ${repairCost},
          ${currentCondition},
          100,
          'in_progress',
          UTC_TIMESTAMP(),
          DATE_ADD(UTC_TIMESTAMP(), INTERVAL ${repairDurationSeconds} SECOND)
        )
      `,
    ]);

    return {
      repairCost,
      newMoney: updatedPlayer.money,
      newCondition: currentCondition,
      repairDurationSeconds,
      repairCompletesAt,
    };
  },

  async getTuningOverview(playerId: number): Promise<{
    parts: { car: number; motorcycle: number; boat: number };
    vehicles: Array<{
      inventoryId: number;
      vehicleId: string;
      name: string;
      vehicleType: 'car' | 'boat' | 'motorcycle';
      condition: number;
      image: string | null;
      baseValue: number;
      tunedValueMultiplier: number;
      estimatedValue: number;
      stats: VehicleStats;
      tuningLevels: { speed: number; stealth: number; armor: number };
      locked: boolean;
      lockReason: string | null;
      tuneCooldownRemainingSeconds: number;
      upgradeCosts: {
        speed: { nextLevel: number; partsCost: number; moneyCost: number; maxed: boolean };
        stealth: { nextLevel: number; partsCost: number; moneyCost: number; maxed: boolean };
        armor: { nextLevel: number; partsCost: number; moneyCost: number; maxed: boolean };
      };
    }>;
  }> {
    await ensureTuneTables();
    const parts = await getPlayerPartsInventory(playerId);
    const inventory = await prisma.vehicleInventory.findMany({
      where: { playerId },
      orderBy: { stolenAt: 'desc' },
    });
    const activeRepairJobs = await getActiveRepairJobs(playerId);

    const tuningMap = await getVehicleTuningMap(
      playerId,
      inventory.map((item) => item.id)
    );

    const vehicles = inventory
      .map((item) => {
        const definition = this.getVehicleById(item.vehicleId);
        if (!definition) return null;

        const vehicleType = normalizeVehicleType(item.vehicleType);
        const tuningState = tuningMap.get(item.id) ?? {
          speed: 0,
          stealth: 0,
          armor: 0,
          tuneCooldownUntil: null,
        };
        const levels = {
          speed: tuningState.speed,
          stealth: tuningState.stealth,
          armor: tuningState.armor,
        };
        const tunedStats = getTunedStats(definition.stats, levels);
        const tunedValueMultiplier = getTuneValueMultiplier(levels);
        const estimatedValue = Math.floor(
          definition.baseValue * (item.condition / 100) * tunedValueMultiplier
        );
        const repairJob = activeRepairJobs.get(item.id);
        const tuneCooldownRemainingSeconds = getTuneCooldownRemainingSeconds(
          tuningState.tuneCooldownUntil
        );
        const locked =
          Boolean(item.transportStatus) || Boolean(repairJob) || tuneCooldownRemainingSeconds > 0;
        const lockReason = item.transportStatus
          ? 'VEHICLE_IN_TRANSIT'
          : repairJob
            ? 'VEHICLE_REPAIR_IN_PROGRESS'
            : tuneCooldownRemainingSeconds > 0
              ? 'TUNE_COOLDOWN_ACTIVE'
              : null;
        const conditionImage =
          item.condition >= 100
            ? definition.imageNew ||
              definition.imageDirty ||
              definition.imageDamaged ||
              definition.image
            : item.condition >= 70
              ? definition.imageDirty ||
                definition.imageNew ||
                definition.imageDamaged ||
                definition.image
              : definition.imageDamaged ||
                definition.imageDirty ||
                definition.imageNew ||
                definition.image;

        const speedCost =
          levels.speed >= TUNE_MAX_LEVEL
            ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
            : {
                ...getTuneUpgradeCost(definition, vehicleType, 'speed', levels.speed),
                maxed: false,
              };
        const stealthCost =
          levels.stealth >= TUNE_MAX_LEVEL
            ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
            : {
                ...getTuneUpgradeCost(definition, vehicleType, 'stealth', levels.stealth),
                maxed: false,
              };
        const armorCost =
          levels.armor >= TUNE_MAX_LEVEL
            ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
            : {
                ...getTuneUpgradeCost(definition, vehicleType, 'armor', levels.armor),
                maxed: false,
              };

        return {
          inventoryId: item.id,
          vehicleId: definition.id,
          name: definition.name,
          vehicleType,
          condition: item.condition,
          image: conditionImage ?? null,
          baseValue: definition.baseValue,
          tunedValueMultiplier,
          estimatedValue,
          stats: tunedStats,
          tuningLevels: levels,
          locked,
          lockReason,
          tuneCooldownRemainingSeconds,
          upgradeCosts: {
            speed: speedCost,
            stealth: stealthCost,
            armor: armorCost,
          },
        };
      })
      .filter((item): item is NonNullable<typeof item> => item != null);

    return { parts, vehicles };
  },

  async upgradeVehicleTuning(
    playerId: number,
    inventoryId: number,
    stat: 'speed' | 'stealth' | 'armor'
  ): Promise<{
    newMoney: number;
    parts: { car: number; motorcycle: number; boat: number };
    tuningLevels: { speed: number; stealth: number; armor: number };
    upgradeCost: { partsCost: number; moneyCost: number; nextLevel: number };
  }> {
    await ensureTuneTables();
    await ensurePlayerPartsRow(playerId);

    const inventoryItem = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!inventoryItem) throw new Error('VEHICLE_NOT_FOUND');
    if (inventoryItem.playerId !== playerId) throw new Error('NOT_OWNER');
    if (inventoryItem.transportStatus) throw new Error('VEHICLE_IN_TRANSIT');
    if (await hasRepairInProgress(playerId, inventoryId))
      throw new Error('VEHICLE_REPAIR_IN_PROGRESS');

    const vehicleDef = this.getVehicleById(inventoryItem.vehicleId);
    if (!vehicleDef) throw new Error('INVALID_VEHICLE');

    const vehicleType = normalizeVehicleType(inventoryItem.vehicleType);
    const tuningState = (await getVehicleTuningMap(playerId, [inventoryId])).get(inventoryId) ?? {
      speed: 0,
      stealth: 0,
      armor: 0,
      tuneCooldownUntil: null,
    };
    const cooldownRemainingSeconds = getTuneCooldownRemainingSeconds(tuningState.tuneCooldownUntil);
    if (cooldownRemainingSeconds > 0) {
      throw new Error(`TUNE_COOLDOWN_ACTIVE:${cooldownRemainingSeconds}`);
    }

    const currentLevels = {
      speed: tuningState.speed,
      stealth: tuningState.stealth,
      armor: tuningState.armor,
    };
    const currentLevel = currentLevels[stat] ?? 0;

    if (currentLevel >= TUNE_MAX_LEVEL) {
      throw new Error('TUNE_STAT_MAXED');
    }

    const cost = getTuneUpgradeCost(vehicleDef, vehicleType, stat, currentLevel);

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) throw new Error('PLAYER_NOT_FOUND');

    const isVipActive = isPlayerVipActive(player);
    const maxConcurrentTunes = getConcurrentTuneLimit(isVipActive);
    const activeTuneJobsCount = await getActiveTuneCooldownCount(playerId);
    if (activeTuneJobsCount >= maxConcurrentTunes) {
      throw new Error(
        `TUNE_CONCURRENCY_LIMIT_REACHED:${maxConcurrentTunes}:${activeTuneJobsCount}:${isVipActive ? 1 : 0}`
      );
    }

    if (player.money < cost.moneyCost) throw new Error('INSUFFICIENT_FUNDS');

    const partsBefore = await getPlayerPartsInventory(playerId);
    const availableParts = partsBefore[vehicleType];
    if (availableParts < cost.partsCost) {
      throw new Error('INSUFFICIENT_PARTS');
    }

    await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`
        INSERT INTO vehicle_tuning_upgrades (
          player_id,
          vehicle_inventory_id,
          speed_level,
          stealth_level,
          armor_level
        ) VALUES (
          ${playerId},
          ${inventoryId},
          0,
          0,
          0
        )
        ON DUPLICATE KEY UPDATE player_id = player_id
      `;

      if (stat === 'speed') {
        await tx.$executeRaw`
          UPDATE vehicle_tuning_upgrades
          SET speed_level = speed_level + 1
          WHERE player_id = ${playerId}
            AND vehicle_inventory_id = ${inventoryId}
        `;
      } else if (stat === 'stealth') {
        await tx.$executeRaw`
          UPDATE vehicle_tuning_upgrades
          SET stealth_level = stealth_level + 1
          WHERE player_id = ${playerId}
            AND vehicle_inventory_id = ${inventoryId}
        `;
      } else {
        await tx.$executeRaw`
          UPDATE vehicle_tuning_upgrades
          SET armor_level = armor_level + 1
          WHERE player_id = ${playerId}
            AND vehicle_inventory_id = ${inventoryId}
        `;
      }

      const cooldownSeconds = TUNE_UPGRADE_COOLDOWN_SECONDS_BY_TYPE[vehicleType];
      await tx.$executeRaw`
        UPDATE vehicle_tuning_upgrades
        SET tune_cooldown_until = DATE_ADD(UTC_TIMESTAMP(), INTERVAL ${cooldownSeconds} SECOND)
        WHERE player_id = ${playerId}
          AND vehicle_inventory_id = ${inventoryId}
      `;

      if (vehicleType === 'boat') {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET boat_parts = boat_parts - ${cost.partsCost}
          WHERE player_id = ${playerId}
        `;
      } else if (vehicleType === 'motorcycle') {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET motorcycle_parts = motorcycle_parts - ${cost.partsCost}
          WHERE player_id = ${playerId}
        `;
      } else {
        await tx.$executeRaw`
          UPDATE player_vehicle_parts
          SET car_parts = car_parts - ${cost.partsCost}
          WHERE player_id = ${playerId}
        `;
      }

      await tx.player.update({
        where: { id: playerId },
        data: {
          money: {
            decrement: cost.moneyCost,
          },
        },
      });
    });

    const newLevels = await getVehicleTuningLevels(playerId, inventoryId);
    const partsAfter = await getPlayerPartsInventory(playerId);
    const updatedPlayer = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    return {
      newMoney: updatedPlayer?.money ?? 0,
      parts: partsAfter,
      tuningLevels: newLevels,
      upgradeCost: {
        partsCost: cost.partsCost,
        moneyCost: cost.moneyCost,
        nextLevel: cost.nextLevel,
      },
    };
  },
};
