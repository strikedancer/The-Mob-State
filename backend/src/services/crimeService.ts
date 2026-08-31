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
import { weaponSelectionService } from './weaponSelectionService';
import config from '../config';
import { processCrimeAttempt, CrimeOutcome } from '../utils/crimeOutcomeEngine';
import { getPlayerTool, degradeTool, resolveSelectedCrimeVehicle } from './vehicleToolService';
import { serializeAchievementForClient } from './achievementService';
import * as judgeService from './judgeService';
import { notificationService } from './notificationService';
import { economyBalanceService } from './economyBalanceService';
import { getActiveEventBoostEffects } from './premiumCreditsService';
import {
  isTrainingComboReadinessActive,
  TRAINING_COMBO_READINESS_BONUS,
} from '../lib/trainingComboReadiness';
import { latestGymTrainAt } from './gymService';
import {
  scaleCrimeJailMinutes,
  crimeFailWantedIncrease,
} from '../utils/crimeJailScaling';

const CRIMINAL_RECORD_WIPE_CRIME_ID = 'criminal_record_wipe';
/** Minimum rank to steal cars — keep in sync with vehicleService.stealVehicle. */
const LAND_VEHICLE_THEFT_MIN_RANK = 5;

async function runCrimeSideEffect(
  label: string,
  effect: () => Promise<void>,
): Promise<void> {
  try {
    await effect();
  } catch (error) {
    console.error(`[Crime Service] ${label} failed:`, error);
  }
}

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
    vehicleFuelUsed?: number;
    toolDamageSustained?: number;
    vehicleConfiscated?: boolean;
    weaponConfiscated?: boolean;
    vehicleChaseDamage?: number;
    newlyUnlockedAchievements?: any[];
    clearedRecordCount?: number;
    sessionPayoutMultiplier?: number;
    sessionAttemptsInWindow?: number;
    sessionWindowMinutes?: number;
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
        currentCountry: true,
      },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Check level requirement
    if (player.rank < crime.minLevel) {
      throw new Error('LEVEL_TOO_LOW');
    }

    if (crimeId === CRIMINAL_RECORD_WIPE_CRIME_ID) {
      const visibleConvictionCount = await judgeService.getVisibleCriminalRecordCount(playerId);
      if (visibleConvictionCount <= 0) {
        throw new Error('NO_CRIMINAL_RECORD');
      }
    }

    // Check vehicle requirement
    let selectedVehicle: {
      id: number;
      speed: number;
      armor: number;
      stealth: number;
      cargo: number;
      condition: number;
      fuel: number;
      maxFuel: number;
    } | null = null;
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
      selectedVehicle = {
        id: vehicleInventory.id,
        speed: vehicleDef?.stats.speed ?? 50,
        armor: vehicleDef?.stats.armor ?? 50,
        stealth: vehicleDef?.stats.stealth ?? 50,
        cargo: vehicleDef?.stats.cargo ?? 50,
        condition: vehicleInventory.condition,
        fuel: vehicleInventory.fuelLevel,
        maxFuel: vehicleDef?.fuelCapacity ?? 100,
      };
    }

    // Check weapon requirements
    let weaponUsed = null;
    let pendingAmmoRequirement: { ammoType: string; amount: number } | null = null;

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

        // Check if player has enough ammo
        if (!(await ammoService.hasAmmo(playerId, weaponDef.ammoType, ammoNeeded))) {
          throw new Error('NO_AMMO');
        }

        pendingAmmoRequirement = {
          ammoType: weaponDef.ammoType,
          amount: ammoNeeded,
        };
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

    const activeBoosts = await getActiveEventBoostEffects(playerId);

    let successPenaltyPp = 0;
    try {
      const { countryPoliceService } = await import('./countryPoliceService');
      const mods = await countryPoliceService.getModifiersForCountry(
        player.currentCountry || 'netherlands',
      );
      if (mods.enabled) {
        successPenaltyPp = mods.successPenaltyPp;
      }
    } catch {
      successPenaltyPp = 0;
    }

    // Normalize requirement field names for outcome engine compatibility
    const normalizedCrimeForOutcome = {
      ...crime,
      baseSuccessChance: Math.min(
        0.95,
        crime.baseSuccessChance * (1 + activeBoosts.crimeSuccessPct),
      ),
      requiresVehicle: crime.requiredVehicle,
      requiresWeapon: crime.requiredWeapon,
    };

    // Process crime attempt with outcome engine
    const crimeResult = await processCrimeAttempt(
      normalizedCrimeForOutcome,
      player.rank,
      selectedVehicle || undefined,
      primaryTool || undefined,
      { successPenaltyPp },
    );

    try {
      const { countryPoliceService } = await import('./countryPoliceService');
      await countryPoliceService.recordActivityGain({
        playerId,
        countryCode: player.currentCountry || 'netherlands',
        source: 'crime',
        maxReward: crime.maxReward,
      });
    } catch (pressureErr) {
      console.error('[Crime] country police pressure gain failed', pressureErr);
    }

    // Apply tool/weapon degradation outside the DB transaction — nested prisma
    // calls inside $transaction cause MariaDB "record changed since last read".
    if (primaryTool && primaryToolRecord && crimeResult.toolDamageSustained) {
      await degradeTool(playerId, primaryTool.id, crimeResult.toolDamageSustained);
    }
    if (weaponUsed) {
      await weaponService.degradeWeapon(playerId, weaponUsed.weaponId);
    }

    // Map outcome engine result to existing format
    let success = crimeResult.success;
    let reward = crimeResult.reward;
    let xpGained = crimeResult.xpGained;
    let xpLost = 0;
    let jailed = crimeResult.jailed;
    let jailTime = crimeResult.jailTime;
    if (jailTime > 0) {
      jailTime = scaleCrimeJailMinutes(jailTime, player.rank, crime.minLevel);
    }
    const vehicleBroken = crimeResult.vehicleBrokeDown || false;
    const diminishingContext = await economyBalanceService.getDiminishingContext(
      playerId,
      'crime',
    );
    const sessionPayoutMultiplier = diminishingContext.multiplier;

    if (success && reward > 0 && activeBoosts.crimeRewardPct > 0) {
      reward = Math.max(1, Math.round(reward * (1 + activeBoosts.crimeRewardPct)));
    }

    if (success && reward > 0 && sessionPayoutMultiplier < 1) {
      reward = economyBalanceService.applySoftDiminishing(
        reward,
        sessionPayoutMultiplier,
        1,
      );
    }

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
        // Regular crime increases wanted level (softer for low ranks)
        const wantedBump = crimeFailWantedIncrease(
          player.rank,
          config.wantedLevelIncreaseOnCrimeFail,
        );
        await policeService.increaseWantedLevel(playerId, wantedBump);
      }

      // Additional jail check if outcome engine didn't jail
      if (!jailed) {
        const jailRoll = Math.random();
        if (jailRoll < config.crimeJailChance) {
          // 50% chance of getting caught and additional XP loss
          jailed = true;
          jailTime = scaleCrimeJailMinutes(crime.jailTime, player.rank, crime.minLevel);
          
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
    let result = await prisma.$transaction(async (tx) => {
      // Calculate health damage (5-15 HP per crime)
      const healthDamage = 5 + Math.floor(Math.random() * 11); // 5-15
      const newHealth = Math.max(0, player.health - healthDamage);

      // Track vehicle consequences
      let vehicleConfiscated = false;
      let weaponConfiscated = false;
      let vehicleChaseDamage = 0;
      let clearCrimeWeaponSelection = false;

      // Update player money, XP, and health
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: player.money + reward,
          xp: player.xp + xpGained,
          health: newHealth,
        },
      });

      if (pendingAmmoRequirement) {
        const currentAmmo = await tx.ammoInventory.findUnique({
          where: {
            playerId_ammoType: {
              playerId,
              ammoType: pendingAmmoRequirement.ammoType,
            },
          },
          select: {
            id: true,
            quantity: true,
          },
        });

        if (!currentAmmo || currentAmmo.quantity < pendingAmmoRequirement.amount) {
          throw new Error('NO_AMMO');
        }

        if (currentAmmo.quantity === pendingAmmoRequirement.amount) {
          await tx.ammoInventory.delete({
            where: { id: currentAmmo.id },
          });
        } else {
          await tx.ammoInventory.update({
            where: { id: currentAmmo.id },
            data: {
              quantity: currentAmmo.quantity - pendingAmmoRequirement.amount,
            },
          });
        }
      }

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

      if (vehicleInventory && vehicleId) {
        const conditionLoss = Math.ceil(crimeResult.vehicleConditionLoss ?? 0);
        const fuelUsed = crimeResult.vehicleFuelUsed ?? config.crimeFuelCost;
        const nextCondition = vehicleBroken
          ? 0
          : Math.max(0, vehicleInventory.condition - conditionLoss);
        const nextFuelLevel = Math.max(0, vehicleInventory.fuelLevel - fuelUsed);

        await tx.vehicleInventory.update({
          where: { id: vehicleId },
          data: {
            condition: nextCondition,
            fuelLevel: nextFuelLevel,
          },
        });
      }

      // Weapon/tool degradation runs before this transaction (see above).
      if (jailed) {
        if (weaponUsed) {
          const currentWeapon = await tx.weaponInventory.findUnique({
            where: {
              playerId_weaponId: {
                playerId,
                weaponId: weaponUsed.weaponId,
              },
            },
            select: {
              id: true,
              quantity: true,
            },
          });

          if (currentWeapon) {
            if (currentWeapon.quantity > 1) {
              await tx.weaponInventory.update({
                where: { id: currentWeapon.id },
                data: { quantity: currentWeapon.quantity - 1 },
              });
            } else {
              await tx.weaponInventory.delete({
                where: { id: currentWeapon.id },
              });
              clearCrimeWeaponSelection = true;
            }

            await tx.player.update({
              where: { id: playerId },
              data: {
                inventory_slots_used: { decrement: 1 },
              },
            });

            weaponConfiscated = true;
          }
        }
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
          vehicleId: null,
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
        weaponConfiscated,
        vehicleChaseDamage,
        clearCrimeWeaponSelection,
      };
    });

    if (jailed) {
      await toolService.confiscateTools(playerId, requiredToolsForCrime);
    }

    if (result.clearCrimeWeaponSelection) {
      await weaponSelectionService.clearSelectedCrimeWeapon(playerId);
    }

    // Check if player needs ICU (health reached 0)
    if (result.newHealth === 0) {
      await intensiveCareService.checkAndApplyICU(playerId, result.newHealth);
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

    if (jailed && !arrested && jailTime > 0) {
      if (crime.isFederal) {
        await fbiService.jailPlayerFederal(playerId, jailTime);
        const fbiArrestResult = await fbiService.checkFBIArrest(playerId);
        arrestingAuthority = 'FBI';
        heatLevel = fbiArrestResult.fbiHeat;
        bailAmount = fbiArrestResult.federalBail || bailAmount;
      } else {
        await policeService.jailPlayer(playerId, jailTime);
        const policeArrestResult = await policeService.checkArrest(playerId);
        arrestingAuthority = 'Police';
        heatLevel = policeArrestResult.wantedLevel;
        bailAmount = policeArrestResult.bail || bailAmount;
      }
    }

    const jailedAfterSuccessfulCrime = success && jailed;

    if (jailedAfterSuccessfulCrime) {
      const lateArrestResult = await prisma.$transaction(async (tx) => {
        let vehicleConfiscated = false;
        let weaponConfiscated = false;
        let vehicleChaseDamage = 0;
        let clearCrimeWeaponSelection = false;

        if (weaponUsed) {
          const currentWeapon = await tx.weaponInventory.findUnique({
            where: {
              playerId_weaponId: {
                playerId,
                weaponId: weaponUsed.weaponId,
              },
            },
            select: {
              id: true,
              quantity: true,
            },
          });

          if (currentWeapon) {
            if (currentWeapon.quantity > 1) {
              await tx.weaponInventory.update({
                where: { id: currentWeapon.id },
                data: { quantity: currentWeapon.quantity - 1 },
              });
            } else {
              await tx.weaponInventory.delete({
                where: { id: currentWeapon.id },
              });
              clearCrimeWeaponSelection = true;
            }

            await tx.player.update({
              where: { id: playerId },
              data: {
                inventory_slots_used: { decrement: 1 },
              },
            });

            weaponConfiscated = true;
          }
        }

        if (vehicleInventory && vehicleId) {
          const confiscationChance = 0.7;
          if (Math.random() < confiscationChance) {
            await tx.vehicleInventory.deleteMany({
              where: {
                id: vehicleId,
                playerId,
              },
            });
            vehicleConfiscated = true;
          } else {
            const currentVehicle = await tx.vehicleInventory.findUnique({
              where: { id: vehicleId },
              select: { condition: true },
            });

            if (currentVehicle) {
              const chaseDamage = 30 + Math.floor(Math.random() * 31);
              const newCondition = Math.max(0, currentVehicle.condition - chaseDamage);

              await tx.vehicleInventory.update({
                where: { id: vehicleId },
                data: { condition: newCondition },
              });
              vehicleChaseDamage = chaseDamage;
            }
          }
        }

        return {
          vehicleConfiscated,
          weaponConfiscated,
          vehicleChaseDamage,
          clearCrimeWeaponSelection,
        };
      });

      result = {
        ...result,
        vehicleConfiscated:
          result.vehicleConfiscated || lateArrestResult.vehicleConfiscated,
        weaponConfiscated:
          result.weaponConfiscated || lateArrestResult.weaponConfiscated,
        vehicleChaseDamage:
          lateArrestResult.vehicleChaseDamage > 0
            ? lateArrestResult.vehicleChaseDamage
            : result.vehicleChaseDamage,
        clearCrimeWeaponSelection:
          result.clearCrimeWeaponSelection ||
          lateArrestResult.clearCrimeWeaponSelection,
      };

      success = false;
    }

    // Create world event and activity logging after final arrest state is known.
    let clearedRecordCount = 0;
    if (success) {
      if (crimeId === CRIMINAL_RECORD_WIPE_CRIME_ID) {
        clearedRecordCount = await judgeService.expungeCriminalRecord(playerId);
      }

      await runCrimeSideEffect('onboarding crime', async () => {
        const { onboardingService } = await import('./onboardingService');
        await onboardingService.markCrime(playerId);
      });

      await runCrimeSideEffect('worldEvent crime.success', async () => {
        await worldEventService.createEvent(
          'crime.success',
          {
            crimeName: crime.name,
            reward,
            xpGained,
            clearedRecordCount,
            sessionPayoutMultiplier,
          },
          playerId,
        );
      });

      await runCrimeSideEffect('activity CRIME', async () => {
        await activityService.logActivity(
          playerId,
          'CRIME',
          clearedRecordCount > 0
            ? `Completed ${crime.name} and wiped ${clearedRecordCount} criminal record entries`
            : `Completed ${crime.name} and earned €${reward.toLocaleString()}`,
          {
            crimeId: crime.id,
            crimeName: crime.name,
            reward,
            xpGained,
            clearedRecordCount,
            sessionPayoutMultiplier,
          },
          true
        );
      });

      if (clearedRecordCount > 0) {
        await runCrimeSideEffect('activity CRIMINAL_RECORD_EXPUNGED', async () => {
          await activityService.logActivity(
            playerId,
            'CRIMINAL_RECORD_EXPUNGED',
            `Wiped ${clearedRecordCount} criminal record entries via ${crime.name}`,
            {
              crimeId: crime.id,
              crimeName: crime.name,
              clearedRecordCount,
            },
            true
          );
        });
      }

      if (result.newRank > player.rank) {
        await runCrimeSideEffect('activity RANK_UP', async () => {
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
        });
      }
    } else if (jailed) {
      await runCrimeSideEffect('worldEvent crime.caught', async () => {
        await worldEventService.createEvent(
          'crime.caught',
          {
            crimeName: crime.name,
            jailTime,
          },
          playerId,
        );
      });
    }

    if (!success) {
      await runCrimeSideEffect('activity CRIME_FAILED', async () => {
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
      });
    }

    if (!success && jailed && !arrested) {
      await runCrimeSideEffect('activity ARREST', async () => {
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
      });

      void notificationService.sendArrestAwaitingHelpNotifications(
        playerId,
        jailTime,
        crime.isFederal ? 'FBI' : 'Police',
        'CRIME'
      ).catch((error) => {
        console.error('[Crime Service] arrest help notifications failed:', error);
      });
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
      vehicleFuelUsed: crimeResult.vehicleFuelUsed,
      toolDamageSustained: crimeResult.toolDamageSustained,
      vehicleConfiscated: result.vehicleConfiscated,
      weaponConfiscated: result.weaponConfiscated,
      vehicleChaseDamage: result.vehicleChaseDamage,
      newlyUnlockedAchievements,
      clearedRecordCount,
      sessionPayoutMultiplier,
      sessionAttemptsInWindow: diminishingContext.attemptsInWindow,
      sessionWindowMinutes: diminishingContext.sessionWindowMinutes,
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
      select: { rank: true, currentCountry: true },
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

    // 6️⃣–7️⃣ SHOOTING + GYM (parallel fetch; include lastTrainedAt for combo-readiness)
    const [shootingStats, gymStats] = await Promise.all([
      prisma.shootingRangeStats.findUnique({
        where: { playerId },
        select: { accuracyBonus: true, lastTrainedAt: true },
      }),
      prisma.gymStats.findUnique({
        where: { playerId },
        select: {
          strengthBonus: true,
          lastTrainedAt: true,
          speedLastTrainedAt: true,
          staminaLastTrainedAt: true,
        },
      }),
    ]);

    // Max +10% from 100 sessions (0.1% per session) — shooting
    if (shootingStats?.accuracyBonus) {
      successChance += shootingStats.accuracyBonus;
    }

    // Max +8% aggregate gym bonus (strength/speed/stamina tracks; see gymService.computeAggregateGymBonus)
    if (gymStats?.strengthBonus) {
      successChance += gymStats.strengthBonus;
    }

    // 8️⃣ Same-UTC-day combo: both tracks trained today → small extra (see trainingComboReadiness.ts)
    const gymLastUtc = gymStats
      ? latestGymTrainAt({
          lastTrainedAt: gymStats.lastTrainedAt ?? null,
          speedLastTrainedAt: gymStats.speedLastTrainedAt ?? null,
          staminaLastTrainedAt: gymStats.staminaLastTrainedAt ?? null,
        })
      : null;

    if (
      isTrainingComboReadinessActive(
        gymLastUtc,
        shootingStats?.lastTrainedAt ?? null,
      )
    ) {
      successChance += TRAINING_COMBO_READINESS_BONUS;
    }

    try {
      const { countryPoliceService } = await import('./countryPoliceService');
      const mods = await countryPoliceService.getModifiersForCountry(
        player.currentCountry || 'netherlands',
      );
      if (mods.enabled && mods.successPenaltyPp > 0) {
        successChance = countryPoliceService.applySuccessPenalty(
          successChance,
          mods.successPenaltyPp,
        );
      }
    } catch {
      // ignore
    }

    // Keep realistic bounds: at least 5%, at most 95%
    return Math.max(0.05, Math.min(successChance, 0.95));
  },

  /**
   * Load player state once for crime readiness checks (GET /crimes list).
   */
  async buildCrimeReadinessContext(
    playerId: number,
    playerRank: number,
    currentCountry: string,
  ) {
    const [
      selectedVehicle,
      selectedWeapon,
      drugRows,
      carriedTools,
      storageTools,
      ammoInventory,
      criminalRecordCount,
    ] = await Promise.all([
      resolveSelectedCrimeVehicle(playerId, currentCountry),
      weaponSelectionService.getSelectedCrimeWeapon(playerId),
      prisma.drugInventory.findMany({
        where: { playerId },
        select: { drugType: true, quantity: true },
      }),
      prisma.playerTools.findMany({
        where: { playerId, location: 'carried', durability: { gt: 0 } },
        select: { toolId: true },
      }),
      prisma.playerTools.findMany({
        where: { playerId, location: { not: 'carried' }, durability: { gt: 0 } },
        select: { toolId: true },
      }),
      prisma.ammoInventory.findMany({
        where: { playerId },
        select: { ammoType: true, quantity: true },
      }),
      judgeService.getVisibleCriminalRecordCount(playerId),
    ]);

    const drugTotalsByType = new Map<string, number>();
    for (const row of drugRows) {
      drugTotalsByType.set(
        row.drugType,
        (drugTotalsByType.get(row.drugType) ?? 0) + row.quantity,
      );
    }

    const ammoCounts = new Map<string, number>();
    for (const row of ammoInventory) {
      ammoCounts.set(row.ammoType, row.quantity);
    }

    const weaponDefinition = selectedWeapon
      ? weaponService.getAllWeapons().find((w) => w.id === selectedWeapon.weaponId)
      : undefined;

    return {
      playerRank,
      hasCriminalRecord: criminalRecordCount > 0,
      selectedVehicle,
      selectedWeapon,
      weaponDefinition,
      ammoCounts,
      drugTotalsByType,
      carriedToolIds: new Set(carriedTools.map((t) => t.toolId)),
      storageToolIds: new Set(storageTools.map((t) => t.toolId)),
    };
  },

  /**
   * Whether the player's selected crime weapon satisfies this crime's requirements.
   */
  isWeaponReadyForCrime(
    crimeId: string,
    context: Awaited<ReturnType<typeof crimeService.buildCrimeReadinessContext>>,
  ): boolean {
    const crime = this.getCrimeDefinition(crimeId);
    if (!crime?.requiredWeapon) {
      return true;
    }

    if (!context.selectedWeapon || context.selectedWeapon.condition <= 0) {
      return false;
    }

    const def = context.weaponDefinition;
    const suitableTypes = crime.suitableWeaponTypes || [];
    const isTypeAllowed =
      suitableTypes.length === 0 ||
      (def && suitableTypes.includes(def.type));
    const meetsDamage = (def?.damage ?? 0) >= (crime.minDamage || 0);
    const meetsIntimidation =
      (def?.intimidation ?? 0) >= (crime.minIntimidation || 0);

    if (!isTypeAllowed || !meetsDamage || !meetsIntimidation) {
      return false;
    }

    if (def?.requiresAmmo && def.ammoType) {
      const needed = def.ammoPerCrime || 1;
      const have = context.ammoCounts.get(def.ammoType) ?? 0;
      if (have < needed) {
        return false;
      }
    }

    return true;
  },

  /**
   * Evaluate whether the player can attempt this crime and why not.
   */
  evaluateCrimeReadiness(
    crimeId: string,
    context: Awaited<ReturnType<typeof crimeService.buildCrimeReadinessContext>>,
  ): {
    canAttempt: boolean;
    readinessBlocker:
      | 'rank'
      | 'criminal_record'
      | 'vehicle'
      | 'weapon'
      | 'weapon_ammo'
      | 'tools'
      | 'tools_in_storage'
      | 'drugs'
      | null;
    missingToolIds: string[];
    toolsInStorageIds: string[];
    toolsReady: boolean;
  } {
    const crime = this.getCrimeDefinition(crimeId);
    const requiredTools = crime ? toolService.getRequiredToolsForCrime(crimeId) : [];
    const missingToolIds: string[] = [];
    const toolsInStorageIds: string[] = [];

    for (const toolId of requiredTools) {
      if (context.carriedToolIds.has(toolId)) {
        continue;
      }
      if (context.storageToolIds.has(toolId)) {
        toolsInStorageIds.push(toolId);
      } else {
        missingToolIds.push(toolId);
      }
    }

    const toolsReady =
      requiredTools.length === 0 ||
      (missingToolIds.length === 0 && toolsInStorageIds.length === 0);

    if (!crime) {
      return {
        canAttempt: false,
        readinessBlocker: 'rank',
        missingToolIds,
        toolsInStorageIds,
        toolsReady,
      };
    }

    if (context.playerRank < crime.minLevel) {
      return {
        canAttempt: false,
        readinessBlocker: 'rank',
        missingToolIds,
        toolsInStorageIds,
        toolsReady,
      };
    }

    if (crimeId === CRIMINAL_RECORD_WIPE_CRIME_ID && !context.hasCriminalRecord) {
      return {
        canAttempt: false,
        readinessBlocker: 'criminal_record',
        missingToolIds,
        toolsInStorageIds,
        toolsReady,
      };
    }

    if (missingToolIds.length > 0) {
      return {
        canAttempt: false,
        readinessBlocker: 'tools',
        missingToolIds,
        toolsInStorageIds,
        toolsReady,
      };
    }

    if (toolsInStorageIds.length > 0) {
      return {
        canAttempt: false,
        readinessBlocker: 'tools_in_storage',
        missingToolIds,
        toolsInStorageIds,
        toolsReady,
      };
    }

    if (crime.requiredVehicle) {
      const vehicle = context.selectedVehicle;
      if (!vehicle || vehicle.inventory.fuelLevel <= 0) {
        return {
          canAttempt: false,
          readinessBlocker: 'vehicle',
          missingToolIds,
          toolsInStorageIds,
          toolsReady,
        };
      }
    }

    if (crime.requiredWeapon) {
      if (!context.selectedWeapon || context.selectedWeapon.condition <= 0) {
        return {
          canAttempt: false,
          readinessBlocker: 'weapon',
          missingToolIds,
          toolsInStorageIds,
          toolsReady,
        };
      }

      const def = context.weaponDefinition;
      const suitableTypes = crime.suitableWeaponTypes || [];
      const isTypeAllowed =
        suitableTypes.length === 0 ||
        (def && suitableTypes.includes(def.type));
      const meetsDamage = (def?.damage ?? 0) >= (crime.minDamage || 0);
      const meetsIntimidation =
        (def?.intimidation ?? 0) >= (crime.minIntimidation || 0);

      if (!isTypeAllowed || !meetsDamage || !meetsIntimidation) {
        return {
          canAttempt: false,
          readinessBlocker: 'weapon',
          missingToolIds,
          toolsInStorageIds,
          toolsReady,
        };
      }

      if (def?.requiresAmmo && def.ammoType) {
        const needed = def.ammoPerCrime || 1;
        const have = context.ammoCounts.get(def.ammoType) ?? 0;
        if (have < needed) {
          return {
            canAttempt: false,
            readinessBlocker: 'weapon_ammo',
            missingToolIds,
            toolsInStorageIds,
            toolsReady,
          };
        }
      }
    }

    if (crime.requiredDrugs && crime.minDrugQuantity) {
      let hasDrugs = false;
      for (const drugType of crime.requiredDrugs) {
        const total = context.drugTotalsByType.get(drugType) ?? 0;
        if (total >= crime.minDrugQuantity) {
          hasDrugs = true;
          break;
        }
      }
      if (!hasDrugs) {
        return {
          canAttempt: false,
          readinessBlocker: 'drugs',
          missingToolIds,
          toolsInStorageIds,
          toolsReady,
        };
      }
    }

    return {
      canAttempt: true,
      readinessBlocker: null,
      missingToolIds,
      toolsInStorageIds,
      toolsReady,
    };
  },

  /**
   * Whether a crime should appear under the "available" filter.
   * Tool/weapon gaps are OK (buyable); vehicle/drug crimes need system rank unlocks.
   */
  isCrimeListedAvailable(
    crimeId: string,
    context: Awaited<ReturnType<typeof crimeService.buildCrimeReadinessContext>>,
  ): boolean {
    const crime = this.getCrimeDefinition(crimeId);
    if (!crime) {
      return false;
    }

    if (context.playerRank < crime.minLevel) {
      return false;
    }

    if (crimeId === CRIMINAL_RECORD_WIPE_CRIME_ID && !context.hasCriminalRecord) {
      return false;
    }

    if (crime.requiredVehicle && context.playerRank < LAND_VEHICLE_THEFT_MIN_RANK) {
      return false;
    }

    if (crime.requiredDrugs && crime.minDrugQuantity) {
      let hasDrugs = false;
      for (const drugType of crime.requiredDrugs) {
        const total = context.drugTotalsByType.get(drugType) ?? 0;
        if (total >= crime.minDrugQuantity) {
          hasDrugs = true;
          break;
        }
      }

      if (!hasDrugs) {
        const canObtainAnyDrug = crime.requiredDrugs.some((drugId) => {
          const drugDef = drugService.getDrugDefinition(drugId);
          return drugDef != null && context.playerRank >= drugDef.requiredRank;
        });
        if (!canObtainAnyDrug) {
          return false;
        }
      }
    }

    return true;
  },

  /**
   * Whether the player can attempt this crime right now (rank + resources).
   */
  canAttemptCrime(
    crimeId: string,
    context: Awaited<ReturnType<typeof crimeService.buildCrimeReadinessContext>>,
  ): boolean {
    return this.evaluateCrimeReadiness(crimeId, context).canAttempt;
  },
};
