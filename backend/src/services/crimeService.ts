import prisma from '../lib/prisma';
import crimesData from '../../content/crimes.json';
import { worldEventService } from './worldEventService';
import { activityService } from './activityService';
import * as policeService from './policeService';
import * as fbiService from './fbiService';
import { playerService } from './playerService';
import { weaponService } from './weaponService';
import { ammoService } from './ammoService';
import { intensiveCareService } from './intensiveCareService';
import toolService from './toolService';
import drugService from './drugService';
import { vehicleService } from './vehicleService';
import config from '../config';
import { processCrimeAttempt, CrimeOutcome } from '../utils/crimeOutcomeEngine';
import { getPlayerCrimeVehicle, getPlayerTool, degradeVehicle, degradeTool } from './vehicleToolService';
import { serializeAchievementForClient } from './achievementService';

interface CrimeDefinition {
  id: string;
  name: string;
  description: string;
  minLevel: number;
  baseSuccessChance: number;
  minReward: number;
  maxReward: number;
  xpReward: number;
  minXpReward?: number;
  maxXpReward?: number;
  jailTime: number;
  requiredVehicle: boolean;
  breakdownChance: number;
  isFederal?: boolean;
  requiredWeapon?: boolean;
  suitableWeaponTypes?: string[];
  minDamage?: number;
  minIntimidation?: number;
  requiredTools?: string[];
  requiredDrugs?: string[];
  minDrugQuantity?: number;
}

export const crimeService = {
  /**
   * Get all available crimes
   */
  getAvailableCrimes(): CrimeDefinition[] {
    return crimesData.crimes;
  },

  /**
   * Get crime definition by ID
   */
  getCrimeDefinition(crimeId: string): CrimeDefinition | undefined {
    return crimesData.crimes.find((c) => c.id === crimeId);
  },

  /**
   * Get crimes available for a player's level
   */
  getCrimesForLevel(playerLevel: number): CrimeDefinition[] {
    return crimesData.crimes.filter((c) => c.minLevel <= playerLevel);
  },

  /**
   * Attempt a crime
   */
  async attemptCrime(
    playerId: number,
    crimeId: string,
    vehicleId?: number,
    selectedWeaponId?: string,
  ): Promise<{
    success: boolean;
    reward: number;
    xpGained: number;
    xpLost: number;
    jailed: boolean;
    jailTime: number;
    vehicleBroken: boolean;
    arrested: boolean;
    arrestingAuthority?: string;
    wantedLevel: number;
    fbiHeat: number;
    bail?: number;
    newMoney: number;
    newXp: number;
    newRank: number;
    newHealth: number;
    outcome?: string;
    outcomeMessage?: string;
    vehicleConditionLoss?: number;
    toolDamageSustained?: number;
    vehicleConfiscated?: boolean;
    vehicleChaseDamage?: number;
    newlyUnlockedAchievements?: any[];
  }> {
    const crime = this.getCrimeDefinition(crimeId);
    if (!crime) {
      throw new Error('INVALID_CRIME_ID');
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        id: true,
        rank: true,
        xp: true,
        money: true,
        health: true,
      },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Check level requirement
    if (player.rank < crime.minLevel) {
      throw new Error('LEVEL_TOO_LOW');
    }

    // Check vehicle requirement
    let vehicleStats = null;
    let vehicleInventory = null;
    if (crime.requiredVehicle) {
      if (!vehicleId) {
        throw new Error('VEHICLE_REQUIRED');
      }

      vehicleInventory = await prisma.vehicleInventory.findUnique({
        where: { id: vehicleId },
      });

      if (!vehicleInventory) {
        throw new Error('VEHICLE_NOT_FOUND');
      }

      if (vehicleInventory.playerId !== playerId) {
        throw new Error('NOT_VEHICLE_OWNER');
      }

      if (vehicleInventory.fuelLevel <= 0) {
        throw new Error('NO_FUEL');
      }

      // Get vehicle definition to extract stats
      const vehicleDef = vehicleService.getVehicleById(vehicleInventory.vehicleId);
      if (vehicleDef && vehicleDef.stats) {
        vehicleStats = {
          ...vehicleDef.stats,
          condition: vehicleInventory.condition, // 0-100
        };
      }
    }

    // Check weapon requirements
    let weaponUsed = null;
    // let ammoConsumed = 0; // Commented out - not used yet

    if (crime.requiredWeapon) {
      if (!selectedWeaponId) {
        throw new Error('WEAPON_SELECTION_REQUIRED');
      }

      const selectedInventory = await prisma.weaponInventory.findUnique({
        where: {
          playerId_weaponId: {
            playerId,
            weaponId: selectedWeaponId,
          },
        },
        select: {
          weaponId: true,
          condition: true,
        },
      });

      if (!selectedInventory) {
        throw new Error('WEAPON_REQUIRED');
      }

      if (selectedInventory.condition <= 0) {
        throw new Error('WEAPON_BROKEN');
      }

      const selectedDefinition = weaponService
        .getAllWeapons()
        .find((w) => w.id === selectedInventory.weaponId);

      const suitableTypes = crime.suitableWeaponTypes || [];
      const isTypeAllowed =
        suitableTypes.length === 0 ||
        (selectedDefinition && suitableTypes.includes(selectedDefinition.type));
      const meetsDamage = (selectedDefinition?.damage ?? 0) >= (crime.minDamage || 0);
      const meetsIntimidation =
        (selectedDefinition?.intimidation ?? 0) >= (crime.minIntimidation || 0);

      if (!isTypeAllowed || !meetsDamage || !meetsIntimidation) {
        throw new Error(`WEAPON_NOT_SUITABLE:${suitableTypes.join(',')}`);
      }

      weaponUsed = selectedInventory;

      // Check if weapon requires ammo
      const weaponDef = weaponService.getAllWeapons().find(
        (w) => w.id === weaponUsed.weaponId,
      );

      if (weaponDef?.requiresAmmo && weaponDef.ammoType) {
        const ammoNeeded = weaponDef.ammoPerCrime || 1;
        console.log(`[CrimeService] Weapon ammo check - weaponId: ${weaponUsed.weaponId}, ammoType: ${weaponDef.ammoType}, ammoPerCrime: ${weaponDef.ammoPerCrime}, calculated ammoNeeded: ${ammoNeeded}`);

        // Check if player has enough ammo
        if (!(await ammoService.hasAmmo(playerId, weaponDef.ammoType, ammoNeeded))) {
          throw new Error('NO_AMMO');
        }

        // Consume ammo (this happens regardless of crime success)
        console.log(`[CrimeService] About to consume ammo - playerId: ${playerId}, ammoType: ${weaponDef.ammoType}, amount: ${ammoNeeded}`);
        await ammoService.consumeAmmo(playerId, weaponDef.ammoType, ammoNeeded);
        // ammoConsumed = ammoNeeded; // Commented out - variable not used
      }
    }

    // Check tool requirements (only carried inventory)
    const toolCheck = await toolService.hasRequiredToolsForCrime(playerId, crimeId);
    
    if (!toolCheck.hasAll) {
      // Check if tools are in storage
      if (toolCheck.toolsInStorage.length > 0) {
        const storageToolNames = toolCheck.toolsInStorage
          .map((toolId) => {
            const toolDef = toolService.getToolDefinition(toolId);
            return toolDef ? toolDef.name : toolId;
          })
          .join(', ');
        throw new Error(`TOOL_IN_STORAGE: ${storageToolNames}`);
      }
      
      // Tools completely missing
      const missingToolNames = toolCheck.missingTools
        .map((toolId) => {
          const toolDef = toolService.getToolDefinition(toolId);
          return toolDef ? toolDef.name : toolId;
        })
        .join(', ');
      throw new Error(`TOOL_REQUIRED: ${missingToolNames}`);
    }

    // Check drug requirements
    if (crime.requiredDrugs && crime.minDrugQuantity) {
      const hasDrugs = await drugService.hasRequiredDrugs(
        playerId,
        crime.requiredDrugs,
        crime.minDrugQuantity
      );

      if (!hasDrugs) {
        throw new Error(`DRUGS_REQUIRED:${crime.minDrugQuantity}:${crime.requiredDrugs.join(',')}`);
      }
    }

    // Get selected crime vehicle (from new system)
    let selectedVehicle = null;
    let selectedVehicleRecord = null;
    if (crime.requiredVehicle) {
      selectedVehicleRecord = await getPlayerCrimeVehicle(playerId);
      if (selectedVehicleRecord) {
        // Map to outcome engine format
        selectedVehicle = {
          id: selectedVehicleRecord.id,
          speed: selectedVehicleRecord.speed,
          armor: selectedVehicleRecord.armor,
          stealth: selectedVehicleRecord.stealth,
          cargo: selectedVehicleRecord.cargo,
          condition: selectedVehicleRecord.condition,
          fuel: selectedVehicleRecord.fuel,
          maxFuel: 100, // TODO: Get from vehicle definition if needed
        };
      }
    }

    // Get primary tool (if required)
    let primaryTool = null;
    let primaryToolRecord = null;
    const requiredTools = toolService.getRequiredToolsForCrime(crimeId);
    if (requiredTools.length > 0) {
      // Get first required tool
      primaryToolRecord = await getPlayerTool(playerId, requiredTools[0]);
      if (primaryToolRecord) {
        primaryTool = {
          id: primaryToolRecord.toolId,
          durability: primaryToolRecord.durability,
        };
      }
    }

    // Normalize requirement field names for outcome engine compatibility
    const normalizedCrimeForOutcome = {
      ...crime,
      requiresVehicle: crime.requiredVehicle,
      requiresWeapon: crime.requiredWeapon,
    };

    // Process crime attempt with outcome engine
    const crimeResult = await processCrimeAttempt(
      normalizedCrimeForOutcome,
      player.rank,
      selectedVehicle || undefined,
      primaryTool || undefined
    );

    // Apply vehicle degradation (if used)
    if (selectedVehicle && selectedVehicleRecord && crimeResult.vehicleConditionLoss) {
      await degradeVehicle(
        selectedVehicleRecord.id,
        crimeResult.vehicleConditionLoss,
        crimeResult.vehicleFuelUsed || 0
      );
    }

    // Apply tool degradation (if used)
    if (primaryTool && primaryToolRecord && crimeResult.toolDamageSustained) {
      await degradeTool(playerId, primaryTool.id, crimeResult.toolDamageSustained);
    }

    // Map outcome engine result to existing format
    const success = crimeResult.success;
    const reward = crimeResult.reward;
    let xpGained = crimeResult.xpGained;
    let xpLost = 0;
    let jailed = crimeResult.jailed;
    let jailTime = crimeResult.jailTime;
    const vehicleBroken = crimeResult.vehicleBrokeDown || false;

    // Handle XP loss on failure
    if (!success) {
      // Failure: Lose XP (10-25% of potential XP gain)
      const potentialXp = Math.round(
        ((crime.minXpReward ?? crime.xpReward) + (crime.maxXpReward ?? crime.xpReward)) / 2,
      );
      const xpLossPercent = 
        config.xpLoss.crimeFailed.min + 
        Math.random() * (config.xpLoss.crimeFailed.max - config.xpLoss.crimeFailed.min);
      const xpToLose = Math.floor(potentialXp * xpLossPercent);
      
      if (xpToLose > 0) {
        const lossResult = await playerService.loseXP(playerId, xpToLose);
        xpLost = lossResult.xpLost;
      }

      // Failure: Increase wanted level OR FBI heat (not both)
      if (crime.isFederal) {
        // Federal crime increases FBI heat
        await fbiService.increaseFBIHeat(playerId, config.fbiHeatIncreaseOnFederalCrimeFail);
      } else {
        // Regular crime increases wanted level
        await policeService.increaseWantedLevel(playerId, config.wantedLevelIncreaseOnCrimeFail);
      }

      // Additional jail check if outcome engine didn't jail
      if (!jailed) {
        const jailRoll = Math.random();
        if (jailRoll < config.crimeJailChance) {
          // 50% chance of getting caught and additional XP loss
          jailed = true;
          jailTime = crime.jailTime;
          
          // Additional XP loss when jailed (5% of current rank's XP requirement)
          const { getXPForRank } = await import('../config');
          const currentRankXP = getXPForRank(player.rank + 1) - getXPForRank(player.rank);
          const jailXPLoss = Math.floor(currentRankXP * config.xpLoss.crimeJailed);
          
          if (jailXPLoss > 0) {
            const jailLossResult = await playerService.loseXP(playerId, jailXPLoss);
            xpLost += jailLossResult.xpLost;
          }
        }
      }
    }

    const requiredToolsForCrime = toolService.getRequiredToolsForCrime(crimeId);

    // Execute transaction
    const result = await prisma.$transaction(async (tx) => {
      // Calculate health damage (5-15 HP per crime)
      const healthDamage = 5 + Math.floor(Math.random() * 11); // 5-15
      const newHealth = Math.max(0, player.health - healthDamage);

      // Track vehicle consequences
      let vehicleConfiscated = false;
      let vehicleChaseDamage = 0;

      // Update player money, XP, and health
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money + reward,
          xp: player.xp + xpGained,
          health: newHealth,
        },
      });

      // Check for rank up using exponential system
      const { getRankFromXP } = await import('../config');
      const calculatedNewRank = getRankFromXP(updatedPlayer.xp);
      if (calculatedNewRank > player.rank) {
        // Update rank in database and re-fetch updated player
        const playerWithNewRank = await tx.player.update({
          where: { id: playerId },
          data: { rank: calculatedNewRank },
        });
        // Update the returned player with new rank
        updatedPlayer.rank = playerWithNewRank.rank;
      }

      // Vehicle degradation already handled by outcome engine
      // Old vehicleInventory system kept for backward compatibility
      if (vehicleBroken && vehicleInventory && vehicleId) {
        await tx.vehicleInventory.update({
          where: { id: vehicleId },
          data: { isBroken: true },
        });
      }

      // Fuel consumption for old vehicleInventory system
      if (vehicleInventory && vehicleId) {
        await tx.vehicleInventory.update({
          where: { id: vehicleId },
          data: { fuelLevel: Math.max(0, vehicleInventory.fuelLevel - config.crimeFuelCost) },
        });
      }

      // Degrade weapon if used
      if (weaponUsed) {
        await weaponService.degradeWeapon(playerId, weaponUsed.weaponId);
      }

      // Tool degradation already handled by outcome engine
      // Tools still get confiscated when jailed
      if (jailed) {
        // Police confiscate all tools when caught
        await toolService.confiscateTools(playerId, requiredToolsForCrime);
      }
      // Note: Tool durability loss is handled by degradeTool() call above
      // so we skip the useTool() call to avoid double degradation

      // Vehicle consequences when arrested
      if (jailed && vehicleInventory && vehicleId) {
        const confiscationChance = 0.7; // 70% chance vehicle is seized
        
        if (Math.random() < confiscationChance) {
          // Police seize the vehicle (remove from inventory)
          await tx.vehicleInventory.delete({
            where: { id: vehicleId },
          });
          vehicleConfiscated = true;
        } else {
          // Heavy damage from chase (30-60% condition loss)
          const chaseDamage = 30 + Math.floor(Math.random() * 31); // 30-60
          const newCondition = Math.max(0, vehicleInventory.condition - chaseDamage);
          
          await tx.vehicleInventory.update({
            where: { id: vehicleId },
            data: { condition: newCondition },
          });
          vehicleChaseDamage = chaseDamage;
        }
      }

      // Handle drug consumption for drug deals
      if (crime.requiredDrugs && crime.minDrugQuantity && success) {
        // Find which drug the player has and consume it
        const inventory = await drugService.getDrugInventory(playerId);
        for (const drugType of crime.requiredDrugs) {
          const drug = inventory.find((d) => d.drugType === drugType && d.quantity >= crime.minDrugQuantity!);
          if (drug) {
            await drugService.consumeDrugs(playerId, drugType, crime.minDrugQuantity!);
            break; // Only consume one type
          }
        }
      }

      // Record crime attempt with detailed outcome data
      await tx.crimeAttempt.create({
        data: {
          player: {
            connect: { id: playerId }
          },
          crimeId,
          success,
          reward,
          xpGained,
          jailed,
          jailTime,
          vehicleId: selectedVehicleRecord?.id || null,
          usedToolId: primaryToolRecord?.toolId || null,
          outcome: crimeResult.outcome,
          outcomeFail: !success ? crimeResult.message : null,
          lootStolen: crimeResult.lootStolen,
          cargoUsed: crimeResult.cargoUsed,
          vehicleConditionUsed: crimeResult.vehicleConditionBefore || null,
          vehicleSpeedBonus: crimeResult.vehicleSpeedBonus ?? 1,
          vehicleCargoBonus: crimeResult.vehicleCargoBonus ?? 1,
          vehicleStealthBonus: crimeResult.vehicleStealthBonus ?? 1,
          toolConditionBefore: crimeResult.toolConditionBefore || null,
          toolDamageSustained: crimeResult.toolDamageSustained ?? 0,
        },
      });

      return {
        newMoney: updatedPlayer.money,
        newXp: updatedPlayer.xp,
        newRank: calculatedNewRank,
        newHealth,
        healthDamage,
        xpLost,
        vehicleConfiscated,
        vehicleChaseDamage,
      };
    });

    // Check if player needs ICU (health reached 0)
    if (result.newHealth === 0) {
      await intensiveCareService.checkAndApplyICU(playerId, result.newHealth);
    }

    // Create world event
    if (success) {
      await worldEventService.createEvent('crime.success', {
        playerId,
        crimeName: crime.name,
        reward,
        xpGained,
      });

      // Log activity for friend feed
      await activityService.logActivity(
        playerId,
        'CRIME',
        `Completed ${crime.name} and earned €${reward.toLocaleString()}`,
        {
          crimeId: crime.id,
          crimeName: crime.name,
          reward,
          xpGained,
        },
        true
      );

      // Check if player ranked up
      if (result.newRank > player.rank) {
        await activityService.logActivity(
          playerId,
          'RANK_UP',
          `Ranked up to level ${result.newRank}!`,
          {
            oldRank: player.rank,
            newRank: result.newRank,
          },
          true
        );
      }
    } else if (jailed) {
      await worldEventService.createEvent('crime.caught', {
        playerId,
        crimeName: crime.name,
        jailTime,
      });
    }

    // Check if player gets arrested (FBI for federal crimes, police for regular)
    // ONLY if not already jailed by the crime outcome itself
    let arrested = false;
    let arrestingAuthority = '';
    let heatLevel = 0;
    let bailAmount = 0;

    if (!jailed) {
      // Only check for wanted level arrest if crime didn't already jail the player
      if (crime.isFederal) {
        // FBI arrest for federal crimes
        const fbiArrestResult = await fbiService.checkFBIArrest(playerId);

        if (fbiArrestResult.arrested) {
          const federalJailTime = fbiArrestResult.federalJailTime || 60;
          await fbiService.jailPlayerFederal(playerId, federalJailTime);

          await worldEventService.createEvent('fbi.arrested', {
            playerId,
            fbiHeat: fbiArrestResult.fbiHeat,
            federalBail: fbiArrestResult.federalBail,
            jailTime: federalJailTime,
          });

          arrested = true;
          arrestingAuthority = 'FBI';
          heatLevel = fbiArrestResult.fbiHeat;
          bailAmount = fbiArrestResult.federalBail || 0;
          
          // Update jailed status to true since we're arresting now
          jailed = true;
          jailTime = federalJailTime;
        } else {
          heatLevel = fbiArrestResult.fbiHeat;
        }
      } else {
        // Police arrest for regular crimes
        const policeArrestResult = await policeService.checkArrest(playerId);

        if (policeArrestResult.arrested) {
          const policeJailTime = policeArrestResult.jailTime || 30;
          await policeService.jailPlayer(playerId, policeJailTime);

          await worldEventService.createEvent('police.arrested', {
            playerId,
            wantedLevel: policeArrestResult.wantedLevel,
            bail: policeArrestResult.bail,
            jailTime: policeJailTime,
          });

          arrested = true;
          arrestingAuthority = 'Police';
          heatLevel = policeArrestResult.wantedLevel;
          bailAmount = policeArrestResult.bail || 0;
          
          // Update jailed status to true since we're arresting now
          jailed = true;
          jailTime = policeJailTime;
        } else {
          heatLevel = policeArrestResult.wantedLevel;
        }
      }
    } else {
      // Already jailed by crime outcome, just get current heat levels for response
      if (crime.isFederal) {
        const fbiArrestResult = await fbiService.checkFBIArrest(playerId);
        heatLevel = fbiArrestResult.fbiHeat;
      } else {
        const policeArrestResult = await policeService.checkArrest(playerId);
        heatLevel = policeArrestResult.wantedLevel;
      }
    }

    if (!success) {
      await activityService.logActivity(
        playerId,
        'CRIME_FAILED',
        `Failed ${crime.name}${jailed ? ' and got caught' : ''}`,
        {
          crimeId: crime.id,
          crimeName: crime.name,
          outcome: crimeResult.outcome,
          outcomeMessage: crimeResult.message,
          xpLost,
          jailed,
          jailTime,
          wantedLevel: crime.isFederal ? undefined : heatLevel,
          fbiHeat: crime.isFederal ? heatLevel : undefined,
          bail: bailAmount,
          confiscatedTools: jailed ? requiredToolsForCrime : [],
        },
        true
      );
    }

    if (!success && jailed && !arrested) {
      await activityService.logActivity(
        playerId,
        'ARREST',
        `Arrested after ${crime.name}`,
        {
          crimeId: crime.id,
          crimeName: crime.name,
          authority: arrestingAuthority || (crime.isFederal ? 'FBI' : 'Police'),
          jailTime,
          bail: bailAmount,
          wantedLevel: crime.isFederal ? undefined : heatLevel,
          fbiHeat: crime.isFederal ? heatLevel : undefined,
        },
        true
      );
    }

    // Check for achievement unlocks if crime was successful
    let newlyUnlockedAchievements: any[] = [];
    if (success) {
      try {
        const { checkAndUnlockAchievements } = await import('./achievementService');
        const achievementResults = await checkAndUnlockAchievements(playerId);
        newlyUnlockedAchievements = achievementResults.map(r =>
          serializeAchievementForClient(r.achievement)
        );
      } catch (err) {
        console.error('[Achievement Check] Error after crime:', err);
      }
    }

    return {
      success,
      reward,
      xpGained,
      xpLost,
      jailed,
      jailTime,
      vehicleBroken,
      arrested,
      arrestingAuthority,
      wantedLevel: crime.isFederal ? 0 : heatLevel,
      fbiHeat: crime.isFederal ? heatLevel : 0,
      bail: bailAmount,
      newMoney: result.newMoney,
      newXp: result.newXp,
      newRank: result.newRank,
      newHealth: result.newHealth,
      outcome: crimeResult.outcome,
      outcomeMessage: crimeResult.message,
      vehicleConditionLoss: crimeResult.vehicleConditionLoss,
      toolDamageSustained: crimeResult.toolDamageSustained,
      vehicleConfiscated: result.vehicleConfiscated,
      vehicleChaseDamage: result.vehicleChaseDamage,
      newlyUnlockedAchievements,
      // weaponUsed: weaponUsed?.weaponId || null,
      // ammoConsumed,
    };
  },

  /**
   * Get player's crime history
   */
  async getCrimeHistory(
    playerId: number,
    limit: number = 20
  ): Promise<
    Array<{
      id: number;
      crimeId: string;
      crimeName: string;
      success: boolean;
      reward: number;
      xpGained: number;
      jailed: boolean;
      jailTime: number;
      createdAt: Date;
    }>
  > {
    const attempts = await prisma.crimeAttempt.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
      take: limit,
      select: {
        id: true,
        crimeId: true,
        success: true,
        reward: true,
        xpGained: true,
        jailed: true,
        jailTime: true,
        createdAt: true,
      },
    });

    return attempts.map((attempt) => {
      const crime = this.getCrimeDefinition(attempt.crimeId);
      return {
        ...attempt,
        crimeName: crime?.name || 'Unknown',
      };
    });
  },

  /**
   * Calculate the success chance for a player attempting a specific crime
   * Base model:
   * - Always: base chance + rank bonus + mastery bonus
   * - Tools crimes: add tool condition modifier
   * - Vehicle crimes: add vehicle stat modifier
   * - Tools + Vehicle crimes: both modifiers apply
   */
  async calculatePlayerSuccessChance(
    playerId: number,
    crimeId: string,
    weaponUsed?: { weaponId: string; condition: number },
    vehicleStats?: { speed: number; armor: number; cargo: number; stealth: number; condition: number }
  ): Promise<number> {
    const crime = this.getCrimeDefinition(crimeId);
    if (!crime) {
      return 0;
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { rank: true },
    });

    if (!player) {
      return crime.baseSuccessChance;
    }

    // Base scaling: keep early game challenging.
    // Example: easiest crime 70% base -> ~27% starting chance.
    const baseScaledChance = crime.baseSuccessChance * 0.385;
    let successChance = baseScaledChance;

    // 1️⃣ RANK ADVANTAGE: modest bonus only for ranks above crime minimum
    // +0.2% per level above requirement (max +8%)
    const levelsAboveRequirement = Math.max(0, player.rank - crime.minLevel);
    const rankBonus = Math.min(levelsAboveRequirement * 0.002, 0.08);
    successChance += rankBonus;

    // 2️⃣ CRIME MASTERY: Get player's experience with this specific crime
    // +1% success per 5 attempts (max +10% at 50 attempts)
    const crimeAttempts = await prisma.crimeAttempt.count({
      where: {
        playerId: playerId,
        crimeId: crimeId,
      },
    });
    const masteryBonus = Math.min((crimeAttempts / 5) * 0.01, 0.10); // Max 10% bonus
    successChance += masteryBonus;

    // 3️⃣ WEAPON BONUS: Using correct weapon type
    if (weaponUsed && crime.suitableWeaponTypes) {
      const weaponDef = weaponService.getAllWeapons().find(
        (w) => w.id === weaponUsed.weaponId
      );

      if (weaponDef && crime.suitableWeaponTypes.includes(weaponDef.type)) {
        // 10% success bonus for correct weapon
        successChance += 0.1;

        // Additional 5% bonus for good weapon condition (>80%)
        if (weaponUsed.condition > 80) {
          successChance += 0.05;
        }
      }
    }

    // 4️⃣ TOOL BONUS: Only for crimes that require tools
    if (crime.requiredTools && crime.requiredTools.length > 0) {
      const toolConditionPercents: number[] = [];

      for (const requiredToolId of crime.requiredTools) {
        const playerTool = await getPlayerTool(playerId, requiredToolId);
        const toolDef = toolService.getToolDefinition(requiredToolId);

        if (playerTool && toolDef && toolDef.maxDurability > 0) {
          const conditionPercent = Math.max(
            0,
            Math.min(100, (playerTool.durability / toolDef.maxDurability) * 100)
          );
          toolConditionPercents.push(conditionPercent);
        }
      }

      if (toolConditionPercents.length > 0) {
        const avgToolCondition =
          toolConditionPercents.reduce((sum, value) => sum + value, 0) /
          toolConditionPercents.length;

        // Tool condition from 50% baseline: -8% at 0%, +8% at 100%
        const normalizedToolCondition = (avgToolCondition - 50) / 50;
        const toolBonus = normalizedToolCondition * 0.08;
        successChance += toolBonus;
      }
    }

    // 5️⃣ VEHICLE BONUS: Only for crimes that require a vehicle
    if (crime.requiredVehicle && vehicleStats) {
      const conditionMultiplier = vehicleStats.condition / 100; // 0-1 based on condition %
      let vehicleBonus = 0;

      // Speed bonus: 1% per 5 speed points (max 19%)
      const speedBonus = Math.min((vehicleStats.speed / 5) * 0.01, 0.19);
      vehicleBonus += speedBonus * conditionMultiplier;

      // Armor bonus: 1% per 10 armor points (max 5%)
      const armorBonus = Math.min((vehicleStats.armor / 10) * 0.01, 0.05);
      vehicleBonus += armorBonus * conditionMultiplier;

      // Cargo bonus: 1% per 20 cargo capacity (max 5%)
      const cargoBonus = Math.min((vehicleStats.cargo / 20) * 0.01, 0.05);
      vehicleBonus += cargoBonus * conditionMultiplier;

      // Stealth bonus: 1% per 10 stealth points (max 9.5%)
      const stealthBonus = Math.min((vehicleStats.stealth / 10) * 0.01, 0.095);
      vehicleBonus += stealthBonus * conditionMultiplier;

      successChance += vehicleBonus;
    }

    // 6️⃣ SHOOTING RANGE TRAINING: Accuracy bonus from training
    // Max +10% from 100 sessions (0.1% per session)
    const shootingStats = await prisma.shootingRangeStats.findUnique({
      where: { playerId },
      select: { accuracyBonus: true },
    });
    if (shootingStats?.accuracyBonus) {
      successChance += shootingStats.accuracyBonus;
    }

    // 7️⃣ GYM TRAINING: Strength bonus from training
    // Max +8% from 100 sessions (0.08% per session)
    const gymStats = await prisma.gymStats.findUnique({
      where: { playerId },
      select: { strengthBonus: true },
    });
    if (gymStats?.strengthBonus) {
      successChance += gymStats.strengthBonus;
    }

    // Keep realistic bounds: at least 5%, at most 95%
    return Math.max(0.05, Math.min(successChance, 0.95));
  },
};
