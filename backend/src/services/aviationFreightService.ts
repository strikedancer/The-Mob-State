import prisma from '../lib/prisma';

export async function ensureAviationFreightSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS aviation_freight_jobs (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      aircraftId INT NULL,
      originCountry VARCHAR(50) NOT NULL,
      destCountry VARCHAR(50) NOT NULL,
      cargoTiles INT NOT NULL,
      payout INT NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'accepted',
      offerKey VARCHAR(64) NOT NULL,
      acceptedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      completedAt DATETIME NULL,
      PRIMARY KEY (id),
      KEY idx_aviation_freight_player (playerId),
      KEY idx_aviation_freight_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}

type FreightOffer = {
  offerKey: string;
  originCountry: string;
  destCountry: string;
  cargoTiles: number;
  payout: number;
};

const OFFER_POOL: Array<Omit<FreightOffer, 'offerKey'>> = [
  { originCountry: 'netherlands', destCountry: 'belgium', cargoTiles: 2, payout: 18000 },
  { originCountry: 'belgium', destCountry: 'france', cargoTiles: 3, payout: 28000 },
  { originCountry: 'france', destCountry: 'spain', cargoTiles: 4, payout: 42000 },
  { originCountry: 'germany', destCountry: 'netherlands', cargoTiles: 3, payout: 30000 },
  { originCountry: 'italy', destCountry: 'france', cargoTiles: 4, payout: 45000 },
  { originCountry: 'spain', destCountry: 'portugal', cargoTiles: 2, payout: 22000 },
  { originCountry: 'united_kingdom', destCountry: 'netherlands', cargoTiles: 5, payout: 55000 },
  { originCountry: 'poland', destCountry: 'germany', cargoTiles: 3, payout: 32000 },
];

function utcDateKey(d = new Date()): string {
  return d.toISOString().slice(0, 10);
}

function dailyOffers(): FreightOffer[] {
  const day = utcDateKey();
  // Stable 4 offers per UTC day.
  const seed = [...day].reduce((a, c) => a + c.charCodeAt(0), 0);
  const picks: FreightOffer[] = [];
  for (let i = 0; i < 4; i++) {
    const base = OFFER_POOL[(seed + i * 3) % OFFER_POOL.length];
    picks.push({
      ...base,
      offerKey: `${day}-${i}-${base.originCountry}-${base.destCountry}`,
    });
  }
  return picks;
}

function localOriginOffer(currentCountry: string): FreightOffer | null {
  const base = OFFER_POOL.find((o) => o.originCountry === currentCountry);
  if (!base) return null;
  const day = utcDateKey();
  return {
    ...base,
    offerKey: `${day}-local-${base.originCountry}-${base.destCountry}`,
  };
}

/** Daily board plus a guaranteed offer from the player's current country when possible. */
export function offersForPlayer(currentCountry: string | null | undefined): FreightOffer[] {
  const offers = dailyOffers();
  const country = (currentCountry || '').trim();
  if (!country) return offers;

  const sorted = [...offers].sort((a, b) => {
    const aMatch = a.originCountry === country ? 0 : 1;
    const bMatch = b.originCountry === country ? 0 : 1;
    return aMatch - bMatch;
  });

  if (sorted.some((o) => o.originCountry === country)) return sorted;

  const local = localOriginOffer(country);
  if (!local) return sorted;
  return [local, ...sorted.slice(0, 3)];
}

function resolveOffer(
  offerKey: string,
  currentCountry: string | null | undefined,
): FreightOffer | undefined {
  return offersForPlayer(currentCountry).find((o) => o.offerKey === offerKey);
}

export async function listFreightBoard(playerId: number): Promise<{
  offers: FreightOffer[];
  activeJob: Record<string, unknown> | null;
}> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  const active = await prisma.$queryRawUnsafe<
    Array<{
      id: number;
      aircraftId: number | null;
      originCountry: string;
      destCountry: string;
      cargoTiles: number;
      payout: number;
      status: string;
      offerKey: string;
    }>
  >(
    `SELECT id, aircraftId, originCountry, destCountry, cargoTiles, payout, status, offerKey
     FROM aviation_freight_jobs
     WHERE playerId = ? AND status IN ('accepted','in_flight','claimable')
     ORDER BY id DESC LIMIT 1`,
    playerId,
  );
  return {
    offers: offersForPlayer(player?.currentCountry),
    activeJob: active[0]
      ? {
          id: Number(active[0].id),
          aircraftId: active[0].aircraftId == null ? null : Number(active[0].aircraftId),
          originCountry: active[0].originCountry,
          destCountry: active[0].destCountry,
          cargoTiles: Number(active[0].cargoTiles),
          payout: Number(active[0].payout),
          status: active[0].status,
          offerKey: active[0].offerKey,
        }
      : null,
  };
}

export async function acceptFreightOffer(
  playerId: number,
  offerKey: string,
  aircraftId: number,
): Promise<{ jobId: number }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  if (!player) throw new Error('PLAYER_NOT_FOUND');

  const offer = resolveOffer(offerKey, player.currentCountry);
  if (!offer) throw new Error('FREIGHT_OFFER_NOT_FOUND');

  const board = await listFreightBoard(playerId);
  if (board.activeJob) throw new Error('FREIGHT_JOB_ACTIVE');

  const aircraft = await prisma.aircraft.findFirst({
    where: { id: aircraftId, playerId },
  });
  if (!aircraft) throw new Error('AIRCRAFT_NOT_FOUND');
  if (aircraft.isBroken) throw new Error('AIRCRAFT_BROKEN');

  const { getAircraftById } = await import('./aviationService');
  const def = getAircraftById(aircraft.aircraftType);
  const capacity = Number(def?.cargoCapacity ?? 0);
  if (capacity < offer.cargoTiles) throw new Error('FREIGHT_CARGO_TOO_SMALL');

  if (player.currentCountry !== offer.originCountry) {
    throw new Error('FREIGHT_WRONG_ORIGIN');
  }

  const result = await prisma.$executeRawUnsafe(
    `INSERT INTO aviation_freight_jobs
       (playerId, aircraftId, originCountry, destCountry, cargoTiles, payout, status, offerKey)
     VALUES (?, ?, ?, ?, ?, ?, 'accepted', ?)`,
    playerId,
    aircraftId,
    offer.originCountry,
    offer.destCountry,
    offer.cargoTiles,
    offer.payout,
    offer.offerKey,
  );
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM aviation_freight_jobs WHERE playerId = ? ORDER BY id DESC LIMIT 1`,
    playerId,
  );
  void result;
  return { jobId: Number(rows[0]?.id ?? 0) };
}

export async function markFreightInFlight(playerId: number, aircraftId: number, destination: string): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE aviation_freight_jobs
     SET status = 'claimable'
     WHERE playerId = ? AND aircraftId = ? AND status = 'accepted' AND destCountry = ?`,
    playerId,
    aircraftId,
    destination,
  );
}

export async function claimFreightPayout(playerId: number, jobId: number): Promise<{ payout: number }> {
  const rows = await prisma.$queryRawUnsafe<
    Array<{ id: number; payout: number; destCountry: string; status: string }>
  >(
    `SELECT id, payout, destCountry, status FROM aviation_freight_jobs
     WHERE id = ? AND playerId = ? LIMIT 1`,
    jobId,
    playerId,
  );
  const job = rows[0];
  if (!job) throw new Error('FREIGHT_JOB_NOT_FOUND');
  if (job.status !== 'claimable' && job.status !== 'accepted') {
    throw new Error('FREIGHT_JOB_NOT_CLAIMABLE');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  if (!player || player.currentCountry !== job.destCountry) {
    throw new Error('FREIGHT_WRONG_DEST');
  }

  const payout = Number(job.payout) || 0;
  const updated = await prisma.$executeRawUnsafe(
    `UPDATE aviation_freight_jobs
     SET status = 'done', completedAt = NOW()
     WHERE id = ? AND playerId = ? AND status IN ('accepted','claimable')`,
    jobId,
    playerId,
  );
  if (!updated) throw new Error('FREIGHT_JOB_NOT_CLAIMABLE');
  await prisma.player.update({
    where: { id: playerId },
    data: { money: { increment: payout } },
  });
  return { payout };
}
