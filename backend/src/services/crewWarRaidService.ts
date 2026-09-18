import { Prisma } from '@prisma/client';
import {
  getCrewBuildingRecord,
  getCrewStorageCapacity,
  type CrewBuildingStyle,
  type CrewBuildingType,
} from './crewBuildingService';

export const RAID_LOOT_TARGETS = [
  'cash',
  'car',
  'boat',
  'weapon',
  'tool',
  'ammo',
  'drug',
  'trade',
] as const;

export type RaidLootTarget = (typeof RAID_LOOT_TARGETS)[number];

export const SABOTAGE_BUILDING_TYPES: Exclude<CrewBuildingType, 'hq'>[] = [
  'car_storage',
  'boat_storage',
  'weapon_storage',
  'tool_storage',
  'ammo_storage',
  'drug_storage',
  'trade_storage',
  'cash_storage',
];

export function isRaidLootTarget(value: string | undefined): value is RaidLootTarget {
  return Boolean(value && (RAID_LOOT_TARGETS as readonly string[]).includes(value));
}

export function isSabotageBuildingType(
  value: string | undefined,
): value is Exclude<CrewBuildingType, 'hq'> {
  return Boolean(value && (SABOTAGE_BUILDING_TYPES as readonly string[]).includes(value));
}

function styleForSideLevel(level: number): CrewBuildingStyle {
  if (level >= 11) return 'vip';
  if (level >= 8) return 'villa';
  if (level >= 5) return 'city';
  if (level >= 3) return 'rural';
  return 'camping';
}

function sliceStack(quantity: number, fraction: number, minTake: number, maxTake: number): number {
  if (quantity <= 0) return 0;
  return Math.min(quantity, Math.max(minTake, Math.min(maxTake, Math.floor(quantity * fraction))));
}

async function defenderHasShield(
  tx: Prisma.TransactionClient,
  warId: number,
  defenderCrewId: number,
): Promise<boolean> {
  const since = new Date(Date.now() - 75 * 60 * 1000);
  const row = await tx.crewWarAction.findFirst({
    where: {
      warId,
      actorCrewId: defenderCrewId,
      actionType: 'crew_shield',
      result: 'success',
      createdAt: { gte: since },
    },
    select: { id: true },
  });
  return Boolean(row);
}

export async function applyWarRaidLoot(
  tx: Prisma.TransactionClient,
  input: {
    warId: number;
    attackerCrewId: number;
    defenderCrewId: number;
    actorPlayerId: number;
    lootTarget: RaidLootTarget;
  },
): Promise<{ moneyDelta: number; metadata: Record<string, unknown> }> {
  const shielded = await defenderHasShield(tx, input.warId, input.defenderCrewId);
  const shrink = (n: number) => (shielded ? Math.floor(n * 0.6) : n);

  if (input.lootTarget === 'cash') {
    const [defender, attacker] = await Promise.all([
      tx.crew.findUnique({ where: { id: input.defenderCrewId }, select: { bankBalance: true } }),
      tx.crew.findUnique({ where: { id: input.attackerCrewId }, select: { bankBalance: true } }),
    ]);
    const bankBalance = defender?.bankBalance ?? 0;
    let loot = shrink(Math.max(0, Math.min(75000, Math.floor(bankBalance * 0.08))));
    const cap = await getCrewStorageCapacity(input.attackerCrewId, 'cash_storage');
    const room = Math.max(0, cap - (attacker?.bankBalance ?? 0));
    loot = Math.min(loot, room);
    if (loot <= 0) {
      throw new Error(bankBalance <= 0 ? 'RAID_NOTHING_TO_STEAL' : 'RAID_NO_CAPACITY');
    }
    const taken = await tx.crew.updateMany({
      where: { id: input.defenderCrewId, bankBalance: { gte: loot } },
      data: { bankBalance: { decrement: loot } },
    });
    if (taken.count !== 1) {
      throw new Error('RAID_NOTHING_TO_STEAL');
    }
    await tx.crew.update({
      where: { id: input.attackerCrewId },
      data: { bankBalance: { increment: loot } },
    });
    return {
      moneyDelta: loot,
      metadata: { lootTarget: 'cash', amount: loot, shielded, taken: true },
    };
  }

  if (input.lootTarget === 'car' || input.lootTarget === 'boat') {
    const isCar = input.lootTarget === 'car';
    const cap = await getCrewStorageCapacity(
      input.attackerCrewId,
      isCar ? 'car_storage' : 'boat_storage',
    );
    const owned = isCar
      ? await tx.crewCarInventory.count({ where: { crewId: input.attackerCrewId } })
      : await tx.crewBoatInventory.count({ where: { crewId: input.attackerCrewId } });
    if (cap <= 0 || owned >= cap) {
      throw new Error('RAID_NO_CAPACITY');
    }
    if (shielded) {
      return {
        moneyDelta: 0,
        metadata: { lootTarget: input.lootTarget, shielded: true, taken: false },
      };
    }
    const vehicle = isCar
      ? await tx.crewCarInventory.findFirst({
          where: { crewId: input.defenderCrewId },
          orderBy: { addedAt: 'desc' },
        })
      : await tx.crewBoatInventory.findFirst({
          where: { crewId: input.defenderCrewId },
          orderBy: { addedAt: 'desc' },
        });
    if (!vehicle) {
      throw new Error('RAID_NOTHING_TO_STEAL');
    }
    if (isCar) {
      await tx.crewCarInventory.update({
        where: { id: vehicle.id },
        data: { crewId: input.attackerCrewId, addedByPlayerId: input.actorPlayerId },
      });
    } else {
      await tx.crewBoatInventory.update({
        where: { id: vehicle.id },
        data: { crewId: input.attackerCrewId, addedByPlayerId: input.actorPlayerId },
      });
    }
    return {
      moneyDelta: 0,
      metadata: {
        lootTarget: input.lootTarget,
        vehicleId: vehicle.vehicleId,
        inventoryId: vehicle.id,
        shielded,
        taken: true,
      },
    };
  }

  if (input.lootTarget === 'weapon') {
    const stack = await tx.crewWeaponInventory.findFirst({
      where: { crewId: input.defenderCrewId, quantity: { gt: 0 } },
      orderBy: { quantity: 'desc' },
    });
    if (!stack) throw new Error('RAID_NOTHING_TO_STEAL');
    const take = shrink(sliceStack(stack.quantity, 0.15, 1, 8));
    if (take <= 0) throw new Error('RAID_NOTHING_TO_STEAL');
    const cap = await getCrewStorageCapacity(input.attackerCrewId, 'weapon_storage');
    const current = await tx.crewWeaponInventory.aggregate({
      where: { crewId: input.attackerCrewId },
      _sum: { quantity: true },
    });
    if (cap <= 0 || (current._sum.quantity ?? 0) + take > cap) {
      throw new Error('RAID_NO_CAPACITY');
    }
    if (stack.quantity === take) {
      await tx.crewWeaponInventory.delete({ where: { id: stack.id } });
    } else {
      await tx.crewWeaponInventory.update({
        where: { id: stack.id },
        data: { quantity: { decrement: take } },
      });
    }
    const existing = await tx.crewWeaponInventory.findUnique({
      where: { crewId_weaponId: { crewId: input.attackerCrewId, weaponId: stack.weaponId } },
    });
    if (existing) {
      const total = existing.quantity + take;
      await tx.crewWeaponInventory.update({
        where: { id: existing.id },
        data: {
          quantity: total,
          averageCondition: Math.floor(
            (existing.averageCondition * existing.quantity + stack.averageCondition * take) / total,
          ),
        },
      });
    } else {
      await tx.crewWeaponInventory.create({
        data: {
          crewId: input.attackerCrewId,
          weaponId: stack.weaponId,
          quantity: take,
          averageCondition: stack.averageCondition,
        },
      });
    }
    return {
      moneyDelta: 0,
      metadata: {
        lootTarget: 'weapon',
        weaponId: stack.weaponId,
        quantity: take,
        shielded,
        taken: true,
      },
    };
  }

  if (input.lootTarget === 'tool') {
    const cap = await getCrewStorageCapacity(input.attackerCrewId, 'tool_storage');
    const owned = await tx.crewToolInventory.count({ where: { crewId: input.attackerCrewId } });
    if (cap <= 0 || owned >= cap) {
      throw new Error('RAID_NO_CAPACITY');
    }
    if (shielded) {
      return {
        moneyDelta: 0,
        metadata: { lootTarget: 'tool', shielded: true, taken: false },
      };
    }
    const tool = await tx.crewToolInventory.findFirst({
      where: { crewId: input.defenderCrewId },
      orderBy: { durability: 'desc' },
    });
    if (!tool) {
      throw new Error('RAID_NOTHING_TO_STEAL');
    }
    await tx.crewToolInventory.update({
      where: { id: tool.id },
      data: { crewId: input.attackerCrewId, addedByPlayerId: input.actorPlayerId },
    });
    return {
      moneyDelta: 0,
      metadata: {
        lootTarget: 'tool',
        toolId: tool.toolId,
        inventoryId: tool.id,
        durability: tool.durability,
        shielded,
        taken: true,
      },
    };
  }

  if (input.lootTarget === 'ammo') {
    const stack = await tx.crewAmmoInventory.findFirst({
      where: { crewId: input.defenderCrewId, quantity: { gt: 0 } },
      orderBy: { quantity: 'desc' },
    });
    if (!stack) throw new Error('RAID_NOTHING_TO_STEAL');
    const take = shrink(sliceStack(stack.quantity, 0.12, 10, 80));
    if (take <= 0) throw new Error('RAID_NOTHING_TO_STEAL');
    const cap = await getCrewStorageCapacity(input.attackerCrewId, 'ammo_storage');
    const current = await tx.crewAmmoInventory.aggregate({
      where: { crewId: input.attackerCrewId },
      _sum: { quantity: true },
    });
    if (cap <= 0 || (current._sum.quantity ?? 0) + take > cap) {
      throw new Error('RAID_NO_CAPACITY');
    }
    if (stack.quantity === take) {
      await tx.crewAmmoInventory.delete({ where: { id: stack.id } });
    } else {
      await tx.crewAmmoInventory.update({
        where: { id: stack.id },
        data: { quantity: { decrement: take } },
      });
    }
    await tx.crewAmmoInventory.upsert({
      where: { crewId_ammoType: { crewId: input.attackerCrewId, ammoType: stack.ammoType } },
      create: { crewId: input.attackerCrewId, ammoType: stack.ammoType, quantity: take },
      update: { quantity: { increment: take } },
    });
    return {
      moneyDelta: 0,
      metadata: {
        lootTarget: 'ammo',
        ammoType: stack.ammoType,
        quantity: take,
        shielded,
        taken: true,
      },
    };
  }

  if (input.lootTarget === 'drug') {
    const lot = await tx.crewDrugLot.findFirst({
      where: { crewId: input.defenderCrewId, quantity: { gt: 0 } },
      orderBy: { quantity: 'desc' },
    });
    if (!lot) throw new Error('RAID_NOTHING_TO_STEAL');
    const take = shrink(sliceStack(lot.quantity, 0.1, 5, 40));
    if (take <= 0) throw new Error('RAID_NOTHING_TO_STEAL');
    const cap = await getCrewStorageCapacity(input.attackerCrewId, 'drug_storage');
    const [legacy, lots] = await Promise.all([
      tx.crewDrugInventory.aggregate({
        where: { crewId: input.attackerCrewId },
        _sum: { quantity: true },
      }),
      tx.crewDrugLot.aggregate({
        where: { crewId: input.attackerCrewId },
        _sum: { quantity: true },
      }),
    ]);
    const used = (legacy._sum.quantity ?? 0) + (lots._sum.quantity ?? 0);
    if (cap <= 0 || used + take > cap) {
      throw new Error('RAID_NO_CAPACITY');
    }
    if (lot.quantity === take) {
      await tx.crewDrugLot.delete({ where: { id: lot.id } });
    } else {
      await tx.crewDrugLot.update({
        where: { id: lot.id },
        data: { quantity: { decrement: take } },
      });
    }
    await tx.crewDrugLot.upsert({
      where: {
        crewId_drugType_quality: {
          crewId: input.attackerCrewId,
          drugType: lot.drugType,
          quality: lot.quality,
        },
      },
      create: {
        crewId: input.attackerCrewId,
        drugType: lot.drugType,
        quality: lot.quality,
        quantity: take,
      },
      update: { quantity: { increment: take } },
    });
    return {
      moneyDelta: 0,
      metadata: {
        lootTarget: 'drug',
        drugType: lot.drugType,
        quality: lot.quality,
        quantity: take,
        shielded,
        taken: true,
      },
    };
  }

  const stack = await tx.crewTradeInventory.findFirst({
    where: { crewId: input.defenderCrewId, quantity: { gt: 0 } },
    orderBy: { quantity: 'desc' },
  });
  if (!stack) throw new Error('RAID_NOTHING_TO_STEAL');
  const take = shrink(sliceStack(stack.quantity, 0.12, 1, 12));
  if (take <= 0) throw new Error('RAID_NOTHING_TO_STEAL');
  const cap = await getCrewStorageCapacity(input.attackerCrewId, 'trade_storage');
  const current = await tx.crewTradeInventory.aggregate({
    where: { crewId: input.attackerCrewId },
    _sum: { quantity: true },
  });
  if (cap <= 0 || (current._sum.quantity ?? 0) + take > cap) {
    throw new Error('RAID_NO_CAPACITY');
  }
  if (stack.quantity === take) {
    await tx.crewTradeInventory.delete({ where: { id: stack.id } });
  } else {
    await tx.crewTradeInventory.update({
      where: { id: stack.id },
      data: { quantity: { decrement: take } },
    });
  }
  const existing = await tx.crewTradeInventory.findUnique({
    where: { crewId_goodType: { crewId: input.attackerCrewId, goodType: stack.goodType } },
  });
  if (existing) {
    const total = existing.quantity + take;
    await tx.crewTradeInventory.update({
      where: { id: existing.id },
      data: {
        quantity: total,
        averagePurchasePrice: Math.floor(
          (existing.averagePurchasePrice * existing.quantity + stack.averagePurchasePrice * take) /
            total,
        ),
        averageCondition: Math.floor(
          (existing.averageCondition * existing.quantity + stack.averageCondition * take) / total,
        ),
      },
    });
  } else {
    await tx.crewTradeInventory.create({
      data: {
        crewId: input.attackerCrewId,
        goodType: stack.goodType,
        quantity: take,
        averagePurchasePrice: stack.averagePurchasePrice,
        averageCondition: stack.averageCondition,
      },
    });
  }
  return {
    moneyDelta: 0,
    metadata: {
      lootTarget: 'trade',
      goodType: stack.goodType,
      quantity: take,
      shielded,
      taken: true,
    },
  };
}

export async function applyWarSabotage(
  tx: Prisma.TransactionClient,
  input: {
    warId: number;
    attackerCrewId: number;
    defenderCrewId: number;
    buildingType: Exclude<CrewBuildingType, 'hq'>;
  },
): Promise<{ metadata: Record<string, unknown> }> {
  const prior = await tx.crewWarAction.findMany({
    where: {
      warId: input.warId,
      targetCrewId: input.defenderCrewId,
      actionType: 'attack_sabotage',
      result: 'success',
    },
    select: { metadataJson: true },
  });
  for (const row of prior) {
    try {
      const meta = row.metadataJson ? JSON.parse(row.metadataJson) : {};
      if (meta?.buildingType === input.buildingType && meta?.levelDropped) {
        throw new Error('SABOTAGE_ALREADY_DONE');
      }
    } catch (error) {
      if (error instanceof Error && error.message === 'SABOTAGE_ALREADY_DONE') {
        throw error;
      }
    }
  }

  const shielded = await defenderHasShield(tx, input.warId, input.defenderCrewId);
  if (shielded) {
    return {
      metadata: {
        buildingType: input.buildingType,
        levelDropped: false,
        shielded: true,
      },
    };
  }

  const record = await getCrewBuildingRecord(input.defenderCrewId, input.buildingType);
  const level = record?.level ?? 0;
  if (!record || level <= 1) {
    throw new Error('SABOTAGE_MIN_LEVEL');
  }
  const nextLevel = level - 1;
  const nextStyle = styleForSideLevel(nextLevel);
  const data = { level: nextLevel, style: nextStyle };

  switch (input.buildingType) {
    case 'car_storage':
      await tx.crewCarStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'boat_storage':
      await tx.crewBoatStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'weapon_storage':
      await tx.crewWeaponStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'ammo_storage':
      await tx.crewAmmoStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'drug_storage':
      await tx.crewDrugStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'trade_storage':
      await tx.crewTradeStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    case 'cash_storage':
      await tx.crewCashStorageBuilding.update({ where: { crewId: input.defenderCrewId }, data });
      break;
    default:
      throw new Error('INVALID_SABOTAGE_BUILDING');
  }

  return {
    metadata: {
      buildingType: input.buildingType,
      fromLevel: level,
      toLevel: nextLevel,
      levelDropped: true,
      shielded: false,
    },
  };
}
