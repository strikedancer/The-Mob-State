import { PrismaClient } from '@prisma/client';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';

const prisma = new PrismaClient() as any;

type SabotageType =
  | 'tip_police'
  | 'steal_customer'
  | 'damage_reputation'
  | 'bribe_employee';

const sabotageCosts: Record<SabotageType, number> = {
  tip_police: 5000,
  steal_customer: 3000,
  damage_reputation: 10000,
  bribe_employee: 8000,
};

function getBaseSuccessChance(type: SabotageType): number {
  switch (type) {
    case 'tip_police':
      return 0.7;
    case 'steal_customer':
      return 0.75;
    case 'damage_reputation':
      return 0.6;
    case 'bribe_employee':
      return 0.5;
    default:
      return 0.5;
  }
}

function isSabotageType(value: string): value is SabotageType {
  return ['tip_police', 'steal_customer', 'damage_reputation', 'bribe_employee'].includes(value);
}

async function getDefenseReduction(victimId: number): Promise<number> {
  const districts = await prisma.redLightDistrict.findMany({
    where: { ownerId: victimId },
    select: { securityLevel: true },
  });

  if (districts.length === 0) return 0;

  const avgSecurity =
    districts.reduce((sum: number, district: any) => sum + (district.securityLevel ?? 0), 0) /
    districts.length;

  return avgSecurity * 0.1;
}

async function hasRecentSabotage(attackerId: number): Promise<boolean> {
  const cooldownStart = new Date(Date.now() - 4 * 60 * 60 * 1000);

  const recent = await prisma.sabotageAction.findFirst({
    where: {
      attackerId,
      createdAt: { gte: cooldownStart },
    },
    select: { id: true },
  });

  return !!recent;
}

async function getProtectionInsurance(playerId: number) {
  const insurance = await prisma.prostitutionProtectionInsurance.findUnique({
    where: { playerId },
  });

  if (!insurance) return null;
  if (insurance.activeUntil <= new Date()) return null;
  return insurance;
}

async function hasRetaliationDiscount(attackerId: number, victimId: number): Promise<boolean> {
  const retaliationWindowStart = new Date(Date.now() - 24 * 60 * 60 * 1000);

  const recentIncoming = await prisma.sabotageAction.findFirst({
    where: {
      attackerId: victimId,
      victimId: attackerId,
      createdAt: { gte: retaliationWindowStart },
      success: true,
    },
    select: { id: true },
    orderBy: { createdAt: 'desc' },
  });

  return !!recentIncoming;
}

export const rivalryService = {
  async getProtectionStatus(playerId: number) {
    const insurance = await getProtectionInsurance(playerId);
    return {
      active: !!insurance,
      weeklyCost: insurance?.weeklyCost ?? 25000,
      damageReduction: insurance?.damageReduction ?? 0.3,
      activeUntil: insurance?.activeUntil ?? null,
    };
  },

  async buyProtectionInsurance(playerId: number) {
    const existing = await getProtectionInsurance(playerId);
    if (existing) {
      return {
        success: false,
        message: 'Protection insurance is already active',
      };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, money: true },
    });

    if (!player) {
      return { success: false, message: 'Player not found' };
    }

    const weeklyCost = 25000;
    if (player.money < weeklyCost) {
      return { success: false, message: 'Not enough money for protection insurance' };
    }

    const activeUntil = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

    await prisma.$transaction(async (tx: any) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: weeklyCost } },
      });

      await tx.prostitutionProtectionInsurance.upsert({
        where: { playerId },
        update: {
          weeklyCost,
          damageReduction: 0.3,
          activeUntil,
        },
        create: {
          playerId,
          weeklyCost,
          damageReduction: 0.3,
          activeUntil,
        },
      });
    });

    return {
      success: true,
      message: 'Protection insurance activated for 7 days',
      protection: {
        active: true,
        weeklyCost,
        damageReduction: 0.3,
        activeUntil,
      },
    };
  },

  async startRivalry(playerId: number, rivalPlayerId: number) {
    if (playerId === rivalPlayerId) {
      return { success: false, message: 'You cannot challenge yourself' };
    }

    const rival = await prisma.player.findUnique({
      where: { id: rivalPlayerId },
      select: { id: true, username: true },
    });

    if (!rival) {
      return { success: false, message: 'Rival player not found' };
    }

    const rivalry = await prisma.prostitutionRivalry.upsert({
      where: {
        playerId_rivalPlayerId: {
          playerId,
          rivalPlayerId,
        },
      },
      update: {},
      create: {
        playerId,
        rivalPlayerId,
      },
      include: {
        rivalPlayer: {
          select: { id: true, username: true },
        },
      },
    });

    await prisma.prostitutionRivalry.upsert({
      where: {
        playerId_rivalPlayerId: {
          playerId: rivalPlayerId,
          rivalPlayerId: playerId,
        },
      },
      update: {},
      create: {
        playerId: rivalPlayerId,
        rivalPlayerId: playerId,
      },
    });

    return {
      success: true,
      message: `Rivalry started with ${rival.username}`,
      rivalry,
    };
  },

  async getActiveRivals(playerId: number) {
    const rivalries = await prisma.prostitutionRivalry.findMany({
      where: { playerId },
      include: {
        rivalPlayer: {
          select: {
            id: true,
            username: true,
            rank: true,
          },
        },
      },
      orderBy: [{ rivalryScore: 'desc' }, { startedAt: 'desc' }],
    });

    return rivalries;
  },

  async getHistory(playerId: number, limit = 20) {
    const history = await prisma.sabotageAction.findMany({
      where: {
        OR: [{ attackerId: playerId }, { victimId: playerId }],
      },
      include: {
        attacker: { select: { id: true, username: true } },
        victim: { select: { id: true, username: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return history;
  },

  async executeSabotage(attackerId: number, victimId: number, actionType: string) {
    if (!isSabotageType(actionType)) {
      return { success: false, message: 'Invalid sabotage action' };
    }

    const recentSabotage = await hasRecentSabotage(attackerId);
    if (recentSabotage) {
      return {
        success: false,
        message: 'Sabotage cooldown active (4 hours)',
      };
    }

    const [attacker, victim, rivalry] = await Promise.all([
      prisma.player.findUnique({
        where: { id: attackerId },
        select: { id: true, money: true, username: true },
      }),
      prisma.player.findUnique({
        where: { id: victimId },
        select: { id: true, money: true, username: true },
      }),
      prisma.prostitutionRivalry.findUnique({
        where: {
          playerId_rivalPlayerId: {
            playerId: attackerId,
            rivalPlayerId: victimId,
          },
        },
      }),
    ]);

    if (!attacker || !victim) {
      return { success: false, message: 'Player not found' };
    }

    if (!rivalry) {
      return { success: false, message: 'No active rivalry with this player' };
    }

    const hasRetaliation = await hasRetaliationDiscount(attackerId, victimId);
    const baseCost = sabotageCosts[actionType];
    const cost = hasRetaliation ? Math.floor(baseCost * 0.5) : baseCost;

    if (attacker.money < cost) {
      return { success: false, message: 'Not enough money for sabotage' };
    }

    const victimProtection = await getProtectionInsurance(victimId);
    const protectionMultiplier = victimProtection ? 1 - victimProtection.damageReduction : 1;

    const defenseReduction = await getDefenseReduction(victimId);
    const chance = Math.max(0.1, getBaseSuccessChance(actionType) - defenseReduction);
    const success = Math.random() < chance;

    let impactDescription = 'Sabotage failed';

    await prisma.$transaction(async (tx: any) => {
      await tx.player.update({
        where: { id: attackerId },
        data: { money: { decrement: cost } },
      });

      if (success) {
        if (actionType === 'tip_police') {
          const heatIncrease = Math.max(1, Math.round(5 * protectionMultiplier));
          await tx.player.update({
            where: { id: victimId },
            data: { fbiHeat: { increment: heatIncrease } },
          });
          impactDescription = `Police pressure increased by ${heatIncrease}`;
        }

        if (actionType === 'steal_customer') {
          const rawStealAmount = Math.min(5000, Math.max(500, Math.floor(victim.money * 0.02)));
          const stealAmount = Math.max(250, Math.round(rawStealAmount * protectionMultiplier));
          await tx.player.update({
            where: { id: victimId },
            data: { money: { decrement: stealAmount } },
          });
          await tx.player.update({
            where: { id: attackerId },
            data: { money: { increment: stealAmount } },
          });
          impactDescription = `Stole €${stealAmount} from rival flow`;
        }

        if (actionType === 'damage_reputation') {
          const expLoss = Math.max(5, Math.round(20 * protectionMultiplier));
          await tx.prostitute.updateMany({
            where: { playerId: victimId, level: { gt: 1 } },
            data: { experience: { decrement: expLoss } },
          });
          impactDescription = `Rival prostitutes lost ${expLoss} XP`;
        }

        if (actionType === 'bribe_employee') {
          const victimProstitute = await tx.prostitute.findFirst({
            where: {
              playerId: victimId,
              isBusted: false,
            },
            orderBy: { level: 'desc' },
          });

          if (victimProstitute) {
            const bustedMinutes = Math.max(30, Math.round(120 * protectionMultiplier));
            const bustedUntil = new Date(Date.now() + bustedMinutes * 60 * 1000);
            await tx.prostitute.update({
              where: { id: victimProstitute.id },
              data: {
                isBusted: true,
                bustedUntil,
              },
            });
            impactDescription = `${victimProstitute.name} was busted for ${bustedMinutes} minutes`;
          } else {
            impactDescription = 'No suitable rival prostitute found';
          }
        }

        await tx.prostitutionRivalry.update({
          where: {
            playerId_rivalPlayerId: {
              playerId: attackerId,
              rivalPlayerId: victimId,
            },
          },
          data: {
            rivalryScore: { increment: 1 },
            lastAttackAt: new Date(),
          },
        });

        await tx.prostitutionRivalry.update({
          where: {
            playerId_rivalPlayerId: {
              playerId: victimId,
              rivalPlayerId: attackerId,
            },
          },
          data: {
            rivalryScore: { decrement: 1 },
            lastAttackAt: new Date(),
          },
        });
      }

      await tx.sabotageAction.create({
        data: {
          attackerId,
          victimId,
          actionType,
          success,
          cost,
          impactDescription,
        },
      });
    });

    // Check for achievement unlocks for attacker
    let newlyUnlockedAchievements: any[] = [];
    if (success) {
      try {
        const achievementResults = await checkAndUnlockAchievements(attackerId);
        newlyUnlockedAchievements = achievementResults.map(r =>
          serializeAchievementForClient(r.achievement)
        );
      } catch (err) {
        console.error('[Achievement Check] Error after sabotage:', err);
      }
    }

    return {
      success: true,
      message: success ? 'Sabotage succeeded' : 'Sabotage failed',
      newlyUnlockedAchievements: newlyUnlockedAchievements,
      result: {
        actionType,
        baseCost,
        cost,
        retaliationDiscountApplied: hasRetaliation,
        victimProtectionApplied: !!victimProtection,
        success,
        impactDescription,
      },
    };
  },
};
