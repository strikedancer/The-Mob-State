/**
 * Trade Service - Phase 9.2
 *
 * Handles buying and selling contraband between countries.
 * Prices vary by country based on trade bonuses.
 */

import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { playerService } from './playerService';
import { gameEventService } from './gameEventService';
import { scoreTradeSellContribution } from './gameEventTradeContribution';
import tradableGoods from '../../content/tradableGoods.json';
import countries from '../../content/countries.json';
import { getPlayerCountry } from './travelService';

export interface TradableGood {
  id: string;
  name: string;
  description: string;
  basePrice: number;
  maxInventory: number;
  weight: number;
  spoilageHours?: number;
  damageChancePerTrip?: number;
  confiscationChance?: number;
  priceVolatility?: number;
  /** Countries where this good can be purchased (sell remains allowed everywhere). */
  availableInCountries?: string[];
  /** UI grouping: starter | bulk | luxury | dangerous */
  category?: string;
  /** Sort hint: 1 (entry) .. 4 (endgame) */
  tier?: number;
}

export interface TradeResult {
  success: boolean;
  goodType: string;
  goodName: string;
  quantity: number;
  pricePerUnit: number;
  totalCost: number;
  newBalance: number;
  newQuantity: number;
  xpGained?: number;
  realizedProfit?: number;
}

/** Small XP from selling contraband: volume + profit, capped so crimes stay primary. */
export function calculateTradeSellXp(totalEarnings: number, realizedProfit: number): number {
  const volumeXp = Math.floor(Math.max(0, totalEarnings) / 400);
  const profitXp = Math.floor(Math.max(0, realizedProfit) / 200);
  return Math.min(30, Math.max(1, volumeXp + profitXp));
}

/**
 * Get all tradable goods
 */
export function getAllGoods(): TradableGood[] {
  return tradableGoods as TradableGood[];
}

/**
 * Get good by ID
 */
export function getGoodById(goodType: string): TradableGood | undefined {
  return tradableGoods.find((g) => g.id === goodType) as TradableGood | undefined;
}

/**
 * Validate if good exists
 */
export function isValidGood(goodType: string): boolean {
  return tradableGoods.some((g) => g.id === goodType);
}

/**
 * Whether a good can be purchased in the given country.
 * Legacy goods without `availableInCountries` remain buyable everywhere.
 */
export function isGoodAvailableInCountry(goodType: string, countryId: string): boolean {
  const good = getGoodById(goodType);
  if (!good) {
    return false;
  }
  const sources = good.availableInCountries;
  if (!sources?.length) {
    return true;
  }
  return sources.includes(countryId);
}

/** Country-specific trade bonus multiplier (no volatility). */
export function getTradeBonus(goodType: string, countryId: string): number {
  const country = countries.find((c) => c.id === countryId);
  if (!country) {
    return 1.0;
  }
  return (country as any).tradeBonuses?.[goodType] || 1.0;
}

/**
 * Calculate price for a good in a specific country with volatility
 */
export function calculatePrice(goodType: string, countryId: string): number {
  const good = getGoodById(goodType);
  if (!good) {
    return 0;
  }

  const country = countries.find((c) => c.id === countryId);
  if (!country) {
    return good.basePrice;
  }

  // Apply country-specific trade bonus
  const tradeBonus = (country as any).tradeBonuses?.[goodType] || 1.0;
  let price = good.basePrice * tradeBonus;

  // Apply price volatility (random fluctuation based on good type)
  if (good.priceVolatility && good.priceVolatility > 0) {
    const volatilityRange = good.priceVolatility; // e.g., 0.25 = ±25%
    const randomFactor = 1 + (Math.random() * 2 - 1) * volatilityRange;
    price = price * randomFactor;
  }

  return Math.floor(price);
}

/**
 * Get player's inventory for a specific good
 */
export async function getInventoryItem(playerId: number, goodType: string): Promise<number> {
  const item = await prisma.inventory.findUnique({
    where: {
      playerId_goodType: {
        playerId,
        goodType,
      },
    },
  });

  return item?.quantity || 0;
}

/**
 * Get player's full inventory with spoilage/damage checks
 */
export async function getFullInventory(playerId: number) {
  const inventory = await prisma.inventory.findMany({
    where: { playerId },
  });

  const now = new Date();

  // Map to include good details and check for spoilage/damage
  return inventory.map((item) => {
    const good = getGoodById(item.goodType);
    let quantity = item.quantity;
    let condition = item.condition || 100;
    let spoiled = false;

    // Check if flowers are spoiled
    if (good?.spoilageHours && item.purchasedAt) {
      const hoursSincePurchase = (now.getTime() - new Date(item.purchasedAt).getTime()) / (1000 * 60 * 60);
      if (hoursSincePurchase > good.spoilageHours) {
        spoiled = true;
        quantity = 0; // Flowers are worthless when spoiled
      }
    }

    return {
      id: item.id,
      goodType: item.goodType,
      goodName: good?.name || item.goodType,
      name: good?.name || item.goodType,
      quantity,
      purchasePrice: item.purchasePrice || 0,
      basePrice: good?.basePrice || 0,
      condition,
      spoiled,
      purchasedAt: item.purchasedAt,
    };
  });
}

/**
 * Buy goods in current country
 */
export async function buyGoods(
  playerId: number,
  goodType: string,
  quantity: number
): Promise<TradeResult> {
  // Validate inputs
  if (quantity <= 0 || !Number.isInteger(quantity)) {
    throw new Error('INVALID_QUANTITY');
  }

  if (!isValidGood(goodType)) {
    throw new Error('INVALID_GOOD_TYPE');
  }

  const good = getGoodById(goodType);
  if (!good) {
    throw new Error('GOOD_NOT_FOUND');
  }

  // Get player's current country
  const currentCountry = await getPlayerCountry(playerId);

  if (!isGoodAvailableInCountry(goodType, currentCountry)) {
    throw new Error('GOOD_NOT_AVAILABLE_IN_COUNTRY');
  }

  // Calculate price in current country
  const pricePerUnit = calculatePrice(goodType, currentCountry);
  const totalCost = pricePerUnit * quantity;

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if player has enough money
  if (player.money < totalCost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Check inventory limits
  const currentQuantity = await getInventoryItem(playerId, goodType);
  const newQuantity = currentQuantity + quantity;

  if (newQuantity > good.maxInventory) {
    throw new Error('INVENTORY_FULL');
  }

  // Get existing inventory to calculate weighted average purchase price
  const existingInventory = await prisma.inventory.findUnique({
    where: {
      playerId_goodType: {
        playerId,
        goodType,
      },
    },
  });

  // Calculate weighted average purchase price
  const oldValue = (existingInventory?.purchasePrice || 0) * currentQuantity;
  const newValue = pricePerUnit * quantity;
  const averagePurchasePrice = Math.floor((oldValue + newValue) / newQuantity);

  // Execute transaction
  const [updatedPlayer, updatedInventory] = await prisma.$transaction([
    // Deduct money
    prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - totalCost },
    }),
    // Update inventory
    prisma.inventory.upsert({
      where: {
        playerId_goodType: {
          playerId,
          goodType,
        },
      },
      create: {
        playerId,
        goodType,
        quantity,
        purchasePrice: pricePerUnit,
      },
      update: {
        quantity: newQuantity,
        purchasePrice: averagePurchasePrice,
      },
    }),
  ]);

  // Create world event
  await worldEventService.createEvent(
    'trade.bought',
    {
      playerId,
      goodType,
      goodName: good.name,
      quantity,
      pricePerUnit,
      totalCost,
      country: currentCountry,
    },
    playerId
  );

  return {
    success: true,
    goodType,
    goodName: good.name,
    quantity,
    pricePerUnit,
    totalCost,
    newBalance: updatedPlayer.money,
    newQuantity: updatedInventory.quantity,
  };
}

/**
 * Sell goods in current country
 */
export async function sellGoods(
  playerId: number,
  goodType: string,
  quantity: number
): Promise<TradeResult> {
  // Validate inputs
  if (quantity <= 0 || !Number.isInteger(quantity)) {
    throw new Error('INVALID_QUANTITY');
  }

  if (!isValidGood(goodType)) {
    throw new Error('INVALID_GOOD_TYPE');
  }

  const good = getGoodById(goodType);
  if (!good) {
    throw new Error('GOOD_NOT_FOUND');
  }

  // Check if player has enough in inventory
  const inventoryItem = await prisma.inventory.findUnique({
    where: {
      playerId_goodType: {
        playerId,
        goodType,
      },
    },
  });

  if (!inventoryItem || inventoryItem.quantity < quantity) {
    throw new Error('INSUFFICIENT_INVENTORY');
  }

  // Check for spoilage (flowers)
  if (good.spoilageHours && inventoryItem.purchasedAt) {
    const now = new Date();
    const hoursSincePurchase = (now.getTime() - new Date(inventoryItem.purchasedAt).getTime()) / (1000 * 60 * 60);
    if (hoursSincePurchase > good.spoilageHours) {
      throw new Error('GOODS_SPOILED');
    }
  }

  // Get player's current country
  const currentCountry = await getPlayerCountry(playerId);

  // Calculate price in current country
  // Sell price is 90% of buy price (10% spread)
  const buyPrice = calculatePrice(goodType, currentCountry);
  let pricePerUnit = Math.floor(buyPrice * 0.9);

  // Apply condition damage (electronics)
  const condition = inventoryItem.condition || 100;
  if (condition < 100) {
    pricePerUnit = Math.floor(pricePerUnit * (condition / 100));
  }

  const totalEarnings = pricePerUnit * quantity;
  const unitCost = inventoryItem.purchasePrice || 0;
  const realizedProfit = (pricePerUnit - unitCost) * quantity;
  const xpGained = calculateTradeSellXp(totalEarnings, realizedProfit);

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const newQuantity = inventoryItem.quantity - quantity;

  // Execute transaction
  const [updatedPlayer] = await prisma.$transaction([
    // Add money
    prisma.player.update({
      where: { id: playerId },
      data: { money: player.money + totalEarnings },
    }),
    // Update inventory (or delete if 0)
    newQuantity === 0
      ? prisma.inventory.delete({
          where: {
            playerId_goodType: {
              playerId,
              goodType,
            },
          },
        })
      : prisma.inventory.update({
          where: {
            playerId_goodType: {
              playerId,
              goodType,
            },
          },
          data: {
            quantity: newQuantity,
          },
        }),
  ]);

  let awardedXp = 0;
  try {
    const xpResult = await playerService.gainXP(playerId, xpGained);
    awardedXp = xpResult.xpGained;
  } catch (err) {
    console.error('[TradeService] Failed to award sell XP:', err);
  }

  // Create world event
  await worldEventService.createEvent(
    'trade.sold',
    {
      playerId,
      goodType,
      goodName: good.name,
      quantity,
      pricePerUnit,
      totalEarnings,
      realizedProfit,
      xpGained: awardedXp,
      country: currentCountry,
    },
    playerId
  );

  const tradeEventPoints = scoreTradeSellContribution(realizedProfit, totalEarnings);
  if (tradeEventPoints > 0) {
    void gameEventService
      .recordContribution(playerId, 'trade', tradeEventPoints)
      .catch(() => {});
  }

  return {
    success: true,
    goodType,
    goodName: good.name,
    quantity,
    pricePerUnit,
    totalCost: totalEarnings,
    newBalance: updatedPlayer.money,
    newQuantity,
    xpGained: awardedXp,
    realizedProfit,
  };
}

/**
 * Get current prices for all goods in player's country
 */
export async function getCurrentPrices(playerId: number) {
  const currentCountry = await getPlayerCountry(playerId);

  return tradableGoods.map((good) => {
    const multiplier = getTradeBonus(good.id, currentCountry);
    const availableToBuy = isGoodAvailableInCountry(good.id, currentCountry);
    const buyPrice = calculatePrice(good.id, currentCountry);
    const sellPrice = Math.floor(buyPrice * 0.9); // 10% spread
    
    return {
      goodType: good.id,
      goodName: good.name,
      basePrice: good.basePrice,
      currentPrice: buyPrice,
      sellPrice,
      multiplier,
      maxInventory: good.maxInventory,
      availableToBuy,
      sourceCountries: good.availableInCountries ?? [],
      category: good.category ?? 'luxury',
      tier: good.tier ?? 2,
    };
  });
}
