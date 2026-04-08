import prisma from '../lib/prisma';
import { checkAndUnlockAchievements, serializeAchievementForClient } from './achievementService';
import { checkIfJailed, increaseWantedLevel, jailPlayer } from './policeService';
import { activityService } from './activityService';
import { propertyService } from './propertyService';
import { increaseFBIHeat } from './fbiService';

const RECRUITMENT_COOLDOWN_MINUTES = 5;
const RECRUITMENT_SUCCESS_CHANCE = 0.75; // 75% kans op succesvolle werving
const RECRUITMENT_LOSS_ON_FAILURE_CHANCE = 0.18; // 18% kans om bij mislukking een dame te verliezen
const STREET_EARNINGS_PER_HOUR = 40; // €40/hour on street (base)

// Leveling System
const XP_PER_HOUR = 5; // XP earned per hour
const XP_PER_LEVEL = 100; // XP needed per level
const MAX_LEVEL = 10;
const EARNINGS_BONUS_PER_LEVEL = 0.05; // 5% bonus per level
const VIP_PROSTITUTE_EARNINGS_MULTIPLIER = 1.5; // VIP dames verdienen 50% meer
const VIP_PROSTITUTE_RECRUIT_CHANCE = 0.4; // 40% kans voor VIP spelers

type ProstitutionBalanceProfile = 'casual' | 'normal' | 'hardcore';

const PROSTITUTION_BALANCE_PROFILE_ENV = 'PROSTITUTION_BALANCE_PROFILE';

const PROSTITUTION_BALANCE_PRESETS: Record<ProstitutionBalanceProfile, {
  betrayalBaseChance: number;
  betrayalPerLostCrew: number;
  betrayalNightclubLossBonus: number;
  betrayalMaxChance: number;
  seizureBase: number;
  seizurePerLoss: number;
  seizureNightclubBonus: number;
  seizureMin: number;
  seizureMax: number;
  licenseBaseChance: number;
  licensePerLoss: number;
  licenseNightclubBonus: number;
  licenseMin: number;
  licenseMax: number;
  wantedBase: number;
  wantedPerLoss: number;
  wantedNightclubBonus: number;
  wantedLicenseBonus: number;
  fbiBase: number;
  fbiPerLoss: number;
  fbiNightclubBonus: number;
  fbiLicenseBonus: number;
  jailBaseMinutes: number;
  jailPerLossMinutes: number;
  jailNightclubBonusMinutes: number;
  jailLicenseBonusMinutes: number;
  housingGraceDays: number;
  housingAtRiskDays: number;
  housingBonusPerUpgradeLevel: number;
  housingBonusMax: number;
  happinessBaseWithHousing: number;
  happinessBaseWithoutHousing: number;
  happinessPerUpgradeLevel: number;
  happinessOverduePenalty: number;
  happinessAtRiskPenalty: number;
  happinessBustedPenalty: number;
  happinessEarningsStep: number;
}> = {
  casual: {
    betrayalBaseChance: 0.06,
    betrayalPerLostCrew: 0.03,
    betrayalNightclubLossBonus: 0.08,
    betrayalMaxChance: 0.35,
    seizureBase: 0.25,
    seizurePerLoss: 0.06,
    seizureNightclubBonus: 0.06,
    seizureMin: 0.20,
    seizureMax: 0.55,
    licenseBaseChance: 0.05,
    licensePerLoss: 0.04,
    licenseNightclubBonus: 0.07,
    licenseMin: 0.05,
    licenseMax: 0.30,
    wantedBase: 4,
    wantedPerLoss: 2,
    wantedNightclubBonus: 2,
    wantedLicenseBonus: 3,
    fbiBase: 1,
    fbiPerLoss: 1,
    fbiNightclubBonus: 1,
    fbiLicenseBonus: 2,
    jailBaseMinutes: 25,
    jailPerLossMinutes: 10,
    jailNightclubBonusMinutes: 12,
    jailLicenseBonusMinutes: 18,
    housingGraceDays: 10,
    housingAtRiskDays: 3,
    housingBonusPerUpgradeLevel: 7,
    housingBonusMax: 30,
    happinessBaseWithHousing: 56,
    happinessBaseWithoutHousing: 26,
    happinessPerUpgradeLevel: 16,
    happinessOverduePenalty: 26,
    happinessAtRiskPenalty: 9,
    happinessBustedPenalty: 12,
    happinessEarningsStep: 0.003,
  },
  normal: {
    betrayalBaseChance: 0.10,
    betrayalPerLostCrew: 0.05,
    betrayalNightclubLossBonus: 0.15,
    betrayalMaxChance: 0.55,
    seizureBase: 0.35,
    seizurePerLoss: 0.10,
    seizureNightclubBonus: 0.10,
    seizureMin: 0.35,
    seizureMax: 0.80,
    licenseBaseChance: 0.10,
    licensePerLoss: 0.08,
    licenseNightclubBonus: 0.12,
    licenseMin: 0.10,
    licenseMax: 0.55,
    wantedBase: 6,
    wantedPerLoss: 3,
    wantedNightclubBonus: 4,
    wantedLicenseBonus: 6,
    fbiBase: 2,
    fbiPerLoss: 2,
    fbiNightclubBonus: 2,
    fbiLicenseBonus: 3,
    jailBaseMinutes: 35,
    jailPerLossMinutes: 15,
    jailNightclubBonusMinutes: 20,
    jailLicenseBonusMinutes: 30,
    housingGraceDays: 7,
    housingAtRiskDays: 2,
    housingBonusPerUpgradeLevel: 6,
    housingBonusMax: 24,
    happinessBaseWithHousing: 50,
    happinessBaseWithoutHousing: 20,
    happinessPerUpgradeLevel: 15,
    happinessOverduePenalty: 35,
    happinessAtRiskPenalty: 12,
    happinessBustedPenalty: 15,
    happinessEarningsStep: 0.004,
  },
  hardcore: {
    betrayalBaseChance: 0.14,
    betrayalPerLostCrew: 0.07,
    betrayalNightclubLossBonus: 0.18,
    betrayalMaxChance: 0.75,
    seizureBase: 0.45,
    seizurePerLoss: 0.12,
    seizureNightclubBonus: 0.12,
    seizureMin: 0.45,
    seizureMax: 0.90,
    licenseBaseChance: 0.16,
    licensePerLoss: 0.10,
    licenseNightclubBonus: 0.16,
    licenseMin: 0.16,
    licenseMax: 0.70,
    wantedBase: 8,
    wantedPerLoss: 4,
    wantedNightclubBonus: 5,
    wantedLicenseBonus: 8,
    fbiBase: 3,
    fbiPerLoss: 2,
    fbiNightclubBonus: 3,
    fbiLicenseBonus: 4,
    jailBaseMinutes: 45,
    jailPerLossMinutes: 18,
    jailNightclubBonusMinutes: 25,
    jailLicenseBonusMinutes: 35,
    housingGraceDays: 5,
    housingAtRiskDays: 1,
    housingBonusPerUpgradeLevel: 5,
    housingBonusMax: 20,
    happinessBaseWithHousing: 46,
    happinessBaseWithoutHousing: 16,
    happinessPerUpgradeLevel: 13,
    happinessOverduePenalty: 42,
    happinessAtRiskPenalty: 15,
    happinessBustedPenalty: 18,
    happinessEarningsStep: 0.005,
  },
};

function getProstitutionBalanceProfile(): ProstitutionBalanceProfile {
  const rawValue = process.env[PROSTITUTION_BALANCE_PROFILE_ENV]?.trim().toLowerCase();
  if (rawValue === 'casual' || rawValue === 'hardcore' || rawValue === 'normal') {
    return rawValue;
  }
  return 'normal';
}

function getProstitutionBalancePreset() {
  const profile = getProstitutionBalanceProfile();
  return {
    profile,
    preset: PROSTITUTION_BALANCE_PRESETS[profile],
  };
}

function getProstitutionEconomyPreset() {
  return getProstitutionBalancePreset().preset;
}

// Tier-based earnings (for districts)
const TIER_MULTIPLIERS = {
  1: { gross: 75, rent: 20 },   // Basic: €75/h gross, €20/h rent
  2: { gross: 100, rent: 30 },  // Luxury: €100/h gross, €30/h rent
  3: { gross: 150, rent: 50 }   // VIP: €150/h gross, €50/h rent
};

const PROSTITUTE_NAMES = [
  'Scarlett', 'Ruby', 'Diamond', 'Crystal', 'Sapphire',
  'Jade', 'Amber', 'Pearl', 'Candy', 'Angel',
  'Destiny', 'Cherry', 'Raven', 'Luna', 'Star',
  'Honey', 'Tiffany', 'Jasmine', 'Bella', 'Venus',
  'Roxanne', 'Ginger', 'Misty', 'Aurora', 'Chloe'
];

const RECRUITMENT_FAILURE_REASONS = [
  'Ze zag je aankomen en ging er vandoor',
  'Een rivaliserende pooier was je net voor',
  'De politie controleerde de buurt onverwacht',
  'Je contactpersoon bleek onbetrouwbaar',
  'De deal klapte op het laatste moment'
];

const RECRUITMENT_LOSS_REASONS = [
  'werd opgepakt tijdens een politie-inval',
  'is overgelopen naar een rivaliserende crew',
  'is spoorloos verdwenen na een conflict',
  'is gevlucht na intimidatie in de buurt'
];

function isVipProstitute(variant: number): boolean {
  return variant >= 6 && variant <= 10;
}

function getHousingTierForVariant(variant: number): number {
  return isVipProstitute(variant) ? 2 : 1;
}

const HOUSING_RENT_STANDARD_KEY = 'PROSTITUTION_HOUSING_RENT_STANDARD_PER_DAY';
const HOUSING_RENT_VIP_KEY = 'PROSTITUTION_HOUSING_RENT_VIP_PER_DAY';
const HOUSING_RENT_STANDARD_DEFAULT = 35;
const HOUSING_RENT_VIP_DEFAULT = 60;

function getConfiguredHousingRentPerDay(key: string, fallback: number): number {
  const raw = process.env[key];
  if (raw !== undefined) {
    const parsed = parseInt(raw, 10);
    if (!isNaN(parsed) && parsed >= 0) return parsed;
  }
  return fallback;
}

function getHousingRentPerDay(variant: number): number {
  if (isVipProstitute(variant)) {
    return getConfiguredHousingRentPerDay(HOUSING_RENT_VIP_KEY, HOUSING_RENT_VIP_DEFAULT);
  }
  return getConfiguredHousingRentPerDay(HOUSING_RENT_STANDARD_KEY, HOUSING_RENT_STANDARD_DEFAULT);
}

function addDays(date: Date, days: number): Date {
  const next = new Date(date);
  next.setDate(next.getDate() + days);
  return next;
}

const VIP_HOUSING_BONUS_KEY = 'VIP_HOUSING_BONUS_PER_PROPERTY';
const VIP_HOUSING_BONUS_DEFAULT = 5;

function getVipHousingBonusPerProperty(): number {
  const raw = process.env[VIP_HOUSING_BONUS_KEY];
  if (raw !== undefined) {
    const parsed = parseInt(raw, 10);
    if (!isNaN(parsed) && parsed >= 0) return parsed;
  }
  return VIP_HOUSING_BONUS_DEFAULT;
}

function getResidentialCapacityFromProperty(definition: any, upgradeLevel: number): number {
  const hasResidentialFeature = Array.isArray(definition?.features)
    && definition.features.includes('residential');

  if (!hasResidentialFeature) {
    return 0;
  }

  const storageCapacity = Array.isArray(definition?.storageCapacity)
    ? definition.storageCapacity
    : [];
  const rawCapacity = storageCapacity[Math.max(0, upgradeLevel - 1)] ?? storageCapacity[0] ?? 0;
  return Math.max(1, Math.floor(rawCapacity / 5));
}

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

export const prostituteService = {
  async maybeTriggerBetrayalAfterLoss(
    playerId: number,
    lost: Array<{ id: number; name: string; nightclubVenueId: number | null }>
  ): Promise<{
    triggered: boolean;
    message?: string;
    seizedDrugsGrams?: number;
    nightclubLicensesRevoked?: number;
  }> {
    if (lost.length === 0) {
      return { triggered: false };
    }

    const { profile, preset } = getProstitutionBalancePreset();
    const lossWeight = Math.min(lost.length, 4);
    const hadNightclubWorkerLoss = lost.some((item) => typeof item.nightclubVenueId === 'number');
    const chance = Math.min(
      preset.betrayalBaseChance
        + (lossWeight * preset.betrayalPerLostCrew)
        + (hadNightclubWorkerLoss ? preset.betrayalNightclubLossBonus : 0),
      preset.betrayalMaxChance
    );

    if (Math.random() > chance) {
      return { triggered: false };
    }

    const seizureSeverity = clamp(
      preset.seizureBase + (lossWeight * preset.seizurePerLoss) + (hadNightclubWorkerLoss ? preset.seizureNightclubBonus : 0),
      preset.seizureMin,
      preset.seizureMax
    );

    const licenseRevocationChance = clamp(
      preset.licenseBaseChance + (lossWeight * preset.licensePerLoss) + (hadNightclubWorkerLoss ? preset.licenseNightclubBonus : 0),
      preset.licenseMin,
      preset.licenseMax
    );
    const shouldRevokeLicense = Math.random() < licenseRevocationChance;

    const nightclubProperties = await prisma.property.findMany({
      where: {
        playerId,
        propertyType: 'nightclub',
      },
      include: {
        nightclub: {
          include: {
            inventory: {
              select: {
                id: true,
                quantity: true,
              },
            },
          },
        },
      },
    });

    if (nightclubProperties.length === 0) {
      return { triggered: false };
    }

    const propertyToRevoke = shouldRevokeLicense
      ? nightclubProperties[Math.floor(Math.random() * nightclubProperties.length)]
      : null;
    const revokedVenueId = propertyToRevoke?.nightclub?.id ?? null;
    let seizedDrugsGrams = 0;
    let nightclubLicensesRevoked = 0;

    await prisma.$transaction(async (tx) => {
      // Partial drug seizure based on betrayal severity.
      for (const property of nightclubProperties) {
        for (const inv of property.nightclub?.inventory ?? []) {
          const currentQty = inv.quantity ?? 0;
          if (currentQty <= 0) continue;
          const remaining = Math.max(0, Math.floor(currentQty * (1 - seizureSeverity)));
          const seized = Math.max(0, currentQty - remaining);
          if (seized <= 0) continue;

          seizedDrugsGrams += seized;
          await tx.nightclubDrugInventory.update({
            where: { id: inv.id },
            data: { quantity: remaining },
          });
        }
      }

      if (revokedVenueId != null) {
        await tx.prostitute.updateMany({
          where: { playerId, nightclubVenueId: revokedVenueId },
          data: { location: 'street', nightclubVenueId: null, nightclubAssignedAt: null },
        });

        await tx.property.delete({
          where: { id: propertyToRevoke!.id },
        });

        nightclubLicensesRevoked = 1;
      }
    });

    const wantedIncrease = preset.wantedBase
      + (lossWeight * preset.wantedPerLoss)
      + (hadNightclubWorkerLoss ? preset.wantedNightclubBonus : 0)
      + (nightclubLicensesRevoked > 0 ? preset.wantedLicenseBonus : 0);
    const fbiIncrease = preset.fbiBase
      + (lossWeight * preset.fbiPerLoss)
      + (hadNightclubWorkerLoss ? preset.fbiNightclubBonus : 0)
      + (nightclubLicensesRevoked > 0 ? preset.fbiLicenseBonus : 0);
    const jailMinutes = preset.jailBaseMinutes
      + (lossWeight * preset.jailPerLossMinutes)
      + (hadNightclubWorkerLoss ? preset.jailNightclubBonusMinutes : 0)
      + (nightclubLicensesRevoked > 0 ? preset.jailLicenseBonusMinutes : 0);

    await increaseWantedLevel(playerId, wantedIncrease);
    await increaseFBIHeat(playerId, fbiIncrease);
    await jailPlayer(playerId, jailMinutes);

    const message = nightclubLicensesRevoked > 0
      ? `Verraad! Ex-crew lekte je nightclub stash. Een vergunning is ingetrokken en je voorraad is deels in beslag genomen.`
      : `Verraad! Ex-crew lekte je stash. Politie/FBI hebben een deel van je nightclub voorraad in beslag genomen.`;

    await activityService.logActivity(
      playerId,
      'PROSTITUTE_BETRAYAL_RAID',
      message,
      {
        balanceProfile: profile,
        betrayalChance: chance,
        seizureSeverity,
        lostCrewCount: lost.length,
        lostCrew: lost.map((item) => item.name),
        seizedDrugsGrams,
        nightclubLicensesRevoked,
        wantedIncrease,
        fbiIncrease,
        jailMinutes,
      },
      true
    ).catch(() => {});

    return {
      triggered: true,
      message,
      seizedDrugsGrams,
      nightclubLicensesRevoked,
    };
  },

  async getResidentialPortfolioStats(playerId: number): Promise<{
    totalCapacity: number;
    residentialProperties: number;
    averageResidentialUpgrade: number;
    housingHappinessBonusPercent: number;
  }> {
    const ownedProperties = await prisma.property.findMany({
      where: { playerId },
      select: {
        propertyType: true,
        upgradeLevel: true,
      },
    });

    const residential = ownedProperties.filter((property) => {
      const definition = propertyService.getPropertyDefinition(property.propertyType);
      return Array.isArray(definition?.features) && definition!.features.includes('residential');
    });

    const totalCapacity = residential.reduce((sum, property) => {
      const definition = propertyService.getPropertyDefinition(property.propertyType);
      return sum + getResidentialCapacityFromProperty(definition, property.upgradeLevel);
    }, 0);

    const averageResidentialUpgrade = residential.length > 0
      ? residential.reduce((sum, item) => sum + item.upgradeLevel, 0) / residential.length
      : 0;

    const economyPreset = getProstitutionEconomyPreset();
    // Housing quality bonus from upgrades scales per selected profile.
    const housingHappinessBonusPercent = residential.length > 0
      ? clamp(
        (averageResidentialUpgrade - 1) * economyPreset.housingBonusPerUpgradeLevel,
        0,
        economyPreset.housingBonusMax
      )
      : 0;

    return {
      totalCapacity,
      residentialProperties: residential.length,
      averageResidentialUpgrade,
      housingHappinessBonusPercent,
    };
  },

  getProstituteHappinessScore(
    prostitute: { isBusted: boolean; bustedUntil: Date | null; housingPaidUntil: Date | null },
    averageResidentialUpgrade: number
  ): number {
    const economyPreset = getProstitutionEconomyPreset();
    const now = new Date();
    let score = averageResidentialUpgrade > 0
      ? economyPreset.happinessBaseWithHousing + ((averageResidentialUpgrade - 1) * economyPreset.happinessPerUpgradeLevel)
      : economyPreset.happinessBaseWithoutHousing;

    if (prostitute.housingPaidUntil && prostitute.housingPaidUntil < now) {
      score -= economyPreset.happinessOverduePenalty;
    } else if (prostitute.housingPaidUntil && prostitute.housingPaidUntil <= addDays(now, economyPreset.housingAtRiskDays)) {
      score -= economyPreset.happinessAtRiskPenalty;
    }

    if (prostitute.isBusted && prostitute.bustedUntil && prostitute.bustedUntil > now) {
      score -= economyPreset.happinessBustedPenalty;
    }

    return Math.round(clamp(score, 5, 100));
  },

  getHappinessLabel(score: number): string {
    if (score >= 85) return 'ecstatic';
    if (score >= 70) return 'happy';
    if (score >= 50) return 'stable';
    if (score >= 30) return 'stressed';
    return 'miserable';
  },

  async getHousingCapacity(playerId: number): Promise<{
    totalCapacity: number;
    occupiedSlots: number;
    freeSlots: number;
    residentialProperties: number;
    vipBonusPerProperty: number;
    isVip: boolean;
  }> {
    const residentialStats = await this.getResidentialPortfolioStats(playerId);

    const occupiedSlots = await prisma.prostitute.count({ where: { playerId } });

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { isVip: true, vipExpiresAt: true },
    });
    const isVip =
      player?.isVip === true &&
      (!player.vipExpiresAt || player.vipExpiresAt > new Date());

    const vipBonusPerProperty = getVipHousingBonusPerProperty();
    const vipTotalBonus = isVip ? vipBonusPerProperty * residentialStats.residentialProperties : 0;
    const totalCapacity = residentialStats.totalCapacity + vipTotalBonus;

    return {
      totalCapacity,
      occupiedSlots,
      freeSlots: Math.max(0, totalCapacity - occupiedSlots),
      residentialProperties: residentialStats.residentialProperties,
      vipBonusPerProperty,
      isVip,
    };
  },

  async processHousingUpkeep(playerId: number): Promise<{
    evictedCount: number;
    evictedNames: string[];
    betrayalTriggered?: boolean;
    betrayalMessage?: string;
    seizedDrugsGrams?: number;
    nightclubLicensesRevoked?: number;
  }> {
    const now = new Date();
    const overdue = await prisma.prostitute.findMany({
      where: {
        playerId,
        housingPaidUntil: { lt: now },
      },
      select: {
        id: true,
        name: true,
        redLightRoomId: true,
        nightclubVenueId: true,
        lastWorkedAt: true,
        recruitedAt: true,
      },
    });

    const capacity = await this.getHousingCapacity(playerId);
    const allOwned = await prisma.prostitute.findMany({
      where: { playerId },
      select: {
        id: true,
        name: true,
        redLightRoomId: true,
        nightclubVenueId: true,
        lastWorkedAt: true,
        recruitedAt: true,
      },
      orderBy: [
        { lastWorkedAt: 'asc' },
        { recruitedAt: 'asc' },
      ],
    });

    const overflowCount = Math.max(0, allOwned.length - capacity.totalCapacity);
    const overflow = overflowCount > 0 ? allOwned.slice(0, overflowCount) : [];
    const combined = [...overdue];
    for (const item of overflow) {
      if (!combined.some((existing) => existing.id == item.id)) {
        combined.push(item);
      }
    }

    if (combined.length === 0) {
      return { evictedCount: 0, evictedNames: [] };
    }

    const betrayal = await this.maybeTriggerBetrayalAfterLoss(playerId, combined);

    const ids = combined.map((item) => item.id);
    const roomIds = combined
      .map((item) => item.redLightRoomId)
      .filter((value): value is number => typeof value === 'number');

    await prisma.$transaction(async (tx) => {
      if (roomIds.length > 0) {
        await tx.redLightRoom.updateMany({
          where: { id: { in: roomIds } },
          data: { occupied: false },
        });
      }

      await tx.nightclubProstituteAssignment.updateMany({
        where: {
          prostituteId: { in: ids },
          isActive: true,
        },
        data: {
          isActive: false,
          releasedAt: now,
        },
      });

      await tx.prostitute.deleteMany({
        where: { id: { in: ids } },
      });
    });

    await activityService.logActivity(
      playerId,
      'PROSTITUTE_HOUSING_EVICTION',
      `Housing expired for ${overdue.length} prostitute(s)`,
      {
        evictedCount: overdue.length,
        evictedNames: combined.map((item) => item.name),
      },
      true
    ).catch(() => {});

    return {
      evictedCount: combined.length,
      evictedNames: combined.map((item) => item.name),
      betrayalTriggered: betrayal.triggered,
      betrayalMessage: betrayal.message,
      seizedDrugsGrams: betrayal.seizedDrugsGrams,
      nightclubLicensesRevoked: betrayal.nightclubLicensesRevoked,
    };
  },

  async getHousingSummary(playerId: number) {
    const upkeep = await this.processHousingUpkeep(playerId);
    const economyPreset = getProstitutionEconomyPreset();

    const prostitutes = await prisma.prostitute.findMany({
      where: { playerId },
      select: {
        housingRentPerDay: true,
        housingPaidUntil: true,
      },
    });

    const now = new Date();
    const atRiskCutoff = addDays(now, economyPreset.housingAtRiskDays);
    const capacity = await this.getHousingCapacity(playerId);
    const residentialStats = await this.getResidentialPortfolioStats(playerId);

    const atRiskCount = prostitutes.filter(
      (item) => item.housingPaidUntil && item.housingPaidUntil >= now && item.housingPaidUntil <= atRiskCutoff
    ).length;
    const safeCount = prostitutes.filter(
      (item) => item.housingPaidUntil && item.housingPaidUntil > atRiskCutoff
    ).length;

    return {
      totalWeeklyRent: prostitutes.reduce((sum, item) => sum + (item.housingRentPerDay * economyPreset.housingGraceDays), 0),
      atRiskCount,
      safeCount,
      graceDays: economyPreset.housingGraceDays,
      totalCapacity: capacity.totalCapacity,
      occupiedSlots: prostitutes.length,
      freeSlots: Math.max(0, capacity.totalCapacity - prostitutes.length),
      residentialProperties: capacity.residentialProperties,
      averageResidentialUpgrade: Number(residentialStats.averageResidentialUpgrade.toFixed(2)),
      housingHappinessBonusPercent: Math.round(residentialStats.housingHappinessBonusPercent),
      betrayalTriggered: upkeep.betrayalTriggered == true,
      betrayalMessage: upkeep.betrayalMessage ?? null,
      seizedDrugsGrams: upkeep.seizedDrugsGrams ?? 0,
      nightclubLicensesRevoked: upkeep.nightclubLicensesRevoked ?? 0,
    };
  },

  /**
   * Check if player can recruit a prostitute
   */
  async canRecruit(playerId: number): Promise<{ canRecruit: boolean; cooldownRemaining?: number; jailRemaining?: number }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { lastProstituteRecruitment: true }
    });

    if (!player) {
      return { canRecruit: false };
    }

    const housingCapacity = await this.getHousingCapacity(playerId);
    if (housingCapacity.freeSlots <= 0) {
      return { canRecruit: false };
    }

    const remainingJailTime = await checkIfJailed(playerId);
    if (remainingJailTime > 0) {
      return { canRecruit: false, jailRemaining: remainingJailTime };
    }

    if (!player.lastProstituteRecruitment) {
      return { canRecruit: true };
    }

    const now = new Date();
    const cooldownEnd = new Date(player.lastProstituteRecruitment.getTime() + RECRUITMENT_COOLDOWN_MINUTES * 60 * 1000);
    
    if (now < cooldownEnd) {
      const remainingMs = cooldownEnd.getTime() - now.getTime();
      return { canRecruit: false, cooldownRemaining: Math.ceil(remainingMs / 1000) };
    }

    return { canRecruit: true };
  },

  /**
   * Recruit a new prostitute
   */
  async recruitProstitute(playerId: number): Promise<{ success: boolean; message: string; prostitute?: any; cooldownRemaining?: number; newlyUnlockedAchievements?: any[]; lostProstitute?: { id: number; name: string; reason: string } }> {
    const economyPreset = getProstitutionEconomyPreset();
    await this.processHousingUpkeep(playerId);

    const remainingJailTime = await checkIfJailed(playerId);
    if (remainingJailTime > 0) {
      return {
        success: false,
        message: 'Je kunt geen prostituees werven vanuit de gevangenis'
      };
    }

    const housingCapacity = await this.getHousingCapacity(playerId);
    if (housingCapacity.freeSlots <= 0) {
      return {
        success: false,
        message: 'Je hebt eerst een huis of appartement nodig met een vrije woonplek',
      };
    }

    // Check cooldown
    const cooldownCheck = await this.canRecruit(playerId);
    if (!cooldownCheck.canRecruit) {
      return {
        success: false,
        message: 'Je moet nog wachten voordat je weer kunt werven',
        cooldownRemaining: cooldownCheck.cooldownRemaining
      };
    }

    // Cooldown starts on attempt (both success and failure)
    await prisma.player.update({
      where: { id: playerId },
      data: { lastProstituteRecruitment: new Date() }
    });

    // Get player VIP status
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { isVip: true, vipExpiresAt: true }
    });

    // Settle existing earnings first
    await this.settleEarnings(playerId);

    const hasActiveVip =
      player?.isVip === true &&
      (!player.vipExpiresAt || player.vipExpiresAt > new Date());

    // Recruitment can fail
    if (Math.random() > RECRUITMENT_SUCCESS_CHANCE) {
      const failureReason = RECRUITMENT_FAILURE_REASONS[
        Math.floor(Math.random() * RECRUITMENT_FAILURE_REASONS.length)
      ];

      const currentProstitutes = await prisma.prostitute.findMany({
        where: { playerId },
        select: {
          id: true,
          name: true,
          redLightRoomId: true,
        },
      });

      if (currentProstitutes.length > 0 && Math.random() < RECRUITMENT_LOSS_ON_FAILURE_CHANCE) {
        const lost = currentProstitutes[Math.floor(Math.random() * currentProstitutes.length)];
        const lossReason = RECRUITMENT_LOSS_REASONS[
          Math.floor(Math.random() * RECRUITMENT_LOSS_REASONS.length)
        ];

        if (lost.redLightRoomId) {
          await prisma.redLightRoom.update({
            where: { id: lost.redLightRoomId },
            data: { occupied: false },
          });
        }

        await prisma.prostitute.delete({
          where: { id: lost.id },
        });

        await activityService.logActivity(
          playerId,
          'PROSTITUTE_RECRUIT_FAILED',
          `Recruitment failed and ${lost.name} was lost`,
          {
            failureReason,
            lostProstituteId: lost.id,
            lostProstituteName: lost.name,
            lossReason,
          },
          true
        );

        return {
          success: false,
          message: `Werving mislukt: ${failureReason}. Je verloor ${lost.name}; ze ${lossReason}.`,
          lostProstitute: {
            id: lost.id,
            name: lost.name,
            reason: lossReason,
          },
        };
      }

      await activityService.logActivity(
        playerId,
        'PROSTITUTE_RECRUIT_FAILED',
        'Recruitment attempt failed',
        {
          failureReason,
        },
        true
      );

      return {
        success: false,
        message: `Werving mislukt: ${failureReason}`,
      };
    }

    // Random name and variant
    const randomName = PROSTITUTE_NAMES[Math.floor(Math.random() * PROSTITUTE_NAMES.length)];
    const randomVariant = hasActiveVip && Math.random() < VIP_PROSTITUTE_RECRUIT_CHANCE
      ? Math.floor(Math.random() * 5) + 6 // VIP variants 6-10
      : Math.floor(Math.random() * 5) + 1; // Normal variants 1-5

    const prostitute = await prisma.prostitute.create({
      data: {
        playerId,
        name: randomName,
        variant: randomVariant,
        housingTier: getHousingTierForVariant(randomVariant),
        housingRentPerDay: getHousingRentPerDay(randomVariant),
        housingPaidUntil: addDays(new Date(), economyPreset.housingGraceDays),
        lastWorkedAt: new Date(),
      }
    });

    // Check for achievement unlocks and get newly unlocked ones
    let newlyUnlockedAchievements: any[] = [];
    try {
      const achievementResults = await checkAndUnlockAchievements(playerId);
      newlyUnlockedAchievements = achievementResults
        .filter(r => r.newlyUnlocked)
        .map(r => serializeAchievementForClient(r.achievement));
    } catch (err) {
      console.error('[Achievement Check] Error after recruit:', err);
    }

    await activityService.logActivity(
      playerId,
      'PROSTITUTE_RECRUIT',
      `Recruited ${randomName}`,
      {
        prostituteId: prostitute.id,
        prostituteName: randomName,
        variant: randomVariant,
        isVipVariant: isVipProstitute(randomVariant),
      },
      true
    );

    return {
      success: true,
      message: `Je hebt ${randomName} geworven!`,
      prostitute,
      newlyUnlockedAchievements
    };
  },

  /**
   * Get all prostitutes for a player
   */
  async getPlayerProstitutes(playerId: number) {
    const economyPreset = getProstitutionEconomyPreset();
    await this.processHousingUpkeep(playerId);
    const residentialStats = await this.getResidentialPortfolioStats(playerId);

    const prostitutes = await prisma.prostitute.findMany({
      where: { playerId },
      include: {
        redLightRoom: {
          include: {
            redLightDistrict: {
              select: {
                id: true,
                countryCode: true
              }
            }
          }
        }
      },
      orderBy: { recruitedAt: 'desc' }
    });

    return prostitutes.map((prostitute) => {
      const happinessScore = this.getProstituteHappinessScore(
        prostitute,
        residentialStats.averageResidentialUpgrade
      );
      const happinessEarningsMultiplier = Number((1 + ((happinessScore - 50) * economyPreset.happinessEarningsStep)).toFixed(3));

      return {
        ...prostitute,
        happinessScore,
        happinessLabel: this.getHappinessLabel(happinessScore),
        happinessEarningsMultiplier,
      };
    });
  },

  /**
   * Calculate and settle earnings for all prostitutes
   * Now includes XP gains and level-ups
   */
  async settleEarnings(playerId: number): Promise<number> {
    await this.processHousingUpkeep(playerId);

    const prostitutes = await prisma.prostitute.findMany({
      where: { playerId },
      include: {
        redLightRoom: {
          include: {
            redLightDistrict: true
          }
        }
      }
    });

    let totalEarnings = 0;
    const now = new Date();

    for (const prostitute of prostitutes) {
      // Skip if busted
      if (prostitute.isBusted && prostitute.bustedUntil && now < prostitute.bustedUntil) {
        continue;
      }

      // Clear busted status if time expired
      if (prostitute.isBusted && prostitute.bustedUntil && now >= prostitute.bustedUntil) {
        await prisma.prostitute.update({
          where: { id: prostitute.id },
          data: { isBusted: false, bustedUntil: null }
        });
      }

      const hoursElapsed = (now.getTime() - prostitute.lastEarningsAt.getTime()) / (1000 * 60 * 60);
      const fullHoursElapsed = Math.floor(hoursElapsed);

      if (prostitute.location === 'nightclub') {
        await prisma.prostitute.update({
          where: { id: prostitute.id },
          data: { lastEarningsAt: now }
        });
        continue;
      }

      // Settle only on full hours (hourly payout)
      if (fullHoursElapsed < 1) continue;

      const settledUntil = new Date(
        prostitute.lastEarningsAt.getTime() + fullHoursElapsed * 60 * 60 * 1000
      );

      let earnings = 0;
      let rentPaid = 0;
      const levelBonus = 1 + (prostitute.level - 1) * EARNINGS_BONUS_PER_LEVEL;
      const vipMultiplier = isVipProstitute(prostitute.variant)
        ? VIP_PROSTITUTE_EARNINGS_MULTIPLIER
        : 1;

      if (prostitute.location === 'redlight' && prostitute.redLightRoom) {
        // In red light district - use tier-based earnings
        const tier = prostitute.redLightRoom.tier || 1;
        const tierConfig = TIER_MULTIPLIERS[tier as keyof typeof TIER_MULTIPLIERS] || TIER_MULTIPLIERS[1];

        const grossEarnings = Math.floor(tierConfig.gross * fullHoursElapsed * levelBonus);
        rentPaid = Math.floor(tierConfig.rent * fullHoursElapsed);
        earnings = Math.floor((grossEarnings - rentPaid) * vipMultiplier);

        // Pay rent to RLD owner
        if (prostitute.redLightRoom.redLightDistrict.ownerId) {
          await prisma.player.update({
            where: { id: prostitute.redLightRoom.redLightDistrict.ownerId },
            data: { money: { increment: rentPaid } }
          });
        }
      } else {
        // On street
        earnings = Math.floor(
          STREET_EARNINGS_PER_HOUR * fullHoursElapsed * levelBonus * vipMultiplier
        );
      }

      totalEarnings += earnings;

      // Update prostitute (no auto-XP: XP only gained via explicit work-shift)
      await prisma.prostitute.update({
        where: { id: prostitute.id },
        data: { 
          lastEarningsAt: settledUntil
        }
      });

      // Update room lastEarningsAt if in red light
      if (prostitute.redLightRoomId) {
        await prisma.redLightRoom.update({
          where: { id: prostitute.redLightRoomId },
          data: { lastEarningsAt: settledUntil }
        });
      }
    }

    // Add earnings to player
    if (totalEarnings > 0) {
      await prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: totalEarnings } }
      });
    }

    return totalEarnings;
  },

  /**
   * Move prostitute to red light district room
   */
  async moveToRedLight(
    playerId: number,
    prostituteId: number,
    redLightRoomId?: number,
    redLightDistrictId?: number
  ): Promise<{ success: boolean; message: string }> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true }
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    // Check if prostitute belongs to player
    const prostitute = await prisma.prostitute.findFirst({
      where: {
        id: prostituteId,
        playerId
      }
    });

    if (!prostitute) {
      return { success: false, message: 'Prostituee niet gevonden' };
    }

    if (!redLightRoomId && !redLightDistrictId) {
      return { success: false, message: 'Kamer of district is vereist' };
    }

    if (prostitute.location === 'redlight' || prostitute.redLightRoomId) {
      return { success: false, message: 'Deze prostituee staat al in een Red Light District' };
    }

    if (prostitute.location === 'nightclub' || prostitute.nightclubVenueId) {
      return {
        success: false,
        message: 'Deze prostituee werkt in een nachtclub. Haal haar daar eerst weg.'
      };
    }

    let room = redLightRoomId
      ? await prisma.redLightRoom.findUnique({
          where: { id: redLightRoomId },
          include: {
            prostitute: true,
            redLightDistrict: {
              select: {
                id: true,
                ownerId: true,
                countryCode: true
              }
            }
          }
        })
      : null;

    if (!room && redLightDistrictId) {
      const district = await prisma.redLightDistrict.findUnique({
        where: { id: redLightDistrictId },
        select: {
          id: true,
          ownerId: true,
          countryCode: true
        }
      });

      if (!district) {
        return { success: false, message: 'Red Light District niet gevonden' };
      }

      if (!district.ownerId) {
        return { success: false, message: 'Dit Red Light District heeft nog geen eigenaar' };
      }

      if (player.currentCountry !== district.countryCode) {
        return {
          success: false,
          message: 'Je kunt alleen prostituees plaatsen in het Red Light District van je huidige land'
        };
      }

      const availableRoom = await prisma.redLightRoom.findFirst({
        where: {
          redLightDistrictId: district.id,
          occupied: false,
          prostitute: null
        },
        orderBy: { roomNumber: 'asc' },
        include: {
          prostitute: true,
          redLightDistrict: {
            select: {
              id: true,
              ownerId: true,
              countryCode: true
            }
          }
        }
      });

      if (availableRoom) {
        room = availableRoom;
      } else {
        // Check room count limit (3 million rooms per district)
        const roomCount = await prisma.redLightRoom.count({
          where: { redLightDistrictId: district.id }
        });

        if (roomCount >= 3000000) {
          return {
            success: false,
            message: 'Maximum aantal kamers (3.000.000) bereikt voor dit district'
          };
        }

        const lastRoom = await prisma.redLightRoom.findFirst({
          where: { redLightDistrictId: district.id },
          orderBy: { roomNumber: 'desc' },
          select: { roomNumber: true }
        });

        const nextRoomNumber = (lastRoom?.roomNumber ?? 0) + 1;
        room = await prisma.redLightRoom.create({
          data: {
            redLightDistrictId: district.id,
            roomNumber: nextRoomNumber
          },
          include: {
            prostitute: true,
            redLightDistrict: {
              select: {
                id: true,
                ownerId: true,
                countryCode: true
              }
            }
          }
        });
      }
    }

    if (!room) {
      return { success: false, message: 'Kamer niet gevonden' };
    }

    if (room.prostitute) {
      return { success: false, message: 'Deze kamer is al bezet' };
    }

    if (!room.redLightDistrict.ownerId) {
      return { success: false, message: 'Dit Red Light District heeft nog geen eigenaar' };
    }

    if (player.currentCountry !== room.redLightDistrict.countryCode) {
      return {
        success: false,
        message: 'Je kunt alleen prostituees plaatsen in het Red Light District van je huidige land'
      };
    }

    // Settle earnings before moving
    await this.settleEarnings(playerId);

    // Move prostitute
    await prisma.prostitute.update({
      where: { id: prostituteId },
      data: {
        location: 'redlight',
        redLightRoomId: room.id,
        lastEarningsAt: new Date()
      }
    });

    await prisma.redLightRoom.update({
      where: { id: room.id },
      data: { 
        occupied: true,
        lastEarningsAt: new Date()
      }
    });

    return { success: true, message: 'Prostituee verplaatst naar Red Light District' };
  },

  /**
   * Move prostitute back to street
   */
  async moveToStreet(
    playerId: number,
    prostituteId: number
  ): Promise<{ success: boolean; message: string }> {
    const prostitute = await prisma.prostitute.findFirst({
      where: {
        id: prostituteId,
        playerId
      },
      include: { redLightRoom: true }
    });

    if (!prostitute) {
      return { success: false, message: 'Prostituee niet gevonden' };
    }

    if (prostitute.location === 'street') {
      return { success: true, message: 'Prostituee staat al op straat' };
    }

    if (prostitute.location === 'redlight' || prostitute.redLightRoomId) {
      return {
        success: false,
        message: 'Eenmaal geplaatst in Red Light District kan een prostituee niet terug naar straat'
      };
    }

    // Settle earnings before moving
    await this.settleEarnings(playerId);

    // Free up the room if occupied
    if (prostitute.redLightRoomId) {
      await prisma.redLightRoom.update({
        where: { id: prostitute.redLightRoomId },
        data: { occupied: false }
      });
    }

    // Move to street
    await prisma.prostitute.update({
      where: { id: prostituteId },
      data: {
        location: 'street',
        redLightRoomId: null,
        nightclubVenueId: null,
        nightclubAssignedAt: null,
        lastEarningsAt: new Date()
      }
    });

    return { success: true, message: 'Prostituee verplaatst naar de straat' };
  },

  /**
   * Get earnings stats (updated for leveling and tiers)
   */
  async getEarningsStats(playerId: number) {
    await this.processHousingUpkeep(playerId);

    const prostitutes = await prisma.prostitute.findMany({
      where: { playerId },
      include: {
        redLightRoom: {
          include: {
            redLightDistrict: true
          }
        }
      }
    });

    const now = new Date();
    let potentialEarnings = 0;
    let streetCount = 0;
    let redlightCount = 0;
    let bustedCount = 0;

    for (const prostitute of prostitutes) {
      // Check if busted
      if (prostitute.isBusted && prostitute.bustedUntil && now < prostitute.bustedUntil) {
        bustedCount++;
        continue;
      }

      const hoursElapsed = (now.getTime() - prostitute.lastEarningsAt.getTime()) / (1000 * 60 * 60);
      const levelBonus = 1 + (prostitute.level - 1) * EARNINGS_BONUS_PER_LEVEL;
      const vipMultiplier = isVipProstitute(prostitute.variant)
        ? VIP_PROSTITUTE_EARNINGS_MULTIPLIER
        : 1;

      if (prostitute.location === 'nightclub') {
        continue;
      }
      
      if (prostitute.location === 'redlight' && prostitute.redLightRoom) {
        const tier = prostitute.redLightRoom.tier || 1;
        const tierConfig = TIER_MULTIPLIERS[tier as keyof typeof TIER_MULTIPLIERS] || TIER_MULTIPLIERS[1];
        
        const grossEarnings = Math.floor(tierConfig.gross * hoursElapsed * levelBonus);
        const rentPaid = Math.floor(tierConfig.rent * hoursElapsed);
        potentialEarnings += Math.floor((grossEarnings - rentPaid) * vipMultiplier);
        redlightCount++;
      } else {
        potentialEarnings += Math.floor(STREET_EARNINGS_PER_HOUR * hoursElapsed * levelBonus * vipMultiplier);
        streetCount++;
      }
    }

    return {
      totalCount: prostitutes.length,
      streetCount,
      redlightCount,
      bustedCount,
      potentialEarnings,
      hourlyRate: {
        street: STREET_EARNINGS_PER_HOUR,
        redlight: TIER_MULTIPLIERS[1].gross - TIER_MULTIPLIERS[1].rent // Net earnings tier 1
      }
    };
  },

  /**
   * Settle earnings for all players (called by tick service)
   */
  async settleAllProstitutionEarnings(): Promise<{
    playersProcessed: number;
    totalEarningsSettled: number;
    totalEvicted: number;
  }> {
    const players = await prisma.player.findMany({
      select: { id: true },
      where: {
        prostitutes: {
          some: {} // Only players with at least one prostitute
        }
      }
    });

    let totalEarningsSettled = 0;
    let totalEvicted = 0;

    for (const player of players) {
      const earnings = await this.settleEarnings(player.id);
      totalEarningsSettled += earnings;
      const housing = await this.processHousingUpkeep(player.id);
      totalEvicted += housing.evictedCount;
    }

    return {
      playersProcessed: players.length,
      totalEarningsSettled,
      totalEvicted,
    };
  },

  /**
   * Work shift: Direct 8-hour work with XP gain
   * Prostitute works explicitly for 8 hours, earns money and XP, then returns to available pool
   */
  async workShift(
    playerId: number,
    prostituteId: number,
    location: 'nightclub' | 'street' | 'redlight' = 'street'
  ): Promise<{
    success: boolean;
    message: string;
    earnings?: number;
    xpGained?: number;
    newLevel?: number;
    leveledUp?: boolean;
  }> {
    const economyPreset = getProstitutionEconomyPreset();
    await this.processHousingUpkeep(playerId);
    const residentialStats = await this.getResidentialPortfolioStats(playerId);

    // Verify prostitute belongs to player
    const prostitute = await prisma.prostitute.findFirst({
      where: { id: prostituteId, playerId },
      include: {
        redLightRoom: {
          include: {
            redLightDistrict: true
          }
        }
      }
    });

    if (!prostitute) {
      return { success: false, message: 'Prostituee niet gevonden' };
    }

    // Can't work if busted
    if (prostitute.isBusted && prostitute.bustedUntil && new Date() < prostitute.bustedUntil) {
      return { success: false, message: 'Deze prostituee is gearresteerd en kan niet werken' };
    }

    // Verify location validity
    if (location === 'redlight' && !prostitute.redLightRoomId) {
      return { success: false, message: 'Deze prostituee werkt niet in een Red Light District' };
    }

    let earnings = 0;
    let rentPaid = 0;
    const housingRentPaid = prostitute.housingRentPerDay * economyPreset.housingGraceDays;
    const SHIFT_HOURS = 8;
    const levelBonus = 1 + (prostitute.level - 1) * EARNINGS_BONUS_PER_LEVEL;
    const vipMultiplier = isVipProstitute(prostitute.variant)
      ? VIP_PROSTITUTE_EARNINGS_MULTIPLIER
      : 1;

    // Calculate earnings based on location
    if (location === 'redlight' && prostitute.redLightRoom) {
      const tier = prostitute.redLightRoom.tier || 1;
      const tierConfig = TIER_MULTIPLIERS[tier as keyof typeof TIER_MULTIPLIERS] || TIER_MULTIPLIERS[1];

      const grossEarnings = Math.floor(tierConfig.gross * SHIFT_HOURS * levelBonus);
      rentPaid = Math.floor(tierConfig.rent * SHIFT_HOURS);
      earnings = Math.floor((grossEarnings - rentPaid) * vipMultiplier);

      // Pay rent to RLD owner
      if (prostitute.redLightRoom.redLightDistrict.ownerId) {
        await prisma.player.update({
          where: { id: prostitute.redLightRoom.redLightDistrict.ownerId },
          data: { money: { increment: rentPaid } }
        });
      }
    } else if (location === 'nightclub') {
      // Nightclub work (earnings set by nightclub owner, here we use street rate as base)
      earnings = Math.floor(STREET_EARNINGS_PER_HOUR * SHIFT_HOURS * levelBonus * vipMultiplier);
    } else {
      // Street
      earnings = Math.floor(STREET_EARNINGS_PER_HOUR * SHIFT_HOURS * levelBonus * vipMultiplier);
    }

    earnings = Math.max(0, earnings - housingRentPaid);

    // Calculate XP gained (only from explicit work shift)
    const xpGained = Math.floor(XP_PER_HOUR * SHIFT_HOURS);
    const newExperience = prostitute.experience + xpGained;
    const newLevel = Math.min(MAX_LEVEL, Math.floor(newExperience / XP_PER_LEVEL) + 1);
    const leveledUp = newLevel > prostitute.level;

    const happinessScore = this.getProstituteHappinessScore(
      prostitute,
      residentialStats.averageResidentialUpgrade
    );
    const happinessMultiplier = 1 + ((happinessScore - 50) * economyPreset.happinessEarningsStep);
    earnings = Math.floor(earnings * happinessMultiplier);

    // Update prostitute: add earnings, XP, level
    await prisma.prostitute.update({
      where: { id: prostituteId },
      data: {
        experience: newExperience,
        level: newLevel,
        lastEarningsAt: new Date(),
        lastWorkedAt: new Date(),
        housingPaidUntil: addDays(new Date(), economyPreset.housingGraceDays),
      }
    });

    // Add earnings to player
    if (earnings > 0) {
      await prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: earnings } }
      });
    }

    // Log activity
    await activityService.logActivity({
      playerId,
      action: 'prostitute_work_shift',
      details: {
        prostituteId,
        prostituteName: prostitute.name,
        location,
        earnedMoney: earnings,
        xpGained,
        newLevel,
        leveledUp
      }
    }).catch(() => {}); // Non-blocking

    return {
      success: true,
      message: leveledUp
        ? `${prostitute.name} werkte hard en steeg naar level ${newLevel}!`
        : `${prostitute.name} verdiende netto €${earnings} (geluk ${happinessScore}%) en betaalde haar huisvesting voor ${economyPreset.housingGraceDays} dagen`,
      earnings,
      xpGained,
      newLevel,
      leveledUp
    };
  }
};