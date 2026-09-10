import { readFileSync } from 'fs';
import { join } from 'path';

type CatalogProperty = {
  id: string;
  storageCapacity?: number[];
};

let catalog: CatalogProperty[] | null = null;

function loadCatalog(): CatalogProperty[] {
  if (catalog) return catalog;
  const raw = readFileSync(join(__dirname, '../../content/properties.json'), 'utf8');
  const parsed = JSON.parse(raw) as { properties?: CatalogProperty[] };
  catalog = parsed.properties ?? [];
  return catalog;
}

/**
 * Storage slots from `properties.json` for this type and upgrade level.
 * House L1 = 10, apartment L1 = 5, warehouse L1 = 100.
 * Returns null when the catalog has no capacity array (fall back to DB).
 */
export function catalogStorageCapacity(
  propertyType: string,
  upgradeLevel: number,
): number | null {
  const def = loadCatalog().find((item) => item.id === propertyType);
  const caps = def?.storageCapacity;
  if (!Array.isArray(caps) || caps.length === 0) return null;
  const index = Math.max(0, Math.min(caps.length - 1, Math.floor(upgradeLevel) - 1));
  return Number(caps[index] ?? 0);
}
