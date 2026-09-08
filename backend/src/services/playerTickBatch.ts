import prisma from '../lib/prisma';
import config from '../config';

export type PassivePlayerTickStats = {
  healed: number;
  wantedDecayed: number;
  fbiHeatDecayed: number;
};

let fbiDecayParity = 0;

function fbiHeatStepsThisTick(decayPerTick: number): number {
  if (!(decayPerTick > 0)) return 0;
  const whole = Math.floor(decayPerTick);
  const fraction = decayPerTick - whole;
  if (fraction <= 0) return whole;
  const ticksPerPoint = Math.max(2, Math.round(1 / fraction));
  fbiDecayParity += 1;
  const extra = fbiDecayParity % ticksPerPoint === 0 ? 1 : 0;
  return whole + extra;
}

/**
 * One batched UPDATE per column instead of find/update per player.
 * Heal: +N HP, cap 100, skip HP 0 (ICU). Wanted: −N if > 0.
 * FBI heat is an INT column; a 0.5 decay therefore subtracts 1 every two ticks.
 */
export async function applyPassivePlayerTickBatch(): Promise<PassivePlayerTickStats> {
  const healAmount = Math.max(0, Math.floor(config.passiveHealingPerTick || 0));
  const wantedDecay = Math.max(0, Math.floor(config.wantedLevelDecayPerTick || 1));
  const fbiDecay = Number(config.fbiHeatDecayPerTick);
  const fbiDecayAmount = Number.isFinite(fbiDecay) && fbiDecay > 0 ? fbiDecay : 0.5;
  const fbiSteps = fbiHeatStepsThisTick(fbiDecayAmount);

  const healed =
    healAmount > 0
      ? await prisma.$executeRaw`
          UPDATE players
          SET health = LEAST(100, health + ${healAmount})
          WHERE health > 0 AND health < 100
        `
      : 0;

  const wantedDecayed =
    wantedDecay > 0
      ? await prisma.$executeRaw`
          UPDATE players
          SET wantedLevel = GREATEST(0, wantedLevel - ${wantedDecay})
          WHERE wantedLevel > 0
        `
      : 0;

  const fbiHeatDecayed =
    fbiSteps > 0
      ? await prisma.$executeRaw`
          UPDATE players
          SET fbiHeat = GREATEST(0, fbiHeat - ${fbiSteps})
          WHERE fbiHeat > 0
        `
      : 0;

  return {
    healed: Number(healed),
    wantedDecayed: Number(wantedDecayed),
    fbiHeatDecayed: Number(fbiHeatDecayed),
  };
}
