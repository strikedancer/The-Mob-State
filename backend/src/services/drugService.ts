import prisma from '../lib/prisma';
import fs from 'fs';
import path from 'path';
import { drugFacilityService } from './drugFacilityService';

interface DrugDefinition {
  id: string;
  name: string;
  displayName: string;
  type: string;
  description: string;
  weightPerUnit: number; // grams per unit (100g = 1 slot)
  productionTime: number; // in minutes
  materials: { [key: string]: number };
  yieldMin: number;
  yieldMax: number;
  basePrice: number;
  requiredRank: number;
  countryPricing: { [country: string]: number };
}

interface MaterialDefinition {
  id: string;
  name: string;
  description: string;
  price: number;
  category: string;
}

interface DrugData {
  drugs: DrugDefinition[];
  materials: MaterialDefinition[];
}

type ProductionRiskTier = 'low' | 'medium' | 'high';

interface ProductionIncidentResult {
  quantity: number;
  quality: string;
  extraMinutes: number;
  heatDelta: number;
  summary: string;
  incidentType: 'delay' | 'contamination' | 'yield_loss' | 'instability' | 'none' | 'mixed';
}

interface ProductionIncidentDisplayInfo {
  note?: string;
  severity?: 'low' | 'medium' | 'high';
  type?: 'delay' | 'contamination' | 'yield_loss' | 'instability' | 'mixed';
}

interface ProductionRiskProfile {
  baseChance: number;
  heatCap: number;
  mitigationCap: number;
  severeBase: number;
  severeHeat: number;
  moderateBase: number;
  moderateHeat: number;
}

class DrugService {
  private drugs: Map<string, DrugDefinition> = new Map();
  private materials: Map<string, MaterialDefinition> = new Map();

  constructor() {
    this.loadDrugs();
  }

  private loadDrugs(): void {
    try {
      const filePath = path.join(__dirname, '../../content/drugs.json');
      const fileContent = fs.readFileSync(filePath, 'utf-8');
      const data: DrugData = JSON.parse(fileContent);

      // Load drugs
      data.drugs.forEach((drug) => {
        this.drugs.set(drug.id, drug);
      });

      // Load materials
      data.materials.forEach((material) => {
        this.materials.set(material.id, material);
      });

      console.log(`✅ Loaded ${this.drugs.size} drug types and ${this.materials.size} production materials`);
    } catch (error) {
      console.error('❌ Error loading drugs:', error);
    }
  }

  // Get all drug definitions
  getAllDrugs(): DrugDefinition[] {
    return Array.from(this.drugs.values());
  }

  // Get drug definition by ID
  getDrugDefinition(drugId: string): DrugDefinition | undefined {
    return this.drugs.get(drugId);
  }

  // Get all materials
  getAllMaterials(): MaterialDefinition[] {
    return Array.from(this.materials.values());
  }

  // Get material definition by ID
  getMaterialDefinition(materialId: string): MaterialDefinition | undefined {
    return this.materials.get(materialId);
  }

  // Buy production materials
  async buyMaterial(playerId: number, materialId: string, quantity: number): Promise<{ success: boolean; message: string }> {
    const material = this.materials.get(materialId);
    if (!material) {
      return { success: false, message: 'Onbekend materiaal' };
    }

    const totalCost = material.price * quantity;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.money < totalCost) {
      return {
        success: false,
        message: `Je hebt €${totalCost.toLocaleString()} nodig. Je hebt €${player.money.toLocaleString()}`,
      };
    }

    // Update or create material inventory
    const existingMaterial = await prisma.productionMaterial.findUnique({
      where: {
        playerId_materialId: {
          playerId,
          materialId,
        },
      },
    });

    if (existingMaterial) {
      await prisma.productionMaterial.update({
        where: {
          playerId_materialId: {
            playerId,
            materialId,
          },
        },
        data: {
          quantity: existingMaterial.quantity + quantity,
        },
      });
    } else {
      await prisma.productionMaterial.create({
        data: {
          playerId,
          materialId,
          quantity,
        },
      });
    }

    // Deduct money
    await prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money - totalCost,
      },
    });

    return {
      success: true,
      message: `${quantity}x ${material.name} gekocht voor €${totalCost.toLocaleString()}`,
    };
  }

  // Get player's materials inventory
  async getPlayerMaterials(playerId: number): Promise<any[]> {
    const materials = await prisma.productionMaterial.findMany({
      where: { playerId },
    });

    return materials.map((m) => {
      const def = this.materials.get(m.materialId);
      return {
        id: m.id,
        materialId: m.materialId,
        name: def?.name || m.materialId,
        description: def?.description || '',
        quantity: m.quantity,
        price: def?.price || 0,
      };
    });
  }

  // Start drug production
  async startProduction(
    playerId: number,
    drugId: string,
    propertyId?: number
  ): Promise<{ success: boolean; message: string; finishesAt?: Date }> {
    const drug = this.drugs.get(drugId);
    if (!drug) {
      return { success: false, message: 'Onbekende drug' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    // Check rank requirement
    if (player.rank < drug.requiredRank) {
      return {
        success: false,
        message: `Je hebt rank ${drug.requiredRank} nodig voor ${drug.displayName} productie`,
      };
    }

    // ── Facility check ─────────────────────────────────────────────────────────
    const requiredFacilityType = drugFacilityService.getFacilityTypeForDrug(drugId);
    let facilityId: number | null = null;
    let facilityCountry = 'netherlands';
    let facilityMultipliers = { qualityBonus: 0, yieldBonus: 0, speedBonus: 0 };

    if (requiredFacilityType) {
      const facility = await prisma.drugFacility.findUnique({
        where: { playerId_country_facilityType: { playerId, country: player.currentCountry || 'netherlands', facilityType: requiredFacilityType } },
        include: { upgrades: true },
      });

      if (!facility) {
        const def = drugFacilityService.getFacilityDefinition(requiredFacilityType);
        return {
          success: false,
          message: `Je hebt een ${def?.displayName ?? requiredFacilityType} in je huidigging land nodig om ${drug.displayName} te produceren.`,
        };
      }

      // Check slot availability
      const activeCount = await drugFacilityService.getActiveProductionCount(facility.id);
      if (activeCount >= facility.slots) {
        return {
          success: false,
          message: `Je ${drug.type === 'WEED' ? 'kas' : 'lab'} heeft geen vrije plekken (${activeCount}/${facility.slots}). Upgrade naar meer plekken of wacht tot een productie klaar is.`,
        };
      }

      facilityId = facility.id;
      facilityCountry = facility.country;
      facilityMultipliers = drugFacilityService.calculateMultipliersForFacilityType(
        requiredFacilityType,
        facility.upgrades,
      );
    }
    // Check if player has all required materials
    const playerMaterials = await prisma.productionMaterial.findMany({
      where: { playerId },
    });

    const materialMap: { [key: string]: number } = {};
    playerMaterials.forEach((m) => {
      materialMap[m.materialId] = m.quantity;
    });

    for (const [materialId, required] of Object.entries(drug.materials)) {
      const available = materialMap[materialId] || 0;
      if (available < required) {
        const materialDef = this.materials.get(materialId);
        return {
          success: false,
          message: `Je hebt ${required}x ${materialDef?.name || materialId} nodig (je hebt ${available})`,
        };
      }
    }

    // If propertyId provided, verify ownership
    if (propertyId) {
      const property = await prisma.property.findUnique({
        where: { id: propertyId },
      });

      if (!property || property.playerId !== playerId) {
        return { success: false, message: 'Je bezit dit pand niet' };
      }

      if (!['nightclub'].includes(property.propertyType)) {
        return { success: false, message: 'Dit pand is niet geschikt voor drug productie' };
      }
    }

    // Deduct materials
    for (const [materialId, required] of Object.entries(drug.materials)) {
      await prisma.productionMaterial.update({
        where: {
          playerId_materialId: {
            playerId,
            materialId,
          },
        },
        data: {
          quantity: {
            decrement: required,
          },
        },
      });
    }

    // ── Apply facility multipliers ──────────────────────────────────────────────
    const { yieldBonus, speedBonus, qualityBonus } = facilityMultipliers;

    // ── Crew bonus ──────────────────────────────────────────────────────────────
    const crewBonus = await this.getCrewDrugBonus(playerId);
    const totalYieldBonus = yieldBonus + crewBonus.yieldBonus;
    const totalSpeedBonus = speedBonus + crewBonus.speedBonus;
    const heatInfo = await this.getDrugHeat(playerId);

    // Yield: apply yield bonus to both min and max
    const boostedMin = Math.round(drug.yieldMin * (1 + totalYieldBonus));
    const boostedMax = Math.round(drug.yieldMax * (1 + totalYieldBonus));
    let yield_amount = Math.floor(Math.random() * (boostedMax - boostedMin + 1)) + boostedMin;

    // Quality roll
    let quality = drugFacilityService.rollQuality(qualityBonus);
    const qualityMultiplier = drugFacilityService.getQualityPriceMultiplier(quality);

    // Speed: reduce production time
    let reducedMinutes = Math.max(5, Math.round(drug.productionTime * (1 - totalSpeedBonus)));

    const incident = this.rollProductionIncident(
      drug,
      heatInfo.heat,
      facilityMultipliers,
      yield_amount,
      quality,
      reducedMinutes,
    );

    yield_amount = incident.quantity;
    quality = incident.quality as any;
    reducedMinutes += incident.extraMinutes;

    const finalQualityMultiplier = drugFacilityService.getQualityPriceMultiplier(quality as any);
    const finishesAt = new Date(Date.now() + reducedMinutes * 60 * 1000);

    // Create production record
    await prisma.drugProduction.create({
      data: {
        playerId,
        propertyId: propertyId ?? null,
        facilityId,
        drugType: drugId,
        quantity: yield_amount,
        quality,
        qualityMultiplier: finalQualityMultiplier,
        finishesAt,
      },
    });

    const qualityDef = drugFacilityService.getQualityTier(quality);
    const qualityLabel = qualityDef?.label ?? quality;

    // Production increases heat
    await this.updateHeat(playerId, 5 + incident.heatDelta);

    return {
      success: true,
      message: `${drug.displayName} productie gestart! Klaar over ${reducedMinutes} min — opbrengst: ${yield_amount}, kwaliteit: ${qualityLabel}${incident.summary.isNotEmpty ? `\n${incident.summary}` : ''}`,
      finishesAt,
    };
  }

  private getProductionRiskTier(drug: DrugDefinition): ProductionRiskTier {
    if (drug.id === 'magic_mushrooms' || drug.type === 'MUSHROOMS') return 'medium';
    if (drug.id === 'lsd' || drug.id === 'crystal_meth' || drug.id === 'fentanyl') return 'high';
    if (['COCAINE', 'SPEED', 'HEROIN', 'XTC'].includes(drug.type)) return 'medium';
    return 'low';
  }

  private lowerQuality(quality: string, steps: number): string {
    const order = ['D', 'C', 'B', 'A', 'S'];
    const index = order.indexOf(quality);
    if (index <= 0) return 'D';
    return order[Math.max(0, index - steps)] ?? 'D';
  }

  private getProductionRiskProfile(drug: DrugDefinition): ProductionRiskProfile {
    // Weed: safest entry path
    if (drug.type === 'WEED') {
      return {
        baseChance: 0.06,
        heatCap: 0.05,
        mitigationCap: 0.11,
        severeBase: 0.025,
        severeHeat: 0.035,
        moderateBase: 0.17,
        moderateHeat: 0.08,
      };
    }

    // Mushrooms: slightly riskier than weed, safer than chemical labs
    if (drug.id === 'magic_mushrooms' || drug.type === 'MUSHROOMS') {
      return {
        baseChance: 0.07,
        heatCap: 0.05,
        mitigationCap: 0.11,
        severeBase: 0.03,
        severeHeat: 0.04,
        moderateBase: 0.18,
        moderateHeat: 0.10,
      };
    }

    // Heavy chemical drugs: most volatile
    if (drug.id === 'lsd' || drug.id === 'crystal_meth' || drug.id === 'fentanyl') {
      return {
        baseChance: 0.15,
        heatCap: 0.09,
        mitigationCap: 0.08,
        severeBase: 0.06,
        severeHeat: 0.08,
        moderateBase: 0.28,
        moderateHeat: 0.18,
      };
    }

    // Default lab drugs
    return {
      baseChance: 0.115,
      heatCap: 0.08,
      mitigationCap: 0.09,
      severeBase: 0.05,
      severeHeat: 0.07,
      moderateBase: 0.25,
      moderateHeat: 0.15,
    };
  }

  private describeProductionIncidentForDisplay(
    drug: DrugDefinition | undefined,
    facility: { facilityType: string; upgrades: { upgradeType: string; level: number }[] } | null,
    production: { quantity: number; startedAt: Date; finishesAt: Date },
  ): ProductionIncidentDisplayInfo {
    if (!drug || !facility) return {};

    const multipliers = drugFacilityService.calculateMultipliersForFacilityType(
      facility.facilityType,
      facility.upgrades,
    );
    const expectedMinutes = Math.max(5, Math.round(drug.productionTime * (1 - multipliers.speedBonus)));
    const actualMinutes = Math.max(
      1,
      Math.round((production.finishesAt.getTime() - production.startedAt.getTime()) / 60000),
    );
    const expectedMinYield = Math.round(drug.yieldMin * (1 + multipliers.yieldBonus));

    const notes: string[] = [];
    let type: 'delay' | 'contamination' | 'yield_loss' | 'instability' | 'mixed' = 'delay';
    let severity: 'low' | 'medium' | 'high' = 'low';

    const hasYieldIssue = production.quantity < expectedMinYield;
    const hasDelayIssue = actualMinutes > expectedMinutes + 2;

    if (hasYieldIssue) {
      notes.add(
        drug.id === 'magic_mushrooms'
            ? 'Schimmel of besmetting heeft de opbrengst verlaagd.'
            : 'De batch heeft minder opgeleverd dan verwacht.',
      );
      type = drug.id === 'magic_mushrooms' ? 'contamination' : 'yield_loss';
      severity = production.quantity < Math.round(expectedMinYield * 0.8) ? 'high' : 'medium';
    }

    if (hasDelayIssue) {
      notes.add(
        drug.id === 'magic_mushrooms'
            ? 'De groei liep vertraging op door instabiele omstandigheden.'
            : 'De productie liep vertraging op door een storing.',
      );
      type = hasYieldIssue ? 'mixed' : 'delay';
      if (actualMinutes > Math.round(expectedMinutes * 1.18)) {
        severity = 'high';
      } else if (severity === 'low') {
        severity = 'medium';
      }
    }

    if (notes.isEmpty) return {};

    return {
      note: notes.join(' '),
      severity,
      type,
    };
  }

  private rollProductionIncident(
    drug: DrugDefinition,
    heat: number,
    multipliers: { qualityBonus: number; yieldBonus: number; speedBonus: number },
    quantity: number,
    quality: string,
    baseMinutes: number,
  ): ProductionIncidentResult {
    const riskTier = this.getProductionRiskTier(drug);
    const riskProfile = this.getProductionRiskProfile(drug);
    const isMushroomBatch = drug.id === 'magic_mushrooms';
    const heatFactor = Math.min(riskProfile.heatCap, (heat / 100) * riskProfile.heatCap);
    const mitigation = Math.min(
      riskProfile.mitigationCap,
      multipliers.qualityBonus * 0.03 + multipliers.yieldBonus * 0.02 + multipliers.speedBonus * 0.02,
    );
    const incidentChance = Math.max(0.03, riskProfile.baseChance + heatFactor - mitigation);

    if (Math.random() >= incidentChance) {
      return {
        quantity,
        quality,
        extraMinutes: 0,
        heatDelta: 0,
        summary: '',
        incidentType: 'none',
      };
    }

    const severityRoll = Math.random();
    const severeThreshold = isMushroomBatch
      ? Math.min(0.07, riskProfile.severeBase + (heat / 100) * riskProfile.severeHeat)
      : Math.min(0.12, riskProfile.severeBase + (heat / 100) * riskProfile.severeHeat + (riskTier === 'high' ? 0.03 : 0));
    const moderateThreshold = isMushroomBatch
      ? Math.min(0.30, riskProfile.moderateBase + (heat / 100) * riskProfile.moderateHeat)
      : Math.min(0.45, riskProfile.moderateBase + (heat / 100) * riskProfile.moderateHeat + (riskTier !== 'low' ? 0.05 : 0));

    let nextQuantity = quantity;
    let nextQuality = quality;
    let extraMinutes = 0;
    let heatDelta = 0;
    let summary = '';
    let incidentType: ProductionIncidentResult['incidentType'] = 'delay';

    const applyQuantityPenalty = (minFactor: number, maxFactor: number) => {
      const factor = minFactor + Math.random() * (maxFactor - minFactor);
      nextQuantity = Math.max(1, Math.round(nextQuantity * factor));
    };

    const applyDelay = (minPct: number, maxPct: number) => {
      const pct = minPct + Math.random() * (maxPct - minPct);
      extraMinutes = Math.max(extraMinutes, Math.round(baseMinutes * pct));
    };

    if (severityRoll < severeThreshold) {
      if (riskTier === 'low') {
        applyQuantityPenalty(0.65, 0.78);
        nextQuality = this.lowerQuality(nextQuality, 1);
        applyDelay(0.12, 0.22);
        summary = '⚠️ Grote kweekstoring: een deel van de batch is verloren gegaan en de kwaliteit is gedaald.';
        incidentType = 'yield_loss';
      } else if (riskTier === 'medium') {
        applyQuantityPenalty(0.60, 0.72);
        nextQuality = this.lowerQuality(nextQuality, 1);
        applyDelay(0.18, 0.30);
        heatDelta = 2;
        summary = drug.id === 'magic_mushrooms'
          ? '⚠️ Besmette kweekbak: schimmel heeft de batch geraakt. Opbrengst en kwaliteit zijn verlaagd.'
          : '⚠️ Grote productiestoring: de batch is deels bedorven en loopt vertraging op.';
        incidentType = drug.id === 'magic_mushrooms' ? 'contamination' : 'mixed';
      } else {
        applyQuantityPenalty(0.58, 0.70);
        nextQuality = this.lowerQuality(nextQuality, 1);
        applyDelay(0.15, 0.28);
        heatDelta = 4;
        summary = '⚠️ Instabiele batch: een deel van de productie is mislukt. Opbrengst, tijd en kwaliteit zijn geraakt.';
        incidentType = 'instability';
      }
    } else if (severityRoll < moderateThreshold) {
      if (riskTier === 'low') {
        applyQuantityPenalty(0.82, 0.90);
        nextQuality = this.lowerQuality(nextQuality, 1);
        summary = '⚠️ Ongunstige groeiomstandigheden: iets minder opbrengst en een lagere batchkwaliteit.';
        incidentType = 'yield_loss';
      } else if (riskTier === 'medium') {
        applyQuantityPenalty(0.76, 0.88);
        nextQuality = this.lowerQuality(nextQuality, 1);
        summary = drug.id === 'magic_mushrooms'
          ? '⚠️ Schimmel in het substraat: de batch levert minder op en de kwaliteit daalt.'
          : '⚠️ Vervuilde batch: de productie levert minder op en de kwaliteit daalt.';
        incidentType = drug.id === 'magic_mushrooms' ? 'contamination' : 'yield_loss';
      } else {
        applyQuantityPenalty(0.78, 0.88);
        nextQuality = this.lowerQuality(nextQuality, 1);
        heatDelta = 1;
        summary = '⚠️ Chemische vervuiling: de batch is minder zuiver en de opbrengst valt lager uit.';
        incidentType = 'contamination';
      }
    } else {
      if (riskTier === 'low') {
        applyDelay(0.10, 0.16);
        summary = '⚠️ Kleine klimaatstoring: de productie duurt iets langer dan gepland.';
        incidentType = 'delay';
      } else if (riskTier === 'medium') {
        if (drug.id === 'magic_mushrooms') {
          applyDelay(0.12, 0.18);
          summary = '⚠️ Vochtigheid schommelt: de paddenstoelen groeien trager dan verwacht.';
          incidentType = 'delay';
        } else {
          applyDelay(0.10, 0.18);
          summary = '⚠️ Kleine productiestoring: de batch loopt wat vertraging op.';
          incidentType = 'delay';
        }
      } else {
        nextQuality = this.lowerQuality(nextQuality, 1);
        summary = '⚠️ Onstabiele reactie: de batch haalt een lagere kwaliteit dan gehoopt.';
        incidentType = 'instability';
      }
    }

    return {
      quantity: nextQuantity,
      quality: nextQuality,
      extraMinutes,
      heatDelta,
      summary,
      incidentType,
    };
  }

  // Get active productions
  async getActiveProductions(playerId: number): Promise<any[]> {
    const productions = await prisma.drugProduction.findMany({
      where: {
        playerId,
        completed: false,
      },
      include: {
        facility: {
          include: { upgrades: true },
        },
      },
      orderBy: {
        finishesAt: 'asc',
      },
    });

    return productions.map((p) => {
      const drug = this.drugs.get(p.drugType);
      const now = new Date();
      const isReady = p.finishesAt <= now;
      const qualityDef = drugFacilityService.getQualityTier((p.quality ?? 'C') as any);
      const incidentInfo = this.describeProductionIncidentForDisplay(
        drug,
        p.facility
          ? {
              facilityType: p.facility.facilityType,
              upgrades: p.facility.upgrades,
            }
          : null,
        p,
      );

      return {
        id: p.id,
        drugType: p.drugType,
        drugName: drug?.displayName || p.drugType,
        quantity: p.quantity,
        startedAt: p.startedAt,
        finishesAt: p.finishesAt,
        isReady,
        timeRemaining: isReady ? 0 : Math.max(0, p.finishesAt.getTime() - now.getTime()),
        quality: p.quality ?? 'C',
        qualityLabel: qualityDef?.label ?? (p.quality ?? 'C'),
        qualityColor: qualityDef?.color ?? '#888888',
        qualityMultiplier: p.qualityMultiplier ?? 1.0,
        facilityId: p.facilityId ?? null,
        incidentNote: incidentInfo.note ?? null,
        incidentSeverity: incidentInfo.severity ?? null,
        incidentType: incidentInfo.type ?? null,
      };
    });
  }

  // Collect finished production
  async collectProduction(playerId: number, productionId: number): Promise<{ success: boolean; message: string }> {
    const production = await prisma.drugProduction.findUnique({
      where: { id: productionId },
    });

    if (!production) {
      return { success: false, message: 'Productie niet gevonden' };
    }

    if (production.playerId !== playerId) {
      return { success: false, message: 'Dit is niet jouw productie' };
    }

    if (production.collected) {
      return { success: false, message: 'Deze productie is al opgehaald' };
    }

    const now = new Date();
    if (production.finishesAt > now) {
      const timeLeft = Math.ceil((production.finishesAt.getTime() - now.getTime()) / 60000);
      return { success: false, message: `Productie nog niet klaar (nog ${timeLeft} minuten)` };
    }

    const quality = (production as any).quality ?? 'C';

    // Atomic collect: never mark as collected unless inventory update succeeds.
    await prisma.$transaction(async (tx) => {
      await tx.drugProduction.update({
        where: { id: productionId },
        data: {
          completed: true,
          collected: true,
        },
      });

      const existingDrug = await tx.drugInventory.findUnique({
        where: {
          playerId_drugType_quality: {
            playerId,
            drugType: production.drugType,
            quality,
          },
        },
      });

      if (existingDrug) {
        await tx.drugInventory.update({
          where: {
            playerId_drugType_quality: {
              playerId,
              drugType: production.drugType,
              quality,
            },
          },
          data: {
            quantity: existingDrug.quantity + production.quantity,
          },
        });
      } else {
        await tx.drugInventory.create({
          data: {
            playerId,
            drugType: production.drugType,
            quality,
            quantity: production.quantity,
          },
        });
      }
    });

    const drug = this.drugs.get(production.drugType);
    const qualityDef = drugFacilityService.getQualityTier(quality as any);
    const qualityLabel = qualityDef?.label ?? quality;

    // Collect reduces heat slightly
    await this.updateHeat(playerId, -3);

    // Raid check — higher heat = higher chance of losing some product
    const heatInfo = await this.getDrugHeat(playerId);
    let raidMessage = '';
    if (heatInfo.raidChance > 0 && Math.random() < heatInfo.raidChance) {
      const confiscatePct = 0.20 + Math.random() * 0.30; // 20–50%
      const confiscated = Math.round(production.quantity * confiscatePct);
      if (confiscated > 0) {
        await prisma.drugInventory.update({
          where: { playerId_drugType_quality: { playerId, drugType: production.drugType, quality } },
          data: { quantity: { decrement: confiscated } },
        });
        await this.updateHeat(playerId, -15); // Raid reduces heat
        raidMessage = ` ⚠️ POLITIE-INVAL: ${confiscated}g geconfisqueerd! (heat: ${heatInfo.heat})`;
      }
    }

    return {
      success: true,
      message: `${production.quantity}x ${drug?.displayName || production.drugType} (${qualityLabel}) opgehaald!${raidMessage}`,
    };
  }

  // Get player drug inventory
  async getDrugInventory(playerId: number): Promise<any[]> {
    const inventory = await prisma.drugInventory.findMany({
      where: {
        playerId,
        quantity: { gt: 0 },
      },
      orderBy: [{ drugType: 'asc' }, { quality: 'asc' }],
    });

    return inventory.map((i) => {
      const drug = this.drugs.get(i.drugType);
      const qualityDef = drugFacilityService.getQualityTier((i.quality ?? 'C') as any);
      return {
        id: i.id,
        drugType: i.drugType,
        drugName: drug?.displayName || i.drugType,
        quality: i.quality ?? 'C',
        qualityLabel: qualityDef?.label ?? (i.quality ?? 'C'),
        qualityColor: qualityDef?.color ?? '#888888',
        qualityMultiplier: qualityDef?.priceMultiplier ?? 1.0,
        quantity: i.quantity,
        basePrice: drug?.basePrice || 0,
        effectivePrice: Math.round((drug?.basePrice || 0) * (qualityDef?.priceMultiplier ?? 1.0)),
      };
    });
  }

  // Sell drugs
  async sellDrugs(
    playerId: number,
    drugType: string,
    quantity: number,
    quality: string = 'C'
  ): Promise<{ success: boolean; message: string; earnings?: number }> {
    const drug = this.drugs.get(drugType);
    if (!drug) {
      return { success: false, message: 'Onbekende drug' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    const inventory = await prisma.drugInventory.findUnique({
      where: {
        playerId_drugType_quality: {
          playerId,
          drugType,
          quality,
        },
      },
    });

    if (!inventory || inventory.quantity < quantity) {
      return {
        success: false,
        message: `Je hebt niet genoeg ${drug.displayName} kwaliteit ${quality} (je hebt ${inventory?.quantity || 0})`,
      };
    }

    // Get country-specific price and apply quality multiplier
    const countryPrice = drug.countryPricing[player.currentCountry] || drug.basePrice;
    const qualityMultiplier = drugFacilityService.getQualityPriceMultiplier(quality as any);
    const totalEarnings = Math.round(countryPrice * qualityMultiplier * quantity);

    // Update inventory
    if (inventory.quantity === quantity) {
      await prisma.drugInventory.delete({
        where: {
          playerId_drugType_quality: {
            playerId,
            drugType,
            quality,
          },
        },
      });
    } else {
      await prisma.drugInventory.update({
        where: {
          playerId_drugType_quality: {
            playerId,
            drugType,
            quality,
          },
        },
        data: {
          quantity: inventory.quantity - quantity,
        },
      });
    }

    // Add money to player
    await prisma.player.update({
      where: { id: playerId },
      data: {
        money: player.money + totalEarnings,
      },
    });

    // Selling drugs increases heat (+2 per 100g sold)
    const heatIncrease = Math.round(quantity / 100) * 2;
    await this.updateHeat(playerId, heatIncrease);

    const qualityDef = drugFacilityService.getQualityTier(quality as any);
    const qualityLabel = qualityDef?.label ?? quality;

    return {
      success: true,
      message: `${quantity}x ${drug.displayName} (${qualityLabel}) verkocht voor €${totalEarnings.toLocaleString()}!`,
      earnings: totalEarnings,
    };
  }

  // Check if player has required drugs for crime (aggregates across all qualities)
  async hasRequiredDrugs(playerId: number, drugTypes: string[], minQuantity: number): Promise<boolean> {
    const inventory = await prisma.drugInventory.findMany({
      where: { playerId },
    });

    for (const drugType of drugTypes) {
      const rows = inventory.filter((d) => d.drugType === drugType);
      const total = rows.reduce((sum, r) => sum + r.quantity, 0);
      if (total >= minQuantity) {
        return true;
      }
    }

    return false;
  }

  // Consume drugs for crime (consumes from lowest quality first)
  async consumeDrugs(playerId: number, drugType: string, quantity: number): Promise<void> {
    // Quality order: D first (worst), then C, B, A, S
    const qualityOrder = ['D', 'C', 'B', 'A', 'S'];
    const rows = await prisma.drugInventory.findMany({
      where: { playerId, drugType },
      orderBy: { quality: 'asc' },
    });
    // Sort by quality order
    rows.sort((a, b) => qualityOrder.indexOf(a.quality ?? 'C') - qualityOrder.indexOf(b.quality ?? 'C'));

    const totalAvailable = rows.reduce((sum, r) => sum + r.quantity, 0);
    if (totalAvailable < quantity) {
      throw new Error('Niet genoeg drugs');
    }

    let remaining = quantity;
    for (const row of rows) {
      if (remaining <= 0) break;
      const consume = Math.min(row.quantity, remaining);
      remaining -= consume;
      if (row.quantity === consume) {
        await prisma.drugInventory.delete({ where: { id: row.id } });
      } else {
        await prisma.drugInventory.update({
          where: { id: row.id },
          data: { quantity: row.quantity - consume },
        });
      }
    }
  }

  // Background job: Process finished productions
  async processFinishedProductions(): Promise<void> {
    const now = new Date();

    const finishedProductions = await prisma.drugProduction.findMany({
      where: {
        finishesAt: {
          lte: now,
        },
        completed: false,
      },
    });

    console.log(`Processing ${finishedProductions.length} finished drug productions`);

    for (const production of finishedProductions) {
      await prisma.drugProduction.update({
        where: { id: production.id },
        data: {
          completed: true,
        },
      });
    }
  }

  // Store drugs in a property
  async storeDrugs(playerId: number, propertyId: number, drugType: string, quantity: number): Promise<{ success: boolean; message: string }> {
    // Get drug definition for weight calculation
    const drugDef = this.drugs.get(drugType);
    if (!drugDef) {
      return { success: false, message: 'Onbekend drug type' };
    }

    // Verify property ownership
    const property = await prisma.property.findFirst({
      where: {
        id: propertyId,
        playerId,
      },
    });

    if (!property) {
      return { success: false, message: 'Je bezit deze eigendom niet' };
    }

    if (property.propertyType !== 'nightclub') {
      return { success: false, message: 'Alleen een nachtclub kan drugs opslaan' };
    }

    // Check if player is in the same country as the property
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.currentCountry !== property.countryId) {
      return { success: false, message: 'Je moet in hetzelfde land zijn als het eigendom' };
    }

    // Check if player has the drugs
    const inventory = await prisma.drugInventory.findUnique({
      where: {
        playerId_drugType: {
          playerId,
          drugType,
        },
      },
    });

    if (!inventory || inventory.quantity < quantity) {
      return { success: false, message: 'Je hebt niet genoeg drugs om op te slaan' };
    }

    // Check storage capacity (weight-based: 1 unit = 100g)
    const storageCapacity = await prisma.propertyStorageCapacity.findUnique({
      where: { propertyType: property.propertyType },
    });

    const currentStorage = await prisma.propertyDrugStorage.findMany({
      where: { propertyId },
    });

    // Calculate total weight in grams
    let totalWeightGrams = 0;
    for (const item of currentStorage) {
      const itemDef = this.drugs.get(item.drugType);
      if (itemDef) {
        totalWeightGrams += item.quantity * itemDef.weightPerUnit;
      }
    }

    const newWeightGrams = quantity * drugDef.weightPerUnit;
    const maxCapacityGrams = (storageCapacity?.maxSlots || 100) * 100; // slots * 100g per slot

    if (totalWeightGrams + newWeightGrams > maxCapacityGrams) {
      const totalKg = (totalWeightGrams / 1000).toFixed(1);
      const maxKg = (maxCapacityGrams / 1000).toFixed(1);
      return { 
        success: false, 
        message: `Onvoldoende opslagruimte. Capaciteit: ${maxKg}kg, gebruikt: ${totalKg}kg` 
      };
    }

    // Transfer drugs from player inventory to property storage
    await prisma.$transaction(async (tx) => {
      // Remove from player inventory
      if (inventory.quantity === quantity) {
        await tx.drugInventory.delete({
          where: {
            playerId_drugType: {
              playerId,
              drugType,
            },
          },
        });
      } else {
        await tx.drugInventory.update({
          where: {
            playerId_drugType: {
              playerId,
              drugType,
            },
          },
          data: {
            quantity: inventory.quantity - quantity,
          },
        });
      }

      // Add to property storage
      const existingStorage = await tx.propertyDrugStorage.findUnique({
        where: {
          propertyId_drugType: {
            propertyId,
            drugType,
          },
        },
      });

      if (existingStorage) {
        await tx.propertyDrugStorage.update({
          where: {
            propertyId_drugType: {
              propertyId,
              drugType,
            },
          },
          data: {
            quantity: existingStorage.quantity + quantity,
          },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: {
            propertyId,
            drugType,
            quantity,
          },
        });
      }
    });

    const weightKg = (newWeightGrams / 1000).toFixed(1);
    return { 
      success: true, 
      message: `${quantity}x ${drugType} (${weightKg}kg) opgeslagen in ${property.propertyType}` 
    };
  }

  // Retrieve drugs from a property
  async retrieveDrugs(playerId: number, propertyId: number, drugType: string, quantity: number): Promise<{ success: boolean; message: string }> {
    // Verify property ownership
    const property = await prisma.property.findFirst({
      where: {
        id: propertyId,
        playerId,
      },
    });

    if (!property) {
      return { success: false, message: 'Je bezit deze eigendom niet' };
    }

    if (property.propertyType !== 'nightclub') {
      return { success: false, message: 'Alleen een nachtclub heeft drugopslag' };
    }

    // Check if player is in the same country as the property
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.currentCountry !== property.countryId) {
      return { success: false, message: 'Je moet in hetzelfde land zijn als het eigendom' };
    }

    // Check if property has the drugs
    const storage = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType,
        },
      },
    });

    if (!storage || storage.quantity < quantity) {
      return { success: false, message: 'Niet genoeg drugs in opslag' };
    }

    // Transfer drugs from property storage to player inventory
    await prisma.$transaction(async (tx) => {
      // Remove from property storage
      if (storage.quantity === quantity) {
        await tx.propertyDrugStorage.delete({
          where: {
            propertyId_drugType: {
              propertyId,
              drugType,
            },
          },
        });
      } else {
        await tx.propertyDrugStorage.update({
          where: {
            propertyId_drugType: {
              propertyId,
              drugType,
            },
          },
          data: {
            quantity: storage.quantity - quantity,
          },
        });
      }

      // Add to player inventory
      const inventory = await tx.drugInventory.findUnique({
        where: {
          playerId_drugType: {
            playerId,
            drugType,
          },
        },
      });

      if (inventory) {
        await tx.drugInventory.update({
          where: {
            playerId_drugType: {
              playerId,
              drugType,
            },
          },
          data: {
            quantity: inventory.quantity + quantity,
          },
        });
      } else {
        await tx.drugInventory.create({
          data: {
            playerId,
            drugType,
            quantity,
          },
        });
      }
    });

    return { 
      success: true, 
      message: `${quantity}x ${drugType} opgehaald uit ${property.propertyType}` 
    };
  }

  // Get property storage
  async getPropertyStorage(playerId: number, propertyId: number): Promise<{ success: boolean; storage?: any[]; property?: any; capacity?: any; message?: string }> {
    // Verify property ownership
    const property = await prisma.property.findFirst({
      where: {
        id: propertyId,
        playerId,
      },
    });

    if (!property) {
      return { success: false, message: 'Je bezit deze eigendom niet' };
    }

    if (property.propertyType !== 'nightclub') {
      return { success: false, message: 'Dit pand heeft geen drugopslag' };
    }

    // Get storage capacity
    const storageCapacity = await prisma.propertyStorageCapacity.findUnique({
      where: { propertyType: property.propertyType },
    });

    // Get stored drugs
    const storage = await prisma.propertyDrugStorage.findMany({
      where: { propertyId },
    });

    // Calculate total weight in grams
    let totalWeightGrams = 0;
    const storageWithWeight = storage.map((item) => {
      const drugDef = this.drugs.get(item.drugType);
      const weightGrams = drugDef ? item.quantity * drugDef.weightPerUnit : item.quantity * 100;
      totalWeightGrams += weightGrams;
      return {
        ...item,
        weightGrams,
        weightKg: (weightGrams / 1000).toFixed(1),
      };
    });

    const maxCapacityGrams = (storageCapacity?.maxSlots || 100) * 100;

    return {
      success: true,
      storage: storageWithWeight,
      property: {
        id: property.id,
        propertyType: property.propertyType,
        countryId: property.countryId,
      },
      capacity: {
        maxKg: (maxCapacityGrams / 1000).toFixed(1),
        usedKg: (totalWeightGrams / 1000).toFixed(1),
        availableKg: ((maxCapacityGrams - totalWeightGrams) / 1000).toFixed(1),
        maxGrams: maxCapacityGrams,
        usedGrams: totalWeightGrams,
        availableGrams: maxCapacityGrams - totalWeightGrams,
      },
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // MARKET FLUCTUATIONS — deterministic daily ±25% price multiplier per drug
  // ─────────────────────────────────────────────────────────────────────────────

  getMarketFluctuation(drugId: string): number {
    const today = new Date();
    const dayOfYear = Math.floor(
      (today.getTime() - new Date(today.getFullYear(), 0, 0).getTime()) / 86400000
    );
    // Simple deterministic hash from drugId
    let hash = 0;
    for (let i = 0; i < drugId.length; i++) {
      hash = (hash * 31 + drugId.charCodeAt(i)) % 1000;
    }
    // Sin-based fluctuation, unique pattern per drug, resets each day
    const fluctuation = Math.sin((dayOfYear * 2.7 + hash) * 1.3) * 0.25;
    return Math.round((1 + fluctuation) * 100) / 100; // two decimals, 0.75–1.25
  }

  getAllMarketPrices(): Record<string, { multiplier: number; trend: 'up' | 'down' | 'stable' }> {
    const result: Record<string, { multiplier: number; trend: 'up' | 'down' | 'stable' }> = {};
    for (const [id] of this.drugs) {
      const today = this.getMarketFluctuation(id);
      // Simple trend: compare with yesterday's multiplier
      const yesterday = (() => {
        const d = new Date();
        d.setDate(d.getDate() - 1);
        const dayOfYear = Math.floor((d.getTime() - new Date(d.getFullYear(), 0, 0).getTime()) / 86400000);
        let hash = 0;
        for (let i = 0; i < id.length; i++) hash = (hash * 31 + id.charCodeAt(i)) % 1000;
        return Math.round((1 + Math.sin((dayOfYear * 2.7 + hash) * 1.3) * 0.25) * 100) / 100;
      })();
      const diff = today - yesterday;
      result[id] = {
        multiplier: today,
        trend: diff > 0.02 ? 'up' : diff < -0.02 ? 'down' : 'stable',
      };
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HEAT SYSTEM — police attention from drug activity
  // ─────────────────────────────────────────────────────────────────────────────

  private calcHeatDecay(heat: number, lastActionAt: Date | null): number {
    if (!lastActionAt || heat <= 0) return heat;
    const hoursSince = (Date.now() - lastActionAt.getTime()) / 3600000;
    // -1 heat per 6 hours, max -20 per calculation
    const decay = Math.min(20, Math.floor(hoursSince / 6));
    return Math.max(0, heat - decay);
  }

  async getDrugHeat(playerId: number): Promise<{ heat: number; level: string; raidChance: number }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { drugHeat: true, lastDrugActionAt: true },
    });
    if (!player) return { heat: 0, level: 'Laag', raidChance: 0 };

    const heat = this.calcHeatDecay(player.drugHeat ?? 0, player.lastDrugActionAt);
    return { heat, ...this.heatLevel(heat) };
  }

  private heatLevel(heat: number): { level: string; raidChance: number } {
    if (heat < 20) return { level: 'Laag',    raidChance: 0 };
    if (heat < 40) return { level: 'Matig',   raidChance: 0.05 };
    if (heat < 60) return { level: 'Verhoogd',raidChance: 0.10 };
    if (heat < 80) return { level: 'Hoog',    raidChance: 0.20 };
    return              { level: 'Kritiek',   raidChance: 0.35 };
  }

  private async updateHeat(playerId: number, delta: number): Promise<number> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { drugHeat: true, lastDrugActionAt: true },
    });
    if (!player) return 0;

    const decayed = this.calcHeatDecay(player.drugHeat ?? 0, player.lastDrugActionAt);
    const newHeat = Math.min(100, Math.max(0, decayed + delta));

    await prisma.player.update({
      where: { id: playerId },
      data: { drugHeat: newHeat, lastDrugActionAt: new Date() },
    });
    return newHeat;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // AUTO-COLLECT — VIP feature: collect all ready productions automatically
  // ─────────────────────────────────────────────────────────────────────────────

  async autoCollectAll(playerId: number): Promise<number> {
    const ready = await prisma.drugProduction.findMany({
      where: { playerId, completed: false, finishesAt: { lte: new Date() } },
      select: { id: true },
    });
    let collected = 0;
    for (const prod of ready) {
      const result = await this.collectProduction(playerId, prod.id);
      if (result.success) collected++;
    }
    return collected;
  }

  async toggleAutoCollect(
    playerId: number
  ): Promise<{ success: boolean; enabled: boolean; message: string }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { isVip: true, autoCollectDrugs: true },
    });
    if (!player) return { success: false, enabled: false, message: 'Speler niet gevonden' };
    if (!player.isVip) {
      return { success: false, enabled: false, message: 'Auto-ophalen is een VIP-functie' };
    }
    const newVal = !player.autoCollectDrugs;
    await prisma.player.update({ where: { id: playerId }, data: { autoCollectDrugs: newVal } });
    return {
      success: true,
      enabled: newVal,
      message: newVal ? 'Auto-ophalen ingeschakeld' : 'Auto-ophalen uitgeschakeld',
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DRUG CUTTING — reduce quality for more units
  // ─────────────────────────────────────────────────────────────────────────────

  async cutDrugs(
    playerId: number,
    drugType: string,
    quality: string,
    quantity: number
  ): Promise<{ success: boolean; message: string; newQuantity?: number; newQuality?: string }> {
    const qualityOrder = ['D', 'C', 'B', 'A', 'S'];
    const cutBonuses: Record<string, number> = { S: 0.60, A: 0.50, B: 0.40, C: 0.30 };
    const idx = qualityOrder.indexOf(quality);

    if (idx <= 0) {
      return { success: false, message: 'D-kwaliteit drugs kunnen niet verder worden gesneden' };
    }

    const drug = this.drugs.get(drugType);
    if (!drug) return { success: false, message: 'Onbekend drug type' };

    const inventory = await prisma.drugInventory.findUnique({
      where: { playerId_drugType_quality: { playerId, drugType, quality } },
    });

    if (!inventory || inventory.quantity < quantity) {
      return {
        success: false,
        message: `Je hebt niet genoeg ${drug.displayName} (${quality}) om te snijden`,
      };
    }

    const bonus = cutBonuses[quality] ?? 0.30;
    const newQuantity = Math.round(quantity * (1 + bonus));
    const newQuality = qualityOrder[idx - 1];

    await prisma.$transaction(async (tx) => {
      // Deduct source
      if (inventory.quantity === quantity) {
        await tx.drugInventory.delete({
          where: { playerId_drugType_quality: { playerId, drugType, quality } },
        });
      } else {
        await tx.drugInventory.update({
          where: { playerId_drugType_quality: { playerId, drugType, quality } },
          data: { quantity: inventory.quantity - quantity },
        });
      }
      // Add cut result
      const existing = await tx.drugInventory.findUnique({
        where: { playerId_drugType_quality: { playerId, drugType, quality: newQuality } },
      });
      if (existing) {
        await tx.drugInventory.update({
          where: { playerId_drugType_quality: { playerId, drugType, quality: newQuality } },
          data: { quantity: existing.quantity + newQuantity },
        });
      } else {
        await tx.drugInventory.create({
          data: { playerId, drugType, quality: newQuality, quantity: newQuantity },
        });
      }
    });

    // Cutting adds minor heat
    await this.updateHeat(playerId, 3);

    return {
      success: true,
      message: `${quantity}g ${drug.displayName} (${quality}) gesneden → ${newQuantity}g ${newQuality} (+${Math.round(bonus * 100)}%)`,
      newQuantity,
      newQuality,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ANALYTICS / STATS
  // ─────────────────────────────────────────────────────────────────────────────

  async getDrugStats(playerId: number): Promise<any> {
    const [productions, inventory, facilities, player] = await Promise.all([
      prisma.drugProduction.findMany({ where: { playerId }, select: { drugType: true, quantity: true, quality: true, completed: true, collected: true, startedAt: true, finishesAt: true } }),
      prisma.drugInventory.findMany({ where: { playerId } }),
      prisma.drugFacility.findMany({ where: { playerId }, include: { upgrades: true } }),
      prisma.player.findUnique({ where: { id: playerId }, select: { drugHeat: true, lastDrugActionAt: true, isVip: true, autoCollectDrugs: true, currentCountry: true } }),
    ]);

    // Totals by drug
    const byDrug: Record<string, { produced: number; inStock: number }> = {};
    for (const p of productions.filter((p) => p.completed)) {
      byDrug[p.drugType] = byDrug[p.drugType] ?? { produced: 0, inStock: 0 };
      byDrug[p.drugType].produced += p.quantity;
    }
    for (const i of inventory) {
      byDrug[i.drugType] = byDrug[i.drugType] ?? { produced: 0, inStock: 0 };
      byDrug[i.drugType].inStock += i.quantity;
    }

    const totalProduced = Object.values(byDrug).reduce((s, d) => s + d.produced, 0);
    const totalInStock  = Object.values(byDrug).reduce((s, d) => s + d.inStock, 0);
    const bestDrug = Object.entries(byDrug).sort((a, b) => b[1].produced - a[1].produced)[0]?.[0] ?? null;

    // Facility efficiency
    const totalSlots = facilities.reduce((s, f) => s + f.slots, 0);
    const activeCount = productions.filter((p) => !p.completed && p.finishesAt > new Date()).length;
    const efficiency = totalSlots > 0 ? Math.round((activeCount / totalSlots) * 100) : 0;

    const heat = this.calcHeatDecay(player?.drugHeat ?? 0, player?.lastDrugActionAt ?? null);
    const heatInfo = this.heatLevel(heat);

    return {
      totalProduced,
      totalInStock,
      bestDrug,
      bestDrugName: bestDrug ? (this.drugs.get(bestDrug)?.displayName ?? bestDrug) : null,
      byDrug,
      activeProductions: activeCount,
      facilityCount: facilities.length,
      totalSlots,
      efficiency,
      heat,
      heatLevel: heatInfo.level,
      raidChance: heatInfo.raidChance,
      isVip: player?.isVip ?? false,
      autoCollectEnabled: player?.autoCollectDrugs ?? false,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CREW BONUS helper — called from startProduction
  // ─────────────────────────────────────────────────────────────────────────────

  async getCrewDrugBonus(playerId: number): Promise<{ yieldBonus: number; speedBonus: number }> {
    try {
      const membership = await prisma.crewMember.findUnique({
        where: { playerId },
        include: { crew: { include: { hqBuilding: true } } },
      });
      if (!membership?.crew?.hqBuilding) return { yieldBonus: 0, speedBonus: 0 };
      const hqLevel = membership.crew.hqBuilding.level ?? 0;
      // +2% yield and +1% speed per HQ level, caps at level 10
      const effectiveLevel = Math.min(hqLevel, 10);
      return {
        yieldBonus: effectiveLevel * 0.02,
        speedBonus: effectiveLevel * 0.01,
      };
    } catch {
      return { yieldBonus: 0, speedBonus: 0 };
    }
  }
}

export default new DrugService();
