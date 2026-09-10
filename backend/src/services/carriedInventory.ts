import prisma from '../lib/prisma';
import {
  CARRIED_TRADE_LOCATION,
  drugSlotsForGrams,
  tradeSlotsForQuantity,
} from '../utils/propertyStash';
import { CARRIED_MATERIAL_LOCATION } from './productionMaterialStock';

type Tx = {
  inventory: typeof prisma.inventory;
  drugInventory: typeof prisma.drugInventory;
  productionMaterial: typeof prisma.productionMaterial;
  player: typeof prisma.player;
};

export async function getCarriedDrugSlots(playerId: number): Promise<number> {
  const rows = await prisma.drugInventory.findMany({
    where: { playerId, quantity: { gt: 0 } },
    select: { quantity: true },
  });
  return rows.reduce((sum, row) => sum + drugSlotsForGrams(row.quantity), 0);
}

/** Trade currently riding in the backpack sentinel. Travels with the player. */
export async function getCarriedTradeSlots(playerId: number): Promise<number> {
  const rows = await prisma.inventory.findMany({
    where: { playerId, country: CARRIED_TRADE_LOCATION, quantity: { gt: 0 } },
    select: { quantity: true },
  });
  return rows.reduce((sum, row) => sum + tradeSlotsForQuantity(row.quantity), 0);
}

/**
 * Backpack trade slots: carried lots plus leftover current-country warehouse
 * lots (legacy stock still usable here until stashed or sold).
 */
export async function getBackpackTradeSlots(playerId: number): Promise<number> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  const currentCountry = player?.currentCountry;
  const rows = await prisma.inventory.findMany({
    where: {
      playerId,
      quantity: { gt: 0 },
      OR: [
        { country: CARRIED_TRADE_LOCATION },
        ...(currentCountry ? [{ country: currentCountry }] : []),
      ],
    },
    select: { quantity: true },
  });
  return rows.reduce((sum, row) => sum + tradeSlotsForQuantity(row.quantity), 0);
}

export async function getRiskyBackpackSlots(playerId: number): Promise<number> {
  const { getCarriedMaterialSlots } = await import('./productionMaterialStock');
  const [materials, drugs, trade] = await Promise.all([
    getCarriedMaterialSlots(playerId),
    getCarriedDrugSlots(playerId),
    getCarriedTradeSlots(playerId),
  ]);
  return materials + drugs + trade;
}

export async function extraSlotsForDrugAdd(
  playerId: number,
  drugType: string,
  quality: string,
  quantity: number,
): Promise<number> {
  const existing = await prisma.drugInventory.findUnique({
    where: { playerId_drugType_quality: { playerId, drugType, quality } },
    select: { quantity: true },
  });
  const current = existing?.quantity ?? 0;
  return drugSlotsForGrams(current + quantity) - drugSlotsForGrams(current);
}

export async function extraSlotsForTradeAdd(
  playerId: number,
  quantity: number,
): Promise<number> {
  return tradeSlotsForQuantity(quantity);
}

export async function assertBackpackFits(
  playerId: number,
  extraSlots: number,
): Promise<void> {
  if (extraSlots <= 0) return;
  const toolService = (await import('./toolService')).default;
  const { getPlayerCarryingCapacity } = await import('./backpackService');
  const used = await toolService.calculateInventoryUsage(playerId);
  const max = await getPlayerCarryingCapacity(playerId);
  if (used + extraSlots > max) {
    throw new Error('INVENTORY_FULL');
  }
}

export async function refreshInventorySlotUsage(playerId: number): Promise<void> {
  const toolService = (await import('./toolService')).default;
  const usage = await toolService.calculateInventoryUsage(playerId);
  await prisma.player.update({
    where: { id: playerId },
    data: { inventory_slots_used: usage },
  });
}

export async function getBackpackTradeQuantity(
  playerId: number,
  goodType: string,
  currentCountry: string,
): Promise<number> {
  const [carried, leftover] = await Promise.all([
    prisma.inventory.findUnique({
      where: {
        playerId_goodType_country: {
          playerId,
          goodType,
          country: CARRIED_TRADE_LOCATION,
        },
      },
    }),
    prisma.inventory.findUnique({
      where: {
        playerId_goodType_country: {
          playerId,
          goodType,
          country: currentCountry,
        },
      },
    }),
  ]);
  return (carried?.quantity || 0) + (leftover?.quantity || 0);
}

export async function listBackpackTradeLots(
  playerId: number,
  currentCountry: string,
) {
  const rows = await prisma.inventory.findMany({
    where: {
      playerId,
      quantity: { gt: 0 },
      OR: [
        { country: CARRIED_TRADE_LOCATION },
        { country: currentCountry },
      ],
    },
    orderBy: { goodType: 'asc' },
  });
  const merged = new Map<
    string,
    {
      goodType: string;
      quantity: number;
      purchasePrice: number;
      condition: number;
    }
  >();
  for (const row of rows) {
    const existing = merged.get(row.goodType);
    if (!existing) {
      merged.set(row.goodType, {
        goodType: row.goodType,
        quantity: row.quantity,
        purchasePrice: row.purchasePrice ?? 0,
        condition: row.condition ?? 100,
      });
      continue;
    }
    const nextQty = existing.quantity + row.quantity;
    existing.purchasePrice = Math.floor(
      (existing.quantity * existing.purchasePrice +
        row.quantity * (row.purchasePrice ?? 0)) /
        Math.max(1, nextQty),
    );
    existing.condition = Math.min(existing.condition, row.condition ?? 100);
    existing.quantity = nextQty;
  }
  return [...merged.values()];
}

export async function debitBackpackTrade(
  tx: Tx,
  playerId: number,
  currentCountry: string,
  goodType: string,
  quantity: number,
): Promise<{ purchasePrice: number; condition: number; purchasedAt: Date | null }> {
  if (quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }
  const [carried, leftover] = await Promise.all([
    tx.inventory.findUnique({
      where: {
        playerId_goodType_country: {
          playerId,
          goodType,
          country: CARRIED_TRADE_LOCATION,
        },
      },
    }),
    tx.inventory.findUnique({
      where: {
        playerId_goodType_country: {
          playerId,
          goodType,
          country: currentCountry,
        },
      },
    }),
  ]);
  const available = (carried?.quantity || 0) + (leftover?.quantity || 0);
  if (available < quantity) {
    throw new Error('INSUFFICIENT_GOODS');
  }

  let remaining = quantity;
  let value = 0;
  let condition = 100;
  let purchasedAt: Date | null = null;

  const takeFrom = async (
    row: { id: number; quantity: number; purchasePrice: number | null; condition: number | null; purchasedAt: Date | null } | null,
  ) => {
    if (!row || remaining <= 0 || row.quantity <= 0) return;
    const take = Math.min(row.quantity, remaining);
    remaining -= take;
    value += take * (row.purchasePrice ?? 0);
    condition = Math.min(condition, row.condition ?? 100);
    if (row.purchasedAt && (!purchasedAt || row.purchasedAt < purchasedAt)) {
      purchasedAt = row.purchasedAt;
    }
    if (take >= row.quantity) {
      await tx.inventory.delete({ where: { id: row.id } });
    } else {
      await tx.inventory.update({
        where: { id: row.id },
        data: { quantity: row.quantity - take, lastUpdated: new Date() },
      });
    }
  };

  await takeFrom(carried);
  await takeFrom(leftover);

  return {
    purchasePrice: Math.floor(value / Math.max(1, quantity)),
    condition,
    purchasedAt,
  };
}

export async function creditCarriedTrade(
  tx: Tx,
  playerId: number,
  goodType: string,
  quantity: number,
  purchasePrice: number,
  condition = 100,
  purchasedAt?: Date | null,
): Promise<void> {
  if (quantity <= 0) return;
  const existing = await tx.inventory.findUnique({
    where: {
      playerId_goodType_country: {
        playerId,
        goodType,
        country: CARRIED_TRADE_LOCATION,
      },
    },
  });
  if (existing) {
    const nextQty = existing.quantity + quantity;
    const blendedPrice = Math.floor(
      (existing.quantity * (existing.purchasePrice ?? 0) + quantity * purchasePrice) /
        Math.max(1, nextQty),
    );
    await tx.inventory.update({
      where: { id: existing.id },
      data: {
        quantity: nextQty,
        purchasePrice: blendedPrice,
        condition: Math.min(existing.condition ?? 100, condition),
        lastUpdated: new Date(),
        ...(purchasedAt && (!existing.purchasedAt || purchasedAt < existing.purchasedAt)
          ? { purchasedAt }
          : {}),
      },
    });
    return;
  }
  await tx.inventory.create({
    data: {
      playerId,
      goodType,
      country: CARRIED_TRADE_LOCATION,
      quantity,
      purchasePrice,
      condition,
      ...(purchasedAt ? { purchasedAt } : {}),
    },
  });
}

function seizeAmount(quantity: number): number {
  if (quantity <= 0) return 0;
  const raw = quantity * 0.4;
  const base = Math.floor(raw);
  const remainder = raw - base;
  return base + (remainder > 0 && Math.random() < remainder ? 1 : 0);
}

export async function confiscateCarriedDrugs(
  playerId: number,
  chance: number,
): Promise<Array<{ drugType: string; quality: string; quantity: number }>> {
  const rows = await prisma.drugInventory.findMany({
    where: { playerId, quantity: { gt: 0 } },
  });
  const confiscated: Array<{ drugType: string; quality: string; quantity: number }> = [];
  for (const row of rows) {
    if (Math.random() >= chance) continue;
    const lost = Math.max(1, Math.floor(row.quantity * (0.3 + Math.random() * 0.4)));
    confiscated.push({ drugType: row.drugType, quality: row.quality, quantity: lost });
    const remaining = row.quantity - lost;
    if (remaining <= 0) {
      await prisma.drugInventory.delete({ where: { id: row.id } });
    } else {
      await prisma.drugInventory.update({
        where: { id: row.id },
        data: { quantity: remaining },
      });
    }
  }
  return confiscated;
}

export async function confiscateCarriedTrade(
  playerId: number,
  chance: number,
): Promise<Array<{ goodType: string; quantity: number }>> {
  const rows = await prisma.inventory.findMany({
    where: { playerId, country: CARRIED_TRADE_LOCATION, quantity: { gt: 0 } },
  });
  const confiscated: Array<{ goodType: string; quantity: number }> = [];
  for (const row of rows) {
    if (Math.random() >= chance) continue;
    const lost = Math.max(1, Math.floor(row.quantity * (0.3 + Math.random() * 0.4)));
    confiscated.push({ goodType: row.goodType, quantity: lost });
    const remaining = row.quantity - lost;
    if (remaining <= 0) {
      await prisma.inventory.delete({ where: { id: row.id } });
    } else {
      await prisma.inventory.update({
        where: { id: row.id },
        data: { quantity: remaining },
      });
    }
  }
  return confiscated;
}

export async function seizeCarriedOnArrest(playerId: number): Promise<{
  seizedUnits: number;
}> {
  let seizedUnits = 0;
  const drugs = await prisma.drugInventory.findMany({
    where: { playerId, quantity: { gt: 0 } },
  });
  for (const row of drugs) {
    const take = seizeAmount(row.quantity);
    if (take <= 0) continue;
    seizedUnits += take;
    if (take >= row.quantity) {
      await prisma.drugInventory.delete({ where: { id: row.id } });
    } else {
      await prisma.drugInventory.update({
        where: { id: row.id },
        data: { quantity: row.quantity - take },
      });
    }
  }

  const trade = await prisma.inventory.findMany({
    where: { playerId, country: CARRIED_TRADE_LOCATION, quantity: { gt: 0 } },
  });
  for (const row of trade) {
    const take = seizeAmount(row.quantity);
    if (take <= 0) continue;
    seizedUnits += take;
    if (take >= row.quantity) {
      await prisma.inventory.delete({ where: { id: row.id } });
    } else {
      await prisma.inventory.update({
        where: { id: row.id },
        data: { quantity: row.quantity - take },
      });
    }
  }

  const materials = await prisma.productionMaterial.findMany({
    where: { playerId, country: CARRIED_MATERIAL_LOCATION, quantity: { gt: 0 } },
  });
  for (const row of materials) {
    const take = seizeAmount(row.quantity);
    if (take <= 0) continue;
    seizedUnits += take;
    if (take >= row.quantity) {
      await prisma.productionMaterial.delete({ where: { id: row.id } });
    } else {
      await prisma.productionMaterial.update({
        where: { id: row.id },
        data: { quantity: row.quantity - take },
      });
    }
  }

  if (seizedUnits > 0) {
    await refreshInventorySlotUsage(playerId);
  }

  return { seizedUnits };
}
