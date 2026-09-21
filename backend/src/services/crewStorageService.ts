import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';
import { vehicleService } from './vehicleService';
import { getCommittedTotals } from './territoryArsenalService';
import {
  completeDueCrewVehicleRepairs,
  copyPersonalTuningToCrewVehicle,
  decorateCrewVehicle,
  ensureCrewVehicleOpsSchema,
} from './crewVehicleOpsService';
import {
  debitBackpackTrade,
  getBackpackTradeQuantity,
  refreshInventorySlotUsage,
} from './carriedInventory';
import { ensureCrewPartsStorageSchema } from '../startup/ensureCrewPartsStorageSchema';
import {
  ammoSlotsForRounds,
  drugSlotsForGrams,
  tradeSlotsForLots,
  tradeSlotsForQuantity,
} from '../utils/propertyStash';

export type CrewPartType = 'car' | 'motorcycle' | 'boat';

function normalizeCrewPartType(value: string): CrewPartType | null {
  if (value === 'car' || value === 'motorcycle' || value === 'boat') return value;
  return null;
}

function crewPartsColumn(type: CrewPartType): 'carParts' | 'motorcycleParts' | 'boatParts' {
  if (type === 'boat') return 'boatParts';
  if (type === 'motorcycle') return 'motorcycleParts';
  return 'carParts';
}

async function getCrewAmmoSlotsUsed(crewId: number): Promise<number> {
  const rows = await prisma.crewAmmoInventory.findMany({
    where: { crewId, quantity: { gt: 0 } },
    select: { quantity: true },
  });
  return rows.reduce((sum, row) => sum + ammoSlotsForRounds(row.quantity), 0);
}

async function getCrewDrugSlotsUsed(crewId: number): Promise<number> {
  const [goods, lots] = await Promise.all([
    prisma.crewDrugInventory.findMany({
      where: { crewId, quantity: { gt: 0 } },
      select: { quantity: true },
    }),
    prisma.crewDrugLot.findMany({
      where: { crewId, quantity: { gt: 0 } },
      select: { quantity: true },
    }),
  ]);
  return (
    goods.reduce((sum, row) => sum + drugSlotsForGrams(row.quantity), 0) +
    lots.reduce((sum, row) => sum + drugSlotsForGrams(row.quantity), 0)
  );
}

async function getCrewTradeSlotsUsed(crewId: number): Promise<number> {
  const rows = await prisma.crewTradeInventory.findMany({
    where: { crewId, quantity: { gt: 0 } },
    select: { goodType: true, quantity: true },
  });
  return tradeSlotsForLots(rows);
}

function extraAmmoSlotsForAdd(
  currentRounds: number,
  addRounds: number,
): number {
  if (addRounds <= 0) return 0;
  return ammoSlotsForRounds(currentRounds + addRounds) - ammoSlotsForRounds(currentRounds);
}

function extraDrugSlotsForAdd(currentGrams: number, addGrams: number): number {
  if (addGrams <= 0) return 0;
  return drugSlotsForGrams(currentGrams + addGrams) - drugSlotsForGrams(currentGrams);
}

function extraTradeSlotsForAdd(
  goodType: string,
  currentQty: number,
  addQty: number,
): number {
  if (addQty <= 0) return 0;
  return (
    tradeSlotsForQuantity(goodType, currentQty + addQty) -
    tradeSlotsForQuantity(goodType, currentQty)
  );
}

function playerPartsColumn(type: CrewPartType): 'car_parts' | 'motorcycle_parts' | 'boat_parts' {
  if (type === 'boat') return 'boat_parts';
  if (type === 'motorcycle') return 'motorcycle_parts';
  return 'car_parts';
}

async function ensureCrewPartsInventoryRow(crewId: number) {
  await ensureCrewPartsStorageSchema();
  await prisma.$executeRaw`
    INSERT INTO crew_vehicle_parts_inventory (crewId, carParts, motorcycleParts, boatParts)
    VALUES (${crewId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE crewId = crewId
  `;
}

async function getCrewPartsTotals(crewId: number): Promise<{
  car: number;
  motorcycle: number;
  boat: number;
  total: number;
}> {
  await ensureCrewPartsInventoryRow(crewId);
  const rows = await prisma.$queryRaw<
    Array<{ carParts: number; motorcycleParts: number; boatParts: number }>
  >`
    SELECT carParts, motorcycleParts, boatParts
    FROM crew_vehicle_parts_inventory
    WHERE crewId = ${crewId}
    LIMIT 1
  `;
  const car = Number(rows[0]?.carParts ?? 0);
  const motorcycle = Number(rows[0]?.motorcycleParts ?? 0);
  const boat = Number(rows[0]?.boatParts ?? 0);
  return { car, motorcycle, boat, total: car + motorcycle + boat };
}

async function playerCountry(playerId: number): Promise<string> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  return player?.currentCountry?.trim() || 'netherlands';
}

function resolveCrewLandVehicleType(vehicleId: string): 'car' | 'motorcycle' {
  return vehicleService.getVehicleById(vehicleId)?.vehicleCategory === 'motorcycle'
    ? 'motorcycle'
    : 'car';
}

function crewVehicleCatalogArt(vehicleId: string, condition: number) {
  const def = vehicleService.getVehicleById(vehicleId);
  if (!def) {
    return { name: vehicleId, image: '', imageNew: '', imageDirty: '', imageDamaged: '' };
  }
  let image = '';
  if (condition >= 100 && def.imageNew) image = def.imageNew;
  else if (condition >= 70 && def.imageDirty) image = def.imageDirty;
  else if (condition < 70 && def.imageDamaged) image = def.imageDamaged;
  if (!image) {
    image = def.imageNew || def.imageDirty || def.imageDamaged || '';
  }
  return {
    name: def.name ?? vehicleId,
    image,
    imageNew: def.imageNew ?? '',
    imageDirty: def.imageDirty ?? '',
    imageDamaged: def.imageDamaged ?? '',
  };
}

export async function depositCrewCar(
  crewId: number,
  playerId: number,
  vehicleInventoryId: number
) {
  const capacity = await getCrewStorageCapacity(crewId, 'car_storage');
  if (capacity <= 0) {
    throw new Error('CAR_STORAGE_NOT_OWNED');
  }

  const currentCount = await prisma.crewCarInventory.count({
    where: { crewId },
  });
  if (currentCount >= capacity) {
    throw new Error('CAR_STORAGE_FULL');
  }

  const vehicle = await prisma.vehicleInventory.findUnique({
    where: { id: vehicleInventoryId },
  });

  if (!vehicle) {
    throw new Error('VEHICLE_NOT_FOUND');
  }

  if (
    vehicle.playerId !== playerId ||
    (vehicle.vehicleType !== 'car' && vehicle.vehicleType !== 'motorcycle')
  ) {
    throw new Error('NOT_OWNER');
  }

  if (vehicle.transportStatus) {
    throw new Error('VEHICLE_IN_TRANSIT');
  }

  if (vehicle.showroomPropertyId) {
    throw new Error('VEHICLE_IN_SHOWROOM');
  }

  await ensureCrewVehicleOpsSchema();
  const created = await prisma.$transaction(async (tx) => {
    const row = await tx.crewCarInventory.create({
      data: {
        crewId,
        vehicleId: vehicle.vehicleId,
        condition: vehicle.condition,
        fuelLevel: vehicle.fuelLevel,
        stolenInCountry: vehicle.stolenInCountry,
        addedByPlayerId: playerId,
      },
    });

    await tx.vehicleInventory.delete({
      where: { id: vehicleInventoryId },
    });
    return row;
  });
  await copyPersonalTuningToCrewVehicle(playerId, vehicleInventoryId, 'car', created.id);
}

export async function depositCrewBoat(
  crewId: number,
  playerId: number,
  vehicleInventoryId: number
) {
  const capacity = await getCrewStorageCapacity(crewId, 'boat_storage');
  if (capacity <= 0) {
    throw new Error('BOAT_STORAGE_NOT_OWNED');
  }

  const currentCount = await prisma.crewBoatInventory.count({
    where: { crewId },
  });
  if (currentCount >= capacity) {
    throw new Error('BOAT_STORAGE_FULL');
  }

  const vehicle = await prisma.vehicleInventory.findUnique({
    where: { id: vehicleInventoryId },
  });

  if (!vehicle) {
    throw new Error('VEHICLE_NOT_FOUND');
  }

  if (vehicle.playerId !== playerId || vehicle.vehicleType !== 'boat') {
    throw new Error('NOT_OWNER');
  }

  if (vehicle.transportStatus) {
    throw new Error('VEHICLE_IN_TRANSIT');
  }

  if (vehicle.showroomPropertyId) {
    throw new Error('VEHICLE_IN_SHOWROOM');
  }

  await ensureCrewVehicleOpsSchema();
  const created = await prisma.$transaction(async (tx) => {
    const row = await tx.crewBoatInventory.create({
      data: {
        crewId,
        vehicleId: vehicle.vehicleId,
        condition: vehicle.condition,
        fuelLevel: vehicle.fuelLevel,
        stolenInCountry: vehicle.stolenInCountry,
        addedByPlayerId: playerId,
      },
    });

    await tx.vehicleInventory.delete({
      where: { id: vehicleInventoryId },
    });
    return row;
  });
  await copyPersonalTuningToCrewVehicle(playerId, vehicleInventoryId, 'boat', created.id);
}

export async function depositCrewWeapon(
  crewId: number,
  playerId: number,
  weaponId: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'weapon_storage');
  if (capacity <= 0) {
    throw new Error('WEAPON_STORAGE_NOT_OWNED');
  }

  const currentTotal = await prisma.crewWeaponInventory.aggregate({
    where: { crewId },
    _sum: { quantity: true },
  });

  const currentQuantity = currentTotal._sum.quantity ?? 0;
  if (currentQuantity + quantity > capacity) {
    throw new Error('WEAPON_STORAGE_FULL');
  }

  const playerWeapon = await prisma.weaponInventory.findUnique({
    where: {
      playerId_weaponId: {
        playerId,
        weaponId,
      },
    },
  });

  if (!playerWeapon || playerWeapon.quantity < quantity) {
    throw new Error('INSUFFICIENT_WEAPONS');
  }

  await prisma.$transaction(async (tx) => {
    if (playerWeapon.quantity === quantity) {
      await tx.weaponInventory.delete({
        where: { id: playerWeapon.id },
      });
    } else {
      await tx.weaponInventory.update({
        where: { id: playerWeapon.id },
        data: { quantity: playerWeapon.quantity - quantity },
      });
    }

    const existing = await tx.crewWeaponInventory.findUnique({
      where: {
        crewId_weaponId: {
          crewId,
          weaponId,
        },
      },
    });

    if (existing) {
      const totalQty = existing.quantity + quantity;
      const weightedCondition = Math.floor(
        (existing.averageCondition * existing.quantity + playerWeapon.condition * quantity) / totalQty
      );
      await tx.crewWeaponInventory.update({
        where: { id: existing.id },
        data: {
          quantity: totalQty,
          averageCondition: weightedCondition,
        },
      });
    } else {
      await tx.crewWeaponInventory.create({
        data: {
          crewId,
          weaponId,
          quantity,
          averageCondition: playerWeapon.condition,
        },
      });
    }
  });
}

export async function depositCrewTool(
  crewId: number,
  playerId: number,
  playerToolId: number
) {
  const capacity = await getCrewStorageCapacity(crewId, 'tool_storage');
  if (capacity <= 0) {
    throw new Error('TOOL_STORAGE_NOT_OWNED');
  }

  const currentCount = await prisma.crewToolInventory.count({
    where: { crewId },
  });
  if (currentCount >= capacity) {
    throw new Error('TOOL_STORAGE_FULL');
  }

  const playerTool = await prisma.playerTools.findUnique({
    where: { id: playerToolId },
  });

  if (!playerTool) {
    throw new Error('TOOL_NOT_FOUND');
  }
  if (playerTool.playerId !== playerId) {
    throw new Error('NOT_OWNER');
  }
  if (playerTool.location !== 'carried') {
    throw new Error('TOOL_NOT_CARRIED');
  }
  if (playerTool.durability <= 0) {
    throw new Error('TOOL_BROKEN');
  }

  await prisma.$transaction(async (tx) => {
    await tx.crewToolInventory.create({
      data: {
        crewId,
        toolId: playerTool.toolId,
        durability: playerTool.durability,
        addedByPlayerId: playerId,
      },
    });

    if (playerTool.quantity > 1) {
      await tx.playerTools.update({
        where: { id: playerToolId },
        data: { quantity: playerTool.quantity - 1 },
      });
    } else {
      await tx.playerTools.delete({
        where: { id: playerToolId },
      });
    }
  });
}

export async function depositCrewParts(
  crewId: number,
  playerId: number,
  partsTypeInput: string,
  quantity: number
) {
  const partsType = normalizeCrewPartType(partsTypeInput);
  if (!partsType) {
    throw new Error('INVALID_PARTS_TYPE');
  }
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'parts_storage');
  if (capacity <= 0) {
    throw new Error('PARTS_STORAGE_NOT_OWNED');
  }

  const current = await getCrewPartsTotals(crewId);
  if (current.total + quantity > capacity) {
    throw new Error('PARTS_STORAGE_FULL');
  }

  await prisma.$executeRaw`
    INSERT INTO player_vehicle_parts (player_id, car_parts, motorcycle_parts, boat_parts)
    VALUES (${playerId}, 0, 0, 0)
    ON DUPLICATE KEY UPDATE player_id = player_id
  `;
  const playerRows = await prisma.$queryRaw<
    Array<{ car_parts: number; motorcycle_parts: number; boat_parts: number }>
  >`
    SELECT car_parts, motorcycle_parts, boat_parts
    FROM player_vehicle_parts
    WHERE player_id = ${playerId}
    LIMIT 1
  `;
  const available =
    partsType === 'boat'
      ? Number(playerRows[0]?.boat_parts ?? 0)
      : partsType === 'motorcycle'
        ? Number(playerRows[0]?.motorcycle_parts ?? 0)
        : Number(playerRows[0]?.car_parts ?? 0);
  if (available < quantity) {
    throw new Error('INSUFFICIENT_PARTS');
  }

  const crewColumn = crewPartsColumn(partsType);
  const playerColumn = playerPartsColumn(partsType);
  await prisma.$transaction([
    prisma.$executeRawUnsafe(
      `UPDATE player_vehicle_parts SET ${playerColumn} = ${playerColumn} - ? WHERE player_id = ? AND ${playerColumn} >= ?`,
      quantity,
      playerId,
      quantity
    ),
    prisma.$executeRawUnsafe(
      `UPDATE crew_vehicle_parts_inventory SET ${crewColumn} = ${crewColumn} + ? WHERE crewId = ?`,
      quantity,
      crewId
    ),
  ]);
}

export async function getCrewPartsStock(crewId: number, partsType: CrewPartType): Promise<number> {
  const totals = await getCrewPartsTotals(crewId);
  return totals[partsType];
}

export { getCrewPartsTotals };

export async function depositCrewAmmo(
  crewId: number,
  playerId: number,
  ammoType: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'ammo_storage');
  if (capacity <= 0) {
    throw new Error('AMMO_STORAGE_NOT_OWNED');
  }

  const existingCrewAmmo = await prisma.crewAmmoInventory.findUnique({
    where: { crewId_ammoType: { crewId, ammoType } },
    select: { quantity: true },
  });
  const usedSlots = await getCrewAmmoSlotsUsed(crewId);
  const extraSlots = extraAmmoSlotsForAdd(existingCrewAmmo?.quantity ?? 0, quantity);
  if (usedSlots + extraSlots > capacity) {
    throw new Error('AMMO_STORAGE_FULL');
  }

  const playerAmmo = await prisma.ammoInventory.findUnique({
    where: {
      playerId_ammoType: {
        playerId,
        ammoType,
      },
    },
  });

  if (!playerAmmo || playerAmmo.quantity < quantity) {
    throw new Error('INSUFFICIENT_AMMO');
  }

  await prisma.$transaction(async (tx) => {
    if (playerAmmo.quantity === quantity) {
      await tx.ammoInventory.delete({
        where: { id: playerAmmo.id },
      });
    } else {
      await tx.ammoInventory.update({
        where: { id: playerAmmo.id },
        data: { quantity: playerAmmo.quantity - quantity },
      });
    }

    await tx.crewAmmoInventory.upsert({
      where: {
        crewId_ammoType: {
          crewId,
          ammoType,
        },
      },
      create: {
        crewId,
        ammoType,
        quantity,
      },
      update: {
        quantity: { increment: quantity },
      },
    });
  });
}

async function getCrewDrugStorageUsed(crewId: number): Promise<number> {
  return getCrewDrugSlotsUsed(crewId);
}

export async function depositCrewDrugLots(
  crewId: number,
  playerId: number,
  drugType: string,
  quality: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'drug_storage');
  if (capacity <= 0) {
    throw new Error('DRUG_STORAGE_NOT_OWNED');
  }

  const existingLot = await prisma.crewDrugLot.findUnique({
    where: { crewId_drugType_quality: { crewId, drugType, quality } },
    select: { quantity: true },
  });
  const usedSlots = await getCrewDrugSlotsUsed(crewId);
  const extraSlots = extraDrugSlotsForAdd(existingLot?.quantity ?? 0, quantity);
  if (usedSlots + extraSlots > capacity) {
    throw new Error('DRUG_STORAGE_FULL');
  }

  const playerItem = await prisma.drugInventory.findUnique({
    where: { playerId_drugType_quality: { playerId, drugType, quality } },
  });
  if (!playerItem || playerItem.quantity < quantity) {
    throw new Error('INSUFFICIENT_DRUGS');
  }

  await prisma.$transaction(async (tx) => {
    if (playerItem.quantity === quantity) {
      await tx.drugInventory.delete({ where: { id: playerItem.id } });
    } else {
      await tx.drugInventory.update({
        where: { id: playerItem.id },
        data: { quantity: playerItem.quantity - quantity },
      });
    }

    await tx.crewDrugLot.upsert({
      where: { crewId_drugType_quality: { crewId, drugType, quality } },
      create: { crewId, drugType, quality, quantity },
      update: { quantity: { increment: quantity } },
    });
  });
}

export async function withdrawCrewDrugLots(
  crewId: number,
  playerId: number,
  drugType: string,
  quality: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const lot = await prisma.crewDrugLot.findUnique({
    where: { crewId_drugType_quality: { crewId, drugType, quality } },
  });
  if (!lot || lot.quantity < quantity) {
    throw new Error('INSUFFICIENT_CREW_DRUGS');
  }

  await prisma.$transaction(async (tx) => {
    if (lot.quantity === quantity) {
      await tx.crewDrugLot.delete({ where: { id: lot.id } });
    } else {
      await tx.crewDrugLot.update({
        where: { id: lot.id },
        data: { quantity: lot.quantity - quantity },
      });
    }

    const existing = await tx.drugInventory.findUnique({
      where: { playerId_drugType_quality: { playerId, drugType, quality } },
    });
    if (existing) {
      await tx.drugInventory.update({
        where: { id: existing.id },
        data: { quantity: existing.quantity + quantity },
      });
    } else {
      await tx.drugInventory.create({
        data: { playerId, drugType, quality, quantity, ownProduction: false },
      });
    }
  });
}

export async function depositCrewDrugs(
  crewId: number,
  playerId: number,
  goodType: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'drug_storage');
  if (capacity <= 0) {
    throw new Error('DRUG_STORAGE_NOT_OWNED');
  }

  const existingLegacy = await prisma.crewDrugInventory.findUnique({
    where: { crewId_goodType: { crewId, goodType } },
    select: { quantity: true },
  });
  const usedSlots = await getCrewDrugSlotsUsed(crewId);
  const extraSlots = extraDrugSlotsForAdd(existingLegacy?.quantity ?? 0, quantity);
  if (usedSlots + extraSlots > capacity) {
    throw new Error('DRUG_STORAGE_FULL');
  }

  const country = await playerCountry(playerId);
  const playerItem = await prisma.inventory.findUnique({
    where: {
      playerId_goodType_country: {
        playerId,
        goodType,
        country,
      },
    },
  });

  if (!playerItem || playerItem.quantity < quantity) {
    throw new Error('INSUFFICIENT_DRUGS');
  }

  await prisma.$transaction(async (tx) => {
    if (playerItem.quantity === quantity) {
      await tx.inventory.delete({
        where: { id: playerItem.id },
      });
    } else {
      await tx.inventory.update({
        where: { id: playerItem.id },
        data: { quantity: playerItem.quantity - quantity },
      });
    }

    const existing = await tx.crewDrugInventory.findUnique({
      where: {
        crewId_goodType: {
          crewId,
          goodType,
        },
      },
    });

    if (existing) {
      const totalQty = existing.quantity + quantity;
      const weightedPrice = Math.floor(
        (existing.averagePurchasePrice * existing.quantity + playerItem.purchasePrice * quantity) / totalQty
      );
      const weightedCondition = Math.floor(
        (existing.averageCondition * existing.quantity + playerItem.condition * quantity) / totalQty
      );
      await tx.crewDrugInventory.update({
        where: { id: existing.id },
        data: {
          quantity: totalQty,
          averagePurchasePrice: weightedPrice,
          averageCondition: weightedCondition,
        },
      });
    } else {
      await tx.crewDrugInventory.create({
        data: {
          crewId,
          goodType,
          quantity,
          averagePurchasePrice: playerItem.purchasePrice,
          averageCondition: playerItem.condition,
        },
      });
    }
  });
}

export async function depositCrewTradeGoods(
  crewId: number,
  playerId: number,
  goodType: string,
  quantity: number
) {
  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const capacity = await getCrewStorageCapacity(crewId, 'trade_storage');
  if (capacity <= 0) {
    throw new Error('TRADE_STORAGE_NOT_OWNED');
  }

  const existingTrade = await prisma.crewTradeInventory.findUnique({
    where: { crewId_goodType: { crewId, goodType } },
    select: { quantity: true },
  });
  const usedSlots = await getCrewTradeSlotsUsed(crewId);
  const extraSlots = extraTradeSlotsForAdd(
    goodType,
    existingTrade?.quantity ?? 0,
    quantity,
  );
  if (usedSlots + extraSlots > capacity) {
    throw new Error('TRADE_STORAGE_FULL');
  }

  const country = await playerCountry(playerId);
  const available = await getBackpackTradeQuantity(playerId, goodType, country);
  if (available < quantity) {
    throw new Error('INSUFFICIENT_TRADE_GOODS');
  }

  await prisma.$transaction(async (tx) => {
    const taken = await debitBackpackTrade(tx, playerId, country, goodType, quantity);

    const existing = await tx.crewTradeInventory.findUnique({
      where: { crewId_goodType: { crewId, goodType } },
    });
    if (existing) {
      const totalQty = existing.quantity + quantity;
      const weightedPrice = Math.floor(
        (existing.averagePurchasePrice * existing.quantity + taken.purchasePrice * quantity) / totalQty
      );
      const weightedCondition = Math.floor(
        (existing.averageCondition * existing.quantity + taken.condition * quantity) / totalQty
      );
      await tx.crewTradeInventory.update({
        where: { id: existing.id },
        data: {
          quantity: totalQty,
          averagePurchasePrice: weightedPrice,
          averageCondition: weightedCondition,
        },
      });
    } else {
      await tx.crewTradeInventory.create({
        data: {
          crewId,
          goodType,
          quantity,
          averagePurchasePrice: taken.purchasePrice,
          averageCondition: taken.condition,
        },
      });
    }
  });
  await refreshInventorySlotUsage(playerId);
}

/** Deduct crew trade inventory when starting a mission that requires contraband cargo. */
export async function consumeCrewTradeGoods(
  crewId: number,
  requirements: Array<{ goodType: string; quantity: number }>
): Promise<void> {
  if (!requirements.length) {
    return;
  }

  await prisma.$transaction(async (tx) => {
    for (const req of requirements) {
      const inv = await tx.crewTradeInventory.findUnique({
        where: { crewId_goodType: { crewId, goodType: req.goodType } },
      });
      if (!inv || inv.quantity < req.quantity) {
        throw new Error('MISSION_TRADE_REQUIREMENTS_NOT_MET');
      }
    }

    for (const req of requirements) {
      const inv = await tx.crewTradeInventory.findUnique({
        where: { crewId_goodType: { crewId, goodType: req.goodType } },
      });
      if (!inv) {
        throw new Error('MISSION_TRADE_REQUIREMENTS_NOT_MET');
      }
      if (inv.quantity === req.quantity) {
        await tx.crewTradeInventory.delete({ where: { id: inv.id } });
      } else {
        await tx.crewTradeInventory.update({
          where: { id: inv.id },
          data: { quantity: inv.quantity - req.quantity },
        });
      }
    }
  });
}

export async function getCrewStorageSummary(crewId: number, viewerCountry = 'netherlands') {
  await completeDueCrewVehicleRepairs(crewId);
  const [
    carCapacity,
    boatCapacity,
    weaponCapacity,
    toolCapacity,
    partsCapacity,
    ammoCapacity,
    drugCapacity,
    tradeCapacity,
    cashCapacity,
  ] = await Promise.all([
    getCrewStorageCapacity(crewId, 'car_storage'),
    getCrewStorageCapacity(crewId, 'boat_storage'),
    getCrewStorageCapacity(crewId, 'weapon_storage'),
    getCrewStorageCapacity(crewId, 'tool_storage'),
    getCrewStorageCapacity(crewId, 'parts_storage'),
    getCrewStorageCapacity(crewId, 'ammo_storage'),
    getCrewStorageCapacity(crewId, 'drug_storage'),
    getCrewStorageCapacity(crewId, 'trade_storage'),
    getCrewStorageCapacity(crewId, 'cash_storage'),
  ]);
  const parts = await getCrewPartsTotals(crewId);

  const [
    cars,
    boats,
    weapons,
    tools,
    ammo,
    drugs,
    drugLots,
    tradeGoods,
    crew,
  ] = await Promise.all([
    prisma.$queryRaw<
      Array<{
        id: number;
        crewId: number;
        vehicleId: string;
        condition: number;
        fuelLevel: number;
        stolenInCountry: string | null;
        addedByPlayerId: number;
        addedAt: Date;
        speed_level: number;
        stealth_level: number;
        armor_level: number;
        tune_cooldown_until: Date | null;
        repair_completes_at: Date | null;
        repair_cost: number | null;
      }>
    >`
      SELECT id, crewId, vehicleId, \`condition\`, fuelLevel, stolenInCountry,
             addedByPlayerId, addedAt, speed_level, stealth_level, armor_level,
             tune_cooldown_until, repair_completes_at, repair_cost
      FROM crew_car_inventory
      WHERE crewId = ${crewId}
    `,
    prisma.$queryRaw<
      Array<{
        id: number;
        crewId: number;
        vehicleId: string;
        condition: number;
        fuelLevel: number;
        stolenInCountry: string | null;
        addedByPlayerId: number;
        addedAt: Date;
        speed_level: number;
        stealth_level: number;
        armor_level: number;
        tune_cooldown_until: Date | null;
        repair_completes_at: Date | null;
        repair_cost: number | null;
      }>
    >`
      SELECT id, crewId, vehicleId, \`condition\`, fuelLevel, stolenInCountry,
             addedByPlayerId, addedAt, speed_level, stealth_level, armor_level,
             tune_cooldown_until, repair_completes_at, repair_cost
      FROM crew_boat_inventory
      WHERE crewId = ${crewId}
    `,
    prisma.crewWeaponInventory.findMany({ where: { crewId } }),
    prisma.crewToolInventory.findMany({ where: { crewId } }),
    prisma.crewAmmoInventory.findMany({ where: { crewId } }),
    prisma.crewDrugInventory.findMany({ where: { crewId } }),
    prisma.crewDrugLot.findMany({ where: { crewId } }),
    prisma.crewTradeInventory.findMany({ where: { crewId } }),
    prisma.crew.findUnique({ where: { id: crewId }, select: { bankBalance: true } }),
  ]);

  const weaponCount = weapons.reduce((sum, item) => sum + item.quantity, 0);
  const ammoCount = ammo.reduce((sum, item) => sum + ammoSlotsForRounds(item.quantity), 0);
  const committed = await getCommittedTotals(crewId).catch(() => ({ weapons: 0, ammo: 0 }));
  const drugCount =
    drugs.reduce((sum, item) => sum + drugSlotsForGrams(item.quantity), 0) +
    drugLots.reduce((sum, item) => sum + drugSlotsForGrams(item.quantity), 0);
  const tradeCount = tradeSlotsForLots(tradeGoods);
  const carsWithType = cars.map((vehicle) => {
    const normalized = {
      ...vehicle,
      condition: Number(vehicle.condition ?? 0),
      fuelLevel: Number(vehicle.fuelLevel ?? 0),
      speed_level: Number(vehicle.speed_level ?? 0),
      stealth_level: Number(vehicle.stealth_level ?? 0),
      armor_level: Number(vehicle.armor_level ?? 0),
      repair_cost: vehicle.repair_cost == null ? null : Number(vehicle.repair_cost),
    };
    const art = crewVehicleCatalogArt(normalized.vehicleId, normalized.condition);
    return {
      ...normalized,
      vehicleType: resolveCrewLandVehicleType(normalized.vehicleId),
      ...art,
      ...decorateCrewVehicle(normalized, 'car', viewerCountry),
    };
  });
  const boatsWithName = boats.map((vehicle) => {
    const normalized = {
      ...vehicle,
      condition: Number(vehicle.condition ?? 0),
      fuelLevel: Number(vehicle.fuelLevel ?? 0),
      speed_level: Number(vehicle.speed_level ?? 0),
      stealth_level: Number(vehicle.stealth_level ?? 0),
      armor_level: Number(vehicle.armor_level ?? 0),
      repair_cost: vehicle.repair_cost == null ? null : Number(vehicle.repair_cost),
    };
    const art = crewVehicleCatalogArt(normalized.vehicleId, normalized.condition);
    return {
      ...normalized,
      ...art,
      ...decorateCrewVehicle(normalized, 'boat', viewerCountry),
    };
  });

  return {
    capacities: {
      cars: carCapacity,
      boats: boatCapacity,
      weapons: weaponCapacity,
      tools: toolCapacity,
      parts: partsCapacity,
      ammo: ammoCapacity,
      drugs: drugCapacity,
      trade: tradeCapacity,
      cash: cashCapacity,
    },
    totals: {
      cars: cars.length,
      boats: boats.length,
      weapons: weaponCount,
      tools: tools.length,
      parts: parts.total,
      ammo: ammoCount,
      drugs: drugCount,
      trade: tradeCount,
      cash: crew?.bankBalance ?? 0,
    },
    committed: {
      weapons: committed.weapons,
      ammo: committed.ammo,
    },
    inventory: {
      cars: carsWithType,
      boats: boatsWithName,
      weapons,
      tools,
      parts: [
        { partsType: 'car', quantity: parts.car },
        { partsType: 'motorcycle', quantity: parts.motorcycle },
        { partsType: 'boat', quantity: parts.boat },
      ].filter((row) => row.quantity > 0),
      ammo,
      drugs,
      drugLots,
      trade: tradeGoods,
    },
  };
}
