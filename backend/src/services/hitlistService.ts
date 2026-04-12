/**
 * Hit List Service - Phase C.4
 * 
 * Handles hit list creation, bounties, combat, and security system
 */

import prisma from '../lib/prisma';
import { ammoFactoryService } from './ammoFactoryService';
import weaponService from './weaponService';

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

  const targetSecurity = await prisma.playerSecurity.findUnique({
    where: { playerId: hit.targetId },
  });

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
  const targetDefense = (targetSecurity?.armor || 0) + ((targetSecurity?.bodyguards || 0) * 10);
  const targetPower = targetWeaponDamage * 5 + targetDefense;

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

  const targetSecurity = await prisma.playerSecurity.findUnique({
    where: { playerId: hit.targetId },
    select: { bodyguards: true, armor: true },
  });

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
      armor: targetSecurity?.armor || 0,
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

  // Update or create security
  const security = await prisma.playerSecurity.findUnique({
    where: { playerId },
  });

  if (security) {
    await prisma.playerSecurity.update({
      where: { playerId },
      data: { bodyguards: security.bodyguards + quantity },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        bodyguards: quantity,
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
  // Security.json content file not available - feature disabled
  throw new Error('ARMOR_PURCHASE_UNAVAILABLE');

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
        armor: Math.max(security.armor, armor.armor), // Take highest armor rating
        armorType: armorId,
      },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        armor: armor.armor,
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
  const security = await prisma.playerSecurity.findUnique({
    where: { playerId },
  });

  if (!security) {
    return {
      bodyguards: 0,
      armor: 0,
      armorType: null,
    };
  }

  return security;
}
