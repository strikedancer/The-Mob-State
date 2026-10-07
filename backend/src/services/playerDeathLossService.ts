/**
 * Records exactly what a hitlist kill removes, and can put that loss back.
 * Houses and apartments, including their storage, are not part of the loss.
 */
import prisma from '../lib/prisma';
import { isVipStatusActive } from './vipBenefitsService';
import { isNpcPlayerId } from './npcLookup';

export const KEPT_DEATH_PROPERTY_TYPES = ['house', 'apartment'] as const;

export type HitLootTransfer = {
  kind: 'inventory' | 'ammo' | 'weapon' | 'tool';
  quantity: number;
  goodType?: string;
  country?: string;
  ammoType?: string;
  weaponId?: string;
  toolId?: string;
  durability?: number;
};

type DeathLoot = {
  killerId: number;
  placedById: number;
  bounty: number;
  cashTaken: number;
  cashAwarded: number;
  transfers: HitLootTransfer[];
};

type DeathDraft = {
  version: 1;
  vipProtectionApplied: boolean;
  player: Record<string, unknown>;
  keptProperties: Array<{ id: number; propertyType: string; countryId: string }>;
  losses: Record<string, unknown[]>;
  loot?: DeathLoot;
};

const PLAYER_RESTORE_FIELDS = [
  'money',
  'health',
  'hunger',
  'thirst',
  'rank',
  'xp',
  'currentCountry',
  'fbiHeat',
  'wantedLevel',
  'travelingTo',
  'travelRoute',
  'currentTravelLeg',
  'travelStartedAt',
  'isHunted',
  'jailRelease',
  'intensiveCareUntil',
  'inventory_slots_used',
  'lastAmmoPurchaseAt',
  'lastHospitalVisit',
  'lastProstituteRecruitment',
  'drugHeat',
  'autoCollectDrugs',
  'lastDrugActionAt',
  'killCount',
  'hitCount',
  'max_inventory_slots',
  'reputation',
  'premiumCredits',
] as const;

export function isKeptOnDeathProperty(propertyType: string): boolean {
  return (KEPT_DEATH_PROPERTY_TYPES as readonly string[]).includes(propertyType);
}

export function keptToolLocation(propertyId: number): string {
  return `property_${propertyId}`;
}

function jsonSafe(value: unknown): string {
  return JSON.stringify(value, (_key, current) => {
    if (typeof current === 'bigint') return { __bigint: current.toString() };
    if (
      current &&
      typeof current === 'object' &&
      typeof (current as { toFixed?: unknown }).toFixed === 'function' &&
      'd' in (current as object) &&
      'e' in (current as object)
    ) {
      return (current as { toString(): string }).toString();
    }
    return current;
  });
}

function reviveRow(row: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(row)) {
    if (
      value &&
      typeof value === 'object' &&
      !Array.isArray(value) &&
      '__bigint' in (value as object)
    ) {
      out[key] = BigInt(String((value as { __bigint: string }).__bigint));
      continue;
    }
    if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}T/.test(value)) {
      const parsed = new Date(value);
      out[key] = Number.isNaN(parsed.getTime()) ? value : parsed;
      continue;
    }
    out[key] = value;
  }
  return out;
}

function rowOwner(row: Record<string, unknown>): number | null {
  if (typeof row.playerId === 'number') return row.playerId;
  if (typeof row.player_id === 'number') return row.player_id;
  if (typeof row.ownerId === 'number') return row.ownerId;
  return null;
}

async function putBack(
  tx: any,
  delegate: string,
  row: Record<string, unknown>,
  warnings: string[]
) {
  const data = reviveRow(row);
  delete data.updatedAt;
  delete data.updated_at;
  const id = data.id;
  try {
    if (typeof id === 'number') {
      const taken = await tx[delegate].findUnique({ where: { id } });
      if (taken) {
        const owner = rowOwner(taken as Record<string, unknown>);
        const wanted = rowOwner(data);
        if (owner != null && wanted != null && owner !== wanted) {
          warnings.push(`id_taken:${delegate}:${id}`);
          return;
        }
        if (owner != null && wanted != null) {
          const rest = { ...data };
          delete rest.id;
          await tx[delegate].update({ where: { id }, data: rest });
          return;
        }
        delete data.id;
      }
    }
    await tx[delegate].create({ data });
  } catch (error) {
    const code = (error as { code?: string })?.code;
    if (code === 'P2002') {
      warnings.push(`duplicate:${delegate}`);
      return;
    }
    throw error;
  }
}

async function putBackMany(
  tx: any,
  delegate: string,
  rows: unknown[] | undefined,
  warnings: string[]
) {
  for (const row of rows || []) {
    if (!row || typeof row !== 'object') continue;
    await putBack(tx, delegate, row as Record<string, unknown>, warnings);
  }
}

export async function collectPlayerDeathLoss(tx: any, playerId: number): Promise<DeathDraft> {
  const playerSelect = Object.fromEntries(PLAYER_RESTORE_FIELDS.map((field) => [field, true]));
  const player = await tx.player.findUnique({
    where: { id: playerId },
    select: { id: true, isVip: true, vipExpiresAt: true, ...playerSelect },
  });
  if (!player) {
    throw new Error('TARGET_NOT_FOUND');
  }

  const vipProtectionApplied = isVipStatusActive(player);
  const properties = await tx.property.findMany({ where: { playerId } });
  const keptProperties = properties.filter((row: { propertyType: string }) =>
    isKeptOnDeathProperty(row.propertyType)
  );
  const lostProperties = properties.filter(
    (row: { propertyType: string }) => !isKeptOnDeathProperty(row.propertyType)
  );
  const keptLocations = new Set(
    keptProperties.map((row: { id: number }) => keptToolLocation(row.id))
  );
  const lostPropertyIds = lostProperties.map((row: { id: number }) => row.id);

  const tools = await tx.playerTools.findMany({ where: { playerId } });
  const lostTools = tools.filter(
    (row: { location: string }) => !keptLocations.has(row.location)
  );
  const loadouts = await tx.toolLoadouts.findMany({ where: { playerId } });
  const loadoutIds = loadouts.map((row: { id: number }) => row.id);
  const loadoutTools =
    loadoutIds.length > 0
      ? await tx.loadoutTools.findMany({ where: { loadoutId: { in: loadoutIds } } })
      : [];
  const propertyDrugStorage =
    lostPropertyIds.length > 0
      ? await tx.propertyDrugStorage.findMany({ where: { propertyId: { in: lostPropertyIds } } })
      : [];
  const nightclubVenues =
    lostPropertyIds.length > 0
      ? await tx.nightclubVenue.findMany({ where: { propertyId: { in: lostPropertyIds } } })
      : [];
  const venueIds = nightclubVenues.map((row: { id: number }) => row.id);
  const nightclubDrugInventory =
    venueIds.length > 0
      ? await tx.nightclubDrugInventory.findMany({ where: { venueId: { in: venueIds } } })
      : [];
  const casinos = await tx.casinoOwnership.findMany({ where: { ownerId: playerId } });
  const casinoIds = casinos.map((row: { casinoId: string }) => row.casinoId);
  const casinoStaff =
    casinoIds.length > 0
      ? await tx.casinoStaffHire.findMany({ where: { casinoId: { in: casinoIds } } })
      : [];
  const facilities = await tx.drugFacility.findMany({ where: { playerId } });
  const facilityIds = facilities.map((row: { id: number }) => row.id);
  const facilityUpgrades =
    facilityIds.length > 0
      ? await tx.drugFacilityUpgrade.findMany({ where: { facilityId: { in: facilityIds } } })
      : [];

  const losses: Record<string, unknown[]> = {
    actionCooldowns: await tx.actionCooldown.findMany({ where: { playerId } }),
    crimeAttempts: await tx.crimeAttempt.findMany({ where: { playerId } }),
    jobAttempts: await tx.jobAttempt.findMany({ where: { playerId } }),
    inventory: await tx.inventory.findMany({ where: { playerId } }),
    vehicleTuning: await tx.vehicle_tuning_upgrades.findMany({ where: { player_id: playerId } }),
    vehicleRepairJobs: await tx.vehicle_repair_jobs.findMany({ where: { player_id: playerId } }),
    vehicles: await tx.vehicleInventory.findMany({ where: { playerId } }),
    ammo: await tx.ammoInventory.findMany({ where: { playerId } }),
    weapons: await tx.weaponInventory.findMany({ where: { playerId } }),
    tools: lostTools,
    toolLoadouts: loadouts,
    loadoutTools,
    properties: lostProperties,
    propertyDrugStorage,
    nightclubVenues,
    nightclubDrugInventory,
    prostitutes: await tx.prostitute.findMany({ where: { playerId } }),
    casinos,
    casinoStaff,
    drugInventory: await tx.drugInventory.findMany({ where: { playerId } }),
    drugFacilities: facilities,
    drugFacilityUpgrades: facilityUpgrades,
    drugProductions: await tx.drugProduction.findMany({ where: { playerId } }),
    productionMaterials: await tx.productionMaterial.findMany({ where: { playerId } }),
    ammoFactories: await tx.ammoFactory.findMany({ where: { ownerId: playerId } }),
  };

  if (!vipProtectionApplied) {
    const bank = await tx.bankAccount.findUnique({ where: { playerId } });
    losses.bank = bank ? [bank] : [];
    losses.backpacks = await tx.playerBackpack.findMany({ where: { playerId } });
    losses.inventoryUpgrades = await tx.inventoryUpgrades.findMany({ where: { playerId } });
    losses.selectedVehicles = await tx.playerSelectedVehicle.findMany({ where: { playerId } });
    losses.activities = await tx.playerActivity.findMany({ where: { playerId } });
    losses.worldEvents = await tx.worldEvent.findMany({ where: { playerId } });
    losses.prostitutionAchievements = await tx.prostitutionAchievement.findMany({
      where: { playerId },
    });
    losses.cryptoOrders = await tx.crypto_orders.findMany({ where: { player_id: playerId } });
    losses.cryptoTransactions = await tx.crypto_transactions.findMany({
      where: { player_id: playerId },
    });
    losses.cryptoHoldings = await tx.crypto_holdings.findMany({ where: { player_id: playerId } });
    losses.cryptoMissionProgress = await tx.crypto_mission_progress.findMany({
      where: { player_id: playerId },
    });
    losses.cryptoLeaderboardRewards = await tx.crypto_leaderboard_rewards.findMany({
      where: { player_id: playerId },
    });
  }

  const { isVip: _isVip, vipExpiresAt: _vipExpiresAt, id: _id, ...playerFields } = player;
  return {
    version: 1,
    vipProtectionApplied,
    player: playerFields,
    keptProperties: keptProperties.map(
      (row: { id: number; propertyType: string; countryId: string }) => ({
        id: row.id,
        propertyType: row.propertyType,
        countryId: row.countryId,
      })
    ),
    losses,
  };
}

function summarize(draft: DeathDraft) {
  const counts: Record<string, number> = {};
  for (const [key, rows] of Object.entries(draft.losses)) {
    counts[key] = Array.isArray(rows) ? rows.length : 0;
  }
  return {
    version: draft.version,
    rankBefore: draft.player.rank ?? null,
    xpBefore: draft.player.xp ?? null,
    moneyBefore: draft.player.money ?? null,
    countryBefore: draft.player.currentCountry ?? null,
    vipProtectionApplied: draft.vipProtectionApplied,
    keptHouses: draft.keptProperties.filter((row) => row.propertyType === 'house').length,
    keptApartments: draft.keptProperties.filter((row) => row.propertyType === 'apartment').length,
    counts,
  };
}

export async function savePlayerDeathLoss(
  tx: any,
  input: {
    playerId: number;
    hitId: number;
    killerId: number;
    placedById: number;
    bounty: number;
    draft: DeathDraft;
  }
) {
  const summary = summarize(input.draft);
  return tx.playerDeathSnapshot.create({
    data: {
      playerId: input.playerId,
      hitId: input.hitId,
      killerId: input.killerId,
      placedById: input.placedById,
      bounty: input.bounty,
      vipProtectionApplied: input.draft.vipProtectionApplied,
      summary: jsonSafe(summary),
      payload: jsonSafe(input.draft),
    },
    select: { id: true },
  });
}

async function clawLoot(tx: any, loot: DeathLoot | undefined, warnings: string[]) {
  if (!loot) return;
  const killer = await tx.player.findUnique({
    where: { id: loot.killerId },
    select: { money: true },
  });
  if (killer) {
    const take = Math.max(0, loot.bounty) + Math.max(0, loot.cashAwarded);
    const next = Math.max(0, Number(killer.money || 0) - take);
    if (Number(killer.money || 0) < take) {
      warnings.push('killer_cash_short');
    }
    await tx.player.update({
      where: { id: loot.killerId },
      data: { money: next },
    });
  }
  if (loot.placedById && loot.placedById !== loot.killerId && loot.bounty > 0) {
    await tx.player.update({
      where: { id: loot.placedById },
      data: { money: { increment: loot.bounty } },
    });
  }

  for (const transfer of loot.transfers || []) {
    const qty = Math.max(0, Number(transfer.quantity || 0));
    if (qty <= 0) continue;
    if (transfer.kind === 'inventory' && transfer.goodType && transfer.country) {
      const row = await tx.inventory.findUnique({
        where: {
          playerId_goodType_country: {
            playerId: loot.killerId,
            goodType: transfer.goodType,
            country: transfer.country,
          },
        },
      });
      if (!row) {
        warnings.push(`loot_missing:inventory:${transfer.goodType}`);
        continue;
      }
      const left = Number(row.quantity || 0) - qty;
      if (left > 0) {
        await tx.inventory.update({ where: { id: row.id }, data: { quantity: left } });
      } else {
        if (left < 0) warnings.push(`loot_short:inventory:${transfer.goodType}`);
        await tx.inventory.delete({ where: { id: row.id } });
      }
    } else if (transfer.kind === 'ammo' && transfer.ammoType) {
      const row = await tx.ammoInventory.findUnique({
        where: { playerId_ammoType: { playerId: loot.killerId, ammoType: transfer.ammoType } },
      });
      if (!row) {
        warnings.push(`loot_missing:ammo:${transfer.ammoType}`);
        continue;
      }
      const left = Number(row.quantity || 0) - qty;
      if (left > 0) {
        await tx.ammoInventory.update({ where: { id: row.id }, data: { quantity: left } });
      } else {
        if (left < 0) warnings.push(`loot_short:ammo:${transfer.ammoType}`);
        await tx.ammoInventory.delete({ where: { id: row.id } });
      }
    } else if (transfer.kind === 'weapon' && transfer.weaponId) {
      const row = await tx.weaponInventory.findUnique({
        where: { playerId_weaponId: { playerId: loot.killerId, weaponId: transfer.weaponId } },
      });
      if (!row) {
        warnings.push(`loot_missing:weapon:${transfer.weaponId}`);
        continue;
      }
      const left = Number(row.quantity || 0) - qty;
      if (left > 0) {
        await tx.weaponInventory.update({ where: { id: row.id }, data: { quantity: left } });
      } else {
        if (left < 0) warnings.push(`loot_short:weapon:${transfer.weaponId}`);
        await tx.weaponInventory.delete({ where: { id: row.id } });
      }
    } else if (transfer.kind === 'tool' && transfer.toolId) {
      const row = await tx.playerTools.findFirst({
        where: {
          playerId: loot.killerId,
          toolId: transfer.toolId,
          location: 'carried',
          durability: transfer.durability,
        },
      });
      if (!row) {
        warnings.push(`loot_missing:tool:${transfer.toolId}`);
        continue;
      }
      const left = Number(row.quantity || 0) - qty;
      if (left > 0) {
        await tx.playerTools.update({ where: { id: row.id }, data: { quantity: left } });
      } else {
        if (left < 0) warnings.push(`loot_short:tool:${transfer.toolId}`);
        await tx.playerTools.delete({ where: { id: row.id } });
      }
    }
  }
}

export async function restorePlayerDeathSnapshot(snapshotId: number, adminId: number | null) {
  const stored = await prisma.playerDeathSnapshot.findUnique({ where: { id: snapshotId } });
  if (!stored) {
    throw new Error('DEATH_SNAPSHOT_NOT_FOUND');
  }
  if (stored.restoredAt) {
    throw new Error('DEATH_SNAPSHOT_ALREADY_RESTORED');
  }

  const draft = JSON.parse(stored.payload) as DeathDraft;
  const warnings: string[] = [];
  const losses = draft.losses || {};

  await prisma.$transaction(async (tx) => {
    await putBackMany(tx, 'property', losses.properties, warnings);
    await putBackMany(tx, 'propertyDrugStorage', losses.propertyDrugStorage, warnings);
    await putBackMany(tx, 'nightclubVenue', losses.nightclubVenues, warnings);
    await putBackMany(tx, 'nightclubDrugInventory', losses.nightclubDrugInventory, warnings);
    await putBackMany(tx, 'drugFacility', losses.drugFacilities, warnings);
    await putBackMany(tx, 'drugFacilityUpgrade', losses.drugFacilityUpgrades, warnings);
    await putBackMany(tx, 'drugProduction', losses.drugProductions, warnings);
    await putBackMany(tx, 'vehicleInventory', losses.vehicles, warnings);
    await putBackMany(tx, 'vehicle_tuning_upgrades', losses.vehicleTuning, warnings);
    await putBackMany(tx, 'vehicle_repair_jobs', losses.vehicleRepairJobs, warnings);
    await putBackMany(tx, 'inventory', losses.inventory, warnings);
    await putBackMany(tx, 'ammoInventory', losses.ammo, warnings);
    await putBackMany(tx, 'weaponInventory', losses.weapons, warnings);
    await putBackMany(tx, 'playerTools', losses.tools, warnings);
    await putBackMany(tx, 'toolLoadouts', losses.toolLoadouts, warnings);
    await putBackMany(tx, 'loadoutTools', losses.loadoutTools, warnings);
    await putBackMany(tx, 'prostitute', losses.prostitutes, warnings);
    const restoredCasinoIds = new Set<string>();
    for (const casino of (losses.casinos || []) as Array<Record<string, unknown>>) {
      const casinoId = String(casino.casinoId || '');
      if (!casinoId) continue;
      const existing = await tx.casinoOwnership.findUnique({ where: { casinoId } });
      if (existing && existing.ownerId !== stored.playerId) {
        const npc = await isNpcPlayerId(existing.ownerId);
        if (!npc) {
          warnings.push(`casino_owned:${casinoId}`);
          continue;
        }
        const data = reviveRow(casino);
        delete data.id;
        delete data.updatedAt;
        data.ownerId = stored.playerId;
        await tx.casinoOwnership.update({ where: { casinoId }, data });
      } else {
        await putBack(tx, 'casinoOwnership', casino, warnings);
      }
      restoredCasinoIds.add(casinoId);
    }
    for (const hire of (losses.casinoStaff || []) as Array<Record<string, unknown>>) {
      if (!restoredCasinoIds.has(String(hire.casinoId || ''))) continue;
      const existing = await tx.casinoStaffHire.findFirst({
        where: { casinoId: String(hire.casinoId), role: String(hire.role || '') },
      });
      if (existing) continue;
      await putBack(tx, 'casinoStaffHire', hire, warnings);
    }
    await putBackMany(tx, 'drugInventory', losses.drugInventory, warnings);
    await putBackMany(tx, 'productionMaterial', losses.productionMaterials, warnings);
    await putBackMany(tx, 'actionCooldown', losses.actionCooldowns, warnings);
    await putBackMany(tx, 'crimeAttempt', losses.crimeAttempts, warnings);
    await putBackMany(tx, 'jobAttempt', losses.jobAttempts, warnings);
    await putBackMany(tx, 'playerBackpack', losses.backpacks, warnings);
    await putBackMany(tx, 'inventoryUpgrades', losses.inventoryUpgrades, warnings);
    await putBackMany(tx, 'playerSelectedVehicle', losses.selectedVehicles, warnings);
    await putBackMany(tx, 'playerActivity', losses.activities, warnings);
    await putBackMany(tx, 'worldEvent', losses.worldEvents, warnings);
    await putBackMany(tx, 'prostitutionAchievement', losses.prostitutionAchievements, warnings);
    await putBackMany(tx, 'crypto_orders', losses.cryptoOrders, warnings);
    await putBackMany(tx, 'crypto_transactions', losses.cryptoTransactions, warnings);
    await putBackMany(tx, 'crypto_holdings', losses.cryptoHoldings, warnings);
    await putBackMany(tx, 'crypto_mission_progress', losses.cryptoMissionProgress, warnings);
    await putBackMany(tx, 'crypto_leaderboard_rewards', losses.cryptoLeaderboardRewards, warnings);

    const bank = (losses.bank || [])[0] as Record<string, unknown> | undefined;
    if (bank && typeof bank.balance === 'number') {
      await tx.bankAccount.updateMany({
        where: { playerId: stored.playerId },
        data: { balance: bank.balance },
      });
    }

    const playerData = reviveRow(draft.player || {});
    delete playerData.id;
    delete playerData.updatedAt;
    await tx.player.update({
      where: { id: stored.playerId },
      data: playerData,
    });

    await clawLoot(tx, draft.loot, warnings);

    for (const factory of (losses.ammoFactories || []) as Array<Record<string, unknown>>) {
      const countryId = String(factory.countryId || '');
      if (!countryId) continue;
      const current = await tx.ammoFactory.findUnique({ where: { countryId } });
      if (!current) {
        warnings.push(`factory_missing:${countryId}`);
        continue;
      }
      if (current.ownerId && current.ownerId !== stored.playerId) {
        const npc = await isNpcPlayerId(current.ownerId);
        if (!npc) {
          warnings.push(`factory_owned:${countryId}`);
          continue;
        }
      }
      await tx.ammoFactory.update({
        where: { countryId },
        data: {
          ownerId: stored.playerId,
          level: Number(factory.level || 1),
          qualityLevel: Number(factory.qualityLevel || 1),
          lastActiveAt: factory.lastActiveAt ? new Date(String(factory.lastActiveAt)) : null,
          lastProducedAt: factory.lastProducedAt ? new Date(String(factory.lastProducedAt)) : null,
        },
      });
    }

    await tx.playerDeathSnapshot.update({
      where: { id: snapshotId },
      data: {
        restoredAt: new Date(),
        restoredByAdminId: adminId,
      },
    });
  }, { timeout: 120_000, maxWait: 10_000 });

  return { snapshotId, playerId: stored.playerId, warnings };
}

export async function listPlayerDeathSnapshots(playerId: number) {
  const rows = await prisma.playerDeathSnapshot.findMany({
    where: { playerId },
    orderBy: { id: 'desc' },
    select: {
      id: true,
      hitId: true,
      killerId: true,
      placedById: true,
      bounty: true,
      vipProtectionApplied: true,
      summary: true,
      createdAt: true,
      restoredAt: true,
    },
  });
  return rows.map((row) => ({
    ...row,
    summary: JSON.parse(row.summary),
  }));
}
