import prisma from '../lib/prisma';

const DEFAULT_BONUS = 25_000;

function utcDateKey(d = new Date()): string {
  return d.toISOString().slice(0, 10);
}

export type DailyContractView = {
  contractDate: string;
  hitId: number | null;
  targetPlayerId: number;
  targetUsername: string | null;
  bounty: number | null;
  bonusCash: number;
  status: string;
  isFeaturedHit: boolean;
};

async function pickActiveHit(): Promise<{
  hitId: number;
  targetPlayerId: number;
  bounty: number;
} | null> {
  const rows = await prisma.$queryRawUnsafe<
    Array<{ id: number; targetId: number; bounty: number; counterBounty: number | null }>
  >(
    `SELECT id, targetId, bounty, counterBounty
     FROM hit_list
     WHERE status = 'ACTIVE'
     ORDER BY GREATEST(bounty, COALESCE(counterBounty, 0)) DESC, id ASC
     LIMIT 1`,
  );
  const hit = rows[0];
  if (!hit) return null;
  const bounty = Math.max(Number(hit.bounty) || 0, Number(hit.counterBounty) || 0);
  return {
    hitId: Number(hit.id),
    targetPlayerId: Number(hit.targetId),
    bounty,
  };
}

async function pickFallbackTarget(): Promise<{ targetPlayerId: number } | null> {
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM players
     WHERE health > 0 AND (bannedUntil IS NULL OR bannedUntil < NOW())
     ORDER BY id DESC
     LIMIT 25`,
  );
  if (!rows.length) return null;
  const pick = rows[Math.floor(Math.random() * rows.length)];
  return { targetPlayerId: Number(pick.id) };
}

export async function ensureTodaysDailyContract(): Promise<DailyContractView> {
  const dateKey = utcDateKey();
  const existing = await prisma.$queryRawUnsafe<
    Array<{
      contractDate: Date;
      hitId: number | null;
      targetPlayerId: number;
      bonusCash: number;
      status: string;
    }>
  >(
    `SELECT contractDate, hitId, targetPlayerId, bonusCash, status
     FROM hitlist_daily_contracts WHERE contractDate = ? LIMIT 1`,
    dateKey,
  );
  if (existing[0]) {
    return hydrateContract(existing[0]);
  }

  const active = await pickActiveHit();
  let hitId: number | null = null;
  let targetPlayerId: number;
  if (active) {
    hitId = active.hitId;
    targetPlayerId = active.targetPlayerId;
  } else {
    const fallback = await pickFallbackTarget();
    if (!fallback) {
      return {
        contractDate: dateKey,
        hitId: null,
        targetPlayerId: 0,
        targetUsername: null,
        bounty: null,
        bonusCash: DEFAULT_BONUS,
        status: 'unavailable',
        isFeaturedHit: false,
      };
    }
    targetPlayerId = fallback.targetPlayerId;
  }

  await prisma.$executeRawUnsafe(
    `INSERT INTO hitlist_daily_contracts
       (contractDate, hitId, targetPlayerId, bonusCash, status)
     VALUES (?, ?, ?, ?, 'open')
     ON DUPLICATE KEY UPDATE contractDate = contractDate`,
    dateKey,
    hitId,
    targetPlayerId,
    DEFAULT_BONUS,
  );

  const created = await prisma.$queryRawUnsafe<
    Array<{
      contractDate: Date;
      hitId: number | null;
      targetPlayerId: number;
      bonusCash: number;
      status: string;
    }>
  >(
    `SELECT contractDate, hitId, targetPlayerId, bonusCash, status
     FROM hitlist_daily_contracts WHERE contractDate = ? LIMIT 1`,
    dateKey,
  );
  return hydrateContract(created[0]!);
}

async function hydrateContract(row: {
  contractDate: Date;
  hitId: number | null;
  targetPlayerId: number;
  bonusCash: number;
  status: string;
}): Promise<DailyContractView> {
  const target = await prisma.player.findUnique({
    where: { id: Number(row.targetPlayerId) },
    select: { username: true },
  });
  let bounty: number | null = null;
  const hitId = row.hitId == null ? null : Number(row.hitId);
  if (hitId != null) {
    const hit = await prisma.hitList.findUnique({
      where: { id: hitId },
      select: { bounty: true, counterBounty: true, status: true },
    });
    if (hit) {
      bounty = Math.max(hit.bounty, hit.counterBounty ?? 0);
    }
  }
  return {
    contractDate: utcDateKey(new Date(row.contractDate)),
    hitId,
    targetPlayerId: Number(row.targetPlayerId),
    targetUsername: target?.username ?? null,
    bounty,
    bonusCash: Number(row.bonusCash) || DEFAULT_BONUS,
    status: String(row.status),
    isFeaturedHit: hitId != null,
  };
}

export async function getDailyContract(): Promise<DailyContractView> {
  return ensureTodaysDailyContract();
}

/**
 * If the completed hit matches today's open contract, pay bonus once and mark completed.
 * Returns bonus paid (0 if none).
 */
export async function maybePayoutDailyContractBonus(params: {
  playerId: number;
  hitId: number;
  targetPlayerId: number;
}): Promise<number> {
  const dateKey = utcDateKey();
  const rows = await prisma.$queryRawUnsafe<
    Array<{ hitId: number | null; targetPlayerId: number; bonusCash: number; status: string }>
  >(
    `SELECT hitId, targetPlayerId, bonusCash, status
     FROM hitlist_daily_contracts WHERE contractDate = ? LIMIT 1`,
    dateKey,
  );
  const contract = rows[0];
  if (!contract || contract.status !== 'open') return 0;

  const matchesHit =
    contract.hitId != null && Number(contract.hitId) === params.hitId;
  const matchesTarget =
    contract.hitId == null && Number(contract.targetPlayerId) === params.targetPlayerId;
  if (!matchesHit && !matchesTarget) return 0;

  const bonus = Math.max(0, Number(contract.bonusCash) || DEFAULT_BONUS);
  const updated = await prisma.$executeRawUnsafe(
    `UPDATE hitlist_daily_contracts
     SET status = 'completed', completedBy = ?, completedAt = NOW()
     WHERE contractDate = ? AND status = 'open'`,
    params.playerId,
    dateKey,
  );
  if (!updated) return 0;

  if (bonus > 0) {
    await prisma.player.update({
      where: { id: params.playerId },
      data: { money: { increment: bonus } },
    });
  }
  return bonus;
}
