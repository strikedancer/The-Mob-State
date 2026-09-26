import prisma from '../lib/prisma';

const SHARE_KEYS = ['CREW_INCOME_SHARE_PERCENT', 'CREW_INCOME_SHARE_MAX_PERCENT'] as const;

async function getSharePercent(): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (?, ?)`,
    ...SHARE_KEYS,
  );
  const map = Object.fromEntries(rows.map((r) => [r.configKey, r.configValue]));
  const pct = Math.floor(Number(map.CREW_INCOME_SHARE_PERCENT ?? 5));
  const max = Math.floor(Number(map.CREW_INCOME_SHARE_MAX_PERCENT ?? 10));
  return Math.max(0, Math.min(max, Math.min(10, pct)));
}

type ShareRow = {
  crewId: number;
  incomeShareEnabled: number | boolean;
};

/**
 * Optional personal→crew bank cut on cash payouts (player toggle).
 * Does not stack on mandatory crew splits (vehicle ops / wholesale).
 */
export async function applyOptionalCrewIncomeShare(
  playerId: number,
  grossAmount: number,
): Promise<{ personal: number; crewShare: number; crewId: number | null }> {
  const gross = Math.max(0, Math.floor(grossAmount));
  if (gross <= 0) {
    return { personal: 0, crewShare: 0, crewId: null };
  }

  const rows = await prisma.$queryRawUnsafe<ShareRow[]>(
    `SELECT crewId, incomeShareEnabled FROM crew_members WHERE playerId = ? LIMIT 1`,
    playerId,
  );
  const membership = rows[0];
  if (!membership || !Number(membership.incomeShareEnabled)) {
    return { personal: gross, crewShare: 0, crewId: null };
  }

  const pct = await getSharePercent();
  if (pct <= 0) {
    return { personal: gross, crewShare: 0, crewId: membership.crewId };
  }

  let crewShare = Math.floor((gross * pct) / 100);
  if (crewShare <= 0) {
    return { personal: gross, crewShare: 0, crewId: membership.crewId };
  }

  const crewId = Number(membership.crewId);
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew) {
    return { personal: gross, crewShare: 0, crewId: null };
  }

  try {
    const { getCrewStorageCapacity } = await import('./crewService');
    const capacity = await getCrewStorageCapacity(crewId, 'cash_storage');
    if (capacity > 0) {
      const room = Math.max(0, capacity - crew.bankBalance);
      if (room <= 0) {
        return { personal: gross, crewShare: 0, crewId };
      }
      crewShare = Math.min(crewShare, room);
    }
  } catch {
    // keep calculated share
  }

  if (crewShare <= 0) {
    return { personal: gross, crewShare: 0, crewId };
  }

  await prisma.$executeRawUnsafe(
    `UPDATE crews SET bankBalance = bankBalance + ? WHERE id = ?`,
    crewShare,
    crewId,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE crew_members
     SET lifetimeContribution = lifetimeContribution + ?
     WHERE crewId = ? AND playerId = ?`,
    crewShare,
    crewId,
    playerId,
  );

  return { personal: gross - crewShare, crewShare, crewId };
}

export async function setIncomeShareEnabled(
  crewId: number,
  playerId: number,
  enabled: boolean,
): Promise<void> {
  const result = await prisma.$executeRawUnsafe(
    `UPDATE crew_members SET incomeShareEnabled = ? WHERE crewId = ? AND playerId = ?`,
    enabled ? 1 : 0,
    crewId,
    playerId,
  );
  if (!result) {
    const row = await prisma.crewMember.findFirst({ where: { crewId, playerId } });
    if (!row) throw new Error('NOT_A_MEMBER');
  }
}
