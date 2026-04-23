import prisma from '../lib/prisma';

type CreditCatalogItem = {
  key: string;
  titleNl: string;
  titleEn: string;
  descriptionNl: string;
  descriptionEn: string;
  creditCost: number;
  effectType:
    | 'CASH_BUNDLE'
    | 'HIT_PROTECTION'
    | 'VEHICLE_REPAIR_FINISH'
    | 'VEHICLE_TUNE_RESET'
    | 'ACTION_COOLDOWN_RESET'
    | 'EVENT_BOOST';
  moneyAmount?: number;
  durationHours?: number;
  actionType?: string;
  metadataJson?: string;
  sortOrder: number;
};

type RedeemOptions = {
  vehicleInventoryId?: number;
  actionType?: string;
};

type RedeemResult = {
  balance: number;
  effectType: string;
  messageNl: string;
  messageEn: string;
};

type ActionCooldownState = {
  actionType: string;
  cooldownSeconds: number;
  elapsedSeconds: number;
  remainingSeconds: number;
  isActive: boolean;
};

type ActiveEventBoostEffects = {
  crimeSuccessPct: number;
  crimeRewardPct: number;
  hitAttackPct: number;
  hitDefensePct: number;
  eventContributionPct: number;
};

const DEFAULT_ACTION_COOLDOWNS: Record<string, number> = {
  crime: 90,
  job: 900,
  travel: 3600,
  heist: 21600,
  appeal: 14400,
  vehicle_theft: 300,
  motorcycle_theft: 240,
  boat_theft: 600,
  prison_escape: 600,
  prison_jailbreak: 900,
  prison_bail: 900,
};

const ACTION_RESET_BASE_COST: Record<string, number> = {
  crime: 18,
  job: 16,
  vehicle_theft: 20,
  motorcycle_theft: 16,
  boat_theft: 24,
  travel: 14,
  heist: 34,
  appeal: 18,
  prison_escape: 18,
  prison_jailbreak: 20,
  prison_bail: 18,
};

const ACTION_RESET_VALUE_WEIGHT: Record<string, number> = {
  crime: 1.0,
  job: 1.05,
  vehicle_theft: 1.1,
  motorcycle_theft: 1.0,
  boat_theft: 1.2,
  travel: 0.95,
  heist: 1.35,
  appeal: 1.1,
  prison_escape: 1.1,
  prison_jailbreak: 1.15,
  prison_bail: 1.05,
};

const EVENT_BOOST_CAPS: ActiveEventBoostEffects = {
  crimeSuccessPct: 0.05,
  crimeRewardPct: 0.08,
  hitAttackPct: 0.04,
  hitDefensePct: 0.04,
  eventContributionPct: 0.15,
};

const DEFAULT_CREDIT_ITEMS: CreditCatalogItem[] = [
  {
    key: 'cash_bundle_250k',
    titleNl: 'Cash boost €250.000',
    titleEn: 'Cash boost €250,000',
    descriptionNl: 'Zet credits direct om in contant geld voor snelle progressie.',
    descriptionEn: 'Convert credits into instant cash for faster progression.',
    creditCost: 25,
    effectType: 'CASH_BUNDLE',
    moneyAmount: 250000,
    sortOrder: 10,
  },
  {
    key: 'hit_protection_24h',
    titleNl: 'Moordbescherming 24 uur',
    titleEn: 'Hit protection 24 hours',
    descriptionNl: 'Voorkomt hitlist-kills voor 24 uur.',
    descriptionEn: 'Prevents hitlist kills for 24 hours.',
    creditCost: 60,
    effectType: 'HIT_PROTECTION',
    durationHours: 24,
    sortOrder: 20,
  },
  {
    key: 'repair_finish_now',
    titleNl: 'Reparatie direct afronden',
    titleEn: 'Finish repair instantly',
    descriptionNl: 'Rond een actieve voertuigreparatie direct af.',
    descriptionEn: 'Complete one active vehicle repair instantly.',
    creditCost: 30,
    effectType: 'VEHICLE_REPAIR_FINISH',
    sortOrder: 30,
  },
  {
    key: 'tune_cooldown_reset',
    titleNl: 'Tune cooldown reset',
    titleEn: 'Tune cooldown reset',
    descriptionNl: 'Verwijdert de actieve tune cooldown van een voertuig.',
    descriptionEn: 'Clears the active tune cooldown from one vehicle.',
    creditCost: 20,
    effectType: 'VEHICLE_TUNE_RESET',
    sortOrder: 40,
  },
  {
    key: 'crime_cooldown_reset',
    titleNl: 'Crime cooldown reset',
    titleEn: 'Crime cooldown reset',
    descriptionNl: 'Maakt je crime cooldown direct weer beschikbaar.',
    descriptionEn: 'Makes your crime cooldown immediately available again.',
    creditCost: 18,
    effectType: 'ACTION_COOLDOWN_RESET',
    actionType: 'crime',
    sortOrder: 50,
  },
  {
    key: 'job_cooldown_reset',
    titleNl: 'Werk cooldown reset',
    titleEn: 'Job cooldown reset',
    descriptionNl: 'Maak je werkactie direct opnieuw beschikbaar.',
    descriptionEn: 'Make your job action immediately available again.',
    creditCost: 16,
    effectType: 'ACTION_COOLDOWN_RESET',
    actionType: 'job',
    sortOrder: 51,
  },
  {
    key: 'vehicle_theft_cooldown_reset',
    titleNl: 'Auto theft cooldown reset',
    titleEn: 'Car theft cooldown reset',
    descriptionNl: 'Reset de cooldown van auto stelen direct.',
    descriptionEn: 'Reset the car theft cooldown instantly.',
    creditCost: 20,
    effectType: 'ACTION_COOLDOWN_RESET',
    actionType: 'vehicle_theft',
    sortOrder: 52,
  },
  {
    key: 'motorcycle_theft_cooldown_reset',
    titleNl: 'Motor theft cooldown reset',
    titleEn: 'Motorcycle theft cooldown reset',
    descriptionNl: 'Reset de cooldown van motor stelen direct.',
    descriptionEn: 'Reset the motorcycle theft cooldown instantly.',
    creditCost: 16,
    effectType: 'ACTION_COOLDOWN_RESET',
    actionType: 'motorcycle_theft',
    sortOrder: 53,
  },
  {
    key: 'boat_theft_cooldown_reset',
    titleNl: 'Boot theft cooldown reset',
    titleEn: 'Boat theft cooldown reset',
    descriptionNl: 'Reset de cooldown van boot stelen direct.',
    descriptionEn: 'Reset the boat theft cooldown instantly.',
    creditCost: 24,
    effectType: 'ACTION_COOLDOWN_RESET',
    actionType: 'boat_theft',
    sortOrder: 54,
  },
  {
    key: 'crime_focus_boost_2h',
    titleNl: 'Crime Focus 2u',
    titleEn: 'Crime Focus 2h',
    descriptionNl: 'Tijdelijke focusboost voor crimes: iets hogere slaagkans en payout.',
    descriptionEn: 'Temporary crime focus boost: slightly higher success chance and payout.',
    creditCost: 45,
    effectType: 'EVENT_BOOST',
    durationHours: 2,
    metadataJson: '{"boosts":{"crimeSuccessPct":0.03,"crimeRewardPct":0.05}}',
    sortOrder: 60,
  },
  {
    key: 'contract_tactics_boost_2h',
    titleNl: 'Contract Tactics 2u',
    titleEn: 'Contract Tactics 2h',
    descriptionNl: 'Tijdelijke hitlist side-grade: kleine aanval- en verdedigingbonus.',
    descriptionEn: 'Temporary hitlist side-grade: small attack and defense bonus.',
    creditCost: 55,
    effectType: 'EVENT_BOOST',
    durationHours: 2,
    metadataJson: '{"boosts":{"hitAttackPct":0.04,"hitDefensePct":0.02}}',
    sortOrder: 61,
  },
  {
    key: 'event_hustle_boost_4h',
    titleNl: 'Event Hustle 4u',
    titleEn: 'Event Hustle 4h',
    descriptionNl: 'Tijdelijke event boost: meer bijdragepunten tijdens live events.',
    descriptionEn: 'Temporary event boost: more contribution points during live events.',
    creditCost: 60,
    effectType: 'EVENT_BOOST',
    durationHours: 4,
    metadataJson: '{"boosts":{"eventContributionPct":0.15}}',
    sortOrder: 62,
  },
];

const addHours = (date: Date, hours: number) => new Date(date.getTime() + hours * 60 * 60 * 1000);

function parseJsonObject(value: string | null | undefined): Record<string, unknown> {
  if (!value || !value.trim()) {
    return {};
  }
  try {
    const parsed = JSON.parse(value);
    if (parsed && typeof parsed === 'object') {
      return parsed as Record<string, unknown>;
    }
  } catch {
    return {};
  }
  return {};
}

function toFiniteNumber(value: unknown, fallback: number): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function getActionResetCost(actionType: string, remainingSeconds: number, cooldownSeconds: number): number {
  const baseCost = ACTION_RESET_BASE_COST[actionType] ?? 18;
  const valueWeight = ACTION_RESET_VALUE_WEIGHT[actionType] ?? 1;
  const normalizedCooldown = Math.max(1, cooldownSeconds || DEFAULT_ACTION_COOLDOWNS[actionType] || 1);
  const normalizedRemaining = Math.max(0, remainingSeconds);
  const remainingRatio = Math.max(0, Math.min(1, normalizedRemaining / normalizedCooldown));
  // Smoother scaling: short cooldowns should not spike to punishing credit costs.
  const ratioFactor = 1 + remainingRatio * 0.35;
  const computed = Math.round(baseCost * valueWeight * ratioFactor);
  const maxCost = Math.max(baseCost + 6, Math.round(baseCost * 2.2));
  return Math.max(baseCost, Math.min(maxCost, computed));
}

async function getActionCooldownState(
  tx: any,
  playerId: number,
  actionType: string,
): Promise<ActionCooldownState> {
  const cooldown = await tx.actionCooldown.findUnique({
    where: {
      playerId_actionType: {
        playerId,
        actionType,
      },
    },
    select: {
      lastUsedAt: true,
      cooldownSeconds: true,
    },
  });

  const fallbackCooldown = DEFAULT_ACTION_COOLDOWNS[actionType] ?? 0;
  if (!cooldown) {
    return {
      actionType,
      cooldownSeconds: fallbackCooldown,
      elapsedSeconds: fallbackCooldown,
      remainingSeconds: 0,
      isActive: false,
    };
  }

  const cooldownSeconds = Math.max(
    0,
    toFiniteNumber(cooldown.cooldownSeconds, fallbackCooldown),
  );
  const elapsedSeconds = Math.max(
    0,
    Math.floor((Date.now() - new Date(cooldown.lastUsedAt).getTime()) / 1000),
  );
  const remainingSeconds = Math.max(0, cooldownSeconds - elapsedSeconds);

  return {
    actionType,
    cooldownSeconds,
    elapsedSeconds,
    remainingSeconds,
    isActive: remainingSeconds > 0,
  };
}

function getNumericBoostValue(
  source: Record<string, unknown>,
  key: keyof ActiveEventBoostEffects,
): number {
  const boosts =
    source.boosts && typeof source.boosts === 'object'
      ? (source.boosts as Record<string, unknown>)
      : source;
  return Math.max(0, toFiniteNumber(boosts[key], 0));
}

async function updateCreditsBalance(
  tx: any,
  playerId: number,
  delta: number,
  reasonType: 'PURCHASE' | 'REDEEM' | 'REFUND' | 'ADMIN_ADJUSTMENT',
  reasonKey?: string,
  metadataJson?: string,
) {
  const player = await tx.player.findUnique({
    where: { id: playerId },
    select: { premiumCredits: true },
  });

  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const nextBalance = player.premiumCredits + delta;
  if (nextBalance < 0) {
    throw new Error('INSUFFICIENT_CREDITS');
  }

  await tx.player.update({
    where: { id: playerId },
    data: { premiumCredits: nextBalance },
  });

  await tx.playerCreditTransaction.create({
    data: {
      playerId,
      delta,
      balanceAfter: nextBalance,
      reasonType,
      reasonKey: reasonKey ?? null,
      metadataJson: metadataJson ?? null,
    },
  });

  return nextBalance;
}

export async function grantPurchasedCredits(
  tx: any,
  playerId: number,
  amount: number,
  productKey: string,
) {
  return updateCreditsBalance(
    tx,
    playerId,
    amount,
    'PURCHASE',
    productKey,
    JSON.stringify({ source: 'premium_checkout', amount }),
  );
}

export async function createTimedCreditEntitlement(
  tx: any,
  playerId: number,
  key: string,
  effectType: 'HIT_PROTECTION' | 'EVENT_BOOST',
  durationHours: number,
  metadata: Record<string, unknown> = {},
  expiresAtOverride?: Date,
) {
  const now = new Date();
  const expiresAt = expiresAtOverride ?? addHours(now, durationHours);

  await tx.playerCreditEntitlement.create({
    data: {
      playerId,
      key,
      effectType,
      durationHours,
      expiresAt,
      metadataJson: JSON.stringify(metadata),
    },
  });

  return expiresAt;
}

export async function ensureDefaultCreditCatalog() {
  await Promise.all(
    DEFAULT_CREDIT_ITEMS.map((item) =>
      prisma.creditShopItem.upsert({
        where: { key: item.key },
        create: {
          ...item,
          isActive: true,
        },
        update: {
          titleNl: item.titleNl,
          titleEn: item.titleEn,
          descriptionNl: item.descriptionNl,
          descriptionEn: item.descriptionEn,
          creditCost: item.creditCost,
          effectType: item.effectType,
          moneyAmount: item.moneyAmount ?? null,
          durationHours: item.durationHours ?? null,
          actionType: item.actionType ?? null,
          metadataJson: item.metadataJson ?? null,
          sortOrder: item.sortOrder,
        },
      }),
    ),
  );
}

export async function getCreditOverview(playerId: number) {
  await ensureDefaultCreditCatalog();

  const [player, items, entitlements] = await Promise.all([
    prisma.player.findUnique({
      where: { id: playerId },
      select: { premiumCredits: true, hitProtectionExpiresAt: true },
    }),
    prisma.creditShopItem.findMany({
      where: { isActive: true },
      orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
    }),
    prisma.playerCreditEntitlement.findMany({
      where: {
        playerId,
        status: 'ACTIVE',
        OR: [{ expiresAt: null }, { expiresAt: { gt: new Date() } }],
      },
      orderBy: [{ startedAt: 'desc' }],
    }),
  ]);

  const enrichedItems = await Promise.all(
    items.map(async (item) => {
      if (item.effectType !== 'ACTION_COOLDOWN_RESET') {
        return item;
      }

      const actionType = item.actionType || 'crime';
      const cooldownState = await getActionCooldownState(prisma, playerId, actionType);
      const effectiveCost = getActionResetCost(
        actionType,
        cooldownState.remainingSeconds,
        cooldownState.cooldownSeconds,
      );

      return {
        ...item,
        effectiveCreditCost: effectiveCost,
        canRedeemNow: cooldownState.isActive,
        unavailableReason: cooldownState.isActive ? null : 'ACTION_COOLDOWN_NOT_ACTIVE',
        cooldownState: {
          actionType,
          cooldownSeconds: cooldownState.cooldownSeconds,
          remainingSeconds: cooldownState.remainingSeconds,
        },
      };
    }),
  );

  return {
    balance: player?.premiumCredits ?? 0,
    hitProtectionExpiresAt: player?.hitProtectionExpiresAt ?? null,
    items: enrichedItems,
    entitlements,
  };
}

export async function redeemCreditItem(
  playerId: number,
  itemKey: string,
  options: RedeemOptions = {},
): Promise<RedeemResult> {
  await ensureDefaultCreditCatalog();

  const item = await prisma.creditShopItem.findFirst({
    where: { key: itemKey, isActive: true },
  });

  if (!item) {
    throw new Error('CREDIT_ITEM_NOT_FOUND');
  }

  return prisma.$transaction(async (tx) => {
    const player = await tx.player.findUnique({
      where: { id: playerId },
      select: { premiumCredits: true, hitProtectionExpiresAt: true },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    let redeemCost = item.creditCost;

    let messageNl = 'Credits ingewisseld';
    let messageEn = 'Credits redeemed';

    if (item.effectType === 'CASH_BUNDLE') {
      if (!item.moneyAmount || item.moneyAmount <= 0) {
        throw new Error('INVALID_CREDIT_ITEM_CONFIGURATION');
      }

      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: item.moneyAmount } },
      });

      messageNl = `€${item.moneyAmount.toLocaleString('nl-NL')} contant toegevoegd`;
      messageEn = `Added €${item.moneyAmount.toLocaleString('en-US')} cash`;
    } else if (item.effectType === 'HIT_PROTECTION') {
      const durationHours = item.durationHours ?? 24;
      const base =
        player.hitProtectionExpiresAt && player.hitProtectionExpiresAt > new Date()
          ? player.hitProtectionExpiresAt
          : new Date();
      const expiresAt = addHours(base, durationHours);

      await tx.player.update({
        where: { id: playerId },
        data: { hitProtectionExpiresAt: expiresAt },
      });

      await createTimedCreditEntitlement(
        tx,
        playerId,
        item.key,
        'HIT_PROTECTION',
        durationHours,
        { source: 'credit_redemption' },
        expiresAt,
      );

      messageNl = 'Moordbescherming geactiveerd';
      messageEn = 'Hit protection activated';
    } else if (item.effectType === 'VEHICLE_REPAIR_FINISH') {
      if (!options.vehicleInventoryId || !Number.isFinite(options.vehicleInventoryId)) {
        throw new Error('VEHICLE_ID_REQUIRED');
      }

      const jobs = await tx.$queryRawUnsafe<any[]>(
        `SELECT id, target_condition FROM vehicle_repair_jobs WHERE player_id = ? AND vehicle_inventory_id = ? AND status = 'in_progress' LIMIT 1`,
        playerId,
        options.vehicleInventoryId,
      );

      const job = jobs[0];
      if (!job) {
        throw new Error('REPAIR_JOB_NOT_FOUND');
      }

      await tx.$executeRawUnsafe(
        `UPDATE vehicle_repair_jobs SET status = 'completed', completed_at = NOW(3), completes_at = NOW(3) WHERE id = ?`,
        job.id,
      );
      await tx.vehicleInventory.update({
        where: { id: options.vehicleInventoryId },
        data: { condition: Number(job.target_condition ?? 100) },
      });

      messageNl = 'Voertuigreparatie direct afgerond';
      messageEn = 'Vehicle repair completed instantly';
    } else if (item.effectType === 'VEHICLE_TUNE_RESET') {
      if (!options.vehicleInventoryId || !Number.isFinite(options.vehicleInventoryId)) {
        throw new Error('VEHICLE_ID_REQUIRED');
      }

      const updated = await tx.$executeRawUnsafe(
        `UPDATE vehicle_tuning_upgrades
         SET tune_cooldown_until = NULL, updated_at = NOW(3)
         WHERE player_id = ? AND vehicle_inventory_id = ? AND tune_cooldown_until IS NOT NULL AND tune_cooldown_until > UTC_TIMESTAMP()`,
        playerId,
        options.vehicleInventoryId,
      );

      if (!updated) {
        throw new Error('TUNE_COOLDOWN_NOT_ACTIVE');
      }

      messageNl = 'Tune cooldown verwijderd';
      messageEn = 'Tune cooldown cleared';
    } else if (item.effectType === 'ACTION_COOLDOWN_RESET') {
      const actionType = item.actionType || options.actionType;
      if (!actionType) {
        throw new Error('ACTION_TYPE_REQUIRED');
      }

      const cooldownState = await getActionCooldownState(tx, playerId, actionType);
      if (!cooldownState.isActive) {
        throw new Error('ACTION_COOLDOWN_NOT_ACTIVE');
      }

      redeemCost = getActionResetCost(
        actionType,
        cooldownState.remainingSeconds,
        cooldownState.cooldownSeconds,
      );

      if (player.premiumCredits < redeemCost) {
        throw new Error('INSUFFICIENT_CREDITS');
      }

      await tx.actionCooldown.deleteMany({
        where: { playerId, actionType },
      });

      messageNl = `Cooldown voor ${actionType} gereset voor ${redeemCost} credits`;
      messageEn = `Cooldown for ${actionType} reset for ${redeemCost} credits`;
    } else if (item.effectType === 'EVENT_BOOST') {
      if (player.premiumCredits < redeemCost) {
        throw new Error('INSUFFICIENT_CREDITS');
      }

      const itemMetadata = parseJsonObject(item.metadataJson);
      const durationHours = item.durationHours ?? 24;
      await createTimedCreditEntitlement(tx, playerId, item.key, 'EVENT_BOOST', durationHours, {
        source: 'credit_redemption',
        ...itemMetadata,
      });

      messageNl = 'Event boost geactiveerd';
      messageEn = 'Event boost activated';
    } else if (player.premiumCredits < redeemCost) {
      throw new Error('INSUFFICIENT_CREDITS');
    }

    const balance = await updateCreditsBalance(
      tx,
      playerId,
      -redeemCost,
      'REDEEM',
      item.key,
      JSON.stringify({
        effectType: item.effectType,
        vehicleInventoryId: options.vehicleInventoryId ?? null,
        actionType: item.actionType ?? options.actionType ?? null,
        creditCost: redeemCost,
      }),
    );

    return {
      balance,
      effectType: item.effectType,
      messageNl,
      messageEn,
    };
  });
}

export async function getActiveEventBoostEffects(
  playerId: number,
): Promise<ActiveEventBoostEffects> {
  const activeEntitlements = await prisma.playerCreditEntitlement.findMany({
    where: {
      playerId,
      effectType: 'EVENT_BOOST',
      status: 'ACTIVE',
      OR: [{ expiresAt: null }, { expiresAt: { gt: new Date() } }],
    },
    select: {
      metadataJson: true,
    },
  });

  const strongest: ActiveEventBoostEffects = {
    crimeSuccessPct: 0,
    crimeRewardPct: 0,
    hitAttackPct: 0,
    hitDefensePct: 0,
    eventContributionPct: 0,
  };

  for (const entitlement of activeEntitlements) {
    const metadata = parseJsonObject(entitlement.metadataJson);
    strongest.crimeSuccessPct = Math.max(
      strongest.crimeSuccessPct,
      getNumericBoostValue(metadata, 'crimeSuccessPct'),
    );
    strongest.crimeRewardPct = Math.max(
      strongest.crimeRewardPct,
      getNumericBoostValue(metadata, 'crimeRewardPct'),
    );
    strongest.hitAttackPct = Math.max(
      strongest.hitAttackPct,
      getNumericBoostValue(metadata, 'hitAttackPct'),
    );
    strongest.hitDefensePct = Math.max(
      strongest.hitDefensePct,
      getNumericBoostValue(metadata, 'hitDefensePct'),
    );
    strongest.eventContributionPct = Math.max(
      strongest.eventContributionPct,
      getNumericBoostValue(metadata, 'eventContributionPct'),
    );
  }

  return {
    crimeSuccessPct: Math.min(strongest.crimeSuccessPct, EVENT_BOOST_CAPS.crimeSuccessPct),
    crimeRewardPct: Math.min(strongest.crimeRewardPct, EVENT_BOOST_CAPS.crimeRewardPct),
    hitAttackPct: Math.min(strongest.hitAttackPct, EVENT_BOOST_CAPS.hitAttackPct),
    hitDefensePct: Math.min(strongest.hitDefensePct, EVENT_BOOST_CAPS.hitDefensePct),
    eventContributionPct: Math.min(
      strongest.eventContributionPct,
      EVENT_BOOST_CAPS.eventContributionPct,
    ),
  };
}
