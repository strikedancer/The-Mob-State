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
import { applyReputationAction } from './reputationService';
import {
  checkAndUnlockAchievements,
  serializeAchievementForClient,
} from './achievementService';

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
console.log('[VehicleService Init] Cars:', vehiclesData.cars?.length ?? 0, 'Boats:', vehiclesData.boats?.length ?? 0);
if (!vehiclesData.cars || !vehiclesData.boats) {
  console.error('[VehicleService Init] WARNING: vehicles.json structure issue! Cars array exists:', !!vehiclesData.cars, 'Boats array exists:', !!vehiclesData.boats);
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

const TUNE_MAX_LEVEL = 10;
const STANDARD_CONCURRENT_VEHICLE_ACTION_LIMIT = 1;
const VIP_CONCURRENT_VEHICLE_ACTION_LIMIT = 5;
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

const calculateVehicleTheftXp = (vehicle: Vehicle, vehicleType: 'car' | 'boat' | 'motorcycle'): number => {
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

const normalizeVehicleType = (vehicleType: string | null | undefined): 'car' | 'boat' | 'motorcycle' => {
  const normalized = (vehicleType ?? '').toString().trim().toLowerCase();
  if (['boat', 'boats', 'boot', 'ship', 'yacht'].includes(normalized)) return 'boat';
  if (['motorcycle', 'motorcycles', 'motor', 'motorbike', 'bike'].includes(normalized)) return 'motorcycle';
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
    const remaining = ((activeMinutes - minuteInCycle - 1) * 60) + (60 - now.getUTCSeconds());
    return {
      active: true,
      // null during active windows means the event applies to all vehicle categories.
      activeCategory: null,
      remainingSeconds: Math.max(1, remaining),
      startsInSeconds: 0,
    };
  }

  const startsInSeconds = ((cycleMinutes - minuteInCycle - 1) * 60) + (60 - now.getUTCSeconds());
  return {
    active: false,
    activeCategory: null,
    remainingSeconds: 0,
    startsInSeconds: Math.max(1, startsInSeconds),
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
      return isBoat ? 24 : (isMotorcycle ? 50 : 60);
    case 'uncommon':
      return isBoat ? 16 : (isMotorcycle ? 34 : 40);
    case 'rare':
      return isBoat ? 10 : (isMotorcycle ? 20 : 22);
    case 'epic':
      return isBoat ? 6 : (isMotorcycle ? 11 : 12);
    case 'legendary':
      return isBoat ? 3 : 5;
    default:
      return isBoat ? 12 : (isMotorcycle ? 24 : 30);
  }
};

const repairDurationSecondsForVehicle = (vehicle: Vehicle, currentCondition: number): number => {
  const damagePercent = Math.max(0, 100 - currentCondition);
  const isBoat = vehicle.vehicleCategory === 'boat';
  const isMotorcycle = vehicle.vehicleCategory === 'motorcycle';
  const baseSeconds = isBoat ? 20 * 60 : (isMotorcycle ? 8 * 60 : 12 * 60);
  const damageSeconds = damagePercent * (isBoat ? 120 : (isMotorcycle ? 70 : 90));
  const valueSeconds = Math.min(
    6 * 60 * 60,
    Math.floor(vehicle.baseValue / (isBoat ? 120 : (isMotorcycle ? 260 : 200)))
  );

  return Math.max(
    isBoat ? 30 * 60 : (isMotorcycle ? 10 * 60 : 15 * 60),
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

async function getPlayerPartsInventory(playerId: number): Promise<{ car: number; motorcycle: number; boat: number }> {
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

async function getVehicleTuningMap(playerId: number, inventoryIds: number[]): Promise<Map<number, {
  speed: number;
  stealth: number;
  armor: number;
  tuneCooldownUntil: Date | null;
}>> {
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

async function getVehicleTuningLevels(playerId: number, inventoryId: number): Promise<{ speed: number; stealth: number; armor: number }> {
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

const getTuneValueMultiplier = (levels: { speed: number; stealth: number; armor: number }): number => {
  const totalLevel = getTotalTuneLevel(levels);
  return 1 + totalLevel * 0.03;
};

const getTunedStats = (
  baseStats: VehicleStats,
  levels: { speed: number; stealth: number; armor: number }
): VehicleStats => {
  return {
    speed: Math.round((baseStats.speed ?? 0) * (1 + (levels.speed ?? 0) * tuneStatBonusPerLevelMap.speed)),
    stealth: Math.round((baseStats.stealth ?? 0) * (1 + (levels.stealth ?? 0) * tuneStatBonusPerLevelMap.stealth)),
    armor: Math.round((baseStats.armor ?? 0) * (1 + (levels.armor ?? 0) * tuneStatBonusPerLevelMap.armor)),
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
  const dueJobs = playerId == null
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

  await prisma.$transaction(
    dueJobs.flatMap((job) => [
      prisma.vehicleInventory.update({
        where: { id: job.vehicle_inventory_id },
        data: { condition: job.target_condition },
      }),
      prisma.$executeRaw`
        UPDATE vehicle_repair_jobs
        SET status = 'completed', completed_at = UTC_TIMESTAMP()
        WHERE id = ${job.id}
      `,
    ])
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

const getConcurrentVehicleActionLimit = (isVipActive: boolean): number => {
  return isVipActive ? VIP_CONCURRENT_VEHICLE_ACTION_LIMIT : STANDARD_CONCURRENT_VEHICLE_ACTION_LIMIT;
};

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

  return new Map(
    rows.map((row) => [row.vehicleId, Number(row.total)])
  );
}

async function getWorldCountForVehicle(vehicleId: string): Promise<number> {
  const counts = await getWorldVehicleCounts();
  return counts.get(vehicleId) ?? 0;
}

const withVehicleMeta = (
  vehicle: Vehicle,
  vehicleCategory: 'car' | 'boat' | 'motorcycle',
  worldCount = 0,
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
      boatsKeys: vehiclesData.boats ? Object.keys(vehiclesData.boats[0] || {}) : []
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
    const vehicle = allVehicles.find((v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId);
    if (!vehicle) return undefined;
    const isCar = (vehiclesData.cars as unknown as Vehicle[])
      .some((v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId);
    const isBoat = (vehiclesData.boats as unknown as Vehicle[])
      .some((v) => (v.id ?? '').toString().trim().toLowerCase() === normalizedVehicleId);
    return withVehicleMeta(
      vehicle,
      isCar ? 'car' : (isBoat ? 'boat' : 'motorcycle')
    );
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
        policeEventStatus.activeCategory == null ||
        policeEventStatus.activeCategory === category;
      return policeEventStatus.active && categoryAllowed;
    };

    const cars = (vehiclesData.cars as unknown as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'car')) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'car', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0);
      
    const boats = (vehiclesData.boats as unknown as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'boat')) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'boat', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0);

    const motorcycles = ((((vehiclesData as any).motorcycles ?? []) as Vehicle[])
      .filter((v) => {
        if (!canExposeVehicle(v, 'motorcycle')) return false;
        if (isExtendedCountry) return true;
        const availability = v.availableInCountries?.map(normalizeCountryId) ?? [];
        return availability.includes(normalizedCountry);
      })
      .map((v) => withVehicleMeta(v, 'motorcycle', worldCounts.get(v.id) ?? 0))
      .filter((v) => (v.remainingWorldAvailability ?? 1) > 0));
      
    return [...cars, ...motorcycles, ...boats];
  },

  getPoliceVehicleEventStatus(): PoliceVehicleEventStatus {
    return getPoliceVehicleEventStatusForTime(new Date());
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
    cooldownRemainingSeconds?: number;
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
    const motorcycleMatch = (((vehiclesData as any).motorcycles ?? []) as any[]).find((m: any) => m.id === vehicleId);
    
    console.log(`[DETECT] carMatch: ${carMatch ? carMatch.name : 'NO'}, boatMatch: ${boatMatch ? boatMatch.name : 'NO'}`);
    
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

    const logVehicleTheftActivity = async (
      description: string,
      details: Record<string, unknown>,
    ) => {
      try {
        await activityService.logActivity(
          playerId,
          'VEHICLE_THEFT',
          description,
          details,
          true,
        );
      } catch (error) {
        console.error('[VehicleService] Failed to log vehicle theft activity', error);
      }
    };

    const applyVehicleArrest = async (jailTime: number) => {
      const now = new Date();
      const jailReleaseTime = new Date(now.getTime() + (jailTime * 60 * 1000));

      await prisma.$transaction(async (tx) => {
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
        true,
      );
    };

    // Check rank requirements
    if (vehicleType === 'car' && player.rank < 5) {
      return {
        success: false,
        message: 'Je moet minimaal rank 5 zijn om auto\'s te stelen',
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
    const cooldownType = vehicleType === 'car'
      ? 'vehicle_theft'
      : (vehicleType === 'boat' ? 'boat_theft' : 'motorcycle_theft');
    const cooldownRemaining = await checkCooldown(playerId, cooldownType);
    if (cooldownRemaining > 0) {
      const minutes = Math.ceil(cooldownRemaining / 60);
      const vehicleTypeName = vehicleType === 'car' ? 'auto' : (vehicleType === 'boat' ? 'boot' : 'motor');
      return {
        success: false,
        message: `Je moet nog ${minutes} minuten wachten voordat je weer een ${vehicleTypeName} kunt stelen`,
        cooldownRemainingSeconds: cooldownRemaining,
      };
    }

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
      const totalCapacity = garage.capacity + capacityBonus;

      const currentCars = await prisma.vehicleInventory.count({
        where: {
          playerId,
          currentLocation: player.currentCountry!,
          vehicleType: { in: ['car', 'motorcycle'] },
        },
      });

      if (currentCars >= totalCapacity) {
        return {
          success: false,
          message: `Je garage is vol! Capaciteit: ${currentCars}/${totalCapacity}`,
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
      successChance = 0.60 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 75000) {
      // Mid-range vehicles (€30k-75k): 45-60% success
      successChance = 0.45 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 150000) {
      // Expensive vehicles (€75k-150k): 30-45% success
      successChance = 0.30 + Math.random() * 0.15;
    } else if (vehicleDef.baseValue < 300000) {
      // Very expensive vehicles (€150k-300k): 20-30% success
      successChance = 0.20 + Math.random() * 0.10;
    } else if (vehicleDef.baseValue < 500000) {
      // Ultra rare supercars (€300k-500k): 10-18% success
      successChance = 0.10 + Math.random() * 0.08;
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
    const rankBonus = Math.min(0.10, player.rank * 0.005);
    successChance = Math.min(0.95, successChance + rankBonus);

    const success = Math.random() < successChance;

    if (!success) {
      // Failed steal - increase wanted level
      const updatedPlayer = await prisma.player.update({
        where: { id: playerId },
        data: {
          wantedLevel: Math.min(5, (player.wantedLevel || 0) + 1),
        },
        select: { wantedLevel: true },
      });

      // Set cooldown even on failed theft
      await setCooldown(playerId, cooldownType);

      // Check if player gets arrested after failed steal
      const arrestResult = await checkArrest(playerId);
      
      if (arrestResult.arrested) {
        await applyVehicleArrest(arrestResult.jailTime!);

        const newReputation = await applyReputationAction(
          playerId,
          'vehicle_theft_arrest',
          false,
        );

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
          },
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

      const newReputation = await applyReputationAction(
        playerId,
        'vehicle_theft',
        false,
      );

      await logVehicleTheftActivity(
        `Mislukte voertuigdiefstal: gesnapt tijdens poging (${vehicleDef.name})`,
        {
          vehicleId,
          vehicleName: vehicleDef.name,
          vehicleType,
          success: false,
          arrested: false,
          wantedLevel: updatedPlayer.wantedLevel,
        },
      );

      return {
        success: false,
        message: 'Je werd gesnapt tijdens de poging! Wanted level verhoogd.',
        arrested: false,
        wantedLevel: updatedPlayer.wantedLevel,
        reputation: newReputation,
      };
    }

    // Success - create vehicle inventory entry
    const theftXpGained = calculateVehicleTheftXp(vehicleWithMeta, vehicleType);

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
    const postSuccessPlayer = await prisma.player.update({
      where: { id: playerId },
      data: {
        wantedLevel: Math.min(5, (player.wantedLevel || 0) + 1),
      },
      select: { wantedLevel: true },
    });

    // Set cooldown after successful theft
    await setCooldown(playerId, cooldownType);

    const newReputation = await applyReputationAction(
      playerId,
      'vehicle_theft',
      true,
    );

    const newlyUnlockedAchievements = (
      await checkAndUnlockAchievements(playerId)
    ).map(({ achievement }) => serializeAchievementForClient(achievement));

    // Check if player gets arrested even after successful steal (lower chance)
    const arrestResult = await checkArrest(playerId);
    
    if (arrestResult.arrested) {
      // Player got arrested AFTER stealing the vehicle successfully
      // Vehicle stays stolen but player goes to jail
      await applyVehicleArrest(arrestResult.jailTime!);

      const postArrestReputation = await applyReputationAction(
        playerId,
        'vehicle_theft_arrest',
        false,
      );

      await logVehicleTheftActivity(
        `Voertuig gestolen, maar direct opgepakt (${vehicleDef.name})`,
        {
          vehicleId,
          vehicleName: vehicleDef.name,
          vehicleType,
          success: true,
          xpGained: theftXpGained,
          newXp: xpUpdate.xp,
          newRank,
          arrestedAfterTheft: true,
          jailTime: arrestResult.jailTime,
          bail: arrestResult.bail,
        },
      );

      return {
        success: true,
        message: `Je stal de ${vehicleDef.name}, maar werd daarna opgepakt! ${arrestResult.jailTime} min gevangenis. Borgsom: €${arrestResult.bail}`,
        arrested: true,
        arrestedAfterTheft: true,
        jailTime: arrestResult.jailTime,
        bail: arrestResult.bail,
        wantedLevel: 0,
        xpGained: theftXpGained,
        newXp: xpUpdate.xp,
        newRank,
        reputation: postArrestReputation,
        newlyUnlockedAchievements,
        vehicle: {
          ...stolenVehicle,
          definition: vehicleDef,
        },
      };
    }

    await logVehicleTheftActivity(
      `Succesvolle voertuigdiefstal: ${vehicleDef.name}`,
      {
        vehicleId,
        vehicleName: vehicleDef.name,
        vehicleType,
        success: true,
        xpGained: theftXpGained,
        newXp: xpUpdate.xp,
        newRank,
      },
    );

    return {
      success: true,
      message: `Je hebt succesvol een ${vehicleDef.name} gestolen! -5 honger, -5 dorst`,
      wantedLevel: postSuccessPlayer.wantedLevel,
      xpGained: theftXpGained,
      newXp: xpUpdate.xp,
      newRank,
      reputation: newReputation,
      newlyUnlockedAchievements,
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
      tuningMap = await getVehicleTuningMap(playerId, inventory.map((item) => item.id));
    } catch (error) {
      // Keep inventory endpoint functional even if tuning metadata query fails.
      console.error('[VehicleService] getPlayerInventory tuningMap failed:', error);
    }

    // Add vehicle definitions
    return inventory.map((item) => {
      const definition = this.getVehicleById(item.vehicleId);
      const repairJob = activeRepairJobs.get(item.id);
      const tuningLevels = tuningMap.get(item.id) ?? { speed: 0, stealth: 0, armor: 0 };
      const tunedStats = definition?.stats ? getTunedStats(definition.stats, tuningLevels) : undefined;
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
    const chopShopMultiplier = 1 + Math.min(0.20, facilityUpgradeLevel * 0.02);
    const tuningLevels = await getVehicleTuningLevels(playerId, inventoryId);
    const tuneMultiplier = getTuneValueMultiplier(tuningLevels);
    const scrapPrice = Math.floor(baseValue * 0.35 * conditionMultiplier * chopShopMultiplier * tuneMultiplier);
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
      const meetsStealth =
        !requirements.minStealth || def.stats.stealth >= requirements.minStealth;

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
    const finalFuelPercentage = actualFuelToAdd >= maxFuelToAdd 
      ? 100 
      : Math.min(100, Math.round(newFuelPercentage));

    console.log(`[Refuel] Vehicle ${vehicleId}: ${fuelPercentage}% + ${actualFuelToAdd}L = ${finalFuelPercentage}% (capacity: ${vehicleDef.fuelCapacity}L)`);

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
    const currentCondition = vehicle.condition || 100;
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
    const maxConcurrentRepairs = getConcurrentVehicleActionLimit(isVipActive);
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
    const reductionFactor = Math.max(0.65, 1 - (facilityUpgradeLevel * 0.04));
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

    const tuningMap = await getVehicleTuningMap(playerId, inventory.map((item) => item.id));

    const vehicles = inventory
      .map((item) => {
        const definition = this.getVehicleById(item.vehicleId);
        if (!definition) return null;

        const vehicleType = normalizeVehicleType(item.vehicleType);
        const tuningState = tuningMap.get(item.id) ?? { speed: 0, stealth: 0, armor: 0, tuneCooldownUntil: null };
        const levels = { speed: tuningState.speed, stealth: tuningState.stealth, armor: tuningState.armor };
        const tunedStats = getTunedStats(definition.stats, levels);
        const tunedValueMultiplier = getTuneValueMultiplier(levels);
        const estimatedValue = Math.floor(definition.baseValue * (item.condition / 100) * tunedValueMultiplier);
        const repairJob = activeRepairJobs.get(item.id);
        const tuneCooldownRemainingSeconds = getTuneCooldownRemainingSeconds(tuningState.tuneCooldownUntil);
        const locked = Boolean(item.transportStatus) || Boolean(repairJob) || tuneCooldownRemainingSeconds > 0;
        const lockReason = item.transportStatus
          ? 'VEHICLE_IN_TRANSIT'
          : (repairJob ? 'VEHICLE_REPAIR_IN_PROGRESS' : (tuneCooldownRemainingSeconds > 0 ? 'TUNE_COOLDOWN_ACTIVE' : null));
        const conditionImage =
          item.condition >= 100
            ? (definition.imageNew || definition.imageDirty || definition.imageDamaged || definition.image)
            : item.condition >= 70
                ? (definition.imageDirty || definition.imageNew || definition.imageDamaged || definition.image)
                : (definition.imageDamaged || definition.imageDirty || definition.imageNew || definition.image);

        const speedCost = levels.speed >= TUNE_MAX_LEVEL
          ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
          : { ...getTuneUpgradeCost(definition, vehicleType, 'speed', levels.speed), maxed: false };
        const stealthCost = levels.stealth >= TUNE_MAX_LEVEL
          ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
          : { ...getTuneUpgradeCost(definition, vehicleType, 'stealth', levels.stealth), maxed: false };
        const armorCost = levels.armor >= TUNE_MAX_LEVEL
          ? { nextLevel: TUNE_MAX_LEVEL, partsCost: 0, moneyCost: 0, maxed: true }
          : { ...getTuneUpgradeCost(definition, vehicleType, 'armor', levels.armor), maxed: false };

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
    if (await hasRepairInProgress(playerId, inventoryId)) throw new Error('VEHICLE_REPAIR_IN_PROGRESS');

    const vehicleDef = this.getVehicleById(inventoryItem.vehicleId);
    if (!vehicleDef) throw new Error('INVALID_VEHICLE');

    const vehicleType = normalizeVehicleType(inventoryItem.vehicleType);
    const tuningState = (await getVehicleTuningMap(playerId, [inventoryId])).get(inventoryId)
      ?? { speed: 0, stealth: 0, armor: 0, tuneCooldownUntil: null };
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
    const maxConcurrentTunes = getConcurrentVehicleActionLimit(isVipActive);
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
    const updatedPlayer = await prisma.player.findUnique({ where: { id: playerId }, select: { money: true } });

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
