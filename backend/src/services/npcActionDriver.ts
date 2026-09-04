import { NPCType } from '@prisma/client';
import npcBehaviors from '../../content/npcBehaviors.json';
import vehiclesData from '../../content/vehicles.json';
import prisma from '../lib/prisma';
import { crimeService } from './crimeService';
import { jobService } from './jobService';
import toolService from './toolService';
import { weaponService } from './weaponService';
import { weaponSelectionService } from './weaponSelectionService';
import { vehicleService } from './vehicleService';
import { propertyService } from './propertyService';
import { hospitalService } from './hospitalService';
import { gymService } from './gymService';
import { shootingRangeService } from './shootingRangeService';
import { educationService } from './educationService';
import * as policeService from './policeService';
import { intensiveCareService } from './intensiveCareService';
import * as cooldownService from './cooldownService';
import * as travelService from './travelService';
import * as bankService from './bankService';

type Behavior = (typeof npcBehaviors.behaviors)[keyof typeof npcBehaviors.behaviors];

export type NpcLiveCycleResult = {
  activitiesPerformed: number;
  moneyEarned: number;
  xpEarned: number;
  arrests: number;
  actions: string[];
};

export type NpcCycleOptions = {
  allowBank?: boolean;
  allowTravelStart?: boolean;
  allowVehicleSteal?: boolean;
};

export const NPC_ACTIVE_HOURS_PER_DAY: Record<NPCType, number> = {
  MATIG: 2.5,
  GEMIDDELD: 5,
  CONTINU: 8,
};

export function tickMinutesForType(npcType: NPCType): number {
  if (npcType === 'CONTINU') return 10;
  if (npcType === 'GEMIDDELD') return 12;
  return 20;
}

export function activeHoursForCalendar(npcType: NPCType, calendarHours: number): number {
  const activePerDay = NPC_ACTIVE_HOURS_PER_DAY[npcType] ?? 5;
  return Math.max(0.1, calendarHours * (activePerDay / 24));
}

export function maxLiveCyclesPerDay(npcType: NPCType): number {
  return Math.max(1, Math.round((NPC_ACTIVE_HOURS_PER_DAY[npcType] * 60) / tickMinutesForType(npcType)));
}

function shiftDate(value: Date | null | undefined, seconds: number): Date | null {
  if (!value) return null;
  return new Date(value.getTime() - seconds * 1000);
}

const STARTER_WEAPON = 'knife';
const MAX_TOOL_PRICE_SHARE = 0.2;
const MAX_TOOL_PRICE_ABS = 15000;

async function logNpcAction(
  npcId: number,
  activityType: string,
  details: Record<string, unknown>,
  success: boolean,
  moneyEarned = 0,
  xpEarned = 0,
) {
  await prisma.nPCActivityLog.create({
    data: {
      npcId,
      activityType,
      details: JSON.stringify(details),
      success,
      moneyEarned,
      xpEarned,
    },
  });
}

async function loadPlayer(playerId: number) {
  return prisma.player.findUnique({ where: { id: playerId } });
}

async function findLocalVehicle(playerId: number, country: string) {
  return prisma.vehicleInventory.findFirst({
    where: {
      playerId,
      currentLocation: country,
      transportStatus: null,
      marketListing: false,
      fuelLevel: { gt: 0 },
    },
    orderBy: { stolenAt: 'desc' },
  });
}

function pickWeightedId(prefs: Record<string, number>): string | null {
  const entries = Object.entries(prefs);
  if (entries.length === 0) return null;
  const total = entries.reduce((sum, [, weight]) => sum + weight, 0);
  let roll = Math.random() * (total || 1);
  for (const [id, weight] of entries) {
    roll -= weight;
    if (roll <= 0) return id;
  }
  return entries[0][0];
}

async function tryBail(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const jailed = await policeService.checkIfJailed(playerId);
  if (jailed <= 0) return false;
  const bail = policeService.calculateBail(Math.max(player.wantedLevel || 1, 1));
  if (player.money < bail) return false;
  try {
    await policeService.payBail(playerId);
    await logNpcAction(npcId, 'HEAT_MANAGEMENT', { action: 'pay_bail', cost: bail }, true, -bail);
    return true;
  } catch (error) {
    console.error('[NPC live] Bail failed:', error);
    return false;
  }
}

async function tryHospital(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player || player.health >= 35) return false;
  try {
    if (player.health < 10) {
      await hospitalService.emergencyRoom(playerId);
      await logNpcAction(npcId, 'SURVIVAL', { action: 'emergency_room' }, true);
      return true;
    }
    await hospitalService.heal(playerId);
    await logNpcAction(npcId, 'SURVIVAL', { action: 'hospital' }, true);
    return true;
  } catch (error) {
    console.error('[NPC live] Hospital failed:', error);
    return false;
  }
}

async function tryContinueTravel(npcId: number, playerId: number): Promise<boolean> {
  const status = await travelService.getJourneyStatus(playerId);
  if (!status.isInTransit) return false;
  if ((await cooldownService.checkCooldown(playerId, 'travel')) > 0) return false;
  if ((await policeService.checkIfJailed(playerId)) > 0) return false;
  try {
    const result = await travelService.continueJourney(playerId);
    await cooldownService.setCooldown(playerId, 'travel');
    await logNpcAction(
      npcId,
      'TRAVEL',
      { action: 'continue', country: result.newCountry },
      true,
      -result.travelCost,
    );
    return true;
  } catch (error) {
    console.error('[NPC live] Continue travel failed:', error);
    return false;
  }
}

function scoreCrime(
  crime: { id: string; minLevel: number; maxReward: number },
  playerRank: number,
  prefWeight: number,
): number {
  const stalePenalty = crime.minLevel < playerRank - 4 ? 0.35 : 1;
  return (crime.minLevel * 80 + crime.maxReward * 0.04 + prefWeight * 40) * stalePenalty;
}

function pickWeightedFrom<T>(items: Array<{ item: T; weight: number }>): T | null {
  if (items.length === 0) return null;
  const total = items.reduce((sum, entry) => sum + Math.max(0.01, entry.weight), 0);
  let roll = Math.random() * total;
  for (const entry of items) {
    roll -= Math.max(0.01, entry.weight);
    if (roll <= 0) return entry.item;
  }
  return items[0].item;
}

async function tryBuyGear(npcId: number, playerId: number, behavior: Behavior): Promise<number> {
  const player = await loadPlayer(playerId);
  if (!player) return 0;
  let bought = 0;

  const rankedCrimes = crimeService
    .getCrimesForLevel(player.rank)
    .filter((crime) => !crime.requiredDrugs?.length && crime.id !== 'criminal_record_wipe')
    .sort((a, b) => b.minLevel - a.minLevel || b.maxReward - a.maxReward)
    .slice(0, 6);

  for (const crime of rankedCrimes) {
    if (bought >= 3) break;
    const tools = await toolService.hasRequiredToolsForCrime(playerId, crime.id);
    for (const toolId of tools.missingTools) {
      if (bought >= 3) break;
      const definition = toolService.getToolDefinition(toolId);
      const price = definition?.basePrice ?? 0;
      const cashCap = Math.max(500, player.money * MAX_TOOL_PRICE_SHARE);
      if (price > MAX_TOOL_PRICE_ABS || price > cashCap) continue;
      const result = await toolService.buyTool(playerId, toolId);
      if (result.success) {
        bought += 1;
        await logNpcAction(npcId, 'PURCHASE', { itemType: 'tool', itemId: toolId }, true);
      }
    }
  }

  const ownedWeapons = await prisma.weaponInventory.count({ where: { playerId } });
  if (ownedWeapons === 0) {
    const result = await weaponService.buyWeapon(playerId, STARTER_WEAPON);
    if (result.success) {
      bought += 1;
      await weaponSelectionService.setSelectedCrimeWeapon(playerId, STARTER_WEAPON);
      await logNpcAction(npcId, 'PURCHASE', { itemType: 'weapon', itemId: STARTER_WEAPON }, true);
    }
  } else {
    const selected = await weaponSelectionService.getSelectedCrimeWeapon(playerId);
    if (!selected) {
      const first = await prisma.weaponInventory.findFirst({
        where: { playerId, condition: { gt: 0 } },
      });
      if (first) {
        await weaponSelectionService.setSelectedCrimeWeapon(playerId, first.weaponId);
      }
    }
  }

  return bought;
}

async function tryJob(npcId: number, playerId: number, behavior: Behavior): Promise<boolean> {
  if ((await cooldownService.checkCooldown(playerId, 'job')) > 0) return false;
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const { availableJobs } = await jobService.getJobsForPlayer(playerId, player.rank);
  if (availableJobs.length === 0) return false;

  const preferred = pickWeightedId(behavior.jobPreferences);
  const ranked = [...availableJobs].sort((a, b) => b.maxEarnings - a.maxEarnings);
  const topJobs = ranked.slice(0, Math.min(4, ranked.length));
  const preferredJob = availableJobs.find((item) => item.id === preferred);
  const job =
    (preferredJob && Math.random() < 0.35 ? preferredJob : null) ||
    pickWeightedFrom(topJobs.map((item, index) => ({ item, weight: topJobs.length - index }))) ||
    ranked[0];

  try {
    const result = await jobService.workJob(playerId, job.id);
    await cooldownService.setCooldown(
      playerId,
      'job',
      cooldownService.calculateJobCooldown(job.maxEarnings),
    );
    await logNpcAction(
      npcId,
      'JOB',
      { jobId: job.id, jobName: job.name },
      result.success,
      result.earnings || 0,
      result.xpGained || 0,
    );
    return true;
  } catch (error) {
    console.error('[NPC live] Job failed:', error);
    return false;
  }
}

async function tryCrime(npcId: number, playerId: number, behavior: Behavior): Promise<boolean> {
  if ((await cooldownService.checkCooldown(playerId, 'crime')) > 0) return false;
  const player = await loadPlayer(playerId);
  if (!player) return false;

  const doable: Array<{
    crime: NonNullable<ReturnType<typeof crimeService.getCrimeDefinition>>;
    vehicleId?: number;
    weight: number;
  }> = [];

  for (const crime of crimeService.getCrimesForLevel(player.rank)) {
    if (!crime || crime.requiredDrugs?.length) continue;
    if (crime.id === 'criminal_record_wipe') continue;

    const tools = await toolService.hasRequiredToolsForCrime(playerId, crime.id);
    if (!tools.hasAll) continue;

    let vehicleId: number | undefined;
    if (crime.requiredVehicle) {
      const vehicle = await findLocalVehicle(playerId, player.currentCountry);
      if (!vehicle) continue;
      vehicleId = vehicle.id;
    }

    if (crime.requiredWeapon) {
      const equipped = await weaponSelectionService.getEquippedWeapons(playerId);
      if (equipped.length === 0) continue;
      const ammoRows = await prisma.ammoInventory.findMany({
        where: { playerId },
        select: { ammoType: true, quantity: true },
      });
      const ammoCounts = new Map<string, number>();
      for (const row of ammoRows) {
        ammoCounts.set(row.ammoType, row.quantity);
      }
      const pickWeapon = crimeService.pickBestEquippedWeaponForCrime(
        crime.id,
        equipped,
        ammoCounts,
      );
      if (!pickWeapon.weapon) continue;
    }

    doable.push({
      crime,
      vehicleId,
      weight: scoreCrime(
        crime,
        player.rank,
        (behavior.crimePreferences as Record<string, number>)[crime.id] ?? 0,
      ),
    });
  }

  const ranked = doable.sort((a, b) => b.weight - a.weight).slice(0, 4);
  const pick = pickWeightedFrom(ranked.map((entry) => ({ item: entry, weight: entry.weight })));
  if (!pick) return false;

  try {
    const result = await crimeService.attemptCrime(
      playerId,
      pick.crime.id,
      pick.vehicleId,
    );
    await cooldownService.setCooldown(
      playerId,
      'crime',
      cooldownService.calculateCrimeCooldown(pick.crime.maxReward),
    );
    await logNpcAction(
      npcId,
      'CRIME',
      { crimeId: pick.crime.id, crimeName: pick.crime.name, jailed: result.jailed },
      result.success,
      result.reward || 0,
      result.xpGained || 0,
    );
    return true;
  } catch (error) {
    console.error('[NPC live] Crime failed:', pick.crime.id, error);
    return false;
  }
}

async function tryStealVehicle(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const existing = await findLocalVehicle(playerId, player.currentCountry);
  if (existing) return false;

  const cars = vehiclesData.cars
    .filter(
      (car) =>
        car.requiredRank <= player.rank &&
        (!car.availableInCountries?.length ||
          car.availableInCountries.includes(player.currentCountry)),
    )
    .sort((a, b) => a.baseValue - b.baseValue);
  if (cars.length === 0) return false;
  const vehicle = cars[Math.floor(Math.random() * Math.min(cars.length, 5))];

  try {
    const result = await vehicleService.stealVehicle(playerId, vehicle.id);
    await logNpcAction(
      npcId,
      'VEHICLE_THEFT',
      { itemId: vehicle.id, itemName: vehicle.name, success: result.success },
      Boolean(result.success),
      0,
      result.xpGained || 0,
    );
    return Boolean(result.success);
  } catch (error) {
    console.error('[NPC live] Vehicle theft failed:', error);
    return false;
  }
}

async function tryGym(npcId: number, playerId: number): Promise<boolean> {
  const status = await gymService.getStatus(playerId);
  const track = status.canTrainStrength
    ? 'strength'
    : status.canTrainSpeed
      ? 'speed'
      : status.canTrainStamina
        ? 'stamina'
        : null;
  if (!track) return false;
  const result = await gymService.train(playerId, track);
  if (!result.success) return false;
  await logNpcAction(npcId, 'TRAINING', { action: 'gym', track }, true);
  return true;
}

async function tryShootingRange(npcId: number, playerId: number): Promise<boolean> {
  const status = await shootingRangeService.getStatus(playerId);
  if (!status.canTrain) return false;
  const result = await shootingRangeService.train(playerId);
  if (!result.success) return false;
  await logNpcAction(npcId, 'TRAINING', { action: 'shooting_range' }, true);
  return true;
}

async function trySchool(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const trackIds = educationService.getTracks().map((track) => track.id);
  for (const trackId of trackIds) {
    try {
      await educationService.trainTrack(playerId, trackId, player.rank);
      await logNpcAction(npcId, 'TRAINING', { action: 'school', trackId }, true);
      return true;
    } catch {
      // Rank, cooldown or max-level — try the next track.
    }
  }
  return false;
}

async function tryBank(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player || player.money < 10000) return false;
  const reserve = 5000;
  const amount = Math.floor((player.money - reserve) * 0.15);
  if (amount < 250) return false;
  try {
    await bankService.getOrCreateBankAccount(playerId);
    await bankService.deposit(playerId, amount, 'npc-auto-deposit');
    await logNpcAction(npcId, 'BANK', { action: 'deposit', amount }, true, -amount);
    return true;
  } catch (error) {
    return false;
  }
}

async function tryTravel(npcId: number, playerId: number, chance: number): Promise<boolean> {
  if (Math.random() > chance) return false;
  if ((await cooldownService.checkCooldown(playerId, 'travel')) > 0) return false;
  const status = await travelService.getJourneyStatus(playerId);
  if (status.isInTransit) return false;
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const destinations = travelService
    .getAllCountriesWithRoutes(player.currentCountry)
    .filter((country) => country.id !== player.currentCountry);
  if (destinations.length === 0) return false;
  const destination = destinations[Math.floor(Math.random() * destinations.length)];
  try {
    const result = await travelService.startJourney(playerId, destination.id);
    await cooldownService.setCooldown(playerId, 'travel');
    await logNpcAction(
      npcId,
      'TRAVEL',
      { action: 'start', destination: destination.id },
      true,
      -result.travelCost,
    );
    return true;
  } catch (error) {
    return false;
  }
}

async function tryProperty(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const owned = await prisma.property.count({ where: { playerId } });
  if (owned > 0) return false;
  const result = await propertyService.claimProperty(
    playerId,
    'apartment',
    player.currentCountry,
  );
  if (!result.success) return false;
  await logNpcAction(
    npcId,
    'PURCHASE',
    { itemType: 'property', itemId: 'apartment' },
    true,
  );
  return true;
}

export async function runNpcLiveCycle(
  npcId: number,
  playerId: number,
  npcType: NPCType,
  options: NpcCycleOptions = {},
): Promise<NpcLiveCycleResult> {
  const behavior = npcBehaviors.behaviors[npcType];
  const result: NpcLiveCycleResult = {
    activitiesPerformed: 0,
    moneyEarned: 0,
    xpEarned: 0,
    arrests: 0,
    actions: [],
  };

  const mark = (action: string, ok: boolean) => {
    if (!ok) return;
    result.activitiesPerformed += 1;
    result.actions.push(action);
  };

  if (await policeService.checkIfJailed(playerId)) {
    mark('bail', await tryBail(npcId, playerId));
    mark('hospital', await tryHospital(npcId, playerId));
    return result;
  }

  if (await intensiveCareService.checkICUStatus(playerId)) {
    mark('hospital', await tryHospital(npcId, playerId));
    return result;
  }

  mark('travel-continue', await tryContinueTravel(npcId, playerId));
  if (await policeService.checkIfJailed(playerId)) {
    result.arrests += 1;
    return result;
  }

  mark('hospital', await tryHospital(npcId, playerId));
  const gearBought = await tryBuyGear(npcId, playerId, behavior);
  if (gearBought > 0) {
    result.activitiesPerformed += gearBought;
    result.actions.push('gear');
  }

  if (options.allowVehicleSteal !== false) {
    mark('vehicle', await tryStealVehicle(npcId, playerId));
  }
  mark('job', await tryJob(npcId, playerId, behavior));

  const beforeCrime = await loadPlayer(playerId);
  mark('crime', await tryCrime(npcId, playerId, behavior));
  const afterCrime = await loadPlayer(playerId);
  if (afterCrime?.jailRelease && afterCrime.jailRelease > new Date()) {
    result.arrests += 1;
  }
  if (afterCrime && beforeCrime) {
    result.moneyEarned += afterCrime.money - beforeCrime.money;
    result.xpEarned += afterCrime.xp - beforeCrime.xp;
  }

  mark('gym', await tryGym(npcId, playerId));
  mark('range', await tryShootingRange(npcId, playerId));
  mark('school', await trySchool(npcId, playerId));
  mark('property', await tryProperty(npcId, playerId));
  if (options.allowTravelStart !== false) {
    mark('travel', await tryTravel(npcId, playerId, behavior.travelChance ?? 0.2));
  }
  if (options.allowBank) {
    mark('bank', await tryBank(npcId, playerId));
  }

  return result;
}

async function advancePlayerSimClock(playerId: number, seconds: number): Promise<void> {
  if (seconds <= 0) return;

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      jailRelease: true,
      intensiveCareUntil: true,
      lastHospitalVisit: true,
    },
  });
  if (!player) return;

  await prisma.player.update({
    where: { id: playerId },
    data: {
      jailRelease: shiftDate(player.jailRelease, seconds),
      intensiveCareUntil: shiftDate(player.intensiveCareUntil, seconds),
      lastHospitalVisit: shiftDate(player.lastHospitalVisit, seconds),
    },
  });

  const cooldowns = await prisma.actionCooldown.findMany({
    where: { playerId },
    select: { id: true, lastUsedAt: true },
  });
  for (const cooldown of cooldowns) {
    const next = shiftDate(cooldown.lastUsedAt, seconds);
    if (!next) continue;
    await prisma.actionCooldown.update({
      where: { id: cooldown.id },
      data: { lastUsedAt: next },
    });
  }

  const gym = await prisma.gymStats.findUnique({ where: { playerId } });
  if (gym) {
    await prisma.gymStats.update({
      where: { playerId },
      data: {
        lastTrainedAt: shiftDate(gym.lastTrainedAt, seconds),
        speedLastTrainedAt: shiftDate(gym.speedLastTrainedAt, seconds),
        staminaLastTrainedAt: shiftDate(gym.staminaLastTrainedAt, seconds),
      },
    });
  }

  const range = await prisma.shootingRangeStats.findUnique({ where: { playerId } });
  if (range) {
    await prisma.shootingRangeStats.update({
      where: { playerId },
      data: { lastTrainedAt: shiftDate(range.lastTrainedAt, seconds) },
    });
  }

  const latestJail = await prisma.crimeAttempt.findFirst({
    where: { playerId, jailed: true },
    orderBy: { createdAt: 'desc' },
    select: { id: true, createdAt: true },
  });
  if (latestJail) {
    const nextCreated = shiftDate(latestJail.createdAt, seconds);
    if (nextCreated) {
      await prisma.crimeAttempt.update({
        where: { id: latestJail.id },
        data: { createdAt: nextCreated },
      });
    }
  }
}

async function playerWealth(playerId: number): Promise<{ cash: number; xp: number; bank: number }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, xp: true },
  });
  const bank = await prisma.bankAccount.findUnique({
    where: { playerId },
    select: { balance: true },
  });
  return {
    cash: player?.money ?? 0,
    xp: player?.xp ?? 0,
    bank: bank?.balance ?? 0,
  };
}

export async function simulateNpcGameHours(
  npcId: number,
  playerId: number,
  npcType: NPCType,
  hours: number,
): Promise<
  NpcLiveCycleResult & {
    ticks: number;
    intervalMinutes: number;
    calendarHours: number;
    activeHours: number;
    sleepMinutes: number;
  }
> {
  const intervalMinutes = tickMinutesForType(npcType);
  const calendarHours = hours;
  const activeHours = activeHoursForCalendar(npcType, calendarHours);
  const ticks = Math.max(1, Math.min(150, Math.round((activeHours * 60) / intervalMinutes)));
  const start = await playerWealth(playerId);
  const result: NpcLiveCycleResult & {
    ticks: number;
    intervalMinutes: number;
    calendarHours: number;
    activeHours: number;
    sleepMinutes: number;
  } = {
    activitiesPerformed: 0,
    moneyEarned: 0,
    xpEarned: 0,
    arrests: 0,
    actions: [],
    ticks,
    intervalMinutes,
    calendarHours,
    activeHours,
    sleepMinutes: 0,
  };

  for (let i = 0; i < ticks; i++) {
    const elapsedMinutes = i * intervalMinutes;
    const cycle = await runNpcLiveCycle(npcId, playerId, npcType, {
      allowBank: elapsedMinutes > 0 && elapsedMinutes % 240 === 0,
      allowTravelStart: elapsedMinutes === 0 || elapsedMinutes % 240 === 0,
      allowVehicleSteal: elapsedMinutes === 0 || elapsedMinutes % 60 === 0,
    });
    result.activitiesPerformed += cycle.activitiesPerformed;
    result.arrests += cycle.arrests;
    result.actions.push(...cycle.actions);
    if (i < ticks - 1) {
      await advancePlayerSimClock(playerId, intervalMinutes * 60);
    }
  }

  const activeMinutes = ticks * intervalMinutes;
  const sleepMinutes = Math.max(0, Math.round(calendarHours * 60 - activeMinutes));
  result.sleepMinutes = sleepMinutes;
  if (sleepMinutes > 0) {
    await advancePlayerSimClock(playerId, sleepMinutes * 60);
  }

  const end = await playerWealth(playerId);
  result.moneyEarned = end.cash + end.bank - (start.cash + start.bank);
  result.xpEarned = end.xp - start.xp;
  return result;
}
