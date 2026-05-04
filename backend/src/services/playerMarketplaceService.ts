/**
 * Player-to-player listings on the Zwarte Markt “Marktplaats” tab (non-vehicle).
 * Vehicles remain VehicleInventory.marketListing — see blackMarketService.
 */

import prisma from '../lib/prisma';
import toolService from './toolService';

export const MARKET_LISTING_KIND_PLAYER_TOOL = 'player_tool';

function toolPriceBounds(basePrice: number): { min: number; max: number } {
  return {
    min: Math.max(1, Math.floor(basePrice * 0.1)),
    max: Math.floor(basePrice * 8),
  };
}

async function serializeToolListing(row: {
  id: number;
  sellerId: number;
  kind: string;
  refId: number;
  price: number;
  countryCode: string | null;
  createdAt: Date;
  seller: { id: number; username: string };
}) {
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

export const playerMarketplaceService = {
  async getActiveToolListings(country?: string) {
    const rows = await prisma.playerMarketListing.findMany({
      where: {
        status: 'active',
        kind: MARKET_LISTING_KIND_PLAYER_TOOL,
        ...(country ? { countryCode: country } : {}),
      },
      include: {
        seller: { select: { id: true, username: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    const out: unknown[] = [];
    for (const row of rows) {
      const pt = await prisma.playerTools.findUnique({ where: { id: row.refId } });
      if (!pt || pt.playerId !== row.sellerId) {
        await prisma.playerMarketListing.update({
          where: { id: row.id },
          data: { status: 'cancelled' },
        });
        continue;
      }
      const serialized = await serializeToolListing(row);
      if (serialized) out.push(serialized);
    }
    return out;
  },

  async listPlayerTool(playerId: number, playerToolId: number, price: number) {
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

    const { min, max } = toolPriceBounds(def.basePrice);
    if (!Number.isFinite(price) || price < min || price > max) {
      return {
        success: false as const,
        message: `Price must be between €${min} and €${max}`,
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    await prisma.playerMarketListing.create({
      data: {
        sellerId: playerId,
        kind: MARKET_LISTING_KIND_PLAYER_TOOL,
        refId: playerToolId,
        price,
        status: 'active',
        countryCode: player?.currentCountry ?? null,
      },
    });

    return { success: true as const, message: 'Listed' };
  },

  async delist(playerId: number, listingId: number) {
    const row = await prisma.playerMarketListing.findUnique({
      where: { id: listingId },
    });
    if (!row) {
      throw new Error('LISTING_NOT_FOUND');
    }
    if (row.sellerId !== playerId) {
      throw new Error('NOT_OWNER');
    }
    if (row.status !== 'active') {
      throw new Error('NOT_ACTIVE');
    }

    await prisma.playerMarketListing.update({
      where: { id: listingId },
      data: { status: 'cancelled' },
    });

    return { success: true as const };
  },

  async buyListing(
    buyerId: number,
    listingId: number,
  ): Promise<{ newMoney: number; purchasePrice: number }> {
    const listing = await prisma.playerMarketListing.findUnique({
      where: { id: listingId },
      include: {
        seller: { select: { id: true, username: true } },
      },
    });

    if (!listing || listing.status !== 'active') {
      throw new Error('NOT_FOR_SALE');
    }
    if (listing.sellerId === buyerId) {
      throw new Error('CANNOT_BUY_OWN');
    }

    if (listing.kind === MARKET_LISTING_KIND_PLAYER_TOOL) {
      return this._buyPlayerToolListing(buyerId, listing);
    }

    throw new Error('UNSUPPORTED_KIND');
  },

  async _buyPlayerToolListing(
    buyerId: number,
    listing: {
      id: number;
      sellerId: number;
      refId: number;
      price: number;
      kind: string;
    },
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

    const buyer = await prisma.player.findUnique({
      where: { id: buyerId },
      select: { id: true, money: true },
    });
    if (!buyer) {
      throw new Error('PLAYER_NOT_FOUND');
    }
    if (buyer.money < listing.price) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const canCarry = await toolService.canCarryTool(buyerId, pt.toolId, pt.quantity);
    if (!canCarry) {
      throw new Error('INVENTORY_FULL');
    }

    const result = await prisma.$transaction(async (tx) => {
      const buyerRow = await tx.player.findUnique({
        where: { id: buyerId },
        select: { money: true },
      });
      if (!buyerRow || buyerRow.money < listing.price) {
        throw new Error('INSUFFICIENT_FUNDS');
      }

      await tx.player.update({
        where: { id: buyerId },
        data: { money: buyerRow.money - listing.price },
      });

      await tx.player.update({
        where: { id: listing.sellerId },
        data: { money: { increment: listing.price } },
      });

      const existingBuyerCarried = await tx.playerTools.findFirst({
        where: {
          playerId: buyerId,
          toolId: pt.toolId,
          location: pt.location,
        },
      });

      if (
        existingBuyerCarried &&
        existingBuyerCarried.id !== pt.id &&
        pt.location === 'carried'
      ) {
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
        await tx.playerTools.update({
          where: { id: pt.id },
          data: { playerId: buyerId },
        });
      }

      await tx.playerMarketListing.update({
        where: { id: listing.id },
        data: {
          status: 'sold',
          buyerId,
          soldAt: new Date(),
        },
      });

      const finalBuyer = await tx.player.findUnique({
        where: { id: buyerId },
        select: { money: true },
      });

      return {
        newMoney: finalBuyer!.money,
        purchasePrice: listing.price,
      };
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

  async getSellerActiveListings(playerId: number) {
    const rows = await prisma.playerMarketListing.findMany({
      where: {
        sellerId: playerId,
        status: 'active',
      },
      include: {
        seller: { select: { id: true, username: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    const out: unknown[] = [];
    for (const row of rows) {
      if (row.kind !== MARKET_LISTING_KIND_PLAYER_TOOL) continue;
      const serialized = await serializeToolListing(row);
      if (serialized) out.push(serialized);
    }
    return out;
  },
};
