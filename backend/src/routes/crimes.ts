import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { crimeService } from '../services/crimeService';
import * as policeService from '../services/policeService';
import * as cooldownService from '../services/cooldownService';
import { intensiveCareService } from '../services/intensiveCareService';
import { getWealthStatus } from '../utils/wealthSystem';
import { getPlayerCrimeVehicle } from '../services/vehicleToolService';
import { weaponSelectionService } from '../services/weaponSelectionService';
import prisma from '../lib/prisma';
import { gameEventService } from '../services/gameEventService';

const router = Router();

/**
 * GET /crimes
 * Get all available crimes with player-specific success chances
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player?.id;
  
  if (playerId) {
    // Check for active cooldown
    const cooldown = await cooldownService.getCooldown(playerId, 'crime');
    if (cooldown && cooldown.remainingSeconds > 0) {
      return res.status(200).json({
        event: 'crimes.list',
        params: {},
        crimes: [],
        cooldown: {
          actionType: 'crime',
          remainingSeconds: cooldown.remainingSeconds,
        },
      });
    }
  }
  
  const crimes = crimeService.getAvailableCrimes();

  // Get player's selected vehicle for crime bonus calculations
  let vehicleStats: { speed: number; armor: number; cargo: number; stealth: number; condition: number } | undefined;
  if (playerId) {
    const selectedVehicle = await getPlayerCrimeVehicle(playerId);
    if (selectedVehicle) {
      vehicleStats = {
        speed: selectedVehicle.speed,
        armor: selectedVehicle.armor,
        cargo: selectedVehicle.cargo,
        stealth: selectedVehicle.stealth,
        condition: selectedVehicle.condition,
      };
    }
  }

  // Calculate player-specific success chances for each crime
  let crimesWithChances = crimes;
  if (playerId) {
    crimesWithChances = await Promise.all(
      crimes.map(async (crime) => {
        const vehicleStatsForCrime = crime.requiredVehicle ? vehicleStats : undefined;
        const playerSuccessChance = await crimeService.calculatePlayerSuccessChance(
          playerId,
          crime.id,
          undefined, // weaponUsed
          vehicleStatsForCrime // Only apply vehicle bonus to crimes that require a vehicle
        );
        return {
          ...crime,
          playerSuccessChance: Math.round(playerSuccessChance * 100), // Convert to percentage
        };
      })
    );
  }

  return res.status(200).json({
    event: 'crimes.list',
    params: {},
    crimes: crimesWithChances,
  });
});

/**
 * GET /crimes/available
 * Get crimes available for the player's level
 */
router.get('/available', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const crimes = crimeService.getCrimesForLevel(req.player!.rank);

    return res.status(200).json({
      event: 'crimes.available',
      params: {},
      crimes,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /crimes/history
 * Get player's crime history
 */
router.get('/history', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const limit = parseInt((req.query.limit as string) || '20', 10);
    const history = await crimeService.getCrimeHistory(req.player!.id, limit);

    return res.status(200).json({
      event: 'crimes.history',
      params: {},
      history,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /crimes/:crimeId/attempt
 * Attempt a crime
 */
router.post(
  '/:crimeId/attempt', 
  authenticate,
  async (req: AuthRequest, res: Response) => {
  try {
    const crimeId = req.params.crimeId as string;

    // Get crime definition for dynamic cooldown calculation
    const crime = crimeService.getCrimeDefinition(crimeId);
    if (!crime) {
      return res.status(404).json({
        event: 'crime.error',
        params: {
          reason: 'INVALID_CRIME_ID',
        },
      });
    }

    // Get player's selected vehicle for crimes
    let vehicleId: number | undefined;
    if (crime.requiredVehicle) {
      const selectedVehicle = await getPlayerCrimeVehicle(req.player!.id);
      if (selectedVehicle) {
        // Find the VehicleInventory record with matching type
        const vehicleInventory = await prisma.vehicleInventory.findFirst({
          where: {
            playerId: req.player!.id,
            vehicleId: selectedVehicle.vehicleType,
          },
          orderBy: {
            stolenAt: 'desc',
          },
        });
        if (vehicleInventory) {
          vehicleId = vehicleInventory.id;
        }
      }
    }

    // Check crime cooldown (fixed 90 seconds for all crimes)
    const remainingCooldown = await cooldownService.checkCooldown(
      req.player!.id, 
      'crime'
    );

    if (remainingCooldown > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType: 'crime',
          remainingSeconds: remainingCooldown,
          message: `You must wait ${remainingCooldown} seconds before performing this action again`,
        },
      });
    }

    // Check if player is in intensive care
    const icuMinutes = await intensiveCareService.checkICUStatus(req.player!.id);
    if (icuMinutes > 0) {
      return res.status(403).json({
        event: 'error.inICU',
        params: {
          message: `Je ligt op de intensive care. Je kunt over ${icuMinutes} minuten weer actief worden.`,
          remainingMinutes: icuMinutes,
        },
      });
    }

    // Check if player is in jail
    const remainingJailTime = await policeService.checkIfJailed(req.player!.id);
    if (remainingJailTime > 0) {
      return res.status(403).json({
        event: 'error.jailed',
        params: {
          remainingTime: remainingJailTime,
        },
      });
    }

    const selectedWeapon = await weaponSelectionService.getSelectedCrimeWeapon(
      req.player!.id,
    );

    const result = await crimeService.attemptCrime(
      req.player!.id,
      crimeId,
      vehicleId ? parseInt(vehicleId, 10) : undefined,
      selectedWeapon?.weaponId,
    );

    // Set cooldown after attempt (fixed 90 seconds for all crimes)
    const cooldownInfo = await cooldownService.setCooldown(req.player!.id, 'crime');

    console.log('[Crime Route] Result:', JSON.stringify(result, null, 2));
    console.log('[Crime Route] Cooldown:', JSON.stringify(cooldownInfo, null, 2));

    // Record event contribution (fire-and-forget)
    if (result.success) {
      gameEventService.recordContribution(req.player!.id, 'crime', 1).catch(() => {});
    }

    return res.status(200).json({
      event: result.success ? 'crime.success' : 'crime.failed',
      params: {
        crimeId,
        crimeName: crime.name,
        success: result.success,
        reward: result.reward,
        xpGained: result.xpGained,
        jailed: result.jailed,
        jailTime: result.jailTime,
        vehicleBroken: result.vehicleBroken,
        arrested: result.arrested,
        arrestingAuthority: result.arrestingAuthority,
        wantedLevel: result.wantedLevel,
        fbiHeat: result.fbiHeat,
        bail: result.bail,
        vehicleConfiscated: result.vehicleConfiscated,
        vehicleChaseDamage: result.vehicleChaseDamage,
      },
      player: {
        money: result.newMoney,
        xp: result.newXp,
        rank: result.newRank,
        health: result.newHealth,
        wantedLevel: result.wantedLevel,
        fbiHeat: result.fbiHeat,
        wealthStatus: getWealthStatus(result.newMoney).title,
        wealthIcon: getWealthStatus(result.newMoney).icon,
      },
      cooldown: cooldownInfo,
    });
  } catch (error) {
    console.error('[Crime Route] Error:', error);
    if (error instanceof Error) {
      if (error.message === 'INVALID_CRIME_ID') {
        return res.status(404).json({
          event: 'crime.error',
          params: { reason: 'INVALID_CRIME_ID' },
        });
      }

      if (error.message === 'LEVEL_TOO_LOW') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'LEVEL_TOO_LOW' },
        });
      }

      if (error.message === 'VEHICLE_REQUIRED') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'VEHICLE_REQUIRED' },
        });
      }

      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'crime.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_VEHICLE_OWNER') {
        return res.status(403).json({
          event: 'crime.error',
          params: { reason: 'NOT_VEHICLE_OWNER' },
        });
      }

      if (error.message === 'VEHICLE_BROKEN') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'VEHICLE_BROKEN' },
        });
      }

      if (error.message === 'NO_FUEL') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'NO_FUEL' },
        });
      }

      if (error.message.startsWith('TOOL_REQUIRED')) {
        // Extract tool names from error message "TOOL_REQUIRED: Tool1, Tool2"
        const toolNames = error.message.split(': ')[1] || 'gereedschap';
        return res.status(400).json({
          event: 'crime.error',
          params: { 
            reason: 'TOOL_REQUIRED',
            tools: toolNames
          },
        });
      }

      if (error.message.startsWith('TOOL_IN_STORAGE')) {
        // Extract tool names from error message "TOOL_IN_STORAGE: Tool1, Tool2"
        const toolNames = error.message.split(': ')[1] || 'gereedschap';
        return res.status(400).json({
          event: 'crime.error',
          params: { 
            reason: 'TOOL_IN_STORAGE',
            tools: toolNames
          },
        });
      }

      if (error.message === 'WEAPON_REQUIRED') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'WEAPON_REQUIRED' },
        });
      }

      if (error.message === 'WEAPON_SELECTION_REQUIRED') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'WEAPON_SELECTION_REQUIRED' },
        });
      }

      if (error.message.startsWith('WEAPON_NOT_SUITABLE:')) {
        const suitableTypes = error.message.split(':')[1];
        return res.status(400).json({
          event: 'crime.error',
          params: { 
            reason: 'WEAPON_NOT_SUITABLE',
            suitableTypes: suitableTypes
          },
        });
      }

      if (error.message === 'WEAPON_BROKEN') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'WEAPON_BROKEN' },
        });
      }

      if (error.message === 'NO_AMMO') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'NO_AMMO' },
        });
      }

      if (error.message.startsWith('DRUGS_REQUIRED')) {
        const [, minDrugQuantityRaw, requiredDrugsRaw] = error.message.split(':');
        const minDrugQuantity = Number.parseInt(minDrugQuantityRaw || '1', 10) || 1;
        const requiredDrugs = (requiredDrugsRaw || '')
          .split(',')
          .map((drug) => drug.trim())
          .filter(Boolean);
        return res.status(400).json({
          event: 'crime.error',
          params: {
            reason: 'DRUGS_REQUIRED',
            minDrugQuantity,
            requiredDrugs,
          },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
