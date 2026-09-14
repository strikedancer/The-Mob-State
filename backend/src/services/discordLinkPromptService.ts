import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';

export const DISCORD_LINK_BONUS_CASH = 5000;
const PROMPT_INTERVAL_MS = 7 * 24 * 60 * 60 * 1000;

function formatCash(amount: number, language: string): string {
  const abs = Math.abs(Math.trunc(amount)).toString();
  const grouped = abs.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  if ((language || 'en').toLowerCase().startsWith('nl')) {
    return `€${grouped}`;
  }
  return `€${grouped}`;
}

export const discordLinkPromptService = {
  async status(playerId: number): Promise<{ show: boolean; rewardCash: number }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        discordId: true,
        discordLinkPromptShownAt: true,
        discordLinkPromptDeclinedAt: true,
        discordLinkBonusPaidAt: true,
      },
    });
    if (
      !player ||
      player.discordId ||
      player.discordLinkPromptDeclinedAt ||
      player.discordLinkBonusPaidAt
    ) {
      return { show: false, rewardCash: DISCORD_LINK_BONUS_CASH };
    }
    const shownAt = player.discordLinkPromptShownAt?.getTime() ?? 0;
    if (shownAt && Date.now() - shownAt < PROMPT_INTERVAL_MS) {
      return { show: false, rewardCash: DISCORD_LINK_BONUS_CASH };
    }
    return { show: true, rewardCash: DISCORD_LINK_BONUS_CASH };
  },

  async markShown(playerId: number): Promise<void> {
    await prisma.player.update({
      where: { id: playerId },
      data: { discordLinkPromptShownAt: new Date() },
    });
  },

  async decline(playerId: number): Promise<void> {
    await prisma.player.update({
      where: { id: playerId },
      data: {
        discordLinkPromptDeclinedAt: new Date(),
        discordLinkPromptShownAt: new Date(),
      },
    });
  },

  async payLinkBonus(playerId: number): Promise<number> {
    const paid = await prisma.$transaction(async (tx) => {
      const claimed = await tx.player.updateMany({
        where: {
          id: playerId,
          discordId: { not: null },
          discordLinkBonusPaidAt: null,
        },
        data: { discordLinkBonusPaidAt: new Date() },
      });
      if (claimed.count === 0) return 0;
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: DISCORD_LINK_BONUS_CASH } },
      });
      return DISCORD_LINK_BONUS_CASH;
    });
    if (paid === 0) return 0;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { preferredLanguage: true },
    });
    const lang = player?.preferredLanguage || 'en';
    const cash = formatCash(DISCORD_LINK_BONUS_CASH, lang);
    const message = lang.toLowerCase().startsWith('nl')
      ? `Discord\nJe account is gekoppeld. ${cash} is bijgeschreven.`
      : `Discord\nYour account is linked. ${cash} has been added.`;
    try {
      await directMessageService.sendSystemMessage(playerId, message, { sendPush: true });
    } catch (error) {
      console.error('[DiscordLink] Failed to send bonus inbox', error);
    }
    return paid;
  },
};
