import prisma from '../lib/prisma';
import config from '../config';

export const hospitalService = {
  /**
   * Heal a player at the hospital
   * Costs money and restores health
   */
  async heal(
    playerId: number,
    treatmentType: 'standard' | 'intensive' = 'standard',
  ): Promise<{
    healthRestored: number;
    cost: number;
    newHealth: number;
    newMoney: number;
    treatmentType: 'standard' | 'intensive';
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, health: true, money: true, lastHospitalVisit: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Check if player is already at full health
    if (player.health >= 100) {
      throw new Error('ALREADY_FULL_HEALTH');
    }

    // Check cooldown
    if (player.lastHospitalVisit) {
      const cooldownMs = config.hospitalCooldownMinutes * 60 * 1000;
      const timeSinceLastVisit = Date.now() - player.lastHospitalVisit.getTime();
      if (timeSinceLastVisit < cooldownMs) {
        const remainingMinutes = Math.ceil((cooldownMs - timeSinceLastVisit) / 60000);
        throw new Error(`ON_COOLDOWN:${remainingMinutes}`);
      }
    }

    const treatmentConfig =
      treatmentType === 'intensive'
        ? {
            cost: Math.round(config.hospitalHealCost * 2),
            healAmount: Math.round(config.hospitalHealAmount * 2.5),
          }
        : {
            cost: config.hospitalHealCost,
            healAmount: config.hospitalHealAmount,
          };

    // Check if player has enough money
    if (player.money < treatmentConfig.cost) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    // Calculate how much health to restore
    const healthNeeded = 100 - player.health;
    const healthRestored = Math.min(healthNeeded, treatmentConfig.healAmount);
    const newHealth = player.health + healthRestored;

    // Update player in transaction (atomic operation)
    const updatedPlayer = await prisma.$transaction(async (tx) => {
      return await tx.player.update({
        where: { id: playerId },
        data: {
          health: newHealth,
          money: player.money - treatmentConfig.cost,
          lastHospitalVisit: new Date(),
        },
      });
    });

    return {
      healthRestored,
      cost: treatmentConfig.cost,
      newHealth: updatedPlayer.health,
      newMoney: updatedPlayer.money,
      treatmentType,
    };
  },

  /**
   * Emergency room - free healing when HP is critically low
   */
  async emergencyRoom(playerId: number): Promise<{
    healthRestored: number;
    newHealth: number;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, health: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Only available when HP is critically low
    if (player.health >= 10) {
      throw new Error('NOT_CRITICAL');
    }

    // Free healing: restore 20 HP
    const healthRestored = 20;
    const newHealth = Math.min(100, player.health + healthRestored);

    const updatedPlayer = await prisma.player.update({
      where: { id: playerId },
      data: { health: newHealth },
    });

    return {
      healthRestored,
      newHealth: updatedPlayer.health,
    };
  },

  /**
   * Get cooldown status for a player
   */
  async getCooldownStatus(playerId: number): Promise<{
    onCooldown: boolean;
    remainingSeconds: number;
    cooldownMinutes: number;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { lastHospitalVisit: true },
    });

    if (!player) throw new Error('PLAYER_NOT_FOUND');

    const cooldownMs = config.hospitalCooldownMinutes * 60 * 1000;
    if (player.lastHospitalVisit) {
      const elapsed = Date.now() - player.lastHospitalVisit.getTime();
      if (elapsed < cooldownMs) {
        const remainingSeconds = Math.ceil((cooldownMs - elapsed) / 1000);
        return { onCooldown: true, remainingSeconds, cooldownMinutes: config.hospitalCooldownMinutes };
      }
    }

    return { onCooldown: false, remainingSeconds: 0, cooldownMinutes: config.hospitalCooldownMinutes };
  },

  /**
   * Get hospital info (cost, heal amount)
   */
  getHospitalInfo(): {
    cost: number;
    healAmount: number;
    treatmentOptions: {
      standard: { cost: number; healAmount: number };
      intensive: { cost: number; healAmount: number };
    };
  } {
    return {
      cost: config.hospitalHealCost,
      healAmount: config.hospitalHealAmount,
      treatmentOptions: {
        standard: {
          cost: config.hospitalHealCost,
          healAmount: config.hospitalHealAmount,
        },
        intensive: {
          cost: Math.round(config.hospitalHealCost * 2),
          healAmount: Math.round(config.hospitalHealAmount * 2.5),
        },
      },
    };
  },
};
