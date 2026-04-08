import express, { Request, Response, NextFunction } from 'express';
import { authenticate } from '../middleware/authenticate';
import prisma from '../lib/prisma';
import { ammoService } from '../services/ammoService';
const StripeSdk = require('stripe');

const router = express.Router();

const stripeSecretKey = process.env.STRIPE_SECRET_KEY || '';
const stripeClient = stripeSecretKey ? new StripeSdk(stripeSecretKey) : null;

const APP_URL = process.env.APP_URL || 'http://localhost:3000';
const STRIPE_PLAYER_VIP_PRICE_ID = process.env.STRIPE_PLAYER_VIP_PRICE_ID || '';
const STRIPE_CREW_VIP_PRICE_ID = process.env.STRIPE_CREW_VIP_PRICE_ID || '';
const STRIPE_WEBHOOK_SECRET = process.env.STRIPE_WEBHOOK_SECRET || '';

const MAX_NON_VIP_BUILDING_LEVEL = 10;

type PremiumOfferRecord = {
  id: number;
  key: string;
  titleNl: string;
  titleEn: string;
  imageUrl: string | null;
  priceEurCents: number;
  rewardType: 'money' | 'ammo';
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
  isActive: boolean;
  showPopupOnOpen: boolean;
  sortOrder: number;
};

const premiumOfferRepo = (prisma as any).premiumOneTimeOffer as {
  findMany: (args: any) => Promise<PremiumOfferRecord[]>;
  findFirst: (args: any) => Promise<PremiumOfferRecord | null>;
};

const centsToEuroValue = (cents: number): string => (cents / 100).toFixed(2);

function getStripeClient() {
  if (!stripeClient) {
    throw new Error('Stripe is not configured. Missing STRIPE_SECRET_KEY');
  }

  return stripeClient;
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

async function activateVipFromMetadata(metadata: Record<string, string>, subscriptionId?: string): Promise<void> {
  const playerId = parseInt(metadata.playerId || '', 10);
  if (!playerId) return;

  const expiry = new Date();
  expiry.setDate(expiry.getDate() + 30);

  if (metadata.type === 'player_vip' || metadata.type === 'crew_vip') {
    await prisma.player.update({
      where: { id: playerId },
      data: { isVip: true, vipExpiresAt: expiry },
    });
  }

  if (metadata.type === 'crew_vip' && metadata.crewId) {
    const crewId = parseInt(metadata.crewId, 10);
    if (!crewId) return;

    await prisma.crew.update({
      where: { id: crewId },
      data: { isVip: true, vipExpiresAt: expiry, stripeSubscriptionId: subscriptionId || null },
    });
  }
}

async function deactivateVipFromMetadata(metadata: Record<string, string>, subscriptionId?: string): Promise<void> {
  const playerId = parseInt(metadata.playerId || '', 10);

  if (playerId) {
    await prisma.player.update({
      where: { id: playerId },
      data: { isVip: false, vipExpiresAt: null },
    });
  }

  if (metadata.type === 'crew_vip') {
    const crewId = parseInt(metadata.crewId || '', 10);
    if (crewId) {
      await prisma.crew.update({
        where: { id: crewId },
        data: { isVip: false, vipExpiresAt: null, stripeSubscriptionId: null },
      });
      await downgradeCrewAfterVipExpiry(crewId);
      return;
    }
  }

  if (subscriptionId) {
    const crew = await prisma.crew.findFirst({
      where: { stripeSubscriptionId: subscriptionId },
      select: { id: true },
    });

    if (crew) {
      await prisma.crew.update({
        where: { id: crew.id },
        data: { isVip: false, vipExpiresAt: null, stripeSubscriptionId: null },
      });
      await downgradeCrewAfterVipExpiry(crew.id);
    }
  }
}

async function getOrCreateStripeCustomer(playerId: number, email: string | null | undefined): Promise<string> {
  const stripe = getStripeClient();

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { stripeCustomerId: true },
  });

  if (player?.stripeCustomerId) {
    return player.stripeCustomerId;
  }

  const customer = await stripe.customers.create({
    email: email || undefined,
    name: `Player_${playerId}`,
    metadata: { playerId: String(playerId) },
  });

  await prisma.player.update({
    where: { id: playerId },
    data: { stripeCustomerId: customer.id },
  });

  return customer.id;
}

async function fulfillOneTimePurchase(sessionId: string, metadata: Record<string, string | undefined>): Promise<void> {
  const playerId = Number(metadata.playerId);
  const productKey = metadata.productKey || '';
  const rewardType = metadata.rewardType || '';
  const moneyAmount = Number(metadata.moneyAmount || 0);
  const ammoType = metadata.ammoType || '';
  const ammoQuantity = Number(metadata.ammoQuantity || 0);

  if (!Number.isFinite(playerId) || playerId <= 0 || !productKey) {
    console.warn('[Stripe webhook] Invalid one-time payment metadata', { sessionId, metadata });
    return;
  }

  if (rewardType !== 'money' && rewardType !== 'ammo') {
    console.warn('[Stripe webhook] Unknown one-time reward type', { sessionId, rewardType });
    return;
  }

  const insertedRows = await prisma.$executeRawUnsafe(
    `INSERT IGNORE INTO stripe_payment_fulfillments (stripeSessionId, playerId, productKey, payload, fulfilledAt)
     VALUES (?, ?, ?, CAST(? AS JSON), NOW(3))`,
    sessionId,
    playerId,
    productKey,
    JSON.stringify(metadata)
  );

  if (Number(insertedRows) === 0) {
    return;
  }

  if (rewardType === 'money') {
    if (!Number.isFinite(moneyAmount) || moneyAmount <= 0) {
      console.warn('[Stripe webhook] Invalid money amount in metadata', { sessionId, moneyAmount });
      return;
    }

    await prisma.player.update({
      where: { id: playerId },
      data: { money: { increment: moneyAmount } },
    });

    return;
  }

  if (!ammoType || !Number.isFinite(ammoQuantity) || ammoQuantity <= 0) {
    console.warn('[Stripe webhook] Invalid ammo metadata', { sessionId, ammoType, ammoQuantity });
    return;
  }

  const ammoDef = ammoService.getAmmoDefinition(ammoType);
  if (!ammoDef) {
    console.warn('[Stripe webhook] Ammo definition not found', { sessionId, ammoType });
    return;
  }

  const existing = await prisma.ammoInventory.findUnique({
    where: {
      playerId_ammoType: {
        playerId,
        ammoType,
      },
    },
  });

  const currentQty = existing?.quantity ?? 0;
  const newQty = Math.min(currentQty + ammoQuantity, ammoDef.maxInventory);

  if (existing) {
    await prisma.ammoInventory.update({
      where: { id: existing.id },
      data: { quantity: newQty },
    });
  } else {
    await prisma.ammoInventory.create({
      data: {
        playerId,
        ammoType,
        quantity: newQty,
        quality: 1.0,
      },
    });
  }
}

router.post('/checkout/player-vip', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const stripe = getStripeClient();

    if (!STRIPE_PLAYER_VIP_PRICE_ID) {
      return res.status(500).json({ event: 'error.payment_provider_misconfigured', params: {} });
    }

    const playerId = (req as any).player?.id as number;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { email: true },
    });

    const customerId = await getOrCreateStripeCustomer(playerId, player?.email);

    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      customer: customerId,
      line_items: [{ price: STRIPE_PLAYER_VIP_PRICE_ID, quantity: 1 }],
      success_url: `${APP_URL}/premium?status=success`,
      cancel_url: `${APP_URL}/premium?status=cancelled`,
      metadata: {
        type: 'player_vip',
        playerId: String(playerId),
      },
      subscription_data: {
        metadata: {
          type: 'player_vip',
          playerId: String(playerId),
        },
      },
    });

    if (!session.url) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: session.url });
  } catch (error: unknown) {
    console.error('[Stripe] checkout/player-vip error:', error);
    return next(error);
  }
});

router.post('/checkout/crew-vip', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const stripe = getStripeClient();

    if (!STRIPE_CREW_VIP_PRICE_ID) {
      return res.status(500).json({ event: 'error.payment_provider_misconfigured', params: {} });
    }

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

    const customerId = await getOrCreateStripeCustomer(playerId, player?.email);

    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      customer: customerId,
      line_items: [{ price: STRIPE_CREW_VIP_PRICE_ID, quantity: 1 }],
      success_url: `${APP_URL}/premium?status=success`,
      cancel_url: `${APP_URL}/premium?status=cancelled`,
      metadata: {
        type: 'crew_vip',
        playerId: String(playerId),
        crewId: String(crewId),
      },
      subscription_data: {
        metadata: {
          type: 'crew_vip',
          playerId: String(playerId),
          crewId: String(crewId),
        },
      },
    });

    if (!session.url) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: session.url });
  } catch (error: unknown) {
    console.error('[Stripe] checkout/crew-vip error:', error);
    return next(error);
  }
});

router.get('/checkout/one-time/catalog', authenticate, async (_req: Request, res: Response) => {
  const products = await listActivePremiumOffers();

  return res.json({
    products: products.map((offer: PremiumOfferRecord) => ({
      key: offer.key,
      titleNl: offer.titleNl,
      titleEn: offer.titleEn,
      imageUrl: offer.imageUrl,
      priceEur: centsToEuroValue(offer.priceEurCents),
      reward: offer.rewardType === 'money'
        ? { type: 'money', amount: offer.moneyAmount ?? 0 }
        : { type: 'ammo', ammoType: offer.ammoType ?? '', quantity: offer.ammoQuantity ?? 0 },
    })),
  });
});

router.get('/checkout/one-time/popup', authenticate, async (req: Request, res: Response) => {
  const playerId = (req as any).player?.id as number;
  const locale = (req.query.locale as string | undefined)?.toLowerCase() === 'nl' ? 'nl' : 'en';

  const offer = await prisma.$queryRawUnsafe<any[]>(
    `SELECT o.id, o.key, o.titleNl, o.titleEn, o.imageUrl, o.priceEurCents, o.rewardType, o.moneyAmount, o.ammoType, o.ammoQuantity
     FROM premium_one_time_offers o
     LEFT JOIN player_premium_popup_seen s ON s.offerId = o.id AND s.playerId = ?
     WHERE o.isActive = 1 AND o.showPopupOnOpen = 1 AND s.id IS NULL
     ORDER BY o.sortOrder ASC, o.id ASC
     LIMIT 1`,
    playerId
  );

  if (!offer || offer.length === 0) {
    return res.json({ popup: null });
  }

  const item = offer[0];

  const reward = item.rewardType === 'money'
    ? `+€${item.moneyAmount ?? 0}`
    : `${item.ammoType ?? ''} x${item.ammoQuantity ?? 0}`;

  return res.json({
    popup: {
      key: item.key,
      title: locale === 'nl' ? item.titleNl : item.titleEn,
      imageUrl: item.imageUrl,
      priceEur: centsToEuroValue(item.priceEurCents),
      reward,
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
    offer.id
  );

  return res.json({ success: true });
});

router.post('/checkout/one-time', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const stripe = getStripeClient();

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

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { email: true },
    });

    const customerId = await getOrCreateStripeCustomer(playerId, player?.email);

    const session = await stripe.checkout.sessions.create({
      mode: 'payment',
      customer: customerId,
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: 'eur',
            unit_amount: product.priceEurCents,
            product_data: {
              name: product.titleEn,
              metadata: { productKey: product.key },
            },
          },
        },
      ],
      success_url: `${APP_URL}/premium?status=paid`,
      cancel_url: `${APP_URL}/premium?status=cancelled`,
      metadata: {
        type: 'one_time',
        playerId: String(playerId),
        productKey: product.key,
        rewardType: product.rewardType,
        moneyAmount: product.moneyAmount ? String(product.moneyAmount) : undefined,
        ammoType: product.ammoType || undefined,
        ammoQuantity: product.ammoQuantity ? String(product.ammoQuantity) : undefined,
      },
    });

    if (!session.url) {
      return res.status(500).json({ event: 'error.payment_creation_failed', params: {} });
    }

    return res.json({ url: session.url });
  } catch (error: unknown) {
    console.error('[Stripe] checkout/one-time error:', error);
    return next(error);
  }
});

router.get('/status', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const playerId = (req as any).player?.id as number;
    const player = await prisma.player.findUnique({ where: { id: playerId }, select: { isVip: true, vipExpiresAt: true } });
    const membership = await prisma.crewMember.findFirst({
      where: { playerId },
      include: { crew: { select: { id: true, isVip: true, vipExpiresAt: true } } },
    });

    return res.json({
      playerVip: { isVip: player?.isVip || false, expiresAt: player?.vipExpiresAt || null },
      crewVip: membership ? { crewId: membership.crew.id, isVip: membership.crew.isVip, expiresAt: membership.crew.vipExpiresAt } : null,
    });
  } catch (error) {
    return next(error);
  }
});

router.post('/webhook', async (req: Request, res: Response) => {
  try {
    const stripe = getStripeClient();

    if (!STRIPE_WEBHOOK_SECRET) {
      return res.status(500).json({ error: 'Missing STRIPE_WEBHOOK_SECRET' });
    }

    const signature = req.headers['stripe-signature'];
    if (!signature || typeof signature !== 'string') {
      return res.status(400).json({ error: 'Missing stripe-signature header' });
    }

    const event = stripe.webhooks.constructEvent(req.body, signature, STRIPE_WEBHOOK_SECRET);

    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object as any;
        const metadata = (session.metadata || {}) as Record<string, string>;

        if (session.mode === 'payment' && metadata.type === 'one_time') {
          await fulfillOneTimePurchase(session.id, metadata);
        }
        break;
      }

      case 'customer.subscription.created':
      case 'customer.subscription.updated': {
        const subscription = event.data.object as any;
        const metadata = (subscription.metadata || {}) as Record<string, string>;

        if (subscription.status === 'active' || subscription.status === 'trialing') {
          await activateVipFromMetadata(metadata, subscription.id);
        }
        break;
      }

      case 'customer.subscription.deleted': {
        const subscription = event.data.object as any;
        const metadata = (subscription.metadata || {}) as Record<string, string>;
        await deactivateVipFromMetadata(metadata, subscription.id);
        break;
      }

      default:
        break;
    }

    return res.json({ received: true });
  } catch (error) {
    console.error('[Stripe webhook] error:', error);
    return res.status(500).json({ error: 'Webhook processing failed' });
  }
});

export default router;
