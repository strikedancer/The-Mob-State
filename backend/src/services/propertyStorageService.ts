import prisma from '../lib/prisma';
import toolService from './toolService';

const PROPERTY_STORAGE_RULES: Record<string, Array<'tools' | 'drugs' | 'weapons' | 'cash'>> = {
  warehouse: ['tools'],
  nightclub: ['drugs'],
  house: ['weapons', 'cash'],
  apartment: ['weapons', 'cash'],
  mansion: ['weapons', 'cash'],
  penthouse: ['weapons', 'cash'],
  safehouse: ['weapons', 'cash'],
};

const CASH_SLOT_VALUE = 10000;

class PropertyStorageService {
  getAllowedCategories(propertyType: string): Array<'tools' | 'drugs' | 'weapons' | 'cash'> {
    return PROPERTY_STORAGE_RULES[propertyType] ?? [];
  }

  private async getPlayerAndProperty(playerId: number, propertyId: number) {
    const [player, property] = await Promise.all([
      prisma.player.findUnique({ where: { id: playerId }, select: { currentCountry: true } }),
      prisma.property.findFirst({ where: { id: propertyId, playerId } }),
    ]);

    if (!player || !property) {
      throw new Error('PROPERTY_NOT_FOUND');
    }

    return { player, property };
  }

  private ensureCountryAccess(playerCountry: string, propertyCountry: string) {
    if (playerCountry !== propertyCountry) {
      throw new Error('WRONG_COUNTRY');
    }
  }

  private async getCapacity(propertyType: string): Promise<number> {
    const configured = await prisma.propertyStorageCapacity.findUnique({
      where: { propertyType },
      select: { maxSlots: true },
    });
    return configured?.maxSlots ?? 20;
  }

  private async getWeaponStorage(propertyId: number) {
    const rows = await prisma.propertyDrugStorage.findMany({
      where: {
        propertyId,
        drugType: { startsWith: 'weapon:' },
      },
      orderBy: { drugType: 'asc' },
    });

    return rows.map((row) => ({
      weaponId: row.drugType.replace('weapon:', ''),
      quantity: row.quantity,
    }));
  }

  private async getCashStorage(propertyId: number): Promise<number> {
    const row = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: '__cash__',
        },
      },
      select: { quantity: true },
    });

    return row?.quantity ?? 0;
  }

  async getPropertyStorageOverview(playerId: number) {
    const properties = await prisma.property.findMany({
      where: { playerId },
      orderBy: { purchasedAt: 'desc' },
    });

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    const overview = [] as any[];

    for (const property of properties) {
      const allowedCategories = this.getAllowedCategories(property.propertyType);
      const capacity = await this.getCapacity(property.propertyType);

      let toolCount = 0;
      let tools: any[] = [];
      let drugCount = 0;
      let weaponCount = 0;
      let cashAmount = 0;
      let usage = 0;

      if (allowedCategories.includes('tools')) {
        tools = await toolService.getPropertyStorage(playerId, property.id);
        toolCount = tools.length;
        usage += await toolService.getPropertyStorageUsage(playerId, property.id);
      }

      if (allowedCategories.includes('drugs')) {
        const drugs = await prisma.propertyDrugStorage.findMany({
          where: {
            propertyId: property.id,
            NOT: [{ drugType: { startsWith: 'weapon:' } }, { drugType: '__cash__' }],
          },
          select: { quantity: true },
        });
        drugCount = drugs.reduce((sum, row) => sum + row.quantity, 0);
        usage += drugCount;
      }

      if (allowedCategories.includes('weapons')) {
        const weapons = await this.getWeaponStorage(property.id);
        weaponCount = weapons.reduce((sum, row) => sum + row.quantity, 0);
        usage += weaponCount;
      }

      if (allowedCategories.includes('cash')) {
        cashAmount = await this.getCashStorage(property.id);
        usage += Math.ceil(cashAmount / CASH_SLOT_VALUE);
      }

      const accessibleInCurrentCountry = player?.currentCountry === property.countryId;

      overview.push({
        propertyId: property.id,
        propertyType: property.propertyType,
        propertyCountry: property.countryId,
        allowedCategories,
        usage,
        capacity,
        percentFull: capacity > 0 ? Math.min(100, Math.round((usage / capacity) * 100)) : 0,
        toolCount,
        tools,
        weaponCount,
        drugCount,
        cashAmount,
        accessibleInCurrentCountry,
      });
    }

    return overview;
  }

  async getPropertyStorageDetail(playerId: number, propertyId: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowedCategories = this.getAllowedCategories(property.propertyType);
    const capacity = await this.getCapacity(property.propertyType);

    const tools = allowedCategories.includes('tools')
      ? await toolService.getPropertyStorage(playerId, property.id)
      : [];

    const drugs = allowedCategories.includes('drugs')
      ? await prisma.propertyDrugStorage.findMany({
          where: {
            propertyId: property.id,
            NOT: [{ drugType: { startsWith: 'weapon:' } }, { drugType: '__cash__' }],
          },
          select: { drugType: true, quantity: true },
          orderBy: { drugType: 'asc' },
        })
      : [];

    const weapons = allowedCategories.includes('weapons')
      ? await this.getWeaponStorage(property.id)
      : [];

    const cashAmount = allowedCategories.includes('cash')
      ? await this.getCashStorage(property.id)
      : 0;

    const toolUsage = allowedCategories.includes('tools')
      ? await toolService.getPropertyStorageUsage(playerId, property.id)
      : 0;
    const drugUsage = drugs.reduce((sum, row) => sum + row.quantity, 0);
    const weaponUsage = weapons.reduce((sum, row) => sum + row.quantity, 0);
    const cashUsage = Math.ceil(cashAmount / CASH_SLOT_VALUE);
    const usage = toolUsage + drugUsage + weaponUsage + cashUsage;

    return {
      propertyId: property.id,
      propertyType: property.propertyType,
      propertyCountry: property.countryId,
      allowedCategories,
      capacity,
      usage,
      percentFull: capacity > 0 ? Math.min(100, Math.round((usage / capacity) * 100)) : 0,
      tools,
      weapons,
      drugs,
      cashAmount,
    };
  }

  async depositWeapon(playerId: number, propertyId: number, weaponId: string, quantity: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('weapons')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const weapon = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
    });

    if (!weapon || weapon.quantity < quantity) {
      throw new Error('INSUFFICIENT_WEAPON_QUANTITY');
    }

    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    if (detail.usage + quantity > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      if (weapon.quantity === quantity) {
        await tx.weaponInventory.delete({ where: { id: weapon.id } });
      } else {
        await tx.weaponInventory.update({
          where: { id: weapon.id },
          data: { quantity: weapon.quantity - quantity },
        });
      }

      const storageKey = `weapon:${weaponId}`;
      const existing = await tx.propertyDrugStorage.findUnique({
        where: {
          propertyId_drugType: {
            propertyId,
            drugType: storageKey,
          },
        },
      });

      if (existing) {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + quantity },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: {
            propertyId,
            drugType: storageKey,
            quantity,
          },
        });
      }
    });
  }

  async withdrawWeapon(playerId: number, propertyId: number, weaponId: string, quantity: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('weapons')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const storageKey = `weapon:${weaponId}`;
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: storageKey,
        },
      },
    });

    if (!stored || stored.quantity < quantity) {
      throw new Error('INSUFFICIENT_WEAPON_QUANTITY');
    }

    await prisma.$transaction(async (tx) => {
      if (stored.quantity === quantity) {
        await tx.propertyDrugStorage.delete({ where: { id: stored.id } });
      } else {
        await tx.propertyDrugStorage.update({
          where: { id: stored.id },
          data: { quantity: stored.quantity - quantity },
        });
      }

      const existing = await tx.weaponInventory.findUnique({
        where: {
          playerId_weaponId: {
            playerId,
            weaponId,
          },
        },
      });

      if (existing) {
        await tx.weaponInventory.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + quantity },
        });
      } else {
        await tx.weaponInventory.create({
          data: {
            playerId,
            weaponId,
            quantity,
            condition: 100,
          },
        });
      }
    });
  }

  async depositCash(playerId: number, propertyId: number, amount: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('cash')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    if (amount <= 0) throw new Error('INVALID_AMOUNT');

    const currentPlayer = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!currentPlayer || currentPlayer.money < amount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const cashStored = await this.getCashStorage(propertyId);
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    const currentCashSlots = Math.ceil(cashStored / CASH_SLOT_VALUE);
    const newCashSlots = Math.ceil((cashStored + amount) / CASH_SLOT_VALUE);
    const deltaSlots = newCashSlots - currentCashSlots;

    if (detail.usage + deltaSlots > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: amount } },
      });

      const existing = await tx.propertyDrugStorage.findUnique({
        where: {
          propertyId_drugType: {
            propertyId,
            drugType: '__cash__',
          },
        },
      });

      if (existing) {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + amount },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: {
            propertyId,
            drugType: '__cash__',
            quantity: amount,
          },
        });
      }
    });
  }

  async withdrawCash(playerId: number, propertyId: number, amount: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('cash')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    if (amount <= 0) throw new Error('INVALID_AMOUNT');

    const existing = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: '__cash__',
        },
      },
    });

    if (!existing || existing.quantity < amount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    await prisma.$transaction(async (tx) => {
      if (existing.quantity === amount) {
        await tx.propertyDrugStorage.delete({ where: { id: existing.id } });
      } else {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity - amount },
        });
      }

      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: amount } },
      });
    });
  }
}

export const propertyStorageService = new PropertyStorageService();
