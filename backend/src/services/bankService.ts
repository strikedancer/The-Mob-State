/**
 * Bank Service - Phase 8.1
 *
 * Handles bank account operations:
 * - Deposits and withdrawals
 * - Balance checks
 * - Interest calculation
 * - Account creation
 */

import prisma from '../lib/prisma';

export interface BankAccountInfo {
  id: number;
  playerId: number;
  balance: number;
  interestRate: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface DepositResult {
  success: boolean;
  newBalance: number;
  newCash: number;
  amount: number;
}

export interface WithdrawResult {
  success: boolean;
  newBalance: number;
  newCash: number;
  amount: number;
}

export interface TransferResult {
  success: boolean;
  amount: number;
  senderNewBalance: number;
  recipientNewBalance: number;
  recipientPlayerId: number;
  recipientUsername: string;
}

export interface BankTransactionItem {
  id: number;
  type: 'deposit' | 'withdraw' | 'transfer_sent' | 'transfer_received';
  amount: number;
  createdAt: Date;
}

export interface BankTransactionPage {
  transactions: BankTransactionItem[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface RecentRecipient {
  username: string;
  playerId: number | null;
  isFriend: boolean;
}

/**
 * Get or create bank account for player
 */
export async function getOrCreateBankAccount(playerId: number): Promise<BankAccountInfo> {
  // Try to find existing account
  let account = await prisma.bankAccount.findUnique({
    where: { playerId },
  });

  // Create if doesn't exist
  if (!account) {
    account = await prisma.bankAccount.create({
      data: {
        playerId,
        balance: 0,
        interestRate: 0,
      },
    });
  }

  return account;
}

/**
 * Get bank account balance
 */
export async function getBalance(playerId: number): Promise<number> {
  const account = await getOrCreateBankAccount(playerId);
  return account.balance;
}

/**
 * Deposit money into bank account
 */
export async function deposit(playerId: number, amount: number): Promise<DepositResult> {
  // Validate amount
  if (amount <= 0) {
    throw new Error('INVALID_AMOUNT');
  }

  if (!Number.isInteger(amount)) {
    throw new Error('INVALID_AMOUNT');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if player has enough cash
  if (player.money < amount) {
    throw new Error('INSUFFICIENT_CASH');
  }

  // Get or create bank account
  const account = await getOrCreateBankAccount(playerId);

  // Perform transaction
  const [updatedPlayer, updatedAccount] = await prisma.$transaction([
    // Deduct from player cash
    prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money - amount,
      },
    }),
    // Add to bank account
    prisma.bankAccount.update({
      where: { id: account.id },
      data: {
        balance: account.balance + amount,
      },
    }),
  ]);

  return {
    success: true,
    newBalance: updatedAccount.balance,
    newCash: updatedPlayer.money,
    amount,
  };
}

/**
 * Withdraw money from bank account
 */
export async function withdraw(playerId: number, amount: number): Promise<WithdrawResult> {
  // Validate amount
  if (amount <= 0) {
    throw new Error('INVALID_AMOUNT');
  }

  if (!Number.isInteger(amount)) {
    throw new Error('INVALID_AMOUNT');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Get bank account
  const account = await getOrCreateBankAccount(playerId);

  // Check if account has enough balance
  if (account.balance < amount) {
    throw new Error('INSUFFICIENT_BALANCE');
  }

  // Perform transaction
  const [updatedPlayer, updatedAccount] = await prisma.$transaction([
    // Add to player cash
    prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money + amount,
      },
    }),
    // Deduct from bank account
    prisma.bankAccount.update({
      where: { id: account.id },
      data: {
        balance: account.balance - amount,
      },
    }),
  ]);

  return {
    success: true,
    newBalance: updatedAccount.balance,
    newCash: updatedPlayer.money,
    amount,
  };
}

/**
 * Transfer money from sender bank account to recipient bank account by username
 */
export async function transferToPlayer(
  senderPlayerId: number,
  recipientUsername: string,
  amount: number
): Promise<TransferResult> {
  if (!recipientUsername || recipientUsername.trim().length < 2) {
    throw new Error('INVALID_RECIPIENT');
  }

  if (amount <= 0 || !Number.isInteger(amount)) {
    throw new Error('INVALID_AMOUNT');
  }

  const sender = await prisma.player.findUnique({
    where: { id: senderPlayerId },
    select: { id: true, username: true },
  });

  if (!sender) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const recipient = await prisma.player.findUnique({
    where: { username: recipientUsername.trim() },
    select: { id: true, username: true },
  });

  if (!recipient) {
    throw new Error('RECIPIENT_NOT_FOUND');
  }

  if (recipient.id == senderPlayerId) {
    throw new Error('CANNOT_TRANSFER_TO_SELF');
  }

  const result = await prisma.$transaction(async (tx) => {
    let senderAccount = await tx.bankAccount.findUnique({
      where: { playerId: senderPlayerId },
    });

    if (!senderAccount) {
      senderAccount = await tx.bankAccount.create({
        data: {
          playerId: senderPlayerId,
          balance: 0,
          interestRate: 0,
        },
      });
    }

    if (senderAccount.balance < amount) {
      throw new Error('INSUFFICIENT_BALANCE');
    }

    const recipientAccount = await tx.bankAccount.upsert({
      where: { playerId: recipient.id },
      update: {},
      create: {
        playerId: recipient.id,
        balance: 0,
        interestRate: 0,
      },
    });

    const updatedSenderAccount = await tx.bankAccount.update({
      where: { id: senderAccount.id },
      data: {
        balance: senderAccount.balance - amount,
      },
    });

    const updatedRecipientAccount = await tx.bankAccount.update({
      where: { id: recipientAccount.id },
      data: {
        balance: recipientAccount.balance + amount,
      },
    });

    return {
      updatedSenderAccount,
      updatedRecipientAccount,
    };
  });

  return {
    success: true,
    amount,
    senderNewBalance: result.updatedSenderAccount.balance,
    recipientNewBalance: result.updatedRecipientAccount.balance,
    recipientPlayerId: recipient.id,
    recipientUsername: recipient.username,
  };
}

/**
 * Calculate and apply interest to a bank account
 * Called by tick service
 */
export async function applyInterest(playerId: number): Promise<number> {
  // Interest is disabled for the bank system.
  // Keep function for backward compatibility with existing callers.
  void playerId;
  return 0;
}

/**
 * Apply interest to all bank accounts (called by tick service)
 */
export async function applyInterestToAll(): Promise<{
  accountsProcessed: number;
  totalInterestPaid: number;
}> {
  return {
    accountsProcessed: 0,
    totalInterestPaid: 0,
  };
}

/**
 * Get detailed account info
 */
export async function getAccountInfo(playerId: number): Promise<BankAccountInfo> {
  return await getOrCreateBankAccount(playerId);
}

/**
 * Get paginated bank transactions for player
 */
export async function getTransactions(
  playerId: number,
  page = 1,
  limit = 20
): Promise<BankTransactionPage> {
  const safePage = Number.isInteger(page) && page > 0 ? page : 1;
  const safeLimit = Number.isInteger(limit) && limit > 0 ? Math.min(limit, 100) : 20;
  const skip = (safePage - 1) * safeLimit;

  const whereClause = {
    playerId,
    eventKey: {
      in: ['bank.deposit', 'bank.withdraw', 'bank.transfer_sent', 'bank.transfer_received'],
    },
  };

  const [total, events] = await prisma.$transaction([
    prisma.worldEvent.count({ where: whereClause }),
    prisma.worldEvent.findMany({
      where: whereClause,
      orderBy: {
        createdAt: 'desc',
      },
      skip,
      take: safeLimit,
      select: {
        id: true,
        eventKey: true,
        params: true,
        createdAt: true,
      },
    }),
  ]);

  const transactions: BankTransactionItem[] = events.map((event) => {
    const params = (event.params as Record<string, unknown>) || {};
    const amountValue = params.amount;
    const amount =
      typeof amountValue === 'number'
        ? Math.floor(amountValue)
        : typeof amountValue === 'string'
          ? parseInt(amountValue, 10) || 0
          : 0;

    return {
      id: event.id,
      type:
        event.eventKey === 'bank.deposit'
          ? 'deposit'
          : event.eventKey === 'bank.withdraw'
            ? 'withdraw'
            : event.eventKey === 'bank.transfer_sent'
              ? 'transfer_sent'
              : 'transfer_received',
      amount,
      createdAt: event.createdAt,
    };
  });

  const totalPages = Math.max(1, Math.ceil(total / safeLimit));

  return {
    transactions,
    total,
    page: safePage,
    limit: safeLimit,
    totalPages,
  };
}

/**
 * Get recent unique transfer recipients for quick reuse in UI
 */
export async function getRecentRecipients(
  playerId: number,
  limit = 8
): Promise<RecentRecipient[]> {
  const safeLimit = Number.isInteger(limit) && limit > 0 ? Math.min(limit, 20) : 8;

  const events = await prisma.worldEvent.findMany({
    where: {
      playerId,
      eventKey: 'bank.transfer_sent',
    },
    orderBy: {
      createdAt: 'desc',
    },
    take: 100,
    select: {
      params: true,
    },
  });

  const seen = new Set<string>();
  const recipients: RecentRecipient[] = [];

  for (const event of events) {
    const params = (event.params as Record<string, unknown>) || {};
    const username = (params.recipientUsername as string | undefined)?.trim();
    if (!username) continue;

    const lowered = username.toLowerCase();
    if (seen.has(lowered)) continue;

    seen.add(lowered);
    recipients.push({
      username,
      playerId:
        typeof params.recipientPlayerId === 'number'
          ? params.recipientPlayerId
          : typeof params.recipientPlayerId === 'string'
            ? parseInt(params.recipientPlayerId, 10) || null
            : null,
      isFriend: false,
    });

    if (recipients.length >= safeLimit) break;
  }

  const recipientIds = recipients
    .map((recipient) => recipient.playerId)
    .filter((id): id is number => id !== null);

  if (recipientIds.length > 0) {
    const friendships = await prisma.friendship.findMany({
      where: {
        status: 'accepted',
        OR: [
          {
            requesterId: playerId,
            addresseeId: { in: recipientIds },
          },
          {
            requesterId: { in: recipientIds },
            addresseeId: playerId,
          },
        ],
      },
      select: {
        requesterId: true,
        addresseeId: true,
      },
    });

    const friendIds = new Set<number>();

    for (const friendship of friendships) {
      if (friendship.requesterId === playerId) {
        friendIds.add(friendship.addresseeId);
      } else {
        friendIds.add(friendship.requesterId);
      }
    }

    for (const recipient of recipients) {
      recipient.isFriend = recipient.playerId !== null && friendIds.has(recipient.playerId);
    }
  }

  return recipients;
}
