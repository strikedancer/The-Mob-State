import prisma from '../lib/prisma';
import { checkIfJailed, increaseWantedLevel, jailPlayer } from './policeService';
import { increaseFBIHeat } from './fbiService';
import { isVipStatusActive } from './vipBenefitsService';
import { prostituteService } from './prostituteService';
import { rldNotify } from './rldNotify';
import { serializeContest } from './redLightDistrictService';
import {
  RLD_BUST_HOURS,
  RLD_CONTEST_ACTIVE_MS,
  RLD_CONTEST_COOLDOWN_MS,
  RLD_CONTEST_HOLD_COST,
  RLD_CONTEST_HOLD_HEAT,
  RLD_CONTEST_HOLD_MAX,
  RLD_CONTEST_HOLD_MAX_VIP,
  RLD_CONTEST_HOLD_POINTS,
  RLD_CONTEST_LOCKDOWN_MS,
  RLD_CONTEST_MIN_RANK,
  RLD_CONTEST_PREP_MS,
  RLD_CONTEST_SABOTAGE_COST,
  RLD_CONTEST_SABOTAGE_POINTS,
  RLD_CONTEST_SECURITY_POINTS,
  RLD_CONTEST_STAKE,
  RLD_CONTEST_STEAL_POINTS,
  RLD_CONTEST_VIP_DEFENSE_POINTS,
  RLD_EVENT_FAIL_BUST_CHANCE,
  RLD_FAIL_BUST_CHANCE,
  RLD_FAIL_WORKER_BUST_CHANCE,
  RLD_GUARD_COOLDOWN_HOURS,
  RLD_GUARD_COST,
  RLD_GUARD_HOURS,
  RLD_GUARD_HOURS_VIP,
  RLD_HOT_HOURS,
  RLD_OCCUPANCY_BUSY,
  RLD_RECLAIM_COST,
  RLD_RECLAIM_HEAT,
  RLD_STEAL_COOLDOWN_HOURS,
  RLD_STEAL_COST,
  RLD_STEAL_HEAT,
  RLD_STEAL_WANTED,
  isWorkerOnShift,
  isWorkerResting,
  occupancyRate,
  rldOccupancyCapacity,
} from './rldConfig';

type ActionResult = { success: boolean; message: string; [key: string]: unknown };

function hoursFromNow(hours: number): Date {
  return new Date(Date.now() + hours * 60 * 60 * 1000);
}

async function hasRivalry(a: number, b: number): Promise<boolean> {
  const row = await prisma.prostitutionRivalry.findFirst({
    where: {
      OR: [
        { playerId: a, rivalPlayerId: b },
        { playerId: b, rivalPlayerId: a },
      ],
    },
    select: { id: true },
  });
  return !!row;
}

async function hasProtection(playerId: number): Promise<boolean> {
  const insurance = await prisma.prostitutionProtectionInsurance.findUnique({
    where: { playerId },
  });
  if (!insurance) return false;
  return insurance.activeUntil > new Date();
}

async function isInActiveEvent(prostituteId: number): Promise<boolean> {
  const now = new Date();
  const row = await prisma.eventParticipation.findFirst({
    where: {
      prostituteId,
      status: 'active',
      event: {
        startTime: { lte: now },
        endTime: { gte: now },
      },
    },
    select: { id: true },
  });
  return !!row;
}

async function countryHasActiveEvent(countryCode: string): Promise<boolean> {
  const now = new Date();
  const row = await prisma.vipEvent.findFirst({
    where: {
      countryCode,
      startTime: { lte: now },
      endTime: { gte: now },
    },
    select: { id: true },
  });
  return !!row;
}

function stealChance(params: {
  security: number;
  occupancy: number;
  workerLevel: number;
  guarded: boolean;
  onEvent: boolean;
  resting: boolean;
  working: boolean;
  rivalry: boolean;
  protection: boolean;
}): number {
  if (params.guarded) return 0.02;
  let chance = 0.38;
  chance -= params.security * 0.06;
  chance -= Math.max(0, params.workerLevel - 1) * 0.015;
  if (params.occupancy >= RLD_OCCUPANCY_BUSY) chance += 0.12;
  if (params.onEvent) chance += 0.15;
  if (params.resting) chance -= 0.15;
  if (params.working && !params.onEvent) chance += 0.04;
  if (params.rivalry) chance += 0.08;
  if (params.protection) chance -= 0.15;
  return Math.max(0.05, Math.min(0.75, chance));
}

async function bustWorker(prostituteId: number): Promise<void> {
  await prisma.prostitute.update({
    where: { id: prostituteId },
    data: {
      isBusted: true,
      bustedUntil: hoursFromNow(RLD_BUST_HOURS),
    },
  });
}

async function addContestStealPoints(districtId: number, status: string | null | undefined) {
  if (status !== 'active') return;
  await prisma.redLightDistrict.update({
    where: { id: districtId },
    data: { contestAttackerScore: { increment: RLD_CONTEST_STEAL_POINTS } },
  });
}

export const rldPvpService = {
  async guardRoom(playerId: number, roomId: number): Promise<ActionResult> {
    const now = new Date();
    const room = await prisma.redLightRoom.findUnique({
      where: { id: roomId },
      include: {
        redLightDistrict: true,
        prostitute: { select: { id: true, playerId: true, name: true } },
      },
    });
    if (!room) return { success: false, message: 'Kamer niet gevonden' };
    if (room.redLightDistrict.ownerId !== playerId) {
      return { success: false, message: 'Alleen de eigenaar kan een ster bewaken' };
    }
    if (!room.occupied || !room.prostitute) {
      return { success: false, message: 'Deze kamer is leeg' };
    }
    if (room.prostitute.playerId !== playerId) {
      return { success: false, message: 'Je kunt alleen je eigen recruit bewaken' };
    }
    if (room.guardUntil && room.guardUntil > now) {
      return { success: false, message: 'Deze kamer wordt al bewaakt' };
    }
    if (room.guardCooldownUntil && room.guardCooldownUntil > now) {
      return { success: false, message: 'Bewaken is nog in cooldown' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, isVip: true, vipExpiresAt: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };
    if (player.money < RLD_GUARD_COST) {
      return {
        success: false,
        message: `Je hebt €${RLD_GUARD_COST.toLocaleString('nl-NL')} nodig om te bewaken`,
      };
    }

    const hours = isVipStatusActive(player) ? RLD_GUARD_HOURS_VIP : RLD_GUARD_HOURS;
    const guardUntil = hoursFromNow(hours);
    const cooldownUntil = new Date(guardUntil.getTime() + RLD_GUARD_COOLDOWN_HOURS * 60 * 60 * 1000);

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: RLD_GUARD_COST } },
      }),
      prisma.redLightRoom.update({
        where: { id: roomId },
        data: { guardUntil, guardCooldownUntil: cooldownUntil },
      }),
    ]);

    return {
      success: true,
      message: `${room.prostitute.name} wordt ${hours} uur bewaakt. Deze kamer verdient de helft.`,
      guardUntil: guardUntil.toISOString(),
    };
  },

  async stealFromRoom(playerId: number, roomId: number): Promise<ActionResult> {
    const jail = await checkIfJailed(playerId);
    if (jail > 0) {
      return { success: false, message: 'Je zit in de cel' };
    }

    const now = new Date();
    const room = await prisma.redLightRoom.findUnique({
      where: { id: roomId },
      include: {
        redLightDistrict: { include: { rooms: { select: { occupied: true } } } },
        prostitute: true,
      },
    });
    if (!room?.prostitute) {
      return { success: false, message: 'Deze kamer is leeg' };
    }
    const worker = room.prostitute;
    if (worker.playerId === playerId) {
      return { success: false, message: 'Je kunt je eigen recruit niet stelen' };
    }

    const attacker = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        money: true,
        currentCountry: true,
        username: true,
      },
    });
    if (!attacker) return { success: false, message: 'Speler niet gevonden' };
    if (attacker.currentCountry !== room.redLightDistrict.countryCode) {
      return { success: false, message: 'Je moet in hetzelfde land zijn om te stelen' };
    }
    if (attacker.money < RLD_STEAL_COST) {
      return {
        success: false,
        message: `Stelen kost €${RLD_STEAL_COST.toLocaleString('nl-NL')}`,
      };
    }

    const cooldown = await prisma.rldStealCooldown.findUnique({
      where: { attackerId_districtId: { attackerId: playerId, districtId: room.redLightDistrictId } },
    });
    if (cooldown && cooldown.until > now) {
      const mins = Math.ceil((cooldown.until.getTime() - now.getTime()) / 60000);
      return { success: false, message: `Je kunt hier over ${mins} minuten weer stelen` };
    }

    const housing = await prostituteService.getHousingCapacity(playerId);
    if (housing.freeSlots <= 0) {
      return {
        success: false,
        message: 'Geen vrije woonplek. Koop of upgrade eerst een huis of appartement.',
      };
    }

    const occupied = room.redLightDistrict.rooms.filter((r) => r.occupied).length;
    const total = rldOccupancyCapacity(
      room.redLightDistrict.rooms.length || room.redLightDistrict.roomCount || 0
    );
    const onEvent = await isInActiveEvent(worker.id);
    const rivalry = await hasRivalry(playerId, worker.playerId);
    const protection = await hasProtection(worker.playerId);
    const guarded = !!(room.guardUntil && room.guardUntil > now);
    const chance = stealChance({
      security: room.redLightDistrict.securityLevel || 0,
      occupancy: occupancyRate(occupied, total),
      workerLevel: worker.level || 1,
      guarded,
      onEvent,
      resting: isWorkerResting(worker.lastWorkedAt, now),
      working: isWorkerOnShift(worker.lastWorkedAt, now),
      rivalry,
      protection,
    });

    await prisma.player.update({
      where: { id: playerId },
      data: { money: { decrement: RLD_STEAL_COST } },
    });
    await increaseFBIHeat(playerId, RLD_STEAL_HEAT);
    await increaseWantedLevel(playerId, RLD_STEAL_WANTED);
    await prisma.rldStealCooldown.upsert({
      where: { attackerId_districtId: { attackerId: playerId, districtId: room.redLightDistrictId } },
      create: {
        attackerId: playerId,
        districtId: room.redLightDistrictId,
        until: hoursFromNow(RLD_STEAL_COOLDOWN_HOURS),
      },
      update: { until: hoursFromNow(RLD_STEAL_COOLDOWN_HOURS) },
    });

    if (Math.random() >= chance) {
      const bustChance = onEvent ? RLD_EVENT_FAIL_BUST_CHANCE : RLD_FAIL_BUST_CHANCE;
      if (Math.random() < bustChance) {
        await jailPlayer(playerId, RLD_BUST_HOURS * 60, 'Police', {
          reason: 'red_light',
        });
      }
      if (Math.random() < RLD_FAIL_WORKER_BUST_CHANCE) {
        await bustWorker(worker.id);
      }
      return {
        success: false,
        message: onEvent
          ? 'De diefstal mislukte in de drukte. Extra politie-aandacht.'
          : 'De diefstal mislukte. Beveiliging of pech.',
        chance: Math.round(chance * 100),
      };
    }

    const stillHot = !!(worker.hotUntil && worker.hotUntil > now && worker.stolenFromPlayerId);
    const stolenFromId = stillHot ? worker.stolenFromPlayerId : worker.playerId;
    const hotUntil = stillHot && worker.hotUntil ? worker.hotUntil : hoursFromNow(RLD_HOT_HOURS);
    const victimId = worker.playerId;
    const workerName = worker.name;

    await prisma.$transaction([
      prisma.redLightRoom.update({
        where: { id: room.id },
        data: { occupied: false, guardUntil: null },
      }),
      prisma.prostitute.update({
        where: { id: worker.id },
        data: {
          playerId,
          location: 'street',
          country: room.redLightDistrict.countryCode,
          redLightRoomId: null,
          nightclubVenueId: null,
          nightclubAssignedAt: null,
          lastEarningsAt: now,
          stolenFromPlayerId: stolenFromId,
          hotUntil,
        },
      }),
    ]);

    await addContestStealPoints(room.redLightDistrictId, room.redLightDistrict.contestStatus);

    const thiefName = attacker.username;
    void rldNotify.stolen(victimId, thiefName, workerName);

    return {
      success: true,
      message: `${workerName} is van jou. Ze staat 12 uur op straat; de oude baas kan haar terughalen.`,
      hotUntil: hotUntil.toISOString(),
    };
  },

  async reclaimWorker(playerId: number, prostituteId: number): Promise<ActionResult> {
    const now = new Date();
    const worker = await prisma.prostitute.findUnique({
      where: { id: prostituteId },
    });
    if (!worker) return { success: false, message: 'Recruit niet gevonden' };
    if (worker.stolenFromPlayerId !== playerId) {
      return { success: false, message: 'Alleen de oude baas kan haar terughalen' };
    }
    if (!worker.hotUntil || worker.hotUntil <= now) {
      return { success: false, message: 'Het terughaal-venster is voorbij' };
    }
    if (worker.playerId === playerId) {
      return { success: false, message: 'Ze is al van jou' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, currentCountry: true, username: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };
    if (player.money < RLD_RECLAIM_COST) {
      return {
        success: false,
        message: `Terughalen kost €${RLD_RECLAIM_COST.toLocaleString('nl-NL')}`,
      };
    }

    const housing = await prostituteService.getHousingCapacity(playerId);
    if (housing.freeSlots <= 0) {
      return {
        success: false,
        message: 'Geen vrije woonplek om haar terug te nemen.',
      };
    }

    const thiefId = worker.playerId;
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: RLD_RECLAIM_COST } },
      }),
      prisma.prostitute.update({
        where: { id: worker.id },
        data: {
          playerId,
          location: 'street',
          country: player.currentCountry,
          redLightRoomId: null,
          nightclubVenueId: null,
          nightclubAssignedAt: null,
          stolenFromPlayerId: null,
          hotUntil: null,
          lastEarningsAt: now,
        },
      }),
    ]);
    await increaseFBIHeat(playerId, RLD_RECLAIM_HEAT);

    void rldNotify.reclaimed(thiefId, player.username, worker.name);

    return {
      success: true,
      message: `${worker.name} is terug. Ze staat op straat.`,
    };
  },

  async startContest(playerId: number, districtId: number): Promise<ActionResult> {
    const jail = await checkIfJailed(playerId);
    if (jail > 0) return { success: false, message: 'Je zit in de cel' };

    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: { owner: { select: { id: true, username: true, isVip: true, vipExpiresAt: true } } },
    });
    if (!district) return { success: false, message: 'District niet gevonden' };
    if (!district.ownerId || !district.owner) {
      return { success: false, message: 'Dit district heeft geen eigenaar' };
    }
    if (district.ownerId === playerId) {
      return { success: false, message: 'Je bent al de eigenaar' };
    }

    const now = new Date();
    if (district.contestStatus && district.contestStatus !== 'idle') {
      return { success: false, message: 'Er loopt al een contest om dit district' };
    }
    if (district.contestCooldownUntil && district.contestCooldownUntil > now) {
      return { success: false, message: 'Dit district is nog beschermd na de vorige contest' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, rank: true, currentCountry: true, username: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };
    if (player.currentCountry !== district.countryCode) {
      return { success: false, message: 'Je moet in hetzelfde land zijn' };
    }
    if (player.rank < RLD_CONTEST_MIN_RANK) {
      return { success: false, message: `Je hebt rang ${RLD_CONTEST_MIN_RANK} nodig om een district te betwisten` };
    }
    if (player.money < RLD_CONTEST_STAKE) {
      return {
        success: false,
        message: `De inzet is €${RLD_CONTEST_STAKE.toLocaleString('nl-NL')}`,
      };
    }

    const prepAt = now;
    const activeAt = new Date(now.getTime() + RLD_CONTEST_PREP_MS);
    const lockdownAt = new Date(activeAt.getTime() + RLD_CONTEST_ACTIVE_MS);
    const resolveAt = new Date(lockdownAt.getTime() + RLD_CONTEST_LOCKDOWN_MS);
    const vipBonus = isVipStatusActive(district.owner) ? RLD_CONTEST_VIP_DEFENSE_POINTS : 0;
    const defenderStart =
      (district.securityLevel || 0) * RLD_CONTEST_SECURITY_POINTS + vipBonus;

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: RLD_CONTEST_STAKE } },
      }),
      prisma.redLightDistrict.update({
        where: { id: districtId },
        data: {
          contestStatus: 'preparing',
          contestChallengerId: playerId,
          contestAttackerScore: 0,
          contestDefenderScore: defenderStart,
          contestHoldCount: 0,
          contestStake: RLD_CONTEST_STAKE,
          contestPrepAt: prepAt,
          contestActiveAt: activeAt,
          contestLockdownAt: lockdownAt,
          contestResolveAt: resolveAt,
        },
      }),
    ]);

    void rldNotify.contestPrep(district.ownerId, player.username, district.countryCode);

    return {
      success: true,
      message: 'Contest gestart. De eigenaar heeft even tijd om zich voor te bereiden.',
      contest: {
        status: 'preparing',
        activeAt: activeAt.toISOString(),
        resolveAt: resolveAt.toISOString(),
      },
    };
  },

  async holdContest(playerId: number, districtId: number): Promise<ActionResult> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
    });
    if (!district) return { success: false, message: 'District niet gevonden' };
    if (district.ownerId !== playerId) {
      return { success: false, message: 'Alleen de eigenaar kan houden' };
    }
    if (district.contestStatus !== 'active') {
      return { success: false, message: 'Houden kan alleen tijdens het gevecht' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, isVip: true, vipExpiresAt: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };
    const maxHolds = isVipStatusActive(player) ? RLD_CONTEST_HOLD_MAX_VIP : RLD_CONTEST_HOLD_MAX;
    if ((district.contestHoldCount || 0) >= maxHolds) {
      return { success: false, message: 'Je hebt al het maximum aantal keren gehouden' };
    }
    if (player.money < RLD_CONTEST_HOLD_COST) {
      return {
        success: false,
        message: `Houden kost €${RLD_CONTEST_HOLD_COST.toLocaleString('nl-NL')}`,
      };
    }

    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: RLD_CONTEST_HOLD_COST } },
      }),
      prisma.redLightDistrict.update({
        where: { id: districtId },
        data: {
          contestHoldCount: { increment: 1 },
          contestDefenderScore: { increment: RLD_CONTEST_HOLD_POINTS },
        },
      }),
    ]);
    await increaseFBIHeat(playerId, RLD_CONTEST_HOLD_HEAT);

    return {
      success: true,
      message: 'Je houdt het district. Extra punten, extra politie-aandacht.',
    };
  },

  async sabotageRoom(playerId: number, roomId: number): Promise<ActionResult> {
    const now = new Date();
    const room = await prisma.redLightRoom.findUnique({
      where: { id: roomId },
      include: { redLightDistrict: true },
    });
    if (!room) return { success: false, message: 'Kamer niet gevonden' };
    const district = room.redLightDistrict;
    if (district.contestStatus !== 'active' || district.contestChallengerId !== playerId) {
      return { success: false, message: 'Sabotage kan alleen de uitdager tijdens het gevecht' };
    }
    if (room.sabotagedUntil && room.sabotagedUntil > now) {
      return { success: false, message: 'Deze kamer is al gesloten' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, currentCountry: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };
    if (player.currentCountry !== district.countryCode) {
      return { success: false, message: 'Je moet in hetzelfde land zijn' };
    }
    if (player.money < RLD_CONTEST_SABOTAGE_COST) {
      return {
        success: false,
        message: `Sabotage kost €${RLD_CONTEST_SABOTAGE_COST.toLocaleString('nl-NL')}`,
      };
    }

    const until = district.contestResolveAt ?? hoursFromNow(1);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: RLD_CONTEST_SABOTAGE_COST } },
      }),
      prisma.redLightRoom.update({
        where: { id: roomId },
        data: { sabotagedUntil: until },
      }),
      prisma.redLightDistrict.update({
        where: { id: district.id },
        data: { contestAttackerScore: { increment: RLD_CONTEST_SABOTAGE_POINTS } },
      }),
    ]);

    return {
      success: true,
      message: `Kamer ${room.roomNumber} is gesloten tot het einde van de contest.`,
    };
  },

  async processContests(): Promise<{ advanced: number; resolved: number }> {
    const now = new Date();
    const live = await prisma.redLightDistrict.findMany({
      where: { contestStatus: { in: ['preparing', 'active', 'lockdown'] } },
      include: {
        owner: { select: { id: true, username: true } },
        contestChallenger: { select: { id: true, username: true } },
      },
    });
    let advanced = 0;
    let resolved = 0;

    for (const district of live) {
      if (district.contestStatus === 'preparing' && district.contestActiveAt && district.contestActiveAt <= now) {
        await prisma.redLightDistrict.update({
          where: { id: district.id },
          data: { contestStatus: 'active' },
        });
        if (district.ownerId) {
          void rldNotify.contestActive(district.ownerId, district.countryCode);
        }
        if (district.contestChallengerId) {
          void rldNotify.contestActive(district.contestChallengerId, district.countryCode);
        }
        advanced += 1;
        continue;
      }

      if (district.contestStatus === 'active' && district.contestLockdownAt && district.contestLockdownAt <= now) {
        await prisma.redLightDistrict.update({
          where: { id: district.id },
          data: { contestStatus: 'lockdown' },
        });
        advanced += 1;
        continue;
      }

      if (
        (district.contestStatus === 'lockdown' || district.contestStatus === 'active') &&
        district.contestResolveAt &&
        district.contestResolveAt <= now
      ) {
        await this.resolveContest(district.id);
        resolved += 1;
      }
    }

    return { advanced, resolved };
  },

  async resolveContest(districtId: number): Promise<void> {
    const district = await prisma.redLightDistrict.findUnique({
      where: { id: districtId },
      include: {
        owner: { select: { id: true, username: true } },
        contestChallenger: { select: { id: true, username: true } },
      },
    });
    if (!district || district.contestStatus === 'idle') return;

    const attackerScore = district.contestAttackerScore ?? 0;
    const defenderScore = district.contestDefenderScore ?? 0;
    const challengerId = district.contestChallengerId;
    const ownerId = district.ownerId;
    const attackerWins = !!challengerId && attackerScore > defenderScore;
    const cooldownUntil = new Date(Date.now() + RLD_CONTEST_COOLDOWN_MS);

    await prisma.redLightDistrict.update({
      where: { id: districtId },
      data: {
        ownerId: attackerWins ? challengerId : ownerId,
        contestStatus: 'idle',
        contestChallengerId: null,
        contestAttackerScore: 0,
        contestDefenderScore: 0,
        contestHoldCount: 0,
        contestStake: 0,
        contestPrepAt: null,
        contestActiveAt: null,
        contestLockdownAt: null,
        contestResolveAt: null,
        contestCooldownUntil: cooldownUntil,
      },
    });

    await prisma.redLightRoom.updateMany({
      where: { redLightDistrictId: districtId },
      data: { sabotagedUntil: null },
    });

    if (attackerWins && challengerId) {
      await prisma.player.update({
        where: { id: challengerId },
        data: { money: { increment: district.contestStake || 0 } },
      });
      void rldNotify.contestWon(challengerId, district.countryCode);
      if (ownerId) {
        const winnerName = district.contestChallenger?.username || '???';
        void rldNotify.contestLost(ownerId, winnerName, district.countryCode);
      }
    } else if (challengerId) {
      if (ownerId) {
        await prisma.player.update({
          where: { id: ownerId },
          data: { money: { increment: district.contestStake || 0 } },
        });
        void rldNotify.contestWon(ownerId, district.countryCode);
      }
      const winnerName = district.owner?.username || '???';
      void rldNotify.contestLost(challengerId, winnerName, district.countryCode);
    }
  },

  serializeContest,
};

export async function countryEventActive(countryCode: string): Promise<boolean> {
  return countryHasActiveEvent(countryCode);
}
