import prisma from '../lib/prisma';
import {
  STASH_MATERIAL_PREFIX,
  STASH_PROPERTY_TYPES,
  materialStashKey,
  parseMaterialStashKey,
} from '../utils/propertyStash';

/** Sentinel country value for materials stored in the personal backpack. */
export const CARRIED_MATERIAL_LOCATION = '_carried_';

/** Units of one material stack that fit in a single backpack slot. */
export const MATERIAL_UNITS_PER_SLOT = 5;

export function materialSlotsForQuantity(quantity: number): number {
  if (quantity <= 0) return 0;
  return Math.ceil(quantity / MATERIAL_UNITS_PER_SLOT);
}

export function isCarriedLocation(country: string | null | undefined): boolean {
  return (country ?? '') === CARRIED_MATERIAL_LOCATION;
}

type Tx = Parameters<Parameters<typeof prisma.$transaction>[0]>[0];

export async function getCarriedMaterialSlots(playerId: number): Promise<number> {
  const rows = await prisma.productionMaterial.findMany({
    where: { playerId, country: CARRIED_MATERIAL_LOCATION },
    select: { quantity: true },
  });
  return rows.reduce((sum, row) => sum + materialSlotsForQuantity(row.quantity), 0);
}

async function upsertDelta(
  tx: Tx,
  playerId: number,
  country: string,
  materialId: string,
  delta: number,
): Promise<void> {
  if (delta === 0) return;
  const existing = await tx.productionMaterial.findUnique({
    where: {
      playerId_country_materialId: { playerId, country, materialId },
    },
  });
  if (!existing) {
    if (delta < 0) {
      throw new Error('INSUFFICIENT_MATERIALS');
    }
    await tx.productionMaterial.create({
      data: { playerId, country, materialId, quantity: delta },
    });
    return;
  }
  const next = existing.quantity + delta;
  if (next < 0) {
    throw new Error('INSUFFICIENT_MATERIALS');
  }
  if (next === 0) {
    await tx.productionMaterial.delete({ where: { id: existing.id } });
    return;
  }
  await tx.productionMaterial.update({
    where: { id: existing.id },
    data: { quantity: next },
  });
}

export async function addMaterialStock(
  tx: Tx,
  playerId: number,
  country: string,
  materialId: string,
  quantity: number,
): Promise<void> {
  if (quantity <= 0) return;
  await upsertDelta(tx, playerId, country, materialId, quantity);
}

export async function removeMaterialStock(
  tx: Tx,
  playerId: number,
  country: string,
  materialId: string,
  quantity: number,
): Promise<void> {
  if (quantity <= 0) return;
  await upsertDelta(tx, playerId, country, materialId, -quantity);
}

async function propertyMaterialLots(
  playerId: number,
  currentCountry: string,
) {
  const properties = await prisma.property.findMany({
    where: {
      playerId,
      countryId: currentCountry,
      propertyType: { in: [...STASH_PROPERTY_TYPES] },
    },
    select: { id: true },
    orderBy: { id: 'asc' },
  });
  if (properties.length === 0) return [];
  const rows = await prisma.propertyDrugStorage.findMany({
    where: {
      propertyId: { in: properties.map((item) => item.id) },
      drugType: { startsWith: STASH_MATERIAL_PREFIX },
      quantity: { gt: 0 },
    },
  });
  return rows
    .map((row) => ({
      propertyId: row.propertyId,
      materialId: parseMaterialStashKey(row.drugType),
      quantity: row.quantity,
    }))
    .filter(
      (
        row,
      ): row is { propertyId: number; materialId: string; quantity: number } =>
        !!row.materialId,
    );
}

export async function getPropertyMaterialQuantities(
  playerId: number,
  currentCountry: string,
): Promise<Record<string, number>> {
  const lots = await propertyMaterialLots(playerId, currentCountry);
  const map: Record<string, number> = {};
  for (const lot of lots) {
    map[lot.materialId] = (map[lot.materialId] ?? 0) + lot.quantity;
  }
  return map;
}

async function removePropertyMaterialStock(
  tx: Tx,
  propertyId: number,
  materialId: string,
  quantity: number,
): Promise<void> {
  if (quantity <= 0) return;
  const key = materialStashKey(materialId);
  const existing = await tx.propertyDrugStorage.findUnique({
    where: { propertyId_drugType: { propertyId, drugType: key } },
  });
  if (!existing || existing.quantity < quantity) {
    throw new Error('INSUFFICIENT_MATERIALS');
  }
  if (existing.quantity === quantity) {
    await tx.propertyDrugStorage.delete({ where: { id: existing.id } });
    return;
  }
  await tx.propertyDrugStorage.update({
    where: { id: existing.id },
    data: { quantity: existing.quantity - quantity },
  });
}

/**
 * Available for production in the current country = local depot + house/warehouse + backpack.
 */
export async function getProductionAvailableMap(
  playerId: number,
  currentCountry: string,
): Promise<Record<string, { depot: number; stored: number; carried: number; total: number }>> {
  const rows = await prisma.productionMaterial.findMany({
    where: {
      playerId,
      OR: [{ country: currentCountry }, { country: CARRIED_MATERIAL_LOCATION }],
    },
  });
  const map: Record<string, { depot: number; stored: number; carried: number; total: number }> = {};
  for (const row of rows) {
    const entry = map[row.materialId] ?? { depot: 0, stored: 0, carried: 0, total: 0 };
    if (isCarriedLocation(row.country)) {
      entry.carried += row.quantity;
    } else {
      entry.depot += row.quantity;
    }
    entry.total = entry.depot + entry.stored + entry.carried;
    map[row.materialId] = entry;
  }
  const stored = await getPropertyMaterialQuantities(playerId, currentCountry);
  for (const [materialId, quantity] of Object.entries(stored)) {
    const entry = map[materialId] ?? { depot: 0, stored: 0, carried: 0, total: 0 };
    entry.stored += quantity;
    entry.total = entry.depot + entry.stored + entry.carried;
    map[materialId] = entry;
  }
  return map;
}

/**
 * Deduct required materials: prefer local depot, then house/warehouse in this country, then backpack.
 */
export async function deductForProduction(
  tx: Tx,
  playerId: number,
  currentCountry: string,
  requirements: Record<string, number>,
): Promise<void> {
  const available = await getProductionAvailableMap(playerId, currentCountry);
  for (const [materialId, required] of Object.entries(requirements)) {
    const have = available[materialId]?.total ?? 0;
    if (have < required) {
      throw new Error('INSUFFICIENT_MATERIALS');
    }
  }

  const lots = await propertyMaterialLots(playerId, currentCountry);

  for (const [materialId, required] of Object.entries(requirements)) {
    let left = required;
    const depotQty = available[materialId]?.depot ?? 0;
    const fromDepot = Math.min(depotQty, left);
    if (fromDepot > 0) {
      await removeMaterialStock(tx, playerId, currentCountry, materialId, fromDepot);
      left -= fromDepot;
    }
    if (left > 0) {
      for (const lot of lots) {
        if (lot.materialId !== materialId || lot.quantity <= 0 || left <= 0) continue;
        const take = Math.min(lot.quantity, left);
        await removePropertyMaterialStock(tx, lot.propertyId, materialId, take);
        lot.quantity -= take;
        left -= take;
      }
    }
    if (left > 0) {
      await removeMaterialStock(
        tx,
        playerId,
        CARRIED_MATERIAL_LOCATION,
        materialId,
        left,
      );
    }
  }
}

export function materialTravelConfiscationChance(
  carriedSlots: number,
  wantedLevel: number,
): number {
  const base = 0.1;
  const slotBonus = Math.min(0.25, carriedSlots * 0.03);
  const wantedBonus = Math.min(0.1, wantedLevel * 0.005);
  return Math.min(0.45, base + slotBonus + wantedBonus);
}

export function materialTravelArrestBonus(carriedSlots: number): number {
  return Math.min(0.12, carriedSlots * 0.015);
}
