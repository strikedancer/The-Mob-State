/**
 * Phase 13.2: Redis Client Service
 * Provides Redis connection for caching, session storage, and rate limiting
 */

import { createClient, RedisClientType } from 'redis';

let redisClient: RedisClientType | null = null;
let isConnected = false;
let errorLogged = false; // Track if we already logged the error

/**
 * Initialize Redis client
 */
export async function initRedis(): Promise<void> {
  try {
    const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
    
    redisClient = createClient({
      url: redisUrl,
      socket: {
        reconnectStrategy: (retries) => {
          // Only try 2 times (initial + 1 retry), then give up
          if (retries > 1) {
            return new Error('Max reconnection attempts');
          }
          return 500; // Wait 500ms before retry
        },
      },
    });

    // Event handlers
    redisClient.on('error', (_err) => {
      // Only log once to avoid spam
      if (!errorLogged) {
        console.error('❌ Redis unavailable (running without cache)');
        errorLogged = true;
      }
      isConnected = false;
    });

    redisClient.on('connect', () => {
      console.log('🔗 Redis: Connecting...');
    });

    redisClient.on('ready', () => {
      console.log('✅ Redis: Connected and ready');
      isConnected = true;
    });

    redisClient.on('reconnecting', () => {
      // Suppress reconnecting messages
      isConnected = false;
    });

    redisClient.on('end', () => {
      // Suppress end messages
      isConnected = false;
    });

    // Connect
    await redisClient.connect();
  } catch (error) {
    console.error('❌ Redis initialization failed:', error);
    console.log('⚠️  Running without Redis (caching disabled)');
    redisClient = null;
    isConnected = false;
  }
}

/**
 * Get Redis client instance
 */
export function getRedisClient(): RedisClientType | null {
  return redisClient;
}

/**
 * Check if Redis is connected
 */
export function isRedisConnected(): boolean {
  return isConnected && redisClient !== null;
}

/**
 * Get Redis connection options for BullMQ
 */
export function getRedisConnectionOptions(): { host: string; port: number } | null {
  if (!isConnected || !redisClient) {
    return null;
  }
  
  const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
  const url = new URL(redisUrl);
  
  return {
    host: url.hostname,
    port: parseInt(url.port) || 6379,
  };
}

/**
 * Close Redis connection
 */
export async function closeRedis(): Promise<void> {
  if (redisClient) {
    await redisClient.quit();
    redisClient = null;
    isConnected = false;
    console.log('✅ Redis connection closed');
  }
}

/**
 * Cache Helper Functions
 */

/**
 * Get cached value
 */
export async function getCached<T>(key: string): Promise<T | null> {
  if (!isRedisConnected() || !redisClient) {
    return null;
  }

  try {
    const value = await redisClient.get(key);
    if (!value) {
      return null;
    }
    return JSON.parse(value) as T;
  } catch (error) {
    console.error(`Redis GET error for key ${key}:`, error);
    return null;
  }
}

/**
 * Set cached value with TTL
 */
export async function setCached<T>(
  key: string,
  value: T,
  ttlSeconds?: number
): Promise<boolean> {
  if (!isRedisConnected() || !redisClient) {
    return false;
  }

  try {
    const serialized = JSON.stringify(value);
    if (ttlSeconds) {
      await redisClient.setEx(key, ttlSeconds, serialized);
    } else {
      await redisClient.set(key, serialized);
    }
    return true;
  } catch (error) {
    console.error(`Redis SET error for key ${key}:`, error);
    return false;
  }
}

/**
 * Delete cached value
 */
export async function deleteCached(key: string): Promise<boolean> {
  if (!isRedisConnected() || !redisClient) {
    return false;
  }

  try {
    await redisClient.del(key);
    return true;
  } catch (error) {
    console.error(`Redis DEL error for key ${key}:`, error);
    return false;
  }
}

/**
 * Check if key exists
 */
export async function existsCached(key: string): Promise<boolean> {
  if (!isRedisConnected() || !redisClient) {
    return false;
  }

  try {
    const exists = await redisClient.exists(key);
    return exists === 1;
  } catch (error) {
    console.error(`Redis EXISTS error for key ${key}:`, error);
    return false;
  }
}

/**
 * Increment counter (for rate limiting)
 */
export async function incrementCounter(
  key: string,
  ttlSeconds?: number
): Promise<number> {
  if (!isRedisConnected() || !redisClient) {
    return 0;
  }

  try {
    const count = await redisClient.incr(key);
    if (ttlSeconds && count === 1) {
      // Set TTL only on first increment
      await redisClient.expire(key, ttlSeconds);
    }
    return count;
  } catch (error) {
    console.error(`Redis INCR error for key ${key}:`, error);
    return 0;
  }
}

/**
 * Get counter value
 */
export async function getCounter(key: string): Promise<number> {
  if (!isRedisConnected() || !redisClient) {
    return 0;
  }

  try {
    const value = await redisClient.get(key);
    return value ? parseInt(value, 10) : 0;
  } catch (error) {
    console.error(`Redis GET counter error for key ${key}:`, error);
    return 0;
  }
}

/**
 * Session Storage Functions
 */

const SESSION_PREFIX = 'session:';
const SESSION_TTL = 24 * 60 * 60; // 24 hours

/**
 * Store session data
 */
export async function setSession(
  sessionId: string,
  data: unknown
): Promise<boolean> {
  return setCached(`${SESSION_PREFIX}${sessionId}`, data, SESSION_TTL);
}

/**
 * Get session data
 */
export async function getSession<T>(sessionId: string): Promise<T | null> {
  return getCached<T>(`${SESSION_PREFIX}${sessionId}`);
}

/**
 * Delete session
 */
export async function deleteSession(sessionId: string): Promise<boolean> {
  return deleteCached(`${SESSION_PREFIX}${sessionId}`);
}

/**
 * Extend session TTL
 */
export async function extendSession(sessionId: string): Promise<boolean> {
  if (!isRedisConnected() || !redisClient) {
    return false;
  }

  try {
    await redisClient.expire(`${SESSION_PREFIX}${sessionId}`, SESSION_TTL);
    return true;
  } catch (error) {
    console.error(`Redis EXPIRE error for session ${sessionId}:`, error);
    return false;
  }
}
