export const STASH_MATERIAL_PREFIX = 'material:';
export const STASH_DRUG_PREFIX = 'drug:';
export const STASH_TRADE_PREFIX = 'trade:';
export const STASH_TRADE_PX_PREFIX = 'tradepx:';

/** Grams of one drug stack per property storage slot. */
export const DRUG_GRAMS_PER_SLOT = 50;
const MATERIAL_UNITS_PER_SLOT = 5;

export const STASH_PROPERTY_TYPES = [
  'warehouse',
  'house',
  'apartment',
  'mansion',
  'penthouse',
  'safehouse',
] as const;

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

export function stashSlotsForRow(drugType: string, quantity: number): number {
  if (quantity <= 0) return 0;
  if (drugType.startsWith(STASH_MATERIAL_PREFIX)) {
    return Math.ceil(quantity / MATERIAL_UNITS_PER_SLOT);
  }
  if (drugType.startsWith(STASH_DRUG_PREFIX)) {
    return drugSlotsForGrams(quantity);
  }
  if (drugType.startsWith(STASH_TRADE_PREFIX)) {
    return quantity;
  }
  return 0;
}

export function isMetaStashKey(drugType: string): boolean {
  return (
    drugType.startsWith(STASH_TRADE_PX_PREFIX) ||
    drugType.startsWith('armorcond:')
  );
}
