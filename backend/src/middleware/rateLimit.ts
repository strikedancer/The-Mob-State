/**
 * Phase 13.2: Redis-backed Rate Limiter
 * Prevents abuse by limiting request frequency
 */

import { Request, Response, NextFunction } from 'express';
import { incrementCounter, isRedisConnected } from '../services/redisClient';

interface RateLimitOptions {
  windowMs: number; // Time window in milliseconds
  maxRequests: number; // Max requests per window
  message?: string; // Custom error message
  skipSuccessfulRequests?: boolean; // Don't count successful requests
  keyGenerator?: (req: Request) => string; // Custom key generator
}

const DEFAULT_OPTIONS: RateLimitOptions = {
  windowMs: 60 * 1000, // 1 minute
  maxRequests: 60, // 60 requests per minute
  message: 'TOO_MANY_REQUESTS',
  skipSuccessfulRequests: false,
};

/**
 * Create rate limiter middleware
 */
export function createRateLimiter(options: Partial<RateLimitOptions> = {}) {
  const opts = { ...DEFAULT_OPTIONS, ...options };
  const windowSeconds = Math.ceil(opts.windowMs / 1000);

  return async (req: Request, res: Response, next: NextFunction) => {
    // If Redis is not connected, bypass rate limiting (fallback gracefully)
    if (!isRedisConnected()) {
      console.warn('⚠️  Rate limiting disabled (Redis not connected)');
      return next();
    }

    // Generate rate limit key
    const key = opts.keyGenerator
      ? opts.keyGenerator(req)
      : generateDefaultKey(req);

    const rateLimitKey = `ratelimit:${key}`;

    try {
      // Increment request counter
      const requestCount = await incrementCounter(rateLimitKey, windowSeconds);

      // Set rate limit headers
      res.setHeader('X-RateLimit-Limit', opts.maxRequests.toString());
      res.setHeader('X-RateLimit-Remaining', Math.max(0, opts.maxRequests - requestCount).toString());
      res.setHeader('X-RateLimit-Reset', getResetTime(windowSeconds).toString());

      // Check if rate limit exceeded
      if (requestCount > opts.maxRequests) {
        return res.status(429).json({
          event: 'error.rate_limit',
          params: {
            reason: opts.message,
            retryAfter: windowSeconds,
          },
        });
      }

      // If skipSuccessfulRequests, we need to decrement on success
      if (opts.skipSuccessfulRequests) {
        const originalSend = res.send;
        res.send = function (this: Response, data: unknown) {
          // Decrement if response is successful (2xx)
          if (res.statusCode >= 200 && res.statusCode < 300) {
            // Fire and forget - don't wait for Redis
            decrementCounter(rateLimitKey).catch((err) => {
              console.error('Error decrementing rate limit counter:', err);
            });
          }
          return originalSend.call(this, data);
        } as typeof res.send;
      }

      next();
    } catch (error) {
      console.error('Rate limiter error:', error);
      // On error, allow request through (fail open)
      next();
    }
  };
}

/**
 * Generate default rate limit key from request
 * Uses IP address + user ID (if authenticated)
 */
function generateDefaultKey(req: Request): string {
  const ip = req.ip || req.socket.remoteAddress || 'unknown';
  
  // If authenticated, include user ID
  // @ts-expect-error - player may exist from auth middleware
  const userId = req.player?.id;
  
  if (userId) {
    return `user:${userId}`;
  }
  
  return `ip:${ip}`;
}

/**
 * Calculate reset time (Unix timestamp)
 */
function getResetTime(windowSeconds: number): number {
  return Math.floor(Date.now() / 1000) + windowSeconds;
}

/**
 * Decrement counter (for skipSuccessfulRequests)
 */
async function decrementCounter(key: string): Promise<void> {
  const { getRedisClient } = await import('../services/redisClient');
  const client = getRedisClient();
  if (client) {
    await client.decr(key);
  }
}

/**
 * Preset rate limiters
 */

/**
 * Global rate limiter (100 requests per minute per IP)
 */
export const globalRateLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 100,
  message: 'GLOBAL_RATE_LIMIT_EXCEEDED',
});

/**
 * Auth rate limiter (5 login attempts per 15 minutes per IP)
 */
export const authRateLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000,
  maxRequests: 5,
  message: 'AUTH_RATE_LIMIT_EXCEEDED',
  keyGenerator: (req) => {
    const ip = req.ip || req.socket.remoteAddress || 'unknown';
    return `auth:${ip}`;
  },
});

/**
 * Crime rate limiter (20 crimes per minute per user)
 */
export const crimeRateLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 20,
  message: 'CRIME_RATE_LIMIT_EXCEEDED',
  skipSuccessfulRequests: false,
  keyGenerator: (req) => {
    // @ts-expect-error - player from auth middleware
    const userId = req.player?.id || 'anonymous';
    return `crime:${userId}`;
  },
});

/**
 * Trade rate limiter (30 trades per minute per user)
 */
export const tradeRateLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 30,
  message: 'TRADE_RATE_LIMIT_EXCEEDED',
  keyGenerator: (req) => {
    // @ts-expect-error - player from auth middleware
    const userId = req.player?.id || 'anonymous';
    return `trade:${userId}`;
  },
});

/**
 * API rate limiter (300 requests per minute per user)
 */
export const apiRateLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 300,
  message: 'API_RATE_LIMIT_EXCEEDED',
});
