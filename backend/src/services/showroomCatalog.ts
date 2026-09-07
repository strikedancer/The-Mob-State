import { readFileSync } from 'fs';
import { join } from 'path';

export const SHOWROOM_PROPERTY_IDS = [
  'car_showroom',
  'motorcycle_showroom',
  'boat_harbor',
] as const;

export type ShowroomPropertyId = (typeof SHOWROOM_PROPERTY_IDS)[number];
export type ShowroomVehicleType = 'car' | 'motorcycle' | 'boat';

export const SHOWROOM_CATEGORY: Record<ShowroomPropertyId, ShowroomVehicleType> = {
  car_showroom: 'car',
  motorcycle_showroom: 'motorcycle',
  boat_harbor: 'boat',
};

export const SHOWROOM_SLOT_STEPS = [8, 20, 40, 80] as const;

export const notInShowroomWhere = { showroomPropertyId: null } as const;

interface VehicleCatalogEntry {
  id: string;
  name: string;
  image?: string;
  imageNew?: string;
  imageDirty?: string;
  imageDamaged?: string;
  baseValue?: number;
}

interface VehiclesFile {
  cars?: VehicleCatalogEntry[];
  motorcycles?: VehicleCatalogEntry[];
  boats?: VehicleCatalogEntry[];
}

let catalogCache: Record<ShowroomVehicleType, VehicleCatalogEntry[]> | null = null;

function loadCatalog(): Record<ShowroomVehicleType, VehicleCatalogEntry[]> {
  if (catalogCache) return catalogCache;
  const raw = readFileSync(join(__dirname, '../../content/vehicles.json'), 'utf-8');
  const data = JSON.parse(raw) as VehiclesFile;
  catalogCache = {
    car: data.cars ?? [],
    motorcycle: data.motorcycles ?? [],
    boat: data.boats ?? [],
  };
  return catalogCache;
}

export function isShowroomProperty(propertyId: string): propertyId is ShowroomPropertyId {
  return (SHOWROOM_PROPERTY_IDS as readonly string[]).includes(propertyId);
}

export function getShowroomCategory(propertyId: string): ShowroomVehicleType | null {
  if (!isShowroomProperty(propertyId)) return null;
  return SHOWROOM_CATEGORY[propertyId];
}

export function getShowroomCatalogSize(propertyId: string): number {
  const category = getShowroomCategory(propertyId);
  if (!category) return 0;
  return loadCatalog()[category].length;
}

export function resolveShowroomSlotCaps(propertyId: string): number[] {
  const catalogSize = getShowroomCatalogSize(propertyId);
  if (catalogSize <= 0) return [0];
  const steps = [...SHOWROOM_SLOT_STEPS, catalogSize];
  return steps.map((step) => Math.max(1, Math.min(step, catalogSize)));
}

export function showroomSlotCapAtLevel(propertyId: string, level: number): number {
  const caps = resolveShowroomSlotCaps(propertyId);
  const index = Math.max(0, Math.min(caps.length - 1, level - 1));
  return caps[index] ?? 0;
}

export function findShowroomVehicleDef(vehicleId: string): VehicleCatalogEntry | null {
  const catalog = loadCatalog();
  return (
    catalog.car.find((item) => item.id === vehicleId) ??
    catalog.motorcycle.find((item) => item.id === vehicleId) ??
    catalog.boat.find((item) => item.id === vehicleId) ??
    null
  );
}

export function showroomVehicleImage(
  def: VehicleCatalogEntry | null,
  condition: number,
): string | null {
  if (!def) return null;
  if (condition >= 100) {
    return def.imageNew || def.imageDirty || def.imageDamaged || def.image || null;
  }
  if (condition >= 70) {
    return def.imageDirty || def.imageNew || def.imageDamaged || def.image || null;
  }
  return def.imageDamaged || def.imageDirty || def.imageNew || def.image || null;
}

export function isExhibited(vehicle: { showroomPropertyId?: number | null }): boolean {
  return vehicle.showroomPropertyId != null;
}

export function assertNotExhibited(vehicle: { showroomPropertyId?: number | null }): void {
  if (isExhibited(vehicle)) {
    throw new Error('VEHICLE_IN_SHOWROOM');
  }
}
