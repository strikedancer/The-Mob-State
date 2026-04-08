import { Crime } from '../types/crime';

interface Vehicle {
  id: number;
  speed: number;        // 1-100
  armor: number;        // 1-100
  stealth: number;      // 1-100
  cargo: number;        // 1-100
  condition: number;    // 0-100
  fuel: number;         // 0-maxFuel
  maxFuel: number;
}

interface Tool {
  id: string;
  durability: number;   // 0-100
}

export enum CrimeOutcome {
  SUCCESS = 'success',
  CAUGHT = 'caught',
  FLED_NO_LOOT = 'fled_no_loot',
  OUT_OF_FUEL = 'out_of_fuel',
  VEHICLE_BREAKDOWN = 'vehicle_breakdown',
  TOOL_BROKE = 'tool_broke',
  FAILED = 'failed',
}

export interface CrimeResult {
  outcome: CrimeOutcome;
  success: boolean;
  caught: boolean;
  jailed: boolean;
  jailTime: number;
  reward: number;
  xpGained: number;
  lootStolen: number;
  cargoUsed: number;
  
  // Vehicle factors
  vehicleUsed?: number;
  vehicleConditionBefore?: number;
  vehicleConditionAfter?: number;
  vehicleConditionLoss?: number;
  vehicleFuelUsed?: number;
  vehicleSpeedBonus?: number;
  vehicleCargoBonus?: number;
  vehicleStealthBonus?: number;
  vehicleBrokeDown?: boolean;
  
  // Tool factors
  toolUsed?: string;
  toolConditionBefore?: number;
  toolConditionAfter?: number;
  toolDamageSustained?: number;
  toolBroke?: boolean;
  
  // Outcome message
  message: string;
  messageKey: string;  // For localization
}

/**
 * Calculate crime success chance with all modifiers
 */
export function calculateCrimeSuccessChance(
  crime: Crime,
  playerRank: number,
  vehicle?: Vehicle,
  tool?: Tool
): number {
  let baseChance = crime.baseSuccessChance;
  
  // Rank bonus (every rank above minimum gives +0.5% success)
  if (playerRank > crime.minLevel) {
    const rankBonus = (playerRank - crime.minLevel) * 0.005;
    baseChance += rankBonus;
  }
  
  // Vehicle modifiers
  if (vehicle && crime.requiresVehicle) {
    // Speed increases success (faster escape)
    const speedBonus = (vehicle.speed - 50) * 0.002; // -10% to +10%
    baseChance += speedBonus;
    
    // Stealth increases success (lower detection)
    const stealthBonus = (vehicle.stealth - 50) * 0.0025; // -12.5% to +12.5%
    baseChance += stealthBonus;
    
    // Cargo decreases success (more suspicious, harder to escape)
    const cargoPenalty = (vehicle.cargo - 50) * 0.001; // -5% to +5%
    baseChance -= cargoPenalty;
    
    // Low condition is BAD - exponential penalty
    if (vehicle.condition < 60) {
      const conditionPenalty = (60 - vehicle.condition) * 0.005; // Up to -30% at condition 0
      baseChance -= conditionPenalty;
    }
    
    // Low fuel is VERY BAD - exponential penalty
    const fuelPercent = (vehicle.fuel / vehicle.maxFuel) * 100;
    if (fuelPercent < 30) {
      const fuelPenalty = (30 - fuelPercent) * 0.01; // Up to -30% at 0 fuel
      baseChance -= fuelPenalty;
    }
  }
  
  // Tool condition modifier
  if (tool && crime.requiredTools && crime.requiredTools.length > 0) {
    // Tools in good condition increase success
    const toolBonus = (tool.durability - 50) * 0.001; // -5% to +5%
    baseChance += toolBonus;
    
    // Tools below 20% durability are risky
    if (tool.durability < 20) {
      const toolPenalty = (20 - tool.durability) * 0.015; // Up to -30% at 0 durability
      baseChance -= toolPenalty;
    }
  }
  
  // Cap between 5% and 95%
  return Math.max(0.05, Math.min(0.95, baseChance));
}

/**
 * Calculate loot amount based on cargo capacity
 */
export function calculateLoot(
  baseMin: number,
  baseMax: number,
  vehicle?: Vehicle
): number {
  const baseLoot = Math.floor(Math.random() * (baseMax - baseMin + 1)) + baseMin;
  
  if (!vehicle) {
    return baseLoot;
  }
  
  // Cargo capacity affects loot amount
  // High cargo = more loot (but remember it also decreased success chance)
  const cargoMultiplier = 0.7 + (vehicle.cargo / 100) * 0.6; // 0.7x to 1.3x
  
  return Math.floor(baseLoot * cargoMultiplier);
}

function calculateCrimeXpReward(crime: Crime): number {
  const minXp = crime.minXpReward ?? crime.xpReward;
  const maxXp = crime.maxXpReward ?? crime.xpReward;
  const safeMin = Math.min(minXp, maxXp);
  const safeMax = Math.max(minXp, maxXp);
  return Math.floor(Math.random() * (safeMax - safeMin + 1)) + safeMin;
}

/**
 * Process crime attempt with all scenarios
 */
export async function processCrimeAttempt(
  crime: Crime,
  playerRank: number,
  vehicle?: Vehicle,
  tool?: Tool
): Promise<CrimeResult> {
  const result: CrimeResult = {
    outcome: CrimeOutcome.SUCCESS,
    success: false,
    caught: false,
    jailed: false,
    jailTime: 0,
    reward: 0,
    xpGained: 0,
    lootStolen: 0,
    cargoUsed: 0,
    message: '',
    messageKey: 'crime.outcome.success',
  };
  
  // SCENARIO 1: Vehicle condition check (before crime)
  if (vehicle && crime.requiresVehicle) {
    result.vehicleUsed = vehicle.id;
    result.vehicleConditionBefore = vehicle.condition;
    
    // Very low condition = high chance of breakdown BEFORE crime
    if (vehicle.condition < 20) {
      const breakdownChance = (20 - vehicle.condition) / 100; // 0% to 20%
      if (Math.random() < breakdownChance) {
        result.outcome = CrimeOutcome.VEHICLE_BREAKDOWN;
        result.success = false;
        result.caught = false;
        result.message = 'Your vehicle broke down before reaching the crime scene';
        result.messageKey = 'crime.outcome.vehicleBreakdownBefore';
        result.vehicleBrokeDown = true;
        return result;
      }
    }
  }
  
  // SCENARIO 2: Tool check (does it break immediately?)
  if (tool && crime.requiredTools && crime.requiredTools.length > 0) {
    result.toolUsed = tool.id;
    result.toolConditionBefore = tool.durability;
    
    // Very low durability = high chance of breaking during crime
    if (tool.durability < 10) {
      const breakChance = (10 - tool.durability) / 50; // 0% to 20%
      if (Math.random() < breakChance) {
        result.outcome = CrimeOutcome.TOOL_BROKE;
        result.success = false;
        result.caught = true; // Tool broke, left evidence
        result.jailed = true;
        result.jailTime = Math.floor(crime.jailTime * 0.5); // Half jail time
        result.message = 'Your tool broke during the crime, leaving evidence';
        result.messageKey = 'crime.outcome.toolBroke';
        result.toolBroke = true;
        return result;
      }
    }
  }
  
  // SCENARIO 3: Calculate success chance
  const successChance = calculateCrimeSuccessChance(crime, playerRank, vehicle, tool);
  const roll = Math.random();
  
  if (roll <= successChance) {
    // SUCCESS!
    result.success = true;
    result.outcome = CrimeOutcome.SUCCESS;
    result.lootStolen = calculateLoot(crime.minReward, crime.maxReward, vehicle);
    result.reward = result.lootStolen;
    result.xpGained = calculateCrimeXpReward(crime);
    result.message = 'Crime successful!';
    result.messageKey = 'crime.outcome.success';
    
    // Calculate cargo used
    if (vehicle) {
      result.cargoUsed = Math.floor(result.lootStolen / 1000); // $1000 = 1 cargo
    }
  } else {
    // FAILED - but multiple failure scenarios
    result.success = false;
    const potentialXp = calculateCrimeXpReward(crime);
    result.xpGained = Math.floor(potentialXp * 0.2); // 20% XP for trying
    
    // SCENARIO 4: Out of fuel during escape?
    if (vehicle && crime.requiresVehicle) {
      const fuelPercent = (vehicle.fuel / vehicle.maxFuel) * 100;
      
      if (fuelPercent < 15) {
        // High chance of running out during escape
        const outOfFuelChance = (15 - fuelPercent) / 30; // 0% to 50%
        if (Math.random() < outOfFuelChance) {
          result.outcome = CrimeOutcome.OUT_OF_FUEL;
          result.caught = false; // Fled on foot
          result.lootStolen = calculateLoot(crime.minReward, crime.maxReward, vehicle);
          result.reward = 0; // Had to abandon loot
          result.message = 'Ran out of fuel during escape - fled on foot, lost loot and vehicle';
          result.messageKey = 'crime.outcome.outOfFuel';
          result.vehicleBrokeDown = true;
          return result;
        }
      }
      
      // SCENARIO 5: Vehicle breakdown during escape?
      if (vehicle.condition < 40) {
        const breakdownChance = (40 - vehicle.condition) / 100; // 0% to 40%
        if (Math.random() < breakdownChance) {
          result.outcome = CrimeOutcome.VEHICLE_BREAKDOWN;
          result.caught = false;
          result.lootStolen = calculateLoot(crime.minReward, crime.maxReward, vehicle);
          result.reward = Math.floor(result.lootStolen * 0.3); // Lost 70% of loot
          result.message = 'Vehicle broke down during escape - abandoned most loot';
          result.messageKey = 'crime.outcome.vehicleBreakdownDuring';
          result.vehicleBrokeDown = true;
          return result;
        }
      }
    }
    
    // SCENARIO 6: Regular caught
    result.outcome = CrimeOutcome.CAUGHT;
    result.caught = true;
    result.jailed = true;
    result.jailTime = crime.jailTime;
    result.message = 'Caught by police';
    result.messageKey = 'crime.outcome.caught';
  }
  
  // Apply vehicle wear and tear (if used)
  if (vehicle && crime.requiresVehicle && result.vehicleConditionBefore) {
    // Condition loss: 1-5% per crime depending on vehicle usage
    const baseWear = 1 + Math.random() * 4;
    const speedWear = (vehicle.speed / 100) * 2; // Fast driving = more wear
    result.vehicleConditionLoss = baseWear + speedWear;
    result.vehicleConditionAfter = Math.max(0, result.vehicleConditionBefore - result.vehicleConditionLoss);
    
    // Fuel usage: 10-30% depending on crime type
    result.vehicleFuelUsed = Math.floor(10 + Math.random() * 20);
  }
  
  // Apply tool wear (if used)
  if (tool && crime.requiredTools && crime.requiredTools.length > 0 && result.toolConditionBefore) {
    // Tool damage: 5-15% per use
    result.toolDamageSustained = Math.floor(5 + Math.random() * 10);
    result.toolConditionAfter = Math.max(0, result.toolConditionBefore - result.toolDamageSustained);
    
    if (result.toolConditionAfter === 0) {
      result.toolBroke = true;
    }
  }
  
  // Calculate bonuses for tracking
  if (vehicle && crime.requiresVehicle) {
    result.vehicleSpeedBonus = 0.8 + (vehicle.speed / 100) * 0.4; // 0.8 to 1.2
    result.vehicleCargoBonus = 0.7 + (vehicle.cargo / 100) * 0.6; // 0.7 to 1.3
    result.vehicleStealthBonus = 0.7 + (vehicle.stealth / 100) * 0.6; // 0.7 to 1.3
  }
  
  return result;
}
