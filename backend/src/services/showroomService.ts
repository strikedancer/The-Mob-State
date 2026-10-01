import prisma from '../lib/prisma';
import { timeProvider } from '../utils/timeProvider';
import { activityService } from './activityService';
import { propertyService } from './propertyService';
import { computeGarageSlotTotals } from './garageService';
import { resolveSelectedCrimeVehicle } from './vehicleToolService';
import {
  SHOWROOM_PROPERTY_IDS,
  SHOWROOM_CAT_COOLDOWN_SECONDS,
  findShowroomVehicleDef,
  getShowroomCatalogSize,
  getShowroomCategory,
  getShowroomPropertyTypeForVehicle,
  isShowroomProperty,
  notInShowroomWhere,
  showroomCatCost,
  showroomSlotCapAtLevel,
  showroomVehicleDisplayValue,
  showroomVehicleImage,
  showroomVehicleRarity,
  type ShowroomVehicleType,
} from './showroomCatalog';
import { checkCooldown, setCooldown } from './cooldownService';

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
  showroomCatted?: boolean | null;
}) {
  const def = findShowroomVehicleDef(item.vehicleId);
  const baseValue = def?.baseValue ?? 0;
  const value = showroomVehicleDisplayValue(def, item.condition);
  const catted = Boolean(item.showroomCatted);
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
    baseValue,
    value,
    rarity: showroomVehicleRarity(def),
    catted,
    catCost: catted ? 0 : showroomCatCost(def),
  };
}

function rarityCounts(vehicles: Array<{ rarity: string }>): Record<string, number> {
  const counts: Record<string, number> = {};
  for (const vehicle of vehicles) {
    const key = vehicle.rarity || 'common';
    counts[key] = (counts[key] ?? 0) + 1;
  }
  return counts;
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

export type PublicShowroomExhibit = {
  inventoryId: number;
  vehicleId: string;
  name: string;
  rarity: string;
  image: string | null;
};

export type PublicShowroomStats = {
  slotsUsed: number;
  slotsMax: number;
  catalogSize: number;
  totalValue: number;
  rarityCounts: Record<string, number>;
  exhibits: PublicShowroomExhibit[];
};

class ShowroomService {
  /**
   * Prestige showroom summary for public profiles.
   * Includes exhibit name/image/rarity for showcase; no country / eligible garage intel.
   */
  async getPublicShowroomStatsByPropertyId(
    playerId: number,
  ): Promise<Map<number, PublicShowroomStats>> {
    const showrooms = await prisma.property.findMany({
      where: {
        playerId,
        propertyType: { in: [...SHOWROOM_PROPERTY_IDS] },
      },
      select: { id: true, propertyType: true, upgradeLevel: true },
    });

    const result = new Map<number, PublicShowroomStats>();
    if (showrooms.length === 0) return result;

    const exhibits = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        showroomPropertyId: { in: showrooms.map((row) => row.id) },
      },
      select: {
        id: true,
        showroomPropertyId: true,
        vehicleId: true,
        condition: true,
      },
      orderBy: { showroomPlacedAt: 'asc' },
    });

    const byProperty = new Map<number, typeof exhibits>();
    for (const exhibit of exhibits) {
      const propertyId = exhibit.showroomPropertyId;
      if (propertyId == null) continue;
      const list = byProperty.get(propertyId) ?? [];
      list.push(exhibit);
      byProperty.set(propertyId, list);
    }

    for (const showroom of showrooms) {
      const rows = byProperty.get(showroom.id) ?? [];
      const mapped = rows.map((row) => {
        const def = findShowroomVehicleDef(row.vehicleId);
        return {
          inventoryId: row.id,
          vehicleId: row.vehicleId,
          name: def?.name ?? row.vehicleId,
          rarity: showroomVehicleRarity(def),
          image: showroomVehicleImage(def),
          value: showroomVehicleDisplayValue(def, row.condition),
        };
      });
      result.set(showroom.id, {
        slotsUsed: rows.length,
        slotsMax: showroomSlotCapAtLevel(showroom.propertyType, showroom.upgradeLevel),
        catalogSize: getShowroomCatalogSize(showroom.propertyType),
        totalValue: mapped.reduce((sum, item) => sum + (item.value || 0), 0),
        rarityCounts: rarityCounts(mapped),
        exhibits: mapped.map(({ inventoryId, vehicleId, name, rarity, image }) => ({
          inventoryId,
          vehicleId,
          name,
          rarity,
          image,
        })),
      });
    }

    return result;
  }

  async getExhibitedVehicleIds(playerId: number): Promise<string[]> {
    const rows = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        showroomPropertyId: { not: null },
      },
      select: { vehicleId: true },
      distinct: ['vehicleId'],
    });
    return rows.map((row) => row.vehicleId).filter((id) => Boolean(id));
  }

  /**
   * Lightweight map of owned showrooms so garage/marina can offer Place without
   * opening Eigendommen first.
   */
  async getOwnedShowroomTargets(playerId: number): Promise<
    Partial<Record<ShowroomVehicleType, { propertyId: number; countryId: string }>>
  > {
    const rows = await prisma.property.findMany({
      where: {
        playerId,
        propertyType: { in: [...SHOWROOM_PROPERTY_IDS] },
      },
      select: { id: true, propertyType: true, countryId: true },
    });
    const result: Partial<
      Record<ShowroomVehicleType, { propertyId: number; countryId: string }>
    > = {};
    for (const row of rows) {
      const category = getShowroomCategory(row.propertyType);
      if (!category) continue;
      result[category] = {
        propertyId: row.id,
        countryId: row.countryId,
      };
    }
    return result;
  }

  async placeVehicleFromInventory(playerId: number, vehicleInventoryId: number) {
    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: vehicleInventoryId },
      select: { id: true, playerId: true, vehicleType: true },
    });
    if (!vehicle || vehicle.playerId !== playerId) {
      return { success: false as const, error: 'VEHICLE_NOT_FOUND' };
    }

    const propertyType = getShowroomPropertyTypeForVehicle(vehicle.vehicleType);
    if (!propertyType) {
      return { success: false as const, error: 'SHOWROOM_WRONG_TYPE' };
    }

    const property = await prisma.property.findFirst({
      where: { playerId, propertyType },
      select: { id: true },
    });
    if (!property) {
      return { success: false as const, error: 'SHOWROOM_NOT_OWNED' };
    }

    return this.placeVehicle(playerId, property.id, vehicleInventoryId);
  }

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
    const mappedExhibits = exhibits.map(mapVehicle);
    const totalValue = mappedExhibits.reduce((sum, item) => sum + (item.value || 0), 0);
    const catCooldownRemainingSeconds = await checkCooldown(playerId, 'showroom_cat');

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
        totalValue,
        rarityCounts: rarityCounts(mappedExhibits),
        canManage,
        catCooldownRemainingSeconds,
        catCooldownSeconds: SHOWROOM_CAT_COOLDOWN_SECONDS,
        exhibits: mappedExhibits,
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
        showroomCatted: false,
      },
    });

    // Drop crime-vehicle selection if this was the only usable copy of that model.
    await resolveSelectedCrimeVehicle(playerId, player.currentCountry!);

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
        showroomCatted: false,
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

  /**
   * Forge clean papers for an exhibited vehicle (cash).
   * Police/FBI skip seize while `showroomCatted` stays true in the vitrine.
   */
  async catVehicle(
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
      select: { currentCountry: true, money: true },
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
    if (vehicle.showroomCatted) {
      return { success: false as const, error: 'SHOWROOM_ALREADY_CATTED' };
    }

    const remainingCooldown = await checkCooldown(playerId, 'showroom_cat');
    if (remainingCooldown > 0) {
      return {
        success: false as const,
        error: 'SHOWROOM_CAT_COOLDOWN',
        remainingSeconds: remainingCooldown,
      };
    }

    const def = findShowroomVehicleDef(vehicle.vehicleId);
    const cost = showroomCatCost(def);
    if (player.money < cost) {
      return { success: false as const, error: 'INSUFFICIENT_FUNDS', cost };
    }

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: cost } },
      }),
      prisma.vehicleInventory.update({
        where: { id: vehicle.id },
        data: { showroomCatted: true },
      }),
    ]);

    const cooldown = await setCooldown(playerId, 'showroom_cat');

    await activityService.logActivity(
      playerId,
      'PROPERTY',
      `Catte papieren voor ${def?.name ?? vehicle.vehicleId} in de collectie`,
      {
        propertyType: property.propertyType,
        vehicleId: vehicle.vehicleId,
        inventoryId: vehicle.id,
        country: property.countryId,
        cost,
        cooldownSeconds: SHOWROOM_CAT_COOLDOWN_SECONDS,
      },
    );

    return {
      success: true as const,
      cost,
      remainingSeconds: cooldown.remainingSeconds,
    };
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
    vehiclesProtected: number;
  }> {
    const empty = {
      showroomCount: 0,
      vehiclesSeized: 0,
      names: [] as string[],
      vehiclesProtected: 0,
    };
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
    let skippedCatted = 0;
    for (const vehicle of exhibits) {
      if (vehicle.showroomCatted) {
        skippedCatted += 1;
        continue;
      }
      if (!seizeOne()) continue;
      const def = findShowroomVehicleDef(vehicle.vehicleId);
      await prisma.vehicleInventory.delete({ where: { id: vehicle.id } });
      seizedNames.push(def?.name ?? vehicle.vehicleId);
    }

    return {
      showroomCount: showrooms.length,
      vehiclesSeized: seizedNames.length,
      names: seizedNames,
      vehiclesProtected: skippedCatted,
    };
  }
}

export const showroomService = new ShowroomService();
