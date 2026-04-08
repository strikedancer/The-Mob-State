import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import {
  getMarket,
  getPriceHistory,
  getPortfolio,
  getTransactionHistory,
  buyCrypto,
  sellCrypto,
  placeOrder,
  listOrders,
  cancelOrder,
} from '../services/cryptoService';

const router = Router();

router.get('/market', authenticate, async (_req: AuthRequest, res: Response) => {
  try {
    const data = await getMarket();
    return res.status(200).json({ success: true, ...data });
  } catch (error) {
    console.error('[crypto] market error:', error);
    return res.status(500).json({ success: false, message: 'Kon crypto markt niet laden.' });
  }
});

router.get('/history', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const symbol = String(req.query?.symbol ?? '').trim();
    const points = Number(req.query?.points ?? 120);
    const hours = Number(req.query?.hours ?? 24);
    const data = await getPriceHistory(symbol, points, hours);
    return res.status(200).json({ success: true, ...data });
  } catch (error: any) {
    if (error instanceof Error && error.message === 'ASSET_NOT_FOUND') {
      return res.status(404).json({ success: false, message: 'Crypto niet gevonden.' });
    }

    console.error('[crypto] history error:', error);
    return res.status(500).json({ success: false, message: 'Kon crypto grafiekdata niet laden.' });
  }
});

router.get('/portfolio', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const data = await getPortfolio(playerId);
    return res.status(200).json({ success: true, ...data });
  } catch (error) {
    console.error('[crypto] portfolio error:', error);
    return res.status(500).json({ success: false, message: 'Kon portfolio niet laden.' });
  }
});

router.get('/transactions', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const symbol = String(req.query?.symbol ?? '').trim();
    const limit = Number(req.query?.limit ?? 15);
    const data = await getTransactionHistory(playerId, symbol, limit);
    return res.status(200).json({ success: true, ...data });
  } catch (error: any) {
    if (error instanceof Error && error.message === 'ASSET_NOT_FOUND') {
      return res.status(404).json({ success: false, message: 'Crypto niet gevonden.' });
    }

    console.error('[crypto] transaction history error:', error);
    return res.status(500).json({ success: false, message: 'Kon crypto transactiehistorie niet laden.' });
  }
});

router.post('/buy', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const symbol = String(req.body?.symbol ?? '').trim();
    const quantity = Number(req.body?.quantity ?? 0);
    const result = await buyCrypto(playerId, symbol, quantity);

    return res.status(200).json({
      success: true,
      message: `Je kocht ${result.quantity} ${result.symbol} voor €${result.totalCost.toFixed(2)}.`,
      ...result,
    });
  } catch (error: any) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_QUANTITY') {
        return res.status(400).json({ success: false, message: 'Ongeldige hoeveelheid.' });
      }
      if (error.message === 'ASSET_NOT_FOUND') {
        return res.status(404).json({ success: false, message: 'Crypto niet gevonden.' });
      }
      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({ success: false, message: 'Niet genoeg geld.' });
      }
    }

    console.error('[crypto] buy error:', error);
    return res.status(500).json({ success: false, message: 'Aankoop mislukt.' });
  }
});

router.post('/sell', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const symbol = String(req.body?.symbol ?? '').trim();
    const quantity = Number(req.body?.quantity ?? 0);
    const result = await sellCrypto(playerId, symbol, quantity);

    return res.status(200).json({
      success: true,
      message: `Je verkocht ${result.quantity} ${result.symbol} voor €${result.totalValue.toFixed(2)}.`,
      ...result,
    });
  } catch (error: any) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_QUANTITY') {
        return res.status(400).json({ success: false, message: 'Ongeldige hoeveelheid.' });
      }
      if (error.message === 'ASSET_NOT_FOUND') {
        return res.status(404).json({ success: false, message: 'Crypto niet gevonden.' });
      }
      if (error.message === 'NOT_ENOUGH_HOLDING') {
        return res.status(400).json({ success: false, message: 'Niet genoeg crypto in bezit.' });
      }
    }

    console.error('[crypto] sell error:', error);
    return res.status(500).json({ success: false, message: 'Verkoop mislukt.' });
  }
});

router.get('/orders', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const data = await listOrders(playerId);
    return res.status(200).json({ success: true, ...data });
  } catch (error) {
    console.error('[crypto] list orders error:', error);
    return res.status(500).json({ success: false, message: 'Kon crypto orders niet laden.' });
  }
});

router.post('/orders', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const symbol = String(req.body?.symbol ?? '').trim();
    const orderType = String(req.body?.orderType ?? '').trim();
    const side = String(req.body?.side ?? '').trim();
    const quantity = Number(req.body?.quantity ?? 0);
    const targetPrice = Number(req.body?.targetPrice ?? 0);

    const result = await placeOrder(playerId, symbol, orderType, side, quantity, targetPrice);
    return res.status(200).json({
      success: true,
      message: `Order geplaatst: ${result.side} ${result.quantity} ${result.symbol} @ ${result.targetPrice.toFixed(8)}.`,
      ...result,
    });
  } catch (error: any) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_QUANTITY') {
        return res.status(400).json({ success: false, message: 'Ongeldige hoeveelheid.' });
      }
      if (error.message === 'INVALID_TARGET_PRICE') {
        return res.status(400).json({ success: false, message: 'Ongeldige doelprijs.' });
      }
      if (error.message === 'ASSET_NOT_FOUND') {
        return res.status(404).json({ success: false, message: 'Crypto niet gevonden.' });
      }
      if (error.message === 'INVALID_ORDER_TYPE') {
        return res.status(400).json({ success: false, message: 'Ongeldig ordertype.' });
      }
      if (error.message === 'INVALID_SIDE') {
        return res.status(400).json({ success: false, message: 'Ongeldige orderrichting.' });
      }
      if (error.message === 'INVALID_ORDER_COMBINATION') {
        return res.status(400).json({ success: false, message: 'Deze combinatie van ordertype en richting is niet toegestaan.' });
      }
      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({ success: false, message: 'Niet genoeg geld.' });
      }
      if (error.message === 'NOT_ENOUGH_HOLDING') {
        return res.status(400).json({ success: false, message: 'Niet genoeg crypto in bezit.' });
      }
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({ success: false, message: 'Speler niet gevonden.' });
      }
    }

    console.error('[crypto] place order error:', error);
    return res.status(500).json({ success: false, message: 'Order plaatsen mislukt.' });
  }
});

router.post('/orders/:orderId/cancel', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ success: false, message: 'Niet ingelogd.' });
    }

    const orderId = Number(req.params.orderId);
    const result = await cancelOrder(playerId, orderId);
    return res.status(200).json({
      success: true,
      message: `Order ${result.orderId} geannuleerd.`,
      ...result,
    });
  } catch (error: any) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_ORDER_ID') {
        return res.status(400).json({ success: false, message: 'Ongeldig order-id.' });
      }
      if (error.message === 'ORDER_NOT_FOUND_OR_NOT_OPEN') {
        return res.status(404).json({ success: false, message: 'Order niet gevonden of niet meer actief.' });
      }
    }

    console.error('[crypto] cancel order error:', error);
    return res.status(500).json({ success: false, message: 'Order annuleren mislukt.' });
  }
});

export default router;
