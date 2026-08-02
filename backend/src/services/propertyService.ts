import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';
import { worldEventService } from './worldEventService';
import { timeProvider } from '../utils/timeProvider';
import { activityService } from './activityService';
import { getOrCreateBankAccount } from './bankService';

interface PropertyDefinition {
  id: string;
  name: string;
  description: string;
  image: string;
  type: 'unique_per_country' | 'limited_per_country' | 'unlimited';
  maxOwners?: number;
  basePrice: number;
  baseIncome: number;
  incomeInterval: number;
  minLevel: number;
  features: string[];
  upgradeOptions: Array<{
    level: number;
    cost: number;
    incomeBonus: number;
  }>;
}

interface PropertiesData {
  properties: PropertyDefinition[];
}

class PropertyService {
  private properties: PropertyDefinition[] = [];
  private readonly hiddenPropertyIds = new Set(['shop']);
  private readonly scaledResidentialTypes = new Set(['house', 'apartment']);

  constructor() {
    this.loadProperties();
  }

  private loadProperties() {
    const propertiesPath = join(__dirname, '../../content/properties.json');
    const propertiesData = readFileSync(propertiesPath, 'utf-8');
    const data: PropertiesData = JSON.parse(propertiesData);
    this.properties = data.properties;
  }

  /**
   * Get all property definitions
   */
  getAllProperties(): PropertyDefinition[] {
    return this.properties.filter((property) => !this.hiddenPropertyIds.has(property.id));
  }

  private isPropertyVisibleInPropertiesModule(propertyId: string): boolean {
    return !this.hiddenPropertyIds.has(propertyId);
  }

  private isScaledResidentialProperty(propertyId: string): boolean {
    return this.scaledResidentialTypes.has(propertyId);
  }

  private getScaledPurchasePrice(basePrice: number, existingCountInCountry: number): number {
    const safeCount = Math.max(0, Math.floor(existingCountInCountry));
    const multiplier = 1 + (safeCount * 0.2);
    return Math.max(basePrice, Math.round(basePrice * multiplier));
  }

  private getScaledUpgradeCost(baseCost: number, ownedCountInCountry: number): number {
    const safeCount = Math.max(1, Math.floor(ownedCountInCountry));
    const extraOwned = Math.max(0, safeCount - 1);
    const multiplier = 1 + (extraOwned * 0.12);
    return Math.max(baseCost, Math.round(baseCost * multiplier));
  }

  /**
   * Get property definition by ID
   */
  getPropertyDefinition(propertyId: string): PropertyDefinition | undefined {
    return this.properties.find((p) => p.id === propertyId);
  }

  /**
   * Get available properties for a specific country
   * Returns property availability status
   */
  async getAvailableProperties(countryId: string, playerId?: number): Promise<
    Array<{
      property: PropertyDefinition;
      available: boolean;
      ownedBy?: number;
      ownedCount?: number;
      slotsAvailable?: number;
    }>
  > {
    const result = [];

    let playerResidentialCountInCountry = 0;
    if (typeof playerId === 'number' && playerId > 0) {
      playerResidentialCountInCountry = await prisma.property.count({
        where: {
          playerId,
          countryId,
          propertyType: { in: Array.from(this.scaledResidentialTypes) },
        },
      });
    }

    for (const property of this.properties) {
      if (!this.isPropertyVisibleInPropertiesModule(property.id)) {
        continue;
      }

      if (property.type === 'unique_per_country') {
        // Casino: Only 1 per country
        const existingOwner = await prisma.property.findFirst({
          where: {
            propertyId: `${property.id}_${countryId}`,
            countryId,
          },
          select: { playerId: true },
        });

        const adjustedProperty = this.isScaledResidentialProperty(property.id)
          ? {
              ...property,
              basePrice: this.getScaledPurchasePrice(property.basePrice, playerResidentialCountInCountry),
            }
          : property;

        result.push({
          property: adjustedProperty,
          available: !existingOwner,
          ownedBy: existingOwner?.playerId,
        });
      } else if (property.type === 'limited_per_country') {
        // Warehouse/Nightclub: Limited slots per country
        const ownedCount = await prisma.property.count({
          where: {
            propertyType: property.id,
            countryId,
          },
        });

        const maxOwners = property.maxOwners || 1;
        const slotsAvailable = maxOwners - ownedCount;

        const adjustedProperty = this.isScaledResidentialProperty(property.id)
          ? {
              ...property,
              basePrice: this.getScaledPurchasePrice(property.basePrice, playerResidentialCountInCountry),
            }
          : property;

        result.push({
          property: adjustedProperty,
          available: slotsAvailable > 0,
          ownedCount,
          slotsAvailable,
        });
      } else {
        // Unlimited: Always available
        const adjustedProperty = this.isScaledResidentialProperty(property.id)
          ? {
              ...property,
              basePrice: this.getScaledPurchasePrice(property.basePrice, playerResidentialCountInCountry),
            }
          : property;

        result.push({
          property: adjustedProperty,
          available: true,
        });
      }
    }

    return result;
  }

  /**
   * Check if a specific property slot is available
   */
  async checkAvailability(
    propertyId: string,
    countryId: string,
    slotNumber?: number
  ): Promise<{ available: boolean; reason?: string }> {
    const property = this.getPropertyDefinition(propertyId);

    if (!property) {
      return { available: false, reason: 'PROPERTY_NOT_FOUND' };
    }

    if (property.type === 'unique_per_country') {
      const fullPropertyId = `${propertyId}_${countryId}`;
      const existingOwner = await prisma.property.findUnique({
        where: { propertyId: fullPropertyId },
      });

      return {
        available: !existingOwner,
        reason: existingOwner ? 'ALREADY_OWNED' : undefined,
      };
    } else if (property.type === 'limited_per_country') {
      const ownedCount = await prisma.property.count({
        where: {
          propertyType: propertyId,
          countryId,
        },
      });

      const maxOwners = property.maxOwners || 1;

      if (slotNumber !== undefined) {
        // Check specific slot
        const fullPropertyId = `${propertyId}_${slotNumber}_${countryId}`;
        const existingOwner = await prisma.property.findUnique({
          where: { propertyId: fullPropertyId },
        });

        return {
          available: !existingOwner,
          reason: existingOwner ? 'SLOT_TAKEN' : undefined,
        };
      }

      return {
        available: ownedCount < maxOwners,
        reason: ownedCount >= maxOwners ? 'ALL_SLOTS_TAKEN' : undefined,
      };
    }

    // Unlimited type - always available
    return { available: true };
  }

  /**
   * Claim a property
   */
  async claimProperty(
    playerId: number,
    propertyId: string,
    countryId: string,
    slotNumber?: number
  ): Promise<{
    success: boolean;
    property?: any;
    error?: string;
  }> {
    if (!this.isPropertyVisibleInPropertiesModule(propertyId)) {
      return { success: false, error: 'PROPERTY_DISABLED' };
    }

    const property = this.getPropertyDefinition(propertyId);

    if (!property) {
      return { success: false, error: 'PROPERTY_NOT_FOUND' };
    }

    // Get player
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { rank: true, money: true, currentCountry: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Check level requirement
    if (player.rank < property.minLevel) {
      return { success: false, error: 'LEVEL_TOO_LOW' };
    }

    const residentialOwnedInCountry = this.isScaledResidentialProperty(propertyId)
      ? await prisma.property.count({
          where: {
            playerId,
            countryId,
            propertyType: { in: Array.from(this.scaledResidentialTypes) },
          },
        })
      : 0;

    const purchasePrice = this.isScaledResidentialProperty(propertyId)
      ? this.getScaledPurchasePrice(property.basePrice, residentialOwnedInCountry)
      : property.basePrice;

    // Check if player has enough money
    if (player.money < purchasePrice) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    // Check if player is in the correct country (only for country-specific properties)
    if (property.type !== 'unlimited' && player.currentCountry !== countryId) {
      return { success: false, error: 'WRONG_COUNTRY' };
    }

    // Generate full property ID
    let fullPropertyId: string;
    if (property.type === 'unique_per_country') {
      fullPropertyId = `${propertyId}_${countryId}`;
    } else if (property.type === 'limited_per_country') {
      if (slotNumber === undefined) {
        // Find first available slot
        const maxOwners = property.maxOwners || 1;
        let foundSlot = false;
        for (let i = 1; i <= maxOwners; i++) {
          const testPropertyId = `${propertyId}_${i}_${countryId}`;
          const existing = await prisma.property.findUnique({
            where: { propertyId: testPropertyId },
          });
          if (!existing) {
            slotNumber = i;
            foundSlot = true;
            break;
          }
        }
        if (!foundSlot) {
          return { success: false, error: 'ALL_SLOTS_TAKEN' };
        }
      }
      fullPropertyId = `${propertyId}_${slotNumber}_${countryId}`;
    } else {
      // Unlimited - use unique timestamp
      fullPropertyId = `${propertyId}_${playerId}_${Date.now()}`;
    }

    // Check availability one more time (race condition protection)
    const availability = await this.checkAvailability(propertyId, countryId, slotNumber);
    if (!availability.available && property.type !== 'unlimited') {
      return { success: false, error: availability.reason };
    }

    // Create property in transaction
    try {
      const result = await prisma.$transaction(async (tx: any) => {
        // Deduct money
        await tx.player.update({
          where: { id: playerId },
          data: { money: { decrement: purchasePrice } },
        });

        // Create property
        const newProperty = await tx.property.create({
          data: {
            playerId,
            propertyId: fullPropertyId,
            countryId,
            propertyType: propertyId,
            purchasePrice,
            upgradeLevel: 1,
            lastIncomeAt: timeProvider.now(),
            purchasedAt: timeProvider.now(),
          },
        });

        if (propertyId === 'nightclub') {
          await tx.nightclubVenue.create({
            data: {
              propertyId: newProperty.id,
              playerId,
              country: countryId,
              crowdSize: 30,
              crowdVibe: 'chill',
            },
          });
        }

        return newProperty;
      });

      // Create world event
      await worldEventService.createEvent(
        'property.claimed',
        {
          propertyName: property.name,
          propertyType: propertyId,
          country: countryId,
          price: purchasePrice,
        },
        playerId
      );

      // Log player activity
      await activityService.logActivity(
        playerId,
        'PURCHASE',
        `Kocht eigendom: ${property.name} in ${countryId}`,
        {
          propertyType: propertyId,
          propertyName: property.name,
          country: countryId,
          price: purchasePrice,
          propertyDbId: result.id,
        }
      );

      return { success: true, property: result };
    } catch (error: any) {
      if (error.code === 'P2002') {
        // Unique constraint violation
        return { success: false, error: 'PROPERTY_ALREADY_CLAIMED' };
      }
      throw error;
    }
  }

  /**
   * Get player's owned properties
   */
  async getOwnedProperties(playerId: number) {
    const developCfg = await this.getDevelopmentConfig();
    const properties = await prisma.property.findMany({
      where: { playerId },
      orderBy: { purchasedAt: 'desc' },
    });

    // Build per-property purchase-order rank within each country.
    // Apartment bought 1st → rank 1 (cheapest upgrades), 2nd → rank 2, etc.
    const residentialByCountry: Record<string, Array<{ id: number; purchasedAt: Date }>> = {};
    for (const prop of properties) {
      if (this.isScaledResidentialProperty(prop.propertyType)) {
        if (!residentialByCountry[prop.countryId]) {
          residentialByCountry[prop.countryId] = [];
        }
        residentialByCountry[prop.countryId].push({ id: prop.id, purchasedAt: prop.purchasedAt });
      }
    }
    const residentialRankByPropertyId: Record<number, number> = {};
    for (const props of Object.values(residentialByCountry)) {
      const sorted = [...props].sort((a, b) => a.purchasedAt.getTime() - b.purchasedAt.getTime());
      sorted.forEach((p, idx) => {
        residentialRankByPropertyId[p.id] = idx + 1;
      });
    }

    return properties
      .filter((prop) => this.isPropertyVisibleInPropertiesModule(prop.propertyType))
      .map((prop) => {
      const definition = this.getPropertyDefinition(prop.propertyType);
      const overlayKeys = this.getPropertyOverlays(prop);
      
      // Calculate total income (base + all upgrades up to current level)
      let totalIncome = definition?.baseIncome || 0;
      if (definition && definition.upgradeOptions) {
        for (let i = 2; i <= prop.upgradeLevel; i++) {
          const upgrade = definition.upgradeOptions.find((opt: any) => opt.level === i);
          if (upgrade) {
            totalIncome += upgrade.incomeBonus;
          }
        }
      }
      const developmentLevel = Math.max(
        0,
        Number((prop as { developmentLevel?: number | null }).developmentLevel ?? 0),
      );
      const developedIncome = Math.floor(
        totalIncome * (1 + (developmentLevel * developCfg.incomeBonusPercentPerLevel / 100)),
      );
      const nextDevelopCost = developmentLevel >= developCfg.maxLevel
        ? null
        : Math.max(
            1000,
            Math.floor(prop.purchasePrice * (developCfg.costPercent / 100) * (developmentLevel + 1)),
          );

      // Find next upgrade cost
      let nextUpgradeCost = null;
      if (definition && definition.upgradeOptions) {
        const nextUpgrade = definition.upgradeOptions.find(
          (opt: any) => opt.level === prop.upgradeLevel + 1
        );
        const baseNextCost = nextUpgrade?.cost || null;
        if (baseNextCost && this.isScaledResidentialProperty(prop.propertyType)) {
          const ownedCountInCountry = residentialRankByPropertyId[prop.id] ?? 1;
          nextUpgradeCost = this.getScaledUpgradeCost(baseNextCost, ownedCountInCountry);
        } else {
          nextUpgradeCost = baseNextCost;
        }
      }
      
      return {
        ...prop,
        name: definition?.name || 'Unknown',
        description: definition?.description || '',
        baseIncome: developedIncome,
        incomeInterval: definition?.incomeInterval || 60,
        imagePath: definition?.image || null,
        overlayKeys,
        nextUpgradeCost,
        developmentLevel,
        nextDevelopCost,
        developMaxLevel: developCfg.maxLevel,
        developIncomeBonusPercentPerLevel: developCfg.incomeBonusPercentPerLevel,
      };
      });
  }

  /**
   * Determine which overlay images should be shown for a property
   */
  private getPropertyOverlays(property: any): string[] {
    const overlays: string[] = [];

    // Upgrade level overlays
    if (property.upgradeLevel > 1) {
      overlays.push(`upgraded_lvl${property.upgradeLevel}`);
    }

    // Recent purchase (within last hour)
    const hoursSincePurchase = (Date.now() - property.purchasedAt.getTime()) / (1000 * 60 * 60);
    if (hoursSincePurchase < 1) {
      overlays.push('new');
    }

    // Income ready (can collect)
    const definition = this.getPropertyDefinition(property.propertyType);
    if (definition) {
      const minutesSinceLastIncome = 
        (Date.now() - property.lastIncomeAt.getTime()) / (1000 * 60);
      
      if (minutesSinceLastIncome >= definition.incomeInterval) {
        overlays.push('income_ready');
      }
    }

    return overlays;
  }

  /**
   * Forfeit (abandon) a property
   */
  async forfeitProperty(playerId: number, propertyDatabaseId: number): Promise<boolean> {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });

    if (!property) {
      throw new Error('PROPERTY_NOT_FOUND');
    }

    if (property.playerId !== playerId) {
      throw new Error('NOT_PROPERTY_OWNER');
    }

    await prisma.property.delete({
      where: { id: propertyDatabaseId },
    });

    await worldEventService.createEvent(
      'property.forfeited',
      {
        propertyType: property.propertyType,
        country: property.countryId,
      },
      playerId
    );

    return true;
  }

  /**
   * Auto-forfeit properties when player dies or is jailed >24 hours
   */
  async checkAutoForfeit(playerId: number): Promise<void> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { health: true },
    });

    if (!player) return;

    // Check if player is dead
    const isDead = player.health === 0;

    if (isDead) {
      // Forfeit all properties
      await prisma.property.deleteMany({
        where: { playerId },
      });

      await worldEventService.createEvent('property.auto_forfeited_death', {}, playerId);
      return;
    }

    // Check if jailed > 24 hours
    const latestJailAttempt = await prisma.crimeAttempt.findFirst({
      where: {
        playerId,
        jailed: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        createdAt: true,
        jailTime: true,
      },
    });

    if (latestJailAttempt) {
      const releaseTime = new Date(
        latestJailAttempt.createdAt.getTime() + latestJailAttempt.jailTime * 60 * 1000
      );
      const now = timeProvider.now();

      // Still in jail and jail time > 24 hours (1440 minutes)
      if (releaseTime > now && latestJailAttempt.jailTime > 1440) {
        // Forfeit all properties
        await prisma.property.deleteMany({
          where: { playerId },
        });

        await worldEventService.createEvent('property.auto_forfeited_jail', {}, playerId);
      }
    }
  }

  /**
   * Collect income from a property
   */
  async collectIncome(
    playerId: number,
    propertyDatabaseId: number
  ): Promise<{
    success: boolean;
    income?: number;
    newMoney?: number;
    error?: string;
  }> {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });

    if (!property) {
      return { success: false, error: 'PROPERTY_NOT_FOUND' };
    }

    if (property.playerId !== playerId) {
      return { success: false, error: 'NOT_PROPERTY_OWNER' };
    }

    const definition = this.getPropertyDefinition(property.propertyType);
    if (!definition) {
      return { success: false, error: 'PROPERTY_DEFINITION_NOT_FOUND' };
    }

    // Calculate time elapsed since last income collection
    const now = timeProvider.now();
    const lastCollectionTime = property.lastIncomeAt;
    const timeElapsedMinutes = Math.floor((now.getTime() - lastCollectionTime.getTime()) / 60000);

    // Check if enough time has passed (income interval)
    if (timeElapsedMinutes < definition.incomeInterval) {
      return { 
        success: false, 
        error: 'TOO_SOON',
      };
    }

    // Calculate income based on upgrade level
    let totalIncome = definition.baseIncome;

    // Add bonuses from upgrades
    if (property.upgradeLevel > 1) {
      const upgradeOptions = definition.upgradeOptions || [];
      for (let i = 0; i < property.upgradeLevel - 1; i++) {
        const upgrade = upgradeOptions[i];
        if (upgrade) {
          totalIncome += upgrade.incomeBonus;
        }
      }
    }

    // Calculate how many income intervals have passed
    const intervalsElapsed = Math.floor(timeElapsedMinutes / definition.incomeInterval);
    const developmentLevel = Math.max(
      0,
      Number((property as { developmentLevel?: number | null }).developmentLevel ?? 0),
    );
    const developBonusPercent = await this.getDevelopmentIncomeBonusPercent();
    const developMultiplier = 1 + (developmentLevel * developBonusPercent / 100);
    const income = Math.floor(totalIncome * intervalsElapsed * developMultiplier);

    // Update player money and property lastIncomeAt in transaction
    const result = await prisma.$transaction(async (tx: any) => {
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: income } },
        select: { money: true },
      });

      await tx.property.update({
        where: { id: propertyDatabaseId },
        data: { lastIncomeAt: now },
      });

      return updatedPlayer;
    });

    // Create world event
    await worldEventService.createEvent(
      'property.income_collected',
      {
        propertyType: property.propertyType,
        income,
      },
      playerId
    );

    return {
      success: true,
      income,
      newMoney: result.money,
    };
  }

  /**
   * Upgrade a property to the next level
   */
  async upgradeProperty(
    playerId: number,
    propertyDatabaseId: number
  ): Promise<{
    success: boolean;
    newLevel?: number;
    cost?: number;
    newIncome?: number;
    error?: string;
  }> {
    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });

    if (!property) {
      return { success: false, error: 'PROPERTY_NOT_FOUND' };
    }

    if (property.playerId !== playerId) {
      return { success: false, error: 'NOT_PROPERTY_OWNER' };
    }

    const definition = this.getPropertyDefinition(property.propertyType);
    if (!definition) {
      return { success: false, error: 'PROPERTY_DEFINITION_NOT_FOUND' };
    }

    // Check if already at max level
    const upgradeOptions = definition.upgradeOptions || [];
    if (property.upgradeLevel >= upgradeOptions.length + 1) {
      return { success: false, error: 'MAX_LEVEL_REACHED' };
    }

    // Get the upgrade for the next level
    const nextUpgrade = upgradeOptions[property.upgradeLevel - 1];
    if (!nextUpgrade) {
      return { success: false, error: 'UPGRADE_NOT_AVAILABLE' };
    }

    // Get player money
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!player) {
      return { success: false, error: 'PLAYER_NOT_FOUND' };
    }

    // Check if player has enough money
    const ownedCountInCountry = this.isScaledResidentialProperty(property.propertyType)
      ? await prisma.property.count({
          where: {
            playerId,
            countryId: property.countryId,
            propertyType: { in: Array.from(this.scaledResidentialTypes) },
          },
        })
      : 1;

    const upgradeCost = this.isScaledResidentialProperty(property.propertyType)
      ? this.getScaledUpgradeCost(nextUpgrade.cost, ownedCountInCountry)
      : nextUpgrade.cost;

    if (player.money < upgradeCost) {
      return { success: false, error: 'INSUFFICIENT_MONEY' };
    }

    // Calculate new total income
    let newTotalIncome = definition.baseIncome;
    for (let i = 0; i < property.upgradeLevel; i++) {
      const upgrade = upgradeOptions[i];
      if (upgrade) {
        newTotalIncome += upgrade.incomeBonus;
      }
    }

    const newLevel = property.upgradeLevel + 1;

    // Perform upgrade in transaction
    await prisma.$transaction(async (tx: any) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: upgradeCost } },
      });

      await tx.property.update({
        where: { id: propertyDatabaseId },
        data: { upgradeLevel: newLevel },
      });
    });

    // Create world event
    await worldEventService.createEvent(
      'property.upgraded',
      {
        propertyType: property.propertyType,
        newLevel,
        cost: upgradeCost,
      },
      playerId
    );

    return {
      success: true,
      newLevel,
      cost: upgradeCost,
      newIncome: newTotalIncome,
    };
  }

  /**
   * Forfeit all properties owned by a player
   * Called when player dies or is in jail >24 hours
   */
  async forfeitAllProperties(playerId: number): Promise<number> {
    const properties = await prisma.property.findMany({
      where: { playerId },
    });

    if (properties.length === 0) {
      return 0;
    }

    // Delete all properties (they become available again)
    await prisma.property.deleteMany({
      where: { playerId },
    });

    // Create world event for each forfeited property
    for (const property of properties) {
      await worldEventService.createEvent(
        'property.forfeited',
        {
          propertyId: property.propertyId,
          propertyType: property.propertyType,
          countryId: property.countryId,
          reason: 'death_or_imprisonment',
        },
        playerId
      );
    }

    console.log(`🏚️  Forfeited ${properties.length} properties from player ${playerId}`);

    return properties.length;
  }

  /**
   * Check if a specific player should forfeit properties
   * Returns number of properties forfeited
   */
  async checkPlayerForfeiture(playerId: number): Promise<number> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        id: true,
        username: true,
        health: true,
        jailRelease: true,
      },
    });

    if (!player) {
      return 0;
    }

    let shouldForfeit = false;
    let reason = '';

    // Check if player is dead
    if (player.health <= 0) {
      shouldForfeit = true;
      reason = 'death';
    }

    // Check if player is in jail for >24 hours
    if (player.jailRelease) {
      const now = timeProvider.now();
      
      // If jailRelease is in the FUTURE, player is still in jail
      // If it's been >24 hours, forfeit properties
      if (player.jailRelease > now) {
        const jailDuration = (player.jailRelease.getTime() - now.getTime()) / (1000 * 60 * 60);
        if (jailDuration > 24) {
          shouldForfeit = true;
          reason = 'long_imprisonment';
        }
      }
    }

    if (shouldForfeit) {
      console.log(`⚠️  Player ${player.username} forfeiting properties (reason: ${reason})`);
      return await this.forfeitAllProperties(playerId);
    }

    return 0;
  }

  private async getDevelopmentConfig() {
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config
       WHERE configKey IN (
         'PROPERTY_DEVELOP_ENABLED',
         'PROPERTY_DEVELOP_MAX_LEVEL',
         'PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE',
         'PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL',
         'PROPERTY_DEVELOP_COOLDOWN_SECONDS'
       )`,
    );
    const cfg = rows.reduce<Record<string, string>>((acc, row) => {
      acc[row.configKey] = row.configValue;
      return acc;
    }, {});
    return {
      enabled: Number(cfg.PROPERTY_DEVELOP_ENABLED ?? 1) === 1,
      maxLevel: Math.max(1, Math.floor(Number(cfg.PROPERTY_DEVELOP_MAX_LEVEL ?? 5))),
      costPercent: Math.max(1, Number(cfg.PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE ?? 25)),
      incomeBonusPercentPerLevel: Math.max(0, Number(cfg.PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL ?? 8)),
      cooldownSeconds: Math.max(0, Math.floor(Number(cfg.PROPERTY_DEVELOP_COOLDOWN_SECONDS ?? 3600))),
    };
  }

  private async getDevelopmentIncomeBonusPercent(): Promise<number> {
    const cfg = await this.getDevelopmentConfig();
    return cfg.incomeBonusPercentPerLevel;
  }

  async developProperty(
    playerId: number,
    propertyDatabaseId: number,
  ): Promise<{
    success: boolean;
    developmentLevel?: number;
    cost?: number;
    bankBalance?: number;
    error?: string;
  }> {
    const cfg = await this.getDevelopmentConfig();
    if (!cfg.enabled) {
      return { success: false, error: 'PROPERTY_DEVELOP_DISABLED' };
    }

    const property = await prisma.property.findUnique({
      where: { id: propertyDatabaseId },
    });
    if (!property) return { success: false, error: 'PROPERTY_NOT_FOUND' };
    if (property.playerId !== playerId) return { success: false, error: 'NOT_PROPERTY_OWNER' };

    const developmentLevel = Math.max(
      0,
      Number((property as { developmentLevel?: number | null }).developmentLevel ?? 0),
    );
    if (developmentLevel >= cfg.maxLevel) {
      return { success: false, error: 'PROPERTY_DEVELOP_MAX_LEVEL' };
    }

    const lastDevelopAt = (property as { lastDevelopAt?: Date | null }).lastDevelopAt ?? null;
    if (lastDevelopAt && cfg.cooldownSeconds > 0) {
      const elapsed = Math.floor((Date.now() - new Date(lastDevelopAt).getTime()) / 1000);
      if (elapsed < cfg.cooldownSeconds) {
        return { success: false, error: 'PROPERTY_DEVELOP_COOLDOWN' };
      }
    }

    const cost = Math.max(
      1000,
      Math.floor(property.purchasePrice * (cfg.costPercent / 100) * (developmentLevel + 1)),
    );
    const account = await getOrCreateBankAccount(playerId);
    if (account.balance < cost) {
      return { success: false, error: 'INSUFFICIENT_BALANCE' };
    }

    const nextLevel = developmentLevel + 1;
    const updatedAccount = await prisma.$transaction(async (tx) => {
      const bankUpdate = await tx.bankAccount.updateMany({
        where: { id: account.id, balance: { gte: cost } },
        data: { balance: { decrement: cost } },
      });
      if (bankUpdate.count !== 1) {
        throw new Error('INSUFFICIENT_BALANCE');
      }
      await tx.$executeRawUnsafe(
        `UPDATE properties
         SET developmentLevel = ?, lastDevelopAt = NOW()
         WHERE id = ? AND playerId = ?`,
        nextLevel,
        propertyDatabaseId,
        playerId,
      );
      return tx.bankAccount.findUnique({ where: { id: account.id }, select: { balance: true } });
    });

    await activityService.logActivity(
      playerId,
      'property.developed',
      'Property development completed',
      { propertyId: propertyDatabaseId, developmentLevel: nextLevel, cost },
      false,
    ).catch(() => {});

    return {
      success: true,
      developmentLevel: nextLevel,
      cost,
      bankBalance: updatedAccount?.balance ?? account.balance - cost,
    };
  }
}

export const propertyService = new PropertyService();
