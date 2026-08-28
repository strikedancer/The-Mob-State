/**
 * Monthly Season Pass (€7.99 one-shot, not a subscription).
 * 50 category-specific goals per month; free track for everyone, premium after Mollie purchase.
 */

import prisma from '../lib/prisma';
import { fulfillExtendedEventRewards } from './eventRewardFulfillmentService';
import { creditEventItem } from './eventItemService';
import { grantPurchasedCredits } from './premiumCreditsService';
import {
  SEASON_PASS_LEVELS,
  SeasonPassGoalCategory,
  SeasonPassLevelDef,
} from './seasonPassLevels';

export type SeasonPassTrack = 'free' | 'premium';

export type { SeasonPassLevelDef, SeasonPassGoalCategory };

const STAT_COLUMNS: Record<SeasonPassGoalCategory, string> = {
  crime: 'stat_crime',
  vehicles: 'stat_vehicles',
  smuggling: 'stat_smuggling',
  drugs: 'stat_drugs',
  money: 'stat_money',
  xp: 'stat_xp',
};

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

async function ensureStatColumns(): Promise<void> {
  for (const col of Object.values(STAT_COLUMNS)) {
    try {
      await prisma.$executeRawUnsafe(
        `ALTER TABLE player_season_pass ADD COLUMN ${col} INT NOT NULL DEFAULT 0`,
      );
    } catch {
      /* column exists */
    }
  }
}

export async function ensureSeasonPassTables(): Promise<void> {
  if (tablesReady) return;
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS player_season_pass (
      player_id INT NOT NULL,
      season_key VARCHAR(10) NOT NULL,
      score INT NOT NULL DEFAULT 0,
      premium_unlocked TINYINT(1) NOT NULL DEFAULT 0,
      stat_crime INT NOT NULL DEFAULT 0,
      stat_vehicles INT NOT NULL DEFAULT 0,
      stat_smuggling INT NOT NULL DEFAULT 0,
      stat_drugs INT NOT NULL DEFAULT 0,
      stat_money INT NOT NULL DEFAULT 0,
      stat_xp INT NOT NULL DEFAULT 0,
      updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
      PRIMARY KEY (player_id, season_key),
      INDEX idx_season_pass_season (season_key)
    )
  `);
  await ensureStatColumns();
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

/** @deprecated Prefer addSeasonPassProgress with a specific category. */
export async function addSeasonPassScore(_playerId: number, _amount: number): Promise<void> {
  /* no-op: generic score removed in favour of category stats */
}

export async function addSeasonPassProgress(
  playerId: number,
  category: SeasonPassGoalCategory,
  amount: number,
): Promise<void> {
  if (amount <= 0) return;
  const seasonKey = currentSeasonKey();
  const col = STAT_COLUMNS[category];
  if (!col) return;
  await ensureRow(playerId, seasonKey);
  await prisma.$executeRawUnsafe(
    `UPDATE player_season_pass
     SET ${col} = ${col} + ?, score = score + ?
     WHERE player_id = ? AND season_key = ?`,
    Math.floor(amount),
    Math.floor(amount),
    playerId,
    seasonKey,
  );
}

const EVENT_CATEGORY_MAP: Record<string, SeasonPassGoalCategory | undefined> = {
  crime: 'crime',
  vehicles: 'vehicles',
  smuggling: 'smuggling',
  drugs: 'drugs',
};

export function mapEventCategoryToSeasonPass(
  category: string,
): SeasonPassGoalCategory | null {
  if (category in STAT_COLUMNS) return category as SeasonPassGoalCategory;
  return EVENT_CATEGORY_MAP[category] ?? null;
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
  stat_crime: number;
  stat_vehicles: number;
  stat_smuggling: number;
  stat_drugs: number;
  stat_money: number;
  stat_xp: number;
};

function statsFromRow(row: ProgressRow | undefined) {
  return {
    crime: Number(row?.stat_crime ?? 0),
    vehicles: Number(row?.stat_vehicles ?? 0),
    smuggling: Number(row?.stat_smuggling ?? 0),
    drugs: Number(row?.stat_drugs ?? 0),
    money: Number(row?.stat_money ?? 0),
    xp: Number(row?.stat_xp ?? 0),
  };
}

function progressForGoal(stats: ReturnType<typeof statsFromRow>, def: SeasonPassLevelDef): number {
  return stats[def.goalCategory] ?? 0;
}

export async function getSeasonPassStatus(playerId: number) {
  const seasonKey = currentSeasonKey();
  const { startsAt, endsAt } = seasonWindow(seasonKey);
  await ensureRow(playerId, seasonKey);

  const rows = await prisma.$queryRawUnsafe<ProgressRow[]>(
    `SELECT score, premium_unlocked,
            stat_crime, stat_vehicles, stat_smuggling, stat_drugs, stat_money, stat_xp
     FROM player_season_pass
     WHERE player_id = ? AND season_key = ? LIMIT 1`,
    playerId,
    seasonKey,
  );
  const stats = statsFromRow(rows[0]);
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
    const progress = progressForGoal(stats, def);
    const unlocked = progress >= def.goalTarget;
    return {
      level: def.level,
      goalCategory: def.goalCategory,
      goalTarget: def.goalTarget,
      progress,
      remaining: Math.max(0, def.goalTarget - progress),
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

  const nextLevel = levels.find((l) => !l.unlocked) ?? null;

  return {
    seasonKey,
    startsAt,
    endsAt,
    totalGoals: SEASON_PASS_LEVELS.length,
    stats,
    premiumUnlocked,
    priceEurCents: 799,
    productKey: 'season_pass_monthly',
    nextLevel: nextLevel
      ? {
          level: nextLevel.level,
          goalCategory: nextLevel.goalCategory,
          goalTarget: nextLevel.goalTarget,
          progress: nextLevel.progress,
          remaining: nextLevel.remaining,
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
  addSeasonPassProgress,
  mapEventCategoryToSeasonPass,
  unlockSeasonPassPremium,
  getSeasonPassStatus,
  claimSeasonPassReward,
  levels: SEASON_PASS_LEVELS,
};
