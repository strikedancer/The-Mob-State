import { Prisma } from '@prisma/client';
import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';

type JsonRecord = Record<string, unknown>;

const toJson = (value: unknown): Prisma.InputJsonValue | undefined => {
  if (value === undefined) {
    return undefined;
  }

  return value as Prisma.InputJsonValue;
};

const liveEventInclude = {
  template: true,
  modifiers: true,
  rewardRules: {
    orderBy: {
      sortOrder: 'asc' as const,
    },
  },
} satisfies Prisma.GameLiveEventInclude;

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
        configSchemaJson: toJson(input.configSchemaJson),
        uiSchemaJson: toJson(input.uiSchemaJson),
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
          input.configSchemaJson === undefined ? undefined : toJson(input.configSchemaJson),
        uiSchemaJson:
          input.uiSchemaJson === undefined ? undefined : toJson(input.uiSchemaJson),
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
        configJson: toJson(input.configJson),
        stateJson: toJson(input.stateJson),
        announcementJson: toJson(input.announcementJson),
        scopeJson: toJson(input.scopeJson),
        createdByAdminId: input.createdByAdminId,
        modifiers: input.modifiers?.length
          ? {
              create: input.modifiers.map((modifier) => ({
                targetSystem: modifier.targetSystem,
                modifierKey: modifier.modifierKey,
                operation: modifier.operation,
                valueJson: toJson(modifier.valueJson),
                conditionsJson: toJson(modifier.conditionsJson),
              })),
            }
          : undefined,
        rewardRules: input.rewardRules?.length
          ? {
              create: input.rewardRules.map((rule, index) => ({
                triggerType: rule.triggerType,
                triggerConfigJson: toJson(rule.triggerConfigJson),
                rewardsJson: rule.rewardsJson as Prisma.InputJsonValue,
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
        configJson: input.configJson === undefined ? undefined : toJson(input.configJson),
        stateJson: input.stateJson === undefined ? undefined : toJson(input.stateJson),
        announcementJson:
          input.announcementJson === undefined ? undefined : toJson(input.announcementJson),
        scopeJson: input.scopeJson === undefined ? undefined : toJson(input.scopeJson),
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
    const myProgress = playerId && liveEventIds.length > 0
      ? await prisma.gameEventParticipantProgress.findMany({
          where: {
            playerId,
            liveEventId: { in: liveEventIds },
          },
        })
      : [];

    return {
      serverTime: now,
      featured,
      active,
      upcoming,
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
        participants: {
          where: playerId ? { OR: [{ playerId }, { rank: { lte: 10 } }] } : { rank: { lte: 10 } },
          orderBy: [
            { rank: 'asc' },
            { score: 'desc' },
          ],
          take: 25,
          include: {
            player: {
              select: {
                id: true,
                username: true,
                rank: true,
              },
            },
          },
        },
      },
    });

    if (!event) {
      return null;
    }

    const myProgress = playerId
      ? await prisma.gameEventParticipantProgress.findFirst({
          where: {
            liveEventId,
            playerId,
          },
        })
      : null;

    return {
      ...event,
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
      const activeEvents = await prisma.gameLiveEvent.findMany({
        where: {
          status: 'active',
          template: { category },
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
              score: amount,
              lastContributionAt: now,
            },
            update: {
              score: { increment: amount },
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
        const triggerConfig = (rule.triggerConfigJson as Record<string, unknown>) ?? {};
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
                  grantedRewardsJson: rule.rewardsJson as Prisma.InputJsonValue,
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
    console.log(`[GameEventService] Resolved event ${liveEventId} with ${participants.length} participants`);
  }
}

export const gameEventService = new GameEventService();
