import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';
import toolService from './toolService';
import backpackService from './backpackService';

const { getPlayerCarryingCapacity } = backpackService;

interface WeaponDefinition {
  id: string;
  name: string;
  type: string;
  damage: number;
  intimidation: number;
  requiresAmmo: boolean;
  ammoType?: string;
  magazineCapacity?: number;
  ammoPerCrime?: number;
  price: number;
  requiredRank: number;
  vipOnly?: boolean;
  image?: string;
  suitableFor: string[];
  conditionDegradation: number;
}

interface WeaponsData {
  weapons: WeaponDefinition[];
}

class WeaponService {
  private weapons: WeaponDefinition[] = [];

  constructor() {
    this.loadWeapons();
  }

  private loadWeapons() {
    const weaponsPath = join(__dirname, '../../content/weapons.json');
    const weaponsData = readFileSync(weaponsPath, 'utf-8');
    const data: WeaponsData = JSON.parse(weaponsData);
    this.weapons = data.weapons;
  }

  /**
   * Get all weapon definitions
   */
  getAllWeapons(): WeaponDefinition[] {
    return this.weapons;
  }

  /**
   * Get a specific weapon definition by ID
   */
  getWeaponDefinition(weaponId: string): WeaponDefinition | undefined {
    return this.weapons.find((w) => w.id === weaponId);
  }

  /**
   * Get player's weapon inventory with definitions
   */
  async getPlayerWeapons(playerId: number) {
    const inventory = await prisma.weaponInventory.findMany({
      where: { playerId },
      orderBy: { purchasedAt: 'desc' },
    });

    return inventory.map((item) => {
      const definition = this.getWeaponDefinition(item.weaponId);
      return {
        ...item,
        ...definition,
        isBroken: item.condition < 10,
        needsRepair: item.condition < 50,
      };
    });
  }

  /**
   * Buy a weapon from the black market
   */
  async buyWeapon(
    playerId: number,
    weaponId: string
  ): Promise<{ success: boolean; error?: string; weapon?: any }> {
    const weapon = this.getWeaponDefinition(weaponId);

    if (!weapon) {
      return { success: false, error: 'WEAPON_NOT_FOUND' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Check VIP requirement
    if (weapon.vipOnly && !player.isVip) {
      return { success: false, error: 'VIP_ONLY' };
    }

    // Check rank requirement (rank 15 unlocks all non-VIP weapons)
    if (player.rank < weapon.requiredRank && player.rank < 15) {
      return { success: false, error: 'RANK_TOO_LOW' };
    }

    // Check if player has enough money
    if (player.money < weapon.price) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    const currentUsage = await toolService.calculateInventoryUsage(playerId);
    const maxSlots = await getPlayerCarryingCapacity(playerId);
    if (currentUsage + 1 > maxSlots) {
      return { success: false, error: 'INVENTORY_FULL' };
    }

    // Check if player already has this weapon
    const existing = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
    });

    if (existing) {
      // Increase quantity instead of buying duplicate
      await prisma.weaponInventory.update({
        where: { id: existing.id },
        data: { quantity: existing.quantity + 1 },
      });

      await prisma.player.update({
        where: { id: playerId },
        data: {
          money: player.money - weapon.price,
          inventory_slots_used: currentUsage + 1,
        },
      });

      return { success: true, weapon: { ...weapon, quantity: existing.quantity + 1 } };
    }

    // Buy new weapon
    const newWeapon = await prisma.weaponInventory.create({
      data: {
        playerId,
        weaponId,
        quantity: 1,
        condition: 100,
      },
    });

    await prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money - weapon.price,
        inventory_slots_used: currentUsage + 1,
      },
    });

    return { success: true, weapon: { ...newWeapon, ...weapon } };
  }

  /**
   * Sell a weapon
   */
  async sellWeapon(
    playerId: number,
    inventoryId: number
  ): Promise<{ success: boolean; error?: string; sellPrice?: number }> {
    const item = await prisma.weaponInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!item) {
      return { success: false, error: 'WEAPON_NOT_FOUND' };
    }

    if (item.playerId !== playerId) {
      return { success: false, error: 'NOT_YOUR_WEAPON' };
    }

    const weapon = this.getWeaponDefinition(item.weaponId);
    if (!weapon) {
      return { success: false, error: 'WEAPON_DEFINITION_NOT_FOUND' };
    }

    // Sell price is 40% of purchase price * condition percentage
    const sellPrice = Math.floor(weapon.price * 0.4 * (item.condition / 100));

    if (item.quantity > 1) {
      // Decrease quantity
      await prisma.weaponInventory.update({
        where: { id: inventoryId },
        data: { quantity: item.quantity - 1 },
      });
    } else {
      // Delete if only 1
      await prisma.weaponInventory.delete({
        where: { id: inventoryId },
      });
    }

    const newUsage = Math.max(0, (await toolService.calculateInventoryUsage(playerId)) - 1);

    await prisma.player.update({
      where: { id: playerId },
      data: {
        money: { increment: sellPrice },
        inventory_slots_used: newUsage,
      },
    });

    return { success: true, sellPrice };
  }

  /**
   * Repair a weapon
   */
  async repairWeapon(
    playerId: number,
    inventoryId: number
  ): Promise<{ success: boolean; error?: string; repairCost?: number }> {
    const item = await prisma.weaponInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!item) {
      return { success: false, error: 'WEAPON_NOT_FOUND' };
    }

    if (item.playerId !== playerId) {
      return { success: false, error: 'NOT_YOUR_WEAPON' };
    }

    if (item.condition >= 100) {
      return { success: false, error: 'WEAPON_ALREADY_PERFECT' };
    }

    const weapon = this.getWeaponDefinition(item.weaponId);
    if (!weapon) {
      return { success: false, error: 'WEAPON_DEFINITION_NOT_FOUND' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Repair cost: 30% of weapon price * (100 - condition) / 100
    const conditionLoss = 100 - item.condition;
    const repairCost = Math.ceil(weapon.price * 0.3 * (conditionLoss / 100));

    if (player.money < repairCost) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    await prisma.weaponInventory.update({
      where: { id: inventoryId },
      data: { condition: 100 },
    });

    await prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - repairCost },
    });

    return { success: true, repairCost };
  }

  /**
   * Degrade weapon condition after use
   */
  async degradeWeapon(playerId: number, weaponId: string): Promise<void> {
    const item = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
    });

    if (!item) return;

    const weapon = this.getWeaponDefinition(weaponId);
    if (!weapon) return;

    const newCondition = Math.max(0, item.condition - weapon.conditionDegradation);

    await prisma.weaponInventory.update({
      where: { id: item.id },
      data: { condition: newCondition },
    });
  }

  /**
   * Check if player has a specific weapon and it's usable
   */
  async hasUsableWeapon(
    playerId: number,
    weaponId: string
  ): Promise<{ hasWeapon: boolean; isBroken?: boolean; condition?: number }> {
    const item = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
    });

    if (!item) {
      return { hasWeapon: false };
    }

    return {
      hasWeapon: true,
      isBroken: item.condition < 10,
      condition: item.condition,
    };
  }

  /**
   * Get best weapon for a crime based on requirements
   */
  async getBestWeaponForCrime(
    playerId: number,
    suitableTypes: string[] = [],
    minDamage?: number,
    minIntimidation?: number
  ) {
    const inventory = await this.getPlayerWeapons(playerId);

    // Filter to weapons that meet requirements and are not broken
    const suitable = inventory.filter((item) => {
      if (item.condition < 10) return false; // Broken weapon

      // Check weapon type if specified
      if (suitableTypes.length > 0 && !suitableTypes.includes(item.type || '')) {
        return false;
      }

      // Check minimum damage if specified
      if (minDamage !== undefined && (item.damage || 0) < minDamage) {
        return false;
      }

      // Check minimum intimidation if specified
      if (minIntimidation !== undefined && (item.intimidation || 0) < minIntimidation) {
        return false;
      }

      return true;
    });

    if (suitable.length === 0) {
      return null;
    }

    // Return the one with highest damage + intimidation score
    suitable.sort((a, b) => {
      const scoreA = (a.damage || 0) + (a.intimidation || 0);
      const scoreB = (b.damage || 0) + (b.intimidation || 0);
      return scoreB - scoreA;
    });

    return suitable[0];
  }
}

export const weaponService = new WeaponService();
