import { Request } from 'express';
import prisma from '../lib/prisma';

const BOT_UA = /bot|crawl|spider|slurp|facebookexternalhit|preview|monitor|uptime/i;

function clientIp(req: Request): string {
  const raw = (
    (req.headers['x-forwarded-for'] as string) ||
    (req.headers['x-real-ip'] as string) ||
    req.ip ||
    req.socket.remoteAddress ||
    ''
  )
    .split(',')[0]
    .trim();
  if (!raw) return '';
  return raw.startsWith('::ffff:') ? raw.slice(7) : raw;
}

function isBot(req: Request): boolean {
  const ua = String(req.headers['user-agent'] || '');
  return !ua || BOT_UA.test(ua);
}

export const siteVisitorService = {
  async recordVisit(req: Request): Promise<void> {
    if (isBot(req)) return;
    const ip = clientIp(req);
    if (!ip || ip === 'unknown') return;
    const now = new Date();
    try {
      await prisma.$executeRawUnsafe(
        `INSERT INTO site_visitors (ip, hits, firstSeen, lastSeen)
         VALUES (?, 1, ?, ?)
         ON DUPLICATE KEY UPDATE hits = hits + 1, lastSeen = ?`,
        ip,
        now,
        now,
        now,
      );
    } catch (error) {
      console.error('[Visitors] Failed to record visit:', error);
    }
  },

  async getSummary(): Promise<{ totalHits: number; uniqueIps: number }> {
    const rows = await prisma.$queryRawUnsafe<Array<{ hits: bigint | number; ips: bigint | number }>>(
      `SELECT COALESCE(SUM(hits), 0) AS hits, COUNT(*) AS ips FROM site_visitors`,
    );
    return {
      totalHits: Number(rows[0]?.hits ?? 0),
      uniqueIps: Number(rows[0]?.ips ?? 0),
    };
  },

  async getBreakdown(limit = 100): Promise<
    Array<{ ip: string; hits: number; firstSeen: string; lastSeen: string }>
  > {
    const take = Math.min(Math.max(Number(limit) || 100, 1), 500);
    const rows = await prisma.$queryRawUnsafe<
      Array<{ ip: string; hits: bigint | number; firstSeen: Date; lastSeen: Date }>
    >(
      `SELECT ip, hits, firstSeen, lastSeen
       FROM site_visitors
       ORDER BY lastSeen DESC
       LIMIT ?`,
      take,
    );
    return rows.map((row) => ({
      ip: row.ip,
      hits: Number(row.hits),
      firstSeen: new Date(row.firstSeen).toISOString(),
      lastSeen: new Date(row.lastSeen).toISOString(),
    }));
  },
};
