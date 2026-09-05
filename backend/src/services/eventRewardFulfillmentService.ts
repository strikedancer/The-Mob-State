/**
 * Extends game-event reward delivery beyond cash/XP/credits/event chips.
 * Supports ammo, tools, vehicle parts, weapons, and vehicles (with world-cap + garage checks).
 *
 * rewardsJson shape (all optional, additive to cash/xp/premiumCredits/items):
 * {
 *   ammo: [{ ammoType: "9mm", quantity: 50 }],
 *   tools: [{ toolId: "bolt_cutter", quantity: 1 }],
 *   vehicleParts: { car: 5, motorcycle: 2, boat: 1 },
 *   weapons: [{ weaponId: "knife", condition: 100 }],
 *   vehicles: [{ vehicleId: "honda_nsx_street", condition: 90, fuel: 50 }],
 * }
 *
 * If a vehicle/weapon/tool cannot be granted, cashCompensation is added when configured,
 * otherwise a soft fallback of floor(baseValue * 0.35) / tool.basePrice / weapon.price.
 */

import prisma from '../lib/prisma';
import { ammoService } from './ammoService';
import toolService from './toolService';
import { weaponService } from './weaponService';
import { vehicleService } from './vehicleService';
import { computeGarageSlotTotals } from './garageService';

type TransactionClient = Parameters<Parameters<typeof prisma.$transaction>[0]>[0];

export type AmmoGrant = { ammoType: string; quantity: number };
export type ToolGrant = { toolId: string; quantity: number };
export type WeaponGrant = { weaponId: string; condition: number; quantity: number };
export type VehicleGrant = {
  vehicleId: string;
  condition: number;
  fuel: number;
  cashFallback?: number;
};
export type VehiclePartsGrant = { car: number; motorcycle: number; boat: number };

export type ExtendedEventRewards = {
  ammo: AmmoGrant[];
  tools: ToolGrant[];
  weapons: WeaponGrant[];
  vehicles: VehicleGrant[];
  vehicleParts: VehiclePartsGrant;
};

function toPositiveInt(value: unknown, fallback = 0): number {
  const n = Number(value);
  if (!Number.isFinite(n) || n <= 0) return fallback;
  return Math.floor(n);
}

function clamp(n: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, n));
}

export function parseExtendedEventRewards(
  rewards: Record<string, unknown>,
): ExtendedEventRewards {
  const ammo: AmmoGrant[] = [];
  const tools: ToolGrant[] = [];
  const weapons: WeaponGrant[] = [];
  const vehicles: VehicleGrant[] = [];

  const rawAmmo = rewards.ammo;
  if (Array.isArray(rawAmmo)) {
    for (const entry of rawAmmo) {
      if (!entry || typeof entry !== 'object') continue;
      const row = entry as Record<string, unknown>;
      const ammoType = String(row.ammoType ?? row.type ?? '').trim();
      const quantity = toPositiveInt(row.quantity ?? row.qty);
      if (!ammoType || quantity <= 0) continue;
      if (!ammoService.getAmmoDefinition(ammoType)) continue;
      ammo.push({ ammoType, quantity });
    }
  }

  const rawTools = rewards.tools;
  if (Array.isArray(rawTools)) {
    for (const entry of rawTools) {
      if (!entry || typeof entry !== 'object') continue;
      const row = entry as Record<string, unknown>;
      const toolId = String(row.toolId ?? row.id ?? '').trim();
      const quantity = toPositiveInt(row.quantity ?? row.qty, 1);
      if (!toolId || quantity <= 0) continue;
      if (!toolService.getToolDefinition(toolId)) continue;
      tools.push({ toolId, quantity });
    }
  }

  const rawWeapons = rewards.weapons;
  if (Array.isArray(rawWeapons)) {
    for (const entry of rawWeapons) {
      if (!entry || typeof entry !== 'object') continue;
      const row = entry as Record<string, unknown>;
      const weaponId = String(row.weaponId ?? row.id ?? '').trim();
      const quantity = toPositiveInt(row.quantity ?? row.qty, 1);
      const condition = clamp(toPositiveInt(row.condition, 100), 1, 100);
      if (!weaponId || quantity <= 0) continue;
      if (!weaponService.getWeaponDefinition(weaponId)) continue;
      weapons.push({ weaponId, condition, quantity });
    }
  }

  const rawVehicles = rewards.vehicles;
  if (Array.isArray(rawVehicles)) {
    for (const entry of rawVehicles) {
      if (!entry || typeof entry !== 'object') continue;
      const row = entry as Record<string, unknown>;
      const vehicleId = String(row.vehicleId ?? row.id ?? '').trim();
      if (!vehicleId) continue;
      if (!vehicleService.getVehicleById(vehicleId)) continue;
      vehicles.push({
        vehicleId,
        condition: clamp(toPositiveInt(row.condition, 85), 10, 100),
        fuel: clamp(toPositiveInt(row.fuel ?? row.fuelLevel, 50), 5, 100),
        cashFallback: toPositiveInt(row.cashFallback) || undefined,
      });
    }
  }

  const partsRaw = rewards.vehicleParts;
  let vehicleParts: VehiclePartsGrant = { car: 0, motorcycle: 0, boat: 0 };
  if (partsRaw && typeof partsRaw === 'object' && !Array.isArray(partsRaw)) {
    const p = partsRaw as Record<string, unknown>;
    vehicleParts = {
      car: toPositiveInt(p.car ?? p.car_parts),
      motorcycle: toPositiveInt(p.motorcycle ?? p.motorcycle_parts),
      boat: toPositiveInt(p.boat ?? p.boat_parts),
    };
  }

  return { ammo, tools, weapons, vehicles, vehicleParts };
}

export function hasExtendedEventRewards(ext: ExtendedEventRewards): boolean {
  return (
    ext.ammo.length > 0 ||
    ext.tools.length > 0 ||
    ext.weapons.length > 0 ||
    ext.vehicles.length > 0 ||
    ext.vehicleParts.car > 0 ||
    ext.vehicleParts.motorcycle > 0 ||
    ext.vehicleParts.boat > 0
  );
}

async function getWorldCountForVehicleId(
  db: TransactionClient | typeof prisma,
  vehicleId: string,
): Promise<number> {
  const rows = await db.$queryRaw<Array<{ total: bigint | number }>>`
    SELECT COUNT(*) AS total
    FROM (
      SELECT id FROM vehicle_inventory WHERE vehicleId = ${vehicleId}
      UNION ALL
      SELECT id FROM crew_car_inventory WHERE vehicleId = ${vehicleId}
      UNION ALL
      SELECT id FROM crew_boat_inventory WHERE vehicleId = ${vehicleId}
    ) owned
  `;
  return Number(rows[0]?.total ?? 0);
}

async function grantAmmo(
  tx: TransactionClient,
  playerId: number,
  grant: AmmoGrant,
): Promise<void> {
  const def = ammoService.getAmmoDefinition(grant.ammoType);
  if (!def) return;

  const existing = await tx.ammoInventory.findUnique({
    where: {
      playerId_ammoType: { playerId, ammoType: grant.ammoType },
    },
  });
  const currentQty = existing?.quantity ?? 0;
  const newQty = Math.min(currentQty + grant.quantity, def.maxInventory);
  if (newQty <= currentQty) return;

  if (existing) {
    await tx.ammoInventory.update({
      where: { id: existing.id },
      data: { quantity: newQty },
    });
  } else {
    await tx.ammoInventory.create({
      data: {
        playerId,
        ammoType: grant.ammoType,
        quantity: newQty,
        quality: 1.0,
      },
    });
  }
}

async function grantTool(
  tx: TransactionClient,
  playerId: number,
  grant: ToolGrant,
): Promise<number> {
  const def = toolService.getToolDefinition(grant.toolId);
  if (!def) return 0;
  await toolService.ensureToolCatalogEntry(grant.toolId);

  let remaining = grant.quantity;
  let granted = 0;

  const property = await tx.property.findFirst({
    where: { playerId },
    select: { id: true },
  });

  while (remaining > 0) {
    const canCarry = await toolService.canCarryTool(playerId, grant.toolId, 1);
    let destLocation: string | null = null;

    if (canCarry) {
      destLocation = 'carried';
    } else if (property) {
      destLocation = `property_${property.id}`;
    } else {
      break;
    }

    const existing = await tx.playerTools.findFirst({
      where: { playerId, toolId: grant.toolId, location: destLocation },
    });

    if (existing) {
      await tx.playerTools.update({
        where: { id: existing.id },
        data: {
          quantity: existing.quantity + 1,
          durability: Math.max(existing.durability, def.maxDurability),
        },
      });
    } else {
      await tx.playerTools.create({
        data: {
          playerId,
          toolId: grant.toolId,
          durability: def.maxDurability,
          location: destLocation,
          quantity: 1,
        },
      });
    }

    granted += 1;
    remaining -= 1;
  }

  if (granted < grant.quantity) {
    const missing = grant.quantity - granted;
    const cash = Math.floor(def.basePrice * 0.5) * missing;
    if (cash > 0) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: cash } },
      });
    }
  }

  return granted;
}

async function grantWeapon(
  tx: TransactionClient,
  playerId: number,
  grant: WeaponGrant,
): Promise<void> {
  const def = weaponService.getWeaponDefinition(grant.weaponId);
  if (!def) return;

  const existing = await tx.weaponInventory.findUnique({
    where: {
      playerId_weaponId: { playerId, weaponId: grant.weaponId },
    },
  });

  if (existing) {
    await tx.weaponInventory.update({
      where: { id: existing.id },
      data: {
        quantity: existing.quantity + grant.quantity,
        condition: Math.max(existing.condition, grant.condition),
      },
    });
  } else {
    await tx.weaponInventory.create({
      data: {
        playerId,
        weaponId: grant.weaponId,
        quantity: grant.quantity,
        condition: grant.condition,
      },
    });
  }
}

async function grantVehicleParts(
  tx: TransactionClient,
  playerId: number,
  parts: VehiclePartsGrant,
): Promise<void> {
  if (parts.car <= 0 && parts.motorcycle <= 0 && parts.boat <= 0) return;

  await tx.$executeRaw`
    INSERT INTO player_vehicle_parts (player_id, car_parts, motorcycle_parts, boat_parts)
    VALUES (${playerId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;

  if (parts.car > 0) {
    await tx.$executeRaw`
      UPDATE player_vehicle_parts
      SET car_parts = car_parts + ${parts.car}
      WHERE player_id = ${playerId}
    `;
  }
  if (parts.motorcycle > 0) {
    await tx.$executeRaw`
      UPDATE player_vehicle_parts
      SET motorcycle_parts = motorcycle_parts + ${parts.motorcycle}
      WHERE player_id = ${playerId}
    `;
  }
  if (parts.boat > 0) {
    await tx.$executeRaw`
      UPDATE player_vehicle_parts
      SET boat_parts = boat_parts + ${parts.boat}
      WHERE player_id = ${playerId}
    `;
  }
}

async function grantVehicle(
  tx: TransactionClient,
  playerId: number,
  grant: VehicleGrant,
): Promise<'granted' | 'cash_fallback'> {
  const def = vehicleService.getVehicleById(grant.vehicleId);
  if (!def) return 'cash_fallback';

  const player = await tx.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  const country = player?.currentCountry;
  if (!country) return 'cash_fallback';

  const vehicleType = def.vehicleCategory ?? 'car';
  const worldCount = await getWorldCountForVehicleId(tx, grant.vehicleId);
  const maxAvail = def.maxGameAvailability ?? 12;
  if (worldCount >= maxAvail) {
    const cash =
      grant.cashFallback ?? Math.max(5_000, Math.floor((def.baseValue ?? 0) * 0.35));
    await tx.player.update({
      where: { id: playerId },
      data: { money: { increment: cash } },
    });
    return 'cash_fallback';
  }

  if (vehicleType === 'car' || vehicleType === 'motorcycle') {
    const garage = await tx.garage.findFirst({
      where: { playerId, location: country },
      include: { upgrades: true },
    });
    if (!garage) {
      const cash =
        grant.cashFallback ?? Math.max(5_000, Math.floor((def.baseValue ?? 0) * 0.35));
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: cash } },
      });
      return 'cash_fallback';
    }

    const { carTotalCapacity, motorcycleTotalCapacity } = computeGarageSlotTotals(garage);
    const capacity =
      vehicleType === 'motorcycle' ? motorcycleTotalCapacity : carTotalCapacity;
    const currentCount = await tx.vehicleInventory.count({
      where: { playerId, currentLocation: country, vehicleType },
    });
    if (currentCount >= capacity) {
      const cash =
        grant.cashFallback ?? Math.max(5_000, Math.floor((def.baseValue ?? 0) * 0.35));
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: cash } },
      });
      return 'cash_fallback';
    }
  } else {
    // boats — marina capacity check (best-effort; if no marina, cash fallback)
    const marina = await tx.marina.findFirst({
      where: { playerId, location: country },
      include: { upgrades: true },
    });
    if (!marina) {
      const cash =
        grant.cashFallback ?? Math.max(5_000, Math.floor((def.baseValue ?? 0) * 0.35));
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: cash } },
      });
      return 'cash_fallback';
    }
    const upgradeBonus = marina.upgrades.reduce(
      (sum, u) => sum + (u.capacityBonus || 0),
      0,
    );
    const capacity = marina.capacity + upgradeBonus;
    const currentBoats = await tx.vehicleInventory.count({
      where: { playerId, currentLocation: country, vehicleType: 'boat' },
    });
    if (currentBoats >= capacity) {
      const cash =
        grant.cashFallback ?? Math.max(5_000, Math.floor((def.baseValue ?? 0) * 0.35));
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: cash } },
      });
      return 'cash_fallback';
    }
  }

  await tx.vehicleInventory.create({
    data: {
      playerId,
      vehicleType,
      vehicleId: grant.vehicleId,
      stolenInCountry: country,
      currentLocation: country,
      condition: grant.condition,
      fuelLevel: grant.fuel,
      marketListing: false,
    },
  });

  return 'granted';
}

/**
 * Apply extended rewards inside an existing transaction.
 */
export async function fulfillExtendedEventRewards(
  tx: TransactionClient,
  playerId: number,
  rewards: Record<string, unknown>,
): Promise<void> {
  const ext = parseExtendedEventRewards(rewards);
  if (!hasExtendedEventRewards(ext)) return;

  for (const grant of ext.ammo) {
    await grantAmmo(tx, playerId, grant);
  }
  for (const grant of ext.tools) {
    await grantTool(tx, playerId, grant);
  }
  for (const grant of ext.weapons) {
    await grantWeapon(tx, playerId, grant);
  }
  await grantVehicleParts(tx, playerId, ext.vehicleParts);
  for (const grant of ext.vehicles) {
    await grantVehicle(tx, playerId, grant);
  }
}
