export type StorageCategory =
  | 'tools'
  | 'weapons'
  | 'cash'
  | 'ammo'
  | 'armor'
  | 'materials'
  | 'drugs'
  | 'trade';

const HOUSING_STASH: StorageCategory[] = [
  'tools',
  'weapons',
  'cash',
  'ammo',
  'armor',
  'materials',
  'drugs',
  'trade',
];

export const PROPERTY_STORAGE_RULES: Record<string, StorageCategory[]> = {
  warehouse: HOUSING_STASH,
  nightclub: ['drugs'],
  house: HOUSING_STASH,
  apartment: HOUSING_STASH,
  mansion: HOUSING_STASH,
  penthouse: HOUSING_STASH,
  safehouse: HOUSING_STASH,
};

export function allowedStorageCategories(propertyType: string): StorageCategory[] {
  return PROPERTY_STORAGE_RULES[propertyType] ?? [];
}
