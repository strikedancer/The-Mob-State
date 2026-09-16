import { Response, NextFunction } from 'express';
import prisma from '../lib/prisma';
import type { AuthRequest } from './authenticate';
import { isPlayerStaff, normalizeStaffRole, type PlayerStaffRole } from '../utils/staffRole';

export async function readPlayerStaffRole(playerId: number): Promise<PlayerStaffRole> {
  const rows = await prisma.$queryRawUnsafe<Array<{ staffRole: string }>>(
    'SELECT staffRole FROM players WHERE id = ? LIMIT 1',
    playerId,
  );
  return normalizeStaffRole(rows?.[0]?.staffRole);
}

export function requirePlayerStaff(...roles: Array<'MOD' | 'OPS'>) {
  const allowed = roles.length > 0 ? roles : (['MOD', 'OPS'] as const);
  return async (req: AuthRequest, res: Response, next: NextFunction) => {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'MISSING_TOKEN' },
      });
    }

    const staffRole = await readPlayerStaffRole(playerId);
    if (!isPlayerStaff(staffRole) || !allowed.includes(staffRole)) {
      return res.status(403).json({
        event: 'error.global_chat_failed',
        params: { reason: 'GLOBAL_CHAT_FORBIDDEN' },
      });
    }

    req.player = {
      ...req.player!,
      staffRole,
    };
    return next();
  };
}
