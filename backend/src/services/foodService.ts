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

export async function buyFood(
  playerId: number,
  itemName: string
): Promise<{ newMoney: number }> {
  const item = foodItems.find((f) => f.name === itemName);
  if (!item) {
    throw new Error('INVALID_ITEM');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < item.cost) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  const newMoney = player.money - item.cost;

  await prisma.player.update({
    where: { id: playerId },
    data: {
      money: newMoney,
    },
  });

  return { newMoney };
}

export async function buyDrink(
  playerId: number,
  itemName: string
): Promise<{ newMoney: number }> {
  const item = drinkItems.find((d) => d.name === itemName);
  if (!item) {
    throw new Error('INVALID_ITEM');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < item.cost) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  const newMoney = player.money - item.cost;

  await prisma.player.update({
    where: { id: playerId },
    data: {
      money: newMoney,
    },
  });

  return { newMoney };
}

export async function getMenu(): Promise<{
  food: FoodItem[];
  drinks: DrinkItem[];
}> {
  return {
    food: foodItems,
    drinks: drinkItems,
  };
}
