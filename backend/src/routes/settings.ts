import { Router, Response } from 'express';
import multer from 'multer';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { playerService } from '../services/playerService';
import prisma from '../lib/prisma';
import {
  MAX_PLAYER_PORTRAITS,
  PORTRAIT_SELFIE_CREDIT_COST,
  SELFIE_MAX_BYTES,
} from '../constants/playerPortrait';
import {
  createPortraitFromSelfie,
  deletePortrait,
  listPortraits,
  selectPortrait,
} from '../services/playerPortraitService';
import {
  playerNotificationPreferenceService,
  type PlayerNotificationPreferenceUpdate,
} from '../services/playerNotificationPreferenceService';
import { 
  isAvatarAvailable, 
  canChangeAvatar, 
  canChangeUsername,
  AVATARS 
} from '../utils/rankSystem';

const router = Router();

const selfieUpload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: SELFIE_MAX_BYTES },
  fileFilter: (_req, file, cb) => {
    const ok =
      file.mimetype === 'image/jpeg' ||
      file.mimetype === 'image/png' ||
      file.mimetype === 'image/webp';
    cb(null, ok);
  },
});

// Get player settings
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const player = await playerService.getPlayer(req.player!.id);
    const notificationPreferences = await playerNotificationPreferenceService.getPreferences(req.player!.id);

    return res.status(200).json({
      avatar: player.avatar,
      activePortraitId: player.activePortraitId,
      activePortraitPath: player.activePortraitPath,
      premiumCredits: player.premiumCredits,
      portraitSelfieCreditCost: PORTRAIT_SELFIE_CREDIT_COST,
      maxPlayerPortraits: MAX_PLAYER_PORTRAITS,
      gender: player.gender,
      allowMessages: player.allowMessages,
      preferredLanguage: player.preferredLanguage,
      lastAvatarChange: player.lastAvatarChange,
      lastUsernameChange: player.lastUsernameChange,
      canChangeAvatar: canChangeAvatar(player.lastAvatarChange),
      canChangeUsername: canChangeUsername(player.lastUsernameChange),
      isVip: player.isVip,
      vipExpiresAt: player.vipExpiresAt,
      notificationPreferences,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Update notification preferences
router.post('/notifications', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const body = req.body ?? {};

    const updates: PlayerNotificationPreferenceUpdate = {};
    const allowedKeys: Array<keyof PlayerNotificationPreferenceUpdate> = [
      'pushCryptoTrade',
      'pushCryptoPriceAlert',
      'pushCryptoOrder',
      'pushCryptoMission',
      'pushCryptoLeaderboard',
      'pushGameEvents',
      'inAppCryptoTrade',
      'inAppCryptoPriceAlert',
      'inAppCryptoOrder',
      'inAppCryptoMission',
      'inAppCryptoLeaderboard',
    ];

    for (const key of allowedKeys) {
      if (typeof body[key] === 'boolean') {
        updates[key] = body[key];
      }
    }

    const preferences = await playerNotificationPreferenceService.updatePreferences(playerId, updates);

    return res.status(200).json({
      event: 'settings.notifications.updated',
      params: preferences,
      notificationPreferences: preferences,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get available avatars
router.get('/avatars', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const player = await playerService.getPlayer(req.player!.id);
    
    return res.status(200).json({
      free: AVATARS.free,
      vip: AVATARS.vip,
      current: player.avatar,
      isVip: player.isVip,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Change avatar
router.post('/avatar', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { avatar } = req.body;
    const playerId = req.player!.id;
    const player = await playerService.getPlayer(playerId);

    // Check if can change avatar
    if (!canChangeAvatar(player.lastAvatarChange)) {
      return res.status(400).json({
        event: 'error.avatar_cooldown',
        params: {
          nextChange: new Date(player.lastAvatarChange!.getTime() + 7 * 24 * 60 * 60 * 1000),
        },
      });
    }

    // Check if avatar is available
    if (!isAvatarAvailable(avatar, player.isVip || false)) {
      return res.status(400).json({
        event: 'error.avatar_not_available',
        params: {},
      });
    }

    // Update avatar (preset); clear active custom portrait so the preset is shown.
    await prisma.player.update({
      where: { id: playerId },
      data: {
        avatar,
        activePortraitId: null,
        lastAvatarChange: new Date(),
      },
    });

    return res.status(200).json({
      event: 'avatar.updated',
      params: { avatar },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Change username
router.post('/username', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { username } = req.body;
    const playerId = req.player!.id;
    const player = await playerService.getPlayer(playerId);

    // Check if can change username
    if (!canChangeUsername(player.lastUsernameChange)) {
      return res.status(400).json({
        event: 'error.username_cooldown',
        params: {
          nextChange: new Date(player.lastUsernameChange!.getTime() + 30 * 24 * 60 * 60 * 1000),
        },
      });
    }

    // Validate username
    if (!username || username.length < 3 || username.length > 20) {
      return res.status(400).json({
        event: 'error.invalid_username',
        params: {},
      });
    }

    // Check if username exists
    const existing = await prisma.player.findUnique({
      where: { username },
    });

    if (existing && existing.id !== playerId) {
      return res.status(400).json({
        event: 'error.username_taken',
        params: {},
      });
    }

    // Update username
    await prisma.player.update({
      where: { id: playerId },
      data: {
        username,
        lastUsernameChange: new Date(),
      },
    });

    return res.status(200).json({
      event: 'username.updated',
      params: { username },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// --- Custom portraits (selfie → gangster, library) ---

router.get('/portraits', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const items = await listPortraits(playerId);
    return res.status(200).json({
      event: 'settings.portraits.list',
      params: {
        portraits: items,
        maxPortraits: MAX_PLAYER_PORTRAITS,
        creditCost: PORTRAIT_SELFIE_CREDIT_COST,
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post(
  '/portraits/from-selfie',
  authenticate,
  selfieUpload.single('selfie'),
  async (req: AuthRequest, res: Response) => {
    try {
      req.setTimeout(360_000);
      const consent = String(req.body?.consent ?? '').toLowerCase();
      if (consent !== 'true' && consent !== '1' && consent !== 'yes') {
        return res.status(400).json({
          event: 'error.portrait_consent_required',
          params: {},
        });
      }
      const file = req.file;
      if (!file?.buffer?.length) {
        return res.status(400).json({
          event: 'error.portrait_selfie_missing',
          params: {},
        });
      }

      const playerId = req.player!.id;
      const result = await createPortraitFromSelfie(playerId, file.buffer, file.mimetype);

      return res.status(200).json({
        event: 'settings.portrait.created',
        params: {
          portrait: result.portrait,
          premiumCredits: result.premiumCredits,
          activePortraitId: result.activePortraitId,
        },
      });
    } catch (e: unknown) {
      const err = e as { code?: string; message?: string; available?: number; required?: number };
      if (err.code === 'INSUFFICIENT_CREDITS') {
        return res.status(400).json({
          event: 'error.insufficient_credits',
          params: {
            required: err.required ?? PORTRAIT_SELFIE_CREDIT_COST,
            available: err.available ?? 0,
          },
        });
      }
      if (err.code === 'PORTRAIT_LIMIT') {
        return res.status(400).json({
          event: 'error.portrait_limit',
          params: { max: MAX_PLAYER_PORTRAITS },
        });
      }
      if (err.code === 'SELFIE_TOO_LARGE') {
        return res.status(400).json({
          event: 'error.portrait_selfie_too_large',
          params: { maxBytes: SELFIE_MAX_BYTES },
        });
      }
      if (err.message === 'LEONARDO_API_KEY_MISSING') {
        return res.status(503).json({
          event: 'error.portrait_generation_unavailable',
          params: {},
        });
      }
      console.error('[settings/portraits/from-selfie]', e);
      return res.status(500).json({
        event: 'error.internal',
        params: {},
      });
    }
  }
);

router.post('/portraits/select', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const raw = req.body?.portraitId;
    const portraitId =
      raw === null || raw === undefined || raw === ''
        ? null
        : typeof raw === 'number'
          ? raw
          : parseInt(String(raw), 10);

    if (portraitId !== null && (Number.isNaN(portraitId) || portraitId < 1)) {
      return res.status(400).json({
        event: 'error.invalid_request',
        params: {},
      });
    }

    await selectPortrait(playerId, portraitId);

    return res.status(200).json({
      event: 'settings.portrait.selected',
      params: { portraitId },
    });
  } catch (e: unknown) {
    const err = e as { code?: string };
    if (err.code === 'PORTRAIT_NOT_FOUND') {
      return res.status(404).json({
        event: 'error.portrait_not_found',
        params: {},
      });
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.delete('/portraits/:id', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const id = parseInt(req.params.id, 10);
    if (Number.isNaN(id)) {
      return res.status(400).json({ event: 'error.invalid_request', params: {} });
    }
    await deletePortrait(playerId, id);
    return res.status(200).json({
      event: 'settings.portrait.deleted',
      params: { id },
    });
  } catch (e: unknown) {
    const err = e as { code?: string };
    if (err.code === 'PORTRAIT_NOT_FOUND') {
      return res.status(404).json({
        event: 'error.portrait_not_found',
        params: {},
      });
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Update message settings
router.post('/messages', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { allowMessages } = req.body;
    const playerId = req.player!.id;

    await prisma.player.update({
      where: { id: playerId },
      data: { allowMessages },
    });

    return res.status(200).json({
      event: 'settings.updated',
      params: { allowMessages },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
