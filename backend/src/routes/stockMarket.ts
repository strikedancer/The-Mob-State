import { Router, Response, NextFunction } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as stockMarketService from '../services/stockMarketService';

const router = Router();

const tradeSchema = z.object({
  symbol: z.string().min(1).max(16),
  side: z.enum(['BUY', 'SELL']),
  quantity: z.number().int().positive(),
});

function mapStockError(error: unknown, res: Response, next: NextFunction) {
  if (!(error instanceof Error)) return next(error);
  const map: Record<string, [number, string]> = {
    STOCK_MARKET_DISABLED: [403, 'stock.disabled'],
    INVALID_TRADE: [400, 'stock.invalid_trade'],
    STOCK_NOT_FOUND: [404, 'stock.not_found'],
    INSUFFICIENT_BALANCE: [400, 'error.insufficient_balance'],
    INSUFFICIENT_SHARES: [400, 'stock.insufficient_shares'],
    STOCK_POSITION_LIMIT: [429, 'stock.position_limit'],
  };
  const entry = map[error.message];
  if (entry) return res.status(entry[0]).json({ event: entry[1], params: {} });
  return next(error);
}

router.get('/market', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const market = await stockMarketService.getStockMarket(req.player!.id);
    return res.json({ event: 'stock.market', params: market });
  } catch (error) {
    return mapStockError(error, res, next);
  }
});

router.post('/trade', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const body = tradeSchema.parse(req.body);
    const market = await stockMarketService.tradeStock(
      req.player!.id,
      body.symbol,
      body.side,
      body.quantity,
    );
    return res.json({ event: 'stock.traded', params: market });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapStockError(error, res, next);
  }
});

export default router;
