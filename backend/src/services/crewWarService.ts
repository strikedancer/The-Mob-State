import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { notificationService } from './notificationService';
import { activityService } from './activityService';
import { discordWebhookService } from './discordWebhookService';
import { checkAndUnlockAchievements } from './achievementService';

const PREPARATION_MINUTES = 15;
const ACTIVE_HOURS = 24;
const LOCKDOWN_MINUTES = 30;
const MIN_MEMBERS_REQUIRED = 3;
const REPEATED_TARGET_WINDOW_MS = 30 * 60 * 1000;
const TERRITORY_TICK_MS = 30 * 60 * 1000;
const DEFAULT_REWARD_POOL = 150000;

const WAR_ACTIONS: Record<string, {
  basePoints: number;
  cooldownMs: number;
  requiresTarget?: boolean;
  vipPlayerOnly?: boolean;
  vipCrewOnly?: boolean;
}> = {
  attack_kill: { basePoints: 12, cooldownMs: 20 * 60 * 1000, requiresTarget: true },
  attack_mug: { basePoints: 9, cooldownMs: 35 * 60 * 1000, requiresTarget: true },
  attack_sabotage: { basePoints: 8, cooldownMs: 30 * 60 * 1000, requiresTarget: true },
  defense_success: { basePoints: 6, cooldownMs: 45 * 60 * 1000 },
  intel_scan: { basePoints: 4, cooldownMs: 25 * 60 * 1000, vipPlayerOnly: true },
  raid: { basePoints: 15, cooldownMs: 60 * 60 * 1000, requiresTarget: true },
  crew_shield: { basePoints: 5, cooldownMs: 75 * 60 * 1000, vipCrewOnly: true },
  war_boost: { basePoints: 5, cooldownMs: 60 * 60 * 1000, vipPlayerOnly: true },
  territory_claim: { basePoints: 10, cooldownMs: 20 * 60 * 1000 },
};

const TERRITORIES = ['docks', 'downtown', 'harbor'];

type WarStatus = 'preparing' | 'active' | 'lockdown' | 'resolved' | 'archived' | 'cancelled';
type WarType = 'kill_war' | 'economy_war' | 'territory_war' | 'total_war';

type CrewWarRecord = Awaited<ReturnType<typeof prisma.crewWar.findUnique>>;

function asJson(value: string | null | undefined): Record<string, any> {
  if (!value) return {};
  try {
    const parsed = JSON.parse(value);
    return parsed && typeof parsed === 'object' ? parsed : {};
  } catch {
    return {};
  }
}

function stringifyJson(value: Record<string, any>): string {
  return JSON.stringify(value ?? {});
}

function isVipActive(entity: { isVip: boolean; vipExpiresAt: Date | null } | null | undefined): boolean {
  if (!entity?.isVip) return false;
  if (!entity.vipExpiresAt) return true;
  return entity.vipExpiresAt.getTime() > Date.now();
}

function getMonthSeasonBounds(now = new Date()) {
  const startsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1, 0, 0, 0));
  const endsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1, 0, 0, 0));
  const seasonKey = `${startsAt.getUTCFullYear()}-${String(startsAt.getUTCMonth() + 1).padStart(2, '0')}`;
  return { seasonKey, startsAt, endsAt };
}

async function ensureCurrentSeason() {
  const { seasonKey, startsAt, endsAt } = getMonthSeasonBounds();
  let season = await prisma.crewWarSeason.findUnique({ where: { seasonKey } });
  if (!season) {
    season = await prisma.crewWarSeason.create({
      data: {
        seasonKey,
        startsAt,
        endsAt,
        status: 'active',
        rewardConfigJson: stringifyJson({
          winnerCrewBankReward: 300000,
          topPlayerReward: 75000,
        }),
      },
    });
  }

  await prisma.crewWarSeason.updateMany({
    where: {
      id: { not: season.id },
      status: 'active',
      endsAt: { lte: new Date() },
    },
    data: { status: 'resolved' },
  });

  return season;
}

async function getCrewMemberCount(crewId: number) {
  return prisma.crewMember.count({ where: { crewId } });
}

async function getWarByIdRaw(warId: number) {
  return prisma.crewWar.findUnique({ where: { id: warId } });
}

async function upsertStanding(tx: any, warId: number, crewId: number, delta: {
  totalPoints?: number;
  totalKills?: number;
  totalDeaths?: number;
  totalLoot?: number;
  territoriesHeld?: number;
}) {
  return tx.crewWarStanding.upsert({
    where: {
      warId_crewId: {
        warId,
        crewId,
      },
    },
    create: {
      warId,
      crewId,
      totalPoints: delta.totalPoints ?? 0,
      totalKills: delta.totalKills ?? 0,
      totalDeaths: delta.totalDeaths ?? 0,
      totalLoot: delta.totalLoot ?? 0,
      territoriesHeld: delta.territoriesHeld ?? 0,
      rank: 0,
    },
    update: {
      totalPoints: { increment: delta.totalPoints ?? 0 },
      totalKills: { increment: delta.totalKills ?? 0 },
      totalDeaths: { increment: delta.totalDeaths ?? 0 },
      totalLoot: { increment: delta.totalLoot ?? 0 },
      territoriesHeld: delta.territoriesHeld !== undefined ? delta.territoriesHeld : undefined,
    },
  });
}

async function recomputeRanks(tx: any, warId: number) {
  const standings = await tx.crewWarStanding.findMany({
    where: { warId },
    orderBy: [
      { totalPoints: 'desc' },
      { totalKills: 'desc' },
      { totalLoot: 'desc' },
      { totalDeaths: 'asc' },
    ],
  });

  for (let index = 0; index < standings.length; index += 1) {
    await tx.crewWarStanding.update({
      where: { id: standings[index].id },
      data: { rank: index + 1 },
    });
  }
}

async function applyTerritoryTicks(war: NonNullable<CrewWarRecord>) {
  if (war.status !== 'active' && war.status !== 'lockdown') return;
  if (war.warType !== 'territory_war' && war.warType !== 'total_war') return;

  const now = new Date();
  const metadata = asJson(war.metadataJson);
  const territories = metadata.territories ?? {};
  let lastTickAt = metadata.lastTerritoryTickAt ? new Date(metadata.lastTerritoryTickAt) : new Date(war.activeFrom);
  const tickUntil = new Date(Math.min(now.getTime(), war.endTime.getTime()));

  if (Number.isNaN(lastTickAt.getTime())) {
    lastTickAt = new Date(war.activeFrom);
  }

  let changed = false;
  while (lastTickAt.getTime() + TERRITORY_TICK_MS <= tickUntil.getTime()) {
    const ownershipCounts = [war.attackerCrewId, war.defenderCrewId].reduce<Record<number, number>>((acc, crewId) => {
      acc[crewId] = 0;
      return acc;
    }, {});

    for (const territoryKey of TERRITORIES) {
      const ownerCrewId = Number(territories[territoryKey] ?? 0);
      if (ownerCrewId && ownershipCounts[ownerCrewId] !== undefined) {
        ownershipCounts[ownerCrewId] += 1;
      }
    }

    await prisma.$transaction(async (tx) => {
      for (const [crewIdRaw, heldCount] of Object.entries(ownershipCounts)) {
        const crewId = Number(crewIdRaw);
        if (heldCount <= 0) continue;
        const pointsAwarded = heldCount * 4;
        await upsertStanding(tx, war.id, crewId, {
          totalPoints: pointsAwarded,
          territoriesHeld: heldCount,
        });
        await tx.crewWarAction.create({
          data: {
            warId: war.id,
            actorCrewId: crewId,
            actionType: 'territory_tick',
            result: 'awarded',
            pointsAwarded,
            metadataJson: stringifyJson({ heldCount, tickAt: lastTickAt.toISOString() }),
          },
        });
      }

      await recomputeRanks(tx, war.id);
    });

    lastTickAt = new Date(lastTickAt.getTime() + TERRITORY_TICK_MS);
    changed = true;
  }

  if (changed) {
    metadata.lastTerritoryTickAt = lastTickAt.toISOString();
    await prisma.crewWar.update({
      where: { id: war.id },
      data: { metadataJson: stringifyJson(metadata) },
    });
  }
}

async function finalizeWar(war: NonNullable<CrewWarRecord>) {
  if (war.resolvedAt) return;

  await applyTerritoryTicks(war);

  let topParticipantReward: { playerId: number; rewardMoney: number } | null = null;

  await prisma.$transaction(async (tx) => {
    const standings = await tx.crewWarStanding.findMany({
      where: { warId: war.id },
      orderBy: [
        { totalPoints: 'desc' },
        { totalKills: 'desc' },
        { totalLoot: 'desc' },
        { totalDeaths: 'asc' },
      ],
    });

    if (standings.length === 0) {
      await tx.crewWarStanding.createMany({
        data: [
          { warId: war.id, crewId: war.attackerCrewId, rank: 1 },
          { warId: war.id, crewId: war.defenderCrewId, rank: 2 },
        ],
      });
    }

    const sortedStandings = standings.length > 0 ? standings : await tx.crewWarStanding.findMany({
      where: { warId: war.id },
      orderBy: { rank: 'asc' },
    });

    const winningStanding = sortedStandings[0] ?? null;
    const winnerCrewId = winningStanding?.crewId ?? null;
    const rewardPool = DEFAULT_REWARD_POOL + (war.entryStake || 0);

    if (winnerCrewId) {
      await tx.crew.update({
        where: { id: winnerCrewId },
        data: { bankBalance: { increment: rewardPool } },
      });
    }

    const topParticipant = await tx.crewWarParticipant.findFirst({
      where: { warId: war.id },
      orderBy: [
        { points: 'desc' },
        { kills: 'desc' },
        { lootStolen: 'desc' },
      ],
    });

    if (topParticipant) {
      await tx.player.update({
        where: { id: topParticipant.playerId },
        data: { money: { increment: 75000 }, reputation: { increment: 3 } },
      });
      topParticipantReward = { playerId: topParticipant.playerId, rewardMoney: 75000 };
    }

    await tx.crewWar.update({
      where: { id: war.id },
      data: {
        status: 'resolved',
        winnerCrewId,
        resolvedAt: new Date(),
      },
    });

    await recomputeRanks(tx, war.id);
  });

  const latestWar = await prisma.crewWar.findUnique({ where: { id: war.id } });
  const memberRows = await prisma.crewMember.findMany({
    where: { crewId: { in: [war.attackerCrewId, war.defenderCrewId] } },
    include: { player: { select: { id: true, preferredLanguage: true } } },
  });

  if (latestWar?.winnerCrewId) {
    for (const member of memberRows) {
      await notificationService.sendCrewWarEndedNotification(
        member.player.id,
        latestWar.id,
        latestWar.winnerCrewId,
      );
    }
  }

  if (topParticipantReward) {
    await activityService.logActivity(
      topParticipantReward.playerId,
      'crew_war_reward',
      'Crew war MVP reward received',
      { warId: war.id, rewardMoney: topParticipantReward.rewardMoney },
      true,
    );

    void checkAndUnlockAchievements(topParticipantReward.playerId).catch((error) => {
      console.error('[CrewWarService] Achievement check after war MVP reward failed:', error);
    });
  }

  await worldEventService.createEvent('crew.war_resolved', {
    warId: war.id,
    winnerCrewId: latestWar?.winnerCrewId,
    attackerCrewId: war.attackerCrewId,
    defenderCrewId: war.defenderCrewId,
  });

  void discordWebhookService.sendCrewWarEvent('war_resolved', {
    warId: war.id,
    winnerCrewId: latestWar?.winnerCrewId,
    attackerCrewId: war.attackerCrewId,
    defenderCrewId: war.defenderCrewId,
  });
}

async function syncWarLifecycle(warId: number) {
  const war = await getWarByIdRaw(warId);
  if (!war || war.status === 'resolved' || war.status === 'archived' || war.status === 'cancelled') {
    return war;
  }

  const now = new Date();
  let current = war;

  if (current.status === 'preparing' && current.activeFrom <= now) {
    current = await prisma.crewWar.update({
      where: { id: current.id },
      data: { status: 'active', startTime: now },
    });
    await notifyWarMembers(current, 'started');
    await worldEventService.createEvent('crew.war_started', {
      warId: current.id,
      attackerCrewId: current.attackerCrewId,
      defenderCrewId: current.defenderCrewId,
    });
    void discordWebhookService.sendCrewWarEvent('war_started', {
      warId: current.id,
      attackerCrewId: current.attackerCrewId,
      defenderCrewId: current.defenderCrewId,
    });
  }

  if (current.status === 'active') {
    await applyTerritoryTicks(current);
    if (current.lockDownFrom <= now) {
      current = await prisma.crewWar.update({
        where: { id: current.id },
        data: { status: 'lockdown' },
      });
      await notifyWarMembers(current, 'lockdown');
      await worldEventService.createEvent('crew.war_lockdown', { warId: current.id });
      void discordWebhookService.sendCrewWarEvent('war_lockdown', { warId: current.id });
    }
  }

  if ((current.status === 'active' || current.status === 'lockdown') && current.endTime <= now) {
    await finalizeWar(current);
    return prisma.crewWar.findUnique({ where: { id: current.id } });
  }

  return current;
}

async function syncCrewWarsForCrew(crewId: number) {
  const openWars = await prisma.crewWar.findMany({
    where: {
      status: { in: ['preparing', 'active', 'lockdown'] },
      OR: [{ attackerCrewId: crewId }, { defenderCrewId: crewId }],
    },
    select: { id: true },
  });

  for (const war of openWars) {
    await syncWarLifecycle(war.id);
  }
}

async function getCrewNames(crewIds: number[]) {
  const crews = await prisma.crew.findMany({
    where: { id: { in: crewIds } },
    select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
  });
  return new Map(crews.map((crew) => [crew.id, crew]));
}

async function notifyWarMembers(
  war: { id: number; attackerCrewId: number; defenderCrewId: number },
  type: 'declared' | 'started' | 'lockdown',
) {
  const [crewMap, memberRows] = await Promise.all([
    getCrewNames([war.attackerCrewId, war.defenderCrewId]),
    prisma.crewMember.findMany({
      where: { crewId: { in: [war.attackerCrewId, war.defenderCrewId] } },
      include: { player: { select: { id: true } } },
    }),
  ]);

  for (const member of memberRows) {
    const opposingCrewId = member.crewId === war.attackerCrewId ? war.defenderCrewId : war.attackerCrewId;
    const opposingCrewName = crewMap.get(opposingCrewId)?.name ?? `#${opposingCrewId}`;

    if (type === 'declared') {
      await notificationService.sendCrewWarDeclaredNotification(member.player.id, war.id, opposingCrewName);
    } else if (type === 'started') {
      await notificationService.sendCrewWarStartedNotification(member.player.id, war.id, opposingCrewName);
    } else {
      await notificationService.sendCrewWarLockdownNotification(member.player.id, war.id, opposingCrewName);
    }
  }
}

async function getPlayerNames(playerIds: number[]) {
  const players = await prisma.player.findMany({
    where: { id: { in: playerIds } },
    select: { id: true, username: true, preferredLanguage: true, isVip: true, vipExpiresAt: true },
  });
  return new Map(players.map((player) => [player.id, player]));
}

async function buildWarDetail(warId: number, playerId?: number) {
  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }

  const [standings, participants, actions] = await Promise.all([
    prisma.crewWarStanding.findMany({
      where: { warId },
      orderBy: [{ rank: 'asc' }, { totalPoints: 'desc' }],
    }),
    prisma.crewWarParticipant.findMany({
      where: { warId },
      orderBy: [{ points: 'desc' }, { kills: 'desc' }, { joinedAt: 'asc' }],
    }),
    prisma.crewWarAction.findMany({
      where: { warId },
      orderBy: { createdAt: 'desc' },
      take: 25,
    }),
  ]);

  const crewMap = await getCrewNames([
    war.attackerCrewId,
    war.defenderCrewId,
    ...standings.map((entry) => entry.crewId),
    ...participants.map((entry) => entry.crewId),
    ...actions.map((entry) => entry.actorCrewId).filter((value): value is number => typeof value === 'number'),
    ...actions.map((entry) => entry.targetCrewId).filter((value): value is number => typeof value === 'number'),
  ]);
  const playerMap = await getPlayerNames([
    ...participants.map((entry) => entry.playerId),
    ...actions.map((entry) => entry.actorId).filter((value): value is number => typeof value === 'number'),
    ...actions.map((entry) => entry.targetId).filter((value): value is number => typeof value === 'number'),
  ]);

  const metadata = asJson(war.metadataJson);
  const joinedParticipant = playerId
    ? participants.find((entry) => entry.playerId === playerId) ?? null
    : null;

  return {
    ...war,
    metadata,
    attackerCrew: crewMap.get(war.attackerCrewId) ?? null,
    defenderCrew: crewMap.get(war.defenderCrewId) ?? null,
    winnerCrew: war.winnerCrewId ? crewMap.get(war.winnerCrewId) ?? null : null,
    standings: standings.map((entry) => ({
      ...entry,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
    participants: participants.map((entry) => ({
      ...entry,
      player: playerMap.get(entry.playerId) ?? null,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
    recentActions: actions.map((entry) => ({
      ...entry,
      metadata: asJson(entry.metadataJson),
      actor: entry.actorId ? playerMap.get(entry.actorId) ?? null : null,
      target: entry.targetId ? playerMap.get(entry.targetId) ?? null : null,
      actorCrew: entry.actorCrewId ? crewMap.get(entry.actorCrewId) ?? null : null,
      targetCrew: entry.targetCrewId ? crewMap.get(entry.targetCrewId) ?? null : null,
    })),
    myParticipant: joinedParticipant,
  };
}

async function getMemberRole(crewId: number, playerId: number) {
  return prisma.crewMember.findFirst({
    where: { crewId, playerId },
    select: { role: true },
  });
}

export async function getWarHubForPlayer(playerId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });

  const season = await ensureCurrentSeason();

  if (!membership) {
    return {
      myCrewId: null,
      canDeclare: false,
      currentWar: null,
      availableTargets: [],
      season,
      seasonLeaderboard: [],
      recentWars: [],
    };
  }

  await syncCrewWarsForCrew(membership.crewId);

  const [currentWarRecord, crews, recentWars, seasonStandings] = await Promise.all([
    prisma.crewWar.findFirst({
      where: {
        status: { in: ['preparing', 'active', 'lockdown'] },
        OR: [{ attackerCrewId: membership.crewId }, { defenderCrewId: membership.crewId }],
      },
      orderBy: { createdAt: 'desc' },
    }),
    prisma.crew.findMany({
      where: { id: { not: membership.crewId } },
      orderBy: { name: 'asc' },
      select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
    }),
    prisma.crewWar.findMany({
      where: {
        OR: [{ attackerCrewId: membership.crewId }, { defenderCrewId: membership.crewId }],
      },
      orderBy: { createdAt: 'desc' },
      take: 8,
    }),
    prisma.crewWarStanding.findMany({
      where: {
        warId: {
          in: (await prisma.crewWar.findMany({
            where: { seasonId: season.id, status: { in: ['resolved', 'archived'] } },
            select: { id: true },
          })).map((war) => war.id),
        },
      },
    }),
  ]);

  const currentWar = currentWarRecord ? await buildWarDetail(currentWarRecord.id, playerId) : null;
  const targetCrewIdsInCooldown = new Set(
    recentWars
      .filter((war) => war.cooldownUntil && war.cooldownUntil > new Date())
      .flatMap((war) => [war.attackerCrewId, war.defenderCrewId]),
  );
  const crewCounts = await prisma.crewMember.groupBy({ by: ['crewId'], _count: { _all: true } });
  const countMap = new Map(crewCounts.map((entry) => [entry.crewId, entry._count._all]));
  const myCrewMemberCount = countMap.get(membership.crewId) ?? 0;

  const seasonAggregate = new Map<number, { crewId: number; totalPoints: number; totalKills: number; totalLoot: number }>();
  for (const standing of seasonStandings) {
    const existing = seasonAggregate.get(standing.crewId) ?? {
      crewId: standing.crewId,
      totalPoints: 0,
      totalKills: 0,
      totalLoot: 0,
    };
    existing.totalPoints += standing.totalPoints;
    existing.totalKills += standing.totalKills;
    existing.totalLoot += standing.totalLoot;
    seasonAggregate.set(standing.crewId, existing);
  }

  const seasonLeaderboard = Array.from(seasonAggregate.values())
    .sort((left, right) => right.totalPoints - left.totalPoints || right.totalKills - left.totalKills || right.totalLoot - left.totalLoot)
    .slice(0, 10);
  const seasonCrewMap = await getCrewNames(seasonLeaderboard.map((entry) => entry.crewId));

  return {
    myCrewId: membership.crewId,
    myRole: membership.role,
    canDeclare:
      membership.role === 'leader' &&
      !currentWar &&
      myCrewMemberCount >= MIN_MEMBERS_REQUIRED,
    currentWar,
    availableTargets: crews
      .map((crew) => ({
        ...crew,
        memberCount: countMap.get(crew.id) ?? 0,
        inCooldown: targetCrewIdsInCooldown.has(crew.id),
        isVipActive: isVipActive(crew),
      }))
      .filter((crew) => (countMap.get(crew.id) ?? 0) >= MIN_MEMBERS_REQUIRED),
    season,
    seasonLeaderboard: seasonLeaderboard.map((entry, index) => ({
      rank: index + 1,
      ...entry,
      crew: seasonCrewMap.get(entry.crewId) ?? null,
    })),
    recentWars,
  };
}

export async function declareWar(playerId: number, targetCrewId: number, warType: WarType) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });

  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }
  if (membership.role !== 'leader') {
    throw new Error('NOT_CREW_LEADER');
  }
  if (membership.crewId === targetCrewId) {
    throw new Error('CANNOT_DECLARE_OWN_CREW');
  }

  const [sourceMembers, targetMembers, targetCrew] = await Promise.all([
    getCrewMemberCount(membership.crewId),
    getCrewMemberCount(targetCrewId),
    prisma.crew.findUnique({ where: { id: targetCrewId }, select: { id: true, name: true } }),
  ]);

  if (!targetCrew) {
    throw new Error('TARGET_CREW_NOT_FOUND');
  }
  if (sourceMembers < MIN_MEMBERS_REQUIRED || targetMembers < MIN_MEMBERS_REQUIRED) {
    throw new Error('NOT_ENOUGH_CREW_MEMBERS');
  }

  await syncCrewWarsForCrew(membership.crewId);
  await syncCrewWarsForCrew(targetCrewId);

  const existingWar = await prisma.crewWar.findFirst({
    where: {
      status: { in: ['preparing', 'active', 'lockdown'] },
      OR: [
        { attackerCrewId: membership.crewId },
        { defenderCrewId: membership.crewId },
        { attackerCrewId: targetCrewId },
        { defenderCrewId: targetCrewId },
      ],
    },
  });
  if (existingWar) {
    throw new Error('CREW_ALREADY_IN_WAR');
  }

  const season = await ensureCurrentSeason();
  const now = new Date();
  const activeFrom = new Date(now.getTime() + PREPARATION_MINUTES * 60 * 1000);
  const lockDownFrom = new Date(activeFrom.getTime() + (ACTIVE_HOURS * 60 - LOCKDOWN_MINUTES) * 60 * 1000);
  const endTime = new Date(activeFrom.getTime() + ACTIVE_HOURS * 60 * 60 * 1000);
  const metadata: Record<string, any> = {
    territories: Object.fromEntries(TERRITORIES.map((territory) => [territory, null])),
    lastTerritoryTickAt: activeFrom.toISOString(),
  };

  const war = await prisma.$transaction(async (tx) => {
    const createdWar = await tx.crewWar.create({
      data: {
        seasonId: season.id,
        warType,
        status: 'preparing',
        declaredByPlayerId: playerId,
        attackerCrewId: membership.crewId,
        defenderCrewId: targetCrewId,
        metadataJson: stringifyJson(metadata),
        startTime: now,
        activeFrom,
        lockDownFrom,
        endTime,
        cooldownUntil: new Date(endTime.getTime() + 8 * 60 * 60 * 1000),
        entryStake: 0,
      },
    });

    await tx.crewWarStanding.createMany({
      data: [
        { warId: createdWar.id, crewId: membership.crewId, rank: 1 },
        { warId: createdWar.id, crewId: targetCrewId, rank: 2 },
      ],
    });

    await tx.crewWarParticipant.create({
      data: {
        warId: createdWar.id,
        playerId,
        crewId: membership.crewId,
        role: membership.role,
      },
    });

    await tx.crewWarAction.create({
      data: {
        warId: createdWar.id,
        actorId: playerId,
        actorCrewId: membership.crewId,
        targetCrewId,
        actionType: 'war_declared',
        result: 'success',
        metadataJson: stringifyJson({ warType }),
      },
    });

    return createdWar;
  });

  await notifyWarMembers(war, 'declared');

  await worldEventService.createEvent('crew.war_declared', {
    warId: war.id,
    attackerCrewId: membership.crewId,
    defenderCrewId: targetCrewId,
    warType,
  });

  void discordWebhookService.sendCrewWarEvent('war_declared', {
    warId: war.id,
    attackerCrewId: membership.crewId,
    defenderCrewId: targetCrewId,
    warType,
  });

  return buildWarDetail(war.id, playerId);
}

export async function joinWar(playerId: number, warId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });
  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }

  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }
  if (![war.attackerCrewId, war.defenderCrewId].includes(membership.crewId)) {
    throw new Error('NOT_WAR_PARTICIPANT_CREW');
  }
  if (!['preparing', 'active', 'lockdown'].includes(war.status)) {
    throw new Error('WAR_NOT_JOINABLE');
  }

  await prisma.crewWarParticipant.upsert({
    where: { warId_playerId: { warId, playerId } },
    create: {
      warId,
      playerId,
      crewId: membership.crewId,
      role: membership.role,
    },
    update: {
      crewId: membership.crewId,
      role: membership.role,
      status: 'joined',
    },
  });

  return buildWarDetail(warId, playerId);
}

export async function performWarAction(playerId: number, warId: number, actionType: string, targetPlayerId?: number, territoryKey?: string) {
  const actionConfig = WAR_ACTIONS[actionType];
  if (!actionConfig) {
    throw new Error('INVALID_WAR_ACTION');
  }

  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });
  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }

  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }
  if (war.status !== 'active') {
    throw new Error('WAR_NOT_ACTIVE');
  }
  if (![war.attackerCrewId, war.defenderCrewId].includes(membership.crewId)) {
    throw new Error('NOT_WAR_PARTICIPANT_CREW');
  }

  const enemyCrewId = war.attackerCrewId === membership.crewId ? war.defenderCrewId : war.attackerCrewId;
  const [player, crew, targetPlayer, existingParticipant] = await Promise.all([
    prisma.player.findUnique({ where: { id: playerId }, select: { id: true, username: true, isVip: true, vipExpiresAt: true } }),
    prisma.crew.findUnique({ where: { id: membership.crewId }, select: { id: true, name: true, isVip: true, vipExpiresAt: true } }),
    targetPlayerId
      ? prisma.crewMember.findFirst({
          where: { playerId: targetPlayerId, crewId: enemyCrewId },
          include: { player: { select: { id: true, username: true } } },
        })
      : Promise.resolve(null),
    prisma.crewWarParticipant.findUnique({
      where: { warId_playerId: { warId, playerId } },
    }),
  ]);

  if (!player || !crew) {
    throw new Error('WAR_ACTOR_NOT_FOUND');
  }
  if (actionConfig.requiresTarget && !targetPlayer) {
    throw new Error('WAR_TARGET_REQUIRED');
  }
  if (actionConfig.vipPlayerOnly && !isVipActive(player)) {
    throw new Error('VIP_PLAYER_REQUIRED');
  }
  if (actionConfig.vipCrewOnly && !isVipActive(crew)) {
    throw new Error('VIP_CREW_REQUIRED');
  }

  const participant = existingParticipant ?? await prisma.crewWarParticipant.create({
    data: {
      warId,
      playerId,
      crewId: membership.crewId,
      role: membership.role,
    },
  });

  const now = new Date();
  if (participant.lastActionAt && participant.lastActionAt.getTime() + actionConfig.cooldownMs > now.getTime()) {
    const remainingMs = participant.lastActionAt.getTime() + actionConfig.cooldownMs - now.getTime();
    const remainingMinutes = Math.ceil(remainingMs / 60000);
    throw new Error(`WAR_ACTION_COOLDOWN:${remainingMinutes}`);
  }

  const maxActions = isVipActive(player) ? 28 : 20;
  if (participant.actionCount >= maxActions) {
    throw new Error('WAR_ACTION_LIMIT_REACHED');
  }

  if (targetPlayerId) {
    const repeatedAction = await prisma.crewWarAction.findFirst({
      where: {
        warId,
        actorId: playerId,
        targetId: targetPlayerId,
        createdAt: { gte: new Date(Date.now() - REPEATED_TARGET_WINDOW_MS) },
        result: 'success',
      },
      orderBy: { createdAt: 'desc' },
    });
    if (repeatedAction) {
      await prisma.crewWarAction.create({
        data: {
          warId,
          actorId: playerId,
          actorCrewId: membership.crewId,
          targetId: targetPlayerId,
          targetCrewId: enemyCrewId,
          actionType,
          result: 'blocked_repeated_target',
          metadataJson: stringifyJson({ repeatedActionId: repeatedAction.id }),
        },
      });
      throw new Error('WAR_REPEATED_TARGET_BLOCKED');
    }
  }

  const crewVipBonus = isVipActive(crew) ? 1.1 : 1;
  const playerVipBonus = isVipActive(player) ? 1.15 : 1;
  let pointsAwarded = Math.round(actionConfig.basePoints * crewVipBonus * playerVipBonus);
  let moneyDelta = 0;
  let metadata = asJson(undefined);

  if (actionType === 'attack_mug' || actionType === 'raid') {
    const targetCrew = await prisma.crew.findUnique({
      where: { id: enemyCrewId },
      select: { bankBalance: true },
    });
    const bankBalance = targetCrew?.bankBalance ?? 0;
    const rawLoot = actionType === 'raid'
      ? Math.max(0, Math.min(75000, Math.floor(bankBalance * 0.08)))
      : Math.max(0, Math.min(25000, Math.floor(bankBalance * 0.03)));
    moneyDelta = rawLoot;
    pointsAwarded += moneyDelta > 0 ? 2 : 0;
  }

  if (actionType === 'territory_claim') {
    if (war.warType !== 'territory_war' && war.warType !== 'total_war') {
      throw new Error('WAR_TERRITORY_UNAVAILABLE');
    }
    if (!territoryKey || !TERRITORIES.includes(territoryKey)) {
      throw new Error('INVALID_TERRITORY');
    }
    const warMetadata = asJson(war.metadataJson);
    const territories = warMetadata.territories ?? {};
    const previousOwner = territories[territoryKey] ?? null;
    territories[territoryKey] = membership.crewId;
    warMetadata.territories = territories;
    metadata = { territoryKey, previousOwner, newOwner: membership.crewId };
    await prisma.crewWar.update({
      where: { id: warId },
      data: { metadataJson: stringifyJson(warMetadata) },
    });

    const heldByActor = TERRITORIES.filter((key) => territories[key] === membership.crewId).length;
    const heldByEnemy = TERRITORIES.filter((key) => territories[key] === enemyCrewId).length;
    await prisma.crewWarStanding.upsert({
      where: { warId_crewId: { warId, crewId: membership.crewId } },
      create: { warId, crewId: membership.crewId, territoriesHeld: heldByActor, rank: 1 },
      update: { territoriesHeld: heldByActor },
    });
    await prisma.crewWarStanding.upsert({
      where: { warId_crewId: { warId, crewId: enemyCrewId } },
      create: { warId, crewId: enemyCrewId, territoriesHeld: heldByEnemy, rank: 2 },
      update: { territoriesHeld: heldByEnemy },
    });
  }

  await prisma.$transaction(async (tx) => {
    if (moneyDelta > 0) {
      await tx.crew.update({
        where: { id: enemyCrewId },
        data: { bankBalance: { decrement: moneyDelta } },
      });
      await tx.crew.update({
        where: { id: membership.crewId },
        data: { bankBalance: { increment: moneyDelta } },
      });
    }

    await tx.crewWarParticipant.update({
      where: { id: participant.id },
      data: {
        points: { increment: pointsAwarded },
        kills: actionType === 'attack_kill' ? { increment: 1 } : undefined,
        lootStolen: moneyDelta > 0 ? { increment: moneyDelta } : undefined,
        actionCount: { increment: 1 },
        lastActionAt: now,
      },
    });

    if (targetPlayerId) {
      await tx.crewWarParticipant.upsert({
        where: { warId_playerId: { warId, playerId: targetPlayerId } },
        create: {
          warId,
          playerId: targetPlayerId,
          crewId: enemyCrewId,
          role: targetPlayer?.role ?? 'member',
          deaths: actionType === 'attack_kill' ? 1 : 0,
        },
        update: {
          deaths: actionType === 'attack_kill' ? { increment: 1 } : undefined,
        },
      });
    }

    await upsertStanding(tx, warId, membership.crewId, {
      totalPoints: pointsAwarded,
      totalKills: actionType === 'attack_kill' ? 1 : 0,
      totalLoot: moneyDelta,
    });
    if (actionType === 'attack_kill') {
      await upsertStanding(tx, warId, enemyCrewId, {
        totalDeaths: 1,
      });
    }

    await tx.crewWarAction.create({
      data: {
        warId,
        actorId: playerId,
        actorCrewId: membership.crewId,
        targetId: targetPlayerId,
        targetCrewId: targetPlayerId ? enemyCrewId : null,
        territoryKey: territoryKey ?? null,
        actionType,
        result: 'success',
        pointsAwarded,
        moneyDelta,
        metadataJson: stringifyJson({
          ...metadata,
          playerVip: isVipActive(player),
          crewVip: isVipActive(crew),
        }),
      },
    });

    await recomputeRanks(tx, warId);
  });

  await activityService.logActivity(
    playerId,
    'crew_war_action',
    `Crew war action: ${actionType}`,
    { warId, actionType, pointsAwarded, moneyDelta },
    true,
  );

  void checkAndUnlockAchievements(playerId).catch((error) => {
    console.error('[CrewWarService] Achievement check after war action failed:', error);
  });

  await worldEventService.createEvent('crew.war_action', {
    warId,
    actionType,
    actorId: playerId,
    actorCrewId: membership.crewId,
    targetId: targetPlayerId,
    targetCrewId: targetPlayerId ? enemyCrewId : null,
    pointsAwarded,
    moneyDelta,
  });

  return buildWarDetail(warId, playerId);
}

export async function getWarDetailForPlayer(playerId: number, warId: number) {
  const detail = await buildWarDetail(warId, playerId);
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true },
  });
  if (!membership || ![detail.attackerCrewId, detail.defenderCrewId].includes(membership.crewId)) {
    throw new Error('WAR_ACCESS_DENIED');
  }
  return detail;
}

export async function getAdminWarOverview() {
  const openWars = await prisma.crewWar.findMany({
    where: { status: { in: ['preparing', 'active', 'lockdown'] } },
    orderBy: [{ activeFrom: 'asc' }, { createdAt: 'desc' }],
  });

  for (const war of openWars) {
    await syncWarLifecycle(war.id);
  }

  const season = await ensureCurrentSeason();
  const [activeWars, recentWars, flaggedActions, crews] = await Promise.all([
    prisma.crewWar.findMany({
      where: { status: { in: ['preparing', 'active', 'lockdown'] } },
      orderBy: [{ activeFrom: 'asc' }, { createdAt: 'desc' }],
      take: 20,
    }),
    prisma.crewWar.findMany({
      orderBy: { createdAt: 'desc' },
      take: 20,
    }),
    prisma.crewWarAction.count({
      where: { result: { startsWith: 'blocked' } },
    }),
    prisma.crew.findMany({
      orderBy: { name: 'asc' },
      select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
    }),
  ]);

  const detailedActiveWars = await Promise.all(activeWars.map((war) => buildWarDetail(war.id)));
  const seasonWars = await prisma.crewWar.findMany({
    where: { seasonId: season.id, status: { in: ['resolved', 'archived'] } },
    select: { id: true },
  });
  const seasonStandings = await prisma.crewWarStanding.findMany({
    where: { warId: { in: seasonWars.map((war) => war.id) } },
  });
  const aggregates = new Map<number, { crewId: number; totalPoints: number; totalKills: number; totalLoot: number }>();
  for (const standing of seasonStandings) {
    const current = aggregates.get(standing.crewId) ?? { crewId: standing.crewId, totalPoints: 0, totalKills: 0, totalLoot: 0 };
    current.totalPoints += standing.totalPoints;
    current.totalKills += standing.totalKills;
    current.totalLoot += standing.totalLoot;
    aggregates.set(standing.crewId, current);
  }
  const leaderboard = Array.from(aggregates.values()).sort((left, right) => right.totalPoints - left.totalPoints || right.totalKills - left.totalKills);
  const crewMap = await getCrewNames(leaderboard.map((entry) => entry.crewId));

  return {
    season,
    flaggedActions,
    crews,
    activeWars: detailedActiveWars,
    recentWars,
    seasonLeaderboard: leaderboard.slice(0, 10).map((entry, index) => ({
      rank: index + 1,
      ...entry,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
  };
}

export async function adminDeclareWar(adminId: number, payload: {
  attackerCrewId: number;
  defenderCrewId: number;
  warType: WarType;
  startsInMinutes?: number;
}) {
  const season = await ensureCurrentSeason();
  const now = new Date();
  const startsInMinutes = Math.max(1, Math.min(60, payload.startsInMinutes ?? PREPARATION_MINUTES));
  const activeFrom = new Date(now.getTime() + startsInMinutes * 60 * 1000);
  const lockDownFrom = new Date(activeFrom.getTime() + (ACTIVE_HOURS * 60 - LOCKDOWN_MINUTES) * 60 * 1000);
  const endTime = new Date(activeFrom.getTime() + ACTIVE_HOURS * 60 * 60 * 1000);
  const war = await prisma.crewWar.create({
    data: {
      seasonId: season.id,
      warType: payload.warType,
      status: 'preparing',
      declaredByPlayerId: adminId,
      attackerCrewId: payload.attackerCrewId,
      defenderCrewId: payload.defenderCrewId,
      metadataJson: stringifyJson({ territories: Object.fromEntries(TERRITORIES.map((territory) => [territory, null])) }),
      startTime: now,
      activeFrom,
      lockDownFrom,
      endTime,
      cooldownUntil: new Date(endTime.getTime() + 8 * 60 * 60 * 1000),
    },
  });

  await prisma.crewWarStanding.createMany({
    data: [
      { warId: war.id, crewId: payload.attackerCrewId, rank: 1 },
      { warId: war.id, crewId: payload.defenderCrewId, rank: 2 },
    ],
  });

  await prisma.crewWarAction.create({
    data: {
      warId: war.id,
      actorId: adminId,
      actorCrewId: payload.attackerCrewId,
      targetCrewId: payload.defenderCrewId,
      actionType: 'war_declared',
      result: 'success',
      metadataJson: stringifyJson({ warType: payload.warType, declaredVia: 'admin' }),
    },
  });

  await notifyWarMembers(war, 'declared');

  await worldEventService.createEvent('crew.war_declared', {
    warId: war.id,
    attackerCrewId: payload.attackerCrewId,
    defenderCrewId: payload.defenderCrewId,
    warType: payload.warType,
    declaredVia: 'admin',
  });

  void discordWebhookService.sendCrewWarEvent('war_declared', {
    warId: war.id,
    attackerCrewId: payload.attackerCrewId,
    defenderCrewId: payload.defenderCrewId,
    warType: payload.warType,
    declaredVia: 'admin',
  });

  return buildWarDetail(war.id);
}

export async function adminUpdateWarStatus(warId: number, action: 'start_now' | 'enter_lockdown' | 'resolve' | 'archive' | 'cancel') {
  const war = await prisma.crewWar.findUnique({ where: { id: warId } });
  if (!war) throw new Error('WAR_NOT_FOUND');

  if (action === 'start_now') {
    const updatedWar = await prisma.crewWar.update({
      where: { id: warId },
      data: {
        status: 'active',
        activeFrom: new Date(),
        startTime: new Date(),
        lockDownFrom: new Date(Date.now() + (ACTIVE_HOURS * 60 - LOCKDOWN_MINUTES) * 60 * 1000),
        endTime: new Date(Date.now() + ACTIVE_HOURS * 60 * 60 * 1000),
      },
    });
    await notifyWarMembers(updatedWar, 'started');
    await worldEventService.createEvent('crew.war_started', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      startedVia: 'admin',
    });
    void discordWebhookService.sendCrewWarEvent('war_started', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      startedVia: 'admin',
    });
  } else if (action === 'enter_lockdown') {
    const updatedWar = await prisma.crewWar.update({ where: { id: warId }, data: { status: 'lockdown', lockDownFrom: new Date() } });
    await notifyWarMembers(updatedWar, 'lockdown');
    await worldEventService.createEvent('crew.war_lockdown', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      enteredVia: 'admin',
    });
    void discordWebhookService.sendCrewWarEvent('war_lockdown', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      enteredVia: 'admin',
    });
  } else if (action === 'resolve') {
    await finalizeWar(war);
  } else if (action === 'archive') {
    await prisma.crewWar.update({ where: { id: warId }, data: { status: 'archived' } });
  } else if (action === 'cancel') {
    await prisma.crewWar.update({ where: { id: warId }, data: { status: 'cancelled', resolvedAt: new Date() } });
  }

  return buildWarDetail(warId);
}