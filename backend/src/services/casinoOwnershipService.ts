import prisma from '../lib/prisma';
import { AppError } from '../utils/errors';
import { NotificationService } from './notificationService';
import { emailService } from './emailService';
import { translationService } from './translationService';
import { educationService } from './educationService';
import {
  CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS,
  CASINO_HOUSE_RUNTIME_SETTING_KEYS,
  ensureCasinoStaffCatalog,
  getCasinoHouseRules,
  effectiveRaidDrainPct,
  invalidateCasinoHouseConfigCache,
  type CasinoStaffRole,
} from './casinoHouseConfig';

export {
  CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS,
  CASINO_HOUSE_RUNTIME_SETTING_KEYS,
  invalidateCasinoHouseConfigCache,
};

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
        playerId,
        propertyId: casinoId,
        propertyType: 'casino',
        countryId: normalizedCountryId,
        purchasePrice: price,
      },
      update: {
        playerId,
        countryId: normalizedCountryId,
        purchasePrice: price,
      }
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
      purchasedAt: true,
      lastRaidAt: true,
    }
  });

  if (!ownership) {
    throw new AppError('NOT_FOUND', 'Casino not owned');
  }

  const house = await getCasinoHouseRules(casinoId);
  const netProfit = ownership.totalReceived - ownership.totalPaidOut;
  const profitMargin = ownership.totalReceived > 0 
    ? (netProfit / ownership.totalReceived) * 100 
    : 0;

  const rakeTotal = await prisma.casinoTransaction.aggregate({
    where: { casinoId },
    _sum: { ownerCut: true },
  });

  return {
    bankroll: ownership.bankroll,
    totalReceived: ownership.totalReceived,
    totalPaidOut: ownership.totalPaidOut,
    totalRake: rakeTotal._sum.ownerCut ?? 0,
    netProfit,
    profitMargin: profitMargin.toFixed(2),
    purchasePrice: ownership.purchasePrice,
    purchasedAt: ownership.purchasedAt,
    lastRaidAt: ownership.lastRaidAt,
    isBankrupt: ownership.bankroll < MIN_BANKROLL,
    floorLevel: house?.floorLevel ?? 1,
    maxBet: house?.maxBet ?? 500,
    rakeBps: house?.rakeBps ?? 200,
    raidDrainPct: house ? Number(effectiveRaidDrainPct(house).toFixed(1)) : 18,
    raidDefenseBps: house?.raidDefenseBps ?? 0,
    raidDefensePct: house
      ? Number(((house.raidDefenseBps / 10000) * 100).toFixed(1))
      : 0,
    nextFloorCost: house?.nextFloorCost ?? null,
    staff: house?.staff ?? [],
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
    await prisma.$transaction(async (tx) => {
      await tx.casinoOwnership.delete({
        where: { casinoId },
      });
      await tx.property.updateMany({
        where: { propertyId: casinoId, propertyType: 'casino' },
        data: { playerId: null },
      });
    });
    return true;
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

export async function getHouseSnapshot(countryId: string) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  await ensureCasinoStaffCatalog();
  return getCasinoHouseRules(casinoId);
}

export async function upgradeCasinoFloor(playerId: number, countryId: string) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true, floorLevel: true },
  });
  if (!ownership || ownership.ownerId !== playerId) {
    throw new AppError('UNAUTHORIZED', 'You do not own this casino');
  }
  if (ownership.floorLevel >= 3) {
    throw new AppError('MAX_FLOOR', 'Casino is already private floor');
  }

  const rules = await getCasinoHouseRules(casinoId);
  const cost = rules?.nextFloorCost ?? 0;
  if (cost <= 0) {
    throw new AppError('MAX_FLOOR', 'Casino is already private floor');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });
  if (!player || player.money < cost) {
    throw new AppError('INSUFFICIENT_FUNDS', `You need €${cost.toLocaleString()} to upgrade`);
  }

  await prisma.$transaction(async (tx) => {
    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: cost } },
    });
    await tx.casinoOwnership.update({
      where: { casinoId },
      data: { floorLevel: { increment: 1 } },
    });
  });

  return getCasinoStats(countryId);
}

export async function listStaffCatalog() {
  await ensureCasinoStaffCatalog();
  return prisma.casinoStaffCatalog.findMany({
    where: { isActive: true },
    orderBy: [{ role: 'asc' }, { skillLevel: 'asc' }],
  });
}

export async function hireStaff(playerId: number, countryId: string, catalogId: number) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true },
  });
  if (!ownership || ownership.ownerId !== playerId) {
    throw new AppError('UNAUTHORIZED', 'You do not own this casino');
  }

  await ensureCasinoStaffCatalog();
  const catalog = await prisma.casinoStaffCatalog.findUnique({
    where: { id: catalogId },
  });
  if (!catalog || !catalog.isActive) {
    throw new AppError('STAFF_NOT_FOUND', 'Staff member not available');
  }

  const existing = await prisma.casinoStaffHire.findUnique({
    where: { casinoId_role: { casinoId, role: catalog.role } },
  });
  if (existing) {
    throw new AppError('ROLE_FILLED', `This casino already has a ${catalog.role}`);
  }

  await prisma.casinoStaffHire.create({
    data: {
      casinoId,
      role: catalog.role,
      catalogId: catalog.id,
    },
  });

  return getCasinoStats(countryId);
}

export async function fireStaff(playerId: number, countryId: string, role: CasinoStaffRole) {
  const normalizedCountryId = countryId.toLowerCase();
  const casinoId = `casino_${normalizedCountryId}`;
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true },
  });
  if (!ownership || ownership.ownerId !== playerId) {
    throw new AppError('UNAUTHORIZED', 'You do not own this casino');
  }

  const deleted = await prisma.casinoStaffHire.deleteMany({
    where: { casinoId, role },
  });
  if (deleted.count === 0) {
    throw new AppError('STAFF_NOT_HIRED', 'No staff in that role');
  }
  return getCasinoStats(countryId);
}

export async function payCasinoStaffSalaries(): Promise<{
  casinos: number;
  paid: number;
  fired: number;
}> {
  await ensureCasinoStaffCatalog();
  const ownerships = await prisma.casinoOwnership.findMany({
    include: {
      staffHires: { include: { catalog: true } },
    },
  });

  let paid = 0;
  let fired = 0;
  for (const ownership of ownerships) {
    if (ownership.staffHires.length === 0) continue;
    const salary = ownership.staffHires.reduce(
      (sum, hire) => sum + hire.catalog.salaryPerTick,
      0,
    );
    const countryId = ownership.casinoId.replace(/^casino_/, '');
    if (ownership.bankroll - salary >= MIN_BANKROLL) {
      await prisma.casinoOwnership.update({
        where: { casinoId: ownership.casinoId },
        data: { bankroll: { decrement: salary } },
      });
      paid += salary;
    } else {
      const cheapest = [...ownership.staffHires].sort(
        (a, b) => a.catalog.salaryPerTick - b.catalog.salaryPerTick,
      )[0];
      if (cheapest) {
        await prisma.casinoStaffHire.delete({ where: { id: cheapest.id } });
        fired += 1;
      }
      await checkLowBalance(countryId);
    }
  }
  return { casinos: ownerships.length, paid, fired };
}

export async function applyCasinoLedgerRaid(params: {
  countryId: string;
  crewId: number;
}): Promise<{ drained: number; casinoId: string; ownerId: number } | null> {
  const countryId = (params.countryId || '').toLowerCase();
  if (!countryId) return null;
  const casinoId = `casino_${countryId}`;
  const ownership = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true, bankroll: true },
  });
  if (!ownership) return null;

  const ownerCrew = await prisma.crewMember.findFirst({
    where: { playerId: ownership.ownerId, crewId: params.crewId },
    select: { id: true },
  });
  if (ownerCrew) {
    return null;
  }

  const rules = await getCasinoHouseRules(casinoId);
  if (!rules) return null;
  const drainPct = effectiveRaidDrainPct(rules);
  const drained = Math.min(
    ownership.bankroll - MIN_BANKROLL,
    Math.floor(ownership.bankroll * (drainPct / 100)),
  );
  if (drained <= 0) return null;

  await prisma.casinoOwnership.update({
    where: { casinoId },
    data: {
      bankroll: { decrement: drained },
      lastRaidAt: new Date(),
    },
  });

  const owner = await prisma.player.findUnique({
    where: { id: ownership.ownerId },
    select: { id: true, preferredLanguage: true },
  });
  if (owner) {
    const language = translationService.getPlayerLanguage(owner);
    const casinoName = `Casino ${countryId}`;
    const title =
      language === 'nl' ? 'Casino ledger-raid' : 'Casino ledger raid';
    const body =
      language === 'nl'
        ? `${casinoName}: €${drained.toLocaleString()} is van de bankroll gehaald.`
        : `${casinoName}: €${drained.toLocaleString()} was taken from the bankroll.`;
    try {
      await NotificationService.getInstance().sendToPlayer(owner.id, title, body, {
        type: 'casino_ledger_raid',
        countryId,
        drained: String(drained),
      });
    } catch (error) {
      console.error('[CasinoOwnership] raid notify failed', error);
    }
  }

  await checkLowBalance(countryId);
  await checkBankruptcy(countryId);
  return { drained, casinoId, ownerId: ownership.ownerId };
}

export async function getRuntimeConfigView() {
  const keys = CASINO_HOUSE_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma
    .$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    )
    .catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const values: Record<string, string> = { ...CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS };
  for (const row of rows) {
    values[row.configKey] = String(row.configValue ?? values[row.configKey] ?? '');
  }
  return {
    defaults: CASINO_HOUSE_RUNTIME_SETTING_DEFAULTS,
    values,
    keys,
  };
}

export async function updateRuntimeConfig(updates: Record<string, string | number>) {
  const normalized: Record<string, string> = {};
  for (const [key, value] of Object.entries(updates)) {
    if (!CASINO_HOUSE_RUNTIME_SETTING_KEYS.includes(key)) {
      throw new Error(`INVALID_RUNTIME_KEY:${key}`);
    }
    const asString = String(value ?? '').trim();
    const asNumber = Number(asString);
    if (!Number.isFinite(asNumber)) {
      throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
    }
    normalized[key] = asString;
  }

  for (const [key, value] of Object.entries(normalized)) {
    await prisma.$executeRawUnsafe(
      `
        INSERT INTO runtime_config (configKey, configValue)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)
      `,
      key,
      value,
    );
  }
  invalidateCasinoHouseConfigCache();
  return getRuntimeConfigView();
}

