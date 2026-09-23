import type { GameEventTemplate, GameLiveEvent } from '@prisma/client';
import { normalizePlayerLanguage, type SupportedPlayerLanguage } from '../config/supportedLanguages';
import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import {
  formatEventRewardSummary,
  rewardHeading,
} from './gameEventRewardSummary';
import { notificationService } from './notificationService';
import { playerNotificationPreferenceService } from './playerNotificationPreferenceService';

type LiveWithTemplate = GameLiveEvent & { template: GameEventTemplate };

export type GameEventWinnerNotice = {
  playerId: number;
  rank: number;
  /** One or more rewardsJson blobs granted to this player for this live event. */
  rewards: unknown[];
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

function payoutFallback(lang: SupportedPlayerLanguage): string {
  const map: Record<SupportedPlayerLanguage, string> = {
    nl: 'Je beloning wordt uitbetaald.',
    en: 'Your reward is being paid out.',
    de: 'Deine Belohnung wird ausgezahlt.',
    fr: 'Ta récompense est en cours de versement.',
    es: 'Tu recompensa se está pagando.',
    it: 'Il premio è in pagamento.',
    pl: 'Nagroda jest wypłacana.',
    pt: 'A recompensa está a ser paga.',
  };
  return map[lang];
}

function checkEventsHint(lang: SupportedPlayerLanguage): string {
  const map: Record<SupportedPlayerLanguage, string> = {
    nl: 'Kijk bij Events als je iets mist.',
    en: 'Check Events if anything is missing.',
    de: 'Prüfe Events, falls etwas fehlt.',
    fr: 'Vérifie Événements si quelque chose manque.',
    es: 'Revisa Eventos si falta algo.',
    it: 'Controlla Eventi se manca qualcosa.',
    pl: 'Sprawdź Eventy, jeśli czegoś brakuje.',
    pt: 'Vê Eventos se faltar alguma coisa.',
  };
  return map[lang];
}

function withRewardOrPayout(
  lang: SupportedPlayerLanguage,
  lead: string,
  rewardSummary: string,
): string {
  if (rewardSummary) {
    return `${lead} ${rewardHeading(lang)}: ${rewardSummary}.`;
  }
  return `${lead} ${payoutFallback(lang)}`;
}

function winnerCopy(input: {
  lang: SupportedPlayerLanguage;
  title: string;
  rank: number;
  hideRank: boolean;
  rewardSummary: string;
}): { title: string; body: string; inbox: string } {
  const { lang, title, rank, hideRank, rewardSummary } = input;
  const rewardClause = rewardSummary
    ? `${rewardHeading(lang)}: ${rewardSummary}.`
    : payoutFallback(lang);
  const hint = checkEventsHint(lang);

  if (hideRank) {
    const leadByLang: Record<SupportedPlayerLanguage, string> = {
      nl: `Je hebt een prijs verdiend in ${title}.`,
      en: `You earned a prize in ${title}.`,
      de: `Du hast in ${title} einen Preis verdient.`,
      fr: `Tu as gagné un prix dans ${title}.`,
      es: `Has ganado un premio en ${title}.`,
      it: `Hai vinto un premio in ${title}.`,
      pl: `Zdobyłeś nagrodę w ${title}.`,
      pt: `Ganhaste um prémio em ${title}.`,
    };
    const titles: Record<SupportedPlayerLanguage, string> = {
      nl: 'Eventprijs verdiend',
      en: 'Event prize earned',
      de: 'Event-Preis verdient',
      fr: 'Prix d’événement gagné',
      es: 'Premio de evento',
      it: 'Premio evento',
      pl: 'Nagroda za event',
      pt: 'Prémio de evento',
    };
    const lead = leadByLang[lang];
    return {
      title: titles[lang],
      body: withRewardOrPayout(lang, lead, rewardSummary),
      inbox: `${lead} ${rewardClause} ${hint}`,
    };
  }

  const place = ordinal(lang, rank);
  const won = rank === 1;
  if (won) {
    const leadByLang: Record<SupportedPlayerLanguage, string> = {
      nl: `Je hebt ${title} gewonnen.`,
      en: `You won ${title}.`,
      de: `Du hast ${title} gewonnen.`,
      fr: `Tu as gagné ${title}.`,
      es: `Has ganado ${title}.`,
      it: `Hai vinto ${title}.`,
      pl: `Wygrałeś ${title}.`,
      pt: `Ganhaste ${title}.`,
    };
    const inboxLeadByLang: Record<SupportedPlayerLanguage, string> = {
      nl: `Je hebt ${title} gewonnen (${place} plek).`,
      en: `You won ${title} (${place} place).`,
      de: `Du hast ${title} gewonnen (${place} Platz).`,
      fr: `Tu as gagné ${title} (${place} place).`,
      es: `Has ganado ${title} (${place} puesto).`,
      it: `Hai vinto ${title} (${place} posto).`,
      pl: `Wygrałeś ${title} (${place} miejsce).`,
      pt: `Ganhaste ${title} (${place} lugar).`,
    };
    const titles: Record<SupportedPlayerLanguage, string> = {
      nl: 'Event gewonnen',
      en: 'Event won',
      de: 'Event gewonnen',
      fr: 'Événement gagné',
      es: 'Evento ganado',
      it: 'Evento vinto',
      pl: 'Event wygrany',
      pt: 'Evento ganho',
    };
    return {
      title: titles[lang],
      body: withRewardOrPayout(lang, leadByLang[lang], rewardSummary),
      inbox: `${inboxLeadByLang[lang]} ${rewardClause} ${hint}`,
    };
  }

  const leadByLang: Record<SupportedPlayerLanguage, string> = {
    nl: `Je werd ${place} in ${title}.`,
    en: `You placed ${place} in ${title}.`,
    de: `Du wurdest ${place} in ${title}.`,
    fr: `Tu as terminé ${place} dans ${title}.`,
    es: `Quedaste ${place} en ${title}.`,
    it: `Sei arrivato ${place} in ${title}.`,
    pl: `Zająłeś ${place} miejsce w ${title}.`,
    pt: `Ficaste ${place} em ${title}.`,
  };

  const titles: Record<SupportedPlayerLanguage, string> = {
    nl: 'Eventprijs verdiend',
    en: 'Event prize earned',
    de: 'Event-Preis verdient',
    fr: 'Prix d’événement',
    es: 'Premio de evento',
    it: 'Premio evento',
    pl: 'Nagroda za event',
    pt: 'Prémio de evento',
  };
  return {
    title: titles[lang],
    body: withRewardOrPayout(lang, leadByLang[lang], rewardSummary),
    inbox: `${leadByLang[lang]} ${rewardClause} ${hint}`,
  };
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
      const rewardSummary = formatEventRewardSummary(lang, winner.rewards ?? []);
      const copy = winnerCopy({
        lang,
        title,
        rank: winner.rank,
        hideRank,
        rewardSummary,
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
