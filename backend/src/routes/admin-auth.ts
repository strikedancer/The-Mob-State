import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import prisma from '../lib/prisma';
import config from '../config';

const router = express.Router();

const adminLoginSchema = z.object({
  username: z.string().min(3).max(50),
  password: z.string().min(6),
});

/**
 * POST /api/admin/login
 * Admin login endpoint
 */
router.post('/login', async (req, res) => {
  try {
    console.log('[Admin Login] Request received:', req.body);
    const { username, password } = adminLoginSchema.parse(req.body);

    const admin = await prisma.admin.findUnique({
      where: { username },
    });

    console.log('[Admin Login] Admin found:', admin ? 'Yes' : 'No');

    if (!admin || !admin.isActive) {
      console.log('[Admin Login] Invalid credentials - admin not found or inactive');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const isValidPassword = await bcrypt.compare(password, admin.passwordHash);
    console.log('[Admin Login] Password valid:', isValidPassword);
    
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Update last login
    await prisma.admin.update({
      where: { id: admin.id },
      data: { lastLoginAt: new Date() },
    });

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
      return res.status(400).json({ error: error.errors });
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
