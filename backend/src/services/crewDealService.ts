import { Prisma } from '@prisma/client';
import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';

const DEAL_TTL_MS = 2 * 60 * 60 * 1000;

export type DealOffer = {
  cash: number;
  cars: Array<{
    id: number;
    vehicleId: string;
    condition: number;
    fuelLevel: number;
    stolenInCountry: string | null;
  }>;
  boats: Array<{
    id: number;
    vehicleId: string;
    condition: number;
    fuelLevel: number;
    stolenInCountry: string | null;
  }>;
  weapons: Array<{ weaponId: string; quantity: number; averageCondition: number }>;
  ammo: Array<{ ammoType: string; quantity: number }>;
  drugs: Array<{ drugType: string; quality: string; quantity: number }>;
  trade: Array<{
    goodType: string;
    quantity: number;
    averagePurchasePrice: number;
    averageCondition: number;
  }>;
};

export type DealOfferInput = {
  cash?: number;
  carIds?: number[];
  boatIds?: number[];
  weapons?: Array<{ weaponId: string; quantity: number }>;
  ammo?: Array<{ ammoType: string; quantity: number }>;
  drugs?: Array<{ drugType: string; quality?: string; quantity: number }>;
  trade?: Array<{ goodType: string; quantity: number }>;
};

function emptyOffer(): DealOffer {
  return { cash: 0, cars: [], boats: [], weapons: [], ammo: [], drugs: [], trade: [] };
}

function isOfferEmpty(offer: DealOffer): boolean {
  return (
    offer.cash <= 0 &&
    offer.cars.length === 0 &&
    offer.boats.length === 0 &&
    offer.weapons.length === 0 &&
    offer.ammo.length === 0 &&
    offer.drugs.length === 0 &&
    offer.trade.length === 0
  );
}

function parseOffer(raw: string | null | undefined): DealOffer {
  if (!raw) return emptyOffer();
  try {
    const parsed = JSON.parse(raw) as Partial<DealOffer>;
    return {
      cash: Number(parsed.cash) || 0,
      cars: Array.isArray(parsed.cars) ? parsed.cars : [],
      boats: Array.isArray(parsed.boats) ? parsed.boats : [],
      weapons: Array.isArray(parsed.weapons) ? parsed.weapons : [],
      ammo: Array.isArray(parsed.ammo) ? parsed.ammo : [],
      drugs: Array.isArray(parsed.drugs) ? parsed.drugs : [],
      trade: Array.isArray(parsed.trade) ? parsed.trade : [],
    };
  } catch {
    return emptyOffer();
  }
}

async function requireOfficer(playerId: number, crewId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId, crewId },
    select: { role: true },
  });
  if (!membership) throw new Error('NOT_IN_CREW');
  if (membership.role !== 'leader' && membership.role !== 'co_leader') {
    throw new Error('NOT_CREW_OFFICER');
  }
}

async function debitOffer(
  tx: Prisma.TransactionClient,
  crewId: number,
  input: DealOfferInput,
): Promise<DealOffer> {
  const offer = emptyOffer();
  const cash = Math.max(0, Math.floor(Number(input.cash) || 0));
  if (cash > 0) {
    const taken = await tx.crew.updateMany({
      where: { id: crewId, bankBalance: { gte: cash } },
      data: { bankBalance: { decrement: cash } },
    });
    if (taken.count !== 1) throw new Error('INSUFFICIENT_CREW_FUNDS');
    offer.cash = cash;
  }

  for (const id of input.carIds ?? []) {
    const car = await tx.crewCarInventory.findFirst({ where: { id, crewId } });
    if (!car) throw new Error('DEAL_ITEM_MISSING');
    await tx.crewCarInventory.delete({ where: { id: car.id } });
    offer.cars.push({
      id: car.id,
      vehicleId: car.vehicleId,
      condition: car.condition,
      fuelLevel: car.fuelLevel,
      stolenInCountry: car.stolenInCountry,
    });
  }

  for (const id of input.boatIds ?? []) {
    const boat = await tx.crewBoatInventory.findFirst({ where: { id, crewId } });
    if (!boat) throw new Error('DEAL_ITEM_MISSING');
    await tx.crewBoatInventory.delete({ where: { id: boat.id } });
    offer.boats.push({
      id: boat.id,
      vehicleId: boat.vehicleId,
      condition: boat.condition,
      fuelLevel: boat.fuelLevel,
      stolenInCountry: boat.stolenInCountry,
    });
  }

  for (const row of input.weapons ?? []) {
    const qty = Math.floor(Number(row.quantity) || 0);
    if (qty <= 0) continue;
    const stack = await tx.crewWeaponInventory.findUnique({
      where: { crewId_weaponId: { crewId, weaponId: row.weaponId } },
    });
    if (!stack || stack.quantity < qty) throw new Error('DEAL_ITEM_MISSING');
    if (stack.quantity === qty) {
      await tx.crewWeaponInventory.delete({ where: { id: stack.id } });
    } else {
      await tx.crewWeaponInventory.update({
        where: { id: stack.id },
        data: { quantity: { decrement: qty } },
      });
    }
    offer.weapons.push({
      weaponId: row.weaponId,
      quantity: qty,
      averageCondition: stack.averageCondition,
    });
  }

  for (const row of input.ammo ?? []) {
    const qty = Math.floor(Number(row.quantity) || 0);
    if (qty <= 0) continue;
    const stack = await tx.crewAmmoInventory.findUnique({
      where: { crewId_ammoType: { crewId, ammoType: row.ammoType } },
    });
    if (!stack || stack.quantity < qty) throw new Error('DEAL_ITEM_MISSING');
    if (stack.quantity === qty) {
      await tx.crewAmmoInventory.delete({ where: { id: stack.id } });
    } else {
      await tx.crewAmmoInventory.update({
        where: { id: stack.id },
        data: { quantity: { decrement: qty } },
      });
    }
    offer.ammo.push({ ammoType: row.ammoType, quantity: qty });
  }

  for (const row of input.drugs ?? []) {
    const qty = Math.floor(Number(row.quantity) || 0);
    if (qty <= 0) continue;
    const quality = (row.quality || 'C').toUpperCase();
    const lot = await tx.crewDrugLot.findUnique({
      where: { crewId_drugType_quality: { crewId, drugType: row.drugType, quality } },
    });
    if (!lot || lot.quantity < qty) throw new Error('DEAL_ITEM_MISSING');
    if (lot.quantity === qty) {
      await tx.crewDrugLot.delete({ where: { id: lot.id } });
    } else {
      await tx.crewDrugLot.update({
        where: { id: lot.id },
        data: { quantity: { decrement: qty } },
      });
    }
    offer.drugs.push({ drugType: row.drugType, quality, quantity: qty });
  }

  for (const row of input.trade ?? []) {
    const qty = Math.floor(Number(row.quantity) || 0);
    if (qty <= 0) continue;
    const stack = await tx.crewTradeInventory.findUnique({
      where: { crewId_goodType: { crewId, goodType: row.goodType } },
    });
    if (!stack || stack.quantity < qty) throw new Error('DEAL_ITEM_MISSING');
    if (stack.quantity === qty) {
      await tx.crewTradeInventory.delete({ where: { id: stack.id } });
    } else {
      await tx.crewTradeInventory.update({
        where: { id: stack.id },
        data: { quantity: { decrement: qty } },
      });
    }
    offer.trade.push({
      goodType: row.goodType,
      quantity: qty,
      averagePurchasePrice: stack.averagePurchasePrice,
      averageCondition: stack.averageCondition,
    });
  }

  if (isOfferEmpty(offer)) throw new Error('DEAL_EMPTY_OFFER');
  return offer;
}

async function creditOffer(tx: Prisma.TransactionClient, crewId: number, offer: DealOffer, addedByPlayerId: number) {
  if (offer.cash > 0) {
    await tx.crew.update({
      where: { id: crewId },
      data: { bankBalance: { increment: offer.cash } },
    });
  }
  for (const car of offer.cars) {
    await tx.crewCarInventory.create({
      data: {
        crewId,
        vehicleId: car.vehicleId,
        condition: car.condition,
        fuelLevel: car.fuelLevel,
        stolenInCountry: car.stolenInCountry,
        addedByPlayerId,
      },
    });
  }
  for (const boat of offer.boats) {
    await tx.crewBoatInventory.create({
      data: {
        crewId,
        vehicleId: boat.vehicleId,
        condition: boat.condition,
        fuelLevel: boat.fuelLevel,
        stolenInCountry: boat.stolenInCountry,
        addedByPlayerId,
      },
    });
  }
  for (const weapon of offer.weapons) {
    const existing = await tx.crewWeaponInventory.findUnique({
      where: { crewId_weaponId: { crewId, weaponId: weapon.weaponId } },
    });
    if (existing) {
      const total = existing.quantity + weapon.quantity;
      await tx.crewWeaponInventory.update({
        where: { id: existing.id },
        data: {
          quantity: total,
          averageCondition: Math.floor(
            (existing.averageCondition * existing.quantity +
              weapon.averageCondition * weapon.quantity) /
              total,
          ),
        },
      });
    } else {
      await tx.crewWeaponInventory.create({
        data: {
          crewId,
          weaponId: weapon.weaponId,
          quantity: weapon.quantity,
          averageCondition: weapon.averageCondition,
        },
      });
    }
  }
  for (const ammo of offer.ammo) {
    await tx.crewAmmoInventory.upsert({
      where: { crewId_ammoType: { crewId, ammoType: ammo.ammoType } },
      create: { crewId, ammoType: ammo.ammoType, quantity: ammo.quantity },
      update: { quantity: { increment: ammo.quantity } },
    });
  }
  for (const drug of offer.drugs) {
    await tx.crewDrugLot.upsert({
      where: {
        crewId_drugType_quality: { crewId, drugType: drug.drugType, quality: drug.quality },
      },
      create: {
        crewId,
        drugType: drug.drugType,
        quality: drug.quality,
        quantity: drug.quantity,
      },
      update: { quantity: { increment: drug.quantity } },
    });
  }
  for (const good of offer.trade) {
    const existing = await tx.crewTradeInventory.findUnique({
      where: { crewId_goodType: { crewId, goodType: good.goodType } },
    });
    if (existing) {
      const total = existing.quantity + good.quantity;
      await tx.crewTradeInventory.update({
        where: { id: existing.id },
        data: {
          quantity: total,
          averagePurchasePrice: Math.floor(
            (existing.averagePurchasePrice * existing.quantity +
              good.averagePurchasePrice * good.quantity) /
              total,
          ),
          averageCondition: Math.floor(
            (existing.averageCondition * existing.quantity +
              good.averageCondition * good.quantity) /
              total,
          ),
        },
      });
    } else {
      await tx.crewTradeInventory.create({
        data: {
          crewId,
          goodType: good.goodType,
          quantity: good.quantity,
          averagePurchasePrice: good.averagePurchasePrice,
          averageCondition: good.averageCondition,
        },
      });
    }
  }
}

async function offerFits(
  crewId: number,
  offer: DealOffer,
  db: Prisma.TransactionClient | typeof prisma = prisma,
): Promise<boolean> {
  const [carCap, boatCap, weaponCap, ammoCap, drugCap, tradeCap, cashCap] = await Promise.all([
    getCrewStorageCapacity(crewId, 'car_storage'),
    getCrewStorageCapacity(crewId, 'boat_storage'),
    getCrewStorageCapacity(crewId, 'weapon_storage'),
    getCrewStorageCapacity(crewId, 'ammo_storage'),
    getCrewStorageCapacity(crewId, 'drug_storage'),
    getCrewStorageCapacity(crewId, 'trade_storage'),
    getCrewStorageCapacity(crewId, 'cash_storage'),
  ]);
  const [cars, boats, weapons, ammo, drugs, lots, trade, crew] = await Promise.all([
    db.crewCarInventory.count({ where: { crewId } }),
    db.crewBoatInventory.count({ where: { crewId } }),
    db.crewWeaponInventory.aggregate({ where: { crewId }, _sum: { quantity: true } }),
    db.crewAmmoInventory.aggregate({ where: { crewId }, _sum: { quantity: true } }),
    db.crewDrugInventory.aggregate({ where: { crewId }, _sum: { quantity: true } }),
    db.crewDrugLot.aggregate({ where: { crewId }, _sum: { quantity: true } }),
    db.crewTradeInventory.aggregate({ where: { crewId }, _sum: { quantity: true } }),
    db.crew.findUnique({ where: { id: crewId }, select: { bankBalance: true } }),
  ]);
  const weaponQty = offer.weapons.reduce((sum, row) => sum + row.quantity, 0);
  const ammoQty = offer.ammo.reduce((sum, row) => sum + row.quantity, 0);
  const drugQty = offer.drugs.reduce((sum, row) => sum + row.quantity, 0);
  const tradeQty = offer.trade.reduce((sum, row) => sum + row.quantity, 0);
  return (
    cars + offer.cars.length <= carCap &&
    boats + offer.boats.length <= boatCap &&
    (weapons._sum.quantity ?? 0) + weaponQty <= weaponCap &&
    (ammo._sum.quantity ?? 0) + ammoQty <= ammoCap &&
    (drugs._sum.quantity ?? 0) + (lots._sum.quantity ?? 0) + drugQty <= drugCap &&
    (trade._sum.quantity ?? 0) + tradeQty <= tradeCap &&
    (crew?.bankBalance ?? 0) + offer.cash <= cashCap
  );
}

async function expireStaleDeals(crewIds: number[]) {
  const stale = await prisma.crewStorageDeal.findMany({
    where: {
      status: { in: ['offered', 'countered'] },
      expiresAt: { lt: new Date() },
      OR: [{ initiatorCrewId: { in: crewIds } }, { counterpartyCrewId: { in: crewIds } }],
    },
  });
  for (const deal of stale) {
    await voidDeal(deal.id, 'expired');
  }
}

async function voidDeal(dealId: number, status: 'void' | 'expired') {
  await prisma.$transaction(async (tx) => {
    const deal = await tx.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!deal || deal.status === 'confirmed' || deal.status === 'void' || deal.status === 'expired') {
      return;
    }
    const initiator = parseOffer(deal.initiatorOfferJson);
    const counter = parseOffer(deal.counterpartyOfferJson);
    await creditOffer(tx, deal.initiatorCrewId, initiator, deal.createdByPlayerId);
    if (!isOfferEmpty(counter)) {
      await creditOffer(tx, deal.counterpartyCrewId, counter, deal.createdByPlayerId);
    }
    await tx.crewStorageDeal.update({
      where: { id: dealId },
      data: { status },
    });
  });
}

function serializeDeal(deal: {
  id: number;
  initiatorCrewId: number;
  counterpartyCrewId: number;
  createdByPlayerId: number;
  status: string;
  initiatorOfferJson: string;
  counterpartyOfferJson: string | null;
  initiatorConfirmedAt: Date | null;
  counterpartyConfirmedAt: Date | null;
  expiresAt: Date;
  createdAt: Date;
  initiatorCrew?: { name: string } | null;
  counterpartyCrew?: { name: string } | null;
}) {
  return {
    id: deal.id,
    initiatorCrewId: deal.initiatorCrewId,
    counterpartyCrewId: deal.counterpartyCrewId,
    initiatorCrewName: deal.initiatorCrew?.name ?? null,
    counterpartyCrewName: deal.counterpartyCrew?.name ?? null,
    createdByPlayerId: deal.createdByPlayerId,
    status: deal.status,
    initiatorOffer: parseOffer(deal.initiatorOfferJson),
    counterpartyOffer: parseOffer(deal.counterpartyOfferJson),
    initiatorConfirmedAt: deal.initiatorConfirmedAt,
    counterpartyConfirmedAt: deal.counterpartyConfirmedAt,
    expiresAt: deal.expiresAt,
    createdAt: deal.createdAt,
  };
}

export const crewDealService = {
  async list(playerId: number) {
    const membership = await prisma.crewMember.findFirst({
      where: { playerId },
      select: { crewId: true, role: true },
    });
    if (!membership) throw new Error('NOT_IN_CREW');
    await expireStaleDeals([membership.crewId]);
    const deals = await prisma.crewStorageDeal.findMany({
      where: {
        OR: [{ initiatorCrewId: membership.crewId }, { counterpartyCrewId: membership.crewId }],
        status: { in: ['offered', 'countered'] },
      },
      include: {
        initiatorCrew: { select: { name: true } },
        counterpartyCrew: { select: { name: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: 30,
    });
    return {
      crewId: membership.crewId,
      canManage: membership.role === 'leader' || membership.role === 'co_leader',
      deals: deals.map(serializeDeal),
    };
  },

  async partners(playerId: number, query?: string) {
    const membership = await prisma.crewMember.findFirst({
      where: { playerId },
      select: { crewId: true },
    });
    if (!membership) throw new Error('NOT_IN_CREW');
    const q = (query ?? '').trim();
    const crews = await prisma.crew.findMany({
      where: {
        id: { not: membership.crewId },
        ...(q ? { name: { contains: q } } : {}),
      },
      select: { id: true, name: true, _count: { select: { members: true } } },
      orderBy: { name: 'asc' },
      take: 40,
    });
    return crews.map((crew) => ({
      id: crew.id,
      name: crew.name,
      memberCount: crew._count.members,
    }));
  },

  async create(playerId: number, targetCrewId: number, input: DealOfferInput) {
    const membership = await prisma.crewMember.findFirst({
      where: { playerId },
      select: { crewId: true },
    });
    if (!membership) throw new Error('NOT_IN_CREW');
    await requireOfficer(playerId, membership.crewId);
    if (targetCrewId === membership.crewId) throw new Error('DEAL_SAME_CREW');
    const target = await prisma.crew.findUnique({ where: { id: targetCrewId }, select: { id: true } });
    if (!target) throw new Error('TARGET_CREW_NOT_FOUND');
    const open = await prisma.crewStorageDeal.count({
      where: {
        initiatorCrewId: membership.crewId,
        status: { in: ['offered', 'countered'] },
      },
    });
    if (open >= 5) throw new Error('DEAL_LIMIT');

    const deal = await prisma.$transaction(async (tx) => {
      const offer = await debitOffer(tx, membership.crewId, input);
      return tx.crewStorageDeal.create({
        data: {
          initiatorCrewId: membership.crewId,
          counterpartyCrewId: targetCrewId,
          createdByPlayerId: playerId,
          status: 'offered',
          initiatorOfferJson: JSON.stringify(offer),
          expiresAt: new Date(Date.now() + DEAL_TTL_MS),
        },
        include: {
          initiatorCrew: { select: { name: true } },
          counterpartyCrew: { select: { name: true } },
        },
      });
    });
    return serializeDeal(deal);
  },

  async counter(playerId: number, dealId: number, input: DealOfferInput) {
    const deal = await prisma.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!deal) throw new Error('DEAL_NOT_FOUND');
    await expireStaleDeals([deal.initiatorCrewId, deal.counterpartyCrewId]);
    const fresh = await prisma.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!fresh || fresh.status !== 'offered') throw new Error('DEAL_NOT_COUNTERABLE');
    await requireOfficer(playerId, fresh.counterpartyCrewId);

    const updated = await prisma.$transaction(async (tx) => {
      const offer = await debitOffer(tx, fresh.counterpartyCrewId, input);
      return tx.crewStorageDeal.update({
        where: { id: dealId },
        data: {
          status: 'countered',
          counterpartyOfferJson: JSON.stringify(offer),
        },
        include: {
          initiatorCrew: { select: { name: true } },
          counterpartyCrew: { select: { name: true } },
        },
      });
    });
    return serializeDeal(updated);
  },

  async confirm(playerId: number, dealId: number) {
    const deal = await prisma.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!deal) throw new Error('DEAL_NOT_FOUND');
    await expireStaleDeals([deal.initiatorCrewId, deal.counterpartyCrewId]);
    const fresh = await prisma.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!fresh || fresh.status !== 'countered') throw new Error('DEAL_NOT_CONFIRMABLE');

    const membership = await prisma.crewMember.findFirst({
      where: { playerId, crewId: { in: [fresh.initiatorCrewId, fresh.counterpartyCrewId] } },
    });
    if (!membership) throw new Error('NOT_IN_CREW');
    await requireOfficer(playerId, membership.crewId);

    const settled = await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`SELECT id FROM crew_storage_deals WHERE id = ${dealId} FOR UPDATE`;
      const locked = await tx.crewStorageDeal.findUnique({
        where: { id: dealId },
        include: {
          initiatorCrew: { select: { name: true } },
          counterpartyCrew: { select: { name: true } },
        },
      });
      if (!locked || locked.status !== 'countered') throw new Error('DEAL_NOT_CONFIRMABLE');

      const isInitiator = membership.crewId === locked.initiatorCrewId;
      const already = isInitiator ? locked.initiatorConfirmedAt : locked.counterpartyConfirmedAt;
      if (already) return locked;

      const initiatorConfirmedAt = isInitiator ? new Date() : locked.initiatorConfirmedAt;
      const counterpartyConfirmedAt = isInitiator ? locked.counterpartyConfirmedAt : new Date();
      const bothReady = Boolean(initiatorConfirmedAt && counterpartyConfirmedAt);

      if (!bothReady) {
        return tx.crewStorageDeal.update({
          where: { id: dealId },
          data: { initiatorConfirmedAt, counterpartyConfirmedAt },
          include: {
            initiatorCrew: { select: { name: true } },
            counterpartyCrew: { select: { name: true } },
          },
        });
      }

      const initiatorOffer = parseOffer(locked.initiatorOfferJson);
      const counterOffer = parseOffer(locked.counterpartyOfferJson);
      const initiatorFits = await offerFits(locked.counterpartyCrewId, initiatorOffer, tx);
      const counterFits = await offerFits(locked.initiatorCrewId, counterOffer, tx);
      if (!initiatorFits || !counterFits) {
        await creditOffer(tx, locked.initiatorCrewId, initiatorOffer, locked.createdByPlayerId);
        if (!isOfferEmpty(counterOffer)) {
          await creditOffer(tx, locked.counterpartyCrewId, counterOffer, locked.createdByPlayerId);
        }
        await tx.crewStorageDeal.update({
          where: { id: dealId },
          data: { status: 'void' },
        });
        throw new Error('DEAL_NO_CAPACITY');
      }

      await creditOffer(tx, locked.counterpartyCrewId, initiatorOffer, playerId);
      await creditOffer(tx, locked.initiatorCrewId, counterOffer, playerId);
      return tx.crewStorageDeal.update({
        where: { id: dealId },
        data: {
          status: 'confirmed',
          initiatorConfirmedAt,
          counterpartyConfirmedAt,
        },
        include: {
          initiatorCrew: { select: { name: true } },
          counterpartyCrew: { select: { name: true } },
        },
      });
    });
    return serializeDeal(settled);
  },

  async cancel(playerId: number, dealId: number) {
    const deal = await prisma.crewStorageDeal.findUnique({ where: { id: dealId } });
    if (!deal) throw new Error('DEAL_NOT_FOUND');
    if (deal.status === 'confirmed' || deal.status === 'void' || deal.status === 'expired') {
      throw new Error('DEAL_NOT_CANCELABLE');
    }
    const membership = await prisma.crewMember.findFirst({
      where: { playerId, crewId: { in: [deal.initiatorCrewId, deal.counterpartyCrewId] } },
    });
    if (!membership) throw new Error('NOT_IN_CREW');
    await requireOfficer(playerId, membership.crewId);
    await voidDeal(dealId, 'void');
    return { id: dealId, status: 'void' };
  },
};
