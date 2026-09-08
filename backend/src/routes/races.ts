import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { raceService } from '../services/raceService';

const router = Router();

function fail(res: Response, error: unknown) {
  const message = error instanceof Error ? error.message : 'UNKNOWN_ERROR';
  if (message === 'RACE_DISABLED') {
    return res.status(403).json({ event: 'race.error', params: { reason: 'DISABLED' } });
  }
  if (message.startsWith('RACE_RANK_TOO_LOW:')) {
    return res.status(403).json({
      event: 'race.error',
      params: { reason: 'RANK_TOO_LOW', requiredRank: parseInt(message.split(':')[1], 10) || 3 },
    });
  }
  if (message === 'PLAYER_JAILED') {
    return res.status(403).json({ event: 'race.error', params: { reason: 'JAILED' } });
  }
  if (message === 'PLAYER_TRAVELING') {
    return res.status(403).json({ event: 'race.error', params: { reason: 'TRAVELING' } });
  }
  if (message === 'INSUFFICIENT_FUNDS') {
    return res.status(400).json({ event: 'race.error', params: { reason: 'FUNDS' } });
  }
  if (message.startsWith('RACE_STAKE:')) {
    const parts = message.split(':');
    return res.status(400).json({
      event: 'race.error',
      params: { reason: 'STAKE', min: parseInt(parts[1], 10) || 0, max: parseInt(parts[2], 10) || 0 },
    });
  }
  if (message.startsWith('RACE_BET:')) {
    const parts = message.split(':');
    return res.status(400).json({
      event: 'race.error',
      params: { reason: 'BET', min: parseInt(parts[1], 10) || 0, max: parseInt(parts[2], 10) || 0 },
    });
  }
  const mapped: Record<string, number> = {
    PLAYER_NOT_FOUND: 404,
    RACE_COOLDOWN: 429,
    RACE_CLOSED: 400,
    RACE_ALREADY_ENTERED: 409,
    RACE_FULL: 400,
    RACE_VEHICLE_INVALID: 400,
    RACE_CONDITION: 400,
    RACE_ENTRY_NOT_FOUND: 404,
    RACE_BET_OWN: 400,
    RACE_BET_CAP: 400,
  };
  if (mapped[message]) {
    return res.status(mapped[message]).json({
      event: 'race.error',
      params: { reason: message.replace(/^RACE_/, '') },
    });
  }
  console.error('[races]', error);
  return res.status(500).json({ event: 'error.internal', params: {} });
}

router.get('/overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const overview = await raceService.getOverview(req.player!.id);
    return res.status(200).json({ event: 'race.overview', params: {}, ...overview });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/enter', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const overview = await raceService.enter(
      req.player!.id,
      Number(req.body?.vehicleInventoryId),
      Number(req.body?.stake),
      Boolean(req.body?.fixing),
    );
    return res.status(200).json({ event: 'race.entered', params: {}, ...overview });
  } catch (error) {
    return fail(res, error);
  }
});

router.post('/bet', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const overview = await raceService.bet(
      req.player!.id,
      Number(req.body?.entryId),
      Number(req.body?.amount),
    );
    return res.status(200).json({ event: 'race.bet', params: {}, ...overview });
  } catch (error) {
    return fail(res, error);
  }
});

export default router;
