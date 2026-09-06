/**
 * Player-to-player listings on the Zwarte Markt “Marktplaats” tab (non-vehicle).
 * Vehicles remain VehicleInventory.marketListing — see blackMarketService.
 *
 * Four kinds share the player_market_listings table:
 *   player_tool    — the PlayerTools row itself changes owner (refId = PlayerTools.id, quantity = 1)
 *   drug_lot       — grams debited from DrugInventory and held in the listing
 *   crypto_lot     — decimal amount debited from crypto_holdings and held in the listing
 *   trade_good_lot — units debited from Inventory and held in the listing
 *   event_item     — units debited from player_event_items and held in the listing
 *
 * The three lot kinds are escrowed: the source row is debited when listing, credited back
 * when delisting, and credited to the buyer on purchase. Their payload lives in `meta`
 * (JSON) plus the integer `quantity` column.
 */

import prisma from '../lib/prisma';
import toolService from './toolService';
import drugService from './drugService';
import { drugFacilityService } from './drugFacilityService';
import type { DrugQuality } from './drugFacilityService';
import { getGoodById } from './tradeService';
import {
  creditEventItem,
  debitEventItem,
  getEventItemDefinition,
} from './eventItemService';

export const MARKET_LISTING_KIND_PLAYER_TOOL = 'player_tool';
export const MARKET_LISTING_KIND_DRUG_LOT = 'drug_lot';
export const MARKET_LISTING_KIND_CRYPTO_LOT = 'crypto_lot';
export const MARKET_LISTING_KIND_TRADE_GOOD_LOT = 'trade_good_lot';
export const MARKET_LISTING_KIND_EVENT_ITEM = 'event_item';

/** Crypto amounts are decimal; the integer `quantity` column stores a scaled copy for sorting. */
const CRYPTO_QUANTITY_SCALE = 10_000;
const CRYPTO_EPSILON = 1e-8;

const PRICE_FLOOR_RATIO = 0.1;
const PRICE_CEIL_RATIO = 8;

type TransactionClient = Parameters<Parameters<typeof prisma.$transaction>[0]>[0];

interface ListingRow {
  id: number;
  sellerId: number;
  kind: string;
  refId: number;
  quantity: number;
  meta: string | null;
  price: number;
  status: string;
  countryCode: string | null;
  createdAt: Date;
  seller?: { id: number; username: string };
}

interface DrugLotMeta {
  drugType: string;
  quality: string;
  unitPrice: number;
}

interface CryptoLotMeta {
  assetSymbol: string;
  quantity: string;
  avgBuyPrice: number;
}

interface TradeGoodLotMeta {
  goodType: string;
  country?: string;
  condition: number;
  unitPurchasePrice: number;
  purchasedAt: string | null;
}

interface EventItemLotMeta {
  itemKey: string;
  unitPrice: number;
  nameEn: string;
  nameNl: string;
}

interface ListResult {
  success: boolean;
  message: string;
  listingId?: number;
}

function priceBounds(reference: number): { min: number; max: number } {
  const safe = Math.max(1, reference);
  return {
    min: Math.max(1, Math.floor(safe * PRICE_FLOOR_RATIO)),
    max: Math.max(1, Math.floor(safe * PRICE_CEIL_RATIO)),
  };
}

function outOfBounds(price: number, reference: number): ListResult | null {
  const { min, max } = priceBounds(reference);
  if (!Number.isFinite(price) || price < min || price > max) {
    return { success: false, message: `Price must be between €${min} and €${max}` };
  }
  return null;
}

function parseMeta<T>(raw: string | null): T | null {
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === 'object' ? (parsed as T) : null;
  } catch {
    return null;
  }
}

function toNumber(input: unknown, fallback = 0): number {
  const value = Number(input);
  return Number.isFinite(value) ? value : fallback;
}

function requirePositiveInt(value: unknown): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || !Number.isInteger(parsed) || parsed <= 0) {
    throw new Error('INVALID_QUANTITY');
  }
  return parsed;
}

function normalizeCryptoQuantity(value: unknown): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed <= 0) {
    throw new Error('INVALID_QUANTITY');
  }
  const rounded = Number(parsed.toFixed(8));
  if (rounded <= 0) {
    throw new Error('INVALID_QUANTITY');
  }
  return rounded;
}

/** "1.5" rather than "1.50000000" so the meta payload stays readable. */
function formatCryptoQuantity(value: number): string {
  return String(Number(value.toFixed(8)));
}

async function getSellerCountry(playerId: number): Promise<string | null> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  return player?.currentCountry ?? null;
}

/** Current market price of an asset, or null when crypto tables are not provisioned yet. */
async function getCryptoCurrentPrice(symbol: string): Promise<number | null> {
  try {
    const rows = await prisma.$queryRawUnsafe<Array<{ current_price: string | number }>>(
      'SELECT current_price FROM crypto_assets WHERE symbol = ? LIMIT 1',
      symbol,
    );
    if (rows.length === 0) return null;
    const price = toNumber(rows[0].current_price, 0);
    return price > 0 ? price : null;
  } catch {
    return null;
  }
}

/** Amount already committed to OPEN sell orders, which must stay in the holding. */
async function getReservedCryptoQuantity(
  db: TransactionClient | typeof prisma,
  playerId: number,
  symbol: string,
): Promise<number> {
  try {
    const rows = await db.$queryRawUnsafe<Array<{ reserved_quantity: string | number }>>(
      `
      SELECT COALESCE(SUM(quantity), 0) AS reserved_quantity
      FROM crypto_orders
      WHERE player_id = ? AND asset_symbol = ? AND status = 'OPEN' AND side = 'SELL'
      `,
      playerId,
      symbol,
    );
    return rows.length > 0 ? toNumber(rows[0].reserved_quantity, 0) : 0;
  } catch {
    return 0;
  }
}

async function readCryptoHolding(
  db: TransactionClient | typeof prisma,
  playerId: number,
  symbol: string,
  lockRow: boolean,
): Promise<{ quantity: number; avgBuyPrice: number } | null> {
  const rows = await db.$queryRawUnsafe<
    Array<{ quantity: string | number; avg_buy_price: string | number }>
  >(
    `SELECT quantity, avg_buy_price FROM crypto_holdings WHERE player_id = ? AND asset_symbol = ? LIMIT 1${
      lockRow ? ' FOR UPDATE' : ''
    }`,
    playerId,
    symbol,
  );
  if (rows.length === 0) return null;
  return {
    quantity: toNumber(rows[0].quantity, 0),
    avgBuyPrice: toNumber(rows[0].avg_buy_price, 0),
  };
}

/** Adds `quantity` to a holding, blending avg_buy_price so P/L stays meaningful. */
async function creditCryptoHolding(
  tx: TransactionClient,
  playerId: number,
  symbol: string,
  quantity: number,
  avgBuyPrice: number,
): Promise<void> {
  const existing = await readCryptoHolding(tx, playerId, symbol, true);

  if (!existing) {
    await tx.$executeRawUnsafe(
      'INSERT INTO crypto_holdings (player_id, asset_symbol, quantity, avg_buy_price) VALUES (?, ?, ?, ?)',
      playerId,
      symbol,
      Number(quantity.toFixed(8)),
      avgBuyPrice,
    );
    return;
  }

  const nextQty = existing.quantity + quantity;
  const nextAvg =
    nextQty > 0
      ? (existing.quantity * existing.avgBuyPrice + quantity * avgBuyPrice) / nextQty
      : avgBuyPrice;

  await tx.$executeRawUnsafe(
    'UPDATE crypto_holdings SET quantity = ?, avg_buy_price = ?, updated_at = NOW() WHERE player_id = ? AND asset_symbol = ?',
    Number(nextQty.toFixed(8)),
    nextAvg,
    playerId,
    symbol,
  );
}

/**
 * Moves money from buyer to seller inside a transaction, locking the buyer row first.
 */
async function settlePayment(
  tx: TransactionClient,
  buyerId: number,
  sellerId: number,
  price: number,
): Promise<number> {
  const rows = await tx.$queryRawUnsafe<Array<{ money: number | string }>>(
    'SELECT money FROM players WHERE id = ? FOR UPDATE',
    buyerId,
  );
  if (rows.length === 0) {
    throw new Error('PLAYER_NOT_FOUND');
  }
  const money = toNumber(rows[0].money, 0);
  if (money < price) {
    throw new Error('INSUFFICIENT_FUNDS');
  }

  await tx.player.update({ where: { id: buyerId }, data: { money: money - price } });
  await tx.player.update({ where: { id: sellerId }, data: { money: { increment: price } } });

  return money - price;
}

/** Claims the listing so two concurrent buyers cannot both take it. */
async function claimListing(
  tx: TransactionClient,
  listingId: number,
  buyerId: number,
): Promise<void> {
  const claimed = await tx.playerMarketListing.updateMany({
    where: { id: listingId, status: 'active' },
    data: { status: 'sold', buyerId, soldAt: new Date() },
  });
  if (claimed.count === 0) {
    throw new Error('NOT_FOR_SALE');
  }
}

async function serializeToolListing(row: ListingRow) {
  const pt = await prisma.playerTools.findUnique({
    where: { id: row.refId },
    include: { tool: true },
  });
  if (!pt) return null;
  const def = toolService.getToolDefinition(pt.toolId);
  return {
    listingId: row.id,
    kind: row.kind,
    price: row.price,
    quantity: row.quantity,
    countryCode: row.countryCode,
    createdAt: row.createdAt,
    seller: row.seller,
    playerTool: {
      id: pt.id,
      toolId: pt.toolId,
      durability: pt.durability,
      location: pt.location,
      quantity: pt.quantity,
    },
    toolDefinition: def
      ? {
          id: def.id,
          name: def.name,
          type: def.type,
          basePrice: def.basePrice,
          maxDurability: def.maxDurability,
        }
      : null,
  };
}

function serializeDrugLotListing(row: ListingRow) {
  const meta = parseMeta<DrugLotMeta>(row.meta);
  if (!meta) return null;
  const def = drugService.getDrugDefinition(meta.drugType);
  const tier = drugFacilityService.getQualityTier((meta.quality ?? 'C') as DrugQuality);
  return {
    listingId: row.id,
    kind: row.kind,
    price: row.price,
    quantity: row.quantity,
    countryCode: row.countryCode,
    createdAt: row.createdAt,
    seller: row.seller,
    drugLot: {
      drugType: meta.drugType,
      drugName: def?.displayName ?? meta.drugType,
      quality: meta.quality ?? 'C',
      qualityLabel: tier?.label ?? (meta.quality ?? 'C'),
      unitPrice: meta.unitPrice,
      quantity: row.quantity,
    },
  };
}

function serializeCryptoLotListing(row: ListingRow) {
  const meta = parseMeta<CryptoLotMeta>(row.meta);
  if (!meta) return null;
  return {
    listingId: row.id,
    kind: row.kind,
    price: row.price,
    quantity: row.quantity,
    countryCode: row.countryCode,
    createdAt: row.createdAt,
    seller: row.seller,
    cryptoLot: {
      assetSymbol: meta.assetSymbol,
      quantity: meta.quantity,
      avgBuyPrice: meta.avgBuyPrice,
    },
  };
}

function serializeTradeGoodLotListing(row: ListingRow) {
  const meta = parseMeta<TradeGoodLotMeta>(row.meta);
  if (!meta) return null;
  const good = getGoodById(meta.goodType);
  return {
    listingId: row.id,
    kind: row.kind,
    price: row.price,
    quantity: row.quantity,
    countryCode: row.countryCode,
    createdAt: row.createdAt,
    seller: row.seller,
    tradeGoodLot: {
      goodType: meta.goodType,
      goodName: good?.name ?? meta.goodType,
      condition: meta.condition,
      quantity: row.quantity,
      unitBasePrice: good?.basePrice ?? 0,
    },
  };
}

function serializeEventItemListing(row: ListingRow) {
  const meta = parseMeta<EventItemLotMeta>(row.meta);
  if (!meta) return null;
  const def = getEventItemDefinition(meta.itemKey);
  return {
    listingId: row.id,
    kind: row.kind,
    price: row.price,
    quantity: row.quantity,
    countryCode: row.countryCode,
    createdAt: row.createdAt,
    seller: row.seller,
    eventItemLot: {
      itemKey: meta.itemKey,
      nameEn: meta.nameEn || def?.nameEn || meta.itemKey,
      nameNl: meta.nameNl || def?.nameNl || meta.itemKey,
      unitPrice: meta.unitPrice,
      quantity: row.quantity,
      bound: false,
    },
  };
}

/**
 * Serializes any listing kind. Tool listings whose backing row vanished are cancelled
 * (their "escrow" is the row itself); lot kinds always hold their own payload.
 */
async function serializeListing(row: ListingRow): Promise<unknown | null> {
  switch (row.kind) {
    case MARKET_LISTING_KIND_PLAYER_TOOL: {
      const pt = await prisma.playerTools.findUnique({ where: { id: row.refId } });
      if (!pt || pt.playerId !== row.sellerId) {
        await prisma.playerMarketListing.update({
          where: { id: row.id },
          data: { status: 'cancelled' },
        });
        return null;
      }
      return serializeToolListing(row);
    }
    case MARKET_LISTING_KIND_DRUG_LOT:
      return serializeDrugLotListing(row);
    case MARKET_LISTING_KIND_CRYPTO_LOT:
      return serializeCryptoLotListing(row);
    case MARKET_LISTING_KIND_TRADE_GOOD_LOT:
      return serializeTradeGoodLotListing(row);
    case MARKET_LISTING_KIND_EVENT_ITEM:
      return serializeEventItemListing(row);
    default:
      return null;
  }
}

export const playerMarketplaceService = {
  MARKET_LISTING_KIND_PLAYER_TOOL,
  MARKET_LISTING_KIND_DRUG_LOT,
  MARKET_LISTING_KIND_CRYPTO_LOT,
  MARKET_LISTING_KIND_TRADE_GOOD_LOT,

  /** All active listings of every kind, serialized polymorphically. */
  async getActiveItemListings(country?: string) {
    const rows = await prisma.playerMarketListing.findMany({
      where: {
        status: 'active',
        ...(country ? { countryCode: country } : {}),
      },
      include: { seller: { select: { id: true, username: true } } },
      orderBy: { createdAt: 'desc' },
    });

    const out: unknown[] = [];
    for (const row of rows) {
      const serialized = await serializeListing(row);
      if (serialized) out.push(serialized);
    }
    return out;
  },

  /** Legacy accessor kept for callers that only care about tools. */
  async getActiveToolListings(country?: string) {
    const rows = await prisma.playerMarketListing.findMany({
      where: {
        status: 'active',
        kind: MARKET_LISTING_KIND_PLAYER_TOOL,
        ...(country ? { countryCode: country } : {}),
      },
      include: { seller: { select: { id: true, username: true } } },
      orderBy: { createdAt: 'desc' },
    });

    const out: unknown[] = [];
    for (const row of rows) {
      const serialized = await serializeListing(row);
      if (serialized) out.push(serialized);
    }
    return out;
  },

  async getSellerActiveListings(playerId: number) {
    const rows = await prisma.playerMarketListing.findMany({
      where: { sellerId: playerId, status: 'active' },
      include: { seller: { select: { id: true, username: true } } },
      orderBy: { createdAt: 'desc' },
    });

    const out: unknown[] = [];
    for (const row of rows) {
      const serialized = await serializeListing(row);
      if (serialized) out.push(serialized);
    }
    return out;
  },

  async listPlayerTool(playerId: number, playerToolId: number, price: number): Promise<ListResult> {
    const pt = await prisma.playerTools.findUnique({
      where: { id: playerToolId },
      include: { tool: true },
    });
    if (!pt || pt.playerId !== playerId) {
      throw new Error('TOOL_NOT_FOUND');
    }
    if (pt.location !== 'carried') {
      throw new Error('TOOL_NOT_CARRIED');
    }
    if (pt.durability <= 0) {
      throw new Error('TOOL_BROKEN');
    }

    const dup = await prisma.playerMarketListing.findFirst({
      where: {
        kind: MARKET_LISTING_KIND_PLAYER_TOOL,
        refId: playerToolId,
        status: 'active',
      },
    });
    if (dup) {
      throw new Error('ALREADY_LISTED');
    }

    const def = toolService.getToolDefinition(pt.toolId);
    if (!def) {
      throw new Error('INVALID_TOOL');
    }

    const rejected = outOfBounds(price, def.basePrice);
    if (rejected) return rejected;

    const listing = await prisma.playerMarketListing.create({
      data: {
        sellerId: playerId,
        kind: MARKET_LISTING_KIND_PLAYER_TOOL,
        refId: playerToolId,
        quantity: 1,
        meta: null,
        price,
        status: 'active',
        countryCode: await getSellerCountry(playerId),
      },
    });

    return { success: true, message: 'Listed', listingId: listing.id };
  },

  /** Escrows grams out of DrugInventory into a new listing. */
  async listDrugLot(
    playerId: number,
    drugInventoryId: number,
    quantityInput: number,
    price: number,
  ): Promise<ListResult> {
    const quantity = requirePositiveInt(quantityInput);

    const row = await prisma.drugInventory.findUnique({ where: { id: drugInventoryId } });
    if (!row || row.playerId !== playerId) {
      throw new Error('DRUG_NOT_FOUND');
    }
    if (row.quantity < quantity) {
      throw new Error('INSUFFICIENT_QTY');
    }

    const quality = row.quality ?? 'C';
    const def = drugService.getDrugDefinition(row.drugType);
    const tier = drugFacilityService.getQualityTier(quality as DrugQuality);
    const unitPrice = Math.max(
      1,
      Math.round((def?.basePrice ?? 0) * (tier?.priceMultiplier ?? 1)),
    );

    const rejected = outOfBounds(price, unitPrice * quantity);
    if (rejected) return rejected;

    const countryCode = await getSellerCountry(playerId);

    const meta: DrugLotMeta = { drugType: row.drugType, quality, unitPrice };

    const listing = await prisma.$transaction(async (tx) => {
      const debited = await tx.drugInventory.updateMany({
        where: { id: drugInventoryId, playerId, quantity: { gte: quantity } },
        data: { quantity: { decrement: quantity } },
      });
      if (debited.count === 0) {
        throw new Error('INSUFFICIENT_QTY');
      }

      return tx.playerMarketListing.create({
        data: {
          sellerId: playerId,
          kind: MARKET_LISTING_KIND_DRUG_LOT,
          refId: drugInventoryId,
          quantity,
          meta: JSON.stringify(meta),
          price,
          status: 'active',
          countryCode,
        },
      });
    });

    return { success: true, message: 'Listed', listingId: listing.id };
  },

  /** Escrows a decimal amount out of crypto_holdings into a new listing. */
  async listCryptoLot(
    playerId: number,
    assetSymbolInput: string,
    quantityInput: number | string,
    price: number,
  ): Promise<ListResult> {
    const assetSymbol = String(assetSymbolInput ?? '').trim().toUpperCase();
    if (!assetSymbol) {
      throw new Error('CRYPTO_ASSET_NOT_FOUND');
    }
    const quantity = normalizeCryptoQuantity(quantityInput);

    const [preview, reserved] = await Promise.all([
      readCryptoHolding(prisma, playerId, assetSymbol, false),
      getReservedCryptoQuantity(prisma, playerId, assetSymbol),
    ]);
    if (!preview || preview.quantity - reserved + CRYPTO_EPSILON < quantity) {
      throw new Error('CRYPTO_NOT_ENOUGH');
    }

    const marketPrice = await getCryptoCurrentPrice(assetSymbol);
    const referenceUnit = marketPrice ?? preview.avgBuyPrice;
    const rejected = outOfBounds(price, referenceUnit * quantity);
    if (rejected) return rejected;

    const countryCode = await getSellerCountry(playerId);

    const listing = await prisma.$transaction(async (tx) => {
      const holding = await readCryptoHolding(tx, playerId, assetSymbol, true);
      const reservedNow = await getReservedCryptoQuantity(tx, playerId, assetSymbol);
      if (!holding || holding.quantity - reservedNow + CRYPTO_EPSILON < quantity) {
        throw new Error('CRYPTO_NOT_ENOUGH');
      }

      const nextQty = holding.quantity - quantity;
      if (nextQty <= CRYPTO_EPSILON) {
        await tx.$executeRawUnsafe(
          'DELETE FROM crypto_holdings WHERE player_id = ? AND asset_symbol = ?',
          playerId,
          assetSymbol,
        );
      } else {
        await tx.$executeRawUnsafe(
          'UPDATE crypto_holdings SET quantity = ?, updated_at = NOW() WHERE player_id = ? AND asset_symbol = ?',
          Number(nextQty.toFixed(8)),
          playerId,
          assetSymbol,
        );
      }

      const meta: CryptoLotMeta = {
        assetSymbol,
        quantity: formatCryptoQuantity(quantity),
        avgBuyPrice: holding.avgBuyPrice,
      };

      return tx.playerMarketListing.create({
        data: {
          sellerId: playerId,
          kind: MARKET_LISTING_KIND_CRYPTO_LOT,
          refId: 0,
          quantity: Math.max(1, Math.round(quantity * CRYPTO_QUANTITY_SCALE)),
          meta: JSON.stringify(meta),
          price,
          status: 'active',
          countryCode,
        },
      });
    });

    return { success: true, message: 'Listed', listingId: listing.id };
  },

  /** Escrows units out of Inventory into a new listing. */
  async listTradeGoodLot(
    playerId: number,
    inventoryId: number,
    quantityInput: number,
    price: number,
  ): Promise<ListResult> {
    const quantity = requirePositiveInt(quantityInput);

    const row = await prisma.inventory.findUnique({ where: { id: inventoryId } });
    if (!row || row.playerId !== playerId) {
      throw new Error('TRADE_GOOD_NOT_FOUND');
    }
    const good = getGoodById(row.goodType);
    if (!good) {
      throw new Error('INVALID_GOOD');
    }
    if (row.quantity < quantity) {
      throw new Error('INSUFFICIENT_QTY');
    }

    const rejected = outOfBounds(price, good.basePrice * quantity);
    if (rejected) return rejected;

    const countryCode = await getSellerCountry(playerId);
    if (!countryCode || row.country !== countryCode) {
      throw new Error('TRADE_GOOD_NOT_IN_COUNTRY');
    }
    const meta: TradeGoodLotMeta = {
      goodType: row.goodType,
      country: row.country,
      condition: row.condition ?? 100,
      unitPurchasePrice: row.purchasePrice ?? 0,
      purchasedAt: row.purchasedAt ? new Date(row.purchasedAt).toISOString() : null,
    };

    const listing = await prisma.$transaction(async (tx) => {
      const debited = await tx.inventory.updateMany({
        where: { id: inventoryId, playerId, quantity: { gte: quantity } },
        data: { quantity: { decrement: quantity } },
      });
      if (debited.count === 0) {
        throw new Error('INSUFFICIENT_QTY');
      }
      // tradeService drops emptied rows; keep the same convention so the trade UI stays clean.
      await tx.inventory.deleteMany({ where: { id: inventoryId, quantity: { lte: 0 } } });

      return tx.playerMarketListing.create({
        data: {
          sellerId: playerId,
          kind: MARKET_LISTING_KIND_TRADE_GOOD_LOT,
          refId: inventoryId,
          quantity,
          meta: JSON.stringify(meta),
          price,
          status: 'active',
          countryCode,
        },
      });
    });

    return { success: true, message: 'Listed', listingId: listing.id };
  },

  /** Escrows transferable event collectables into a new listing. */
  async listEventItem(
    playerId: number,
    eventItemId: number,
    quantityInput: number,
    price: number,
  ): Promise<ListResult> {
    const quantity = requirePositiveInt(quantityInput);

    const row = await prisma.playerEventItem.findUnique({ where: { id: eventItemId } });
    if (!row || row.playerId !== playerId) {
      throw new Error('EVENT_ITEM_NOT_FOUND');
    }
    const def = getEventItemDefinition(row.itemKey);
    if (!def) {
      throw new Error('EVENT_ITEM_UNKNOWN');
    }
    if (def.bound) {
      throw new Error('EVENT_ITEM_BOUND');
    }
    if (row.quantity < quantity) {
      throw new Error('INSUFFICIENT_QTY');
    }

    const rejected = outOfBounds(price, def.referenceUnitPrice * quantity);
    if (rejected) return rejected;

    const countryCode = await getSellerCountry(playerId);
    const meta: EventItemLotMeta = {
      itemKey: row.itemKey,
      unitPrice: def.referenceUnitPrice,
      nameEn: def.nameEn,
      nameNl: def.nameNl,
    };

    const listing = await prisma.$transaction(async (tx) => {
      await debitEventItem(tx, playerId, row.itemKey, quantity);
      return tx.playerMarketListing.create({
        data: {
          sellerId: playerId,
          kind: MARKET_LISTING_KIND_EVENT_ITEM,
          refId: eventItemId,
          quantity,
          meta: JSON.stringify(meta),
          price,
          status: 'active',
          countryCode,
        },
      });
    });

    return { success: true, message: 'Listed', listingId: listing.id };
  },

  /** Cancels a listing and returns any escrowed goods to the seller. */
  async delist(playerId: number, listingId: number) {
    const row = await prisma.playerMarketListing.findUnique({ where: { id: listingId } });
    if (!row) {
      throw new Error('LISTING_NOT_FOUND');
    }
    if (row.sellerId !== playerId) {
      throw new Error('NOT_OWNER');
    }
    if (row.status !== 'active') {
      throw new Error('NOT_ACTIVE');
    }

    await prisma.$transaction(async (tx) => {
      const cancelled = await tx.playerMarketListing.updateMany({
        where: { id: listingId, status: 'active' },
        data: { status: 'cancelled' },
      });
      if (cancelled.count === 0) {
        throw new Error('NOT_ACTIVE');
      }

      await restoreEscrow(tx, row);
    });

    return { success: true as const };
  },

  async buyListing(
    buyerId: number,
    listingId: number,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const listing = await prisma.playerMarketListing.findUnique({
      where: { id: listingId },
      include: { seller: { select: { id: true, username: true } } },
    });

    if (!listing || listing.status !== 'active') {
      throw new Error('NOT_FOR_SALE');
    }
    if (listing.sellerId === buyerId) {
      throw new Error('CANNOT_BUY_OWN');
    }

    switch (listing.kind) {
      case MARKET_LISTING_KIND_PLAYER_TOOL:
        return this._buyPlayerToolListing(buyerId, listing);
      case MARKET_LISTING_KIND_DRUG_LOT:
        return this._buyDrugLotListing(buyerId, listing);
      case MARKET_LISTING_KIND_CRYPTO_LOT:
        return this._buyCryptoLotListing(buyerId, listing);
      case MARKET_LISTING_KIND_TRADE_GOOD_LOT:
        return this._buyTradeGoodLotListing(buyerId, listing);
      case MARKET_LISTING_KIND_EVENT_ITEM:
        return this._buyEventItemListing(buyerId, listing);
      default:
        throw new Error('UNSUPPORTED_KIND');
    }
  },

  async _buyPlayerToolListing(
    buyerId: number,
    listing: ListingRow,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const pt = await prisma.playerTools.findUnique({
      where: { id: listing.refId },
      include: { tool: true },
    });

    if (!pt || pt.playerId !== listing.sellerId) {
      await prisma.playerMarketListing.update({
        where: { id: listing.id },
        data: { status: 'cancelled' },
      });
      throw new Error('LISTING_STALE');
    }

    const canCarry = await toolService.canCarryTool(buyerId, pt.toolId, pt.quantity);
    if (!canCarry) {
      throw new Error('INVENTORY_FULL');
    }

    const result = await prisma.$transaction(async (tx) => {
      await claimListing(tx, listing.id, buyerId);
      const newMoney = await settlePayment(tx, buyerId, listing.sellerId, listing.price);

      const existingBuyerCarried = await tx.playerTools.findFirst({
        where: { playerId: buyerId, toolId: pt.toolId, location: pt.location },
      });

      if (existingBuyerCarried && existingBuyerCarried.id !== pt.id && pt.location === 'carried') {
        await tx.playerTools.update({
          where: { id: existingBuyerCarried.id },
          data: {
            quantity: existingBuyerCarried.quantity + pt.quantity,
            durability:
              pt.durability > existingBuyerCarried.durability
                ? pt.durability
                : existingBuyerCarried.durability,
          },
        });
        await tx.playerTools.delete({ where: { id: pt.id } });
      } else {
        await tx.playerTools.update({ where: { id: pt.id }, data: { playerId: buyerId } });
      }

      return { newMoney, purchasePrice: listing.price };
    });

    const sellerUsage = await toolService.calculateInventoryUsage(listing.sellerId);
    const buyerUsage = await toolService.calculateInventoryUsage(buyerId);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: listing.sellerId },
        data: { inventory_slots_used: sellerUsage },
      }),
      prisma.player.update({
        where: { id: buyerId },
        data: { inventory_slots_used: buyerUsage },
      }),
    ]);

    return result;
  },

  async _buyDrugLotListing(
    buyerId: number,
    listing: ListingRow,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const meta = parseMeta<DrugLotMeta>(listing.meta);
    if (!meta) {
      throw new Error('LISTING_STALE');
    }

    return prisma.$transaction(async (tx) => {
      await claimListing(tx, listing.id, buyerId);
      const newMoney = await settlePayment(tx, buyerId, listing.sellerId, listing.price);

      await tx.drugInventory.upsert({
        where: {
          playerId_drugType_quality: {
            playerId: buyerId,
            drugType: meta.drugType,
            quality: meta.quality,
          },
        },
        create: {
          playerId: buyerId,
          drugType: meta.drugType,
          quality: meta.quality,
          quantity: listing.quantity,
        },
        update: { quantity: { increment: listing.quantity } },
      });

      return { newMoney, purchasePrice: listing.price };
    });
  },

  async _buyCryptoLotListing(
    buyerId: number,
    listing: ListingRow,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const meta = parseMeta<CryptoLotMeta>(listing.meta);
    if (!meta) {
      throw new Error('LISTING_STALE');
    }
    const quantity = toNumber(meta.quantity, 0);
    if (quantity <= 0) {
      throw new Error('LISTING_STALE');
    }

    return prisma.$transaction(async (tx) => {
      await claimListing(tx, listing.id, buyerId);
      const newMoney = await settlePayment(tx, buyerId, listing.sellerId, listing.price);

      // The buyer's cost basis is what they actually paid, not the seller's.
      const unitPaid = listing.price / quantity;
      await creditCryptoHolding(tx, buyerId, meta.assetSymbol, quantity, unitPaid);

      return { newMoney, purchasePrice: listing.price };
    });
  },

  async _buyTradeGoodLotListing(
    buyerId: number,
    listing: ListingRow,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const meta = parseMeta<TradeGoodLotMeta>(listing.meta);
    if (!meta) {
      throw new Error('LISTING_STALE');
    }
    const good = getGoodById(meta.goodType);
    if (!good) {
      throw new Error('INVALID_GOOD');
    }

    const lotQuantity = listing.quantity;
    const unitPaid = Math.max(0, Math.floor(listing.price / Math.max(1, lotQuantity)));

    return prisma.$transaction(async (tx) => {
      const buyer = await tx.player.findUnique({
        where: { id: buyerId },
        select: { currentCountry: true },
      });
      const lotCountry = buyer?.currentCountry?.trim() || 'netherlands';
      const existing = await tx.inventory.findUnique({
        where: {
          playerId_goodType_country: {
            playerId: buyerId,
            goodType: meta.goodType,
            country: lotCountry,
          },
        },
      });
      const currentQuantity = existing?.quantity ?? 0;
      if (currentQuantity + lotQuantity > good.maxInventory) {
        throw new Error('TRADE_CAPACITY');
      }

      await claimListing(tx, listing.id, buyerId);
      const newMoney = await settlePayment(tx, buyerId, listing.sellerId, listing.price);

      if (existing) {
        const totalQuantity = currentQuantity + lotQuantity;
        const blendedPrice = Math.floor(
          (currentQuantity * (existing.purchasePrice ?? 0) + lotQuantity * unitPaid) /
            totalQuantity,
        );
        await tx.inventory.update({
          where: { id: existing.id },
          data: {
            quantity: totalQuantity,
            purchasePrice: blendedPrice,
            condition: Math.min(existing.condition ?? 100, meta.condition ?? 100),
          },
        });
      } else {
        await tx.inventory.create({
          data: {
            playerId: buyerId,
            goodType: meta.goodType,
            country: lotCountry,
            quantity: lotQuantity,
            purchasePrice: unitPaid,
            condition: meta.condition ?? 100,
            // Carry the original timestamp so spoilage cannot be reset by relisting.
            ...(meta.purchasedAt ? { purchasedAt: new Date(meta.purchasedAt) } : {}),
          },
        });
      }

      return { newMoney, purchasePrice: listing.price };
    });
  },

  async _buyEventItemListing(
    buyerId: number,
    listing: ListingRow,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const meta = parseMeta<EventItemLotMeta>(listing.meta);
    if (!meta) {
      throw new Error('LISTING_STALE');
    }
    const def = getEventItemDefinition(meta.itemKey);
    if (!def || def.bound) {
      throw new Error('EVENT_ITEM_BOUND');
    }

    return prisma.$transaction(async (tx) => {
      await claimListing(tx, listing.id, buyerId);
      const newMoney = await settlePayment(tx, buyerId, listing.sellerId, listing.price);
      await creditEventItem(tx, buyerId, meta.itemKey, listing.quantity, null);
      return { newMoney, purchasePrice: listing.price };
    });
  },
};
async function restoreEscrow(tx: TransactionClient, listing: ListingRow): Promise<void> {
  switch (listing.kind) {
    case MARKET_LISTING_KIND_DRUG_LOT: {
      const meta = parseMeta<DrugLotMeta>(listing.meta);
      if (!meta) return;
      await tx.drugInventory.upsert({
        where: {
          playerId_drugType_quality: {
            playerId: listing.sellerId,
            drugType: meta.drugType,
            quality: meta.quality,
          },
        },
        create: {
          playerId: listing.sellerId,
          drugType: meta.drugType,
          quality: meta.quality,
          quantity: listing.quantity,
        },
        update: { quantity: { increment: listing.quantity } },
      });
      return;
    }
    case MARKET_LISTING_KIND_CRYPTO_LOT: {
      const meta = parseMeta<CryptoLotMeta>(listing.meta);
      if (!meta) return;
      const quantity = toNumber(meta.quantity, 0);
      if (quantity <= 0) return;
      await creditCryptoHolding(
        tx,
        listing.sellerId,
        meta.assetSymbol,
        quantity,
        toNumber(meta.avgBuyPrice, 0),
      );
      return;
    }
    case MARKET_LISTING_KIND_TRADE_GOOD_LOT: {
      const meta = parseMeta<TradeGoodLotMeta>(listing.meta);
      if (!meta) return;
      const returnCountry =
        meta.country?.trim() || listing.countryCode?.trim() || 'netherlands';
      const existing = await tx.inventory.findUnique({
        where: {
          playerId_goodType_country: {
            playerId: listing.sellerId,
            goodType: meta.goodType,
            country: returnCountry,
          },
        },
      });
      if (existing) {
        await tx.inventory.update({
          where: { id: existing.id },
          data: {
            quantity: existing.quantity + listing.quantity,
            condition: Math.min(existing.condition ?? 100, meta.condition ?? 100),
          },
        });
      } else {
        await tx.inventory.create({
          data: {
            playerId: listing.sellerId,
            goodType: meta.goodType,
            country: returnCountry,
            quantity: listing.quantity,
            purchasePrice: meta.unitPurchasePrice ?? 0,
            condition: meta.condition ?? 100,
            ...(meta.purchasedAt ? { purchasedAt: new Date(meta.purchasedAt) } : {}),
          },
        });
      }
      return;
    }
    case MARKET_LISTING_KIND_EVENT_ITEM: {
      const meta = parseMeta<EventItemLotMeta>(listing.meta);
      if (!meta) return;
      await creditEventItem(tx, listing.sellerId, meta.itemKey, listing.quantity, null);
      return;
    }
    default:
  }
}
