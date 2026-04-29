import type { GameEventTemplate, GameLiveEvent } from '@prisma/client';
import { notificationService } from './notificationService';

type LiveWithTemplate = GameLiveEvent & { template: GameEventTemplate };

/**
 * Fire-and-forget from gameEventService: push when a live player event starts or completes.
 * Uses batched FCM; players without devices are skipped per sendToPlayer.
 */
export const gameEventNotificationService = {
  async onLiveEventStarted(live: LiveWithTemplate): Promise<void> {
    if (live.status !== 'active' || !live.template) {
      return;
    }
    const t = live.template;
    await notificationService.broadcastLocalizedGameEventPushes({
      titleNl: 'Live event gestart',
      titleEn: 'Live event started',
      titleEs: 'Evento en vivo iniciado',
      bodyNl: `${t.titleNl} — doe mee via Events.`,
      bodyEn: `${t.titleEn} — join via Events.`,
      bodyEs: `${t.titleEn} — únete en Eventos.`,
      data: {
        type: 'game_event_started',
        liveEventId: String(live.id),
        templateKey: t.key,
      },
    });
  },

  async onLiveEventCompleted(live: LiveWithTemplate): Promise<void> {
    if (!live.template) {
      return;
    }
    const t = live.template;
    await notificationService.broadcastLocalizedGameEventPushes({
      titleNl: 'Live event afgerond',
      titleEn: 'Live event completed',
      titleEs: 'Evento en vivo finalizado',
      bodyNl: `${t.titleNl} is beëindigd. Controleer je beloningen in Events.`,
      bodyEn: `${t.titleEn} has ended. Check your rewards in Events.`,
      bodyEs: `${t.titleEn} ha terminado. Revisa tus recompensas en Eventos.`,
      data: {
        type: 'game_event_completed',
        liveEventId: String(live.id),
        templateKey: t.key,
      },
    });
  },
};
