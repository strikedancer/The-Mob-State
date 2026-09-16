import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { notificationService } from './notificationService';
import { translationService, type Language } from './translationService';

async function playerLanguage(playerId: number): Promise<Language> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return translationService.getPlayerLanguage(player ?? {});
}

async function notifyRld(
  playerId: number,
  copy: { title: string; pushBody: string; inboxMessage: string },
  type: string,
  extra?: Record<string, string>
): Promise<void> {
  const lang = await playerLanguage(playerId);
  const sender = translationService.getTranslations(lang).common.rldSystemSender;
  await notificationService
    .sendToPlayer(playerId, copy.title, copy.pushBody, { type, ...extra })
    .catch(() => {});
  await directMessageService
    .sendSystemMessage(playerId, copy.inboxMessage, {
      sendPush: false,
      senderName: sender,
    })
    .catch(() => {});
}

export const rldNotify = {
  async stolen(ownerId: number, thiefName: string, workerName: string): Promise<void> {
    const lang = await playerLanguage(ownerId);
    const n = translationService.getTranslations(lang).notification.rldStolen;
    await notifyRld(
      ownerId,
      {
        title: n.title,
        pushBody: n.pushBody(thiefName, workerName),
        inboxMessage: n.inboxMessage(thiefName, workerName),
      },
      'rld_stolen',
      { thiefName, workerName }
    );
  },

  async reclaimed(thiefId: number, ownerName: string, workerName: string): Promise<void> {
    const lang = await playerLanguage(thiefId);
    const n = translationService.getTranslations(lang).notification.rldReclaimed;
    await notifyRld(
      thiefId,
      {
        title: n.title,
        pushBody: n.pushBody(ownerName, workerName),
        inboxMessage: n.inboxMessage(ownerName, workerName),
      },
      'rld_reclaimed',
      { ownerName, workerName }
    );
  },

  async contestPrep(ownerId: number, challengerName: string, country: string): Promise<void> {
    const lang = await playerLanguage(ownerId);
    const n = translationService.getTranslations(lang).notification.rldContestPrep;
    await notifyRld(
      ownerId,
      {
        title: n.title,
        pushBody: n.pushBody(challengerName, country),
        inboxMessage: n.inboxMessage(challengerName, country),
      },
      'rld_contest_prep',
      { challengerName, country }
    );
  },

  async contestActive(playerId: number, country: string): Promise<void> {
    const lang = await playerLanguage(playerId);
    const n = translationService.getTranslations(lang).notification.rldContestActive;
    await notifyRld(
      playerId,
      {
        title: n.title,
        pushBody: n.pushBody(country),
        inboxMessage: n.inboxMessage(country),
      },
      'rld_contest_active',
      { country }
    );
  },

  async contestWon(playerId: number, country: string): Promise<void> {
    const lang = await playerLanguage(playerId);
    const n = translationService.getTranslations(lang).notification.rldContestWon;
    await notifyRld(
      playerId,
      {
        title: n.title,
        pushBody: n.pushBody(country),
        inboxMessage: n.inboxMessage(country),
      },
      'rld_contest_won',
      { country }
    );
  },

  async contestLost(playerId: number, winnerName: string, country: string): Promise<void> {
    const lang = await playerLanguage(playerId);
    const n = translationService.getTranslations(lang).notification.rldContestLost;
    await notifyRld(
      playerId,
      {
        title: n.title,
        pushBody: n.pushBody(winnerName, country),
        inboxMessage: n.inboxMessage(winnerName, country),
      },
      'rld_contest_lost',
      { winnerName, country }
    );
  },
};
