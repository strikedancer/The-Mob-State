import prisma from '../lib/prisma';

interface FoodItem {
  name: string;
  effectValue: number;
  cost: number;
}

interface DrinkItem {
  name: string;
  effectValue: number;
  cost: number;
}

export const foodItems: FoodItem[] = [
  { name: 'Broodje', effectValue: 20, cost: 50 },
  { name: 'Pizza', effectValue: 40, cost: 150 },
  { name: 'Burger', effectValue: 50, cost: 200 },
  { name: 'Steak', effectValue: 80, cost: 500 },
];

export const drinkItems: DrinkItem[] = [
  { name: 'Water', effectValue: 30, cost: 20 },
  { name: 'Frisdrank', effectValue: 40, cost: 50 },
  { name: 'Koffie', effectValue: 35, cost: 75 },
  { name: 'Bier', effectValue: 50, cost: 100 },
];

const NEEDS_TICK_MS = 5 * 60 * 1000;
const HUNGER_PER_TICK = 2;
const THIRST_PER_TICK = 3;
const MAX_CATCHUP_TICKS = 12;
const NEEDS_FLOOR = 5;

function clampNeeds(value: number): number {
  return Math.max(NEEDS_FLOOR, Math.min(100, value));
}

export async function applyNeedsTick(
  playerId: number
): Promise<{ hunger: number; thirst: number }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { hunger: true, thirst: true, lastTickAt: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const now = new Date();
  if (!player.lastTickAt) {
    await prisma.player.update({
      where: { id: playerId },
      data: { lastTickAt: now },
    });
    return {
      hunger: clampNeeds(player.hunger),
      thirst: clampNeeds(player.thirst),
    };
  }

  const ticks = Math.min(
    MAX_CATCHUP_TICKS,
    Math.floor((now.getTime() - player.lastTickAt.getTime()) / NEEDS_TICK_MS)
  );
  if (ticks <= 0) {
    return { hunger: player.hunger, thirst: player.thirst };
  }

  const hunger = clampNeeds(player.hunger - ticks * HUNGER_PER_TICK);
  const thirst = clampNeeds(player.thirst - ticks * THIRST_PER_TICK);

  await prisma.player.update({
    where: { id: playerId },
    data: { hunger, thirst, lastTickAt: now },
  });

  return { hunger, thirst };
}

export async function buyFood(
  playerId: number,
  itemName: string
): Promise<{ newMoney: number; hunger: number; thirst: number; restored: number }> {
  const item = foodItems.find((f) => f.name === itemName);
  if (!item) {
    throw new Error('INVALID_ITEM');
  }

  const needs = await applyNeedsTick(playerId);
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, hunger: true, thirst: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < item.cost) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  const hunger = Math.min(100, (player.hunger ?? needs.hunger) + item.effectValue);
  const thirst = player.thirst ?? needs.thirst;
  const newMoney = player.money - item.cost;

  await prisma.player.update({
    where: { id: playerId },
    data: {
      money: newMoney,
      hunger,
    },
  });

  return { newMoney, hunger, thirst, restored: item.effectValue };
}

export async function buyDrink(
  playerId: number,
  itemName: string
): Promise<{ newMoney: number; hunger: number; thirst: number; restored: number }> {
  const item = drinkItems.find((d) => d.name === itemName);
  if (!item) {
    throw new Error('INVALID_ITEM');
  }

  const needs = await applyNeedsTick(playerId);
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, hunger: true, thirst: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < item.cost) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  const hunger = player.hunger ?? needs.hunger;
  const thirst = Math.min(100, (player.thirst ?? needs.thirst) + item.effectValue);
  const newMoney = player.money - item.cost;

  await prisma.player.update({
    where: { id: playerId },
    data: {
      money: newMoney,
      thirst,
    },
  });

  return { newMoney, hunger, thirst, restored: item.effectValue };
}

export async function getMenu(playerId?: number): Promise<{
  food: FoodItem[];
  drinks: DrinkItem[];
  hunger: number | null;
  thirst: number | null;
}> {
  let hunger: number | null = null;
  let thirst: number | null = null;
  if (playerId) {
    const needs = await applyNeedsTick(playerId);
    hunger = needs.hunger;
    thirst = needs.thirst;
  }

  return {
    food: foodItems,
    drinks: drinkItems,
    hunger,
    thirst,
  };
}
