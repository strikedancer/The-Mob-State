import { Router } from 'express';
import * as foodService from '../services/foodService';
import { authenticate, AuthRequest } from '../middleware/authenticate';

const router = Router();

// Get food and drink menu
router.get('/menu', authenticate, async (_req, res) => {
  try {
    const menu = await foodService.getMenu();
    res.json({
      event: 'food.menu',
      params: {
        food: menu.food,
        drinks: menu.drinks,
      },
    });
  } catch (error: any) {
    res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

// Buy food
router.post('/buy-food', authenticate, async (req: AuthRequest, res) => {
  try {
    const { itemName } = req.body;
    const playerId = req.player!.id;

    const result = await foodService.buyFood(playerId, itemName);

    return res.json({
      event: 'food.purchased',
      params: {
        itemName,
        newMoney: result.newMoney,
        message: `Je hebt ${itemName} gekocht!`,
      },
    });
  } catch (error: any) {
    if (error.message === 'INVALID_ITEM') {
      return res.status(400).json({
        event: 'error.invalidItem',
        params: { message: 'Dit item bestaat niet.' },
      });
    }
    if (error.message === 'INSUFFICIENT_FUNDS') {
      return res.status(400).json({
        event: 'error.insufficientFunds',
        params: { message: 'Je hebt niet genoeg geld.' },
      });
    }
    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

// Buy drink
router.post('/buy-drink', authenticate, async (req: AuthRequest, res) => {
  try {
    const { itemName } = req.body;
    const playerId = req.player!.id;

    const result = await foodService.buyDrink(playerId, itemName);

    return res.json({
      event: 'drink.purchased',
      params: {
        itemName,
        newMoney: result.newMoney,
        message: `Je hebt ${itemName} gekocht!`,
      },
    });
  } catch (error: any) {
    if (error.message === 'INVALID_ITEM') {
      return res.status(400).json({
        event: 'error.invalidItem',
        params: { message: 'Dit item bestaat niet.' },
      });
    }
    if (error.message === 'INSUFFICIENT_FUNDS') {
      return res.status(400).json({
        event: 'error.insufficientFunds',
        params: { message: 'Je hebt niet genoeg geld.' },
      });
    }
    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

export default router;
