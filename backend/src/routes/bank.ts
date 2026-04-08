/**
 * Bank Routes - Phase 8.1
 *
 * Endpoints:
 * - POST /bank/deposit - Deposit money into bank
 * - POST /bank/withdraw - Withdraw money from bank
 * - POST /bank/transfer - Transfer bank money to another player
 * - GET /bank/balance - Get bank account balance
 * - GET /bank/account - Get full account info
 * - GET /bank/transactions - Get paginated bank transactions
 * - GET /bank/recent-recipients - Get recent transfer recipients
 */

import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as bankService from '../services/bankService';
import { worldEventService } from '../services/worldEventService';

const router = Router();

/**
 * POST /bank/deposit
 * Deposit money into bank account
 */
router.post('/deposit', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    const { amount } = req.body;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    if (!amount || typeof amount !== 'number') {
      return res.status(400).json({
        event: 'error.invalid_amount',
        params: {},
      });
    }

    const result = await bankService.deposit(playerId, amount);

    // Create world event
    await worldEventService.createEvent('bank.deposit', {
      playerId,
      amount,
      newBalance: result.newBalance,
    }, playerId);

    return res.json({
      event: 'bank.deposit_success',
      params: {
        amount: result.amount,
        bankBalance: result.newBalance,
        cashRemaining: result.newCash,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_AMOUNT') {
        return res.status(400).json({
          event: 'error.invalid_amount',
          params: {},
        });
      }

      if (error.message === 'INSUFFICIENT_CASH') {
        return res.status(400).json({
          event: 'error.insufficient_cash',
          params: {},
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /bank/withdraw
 * Withdraw money from bank account
 */
router.post('/withdraw', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    const { amount } = req.body;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    if (!amount || typeof amount !== 'number') {
      return res.status(400).json({
        event: 'error.invalid_amount',
        params: {},
      });
    }

    const result = await bankService.withdraw(playerId, amount);

    // Create world event
    await worldEventService.createEvent('bank.withdraw', {
      playerId,
      amount,
      newBalance: result.newBalance,
    }, playerId);

    return res.json({
      event: 'bank.withdraw_success',
      params: {
        amount: result.amount,
        bankBalance: result.newBalance,
        cashReceived: result.newCash,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_AMOUNT') {
        return res.status(400).json({
          event: 'error.invalid_amount',
          params: {},
        });
      }

      if (error.message === 'INSUFFICIENT_BALANCE') {
        return res.status(400).json({
          event: 'error.insufficient_balance',
          params: {},
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /bank/transfer
 * Transfer money from your bank account to another player's bank account
 */
router.post('/transfer', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const senderPlayerId = req.player?.id;
    const { recipientUsername, amount } = req.body;

    if (!senderPlayerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    if (!recipientUsername || typeof recipientUsername !== 'string') {
      return res.status(400).json({
        event: 'error.invalid_recipient',
        params: {},
      });
    }

    if (!amount || typeof amount !== 'number') {
      return res.status(400).json({
        event: 'error.invalid_amount',
        params: {},
      });
    }

    const result = await bankService.transferToPlayer(senderPlayerId, recipientUsername, amount);

    await worldEventService.createEvent(
      'bank.transfer_sent',
      {
        amount,
        recipientPlayerId: result.recipientPlayerId,
        recipientUsername: result.recipientUsername,
        newBalance: result.senderNewBalance,
      },
      senderPlayerId
    );

    await worldEventService.createEvent(
      'bank.transfer_received',
      {
        amount,
        senderPlayerId,
        senderUsername: req.player?.username,
        newBalance: result.recipientNewBalance,
      },
      result.recipientPlayerId
    );

    return res.json({
      event: 'bank.transfer_success',
      params: {
        amount: result.amount,
        recipientUsername: result.recipientUsername,
        bankBalance: result.senderNewBalance,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_RECIPIENT') {
        return res.status(400).json({
          event: 'error.invalid_recipient',
          params: {},
        });
      }

      if (error.message === 'RECIPIENT_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.recipient_not_found',
          params: {},
        });
      }

      if (error.message === 'CANNOT_TRANSFER_TO_SELF') {
        return res.status(400).json({
          event: 'error.cannot_transfer_to_self',
          params: {},
        });
      }

      if (error.message === 'INVALID_AMOUNT') {
        return res.status(400).json({
          event: 'error.invalid_amount',
          params: {},
        });
      }

      if (error.message === 'INSUFFICIENT_BALANCE') {
        return res.status(400).json({
          event: 'error.insufficient_balance',
          params: {},
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /bank/balance
 * Get current bank account balance
 */
router.get('/balance', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const balance = await bankService.getBalance(playerId);

    return res.json({
      event: 'bank.balance',
      params: {
        balance,
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /bank/account
 * Get full bank account information
 */
router.get('/account', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const account = await bankService.getAccountInfo(playerId);

    return res.json({
      event: 'bank.account_info',
      params: {
        id: account.id,
        balance: account.balance,
        interestRate: account.interestRate,
        dailyInterest: Math.floor(account.balance * account.interestRate),
        createdAt: account.createdAt,
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /bank/transactions
 * Get paginated bank transactions
 */
router.get('/transactions', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const pageParam = Number.parseInt(req.query.page as string, 10);
    const limitParam = Number.parseInt(req.query.limit as string, 10);
    const page = Number.isInteger(pageParam) && pageParam > 0 ? pageParam : 1;
    const limit = Number.isInteger(limitParam) && limitParam > 0 ? limitParam : 20;

    const result = await bankService.getTransactions(playerId, page, limit);

    return res.json({
      event: 'bank.transactions',
      params: {
        transactions: result.transactions,
        total: result.total,
        page: result.page,
        limit: result.limit,
        totalPages: result.totalPages,
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /bank/recent-recipients
 * Get recent unique recipients for quick transfer
 */
router.get('/recent-recipients', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const limitParam = Number.parseInt(req.query.limit as string, 10);
    const limit = Number.isInteger(limitParam) && limitParam > 0 ? limitParam : 8;
    const recipients = await bankService.getRecentRecipients(playerId, limit);

    return res.json({
      event: 'bank.recent_recipients',
      params: {
        recipients,
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
