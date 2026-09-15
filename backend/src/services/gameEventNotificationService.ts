import type { GameEventTemplate, GameLiveEvent } from '@prisma/client';
import { normalizePlayerLanguage, type SupportedPlayerLanguage } from '../config/supportedLanguages';
import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { notificationService } from './notificationService';
import { playerNotificationPreferenceService } from './playerNotificationPreferenceService';

type LiveWithTemplate = GameLiveEvent & { template: GameEventTemplate };

export type GameEventWinnerNotice = {
  playerId: number;
  rank: number;
};

function eventTitle(lang: SupportedPlayerLanguage, titleNl: string, titleEn: string): string {
  return lang === 'nl' ? titleNl : titleEn;
}

function ordinal(lang: SupportedPlayerLanguage, rank: number): string {
  if (lang === 'nl') return `${rank}e`;
  if (lang === 'fr') return `${rank}e`;
  if (lang === 'de') return `${rank}.`;
  if (lang === 'es' || lang === 'it' || lang === 'pt') return `${rank}.º`;
  if (lang === 'pl') return `${rank}.`;
  const mod100 = rank % 100;
  const mod10 = rank % 10;
  if (mod100 !== 11 && mod10 === 1) return `${rank}st`;
  if (mod100 !== 12 && mod10 === 2) return `${rank}nd`;
  if (mod100 !== 13 && mod10 === 3) return `${rank}rd`;
  return `${rank}th`;
}

function winnerCopy(input: {
  lang: SupportedPlayerLanguage;
  title: string;
  rank: number;
  hideRank: boolean;
}): { title: string; body: string; inbox: string } {
  const { lang, title, rank, hideRank } = input;
  if (hideRank) {
    const map: Record<SupportedPlayerLanguage, { title: string; body: string; inbox: string }> = {
      nl: {
        title: 'Eventprijs verdiend',
        body: `Je hebt een prijs verdiend in ${title}. Je beloning wordt uitbetaald.`,
        inbox: `Je hebt een prijs verdiend in ${title}. Je beloning wordt uitbetaald. Kijk bij Events als je iets mist.`,
      },
      en: {
        title: 'Event prize earned',
        body: `You earned a prize in ${title}. Your reward is being paid out.`,
        inbox: `You earned a prize in ${title}. Your reward is being paid out. Check Events if anything is missing.`,
      },
      de: {
        title: 'Event-Preis verdient',
        body: `Du hast in ${title} einen Preis verdient. Deine Belohnung wird ausgezahlt.`,
        inbox: `Du hast in ${title} einen Preis verdient. Deine Belohnung wird ausgezahlt. Prüfe Events, falls etwas fehlt.`,
      },
      fr: {
        title: 'Prix d’événement gagné',
        body: `Tu as gagné un prix dans ${title}. Ta récompense est en cours de versement.`,
        inbox: `Tu as gagné un prix dans ${title}. Ta récompense est en cours de versement. Vérifie Événements si quelque chose manque.`,
      },
      es: {
        title: 'Premio de evento',
        body: `Has ganado un premio en ${title}. Tu recompensa se está pagando.`,
        inbox: `Has ganado un premio en ${title}. Tu recompensa se está pagando. Revisa Eventos si falta algo.`,
      },
      it: {
        title: 'Premio evento',
        body: `Hai vinto un premio in ${title}. Il premio è in pagamento.`,
        inbox: `Hai vinto un premio in ${title}. Il premio è in pagamento. Controlla Eventi se manca qualcosa.`,
      },
      pl: {
        title: 'Nagroda za event',
        body: `Zdobyłeś nagrodę w ${title}. Nagroda jest wypłacana.`,
        inbox: `Zdobyłeś nagrodę w ${title}. Nagroda jest wypłacana. Sprawdź Eventy, jeśli czegoś brakuje.`,
      },
      pt: {
        title: 'Prémio de evento',
        body: `Ganhaste um prémio em ${title}. A recompensa está a ser paga.`,
        inbox: `Ganhaste um prémio em ${title}. A recompensa está a ser paga. Vê Eventos se faltar alguma coisa.`,
      },
    };
    return map[lang];
  }

  const place = ordinal(lang, rank);
  const won = rank === 1;
  if (won) {
    const map: Record<SupportedPlayerLanguage, { title: string; body: string; inbox: string }> = {
      nl: {
        title: 'Event gewonnen',
        body: `Je hebt ${title} gewonnen. Je beloning wordt uitbetaald.`,
        inbox: `Je hebt ${title} gewonnen (${place} plek). Je beloning wordt uitbetaald. Kijk bij Events als je iets mist.`,
      },
      en: {
        title: 'Event won',
        body: `You won ${title}. Your reward is being paid out.`,
        inbox: `You won ${title} (${place} place). Your reward is being paid out. Check Events if anything is missing.`,
      },
      de: {
        title: 'Event gewonnen',
        body: `Du hast ${title} gewonnen. Deine Belohnung wird ausgezahlt.`,
        inbox: `Du hast ${title} gewonnen (${place} Platz). Deine Belohnung wird ausgezahlt. Prüfe Events, falls etwas fehlt.`,
      },
      fr: {
        title: 'Événement gagné',
        body: `Tu as gagné ${title}. Ta récompense est en cours de versement.`,
        inbox: `Tu as gagné ${title} (${place} place). Ta récompense est en cours de versement. Vérifie Événements si quelque chose manque.`,
      },
      es: {
        title: 'Evento ganado',
        body: `Has ganado ${title}. Tu recompensa se está pagando.`,
        inbox: `Has ganado ${title} (${place} puesto). Tu recompensa se está pagando. Revisa Eventos si falta algo.`,
      },
      it: {
        title: 'Evento vinto',
        body: `Hai vinto ${title}. Il premio è in pagamento.`,
        inbox: `Hai vinto ${title} (${place} posto). Il premio è in pagamento. Controlla Eventi se manca qualcosa.`,
      },
      pl: {
        title: 'Event wygrany',
        body: `Wygrałeś ${title}. Nagroda jest wypłacana.`,
        inbox: `Wygrałeś ${title} (${place} miejsce). Nagroda jest wypłacana. Sprawdź Eventy, jeśli czegoś brakuje.`,
      },
      pt: {
        title: 'Evento ganho',
        body: `Ganhaste ${title}. A recompensa está a ser paga.`,
        inbox: `Ganhaste ${title} (${place} lugar). A recompensa está a ser paga. Vê Eventos se faltar alguma coisa.`,
      },
    };
    return map[lang];
  }

  const map: Record<SupportedPlayerLanguage, { title: string; body: string; inbox: string }> = {
    nl: {
      title: 'Eventprijs verdiend',
      body: `Je werd ${place} in ${title}. Je beloning wordt uitbetaald.`,
      inbox: `Je werd ${place} in ${title}. Je beloning wordt uitbetaald. Kijk bij Events als je iets mist.`,
    },
    en: {
      title: 'Event prize earned',
      body: `You placed ${place} in ${title}. Your reward is being paid out.`,
      inbox: `You placed ${place} in ${title}. Your reward is being paid out. Check Events if anything is missing.`,
    },
    de: {
      title: 'Event-Preis verdient',
      body: `Du wurdest ${place} in ${title}. Deine Belohnung wird ausgezahlt.`,
      inbox: `Du wurdest ${place} in ${title}. Deine Belohnung wird ausgezahlt. Prüfe Events, falls etwas fehlt.`,
    },
    fr: {
      title: 'Prix d’événement',
      body: `Tu as terminé ${place} dans ${title}. Ta récompense est en cours de versement.`,
      inbox: `Tu as terminé ${place} dans ${title}. Ta récompense est en cours de versement. Vérifie Événements si quelque chose manque.`,
    },
    es: {
      title: 'Premio de evento',
      body: `Quedaste ${place} en ${title}. Tu recompensa se está pagando.`,
      inbox: `Quedaste ${place} en ${title}. Tu recompensa se está pagando. Revisa Eventos si falta algo.`,
    },
    it: {
      title: 'Premio evento',
      body: `Sei arrivato ${place} in ${title}. Il premio è in pagamento.`,
      inbox: `Sei arrivato ${place} in ${title}. Il premio è in pagamento. Controlla Eventi se manca qualcosa.`,
    },
    pl: {
      title: 'Nagroda za event',
      body: `Zająłeś ${place} miejsce w ${title}. Nagroda jest wypłacana.`,
      inbox: `Zająłeś ${place} miejsce w ${title}. Nagroda jest wypłacana. Sprawdź Eventy, jeśli czegoś brakuje.`,
    },
    pt: {
      title: 'Prémio de evento',
      body: `Ficaste ${place} em ${title}. A recompensa está a ser paga.`,
      inbox: `Ficaste ${place} em ${title}. A recompensa está a ser paga. Vê Eventos se faltar alguma coisa.`,
    },
  };
  return map[lang];
}

/**
 * Fire-and-forget from gameEventService: push when a live player event starts or completes,
 * plus personal inbox + push for players who placed for a prize.
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

  async notifyWinners(input: {
    live: LiveWithTemplate;
    winners: GameEventWinnerNotice[];
    hideRank: boolean;
  }): Promise<void> {
    const { live, winners, hideRank } = input;
    if (!live.template || winners.length === 0) {
      return;
    }

    const players = await prisma.player.findMany({
      where: { id: { in: winners.map((winner) => winner.playerId) } },
      select: { id: true, preferredLanguage: true },
    });
    const langById = new Map(players.map((player) => [player.id, normalizePlayerLanguage(player.preferredLanguage)]));

    for (const winner of winners) {
      const lang = langById.get(winner.playerId) ?? 'en';
      const title = eventTitle(lang, live.template.titleNl, live.template.titleEn);
      const copy = winnerCopy({
        lang,
        title,
        rank: winner.rank,
        hideRank,
      });

      try {
        await directMessageService.sendSystemMessage(winner.playerId, copy.inbox, {
          sendPush: false,
        });
      } catch (error) {
        console.error('[GameEventNotification] winner inbox', winner.playerId, error);
      }

      try {
        const prefs = await playerNotificationPreferenceService.getPreferences(winner.playerId);
        if (!prefs.pushGameEvents) {
          continue;
        }
        await notificationService.sendToPlayer(winner.playerId, copy.title, copy.body, {
          type: winner.rank === 1 && !hideRank ? 'game_event_won' : 'game_event_placed',
          liveEventId: String(live.id),
          templateKey: live.template.key,
          rank: String(winner.rank),
        });
      } catch (error) {
        console.error('[GameEventNotification] winner push', winner.playerId, error);
      }
    }
  },
};
