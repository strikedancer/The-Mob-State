import fs from 'fs';
import path from 'path';
import prisma from '../lib/prisma';

interface Backpack {
  id: string;
  name: string;
  description: string;
  type: string;
  slots: number;
  price: number;
  requiredRank: number;
  vipOnly: boolean;
  icon: string;
}

interface PlayerBackpack {
  id: number;
  playerId: number;
  backpackId: string;
  purchasedAt: Date;
  backpack?: Backpack;
}

let backpacksCache: Backpack[] | null = null;

/**
 * Load all backpacks from JSON file
 */
function loadBackpacks(): Backpack[] {
  if (backpacksCache) {
    return backpacksCache;
  }

  const backpacksPath = path.join(process.cwd(), 'content', 'backpacks.json');
  const data = fs.readFileSync(backpacksPath, 'utf-8');
  const parsed = JSON.parse(data);
  backpacksCache = parsed.backpacks;
  return backpacksCache;
}

/**
 * Get all available backpacks
 */
export function getAllBackpacks(): Backpack[] {
  return loadBackpacks();
}

/**
 * Get backpack by ID
 */
export function getBackpackById(backpackId: string): Backpack | undefined {
  const backpacks = loadBackpacks();
  return backpacks.find(b => b.id === backpackId);
}

/**
 * Get player's current backpack
 */
export async function getPlayerBackpack(playerId: number): Promise<PlayerBackpack | null> {
  const playerBackpack = await prisma.playerBackpack.findUnique({
    where: { playerId }
  }) as any;

  if (!playerBackpack) {
    return null;
  }

  const backpackDef = getBackpackById(playerBackpack.backpackId);
  
  if (backpackDef) {
    playerBackpack.backpack = backpackDef;
  }

  return playerBackpack;
}

/**
 * Calculate total carrying capacity for player (base + backpack)
 */
export async function getPlayerCarryingCapacity(playerId: number): Promise<number> {
  const BASE_SLOTS = 5;
  const playerBackpack = await getPlayerBackpack(playerId);
  
  if (!playerBackpack || !playerBackpack.backpack) {
    return BASE_SLOTS;
  }

  return BASE_SLOTS + playerBackpack.backpack.slots;
}

/**
 * Purchase a backpack
 */
export async function purchaseBackpack(
  playerId: number,
  backpackId: string
): Promise<{ 
  success: boolean; 
  event?: string;
  params?: Record<string, any>;
  backpack?: Backpack;
  message?: string;
}> {
  const backpackDef = getBackpackById(backpackId);

  if (!backpackDef) {
    return { 
      success: false, 
      event: 'backpack.purchase_failed',
      params: { reason: 'not_found' }
    };
  }

  // Check if player already has a backpack
  const existingBackpack = await getPlayerBackpack(playerId);
  if (existingBackpack) {
    return { 
      success: false, 
      event: 'backpack.purchase_failed',
      params: { reason: 'already_has' }
    };
  }

  // Get player info
  const player = await prisma.player.findUnique({
    where: { id: playerId }
  }) as any;

  if (!player) {
    return { 
      success: false, 
      event: 'backpack.purchase_failed',
      params: { reason: 'player_not_found' }
    };
  }

  // Check rank requirement
  if (player.rank < backpackDef.requiredRank) {
    return {
      success: false,
      event: 'backpack.purchase_failed',
      params: { 
        reason: 'insufficient_rank',
        required: backpackDef.requiredRank,
        current: player.rank
      }
    };
  }

  // Check VIP requirement
  if (backpackDef.vipOnly && (!player.vipStatus || player.vipStatus === 'NONE')) {
    return {
      success: false,
      event: 'backpack.purchase_failed',
      params: { reason: 'vip_only' }
    };
  }

  // Check if player has enough money
  if (player.money < backpackDef.price) {
    return {
      success: false,
      event: 'backpack.purchase_failed',
      params: { 
        reason: 'insufficient_funds',
        needed: backpackDef.price,
        have: player.money
      }
    };
  }

  try {
    // Deduct money and give backpack (in transaction)
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: backpackDef.price } }
      }),
      prisma.playerBackpack.create({
        data: {
          playerId,
          backpackId
        }
      })
    ]);

    return {
      success: true,
      event: 'backpack.purchased',
      params: {
        name: backpackDef.name,
        slots: backpackDef.slots,
        price: backpackDef.price
      },
      backpack: backpackDef
    };
  } catch (error) {
    console.error('Error purchasing backpack:', error);
    return { 
      success: false, 
      event: 'backpack.purchase_failed',
      params: { reason: 'database_error' }
    };
  }
}

/**
 * Upgrade backpack (sell old one and buy new one)
 */
export async function upgradeBackpack(
  playerId: number,
  newBackpackId: string
): Promise<{ 
  success: boolean; 
  event?: string;
  params?: Record<string, any>;
  backpack?: Backpack;
  message?: string;
}> {
  const newBackpackDef = getBackpackById(newBackpackId);

  if (!newBackpackDef) {
    return { 
      success: false, 
      event: 'backpack.upgrade_failed',
      params: { reason: 'not_found' }
    };
  }

  const existingBackpack = await getPlayerBackpack(playerId);
  if (!existingBackpack || !existingBackpack.backpack) {
    return {
      success: false,
      event: 'backpack.upgrade_failed',
      params: { reason: 'no_backpack' }
    };
  }

  const oldBackpack = existingBackpack.backpack;

  // Check if new backpack is actually better
  if (newBackpackDef.slots <= oldBackpack.slots) {
    return {
      success: false,
      event: 'backpack.upgrade_failed',
      params: { reason: 'not_an_upgrade' }
    };
  }

  // Get player info
  const player = await prisma.player.findUnique({
    where: { id: playerId }
  }) as any;

  if (!player) {
    return { 
      success: false, 
      event: 'backpack.upgrade_failed',
      params: { reason: 'player_not_found' }
    };
  }

  // Check rank requirement
  if (player.rank < newBackpackDef.requiredRank) {
    return {
      success: false,
      event: 'backpack.upgrade_failed',
      params: { 
        reason: 'insufficient_rank',
        required: newBackpackDef.requiredRank,
        current: player.rank
      }
    };
  }

  // Check VIP requirement
  if (newBackpackDef.vipOnly && (!player.vipStatus || player.vipStatus === 'NONE')) {
    return {
      success: false,
      event: 'backpack.upgrade_failed',
      params: { reason: 'vip_only' }
    };
  }

  // Calculate upgrade cost (75% of new backpack price - trade-in value)
  const tradeInValue = Math.floor(oldBackpack.price * 0.5); // 50% trade-in value
  const upgradeCost = newBackpackDef.price - tradeInValue;

  // Check if player has enough money
  if (player.money < upgradeCost) {
    return {
      success: false,
      event: 'backpack.upgrade_failed',
      params: { 
        reason: 'insufficient_funds',
        needed: upgradeCost,
        have: player.money,
        tradeInValue
      }
    };
  }

  try {
    // Deduct upgrade cost and update backpack (in transaction)
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } }
      }),
      prisma.playerBackpack.update({
        where: { playerId },
        data: {
          backpackId: newBackpackId,
          purchasedAt: new Date()
        }
      })
    ]);

    return {
      success: true,
      event: 'backpack.upgraded',
      params: {
        oldName: oldBackpack.name,
        newName: newBackpackDef.name,
        oldSlots: oldBackpack.slots,
        newSlots: newBackpackDef.slots,
        upgradeSlots: newBackpackDef.slots - oldBackpack.slots,
        upgradeCost,
        tradeInValue
      },
      backpack: newBackpackDef
    };
  } catch (error) {
    console.error('Error upgrading backpack:', error);
    return { 
      success: false, 
      event: 'backpack.upgrade_failed',
      params: { reason: 'database_error' }
    };
  }
}

/**
 * Get backpacks available for player (based on rank and VIP status)
 */
export async function getAvailableBackpacks(playerId: number): Promise<{
  owned: Backpack | null;
  available: Backpack[];
  canUpgradeTo: Backpack[];
}> {
  const allBackpacks = getAllBackpacks();
  const playerBackpack = await getPlayerBackpack(playerId);

  // Get player info
  const player = await prisma.player.findUnique({
    where: { id: playerId }
  }) as any;

  if (!player) {
    return { owned: null, available: [], canUpgradeTo: [] };
  }

  const isVip = player.isVip || false;

  const owned = playerBackpack?.backpack || null;
  const ownedSlots = owned?.slots || 0;

  // Filter available backpacks
  const available = allBackpacks.filter(bp => {
    // Check rank
    if (player.rank < bp.requiredRank) return false;
    
    // Check VIP
    if (bp.vipOnly && !isVip) return false;
    
    // Don't show if already owned
    if (owned && bp.id === owned.id) return false;
    
    return true;
  });

  // Upgradeable backpacks (better than current)
  const canUpgradeTo = available.filter(bp => bp.slots > ownedSlots);

  return { owned, available, canUpgradeTo };
}

export default {
  getAllBackpacks,
  getBackpackById,
  getPlayerBackpack,
  getPlayerCarryingCapacity,
  purchaseBackpack,
  upgradeBackpack,
  getAvailableBackpacks
};
