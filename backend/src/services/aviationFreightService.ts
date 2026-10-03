import prisma from '../lib/prisma';

/** Time to deliver after accept (Hangar Fly is instant; this is the contract window). */
export const FREIGHT_DELIVERY_SECONDS = 3 * 60 * 60; // 3 hours
/** Wait after completing/failing a job before accepting another. */
export const FREIGHT_COOLDOWN_SECONDS = 45 * 60; // 45 minutes

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
      expiresAt DATETIME NULL,
      completedAt DATETIME NULL,
      PRIMARY KEY (id),
      KEY idx_aviation_freight_player (playerId),
      KEY idx_aviation_freight_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
  try {
    await prisma.$executeRawUnsafe(
      `ALTER TABLE aviation_freight_jobs ADD COLUMN expiresAt DATETIME NULL`,
    );
  } catch {
    // column already exists
  }
}

type FreightOffer = {
  offerKey: string;
  originCountry: string;
  destCountry: string;
  cargoTiles: number;
  payout: number;
  deliveryWindowSeconds: number;
};

const OFFER_POOL: Array<Omit<FreightOffer, 'offerKey' | 'deliveryWindowSeconds'>> = [
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

function secondsUntilUtcMidnight(now = new Date()): number {
  const next = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1));
  return Math.max(0, Math.floor((next.getTime() - now.getTime()) / 1000));
}

function withDeliveryWindow(
  offer: Omit<FreightOffer, 'deliveryWindowSeconds'>,
): FreightOffer {
  return { ...offer, deliveryWindowSeconds: FREIGHT_DELIVERY_SECONDS };
}

function dailyOffers(): FreightOffer[] {
  const day = utcDateKey();
  // Stable 4 offers per UTC day.
  const seed = [...day].reduce((a, c) => a + c.charCodeAt(0), 0);
  const picks: FreightOffer[] = [];
  for (let i = 0; i < 4; i++) {
    const base = OFFER_POOL[(seed + i * 3) % OFFER_POOL.length];
    picks.push(
      withDeliveryWindow({
        ...base,
        offerKey: `${day}-${i}-${base.originCountry}-${base.destCountry}`,
      }),
    );
  }
  return picks;
}

function localOriginOffer(currentCountry: string): FreightOffer | null {
  const base = OFFER_POOL.find((o) => o.originCountry === currentCountry);
  if (!base) return null;
  const day = utcDateKey();
  return withDeliveryWindow({
    ...base,
    offerKey: `${day}-local-${base.originCountry}-${base.destCountry}`,
  });
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

async function expireStaleJobs(playerId: number): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE aviation_freight_jobs
     SET status = 'failed', completedAt = COALESCE(completedAt, NOW())
     WHERE playerId = ?
       AND status IN ('accepted','in_flight','claimable')
       AND expiresAt IS NOT NULL
       AND expiresAt < NOW()`,
    playerId,
  );
}

async function acceptCooldownSecondsRemaining(playerId: number): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{ completedAt: Date | null }>>(
    `SELECT completedAt FROM aviation_freight_jobs
     WHERE playerId = ? AND status IN ('done','failed') AND completedAt IS NOT NULL
     ORDER BY completedAt DESC LIMIT 1`,
    playerId,
  );
  const completedAt = rows[0]?.completedAt;
  if (!completedAt) return 0;
  const elapsed = Math.floor((Date.now() - new Date(completedAt).getTime()) / 1000);
  return Math.max(0, FREIGHT_COOLDOWN_SECONDS - elapsed);
}

export async function listFreightBoard(playerId: number): Promise<{
  offers: FreightOffer[];
  activeJob: Record<string, unknown> | null;
  boardResetsInSeconds: number;
  acceptCooldownSeconds: number;
  deliveryWindowSeconds: number;
  cooldownSeconds: number;
}> {
  await expireStaleJobs(playerId);
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
      acceptedAt: Date;
      expiresAt: Date | null;
    }>
  >(
    `SELECT id, aircraftId, originCountry, destCountry, cargoTiles, payout, status, offerKey,
            acceptedAt, expiresAt
     FROM aviation_freight_jobs
     WHERE playerId = ? AND status IN ('accepted','in_flight','claimable')
     ORDER BY id DESC LIMIT 1`,
    playerId,
  );
  const job = active[0];
  let secondsRemaining = 0;
  if (job?.expiresAt) {
    secondsRemaining = Math.max(
      0,
      Math.floor((new Date(job.expiresAt).getTime() - Date.now()) / 1000),
    );
  } else if (job?.acceptedAt) {
    const end =
      new Date(job.acceptedAt).getTime() + FREIGHT_DELIVERY_SECONDS * 1000;
    secondsRemaining = Math.max(0, Math.floor((end - Date.now()) / 1000));
  }

  return {
    offers: offersForPlayer(player?.currentCountry),
    activeJob: job
      ? {
          id: Number(job.id),
          aircraftId: job.aircraftId == null ? null : Number(job.aircraftId),
          originCountry: job.originCountry,
          destCountry: job.destCountry,
          cargoTiles: Number(job.cargoTiles),
          payout: Number(job.payout),
          status: job.status,
          offerKey: job.offerKey,
          expiresAt: job.expiresAt ? new Date(job.expiresAt).toISOString() : null,
          secondsRemaining,
        }
      : null,
    boardResetsInSeconds: secondsUntilUtcMidnight(),
    acceptCooldownSeconds: await acceptCooldownSecondsRemaining(playerId),
    deliveryWindowSeconds: FREIGHT_DELIVERY_SECONDS,
    cooldownSeconds: FREIGHT_COOLDOWN_SECONDS,
  };
}

export async function acceptFreightOffer(
  playerId: number,
  offerKey: string,
  aircraftId: number,
): Promise<{ jobId: number; expiresAt: string; secondsRemaining: number }> {
  await expireStaleJobs(playerId);
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true },
  });
  if (!player) throw new Error('PLAYER_NOT_FOUND');

  const cooldown = await acceptCooldownSecondsRemaining(playerId);
  if (cooldown > 0) {
    const err = new Error('FREIGHT_COOLDOWN') as Error & { retryAfterSeconds?: number };
    err.retryAfterSeconds = cooldown;
    throw err;
  }

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

  await prisma.$executeRawUnsafe(
    `INSERT INTO aviation_freight_jobs
       (playerId, aircraftId, originCountry, destCountry, cargoTiles, payout, status, offerKey, expiresAt)
     VALUES (?, ?, ?, ?, ?, ?, 'accepted', ?, DATE_ADD(NOW(), INTERVAL ? SECOND))`,
    playerId,
    aircraftId,
    offer.originCountry,
    offer.destCountry,
    offer.cargoTiles,
    offer.payout,
    offer.offerKey,
    FREIGHT_DELIVERY_SECONDS,
  );
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number; expiresAt: Date | null }>>(
    `SELECT id, expiresAt FROM aviation_freight_jobs WHERE playerId = ? ORDER BY id DESC LIMIT 1`,
    playerId,
  );
  const expiresAt = rows[0]?.expiresAt
    ? new Date(rows[0].expiresAt).toISOString()
    : new Date(Date.now() + FREIGHT_DELIVERY_SECONDS * 1000).toISOString();
  return {
    jobId: Number(rows[0]?.id ?? 0),
    expiresAt,
    secondsRemaining: FREIGHT_DELIVERY_SECONDS,
  };
}

export async function markFreightInFlight(playerId: number, aircraftId: number, destination: string): Promise<void> {
  await expireStaleJobs(playerId);
  await prisma.$executeRawUnsafe(
    `UPDATE aviation_freight_jobs
     SET status = 'claimable'
     WHERE playerId = ? AND aircraftId = ? AND status = 'accepted' AND destCountry = ?
       AND (expiresAt IS NULL OR expiresAt >= NOW())`,
    playerId,
    aircraftId,
    destination,
  );
}

export async function claimFreightPayout(playerId: number, jobId: number): Promise<{ payout: number }> {
  await expireStaleJobs(playerId);
  const rows = await prisma.$queryRawUnsafe<
    Array<{
      id: number;
      payout: number;
      destCountry: string;
      status: string;
      expiresAt: Date | null;
    }>
  >(
    `SELECT id, payout, destCountry, status, expiresAt FROM aviation_freight_jobs
     WHERE id = ? AND playerId = ? LIMIT 1`,
    jobId,
    playerId,
  );
  const job = rows[0];
  if (!job) throw new Error('FREIGHT_JOB_NOT_FOUND');
  if (job.status === 'failed') throw new Error('FREIGHT_EXPIRED');
  if (job.status !== 'claimable' && job.status !== 'accepted') {
    throw new Error('FREIGHT_JOB_NOT_CLAIMABLE');
  }
  if (job.expiresAt && new Date(job.expiresAt).getTime() < Date.now()) {
    await prisma.$executeRawUnsafe(
      `UPDATE aviation_freight_jobs
       SET status = 'failed', completedAt = NOW()
       WHERE id = ? AND playerId = ?`,
      jobId,
      playerId,
    );
    throw new Error('FREIGHT_EXPIRED');
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
     WHERE id = ? AND playerId = ? AND status IN ('accepted','claimable')
       AND (expiresAt IS NULL OR expiresAt >= NOW())`,
    jobId,
    playerId,
  );
  if (!updated) throw new Error('FREIGHT_JOB_NOT_CLAIMABLE');
  await prisma.player.update({
    where: { id: playerId },
    data: { money: { increment: payout } },
  });
  try {
    const { checkAndUnlockAchievements } = await import('./achievementService');
    await checkAndUnlockAchievements(playerId);
  } catch (err) {
    console.error('[aviationFreightService] achievement check failed', playerId, err);
  }
  return { payout };
}
