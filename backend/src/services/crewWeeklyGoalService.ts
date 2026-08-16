import prisma from '../lib/prisma';
import { getRankFromXP } from '../config';

const GOAL_KEY = 'crew_week_mission_1';
const TARGET = 1;
const CREW_CASH = 25000;
const PERSONAL_XP = 40;

function startOfUtcWeek(date: Date): Date {
  const day = date.getUTCDay();
  const mondayBased = day === 0 ? 7 : day;
  const start = new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), 0, 0, 0)
  );
  start.setUTCDate(start.getUTCDate() - (mondayBased - 1));
  return start;
}

function dateKeyUtc(date: Date): string {
  const y = date.getUTCFullYear();
  const m = String(date.getUTCMonth() + 1).padStart(2, '0');
  const d = String(date.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function weekKeyUtc(date: Date): string {
  return dateKeyUtc(startOfUtcWeek(date));
}

export const crewWeeklyGoalService = {
  async getStatus(playerId: number) {
    const membership = await prisma.crewMember.findUnique({
      where: { playerId },
      select: { crewId: true },
    });
    if (!membership) {
      return { inCrew: false };
    }

    const now = new Date();
    const from = startOfUtcWeek(now);
    const weekKey = weekKeyUtc(now);
    const endsAt = new Date(from);
    endsAt.setUTCDate(endsAt.getUTCDate() + 7);

    const [progress, claim] = await Promise.all([
      prisma.$queryRaw<Array<{ cnt: bigint }>>`
        SELECT COUNT(*) AS cnt
        FROM crew_mission_runs
        WHERE crewId = ${membership.crewId}
          AND startedAt >= ${from}
          AND status IN ('resolved', 'claimed', 'in_progress')
      `.catch(() => [{ cnt: 0n }]),
      prisma.$queryRaw<Array<{ id: number }>>`
        SELECT id FROM crew_weekly_goal_claims
        WHERE crewId = ${membership.crewId} AND weekKey = ${weekKey} AND goalKey = ${GOAL_KEY}
        LIMIT 1
      `.catch(() => []),
    ]);

    const current = Number(progress?.[0]?.cnt ?? 0);
    const claimed = (claim?.length ?? 0) > 0;

    return {
      inCrew: true,
      crewId: membership.crewId,
      weekKey,
      endsAt: endsAt.toISOString(),
      goalKey: GOAL_KEY,
      titleNl: 'Weekdoel: 1 crew-missie',
      titleEn: 'Weekly: 1 crew mission',
      progress: current,
      target: TARGET,
      claimed,
      claimable: current >= TARGET && !claimed,
      rewardCrewCash: CREW_CASH,
      rewardPersonalXp: PERSONAL_XP,
    };
  },

  async claim(playerId: number) {
    const membership = await prisma.crewMember.findUnique({
      where: { playerId },
      select: { crewId: true },
    });
    if (!membership) {
      throw Object.assign(new Error('NOT_IN_CREW'), { code: 'NOT_IN_CREW' });
    }

    const status = await this.getStatus(playerId);
    if (!status.inCrew || !status.claimable) {
      throw Object.assign(new Error('NOT_CLAIMABLE'), { code: 'NOT_CLAIMABLE' });
    }

    await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`
        INSERT INTO crew_weekly_goal_claims (crewId, weekKey, goalKey, claimedByPlayerId)
        VALUES (${membership.crewId}, ${status.weekKey}, ${GOAL_KEY}, ${playerId})
      `;
      await tx.crew.update({
        where: { id: membership.crewId },
        data: { bankBalance: { increment: CREW_CASH } },
      });
      const player = await tx.player.findUnique({
        where: { id: playerId },
        select: { xp: true },
      });
      if (player) {
        const newXp = player.xp + PERSONAL_XP;
        await tx.player.update({
          where: { id: playerId },
          data: { xp: newXp, rank: getRankFromXP(newXp) },
        });
      }
    });

    return this.getStatus(playerId);
  },
};
