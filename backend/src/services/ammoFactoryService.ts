import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';
import { educationService } from './educationService';

interface CountryDef {
  id: string;
  name: string;
}

interface AmmoDef {
  type: string;
  name: string;
  boxSize: number;
  pricePerRound: number;
}

const PRODUCTION_INTERVAL_MINUTES = 5;
const PRODUCTION_BACKLOG_HOURS = 8;
const INACTIVITY_HOURS = 48;
const MAX_LEVEL = 5;

class AmmoFactoryService {
  private countries: CountryDef[] = [];
  private ammoTypes: AmmoDef[] = [];

  constructor() {
    this.loadCountries();
    this.loadAmmo();
  }

  private loadCountries() {
    const path = join(__dirname, '../../content/countries.json');
    const data = JSON.parse(readFileSync(path, 'utf-8')) as CountryDef[];
    this.countries = data.map((c) => ({ id: c.id, name: c.name }));
  }

  private loadAmmo() {
    const path = join(__dirname, '../../content/ammo.json');
    const data = JSON.parse(readFileSync(path, 'utf-8')) as { ammo: AmmoDef[] };
    this.ammoTypes = data.ammo;
  }

  private getProductionIntervalMs() {
    return PRODUCTION_INTERVAL_MINUTES * 60 * 1000;
  }

  private getBacklogMs() {
    return PRODUCTION_BACKLOG_HOURS * 60 * 60 * 1000;
  }

  private getTicksPerBacklogWindow() {
    return Math.floor(this.getBacklogMs() / this.getProductionIntervalMs());
  }

  private getInactivityMs() {
    return INACTIVITY_HOURS * 60 * 60 * 1000;
  }

  private outputMultiplier(level: number) {
    // Scales from 1.0 (level 1) to ~10.84 (level 5)
    // Target: 400 rounds/hour × 8 hours = 3200 per cycle at max level
    return 1 + (level - 1) * 2.46;
  }

  private qualityMultiplier(qualityLevel: number) {
    return 1 + (qualityLevel - 1) * 0.05;
  }

  async ensureFactoriesExist() {
    for (const country of this.countries) {
      const existing = await prisma.ammoFactory.findUnique({
        where: { countryId: country.id },
      });

      if (!existing) {
        await prisma.ammoFactory.create({
          data: {
            countryId: country.id,
          },
        });
      }

      for (const ammo of this.ammoTypes) {
        const stock = await prisma.ammoMarketStock.findUnique({
          where: {
            countryId_ammoType: {
              countryId: country.id,
              ammoType: ammo.type,
            },
          },
        });

        if (!stock) {
          await prisma.ammoMarketStock.create({
            data: {
              countryId: country.id,
              ammoType: ammo.type,
              quantity: 0,
              quality: 1.0,
            },
          });
        }
      }
    }
  }

  async listFactories() {
    await this.ensureFactoriesExist();

    const ownedFactories = await prisma.ammoFactory.findMany({
      where: { ownerId: { not: null } },
    });

    for (const ownedFactory of ownedFactories) {
      await this.settleProduction(ownedFactory.id, false);
    }

    return prisma.ammoFactory.findMany({
      include: {
        owner: { select: { id: true, username: true } },
      },
      orderBy: { countryId: 'asc' },
    });
  }

  async getPlayerFactory(playerId: number) {
    await this.ensureFactoriesExist();

    const existing = await prisma.ammoFactory.findFirst({
      where: { ownerId: playerId },
      orderBy: { countryId: 'asc' },
    });

    if (existing) {
      await this.settleProduction(existing.id, false);
    }

    return prisma.ammoFactory.findFirst({
      where: { ownerId: playerId },
      orderBy: { countryId: 'asc' },
    });
  }

  private async settleProduction(factoryId: number, enforceCooldown: boolean) {
    const factory = await prisma.ammoFactory.findUnique({
      where: { id: factoryId },
    });

    if (!factory || !factory.ownerId) {
      return { success: false, error: 'FACTORY_NOT_OWNED' as const };
    }

    if (this.isInactive(factory)) {
      await this.revokeFactoriesForPlayer(factory.ownerId);
      return { success: false, error: 'FACTORY_INACTIVE' as const };
    }

    if (!factory.lastProducedAt) {
      return { success: true, factory, processedTicks: 0 };
    }

    const now = new Date();
    const intervalMs = this.getProductionIntervalMs();
    const sessionStart = factory.lastActiveAt
      ? new Date(factory.lastActiveAt)
      : new Date(factory.lastProducedAt);
    const sessionEnd = new Date(sessionStart.getTime() + this.getBacklogMs());

    const referenceProducedAt = new Date(
      Math.max(new Date(factory.lastProducedAt).getTime(), sessionStart.getTime())
    );
    const effectiveNow = new Date(Math.min(now.getTime(), sessionEnd.getTime()));
    const elapsedMs = effectiveNow.getTime() - referenceProducedAt.getTime();

    if (enforceCooldown && now.getTime() < sessionEnd.getTime() && elapsedMs < intervalMs) {
      return {
        success: false,
        error: 'COOLDOWN' as const,
        nextProduction: new Date(referenceProducedAt.getTime() + intervalMs),
      };
    }

    const ticksToProcess = Math.floor(elapsedMs / intervalMs);

    if (ticksToProcess <= 0) {
      return { success: true, factory, processedTicks: 0 };
    }

    const outputMultiplier = this.outputMultiplier(factory.level);
    const qualityMultiplier = this.qualityMultiplier(factory.qualityLevel);
    const ticksPerWindow = this.getTicksPerBacklogWindow();

    for (const ammo of this.ammoTypes) {
      const produced = Math.floor((ammo.boxSize * outputMultiplier * ticksToProcess) / ticksPerWindow);
      if (produced <= 0) {
        continue;
      }

      const stock = await prisma.ammoMarketStock.findUnique({
        where: {
          countryId_ammoType: {
            countryId: factory.countryId,
            ammoType: ammo.type,
          },
        },
      });

      if (!stock) {
        continue;
      }

      const totalQuantity = stock.quantity + produced;
      const newQuality = totalQuantity > 0
        ? ((stock.quality * stock.quantity) + (qualityMultiplier * produced)) / totalQuantity
        : qualityMultiplier;

      await prisma.ammoMarketStock.update({
        where: { id: stock.id },
        data: {
          quantity: totalQuantity,
          quality: newQuality,
        },
      });
    }

    const nextLastProducedAt = new Date(referenceProducedAt.getTime() + ticksToProcess * intervalMs);

    const updatedFactory = await prisma.ammoFactory.update({
      where: { id: factory.id },
      data: {
        lastProducedAt: nextLastProducedAt,
      },
    });

    return { success: true, factory: updatedFactory, processedTicks: ticksToProcess };
  }

  private isInactive(factory: { lastActiveAt: Date | null }) {
    if (!factory.lastActiveAt) {
      return false;
    }
    return Date.now() - factory.lastActiveAt.getTime() > this.getInactivityMs();
  }

  async revokeFactoriesForPlayer(playerId: number) {
    await prisma.ammoFactory.updateMany({
      where: { ownerId: playerId },
      data: {
        ownerId: null,
        level: 1,
        qualityLevel: 1,
        lastActiveAt: null,
        lastProducedAt: null,
      },
    });
  }

  async purchaseFactory(playerId: number, countryId: string) {
    await this.ensureFactoriesExist();

    const factory = await prisma.ammoFactory.findUnique({
      where: { countryId },
    });

    if (!factory) {
      return { success: false, error: 'FACTORY_NOT_FOUND', cost: 0 };
    }

    if (factory.ownerId && factory.ownerId !== playerId) {
      return { success: false, error: 'FACTORY_OWNED', cost: 0 };
    }

    if (factory.ownerId === playerId) {
      return { success: true, factory, cost: 0 };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, rank: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND', cost: 0 };
    }

    const cost = 500000;

    const educationEligibility = await educationService.checkAssetEligibility(
      playerId,
      'ammo_factory_purchase',
      player.rank
    );

    if (!educationEligibility.allowed) {
      return {
        success: false,
        error: 'EDUCATION_REQUIREMENTS_NOT_MET',
        reasonKey: 'ammoFactory.error.education_requirements_not_met',
        gateId: educationEligibility.gateId,
        gateLabelKey: educationEligibility.gateLabelKey,
        missing: educationEligibility.missing,
        cost,
      };
    }

    if (player.money < cost) {
      return { success: false, error: 'INSUFFICIENT_MONEY', cost };
    }

    await prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - cost },
    });

    const updated = await prisma.ammoFactory.update({
      where: { id: factory.id },
      data: {
        ownerId: playerId,
        lastActiveAt: new Date(),
      },
    });

    return { success: true, factory: updated, cost };
  }

  async produce(playerId: number) {
    await this.ensureFactoriesExist();

    const factory = await prisma.ammoFactory.findFirst({
      where: { ownerId: playerId },
    });

    if (!factory) {
      return { success: false, error: 'FACTORY_NOT_OWNED' };
    }

    if (this.isInactive(factory)) {
      await this.revokeFactoriesForPlayer(playerId);
      return { success: false, error: 'FACTORY_INACTIVE' };
    }

    const now = new Date();
    const hasSession = !!factory.lastProducedAt;
    const sessionStart = factory.lastActiveAt
      ? new Date(factory.lastActiveAt)
      : hasSession
        ? new Date(factory.lastProducedAt!)
        : null;
    const sessionEnded = sessionStart
      ? now.getTime() >= sessionStart.getTime() + this.getBacklogMs()
      : true;

    if (!hasSession || sessionEnded) {
      const startedFactory = await prisma.ammoFactory.update({
        where: { id: factory.id },
        data: {
          lastActiveAt: now,
          lastProducedAt: now,
        },
      });

      return {
        success: true,
        factory: startedFactory,
        processedTicks: 0,
        sessionStarted: true,
      };
    }

    const productionResult = await this.settleProduction(factory.id, true);

    if (!productionResult.success) {
      if (productionResult.error === 'COOLDOWN') {
        return {
          success: false,
          error: 'COOLDOWN',
          nextProduction: productionResult.nextProduction,
        };
      }

      if (productionResult.error === 'FACTORY_INACTIVE') {
        return { success: false, error: 'FACTORY_INACTIVE' };
      }

      return { success: false, error: 'FACTORY_NOT_OWNED' };
    }

    return {
      success: true,
      factory: productionResult.factory,
      processedTicks: productionResult.processedTicks,
    };
  }

  async upgradeFactory(playerId: number, upgradeType: 'output' | 'quality') {
    await this.ensureFactoriesExist();

    const factory = await prisma.ammoFactory.findFirst({
      where: { ownerId: playerId },
    });

    if (!factory) {
      return { success: false, error: 'FACTORY_NOT_OWNED', cost: 0 };
    }

    if (this.isInactive(factory)) {
      await this.revokeFactoriesForPlayer(playerId);
      return { success: false, error: 'FACTORY_INACTIVE', cost: 0 };
    }

    const currentLevel = upgradeType === 'output' ? factory.level : factory.qualityLevel;
    if (currentLevel >= MAX_LEVEL) {
      return { success: false, error: 'MAX_LEVEL', cost: 0 };
    }

    const cost = 250000 * currentLevel;

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, rank: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND', cost: 0 };
    }

    const educationTargetId =
      upgradeType === 'output'
        ? 'ammo_factory_upgrade_output'
        : 'ammo_factory_upgrade_quality';

    const educationEligibility = await educationService.checkAssetEligibility(
      playerId,
      educationTargetId,
      player.rank
    );

    if (!educationEligibility.allowed) {
      return {
        success: false,
        error: 'EDUCATION_REQUIREMENTS_NOT_MET',
        reasonKey: 'ammoFactory.error.education_requirements_not_met',
        gateId: educationEligibility.gateId,
        gateLabelKey: educationEligibility.gateLabelKey,
        missing: educationEligibility.missing,
        cost,
      };
    }

    if (player.money < cost) {
      return { success: false, error: 'INSUFFICIENT_MONEY', cost };
    }

    await prisma.player.update({
      where: { id: playerId },
      data: { money: player.money - cost },
    });

    const updated = await prisma.ammoFactory.update({
      where: { id: factory.id },
      data: {
        level: upgradeType === 'output' ? factory.level + 1 : factory.level,
        qualityLevel: upgradeType === 'quality' ? factory.qualityLevel + 1 : factory.qualityLevel,
      },
    });

    return { success: true, factory: updated, cost };
  }
}

export const ammoFactoryService = new AmmoFactoryService();
