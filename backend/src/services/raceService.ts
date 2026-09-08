import crypto from 'crypto';
import prisma from '../lib/prisma';
import vehiclesData from '../../content/vehicles.json';
import { getRaceRuntimeConfig, type RaceRuntimeConfig } from './raceRuntimeConfig';

type VehicleCatalogRow = {
  id: string;
  name?: string;
  image?: string;
  imageNew?: string;
  imageDirty?: string;
  imageDamaged?: string;
  stats?: { speed?: number };
};

function findCar(vehicleId: string): VehicleCatalogRow | null {
  const cars = (vehiclesData as { cars?: VehicleCatalogRow[] }).cars ?? [];
  return cars.find((row) => row.id === vehicleId) ?? null;
}

function catalogFile(value?: string): string {
  return typeof value === 'string' && value.trim() ? value.trim() : '';
}

/** Same priority as garage `imageForCondition`: new / dirty / damaged, then catalog still. */
function pickCarImage(def: VehicleCatalogRow | null, condition: number | null): string | null {
  if (!def) return null;
  const imageNew = catalogFile(def.imageNew);
  const imageDirty = catalogFile(def.imageDirty);
  const imageDamaged = catalogFile(def.imageDamaged);
  const image = catalogFile(def.image);
  const cond = condition ?? 100;
  if (cond >= 100 && imageNew) return imageNew;
  if (cond >= 70 && imageDirty) return imageDirty;
  if (cond < 70 && imageDamaged) return imageDamaged;
  return imageNew || imageDirty || imageDamaged || image || null;
}

function catalogLook(
  vehicleId: string,
  condition: number | null = null,
): { name: string; image: string | null } {
  const def = findCar(vehicleId);
  return { name: def?.name ?? vehicleId, image: pickCarImage(def, condition) };
}

async function conditionsByInventoryId(ids: number[]): Promise<Map<number, number>> {
  const unique = [...new Set(ids.filter((id) => Number.isInteger(id) && id > 0))];
  if (unique.length === 0) return new Map();
  const rows = await prisma.vehicleInventory.findMany({
    where: { id: { in: unique } },
    select: { id: true, condition: true },
  });
  return new Map(rows.map((row) => [row.id, row.condition]));
}

async function getTuneSpeed(playerId: number, inventoryId: number): Promise<number> {
  try {
    const rows = await prisma.$queryRawUnsafe<Array<{ speed_level: number }>>(
      `SELECT speed_level FROM vehicle_tuning_upgrades
       WHERE player_id = ? AND vehicle_inventory_id = ? LIMIT 1`,
      playerId,
      inventoryId,
    );
    return Number(rows[0]?.speed_level ?? 0);
  } catch {
    return 0;
  }
}

async function requirePlayer(playerId: number) {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      id: true,
      username: true,
      money: true,
      rank: true,
      currentCountry: true,
      wantedLevel: true,
      jailRelease: true,
      travelingTo: true,
    },
  });
  if (!player) throw new Error('PLAYER_NOT_FOUND');
  if (player.jailRelease && player.jailRelease.getTime() > Date.now()) {
    throw new Error('PLAYER_JAILED');
  }
  if (player.travelingTo) {
    throw new Error('PLAYER_TRAVELING');
  }
  return player;
}

async function pickHost(countryCode: string) {
  return prisma.nightclubVenue.findFirst({
    where: { country: countryCode, isOpen: true },
    orderBy: { totalRevenueAllTime: 'desc' },
    select: { id: true, playerId: true },
  });
}

async function ensureOpenMeeting(countryCode: string, cfg: RaceRuntimeConfig) {
  const now = new Date();
  const open = await prisma.midnightRaceMeeting.findFirst({
    where: { countryCode, status: 'open', endsAt: { gt: now } },
    orderBy: { endsAt: 'desc' },
  });
  if (open) return open;

  const last = await prisma.midnightRaceMeeting.findFirst({
    where: { countryCode },
    orderBy: { endsAt: 'desc' },
  });
  if (last) {
    const nextOpenAt = new Date(last.endsAt.getTime() + cfg.cooldownMinutes * 60 * 1000);
    if (nextOpenAt.getTime() > now.getTime()) {
      return { cooldownUntil: nextOpenAt, last } as const;
    }
  }

  const host = await pickHost(countryCode);
  const created = await prisma.midnightRaceMeeting.create({
    data: {
      countryCode,
      status: 'open',
      startsAt: now,
      endsAt: new Date(now.getTime() + cfg.windowMinutes * 60 * 1000),
      hostVenueId: host?.id ?? null,
      hostPlayerId: host?.playerId ?? null,
      rakeBps: cfg.rakeBps,
    },
  });
  return created;
}

function rollSpeedScore(input: {
  baseSpeed: number;
  tuneSpeed: number;
  condition: number;
  fixing: boolean;
}): number {
  const rng = crypto.randomInt(0, 26);
  const tune = input.tuneSpeed * 6;
  const condition = Math.round(input.condition * 0.2);
  const fixing = input.fixing ? 12 : 0;
  return Math.max(1, Math.round(input.baseSpeed + tune + condition + rng + fixing));
}

function serializeMeeting(
  meeting: {
    id: number;
    countryCode: string;
    status: string;
    startsAt: Date;
    endsAt: Date;
    hostVenueId: number | null;
    hostPlayerId: number | null;
    rakeBps: number;
    prizePool: number;
    rakePaid: number;
  },
  extras: Record<string, unknown> = {},
) {
  return {
    id: meeting.id,
    countryCode: meeting.countryCode,
    status: meeting.status,
    startsAt: meeting.startsAt.toISOString(),
    endsAt: meeting.endsAt.toISOString(),
    hostVenueId: meeting.hostVenueId,
    hostPlayerId: meeting.hostPlayerId,
    rakeBps: meeting.rakeBps,
    prizePool: meeting.prizePool,
    rakePaid: meeting.rakePaid,
    ...extras,
  };
}

export const raceService = {
  async getOverview(playerId: number) {
    const cfg = await getRaceRuntimeConfig();
    if (!cfg.enabled) throw new Error('RACE_DISABLED');

    const player = await requirePlayer(playerId);
    if (player.rank < cfg.minRank) {
      throw new Error(`RACE_RANK_TOO_LOW:${cfg.minRank}`);
    }

    const ensured = await ensureOpenMeeting(player.currentCountry, cfg);
    const cooldownUntil = 'cooldownUntil' in ensured ? ensured.cooldownUntil : null;
    const meeting = 'id' in ensured ? ensured : null;

    const lastSettled = await prisma.midnightRaceMeeting.findFirst({
      where: { countryCode: player.currentCountry, status: 'settled' },
      orderBy: { endsAt: 'desc' },
      include: {
        entries: {
          include: { player: { select: { id: true, username: true } } },
          orderBy: [{ finishPlace: 'asc' }, { id: 'asc' }],
        },
      },
    });

    const inventory = await prisma.vehicleInventory.findMany({
      where: {
        playerId,
        vehicleType: 'car',
        currentLocation: player.currentCountry,
        marketListing: false,
        showroomPropertyId: null,
      },
    });
    const eligibleCars = inventory
      .filter((row) => {
        if ((row.transportStatus ?? '') && row.transportStatus !== 'idle') return false;
        if (row.condition < cfg.minCondition) return false;
        return Boolean(findCar(row.vehicleId));
      })
      .map((row) => {
        const def = findCar(row.vehicleId);
        const look = catalogLook(row.vehicleId, row.condition);
        return {
          inventoryId: row.id,
          vehicleId: row.vehicleId,
          name: look.name,
          image: look.image,
          speed: Number(def?.stats?.speed ?? 0),
          condition: row.condition,
        };
      });

    let live: Record<string, unknown> | null = null;
    if (meeting) {
      const [entries, bets, myEntry] = await Promise.all([
        prisma.midnightRaceEntry.findMany({
          where: { meetingId: meeting.id },
          include: { player: { select: { id: true, username: true } } },
          orderBy: { createdAt: 'asc' },
        }),
        prisma.midnightRaceBet.findMany({
          where: { meetingId: meeting.id, bettorId: playerId },
        }),
        prisma.midnightRaceEntry.findUnique({
          where: { meetingId_playerId: { meetingId: meeting.id, playerId } },
        }),
      ]);
      const entryConditions = await conditionsByInventoryId([
        ...entries.map((entry) => entry.vehicleInventoryId),
        ...(myEntry ? [myEntry.vehicleInventoryId] : []),
      ]);
      live = serializeMeeting(meeting, {
        endsInSeconds: Math.max(0, Math.floor((meeting.endsAt.getTime() - Date.now()) / 1000)),
        myEntry: myEntry
          ? {
              id: myEntry.id,
              vehicleId: myEntry.vehicleId,
              ...catalogLook(myEntry.vehicleId, entryConditions.get(myEntry.vehicleInventoryId) ?? null),
              stake: myEntry.stake,
              fixing: myEntry.fixing,
            }
          : null,
        entries: entries.map((entry) => ({
          id: entry.id,
          playerId: entry.playerId,
          username: entry.player.username,
          vehicleId: entry.vehicleId,
          ...catalogLook(entry.vehicleId, entryConditions.get(entry.vehicleInventoryId) ?? null),
          stake: entry.stake,
          fixing: entry.fixing,
        })),
        myBets: bets.map((bet) => ({
          id: bet.id,
          entryId: bet.entryId,
          amount: bet.amount,
        })),
      });
    }

    const resultConditions = lastSettled
      ? await conditionsByInventoryId(lastSettled.entries.map((entry) => entry.vehicleInventoryId))
      : new Map<number, number>();

    return {
      countryCode: player.currentCountry,
      config: {
        minStake: cfg.minStake,
        maxStake: cfg.maxStake,
        minBet: cfg.minBet,
        maxBet: cfg.maxBet,
        maxEntries: cfg.maxEntries,
        maxBetsPerPlayer: cfg.maxBetsPerPlayer,
        minCondition: cfg.minCondition,
        rakeBps: cfg.rakeBps,
        windowMinutes: cfg.windowMinutes,
        cooldownMinutes: cfg.cooldownMinutes,
        fixingWanted: cfg.fixingWanted,
      },
      cooldownUntil: cooldownUntil ? cooldownUntil.toISOString() : null,
      meeting: live,
      eligibleCars,
      lastResult: lastSettled
        ? serializeMeeting(lastSettled, {
            entries: lastSettled.entries.map((entry) => ({
              id: entry.id,
              playerId: entry.playerId,
              username: entry.player.username,
              vehicleId: entry.vehicleId,
              ...catalogLook(entry.vehicleId, resultConditions.get(entry.vehicleInventoryId) ?? null),
              finishPlace: entry.finishPlace,
              payout: entry.payout,
              speedScore: entry.speedScore,
            })),
          })
        : null,
    };
  },

  async enter(playerId: number, vehicleInventoryId: number, stake: number, fixing: boolean) {
    const cfg = await getRaceRuntimeConfig();
    if (!cfg.enabled) throw new Error('RACE_DISABLED');
    const player = await requirePlayer(playerId);
    if (player.rank < cfg.minRank) throw new Error(`RACE_RANK_TOO_LOW:${cfg.minRank}`);

    const amount = Math.floor(Number(stake) || 0);
    if (amount < cfg.minStake || amount > cfg.maxStake) {
      throw new Error(`RACE_STAKE:${cfg.minStake}:${cfg.maxStake}`);
    }

    const ensured = await ensureOpenMeeting(player.currentCountry, cfg);
    if (!('id' in ensured)) throw new Error('RACE_COOLDOWN');
    const meeting = ensured;
    if (meeting.endsAt.getTime() <= Date.now()) throw new Error('RACE_CLOSED');

    const existing = await prisma.midnightRaceEntry.findUnique({
      where: { meetingId_playerId: { meetingId: meeting.id, playerId } },
    });
    if (existing) throw new Error('RACE_ALREADY_ENTERED');

    const entryCount = await prisma.midnightRaceEntry.count({ where: { meetingId: meeting.id } });
    if (entryCount >= cfg.maxEntries) throw new Error('RACE_FULL');

    const car = await prisma.vehicleInventory.findFirst({
      where: {
        id: vehicleInventoryId,
        playerId,
        vehicleType: 'car',
        currentLocation: player.currentCountry,
        marketListing: false,
        showroomPropertyId: null,
      },
    });
    if (!car) throw new Error('RACE_VEHICLE_INVALID');
    if ((car.transportStatus ?? '') && car.transportStatus !== 'idle') {
      throw new Error('RACE_VEHICLE_INVALID');
    }
    if (car.condition < cfg.minCondition) throw new Error('RACE_CONDITION');
    if (!findCar(car.vehicleId)) throw new Error('RACE_VEHICLE_INVALID');

    if (player.money < amount) throw new Error('INSUFFICIENT_FUNDS');

    await prisma.$transaction(async (tx) => {
      const paid = await tx.player.updateMany({
        where: { id: playerId, money: { gte: amount } },
        data: { money: { decrement: amount } },
      });
      if (paid.count !== 1) throw new Error('INSUFFICIENT_FUNDS');
      if (fixing) {
        await tx.player.update({
          where: { id: playerId },
          data: { wantedLevel: { increment: cfg.fixingWanted } },
        });
      }

      await tx.midnightRaceEntry.create({
        data: {
          meetingId: meeting.id,
          playerId,
          vehicleInventoryId: car.id,
          vehicleId: car.vehicleId,
          stake: amount,
          fixing,
          status: 'entered',
        },
      });
    });

    return this.getOverview(playerId);
  },

  async bet(playerId: number, entryId: number, amountRaw: number) {
    const cfg = await getRaceRuntimeConfig();
    if (!cfg.enabled) throw new Error('RACE_DISABLED');
    const player = await requirePlayer(playerId);
    if (player.rank < cfg.minRank) throw new Error(`RACE_RANK_TOO_LOW:${cfg.minRank}`);

    const amount = Math.floor(Number(amountRaw) || 0);
    if (amount < cfg.minBet || amount > cfg.maxBet) {
      throw new Error(`RACE_BET:${cfg.minBet}:${cfg.maxBet}`);
    }

    const entry = await prisma.midnightRaceEntry.findUnique({
      where: { id: entryId },
      include: { meeting: true },
    });
    if (!entry || entry.meeting.countryCode !== player.currentCountry) {
      throw new Error('RACE_ENTRY_NOT_FOUND');
    }
    if (entry.meeting.status !== 'open' || entry.meeting.endsAt.getTime() <= Date.now()) {
      throw new Error('RACE_CLOSED');
    }
    if (entry.playerId === playerId) throw new Error('RACE_BET_OWN');

    const myBets = await prisma.midnightRaceBet.count({
      where: { meetingId: entry.meetingId, bettorId: playerId },
    });
    if (myBets >= cfg.maxBetsPerPlayer) throw new Error('RACE_BET_CAP');
    if (player.money < amount) throw new Error('INSUFFICIENT_FUNDS');

    await prisma.$transaction(async (tx) => {
      const paid = await tx.player.updateMany({
        where: { id: playerId, money: { gte: amount } },
        data: { money: { decrement: amount } },
      });
      if (paid.count !== 1) throw new Error('INSUFFICIENT_FUNDS');
      await tx.midnightRaceBet.create({
        data: {
          meetingId: entry.meetingId,
          entryId: entry.id,
          bettorId: playerId,
          amount,
          status: 'pending',
        },
      });
    });

    return this.getOverview(playerId);
  },

  async processTick(): Promise<{ settled: number; refunded: number }> {
    const due = await prisma.midnightRaceMeeting.findMany({
      where: { status: 'open', endsAt: { lte: new Date() } },
      select: { id: true },
      take: 20,
    });
    let settled = 0;
    let refunded = 0;
    for (const row of due) {
      const result = await this.settleMeeting(row.id);
      if (result === 'refunded') refunded += 1;
      else if (result === 'settled') settled += 1;
    }
    return { settled, refunded };
  },

  async settleMeeting(meetingId: number): Promise<'settled' | 'refunded' | 'skipped'> {
    const meeting = await prisma.midnightRaceMeeting.findUnique({
      where: { id: meetingId },
      include: {
        entries: true,
        bets: true,
      },
    });
    if (!meeting || meeting.status !== 'open') return 'skipped';

    if (meeting.entries.length < 2) {
      await prisma.$transaction(async (tx) => {
        for (const entry of meeting.entries) {
          await tx.player.update({
            where: { id: entry.playerId },
            data: { money: { increment: entry.stake } },
          });
          await tx.midnightRaceEntry.update({
            where: { id: entry.id },
            data: { status: 'refunded', payout: entry.stake },
          });
        }
        for (const bet of meeting.bets) {
          await tx.player.update({
            where: { id: bet.bettorId },
            data: { money: { increment: bet.amount } },
          });
          await tx.midnightRaceBet.update({
            where: { id: bet.id },
            data: { status: 'refunded', payout: bet.amount },
          });
        }
        await tx.midnightRaceMeeting.update({
          where: { id: meeting.id },
          data: { status: 'settled', prizePool: 0, rakePaid: 0 },
        });
      });
      return 'refunded';
    }

    const scored = [];
    for (const entry of meeting.entries) {
      const def = findCar(entry.vehicleId);
      const inventory = await prisma.vehicleInventory.findUnique({
        where: { id: entry.vehicleInventoryId },
        select: { condition: true },
      });
      const tuneSpeed = await getTuneSpeed(entry.playerId, entry.vehicleInventoryId);
      scored.push({
        entry,
        score: rollSpeedScore({
          baseSpeed: Number(def?.stats?.speed ?? 40),
          tuneSpeed,
          condition: inventory?.condition ?? 50,
          fixing: entry.fixing,
        }),
      });
    }
    scored.sort((left, right) => right.score - left.score || left.entry.id - right.entry.id);

    const stakePool = meeting.entries.reduce((sum, entry) => sum + entry.stake, 0);
    const betPool = meeting.bets.reduce((sum, bet) => sum + bet.amount, 0);
    const gross = stakePool + betPool;
    const rake = Math.floor((gross * meeting.rakeBps) / 10000);
    const remainder = Math.max(0, gross - rake);
    const driverPool = Math.floor(remainder * 0.65);
    const betPrize = remainder - driverPool;

    const shares =
      scored.length >= 3 ? [0.55, 0.3, 0.15] : scored.length === 2 ? [0.7, 0.3] : [1];
    const driverPayouts = scored.map((row, index) => ({
      entryId: row.entry.id,
      playerId: row.entry.playerId,
      place: index + 1,
      score: row.score,
      payout: index < shares.length ? Math.floor(driverPool * shares[index]) : 0,
    }));

    const winnerEntryId = scored[0]?.entry.id ?? null;
    const winningBets = winnerEntryId
      ? meeting.bets.filter((bet) => bet.entryId === winnerEntryId)
      : [];
    const winningBetTotal = winningBets.reduce((sum, bet) => sum + bet.amount, 0);
    const betPayouts = meeting.bets.map((bet) => {
      if (!winnerEntryId || bet.entryId !== winnerEntryId || winningBetTotal <= 0) {
        return { id: bet.id, bettorId: bet.bettorId, payout: 0, won: false };
      }
      return {
        id: bet.id,
        bettorId: bet.bettorId,
        payout: Math.floor((betPrize * bet.amount) / winningBetTotal),
        won: true,
      };
    });

    let leftoverRake = rake;
    if (winningBets.length === 0) leftoverRake += betPrize;

    await prisma.$transaction(async (tx) => {
      for (const row of driverPayouts) {
        if (row.payout > 0) {
          await tx.player.update({
            where: { id: row.playerId },
            data: { money: { increment: row.payout } },
          });
        }
        await tx.midnightRaceEntry.update({
          where: { id: row.entryId },
          data: {
            status: 'finished',
            finishPlace: row.place,
            speedScore: row.score,
            payout: row.payout,
          },
        });
      }
      for (const bet of betPayouts) {
        if (bet.payout > 0) {
          await tx.player.update({
            where: { id: bet.bettorId },
            data: { money: { increment: bet.payout } },
          });
        }
        await tx.midnightRaceBet.update({
          where: { id: bet.id },
          data: { status: bet.won ? 'won' : 'lost', payout: bet.payout },
        });
      }
      if (meeting.hostPlayerId && leftoverRake > 0) {
        await tx.player.update({
          where: { id: meeting.hostPlayerId },
          data: { money: { increment: leftoverRake } },
        });
      }
      await tx.midnightRaceMeeting.update({
        where: { id: meeting.id },
        data: {
          status: 'settled',
          prizePool: driverPool + (winningBets.length > 0 ? betPrize : 0),
          rakePaid: leftoverRake,
        },
      });
    });

    return 'settled';
  },
};
