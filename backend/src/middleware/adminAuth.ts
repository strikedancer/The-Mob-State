import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import config from '../config';
import prisma from '../lib/prisma';
import { AdminRole } from '@prisma/client';

export interface AdminRequest extends Request {
  admin?: {
    id: number;
    username: string;
    role: AdminRole;
  };
}

interface JwtPayload {
  adminId: number;
  username: string;
  role: AdminRole;
}

export const adminAuthMiddleware = async (req: AdminRequest, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Missing or invalid authorization header',
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify JWT
    const decoded = jwt.verify(token, config.jwtSecret) as JwtPayload;

    // Verify admin exists and is active
    const admin = await prisma.admin.findUnique({
      where: { id: decoded.adminId },
      select: {
        id: true,
        username: true,
        role: true,
        isActive: true,
      },
    });

    if (!admin) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Admin not found',
      });
    }

    if (!admin.isActive) {
      return res.status(403).json({
        error: 'FORBIDDEN',
        message: 'Admin account is deactivated',
      });
    }

    // Best-effort metadata update: auth must not fail if this write conflicts under concurrent requests
    prisma.admin.update({
      where: { id: admin.id },
      data: { lastLoginAt: new Date() },
    }).catch((updateError) => {
      console.warn('[Admin Auth] Failed to update lastLoginAt', {
        adminId: admin.id,
        error: updateError,
      });
    });

    // Attach admin info to request
    req.admin = {
      id: admin.id,
      username: admin.username,
      role: admin.role,
    };

    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Invalid token',
      });
    }

    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Token expired',
      });
    }

    console.error('[Admin Auth Error]', error);
    return res.status(500).json({
      error: 'INTERNAL_ERROR',
      message: 'Authentication failed',
    });
  }
};

/**
 * Middleware to require specific admin roles
 */
export const requireAdminRole = (...roles: AdminRole[]) => {
  return (req: AdminRequest, res: Response, next: NextFunction) => {
    if (!req.admin) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Admin authentication required',
      });
    }

    if (!roles.includes(req.admin.role)) {
      return res.status(403).json({
        error: 'FORBIDDEN',
        message: `Required role: ${roles.join(' or ')}`,
      });
    }

    next();
  };
};
