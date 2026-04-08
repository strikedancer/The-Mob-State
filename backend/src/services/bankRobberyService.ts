/**
 * Bank Robbery Service - Phase 8.2
 *
 * When a bank heist succeeds, depositors lose money proportionally.
 * This simulates the impact of bank robberies on depositors.
 */

import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';

export interface BankRobberyResult {
  totalStolen: number;
  depositorCount: number;
  impactedDepositors: Array<{
    playerId: number;
    username: string;
    previousBalance: number;
    newBalance: number;
    lossAmount: number;
    lossPercentage: number;
  }>;
}

/**
 * Calculate total deposits across all bank accounts
 */
async function getTotalBankDeposits(): Promise<number> {
  const result = await prisma.bankAccount.aggregate({
    _sum: {
      balance: true,
    },
  });

  return result._sum.balance || 0;
}

/**
 * Get all depositors (accounts with positive balance)
 */
async function getDepositors() {
  return await prisma.bankAccount.findMany({
    where: {
      balance: {
        gt: 0,
      },
    },
    include: {
      player: {
        select: {
          username: true,
        },
      },
    },
  });
}

/**
 * Execute bank robbery impact on depositors
 *
 * When a bank heist succeeds, the stolen amount is distributed as losses
 * across all depositors proportionally to their account balance.
 *
 * @param stolenAmount - Amount stolen from the bank heist
 * @returns BankRobberyResult with details of impacted depositors
 */
export async function executeBankRobbery(stolenAmount: number): Promise<BankRobberyResult> {
  // Get total deposits and all depositors
  const totalDeposits = await getTotalBankDeposits();
  const depositors = await getDepositors();

  // If no deposits, no impact
  if (totalDeposits === 0 || depositors.length === 0) {
    return {
      totalStolen: stolenAmount,
      depositorCount: 0,
      impactedDepositors: [],
    };
  }

  // Calculate what percentage of total deposits was stolen
  // Cap at 100% to prevent over-stealing
  const stolenPercentage = Math.min(stolenAmount / totalDeposits, 1.0);

  const impactedDepositors: BankRobberyResult['impactedDepositors'] = [];

  // Process each depositor
  for (const depositor of depositors) {
    const previousBalance = depositor.balance;

    // Calculate proportional loss for this depositor
    const lossAmount = Math.floor(previousBalance * stolenPercentage);

    // Cap loss at account balance (can't go negative)
    const actualLoss = Math.min(lossAmount, previousBalance);
    const newBalance = previousBalance - actualLoss;

    // Update account balance
    await prisma.bankAccount.update({
      where: { id: depositor.id },
      data: {
        balance: newBalance,
      },
    });

    // Record impact
    impactedDepositors.push({
      playerId: depositor.playerId,
      username: depositor.player.username,
      previousBalance,
      newBalance,
      lossAmount: actualLoss,
      lossPercentage: previousBalance > 0 ? (actualLoss / previousBalance) * 100 : 0,
    });

    // Create individual world event for affected player
    await worldEventService.createEvent(
      'bank.depositor_loss',
      {
        playerId: depositor.playerId,
        previousBalance,
        newBalance,
        lossAmount: actualLoss,
        lossPercentage: (actualLoss / previousBalance) * 100,
      },
      depositor.playerId
    );
  }

  // Create public world event about bank robbery
  await worldEventService.createEvent('bank.robbery_occurred', {
    totalStolen: stolenAmount,
    depositorCount: depositors.length,
    totalDeposits,
    stolenPercentage: stolenPercentage * 100,
  });

  return {
    totalStolen: stolenAmount,
    depositorCount: depositors.length,
    impactedDepositors,
  };
}

/**
 * Get bank robbery statistics
 */
export async function getBankRobberyStats(): Promise<{
  totalDeposits: number;
  depositorCount: number;
  averageBalance: number;
}> {
  const totalDeposits = await getTotalBankDeposits();
  const depositors = await getDepositors();

  return {
    totalDeposits,
    depositorCount: depositors.length,
    averageBalance: depositors.length > 0 ? Math.floor(totalDeposits / depositors.length) : 0,
  };
}
