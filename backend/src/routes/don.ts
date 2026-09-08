import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { donService } from '../services/donService';
import prisma from '../lib/prisma';

const router = Router();

function fail(res: Response, error: unknown) {
  const message = error instanceof Error ? error.message : 'UNKNOWN_ERROR';
  if (message === 'DON_DISABLED') {
    return res.status(403).json({ event: 'don.error', params: { reason: 'DISABLED' } });
  }
  if (message.startsWith('DON_RANK_TOO_LOW:')) {
    return res.status(403).json({
      event: 'don.error',
      params: { reason: 'RANK_TOO_LOW', requiredRank: parseInt(message.split(':')[1], 10) || 7 },
    });
  }
  if (message === 'PLAYER_JAILED') {
    return res.status(403).json({ event: 'don.error', params: { reason: 'JAILED' } });
  }
  if (message === 'WRONG_COUNTRY') {
    return res.status(400).json({ event: 'don.error', params: { reason: 'WRONG_COUNTRY' } });
  }
  if (message === 'INSUFFICIENT_FUNDS') {
    return res.status(400).json({ event: 'don.error', params: { reason: 'INSUFFICIENT_FUNDS' } });
  }
  if (message.startsWith('DON_INTIMIDATION_TOO_LOW:')) {
    const parts = message.split(':');
    return res.status(400).json({
      event: 'don.error',
      params: { reason: 'INTIMIDATION', needed: parseInt(parts[1], 10) || 0, have: parseInt(parts[2], 10) || 0 },
    });
  }
  if (message.startsWith('DON_COLLECT_COOLDOWN:')) {
    return res.status(429).json({
      event: 'don.error',
      params: { reason: 'COLLECT_COOLDOWN', remainingSeconds: parseInt(message.split(':')[1], 10) || 0 },
    });
  }
  if (message.startsWith('DON_LOAN_AMOUNT:')) {
    const parts = message.split(':');
    return res.status(400).json({
      event: 'don.error',
      params: { reason: 'LOAN_AMOUNT', min: parseInt(parts[1], 10) || 0, max: parseInt(parts[2], 10) || 0 },
    });
  }
  if (message.startsWith('DON_ENGINEERING:')) {
    return res.status(400).json({
      event: 'don.error',
      params: { reason: 'ENGINEERING', requiredLevel: parseInt(message.split(':')[1], 10) || 0 },
    });
  }
  const mapped: Record<string, number> = {
    DON_RACKET_NOT_FOUND: 404,
    DON_RACKET_OWNED: 409,
    DON_RACKET_CAP: 400,
    DON_NOT_OWNER: 403,
    DON_RACKET_FREE: 400,
    DON_ALREADY_OWNER: 400,
    DON_CONTEST_ACTIVE: 409,
    DON_NO_CONTEST: 400,
    DON_NO_CREW_BANK_PERM: 403,
    DON_NPC_NOT_FOUND: 404,
    DON_LOAN_CAP: 400,
    DON_LOAN_SELF: 400,
    DON_LOAN_NOT_FOUND: 404,
    DON_LOAN_NOT_DUE: 400,
    DON_OFFICE_NOT_FOUND: 404,
    DON_CONTRACT_NOT_FOUND: 404,
    DON_ALDERMAN_REQUIRED: 403,
    PLAYER_NOT_FOUND: 404,
  };
  if (mapped[message]) {
    return res.status(mapped[message]).json({ event: 'don.error', params: { reason: message.replace(/^DON_/, '') } });
  }
  console.error('[don]', error);
  return res.status(500).json({ event: 'error.internal', params: {} });
}

router.get('/overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const overview = await donService.getOverview(req.player!.id);
    return res.status(200).json({ event: 'don.overview', params: {}, ...overview });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/claim', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.claimRacket(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.racket_claimed', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/collect', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.collectRacket(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.racket_collected', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/squeeze', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.squeezeRacket(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.racket_squeezed', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/tribute', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const tributeToCrew = Boolean(req.body?.tributeToCrew);
    const result = await donService.setTributeDestination(req.player!.id, Number(req.params.id), tributeToCrew);
    return res.status(200).json({ event: 'don.tribute_set', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/contest', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.contestRacket(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.racket_contested', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/rackets/:id/hold', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.holdRacket(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.racket_held', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/loans/npc', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.placeNpcLoan(
      req.player!.id,
      String(req.body?.npcKey ?? ''),
      Number(req.body?.principal ?? 0)
    );
    return res.status(200).json({ event: 'don.loan_npc', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/loans/offer', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    let borrowerId = Number(req.body?.borrowerId ?? 0);
    const username = String(req.body?.borrowerUsername ?? '').trim();
    if (!borrowerId && username) {
      const found = await prisma.player.findFirst({
        where: { username },
        select: { id: true },
      });
      if (!found) {
        throw new Error('PLAYER_NOT_FOUND');
      }
      borrowerId = found.id;
    }
    const result = await donService.offerPlayerLoan(
      req.player!.id,
      borrowerId,
      Number(req.body?.principal ?? 0)
    );
    return res.status(200).json({ event: 'don.loan_offered', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/loans/:id/accept', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.acceptLoan(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.loan_accepted', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/loans/:id/repay', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.repayLoan(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.loan_repaid', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/loans/:id/collect', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.collectDefaultedLoan(req.player!.id, Number(req.params.id));
    return res.status(200).json({ event: 'don.loan_collected', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/officials/:office/bribe', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.bribeOfficial(req.player!.id, String(req.params.office));
    return res.status(200).json({ event: 'don.official_bribed', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/contracts/:id/bid', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await donService.bidContract(req.player!.id, Number(req.params.id), {
      fromCrew: Boolean(req.body?.fromCrew),
      greedy: Boolean(req.body?.greedy),
    });
    return res.status(200).json({ event: 'don.contract_bid', params: result, result });
  } catch (error) {
    return fail(res, error);
  }
});

export default router;
