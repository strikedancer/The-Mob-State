import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { playerService } from '../services/playerService';
import prisma from '../lib/prisma';
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

// Get player settings
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const player = await playerService.getPlayer(req.player!.id);
    const notificationPreferences = await playerNotificationPreferenceService.getPreferences(req.player!.id);
    
    return res.status(200).json({
      avatar: player.avatar,
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

    // Update avatar
    await prisma.player.update({
      where: { id: playerId },
      data: {
        avatar,
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
