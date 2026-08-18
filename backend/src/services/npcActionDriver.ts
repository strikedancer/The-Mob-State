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

const STARTER_TOOLS = ['spray_paint', 'bolt_cutter', 'car_theft_tools', 'burglary_kit', 'crowbar'];
const STARTER_WEAPON = 'knife';

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

async function tryBuyGear(npcId: number, playerId: number, behavior: Behavior): Promise<number> {
  const player = await loadPlayer(playerId);
  if (!player) return 0;
  let bought = 0;

  for (const crimeId of Object.keys(behavior.crimePreferences)) {
    const crime = crimeService.getCrimeDefinition(crimeId);
    if (!crime || player.rank < crime.minLevel) continue;
    const tools = await toolService.hasRequiredToolsForCrime(playerId, crimeId);
    for (const toolId of tools.missingTools) {
      if (!STARTER_TOOLS.includes(toolId)) continue;
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
  const job =
    availableJobs.find((item) => item.id === preferred) ||
    availableJobs[Math.floor(Math.random() * availableJobs.length)];

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

  const preferredOrder = Object.entries(behavior.crimePreferences).sort((a, b) => b[1] - a[1]);
  const candidates = [
    ...preferredOrder.map(([id]) => id),
    ...crimeService.getCrimesForLevel(player.rank).map((crime) => crime.id),
  ];

  for (const crimeId of candidates) {
    const crime = crimeService.getCrimeDefinition(crimeId);
    if (!crime || player.rank < crime.minLevel) continue;
    if (crime.requiredDrugs?.length) continue;
    if (crimeId === 'criminal_record_wipe') continue;

    const tools = await toolService.hasRequiredToolsForCrime(playerId, crimeId);
    if (!tools.hasAll) continue;

    let vehicleId: number | undefined;
    if (crime.requiredVehicle) {
      const vehicle = await findLocalVehicle(playerId, player.currentCountry);
      if (!vehicle) continue;
      vehicleId = vehicle.id;
    }

    let selectedWeaponId: string | undefined;
    if (crime.requiredWeapon) {
      const selected = await weaponSelectionService.getSelectedCrimeWeapon(playerId);
      if (!selected) continue;
      selectedWeaponId = selected.weaponId;
    }

    try {
      const result = await crimeService.attemptCrime(
        playerId,
        crimeId,
        vehicleId,
        selectedWeaponId,
      );
      await cooldownService.setCooldown(
        playerId,
        'crime',
        cooldownService.calculateCrimeCooldown(crime.maxReward),
      );
      await logNpcAction(
        npcId,
        'CRIME',
        { crimeId, crimeName: crime.name, jailed: result.jailed },
        result.success,
        result.reward || 0,
        result.xpGained || 0,
      );
      return true;
    } catch (error) {
      console.error('[NPC live] Crime failed:', crimeId, error);
    }
  }

  return false;
}

async function tryStealVehicle(npcId: number, playerId: number): Promise<boolean> {
  const player = await loadPlayer(playerId);
  if (!player) return false;
  const existing = await findLocalVehicle(playerId, player.currentCountry);
  if (existing) return false;

  const cars = vehiclesData.cars.filter(
    (car) =>
      car.requiredRank <= player.rank &&
      (!car.availableInCountries?.length ||
        car.availableInCountries.includes(player.currentCountry)),
  );
  if (cars.length === 0) return false;
  const vehicle = cars[Math.floor(Math.random() * Math.min(cars.length, 4))];

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
  if (!player || player.money < 2500) return false;
  const amount = Math.floor(player.money * 0.2);
  if (amount < 100) return false;
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

  mark('vehicle', await tryStealVehicle(npcId, playerId));
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
  mark('travel', await tryTravel(npcId, playerId, behavior.travelChance ?? 0.2));
  mark('bank', await tryBank(npcId, playerId));

  return result;
}
