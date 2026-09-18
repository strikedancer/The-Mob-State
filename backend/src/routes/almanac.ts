import { Router, Response } from 'express';
import jwt from 'jsonwebtoken';
import config from '../config';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { createRateLimiter } from '../middleware/rateLimit';
import { playerService } from '../services/playerService';
import * as policeService from '../services/policeService';
import * as bankService from '../services/bankService';
import { getRankTitle } from '../utils/rankSystem';
import prisma from '../lib/prisma';

const router = Router();

const meLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 30,
  message: 'ALMANAC_ME_RATE_LIMIT',
  keyGenerator: (req) => {
    const ip = req.ip || req.socket.remoteAddress || 'unknown';
    return `almanac_me:${ip}`;
  },
});

function remainingMs(expiresAt: Date | null | undefined, now: number): number | null {
  if (!expiresAt) return null;
  const ms = expiresAt.getTime() - now;
  return Number.isFinite(ms) ? Math.max(0, ms) : null;
}

const HANDOFF_EXPIRES_SEC = 30 * 60;

const handoffLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 20,
  message: 'ALMANAC_HANDOFF_RATE_LIMIT',
  keyGenerator: (req) => {
    const ip = req.ip || req.socket.remoteAddress || 'unknown';
    return `almanac_handoff:${ip}`;
  },
});

/**
 * POST /almanac/handoff
 * Mint a short-lived Almanac-only JWT from the current game session.
 * Does not rotate lastSessionAt — the game stays logged in.
 */
router.post('/handoff', handoffLimiter, authenticate, async (req: AuthRequest, res: Response) => {
  try {
    if (req.tokenPurpose === 'almanac') {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'ALMANAC_TOKEN_SCOPE' },
      });
    }
    const player = req.player;
    if (!player) {
      return res.status(401).json({
        event: 'auth.unauthorized',
        params: { reason: 'MISSING_TOKEN' },
      });
    }
    const token = jwt.sign(
      { playerId: player.id, username: player.username, purpose: 'almanac' },
      config.jwtSecret,
      { expiresIn: '30m' }
    );
    return res.status(200).json({
      event: 'almanac.handoff',
      token,
      expiresInSec: HANDOFF_EXPIRES_SEC,
    });
  } catch (error) {
    console.error('[AlmanacRoute] Failed to mint /almanac/handoff', {
      playerId: req.player?.id,
      error,
    });
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

/**
 * GET /almanac/me
 * Read-only snapshot for Ask the Almanac (wiki.themobstate.com).
 * Own account only. No email, password, or other players.
 */
router.get('/me', meLimiter, authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const now = Date.now();
    const [player, jailRemainingSeconds, bankBalance, membership] = await Promise.all([
      playerService.getPlayer(playerId),
      policeService.checkIfJailed(playerId),
      bankService.getBalance(playerId).catch(() => 0),
      prisma.crewMember.findFirst({
        where: { playerId },
        select: {
          crew: {
            select: {
              name: true,
              isVip: true,
              vipExpiresAt: true,
            },
          },
        },
      }),
    ]);

    const vipExpiresAt = player.vipExpiresAt ? new Date(player.vipExpiresAt) : null;
    const vipActive = player.isVip === true && (!vipExpiresAt || vipExpiresAt.getTime() > now);
    const crew = membership?.crew ?? null;
    const crewVipExpiresAt = crew?.vipExpiresAt ? new Date(crew.vipExpiresAt) : null;
    const crewVipActive = Boolean(crew?.isVip) && (!crewVipExpiresAt || crewVipExpiresAt.getTime() > now);
    const rankInfo = getRankTitle(player.rank);

    return res.status(200).json({
      event: 'almanac.me',
      snapshot: {
        username: player.username,
        money: player.money,
        bankBalance,
        health: player.health,
        rank: player.rank,
        rankTitle: rankInfo.title,
        xp: player.xp,
        wantedLevel: player.wantedLevel ?? 0,
        fbiHeat: player.fbiHeat ?? 0,
        currentCountry: player.currentCountry,
        premiumCredits: (player as { premiumCredits?: number }).premiumCredits ?? 0,
        wealthStatus: player.wealthStatus ?? null,
        isVip: vipActive,
        vipExpiresAt: vipActive && vipExpiresAt ? vipExpiresAt.toISOString() : null,
        vipRemainingMs: vipActive ? remainingMs(vipExpiresAt, now) : 0,
        jailRemainingSeconds: jailRemainingSeconds > 0 ? jailRemainingSeconds : 0,
        crewName: crew?.name ?? null,
        crewIsVip: crewVipActive,
        crewVipExpiresAt: crewVipActive && crewVipExpiresAt ? crewVipExpiresAt.toISOString() : null,
        crewVipRemainingMs: crewVipActive ? remainingMs(crewVipExpiresAt, now) : 0,
      },
    });
  } catch (error) {
    console.error('[AlmanacRoute] Failed to load /almanac/me', {
      playerId: req.player?.id,
      error,
    });
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

export default router;
