import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { hospitalService } from '../services/hospitalService';

const router = Router();

// Get hospital info
router.get('/info', (_req, res: Response) => {
  const info = hospitalService.getHospitalInfo();

  return res.status(200).json({
    event: 'hospital.info',
    params: {
      cost: info.cost,
      healAmount: info.healAmount,
      treatmentOptions: info.treatmentOptions,
    },
  });
});

// Emergency room - free healing for critically low HP
router.post('/emergency', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const result = await hospitalService.emergencyRoom(req.player!.id);

    return res.status(200).json({
      event: 'hospital.emergency',
      params: {
        healthRestored: result.healthRestored,
      },
      player: {
        health: result.newHealth,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'NOT_CRITICAL') {
        return res.status(400).json({
          event: 'hospital.error',
          params: { reason: 'NOT_CRITICAL' },
        });
      }
    }

    return res.status(500).json({
      event: 'hospital.error',
      params: { reason: 'UNKNOWN_ERROR' },
    });
  }
});

// Heal player at hospital
router.post('/heal', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const treatmentType =
      req.body?.treatmentType === 'intensive' ? 'intensive' : 'standard';
    const result = await hospitalService.heal(req.player!.id, treatmentType);

    return res.status(200).json({
      event: 'hospital.healed',
      params: {
        healthRestored: result.healthRestored,
        cost: result.cost,
        treatmentType: result.treatmentType,
      },
      player: {
        health: result.newHealth,
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'ALREADY_FULL_HEALTH') {
        return res.status(400).json({
          event: 'hospital.error',
          params: { reason: 'ALREADY_FULL_HEALTH' },
        });
      }

      if (error.message === 'PLAYER_DEAD') {
        return res.status(400).json({
          event: 'hospital.error',
          params: { reason: 'PLAYER_DEAD' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'hospital.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message.startsWith('ON_COOLDOWN:')) {
        const minutes = error.message.split(':')[1];
        return res.status(400).json({
          event: 'hospital.error',
          params: { reason: 'ON_COOLDOWN', remainingMinutes: parseInt(minutes) },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get treatment cooldown status for current player
router.get('/cooldown', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const status = await hospitalService.getCooldownStatus(req.player!.id);
    return res.status(200).json({
      event: 'hospital.cooldown',
      params: status,
    });
  } catch {
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

export default router;
