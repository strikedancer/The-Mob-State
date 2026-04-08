import prisma from '../lib/prisma';
import fs from 'fs';
import path from 'path';
import { activityService } from './activityService';

interface SlotUpgrade {
  slots: number;
  price: number;
  requiredRank: number;
  description: string;
}

interface EquipmentLevel {
  level: number;
  name: string;
  price: number;
  qualityBonus?: number;
  yieldBonus?: number;
  speedBonus?: number;
  description: string;
}

interface EquipmentUpgrade {
  id: string;
  name: string;
  icon: string;
  description: string;
  affectsQuality?: boolean;
  affectsYield?: boolean;
  affectsSpeed?: boolean;
  levels: EquipmentLevel[];
}

interface FacilityDefinition {
  id: string;
  name: string;
  displayName: string;
  description: string;
  forDrugTypes: string[];
  purchasePrice: number;
  requiredRank: number;
  icon: string;
  slotUpgrades: SlotUpgrade[];
  equipmentUpgrades: EquipmentUpgrade[];
}

interface QualityTier {
  label: string;
  priceMultiplier: number;
  color: string;
  description: string;
}

interface FacilitiesData {
  facilities: { [key: string]: FacilityDefinition };
  qualityTiers: { [key: string]: QualityTier };
}

export type DrugQuality = 'D' | 'C' | 'B' | 'A' | 'S';

export interface FacilityMultipliers {
  qualityBonus: number;   // Additive bonus to quality roll
  yieldBonus: number;     // Multiplicative yield multiplier
  speedBonus: number;     // Fraction of time to remove (0.3 = 30% faster)
}

class DrugFacilityService {
  private facilities: Map<string, FacilityDefinition> = new Map();
  private qualityTiers: Map<string, QualityTier> = new Map();

  constructor() {
    this.loadFacilities();
  }

  private loadFacilities(): void {
    try {
      const filePath = path.join(__dirname, '../../content/drug_facilities.json');
      const data: FacilitiesData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
      Object.values(data.facilities).forEach((f) => this.facilities.set(f.id, f));
      Object.entries(data.qualityTiers).forEach(([k, v]) => this.qualityTiers.set(k, v));
      console.log(`✅ Loaded ${this.facilities.size} drug facility types`);
    } catch (err) {
      console.error('❌ Error loading drug facilities:', err);
    }
  }

  getFacilityConfig(): FacilitiesData {
    return {
      facilities: Object.fromEntries(this.facilities),
      qualityTiers: Object.fromEntries(this.qualityTiers),
    };
  }

  getFacilityDefinition(facilityType: string): FacilityDefinition | undefined {
    return this.facilities.get(facilityType);
  }

  /** Which facility type is needed for a given drug? */
  getFacilityTypeForDrug(drugId: string): string | null {
    for (const [, def] of this.facilities) {
      if (def.forDrugTypes.includes(drugId)) return def.id;
    }
    return null;
  }

  getQualityTier(quality: DrugQuality): QualityTier | undefined {
    return this.qualityTiers.get(quality);
  }

  // ─── Buy a new facility ─────────────────────────────────────────────────────

  async buyFacility(
    playerId: number,
    facilityType: string,
    country?: string
  ): Promise<{ success: boolean; message: string }> {
    const def = this.facilities.get(facilityType);
    if (!def) return { success: false, message: 'Onbekend faciliteitstype' };

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) return { success: false, message: 'Speler niet gevonden' };

    const facilityCountry = country || player.currentCountry || 'netherlands';

    if (player.rank < def.requiredRank) {
      return {
        success: false,
        message: `Je hebt rank ${def.requiredRank} nodig voor een ${def.displayName}`,
      };
    }

    const existing = await prisma.drugFacility.findUnique({
      where: { playerId_country_facilityType: { playerId, country: facilityCountry, facilityType } },
    });
    if (existing) {
      return { success: false, message: `Je hebt al een ${def.displayName} in ${facilityCountry}` };
    }

    if (player.money < def.purchasePrice) {
      return {
        success: false,
        message: `Je hebt €${def.purchasePrice.toLocaleString()} nodig. Je hebt €${player.money.toLocaleString()}`,
      };
    }

    await prisma.$transaction([
      prisma.player.update({ where: { id: playerId }, data: { money: { decrement: def.purchasePrice } } }),
      prisma.drugFacility.create({ data: { playerId, country: facilityCountry, facilityType, slots: 1 } }),
    ]);

    // Log player activity
    await activityService.logActivity(
      playerId,
      'PURCHASE',
      `Kocht drug faciliteit: ${def.displayName} in ${facilityCountry}`,
      {
        facilityType,
        facilityName: def.displayName,
        country: facilityCountry,
        price: def.purchasePrice,
      }
    );

    return { success: true, message: `${def.displayName} in ${facilityCountry} gekocht voor €${def.purchasePrice.toLocaleString()}!` };
  }

  // ─── Get facilities for player ──────────────────────────────────────────────

  async getPlayerFacilities(playerId: number, country?: string): Promise<any[]> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    // If country specified, get only that country; otherwise get ALL countries
    const query: any = { playerId };
    if (country) {
      query.country = country;
    }

    const facilities = await prisma.drugFacility.findMany({
      where: query,
      include: { upgrades: true },
    });

    return Promise.all(facilities.map(async (f) => {
      const def = this.facilities.get(f.facilityType);
      const multipliers = this.calculateMultipliersForFacilityType(f.facilityType, f.upgrades);
      const upgradeMap: { [key: string]: number } = {};
      f.upgrades.forEach((u) => { upgradeMap[u.upgradeType] = u.level; });
      const activeProductions = await this.getActiveProductionCount(f.id);
      const nextSlotUpgrade = def?.slotUpgrades.find((u) => u.slots === f.slots + 1);

      return {
        id: f.id,
        facilityType: f.facilityType,
        displayName: def?.displayName || f.facilityType,
        description: def?.description || '',
        icon: def?.icon || 'science',
        slots: f.slots,
        maxSlots: (def?.slotUpgrades.at(-1)?.slots) ?? f.slots,
        activeProductions,
        nextSlotCost: nextSlotUpgrade?.price ?? 0,
        forDrugTypes: def?.forDrugTypes || [],
        upgrades: upgradeMap,
        multipliers,
        purchasedAt: f.purchasedAt,
      };
    }));
  }

  // ─── Upgrade slots ──────────────────────────────────────────────────────────

  async upgradeSlots(
    playerId: number,
    facilityId: number
  ): Promise<{ success: boolean; message: string }> {
    const facility = await prisma.drugFacility.findUnique({ where: { id: facilityId } });
    if (!facility || facility.playerId !== playerId) {
      return { success: false, message: 'Faciliteit niet gevonden' };
    }

    const playerCountry = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!playerCountry || facility.country !== playerCountry.currentCountry) {
      return { success: false, message: 'Deze faciliteit is niet in je huidige land' };
    }

    const def = this.facilities.get(facility.facilityType);
    if (!def) return { success: false, message: 'Onbekend faciliteitstype' };

    const currentSlots = facility.slots;
    const nextUpgrade = def.slotUpgrades.find((u) => u.slots === currentSlots + 1);
    if (!nextUpgrade) {
      return { success: false, message: 'Maximaal aantal plekken bereikt' };
    }

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) return { success: false, message: 'Speler niet gevonden' };

    if (player.rank < nextUpgrade.requiredRank) {
      return { success: false, message: `Je hebt rank ${nextUpgrade.requiredRank} nodig voor deze uitbreiding` };
    }

    if (player.money < nextUpgrade.price) {
      return {
        success: false,
        message: `Je hebt €${nextUpgrade.price.toLocaleString()} nodig. Je hebt €${player.money.toLocaleString()}`,
      };
    }

    await prisma.$transaction([
      prisma.player.update({ where: { id: playerId }, data: { money: { decrement: nextUpgrade.price } } }),
      prisma.drugFacility.update({ where: { id: facilityId }, data: { slots: currentSlots + 1 } }),
    ]);

    return {
      success: true,
      message: `${def.displayName} uitgebreid naar ${currentSlots + 1} plekken!`,
    };
  }

  // ─── Upgrade equipment ──────────────────────────────────────────────────────

  async upgradeEquipment(
    playerId: number,
    facilityId: number,
    upgradeType: string
  ): Promise<{ success: boolean; message: string }> {
    const facility = await prisma.drugFacility.findUnique({
      where: { id: facilityId },
      include: { upgrades: true },
    });
    if (!facility || facility.playerId !== playerId) {
      return { success: false, message: 'Faciliteit niet gevonden' };
    }

    const def = this.facilities.get(facility.facilityType);
    if (!def) return { success: false, message: 'Onbekend faciliteitstype' };

    const equipDef = def.equipmentUpgrades.find((e) => e.id === upgradeType);
    if (!equipDef) return { success: false, message: 'Onbekend upgrade type' };

    const existingUpgrade = facility.upgrades.find((u) => u.upgradeType === upgradeType);
    const currentLevel = existingUpgrade?.level ?? 1;

    if (currentLevel >= equipDef.levels.length) {
      return { success: false, message: `${equipDef.name} is al op maximaal niveau` };
    }

    const nextLevel = equipDef.levels.find((l) => l.level === currentLevel + 1);
    if (!nextLevel) return { success: false, message: 'Maximaal niveau bereikt' };

    const player = await prisma.player.findUnique({ where: { id: playerId } });
    if (!player) return { success: false, message: 'Speler niet gevonden' };

    if (player.money < nextLevel.price) {
      return {
        success: false,
        message: `Je hebt €${nextLevel.price.toLocaleString()} nodig. Je hebt €${player.money.toLocaleString()}`,
      };
    }

    await prisma.$transaction([
      prisma.player.update({ where: { id: playerId }, data: { money: { decrement: nextLevel.price } } }),
      existingUpgrade
        ? prisma.drugFacilityUpgrade.update({
            where: { id: existingUpgrade.id },
            data: { level: currentLevel + 1, upgradedAt: new Date() },
          })
        : prisma.drugFacilityUpgrade.create({
            data: { facilityId, upgradeType, level: 2 },
          }),
    ]);

    return {
      success: true,
      message: `${equipDef.name} geüpgraded naar niveau ${currentLevel + 1}: ${nextLevel.name}!`,
    };
  }

  // ─── Calculate current multipliers ─────────────────────────────────────────

  calculateMultipliersForFacilityType(
    facilityType: string,
    upgrades: { upgradeType: string; level: number }[]
  ): FacilityMultipliers {
    const def = this.facilities.get(facilityType);
    if (!def) return { qualityBonus: 0, yieldBonus: 0, speedBonus: 0 };

    const upgradeMap: { [key: string]: number } = {};
    upgrades.forEach((u) => { upgradeMap[u.upgradeType] = u.level; });

    let qualityBonus = 0;
    let yieldBonus = 0;
    let speedBonus = 0;

    for (const equip of def.equipmentUpgrades) {
      const level = upgradeMap[equip.id] ?? 1;
      const levelDef = equip.levels.find((l) => l.level === level);
      if (levelDef) {
        qualityBonus += levelDef.qualityBonus ?? 0;
        yieldBonus += levelDef.yieldBonus ?? 0;
        speedBonus += levelDef.speedBonus ?? 0;
      }
    }

    return { qualityBonus, yieldBonus, speedBonus };
  }

  calculateMultipliers(upgrades: { upgradeType: string; level: number }[]): FacilityMultipliers {
    const upgradeMap: { [key: string]: number } = {};
    upgrades.forEach((u) => { upgradeMap[u.upgradeType] = u.level; });

    let qualityBonus = 0;
    let yieldBonus = 0;
    let speedBonus = 0;

    for (const [, def] of this.facilities) {
      for (const equip of def.equipmentUpgrades) {
        const level = upgradeMap[equip.id] ?? 1;
        const levelDef = equip.levels.find((l) => l.level === level);
        if (levelDef) {
          qualityBonus += levelDef.qualityBonus ?? 0;
          yieldBonus   += levelDef.yieldBonus   ?? 0;
          speedBonus   += levelDef.speedBonus   ?? 0;
        }
      }
    }

    return { qualityBonus, yieldBonus, speedBonus };
  }

  /** Calculate multipliers from a DB facility+upgrades record */
  async getFacilityMultipliers(facilityId: number): Promise<FacilityMultipliers> {
    const facility = await prisma.drugFacility.findUnique({
      where: { id: facilityId },
      include: { upgrades: true },
    });
    if (!facility) return { qualityBonus: 0, yieldBonus: 0, speedBonus: 0 };

    const def = this.facilities.get(facility.facilityType);
    if (!def) return { qualityBonus: 0, yieldBonus: 0, speedBonus: 0 };

    return this.calculateMultipliersForFacilityType(facility.facilityType, facility.upgrades);
  }

  /**
   * Roll the drug quality based on quality bonus.
   * qualityBonus 0 = mostly C, max ~1.5 = mostly S
   */
  rollQuality(qualityBonus: number): DrugQuality {
    // Base roll: random 0-1.0 + qualityBonus
    const roll = Math.random() + qualityBonus * 0.7;
    if (roll >= 1.60) return 'S';
    if (roll >= 1.20) return 'A';
    if (roll >= 0.85) return 'B';
    if (roll >= 0.45) return 'C';
    return 'D';
  }

  getQualityPriceMultiplier(quality: DrugQuality): number {
    return this.qualityTiers.get(quality)?.priceMultiplier ?? 1.0;
  }

  /** Check how many active productions a facility has */
  async getActiveProductionCount(facilityId: number): Promise<number> {
    return prisma.drugProduction.count({
      where: { facilityId, completed: false },
    });
  }
}

export const drugFacilityService = new DrugFacilityService();
