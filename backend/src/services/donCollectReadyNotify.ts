import prisma from '../lib/prisma';
import { donBusinessLabel, notifyDon } from './donNotify';

/** Wait this long after the first unnotified ready racket so sibling shops share one notice. */
export const COLLECT_READY_BATCH_MS = 10 * 60 * 1000;

type OwnedRacketRow = {
  id: number;
  ownerPlayerId: number | null;
  businessKey: string;
  lastCollectAt: Date | null;
};

export function parseCollectReadyRacketIds(params: unknown): number[] {
  let data = params;
  if (typeof params === 'string') {
    try {
      data = JSON.parse(params);
    } catch {
      return [];
    }
  }
  if (!data || typeof data !== 'object') return [];
  const obj = data as Record<string, unknown>;
  const ids: number[] = [];
  const pushId = (value: unknown) => {
    const n = Number(value);
    if (Number.isInteger(n) && n > 0 && !ids.includes(n)) ids.push(n);
  };
  if (Array.isArray(obj.racketIds)) {
    for (const id of obj.racketIds) pushId(id);
  }
  pushId(obj.racketId);
  return ids;
}

export function joinDonBusinessLabels(keys: string[], nl: boolean): string {
  const labels = keys.map((key) => donBusinessLabel(key, nl));
  if (labels.length <= 1) return labels[0] ?? '';
  const last = labels[labels.length - 1];
  const head = labels.slice(0, -1).join(', ');
  return nl ? `${head} en ${last}` : `${head} and ${last}`;
}

export function collectReadyInboxCopy(businessKeys: string[]): { nl: string; en: string } {
  const unique = [...new Set(businessKeys.filter((key) => key.length > 0))];
  if (unique.length <= 1) {
    const key = unique[0] ?? 'racket';
    return {
      nl: `Je ${donBusinessLabel(key, true)} is klaar om te innen.`,
      en: `Your ${donBusinessLabel(key, false)} is ready to collect.`,
    };
  }
  return {
    nl: `Je ${joinDonBusinessLabels(unique, true)} zijn klaar om te innen.`,
    en: `Your ${joinDonBusinessLabels(unique, false)} are ready to collect.`,
  };
}

export function racketReadyAtMs(lastCollectAt: Date, cooldownSeconds: number): number {
  return lastCollectAt.getTime() + cooldownSeconds * 1000;
}

/** True while another owned shop will become ready inside the 10-minute window of the first unnotified ready shop. */
export function shouldDelayCollectReadyNotify(
  nowMs: number,
  earliestReadyAtMs: number,
  upcomingReadyAtMs: number[],
  batchMs = COLLECT_READY_BATCH_MS
): boolean {
  const windowEnd = earliestReadyAtMs + batchMs;
  if (nowMs >= windowEnd) return false;
  return upcomingReadyAtMs.some((readyAt) => readyAt > nowMs && readyAt <= windowEnd);
}

function racketNotifiedSinceCollect(
  racketId: number,
  lastCollectAt: Date,
  events: Array<{ createdAt: Date; params: string }>
): boolean {
  return events.some((event) => {
    if (event.createdAt.getTime() < lastCollectAt.getTime()) return false;
    return parseCollectReadyRacketIds(event.params).includes(racketId);
  });
}

export async function notifyCollectReadyBatches(now: Date, cooldownSeconds: number): Promise<void> {
  const owned = await prisma.donRacket.findMany({
    where: { ownerPlayerId: { not: null }, lastCollectAt: { not: null } },
    select: { id: true, ownerPlayerId: true, businessKey: true, lastCollectAt: true },
  });
  if (owned.length === 0) return;

  const byOwner = new Map<number, OwnedRacketRow[]>();
  for (const racket of owned) {
    if (!racket.ownerPlayerId || !racket.lastCollectAt) continue;
    const list = byOwner.get(racket.ownerPlayerId) ?? [];
    list.push(racket);
    byOwner.set(racket.ownerPlayerId, list);
  }

  const nowMs = now.getTime();

  for (const [ownerId, rackets] of byOwner) {
    const oldestCollect = rackets.reduce((min, racket) => {
      const at = racket.lastCollectAt!.getTime();
      return at < min ? at : min;
    }, Number.POSITIVE_INFINITY);
    const events = await prisma.worldEvent.findMany({
      where: {
        playerId: ownerId,
        eventKey: 'don.collect_ready',
        createdAt: { gte: new Date(oldestCollect) },
      },
      select: { params: true, createdAt: true },
      orderBy: { createdAt: 'desc' },
      take: 40,
    });

    const pendingReady = rackets
      .filter((racket) => {
        const readyAt = racketReadyAtMs(racket.lastCollectAt!, cooldownSeconds);
        if (readyAt > nowMs) return false;
        return !racketNotifiedSinceCollect(racket.id, racket.lastCollectAt!, events);
      })
      .sort((a, b) => {
        const aReady = racketReadyAtMs(a.lastCollectAt!, cooldownSeconds);
        const bReady = racketReadyAtMs(b.lastCollectAt!, cooldownSeconds);
        if (aReady !== bReady) return aReady - bReady;
        return a.id - b.id;
      });
    if (pendingReady.length === 0) continue;

    const earliestReadyAtMs = racketReadyAtMs(pendingReady[0].lastCollectAt!, cooldownSeconds);
    const upcomingReadyAtMs = rackets
      .filter((racket) => !pendingReady.some((ready) => ready.id === racket.id))
      .map((racket) => racketReadyAtMs(racket.lastCollectAt!, cooldownSeconds))
      .filter((readyAt) => readyAt > nowMs);

    if (shouldDelayCollectReadyNotify(nowMs, earliestReadyAtMs, upcomingReadyAtMs)) {
      continue;
    }

    const racketIds = pendingReady.map((racket) => racket.id);
    const businessKeys = pendingReady.map((racket) => racket.businessKey);
    await notifyDon(ownerId, collectReadyInboxCopy(businessKeys), {
      push: true,
      eventKey: 'don.collect_ready',
      params: {
        racketId: racketIds[0],
        racketIds,
        businessKey: businessKeys[0],
        businessKeys,
      },
    });
  }
}
