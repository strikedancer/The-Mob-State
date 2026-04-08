import prisma from '../lib/prisma';
import { weaponService } from './weaponService';

const ACTIVITY_SELECT = 'CRIME_WEAPON_SELECTED';
const ACTIVITY_CLEAR = 'CRIME_WEAPON_CLEARED';

export const weaponSelectionService = {
  async getSelectedCrimeWeapon(playerId: number): Promise<{
    weaponId: string;
    name: string;
    condition: number;
  } | null> {
    const latestActivity = await prisma.playerActivity.findFirst({
      where: {
        playerId,
        activityType: {
          in: [ACTIVITY_SELECT, ACTIVITY_CLEAR],
        },
      },
      orderBy: { createdAt: 'desc' },
      select: {
        activityType: true,
        details: true,
      },
    });

    if (!latestActivity || latestActivity.activityType === ACTIVITY_CLEAR) {
      return null;
    }

    const details = latestActivity.details as Record<string, unknown>;
    const weaponId = typeof details?.weaponId === 'string' ? details.weaponId : null;

    if (!weaponId) return null;

    const weaponInventory = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
      select: {
        weaponId: true,
        condition: true,
      },
    });

    if (!weaponInventory || weaponInventory.condition <= 0) {
      return null;
    }

    const weaponDefinition = weaponService.getWeaponDefinition(weaponInventory.weaponId);

    return {
      weaponId: weaponInventory.weaponId,
      name: weaponDefinition?.name ?? weaponInventory.weaponId,
      condition: weaponInventory.condition,
    };
  },

  async setSelectedCrimeWeapon(playerId: number, weaponId: string): Promise<void> {
    const weaponInventory = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
      select: {
        weaponId: true,
        condition: true,
      },
    });

    if (!weaponInventory) {
      throw new Error('WEAPON_NOT_FOUND');
    }

    if (weaponInventory.condition <= 0) {
      throw new Error('WEAPON_BROKEN');
    }

    await prisma.playerActivity.create({
      data: {
        playerId,
        activityType: ACTIVITY_SELECT,
        description: `Selected crime weapon: ${weaponId}`,
        details: { weaponId },
        isPublic: false,
      },
    });
  },

  async clearSelectedCrimeWeapon(playerId: number): Promise<void> {
    await prisma.playerActivity.create({
      data: {
        playerId,
        activityType: ACTIVITY_CLEAR,
        description: 'Cleared selected crime weapon',
        details: {},
        isPublic: false,
      },
    });
  },
};
