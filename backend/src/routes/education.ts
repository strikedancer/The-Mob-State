import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { educationService } from '../services/educationService';

const router = Router();

router.get('/tracks', authenticate, (_req: AuthRequest, res: Response) => {
  return res.status(200).json({
    event: 'education.tracks',
    params: {},
    tracks: educationService.getTracks(),
  });
});

router.get('/gates', authenticate, (_req: AuthRequest, res: Response) => {
  return res.status(200).json({
    event: 'education.gates',
    params: {},
    gates: educationService.getEducationGates(),
  });
});

router.get('/profile', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const profile = await educationService.getPlayerEducationProfile(req.player!.id);

    return res.status(200).json({
      event: 'education.profile',
      params: {},
      profile,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/tracks/:trackId/train', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const trackId = req.params.trackId as string;
    const result = await educationService.trainTrack(req.player!.id, trackId, req.player!.rank);

    return res.status(200).json({
      event: 'education.training_completed',
      params: {
        trackId: result.trackId,
        xpGain: result.xpGain,
        totalXp: result.totalXp,
        previousLevel: result.previousLevel,
        newLevel: result.newLevel,
        levelUps: result.levelUps,
        certificationsEarned: result.certificationsEarned,
        cooldownSeconds: result.cooldownSeconds,
      },
      result,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'UNKNOWN_ERROR';

    if (message === 'TRACK_NOT_FOUND') {
      return res.status(404).json({
        event: 'education.error',
        params: {
          reason: 'TRACK_NOT_FOUND',
        },
      });
    }

    if (message.startsWith('TRACK_RANK_TOO_LOW:')) {
      const requiredRank = parseInt(message.split(':')[1], 10) || 1;
      return res.status(403).json({
        event: 'education.error',
        params: {
          reason: 'TRACK_RANK_TOO_LOW',
          requiredRank,
          currentRank: req.player!.rank,
        },
      });
    }

    if (message === 'TRACK_MAX_LEVEL_REACHED') {
      return res.status(400).json({
        event: 'education.error',
        params: {
          reason: 'TRACK_MAX_LEVEL_REACHED',
        },
      });
    }

    if (message.startsWith('TRACK_ON_COOLDOWN:')) {
      const parts = message.split(':');
      const remainingSeconds = parseInt(parts[1] || '0', 10) || 0;
      const cooldownSeconds = parseInt(parts[2] || '0', 10) || 0;

      return res.status(429).json({
        event: 'education.error',
        params: {
          reason: 'TRACK_ON_COOLDOWN',
          remainingSeconds,
          cooldownSeconds,
        },
      });
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
