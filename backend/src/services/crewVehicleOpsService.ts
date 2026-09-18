import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';
import { vehicleService } from './vehicleService';

export type CrewVehicleKind = 'car' | 'boat';
type TuneStat = 'speed' | 'stealth' | 'armor';

type CrewVehicleRow = {
  id: number;
  crewId: number;
  vehicleId: string;
  condition: number;
  fuelLevel: number;
  stolenInCountry: string | null;
  speed_level: number | bigint;
  stealth_level: number | bigint;
  armor_level: number | bigint;
  tune_cooldown_until: Date | null;
  repair_completes_at: Date | null;
  repair_cost: number | bigint | null;
};

let crewVehicleOpsReady = false;

async function ensureColumn(
  tableName: 'crew_car_inventory' | 'crew_boat_inventory',
  columnName: string,
  columnSql: string
) {
  const rows = await prisma.$queryRaw<Array<{ total: number | bigint }>>`
    SELECT COUNT(*) AS total
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND COLUMN_NAME = ${columnName}
  `;
  if (Number(rows[0]?.total ?? 0) === 0) {
    await prisma.$executeRawUnsafe(`ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${columnSql}`);
  }
}

export async function ensureCrewVehicleOpsSchema() {
  if (crewVehicleOpsReady) return;
  for (const table of ['crew_car_inventory', 'crew_boat_inventory'] as const) {
    await ensureColumn(table, 'speed_level', 'INT NOT NULL DEFAULT 0');
    await ensureColumn(table, 'stealth_level', 'INT NOT NULL DEFAULT 0');
    await ensureColumn(table, 'armor_level', 'INT NOT NULL DEFAULT 0');
    await ensureColumn(table, 'tune_cooldown_until', 'DATETIME NULL');
    await ensureColumn(table, 'repair_completes_at', 'DATETIME NULL');
    await ensureColumn(table, 'repair_cost', 'INT NULL');
  }
  crewVehicleOpsReady = true;
}

function tableName(kind: CrewVehicleKind): 'crew_car_inventory' | 'crew_boat_inventory' {
  return kind === 'boat' ? 'crew_boat_inventory' : 'crew_car_inventory';
}

function resolveType(kind: CrewVehicleKind, vehicleId: string): 'car' | 'boat' | 'motorcycle' {
  if (kind === 'boat') return 'boat';
  return vehicleService.getVehicleById(vehicleId)?.vehicleCategory === 'motorcycle'
    ? 'motorcycle'
    : 'car';
}

function tuningOf(row: CrewVehicleRow) {
  return {
    speed: Number(row.speed_level ?? 0),
    stealth: Number(row.stealth_level ?? 0),
    armor: Number(row.armor_level ?? 0),
  };
}

function repairRemainingSeconds(row: CrewVehicleRow): number {
  if (!row.repair_completes_at) return 0;
  return Math.max(0, Math.ceil((new Date(row.repair_completes_at).getTime() - Date.now()) / 1000));
}

async function requireMembership(crewId: number, playerId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { crewId, playerId },
    select: { role: true },
  });
  if (!membership) throw new Error('NOT_IN_CREW');
  return membership;
}

async function requireCrewBankFunds(crewId: number, amount: number) {
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew) throw new Error('CREW_NOT_FOUND');
  if ((crew.bankBalance ?? 0) < amount) throw new Error('INSUFFICIENT_CREW_FUNDS');
  return crew;
}

async function loadCrewVehicle(
  crewId: number,
  kind: CrewVehicleKind,
  itemId: number
): Promise<CrewVehicleRow> {
  await ensureCrewVehicleOpsSchema();
  const table = tableName(kind);
  const rows = await prisma.$queryRawUnsafe<CrewVehicleRow[]>(
    `SELECT id, crewId, vehicleId, \`condition\`, fuelLevel, stolenInCountry,
            speed_level, stealth_level, armor_level, tune_cooldown_until,
            repair_completes_at, repair_cost
     FROM ${table}
     WHERE id = ? AND crewId = ?
     LIMIT 1`,
    itemId,
    crewId
  );
  const row = rows[0];
  if (!row) throw new Error('VEHICLE_NOT_FOUND');
  return {
    ...row,
    condition: Number(row.condition ?? 0),
    fuelLevel: Number(row.fuelLevel ?? 0),
    speed_level: Number(row.speed_level ?? 0),
    stealth_level: Number(row.stealth_level ?? 0),
    armor_level: Number(row.armor_level ?? 0),
    repair_cost: row.repair_cost == null ? null : Number(row.repair_cost),
  };
}

async function completeDueRepair(kind: CrewVehicleKind, row: CrewVehicleRow): Promise<CrewVehicleRow> {
  const remaining = repairRemainingSeconds(row);
  if (!row.repair_completes_at || remaining > 0) return row;
  const table = tableName(kind);
  await prisma.$executeRawUnsafe(
    `UPDATE ${table}
     SET \`condition\` = 100, repair_completes_at = NULL, repair_cost = NULL
     WHERE id = ?`,
    row.id
  );
  return {
    ...row,
    condition: 100,
    repair_completes_at: null,
    repair_cost: null,
  };
}

export function decorateCrewVehicle(
  row: {
    id: number;
    vehicleId: string;
    condition: number;
    fuelLevel: number;
    stolenInCountry?: string | null;
    speed_level?: number;
    stealth_level?: number;
    armor_level?: number;
    tune_cooldown_until?: Date | null;
    repair_completes_at?: Date | null;
    repair_cost?: number | null;
  },
  kind: CrewVehicleKind,
  country: string
) {
  const vehicleType = resolveType(kind, row.vehicleId);
  const condition = Number(row.condition ?? 0);
  const fuelLevel = Number(row.fuelLevel ?? 0);
  const tuning = {
    speed: Number(row.speed_level ?? 0),
    stealth: Number(row.stealth_level ?? 0),
    armor: Number(row.armor_level ?? 0),
  };
  const repairSeconds = row.repair_completes_at
    ? Math.max(0, Math.ceil((new Date(row.repair_completes_at).getTime() - Date.now()) / 1000))
    : 0;
  const sellPrice = vehicleService.quoteSellPrice(
    row.vehicleId,
    country,
    condition,
    vehicleType,
    tuning
  );
  const repairQuote = vehicleService.quoteRepair(row.vehicleId, condition);
  const refuelQuote = vehicleService.quoteRefuelFill(row.vehicleId, fuelLevel);
  const tuneQuotes = {
    speed: vehicleService.quoteTuneUpgrade(vehicleType, 'speed', tuning.speed),
    stealth: vehicleService.quoteTuneUpgrade(vehicleType, 'stealth', tuning.stealth),
    armor: vehicleService.quoteTuneUpgrade(vehicleType, 'armor', tuning.armor),
  };
  return {
    vehicleType,
    tuningLevels: tuning,
    sellPrice,
    repairInProgress: repairSeconds > 0,
    repairRemainingSeconds: repairSeconds,
    repairCost: repairSeconds > 0 ? Number(row.repair_cost ?? 0) : repairQuote.repairCost,
    repairDurationSeconds: repairQuote.repairDurationSeconds,
    refuelLiters: refuelQuote.liters,
    refuelCost: refuelQuote.totalCost,
    tuneQuotes,
    tuneCooldownRemainingSeconds: row.tune_cooldown_until
      ? Math.max(0, Math.ceil((new Date(row.tune_cooldown_until).getTime() - Date.now()) / 1000))
      : 0,
  };
}

export async function completeDueCrewVehicleRepairs(crewId: number) {
  await ensureCrewVehicleOpsSchema();
  await prisma.$executeRaw`
    UPDATE crew_car_inventory
    SET \`condition\` = 100, repair_completes_at = NULL, repair_cost = NULL
    WHERE crewId = ${crewId}
      AND repair_completes_at IS NOT NULL
      AND repair_completes_at <= UTC_TIMESTAMP()
  `;
  await prisma.$executeRaw`
    UPDATE crew_boat_inventory
    SET \`condition\` = 100, repair_completes_at = NULL, repair_cost = NULL
    WHERE crewId = ${crewId}
      AND repair_completes_at IS NOT NULL
      AND repair_completes_at <= UTC_TIMESTAMP()
  `;
}

export async function copyPersonalTuningToCrewVehicle(
  playerId: number,
  personalInventoryId: number,
  kind: CrewVehicleKind,
  crewInventoryId: number
) {
  await ensureCrewVehicleOpsSchema();
  const tuning = await vehicleService.readPersonalTuning(playerId, personalInventoryId);
  const table = tableName(kind);
  await prisma.$executeRawUnsafe(
    `UPDATE ${table}
     SET speed_level = ?, stealth_level = ?, armor_level = ?
     WHERE id = ?`,
    tuning.speed,
    tuning.stealth,
    tuning.armor,
    crewInventoryId
  );
  await prisma.$executeRaw`
    DELETE FROM vehicle_tuning_upgrades
    WHERE vehicle_inventory_id = ${personalInventoryId}
  `;
}

export async function refuelCrewVehicle(
  crewId: number,
  playerId: number,
  kind: CrewVehicleKind,
  itemId: number
) {
  await requireMembership(crewId, playerId);
  let row = await loadCrewVehicle(crewId, kind, itemId);
  row = await completeDueRepair(kind, row);
  if (repairRemainingSeconds(row) > 0) throw new Error('VEHICLE_REPAIR_IN_PROGRESS');

  const quote = vehicleService.quoteRefuelFill(row.vehicleId, row.fuelLevel);
  if (quote.liters <= 0) throw new Error('FUEL_TANK_FULL');

  await requireCrewBankFunds(crewId, quote.totalCost);

  const table = tableName(kind);
  const [updatedCrew] = await prisma.$transaction([
    prisma.crew.update({
      where: { id: crewId },
      data: { bankBalance: { decrement: quote.totalCost } },
      select: { bankBalance: true },
    }),
    prisma.$executeRawUnsafe(`UPDATE ${table} SET fuelLevel = 100 WHERE id = ?`, itemId),
  ]);

  return {
    fuelAdded: quote.liters,
    totalCost: quote.totalCost,
    newFuel: 100,
    crewBalance: updatedCrew.bankBalance,
  };
}

export async function repairCrewVehicle(
  crewId: number,
  playerId: number,
  kind: CrewVehicleKind,
  itemId: number
) {
  await requireMembership(crewId, playerId);
  let row = await loadCrewVehicle(crewId, kind, itemId);
  row = await completeDueRepair(kind, row);
  if (repairRemainingSeconds(row) > 0) throw new Error('VEHICLE_REPAIR_IN_PROGRESS');
  if (row.condition >= 100) throw new Error('VEHICLE_NOT_BROKEN');

  const quote = vehicleService.quoteRepair(row.vehicleId, row.condition);
  await requireCrewBankFunds(crewId, quote.repairCost);

  const table = tableName(kind);
  const [updatedCrew] = await prisma.$transaction([
    prisma.crew.update({
      where: { id: crewId },
      data: { bankBalance: { decrement: quote.repairCost } },
      select: { bankBalance: true },
    }),
    prisma.$executeRawUnsafe(
      `UPDATE ${table}
       SET repair_completes_at = DATE_ADD(UTC_TIMESTAMP(), INTERVAL ? SECOND),
           repair_cost = ?
       WHERE id = ?`,
      quote.repairDurationSeconds,
      quote.repairCost,
      itemId
    ),
  ]);

  return {
    repairCost: quote.repairCost,
    repairDurationSeconds: quote.repairDurationSeconds,
    crewBalance: updatedCrew.bankBalance,
  };
}

export async function sellCrewVehicle(
  crewId: number,
  playerId: number,
  kind: CrewVehicleKind,
  itemId: number
) {
  const membership = await requireMembership(crewId, playerId);
  if (membership.role !== 'leader' && membership.role !== 'co_leader') {
    throw new Error('NOT_CREW_OFFICER');
  }

  let row = await loadCrewVehicle(crewId, kind, itemId);
  row = await completeDueRepair(kind, row);
  if (repairRemainingSeconds(row) > 0) throw new Error('VEHICLE_REPAIR_IN_PROGRESS');

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  const country = player?.currentCountry?.trim() || row.stolenInCountry || 'netherlands';
  const vehicleType = resolveType(kind, row.vehicleId);
  const sellPrice = vehicleService.quoteSellPrice(
    row.vehicleId,
    country,
    row.condition,
    vehicleType,
    tuningOf(row)
  );

  const cashCapacity = await getCrewStorageCapacity(crewId, 'cash_storage');
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew) throw new Error('CREW_NOT_FOUND');
  if ((crew.bankBalance ?? 0) + sellPrice > cashCapacity) {
    throw new Error('CASH_STORAGE_FULL');
  }

  const table = tableName(kind);
  const [updatedCrew] = await prisma.$transaction([
    prisma.crew.update({
      where: { id: crewId },
      data: { bankBalance: { increment: sellPrice } },
      select: { bankBalance: true },
    }),
    prisma.$executeRawUnsafe(`DELETE FROM ${table} WHERE id = ? AND crewId = ?`, itemId, crewId),
  ]);

  return {
    sellPrice,
    crewBalance: updatedCrew.bankBalance,
  };
}

export async function upgradeCrewVehicleTuning(
  crewId: number,
  playerId: number,
  kind: CrewVehicleKind,
  itemId: number,
  stat: TuneStat
) {
  await requireMembership(crewId, playerId);
  let row = await loadCrewVehicle(crewId, kind, itemId);
  row = await completeDueRepair(kind, row);
  if (repairRemainingSeconds(row) > 0) throw new Error('VEHICLE_REPAIR_IN_PROGRESS');

  const cooldownUntil = row.tune_cooldown_until ? new Date(row.tune_cooldown_until) : null;
  const cooldownRemaining = cooldownUntil
    ? Math.max(0, Math.ceil((cooldownUntil.getTime() - Date.now()) / 1000))
    : 0;
  if (cooldownRemaining > 0) {
    throw new Error(`TUNE_COOLDOWN_ACTIVE:${cooldownRemaining}`);
  }

  const vehicleType = resolveType(kind, row.vehicleId);
  const levels = tuningOf(row);
  const quote = vehicleService.quoteTuneUpgrade(vehicleType, stat, levels[stat]);
  if (quote.maxed) throw new Error('TUNE_STAT_MAXED');

  await requireCrewBankFunds(crewId, quote.moneyCost);

  await prisma.$executeRaw`
    INSERT INTO player_vehicle_parts (player_id, car_parts, motorcycle_parts, boat_parts)
    VALUES (${playerId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;

  const partsRows = await prisma.$queryRaw<
    Array<{ car_parts: number; motorcycle_parts: number; boat_parts: number }>
  >`
    SELECT car_parts, motorcycle_parts, boat_parts
    FROM player_vehicle_parts
    WHERE player_id = ${playerId}
    LIMIT 1
  `;
  const available =
    vehicleType === 'boat'
      ? Number(partsRows[0]?.boat_parts ?? 0)
      : vehicleType === 'motorcycle'
        ? Number(partsRows[0]?.motorcycle_parts ?? 0)
        : Number(partsRows[0]?.car_parts ?? 0);
  if (available < quote.partsCost) throw new Error('INSUFFICIENT_PARTS');

  const partsColumn =
    vehicleType === 'boat'
      ? 'boat_parts'
      : vehicleType === 'motorcycle'
        ? 'motorcycle_parts'
        : 'car_parts';
  const levelColumn =
    stat === 'speed' ? 'speed_level' : stat === 'stealth' ? 'stealth_level' : 'armor_level';
  const table = tableName(kind);
  const cooldownSeconds = vehicleService.tuneCooldownSeconds(vehicleType);

  const [updatedCrew] = await prisma.$transaction([
    prisma.crew.update({
      where: { id: crewId },
      data: { bankBalance: { decrement: quote.moneyCost } },
      select: { bankBalance: true },
    }),
    prisma.$executeRawUnsafe(
      `UPDATE player_vehicle_parts SET ${partsColumn} = ${partsColumn} - ? WHERE player_id = ?`,
      quote.partsCost,
      playerId
    ),
    prisma.$executeRawUnsafe(
      `UPDATE ${table}
       SET ${levelColumn} = ${levelColumn} + 1,
           tune_cooldown_until = DATE_ADD(UTC_TIMESTAMP(), INTERVAL ? SECOND)
       WHERE id = ?`,
      cooldownSeconds,
      itemId
    ),
  ]);

  const nextLevels = { ...levels, [stat]: levels[stat] + 1 };
  return {
    crewBalance: updatedCrew.bankBalance,
    tuningLevels: nextLevels,
    upgradeCost: quote,
  };
}
