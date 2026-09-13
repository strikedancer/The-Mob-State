import prisma from '../lib/prisma';

let cache: { ids: Set<number>; at: number } | null = null;
const TTL_MS = 30_000;

export async function getNpcPlayerIdSet(): Promise<Set<number>> {
  if (cache && Date.now() - cache.at < TTL_MS) {
    return cache.ids;
  }

  const rows = await prisma.nPCPlayer.findMany({
    select: { playerId: true },
  });
  cache = {
    ids: new Set(rows.map((row) => row.playerId)),
    at: Date.now(),
  };
  return cache.ids;
}

export async function isNpcPlayerId(playerId: number): Promise<boolean> {
  const ids = await getNpcPlayerIdSet();
  if (ids.has(playerId)) {
    return true;
  }

  const row = await prisma.nPCPlayer.findUnique({
    where: { playerId },
    select: { playerId: true },
  });
  if (!row) {
    return false;
  }

  ids.add(playerId);
  return true;
}

export function invalidateNpcPlayerIdCache() {
  cache = null;
}
