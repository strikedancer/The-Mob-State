import prisma from '../lib/prisma';
import { randomBytes } from 'crypto';
import { worldEventService } from './worldEventService';
import * as casinoOwnershipService from './casinoOwnershipService';
import { AppError } from '../utils/errors';

/**
 * Casino Service
 * Implements server-side RNG for slot machines, blackjack, and roulette
 * All bets go to casino bankroll, all payouts come from casino bankroll
 */

// Slot machine symbols and multipliers
const SLOT_SYMBOLS = ['🍒', '🍋', '🍊', '🍇', '💎', '🔔', '7️⃣'] as const;
const SLOT_MULTIPLIERS: Record<string, number> = {
  '🍒': 2,
  '🍋': 3,
  '🍊': 4,
  '🍇': 5,
  '💎': 10,
  '🔔': 20,
  '7️⃣': 100,
};

// Roulette numbers (European roulette: 0-36)
const ROULETTE_NUMBERS = Array.from({ length: 37 }, (_, i) => i);
const RED_NUMBERS = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];

/**
 * Generate crypto-secure random number
 * @param max - Maximum value (exclusive)
 * @returns Random integer from 0 to max-1
 */
function secureRandom(max: number): number {
  const bytes = randomBytes(4);
  const value = bytes.readUInt32BE(0);
  const result = value % max;
  console.log(`[RNG] max=${max}, value=${value}, result=${result}`);
  return result;
}

/**
 * Generate crypto-secure random seed for logging
 * @returns Hex string seed
 */
function generateSeed(): string {
  return randomBytes(16).toString('hex');
}

function formatCasinoName(countryId: string): string {
  return `Casino ${countryId
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (match) => match.toUpperCase())}`;
}

async function ensureCasinoProperty(casinoId: string) {
  let casino = await prisma.property.findUnique({
    where: { propertyId: casinoId },
    select: { playerId: true, propertyType: true, countryId: true },
  });

  if (!casino) {
    const countryId = casinoId.replace(/^casino_/, '');
    await prisma.property.create({
      data: {
        propertyId: casinoId,
        propertyType: 'casino',
        countryId,
        purchasePrice: 0,
      },
    });

    casino = await prisma.property.findUnique({
      where: { propertyId: casinoId },
      select: { playerId: true, propertyType: true, countryId: true },
    });
  }

  return casino;
}

/**
 * Play slot machine
 * @param playerId - Player ID
 * @param casinoId - Casino property ID (e.g., "casino_netherlands")
 * @param betAmount - Bet amount
 * @returns Game result with payout and casino bankrupt status
 */
export async function playSlots(
  playerId: number,
  casinoId: string,
  betAmount: number
): Promise<{
  result: [string, string, string];
  won: boolean;
  payout: number;
  profit: number;
  newBalance: number;
  casinoBankrupt: boolean;
}> {
  // Verify casino exists
  const casino = await ensureCasinoProperty(casinoId);

  if (!casino) {
    throw new Error('CASINO_NOT_FOUND');
  }

  if (casino.propertyType !== 'casino') {
    throw new Error('NOT_A_CASINO');
  }

  // Get casino ownership and bankroll
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId: casinoId },
    select: { bankroll: true, ownerId: true },
  });

  if (!ownership) {
    throw new AppError('NO_OWNER', 'Casino heeft geen eigenaar');
  }

  // Get player balance
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < betAmount) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  if (betAmount < 10) {
    throw new Error('MIN_BET_10');
  }

  // Generate slot results (crypto-secure RNG)
  const reel1 = SLOT_SYMBOLS[secureRandom(SLOT_SYMBOLS.length)];
  const reel2 = SLOT_SYMBOLS[secureRandom(SLOT_SYMBOLS.length)];
  const reel3 = SLOT_SYMBOLS[secureRandom(SLOT_SYMBOLS.length)];
  const result: [string, string, string] = [reel1, reel2, reel3];

  // Check for win (all 3 symbols match)
  const won = reel1 === reel2 && reel2 === reel3;
  const payout = won ? betAmount * SLOT_MULTIPLIERS[reel1] : 0;
  const seed = generateSeed();

  // Check if casino can cover potential payout
  if (won && ownership.bankroll < payout) {
    throw new AppError('INSUFFICIENT_BANKROLL', 'Casino kas te laag voor deze uitbetaling');
  }

  // Execute transaction
  let casinoBankrupt = false;
  await prisma.$transaction(async (tx) => {
    // Deduct bet from player
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: betAmount } },
    });

    // Add bet to casino bankroll
    await tx.casinoOwnership.update({
      where: { casinoId: casinoId },
      data: {
        bankroll: { increment: betAmount },
        totalReceived: { increment: betAmount },
      },
    });

    // Pay out winnings if player won
    if (won) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: payout } },
      });

      // Deduct payout from casino bankroll
      await tx.casinoOwnership.update({
        where: { casinoId: casinoId },
        data: {
          bankroll: { decrement: payout },
          totalPaidOut: { increment: payout },
        },
      });
    }

    // Log transaction
    await tx.casinoTransaction.create({
      data: {
        playerId,
        casinoId,
        ownerId: ownership.ownerId,
        gameType: 'slots',
        betAmount,
        payout,
        ownerCut: 0, // No longer used with bankroll system
        result: { reels: result },
        rngSeed: seed,
      },
    });
  });

  // Check for bankruptcy
  casinoBankrupt = await casinoOwnershipService.checkBankruptcy(casino.countryId);

  // Check for low balance and notify owner
  await casinoOwnershipService.checkLowBalance(casino.countryId);

  // Calculate new balance
  const newBalance = player.money - betAmount + (won ? payout : 0);

  // Broadcast world event for big wins (100x+ multiplier)
  if (won && SLOT_MULTIPLIERS[reel1] >= 100) {
    await worldEventService.createEvent('casino.bigwin', {
      playerId,
      game: 'slots',
      betAmount,
      payout,
      multiplier: SLOT_MULTIPLIERS[reel1],
    }, playerId);
  }

  const profit = payout - betAmount;

  return {
    result,
    won,
    payout,
    profit,
    newBalance,
    casinoBankrupt,
  };
}

/**
 * Play blackjack (simplified: player vs dealer, hit/stand only)
 * @param playerId - Player ID
 * @param casinoId - Casino property ID
 * @param betAmount - Bet amount
 * @param action - 'hit' or 'stand'
 * @param playerHand - Current player hand (for continuation)
 * @param dealerHand - Current dealer hand (for continuation)
 * @returns Game result
 */
export async function playBlackjack(
  playerId: number,
  casinoId: string,
  betAmount: number,
  action: 'start' | 'hit' | 'stand',
  playerHand?: number[],
  dealerHand?: number[]
): Promise<{
  playerHand: number[];
  dealerHand: number[];
  playerTotal: number;
  dealerTotal: number;
  gameOver: boolean;
  result?: 'win' | 'lose' | 'push';
  payout: number;
  profit: number;
  newBalance?: number;
  casinoBankrupt?: boolean;
}> {
  // Verify casino exists
  const casino = await ensureCasinoProperty(casinoId);

  if (!casino) {
    throw new Error('CASINO_NOT_FOUND');
  }

  if (casino.propertyType !== 'casino') {
    throw new Error('NOT_A_CASINO');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Start new game
  if (action === 'start') {
    if (player.money < betAmount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    if (betAmount < 10) {
      throw new Error('MIN_BET_10');
    }

    // Deal initial cards (2 to player, 2 to dealer)
    playerHand = [drawCard(), drawCard()];
    dealerHand = [drawCard(), drawCard()];

    const playerTotal = calculateBlackjackTotal(playerHand);
    let dealerTotal = calculateBlackjackTotal(dealerHand);

    // Check for natural blackjack
    if (playerTotal === 21) {
      // Player wins automatically
      return await finalizeBlackjack(
        playerId,
        casinoId,
        betAmount,
        playerHand,
        dealerHand,
        'win',
        player.money
      );
    }

    // Auto-play: dealer draws to 17+
    while (dealerTotal < 17) {
      dealerHand.push(drawCard());
      dealerTotal = calculateBlackjackTotal(dealerHand);
    }

    // Determine winner
    let result: 'win' | 'lose' | 'push';
    if (dealerTotal > 21) {
      result = 'win'; // Dealer busts
    } else if (playerTotal > dealerTotal) {
      result = 'win';
    } else if (playerTotal < dealerTotal) {
      result = 'lose';
    } else {
      result = 'push'; // Tie
    }

    return await finalizeBlackjack(
      playerId,
      casinoId,
      betAmount,
      playerHand,
      dealerHand,
      result,
      player.money
    );
  }

  // Continue existing game
  if (!playerHand || !dealerHand) {
    throw new Error('INVALID_GAME_STATE');
  }

  if (action === 'hit') {
    // Player draws a card
    playerHand.push(drawCard());
    const playerTotal = calculateBlackjackTotal(playerHand);

    // Check if player busts
    if (playerTotal > 21) {
      return await finalizeBlackjack(
        playerId,
        casinoId,
        betAmount,
        playerHand,
        dealerHand,
        'lose',
        player.money
      );
    }

    return {
      playerHand,
      dealerHand,
      playerTotal,
      dealerTotal: calculateBlackjackTotal(dealerHand),
      gameOver: false,
      payout: 0,
      profit: 0,
    };
  }

  if (action === 'stand') {
    // Dealer plays (hits on <17)
    let dealerTotal = calculateBlackjackTotal(dealerHand);
    while (dealerTotal < 17) {
      dealerHand.push(drawCard());
      dealerTotal = calculateBlackjackTotal(dealerHand);
    }

    const playerTotal = calculateBlackjackTotal(playerHand);

    // Determine winner
    let result: 'win' | 'lose' | 'push';
    if (dealerTotal > 21) {
      result = 'win'; // Dealer busts
    } else if (playerTotal > dealerTotal) {
      result = 'win';
    } else if (playerTotal < dealerTotal) {
      result = 'lose';
    } else {
      result = 'push'; // Tie
    }

    return await finalizeBlackjack(
      playerId,
      casinoId,
      betAmount,
      playerHand,
      dealerHand,
      result,
      player.money
    );
  }

  throw new Error('INVALID_ACTION');
}

/**
 * Finalize blackjack game and process payments using casino bankroll
 */
async function finalizeBlackjack(
  playerId: number,
  casinoId: string,
  betAmount: number,
  playerHand: number[],
  dealerHand: number[],
  result: 'win' | 'lose' | 'push',
  playerMoney: number
): Promise<{
  playerHand: number[];
  dealerHand: number[];
  playerTotal: number;
  dealerTotal: number;
  gameOver: boolean;
  result: 'win' | 'lose' | 'push';
  payout: number;
  profit: number;
  newBalance: number;
  casinoBankrupt: boolean;
}> {
  const payout = result === 'win' ? betAmount * 2 : result === 'push' ? betAmount : 0;
  const seed = generateSeed();

  // Get casino ownership
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true, bankroll: true },
  });

  if (!ownership) {
    throw new AppError('NO_OWNER', 'Casino heeft geen eigenaar');
  }

  // Check if casino can cover payout
  if (payout > 0 && ownership.bankroll < payout) {
    throw new AppError('INSUFFICIENT_BANKROLL', 'Casino kas te laag voor deze uitbetaling');
  }

  // Execute transaction
  await prisma.$transaction(async (tx) => {
    // Deduct bet from player
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: betAmount } },
    });

    // Add bet to casino bankroll
    await tx.casinoOwnership.update({
      where: { casinoId },
      data: {
        bankroll: { increment: betAmount },
        totalReceived: { increment: betAmount },
      },
    });

    // Pay out winnings if player won or push
    if (payout > 0) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: payout } },
      });

      // Deduct payout from casino bankroll
      await tx.casinoOwnership.update({
        where: { casinoId },
        data: {
          bankroll: { decrement: payout },
          totalPaidOut: { increment: payout },
        },
      });
    }

    // Log transaction
    await tx.casinoTransaction.create({
      data: {
        playerId,
        casinoId,
        ownerId: ownership.ownerId,
        gameType: 'blackjack',
        betAmount,
        payout,
        ownerCut: 0,
        result: { playerHand, dealerHand, result },
        rngSeed: seed,
      },
    });
  });

  // Check for bankruptcy
  const casinoBankrupt = await casinoOwnershipService.checkBankruptcy(casinoId);

  // Check for low balance and notify owner
  await casinoOwnershipService.checkLowBalance(casinoId);

  const newBalance = playerMoney - betAmount + payout;
  const profit = payout - betAmount;

  return {
    playerHand,
    dealerHand,
    playerTotal: calculateBlackjackTotal(playerHand),
    dealerTotal: calculateBlackjackTotal(dealerHand),
    gameOver: true,
    result,
    payout,
    profit,
    newBalance,
    casinoBankrupt,
  };
}

/**
 * Draw a random card (1-11, J/Q/K = 10)
 */
function drawCard(): number {
  const card = secureRandom(13) + 1;
  return card > 10 ? 10 : card;
}

/**
 * Calculate blackjack hand total (aces = 1 or 11)
 */
function calculateBlackjackTotal(hand: number[]): number {
  let total = hand.reduce((sum, card) => sum + card, 0);
  let aces = hand.filter((card) => card === 1).length;

  // Convert aces from 1 to 11 if it doesn't bust
  while (aces > 0 && total + 10 <= 21) {
    total += 10;
    aces--;
  }

  return total;
}

/**
 * Play roulette
 * @param playerId - Player ID
 * @param casinoId - Casino property ID
 * @param betAmount - Bet amount
 * @param betType - Type of bet ('number', 'red', 'black', 'even', 'odd', '1-18', '19-36')
 * @param betValue - Value for number bet (0-36)
 * @returns Game result
 */
export async function playRoulette(
  playerId: number,
  casinoId: string,
  betAmount: number,
  betType: 'number' | 'red' | 'black' | 'even' | 'odd' | '1-18' | '19-36',
  betValue?: number
): Promise<{
  number: number;
  color: 'red' | 'black' | 'green';
  won: boolean;
  payout: number;
  profit: number;
  newBalance: number;
  casinoBankrupt: boolean;
}> {
  // Verify casino
  const casino = await ensureCasinoProperty(casinoId);

  if (!casino) {
    throw new Error('CASINO_NOT_FOUND');
  }

  if (casino.propertyType !== 'casino') {
    throw new Error('NOT_A_CASINO');
  }

  // Get casino ownership
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId: casinoId },
    select: { bankroll: true, ownerId: true },
  });

  if (!ownership) {
    throw new AppError('NO_OWNER', 'Casino heeft geen eigenaar');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < betAmount) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  if (betAmount < 10) {
    throw new Error('MIN_BET_10');
  }

  if (betType === 'number' && (betValue === undefined || betValue < 0 || betValue > 36)) {
    throw new Error('INVALID_NUMBER');
  }

  // Spin the wheel (crypto-secure RNG)
  console.log('[ROULETTE DEBUG] About to spin wheel...');
  const randomIndex = secureRandom(ROULETTE_NUMBERS.length);
  console.log(`[ROULETTE DEBUG] randomIndex=${randomIndex}, ROULETTE_NUMBERS.length=${ROULETTE_NUMBERS.length}`);
  const number = ROULETTE_NUMBERS[randomIndex];
  console.log(`[ROULETTE DEBUG] number=${number}`);
  const color = number === 0 ? 'green' : RED_NUMBERS.includes(number) ? 'red' : 'black';

  // Check if bet won
  let won = false;
  let multiplier = 0;

  switch (betType) {
    case 'number':
      won = number === betValue;
      multiplier = 35; // 35:1 payout
      break;
    case 'red':
      won = color === 'red';
      multiplier = 1; // 1:1 payout
      break;
    case 'black':
      won = color === 'black';
      multiplier = 1;
      break;
    case 'even':
      won = number !== 0 && number % 2 === 0;
      multiplier = 1;
      break;
    case 'odd':
      won = number !== 0 && number % 2 === 1;
      multiplier = 1;
      break;
    case '1-18':
      won = number >= 1 && number <= 18;
      multiplier = 1;
      break;
    case '19-36':
      won = number >= 19 && number <= 36;
      multiplier = 1;
      break;
  }

  const payout = won ? betAmount * (multiplier + 1) : 0;
  const seed = generateSeed();

  // Check if casino can cover payout
  if (won && ownership.bankroll < payout) {
    throw new AppError('INSUFFICIENT_BANKROLL', 'Casino kas te laag voor deze uitbetaling');
  }

  // Execute transaction
  let casinoBankrupt = false;
  await prisma.$transaction(async (tx) => {
    // Deduct bet from player
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: betAmount } },
    });

    // Add bet to casino bankroll
    await tx.casinoOwnership.update({
      where: { casinoId: casinoId },
      data: {
        bankroll: { increment: betAmount },
        totalReceived: { increment: betAmount },
      },
    });

    // Add payout to player if won
    if (won) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: payout } },
      });

      // Deduct payout from casino bankroll
      await tx.casinoOwnership.update({
        where: { casinoId: casinoId },
        data: {
          bankroll: { decrement: payout },
          totalPaidOut: { increment: payout },
        },
      });
    }

    // Log transaction
    await tx.casinoTransaction.create({
      data: {
        playerId,
        casinoId,
        ownerId: ownership.ownerId,
        gameType: 'roulette',
        betAmount,
        payout,
        ownerCut: 0,
        result: { number, color, betType, betValue, won },
        rngSeed: seed,
      },
    });
  });

  // Check for bankruptcy
  casinoBankrupt = await casinoOwnershipService.checkBankruptcy(casino.countryId);

  // Check for low balance and notify owner
  await casinoOwnershipService.checkLowBalance(casino.countryId);

  const newBalance = player.money - betAmount + payout;
  const profit = payout - betAmount;

  // Broadcast world event for straight number wins
  if (won && betType === 'number') {
    await worldEventService.createEvent('casino.roulette.straightwin', {
      playerId,
      number,
      betAmount,
      payout,
    }, playerId);
  }

  return {
    number,
    color,
    won,
    payout,
    profit,
    newBalance,
    casinoBankrupt,
  };
}

/**
 * Play dice game using casino bankroll
 * @param playerId - Player ID
 * @param casinoId - Casino property ID
 * @param betAmount - Bet amount
 * @param prediction - Prediction type: 'high' (8-12), 'low' (2-6), or specific number (2-12)
 * @returns Game result with dice values and payout
 */
export async function playDice(
  playerId: number,
  casinoId: string,
  betAmount: number,
  prediction: 'high' | 'low' | number
): Promise<{
  dice1: number;
  dice2: number;
  total: number;
  won: boolean;
  payout: number;
  profit: number;
  newBalance: number;
  casinoBankrupt: boolean;
}> {
  // Verify casino
  const casino = await ensureCasinoProperty(casinoId);

  if (!casino) {
    throw new Error('CASINO_NOT_FOUND');
  }

  if (casino.propertyType !== 'casino') {
    throw new Error('NOT_A_CASINO');
  }

  // Get casino ownership
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId: casinoId },
    select: { bankroll: true, ownerId: true },
  });

  if (!ownership) {
    throw new AppError('NO_OWNER', 'Casino heeft geen eigenaar');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  if (player.money < betAmount) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  if (betAmount < 10) {
    throw new Error('MIN_BET_10');
  }

  // Roll dice (crypto-secure RNG)
  console.log('[DICE DEBUG] About to roll dice...');
  const dice1 = secureRandom(6) + 1;
  console.log(`[DICE DEBUG] dice1=${dice1}`);
  const dice2 = secureRandom(6) + 1;
  console.log(`[DICE DEBUG] dice2=${dice2}`);
  const total = dice1 + dice2;

  // Check if bet won
  let won = false;
  let multiplier = 0;

  console.log(`[DICE DEBUG] prediction=${prediction} (type: ${typeof prediction}), total=${total}`);

  if (prediction === 'high' && total >= 8) {
    won = true;
    multiplier = 1; // 2x total (1:1)
    console.log('[DICE DEBUG] Won with HIGH');
  } else if (prediction === 'low' && total <= 6) {
    won = true;
    multiplier = 1; // 2x total (1:1)
    console.log('[DICE DEBUG] Won with LOW');
  } else if (typeof prediction === 'number' && prediction === total) {
    won = true;
    multiplier = 5; // 6x total (5:1)
    console.log('[DICE DEBUG] Won with EXACT number');
  } else {
    console.log('[DICE DEBUG] LOST - no condition matched');
  }

  const payout = won ? betAmount * (multiplier + 1) : 0;
  const seed = generateSeed();

  // Check if casino can cover payout
  if (won && ownership.bankroll < payout) {
    throw new AppError('INSUFFICIENT_BANKROLL', 'Casino kas te laag voor deze uitbetaling');
  }

  // Execute transaction
  let casinoBankrupt = false;
  await prisma.$transaction(async (tx) => {
    // Deduct bet from player
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: betAmount } },
    });

    // Add bet to casino bankroll
    await tx.casinoOwnership.update({
      where: { casinoId: casinoId },
      data: {
        bankroll: { increment: betAmount },
        totalReceived: { increment: betAmount },
      },
    });

    // Pay out winnings if player won
    if (won) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: payout } },
      });

      // Deduct payout from casino bankroll
      await tx.casinoOwnership.update({
        where: { casinoId: casinoId },
        data: {
          bankroll: { decrement: payout },
          totalPaidOut: { increment: payout },
        },
      });
    }

    // Log transaction
    await tx.casinoTransaction.create({
      data: {
        playerId,
        casinoId,
        ownerId: ownership.ownerId,
        gameType: 'dice',
        betAmount,
        payout,
        ownerCut: 0,
        result: { dice1, dice2, total, prediction, won },
        rngSeed: seed,
      },
    });
  });

  // Check for bankruptcy
  casinoBankrupt = await casinoOwnershipService.checkBankruptcy(casino.countryId);

  // Check for low balance and notify owner
  await casinoOwnershipService.checkLowBalance(casino.countryId);

  const newBalance = player.money - betAmount + payout;
  const profit = payout - betAmount;

  return {
    dice1,
    dice2,
    total,
    won,
    payout,
    profit,
    newBalance,
    casinoBankrupt,
  };
}

/**
 * Get casino transaction history
 * @param casinoId - Casino property ID
 * @param limit - Number of transactions to retrieve
 * @returns Recent casino transactions
 */
export async function getCasinoHistory(
  casinoId: string,
  limit: number = 20
): Promise<Array<{
  id: number;
  playerId: number;
  gameType: string;
  betAmount: number;
  payout: number;
  createdAt: Date;
}>> {
  const transactions = await prisma.casinoTransaction.findMany({
    where: { casinoId },
    orderBy: { createdAt: 'desc' },
    take: limit,
    select: {
      id: true,
      playerId: true,
      gameType: true,
      betAmount: true,
      payout: true,
      createdAt: true,
    },
  });

  return transactions;
}
