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
];

const addHours = (date: Date, hours: number) => new Date(date.getTime() + hours * 60 * 60 * 1000);

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

  return {
    balance: player?.premiumCredits ?? 0,
    hitProtectionExpiresAt: player?.hitProtectionExpiresAt ?? null,
    items,
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

    if (player.premiumCredits < item.creditCost) {
      throw new Error('INSUFFICIENT_CREDITS');
    }

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

      await tx.actionCooldown.deleteMany({
        where: { playerId, actionType },
      });

      messageNl = `Cooldown voor ${actionType} gereset`;
      messageEn = `Cooldown for ${actionType} reset`;
    } else if (item.effectType === 'EVENT_BOOST') {
      const durationHours = item.durationHours ?? 24;
      await createTimedCreditEntitlement(tx, playerId, item.key, 'EVENT_BOOST', durationHours, {
        source: 'credit_redemption',
        metadataJson: item.metadataJson,
      });

      messageNl = 'Event boost geactiveerd';
      messageEn = 'Event boost activated';
    }

    const balance = await updateCreditsBalance(
      tx,
      playerId,
      -item.creditCost,
      'REDEEM',
      item.key,
      JSON.stringify({
        effectType: item.effectType,
        vehicleInventoryId: options.vehicleInventoryId ?? null,
        actionType: item.actionType ?? options.actionType ?? null,
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