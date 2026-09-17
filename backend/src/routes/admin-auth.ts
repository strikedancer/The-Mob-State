import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import prisma from '../lib/prisma';
import config from '../config';
import { compactAdminUsername, normalizeAdminUsername } from '../utils/adminAccount';
import { isPlayerStaff, normalizeStaffRole } from '../utils/staffRole';

const router = express.Router();

const adminLoginSchema = z.object({
  username: z.string().min(3).max(50),
  password: z.string().min(6),
});

async function findAdminForLogin(rawUsername: string) {
  const normalized = normalizeAdminUsername(rawUsername);
  const compact = compactAdminUsername(rawUsername);
  const exact = await prisma.admin.findUnique({
    where: { username: normalized },
  });
  if (exact) return exact;
  if (compact !== normalized && compact.length >= 3) {
    return prisma.admin.findUnique({
      where: { username: compact },
    });
  }
  return null;
}

/**
 * POST /api/admin/login
 * Admin login endpoint
 */
router.post('/login', async (req, res) => {
  try {
    const { username, password } = adminLoginSchema.parse(req.body);
    console.log('[Admin Login] Request received:', { username: compactAdminUsername(username) });

    const admin = await findAdminForLogin(username);

    if (admin && !admin.isActive) {
      console.log('[Admin Login] Invalid credentials - admin not found or inactive');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    if (!admin) {
      const player = await prisma.player.findUnique({
        where: { username },
        select: {
          id: true,
          username: true,
          passwordHash: true,
          isBanned: true,
          bannedUntil: true,
        },
      });
      if (!player) {
        console.log('[Admin Login] Invalid credentials - admin not found or inactive');
        return res.status(401).json({ error: 'Invalid credentials' });
      }
      const staffRows = await prisma.$queryRawUnsafe<Array<{ staffRole: string }>>(
        'SELECT staffRole FROM players WHERE id = ? LIMIT 1',
        player.id,
      );
      const staffRole = normalizeStaffRole(staffRows?.[0]?.staffRole);
      if (!isPlayerStaff(staffRole)) {
        console.log('[Admin Login] Invalid credentials - admin not found or inactive');
        return res.status(401).json({ error: 'Invalid credentials' });
      }
      if (player.isBanned && (!player.bannedUntil || player.bannedUntil.getTime() > Date.now())) {
        console.log('[Admin Login] Invalid credentials - staff player banned');
        return res.status(401).json({ error: 'Invalid credentials' });
      }
      const playerPasswordOk = await bcrypt.compare(password, player.passwordHash);
      if (!playerPasswordOk) {
        console.log('[Admin Login] Invalid credentials - bad password');
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const token = jwt.sign(
        {
          playerId: player.id,
          username: player.username,
          staffRole,
          role: 'VIEWER',
          type: 'admin',
        },
        config.jwtSecret,
        { expiresIn: '8h' }
      );

      console.log('[Admin Login] Staff player success:', {
        playerId: player.id,
        username: player.username,
        staffRole,
      });

      return res.json({
        token,
        admin: {
          id: player.id,
          username: player.username,
          role: 'VIEWER',
          staffRole,
          playerId: player.id,
        },
      });
    }

    const isValidPassword = await bcrypt.compare(password, admin.passwordHash);
    if (!isValidPassword) {
      console.log('[Admin Login] Invalid credentials - bad password');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    prisma.admin
      .update({
        where: { id: admin.id },
        data: { lastLoginAt: new Date() },
      })
      .catch((updateError) => {
        console.warn('[Admin Login] Failed to update lastLoginAt', {
          adminId: admin.id,
          error: updateError,
        });
      });

    console.log('[Admin Login] Success:', { adminId: admin.id, username: admin.username });

    // Generate JWT with admin role
    const token = jwt.sign(
      {
        adminId: admin.id,
        username: admin.username,
        role: admin.role,
        type: 'admin', // Distinguish from player tokens
      },
      config.jwtSecret,
      { expiresIn: '8h' }
    );

    res.json({
      token,
      admin: {
        id: admin.id,
        username: admin.username,
        role: admin.role,
      },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        error: 'VALIDATION',
        message: 'Username must be 3-50 characters and password at least 6 characters.',
      });
    }
    console.error('Admin login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});

/**
 * GET /api/admin/me
 * Get current admin info
 */
router.get('/me', async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, config.jwtSecret) as {
      adminId?: number;
      playerId?: number;
      type: string;
    };

    if (decoded.type !== 'admin') {
      return res.status(403).json({ error: 'Not an admin token' });
    }

    if (decoded.playerId && !decoded.adminId) {
      const player = await prisma.player.findUnique({
        where: { id: decoded.playerId },
        select: { id: true, username: true, isBanned: true, bannedUntil: true },
      });
      if (!player) {
        return res.status(401).json({ error: 'Admin not found or inactive' });
      }
      const staffRows = await prisma.$queryRawUnsafe<Array<{ staffRole: string }>>(
        'SELECT staffRole FROM players WHERE id = ? LIMIT 1',
        player.id,
      );
      const staffRole = normalizeStaffRole(staffRows?.[0]?.staffRole);
      if (!isPlayerStaff(staffRole)) {
        return res.status(401).json({ error: 'Admin not found or inactive' });
      }
      if (player.isBanned && (!player.bannedUntil || player.bannedUntil.getTime() > Date.now())) {
        return res.status(401).json({ error: 'Admin not found or inactive' });
      }
      return res.json({
        admin: {
          id: player.id,
          username: player.username,
          role: 'VIEWER',
          staffRole,
          playerId: player.id,
          isActive: true,
        },
      });
    }

    if (!decoded.adminId) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    const admin = await prisma.admin.findUnique({
      where: { id: decoded.adminId },
      select: {
        id: true,
        username: true,
        role: true,
        isActive: true,
      },
    });

    if (!admin || !admin.isActive) {
      return res.status(401).json({ error: 'Admin not found or inactive' });
    }

    res.json({ admin });
  } catch (error) {
    const name = error instanceof Error ? error.name : '';
    if (name === 'TokenExpiredError' || name === 'JsonWebTokenError' || name === 'NotBeforeError') {
      return res.status(401).json({ error: 'Invalid token' });
    }
    console.error('Get admin error:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
});

export default router;
