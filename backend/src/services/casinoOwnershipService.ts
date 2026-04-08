import prisma from '../lib/prisma';
import { AppError } from '../utils/errors';
import { NotificationService } from './notificationService';
import { emailService } from './emailService';
import { translationService } from './translationService';
import { educationService } from './educationService';

/**
 * Casino pricing per country (based on travel costs and property values)
 * Initial deposit required: 20% of purchase price
 */
const CASINO_PRICES: { [key: string]: number } = {
  netherlands: 2000000,    // €2M - starting country
  belgium: 3000000,        // €3M
  germany: 4000000,        // €4M
  france: 5000000,         // €5M
  spain: 7000000,          // €7M
  italy: 8000000,          // €8M
  uk: 6000000,             // €6M
  switzerland: 10000000,   // €10M - most expensive (EU)
  usa: 12000000,           // €12M
  mexico: 7000000,         // €7M
  colombia: 6500000,       // €6.5M
  brazil: 8000000,         // €8M
  argentina: 7500000,      // €7.5M
  japan: 14000000,         // €14M
  china: 13000000,         // €13M
  russia: 9000000,         // €9M
  turkey: 7000000,         // €7M
  united_arab_emirates: 15000000, // €15M
  south_africa: 6000000,   // €6M
  australia: 13500000      // €13.5M
};

const INITIAL_DEPOSIT_PERCENT = 0.20; // 20% of purchase price required as initial bankroll
const MIN_BANKROLL = 10000; // Minimum €10K to keep casino operational
const LOW_BALANCE_THRESHOLD = 15000; // Warn owner when bankroll falls below €15K

/**
 * Get casino ownership for a specific country
 */
export async function getOwnershipByCountry(countryId: string) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    include: {
      owner: {
        select: {
          id: true,
          username: true,
          rank: true
        }
      }
    }
  });

  return ownership;
}

/**
 * Purchase a casino for a country
 * Requires purchase price + 20% initial deposit for bankroll
 */
export async function purchaseCasino(playerId: number, countryId: string, initialDeposit: number) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  const price = CASINO_PRICES[normalizedCountryId];

  if (!price) {
    throw new AppError('INVALID_COUNTRY', `Country ${countryId} not found`);
  }

  const minDeposit = Math.floor(price * INITIAL_DEPOSIT_PERCENT);
  if (initialDeposit < minDeposit) {
    throw new AppError('INSUFFICIENT_DEPOSIT', `Minimum deposit is €${minDeposit.toLocaleString()} (20% of purchase price)`);
  }

  // Check if casino already owned
  const existingOwnership = await getOwnershipByCountry(countryId);
  if (existingOwnership) {
    throw new AppError('ALREADY_OWNED', `Casino in ${countryId} is already owned by ${existingOwnership.owner.username}`);
  }

  // Check player has enough money for purchase + initial deposit
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, rank: true }
  });

  if (!player) {
    throw new AppError('PLAYER_NOT_FOUND', 'Player not found');
  }

  const educationEligibility = await educationService.checkAssetEligibility(
    playerId,
    'casino_purchase',
    player.rank
  );

  if (!educationEligibility.allowed) {
    throw new AppError(
      'EDUCATION_REQUIREMENTS_NOT_MET',
      JSON.stringify({
        reasonKey: 'casino.purchase.education_requirements_not_met',
        gateId: educationEligibility.gateId,
        gateLabelKey: educationEligibility.gateLabelKey,
        missing: educationEligibility.missing,
      })
    );
  }

  const totalCost = price + initialDeposit;
  if (player.money < totalCost) {
    throw new AppError('INSUFFICIENT_FUNDS', `You need €${totalCost.toLocaleString()} (€${price.toLocaleString()} purchase + €${initialDeposit.toLocaleString()} deposit)`);
  }

  // Create ownership and set initial bankroll
  const ownership = await prisma.$transaction(async (tx) => {
    // Deduct total cost from player
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: totalCost } }
    });

    // Ensure casino property exists
    await tx.property.upsert({
      where: { propertyId: casinoId },
      create: {
        propertyId: casinoId,
        propertyType: 'casino',
        countryId: normalizedCountryId,
        name: `Casino ${countryId}`,
        price: price,
        income: 0
      },
      update: {}
    });

    // Create ownership record with initial bankroll
    const newOwnership = await tx.casinoOwnership.create({
      data: {
        casinoId,
        ownerId: playerId,
        purchasePrice: price,
        bankroll: initialDeposit,
        totalReceived: 0,
        totalPaidOut: 0
      },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            rank: true,
            money: true
          }
        }
      }
    });

    return newOwnership;
  });

  return ownership;
}

/**
 * Get total revenue for a casino owner (DEPRECATED - use getCasinoStats instead)
 */
export async function getCasinoRevenue(ownerId: number) {
  // Sum all owner cuts from casino transactions
  const transactions = await prisma.casinoTransaction.findMany({
    where: { ownerId },
    select: {
      ownerCut: true
    }
  });

  const totalRevenue = transactions.reduce((sum, tx) => sum + tx.ownerCut, 0);
  return totalRevenue;
}

/**
 * Get casino statistics for owner
 */
export async function getCasinoStats(countryId: string) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: {
      bankroll: true,
      totalReceived: true,
      totalPaidOut: true,
      purchasePrice: true,
      purchasedAt: true
    }
  });

  if (!ownership) {
    throw new AppError('NOT_FOUND', 'Casino not owned');
  }

  const netProfit = ownership.totalReceived - ownership.totalPaidOut;
  const profitMargin = ownership.totalReceived > 0 
    ? (netProfit / ownership.totalReceived) * 100 
    : 0;

  return {
    bankroll: ownership.bankroll,
    totalReceived: ownership.totalReceived,
    totalPaidOut: ownership.totalPaidOut,
    netProfit,
    profitMargin: profitMargin.toFixed(2),
    purchasePrice: ownership.purchasePrice,
    purchasedAt: ownership.purchasedAt,
    isBankrupt: ownership.bankroll < MIN_BANKROLL
  };
}

/**
 * Deposit money into casino bankroll
 */
export async function depositToCasino(playerId: number, countryId: string, amount: number) {
  if (amount <= 0) {
    throw new AppError('INVALID_AMOUNT', 'Deposit amount must be positive');
  }

  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;

  // Check ownership
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true }
  });

  if (!ownership || ownership.ownerId !== playerId) {
    throw new AppError('UNAUTHORIZED', 'You do not own this casino');
  }

  // Check player has enough money
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true }
  });

  if (!player || player.money < amount) {
    throw new AppError('INSUFFICIENT_FUNDS', `You need €${amount.toLocaleString()} to deposit`);
  }

  // Transfer money
  await prisma.$transaction(async (tx) => {
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: amount } }
    });

    await tx.casinoOwnership.update({
      where: { casinoId },
      data: { bankroll: { increment: amount } }
    });
  });

  return await getCasinoStats(countryId);
}

/**
 * Withdraw money from casino bankroll
 */
export async function withdrawFromCasino(playerId: number, countryId: string, amount: number) {
  if (amount <= 0) {
    throw new AppError('INVALID_AMOUNT', 'Withdrawal amount must be positive');
  }

  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;

  // Check ownership and bankroll
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true, bankroll: true }
  });

  if (!ownership || ownership.ownerId !== playerId) {
    throw new AppError('UNAUTHORIZED', 'You do not own this casino');
  }

  if (ownership.bankroll < amount) {
    throw new AppError('INSUFFICIENT_FUNDS', `Casino only has €${ownership.bankroll.toLocaleString()} available`);
  }

  const remainingAfterWithdrawal = ownership.bankroll - amount;
  if (remainingAfterWithdrawal < MIN_BANKROLL) {
    throw new AppError('MIN_BANKROLL_REQUIRED', `Casino must maintain at least €${MIN_BANKROLL.toLocaleString()} bankroll`);
  }

  // Transfer money
  await prisma.$transaction(async (tx) => {
    await tx.player.update({
      where: { id: playerId },
      data: { money: { increment: amount } }
    });

    await tx.casinoOwnership.update({
      where: { casinoId },
      data: { bankroll: { decrement: amount } }
    });
  });

  return await getCasinoStats(countryId);
}

/**
 * Check if casino has gone bankrupt and handle liquidation
 */
export async function checkBankruptcy(countryId: string) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;

  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { bankroll: true, ownerId: true }
  });

  if (!ownership) return false;

  if (ownership.bankroll < MIN_BANKROLL) {
    // Casino is bankrupt - delete ownership
    await prisma.casinoOwnership.delete({
      where: { casinoId }
    });
    
    return true; // Bankrupt
  }

  return false;
}

/**
 * Check if casino balance is low and notify owner
 * Sends notifications when bankroll falls below threshold
 */
export async function checkLowBalance(countryId: string, previousBankroll?: number) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;

  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { 
      bankroll: true, 
      ownerId: true,
      lastLowBalanceNotification: true 
    }
  });

  if (!ownership) return;

  const currentBankroll = ownership.bankroll;

  // Only notify if:
  // 1. Current bankroll is below threshold
  // 2. Previous bankroll was above threshold (just crossed the threshold)
  // 3. Haven't sent notification in the last 24 hours
  const shouldNotify = 
    currentBankroll < LOW_BALANCE_THRESHOLD &&
    currentBankroll >= MIN_BANKROLL && // Not bankrupt yet
    (!ownership.lastLowBalanceNotification || 
      Date.now() - ownership.lastLowBalanceNotification.getTime() > 24 * 60 * 60 * 1000);

  if (!shouldNotify) return;

  // Get owner details
  const owner = await prisma.player.findUnique({
    where: { id: ownership.ownerId },
    select: { 
      id: true, 
      username: true, 
      email: true,
      emailVerified: true,
      preferredLanguage: true 
    }
  });

  if (!owner) return;

  const language = translationService.getPlayerLanguage(owner);
  const casinoName = `Casino ${countryId.charAt(0).toUpperCase() + countryId.slice(1)}`;

  try {
    // Send push notification
    const notificationService = NotificationService.getInstance();
    await notificationService.sendCasinoLowBalanceNotification(
      owner.id,
      casinoName,
      currentBankroll,
      MIN_BANKROLL,
      language
    );

    console.log(`[CasinoOwnership] Sent low balance push notification to ${owner.username} for ${casinoId}`);

    // Send email notification (only if email is verified)
    if (owner.email && owner.emailVerified) {
      await emailService.sendCasinoLowBalanceEmail(
        owner.email,
        owner.username,
        casinoName,
        currentBankroll,
        MIN_BANKROLL,
        language
      );

      console.log(`[CasinoOwnership] Sent low balance email to ${owner.email} for ${casinoId}`);
    }

    // Update last notification timestamp
    await prisma.casinoOwnership.update({
      where: { casinoId },
      data: { lastLowBalanceNotification: new Date() }
    });

  } catch (error) {
    console.error(`[CasinoOwnership] Error sending low balance notification for ${casinoId}:`, error);
    // Don't throw - notification failures should not block casino operations
  }
}

/**
 * Get all casinos owned by a player
 */
export async function getPlayerCasinos(playerId: number) {
  const ownerships = await prisma.casinoOwnership.findMany({
    where: { ownerId: playerId },
    orderBy: { purchasedAt: 'desc' }
  });

  return ownerships;
}

/**
 * Get casino price for a country
 */
export function getCasinoPrice(countryId: string): number {
  const price = CASINO_PRICES[countryId.toLowerCase()];
  if (!price) {
    console.warn(`[CasinoOwnership] No price found for country: ${countryId}, using default €5M`);
    return 5000000; // Default €5M
  }
  return price;
}

/**
 * Get all available casinos (not owned)
 */
export async function getAvailableCasinos() {
  const allCountries = Object.keys(CASINO_PRICES);
  const ownedCasinos = await prisma.casinoOwnership.findMany({
    select: { casinoId: true }
  });

  const ownedCasinoIds = new Set(ownedCasinos.map(o => o.casinoId));
  
  const available = allCountries
    .filter(country => !ownedCasinoIds.has(`casino_${country}`))
    .map(country => ({
      countryId: country,
      casinoId: `casino_${country}`,
      price: CASINO_PRICES[country]
    }));

  return available;
}
