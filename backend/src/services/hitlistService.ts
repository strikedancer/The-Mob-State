/**
 * Hit List Service - Phase C.4
 * 
 * Handles hit list creation, bounties, combat, and security system
 */

import prisma from '../lib/prisma';
import { ammoFactoryService } from './ammoFactoryService';
import weaponService from './weaponService';
import fs from 'fs';
import path from 'path';

const BODYGUARD_DAILY_UPKEEP = 10000;
const BODYGUARD_DEFENSE = 10;
const DAY_IN_MS = 24 * 60 * 60 * 1000;

interface SecurityArmorDefinition {
  id: string;
  name: string;
  price: number;
  armor: number;
  description: string;
}

interface PlayerSecurityState {
  id: number;
  playerId: number;
  bodyguards: number;
  bodyguardUpkeepDueAt: Date | null;
  armor: number;
  armorCondition: number;
  armorType: string | null;
}

let cachedArmorDefinitions: SecurityArmorDefinition[] | null = null;

interface HitListItem {
  id: number;
  targetId: number;
  placedById: number;
  bounty: number;
  counterBounty?: number;
  status: string;
  createdAt: Date;
  completedAt?: Date;
  completedBy?: number;
}

function loadArmorDefinitions(): SecurityArmorDefinition[] {
  if (cachedArmorDefinitions) {
    return cachedArmorDefinitions;
  }

  const filePath = path.resolve(process.cwd(), 'content', 'security.json');
  const raw = fs.readFileSync(filePath, 'utf8');
  const parsed = JSON.parse(raw) as SecurityArmorDefinition[];
  cachedArmorDefinitions = parsed;
  return parsed;
}

function getArmorDefinition(armorId: string): SecurityArmorDefinition {
  const definitions = loadArmorDefinitions();
  const armor = definitions.find((item) => item.id === armorId);
  if (!armor) {
    throw new Error('ARMOR_NOT_FOUND');
  }

  return armor;
}

function getArmorConditionValue(condition?: number | null): number {
  const normalized = typeof condition === 'number' ? condition : 100;
  return Math.max(0, Math.min(100, normalized));
}

function getEffectiveArmor(security?: Pick<PlayerSecurityState, 'armor' | 'armorCondition'> | null): number {
  if (!security || !security.armor) {
    return 0;
  }

  return Math.max(0, Math.round(security.armor * (getArmorConditionValue(security.armorCondition) / 100)));
}

function calculateArmorConditionLoss(attackerPower: number): number {
  return Math.max(6, Math.min(35, Math.round(Math.sqrt(Math.max(1, attackerPower)) * 1.5)));
}

async function settleBodyguardUpkeep(db: any, playerId: number): Promise<PlayerSecurityState | null> {
  const security = await db.playerSecurity.findUnique({
    where: { playerId },
  });

  if (!security) {
    return null;
  }

  const now = new Date();
  let bodyguards = Number(security.bodyguards || 0);
  let upkeepDueAt = security.bodyguardUpkeepDueAt ? new Date(security.bodyguardUpkeepDueAt) : null;
  let changedSecurity = false;

  if (bodyguards <= 0) {
    if (upkeepDueAt !== null) {
      upkeepDueAt = null;
      changedSecurity = true;
    }
  } else if (!upkeepDueAt) {
    upkeepDueAt = new Date(now.getTime() + DAY_IN_MS);
    changedSecurity = true;
  } else {
    const player = await db.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    let balance = Number(player?.money || 0);
    let changedMoney = false;

    while (bodyguards > 0 && upkeepDueAt && upkeepDueAt.getTime() <= now.getTime()) {
      const cycleCost = bodyguards * BODYGUARD_DAILY_UPKEEP;
      if (balance >= cycleCost) {
        balance -= cycleCost;
        upkeepDueAt = new Date(upkeepDueAt.getTime() + DAY_IN_MS);
        changedMoney = true;
      } else {
        bodyguards = 0;
        upkeepDueAt = null;
        changedSecurity = true;
        break;
      }
    }

    if (changedMoney) {
      await db.player.update({
        where: { id: playerId },
        data: { money: balance },
      });
      changedSecurity = true;
    }
  }

  if (!changedSecurity) {
    return {
      ...security,
      armorCondition: getArmorConditionValue(security.armorCondition),
      bodyguardUpkeepDueAt: upkeepDueAt,
      bodyguards,
    };
  }

  return db.playerSecurity.update({
    where: { playerId },
    data: {
      bodyguards,
      bodyguardUpkeepDueAt: upkeepDueAt,
      armorCondition: getArmorConditionValue(security.armorCondition),
    },
  });
}

async function applyArmorWearInTransaction(
  tx: any,
  targetSecurity: PlayerSecurityState | null,
  conditionLoss: number,
) {
  if (!targetSecurity || !targetSecurity.armor || conditionLoss <= 0) {
    return;
  }

  const currentCondition = getArmorConditionValue(targetSecurity.armorCondition);
  const nextCondition = Math.max(0, currentCondition - conditionLoss);

  if (nextCondition <= 0) {
    await tx.playerSecurity.update({
      where: { playerId: targetSecurity.playerId },
      data: {
        armor: 0,
        armorCondition: 100,
        armorType: null,
      },
    });
    return;
  }

  await tx.playerSecurity.update({
    where: { playerId: targetSecurity.playerId },
    data: {
      armorCondition: nextCondition,
    },
  });
}

export async function placeHit(
  playerId: number,
  targetId: number,
  bounty: number
): Promise<HitListItem> {
  // Validate
  if (bounty < 50000) {
    throw new Error('BOUNTY_TOO_LOW');
  }

  if (playerId === targetId) {
    throw new Error('CANNOT_HIT_YOURSELF');
  }

  // Check if player already has active hit on target
  const existing = await prisma.hitList.findFirst({
    where: {
      placedById: playerId,
      targetId,
      status: 'ACTIVE',
    },
  });

  if (existing) {
    throw new Error('HIT_ALREADY_EXISTS');
  }

  // Check if player can afford bounty
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < bounty) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct bounty from player
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - bounty },
  });

  // Create hit
  const hit = await prisma.hitList.create({
    data: {
      targetId,
      placedById: playerId,
      bounty,
      status: 'ACTIVE',
    },
  });

  // Mark target as hunted
  await prisma.player.update({
    where: { id: targetId },
    data: { isHunted: true },
  });

  return hit as any;
}

export async function placeCounterBounty(
  playerId: number,
  hitId: number,
  counterBounty: number
): Promise<HitListItem> {
  // Get hit
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  // Only target can place counter-bounty
  if (hit.targetId !== playerId) {
    throw new Error('NOT_TARGET');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  // Check if counter bounty is higher
  if (!counterBounty || counterBounty <= hit.bounty) {
    throw new Error('COUNTER_BOUNTY_MUST_BE_HIGHER');
  }

  // Check if player can afford counter bounty
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  const difference = counterBounty - hit.bounty;
  if (!player || player.money < difference) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct difference from player
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - difference },
  });

  // Update hit with counter bounty
  const updatedHit = await prisma.hitList.update({
    where: { id: hitId },
    data: { counterBounty },
  });

  return updatedHit as any;
}

export async function getActiveHits(pageSize = 20, offset = 0): Promise<any[]> {
  const hits = await prisma.hitList.findMany({
    where: { status: 'ACTIVE' },
    orderBy: { createdAt: 'desc' },
    take: pageSize,
    skip: offset,
    include: {
      target: {
        select: {
          id: true,
          username: true,
          rank: true,
          avatar: true,
          currentCountry: true,
        },
      },
      placedBy: {
        select: {
          id: true,
          username: true,
          rank: true,
          avatar: true,
        },
      },
    },
  });

  return hits.map(hit => ({
    ...hit,
    target: hit.target
      ? {
          ...hit.target,
          level: hit.target.rank,
        }
      : hit.target,
  }));
}

export async function attemptHit(
  playerId: number,
  hitId: number,
  weaponId: string,
  ammoQuantity: number
): Promise<any> {
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  const attacker = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true, money: true },
  });

  if (!attacker) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const target = await prisma.player.findUnique({
    where: { id: hit.targetId },
    select: { weapon: true, currentCountry: true, hitProtectionExpiresAt: true },
  });

  if (!target) {
    throw new Error('TARGET_NOT_FOUND');
  }

  if (attacker.currentCountry !== target.currentCountry) {
    throw new Error('DIFFERENT_COUNTRY');
  }

  if (target.hitProtectionExpiresAt && target.hitProtectionExpiresAt > new Date()) {
    throw new Error('TARGET_UNDER_HIT_PROTECTION');
  }

  const weaponData = weaponService.getWeaponDefinition(String(weaponId));
  if (!weaponData) {
    throw new Error('WEAPON_NOT_FOUND');
  }

  const ownedWeapon = await prisma.weaponInventory.findUnique({
    where: {
      playerId_weaponId: {
        playerId,
        weaponId: String(weaponId),
      },
    },
  });

  if (!ownedWeapon || ownedWeapon.quantity <= 0 || ownedWeapon.condition <= 0) {
    throw new Error('WEAPON_NOT_OWNED');
  }

  const requiresAmmo = weaponData.requiresAmmo !== false;
  const ammoUsed = requiresAmmo ? Number(ammoQuantity) : 0;
  if (requiresAmmo && (!Number.isFinite(ammoUsed) || ammoUsed <= 0)) {
    throw new Error('INVALID_AMMO');
  }

  let ammoQuality = 1.0;
  let ammoInventoryId: number | null = null;
  let ammoRemaining = 0;

  if (requiresAmmo) {
    const ammoType = weaponData.ammoType;
    if (!ammoType) {
      throw new Error('WEAPON_NOT_FOUND');
    }

    const ammoInventory = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    if (!ammoInventory || ammoInventory.quantity < ammoUsed) {
      throw new Error('INSUFFICIENT_AMMO');
    }

    ammoInventoryId = ammoInventory.id;
    ammoRemaining = ammoInventory.quantity - ammoUsed;
    ammoQuality = ammoInventory.quality || 1.0;
  }

  const targetSecurity = await settleBodyguardUpkeep(prisma, hit.targetId);

  const shootingStats = await prisma.shootingRangeStats.findUnique({
    where: { playerId },
  });
  const sessionsCompleted = shootingStats?.sessionsCompleted || 0;
  const accuracy = Math.min(0.9, 0.5 + (sessionsCompleted / 100) * 0.4);
  const hitRoll = Math.random();
  const hitMultiplier = hitRoll <= accuracy ? 1 : 0.2;
  const ammoQualityMultiplier = 1 + (ammoQuality - 1) * 0.5;
  const conditionMultiplier = Math.max(0.2, ownedWeapon.condition / 100);
  const attackVolume = requiresAmmo ? ammoUsed : 1;
  const attackerPower =
    weaponData.damage *
    attackVolume *
    hitMultiplier *
    ammoQualityMultiplier *
    conditionMultiplier;

  const targetWeapon = target.weapon
    ? weaponService.getWeaponDefinition(String(target.weapon))
    : undefined;
  const targetWeaponDamage = targetWeapon?.damage || 0;
  const targetDefense = getEffectiveArmor(targetSecurity) + ((targetSecurity?.bodyguards || 0) * BODYGUARD_DEFENSE);
  const targetPower = targetWeaponDamage * 5 + targetDefense;
  const armorConditionLoss = calculateArmorConditionLoss(attackerPower);

  const rawWinChance = attackerPower / Math.max(1, attackerPower + targetPower);
  const winChance = Math.min(0.95, Math.max(0.05, rawWinChance));
  const attackerWins = Math.random() < winChance;

  const bounty =
    hit.counterBounty && hit.counterBounty > hit.bounty
      ? hit.counterBounty
      : hit.bounty;
  const isCounterReversal = !!(hit.counterBounty && hit.counterBounty > hit.bounty);

  const originalPlacer = await prisma.player.findUnique({
    where: { id: hit.placedById },
    select: { money: true },
  });

  if (attackerWins) {
    await prisma.$transaction(async (tx) => {
      if (ammoInventoryId != null) {
        await tx.ammoInventory.update({
          where: { id: ammoInventoryId },
          data: { quantity: ammoRemaining },
        });
      }

      await applyArmorWearInTransaction(tx, targetSecurity, armorConditionLoss);

      await tx.player.update({
        where: { id: playerId },
        data: {
          money: attacker.money + bounty,
          killCount: { increment: 1 },
        },
      });

      if (isCounterReversal) {
        await tx.player.update({
          where: { id: hit.placedById },
          data: { health: 0, isHunted: true },
        });
      } else {
        await tx.player.update({
          where: { id: hit.targetId },
          data: { health: 0, isHunted: false, hitCount: { increment: 1 } },
        });
      }

      await tx.hitList.update({
        where: { id: hitId },
        data: {
          status: 'COMPLETED',
          completedBy: playerId,
          completedAt: new Date(),
        },
      });
    });

    await ammoFactoryService.revokeFactoriesForPlayer(
      isCounterReversal ? hit.placedById : hit.targetId
    );

    return {
      success: true,
      winner: playerId,
      bountyPaid: bounty,
      message: `Hit completed! ${playerId} won €${bounty}`,
    };
  }

  await prisma.$transaction(async (tx) => {
    if (ammoInventoryId != null) {
      await tx.ammoInventory.update({
        where: { id: ammoInventoryId },
        data: { quantity: ammoRemaining },
      });
    }

    await applyArmorWearInTransaction(tx, targetSecurity, armorConditionLoss);

    if (!isCounterReversal) {
      await tx.player.update({
        where: { id: hit.placedById },
        data: { money: (originalPlacer?.money || 0) + hit.bounty },
      });

      await tx.hitList.update({
        where: { id: hitId },
        data: { status: 'CANCELLED' },
      });
    }
  });

  return {
    success: false,
    winner: hit.targetId,
    message: 'Hit failed! Target defended successfully',
  };
}

type InvestigationTier = 'quick' | 'standard' | 'deep';

export async function investigateHit(
  playerId: number,
  hitId: number,
  tier: InvestigationTier
): Promise<{
  success: true;
  report: {
    targetId: number;
    country: string | null;
    bodyguards: number;
    armor: number;
    validUntil: string;
    tier: InvestigationTier;
    cost: number;
  };
}> {
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  const tierCost: Record<InvestigationTier, number> = {
    quick: 100000,
    standard: 50000,
    deep: 25000,
  };

  const cost = tierCost[tier];
  if (!cost) {
    throw new Error('INVALID_INVESTIGATION_TIER');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < cost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const target = await prisma.player.findUnique({
    where: { id: hit.targetId },
    select: { currentCountry: true },
  });

  if (!target) {
    throw new Error('TARGET_NOT_FOUND');
  }

  const targetSecurity = await settleBodyguardUpkeep(prisma, hit.targetId);

  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - cost },
  });

  return {
    success: true,
    report: {
      targetId: hit.targetId,
      country: target.currentCountry,
      bodyguards: targetSecurity?.bodyguards || 0,
      armor: getEffectiveArmor(targetSecurity),
      validUntil: new Date(Date.now() + 3 * 60 * 60 * 1000).toISOString(),
      tier,
      cost,
    },
  };
}

export async function cancelHit(playerId: number, hitId: number): Promise<any> {
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  // Only placer can cancel
  if (hit.placedById !== playerId) {
    throw new Error('NOT_PLACER');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  // Refund bounty
  const placer = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  await prisma.player.update({
    where: { id: playerId },
    data: { money: (placer?.money || 0) + hit.bounty },
  });

  // Update hit
  await prisma.hitList.update({
    where: { id: hitId },
    data: { status: 'CANCELLED' },
  });

  // Check if target has other active hits
  const otherHits = await prisma.hitList.count({
    where: {
      targetId: hit.targetId,
      status: 'ACTIVE',
    },
  });

  // If no other hits, mark target as no longer hunted
  if (otherHits === 0) {
    await prisma.player.update({
      where: { id: hit.targetId },
      data: { isHunted: false },
    });
  }

  return { success: true };
}

export async function buyBodyguards(
  playerId: number,
  quantity: number
): Promise<any> {
  const cost = quantity * 10000; // €10k per bodyguard

  const security = await settleBodyguardUpkeep(prisma, playerId);

  // Check if player can afford
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < cost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct cost
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - cost },
  });

  if (security) {
    await prisma.playerSecurity.update({
      where: { playerId },
      data: {
        bodyguards: security.bodyguards + quantity,
        bodyguardUpkeepDueAt: security.bodyguards > 0
          ? security.bodyguardUpkeepDueAt
          : new Date(Date.now() + DAY_IN_MS),
      },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        bodyguards: quantity,
        bodyguardUpkeepDueAt: new Date(Date.now() + DAY_IN_MS),
      },
    });
  }

  return {
    success: true,
    message: `${quantity} bodyguards hired for €${cost}`,
  };
}

export async function buyArmor(
  playerId: number,
  armorId: string
): Promise<any> {
  const armor = getArmorDefinition(armorId);

  await settleBodyguardUpkeep(prisma, playerId);

  // Check if player can afford
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < armor.price) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct cost
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - armor.price },
  });

  // Update or create security
  const security = await prisma.playerSecurity.findUnique({
    where: { playerId },
  });

  if (security) {
    await prisma.playerSecurity.update({
      where: { playerId },
      data: {
        armor: armor.armor,
        armorCondition: 100,
        armorType: armorId,
      },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        bodyguardUpkeepDueAt: null,
        armor: armor.armor,
        armorCondition: 100,
        armorType: armorId,
      },
    });
  }

  return {
    success: true,
    message: `${armor.name} purchased for €${armor.price}`,
  };
}

export async function getSecurityStatus(
  playerId: number
): Promise<any> {
  const security = await settleBodyguardUpkeep(prisma, playerId);

  if (!security) {
    return {
      bodyguards: 0,
      armor: 0,
      baseArmor: 0,
      armorCondition: 100,
      armorDamagePercent: 0,
      armorType: null,
      bodyguardDailyCost: 0,
      bodyguardUpkeepDueAt: null,
    };
  }

  const armorCondition = security.armor > 0 ? getArmorConditionValue(security.armorCondition) : 100;
  return {
    ...security,
    armor: getEffectiveArmor(security),
    baseArmor: security.armor,
    armorCondition,
    armorDamagePercent: security.armor > 0 ? 100 - armorCondition : 0,
    bodyguardDailyCost: security.bodyguards * BODYGUARD_DAILY_UPKEEP,
    bodyguardUpkeepDueAt: security.bodyguardUpkeepDueAt?.toISOString() ?? null,
  };
}
