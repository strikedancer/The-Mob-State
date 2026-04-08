import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';

interface AmmoDefinition {
  type: string;
  name: string;
  pricePerRound: number;
  boxSize: number;
  maxInventory: number;
}

interface AmmoData {
  ammo: AmmoDefinition[];
}

class AmmoService {
  private ammoTypes: AmmoDefinition[] = [];

  constructor() {
    this.loadAmmo();
  }

  private loadAmmo() {
    const ammoPath = join(__dirname, '../../content/ammo.json');
    const ammoData = readFileSync(ammoPath, 'utf-8');
    const data: AmmoData = JSON.parse(ammoData);
    this.ammoTypes = data.ammo;
  }

  /**
   * Get all ammo type definitions
   */
  getAllAmmoTypes(): AmmoDefinition[] {
    return this.ammoTypes;
  }

  /**
   * Get a specific ammo type definition
   */
  getAmmoDefinition(ammoType: string): AmmoDefinition | undefined {
    return this.ammoTypes.find((a) => a.type === ammoType);
  }

  /**
   * Get player's ammo inventory
   */
  async getPlayerAmmo(playerId: number) {
    const inventory = await prisma.ammoInventory.findMany({
      where: { playerId },
    });

    return inventory.map((item) => {
      const definition = this.getAmmoDefinition(item.ammoType);
      return {
        ...item,
        ...definition,
      };
    });
  }

  /**
   * Get ammo market stock for a country
   */
  async getMarketStock(countryId: string) {
    const stock = await prisma.ammoMarketStock.findMany({
      where: { countryId },
      orderBy: { ammoType: 'asc' },
    });

    return stock.map((item) => {
      const definition = this.getAmmoDefinition(item.ammoType);
      return {
        ...item,
        ...definition,
      };
    });
  }

  /**
   * Buy ammo boxes
   */
  async buyAmmo(
    playerId: number,
    ammoType: string,
    boxes: number,
    countryId: string
  ): Promise<{ success: boolean; error?: string; totalCost?: number; roundsPurchased?: number; quality?: number; nextAvailableAt?: string }> {
    const ammo = this.getAmmoDefinition(ammoType);

    if (!ammo) {
      return { success: false, error: 'AMMO_TYPE_NOT_FOUND' };
    }

    if (boxes < 1) {
      return { success: false, error: 'INVALID_QUANTITY' };
    }

    const roundsPurchased = boxes * ammo.boxSize;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, lastAmmoPurchaseAt: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Check ammo purchase cooldown (30 minutes)
    const AMMO_PURCHASE_COOLDOWN_MS = 30 * 60 * 1000;
    if (player.lastAmmoPurchaseAt) {
      const timeSinceLastPurchase = Date.now() - player.lastAmmoPurchaseAt.getTime();
      if (timeSinceLastPurchase < AMMO_PURCHASE_COOLDOWN_MS) {
        const nextAvailableAt = new Date(player.lastAmmoPurchaseAt.getTime() + AMMO_PURCHASE_COOLDOWN_MS);
        return {
          success: false,
          error: 'PURCHASE_COOLDOWN_ACTIVE',
          nextAvailableAt: nextAvailableAt.toISOString(),
        };
      }
    }

    const marketStock = await prisma.ammoMarketStock.findUnique({
      where: {
        countryId_ammoType: {
          countryId,
          ammoType,
        },
      },
    });

    if (!marketStock || marketStock.quantity < roundsPurchased) {
      return { success: false, error: 'INSUFFICIENT_STOCK' };
    }

    const quality = marketStock.quality || 1.0;
    const priceMultiplier = 1 + (quality - 1) * 0.5;
    const totalCost = Math.floor(roundsPurchased * ammo.pricePerRound * priceMultiplier);

    if (player.money < totalCost) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    // Check current inventory
    const existing = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    const currentQuantity = existing?.quantity || 0;
    const newQuantity = currentQuantity + roundsPurchased;

    if (newQuantity > ammo.maxInventory) {
      return { success: false, error: 'MAX_INVENTORY_REACHED' };
    }

    const newQuality = existing
      ? ((existing.quality * currentQuantity) + (quality * roundsPurchased)) / newQuantity
      : quality;

    // Update or create inventory
    if (existing) {
      await prisma.ammoInventory.update({
        where: { id: existing.id },
        data: { quantity: newQuantity, quality: newQuality },
      });
    } else {
      await prisma.ammoInventory.create({
        data: {
          playerId,
          ammoType,
          quantity: roundsPurchased,
          quality: newQuality,
        },
      });
    }

    await prisma.ammoMarketStock.update({
      where: { id: marketStock.id },
      data: { quantity: marketStock.quantity - roundsPurchased },
    });

    // Deduct money and set purchase cooldown
    await prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money - totalCost,
        lastAmmoPurchaseAt: new Date(),
      },
    });

    return { success: true, totalCost, roundsPurchased, quality: newQuality };
  }

  /**
   * Sell ammo
   */
  async sellAmmo(
    playerId: number,
    ammoType: string,
    quantity: number
  ): Promise<{ success: boolean; error?: string; sellPrice?: number }> {
    const ammo = this.getAmmoDefinition(ammoType);

    if (!ammo) {
      return { success: false, error: 'AMMO_TYPE_NOT_FOUND' };
    }

    if (quantity < 1) {
      return { success: false, error: 'INVALID_QUANTITY' };
    }

    const existing = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    if (!existing || existing.quantity < quantity) {
      return { success: false, error: 'INSUFFICIENT_AMMO' };
    }

    // Sell price is 50% of purchase price
    const sellPrice = Math.floor(quantity * ammo.pricePerRound * 0.5);

    // Update inventory
    const newQuantity = existing.quantity - quantity;
    if (newQuantity === 0) {
      await prisma.ammoInventory.delete({
        where: { id: existing.id },
      });
    } else {
      await prisma.ammoInventory.update({
        where: { id: existing.id },
        data: { quantity: newQuantity },
      });
    }

    // Add money
    await prisma.player.update({
      where: { id: playerId },
      data: { money: { increment: sellPrice } },
    });

    return { success: true, sellPrice };
  }

  /**
   * Consume ammo (for crimes)
   */
  async consumeAmmo(
    playerId: number,
    ammoType: string,
    quantity: number
  ): Promise<{ success: boolean; error?: string }> {
    console.log(`[AmmoService] consumeAmmo called - playerId: ${playerId}, ammoType: ${ammoType}, quantity: ${quantity}`);
    
    const existing = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    console.log(`[AmmoService] Current ammo: playerId: ${playerId}, ammoType: ${ammoType}, current quantity: ${existing?.quantity ?? 'NONE'}`);

    if (!existing || existing.quantity < quantity) {
      console.log(`[AmmoService] INSUFFICIENT_AMMO - needed: ${quantity}, have: ${existing?.quantity ?? 0}`);
      return { success: false, error: 'INSUFFICIENT_AMMO' };
    }

    const newQuantity = existing.quantity - quantity;
    console.log(`[AmmoService] Subtracting ${quantity} from ${existing.quantity} = ${newQuantity}`);
    
    if (newQuantity === 0) {
      console.log(`[AmmoService] Deleting ammo record as newQuantity is 0`);
      await prisma.ammoInventory.delete({
        where: { id: existing.id },
      });
    } else {
      console.log(`[AmmoService] Updating ammo to ${newQuantity}`);
      await prisma.ammoInventory.update({
        where: { id: existing.id },
        data: { quantity: newQuantity },
      });
    }

    return { success: true };
  }

  /**
   * Check if player has enough ammo
   */
  async hasAmmo(playerId: number, ammoType: string, required: number): Promise<boolean> {
    const existing = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    return existing ? existing.quantity >= required : false;
  }

  /**
   * Get ammo count for a specific type
   */
  async getAmmoCount(playerId: number, ammoType: string): Promise<number> {
    const existing = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    return existing?.quantity || 0;
  }
}

export const ammoService = new AmmoService();
