import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as casinoService from '../services/casinoService';
import * as casinoOwnershipService from '../services/casinoOwnershipService';
import prisma from '../lib/prisma';
import { AppError } from '../utils/errors';

const router = Router();

/**
 * GET /casino/games
 * Get list of available casino games
 */
router.get('/games', authenticate, async (_req: AuthRequest, res: Response) => {
  const games = [
    {
      id: 'slots',
      name: 'Gokautomaat',
      description: 'Draai de rollen en win tot 100x je inzet!',
      icon: '🎰',
      minBet: 10,
      maxBet: 10000,
      difficulty: 'easy'
    },
    {
      id: 'blackjack',
      name: 'Blackjack',
      description: 'Versla de dealer en win tot 2x je inzet!',
      icon: '🃏',
      minBet: 10,
      maxBet: 10000,
      difficulty: 'medium'
    },
    {
      id: 'roulette',
      name: 'Roulette',
      description: 'Kies je nummer en win tot 35x je inzet!',
      icon: '🎡',
      minBet: 10,
      maxBet: 10000,
      difficulty: 'medium'
    },
    {
      id: 'dice',
      name: 'Dobbelstenen',
      description: 'Gooi de dobbelstenen en win tot 6x je inzet!',
      icon: '🎲',
      minBet: 10,
      maxBet: 5000,
      difficulty: 'easy'
    }
  ];
  
  res.json({
    event: 'casino.games.list',
    params: { games }
  });
});

/**
 * POST /casino/slots/spin
 * Play slot machine (auto-detects casino from player's current country)
 */
router.post('/slots/spin', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { betAmount } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_AMOUNT' },
      });
    }

    // Get player's current country
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
      select: { currentCountry: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'casino.error',
        params: { reason: 'PLAYER_NOT_FOUND' },
      });
    }

    const casinoId = `casino_${player.currentCountry}`;

    const result = await casinoService.playSlots(req.player!.id, casinoId, betAmount);

    return res.status(200).json({
      event: result.won ? 'casino.slots.win' : 'casino.slots.lose',
      params: {
        result: result.result,
        won: result.won,
        payout: result.payout,
        betAmount,
        casinoBankrupt: result.casinoBankrupt,
      },
      player: {
        money: result.newBalance,
      },
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: error.message },
      });
    }

    if (error instanceof Error) {
      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'Minimum inzet is €10' },
        });
      }
    }

    console.error('Casino slots error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'Er is een fout opgetreden' },
    });
  }
});

/**
 * POST /casino/blackjack/play
 * Play blackjack (auto-detects casino via currentCountry)
 */
router.post('/blackjack/play', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { betAmount } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'Ongeldig inzetbedrag' },
      });
    }

    if (betAmount < 10) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'Minimum inzet is €10' },
      });
    }

    // Auto-detect casino via player's current country
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
      select: { currentCountry: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'casino.error',
        params: { reason: 'Speler niet gevonden' },
      });
    }

    const casinoId = `casino_${player.currentCountry}`;

    // Call bankroll-integrated blackjack service
    // Start new game (auto-plays to completion)
    const result = await casinoService.playBlackjack(
      req.player!.id,
      casinoId,
      betAmount,
      'start'
    );

    console.log('🃏 Blackjack result:', {
      playerHand: result.playerHand,
      dealerHand: result.dealerHand,
      playerTotal: result.playerTotal,
      dealerTotal: result.dealerTotal,
      result: result.result,
      payout: result.payout
    });

    const won = result.result === 'win';
    const profit = result.payout - betAmount;

    return res.status(200).json({
      event: won ? 'casino.blackjack.win' : 'casino.blackjack.lose',
      params: {
        playerHand: result.playerHand,
        dealerHand: result.dealerHand,
        playerCards: result.playerHand,
        dealerCards: result.dealerHand,
        playerTotal: result.playerTotal,
        dealerTotal: result.dealerTotal,
        won,
        payout: result.payout,
        profit,
        betAmount,
        newBalance: result.newBalance,
        casinoBankrupt: result.casinoBankrupt,
      },
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: error.message },
      });
    }
    console.error('Casino blackjack error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'Er is een fout opgetreden' },
    });
  }
});

/**
 * POST /casino/roulette/spin
 * Play roulette (auto-detects casino via currentCountry)
 */
router.post('/roulette/spin', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { betAmount, betType, betValue } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'Ongeldig inzetbedrag' },
      });
    }

    if (betAmount < 10) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'Minimum inzet is €10' },
      });
    }

    // Auto-detect casino via player's current country
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
      select: { currentCountry: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'casino.error',
        params: { reason: 'Speler niet gevonden' },
      });
    }

    const casinoId = `casino_${player.currentCountry}`;

    // Call bankroll-integrated roulette service
    const result = await casinoService.playRoulette(
      req.player!.id,
      casinoId,
      betAmount,
      betType,
      betValue
    );

    const profit = result.payout - betAmount;

    return res.status(200).json({
      event: result.won ? 'casino.roulette.win' : 'casino.roulette.lose',
      params: {
        result: result.number,
        isRed: result.color === 'red',
        isBlack: result.color === 'black',
        isEven: result.number !== 0 && result.number % 2 === 0,
        isOdd: result.number !== 0 && result.number % 2 === 1,
        won: result.won,
        payout: result.payout,
        profit,
        betAmount,
        betType,
        betValue,
        newBalance: result.newBalance,
        casinoBankrupt: result.casinoBankrupt,
      },
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: error.message },
      });
    }
    console.error('Casino roulette error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'Er is een fout opgetreden' },
    });
  }
});

/**
 * POST /casino/:casinoId/dice
 * Play dice game
 */
router.post('/:casinoId/dice', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const casinoId = String(req.params.casinoId);
    const { betAmount, prediction } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_AMOUNT' },
      });
    }

    if (!prediction) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_PREDICTION' },
      });
    }

    const result = await casinoService.playDice(req.player!.id, casinoId, betAmount, prediction);

    return res.status(200).json({
      event: result.won ? 'casino.dice.win' : 'casino.dice.lose',
      params: {
        dice1: result.dice1,
        dice2: result.dice2,
        total: result.total,
        won: result.won,
        payout: result.payout,
        casinoBankrupt: result.casinoBankrupt,
        betAmount,
        prediction,
      },
      player: {
        money: result.newBalance,
      },
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: error.message },
      });
    }
    
    if (error instanceof Error) {
      if (error.message === 'CASINO_NOT_FOUND') {
        return res.status(404).json({
          event: 'casino.error',
          params: { reason: 'CASINO_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_A_CASINO') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'NOT_A_CASINO' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'Minimum inzet is €10' },
        });
      }
    }

    console.error('Casino dice error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'Er is een fout opgetreden' },
    });
  }
});

/**
 * POST /casino/dice/roll
 * Play dice game (auto-detects casino from player's current country)
 */
router.post('/dice/roll', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    console.log('[DICE ROUTE] === DICE ROLL REQUEST RECEIVED ===');
    const { betAmount, prediction } = req.body;
    console.log(`[DICE ROUTE] betAmount=${betAmount} (type: ${typeof betAmount}), prediction=${prediction} (type: ${typeof prediction})`);

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      console.log('[DICE ROUTE] Invalid bet amount');
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_AMOUNT' },
      });
    }

    if (!prediction) {
      console.log('[DICE ROUTE] Invalid prediction');
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_PREDICTION' },
      });
    }

    // Get player's current country
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
      select: { currentCountry: true },
    });

    if (!player) {
      console.log('[DICE ROUTE] Player not found');
      return res.status(404).json({
        event: 'casino.error',
        params: { reason: 'PLAYER_NOT_FOUND' },
      });
    }

    const casinoId = `casino_${player.currentCountry}`;
    console.log(`[DICE ROUTE] casinoId=${casinoId}, calling playDice...`);

    const result = await casinoService.playDice(req.player!.id, casinoId, betAmount, prediction);
    console.log(`[DICE ROUTE] playDice returned: won=${result.won}, dice1=${result.dice1}, dice2=${result.dice2}, total=${result.total}, profit=${result.profit}`);

    return res.status(200).json({
      event: result.won ? 'casino.dice.win' : 'casino.dice.lose',
      params: {
        dice1: result.dice1,
        dice2: result.dice2,
        total: result.total,
        won: result.won,
        payout: result.payout,
        profit: result.profit,
        casinoBankrupt: result.casinoBankrupt,
        betAmount,
        prediction,
      },
      player: {
        money: result.newBalance,
      },
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: error.message },
      });
    }
    
    if (error instanceof Error) {
      if (error.message === 'CASINO_NOT_FOUND') {
        return res.status(404).json({
          event: 'casino.error',
          params: { reason: 'CASINO_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'Minimum inzet is €10' },
        });
      }
    }

    console.error('Casino dice error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'Er is een fout opgetreden' },
    });
  }
});

/**
 * POST /casino/:casinoId/slots
 * Play slot machine
 */
router.post('/:casinoId/slots', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const casinoId = String(req.params.casinoId);
    const { betAmount } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_AMOUNT' },
      });
    }

    const result = await casinoService.playSlots(req.player!.id, casinoId, betAmount);

    return res.status(200).json({
      event: result.won ? 'casino.slots.win' : 'casino.slots.lose',
      params: {
        result: result.result,
        won: result.won,
        payout: result.payout,
        betAmount,
        casinoBankrupt: result.casinoBankrupt,
      },
      player: {
        money: result.newBalance,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'CASINO_NOT_FOUND') {
        return res.status(404).json({
          event: 'casino.error',
          params: { reason: 'CASINO_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_A_CASINO') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'NOT_A_CASINO' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'MIN_BET_10', message: 'Minimum bet is €10' },
        });
      }
    }

    console.error('Casino slots error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /casino/:casinoId/blackjack
 * Play blackjack (hit/stand)
 */
router.post('/:casinoId/blackjack', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const casinoId = String(req.params.casinoId);
    const { betAmount, action, playerHand, dealerHand } = req.body;

    if (!action || !['start', 'hit', 'stand'].includes(action)) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_ACTION' },
      });
    }

    if (action === 'start') {
      if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INVALID_BET_AMOUNT' },
        });
      }
    }

    const result = await casinoService.playBlackjack(
      req.player!.id,
      casinoId,
      betAmount || 0,
      action,
      playerHand,
      dealerHand
    );

    const eventKey = result.gameOver
      ? result.result === 'win'
        ? 'casino.blackjack.win'
        : result.result === 'push'
        ? 'casino.blackjack.push'
        : 'casino.blackjack.lose'
      : 'casino.blackjack.continue';

    return res.status(200).json({
      event: eventKey,
      params: {
        playerHand: result.playerHand,
        dealerHand: result.dealerHand,
        playerTotal: result.playerTotal,
        dealerTotal: result.dealerTotal,
        gameOver: result.gameOver,
        result: result.result,
        payout: result.payout,
        casinoBankrupt: result.casinoBankrupt || false,
      },
      player: result.newBalance !== undefined ? { money: result.newBalance } : undefined,
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'CASINO_NOT_FOUND') {
        return res.status(404).json({
          event: 'casino.error',
          params: { reason: 'CASINO_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_A_CASINO') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'NOT_A_CASINO' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'MIN_BET_10', message: 'Minimum bet is €10' },
        });
      }

      if (error.message === 'INVALID_GAME_STATE') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INVALID_GAME_STATE' },
        });
      }
    }

    console.error('Casino blackjack error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /casino/:casinoId/roulette
 * Play roulette
 */
router.post('/:casinoId/roulette', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const casinoId = String(req.params.casinoId);
    const { betAmount, betType, betValue } = req.body;

    if (!betAmount || typeof betAmount !== 'number' || betAmount <= 0) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_AMOUNT' },
      });
    }

    if (
      !betType ||
      !['number', 'red', 'black', 'even', 'odd', '1-18', '19-36'].includes(betType)
    ) {
      return res.status(400).json({
        event: 'casino.error',
        params: { reason: 'INVALID_BET_TYPE' },
      });
    }

    const result = await casinoService.playRoulette(
      req.player!.id,
      casinoId,
      betAmount,
      betType as 'number' | 'red' | 'black' | 'even' | 'odd' | '1-18' | '19-36',
      betValue
    );

    return res.status(200).json({
      event: result.won ? 'casino.roulette.win' : 'casino.roulette.lose',
      params: {
        number: result.number,
        color: result.color,
        won: result.won,
        payout: result.payout,
        casinoBankrupt: result.casinoBankrupt,
        betAmount,
        betType,
        betValue,
      },
      player: {
        money: result.newBalance,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'CASINO_NOT_FOUND') {
        return res.status(404).json({
          event: 'casino.error',
          params: { reason: 'CASINO_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_A_CASINO') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'NOT_A_CASINO' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'MIN_BET_10') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'MIN_BET_10', message: 'Minimum bet is €10' },
        });
      }

      if (error.message === 'INVALID_NUMBER') {
        return res.status(400).json({
          event: 'casino.error',
          params: { reason: 'INVALID_NUMBER', message: 'Number must be 0-36' },
        });
      }
    }

    console.error('Casino roulette error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /casino/:casinoId/history
 * Get recent casino transaction history
 */
router.get('/:casinoId/history', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const casinoId = String(req.params.casinoId);
    const limit = parseInt(String(req.query.limit || '20'), 10);

    const transactions = await casinoService.getCasinoHistory(casinoId, limit);

    return res.status(200).json({
      event: 'casino.history',
      params: {
        casinoId,
        transactions,
      },
    });
  } catch (error) {
    console.error('Casino history error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /casino/ownership/:countryId
 * Check if casino is owned in this country
 */
router.get('/ownership/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const countryId = String(req.params.countryId);
    const ownership = await casinoOwnershipService.getOwnershipByCountry(countryId);
    const price = casinoOwnershipService.getCasinoPrice(countryId);

    return res.status(200).json({
      event: 'casino.ownership.info',
      params: {
        countryId,
        owned: !!ownership,
        owner: ownership ? {
          id: ownership.owner.id,
          username: ownership.owner.username,
          rank: ownership.owner.rank
        } : null,
        purchasePrice: ownership?.purchasePrice || price,
        price
      }
    });
  } catch (error) {
    console.error('Casino ownership check error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * POST /casino/purchase/:countryId
 * Purchase casino for a country
 */
router.post('/purchase/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const countryId = String(req.params.countryId);
    const playerId = req.player!.id;
    const { initialDeposit } = req.body;

    if (!initialDeposit || typeof initialDeposit !== 'number' || initialDeposit <= 0) {
      return res.status(400).json({
        event: 'casino.purchase.failed',
        params: {
          reason: 'Initial deposit amount is required',
          code: 'INVALID_DEPOSIT'
        }
      });
    }

    const ownership = await casinoOwnershipService.purchaseCasino(playerId, countryId, initialDeposit);

    return res.status(200).json({
      event: 'casino.purchased',
      params: {
        countryId,
        casinoId: ownership.casinoId,
        purchasePrice: ownership.purchasePrice,
        initialDeposit: ownership.bankroll,
        remainingMoney: ownership.owner.money
      }
    });
  } catch (error) {
    if (error instanceof AppError) {
      const statusMap: { [key: string]: number} = {
        'INSUFFICIENT_FUNDS': 400,
        'INSUFFICIENT_DEPOSIT': 400,
        'ALREADY_OWNED': 409,
        'INVALID_COUNTRY': 400,
        'EDUCATION_REQUIREMENTS_NOT_MET': 403
      };

      if (error.code === 'EDUCATION_REQUIREMENTS_NOT_MET') {
        let details: any = {};
        try {
          details = JSON.parse(error.message);
        } catch {
          details = {};
        }

        return res.status(statusMap[error.code] || 403).json({
          event: 'casino.purchase.failed',
          params: {
            reason: 'EDUCATION_REQUIREMENTS_NOT_MET',
            reasonKey: details.reasonKey || 'casino.purchase.education_requirements_not_met',
            code: error.code,
            gateId: details.gateId,
            gateLabelKey: details.gateLabelKey,
            missing: details.missing,
          }
        });
      }

      return res.status(statusMap[error.code] || 400).json({
        event: 'casino.purchase.failed',
        params: {
          reason: error.message,
          code: error.code
        }
      });
    }

    console.error('Casino purchase error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * GET /casino/my-casinos
 * Get all casinos owned by current player
 */
router.get('/my-casinos', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const casinos = await casinoOwnershipService.getPlayerCasinos(playerId);
    const revenue = await casinoOwnershipService.getCasinoRevenue(playerId);

    return res.status(200).json({
      event: 'casino.my-casinos',
      params: {
        casinos: casinos.map(c => ({
          casinoId: c.casinoId,
          countryId: c.casinoId.replace('casino_', ''),
          purchasePrice: c.purchasePrice,
          purchasedAt: c.purchasedAt
        })),
        totalRevenue: revenue
      }
    });
  } catch (error) {
    console.error('Get player casinos error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * GET /casino/available
 * Get all available casinos for purchase
 */
router.get('/available', authenticate, async (_req: AuthRequest, res: Response) => {
  try {
    const available = await casinoOwnershipService.getAvailableCasinos();

    return res.status(200).json({
      event: 'casino.available',
      params: { casinos: available }
    });
  } catch (error) {
    console.error('Get available casinos error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * GET /casino/stats/:countryId
 * Get casino statistics for owner
 */
router.get('/stats/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const countryId = String(req.params.countryId);
    const stats = await casinoOwnershipService.getCasinoStats(countryId);

    return res.status(200).json({
      event: 'casino.stats',
      params: stats
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(404).json({
        event: 'casino.stats.failed',
        params: { reason: error.message }
      });
    }

    console.error('Get casino stats error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * POST /casino/deposit/:countryId
 * Deposit money into casino bankroll
 */
router.post('/deposit/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const countryId = String(req.params.countryId);
    const playerId = req.player!.id;
    const { amount } = req.body;

    if (!amount || typeof amount !== 'number' || amount <= 0) {
      return res.status(400).json({
        event: 'casino.deposit.failed',
        params: { reason: 'Invalid deposit amount' }
      });
    }

    const stats = await casinoOwnershipService.depositToCasino(playerId, countryId, amount);

    return res.status(200).json({
      event: 'casino.deposited',
      params: { amount, ...stats }
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.deposit.failed',
        params: { reason: error.message, code: error.code }
      });
    }

    console.error('Casino deposit error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

/**
 * POST /casino/withdraw/:countryId
 * Withdraw money from casino bankroll
 */
router.post('/withdraw/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const countryId = String(req.params.countryId);
    const playerId = req.player!.id;
    const { amount } = req.body;

    if (!amount || typeof amount !== 'number' || amount <= 0) {
      return res.status(400).json({
        event: 'casino.withdraw.failed',
        params: { reason: 'Invalid withdrawal amount' }
      });
    }

    const stats = await casinoOwnershipService.withdrawFromCasino(playerId, countryId, amount);

    return res.status(200).json({
      event: 'casino.withdrawn',
      params: { amount, ...stats }
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(400).json({
        event: 'casino.withdraw.failed',
        params: { reason: error.message, code: error.code }
      });
    }

    console.error('Casino withdraw error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {}
    });
  }
});

export default router;

