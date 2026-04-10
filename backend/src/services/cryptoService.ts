import prisma from '../lib/prisma';
import {
  checkAndUnlockAchievements,
  serializeAchievementForClient,
} from './achievementService';
import { directMessageService } from './directMessageService';
import { notificationService } from './notificationService';
import { playerNotificationPreferenceService } from './playerNotificationPreferenceService';
import { translationService, type Language } from './translationService';

type CryptoSeed = {
  symbol: string;
  name: string;
  basePrice: number;
  volatility: number;
  trendBias: number;
};

type CryptoOrderType = 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT';
type CryptoOrderSide = 'BUY' | 'SELL';
type CryptoOrderStatus = 'OPEN' | 'EXECUTING' | 'FILLED' | 'CANCELLED' | 'FAILED';
type MarketRegime = 'BULL' | 'BEAR' | 'SIDEWAYS';
type MarketNewsImpact = 'BULLISH' | 'BEARISH' | 'NEUTRAL';
type CryptoMissionType = 'DAILY' | 'WEEKLY';
type CryptoMissionMetric = 'TRADE_COUNT' | 'REALIZED_PROFIT';

type CryptoMissionDefinition = {
  key: string;
  missionType: CryptoMissionType;
  targetValue: number;
  rewardMoney: number;
  metric: CryptoMissionMetric;
  titleEn: string;
  titleNl: string;
};

type CryptoOrderRow = {
  id: number;
  player_id: number;
  asset_symbol: string;
  order_type: CryptoOrderType;
  side: CryptoOrderSide;
  quantity: string | number;
  target_price: string | number;
  status: CryptoOrderStatus;
  filled_price: string | number | null;
  failure_reason: string | null;
  created_at: Date;
  updated_at: Date;
};

const CRYPTO_SEEDS: CryptoSeed[] = [
  { symbol: 'BTC', name: 'Bitcoin', basePrice: 62000, volatility: 2.8, trendBias: 0.22 },
  { symbol: 'ETH', name: 'Ethereum', basePrice: 3400, volatility: 3.1, trendBias: 0.2 },
  { symbol: 'SOL', name: 'Solana', basePrice: 140, volatility: 4.4, trendBias: 0.18 },
  { symbol: 'XRP', name: 'XRP', basePrice: 0.72, volatility: 5.4, trendBias: 0.15 },
  { symbol: 'ADA', name: 'Cardano', basePrice: 0.55, volatility: 5.1, trendBias: 0.14 },
  { symbol: 'DOGE', name: 'Dogecoin', basePrice: 0.17, volatility: 6.8, trendBias: 0.08 },
  { symbol: 'AVAX', name: 'Avalanche', basePrice: 39, volatility: 4.9, trendBias: 0.16 },
  { symbol: 'DOT', name: 'Polkadot', basePrice: 8.8, volatility: 4.8, trendBias: 0.13 },
  { symbol: 'MATIC', name: 'Polygon', basePrice: 1.08, volatility: 5.2, trendBias: 0.14 },
  { symbol: 'LTC', name: 'Litecoin', basePrice: 95, volatility: 3.9, trendBias: 0.11 },
  { symbol: 'LINK', name: 'Chainlink', basePrice: 17.5, volatility: 4.3, trendBias: 0.13 },
  { symbol: 'ATOM', name: 'Cosmos', basePrice: 10.2, volatility: 4.6, trendBias: 0.12 },
  { symbol: 'UNI', name: 'Uniswap', basePrice: 11.4, volatility: 4.7, trendBias: 0.14 },
  { symbol: 'AAVE', name: 'Aave', basePrice: 125, volatility: 4.2, trendBias: 0.12 },
  { symbol: 'FIL', name: 'Filecoin', basePrice: 7.7, volatility: 4.9, trendBias: 0.1 },
  { symbol: 'ARB', name: 'Arbitrum', basePrice: 1.36, volatility: 5.6, trendBias: 0.15 },
  { symbol: 'OP', name: 'Optimism', basePrice: 2.95, volatility: 5.4, trendBias: 0.15 },
  { symbol: 'NEAR', name: 'NEAR Protocol', basePrice: 6.2, volatility: 4.8, trendBias: 0.14 },
  { symbol: 'INJ', name: 'Injective', basePrice: 31, volatility: 5.1, trendBias: 0.16 },
  { symbol: 'APT', name: 'Aptos', basePrice: 11.6, volatility: 5.2, trendBias: 0.15 },
  { symbol: 'SUI', name: 'Sui', basePrice: 1.44, volatility: 5.7, trendBias: 0.16 },
  { symbol: 'THETA', name: 'Theta Network', basePrice: 2.4, volatility: 4.8, trendBias: 0.11 },
  { symbol: 'ALGO', name: 'Algorand', basePrice: 0.21, volatility: 5.3, trendBias: 0.11 },
  { symbol: 'VET', name: 'VeChain', basePrice: 0.041, volatility: 5.7, trendBias: 0.1 },
  { symbol: 'TRX', name: 'TRON', basePrice: 0.14, volatility: 4.1, trendBias: 0.1 },
  { symbol: 'XLM', name: 'Stellar', basePrice: 0.19, volatility: 5.2, trendBias: 0.1 },
  { symbol: 'EOS', name: 'EOS', basePrice: 1.2, volatility: 5.4, trendBias: 0.09 },
  { symbol: 'KAS', name: 'Kaspa', basePrice: 0.13, volatility: 6.2, trendBias: 0.13 },
  { symbol: 'SEI', name: 'Sei', basePrice: 0.62, volatility: 6.0, trendBias: 0.13 },
  { symbol: 'PEPE', name: 'Pepe', basePrice: 0.000012, volatility: 8.7, trendBias: 0.03 },
];

let setupReady = false;
let setupPromise: Promise<void> | null = null;
let orderProcessorPromise: Promise<CryptoOrderProcessResult> | null = null;

type CryptoOrderProcessResult = {
  processed: number;
  filled: number;
  failed: number;
  remainingOpen: number;
};

type CryptoMissionCompletion = {
  missionType: CryptoMissionType;
  missionKey: string;
  missionTitleEn: string;
  missionTitleNl: string;
  rewardMoney: number;
};

type CryptoLeaderboardWinner = {
  rank: number;
  playerId: number;
  rewardMoney: number;
  realizedProfit: number;
  tradedVolume: number;
  tradeCount: number;
};

type MarketPulse = {
  marketMovePct: number;
  regime: MarketRegime;
  leaders: string[];
};

type CryptoHistoryPoint = {
  price: number;
  timestamp: string;
};

const MARKET_REGIME_BULL_THRESHOLD = 1.5;
const MARKET_REGIME_BEAR_THRESHOLD = -1.5;
const MARKET_REGIME_MIN_INTERVAL_MS = 15 * 60 * 1000;
const MARKET_NEWS_MIN_INTERVAL_MS = 10 * 60 * 1000;

const CRYPTO_MISSIONS: CryptoMissionDefinition[] = [
  {
    key: 'crypto_daily_trade_count',
    missionType: 'DAILY',
    targetValue: 5,
    rewardMoney: 5000,
    metric: 'TRADE_COUNT',
    titleEn: 'Execute 5 crypto trades in one day',
    titleNl: 'Voer 5 crypto trades uit in 1 dag',
  },
  {
    key: 'crypto_daily_realized_profit',
    missionType: 'DAILY',
    targetValue: 2500,
    rewardMoney: 6500,
    metric: 'REALIZED_PROFIT',
    titleEn: 'Realize EUR 2,500 crypto profit in one day',
    titleNl: 'Realiseer EUR 2.500 crypto winst in 1 dag',
  },
  {
    key: 'crypto_weekly_trade_count',
    missionType: 'WEEKLY',
    targetValue: 25,
    rewardMoney: 22000,
    metric: 'TRADE_COUNT',
    titleEn: 'Execute 25 crypto trades this week',
    titleNl: 'Voer 25 crypto trades uit deze week',
  },
  {
    key: 'crypto_weekly_realized_profit',
    missionType: 'WEEKLY',
    targetValue: 15000,
    rewardMoney: 30000,
    metric: 'REALIZED_PROFIT',
    titleEn: 'Realize EUR 15,000 crypto profit this week',
    titleNl: 'Realiseer EUR 15.000 crypto winst deze week',
  },
];

const CRYPTO_WEEKLY_LEADERBOARD_REWARDS: Record<number, number> = {
  1: 75000,
  2: 50000,
  3: 30000,
  4: 20000,
  5: 10000,
};

function localizeCrypto(language: Language, nl: string, en: string): string {
  return language === 'nl' ? nl : en;
}

function getCryptoNumberLocale(language: Language): string {
  return language === 'nl' ? 'nl-NL' : 'en-US';
}

function formatCryptoMoney(value: number, language: Language): string {
  return new Intl.NumberFormat(getCryptoNumberLocale(language), {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value);
}

function formatCryptoPrice(value: number, language: Language): string {
  const absoluteValue = Math.abs(value);
  const maximumFractionDigits = absoluteValue >= 1000 ? 2 : absoluteValue >= 1 ? 4 : 8;

  return new Intl.NumberFormat(getCryptoNumberLocale(language), {
    minimumFractionDigits: 2,
    maximumFractionDigits,
  }).format(value);
}

function formatCryptoQuantity(value: number, language: Language): string {
  return new Intl.NumberFormat(getCryptoNumberLocale(language), {
    minimumFractionDigits: 0,
    maximumFractionDigits: 8,
  }).format(value);
}

function getLocalizedOrderType(orderType: CryptoOrderType, language: Language): string {
  switch (orderType) {
    case 'LIMIT':
      return localizeCrypto(language, 'Limit', 'Limit');
    case 'STOP_LOSS':
      return localizeCrypto(language, 'Stop-loss', 'Stop-loss');
    case 'TAKE_PROFIT':
      return localizeCrypto(language, 'Take-profit', 'Take-profit');
    default:
      return orderType;
  }
}

function getLocalizedSide(side: 'buy' | 'sell' | CryptoOrderSide, language: Language): string {
  const normalized = side.toUpperCase();
  if (normalized === 'BUY') {
    return localizeCrypto(language, 'Koop', 'Buy');
  }
  return localizeCrypto(language, 'Verkoop', 'Sell');
}

async function getPlayerCryptoLanguage(playerId: number): Promise<Language> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });

  return translationService.getPlayerLanguage(player ?? {});
}

async function sendCryptoInboxMessage(
  playerId: number,
  buildMessage: (language: Language) => string
): Promise<void> {
  const language = await getPlayerCryptoLanguage(playerId);
  const message = buildMessage(language);
  await directMessageService.sendSystemMessage(playerId, message, { sendPush: false });
}

async function sendCryptoTradeInboxMessage(
  playerId: number,
  side: 'buy' | 'sell',
  symbol: string,
  quantity: number,
  price: number,
  totalValue: number,
  realizedProfit?: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => {
    const lines = [
      localizeCrypto(
        language,
        side === 'buy' ? 'Crypto aankoop uitgevoerd' : 'Crypto verkoop uitgevoerd',
        side === 'buy' ? 'Crypto buy executed' : 'Crypto sell executed'
      ),
      '',
      `${localizeCrypto(language, 'Munt', 'Coin')}: ${symbol}`,
      `${localizeCrypto(language, 'Actie', 'Action')}: ${getLocalizedSide(side, language)}`,
      `${localizeCrypto(language, 'Aantal', 'Quantity')}: ${formatCryptoQuantity(quantity, language)}`,
      `${localizeCrypto(language, 'Prijs', 'Price')}: €${formatCryptoPrice(price, language)}`,
      `${localizeCrypto(language, 'Totaal', 'Total')}: €${formatCryptoMoney(totalValue, language)}`,
    ];

    if (realizedProfit !== undefined) {
      lines.push(
        `${localizeCrypto(language, 'Gerealiseerde winst', 'Realized profit')}: €${formatCryptoMoney(realizedProfit, language)}`
      );
    }

    return lines.join('\n');
  });
}

async function sendCryptoOrderPlacedInboxMessage(
  playerId: number,
  symbol: string,
  orderType: CryptoOrderType,
  side: CryptoOrderSide,
  quantity: number,
  targetPrice: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => [
    localizeCrypto(language, 'Crypto order geplaatst', 'Crypto order placed'),
    '',
    `${localizeCrypto(language, 'Munt', 'Coin')}: ${symbol}`,
    `${localizeCrypto(language, 'Type', 'Type')}: ${getLocalizedOrderType(orderType, language)}`,
    `${localizeCrypto(language, 'Actie', 'Action')}: ${getLocalizedSide(side, language)}`,
    `${localizeCrypto(language, 'Aantal', 'Quantity')}: ${formatCryptoQuantity(quantity, language)}`,
    `${localizeCrypto(language, 'Doelprijs', 'Target price')}: €${formatCryptoPrice(targetPrice, language)}`,
  ].join('\n'));
}

async function sendCryptoOrderCancelledInboxMessage(
  playerId: number,
  symbol: string,
  orderType: CryptoOrderType,
  side: CryptoOrderSide,
  quantity: number,
  targetPrice: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => [
    localizeCrypto(language, 'Crypto order geannuleerd', 'Crypto order cancelled'),
    '',
    `${localizeCrypto(language, 'Munt', 'Coin')}: ${symbol}`,
    `${localizeCrypto(language, 'Type', 'Type')}: ${getLocalizedOrderType(orderType, language)}`,
    `${localizeCrypto(language, 'Actie', 'Action')}: ${getLocalizedSide(side, language)}`,
    `${localizeCrypto(language, 'Aantal', 'Quantity')}: ${formatCryptoQuantity(quantity, language)}`,
    `${localizeCrypto(language, 'Doelprijs', 'Target price')}: €${formatCryptoPrice(targetPrice, language)}`,
  ].join('\n'));
}

async function sendCryptoOrderTriggeredInboxMessage(
  playerId: number,
  symbol: string,
  triggerType: 'STOP_LOSS' | 'TAKE_PROFIT',
  triggerPrice: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => [
    localizeCrypto(language, 'Crypto order geactiveerd', 'Crypto order triggered'),
    '',
    `${localizeCrypto(language, 'Munt', 'Coin')}: ${symbol}`,
    `${localizeCrypto(language, 'Trigger', 'Trigger')}: ${getLocalizedOrderType(triggerType, language)}`,
    `${localizeCrypto(language, 'Triggerprijs', 'Trigger price')}: €${formatCryptoPrice(triggerPrice, language)}`,
    '',
    localizeCrypto(
      language,
      'Je verkooporder is geactiveerd en wordt nu uitgevoerd tegen de marktprijs.',
      'Your sell order was triggered and is now being executed at market price.'
    ),
  ].join('\n'));
}

async function sendCryptoOrderFilledInboxMessage(
  playerId: number,
  symbol: string,
  orderType: CryptoOrderType,
  side: CryptoOrderSide,
  quantity: number,
  fillPrice: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => [
    localizeCrypto(language, 'Crypto order uitgevoerd', 'Crypto order filled'),
    '',
    `${localizeCrypto(language, 'Munt', 'Coin')}: ${symbol}`,
    `${localizeCrypto(language, 'Type', 'Type')}: ${getLocalizedOrderType(orderType, language)}`,
    `${localizeCrypto(language, 'Actie', 'Action')}: ${getLocalizedSide(side, language)}`,
    `${localizeCrypto(language, 'Aantal', 'Quantity')}: ${formatCryptoQuantity(quantity, language)}`,
    `${localizeCrypto(language, 'Uitgevoerde prijs', 'Fill price')}: €${formatCryptoPrice(fillPrice, language)}`,
  ].join('\n'));
}

async function sendCryptoMissionCompletedInboxMessage(
  playerId: number,
  missionType: CryptoMissionType,
  missionTitleEn: string,
  missionTitleNl: string,
  rewardMoney: number
): Promise<void> {
  await sendCryptoInboxMessage(playerId, (language) => [
    localizeCrypto(language, 'Crypto missie voltooid', 'Crypto mission completed'),
    '',
    `${localizeCrypto(language, 'Periode', 'Period')}: ${localizeCrypto(language, missionType === 'DAILY' ? 'Dagelijks' : 'Wekelijks', missionType === 'DAILY' ? 'Daily' : 'Weekly')}`,
    `${localizeCrypto(language, 'Missie', 'Mission')}: ${language === 'nl' ? missionTitleNl : missionTitleEn}`,
    `${localizeCrypto(language, 'Beloning', 'Reward')}: €${formatCryptoMoney(rewardMoney, language)}`,
  ].join('\n'));
}

async function sendCryptoLeaderboardRewardInboxMessage(winner: CryptoLeaderboardWinner): Promise<void> {
  await sendCryptoInboxMessage(winner.playerId, (language) => [
    localizeCrypto(language, 'Crypto leaderboard uitbetaling', 'Crypto leaderboard payout'),
    '',
    `${localizeCrypto(language, 'Positie', 'Rank')}: #${winner.rank}`,
    `${localizeCrypto(language, 'Beloning', 'Reward')}: €${formatCryptoMoney(winner.rewardMoney, language)}`,
    `${localizeCrypto(language, 'Gerealiseerde winst', 'Realized profit')}: €${formatCryptoMoney(winner.realizedProfit, language)}`,
    `${localizeCrypto(language, 'Tradevolume', 'Trade volume')}: €${formatCryptoMoney(winner.tradedVolume, language)}`,
    `${localizeCrypto(language, 'Aantal trades', 'Trades')}: ${winner.tradeCount}`,
  ].join('\n'));
}

function parseNumber(input: unknown, fallback = 0): number {
  const value = Number(input);
  return Number.isFinite(value) ? value : fallback;
}

function serializeWorldEventParams(value: Record<string, unknown>): string {
  try {
    return JSON.stringify(value);
  } catch {
    return '{}';
  }
}

function downsampleHistoryPoints(points: CryptoHistoryPoint[], limit: number): CryptoHistoryPoint[] {
  if (points.length <= limit) {
    return points;
  }

  const sampled: CryptoHistoryPoint[] = [];
  const lastIndex = points.length - 1;

  for (let index = 0; index < limit; index += 1) {
    const sourceIndex = Math.round((index * lastIndex) / (limit - 1));
    sampled.push(points[sourceIndex]);
  }

  return sampled;
}

function clampPrice(value: number, basePrice: number): number {
  const MIN_PRICE = 0.000001;
  // Matches DECIMAL(24,8): max 16 digits before decimal.
  const MAX_PRICE = 9999999999999999.99999999;
  const safeBasePrice = Math.max(basePrice, MIN_PRICE);
  const boundedMinPrice = Math.max(MIN_PRICE, Number((safeBasePrice * 0.05).toFixed(8)));
  const boundedMaxPrice = Math.min(MAX_PRICE, Number((safeBasePrice * 250).toFixed(8)));

  if (!Number.isFinite(value)) {
    return boundedMinPrice;
  }

  const normalized = Number(value.toFixed(8));
  if (!Number.isFinite(normalized)) {
    return boundedMinPrice;
  }

  if (normalized > boundedMaxPrice) {
    return boundedMaxPrice;
  }

  return Math.max(boundedMinPrice, normalized);
}

function toUtcDateKey(date: Date): string {
  return date.toISOString().slice(0, 10);
}

function getWeekStartUtc(date: Date): Date {
  const utcMidnight = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
  const day = utcMidnight.getUTCDay();
  const diffToMonday = (day + 6) % 7;
  utcMidnight.setUTCDate(utcMidnight.getUTCDate() - diffToMonday);
  return utcMidnight;
}

function getMissionPeriodKey(missionType: CryptoMissionType, date = new Date()): string {
  if (missionType === 'DAILY') {
    return toUtcDateKey(date);
  }
  return toUtcDateKey(getWeekStartUtc(date));
}

function getCryptoLeaderboardWindowUtc(date = new Date()): { start: Date; end: Date } {
  const start = getWeekStartUtc(date);
  const end = new Date(start);
  end.setUTCDate(end.getUTCDate() + 7);
  return { start, end };
}

function detectMarketRegime(marketMovePct: number): MarketRegime {
  if (marketMovePct >= MARKET_REGIME_BULL_THRESHOLD) {
    return 'BULL';
  }
  if (marketMovePct <= MARKET_REGIME_BEAR_THRESHOLD) {
    return 'BEAR';
  }
  return 'SIDEWAYS';
}

function pickMarketNewsImpact(regime: MarketRegime): MarketNewsImpact {
  if (regime === 'BULL') {
    return Math.random() < 0.75 ? 'BULLISH' : 'NEUTRAL';
  }
  if (regime === 'BEAR') {
    return Math.random() < 0.75 ? 'BEARISH' : 'NEUTRAL';
  }

  const roll = Math.random();
  if (roll < 0.34) {
    return 'BULLISH';
  }
  if (roll < 0.67) {
    return 'BEARISH';
  }
  return 'NEUTRAL';
}

function buildMarketHeadline(
  impact: MarketNewsImpact,
  leaders: string[],
  marketMovePct: number
): string {
  const leadA = leaders[0] ?? 'BTC';
  const leadB = leaders[1] ?? 'ETH';
  const leadC = leaders[2] ?? 'SOL';
  const moveAbs = Math.abs(marketMovePct).toFixed(2);

  if (impact === 'BULLISH') {
    const bullishHeadlines = [
      `Whale accumulation detected as ${leadA} and ${leadB} lead risk-on momentum`,
      `Institutional inflows lift ${leadA}; broad altcoin breadth expands around ${leadC}`,
      `Short squeeze accelerates market upside with ${leadB} outperforming majors`,
    ];
    return bullishHeadlines[Math.floor(Math.random() * bullishHeadlines.length)];
  }

  if (impact === 'BEARISH') {
    const bearishHeadlines = [
      `Risk-off wave hits crypto as ${leadA} loses key support and drags ${leadB}`,
      `Derivatives liquidations pressure ${leadC} while majors retrace ${moveAbs}%`,
      `Macro uncertainty triggers defensive flow out of ${leadB} and high-beta alts`,
    ];
    return bearishHeadlines[Math.floor(Math.random() * bearishHeadlines.length)];
  }

  const neutralHeadlines = [
    `Market consolidates near flat as ${leadA} and ${leadB} trade inside narrow ranges`,
    `Mixed flows keep crypto sideways; traders rotate between ${leadB} and ${leadC}`,
    `Volatility cools with majors pausing after recent ${moveAbs}% swing`,
  ];
  return neutralHeadlines[Math.floor(Math.random() * neutralHeadlines.length)];
}

async function lockPlayerMoneyRow(
  tx: Parameters<typeof prisma.$transaction>[0],
  playerId: number
): Promise<{ id: number; money: number }> {
  const rows = await tx.$queryRawUnsafe<Array<{ id: number; money: number }>>(
    'SELECT id, money FROM players WHERE id = ? FOR UPDATE',
    playerId
  );

  if (rows.length === 0) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  return rows[0];
}

async function lockHoldingRow(
  tx: Parameters<typeof prisma.$transaction>[0],
  playerId: number,
  symbol: string
): Promise<{ quantity: string | number; avg_buy_price: string | number }> {
  const rows = await tx.$queryRawUnsafe<
    Array<{ quantity: string | number; avg_buy_price: string | number }>
  >(
    'SELECT quantity, avg_buy_price FROM crypto_holdings WHERE player_id = ? AND asset_symbol = ? LIMIT 1 FOR UPDATE',
    playerId,
    symbol
  );

  if (rows.length === 0) {
    throw new Error('NOT_ENOUGH_HOLDING');
  }

  return rows[0];
}

async function ensureSchemaAndSeed(): Promise<void> {
  if (setupReady) return;
  if (setupPromise) return setupPromise;

  setupPromise = (async () => {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_assets (
        id INT AUTO_INCREMENT PRIMARY KEY,
        symbol VARCHAR(12) NOT NULL UNIQUE,
        name VARCHAR(80) NOT NULL,
        base_price DECIMAL(24,8) NOT NULL,
        current_price DECIMAL(24,8) NOT NULL,
        volatility DECIMAL(10,4) NOT NULL,
        trend_bias DECIMAL(10,4) NOT NULL DEFAULT 0,
        icon_key VARCHAR(50) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_crypto_assets_symbol (symbol),
        INDEX idx_crypto_assets_updated_at (updated_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_holdings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        player_id INT NOT NULL,
        asset_symbol VARCHAR(12) NOT NULL,
        quantity DECIMAL(24,8) NOT NULL DEFAULT 0,
        avg_buy_price DECIMAL(24,8) NOT NULL DEFAULT 0,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_crypto_holdings_player_asset (player_id, asset_symbol),
        INDEX idx_crypto_holdings_player (player_id),
        INDEX idx_crypto_holdings_symbol (asset_symbol),
        CONSTRAINT fk_crypto_holdings_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_transactions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        player_id INT NOT NULL,
        asset_symbol VARCHAR(12) NOT NULL,
        side VARCHAR(8) NOT NULL,
        quantity DECIMAL(24,8) NOT NULL,
        price DECIMAL(24,8) NOT NULL,
        total_value DECIMAL(24,8) NOT NULL,
        realized_profit DECIMAL(24,8) NOT NULL DEFAULT 0,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_crypto_transactions_player (player_id),
        INDEX idx_crypto_transactions_symbol (asset_symbol),
        INDEX idx_crypto_transactions_created_at (created_at),
        CONSTRAINT fk_crypto_transactions_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_price_history (
        id INT AUTO_INCREMENT PRIMARY KEY,
        asset_symbol VARCHAR(12) NOT NULL,
        price DECIMAL(24,8) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_crypto_price_history_symbol_time (asset_symbol, created_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        player_id INT NOT NULL,
        asset_symbol VARCHAR(12) NOT NULL,
        order_type VARCHAR(20) NOT NULL,
        side VARCHAR(10) NOT NULL,
        quantity DECIMAL(24,8) NOT NULL,
        target_price DECIMAL(24,8) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
        filled_price DECIMAL(24,8) NULL,
        failure_reason VARCHAR(120) NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_crypto_orders_player (player_id),
        INDEX idx_crypto_orders_open (status, asset_symbol),
        INDEX idx_crypto_orders_symbol (asset_symbol),
        CONSTRAINT fk_crypto_orders_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_market_state (
        id TINYINT PRIMARY KEY,
        current_regime VARCHAR(12) NOT NULL DEFAULT 'SIDEWAYS',
        last_regime_change_at DATETIME NULL,
        last_news_at DATETIME NULL,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_mission_progress (
        id INT AUTO_INCREMENT PRIMARY KEY,
        player_id INT NOT NULL,
        mission_key VARCHAR(80) NOT NULL,
        mission_type VARCHAR(16) NOT NULL,
        period_key VARCHAR(20) NOT NULL,
        progress_value DECIMAL(24,8) NOT NULL DEFAULT 0,
        target_value DECIMAL(24,8) NOT NULL,
        reward_money DECIMAL(24,2) NOT NULL DEFAULT 0,
        completed_at DATETIME NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_crypto_mission_player_key_period (player_id, mission_key, period_key),
        INDEX idx_crypto_mission_player_period (player_id, period_key),
        CONSTRAINT fk_crypto_mission_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_leaderboard_state (
        id TINYINT PRIMARY KEY,
        week_start_at DATETIME NOT NULL,
        week_end_at DATETIME NOT NULL,
        last_processed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS crypto_leaderboard_rewards (
        id INT AUTO_INCREMENT PRIMARY KEY,
        week_start_at DATETIME NOT NULL,
        week_end_at DATETIME NOT NULL,
        rank INT NOT NULL,
        player_id INT NOT NULL,
        reward_money DECIMAL(24,2) NOT NULL,
        realized_profit DECIMAL(24,2) NOT NULL,
        traded_volume DECIMAL(24,2) NOT NULL,
        trade_count INT NOT NULL,
        paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_crypto_lb_week_rank (week_start_at, rank),
        UNIQUE KEY uniq_crypto_lb_week_player (week_start_at, player_id),
        INDEX idx_crypto_lb_rewards_player (player_id, paid_at),
        CONSTRAINT fk_crypto_lb_rewards_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO crypto_market_state (id, current_regime)
      VALUES (1, 'SIDEWAYS')
      ON DUPLICATE KEY UPDATE id = VALUES(id)
      `
    );

    const leaderboardWindow = getCryptoLeaderboardWindowUtc(new Date());
    await prisma.$executeRawUnsafe(
      `
      INSERT INTO crypto_leaderboard_state (id, week_start_at, week_end_at)
      VALUES (1, ?, ?)
      ON DUPLICATE KEY UPDATE id = VALUES(id)
      `,
      leaderboardWindow.start,
      leaderboardWindow.end
    );

    for (const seed of CRYPTO_SEEDS) {
      await prisma.$executeRawUnsafe(
        `
        INSERT INTO crypto_assets (symbol, name, base_price, current_price, volatility, trend_bias, icon_key)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
          name = VALUES(name),
          base_price = VALUES(base_price),
          volatility = VALUES(volatility),
          trend_bias = VALUES(trend_bias),
          icon_key = VALUES(icon_key)
        `,
        seed.symbol,
        seed.name,
        seed.basePrice,
        seed.basePrice,
        seed.volatility,
        seed.trendBias,
        seed.symbol.toLowerCase()
      );
    }

    setupReady = true;
  })();

  return setupPromise;
}

async function processCryptoMissionProgress(
  playerId: number,
  payload: { tradeCountDelta: number; realizedProfitDelta: number }
): Promise<CryptoMissionCompletion[]> {
  await ensureSchemaAndSeed();

  const now = new Date();
  const completions = await prisma.$transaction(async (tx) => {
    for (const mission of CRYPTO_MISSIONS) {
      const periodKey = getMissionPeriodKey(mission.missionType, now);
      await tx.$executeRawUnsafe(
        `
        INSERT INTO crypto_mission_progress
          (player_id, mission_key, mission_type, period_key, progress_value, target_value, reward_money)
        VALUES (?, ?, ?, ?, 0, ?, ?)
        ON DUPLICATE KEY UPDATE
          target_value = VALUES(target_value),
          reward_money = VALUES(reward_money),
          mission_type = VALUES(mission_type),
          updated_at = NOW()
        `,
        playerId,
        mission.key,
        mission.missionType,
        periodKey,
        mission.targetValue,
        mission.rewardMoney
      );
    }

    const rows = await tx.$queryRawUnsafe<
      Array<{
        id: number;
        mission_key: string;
        progress_value: string | number;
        target_value: string | number;
        completed_at: Date | null;
      }>
    >(
      `
      SELECT id, mission_key, progress_value, target_value, completed_at
      FROM crypto_mission_progress
      WHERE player_id = ?
        AND period_key IN (?, ?)
      FOR UPDATE
      `,
      playerId,
      getMissionPeriodKey('DAILY', now),
      getMissionPeriodKey('WEEKLY', now)
    );

    const completed: CryptoMissionCompletion[] = [];

    for (const row of rows) {
      const definition = CRYPTO_MISSIONS.find((entry) => entry.key === row.mission_key);
      if (!definition) {
        continue;
      }

      const currentProgress = parseNumber(row.progress_value, 0);
      const targetValue = parseNumber(row.target_value, definition.targetValue);
      const delta = definition.metric === 'TRADE_COUNT'
        ? payload.tradeCountDelta
        : payload.realizedProfitDelta;

      if (delta <= 0) {
        continue;
      }

      const nextProgress = Math.min(targetValue, currentProgress + delta);
      let completedAt = row.completed_at;

      if (!completedAt && nextProgress + 1e-8 >= targetValue) {
        completedAt = now;
        await tx.player.update({
          where: { id: playerId },
          data: { money: { increment: definition.rewardMoney } },
        });

        completed.push({
          missionType: definition.missionType,
          missionKey: definition.key,
          missionTitleEn: definition.titleEn,
          missionTitleNl: definition.titleNl,
          rewardMoney: definition.rewardMoney,
        });
      }

      await tx.$executeRawUnsafe(
        `
        UPDATE crypto_mission_progress
        SET progress_value = ?, completed_at = ?, updated_at = NOW()
        WHERE id = ?
        `,
        nextProgress,
        completedAt,
        row.id
      );
    }

    return completed;
  });

  return completions;
}

async function buildWeeklyCryptoLeaderboard(
  weekStartAt: Date,
  weekEndAt: Date,
  limit = 10
): Promise<Array<{ playerId: number; realizedProfit: number; tradedVolume: number; tradeCount: number }>> {
  const safeLimit = Math.max(1, Math.min(100, Math.floor(limit)));
  const rows = await prisma.$queryRawUnsafe<
    Array<{
      player_id: number;
      realized_profit: string | number;
      traded_volume: string | number;
      trade_count: string | number;
    }>
  >(
    `
    SELECT
      player_id,
      COALESCE(SUM(realized_profit), 0) AS realized_profit,
      COALESCE(SUM(total_value), 0) AS traded_volume,
      COUNT(*) AS trade_count
    FROM crypto_transactions
    WHERE side = 'SELL'
      AND created_at >= ?
      AND created_at < ?
    GROUP BY player_id
    HAVING realized_profit > 0
    ORDER BY realized_profit DESC, traded_volume DESC, player_id ASC
    LIMIT ?
    `,
    weekStartAt,
    weekEndAt,
    safeLimit
  );

  return rows.map((row) => ({
    playerId: row.player_id,
    realizedProfit: Number(parseNumber(row.realized_profit, 0).toFixed(2)),
    tradedVolume: Number(parseNumber(row.traded_volume, 0).toFixed(2)),
    tradeCount: Math.max(0, Math.floor(parseNumber(row.trade_count, 0))),
  }));
}

async function processWeeklyCryptoLeaderboardRewardsIfNeeded(): Promise<{
  processed: boolean;
  weekStartAt: Date;
  weekEndAt: Date;
  winners: CryptoLeaderboardWinner[];
}> {
  await ensureSchemaAndSeed();

  const now = new Date();
  const currentWindow = getCryptoLeaderboardWindowUtc(now);
  const stateRows = await prisma.$queryRawUnsafe<
    Array<{ week_start_at: Date; week_end_at: Date }>
  >(
    `
    SELECT week_start_at, week_end_at
    FROM crypto_leaderboard_state
    WHERE id = 1
    LIMIT 1
    `
  );

  if (stateRows.length === 0) {
    await prisma.$executeRawUnsafe(
      `
      INSERT INTO crypto_leaderboard_state (id, week_start_at, week_end_at, last_processed_at)
      VALUES (1, ?, ?, NOW())
      `,
      currentWindow.start,
      currentWindow.end
    );

    return {
      processed: false,
      weekStartAt: currentWindow.start,
      weekEndAt: currentWindow.end,
      winners: [],
    };
  }

  const state = stateRows[0];
  const weekStartAt = new Date(state.week_start_at);
  const weekEndAt = new Date(state.week_end_at);

  if (now < weekEndAt) {
    return {
      processed: false,
      weekStartAt,
      weekEndAt,
      winners: [],
    };
  }

  const existingRows = await prisma.$queryRawUnsafe<Array<{ total: string | number }>>(
    `
    SELECT COUNT(*) AS total
    FROM crypto_leaderboard_rewards
    WHERE week_start_at = ?
    `,
    weekStartAt
  );

  const existingRewards = Math.floor(parseNumber(existingRows[0]?.total, 0));
  const winners: CryptoLeaderboardWinner[] = [];

  if (existingRewards === 0) {
    const leaderboard = await buildWeeklyCryptoLeaderboard(weekStartAt, weekEndAt, 10);

    for (let index = 0; index < leaderboard.length; index += 1) {
      const rank = index + 1;
      const rewardMoney = CRYPTO_WEEKLY_LEADERBOARD_REWARDS[rank] ?? 0;
      if (rewardMoney <= 0) {
        continue;
      }

      const entry = leaderboard[index];
      await prisma.$transaction(async (tx) => {
        await tx.player.update({
          where: { id: entry.playerId },
          data: { money: { increment: rewardMoney } },
        });

        await tx.$executeRawUnsafe(
          `
          INSERT INTO crypto_leaderboard_rewards
          (week_start_at, week_end_at, rank, player_id, reward_money, realized_profit, traded_volume, trade_count)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          `,
          weekStartAt,
          weekEndAt,
          rank,
          entry.playerId,
          rewardMoney,
          entry.realizedProfit,
          entry.tradedVolume,
          entry.tradeCount
        );
      });

      winners.push({
        rank,
        playerId: entry.playerId,
        rewardMoney,
        realizedProfit: entry.realizedProfit,
        tradedVolume: entry.tradedVolume,
        tradeCount: entry.tradeCount,
      });
    }

    await Promise.allSettled(
      winners.map((winner) =>
        notificationService.sendCryptoLeaderboardRewardNotification(
          winner.playerId,
          winner.rank,
          winner.rewardMoney,
          weekStartAt.toISOString(),
          weekEndAt.toISOString()
        )
      )
    );
  }

  await prisma.$executeRawUnsafe(
    `
    UPDATE crypto_leaderboard_state
    SET week_start_at = ?, week_end_at = ?, last_processed_at = NOW(), updated_at = NOW()
    WHERE id = 1
    `,
    currentWindow.start,
    currentWindow.end
  );

  return {
    processed: true,
    weekStartAt,
    weekEndAt,
    winners,
  };
}

async function calculateMarketPulse(): Promise<MarketPulse> {
  const assets = await prisma.$queryRawUnsafe<
    Array<{ symbol: string; base_price: string | number; current_price: string | number }>
  >(
    `
    SELECT symbol, base_price, current_price
    FROM crypto_assets
    ORDER BY symbol ASC
    `
  );

  if (assets.length === 0) {
    return { marketMovePct: 0, regime: 'SIDEWAYS', leaders: [] };
  }

  const dayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
  const changes: Array<{ symbol: string; changePct: number }> = [];

  for (const asset of assets) {
    const currentPrice = parseNumber(asset.current_price, 0);
    const basePrice = parseNumber(asset.base_price, currentPrice);

    const history = await prisma.$queryRawUnsafe<Array<{ price: string | number }>>(
      `
      SELECT price
      FROM crypto_price_history
      WHERE asset_symbol = ? AND created_at >= ?
      ORDER BY created_at ASC
      LIMIT 1
      `,
      asset.symbol,
      dayAgo
    );

    const anchorPrice = history.length > 0 ? parseNumber(history[0].price, basePrice) : basePrice;
    const changePct = anchorPrice > 0 ? ((currentPrice - anchorPrice) / anchorPrice) * 100 : 0;
    changes.push({ symbol: asset.symbol, changePct: Number(changePct.toFixed(2)) });
  }

  const total = changes.reduce((acc, item) => acc + item.changePct, 0);
  const marketMovePct = Number((total / changes.length).toFixed(2));
  const leaders = [...changes]
    .sort((a, b) => Math.abs(b.changePct) - Math.abs(a.changePct))
    .slice(0, 3)
    .map((item) => item.symbol);

  return {
    marketMovePct,
    regime: detectMarketRegime(marketMovePct),
    leaders,
  };
}

async function notifyAllPlayersMarketRegime(regime: MarketRegime, marketMovePct: number): Promise<void> {
  const players = await prisma.player.findMany({ select: { id: true } });

  await Promise.allSettled(
    players.map((player) =>
      notificationService.sendCryptoMarketRegimeNotification(player.id, regime, marketMovePct)
    )
  );
}

async function notifyAllPlayersMarketNews(
  headline: string,
  impact: MarketNewsImpact,
  symbols: string[]
): Promise<void> {
  const players = await prisma.player.findMany({ select: { id: true } });

  await Promise.allSettled(
    players.map((player) =>
      notificationService.sendCryptoMarketNewsNotification(player.id, headline, impact, symbols)
    )
  );
}

async function publishMarketSignalsIfNeeded(): Promise<void> {
  const pulse = await calculateMarketPulse();

  const stateRows = await prisma.$queryRawUnsafe<
    Array<{ current_regime: string; last_regime_change_at: Date | null; last_news_at: Date | null }>
  >(
    `
    SELECT current_regime, last_regime_change_at, last_news_at
    FROM crypto_market_state
    WHERE id = 1
    LIMIT 1
    `
  );

  if (stateRows.length === 0) {
    return;
  }

  const state = stateRows[0];
  const now = Date.now();
  const lastRegimeChangeAt = state.last_regime_change_at ? new Date(state.last_regime_change_at).getTime() : 0;
  const lastNewsAt = state.last_news_at ? new Date(state.last_news_at).getTime() : 0;
  const currentRegime = String(state.current_regime || 'SIDEWAYS').toUpperCase() as MarketRegime;

  if (
    pulse.regime !== currentRegime &&
    now - lastRegimeChangeAt >= MARKET_REGIME_MIN_INTERVAL_MS
  ) {
    await prisma.$executeRawUnsafe(
      `
      UPDATE crypto_market_state
      SET current_regime = ?, last_regime_change_at = NOW(), updated_at = NOW()
      WHERE id = 1
      `,
      pulse.regime
    );

    await notifyAllPlayersMarketRegime(pulse.regime, pulse.marketMovePct);
  }

  if (now - lastNewsAt < MARKET_NEWS_MIN_INTERVAL_MS) {
    return;
  }

  // Keep market news informative but not noisy.
  if (Math.random() > 0.35) {
    return;
  }

  const impact = pickMarketNewsImpact(pulse.regime);
  const headline = buildMarketHeadline(impact, pulse.leaders, pulse.marketMovePct);

  await prisma.$executeRawUnsafe(
    `
    UPDATE crypto_market_state
    SET last_news_at = NOW(), updated_at = NOW()
    WHERE id = 1
    `
  );

  await notifyAllPlayersMarketNews(headline, impact, pulse.leaders);
}

async function updatePricesIfNeeded(): Promise<void> {
  await ensureSchemaAndSeed();

  type AssetRow = {
    symbol: string;
    base_price: string | number;
    current_price: string | number;
    volatility: string | number;
    trend_bias: string | number;
    updated_at: Date;
  };

  const rows = await prisma.$queryRawUnsafe<AssetRow[]>(
    'SELECT symbol, base_price, current_price, volatility, trend_bias, updated_at FROM crypto_assets'
  );

  const now = Date.now();

  for (const row of rows) {
    const basePrice = Math.max(parseNumber(row.base_price, 0), 0.000001);
    const currentPrice = clampPrice(parseNumber(row.current_price, basePrice), basePrice);
    const volatility = parseNumber(row.volatility, 0);
    const trendBias = parseNumber(row.trend_bias, 0);
    const updatedAtMs = new Date(row.updated_at).getTime();
    const elapsedSeconds = Math.max(0, Math.floor((now - updatedAtMs) / 1000));

    if (elapsedSeconds < 20) {
      continue;
    }

    const steps = Math.min(8, Math.max(1, Math.floor(elapsedSeconds / 20)));

    let nextPrice = currentPrice;
    for (let i = 0; i < steps; i += 1) {
      const randomPulse = (Math.random() * 2 - 1) * volatility;
      const cyclicalDrift = Math.sin((now / 600000) + i) * (volatility * 0.1);
      const deviationRatio = (nextPrice - basePrice) / basePrice;
      const meanReversion = Math.max(-12, Math.min(12, deviationRatio * -0.35));
      const pctMove = (randomPulse + trendBias + cyclicalDrift + meanReversion) / 100;
      nextPrice = clampPrice(nextPrice * (1 + pctMove), basePrice);
    }

    await prisma.$executeRawUnsafe(
      'UPDATE crypto_assets SET current_price = ?, updated_at = NOW() WHERE symbol = ?',
      nextPrice,
      row.symbol
    );

    await prisma.$executeRawUnsafe(
      'INSERT INTO crypto_price_history (asset_symbol, price) VALUES (?, ?)',
      row.symbol,
      nextPrice
    );
  }

  try {
    await publishMarketSignalsIfNeeded();
  } catch (error) {
    console.warn('[crypto] Failed to publish market signals:', error);
  }
}

function shouldFillOrder(
  orderType: CryptoOrderType,
  side: CryptoOrderSide,
  currentPrice: number,
  targetPrice: number
): boolean {
  if (orderType === 'LIMIT' && side === 'BUY') {
    return currentPrice <= targetPrice;
  }

  if (orderType === 'LIMIT' && side === 'SELL') {
    return currentPrice >= targetPrice;
  }

  if (orderType === 'STOP_LOSS') {
    return side === 'SELL' && currentPrice <= targetPrice;
  }

  if (orderType === 'TAKE_PROFIT') {
    return side === 'SELL' && currentPrice >= targetPrice;
  }

  return false;
}

async function getReservedBuyCash(
  playerId: number,
  tx?: Parameters<typeof prisma.$transaction>[0]
): Promise<number> {
  const db = tx ?? prisma;
  const rows = await db.$queryRawUnsafe<Array<{ reserved_cash: string | number }>>(
    `
    SELECT COALESCE(SUM(quantity * target_price), 0) AS reserved_cash
    FROM crypto_orders
    WHERE player_id = ?
      AND status = 'OPEN'
      AND side = 'BUY'
    `,
    playerId
  );

  return parseNumber(rows[0]?.reserved_cash, 0);
}

async function getReservedSellQuantity(
  playerId: number,
  symbol: string,
  tx?: Parameters<typeof prisma.$transaction>[0]
): Promise<number> {
  const db = tx ?? prisma;
  const rows = await db.$queryRawUnsafe<Array<{ reserved_quantity: string | number }>>(
    `
    SELECT COALESCE(SUM(quantity), 0) AS reserved_quantity
    FROM crypto_orders
    WHERE player_id = ?
      AND asset_symbol = ?
      AND status = 'OPEN'
      AND side = 'SELL'
    `,
    playerId,
    symbol
  );

  return parseNumber(rows[0]?.reserved_quantity, 0);
}

async function executeOrder(order: CryptoOrderRow): Promise<'FILLED' | 'FAILED' | 'SKIPPED'> {
  const quantity = parseNumber(order.quantity);
  const targetPrice = parseNumber(order.target_price);

  if (quantity <= 0 || targetPrice <= 0) {
    await prisma.$executeRawUnsafe(
      `
      UPDATE crypto_orders
      SET status = 'FAILED', failure_reason = 'INVALID_ORDER_DATA', updated_at = NOW()
      WHERE id = ?
      `,
      order.id
    );
    return 'FAILED';
  }

  try {
    const locked = await prisma.$executeRawUnsafe(
      `
      UPDATE crypto_orders
      SET status = 'EXECUTING', updated_at = NOW()
      WHERE id = ? AND status = 'OPEN'
      `,
      order.id
    );

    if (locked === 0) {
      return 'SKIPPED';
    }

    if (order.side === 'BUY') {
      const buyResult = await buyCrypto(order.player_id, order.asset_symbol, quantity);
      await prisma.$executeRawUnsafe(
        `
        UPDATE crypto_orders
        SET status = 'FILLED', filled_price = ?, failure_reason = NULL, updated_at = NOW()
        WHERE id = ?
        `,
        buyResult.price,
        order.id
      );

      await notificationService.sendCryptoOrderFilledNotification(
        order.player_id,
        order.asset_symbol,
        order.order_type,
        order.side,
        quantity,
        buyResult.price
      );
      await sendCryptoOrderFilledInboxMessage(
        order.player_id,
        order.asset_symbol,
        order.order_type,
        order.side,
        quantity,
        buyResult.price
      );
      return 'FILLED';
    }

    if (order.order_type === 'STOP_LOSS' || order.order_type === 'TAKE_PROFIT') {
      await notificationService.sendCryptoOrderTriggeredNotification(
        order.player_id,
        order.asset_symbol,
        order.order_type,
        targetPrice
      );
      await sendCryptoOrderTriggeredInboxMessage(
        order.player_id,
        order.asset_symbol,
        order.order_type,
        targetPrice
      );
    }

    const sellResult = await sellCrypto(order.player_id, order.asset_symbol, quantity);
    await prisma.$executeRawUnsafe(
      `
      UPDATE crypto_orders
      SET status = 'FILLED', filled_price = ?, failure_reason = NULL, updated_at = NOW()
      WHERE id = ?
      `,
      sellResult.price,
      order.id
    );

    await notificationService.sendCryptoOrderFilledNotification(
      order.player_id,
      order.asset_symbol,
      order.order_type,
      order.side,
      quantity,
      sellResult.price
    );
    await sendCryptoOrderFilledInboxMessage(
      order.player_id,
      order.asset_symbol,
      order.order_type,
      order.side,
      quantity,
      sellResult.price
    );
    return 'FILLED';
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'UNKNOWN_ERROR';

    await prisma.$executeRawUnsafe(
      `
      UPDATE crypto_orders
      SET status = 'FAILED', failure_reason = ?, updated_at = NOW()
      WHERE id = ?
      `,
      reason.slice(0, 120),
      order.id
    );
    return 'FAILED';
  }
}

async function processOpenOrders(): Promise<CryptoOrderProcessResult> {
  await ensureSchemaAndSeed();

  const openOrders = await prisma.$queryRawUnsafe<CryptoOrderRow[]>(
    `
    SELECT id, player_id, asset_symbol, order_type, side, quantity, target_price, status,
           filled_price, failure_reason, created_at, updated_at
    FROM crypto_orders
    WHERE status = 'OPEN'
    ORDER BY id ASC
    `
  );

  if (openOrders.length === 0) {
    return { processed: 0, filled: 0, failed: 0, remainingOpen: 0 };
  }

  const symbols = Array.from(new Set(openOrders.map((order) => order.asset_symbol)));
  const placeholders = symbols.map(() => '?').join(', ');
  const priceRows = await prisma.$queryRawUnsafe<Array<{ symbol: string; current_price: string | number }>>(
    `SELECT symbol, current_price FROM crypto_assets WHERE symbol IN (${placeholders})`,
    ...symbols
  );

  const priceBySymbol = new Map<string, number>();
  for (const row of priceRows) {
    priceBySymbol.set(row.symbol, parseNumber(row.current_price));
  }

  let processed = 0;
  let filled = 0;
  let failed = 0;

  for (const order of openOrders) {
    const currentPrice = priceBySymbol.get(order.asset_symbol);
    if (currentPrice === undefined) {
      continue;
    }

    const targetPrice = parseNumber(order.target_price);
    if (!shouldFillOrder(order.order_type, order.side, currentPrice, targetPrice)) {
      continue;
    }

    processed += 1;
    const outcome = await executeOrder(order);
    if (outcome === 'FILLED') {
      filled += 1;
    } else if (outcome === 'FAILED') {
      failed += 1;
    }
  }

  const remainingRows = await prisma.$queryRawUnsafe<Array<{ total: string | number }>>(
    `
    SELECT COUNT(*) AS total
    FROM crypto_orders
    WHERE status = 'OPEN'
    `
  );

  return {
    processed,
    filled,
    failed,
    remainingOpen: parseNumber(remainingRows[0]?.total, 0),
  };
}

export async function processOpenOrdersInBackground(): Promise<CryptoOrderProcessResult> {
  if (orderProcessorPromise) {
    return orderProcessorPromise;
  }

  orderProcessorPromise = (async () => {
    await updatePricesIfNeeded();
    const orderResult = await processOpenOrders();

    try {
      const leaderboardResult = await processWeeklyCryptoLeaderboardRewardsIfNeeded();
      if (leaderboardResult.processed && leaderboardResult.winners.length > 0) {
        console.log(
          `[crypto] Weekly leaderboard rewards paid to ${leaderboardResult.winners.length} winner(s)`
        );
      }
    } catch (error) {
      console.warn('[crypto] Failed to process weekly leaderboard rewards:', error);
    }

    return orderResult;
  })();

  try {
    return await orderProcessorPromise;
  } finally {
    orderProcessorPromise = null;
  }
}

export async function getMarket() {
  await processOpenOrdersInBackground();
  const pulse = await calculateMarketPulse();

  type MarketRow = {
    symbol: string;
    name: string;
    icon_key: string;
    base_price: string | number;
    current_price: string | number;
    volatility: string | number;
  };

  const rows = await prisma.$queryRawUnsafe<MarketRow[]>(`
    SELECT symbol, name, icon_key, base_price, current_price, volatility
    FROM crypto_assets
    ORDER BY symbol ASC
  `);

  const dayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);

  const market = await Promise.all(
    rows.map(async (row) => {
      const history = await prisma.$queryRawUnsafe<Array<{ price: string | number }>>(
        `
        SELECT price
        FROM crypto_price_history
        WHERE asset_symbol = ? AND created_at >= ?
        ORDER BY created_at ASC
        LIMIT 1
        `,
        row.symbol,
        dayAgo
      );

      const currentPrice = parseNumber(row.current_price);
      const price24h = history.length > 0 ? parseNumber(history[0].price, currentPrice) : parseNumber(row.base_price, currentPrice);
      const change24hPct = price24h > 0 ? ((currentPrice - price24h) / price24h) * 100 : 0;

      return {
        symbol: row.symbol,
        name: row.name,
        iconKey: row.icon_key,
        basePrice: parseNumber(row.base_price),
        currentPrice,
        volatility: parseNumber(row.volatility),
        price24h,
        change24hPct: Number(change24hPct.toFixed(2)),
      };
    })
  );

  return {
    market,
    marketSignals: {
      regime: pulse.regime,
      marketMovePct: pulse.marketMovePct,
      leaders: pulse.leaders,
    },
    generatedAt: new Date().toISOString(),
  };
}

export async function getPriceHistory(symbol: string, pointsInput?: number, hoursInput?: number) {
  await processOpenOrdersInBackground();

  const normalizedSymbol = symbol.trim().toUpperCase();
  if (!normalizedSymbol) {
    throw new Error('ASSET_NOT_FOUND');
  }

  const pointsLimit = Math.min(720, Math.max(20, Math.floor(Number(pointsInput) || 120)));
  const rawHours = Number(hoursInput);
  const useAllHistory = Number.isFinite(rawHours) && rawHours <= 0;
  const windowHours = useAllHistory
    ? null
    : Math.min(24 * 365, Math.max(1, Math.floor(rawHours || 24)));
  const windowStart = windowHours == null
    ? null
    : new Date(Date.now() - windowHours * 60 * 60 * 1000);

  const assetRows = await prisma.$queryRawUnsafe<
    Array<{ symbol: string; current_price: string | number; base_price: string | number }>
  >(
    `
    SELECT symbol, current_price, base_price
    FROM crypto_assets
    WHERE symbol = ?
    LIMIT 1
    `,
    normalizedSymbol
  );

  if (assetRows.length === 0) {
    throw new Error('ASSET_NOT_FOUND');
  }

  const historyRows = windowStart == null
    ? await prisma.$queryRawUnsafe<
        Array<{ price: string | number; created_at: Date }>
      >(
        `
        SELECT price, created_at
        FROM crypto_price_history
        WHERE asset_symbol = ?
        ORDER BY created_at ASC
        `,
        normalizedSymbol
      )
    : await prisma.$queryRawUnsafe<
        Array<{ price: string | number; created_at: Date }>
      >(
        `
        SELECT price, created_at
        FROM crypto_price_history
        WHERE asset_symbol = ?
          AND created_at >= ?
        ORDER BY created_at ASC
        `,
        normalizedSymbol,
        windowStart
      );

  const currentPrice = parseNumber(assetRows[0].current_price);
  const fallbackStartPrice = parseNumber(assetRows[0].base_price, currentPrice);
  const points: CryptoHistoryPoint[] = historyRows.map((row) => ({
    price: parseNumber(row.price),
    timestamp: new Date(row.created_at).toISOString(),
  }));

  const fallbackTimestamp = windowStart?.toISOString() ?? new Date().toISOString();

  if (points.length === 0) {
    points.push({
      price: fallbackStartPrice,
      timestamp: fallbackTimestamp,
    });
  } else if (windowStart != null && points[0].timestamp != windowStart.toISOString()) {
    points.unshift({
      price: points[0].price,
      timestamp: windowStart.toISOString(),
    });
  }

  if (points[points.length - 1].price !== currentPrice) {
    points.push({
      price: currentPrice,
      timestamp: new Date().toISOString(),
    });
  }

  const sampledPoints = downsampleHistoryPoints(points, pointsLimit);

  const first = sampledPoints[0].price;
  const last = sampledPoints[sampledPoints.length - 1].price;
  const changePct = first > 0 ? ((last - first) / first) * 100 : 0;

  return {
    symbol: normalizedSymbol,
    points: sampledPoints,
    stats: {
      windowHours,
      rangeMode: useAllHistory ? 'ALL' : 'WINDOW',
      firstPrice: Number(first.toFixed(8)),
      lastPrice: Number(last.toFixed(8)),
      changePct: Number(changePct.toFixed(2)),
      pointCount: sampledPoints.length,
    },
    generatedAt: new Date().toISOString(),
  };
}

export async function getPortfolio(playerId: number) {
  await processOpenOrdersInBackground();

  type HoldingRow = {
    asset_symbol: string;
    quantity: string | number;
    avg_buy_price: string | number;
    current_price: string | number;
    name: string;
    icon_key: string;
  };

  const rows = await prisma.$queryRawUnsafe<HoldingRow[]>(
    `
    SELECT h.asset_symbol, h.quantity, h.avg_buy_price, a.current_price, a.name, a.icon_key
    FROM crypto_holdings h
    INNER JOIN crypto_assets a ON a.symbol = h.asset_symbol
    WHERE h.player_id = ?
    ORDER BY h.asset_symbol ASC
    `,
    playerId
  );

  const holdings = rows.map((row) => {
    const quantity = parseNumber(row.quantity);
    const avgBuyPrice = parseNumber(row.avg_buy_price);
    const currentPrice = parseNumber(row.current_price);
    const marketValue = quantity * currentPrice;
    const costBasis = quantity * avgBuyPrice;
    const unrealizedProfit = marketValue - costBasis;

    return {
      symbol: row.asset_symbol,
      name: row.name,
      iconKey: row.icon_key,
      quantity: Number(quantity.toFixed(8)),
      avgBuyPrice,
      currentPrice,
      marketValue: Number(marketValue.toFixed(2)),
      costBasis: Number(costBasis.toFixed(2)),
      unrealizedProfit: Number(unrealizedProfit.toFixed(2)),
      unrealizedProfitPct:
        costBasis > 0 ? Number(((unrealizedProfit / costBasis) * 100).toFixed(2)) : 0,
    };
  });

  const totals = holdings.reduce(
    (acc, item) => {
      acc.marketValue += item.marketValue;
      acc.costBasis += item.costBasis;
      acc.unrealizedProfit += item.unrealizedProfit;
      return acc;
    },
    { marketValue: 0, costBasis: 0, unrealizedProfit: 0 }
  );

  const realizedProfitRows = await prisma.$queryRawUnsafe<Array<{ realized_profit: string | number }>>(
    `
    SELECT COALESCE(SUM(realized_profit), 0) AS realized_profit
    FROM crypto_transactions
    WHERE player_id = ? AND side = 'SELL'
    `,
    playerId
  );

  const realizedProfit = parseNumber(realizedProfitRows[0]?.realized_profit, 0);

  return {
    holdings,
    totals: {
      marketValue: Number(totals.marketValue.toFixed(2)),
      costBasis: Number(totals.costBasis.toFixed(2)),
      unrealizedProfit: Number(totals.unrealizedProfit.toFixed(2)),
      unrealizedProfitPct:
        totals.costBasis > 0
          ? Number(((totals.unrealizedProfit / totals.costBasis) * 100).toFixed(2))
          : 0,
      realizedProfit: Number(realizedProfit.toFixed(2)),
    },
  };
}

export async function getTransactionHistory(playerId: number, symbol: string, limitInput?: number) {
  await processOpenOrdersInBackground();

  const normalizedSymbol = symbol.trim().toUpperCase();
  if (!normalizedSymbol) {
    throw new Error('ASSET_NOT_FOUND');
  }

  const limit = Math.min(50, Math.max(5, Math.floor(Number(limitInput) || 15)));

  const assetRows = await prisma.$queryRawUnsafe<Array<{ symbol: string }>>(
    `
    SELECT symbol
    FROM crypto_assets
    WHERE symbol = ?
    LIMIT 1
    `,
    normalizedSymbol
  );

  if (assetRows.length === 0) {
    throw new Error('ASSET_NOT_FOUND');
  }

  type TransactionRow = {
    id: string | number;
    side: string;
    quantity: string | number;
    price: string | number;
    total_value: string | number;
    realized_profit: string | number;
    created_at: Date;
  };

  const rows = await prisma.$queryRawUnsafe<TransactionRow[]>(
    `
    SELECT id, side, quantity, price, total_value, realized_profit, created_at
    FROM crypto_transactions
    WHERE player_id = ? AND asset_symbol = ?
    ORDER BY created_at DESC, id DESC
    LIMIT ?
    `,
    playerId,
    normalizedSymbol,
    limit
  );

  const transactions = rows.map((row) => ({
    id: Number(row.id),
    side: row.side,
    quantity: Number(parseNumber(row.quantity, 0).toFixed(8)),
    price: Number(parseNumber(row.price, 0).toFixed(8)),
    totalValue: Number(parseNumber(row.total_value, 0).toFixed(2)),
    realizedProfit: Number(parseNumber(row.realized_profit, 0).toFixed(2)),
    createdAt: new Date(row.created_at).toISOString(),
  }));

  const holdingRows = await prisma.$queryRawUnsafe<Array<{ quantity: string | number; avg_buy_price: string | number }>>(
    `
    SELECT quantity, avg_buy_price
    FROM crypto_holdings
    WHERE player_id = ? AND asset_symbol = ?
    LIMIT 1
    `,
    playerId,
    normalizedSymbol
  );

  const holdingQuantity = parseNumber(holdingRows[0]?.quantity, 0);
  const avgBuyPrice = parseNumber(holdingRows[0]?.avg_buy_price, 0);
  const latestBuy = transactions.find((item) => item.side === 'BUY') ?? {
    id: 0,
    side: 'BUY',
    quantity: 0,
    price: 0,
    totalValue: 0,
    realizedProfit: 0,
    createdAt: '',
  };

  const totalBuySpent = transactions
    .filter((item) => item.side === 'BUY')
    .reduce((sum, item) => sum + item.totalValue, 0);
  const totalSellValue = transactions
    .filter((item) => item.side === 'SELL')
    .reduce((sum, item) => sum + item.totalValue, 0);

  return {
    symbol: normalizedSymbol,
    summary: {
      holdingQuantity: Number(holdingQuantity.toFixed(8)),
      avgBuyPrice: Number(avgBuyPrice.toFixed(8)),
      latestBuyPrice: latestBuy.price,
      latestBuyAt: latestBuy.createdAt,
      totalBuySpent: Number(totalBuySpent.toFixed(2)),
      totalSellValue: Number(totalSellValue.toFixed(2)),
      transactionCount: transactions.length,
    },
    transactions,
  };
}

export async function buyCrypto(playerId: number, symbol: string, quantityInput: number) {
  await updatePricesIfNeeded();
  const preferences = await playerNotificationPreferenceService.getPreferences(playerId);

  const quantity = Number(quantityInput);
  if (!Number.isFinite(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const normalizedSymbol = symbol.trim().toUpperCase();

  const result = await prisma.$transaction(async (tx) => {
    const assets = await tx.$queryRawUnsafe<Array<{ symbol: string; name: string; current_price: string | number }>>(
      'SELECT symbol, name, current_price FROM crypto_assets WHERE symbol = ? LIMIT 1',
      normalizedSymbol
    );

    if (assets.length === 0) {
      throw new Error('ASSET_NOT_FOUND');
    }

    const asset = assets[0];
    const price = parseNumber(asset.current_price);
    const totalCost = Number((price * quantity).toFixed(2));

    const player = await lockPlayerMoneyRow(tx, playerId);

    const reservedBuyCash = await getReservedBuyCash(playerId, tx);
    const availableMoney = player.money - reservedBuyCash;

    if (availableMoney + 0.000001 < totalCost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const existingHolding = await tx.$queryRawUnsafe<Array<{ quantity: string | number; avg_buy_price: string | number }>>(
      'SELECT quantity, avg_buy_price FROM crypto_holdings WHERE player_id = ? AND asset_symbol = ? LIMIT 1',
      playerId,
      normalizedSymbol
    );

    if (existingHolding.length === 0) {
      await tx.$executeRawUnsafe(
        `INSERT INTO crypto_holdings (player_id, asset_symbol, quantity, avg_buy_price) VALUES (?, ?, ?, ?)`,
        playerId,
        normalizedSymbol,
        Number(quantity.toFixed(8)),
        price
      );
    } else {
      const oldQty = parseNumber(existingHolding[0].quantity);
      const oldAvg = parseNumber(existingHolding[0].avg_buy_price);
      const newQty = oldQty + quantity;
      const newAvg = newQty > 0 ? ((oldQty * oldAvg) + (quantity * price)) / newQty : price;

      await tx.$executeRawUnsafe(
        `
        UPDATE crypto_holdings
        SET quantity = ?, avg_buy_price = ?, updated_at = NOW()
        WHERE player_id = ? AND asset_symbol = ?
        `,
        Number(newQty.toFixed(8)),
        newAvg,
        playerId,
        normalizedSymbol
      );
    }

    await tx.player.update({
      where: { id: playerId },
      data: { money: { decrement: totalCost } },
    });

    await tx.$executeRawUnsafe(
      `
      INSERT INTO crypto_transactions
      (player_id, asset_symbol, side, quantity, price, total_value, realized_profit)
      VALUES (?, ?, 'BUY', ?, ?, ?, 0)
      `,
      playerId,
      normalizedSymbol,
      Number(quantity.toFixed(8)),
      price,
      totalCost
    );

    if (preferences.inAppCryptoTrade) {
      await tx.worldEvent.create({
        data: {
          playerId,
          eventKey: 'crypto.buy',
          params: serializeWorldEventParams({
            symbol: normalizedSymbol,
            quantity: Number(quantity.toFixed(8)),
            price,
            totalCost,
          }),
        },
      });
    }

    return {
      symbol: normalizedSymbol,
      name: asset.name,
      quantity: Number(quantity.toFixed(8)),
      price,
      totalCost,
    };
  });

  const unlocked = await checkAndUnlockAchievements(playerId);
  const completedMissions = await processCryptoMissionProgress(playerId, {
    tradeCountDelta: 1,
    realizedProfitDelta: 0,
  });

  void notificationService.sendCryptoTradeNotification(
    playerId,
    'buy',
    result.symbol,
    result.quantity,
    result.totalCost
  ).catch((error) => {
    console.warn('[crypto] Failed to send buy notification:', error);
  });

  void sendCryptoTradeInboxMessage(
    playerId,
    'buy',
    result.symbol,
    result.quantity,
    result.price,
    result.totalCost
  ).catch((error) => {
    console.warn('[crypto] Failed to send buy inbox message:', error);
  });

  for (const mission of completedMissions) {
    void notificationService.sendCryptoMissionCompletedNotification(
      playerId,
      mission.missionType,
      mission.missionKey,
      mission.missionTitleEn,
      mission.missionTitleNl,
      mission.rewardMoney
    ).catch((error) => {
      console.warn('[crypto] Failed to send mission notification:', error);
    });

    void sendCryptoMissionCompletedInboxMessage(
      playerId,
      mission.missionType,
      mission.missionTitleEn,
      mission.missionTitleNl,
      mission.rewardMoney
    ).catch((error) => {
      console.warn('[crypto] Failed to send mission inbox message:', error);
    });
  }

  return {
    ...result,
    completedMissions: completedMissions.map((mission) => ({
      missionType: mission.missionType,
      missionKey: mission.missionKey,
      rewardMoney: mission.rewardMoney,
    })),
    newlyUnlockedAchievements: unlocked.map((item) =>
      serializeAchievementForClient(item.achievement)
    ),
  };
}

export async function sellCrypto(playerId: number, symbol: string, quantityInput: number) {
  await updatePricesIfNeeded();
  const preferences = await playerNotificationPreferenceService.getPreferences(playerId);

  const quantity = Number(quantityInput);
  if (!Number.isFinite(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  const normalizedSymbol = symbol.trim().toUpperCase();

  const result = await prisma.$transaction(async (tx) => {
    const assets = await tx.$queryRawUnsafe<Array<{ symbol: string; name: string; current_price: string | number }>>(
      'SELECT symbol, name, current_price FROM crypto_assets WHERE symbol = ? LIMIT 1',
      normalizedSymbol
    );

    if (assets.length === 0) {
      throw new Error('ASSET_NOT_FOUND');
    }

    const asset = assets[0];
    const price = parseNumber(asset.current_price);

    const holdingRow = await lockHoldingRow(tx, playerId, normalizedSymbol);

    const existingQty = parseNumber(holdingRow.quantity);
    const avgBuyPrice = parseNumber(holdingRow.avg_buy_price);

    const reservedSellQty = await getReservedSellQuantity(playerId, normalizedSymbol, tx);
    const availableQty = Math.max(0, existingQty - reservedSellQty);

    if (availableQty + 1e-8 < quantity) {
      throw new Error('NOT_ENOUGH_HOLDING');
    }

    const nextQty = existingQty - quantity;
    const totalValue = Number((quantity * price).toFixed(2));
    const realizedProfit = Number(((price - avgBuyPrice) * quantity).toFixed(2));

    if (nextQty <= 1e-8) {
      await tx.$executeRawUnsafe(
        'DELETE FROM crypto_holdings WHERE player_id = ? AND asset_symbol = ?',
        playerId,
        normalizedSymbol
      );
    } else {
      await tx.$executeRawUnsafe(
        'UPDATE crypto_holdings SET quantity = ?, updated_at = NOW() WHERE player_id = ? AND asset_symbol = ?',
        Number(nextQty.toFixed(8)),
        playerId,
        normalizedSymbol
      );
    }

    await tx.player.update({
      where: { id: playerId },
      data: { money: { increment: totalValue } },
    });

    await tx.$executeRawUnsafe(
      `
      INSERT INTO crypto_transactions
      (player_id, asset_symbol, side, quantity, price, total_value, realized_profit)
      VALUES (?, ?, 'SELL', ?, ?, ?, ?)
      `,
      playerId,
      normalizedSymbol,
      Number(quantity.toFixed(8)),
      price,
      totalValue,
      realizedProfit
    );

    if (preferences.inAppCryptoTrade) {
      await tx.worldEvent.create({
        data: {
          playerId,
          eventKey: 'crypto.sell',
          params: serializeWorldEventParams({
            symbol: normalizedSymbol,
            quantity: Number(quantity.toFixed(8)),
            price,
            totalValue,
            realizedProfit,
          }),
        },
      });
    }

    return {
      symbol: normalizedSymbol,
      name: asset.name,
      quantity: Number(quantity.toFixed(8)),
      price,
      totalValue,
      realizedProfit,
    };
  });

  const unlocked = await checkAndUnlockAchievements(playerId);
  const completedMissions = await processCryptoMissionProgress(playerId, {
    tradeCountDelta: 1,
    realizedProfitDelta: Math.max(0, result.realizedProfit),
  });

  void notificationService.sendCryptoTradeNotification(
    playerId,
    'sell',
    result.symbol,
    result.quantity,
    result.totalValue,
    result.realizedProfit
  ).catch((error) => {
    console.warn('[crypto] Failed to send sell notification:', error);
  });

  void sendCryptoTradeInboxMessage(
    playerId,
    'sell',
    result.symbol,
    result.quantity,
    result.price,
    result.totalValue,
    result.realizedProfit
  ).catch((error) => {
    console.warn('[crypto] Failed to send sell inbox message:', error);
  });

  for (const mission of completedMissions) {
    void notificationService.sendCryptoMissionCompletedNotification(
      playerId,
      mission.missionType,
      mission.missionKey,
      mission.missionTitleEn,
      mission.missionTitleNl,
      mission.rewardMoney
    ).catch((error) => {
      console.warn('[crypto] Failed to send mission notification:', error);
    });

    void sendCryptoMissionCompletedInboxMessage(
      playerId,
      mission.missionType,
      mission.missionTitleEn,
      mission.missionTitleNl,
      mission.rewardMoney
    ).catch((error) => {
      console.warn('[crypto] Failed to send mission inbox message:', error);
    });
  }

  return {
    ...result,
    completedMissions: completedMissions.map((mission) => ({
      missionType: mission.missionType,
      missionKey: mission.missionKey,
      rewardMoney: mission.rewardMoney,
    })),
    newlyUnlockedAchievements: unlocked.map((item) =>
      serializeAchievementForClient(item.achievement)
    ),
  };
}

export async function placeOrder(
  playerId: number,
  symbol: string,
  orderTypeInput: string,
  sideInput: string,
  quantityInput: number,
  targetPriceInput: number
) {
  await updatePricesIfNeeded();

  const normalizedSymbol = symbol.trim().toUpperCase();
  const orderType = orderTypeInput.trim().toUpperCase() as CryptoOrderType;
  const side = sideInput.trim().toUpperCase() as CryptoOrderSide;
  const quantity = Number(quantityInput);
  const targetPrice = Number(targetPriceInput);

  if (!normalizedSymbol) {
    throw new Error('ASSET_NOT_FOUND');
  }

  if (!Number.isFinite(quantity) || quantity <= 0) {
    throw new Error('INVALID_QUANTITY');
  }

  if (!Number.isFinite(targetPrice) || targetPrice <= 0) {
    throw new Error('INVALID_TARGET_PRICE');
  }

  if (!['LIMIT', 'STOP_LOSS', 'TAKE_PROFIT'].includes(orderType)) {
    throw new Error('INVALID_ORDER_TYPE');
  }

  if (!['BUY', 'SELL'].includes(side)) {
    throw new Error('INVALID_SIDE');
  }

  if ((orderType === 'STOP_LOSS' || orderType === 'TAKE_PROFIT') && side !== 'SELL') {
    throw new Error('INVALID_ORDER_COMBINATION');
  }

  const assets = await prisma.$queryRawUnsafe<Array<{ symbol: string; name: string }>>(
    'SELECT symbol, name FROM crypto_assets WHERE symbol = ? LIMIT 1',
    normalizedSymbol
  );

  if (assets.length === 0) {
    throw new Error('ASSET_NOT_FOUND');
  }

  await prisma.$transaction(async (tx) => {
    if (side === 'BUY') {
      const player = await lockPlayerMoneyRow(tx, playerId);
      const reservedBuyCash = await getReservedBuyCash(playerId, tx);
      const availableMoney = player.money - reservedBuyCash;
      const reservationCost = Number((quantity * targetPrice).toFixed(2));

      if (availableMoney + 0.000001 < reservationCost) {
        throw new Error('INSUFFICIENT_FUNDS');
      }
    }

    if (side === 'SELL') {
      const holdingRow = await lockHoldingRow(tx, playerId, normalizedSymbol);
      const heldQty = parseNumber(holdingRow.quantity);
      const reservedSellQty = await getReservedSellQuantity(playerId, normalizedSymbol, tx);
      const availableQty = Math.max(0, heldQty - reservedSellQty);

      if (availableQty + 1e-8 < quantity) {
        throw new Error('NOT_ENOUGH_HOLDING');
      }
    }

    await tx.$executeRawUnsafe(
      `
      INSERT INTO crypto_orders (player_id, asset_symbol, order_type, side, quantity, target_price, status)
      VALUES (?, ?, ?, ?, ?, ?, 'OPEN')
      `,
      playerId,
      normalizedSymbol,
      orderType,
      side,
      Number(quantity.toFixed(8)),
      targetPrice
    );
  });

  await processOpenOrdersInBackground();

  const orderRows = await prisma.$queryRawUnsafe<CryptoOrderRow[]>(
    `
    SELECT id, player_id, asset_symbol, order_type, side, quantity, target_price, status,
           filled_price, failure_reason, created_at, updated_at
    FROM crypto_orders
    WHERE player_id = ?
      AND asset_symbol = ?
      AND order_type = ?
      AND side = ?
      AND ABS(quantity - ?) < 0.00000002
      AND ABS(target_price - ?) < 0.00000002
    ORDER BY id DESC
    LIMIT 1
    `,
    playerId,
    normalizedSymbol,
    orderType,
    side,
    Number(quantity.toFixed(8)),
    targetPrice
  );

  if (orderRows.length === 0) {
    throw new Error('ORDER_PLACE_FAILED');
  }

  const placedOrder = orderRows[0];
  void sendCryptoOrderPlacedInboxMessage(
    playerId,
    placedOrder.asset_symbol,
    placedOrder.order_type,
    placedOrder.side,
    parseNumber(placedOrder.quantity),
    parseNumber(placedOrder.target_price)
  ).catch((error) => {
    console.warn('[crypto] Failed to send order placed inbox message:', error);
  });

  return {
    id: placedOrder.id,
    symbol: placedOrder.asset_symbol,
    name: assets[0].name,
    orderType: placedOrder.order_type,
    side: placedOrder.side,
    quantity: Number(parseNumber(placedOrder.quantity).toFixed(8)),
    targetPrice: parseNumber(placedOrder.target_price),
    status: placedOrder.status,
    filledPrice:
      placedOrder.filled_price === null ? null : parseNumber(placedOrder.filled_price),
    failureReason: placedOrder.failure_reason,
    createdAt: placedOrder.created_at.toISOString(),
    updatedAt: placedOrder.updated_at.toISOString(),
  };
}

export async function listOrders(playerId: number) {
  await processOpenOrdersInBackground();

  const rows = await prisma.$queryRawUnsafe<CryptoOrderRow[]>(
    `
    SELECT id, player_id, asset_symbol, order_type, side, quantity, target_price, status,
           filled_price, failure_reason, created_at, updated_at
    FROM crypto_orders
    WHERE player_id = ?
    ORDER BY created_at DESC
    `,
    playerId
  );

  return {
    orders: rows.map((row) => ({
      id: row.id,
      symbol: row.asset_symbol,
      orderType: row.order_type,
      side: row.side,
      quantity: Number(parseNumber(row.quantity).toFixed(8)),
      targetPrice: parseNumber(row.target_price),
      status: row.status,
      filledPrice: row.filled_price === null ? null : parseNumber(row.filled_price),
      failureReason: row.failure_reason,
      createdAt: row.created_at.toISOString(),
      updatedAt: row.updated_at.toISOString(),
    })),
  };
}

export async function cancelOrder(playerId: number, orderIdInput: number) {
  await ensureSchemaAndSeed();

  const orderId = Number(orderIdInput);
  if (!Number.isInteger(orderId) || orderId <= 0) {
    throw new Error('INVALID_ORDER_ID');
  }

  const orderRows = await prisma.$queryRawUnsafe<CryptoOrderRow[]>(
    `
    SELECT id, player_id, asset_symbol, order_type, side, quantity, target_price, status,
           filled_price, failure_reason, created_at, updated_at
    FROM crypto_orders
    WHERE id = ? AND player_id = ?
    LIMIT 1
    `,
    orderId,
    playerId
  );

  const targetOrder = orderRows[0];

  const updated = await prisma.$executeRawUnsafe(
    `
    UPDATE crypto_orders
    SET status = 'CANCELLED', updated_at = NOW()
    WHERE id = ? AND player_id = ? AND status = 'OPEN'
    `,
    orderId,
    playerId
  );

  if (updated === 0) {
    throw new Error('ORDER_NOT_FOUND_OR_NOT_OPEN');
  }

  if (targetOrder) {
    void sendCryptoOrderCancelledInboxMessage(
      playerId,
      targetOrder.asset_symbol,
      targetOrder.order_type,
      targetOrder.side,
      parseNumber(targetOrder.quantity),
      parseNumber(targetOrder.target_price)
    ).catch((error) => {
      console.warn('[crypto] Failed to send order cancelled inbox message:', error);
    });
  }

  return { orderId, status: 'CANCELLED' as const };
}
