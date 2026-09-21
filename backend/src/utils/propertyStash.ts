import tradableGoods from '../../content/tradableGoods.json';

export const STASH_MATERIAL_PREFIX = 'material:';
export const STASH_DRUG_PREFIX = 'drug:';
export const STASH_TRADE_PREFIX = 'trade:';
export const STASH_TRADE_PX_PREFIX = 'tradepx:';

/** Sentinel `inventory.country` for trade goods in the personal backpack. */
export const CARRIED_TRADE_LOCATION = '_carried_';

/** Grams of one drug stack per property / backpack slot. */
export const DRUG_GRAMS_PER_SLOT = 100;
export const MATERIAL_UNITS_PER_SLOT = 5;
/**
 * Default trade packing for weight-1 (compact) goods.
 * Prefer {@link tradeUnitsPerTile} for per-good volume.
 */
export const TRADE_UNITS_PER_SLOT = 10;

export const STASH_PROPERTY_TYPES = [
  'warehouse',
  'house',
  'apartment',
  'mansion',
  'penthouse',
  'safehouse',
] as const;

type TradeCatalogEntry = {
  id: string;
  weight?: number;
  unitsPerTile?: number;
};

const tradeCatalog = tradableGoods as TradeCatalogEntry[];
const tradeUnitsById = new Map<string, number>();

/** Map catalog `weight` → how many units fit in one storage tile. */
export function unitsPerTileFromWeight(weight: number): number {
  const w = Math.max(1, Math.floor(Number(weight) || 1));
  if (w <= 1) return 10;
  if (w === 2) return 5;
  if (w === 3) return 3;
  return 2;
}

function resolveTradeUnitsPerTile(entry: TradeCatalogEntry | undefined): number {
  if (!entry) return TRADE_UNITS_PER_SLOT;
  const explicit = Number(entry.unitsPerTile);
  if (Number.isFinite(explicit) && explicit > 0) {
    return Math.floor(explicit);
  }
  return unitsPerTileFromWeight(Number(entry.weight) || 1);
}

for (const entry of tradeCatalog) {
  tradeUnitsById.set(entry.id, resolveTradeUnitsPerTile(entry));
}

/** How many units of this trade good fit in one tile (backpack / house / crew / cargo). */
export function tradeUnitsPerTile(goodType: string): number {
  const known = tradeUnitsById.get(goodType);
  if (known != null) return known;
  const entry = tradeCatalog.find((g) => g.id === goodType);
  return resolveTradeUnitsPerTile(entry);
}

export function materialStashKey(materialId: string): string {
  return `${STASH_MATERIAL_PREFIX}${materialId}`;
}

export function drugStashKey(drugType: string, quality: string): string {
  return `${STASH_DRUG_PREFIX}${drugType}:${quality}`;
}

export function tradeStashKey(goodType: string): string {
  return `${STASH_TRADE_PREFIX}${goodType}`;
}

export function tradePriceStashKey(goodType: string): string {
  return `${STASH_TRADE_PX_PREFIX}${goodType}`;
}

export function parseMaterialStashKey(key: string): string | null {
  if (!key.startsWith(STASH_MATERIAL_PREFIX)) return null;
  const id = key.slice(STASH_MATERIAL_PREFIX.length);
  return id || null;
}

export function parseDrugStashKey(
  key: string,
): { drugType: string; quality: string } | null {
  if (!key.startsWith(STASH_DRUG_PREFIX)) return null;
  const rest = key.slice(STASH_DRUG_PREFIX.length);
  const idx = rest.lastIndexOf(':');
  if (idx <= 0) return null;
  const drugType = rest.slice(0, idx);
  const quality = rest.slice(idx + 1);
  if (!drugType || !quality) return null;
  return { drugType, quality };
}

export function parseTradeStashKey(key: string): string | null {
  if (!key.startsWith(STASH_TRADE_PREFIX)) return null;
  const id = key.slice(STASH_TRADE_PREFIX.length);
  return id || null;
}

export function drugSlotsForGrams(grams: number): number {
  if (grams <= 0) return 0;
  return Math.ceil(grams / DRUG_GRAMS_PER_SLOT);
}

export function tradeSlotsForQuantity(goodType: string, quantity: number): number {
  if (quantity <= 0) return 0;
  const perTile = tradeUnitsPerTile(goodType);
  return Math.ceil(quantity / Math.max(1, perTile));
}

export function tradeSlotsForLots(
  rows: Array<{ goodType: string; quantity: number }>,
): number {
  const byType = new Map<string, number>();
  for (const row of rows) {
    byType.set(row.goodType, (byType.get(row.goodType) ?? 0) + row.quantity);
  }
  let sum = 0;
  for (const [goodType, qty] of byType.entries()) {
    sum += tradeSlotsForQuantity(goodType, qty);
  }
  return sum;
}

export function isCarriedTradeLocation(country: string | null | undefined): boolean {
  return (country ?? '') === CARRIED_TRADE_LOCATION;
}

export const CASH_PER_SLOT = 10000;
export const AMMO_ROUNDS_PER_SLOT = 50;

export function ammoSlotsForRounds(rounds: number): number {
  if (rounds <= 0) return 0;
  return Math.ceil(rounds / AMMO_ROUNDS_PER_SLOT);
}

export function cashSlotsForAmount(amount: number): number {
  if (amount <= 0) return 0;
  return Math.ceil(amount / CASH_PER_SLOT);
}

/** How many extra units fit without needing more than `freeSlots` new cells. */
export function maxAddForSlotStack(
  currentQty: number,
  unitsPerSlot: number,
  freeSlots: number,
): number {
  if (unitsPerSlot <= 0) return 0;
  const safeCurrent = Math.max(0, currentQty);
  const safeFree = Math.max(0, freeSlots);
  const remainder = safeCurrent % unitsPerSlot;
  const roomInPartial = remainder === 0 ? 0 : unitsPerSlot - remainder;
  return roomInPartial + safeFree * unitsPerSlot;
}

export function computePropertySlotUsage(input: {
  toolUsage: number;
  weaponQuantity: number;
  ammoUsage: number;
  armorQuantity: number;
  cashAmount: number;
  leftoverDrugRows: Array<{ drugType: string; quantity: number }>;
  stashRows: Array<{ drugType: string; quantity: number }>;
}): number {
  return (
    Math.max(0, input.toolUsage) +
    Math.max(0, input.weaponQuantity) +
    Math.max(0, input.ammoUsage) +
    Math.max(0, input.armorQuantity) +
    cashSlotsForAmount(input.cashAmount) +
    input.leftoverDrugRows.reduce(
      (sum, row) => sum + drugSlotsForGrams(row.quantity),
      0,
    ) +
    input.stashRows.reduce(
      (sum, row) => sum + stashSlotsForRow(row.drugType, row.quantity),
      0,
    )
  );
}

export function stashSlotsForRow(drugType: string, quantity: number): number {
  if (quantity <= 0) return 0;
  if (drugType.startsWith(STASH_MATERIAL_PREFIX)) {
    return Math.ceil(quantity / MATERIAL_UNITS_PER_SLOT);
  }
  if (drugType.startsWith(STASH_DRUG_PREFIX)) {
    return drugSlotsForGrams(quantity);
  }
  if (drugType.startsWith(STASH_TRADE_PREFIX)) {
    const goodType = parseTradeStashKey(drugType);
    return tradeSlotsForQuantity(goodType ?? '', quantity);
  }
  return 0;
}

export function isMetaStashKey(drugType: string): boolean {
  return (
    drugType.startsWith(STASH_TRADE_PX_PREFIX) ||
    drugType.startsWith('armorcond:')
  );
}
