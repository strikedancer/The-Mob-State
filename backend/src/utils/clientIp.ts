import { Request } from 'express';

export function clientIpFromRequest(req: Request): string | null {
  const raw = (
    (req.headers['x-forwarded-for'] as string) ||
    (req.headers['x-real-ip'] as string) ||
    req.ip ||
    req.socket.remoteAddress ||
    ''
  )
    .split(',')[0]
    .trim();
  if (!raw || raw === 'unknown') return null;
  const ip = raw.startsWith('::ffff:') ? raw.slice(7) : raw;
  return ip.length > 45 ? ip.slice(0, 45) : ip;
}
