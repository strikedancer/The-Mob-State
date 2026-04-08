console.log('🔥🔥🔥 [NOTIFICATIONS.TS] FILE LOADED 🔥🔥🔥');
import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/authenticate';
import prisma from '../lib/prisma';

const router = Router();
console.log('🔥🔥🔥 [NOTIFICATIONS.TS] ROUTER CREATED 🔥🔥🔥');

/**
 * POST /notifications/register-token
 * Register FCM device token for push notifications
 */
router.post('/register-token', authenticate, async (req: Request, res: Response) => {
  console.log('[Notifications] /register-token called');
  try {
    const playerId = (req as any).player.id;
    const { token, deviceType } = req.body;

    console.log('[Notifications] PlayerId:', playerId, 'DeviceType:', deviceType);

    if (!token || !deviceType) {
      console.log('[Notifications] ❌ Missing token or deviceType');
      return res.status(400).json({ error: 'Token and deviceType are required' });
    }

    if (!['android', 'ios', 'web'].includes(deviceType)) {
      console.log('[Notifications] ❌ Invalid deviceType:', deviceType);
      return res.status(400).json({ error: 'Invalid deviceType. Must be android, ios, or web' });
    }

    console.log('[Notifications] Checking for existing device...');
    // Check if token already exists
    const existingDevice = await prisma.playerDevice.findFirst({
      where: { deviceToken: token }
    });

    if (existingDevice) {
      console.log('[Notifications] Found existing device:', existingDevice.id);
      // Update existing device with new playerId if different
      if (existingDevice.playerId !== playerId) {
        console.log('[Notifications] Updating device to new playerId');
        await prisma.playerDevice.update({
          where: { id: existingDevice.id },
          data: { playerId }
        });
      }
      return res.json({ success: true, message: 'Device token updated' });
    }

    console.log('[Notifications] Creating new device record...');
    // Create new device record
    await prisma.playerDevice.create({
      data: {
        playerId,
        deviceToken: token,
        deviceType
      }
    });

    console.log(`[Notifications] ✅ Registered ${deviceType} device for player ${playerId}`);

    res.json({ success: true, message: 'Device token registered' });
  } catch (error: any) {
    console.error('[Notifications] ❌ Error registering device token:', error);
    console.error('[Notifications] ❌ Error stack:', error.stack);
    res.status(500).json({ error: 'Failed to register device token' });
  }
});

/**
 * DELETE /notifications/unregister-token
 * Remove FCM device token (e.g., on logout)
 */
router.delete('/unregister-token', authenticate, async (req: Request, res: Response) => {
  try {
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ error: 'Token is required' });
    }

    await prisma.playerDevice.deleteMany({
      where: { deviceToken: token }
    });

    console.log(`[Notifications] Unregistered device token`);

    res.json({ success: true, message: 'Device token unregistered' });
  } catch (error: any) {
    console.error('[Notifications] Error unregistering device token:', error);
    res.status(500).json({ error: 'Failed to unregister device token' });
  }
});

export default router;
