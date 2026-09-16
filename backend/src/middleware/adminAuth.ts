import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import config from '../config';
import prisma from '../lib/prisma';
import { AdminRole } from '@prisma/client';
import { isPlayerStaff, normalizeStaffRole, type PlayerStaffRole } from '../utils/staffRole';

export interface AdminRequest extends Request {
  admin?: {
    id: number;
    username: string;
    role: AdminRole;
    staffRole?: PlayerStaffRole;
    playerId?: number;
  };
}

interface JwtPayload {
  adminId?: number;
  playerId?: number;
  username: string;
  role?: AdminRole;
  staffRole?: string;
  type?: string;
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

    const token = authHeader.substring(7);

    const decoded = jwt.verify(token, config.jwtSecret) as JwtPayload;
    if (decoded.type && decoded.type !== 'admin') {
      return res.status(403).json({
        error: 'FORBIDDEN',
        message: 'Not an admin token',
      });
    }

    if (decoded.playerId && !decoded.adminId) {
      const player = await prisma.player.findUnique({
        where: { id: decoded.playerId },
        select: {
          id: true,
          username: true,
          isBanned: true,
          bannedUntil: true,
        },
      });
      if (!player) {
        return res.status(401).json({
          error: 'UNAUTHORIZED',
          message: 'Staff player not found',
        });
      }
      if (player.isBanned && (!player.bannedUntil || player.bannedUntil.getTime() > Date.now())) {
        return res.status(403).json({
          error: 'FORBIDDEN',
          message: 'Player account is banned',
        });
      }

      const staffRows = await prisma.$queryRawUnsafe<Array<{ staffRole: string }>>(
        'SELECT staffRole FROM players WHERE id = ? LIMIT 1',
        player.id,
      );
      const staffRole = normalizeStaffRole(staffRows?.[0]?.staffRole);
      if (!isPlayerStaff(staffRole)) {
        return res.status(403).json({
          error: 'FORBIDDEN',
          message: 'Staff role revoked',
        });
      }

      req.admin = {
        id: player.id,
        username: player.username,
        role: AdminRole.VIEWER,
        staffRole,
        playerId: player.id,
      };
      return next();
    }

    if (!decoded.adminId) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'Invalid token',
      });
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

    if (isPlayerStaff(req.admin.staffRole)) {
      return res.status(403).json({
        error: 'FORBIDDEN',
        message: 'Player staff cannot use this admin action',
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
