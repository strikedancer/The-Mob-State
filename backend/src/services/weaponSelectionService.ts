import prisma from '../lib/prisma';
import { weaponService } from './weaponService';

type WeaponCarrySlot = 'crime' | 'secondary';

const SLOT_ACTIVITY: Record<WeaponCarrySlot, { select: string; clear: string }> = {
  crime: {
    select: 'CRIME_WEAPON_SELECTED',
    clear: 'CRIME_WEAPON_CLEARED',
  },
  secondary: {
    select: 'SECONDARY_WEAPON_SELECTED',
    clear: 'SECONDARY_WEAPON_CLEARED',
  },
};

const safeStringifyDetails = (value: unknown): string => {
  try {
    return JSON.stringify(value ?? {});
  } catch {
    return '{}';
  }
};

const safeParseDetails = (value: string | null | undefined): Record<string, unknown> => {
  if (!value) {
    return {};
  }

  try {
    const parsed = JSON.parse(value);
    return parsed && typeof parsed === 'object' && !Array.isArray(parsed)
      ? (parsed as Record<string, unknown>)
      : {};
  } catch {
    return {};
  }
};

const otherSlot = (slot: WeaponCarrySlot): WeaponCarrySlot =>
  slot === 'crime' ? 'secondary' : 'crime';

export type EquippedWeapon = {
  weaponId: string;
  name: string;
  condition: number;
  slot: WeaponCarrySlot;
};

export const weaponSelectionService = {
  async getSelectedCrimeWeapon(playerId: number) {
    return getSelectedSlot(playerId, 'crime');
  },

  async setSelectedCrimeWeapon(playerId: number, weaponId: string): Promise<void> {
    await setSelectedSlot(playerId, 'crime', weaponId);
  },

  async clearSelectedCrimeWeapon(playerId: number): Promise<void> {
    await clearSelectedSlot(playerId, 'crime');
  },

  async getSelectedSecondaryWeapon(playerId: number) {
    return getSelectedSlot(playerId, 'secondary');
  },

  async setSelectedSecondaryWeapon(playerId: number, weaponId: string): Promise<void> {
    await setSelectedSlot(playerId, 'secondary', weaponId);
  },

  async clearSelectedSecondaryWeapon(playerId: number): Promise<void> {
    await clearSelectedSlot(playerId, 'secondary');
  },

  async getEquippedWeapons(playerId: number): Promise<EquippedWeapon[]> {
    const [crime, secondary] = await Promise.all([
      getSelectedSlot(playerId, 'crime'),
      getSelectedSlot(playerId, 'secondary'),
    ]);
    const equipped: EquippedWeapon[] = [];
    if (crime) {
      equipped.push({ ...crime, slot: 'crime' });
    }
    if (secondary) {
      equipped.push({ ...secondary, slot: 'secondary' });
    }
    return equipped;
  },

  async getEquippedWeaponSlotCounts(playerId: number): Promise<Map<string, number>> {
    const equipped = await this.getEquippedWeapons(playerId);
    const counts = new Map<string, number>();
    for (const weapon of equipped) {
      counts.set(weapon.weaponId, (counts.get(weapon.weaponId) ?? 0) + 1);
    }
    return counts;
  },
};

async function getSelectedSlot(
  playerId: number,
  slot: WeaponCarrySlot,
): Promise<{
  weaponId: string;
  name: string;
  condition: number;
} | null> {
  const activity = SLOT_ACTIVITY[slot];
  const latestActivity = await prisma.playerActivity.findFirst({
    where: {
      playerId,
      activityType: {
        in: [activity.select, activity.clear],
      },
    },
    orderBy: { createdAt: 'desc' },
    select: {
      activityType: true,
      details: true,
    },
  });

  if (!latestActivity || latestActivity.activityType === activity.clear) {
    return null;
  }

  const details = safeParseDetails(latestActivity.details);
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
}

async function setSelectedSlot(
  playerId: number,
  slot: WeaponCarrySlot,
  weaponId: string,
): Promise<void> {
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

  const activity = SLOT_ACTIVITY[slot];
  await prisma.playerActivity.create({
    data: {
      playerId,
      activityType: activity.select,
      description:
        slot === 'crime'
          ? `Selected crime weapon: ${weaponId}`
          : `Selected secondary weapon: ${weaponId}`,
      details: safeStringifyDetails({ weaponId }),
      isPublic: false,
    },
  });

  const other = await getSelectedSlot(playerId, otherSlot(slot));
  if (other?.weaponId === weaponId) {
    await clearSelectedSlot(playerId, otherSlot(slot));
  }
}

async function clearSelectedSlot(playerId: number, slot: WeaponCarrySlot): Promise<void> {
  const activity = SLOT_ACTIVITY[slot];
  await prisma.playerActivity.create({
    data: {
      playerId,
      activityType: activity.clear,
      description:
        slot === 'crime' ? 'Cleared selected crime weapon' : 'Cleared selected secondary weapon',
      details: safeStringifyDetails({}),
      isPublic: false,
    },
  });
}
