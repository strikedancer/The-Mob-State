/**
 * Monthly Season Pass (€7.99 one-shot, not a subscription).
 * Free track for everyone; premium track unlocks after Mollie purchase for the current YYYY-MM season.
 * Progress comes from live-event contributions (any category).
 */

import prisma from '../lib/prisma';
import {
  fulfillExtendedEventRewards,
  parseExtendedEventRewards,
} from './eventRewardFulfillmentService';
import { creditEventItem } from './eventItemService';
import { grantPurchasedCredits } from './premiumCreditsService';

export type SeasonPassTrack = 'free' | 'premium';

export type SeasonPassLevelDef = {
  level: number;
  scoreRequired: number;
  free: Record<string, unknown>;
  premium: Record<string, unknown>;
};

const SEASON_PASS_LEVELS: SeasonPassLevelDef[] = [
  {
    level: 1,
    scoreRequired: 10,
    free: { cash: 2_500, ammo: [{ ammoType: '9mm', quantity: 20 }] },
    premium: { cash: 7_500, ammo: [{ ammoType: '9mm', quantity: 50 }], premiumCredits: 2 },
  },
  {
    level: 2,
    scoreRequired: 30,
    free: { vehicleParts: { car: 2 }, xp: 50 },
    premium: {
      vehicleParts: { car: 5, motorcycle: 2 },
      tools: [{ toolId: 'bolt_cutter', quantity: 1 }],
      premiumCredits: 3,
    },
  },
  {
    level: 3,
    scoreRequired: 60,
    free: { ammo: [{ ammoType: '9mm', quantity: 30 }], items: [{ itemKey: 'event_chip_bronze', quantity: 1 }] },
    premium: {
      ammo: [{ ammoType: '45acp', quantity: 40 }],
      items: [{ itemKey: 'event_chip_silver', quantity: 1 }],
      premiumCredits: 4,
    },
  },
  {
    level: 4,
    scoreRequired: 100,
    free: { cash: 5_000, vehicleParts: { car: 3 } },
    premium: {
      cash: 15_000,
      tools: [{ toolId: 'crowbar', quantity: 1 }],
      vehicleParts: { car: 8, boat: 2 },
      premiumCredits: 5,
    },
  },
  {
    level: 5,
    scoreRequired: 150,
    free: { ammo: [{ ammoType: '9mm', quantity: 40 }], xp: 100 },
    premium: {
      weapons: [{ weaponId: 'knife', condition: 100 }],
      ammo: [{ ammoType: '9mm', quantity: 80 }],
      premiumCredits: 6,
    },
  },
  {
    level: 6,
    scoreRequired: 220,
    free: { vehicleParts: { motorcycle: 2 }, cash: 7_500 },
    premium: {
      vehicleParts: { car: 10, motorcycle: 6, boat: 3 },
      tools: [{ toolId: 'car_theft_tools', quantity: 1 }],
      premiumCredits: 8,
    },
  },
  {
    level: 7,
    scoreRequired: 300,
    free: { items: [{ itemKey: 'event_chip_silver', quantity: 1 }], ammo: [{ ammoType: '9mm', quantity: 50 }] },
    premium: {
      items: [{ itemKey: 'event_chip_gold', quantity: 1 }],
      ammo: [{ ammoType: '12gauge', quantity: 25 }],
      premiumCredits: 10,
    },
  },
  {
    level: 8,
    scoreRequired: 400,
    free: { cash: 10_000, xp: 150 },
    premium: {
      cash: 30_000,
      weapons: [{ weaponId: 'handgun_9mm', condition: 100 }],
      premiumCredits: 12,
    },
  },
  {
    level: 9,
    scoreRequired: 550,
    free: { vehicleParts: { car: 5, boat: 1 }, ammo: [{ ammoType: '9mm', quantity: 60 }] },
    premium: {
      vehicleParts: { car: 15, motorcycle: 8, boat: 5 },
      tools: [{ toolId: 'hacking_laptop', quantity: 1 }],
      premiumCredits: 15,
    },
  },
  {
    level: 10,
    scoreRequired: 750,
    free: {
      cash: 20_000,
      items: [{ itemKey: 'event_chip_gold', quantity: 1 }],
      xp: 250,
    },
    premium: {
      cash: 50_000,
      vehicles: [
        {
          vehicleId: 'moto_kawasaki_ninja_zx_10r_track_2',
          condition: 85,
          fuel: 50,
          cashFallback: 40_000,
        },
      ],
      weapons: [{ weaponId: 'handgun_heavy', condition: 100 }],
      items: [{ itemKey: 'event_badge_rival', quantity: 1 }],
      premiumCredits: 25,
    },
  },
];

let tablesReady = false;

export function currentSeasonKey(now = new Date()): string {
  const y = now.getUTCFullYear();
  const m = String(now.getUTCMonth() + 1).padStart(2, '0');
  return `${y}-${m}`;
}

export function seasonWindow(seasonKey: string): { startsAt: Date; endsAt: Date } {
  const [y, m] = seasonKey.split('-').map((v) => Number(v));
  const startsAt = new Date(Date.UTC(y, m - 1, 1, 0, 0, 0));
  const endsAt = new Date(Date.UTC(y, m, 1, 0, 0, 0));
  return { startsAt, endsAt };
}

export async function ensureSeasonPassTables(): Promise<void> {
  if (tablesReady) return;
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS player_season_pass (
      player_id INT NOT NULL,
      season_key VARCHAR(10) NOT NULL,
      score INT NOT NULL DEFAULT 0,
      premium_unlocked TINYINT(1) NOT NULL DEFAULT 0,
      updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
      PRIMARY KEY (player_id, season_key),
      INDEX idx_season_pass_season (season_key)
    )
  `);
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS player_season_pass_claims (
      player_id INT NOT NULL,
      season_key VARCHAR(10) NOT NULL,
      level INT NOT NULL,
      track VARCHAR(16) NOT NULL,
      claimed_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      PRIMARY KEY (player_id, season_key, level, track)
    )
  `);
  tablesReady = true;
}

async function ensureRow(playerId: number, seasonKey: string): Promise<void> {
  await ensureSeasonPassTables();
  await prisma.$executeRawUnsafe(
    `INSERT INTO player_season_pass (player_id, season_key, score, premium_unlocked)
     VALUES (?, ?, 0, 0)
     ON DUPLICATE KEY UPDATE player_id = player_id`,
    playerId,
    seasonKey,
  );
}

export async function addSeasonPassScore(playerId: number, amount: number): Promise<void> {
  if (amount <= 0) return;
  const seasonKey = currentSeasonKey();
  await ensureRow(playerId, seasonKey);
  await prisma.$executeRawUnsafe(
    `UPDATE player_season_pass
     SET score = score + ?
     WHERE player_id = ? AND season_key = ?`,
    Math.floor(amount),
    playerId,
    seasonKey,
  );
}

export async function unlockSeasonPassPremium(
  playerId: number,
  seasonKey = currentSeasonKey(),
): Promise<void> {
  await ensureRow(playerId, seasonKey);
  await prisma.$executeRawUnsafe(
    `UPDATE player_season_pass
     SET premium_unlocked = 1
     WHERE player_id = ? AND season_key = ?`,
    playerId,
    seasonKey,
  );
}

type ProgressRow = {
  score: number;
  premium_unlocked: number | boolean;
};

export async function getSeasonPassStatus(playerId: number) {
  const seasonKey = currentSeasonKey();
  const { startsAt, endsAt } = seasonWindow(seasonKey);
  await ensureRow(playerId, seasonKey);

  const rows = await prisma.$queryRawUnsafe<ProgressRow[]>(
    `SELECT score, premium_unlocked FROM player_season_pass
     WHERE player_id = ? AND season_key = ? LIMIT 1`,
    playerId,
    seasonKey,
  );
  const score = Number(rows[0]?.score ?? 0);
  const premiumUnlocked = Boolean(rows[0]?.premium_unlocked);

  const claimRows = await prisma.$queryRawUnsafe<
    Array<{ level: number; track: string }>
  >(
    `SELECT level, track FROM player_season_pass_claims
     WHERE player_id = ? AND season_key = ?`,
    playerId,
    seasonKey,
  );
  const claimed = new Set(claimRows.map((r) => `${r.track}:${r.level}`));

  const levels = SEASON_PASS_LEVELS.map((def) => {
    const unlocked = score >= def.scoreRequired;
    return {
      level: def.level,
      scoreRequired: def.scoreRequired,
      unlocked,
      free: {
        rewards: def.free,
        claimed: claimed.has(`free:${def.level}`),
        claimable: unlocked && !claimed.has(`free:${def.level}`),
      },
      premium: {
        rewards: def.premium,
        claimed: claimed.has(`premium:${def.level}`),
        claimable:
          premiumUnlocked && unlocked && !claimed.has(`premium:${def.level}`),
      },
    };
  });

  const nextLevel = SEASON_PASS_LEVELS.find((l) => score < l.scoreRequired) ?? null;

  return {
    seasonKey,
    startsAt,
    endsAt,
    score,
    premiumUnlocked,
    priceEurCents: 799,
    productKey: 'season_pass_monthly',
    nextLevel: nextLevel
      ? {
          level: nextLevel.level,
          scoreRequired: nextLevel.scoreRequired,
          remaining: Math.max(0, nextLevel.scoreRequired - score),
        }
      : null,
    levels,
  };
}

async function deliverRewards(
  playerId: number,
  rewards: Record<string, unknown>,
  liveEventIdHint?: number | null,
): Promise<void> {
  const cash = Number(rewards.cash ?? 0);
  const xp = Number(rewards.xp ?? 0);
  const premiumCredits = Number(rewards.premiumCredits ?? 0);

  await prisma.$transaction(async (tx) => {
    if (cash > 0) {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: Math.floor(cash) } },
      });
    }
    if (xp > 0) {
      await tx.player.update({
        where: { id: playerId },
        data: { xp: { increment: Math.floor(xp) } },
      });
    }
    if (premiumCredits > 0) {
      await grantPurchasedCredits(
        tx,
        playerId,
        Math.floor(premiumCredits),
        `season_pass_${currentSeasonKey()}`,
      );
    }

    const items = rewards.items;
    if (Array.isArray(items)) {
      for (const entry of items) {
        if (!entry || typeof entry !== 'object') continue;
        const row = entry as Record<string, unknown>;
        const itemKey = String(row.itemKey ?? '').trim();
        const quantity = Math.floor(Number(row.quantity ?? 0));
        if (!itemKey || quantity <= 0) continue;
        await creditEventItem(tx, playerId, itemKey, quantity, liveEventIdHint ?? null);
      }
    }

    await fulfillExtendedEventRewards(tx, playerId, rewards);
  });
}

export async function claimSeasonPassReward(
  playerId: number,
  level: number,
  track: SeasonPassTrack,
): Promise<{ ok: true; rewards: Record<string, unknown> } | { ok: false; reason: string }> {
  const status = await getSeasonPassStatus(playerId);
  const def = SEASON_PASS_LEVELS.find((l) => l.level === level);
  if (!def) return { ok: false, reason: 'INVALID_LEVEL' };

  const node = status.levels.find((l) => l.level === level);
  if (!node) return { ok: false, reason: 'INVALID_LEVEL' };

  if (track === 'free') {
    if (!node.free.claimable) {
      return { ok: false, reason: node.free.claimed ? 'ALREADY_CLAIMED' : 'LOCKED' };
    }
  } else {
    if (!status.premiumUnlocked) return { ok: false, reason: 'PREMIUM_REQUIRED' };
    if (!node.premium.claimable) {
      return { ok: false, reason: node.premium.claimed ? 'ALREADY_CLAIMED' : 'LOCKED' };
    }
  }

  const inserted = await prisma.$executeRawUnsafe(
    `INSERT IGNORE INTO player_season_pass_claims (player_id, season_key, level, track)
     VALUES (?, ?, ?, ?)`,
    playerId,
    status.seasonKey,
    level,
    track,
  );
  if (Number(inserted) === 0) {
    return { ok: false, reason: 'ALREADY_CLAIMED' };
  }

  const rewards = track === 'free' ? def.free : def.premium;
  await deliverRewards(playerId, rewards);
  return { ok: true, rewards };
}

export const seasonPassService = {
  currentSeasonKey,
  seasonWindow,
  ensureSeasonPassTables,
  addSeasonPassScore,
  unlockSeasonPassPremium,
  getSeasonPassStatus,
  claimSeasonPassReward,
  levels: SEASON_PASS_LEVELS,
};
