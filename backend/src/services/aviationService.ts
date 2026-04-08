/**
 * Aviation Service - Phase 10.1
 *
 * Handles aviation licensing and aircraft purchases.
 * High-level players can buy aircraft for fast travel and cargo transport.
 */

import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import aircraft from '../../content/aircraft.json';
import config from '../config';

export interface AircraftDefinition {
  id: string;
  name: string;
  type: string;
  description: string;
  price: number;
  minRank: number;
  maxRange: number;
  fuelCapacity: number;
  fuelCostPerKm: number;
  repairCost: number;
  speedMultiplier: number;
  cargoCapacity: number;
}

export interface LicensePurchaseResult {
  success: boolean;
  licenseType: string;
  cost: number;
  remainingMoney: number;
}

export interface AircraftPurchaseResult {
  success: boolean;
  aircraftId: number;
  aircraftType: string;
  aircraftName: string;
  cost: number;
  remainingMoney: number;
}

// License pricing
const LICENSE_PRICES = {
  basic: 100000, // €100,000 - Required for light aircraft
  commercial: 500000, // €500,000 - Required for business jets
  cargo: 1000000, // €1,000,000 - Required for cargo aircraft
};

const LICENSE_MIN_RANKS = {
  basic: 20,
  commercial: 30,
  cargo: 40,
};

/**
 * Get all available aircraft
 */
export function getAllAircraft(): AircraftDefinition[] {
  return aircraft as AircraftDefinition[];
}

/**
 * Get aircraft by ID
 */
export function getAircraftById(aircraftType: string): AircraftDefinition | undefined {
  return aircraft.find((a) => a.id === aircraftType) as AircraftDefinition | undefined;
}

/**
 * Check if player has aviation license
 */
export async function hasLicense(playerId: number): Promise<boolean> {
  const license = await prisma.aviationLicense.findUnique({
    where: { playerId },
  });
  return license !== null;
}

/**
 * Get player's aviation license
 */
export async function getLicense(playerId: number) {
  return await prisma.aviationLicense.findUnique({
    where: { playerId },
  });
}

/**
 * Purchase aviation license
 */
export async function purchaseLicense(
  playerId: number,
  licenseType: string = 'basic'
): Promise<LicensePurchaseResult> {
  // Validate license type
  if (!LICENSE_PRICES[licenseType as keyof typeof LICENSE_PRICES]) {
    throw new Error('INVALID_LICENSE_TYPE');
  }

  // Check if player already has a license
  const existingLicense = await hasLicense(playerId);
  if (existingLicense) {
    throw new Error('ALREADY_HAS_LICENSE');
  }

  const cost = LICENSE_PRICES[licenseType as keyof typeof LICENSE_PRICES];
  const minRank = LICENSE_MIN_RANKS[licenseType as keyof typeof LICENSE_MIN_RANKS];

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check rank requirement
  if (player.rank < minRank) {
    throw new Error('RANK_TOO_LOW');
  }

  // Check if player has enough money
  if (player.money < cost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Execute transaction
  const [updatedPlayer] = await prisma.$transaction([
    // Deduct money
    prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - cost },
    }),
    // Create license
    prisma.aviationLicense.create({
      data: {
        playerId,
        licenseType,
        purchasePrice: cost,
      },
    }),
  ]);

  // Create world event
  await worldEventService.createEvent(
    'aviation.license_purchased',
    {
      playerId,
      licenseType,
      cost,
    },
    playerId
  );

  return {
    success: true,
    licenseType,
    cost,
    remainingMoney: updatedPlayer.money,
  };
}

/**
 * Purchase aircraft
 */
export async function purchaseAircraft(
  playerId: number,
  aircraftType: string
): Promise<AircraftPurchaseResult> {
  // Validate aircraft type
  const aircraftDef = getAircraftById(aircraftType);
  if (!aircraftDef) {
    throw new Error('INVALID_AIRCRAFT_TYPE');
  }

  // Check if player has license
  const license = await getLicense(playerId);
  if (!license) {
    throw new Error('NO_LICENSE');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check rank requirement
  if (player.rank < aircraftDef.minRank) {
    throw new Error('RANK_TOO_LOW');
  }

  // Check if player has enough money
  if (player.money < aircraftDef.price) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Execute transaction
  const [updatedPlayer, newAircraft] = await prisma.$transaction([
    // Deduct money
    prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - aircraftDef.price },
    }),
    // Create aircraft
    prisma.aircraft.create({
      data: {
        playerId,
        aircraftType,
        fuel: 0, // Starts empty
        maxFuel: aircraftDef.fuelCapacity,
        purchasePrice: aircraftDef.price,
      },
    }),
  ]);

  // Create world event
  await worldEventService.createEvent(
    'aviation.aircraft_purchased',
    {
      playerId,
      aircraftType,
      aircraftName: aircraftDef.name,
      cost: aircraftDef.price,
    },
    playerId
  );

  return {
    success: true,
    aircraftId: newAircraft.id,
    aircraftType,
    aircraftName: aircraftDef.name,
    cost: aircraftDef.price,
    remainingMoney: updatedPlayer.money,
  };
}

/**
 * Get player's aircraft
 */
export async function getPlayerAircraft(playerId: number) {
  const playerAircraft = await prisma.aircraft.findMany({
    where: { playerId },
  });

  // Map to include aircraft details
  return playerAircraft.map((ac) => {
    const def = getAircraftById(ac.aircraftType);
    return {
      id: ac.id,
      aircraftType: ac.aircraftType,
      name: def?.name || ac.aircraftType,
      fuel: ac.fuel,
      maxFuel: ac.maxFuel,
      isBroken: ac.isBroken,
      totalFlights: ac.totalFlights,
      purchasePrice: ac.purchasePrice,
      purchasedAt: ac.purchasedAt,
      // Include definition details
      maxRange: def?.maxRange || 0,
      cargoCapacity: def?.cargoCapacity || 0,
      speedMultiplier: def?.speedMultiplier || 1,
    };
  });
}

/**
 * Get license info including pricing
 */
export function getLicensePricing() {
  return Object.entries(LICENSE_PRICES).map(([type, price]) => ({
    licenseType: type,
    price,
    minRank: LICENSE_MIN_RANKS[type as keyof typeof LICENSE_MIN_RANKS],
  }));
}

/**
 * Get today's flight count (global)
 */
export async function getTodaysFlightCount(): Promise<number> {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const count = await prisma.aircraft.aggregate({
    where: {
      purchasedAt: {
        gte: today,
      },
    },
    _sum: {
      totalFlights: true,
    },
  });

  return count._sum.totalFlights || 0;
}

/**
 * Refuel aircraft
 */
export async function refuelAircraft(
  playerId: number,
  aircraftId: number,
  amount: number
): Promise<{
  success: boolean;
  fuelAdded: number;
  cost: number;
  newFuel: number;
  remainingMoney: number;
}> {
  // Validate amount
  if (amount <= 0 || !Number.isInteger(amount)) {
    throw new Error('INVALID_AMOUNT');
  }

  // Get aircraft
  const playerAircraft = await prisma.aircraft.findFirst({
    where: {
      id: aircraftId,
      playerId,
    },
  });

  if (!playerAircraft) {
    throw new Error('AIRCRAFT_NOT_FOUND');
  }

  // Check if aircraft is broken
  if (playerAircraft.isBroken) {
    throw new Error('AIRCRAFT_BROKEN');
  }

  // Calculate how much fuel can be added
  const maxFuelToAdd = playerAircraft.maxFuel - playerAircraft.fuel;
  const fuelToAdd = Math.min(amount, maxFuelToAdd);

  if (fuelToAdd <= 0) {
    throw new Error('ALREADY_FULL');
  }

  // Calculate cost (€50 per liter)
  const FUEL_COST_PER_LITER = 50;
  const totalCost = fuelToAdd * FUEL_COST_PER_LITER;

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if player has enough money
  if (player.money < totalCost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Execute transaction
  const [updatedPlayer, updatedAircraft] = await prisma.$transaction([
    prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - totalCost },
    }),
    prisma.aircraft.update({
      where: { id: aircraftId },
      data: { fuel: playerAircraft.fuel + fuelToAdd },
    }),
  ]);

  // Create world event
  await worldEventService.createEvent(
    'aviation.refueled',
    {
      playerId,
      aircraftId,
      aircraftType: playerAircraft.aircraftType,
      fuelAdded: fuelToAdd,
      cost: totalCost,
    },
    playerId
  );

  return {
    success: true,
    fuelAdded: fuelToAdd,
    cost: totalCost,
    newFuel: updatedAircraft.fuel,
    remainingMoney: updatedPlayer.money,
  };
}

/**
 * Fly to a destination
 */
export async function flyToDestination(
  playerId: number,
  aircraftId: number,
  destinationCountry: string
): Promise<{
  success: boolean;
  destination: string;
  fuelUsed: number;
  newFuel: number;
  newLocation: string;
}> {
  // Get aircraft
  const playerAircraft = await prisma.aircraft.findFirst({
    where: {
      id: aircraftId,
      playerId,
    },
  });

  if (!playerAircraft) {
    throw new Error('AIRCRAFT_NOT_FOUND');
  }

  // Check if aircraft is broken
  if (playerAircraft.isBroken) {
    throw new Error('AIRCRAFT_BROKEN');
  }

  // Get aircraft definition
  const aircraftDef = getAircraftById(playerAircraft.aircraftType);
  if (!aircraftDef) {
    throw new Error('AIRCRAFT_DEFINITION_NOT_FOUND');
  }

  // Validate destination
  const countries = await import('../../content/countries.json');
  const destinationCountryData = countries.default.find(
    (c: { id: string }) => c.id === destinationCountry
  );

  if (!destinationCountryData) {
    throw new Error('INVALID_DESTINATION');
  }

  // Get player's current location
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if already at destination
  if (player.currentCountry === destinationCountry) {
    throw new Error('ALREADY_AT_DESTINATION');
  }

  // Calculate fuel needed (simplified: 100 liters per flight)
  const fuelNeeded = 100;

  // Check if aircraft has enough fuel
  if (playerAircraft.fuel < fuelNeeded) {
    throw new Error('INSUFFICIENT_FUEL');
  }

  // Check daily flight cap (global limit)
  const todaysFlights = await getTodaysFlightCount();
  if (todaysFlights >= config.maxFlightsPerDay) {
    throw new Error('FLIGHT_CAP_REACHED');
  }

  // Execute flight
  const [, updatedAircraft] = await prisma.$transaction([
    prisma.player.update({
      where: { id: playerId },
      data: { currentCountry: destinationCountry },
    }),
    prisma.aircraft.update({
      where: { id: aircraftId },
      data: {
        fuel: playerAircraft.fuel - fuelNeeded,
        totalFlights: playerAircraft.totalFlights + 1,
      },
    }),
  ]);

  // Create public world event (all flights are public)
  await worldEventService.createEvent(
    'aviation.flight',
    {
      playerId,
      playerName: player.username,
      aircraftType: playerAircraft.aircraftType,
      aircraftName: aircraftDef.name,
      fromCountry: player.currentCountry,
      toCountry: destinationCountry,
      fuelUsed: fuelNeeded,
    },
    undefined // Public event (no specific player)
  );

  return {
    success: true,
    destination: destinationCountry,
    fuelUsed: fuelNeeded,
    newFuel: updatedAircraft.fuel,
    newLocation: destinationCountryData.name,
  };
}
