import prisma from '../lib/prisma';
import { timeProvider } from '../utils/timeProvider';
import { activityService } from './activityService';
import { propertyService } from './propertyService';
import { computeGarageSlotTotals } from './garageService';
import {
  SHOWROOM_PROPERTY_IDS,
  findShowroomVehicleDef,
  getShowroomCatalogSize,
  getShowroomCategory,
  isShowroomProperty,
  notInShowroomWhere,
  showroomSlotCapAtLevel,
  showroomVehicleImage,
  type ShowroomVehicleType,
} from './showroomCatalog';

export { isShowroomProperty, notInShowroomWhere };

function seizeOne(): boolean {
  return Math.random() < 0.4;
}

function mapVehicle(item: {
  id: number;
  vehicleId: string;
  vehicleType: string;
  condition: number;
  currentLocation: string;
  fuelLevel: number;
  showroomPlacedAt?: Date | null;
}) {
  const def = findShowroomVehicleDef(item.vehicleId);
  return {
    inventoryId: item.id,
    vehicleId: item.vehicleId,
    vehicleType: item.vehicleType,
    name: def?.name ?? item.vehicleId,
    image: showroomVehicleImage(def, item.condition),
    condition: item.condition,
    currentLocation: item.currentLocation,
    fuelLevel: item.fuelLevel,
    placedAt: item.showroomPlacedAt ?? null,
    baseValue: def?.baseValue ?? 0,
  };
}

async function garageOrMarinaHasSpace(
  playerId: number,
  countryId: string,
  vehicleType: ShowroomVehicleType,
): Promise<boolean> {
  if (vehicleType === 'boat') {
    const marina = await prisma.marina.findFirst({
      where: { playerId, location: countryId },
      include: { upgrades: { orderBy: { upgradeLevel: 'desc' }, take: 1 } },
    });
    if (!marina) return false;
    const totalCapacity = marina.capacity + (marina.upgrades[0]?.capacityBonus || 0);
    const currentBoats = await prisma.vehicleInventory.count({
      where: {
        playerId,
        currentLocation: countryId,
        vehicleType: 'boat',
        ...notInShowroomWhere,
      },
    });
    return currentBoats < totalCapacity;
  }

  const garage = await prisma.garage.findFirst({
    where: { playerId, location: countryId },
    include: { upgrades: true },
  });
  if (!garage) return false;
  const { carTotalCapacity, motorcycleTotalCapacity } = computeGarageSlotTotals(garage);
  const cap = vehicleType === 'motorcycle' ? motorcycleTotalCapacity : carTotalCapacity;
  const current = await prisma.vehicleInventory.count({
    where: {
      playerId,
      currentLocation: countryId,
      vehicleType,
      ...notInShowroomWhere,
    },
  });
  return current < cap;
}

class ShowroomService {
  async getShowroom(playerId: number, propertyDatabaseId: number) {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });
    if (!property || property.playerId !== playerId) {
      return { success: false as const, error: 'PROPERTY_NOT_FOUND' };
    }
    if (!isShowroomProperty(property.propertyType)) {
      return { success: false as const, error: 'NOT_A_SHOWROOM' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player) {
      return { success: false as const, error: 'PLAYER_NOT_FOUND' };
    }

    const category = getShowroomCategory(property.propertyType)!;
    const slotsMax = showroomSlotCapAtLevel(property.propertyType, property.upgradeLevel);
    const definition = propertyService.getPropertyDefinition(property.propertyType);
    const canManage = player.currentCountry === property.countryId;

    const exhibits = await prisma.vehicleInventory.findMany({
      where: { playerId, showroomPropertyId: property.id },
      orderBy: { showroomPlacedAt: 'asc' },
    });

    const eligibleRaw = canManage
      ? await prisma.vehicleInventory.findMany({
          where: {
            playerId,
            vehicleType: category,
            currentLocation: property.countryId,
            condition: 100,
            transportStatus: null,
            marketListing: false,
            ...notInShowroomWhere,
          },
          orderBy: { stolenAt: 'desc' },
        })
      : [];

    const exhibitedModels = new Set(exhibits.map((item) => item.vehicleId));
    const eligible = eligibleRaw.filter((item) => !exhibitedModels.has(item.vehicleId));

    return {
      success: true as const,
      showroom: {
        propertyId: property.id,
        propertyType: property.propertyType,
        name: definition?.name ?? property.propertyType,
        image: definition?.image ?? null,
        countryId: property.countryId,
        category,
        upgradeLevel: property.upgradeLevel,
        slotsUsed: exhibits.length,
        slotsMax,
        catalogSize: getShowroomCatalogSize(property.propertyType),
        canManage,
        exhibits: exhibits.map(mapVehicle),
        eligible: eligible.map(mapVehicle),
      },
    };
  }

  async placeVehicle(
    playerId: number,
    propertyDatabaseId: number,
    vehicleInventoryId: number,
  ) {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });
    if (!property || property.playerId !== playerId) {
      return { success: false as const, error: 'PROPERTY_NOT_FOUND' };
    }
    if (!isShowroomProperty(property.propertyType)) {
      return { success: false as const, error: 'NOT_A_SHOWROOM' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player) {
      return { success: false as const, error: 'PLAYER_NOT_FOUND' };
    }
    if (player.currentCountry !== property.countryId) {
      return { success: false as const, error: 'WRONG_COUNTRY' };
    }

    const category = getShowroomCategory(property.propertyType)!;
    const slotsMax = showroomSlotCapAtLevel(property.propertyType, property.upgradeLevel);

    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: vehicleInventoryId },
    });
    if (!vehicle || vehicle.playerId !== playerId) {
      return { success: false as const, error: 'VEHICLE_NOT_FOUND' };
    }
    if (vehicle.showroomPropertyId) {
      return { success: false as const, error: 'VEHICLE_IN_SHOWROOM' };
    }
    if (vehicle.vehicleType !== category) {
      return { success: false as const, error: 'SHOWROOM_WRONG_TYPE' };
    }
    if (vehicle.currentLocation !== property.countryId) {
      return { success: false as const, error: 'SHOWROOM_WRONG_COUNTRY' };
    }
    if (vehicle.condition < 100) {
      return { success: false as const, error: 'SHOWROOM_CONDITION' };
    }
    if (vehicle.transportStatus || vehicle.marketListing) {
      return { success: false as const, error: 'SHOWROOM_VEHICLE_BUSY' };
    }

    const exhibitedCount = await prisma.vehicleInventory.count({
      where: { showroomPropertyId: property.id },
    });
    if (exhibitedCount >= slotsMax) {
      return { success: false as const, error: 'SHOWROOM_FULL' };
    }

    const duplicate = await prisma.vehicleInventory.findFirst({
      where: {
        showroomPropertyId: property.id,
        vehicleId: vehicle.vehicleId,
      },
    });
    if (duplicate) {
      return { success: false as const, error: 'SHOWROOM_DUPLICATE_MODEL' };
    }

    await prisma.vehicleInventory.update({
      where: { id: vehicle.id },
      data: {
        showroomPropertyId: property.id,
        showroomPlacedAt: timeProvider.now(),
      },
    });

    const def = findShowroomVehicleDef(vehicle.vehicleId);
    await activityService.logActivity(
      playerId,
      'PROPERTY',
      `Zette ${def?.name ?? vehicle.vehicleId} in de collectie`,
      {
        propertyType: property.propertyType,
        vehicleId: vehicle.vehicleId,
        inventoryId: vehicle.id,
        country: property.countryId,
      },
    );

    return { success: true as const };
  }

  async removeVehicle(
    playerId: number,
    propertyDatabaseId: number,
    vehicleInventoryId: number,
  ) {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });
    if (!property || property.playerId !== playerId) {
      return { success: false as const, error: 'PROPERTY_NOT_FOUND' };
    }
    if (!isShowroomProperty(property.propertyType)) {
      return { success: false as const, error: 'NOT_A_SHOWROOM' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player) {
      return { success: false as const, error: 'PLAYER_NOT_FOUND' };
    }
    if (player.currentCountry !== property.countryId) {
      return { success: false as const, error: 'WRONG_COUNTRY' };
    }

    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: vehicleInventoryId },
    });
    if (!vehicle || vehicle.playerId !== playerId) {
      return { success: false as const, error: 'VEHICLE_NOT_FOUND' };
    }
    if (vehicle.showroomPropertyId !== property.id) {
      return { success: false as const, error: 'VEHICLE_NOT_IN_SHOWROOM' };
    }

    const category = getShowroomCategory(property.propertyType)!;
    const hasSpace = await garageOrMarinaHasSpace(playerId, property.countryId, category);
    if (!hasSpace) {
      return { success: false as const, error: 'SHOWROOM_GARAGE_FULL' };
    }

    await prisma.vehicleInventory.update({
      where: { id: vehicle.id },
      data: {
        showroomPropertyId: null,
        showroomPlacedAt: null,
      },
    });

    const def = findShowroomVehicleDef(vehicle.vehicleId);
    await activityService.logActivity(
      playerId,
      'PROPERTY',
      `Haalde ${def?.name ?? vehicle.vehicleId} uit de collectie`,
      {
        propertyType: property.propertyType,
        vehicleId: vehicle.vehicleId,
        inventoryId: vehicle.id,
        country: property.countryId,
      },
    );

    return { success: true as const };
  }

  async countExhibits(propertyDatabaseId: number): Promise<number> {
    return prisma.vehicleInventory.count({
      where: { showroomPropertyId: propertyDatabaseId },
    });
  }

  async searchShowroomsOnArrest(playerId: number): Promise<{
    showroomCount: number;
    vehiclesSeized: number;
    names: string[];
  }> {
    const empty = { showroomCount: 0, vehiclesSeized: 0, names: [] as string[] };
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player?.currentCountry) return empty;

    const showrooms = await prisma.property.findMany({
      where: {
        playerId,
        countryId: player.currentCountry,
        propertyType: { in: [...SHOWROOM_PROPERTY_IDS] },
      },
      select: { id: true, propertyType: true },
    });
    if (showrooms.length === 0) return empty;

    const exhibits = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        showroomPropertyId: { in: showrooms.map((item) => item.id) },
      },
    });

    const seizedNames: string[] = [];
    for (const vehicle of exhibits) {
      if (!seizeOne()) continue;
      const def = findShowroomVehicleDef(vehicle.vehicleId);
      await prisma.vehicleInventory.delete({ where: { id: vehicle.id } });
      seizedNames.push(def?.name ?? vehicle.vehicleId);
    }

    return {
      showroomCount: showrooms.length,
      vehiclesSeized: seizedNames.length,
      names: seizedNames,
    };
  }
}

export const showroomService = new ShowroomService();
