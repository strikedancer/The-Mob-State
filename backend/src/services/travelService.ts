/**
 * Travel Service - Phase 9.1
 *
 * Handles international travel between countries.
 * Players can travel to different countries for trade opportunities.
 */

import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { activityService } from './activityService';
import { notificationService } from './notificationService';
import { clearPlayerCrimeVehicle } from './vehicleToolService';
import countries from '../../content/countries.json';
import travelRoutes from '../../content/travelRoutes.json';
import {
  CARRIED_MATERIAL_LOCATION,
  getCarriedMaterialSlots,
  materialTravelArrestBonus,
  materialTravelConfiscationChance,
} from './productionMaterialStock';
import toolService from './toolService';

export interface Country {
  id: string;
  name: string;
  travelCost: number;
  tradeBonuses: Record<string, number>;
  description: string;
}

export interface RouteInfo {
  path: string[];
  stops: number;
  isDirect: boolean;
  costMultiplier: number;
  timeDelay: number; // in minutes
}

export interface CountryWithRoute extends Country {
  route?: RouteInfo;
  totalCost?: number;
  totalTime?: number;
}

export interface TravelResult {
  success: boolean;
  newCountry: string;
  newLocation: string;
  travelCost: number;
  remainingMoney: number;
  confiscatedGoods?: Array<{ goodType: string; quantity: number }>;
  damagedGoods?: Array<{ goodType: string; damagePercent: number }>;
  route?: RouteInfo;
}

export interface JourneyStartResult {
  success: boolean;
  destinationCountry: string;
  route: string[];
  newCountry: string;
  newLocation: string;
  currentLocation: string;
  travelCost: number; // Cost for first leg
  totalJourneyCost: number; // Total cost for all legs
  remainingMoney: number;
  legsCompleted: number;
  totalLegs: number;
  nextLeg: string;
}

export interface JourneyStatus {
  isInTransit: boolean;
  destination?: string;
  route?: string[];
  currentLeg: number;
  totalLegs: number;
  currentLocation: string;
}

const TRAVEL_JAIL_TIME_MINUTES = 30;
const LEG_COOLDOWN_MINUTES = 60;
const BASE_ARREST_CHANCE = 0.03;
const WANTED_LEVEL_ARREST_BONUS = 0.015;
const MAX_ARREST_CHANCE = 0.25;

function serializeRoute(route: string[]): string {
  return JSON.stringify(route);
}

function parseStoredRoute(rawRoute: unknown): string[] {
  if (Array.isArray(rawRoute)) {
    return rawRoute.filter((item): item is string => typeof item === 'string');
  }

  if (typeof rawRoute !== 'string' || rawRoute.trim().length === 0) {
    return [];
  }

  try {
    const parsed = JSON.parse(rawRoute);
    if (Array.isArray(parsed)) {
      return parsed.filter((item): item is string => typeof item === 'string');
    }
  } catch {
    // Legacy fallback for previously persisted comma-separated values.
  }

  return rawRoute
    .split(',')
    .map((part) => part.trim())
    .filter((part) => part.length > 0);
}

/**
 * Calculate route between two countries using BFS
 */
function calculateRoute(fromCountry: string, toCountry: string): RouteInfo {
  console.log(`[calculateRoute] Finding route from ${fromCountry} to ${toCountry}`);
  
  // Same country = direct route with no cost
  if (fromCountry === toCountry) {
    return {
      path: [fromCountry],
      stops: 0,
      isDirect: true,
      costMultiplier: 1.0,
      timeDelay: 0,
    };
  }

  // BFS to find shortest route
  const queue: Array<{ country: string; path: string[] }> = [{ country: fromCountry, path: [fromCountry] }];
  const visited = new Set<string>([fromCountry]);
  const directRoutes = (travelRoutes as any).directRoutes;

  console.log(`[calculateRoute] Neighbors of ${fromCountry}:`, directRoutes[fromCountry]);

  while (queue.length > 0) {
    const current = queue.shift()!;

    // Check all neighbors
    const neighbors = directRoutes[current.country] || [];
    for (const neighbor of neighbors) {
      if (visited.has(neighbor)) continue;

      const newPath = [...current.path, neighbor];

      // Found destination
      if (neighbor === toCountry) {
        const stops = newPath.length - 1;
        const isDirect = stops === 1;
        
        console.log(`[calculateRoute] Found route:`, newPath, `(${stops} stops)`);
        
        // Apply cost and time penalties based on stops
        let costMultiplier = 1.0;
        let timeDelay = 0;
        
        if (stops === 1) {
          costMultiplier = (travelRoutes as any).routeCosts.direct;
          timeDelay = (travelRoutes as any).routeTimes.direct;
        } else if (stops === 2) {
          costMultiplier = (travelRoutes as any).routeCosts.oneStop;
          timeDelay = (travelRoutes as any).routeTimes.oneStop;
        } else {
          // 3+ stops: use twoStops penalty
          costMultiplier = (travelRoutes as any).routeCosts.twoStops;
          timeDelay = (travelRoutes as any).routeTimes.twoStops;
        }

        return {
          path: newPath,
          stops,
          isDirect,
          costMultiplier,
          timeDelay,
        };
      }

      visited.add(neighbor);
      queue.push({ country: neighbor, path: newPath });
    }
  }

  // No route found - fallback to direct route (should not happen with proper graph)
  console.warn(`No route found from ${fromCountry} to ${toCountry}, using direct fallback`);
  return {
    path: [fromCountry, toCountry],
    stops: 1,
    isDirect: true,
    costMultiplier: 1.0,
    timeDelay: 0,
  };
}

/**
 * Get all available countries
 */
export function getAllCountries(): Country[] {
  return countries as Country[];
}

/**
 * Get all countries with route information from a specific origin
 */
export function applyAircraftTravelBonus(baseMinutes: number, bonus = 0): number {
  const safeBonus = Math.min(0.9, Math.max(0, bonus));
  return Math.max(1, Math.round(baseMinutes * (1 - safeBonus)));
}

/**
 * Get all countries with route information from a specific origin.
 * `travelBonus` shortens air-route times (best owned plane). Water routes stay unchanged.
 */
export function getAllCountriesWithRoutes(
  fromCountry: string,
  travelBonus = 0
): CountryWithRoute[] {
  return countries.map((country) => {
    const c = country as Country;
    
    if (c.id === fromCountry) {
      // Current country - no route needed
      return {
        ...c,
        route: {
          path: [c.id],
          stops: 0,
          isDirect: true,
          costMultiplier: 1.0,
          timeDelay: 0,
        },
        totalCost: 0,
        totalTime: 0,
      };
    }
    
    const route = calculateRoute(fromCountry, c.id);
    const totalCost = Math.round(c.travelCost * route.costMultiplier);
    const totalLegs = Math.max(route.path.length - 1, 1);
    const baseTime = totalLegs * LEG_COOLDOWN_MINUTES;
    const totalTime = applyAircraftTravelBonus(baseTime, travelBonus);
    
    return {
      ...c,
      route,
      totalCost,
      totalTime,
    };
  });
}

/**
 * Get country by ID
 */
export function getCountryById(countryId: string): Country | undefined {
  return countries.find((c) => c.id === countryId) as Country | undefined;
}

/**
 * Validate if country exists
 */
export function isValidCountry(countryId: string): boolean {
  return countries.some((c) => c.id === countryId);
}

/**
 * Get travel cost to a country (includes route multiplier)
 */
export function getTravelCost(fromCountry: string, toCountry: string): number {
  // If already in the country, no cost
  if (fromCountry === toCountry) {
    return 0;
  }

  const destination = getCountryById(toCountry);
  const baseCost = destination?.travelCost || 0;
  
  // Calculate route and apply cost multiplier
  const route = calculateRoute(fromCountry, toCountry);
  return Math.round(baseCost * route.costMultiplier);
}

/**
 * Get player's current country
 */
export async function getPlayerCountry(playerId: number): Promise<string> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });

  return player?.currentCountry || 'netherlands';
}

/**
 * Get player's journey status
 */
export async function getJourneyStatus(playerId: number): Promise<JourneyStatus> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      currentCountry: true,
      travelingTo: true,
      travelRoute: true,
      currentTravelLeg: true,
    },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const isInTransit = player.currentTravelLeg > 0 && player.travelingTo !== null;
  const parsedRoute = parseStoredRoute(player.travelRoute);
  const route = isInTransit ? parsedRoute : undefined;
  const totalLegs = route ? Math.max(route.length - 1, 0) : 0;

  return {
    isInTransit,
    destination: player.travelingTo || undefined,
    route,
    currentLeg: player.currentTravelLeg,
    totalLegs,
    currentLocation: player.currentCountry,
  };
}

async function clearAllPlayerGoods(playerId: number): Promise<void> {
  await prisma.$transaction(async (tx) => {
    await tx.inventory.deleteMany({
      where: { playerId },
    });

    await tx.drugInventory.deleteMany({
      where: { playerId },
    });

    // Only wipe backpack materials — country depots stay safe.
    await tx.productionMaterial.deleteMany({
      where: { playerId, country: CARRIED_MATERIAL_LOCATION },
    });
  });

  const usage = await toolService.calculateInventoryUsage(playerId);
  await prisma.player.update({
    where: { id: playerId },
    data: { inventory_slots_used: usage },
  });
}

async function confiscateCarriedMaterials(
  playerId: number,
  wantedLevel: number,
): Promise<Array<{ materialId: string; quantity: number }>> {
  const carried = await prisma.productionMaterial.findMany({
    where: { playerId, country: CARRIED_MATERIAL_LOCATION },
  });
  if (carried.length === 0) return [];

  const slots = await getCarriedMaterialSlots(playerId);
  const chance = materialTravelConfiscationChance(slots, wantedLevel);
  const confiscated: Array<{ materialId: string; quantity: number }> = [];

  for (const item of carried) {
    if (Math.random() >= chance) continue;
    const confiscationPercent = 0.3 + Math.random() * 0.4;
    const quantityLost = Math.max(1, Math.floor(item.quantity * confiscationPercent));
    confiscated.push({ materialId: item.materialId, quantity: quantityLost });
    const remaining = item.quantity - quantityLost;
    if (remaining <= 0) {
      await prisma.productionMaterial.delete({ where: { id: item.id } });
    } else {
      await prisma.productionMaterial.update({
        where: { id: item.id },
        data: { quantity: remaining },
      });
    }
  }

  if (confiscated.length > 0) {
    const usage = await toolService.calculateInventoryUsage(playerId);
    await prisma.player.update({
      where: { id: playerId },
      data: { inventory_slots_used: usage },
    });
  }

  return confiscated;
}

function getTravelArrestChance(wantedLevel: number, materialSlots = 0): number {
  const chance =
    BASE_ARREST_CHANCE +
    wantedLevel * WANTED_LEVEL_ARREST_BONUS +
    materialTravelArrestBonus(materialSlots);
  return Math.min(chance, MAX_ARREST_CHANCE);
}

async function sendPlayerToJail(playerId: number, jailTimeMinutes: number): Promise<void> {
  const now = new Date();
  const jailRelease = new Date(now.getTime() + jailTimeMinutes * 60 * 1000);

  await prisma.crimeAttempt.create({
    data: {
      playerId,
      crimeId: 'travel_leg',
      success: false,
      reward: 0,
      xpGained: 0,
      jailed: true,
      jailTime: jailTimeMinutes,
    },
  });

  await activityService.logActivity(
    playerId,
    'ARREST',
    `Arrested during travel for ${jailTimeMinutes} minutes`,
    {
      authority: 'Border Police',
      source: 'TRAVEL',
      jailTime: jailTimeMinutes,
      jailedUntil: jailRelease.toISOString(),
    },
    true
  );

  void notificationService.sendArrestAwaitingHelpNotifications(
    playerId,
    jailTimeMinutes,
    'Border Police',
    'TRAVEL'
  );
}

/**
 * Start a multi-leg journey to a destination
 */
export async function startJourney(playerId: number, destinationCountryId: string): Promise<JourneyStartResult> {
  // Validate destination
  if (!isValidCountry(destinationCountryId)) {
    throw new Error('INVALID_COUNTRY');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if already traveling
  if (player.currentTravelLeg > 0) {
    throw new Error('ALREADY_IN_TRANSIT');
  }

  // Check if already in destination
  if (player.currentCountry === destinationCountryId) {
    throw new Error('ALREADY_IN_COUNTRY');
  }

  // Drug inventory quantities are stored in grams; keep the travel gate in the same unit.
  const drugInventory = await prisma.drugInventory.findMany({
    where: { playerId },
  });

  let totalDrugWeight = 0;
  for (const item of drugInventory) {
    totalDrugWeight += item.quantity;
  }

  const MAX_DRUG_WEIGHT_ON_TRAVEL = 1000; // 1kg in grams
  if (totalDrugWeight > MAX_DRUG_WEIGHT_ON_TRAVEL) {
    const excessKg = ((totalDrugWeight - MAX_DRUG_WEIGHT_ON_TRAVEL) / 1000).toFixed(1);
    const error: any = new Error('TOO_MANY_DRUGS');
    error.message = `Je draagt te veel drugs om te reizen. Max: 1kg, jij hebt: ${(totalDrugWeight / 1000).toFixed(1)}kg. Sla ${excessKg}kg op in een property.`;
    throw error;
  }

  // Calculate route
  const route = calculateRoute(player.currentCountry, destinationCountryId);
  const totalLegs = Math.max(route.path.length - 1, 1);

  // Cost per leg (divide total cost by number of legs)
  const destCountry = getCountryById(destinationCountryId)!;
  const totalCost = Math.round(destCountry.travelCost * route.costMultiplier);
  const baseCostPerLeg = Math.round(totalCost / totalLegs);

  // Check if player has enough money
  if (player.money < baseCostPerLeg) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const isSingleLegJourney = totalLegs <= 1;
  const firstStop = route.path[1] || destinationCountryId;

  // Deduct cost for first leg
  const updatedPlayer = await prisma.player.update({
    where: { id: playerId },
    data: {
      currentCountry: firstStop, // Move to first waypoint (or destination on direct trip)
      currentTravelLeg: isSingleLegJourney ? 0 : 1,
      travelingTo: isSingleLegJourney ? null : destinationCountryId,
      travelRoute: isSingleLegJourney ? null : serializeRoute(route.path),
      travelStartedAt: isSingleLegJourney ? null : new Date(),
      money: player.money - baseCostPerLeg,
    },
  });

  // Clear selected crime vehicle when player moves to different country
  await clearPlayerCrimeVehicle(playerId);

  // Check for arrest on first leg (hybrid chance; backpack materials raise risk)
  const materialSlots = await getCarriedMaterialSlots(playerId);
  const arrestChance = getTravelArrestChance(player.wantedLevel, materialSlots);
  if (Math.random() < arrestChance) {
    await clearAllPlayerGoods(playerId);
    await sendPlayerToJail(playerId, TRAVEL_JAIL_TIME_MINUTES);
    await prisma.player.update({
      where: { id: playerId },
      data: {
        travelingTo: null,
        travelRoute: null,
        currentTravelLeg: 0,
        travelStartedAt: null,
      },
    });

    const error: any = new Error('JAILED_IN_TRANSIT');
    error.jailTime = TRAVEL_JAIL_TIME_MINUTES;
    throw error;
  }

  const confiscatedMaterials = await confiscateCarriedMaterials(
    playerId,
    player.wantedLevel,
  );

  // Log activity
  const routeDescription = route.path.slice(1).map((id) => getCountryById(id)?.name || id).join(' → ');
  await activityService.logActivity(
    playerId,
    'TRAVEL_START',
    isSingleLegJourney
      ? `Traveled to ${destCountry.name}`
      : `Started journey to ${destCountry.name}: ${routeDescription}`,
    {
      destination: destinationCountryId,
      route: route.path,
      totalLegs,
      legsCost: baseCostPerLeg,
      totalCost,
      direct: isSingleLegJourney,
      confiscatedMaterials:
        confiscatedMaterials.length > 0 ? confiscatedMaterials : undefined,
    },
    true
  );

  // Create world event
  await worldEventService.createEvent(
    isSingleLegJourney ? 'travel.arrived' : 'travel.journey_started',
    {
      playerId,
      fromCountry: player.currentCountry,
      toCountry: destinationCountryId,
      destination: destinationCountryId,
      country:
        getCountryById(destinationCountryId)?.name || destinationCountryId,
      route: route.path,
      totalLegs,
      direct: isSingleLegJourney,
      confiscatedMaterials:
        confiscatedMaterials.length > 0 ? confiscatedMaterials : undefined,
    },
    playerId
  );

  return {
    success: true,
    destinationCountry: destinationCountryId,
    route: route.path,
    newCountry: updatedPlayer.currentCountry,
    newLocation:
      getCountryById(updatedPlayer.currentCountry)?.name ||
      updatedPlayer.currentCountry,
    currentLocation: updatedPlayer.currentCountry,
    travelCost: baseCostPerLeg,
    totalJourneyCost: totalCost,
    remainingMoney: updatedPlayer.money,
    legsCompleted: 1,
    totalLegs,
    nextLeg: isSingleLegJourney
      ? destinationCountryId
      : (route.path[2] || destinationCountryId),
  };
}

/**
 * Travel to a country
 */
export async function travelToCountry(playerId: number, countryId: string): Promise<TravelResult> {
  // Validate country
  if (!isValidCountry(countryId)) {
    throw new Error('INVALID_COUNTRY');
  }

  const destination = getCountryById(countryId);
  if (!destination) {
    throw new Error('COUNTRY_NOT_FOUND');
  }

  // Get player
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  // Check if already in destination
  if (player.currentCountry === countryId) {
    throw new Error('ALREADY_IN_COUNTRY');
  }

  // Calculate route
  const route = calculateRoute(player.currentCountry, countryId);

  // Calculate travel cost (with route multiplier)
  const travelCost = getTravelCost(player.currentCountry, countryId);

  // Check if player has enough money
  if (player.money < travelCost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Update player location and deduct money
  const updatedPlayer = await prisma.player.update({
    where: { id: playerId },
    data: {
      currentCountry: countryId,
      money: player.money - travelCost,
    },
  });

  // Clear selected crime vehicle when player moves to different country
  await clearPlayerCrimeVehicle(playerId);

  // Trade warehouses stay in-country; commercial travel does not move or seize them.
  const confiscatedGoods: Array<{ goodType: string; quantity: number }> = [];
  const damagedGoods: Array<{ goodType: string; damagePercent: number }> = [];
  const confiscatedMaterials = await confiscateCarriedMaterials(
    playerId,
    player.wantedLevel,
  );

  // Create world event
  await worldEventService.createEvent(
    'travel.arrived',
    {
      playerId,
      fromCountry: player.currentCountry,
      toCountry: countryId,
      destination: countryId,
      country: getCountryById(countryId)?.name || countryId,
      travelCost,
      confiscatedGoods: confiscatedGoods.length > 0 ? confiscatedGoods : undefined,
      damagedGoods: damagedGoods.length > 0 ? damagedGoods : undefined,
      confiscatedMaterials:
        confiscatedMaterials.length > 0 ? confiscatedMaterials : undefined,
    },
    playerId
  );

  // Log activity
  const destinationCountry = getCountryById(countryId);
  
  // Build route description
  let travelDescription = `Traveled to ${destinationCountry?.name || countryId}`;
  if (!route.isDirect && route.path.length > 2) {
    // Show layover countries
    const layovers = route.path.slice(1, -1); // Skip origin and destination
    const layoverNames = layovers
      .map(id => getCountryById(id)?.name || id)
      .join(', ');
    travelDescription += ` via ${layoverNames}`;
  }
  
  await activityService.logActivity(
    playerId,
    'TRAVEL',
    travelDescription,
    {
      fromCountry: player.currentCountry,
      toCountry: countryId,
      travelCost,
      confiscatedGoods: confiscatedGoods.length,
      route: route.path,
      stops: route.stops,
    },
    true
  );

  return {
    success: true,
    newCountry: countryId,
    newLocation: destination.name,
    travelCost,
    remainingMoney: updatedPlayer.money,
    confiscatedGoods: confiscatedGoods.length > 0 ? confiscatedGoods : undefined,
    damagedGoods: damagedGoods.length > 0 ? damagedGoods : undefined,
    route,
  };
}

/**
 * Get current country info for player
 */
export async function getCurrentCountryInfo(playerId: number): Promise<Country> {
  const currentCountry = await getPlayerCountry(playerId);
  const country = getCountryById(currentCountry);

  if (!country) {
    // Default to Netherlands if country not found
    return getCountryById('netherlands') as Country;
  }

  return country;
}

/**
 * Continue journey to next leg
 */
export async function continueJourney(playerId: number): Promise<TravelResult> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const journey = player as any;
  if (!journey.travelingTo || journey.currentTravelLeg === 0) {
    throw new Error('NOT_IN_TRANSIT');
  }

  const route = parseStoredRoute(journey.travelRoute);
  if (route.length < 2) {
    throw new Error('INVALID_ROUTE');
  }
  const totalLegs = Math.max(route.length - 1, 1);
  const currentLegIndex = journey.currentTravelLeg;

  console.log('🚀 CONTINUE JOURNEY DEBUG:');
  console.log('  Player:', player.username);
  console.log('  Current country:', player.currentCountry);
  console.log('  Current leg index:', currentLegIndex);
  console.log('  Route:', route);
  console.log('  Total legs:', totalLegs);

  // Check if already at destination (currentTravelLeg should be at route.length - 1 for final leg)
  if (currentLegIndex >= route.length - 1) {
    // Journey is complete - finalize it
    await prisma.player.update({
      where: { id: playerId },
      data: {
        travelingTo: null,
        travelRoute: null,
        currentTravelLeg: 0,
        travelStartedAt: null,
      },
    });
    throw new Error('JOURNEY_COMPLETE');
  }

  const nextLegIndex = currentLegIndex + 1;
  const nextCountry = route[nextLegIndex];

  console.log('  Next leg index:', nextLegIndex);
  console.log('  Next country:', nextCountry);

  if (!nextCountry) {
    console.log('  ❌ ERROR: No next country found!');
    throw new Error('INVALID_ROUTE');
  }

  const destinationCountry = getCountryById(journey.travelingTo);
  if (!destinationCountry) {
    console.log('  ❌ ERROR: Destination country not found:', journey.travelingTo);
    throw new Error('COUNTRY_NOT_FOUND');
  }

  const nextCountryData = getCountryById(nextCountry);
  if (!nextCountryData) {
    console.log('  ❌ ERROR: Next country data not found:', nextCountry);
    throw new Error('COUNTRY_NOT_FOUND');
  }
  console.log('  Next country data:', nextCountryData.name);
  const routeInfo = calculateRoute(route[0], journey.travelingTo);
  const totalCost = Math.round(destinationCountry.travelCost * routeInfo.costMultiplier);
  const baseCostPerLeg = Math.round(totalCost / totalLegs);

  // Check if player has enough money
  if (player.money < baseCostPerLeg) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct cost and move to next leg
  const updatedPlayer = await prisma.player.update({
    where: { id: playerId },
    data: {
      currentCountry: nextCountry,
      currentTravelLeg: nextLegIndex,
      money: player.money - baseCostPerLeg,
    },
  });

  // Clear selected crime vehicle when player moves to different country
  await clearPlayerCrimeVehicle(playerId);

  // Check for arrest on this leg (hybrid chance; backpack materials raise risk)
  const materialSlots = await getCarriedMaterialSlots(playerId);
  const arrestChance = getTravelArrestChance(player.wantedLevel, materialSlots);
  if (Math.random() < arrestChance) {
    await clearAllPlayerGoods(playerId);
    await sendPlayerToJail(playerId, TRAVEL_JAIL_TIME_MINUTES);
    await prisma.player.update({
      where: { id: playerId },
      data: {
        travelingTo: null,
        travelRoute: null,
        currentTravelLeg: 0,
        travelStartedAt: null,
      },
    });

    const error: any = new Error('JAILED_IN_TRANSIT');
    error.jailTime = TRAVEL_JAIL_TIME_MINUTES;
    throw error;
  }

  // Trade warehouses stay in-country; commercial travel does not move or seize them.
  const confiscatedGoods: Array<{ goodType: string; quantity: number }> = [];
  const damagedGoods: Array<{ goodType: string; damagePercent: number }> = [];
  const confiscatedMaterials = await confiscateCarriedMaterials(
    playerId,
    player.wantedLevel,
  );

  // Determine if journey is complete
  const isJourneyComplete = nextLegIndex === route.length - 1;

  // If last leg, finalize journey
  if (isJourneyComplete) {
    await prisma.player.update({
      where: { id: playerId },
      data: {
        travelingTo: null,
        travelRoute: null,
        currentTravelLeg: 0,
        travelStartedAt: null,
      },
    });
  }

  // Create world event
  await worldEventService.createEvent(
    isJourneyComplete ? 'travel.journey_complete' : 'travel.leg_completed',
    {
      playerId,
      fromCountry: player.currentCountry,
      toCountry: nextCountry,
      destination: journey.travelingTo,
      country: getCountryById(nextCountry)?.name || nextCountry,
      legNumber: nextLegIndex,
      totalLegs,
      confiscatedGoods: confiscatedGoods.length > 0 ? confiscatedGoods : undefined,
      damagedGoods: damagedGoods.length > 0 ? damagedGoods : undefined,
      confiscatedMaterials:
        confiscatedMaterials.length > 0 ? confiscatedMaterials : undefined,
    },
    playerId
  );

  // Log activity
  const nextCountryInfo = getCountryById(nextCountry);
  let activityMessage = `Traveled to ${nextCountryInfo?.name || nextCountry} (leg ${nextLegIndex}/${totalLegs})`;
  if (isJourneyComplete) {
    activityMessage += ' - Journey complete!';
  }

  await activityService.logActivity(
    playerId,
    'TRAVEL_LEG',
    activityMessage,
    {
      leg: nextLegIndex,
      totalLegs,
      toCountry: nextCountry,
      destination: journey.travelingTo,
      confiscatedGoods: confiscatedGoods.length,
    },
    true
  );

  return {
    success: true,
    newCountry: nextCountry,
    newLocation: nextCountryInfo?.name || nextCountry,
    travelCost: baseCostPerLeg,
    remainingMoney: updatedPlayer.money,
    confiscatedGoods: confiscatedGoods.length > 0 ? confiscatedGoods : undefined,
    damagedGoods: damagedGoods.length > 0 ? damagedGoods : undefined,
  };
}

/**
 * Cancel an active journey
 */
export async function cancelJourney(playerId: number): Promise<{ success: boolean; message: string }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const journey = player as any;
  if (!journey.travelingTo || journey.currentTravelLeg === 0) {
    throw new Error('NOT_IN_TRANSIT');
  }

  // Cancel the journey
  await prisma.player.update({
    where: { id: playerId },
    data: {
      travelingTo: null,
      travelRoute: null,
      currentTravelLeg: 0,
      travelStartedAt: null,
    },
  });

  // Log activity
  await activityService.logActivity(
    playerId,
    'TRAVEL_CANCEL',
    `Canceled journey to ${journey.travelingTo}`,
    {
      destination: journey.travelingTo,
      legCompleted: journey.currentTravelLeg,
    },
    true
  );

  // Create world event
  await worldEventService.createEvent(
    'travel.journey_canceled',
    {
      playerId,
      destination: journey.travelingTo,
      legsCompleted: journey.currentTravelLeg,
    },
    playerId
  );

  return {
    success: true,
    message: `Journey to ${journey.travelingTo} canceled. You are staying in ${player.currentCountry}.`,
  };
}
