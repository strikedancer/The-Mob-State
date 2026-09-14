import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import prisma from '../lib/prisma';
import config from '../config';
import { compactAdminUsername, normalizeAdminUsername } from '../utils/adminAccount';

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

    if (!admin || !admin.isActive) {
      console.log('[Admin Login] Invalid credentials - admin not found or inactive');
      return res.status(401).json({ error: 'Invalid credentials' });
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
      adminId: number;
      type: string;
    };

    if (decoded.type !== 'admin') {
      return res.status(403).json({ error: 'Not an admin token' });
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
    console.error('Get admin error:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
});

export default router;
