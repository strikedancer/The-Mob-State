import express, { Request, Response, NextFunction } from 'express';
import { authenticate } from '../middleware/authenticate';
import prisma from '../lib/prisma';
import { ammoService } from '../services/ammoService';
import {
  createTimedCreditEntitlement,
  getCreditOverview,
  grantPurchasedCredits,
  redeemCreditItem,
} from '../services/premiumCreditsService';

const { createMollieClient } = require('@mollie/api-client');

const router = express.Router();

const mollieApiKey = process.env.MOLLIE_API_KEY || '';
const mollieClient = mollieApiKey ? createMollieClient({ apiKey: mollieApiKey }) : null;

const APP_URL = process.env.APP_URL || 'http://localhost:3000';
const MOLLIE_WEBHOOK_URL = process.env.MOLLIE_WEBHOOK_URL || `${APP_URL}/subscriptions/webhook`;
const PLAYER_VIP_PRICE_EUR = process.env.MOLLIE_PLAYER_VIP_PRICE_EUR || '4.99';
const CREW_VIP_PRICE_EUR = process.env.MOLLIE_CREW_VIP_PRICE_EUR || '9.99';
const MAX_NON_VIP_BUILDING_LEVEL = 10;

type PremiumOfferRecord = {
  id: number;
  key: string;
  titleNl: string;
  titleEn: string;
  descriptionNl: string | null;
  descriptionEn: string | null;
  imageUrl: string | null;
  priceEurCents: number;
  rewardType: 'money' | 'ammo' | 'credits' | 'event_boost';
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
  creditAmount: number | null;
  rewardKey: string | null;
  durationHours: number | null;
  rewardValue: number | null;
  metadataJson: string | null;
  isActive: boolean;
  showPopupOnOpen: boolean;
  sortOrder: number;
};

type PaymentMetadata = {
  type: 'player_vip' | 'crew_vip' | 'one_time';
  playerId: string;
  crewId?: string;
  productKey?: string;
};

const premiumOfferRepo = (prisma as any).premiumOneTimeOffer as {
  findMany: (args: any) => Promise<PremiumOfferRecord[]>;
  findFirst: (args: any) => Promise<PremiumOfferRecord | null>;
};

const centsToEuroValue = (cents: number): string => (cents / 100).toFixed(2);

const mapMollieStatus = (status?: string) => {
  switch ((status || '').toLowerCase()) {
    case 'paid':
      return 'PAID';
    case 'pending':
      return 'PENDING';
    case 'canceled':
      return 'CANCELED';
    case 'expired':
      return 'EXPIRED';
    case 'failed':
      return 'FAILED';
    default:
      return 'OPEN';
  }
};

function getMollieClient() {
  if (!mollieClient) {
    throw new Error('Mollie is not configured. Missing MOLLIE_API_KEY');
  }

  return mollieClient;
}

function getLocaleFromRequest(req: Request): 'nl' | 'en' {
  const locale = String(req.query.locale || req.headers['x-locale'] || '').toLowerCase();
  return locale === 'nl' ? 'nl' : 'en';
}

function addDays(base: Date, days: number) {
  return new Date(base.getTime() + days * 24 * 60 * 60 * 1000);
}

function toDateString(date: Date) {
  return date.toISOString().slice(0, 10);
}

function extendVipExpiry(current: Date | null | undefined) {
  const base = current && current > new Date() ? current : new Date();
  return addDays(base, 30);
}

function getVipPrice(type: 'player_vip' | 'crew_vip') {
  return type === 'crew_vip' ? CREW_VIP_PRICE_EUR : PLAYER_VIP_PRICE_EUR;
}

function getVipDescription(type: 'player_vip' | 'crew_vip', locale: 'nl' | 'en') {
  if (type === 'crew_vip') {
    return locale === 'nl' ? 'Crew VIP abonnement' : 'Crew VIP subscription';
  }

  return locale === 'nl' ? 'Speler VIP abonnement' : 'Player VIP subscription';
}

function buildRewardSummary(offer: PremiumOfferRecord, locale: 'nl' | 'en') {
  if (offer.rewardType === 'money') {
    return locale === 'nl'
      ? `+â‚¬${offer.moneyAmount ?? 0}`
      : `+â‚¬${offer.moneyAmount ?? 0}`;
  }

  if (offer.rewardType === 'ammo') {
    return `${offer.ammoType ?? ''} x${offer.ammoQuantity ?? 0}`;
  }

  if (offer.rewardType === 'credits') {
    return locale === 'nl'
      ? `+${offer.creditAmount ?? 0} credits`
      : `+${offer.creditAmount ?? 0} credits`;
  }

  const duration = offer.durationHours ? `${offer.durationHours}u` : null;
  const rewardKey = offer.rewardKey || (locale === 'nl' ? 'Event boost' : 'Event boost');
  return duration ? `${rewardKey} Â· ${duration}` : rewardKey;
}

function extractWebhookPaymentId(req: Request) {
  if (typeof req.body?.id === 'string') {
    return req.body.id;
  }

  if (Buffer.isBuffer(req.body)) {
    const raw = req.body.toString('utf-8').trim();
    if (!raw) return null;

    try {
      const parsed = JSON.parse(raw) as { id?: string };
      if (typeof parsed.id === 'string') {
        return parsed.id;
      }
    } catch {
      const params = new URLSearchParams(raw);
      const id = params.get('id');
      if (id) {
        return id;
      }
    }
  }

  if (typeof req.query.id === 'string') {
    return req.query.id;
  }

  return null;
}

function formatOfferForCatalog(offer: PremiumOfferRecord) {
  return {
    key: offer.key,
    titleNl: offer.titleNl,
    titleEn: offer.titleEn,
    descriptionNl: offer.descriptionNl,
    descriptionEn: offer.descriptionEn,
    imageUrl: offer.imageUrl,
    priceEur: centsToEuroValue(offer.priceEurCents),
    reward: offer.rewardType === 'money'
      ? { type: 'money', amount: offer.moneyAmount ?? 0 }
      : offer.rewardType === 'ammo'
      ? { type: 'ammo', ammoType: offer.ammoType ?? '', quantity: offer.ammoQuantity ?? 0 }
      : offer.rewardType === 'credits'
      ? { type: 'credits', amount: offer.creditAmount ?? 0 }
      : {
          type: 'event_boost',
          key: offer.rewardKey ?? offer.key,
          durationHours: offer.durationHours ?? 0,
          value: offer.rewardValue ?? 0,
        },
    rewardSummaryNl: buildRewardSummary(offer, 'nl'),
    rewardSummaryEn: buildRewardSummary(offer, 'en'),
  };
}

async function listActivePremiumOffers() {
  return premiumOfferRepo.findMany({
    where: { isActive: true },
    orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
  });
}

async function getActivePremiumOfferByKey(key: string) {
  return premiumOfferRepo.findFirst({
    where: { key, isActive: true },
  });
}

async function downgradeCrewAfterVipExpiry(crewId: number): Promise<void> {
  await prisma.$transaction(async (tx) => {
    await tx.crewHqBuilding.updateMany({
      where: { crewId },
      data: { style: 'villa', level: 3 },
    });

    await Promise.all([
      tx.crewCarStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewBoatStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewWeaponStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewAmmoStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewDrugStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewCashStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
    ]);
  });
}

async function activateVipFromMetadata(metadata: PaymentMetadata, subscriptionId?: string): Promise<void> {
  const playerId = parseInt(metadata.playerId || '', 10);
  if (!playerId) return;

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { vipExpiresAt: true },
  });

  await prisma.player.update({
    where: { id: playerId },
    data: {
      isVip: true,
      vipExpiresAt: extendVipExpiry(player?.vipExpiresAt),
      mollieSubscriptionId: metadata.type === 'player_vip' ? subscriptionId || undefined : undefined,
    },
  });

  if (metadata.type === 'crew_vip' && metadata.crewId) {
    const crewId = parseInt(metadata.crewId, 10);
    if (!crewId) return;

    const crew = await prisma.crew.findUnique({
      where: { id: crewId },
      select: { vipExpiresAt: true },
    });

    await prisma.crew.update({
      where: { id: crewId },
      data: {
        isVip: true,
        vipExpiresAt: extendVipExpiry(crew?.vipExpiresAt),
        mollieSubscriptionId: subscriptionId || undefined,
      },
    });
  }
}

async function deactivateVipForSubscription(metadata: PaymentMetadata, subscriptionId?: string): Promise<void> {
  const playerId = parseInt(metadata.playerId || '', 10);
  if (metadata.type === 'player_vip' && playerId) {
    await prisma.player.update({
      where: { id: playerId },
      data: { isVip: false, vipExpiresAt: null, mollieSubscriptionId: null },
    });
  }

  if (metadata.type === 'crew_vip' && metadata.crewId) {
    const crewId = parseInt(metadata.crewId, 10);
    if (crewId) {
      await prisma.crew.update({
        where: { id: crewId },
        data: { isVip: false, vipExpiresAt: null, mollieSubscriptionId: null },
      });
      await downgradeCrewAfterVipExpiry(crewId);
      return;
    }
  }

  if (subscriptionId) {
    const crew = await prisma.crew.findFirst({
      where: { mollieSubscriptionId: subscriptionId },
      select: { id: true },
    });

    if (crew) {
      await prisma.crew.update({
        where: { id: crew.id },
        data: { isVip: false, vipExpiresAt: null, mollieSubscriptionId: null },
      });
      await downgradeCrewAfterVipExpiry(crew.id);
    }
  }
}

async function getOrCreateMollieCustomer(playerId: number, email: string | null | undefined): Promise<string> {
  const mollie = getMollieClient();

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { mollieCustomerId: true },
  });

  if (player?.mollieCustomerId) {
    return player.mollieCustomerId;
  }

  const customer = await mollie.customers.create({
    email: email || undefined,
    name: `Player_${playerId}`,
    metadata: { playerId: String(playerId) },
  });

  await prisma.player.update({
    where: { id: playerId },
    data: { mollieCustomerId: customer.id },
  });

  return customer.id;
}

async function upsertPaymentTransaction(payload: {
  playerId: number;
  checkoutType: 'PLAYER_VIP' | 'CREW_VIP' | 'ONE_TIME';
  productKey?: string | null;
  amountValue: string;
  description?: string | null;
  providerPaymentId?: string | null;
  providerCustomerId?: string | null;
  providerSubscriptionId?: string | null;
  status: 'OPEN' | 'PENDING' | 'PAID' | 'CANCELED' | 'EXPIRED' | 'FAILED';
  paidAt?: Date | null;
  metadata: Record<string, unknown>;
}) {
  if (!payload.providerPaymentId) {
    return null;
  }

  return prisma.paymentTransaction.upsert({
    where: { providerPaymentId: payload.providerPaymentId },
    create: {
      playerId: payload.playerId,
      checkoutType: payload.checkoutType,
      productKey: payload.productKey ?? null,
      amountValue: payload.amountValue,
      amountCurrency: 'EUR',
      description: payload.description ?? null,
      providerPaymentId: payload.providerPaymentId,
      providerCustomerId: payload.providerCustomerId ?? null,
      providerSubscriptionId: payload.providerSubscriptionId ?? null,
      status: payload.status,
      metadataJson: JSON.stringify(payload.metadata),
      paidAt: payload.paidAt ?? null,
    },
    update: {
      productKey: payload.productKey ?? null,
      amountValue: payload.amountValue,
      description: payload.description ?? null,
      providerCustomerId: payload.providerCustomerId ?? null,
      providerSubscriptionId: payload.providerSubscriptionId ?? null,
      status: payload.status,
      metadataJson: JSON.stringify(payload.metadata),
      paidAt: payload.paidAt ?? null,
    },
  });
}

async function fulfillOneTimePurchase(paymentId: string, metadata: PaymentMetadata): Promise<void> {
  const playerId = Number(metadata.playerId);
  const productKey = metadata.productKey || '';

  if (!Number.isFinite(playerId) || playerId <= 0 || !productKey) {
    console.warn('[Mollie webhook] Invalid one-time metadata', { paymentId, metadata });
    return;
  }

  const product = await getActivePremiumOfferByKey(productKey);
  if (!product) {
    console.warn('[Mollie webhook] Unknown premium product', { paymentId, productKey });
    return;
  }

  await prisma.$transaction(async (tx) => {
    const insertedRows = await tx.$executeRawUnsafe(
      `INSERT IGNORE INTO stripe_payment_fulfillments (stripeSessionId, playerId, productKey, payload, fulfilledAt)
       VALUES (?, ?, ?, CAST(? AS JSON), NOW(3))`,
      paymentId,
      playerId,
      productKey,
      JSON.stringify(metadata),
    );

    if (Number(insertedRows) === 0) {
      return;
    }

    await tx.paymentTransaction.upsert({
      where: { providerPaymentId: paymentId },
      create: {
        playerId,
        productKey,
        checkoutType: 'ONE_TIME',
        amountValue: centsToEuroValue(product.priceEurCents),
        amountCurrency: 'EUR',
        providerPaymentId: paymentId,
        status: 'PAID',
        paidAt: new Date(),
        description: product.titleEn,
        metadataJson: JSON.stringify(metadata),
      },
      update: {
        status: 'PAID',
        paidAt: new Date(),
        metadataJson: JSON.stringify(metadata),
      },
    });

    if (product.rewardType === 'money') {
      if (!product.moneyAmount || product.moneyAmount <= 0) {
        throw new Error('INVALID_PRODUCT_CONFIGURATION');
      }

      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: product.moneyAmount } },
      });
      return;
    }

    if (product.rewardType === 'ammo') {
      if (!product.ammoType || !product.ammoQuantity || product.ammoQuantity <= 0) {
        throw new Error('INVALID_PRODUCT_CONFIGURATION');
      }

      const ammoDef = ammoService.getAmmoDefinition(product.ammoType);
      if (!ammoDef) {
        throw new Error('INVALID_AMMO_DEFINITION');
      }

      const existingAmmo = await tx.ammoInventory.findUnique({
        where: {
          playerId_ammoType: {
            playerId,
            ammoType: product.ammoType,
          },
        },
      });

      const currentQty = existingAmmo?.quantity ?? 0;
      const newQty = Math.min(currentQty + product.ammoQuantity, ammoDef.maxInventory);

      if (existingAmmo) {
        await tx.ammoInventory.update({
          where: { id: existingAmmo.id },
          data: { quantity: newQty },
        });
      } else {
        await tx.ammoInventory.create({
          data: {
            playerId,
            ammoType: product.ammoType,
            quantity: newQty,
            quality: 1.0,
          },
        });
      }

      return;
    }

    if (product.rewardType === 'credits') {
      if (!product.creditAmount || product.creditAmount <= 0) {
        throw new Error('INVALID_PRODUCT_CONFIGURATION');
      }

      await grantPurchasedCredits(tx, playerId, product.creditAmount, product.key);
      return;
    }

    const durationHours = product.durationHours ?? 24;
    await createTimedCreditEntitlement(
      tx,
      playerId,
      product.rewardKey || product.key,
      'EVENT_BOOST',
      durationHours,
      {
        source: 'premium_checkout',
        rewardValue: product.rewardValue ?? 0,
        metadataJson: product.metadataJson,
      },
    );
  });
}

async function ensureVipSubscription(metadata: PaymentMetadata, customerId: string) {
  const mollie = getMollieClient();
  const price = getVipPrice(metadata.type);
  const startDate = toDateString(addDays(new Date(), 30));

  if (metadata.type === 'player_vip') {
    const player = await prisma.player.findUnique({
      where: { id: Number(metadata.playerId) },
      select: { mollieSubscriptionId: true },
    });
    if (player?.mollieSubscriptionId) {
      return player.mollieSubscriptionId;
    }
  }

  if (metadata.type === 'crew_vip' && metadata.crewId) {
    const crew = await prisma.crew.findUnique({
      where: { id: Number(metadata.crewId) },
      select: { mollieSubscriptionId: true },
    });
    if (crew?.mollieSubscriptionId) {
      return crew.mollieSubscriptionId;
    }
  }

  const subscription = await mollie.customerSubscriptions.create({
    customerId,
    amount: { currency: 'EUR', value: price },
    interval: '1 month',
    startDate,
    description: getVipDescription(metadata.type, 'en'),
    webhookUrl: MOLLIE_WEBHOOK_URL,
    metadata,
  });

  if (metadata.type === 'player_vip') {
    await prisma.player.update({
      where: { id: Number(metadata.playerId) },
      data: { mollieSubscriptionId: subscription.id },
    });
  }

  if (metadata.type === 'crew_vip' && metadata.crewId) {
    await prisma.crew.update({
      where: { id: Number(metadata.crewId) },
      data: { mollieSubscriptionId: subscription.id },
    });
  }

  return subscription.id;
}

async function createMollieCheckout(options: {
  playerId: number;
  customerId?: string;
  amountValue: string;
  description: string;
  checkoutType: 'PLAYER_VIP' | 'CREW_VIP' | 'ONE_TIME';
  metadata: PaymentMetadata;
  redirectStatus: 'success' | 'paid';
  sequenceType?: 'first';
}) {
  const mollie = getMollieClient();
  const payment = await mollie.payments.create({
    amount: { currency: 'EUR', value: options.amountValue },
    description: options.description,
    redirectUrl: `${APP_URL}/premium?status=${options.redirectStatus}`,
    cancelUrl: `${APP_URL}/premium?status=cancelled`,
    webhookUrl: MOLLIE_WEBHOOK_URL,
    customerId: options.customerId,
    sequenceType: options.sequenceType,
    metadata: options.metadata,
  });

  await upsertPaymentTransaction({
    playerId: options.playerId,
    checkoutType: options.checkoutType,
    productKey: options.metadata.productKey ?? null,
    amountValue: options.amountValue,
    description: options.description,
    providerPaymentId: payment.id,
    providerCustomerId: payment.customerId || options.customerId || null,
    providerSubscriptionId: payment.subscriptionId || null,
    status: mapMollieStatus(payment.status),
    paidAt: payment.paidAt ? new Date(payment.paidAt) : null,
    metadata: options.metadata,
  });

  return payment;
}

router.post('/checkout/player-vip', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { email: true },
    });

    const customerId = await getOrCreateMollieCustomer(playerId, player?.email);
    const payment = await createMollieCheckout({
      playerId,
      customerId,
      amountValue: PLAYER_VIP_PRICE_EUR,
      description: getVipDescription('player_vip', 'en'),
      checkoutType: 'PLAYER_VIP',
      redirectStatus: 'success',
      sequenceType: 'first',
      metadata: {
        type: 'player_vip',
        playerId: String(playerId),
      },
    });

    const checkoutUrl = payment.getCheckoutUrl?.() || null;
    if (!checkoutUrl) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: checkoutUrl, provider: 'mollie' });
  } catch (error: unknown) {
    console.error('[Mollie] checkout/player-vip error:', error);
    return next(error);
  }
});

router.post('/checkout/crew-vip', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const { crewId } = req.body as { crewId: number };

    if (!crewId || isNaN(Number(crewId))) {
      return res.status(400).json({ event: 'error.invalid_crew_id', params: {} });
    }

    const membership = await prisma.crewMember.findFirst({
      where: { crewId: Number(crewId), playerId, role: 'leader' },
    });

    if (!membership) {
      return res.status(403).json({ event: 'error.not_crew_leader', params: {} });
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { email: true },
    });

    const customerId = await getOrCreateMollieCustomer(playerId, player?.email);
    const payment = await createMollieCheckout({
      playerId,
      customerId,
      amountValue: CREW_VIP_PRICE_EUR,
      description: getVipDescription('crew_vip', 'en'),
      checkoutType: 'CREW_VIP',
      redirectStatus: 'success',
      sequenceType: 'first',
      metadata: {
        type: 'crew_vip',
        playerId: String(playerId),
        crewId: String(crewId),
      },
    });

    const checkoutUrl = payment.getCheckoutUrl?.() || null;
    if (!checkoutUrl) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: checkoutUrl, provider: 'mollie' });
  } catch (error: unknown) {
    console.error('[Mollie] checkout/crew-vip error:', error);
    return next(error);
  }
});

router.get('/checkout/one-time/catalog', authenticate, async (_req: Request, res: Response) => {
  const products = await listActivePremiumOffers();

  return res.json({
    products: products.map(formatOfferForCatalog),
  });
});

router.get('/checkout/one-time/popup', authenticate, async (req: Request, res: Response) => {
  const playerId = (req as any).player?.id as number;
  const locale = getLocaleFromRequest(req);

  const offer = await prisma.$queryRawUnsafe<any[]>(
    `SELECT o.id, o.key, o.titleNl, o.titleEn, o.imageUrl, o.priceEurCents, o.rewardType,
            o.moneyAmount, o.ammoType, o.ammoQuantity, o.creditAmount, o.rewardKey, o.durationHours
     FROM premium_one_time_offers o
     LEFT JOIN player_premium_popup_seen s ON s.offerId = o.id AND s.playerId = ?
     WHERE o.isActive = 1 AND o.showPopupOnOpen = 1 AND s.id IS NULL
     ORDER BY o.sortOrder ASC, o.id ASC
     LIMIT 1`,
    playerId,
  );

  if (!offer || offer.length === 0) {
    return res.json({ popup: null });
  }

  const item = offer[0] as PremiumOfferRecord;

  return res.json({
    popup: {
      key: item.key,
      title: locale === 'nl' ? item.titleNl : item.titleEn,
      imageUrl: item.imageUrl,
      priceEur: centsToEuroValue(item.priceEurCents),
      reward: buildRewardSummary(item, locale),
    },
  });
});

router.post('/checkout/one-time/popup/seen', authenticate, async (req: Request, res: Response) => {
  const playerId = (req as any).player?.id as number;
  const { productKey } = req.body as { productKey?: string };

  if (!productKey) {
    return res.status(400).json({ error: 'productKey is required' });
  }

  const offer = await getActivePremiumOfferByKey(productKey);
  if (!offer) {
    return res.status(404).json({ error: 'Offer not found' });
  }

  await prisma.$executeRawUnsafe(
    `INSERT IGNORE INTO player_premium_popup_seen (playerId, offerId, seenAt) VALUES (?, ?, NOW(3))`,
    playerId,
    offer.id,
  );

  return res.json({ success: true });
});

router.post('/checkout/one-time', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const { productKey } = req.body as { productKey?: string };

    if (!productKey) {
      return res.status(400).json({ event: 'error.invalid_product_key', params: {} });
    }

    const product = await getActivePremiumOfferByKey(productKey);
    if (!product) {
      return res.status(400).json({ event: 'error.invalid_product_key', params: {} });
    }

    if (product.rewardType === 'money' && (!product.moneyAmount || product.moneyAmount <= 0)) {
      return res.status(400).json({ event: 'error.invalid_product_configuration', params: {} });
    }

    if (product.rewardType === 'ammo' && (!product.ammoType || !product.ammoQuantity || product.ammoQuantity <= 0)) {
      return res.status(400).json({ event: 'error.invalid_product_configuration', params: {} });
    }

    if (product.rewardType === 'credits' && (!product.creditAmount || product.creditAmount <= 0)) {
      return res.status(400).json({ event: 'error.invalid_product_configuration', params: {} });
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { email: true },
    });

    const customerId = await getOrCreateMollieCustomer(playerId, player?.email);
    const payment = await createMollieCheckout({
      playerId,
      customerId,
      amountValue: centsToEuroValue(product.priceEurCents),
      description: product.titleEn,
      checkoutType: 'ONE_TIME',
      redirectStatus: 'paid',
      metadata: {
        type: 'one_time',
        playerId: String(playerId),
        productKey: product.key,
      },
    });

    const checkoutUrl = payment.getCheckoutUrl?.() || null;
    if (!checkoutUrl) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: checkoutUrl, provider: 'mollie' });
  } catch (error: unknown) {
    console.error('[Mollie] checkout/one-time error:', error);
    return next(error);
  }
});

router.get('/credits/overview', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const overview = await getCreditOverview(playerId);
    return res.json(overview);
  } catch (error) {
    return next(error);
  }
});

router.post('/credits/redeem', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player?.id as number;
    const locale = getLocaleFromRequest(req);
    const { itemKey, vehicleInventoryId, actionType } = req.body as {
      itemKey?: string;
      vehicleInventoryId?: number;
      actionType?: string;
    };

    if (!itemKey) {
      return res.status(400).json({ error: 'itemKey is required' });
    }

    const result = await redeemCreditItem(playerId, itemKey, {
      vehicleInventoryId,
      actionType,
    });

    return res.json({
      success: true,
      balance: result.balance,
      effectType: result.effectType,
      message: locale === 'nl' ? result.messageNl : result.messageEn,
    });
  } catch (error: any) {
    const messageMap: Record<string, { status: number; message: string }> = {
      CREDIT_ITEM_NOT_FOUND: { status: 404, message: 'Credit item not found' },
      INSUFFICIENT_CREDITS: { status: 400, message: 'Insufficient credits' },
      VEHICLE_ID_REQUIRED: { status: 400, message: 'vehicleInventoryId is required' },
      REPAIR_JOB_NOT_FOUND: { status: 404, message: 'Repair job not found' },
      TUNE_COOLDOWN_NOT_ACTIVE: { status: 400, message: 'Tune cooldown not active' },
      ACTION_TYPE_REQUIRED: { status: 400, message: 'actionType is required' },
      INVALID_CREDIT_ITEM_CONFIGURATION: { status: 400, message: 'Invalid credit item configuration' },
    };

    const mapped = messageMap[error?.message || ''];
    if (mapped) {
      return res.status(mapped.status).json({ error: mapped.message, code: error.message });
    }

    console.error('[Premium credits] redeem error:', error);
    return res.status(500).json({ error: 'Failed to redeem credit item' });
  }
});

router.get('/status', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const [player, membership] = await Promise.all([
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          isVip: true,
          vipExpiresAt: true,
          premiumCredits: true,
          hitProtectionExpiresAt: true,
          mollieSubscriptionId: true,
        },
      }),
      prisma.crewMember.findFirst({
        where: { playerId },
        include: {
          crew: {
            select: {
              id: true,
              isVip: true,
              vipExpiresAt: true,
              mollieSubscriptionId: true,
            },
          },
        },
      }),
    ]);

    return res.json({
      paymentProvider: 'mollie',
      playerVip: {
        isVip: player?.isVip || false,
        expiresAt: player?.vipExpiresAt || null,
        subscriptionId: player?.mollieSubscriptionId || null,
        monthlyPriceEur: PLAYER_VIP_PRICE_EUR,
      },
      crewVip: membership
        ? {
            crewId: membership.crew.id,
            isVip: membership.crew.isVip,
            expiresAt: membership.crew.vipExpiresAt,
            subscriptionId: membership.crew.mollieSubscriptionId || null,
            monthlyPriceEur: CREW_VIP_PRICE_EUR,
          }
        : null,
      credits: {
        balance: player?.premiumCredits ?? 0,
        hitProtectionExpiresAt: player?.hitProtectionExpiresAt ?? null,
      },
    });
  } catch (error) {
    return next(error);
  }
});

router.post('/webhook', async (req: Request, res: Response) => {
  try {
    const mollie = getMollieClient();
    const paymentId = extractWebhookPaymentId(req);

    if (!paymentId) {
      return res.status(400).json({ error: 'Missing payment id' });
    }

    const payment = await mollie.payments.get(paymentId);
    const metadata = ((payment.metadata || {}) as PaymentMetadata) || null;

    if (!metadata?.playerId || !metadata.type) {
      return res.json({ received: true });
    }

    await upsertPaymentTransaction({
      playerId: Number(metadata.playerId),
      checkoutType: metadata.type === 'one_time' ? 'ONE_TIME' : metadata.type === 'crew_vip' ? 'CREW_VIP' : 'PLAYER_VIP',
      productKey: metadata.productKey ?? null,
      amountValue: payment.amount.value,
      description: payment.description,
      providerPaymentId: payment.id,
      providerCustomerId: payment.customerId || null,
      providerSubscriptionId: payment.subscriptionId || null,
      status: mapMollieStatus(payment.status),
      paidAt: payment.paidAt ? new Date(payment.paidAt) : null,
      metadata,
    });

    if (payment.status === 'paid') {
      if (metadata.type === 'one_time') {
        await fulfillOneTimePurchase(payment.id, metadata);
      } else {
        const subscriptionId = payment.subscriptionId || (payment.customerId ? await ensureVipSubscription(metadata, payment.customerId) : undefined);
        await activateVipFromMetadata(metadata, subscriptionId);
      }
    }

    if ((payment.status === 'canceled' || payment.status === 'failed' || payment.status === 'expired') && payment.subscriptionId) {
      await deactivateVipForSubscription(metadata, payment.subscriptionId);
    }

    return res.json({ received: true });
  } catch (error) {
    console.error('[Mollie webhook] error:', error);
    return res.status(500).json({ error: 'Webhook processing failed' });
  }
});

export default router;

