import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';

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

  if (vehicle.playerId !== playerId || vehicle.vehicleType !== 'car') {
    throw new Error('NOT_OWNER');
  }

  if (vehicle.transportStatus) {
    throw new Error('VEHICLE_IN_TRANSIT');
  }

  await prisma.$transaction(async (tx) => {
    await tx.crewCarInventory.create({
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
  });
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

  await prisma.$transaction(async (tx) => {
    await tx.crewBoatInventory.create({
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
  });
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

  const currentTotal = await prisma.crewAmmoInventory.aggregate({
    where: { crewId },
    _sum: { quantity: true },
  });

  const currentQuantity = currentTotal._sum.quantity ?? 0;
  if (currentQuantity + quantity > capacity) {
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

  const currentTotal = await prisma.crewDrugInventory.aggregate({
    where: { crewId },
    _sum: { quantity: true },
  });

  const currentQuantity = currentTotal._sum.quantity ?? 0;
  if (currentQuantity + quantity > capacity) {
    throw new Error('DRUG_STORAGE_FULL');
  }

  const playerItem = await prisma.inventory.findUnique({
    where: {
      playerId_goodType: {
        playerId,
        goodType,
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

export async function getCrewStorageSummary(crewId: number) {
  const [
    carCapacity,
    boatCapacity,
    weaponCapacity,
    ammoCapacity,
    drugCapacity,
    cashCapacity,
  ] = await Promise.all([
    getCrewStorageCapacity(crewId, 'car_storage'),
    getCrewStorageCapacity(crewId, 'boat_storage'),
    getCrewStorageCapacity(crewId, 'weapon_storage'),
    getCrewStorageCapacity(crewId, 'ammo_storage'),
    getCrewStorageCapacity(crewId, 'drug_storage'),
    getCrewStorageCapacity(crewId, 'cash_storage'),
  ]);

  const [
    cars,
    boats,
    weapons,
    ammo,
    drugs,
    crew,
  ] = await Promise.all([
    prisma.crewCarInventory.findMany({ where: { crewId } }),
    prisma.crewBoatInventory.findMany({ where: { crewId } }),
    prisma.crewWeaponInventory.findMany({ where: { crewId } }),
    prisma.crewAmmoInventory.findMany({ where: { crewId } }),
    prisma.crewDrugInventory.findMany({ where: { crewId } }),
    prisma.crew.findUnique({ where: { id: crewId }, select: { bankBalance: true } }),
  ]);

  const weaponCount = weapons.reduce((sum, item) => sum + item.quantity, 0);
  const ammoCount = ammo.reduce((sum, item) => sum + item.quantity, 0);
  const drugCount = drugs.reduce((sum, item) => sum + item.quantity, 0);

  return {
    capacities: {
      cars: carCapacity,
      boats: boatCapacity,
      weapons: weaponCapacity,
      ammo: ammoCapacity,
      drugs: drugCapacity,
      cash: cashCapacity,
    },
    totals: {
      cars: cars.length,
      boats: boats.length,
      weapons: weaponCount,
      ammo: ammoCount,
      drugs: drugCount,
      cash: crew?.bankBalance ?? 0,
    },
    inventory: {
      cars,
      boats,
      weapons,
      ammo,
      drugs,
    },
  };
}
