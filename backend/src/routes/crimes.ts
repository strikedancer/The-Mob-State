import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { crimeService } from '../services/crimeService';
import * as policeService from '../services/policeService';
import * as cooldownService from '../services/cooldownService';
import { intensiveCareService } from '../services/intensiveCareService';
import { getWealthStatus } from '../utils/wealthSystem';
import { calculateReputationChange } from '../utils/rankSystem';
import { applyReputationDelta } from '../services/reputationService';
import { resolveSelectedCrimeVehicle } from '../services/vehicleToolService';
import { weaponSelectionService } from '../services/weaponSelectionService';
import { gameEventService } from '../services/gameEventService';

const router = Router();

function isExpectedCrimeRouteError(error: unknown): boolean {
  if (!(error instanceof Error)) {
    return false;
  }

  const { message } = error;
  return [
    'INVALID_CRIME_ID',
    'LEVEL_TOO_LOW',
    'NO_CRIMINAL_RECORD',
    'VEHICLE_REQUIRED',
    'VEHICLE_UNAVAILABLE',
    'VEHICLE_NOT_FOUND',
    'NOT_VEHICLE_OWNER',
    'VEHICLE_BROKEN',
    'NO_FUEL',
    'WEAPON_REQUIRED',
    'WEAPON_SELECTION_REQUIRED',
    'WEAPON_BROKEN',
    'NO_AMMO',
  ].includes(message)
    || message.startsWith('TOOL_REQUIRED')
    || message.startsWith('TOOL_IN_STORAGE')
    || message.startsWith('WEAPON_NOT_SUITABLE:')
    || message.startsWith('DRUGS_REQUIRED');
}

/**
 * GET /crimes
 * Get all available crimes with player-specific success chances
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  try {
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

    // Get player's selected vehicle for crime bonus calculations.
    let vehicleStats:
      | { speed: number; armor: number; cargo: number; stealth: number; condition: number }
      | undefined;
    if (playerId) {
      const selectedVehicle = await resolveSelectedCrimeVehicle(
        playerId,
        req.player!.currentCountry,
      );
      if (selectedVehicle) {
        vehicleStats = {
          speed: selectedVehicle.vehicle.speed,
          armor: selectedVehicle.vehicle.armor,
          cargo: selectedVehicle.vehicle.cargo,
          stealth: selectedVehicle.vehicle.stealth,
          condition: selectedVehicle.vehicle.condition,
        };
      }
    }

    // Calculate player-specific success chances and readiness for each crime.
    let crimesWithChances = crimes;
    if (playerId) {
      const readinessContext = await crimeService.buildCrimeReadinessContext(
        playerId,
        req.player!.rank,
        req.player!.currentCountry,
      );

      crimesWithChances = await Promise.all(
        crimes.map(async (crime) => {
          const vehicleStatsForCrime = crime.requiredVehicle ? vehicleStats : undefined;
          const playerSuccessChance = await crimeService.calculatePlayerSuccessChance(
            playerId,
            crime.id,
            undefined,
            vehicleStatsForCrime,
          );
          const readiness = crimeService.evaluateCrimeReadiness(
            crime.id,
            readinessContext,
          );
          return {
            ...crime,
            playerSuccessChance: Math.round(playerSuccessChance * 100),
            canAttempt: readiness.canAttempt,
            isAvailable: crimeService.isCrimeListedAvailable(
              crime.id,
              readinessContext,
            ),
            readinessBlocker: readiness.readinessBlocker,
            missingToolIds: readiness.missingToolIds,
            toolsInStorageIds: readiness.toolsInStorageIds,
            toolsReady: readiness.toolsReady,
            weaponReady: crimeService.isWeaponReadyForCrime(
              crime.id,
              readinessContext,
            ),
            selectedCrimeWeaponId: readinessContext.selectedWeapon?.weaponId ?? null,
            selectedCrimeWeaponName: readinessContext.selectedWeapon?.name ?? null,
          };
        }),
      );
    }

    return res.status(200).json({
      event: 'crimes.list',
      params: {},
      crimes: crimesWithChances,
    });
  } catch (error) {
    console.error('[Crimes Route] Error loading crimes list:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
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
      const selectedVehicle = await resolveSelectedCrimeVehicle(
        req.player!.id,
        req.player!.currentCountry,
      );
      if (selectedVehicle) {
        vehicleId = selectedVehicle.inventory.id;
      }
    }

    const crimeCooldownSeconds = cooldownService.calculateCrimeCooldown(crime.maxReward);

    // Check crime cooldown (dynamic based on crime reward tier)
    const remainingCooldown = await cooldownService.checkCooldown(
      req.player!.id,
      'crime',
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

    // Set cooldown after attempt using reward-tier pacing
    const cooldownInfo = await cooldownService.setCooldown(
      req.player!.id,
      'crime',
      crimeCooldownSeconds,
    );

    console.log('[Crime Route] Result:', JSON.stringify(result, null, 2));
    console.log('[Crime Route] Cooldown:', JSON.stringify(cooldownInfo, null, 2));

    // Record event contribution (fire-and-forget)
    if (result.success) {
      gameEventService.recordContribution(req.player!.id, 'crime', 1).catch(() => {});
    }

    // Reputation changes on crime outcomes and FBI escalation.
    let repDelta = 0;
    if (result.jailed) {
      repDelta += calculateReputationChange('crime_caught', false);
    } else {
      repDelta += calculateReputationChange('crime_success', result.success);
    }

    if (
      result.arrested &&
      String(result.arrestingAuthority || '').toUpperCase() === 'FBI'
    ) {
      repDelta += calculateReputationChange('fbi_arrest', false);
    }

    const newReputation = await applyReputationDelta(req.player!.id, repDelta);

    return res.status(200).json({
      event: result.success && !result.jailed ? 'crime.success' : 'crime.failed',
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
        weaponConfiscated: result.weaponConfiscated,
        vehicleChaseDamage: result.vehicleChaseDamage,
        clearedRecordCount: result.clearedRecordCount,
        sessionPayoutMultiplier: result.sessionPayoutMultiplier ?? 1,
        sessionAttemptsInWindow: result.sessionAttemptsInWindow ?? 0,
        sessionWindowMinutes: result.sessionWindowMinutes ?? 60,
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
        reputation: newReputation,
      },
      cooldown: cooldownInfo,
    });
  } catch (error) {
    if (!isExpectedCrimeRouteError(error)) {
      console.error('[Crime Route] Error:', error);
    }

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

      if (error.message === 'NO_CRIMINAL_RECORD') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'NO_CRIMINAL_RECORD' },
        });
      }

      if (error.message === 'VEHICLE_REQUIRED') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'VEHICLE_REQUIRED' },
        });
      }

      if (error.message === 'VEHICLE_UNAVAILABLE') {
        return res.status(400).json({
          event: 'crime.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
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
