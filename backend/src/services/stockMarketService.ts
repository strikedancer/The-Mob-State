import prisma from '../lib/prisma';
import { activityService } from './activityService';
import { getOrCreateBankAccount } from './bankService';

function toNumeric(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

async function getRuntimeConfig(keys: string[]): Promise<Record<string, string>> {
  if (keys.length === 0) return {};
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  );
  return rows.reduce<Record<string, string>>((acc, row) => {
    acc[row.configKey] = row.configValue;
    return acc;
  }, {});
}

async function getStockConfig() {
  const cfg = await getRuntimeConfig([
    'STOCK_MARKET_ENABLED',
    'STOCK_MARKET_TICK_SECONDS',
    'STOCK_MARKET_MAX_POSITIONS',
  ]);
  return {
    enabled: Number(cfg.STOCK_MARKET_ENABLED ?? 1) === 1,
    tickSeconds: Math.max(15, Math.floor(Number(cfg.STOCK_MARKET_TICK_SECONDS ?? 60))),
    maxPositions: Math.max(1, Math.floor(Number(cfg.STOCK_MARKET_MAX_POSITIONS ?? 10))),
  };
}

export async function tickStockPrices(force = false): Promise<void> {
  const cfg = await getStockConfig();
  if (!cfg.enabled) return;

  const assets = await prisma.$queryRawUnsafe<Array<{
    symbol: string;
    basePrice: number | string;
    currentPrice: number | string;
    volatility: number | string;
    lastTickAt: Date | null;
  }>>(
    `SELECT symbol, basePrice, currentPrice, volatility, lastTickAt
     FROM stock_assets WHERE enabled = 1`,
  );

  const now = Date.now();
  for (const asset of assets) {
    const last = asset.lastTickAt ? new Date(asset.lastTickAt).getTime() : 0;
    if (!force && last > 0 && now - last < cfg.tickSeconds * 1000) continue;

    const current = toNumeric(asset.currentPrice);
    const base = Math.max(1, toNumeric(asset.basePrice));
    const vol = Math.max(0.1, toNumeric(asset.volatility));
    const drift = (Math.random() - 0.48) * vol;
    const meanRevert = (base - current) * 0.02;
    const next = Math.max(1, Number((current * (1 + (drift + meanRevert) / 100)).toFixed(4)));

    await prisma.$executeRawUnsafe(
      `UPDATE stock_assets SET currentPrice = ?, lastTickAt = NOW(), updatedAt = NOW() WHERE symbol = ?`,
      next,
      asset.symbol,
    );
  }
}

export async function getStockMarket(playerId: number) {
  const cfg = await getStockConfig();
  if (!cfg.enabled) throw new Error('STOCK_MARKET_DISABLED');
  await tickStockPrices();

  const [assets, holdings, account, recent] = await Promise.all([
    prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `SELECT symbol, nameEn, nameNl, basePrice, currentPrice, volatility
       FROM stock_assets WHERE enabled = 1 ORDER BY symbol`,
    ),
    prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `SELECT symbol, quantity, avgCost FROM stock_holdings WHERE playerId = ? AND quantity > 0`,
      playerId,
    ),
    getOrCreateBankAccount(playerId),
    prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `SELECT id, symbol, side, quantity, price, totalCash, createdAt
       FROM stock_trades WHERE playerId = ? ORDER BY id DESC LIMIT 15`,
      playerId,
    ),
  ]);

  const holdingMap = holdings.reduce<Record<string, { quantity: number; avgCost: number }>>((acc, row) => {
    acc[String(row.symbol)] = {
      quantity: toNumeric(row.quantity),
      avgCost: toNumeric(row.avgCost),
    };
    return acc;
  }, {});

  const listed = assets.map((asset) => {
    const symbol = String(asset.symbol);
    const price = toNumeric(asset.currentPrice);
    const holding = holdingMap[symbol];
    return {
      symbol,
      nameEn: String(asset.nameEn),
      nameNl: String(asset.nameNl),
      price,
      basePrice: toNumeric(asset.basePrice),
      changePercent: Number((((price - toNumeric(asset.basePrice)) / Math.max(1, toNumeric(asset.basePrice))) * 100).toFixed(2)),
      holdingQuantity: holding?.quantity ?? 0,
      avgCost: holding?.avgCost ?? 0,
      marketValue: Math.round((holding?.quantity ?? 0) * price),
    };
  });

  const portfolioValue = listed.reduce((sum, row) => sum + row.marketValue, 0);

  return {
    enabled: true,
    bankBalance: account.balance,
    maxPositions: cfg.maxPositions,
    openPositions: listed.filter((row) => row.holdingQuantity > 0).length,
    portfolioValue,
    assets: listed,
    recentTrades: recent.map((trade) => ({
      id: toNumeric(trade.id),
      symbol: String(trade.symbol),
      side: String(trade.side),
      quantity: toNumeric(trade.quantity),
      price: toNumeric(trade.price),
      totalCash: toNumeric(trade.totalCash),
      createdAt: trade.createdAt,
    })),
  };
}

export async function tradeStock(
  playerId: number,
  symbolInput: string,
  sideInput: 'BUY' | 'SELL',
  quantityInput: number,
) {
  const cfg = await getStockConfig();
  if (!cfg.enabled) throw new Error('STOCK_MARKET_DISABLED');

  const symbol = String(symbolInput || '').trim().toUpperCase();
  const side = sideInput === 'SELL' ? 'SELL' : 'BUY';
  const quantity = Math.floor(Number(quantityInput));
  if (!symbol || quantity <= 0) throw new Error('INVALID_TRADE');

  await tickStockPrices();

  const assets = await prisma.$queryRawUnsafe<Array<{ symbol: string; currentPrice: number | string }>>(
    `SELECT symbol, currentPrice FROM stock_assets WHERE symbol = ? AND enabled = 1 LIMIT 1`,
    symbol,
  );
  if (!assets[0]) throw new Error('STOCK_NOT_FOUND');
  const price = toNumeric(assets[0].currentPrice);
  const totalCash = Math.round(price * quantity);
  if (totalCash <= 0) throw new Error('INVALID_TRADE');

  const account = await getOrCreateBankAccount(playerId);
  const holdings = await prisma.$queryRawUnsafe<Array<{ id: number; quantity: number; avgCost: number | string }>>(
    `SELECT id, quantity, avgCost FROM stock_holdings WHERE playerId = ? AND symbol = ? LIMIT 1`,
    playerId,
    symbol,
  );
  const holding = holdings[0];

  if (side === 'BUY') {
    if (account.balance < totalCash) throw new Error('INSUFFICIENT_BALANCE');
    const openPositions = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
      `SELECT COUNT(*) AS cnt FROM stock_holdings WHERE playerId = ? AND quantity > 0`,
      playerId,
    );
    const openCount = toNumeric(openPositions[0]?.cnt ?? 0);
    if (!holding && openCount >= cfg.maxPositions) throw new Error('STOCK_POSITION_LIMIT');

    await prisma.$transaction(async (tx) => {
      const updated = await tx.bankAccount.updateMany({
        where: { id: account.id, balance: { gte: totalCash } },
        data: { balance: { decrement: totalCash } },
      });
      if (updated.count !== 1) throw new Error('INSUFFICIENT_BALANCE');

      if (holding) {
        const oldQty = toNumeric(holding.quantity);
        const oldAvg = toNumeric(holding.avgCost);
        const newQty = oldQty + quantity;
        const newAvg = ((oldAvg * oldQty) + (price * quantity)) / Math.max(1, newQty);
        await tx.$executeRawUnsafe(
          `UPDATE stock_holdings SET quantity = ?, avgCost = ?, updatedAt = NOW() WHERE id = ?`,
          newQty,
          Number(newAvg.toFixed(4)),
          holding.id,
        );
      } else {
        await tx.$executeRawUnsafe(
          `INSERT INTO stock_holdings (playerId, symbol, quantity, avgCost)
           VALUES (?, ?, ?, ?)`,
          playerId,
          symbol,
          quantity,
          price,
        );
      }

      await tx.$executeRawUnsafe(
        `INSERT INTO stock_trades (playerId, symbol, side, quantity, price, totalCash)
         VALUES (?, ?, 'BUY', ?, ?, ?)`,
        playerId,
        symbol,
        quantity,
        price,
        totalCash,
      );
    });
  } else {
    const owned = toNumeric(holding?.quantity ?? 0);
    if (owned < quantity) throw new Error('INSUFFICIENT_SHARES');

    await prisma.$transaction(async (tx) => {
      await tx.$executeRawUnsafe(
        `UPDATE stock_holdings SET quantity = quantity - ?, updatedAt = NOW() WHERE id = ? AND quantity >= ?`,
        quantity,
        holding!.id,
        quantity,
      );
      await tx.bankAccount.update({
        where: { id: account.id },
        data: { balance: { increment: totalCash } },
      });
      await tx.$executeRawUnsafe(
        `INSERT INTO stock_trades (playerId, symbol, side, quantity, price, totalCash)
         VALUES (?, ?, 'SELL', ?, ?, ?)`,
        playerId,
        symbol,
        quantity,
        price,
        totalCash,
      );
      await tx.$executeRawUnsafe(
        `DELETE FROM stock_holdings WHERE id = ? AND quantity <= 0`,
        holding!.id,
      );
    });
  }

  await activityService.logActivity(
    playerId,
    side === 'BUY' ? 'stock.buy' : 'stock.sell',
    side === 'BUY' ? 'Stock purchase' : 'Stock sale',
    { symbol, quantity, price, totalCash },
    false,
  ).catch(() => {});

  return getStockMarket(playerId);
}
