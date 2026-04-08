import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import config from '../config';
import prisma from '../lib/prisma';
import { setCached } from '../services/redisClient';

export interface AuthRequest extends Request {
  player?: {
    id: number;
    username: string;
    rank: number;
    health: number;
    currentCountry: string;
  };
}

interface JwtPayload {
  playerId: number;
  username: string;
  iat?: number;
}

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authReq = req as AuthRequest;
    console.log('[Auth] Authenticating request:', req.method, req.path);
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log('[Auth] Missing or invalid authorization header');
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'MISSING_TOKEN' },
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify JWT
    const decoded = jwt.verify(token, config.jwtSecret) as JwtPayload;

    // Optional: Verify player still exists in database
    const player = await prisma.player.findUnique({
      where: { id: decoded.playerId },
      select: { 
        id: true, 
        username: true, 
        rank: true, 
        health: true, 
        currentCountry: true,
        isBanned: true,
        bannedUntil: true,
        banReason: true,
      },
    });

    if (!player) {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'PLAYER_NOT_FOUND' },
      });
    }

    const latestSessionLogin = await prisma.worldEvent.findFirst({
      where: {
        playerId: decoded.playerId,
        eventKey: 'auth.session.login',
      },
      orderBy: { createdAt: 'desc' },
      select: { createdAt: true },
    });

    if (latestSessionLogin && typeof decoded.iat === 'number') {
      const tokenIssuedAtMs = decoded.iat * 1000;
      const latestLoginMs = latestSessionLogin.createdAt.getTime();

      if (latestLoginMs - tokenIssuedAtMs > 1000) {
        return res.status(401).json({
          event: 'auth.unauthorized',
          params: { reason: 'SESSION_REPLACED' },
        });
      }
    }

    // Check if player is banned
    if (player.isBanned) {
      // Check if temporary ban has expired
      if (player.bannedUntil && new Date() > player.bannedUntil) {
        // Ban expired, automatically unban
        await prisma.player.update({
          where: { id: player.id },
          data: { isBanned: false, bannedUntil: null, banReason: null },
        });
      } else {
        // Player is still banned
        return res.status(403).json({
          event: 'auth.banned',
          params: {
            reason: player.banReason || 'You have been banned',
            bannedUntil: player.bannedUntil,
            isPermanent: !player.bannedUntil,
          },
        });
      }
    }

    // Attach player info to request
    authReq.player = {
      id: player.id,
      username: player.username,
      rank: player.rank,
      health: player.health,
      currentCountry: player.currentCountry,
    };

    // Track online presence in Redis (fire-and-forget, 5-minute TTL)
    setCached(`online:${player.id}`, 1, 300).catch(() => {});

    console.log('[Auth] Authentication successful for player:', player.id, player.username);
    return next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'INVALID_TOKEN' },
      });
    }

    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'TOKEN_EXPIRED' },
      });
    }

    return res.status(500).json({
      event: 'error.internal',
      params: { message: 'Authentication failed' },
    });
  }
};
