import { Prisma } from '@prisma/client';
import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { getActiveEventBoostEffects, grantPurchasedCredits } from './premiumCreditsService';
import { creditEventItem, parseEventItemGrants } from './eventItemService';
import {
  fulfillExtendedEventRewards,
  hasExtendedEventRewards,
  parseExtendedEventRewards,
} from './eventRewardFulfillmentService';
import { gameEventNotificationService } from './gameEventNotificationService';
import { getDefaultRewardRulesForTemplateKey } from './gameEventPresets';
import { activePortraitPathFromRow } from '../utils/avatarDisplay';
import type { GameEventTemplate, GameLiveEvent } from '@prisma/client';

type GameLiveEventWithTemplate = GameLiveEvent & { template: GameEventTemplate };

type JsonRecord = Record<string, unknown>;

/** Persist JSON into Prisma `String` @db.LongText columns (not native Json type). */
const toJsonString = (value: unknown): string | null | undefined => {
  if (value === undefined) {
    return undefined;
  }
  if (value === null) {
    return null;
  }
  if (typeof value === 'string') {
    return value;
  }
  return JSON.stringify(value);
};

function parseJsonRecord(raw: string | null | undefined): Record<string, unknown> {
  if (raw == null || raw === '') {
    return {};
  }
  if (typeof raw === 'string') {
    try {
      const v = JSON.parse(raw) as unknown;
      return v && typeof v === 'object' && !Array.isArray(v) ? (v as Record<string, unknown>) : {};
    } catch {
      return {};
    }
  }
  return {};
}

const liveEventInclude = {
  template: true,
  modifiers: true,
  rewardRules: {
    orderBy: {
      sortOrder: 'asc' as const,
    },
  },
} satisfies Prisma.GameLiveEventInclude;

/** Live leaderboard rank from score (ranks persist only after event resolve). */
async function computeLiveParticipantRank(
  liveEventId: number,
  score: number,
): Promise<number> {
  const ahead = await prisma.gameEventParticipantProgress.count({
    where: {
      liveEventId,
      score: { gt: score },
    },
  });
  return ahead + 1;
}

const eventParticipantPlayerInclude = {
  player: {
    select: {
      id: true,
      username: true,
      rank: true,
      avatar: true,
      activePortrait: {
        select: { imagePath: true },
      },
    },
  },
} as const;

function mapEventParticipantRow<
  T extends {
    player?: {
      id: number;
      username: string;
      rank: number;
      avatar: string | null;
      activePortrait?: { imagePath: string } | null;
    } | null;
  },
>(row: T): T {
  if (!row.player) {
    return row;
  }
  const { activePortrait, ...playerRest } = row.player;
  return {
    ...row,
    player: {
      ...playerRest,
      activePortraitPath: activePortraitPathFromRow(activePortrait?.imagePath ?? null),
    },
  };
}

class GameEventService {
  async listTemplates() {
    return prisma.gameEventTemplate.findMany({
      orderBy: [
        { isActive: 'desc' },
        { category: 'asc' },
        { eventType: 'asc' },
        { titleNl: 'asc' },
      ],
    });
  }

  async createTemplate(input: {
    key: string;
    category: string;
    eventType: string;
    titleNl: string;
    titleEn: string;
    shortDescriptionNl?: string;
    shortDescriptionEn?: string;
    descriptionNl?: string;
    descriptionEn?: string;
    icon?: string;
    bannerImage?: string;
    configSchemaJson?: JsonRecord;
    uiSchemaJson?: JsonRecord;
    isActive?: boolean;
  }) {
    return prisma.gameEventTemplate.create({
      data: {
        key: input.key,
        category: input.category,
        eventType: input.eventType,
        titleNl: input.titleNl,
        titleEn: input.titleEn,
        shortDescriptionNl: input.shortDescriptionNl,
        shortDescriptionEn: input.shortDescriptionEn,
        descriptionNl: input.descriptionNl,
        descriptionEn: input.descriptionEn,
        icon: input.icon,
        bannerImage: input.bannerImage,
        configSchemaJson: toJsonString(input.configSchemaJson),
        uiSchemaJson: toJsonString(input.uiSchemaJson),
        isActive: input.isActive ?? true,
      },
    });
  }

  async updateTemplate(
    id: number,
    input: Partial<{
      category: string;
      eventType: string;
      titleNl: string;
      titleEn: string;
      shortDescriptionNl: string | null;
      shortDescriptionEn: string | null;
      descriptionNl: string | null;
      descriptionEn: string | null;
      icon: string | null;
      bannerImage: string | null;
      configSchemaJson: JsonRecord | null;
      uiSchemaJson: JsonRecord | null;
      isActive: boolean;
    }>,
  ) {
    return prisma.gameEventTemplate.update({
      where: { id },
      data: {
        ...input,
        configSchemaJson:
          input.configSchemaJson === undefined ? undefined : toJsonString(input.configSchemaJson),
        uiSchemaJson:
          input.uiSchemaJson === undefined ? undefined : toJsonString(input.uiSchemaJson),
      },
    });
  }

  async listSchedules() {
    return prisma.gameEventSchedule.findMany({
      include: {
        template: true,
      },
      orderBy: [
        { enabled: 'desc' },
        { updatedAt: 'desc' },
      ],
    });
  }

  async createSchedule(input: {
    templateId: number;
    scheduleType: string;
    intervalMinutes?: number | null;
    durationMinutes?: number | null;
    cronExpression?: string | null;
    startWindowUtc?: string | null;
    endWindowUtc?: string | null;
    cooldownMinutes?: number | null;
    enabled?: boolean;
    weight?: number;
  }) {
    return prisma.gameEventSchedule.create({
      data: {
        templateId: input.templateId,
        scheduleType: input.scheduleType,
        intervalMinutes: input.intervalMinutes,
        durationMinutes: input.durationMinutes,
        cronExpression: input.cronExpression,
        startWindowUtc: input.startWindowUtc,
        endWindowUtc: input.endWindowUtc,
        cooldownMinutes: input.cooldownMinutes,
        enabled: input.enabled ?? true,
        weight: input.weight ?? 1,
      },
      include: {
        template: true,
      },
    });
  }

  async updateSchedule(
    id: number,
    input: Partial<{
      scheduleType: string;
      intervalMinutes: number | null;
      durationMinutes: number | null;
      cronExpression: string | null;
      startWindowUtc: string | null;
      endWindowUtc: string | null;
      cooldownMinutes: number | null;
      enabled: boolean;
      weight: number;
      lastTriggeredAt: Date | null;
    }>,
  ) {
    return prisma.gameEventSchedule.update({
      where: { id },
      data: input,
      include: {
        template: true,
      },
    });
  }

  async listLiveEvents(status?: string) {
    return prisma.gameLiveEvent.findMany({
      where: status ? { status } : undefined,
      include: liveEventInclude,
      orderBy: [
        { updatedAt: 'desc' },
        { createdAt: 'desc' },
      ],
    });
  }

  async createLiveEvent(input: {
    templateId: number;
    status?: string;
    startedAt?: Date | null;
    endsAt?: Date | null;
    configJson?: JsonRecord;
    stateJson?: JsonRecord;
    announcementJson?: JsonRecord;
    scopeJson?: JsonRecord;
    createdByAdminId?: number;
    modifiers?: Array<{
      targetSystem: string;
      modifierKey: string;
      operation: string;
      valueJson?: JsonRecord;
      conditionsJson?: JsonRecord;
    }>;
    rewardRules?: Array<{
      triggerType: string;
      triggerConfigJson?: JsonRecord;
      rewardsJson: JsonRecord;
      sortOrder?: number;
      isActive?: boolean;
    }>;
  }) {
    const liveEvent = await prisma.gameLiveEvent.create({
      data: {
        templateId: input.templateId,
        status: input.status ?? 'draft',
        startedAt: input.startedAt,
        endsAt: input.endsAt,
        configJson: toJsonString(input.configJson),
        stateJson: toJsonString(input.stateJson),
        announcementJson: toJsonString(input.announcementJson),
        scopeJson: toJsonString(input.scopeJson),
        createdByAdminId: input.createdByAdminId,
        modifiers: input.modifiers?.length
          ? {
              create: input.modifiers.map((modifier) => ({
                targetSystem: modifier.targetSystem,
                modifierKey: modifier.modifierKey,
                operation: modifier.operation,
                valueJson: toJsonString(modifier.valueJson),
                conditionsJson: toJsonString(modifier.conditionsJson),
              })),
            }
          : undefined,
        rewardRules: input.rewardRules?.length
          ? {
              create: input.rewardRules.map((rule, index) => ({
                triggerType: rule.triggerType,
                triggerConfigJson: toJsonString(rule.triggerConfigJson),
                rewardsJson: toJsonString(rule.rewardsJson) ?? '{}',
                sortOrder: rule.sortOrder ?? index,
                isActive: rule.isActive ?? true,
              })),
            }
          : undefined,
      },
      include: liveEventInclude,
    });

    await worldEventService.createEvent('game_event.live.created', {
      liveEventId: liveEvent.id,
      templateId: liveEvent.templateId,
      status: liveEvent.status,
    });

    if (liveEvent.status === 'active' && liveEvent.template) {
      setImmediate(() => {
        void gameEventNotificationService
          .onLiveEventStarted(liveEvent as GameLiveEventWithTemplate)
          .catch((e) => console.error('[GameEventNotification] start', e));
      });
    }

    return liveEvent;
  }

  async updateLiveEvent(
    id: number,
    input: Partial<{
      status: string;
      startedAt: Date | null;
      endsAt: Date | null;
      resolvedAt: Date | null;
      configJson: JsonRecord | null;
      stateJson: JsonRecord | null;
      announcementJson: JsonRecord | null;
      scopeJson: JsonRecord | null;
    }>,
  ) {
    const previous = await prisma.gameLiveEvent.findUnique({
      where: { id },
      select: { status: true },
    });

    const liveEvent = await prisma.gameLiveEvent.update({
      where: { id },
      data: {
        status: input.status,
        startedAt: input.startedAt,
        endsAt: input.endsAt,
        resolvedAt: input.resolvedAt,
        configJson: input.configJson === undefined ? undefined : toJsonString(input.configJson),
        stateJson: input.stateJson === undefined ? undefined : toJsonString(input.stateJson),
        announcementJson:
          input.announcementJson === undefined ? undefined : toJsonString(input.announcementJson),
        scopeJson: input.scopeJson === undefined ? undefined : toJsonString(input.scopeJson),
      },
      include: liveEventInclude,
    });

    if (previous?.status !== liveEvent.status) {
      await worldEventService.createEvent('game_event.live.status_changed', {
        liveEventId: liveEvent.id,
        previousStatus: previous?.status ?? null,
        nextStatus: liveEvent.status,
      });
    }

    return liveEvent;
  }

  async getOverview(playerId?: number) {
    const now = new Date();

    const [active, upcoming] = await Promise.all([
      prisma.gameLiveEvent.findMany({
        where: {
          status: 'active',
          AND: [
            {
              OR: [
                { startedAt: null },
                { startedAt: { lte: now } },
              ],
            },
            {
              OR: [
                { endsAt: null },
                { endsAt: { gt: now } },
              ],
            },
          ],
        },
        include: liveEventInclude,
        orderBy: [
          { startedAt: 'asc' },
          { createdAt: 'desc' },
        ],
      }),
      prisma.gameLiveEvent.findMany({
        where: {
          status: 'scheduled',
          startedAt: { gt: now },
        },
        include: liveEventInclude,
        orderBy: {
          startedAt: 'asc',
        },
        take: 10,
      }),
    ]);

    const featured = active[0] ?? upcoming[0] ?? null;
    const liveEventIds = [...active, ...upcoming].map((item) => item.id);
    const activeEventIds = new Set(active.map((item) => item.id));
    const activeTemplateIds = new Set(active.map((item) => item.templateId));
    const scheduledTemplateIds = new Set(upcoming.map((item) => item.templateId));

    const rawProgress = playerId && liveEventIds.length > 0
      ? await prisma.gameEventParticipantProgress.findMany({
          where: {
            playerId,
            liveEventId: { in: liveEventIds },
          },
        })
      : [];

    const myProgress = await Promise.all(
      rawProgress.map(async (row) => {
        if (!activeEventIds.has(row.liveEventId) || row.rank != null) {
          return row;
        }
        const rank = await computeLiveParticipantRank(row.liveEventId, row.score);
        return { ...row, rank };
      }),
    );

    // Scheduler starts events as `active` immediately, so `upcoming` is often empty.
    // Preview the next interval starts from enabled schedules for templates not live yet.
    const schedules = await prisma.gameEventSchedule.findMany({
      where: {
        enabled: true,
        scheduleType: 'interval',
        template: { isActive: true },
      },
      include: { template: true },
      orderBy: { lastTriggeredAt: 'asc' },
    });

    const upcomingPreview = schedules
      .filter((schedule) => {
        if (!schedule.intervalMinutes) return false;
        if (activeTemplateIds.has(schedule.templateId)) return false;
        if (scheduledTemplateIds.has(schedule.templateId)) return false;
        return true;
      })
      .map((schedule) => {
        const intervalMs = schedule.intervalMinutes! * 60 * 1000;
        const cooldownMs = (schedule.cooldownMinutes ?? 0) * 60 * 1000;
        const durationMs = (schedule.durationMinutes ?? 60) * 60 * 1000;
        const waitMs = Math.max(intervalMs, cooldownMs);
        const startsAt = schedule.lastTriggeredAt
          ? new Date(schedule.lastTriggeredAt.getTime() + waitMs)
          : now;
        const endsAt = new Date(Math.max(startsAt.getTime(), now.getTime()) + durationMs);
        const defaultRules = getDefaultRewardRulesForTemplateKey(schedule.template.key);
        return {
          id: null as number | null,
          preview: true as const,
          status: 'scheduled' as const,
          startedAt: startsAt,
          endsAt,
          template: schedule.template,
          rewardRules: defaultRules.map((rule, index) => ({
            id: -(index + 1),
            triggerType: rule.triggerType,
            triggerConfigJson: JSON.stringify(rule.triggerConfigJson),
            rewardsJson: JSON.stringify(rule.rewardsJson),
            sortOrder: rule.sortOrder,
            isActive: rule.isActive,
          })),
        };
      })
      .filter((item) => item.startedAt.getTime() > now.getTime() - 60_000)
      .sort((a, b) => a.startedAt.getTime() - b.startedAt.getTime())
      .slice(0, 8);

    return {
      serverTime: now,
      featured,
      active,
      upcoming,
      upcomingPreview,
      myProgress,
    };
  }

  async getEventDetails(liveEventId: number, playerId?: number) {
    const event = await prisma.gameLiveEvent.findUnique({
      where: { id: liveEventId },
      include: {
        ...liveEventInclude,
        leaderboardSnapshots: {
          orderBy: {
            snapshotAt: 'desc',
          },
          take: 5,
        },
      },
    });

    if (!event) {
      return null;
    }

    // Ranks are only persisted when an event resolves. Live boards must sort by
    // score — filtering on rank<=10 would return only the viewer (their row is
    // included via playerId OR) while other participants still have rank=null.
    const resolved = event.status === 'completed';
    const participantInclude = eventParticipantPlayerInclude;

    const topParticipants = await prisma.gameEventParticipantProgress.findMany({
      where: { liveEventId },
      orderBy: resolved
        ? [{ rank: 'asc' }, { score: 'desc' }]
        : [{ score: 'desc' }, { updatedAt: 'asc' }],
      take: 10,
      include: participantInclude,
    });

    let myProgress = playerId
      ? await prisma.gameEventParticipantProgress.findFirst({
          where: { liveEventId, playerId },
          include: participantInclude,
        })
      : null;

    let participants = [...topParticipants];
    if (myProgress && !participants.some((row) => row.playerId === playerId)) {
      participants.push(myProgress);
    }

    if (!resolved) {
      const liveRankById = new Map<number, number>();
      topParticipants.forEach((row, index) => {
        liveRankById.set(row.id, index + 1);
      });

      if (myProgress) {
        const myRank = await computeLiveParticipantRank(
          liveEventId,
          myProgress.score,
        );
        liveRankById.set(myProgress.id, myRank);
        myProgress = { ...myProgress, rank: myRank };
      }

      participants = participants.map((row) => ({
        ...row,
        rank: liveRankById.get(row.id) ?? row.rank,
      }));
    }

    participants = participants
      .map(mapEventParticipantRow)
      .sort((a, b) => {
        const rankA = a.rank ?? Number.MAX_SAFE_INTEGER;
        const rankB = b.rank ?? Number.MAX_SAFE_INTEGER;
        if (rankA !== rankB) return rankA - rankB;
        return b.score - a.score;
      });

    if (myProgress) {
      myProgress = mapEventParticipantRow(myProgress);
    }

    return {
      ...event,
      participants,
      myProgress,
    };
  }

  async getActiveModifiers(targetSystem?: string) {
    return prisma.gameLiveEventModifier.findMany({
      where: {
        ...(targetSystem ? { targetSystem } : {}),
        liveEvent: {
          status: 'active',
        },
      },
      include: {
        liveEvent: {
          include: {
            template: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async recordContribution(playerId: number, category: string, amount: number = 1) {
    const now = new Date();
    try {
      const activeBoosts = await getActiveEventBoostEffects(playerId);
      const boostedAmount =
        activeBoosts.eventContributionPct > 0
          ? Math.max(1, Math.round(amount * (1 + activeBoosts.eventContributionPct)))
          : amount;

      const activeEvents = await prisma.gameLiveEvent.findMany({
        where: {
          status: 'active',
          template: {
            OR: [{ category }, { category: 'allround' }],
          },
          AND: [
            { OR: [{ startedAt: null }, { startedAt: { lte: now } }] },
            { OR: [{ endsAt: null }, { endsAt: { gt: now } }] },
          ],
        },
        select: { id: true },
      });

      if (!activeEvents.length) return;

      await Promise.all(
        activeEvents.map((event) =>
          prisma.gameEventParticipantProgress.upsert({
            where: {
              liveEventId_subjectType_subjectKey: {
                liveEventId: event.id,
                subjectType: 'player',
                subjectKey: String(playerId),
              },
            },
            create: {
              liveEventId: event.id,
              playerId,
              subjectType: 'player',
              subjectKey: String(playerId),
              score: boostedAmount,
              lastContributionAt: now,
            },
            update: {
              score: { increment: boostedAmount },
              lastContributionAt: now,
            },
          }),
        ),
      );
    } catch (err) {
      console.error('[GameEventService] recordContribution error:', err);
    }
  }

  async resolveExpiredEvents() {
    const now = new Date();
    try {
      const expired = await prisma.gameLiveEvent.findMany({
        where: { status: 'active', endsAt: { lt: now } },
        select: { id: true },
      });
      for (const event of expired) {
        await this._resolveEvent(event.id);
      }
    } catch (err) {
      console.error('[GameEventService] resolveExpiredEvents error:', err);
    }
  }

  private async _resolveEvent(liveEventId: number) {
    const participants = await prisma.gameEventParticipantProgress.findMany({
      where: { liveEventId },
      orderBy: { score: 'desc' },
    });

    if (participants.length > 0) {
      await Promise.all(
        participants.map((p, i) =>
          prisma.gameEventParticipantProgress.update({
            where: { id: p.id },
            data: { rank: i + 1 },
          }),
        ),
      );

      const rewardRules = await prisma.gameEventRewardRule.findMany({
        where: { liveEventId, isActive: true },
        orderBy: { sortOrder: 'asc' },
      });

      for (const rule of rewardRules) {
        const triggerConfig = parseJsonRecord(rule.triggerConfigJson);
        const minRank = typeof triggerConfig.minRank === 'number' ? triggerConfig.minRank : 1;
        const maxRank = typeof triggerConfig.maxRank === 'number' ? triggerConfig.maxRank : 3;
        const qualifiers = participants.filter((_, i) => i + 1 >= minRank && i + 1 <= maxRank);

        await Promise.all(
          qualifiers
            .filter((p) => p.playerId != null)
            .map((p) =>
              prisma.gameEventRewardClaim.create({
                data: {
                  liveEventId,
                  rewardRuleId: rule.id,
                  playerId: p.playerId!,
                  grantedRewardsJson: rule.rewardsJson,
                  deliveryStatus: 'pending',
                },
              }),
            ),
        );
      }
    }

    await prisma.gameLiveEvent.update({
      where: { id: liveEventId },
      data: { status: 'completed', resolvedAt: new Date() },
    });

    await worldEventService.createEvent('game_event.live.resolved', { liveEventId });

    const forNotify = await prisma.gameLiveEvent.findUnique({
      where: { id: liveEventId },
      include: { template: true },
    });
    if (forNotify?.template) {
      setImmediate(() => {
        void gameEventNotificationService
          .onLiveEventCompleted(forNotify as GameLiveEventWithTemplate)
          .catch((e) => console.error('[GameEventNotification] complete', e));
      });
    }

    console.log(`[GameEventService] Resolved event ${liveEventId} with ${participants.length} participants`);
  }

  /**
   * Pays out pending event reward claims (cash, XP, premium credits, event items,
   * and extended grants: ammo / tools / parts / weapons / vehicles).
   */
  async processPendingRewardDeliveries(batchSize = 50): Promise<void> {
    const pending = await prisma.gameEventRewardClaim.findMany({
      where: { deliveryStatus: 'pending' },
      take: batchSize,
      orderBy: { id: 'asc' },
    });

    for (const claim of pending) {
      try {
        const granted = (claim.grantedRewardsJson
          ? JSON.parse(claim.grantedRewardsJson)
          : {}) as Record<string, unknown>;

        const cash = toFiniteInt(granted.cash, 0);
        const xp = toFiniteInt(granted.xp, 0);
        const premiumCredits = toFiniteInt(granted.premiumCredits, 0);
        const itemGrants = parseEventItemGrants(granted);
        const extended = parseExtendedEventRewards(granted);

        if (
          cash <= 0 &&
          xp <= 0 &&
          premiumCredits <= 0 &&
          itemGrants.length === 0 &&
          !hasExtendedEventRewards(extended)
        ) {
          await prisma.gameEventRewardClaim.update({
            where: { id: claim.id },
            data: { deliveryStatus: 'completed', claimedAt: new Date() },
          });
          continue;
        }

        await prisma.$transaction(async (tx) => {
          if (cash > 0) {
            await tx.player.update({
              where: { id: claim.playerId },
              data: { money: { increment: cash } },
            });
          }
          if (xp > 0) {
            await tx.player.update({
              where: { id: claim.playerId },
              data: { xp: { increment: xp } },
            });
          }
          if (premiumCredits > 0) {
            await grantPurchasedCredits(
              tx,
              claim.playerId,
              premiumCredits,
              `event_reward_${claim.liveEventId}`
            );
          }
          for (const grant of itemGrants) {
            await creditEventItem(
              tx,
              claim.playerId,
              grant.itemKey,
              grant.quantity,
              claim.liveEventId,
            );
          }
          await fulfillExtendedEventRewards(tx, claim.playerId, granted);
          await tx.gameEventRewardClaim.update({
            where: { id: claim.id },
            data: { deliveryStatus: 'completed', claimedAt: new Date() },
          });
        });
      } catch (e) {
        console.error(
          `[GameEventService] Failed to deliver claim ${claim.id} for player ${claim.playerId}:`,
          e
        );
      }
    }
  }
}

function toFiniteInt(v: unknown, defaultValue: number): number {
  const n = Number(v);
  return Number.isFinite(n) ? Math.max(0, Math.floor(n)) : defaultValue;
}

export const gameEventService = new GameEventService();
