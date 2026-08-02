/**
 * Holdable event collectables (not cash/XP/credits). Used by game-event reward
 * delivery and by marketplace kind `event_item`.
 */

import prisma from '../lib/prisma';

export type EventItemDefinition = {
  itemKey: string;
  nameNl: string;
  nameEn: string;
  /** Soft reference unit price for marketplace bounds (cash, not credits). */
  referenceUnitPrice: number;
  /** Soulbound / account-locked — never listable on the marketplace. */
  bound: boolean;
};

type TransactionClient = Parameters<Parameters<typeof prisma.$transaction>[0]>[0];

const EVENT_ITEM_CATALOG: Record<string, EventItemDefinition> = {
  event_chip_bronze: {
    itemKey: 'event_chip_bronze',
    nameNl: 'Event chip (brons)',
    nameEn: 'Event chip (bronze)',
    referenceUnitPrice: 5_000,
    bound: false,
  },
  event_chip_silver: {
    itemKey: 'event_chip_silver',
    nameNl: 'Event chip (zilver)',
    nameEn: 'Event chip (silver)',
    referenceUnitPrice: 15_000,
    bound: false,
  },
  event_chip_gold: {
    itemKey: 'event_chip_gold',
    nameNl: 'Event chip (goud)',
    nameEn: 'Event chip (gold)',
    referenceUnitPrice: 40_000,
    bound: false,
  },
  event_badge_rival: {
    itemKey: 'event_badge_rival',
    nameNl: 'Rival badge (gebonden)',
    nameEn: 'Rival badge (bound)',
    referenceUnitPrice: 25_000,
    bound: true,
  },
};

export type EventItemGrant = { itemKey: string; quantity: number };

function toPositiveInt(value: unknown): number {
  const n = Number(value);
  if (!Number.isFinite(n) || !Number.isInteger(n) || n <= 0) return 0;
  return n;
}

export function getEventItemDefinition(itemKey: string): EventItemDefinition | null {
  const key = String(itemKey ?? '').trim();
  return EVENT_ITEM_CATALOG[key] ?? null;
}

export function listEventItemCatalog(): EventItemDefinition[] {
  return Object.values(EVENT_ITEM_CATALOG);
}

/** Parse `rewardsJson.items` — array of { itemKey, quantity } or map { itemKey: qty }. */
export function parseEventItemGrants(rewards: Record<string, unknown>): EventItemGrant[] {
  const raw = rewards.items;
  const out: EventItemGrant[] = [];

  if (Array.isArray(raw)) {
    for (const entry of raw) {
      if (!entry || typeof entry !== 'object') continue;
      const row = entry as Record<string, unknown>;
      const itemKey = String(row.itemKey ?? row.key ?? '').trim();
      const quantity = toPositiveInt(row.quantity ?? row.qty);
      if (!itemKey || quantity <= 0) continue;
      if (!getEventItemDefinition(itemKey)) continue;
      out.push({ itemKey, quantity });
    }
    return out;
  }

  if (raw && typeof raw === 'object') {
    for (const [itemKey, qty] of Object.entries(raw as Record<string, unknown>)) {
      const quantity = toPositiveInt(qty);
      if (!itemKey || quantity <= 0) continue;
      if (!getEventItemDefinition(itemKey)) continue;
      out.push({ itemKey, quantity });
    }
  }

  return out;
}

export async function creditEventItem(
  tx: TransactionClient | typeof prisma,
  playerId: number,
  itemKey: string,
  quantity: number,
  sourceLiveEventId?: number | null,
): Promise<void> {
  const def = getEventItemDefinition(itemKey);
  if (!def) throw new Error('EVENT_ITEM_UNKNOWN');
  const qty = toPositiveInt(quantity);
  if (qty <= 0) throw new Error('INVALID_QUANTITY');

  const existing = await tx.playerEventItem.findUnique({
    where: { playerId_itemKey: { playerId, itemKey } },
  });

  if (existing) {
    await tx.playerEventItem.update({
      where: { id: existing.id },
      data: {
        quantity: existing.quantity + qty,
        ...(sourceLiveEventId != null ? { sourceLiveEventId } : {}),
      },
    });
    return;
  }

  await tx.playerEventItem.create({
    data: {
      playerId,
      itemKey,
      quantity: qty,
      sourceLiveEventId: sourceLiveEventId ?? null,
    },
  });
}

export async function debitEventItem(
  tx: TransactionClient | typeof prisma,
  playerId: number,
  itemKey: string,
  quantity: number,
): Promise<void> {
  const qty = toPositiveInt(quantity);
  if (qty <= 0) throw new Error('INVALID_QUANTITY');

  const updated = await tx.playerEventItem.updateMany({
    where: { playerId, itemKey, quantity: { gte: qty } },
    data: { quantity: { decrement: qty } },
  });
  if (updated.count === 0) {
    throw new Error('INSUFFICIENT_QTY');
  }
}

export async function getPlayerEventInventory(playerId: number) {
  const rows = await prisma.playerEventItem.findMany({
    where: { playerId, quantity: { gt: 0 } },
    orderBy: { itemKey: 'asc' },
  });

  return rows.map((row) => {
    const def = getEventItemDefinition(row.itemKey);
    return {
      id: row.id,
      itemKey: row.itemKey,
      quantity: row.quantity,
      bound: def?.bound ?? true,
      transferable: def ? !def.bound : false,
      nameNl: def?.nameNl ?? row.itemKey,
      nameEn: def?.nameEn ?? row.itemKey,
      referenceUnitPrice: def?.referenceUnitPrice ?? 0,
      sourceLiveEventId: row.sourceLiveEventId,
    };
  });
}

export const eventItemService = {
  getEventItemDefinition,
  listEventItemCatalog,
  parseEventItemGrants,
  creditEventItem,
  debitEventItem,
  getPlayerEventInventory,
};
