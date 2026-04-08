import prisma from '../lib/prisma';
import { getWealthStatus, getWealthTitle, getWealthIcon } from '../utils/wealthSystem';

export const playerService = {
  /**
   * Get full player data by ID
   */
  async getPlayer(playerId: number) {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Import rank calculation functions
    const { getRankFromXP } = await import('../config');
    
    // Validate that rank matches XP - if not, recalculate and update
    const calculatedRank = getRankFromXP(player.xp);
    if (calculatedRank !== player.rank) {
      console.warn(
        `[PlayerService] Rank mismatch for player ${playerId}: stored rank ${player.rank} but XP ${player.xp} should be rank ${calculatedRank}. Correcting...`
      );
      
      // Update the rank in database
      await prisma.player.update({
        where: { id: playerId },
        data: { rank: calculatedRank },
      });
      
      // Return with corrected rank
      const wealthStatus = getWealthStatus(player.money);
      return {
        id: player.id,
        username: player.username,
        money: player.money,
        health: player.health,
        rank: calculatedRank,
        xp: player.xp,
        wantedLevel: player.wantedLevel,
        fbiHeat: player.fbiHeat,
        currentCountry: player.currentCountry,
        avatar: player.avatar,
        isVip: player.isVip,
        vipExpiresAt: player.vipExpiresAt,
        lastAvatarChange: player.lastAvatarChange,
        lastUsernameChange: player.lastUsernameChange,
        allowMessages: player.allowMessages,
        reputation: player.reputation,
        preferredLanguage: player.preferredLanguage,
        createdAt: player.createdAt,
        updatedAt: player.updatedAt,
        lastTickAt: player.lastTickAt,
        wealthStatus: wealthStatus.title,
        wealthIcon: wealthStatus.icon,
      };
    }

    const wealthStatus = getWealthStatus(player.money);
    return {
      id: player.id,
      username: player.username,
      money: player.money,
      health: player.health,
      rank: player.rank,
      xp: player.xp,
      wantedLevel: player.wantedLevel,
      fbiHeat: player.fbiHeat,
      currentCountry: player.currentCountry,
      avatar: player.avatar,
      isVip: player.isVip,
      vipExpiresAt: player.vipExpiresAt,
      lastAvatarChange: player.lastAvatarChange,
      lastUsernameChange: player.lastUsernameChange,
      allowMessages: player.allowMessages,
      reputation: player.reputation,
      preferredLanguage: player.preferredLanguage,
      createdAt: player.createdAt,
      updatedAt: player.updatedAt,
      lastTickAt: player.lastTickAt,
      wealthStatus: wealthStatus.title,
      wealthIcon: wealthStatus.icon,
    };
  },

  /**
   * Deduct XP from a player
   * Ensures XP never goes below 0
   */
  async loseXP(playerId: number, amount: number): Promise<{ newXP: number; xpLost: number }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { xp: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    const actualXpLost = Math.min(amount, player.xp);
    const newXP = Math.max(0, player.xp - amount);

    await prisma.player.update({
      where: { id: playerId },
      data: { xp: newXP },
    });

    return {
      newXP,
      xpLost: actualXpLost,
    };
  },
};
