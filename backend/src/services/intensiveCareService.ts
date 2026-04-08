import prisma from '../lib/prisma';

export const intensiveCareService = {
  /**
   * Check if player needs to be sent to intensive care (HP reached 0)
   * Returns minutes remaining in ICU or 0 if not in ICU
   */
  async checkAndApplyICU(playerId: number, currentHealth: number): Promise<number> {
    // If health just reached 0, send to ICU for 180 minutes
    if (currentHealth === 0) {
      const icuReleaseTime = new Date(Date.now() + 180 * 60 * 1000); // 180 minutes from now
      
      await prisma.player.update({
        where: { id: playerId },
        data: {
          intensiveCareUntil: icuReleaseTime,
          health: 0, // Ensure health stays at 0
        },
      });

      return 180; // 180 minutes in ICU
    }

    return 0;
  },

  /**
   * Check ICU status for a player
   * Returns minutes remaining in ICU or 0 if not in ICU
   */
  async checkICUStatus(playerId: number): Promise<number> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { intensiveCareUntil: true },
    });

    if (!player || !player.intensiveCareUntil) {
      return 0;
    }

    const now = new Date();
    const icuRelease = new Date(player.intensiveCareUntil);

    if (now >= icuRelease) {
      // ICU time is over, release player and restore to 10 HP
      await prisma.player.update({
        where: { id: playerId },
        data: {
          intensiveCareUntil: null,
          health: 10, // Start with 10 HP after ICU
        },
      });
      return 0;
    }

    // Calculate remaining seconds
    const remainingMs = icuRelease.getTime() - now.getTime();
    return Math.floor(remainingMs / 1000);
  },

  /**
   * Get ICU status for a player (used by frontend)
   */
  async getICUStatus(playerId: number): Promise<{
    inICU: boolean;
    remainingSeconds: number;
    releaseTime?: string;
  }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { intensiveCareUntil: true, health: true },
    });

    if (!player || !player.intensiveCareUntil) {
      return { inICU: false, remainingSeconds: 0 };
    }

    const now = new Date();
    const icuRelease = new Date(player.intensiveCareUntil);

    if (now >= icuRelease) {
      // Auto-release
      await prisma.player.update({
        where: { id: playerId },
        data: {
          intensiveCareUntil: null,
          health: 10,
        },
      });
      return { inICU: false, remainingSeconds: 0 };
    }

    const remainingMs = icuRelease.getTime() - now.getTime();
    const remainingSeconds = Math.floor(remainingMs / 1000);

    return {
      inICU: true,
      remainingSeconds,
      releaseTime: icuRelease.toISOString(),
    };
  },
};
