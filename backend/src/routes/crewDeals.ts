import { Router, Response, NextFunction } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { crewDealService, type DealOfferInput } from '../services/crewDealService';

const router = Router();

const stackSchema = z.object({
  weaponId: z.string().min(1).optional(),
  ammoType: z.string().min(1).optional(),
  drugType: z.string().min(1).optional(),
  quality: z.string().max(2).optional(),
  goodType: z.string().min(1).optional(),
  quantity: z.number().int().positive(),
});

const offerSchema = z.object({
  cash: z.number().int().nonnegative().optional(),
  carIds: z.array(z.number().int().positive()).max(8).optional(),
  boatIds: z.array(z.number().int().positive()).max(8).optional(),
  weapons: z.array(stackSchema.extend({ weaponId: z.string().min(1) })).max(12).optional(),
  ammo: z.array(stackSchema.extend({ ammoType: z.string().min(1) })).max(12).optional(),
  drugs: z.array(stackSchema.extend({ drugType: z.string().min(1) })).max(12).optional(),
  trade: z.array(stackSchema.extend({ goodType: z.string().min(1) })).max(12).optional(),
});

const createSchema = offerSchema.extend({
  targetCrewId: z.number().int().positive(),
});

function mapDealError(error: unknown, res: Response, next: NextFunction) {
  if (error instanceof z.ZodError) {
    return res.status(400).json({ event: 'error.invalid_deal', params: {} });
  }
  if (!(error instanceof Error)) return next(error);
  const table: Record<string, { status: number; event: string }> = {
    NOT_IN_CREW: { status: 400, event: 'error.not_in_crew' },
    NOT_CREW_OFFICER: { status: 403, event: 'error.not_crew_officer' },
    TARGET_CREW_NOT_FOUND: { status: 404, event: 'error.target_crew_not_found' },
    DEAL_SAME_CREW: { status: 400, event: 'error.deal_same_crew' },
    DEAL_EMPTY_OFFER: { status: 400, event: 'error.deal_empty_offer' },
    DEAL_ITEM_MISSING: { status: 409, event: 'error.deal_item_missing' },
    INSUFFICIENT_CREW_FUNDS: { status: 400, event: 'error.insufficient_crew_funds' },
    DEAL_LIMIT: { status: 429, event: 'error.deal_limit' },
    DEAL_NOT_FOUND: { status: 404, event: 'error.deal_not_found' },
    DEAL_NOT_COUNTERABLE: { status: 409, event: 'error.deal_not_counterable' },
    DEAL_NOT_CONFIRMABLE: { status: 409, event: 'error.deal_not_confirmable' },
    DEAL_NOT_CANCELABLE: { status: 409, event: 'error.deal_not_cancelable' },
    DEAL_NO_CAPACITY: { status: 409, event: 'error.deal_no_capacity' },
  };
  const mapped = table[error.message];
  if (!mapped) return next(error);
  return res.status(mapped.status).json({ event: mapped.event, params: {} });
}

function asOffer(body: z.infer<typeof offerSchema>): DealOfferInput {
  return {
    cash: body.cash,
    carIds: body.carIds,
    boatIds: body.boatIds,
    weapons: body.weapons?.map((row) => ({ weaponId: row.weaponId!, quantity: row.quantity })),
    ammo: body.ammo?.map((row) => ({ ammoType: row.ammoType!, quantity: row.quantity })),
    drugs: body.drugs?.map((row) => ({
      drugType: row.drugType!,
      quality: row.quality,
      quantity: row.quantity,
    })),
    trade: body.trade?.map((row) => ({ goodType: row.goodType!, quantity: row.quantity })),
  };
}

router.get('/', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const payload = await crewDealService.list(req.player!.id);
    return res.json({ event: 'crew_deals.list', params: payload });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

router.get('/partners', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const q = typeof req.query.q === 'string' ? req.query.q : '';
    const partners = await crewDealService.partners(req.player!.id, q);
    return res.json({ event: 'crew_deals.partners', params: { partners } });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

router.post('/', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const body = createSchema.parse(req.body);
    const deal = await crewDealService.create(req.player!.id, body.targetCrewId, asOffer(body));
    return res.status(201).json({ event: 'crew_deals.created', params: { deal } });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

router.post('/:id/counter', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const dealId = Number(req.params.id);
    if (Number.isNaN(dealId)) {
      return res.status(400).json({ event: 'error.invalid_deal_id', params: {} });
    }
    const body = offerSchema.parse(req.body);
    const deal = await crewDealService.counter(req.player!.id, dealId, asOffer(body));
    return res.json({ event: 'crew_deals.countered', params: { deal } });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

router.post('/:id/confirm', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const dealId = Number(req.params.id);
    if (Number.isNaN(dealId)) {
      return res.status(400).json({ event: 'error.invalid_deal_id', params: {} });
    }
    const deal = await crewDealService.confirm(req.player!.id, dealId);
    return res.json({ event: 'crew_deals.confirmed', params: { deal } });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

router.post('/:id/cancel', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const dealId = Number(req.params.id);
    if (Number.isNaN(dealId)) {
      return res.status(400).json({ event: 'error.invalid_deal_id', params: {} });
    }
    const deal = await crewDealService.cancel(req.player!.id, dealId);
    return res.json({ event: 'crew_deals.cancelled', params: { deal } });
  } catch (error) {
    return mapDealError(error, res, next);
  }
});

export default router;
