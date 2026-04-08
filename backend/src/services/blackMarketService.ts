/**
 * Phase 12.4: Black Market Service
 * Handles vehicle marketplace with dynamic pricing
 */

import prisma from '../lib/prisma';
import { vehicleService } from './vehicleService';

export const blackMarketService = {
  /**
   * Get all vehicles listed on the market
   */
  async getMarketListings(country?: string) {
    const listings = await prisma.vehicleInventory.findMany({
      where: {
        marketListing: true,
        ...(country && { currentLocation: country }),
      },
      include: {
        player: {
          select: {
            id: true,
            username: true,
          },
        },
      },
      orderBy: {
        stolenAt: 'desc',
      },
    });

    // Add vehicle definitions
    return listings.map((listing) => {
      const definition = vehicleService.getVehicleById(listing.vehicleId);
      return {
        ...listing,
        definition,
      };
    });
  },

  /**
   * List a vehicle for sale on the market
   */
  async listVehicle(
    playerId: number,
    inventoryId: number,
    askingPrice: number
  ): Promise<{
    success: boolean;
    message: string;
  }> {
    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!vehicle) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (vehicle.playerId !== playerId) {
      throw new Error('NOT_OWNER');
    }

    if (vehicle.marketListing) {
      throw new Error('ALREADY_LISTED');
    }

    // Validate asking price (must be reasonable)
    const definition = vehicleService.getVehicleById(vehicle.vehicleId);
    if (!definition) {
      throw new Error('INVALID_VEHICLE');
    }

    const maxPrice = definition.baseValue * 2; // Max 200% of base value
    const minPrice = Math.floor(definition.baseValue * 0.1); // Min 10% of base value

    if (askingPrice > maxPrice || askingPrice < minPrice) {
      return {
        success: false,
        message: `Prijs moet tussen €${minPrice} en €${maxPrice} zijn`,
      };
    }

    // List vehicle
    await prisma.vehicleInventory.update({
      where: { id: inventoryId },
      data: {
        marketListing: true,
        askingPrice,
      },
    });

    return {
      success: true,
      message: 'Voertuig staat nu op de markt',
    };
  },

  /**
   * Remove vehicle from market listing
   */
  async delistVehicle(
    playerId: number,
    inventoryId: number
  ): Promise<{
    success: boolean;
    message: string;
  }> {
    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
    });

    if (!vehicle) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (vehicle.playerId !== playerId) {
      throw new Error('NOT_OWNER');
    }

    if (!vehicle.marketListing) {
      throw new Error('NOT_LISTED');
    }

    await prisma.vehicleInventory.update({
      where: { id: inventoryId },
      data: {
        marketListing: false,
        askingPrice: null,
      },
    });

    return {
      success: true,
      message: 'Voertuig verwijderd van markt',
    };
  },

  /**
   * Buy a vehicle from the market
   */
  async buyVehicle(
    buyerId: number,
    inventoryId: number
  ): Promise<{
    purchasePrice: number;
    newMoney: number;
  }> {
    const vehicle = await prisma.vehicleInventory.findUnique({
      where: { id: inventoryId },
      include: {
        player: {
          select: {
            id: true,
            username: true,
          },
        },
      },
    });

    if (!vehicle) {
      throw new Error('VEHICLE_NOT_FOUND');
    }

    if (!vehicle.marketListing || !vehicle.askingPrice) {
      throw new Error('NOT_FOR_SALE');
    }

    if (vehicle.playerId === buyerId) {
      throw new Error('CANNOT_BUY_OWN_VEHICLE');
    }

    const buyer = await prisma.player.findUnique({
      where: { id: buyerId },
      select: {
        id: true,
        money: true,
        currentCountry: true,
      },
    });

    if (!buyer) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    if (buyer.money < vehicle.askingPrice) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    // Use transaction to transfer ownership
    const result = await prisma.$transaction(async (tx) => {
      // Deduct money from buyer
      const updatedBuyer = await tx.player.update({
        where: { id: buyerId },
        data: {
          money: buyer.money - vehicle.askingPrice!,
        },
      });

      // Add money to seller
      await tx.player.update({
        where: { id: vehicle.playerId },
        data: {
          money: {
            increment: vehicle.askingPrice!,
          },
        },
      });

      // Transfer vehicle ownership
      await tx.vehicleInventory.update({
        where: { id: inventoryId },
        data: {
          playerId: buyerId,
          marketListing: false,
          askingPrice: null,
          currentLocation: buyer.currentCountry!,
        },
      });

      return {
        purchasePrice: vehicle.askingPrice!,
        newMoney: updatedBuyer.money,
      };
    });

    return result;
  },

  /**
   * Calculate dynamic market price based on demand
   */
  calculateDynamicPrice(
    baseValue: number,
    country: string,
    vehicleType: string,
    condition: number
  ): {
    recommendedPrice: number;
    marketDemand: 'high' | 'medium' | 'low';
  } {
    // Base price adjusted for condition
    let price = baseValue * (condition / 100);

    // Country demand modifier (simulated)
    const countryModifiers: Record<string, number> = {
      netherlands: 1.0,
      belgium: 1.05,
      germany: 0.95,
      france: 1.1,
      spain: 1.15,
      italy: 1.2,
      united_kingdom: 1.25,
      switzerland: 1.3,
    };

    const countryMod = countryModifiers[country] || 1.0;
    price *= countryMod;

    // Vehicle type demand (luxury/sports cars worth more)
    const typeModifiers: Record<string, number> = {
      speed: 1.3,
      armored: 1.4,
      cargo: 1.1,
      stealth: 0.9,
      standard: 1.0,
    };

    const typeMod = typeModifiers[vehicleType] || 1.0;
    price *= typeMod;

    // Random daily fluctuation (±10%)
    const randomMod = 0.9 + Math.random() * 0.2;
    price *= randomMod;

    // Determine market demand
    let marketDemand: 'high' | 'medium' | 'low' = 'medium';
    if (countryMod >= 1.2 && typeMod >= 1.3) {
      marketDemand = 'high';
    } else if (countryMod <= 1.0 && typeMod <= 1.0) {
      marketDemand = 'low';
    }

    return {
      recommendedPrice: Math.floor(price),
      marketDemand,
    };
  },

  /**
   * Get player's own market listings
   */
  async getPlayerListings(playerId: number) {
    const listings = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        marketListing: true,
      },
      orderBy: {
        stolenAt: 'desc',
      },
    });

    // Add vehicle definitions and recommended prices
    return listings.map((listing) => {
      const definition = vehicleService.getVehicleById(listing.vehicleId);
      
      let pricing = null;
      if (definition) {
        pricing = this.calculateDynamicPrice(
          definition.baseValue,
          listing.currentLocation,
          definition.type,
          listing.condition
        );
      }

      return {
        ...listing,
        definition,
        pricing,
      };
    });
  },
};
