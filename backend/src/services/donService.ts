import prisma from '../lib/prisma';
import donBusinessesData from '../../content/donBusinesses.json';
import donOfficialsData from '../../content/donOfficials.json';
import donContractsData from '../../content/donContracts.json';
import countriesData from '../../content/countries.json';
import { getDonRuntimeConfig } from './donRuntimeConfig';
import { worldEventService } from './worldEventService';
import { weaponSelectionService } from './weaponSelectionService';
import { weaponService } from './weaponService';
import * as policeService from './policeService';
import { educationService } from './educationService';
import { getCrewStorageCapacity } from './crewBuildingService';

type DonBusinessDef = { key: string; baseTribute: number; minIntimidation: number };
type DonOfficeDef = { key: string; baseCost: number };
type DonNpcDef = { key: string; interestBps: number };
type DonContractDef = {
  key: string;
  payout: number;
  durationHours: number;
  requiresAlderman: boolean;
  minEngineering: number;
};

const BUSINESSES = (donBusinessesData as { businesses: DonBusinessDef[] }).businesses;
const OFFICES = (donOfficialsData as { offices: DonOfficeDef[] }).offices;
const NPCS = (donContractsData as { npcs: DonNpcDef[] }).npcs;
const CONTRACTS = (donContractsData as { contracts: DonContractDef[] }).contracts;
const COUNTRY_IDS = (countriesData as Array<{ id: string }>).map((entry) => entry.id);

const CREW_BANK_ROLES = new Set(['leader', 'co_leader', 'capo']);

function dueAmount(principal: number, interestBps: number): number {
  return Math.round(principal * (1 + interestBps / 10000));
}

async function requireEnabled(playerId: number) {
  const cfg = await getDonRuntimeConfig();
  if (!cfg.enabled) {
    throw new Error('DON_DISABLED');
  }
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      id: true,
      money: true,
      rank: true,
      currentCountry: true,
      jailRelease: true,
      wantedLevel: true,
    },
  });
  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }
  if (player.jailRelease && player.jailRelease.getTime() > Date.now()) {
    throw new Error('PLAYER_JAILED');
  }
  if (player.rank < cfg.minRank) {
    throw new Error(`DON_RANK_TOO_LOW:${cfg.minRank}`);
  }
  return { cfg, player };
}

async function bestIntimidation(playerId: number): Promise<number> {
  const equipped = await weaponSelectionService.getEquippedWeapons(playerId);
  let best = 0;
  for (const weapon of equipped) {
    const def = weaponService.getWeaponDefinition(weapon.weaponId);
    best = Math.max(best, def?.intimidation ?? 0);
  }
  return best;
}

async function requireIntimidation(playerId: number, needed: number): Promise<number> {
  const have = await bestIntimidation(playerId);
  if (have < needed) {
    throw new Error(`DON_INTIMIDATION_TOO_LOW:${needed}:${have}`);
  }
  return have;
}

async function membership(playerId: number) {
  return prisma.crewMember.findUnique({
    where: { playerId },
    select: { crewId: true, role: true, capoCountry: true },
  });
}

function canSendTributeToCrew(
  member: { role: string; capoCountry: string | null } | null,
  countryCode: string
): boolean {
  if (!member || !CREW_BANK_ROLES.has(member.role)) {
    return false;
  }
  if (member.role === 'capo') {
    return member.capoCountry === countryCode;
  }
  return true;
}

async function debitCrewBank(crewId: number, amount: number): Promise<boolean> {
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew || crew.bankBalance < amount) {
    return false;
  }
  await prisma.crew.update({
    where: { id: crewId },
    data: { bankBalance: { decrement: amount } },
  });
  return true;
}

async function creditCrewBank(crewId: number, amount: number): Promise<boolean> {
  const cashCapacity = await getCrewStorageCapacity(crewId, 'cash_storage');
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew) {
    return false;
  }
  const cap = cashCapacity > 0 ? cashCapacity : crew.bankBalance + amount;
  if (crew.bankBalance + amount > cap) {
    return false;
  }
  await prisma.crew.update({
    where: { id: crewId },
    data: { bankBalance: { increment: amount } },
  });
  return true;
}

async function creditTribute(opts: {
  ownerId: number;
  amount: number;
  tributeToCrew: boolean;
  countryCode: string;
}): Promise<{ paidTo: 'crew' | 'cash'; newMoney: number }> {
  const member = await membership(opts.ownerId);
  if (opts.tributeToCrew && member && canSendTributeToCrew(member, opts.countryCode)) {
    const ok = await creditCrewBank(member.crewId, opts.amount);
    if (ok) {
      const player = await prisma.player.findUnique({
        where: { id: opts.ownerId },
        select: { money: true },
      });
      return { paidTo: 'crew', newMoney: player?.money ?? 0 };
    }
  }
  const updated = await prisma.player.update({
    where: { id: opts.ownerId },
    data: { money: { increment: opts.amount } },
    select: { money: true },
  });
  return { paidTo: 'cash', newMoney: updated.money };
}

function businessDef(key: string): DonBusinessDef {
  const found = BUSINESSES.find((entry) => entry.key === key);
  if (!found) {
    throw new Error('DON_BUSINESS_NOT_FOUND');
  }
  return found;
}

async function ensureCountryRackets(countryCode: string): Promise<void> {
  const existing = await prisma.donRacket.findMany({
    where: { countryCode },
    select: { businessKey: true },
  });
  const have = new Set(existing.map((row) => row.businessKey));
  for (const business of BUSINESSES) {
    if (have.has(business.key)) continue;
    await prisma.donRacket.create({
      data: {
        businessKey: business.key,
        countryCode,
      },
    });
  }
}

async function ensureCountryOfficials(countryCode: string): Promise<void> {
  for (const office of OFFICES) {
    await prisma.donOfficial.upsert({
      where: { countryCode_office: { countryCode, office: office.key } },
      update: {},
      create: { countryCode, office: office.key },
    });
  }
}

async function ensureCountryContracts(countryCode: string): Promise<void> {
  const openOrActive = await prisma.donContract.count({
    where: { countryCode, status: { in: ['open', 'active'] } },
  });
  if (openOrActive >= 2) return;

  const existingKeys = new Set(
    (
      await prisma.donContract.findMany({
        where: { countryCode, status: { in: ['open', 'active'] } },
        select: { contractKey: true },
      })
    ).map((row) => row.contractKey)
  );

  for (const contract of CONTRACTS) {
    if (existingKeys.has(contract.key)) continue;
    await prisma.donContract.create({
      data: {
        countryCode,
        contractKey: contract.key,
        status: 'open',
        payout: contract.payout,
      },
    });
    existingKeys.add(contract.key);
    if (existingKeys.size >= 2) break;
  }
}

function tributeFor(def: DonBusinessDef, squeezeUntil: Date | null, now: Date, squeezePercent: number): number {
  if (squeezeUntil && squeezeUntil.getTime() > now.getTime()) {
    return Math.round(def.baseTribute * (squeezePercent / 100));
  }
  return def.baseTribute;
}

async function abandonStaleRackets(now: Date, abandonMs: number): Promise<number> {
  const cutoff = new Date(now.getTime() - abandonMs);
  const stale = await prisma.donRacket.findMany({
    where: {
      ownerPlayerId: { not: null },
      OR: [{ lastCollectAt: { lt: cutoff } }, { lastCollectAt: null, claimedAt: { lt: cutoff } }],
    },
  });
  let count = 0;
  for (const racket of stale) {
    const anchor = racket.lastCollectAt ?? racket.claimedAt;
    if (!anchor || anchor.getTime() >= cutoff.getTime()) continue;
    await prisma.donRacket.update({
      where: { id: racket.id },
      data: {
        ownerPlayerId: null,
        squeezeUntil: null,
        tributeToCrew: false,
        contestUntil: null,
        contestPlayerId: null,
        claimedAt: null,
        lastCollectAt: null,
      },
    });
    count += 1;
  }
  return count;
}

async function resolveExpiredContests(now: Date): Promise<number> {
  const expired = await prisma.donRacket.findMany({
    where: { contestUntil: { lte: now }, contestPlayerId: { not: null } },
  });
  let count = 0;
  for (const racket of expired) {
    await prisma.donRacket.update({
      where: { id: racket.id },
      data: {
        ownerPlayerId: racket.contestPlayerId,
        contestPlayerId: null,
        contestUntil: null,
        claimedAt: now,
        lastCollectAt: now,
        squeezeUntil: null,
        tributeToCrew: false,
      },
    });
    if (racket.contestPlayerId) {
      void worldEventService.createEvent(
        'don.racket_seized',
        { racketId: racket.id, countryCode: racket.countryCode, businessKey: racket.businessKey },
        racket.contestPlayerId
      );
    }
    count += 1;
  }
  return count;
}

export const donService = {
  async getOverview(playerId: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const countryCode = player.currentCountry;
    await Promise.all([
      ensureCountryRackets(countryCode),
      ensureCountryOfficials(countryCode),
      ensureCountryContracts(countryCode),
      this.processTick(),
    ]);

    const now = new Date();
    const member = await membership(playerId);
    const intimidation = await bestIntimidation(playerId);
    const engineering =
      (await educationService.getPlayerEducationProfile(playerId)).tracks.engineering?.level ?? 0;

    const rackets = await prisma.donRacket.findMany({
      where: { countryCode },
      include: {
        owner: { select: { id: true, username: true } },
        contestPlayer: { select: { id: true, username: true } },
      },
    });

    const officials = await prisma.donOfficial.findMany({
      where: { countryCode },
      include: { patron: { select: { id: true, username: true } } },
    });

    const loans = await prisma.donLoan.findMany({
      where: {
        OR: [{ lenderId: playerId }, { borrowerPlayerId: playerId }],
        status: { in: ['offered', 'active', 'defaulted'] },
      },
      include: {
        lender: { select: { id: true, username: true } },
        borrower: { select: { id: true, username: true } },
      },
      orderBy: { dueAt: 'asc' },
    });

    const contracts = await prisma.donContract.findMany({
      where: { countryCode, status: { in: ['open', 'active'] } },
      include: { bidder: { select: { id: true, username: true } } },
    });

    const ownedCount = await prisma.donRacket.count({ where: { ownerPlayerId: playerId } });
    const alderman = officials.find(
      (row) => row.office === 'alderman' && row.patronPlayerId === playerId && row.paidUntil && row.paidUntil > now
    );

    const showCrewOverview =
      !!member && ['leader', 'co_leader', 'consigliere'].includes(member.role);
    const crewRackets = showCrewOverview
      ? await prisma.donRacket.findMany({
          where: {
            ownerPlayerId: { not: null },
            owner: { crewMembership: { crewId: member.crewId } },
          },
          include: { owner: { select: { id: true, username: true } } },
        })
      : [];

    return {
      enabled: cfg.enabled,
      minRank: cfg.minRank,
      countryCode,
      money: player.money,
      wantedLevel: player.wantedLevel,
      intimidation,
      engineeringLevel: engineering,
      ownedRacketCount: ownedCount,
      maxRackets: cfg.maxRacketsPerPlayer,
      canTributeToCrew: canSendTributeToCrew(member, countryCode),
      crewRole: member?.role ?? null,
      capoCountry: member?.capoCountry ?? null,
      collectCooldownSeconds: cfg.collectCooldownSeconds,
      loanMinPrincipal: cfg.loanMinPrincipal,
      loanMaxPrincipal: cfg.loanMaxPrincipal,
      loanMaxActive: cfg.loanMaxActive,
      officialHours: cfg.officialHours,
      businesses: BUSINESSES,
      npcs: NPCS,
      offices: OFFICES,
      contractCatalog: CONTRACTS,
      crewRackets: crewRackets.map((row) => ({
        id: row.id,
        businessKey: row.businessKey,
        countryCode: row.countryCode,
        ownerPlayerId: row.ownerPlayerId,
        ownerUsername: row.owner?.username ?? null,
        tributeToCrew: row.tributeToCrew,
      })),
      rackets: rackets.map((row) => {
        const def = businessDef(row.businessKey);
        const squeezed = !!(row.squeezeUntil && row.squeezeUntil > now);
        return {
          id: row.id,
          businessKey: row.businessKey,
          countryCode: row.countryCode,
          baseTribute: def.baseTribute,
          nextTribute: tributeFor(def, row.squeezeUntil, now, cfg.squeezeTributePercent),
          minIntimidation: def.minIntimidation,
          ownerPlayerId: row.ownerPlayerId,
          ownerUsername: row.owner?.username ?? null,
          squeezeUntil: row.squeezeUntil?.toISOString() ?? null,
          squeezed,
          lastCollectAt: row.lastCollectAt?.toISOString() ?? null,
          tributeToCrew: row.tributeToCrew,
          contestUntil: row.contestUntil?.toISOString() ?? null,
          contestPlayerId: row.contestPlayerId,
          contestUsername: row.contestPlayer?.username ?? null,
          claimedAt: row.claimedAt?.toISOString() ?? null,
          isMine: row.ownerPlayerId === playerId,
        };
      }),
      officials: officials.map((row) => {
        const def = OFFICES.find((office) => office.key === row.office);
        const active = !!(row.paidUntil && row.paidUntil > now);
        return {
          office: row.office,
          baseCost: def?.baseCost ?? 12000,
          nextBid: Math.max(def?.baseCost ?? 12000, Math.round((row.bidAmount || 0) * 1.15) || def?.baseCost || 12000),
          patronPlayerId: active ? row.patronPlayerId : null,
          patronUsername: active ? row.patron?.username ?? null : null,
          paidUntil: active ? row.paidUntil?.toISOString() ?? null : null,
          isMine: active && row.patronPlayerId === playerId,
        };
      }),
      loans: loans.map((row) => ({
        id: row.id,
        lenderId: row.lenderId,
        lenderUsername: row.lender.username,
        borrowerPlayerId: row.borrowerPlayerId,
        borrowerUsername: row.borrower?.username ?? null,
        npcKey: row.npcKey,
        principal: row.principal,
        interestBps: row.interestBps,
        dueAmount: dueAmount(row.principal, row.interestBps),
        dueAt: row.dueAt.toISOString(),
        status: row.status,
        isLender: row.lenderId === playerId,
      })),
      contracts: contracts.map((row) => {
        const def = CONTRACTS.find((entry) => entry.key === row.contractKey);
        return {
          id: row.id,
          contractKey: row.contractKey,
          payout: row.payout,
          status: row.status,
          greedy: row.greedy,
          requiresAlderman: def?.requiresAlderman ?? false,
          minEngineering: def?.minEngineering ?? 0,
          durationHours: def?.durationHours ?? 6,
          bidderPlayerId: row.bidderPlayerId,
          bidderUsername: row.bidder?.username ?? null,
          endsAt: row.endsAt?.toISOString() ?? null,
          hasAlderman: !!alderman,
          bidCost: Math.round((def?.payout ?? row.payout) * 0.2),
        };
      }),
    };
  },

  async claimRacket(playerId: number, racketId: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.countryCode !== player.currentCountry) throw new Error('WRONG_COUNTRY');
    if (racket.ownerPlayerId && racket.ownerPlayerId !== playerId) throw new Error('DON_RACKET_OWNED');
    const owned = await prisma.donRacket.count({ where: { ownerPlayerId: playerId } });
    if (owned >= cfg.maxRacketsPerPlayer) throw new Error('DON_RACKET_CAP');
    const def = businessDef(racket.businessKey);
    await requireIntimidation(playerId, def.minIntimidation);
    const now = new Date();
    const updated = await prisma.donRacket.update({
      where: { id: racketId },
      data: {
        ownerPlayerId: playerId,
        claimedAt: now,
        lastCollectAt: now,
        contestPlayerId: null,
        contestUntil: null,
        squeezeUntil: null,
      },
    });
    void worldEventService.createEvent(
      'don.racket_claimed',
      { racketId, countryCode: racket.countryCode, businessKey: racket.businessKey },
      playerId
    );
    return { racketId: updated.id, businessKey: updated.businessKey };
  },

  async collectRacket(playerId: number, racketId: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.ownerPlayerId !== playerId) throw new Error('DON_NOT_OWNER');
    if (racket.countryCode !== player.currentCountry) throw new Error('WRONG_COUNTRY');
    const now = new Date();
    if (racket.lastCollectAt) {
      const wait = cfg.collectCooldownSeconds * 1000 - (now.getTime() - racket.lastCollectAt.getTime());
      if (wait > 0) {
        throw new Error(`DON_COLLECT_COOLDOWN:${Math.ceil(wait / 1000)}`);
      }
    }
    const def = businessDef(racket.businessKey);
    await requireIntimidation(playerId, def.minIntimidation);
    const amount = tributeFor(def, racket.squeezeUntil, now, cfg.squeezeTributePercent);
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { lastCollectAt: now },
    });
    const paid = await creditTribute({
      ownerId: playerId,
      amount,
      tributeToCrew: racket.tributeToCrew,
      countryCode: racket.countryCode,
    });
    void worldEventService.createEvent(
      'don.racket_collected',
      { racketId, amount, paidTo: paid.paidTo, businessKey: racket.businessKey },
      playerId
    );
    return { amount, paidTo: paid.paidTo, newMoney: paid.newMoney };
  },

  async squeezeRacket(playerId: number, racketId: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.ownerPlayerId !== playerId) throw new Error('DON_NOT_OWNER');
    if (racket.countryCode !== player.currentCountry) throw new Error('WRONG_COUNTRY');
    const def = businessDef(racket.businessKey);
    await requireIntimidation(playerId, def.minIntimidation);
    await policeService.increaseWantedLevel(playerId, cfg.squeezeWanted);
    const fled = Math.random() * 100 < cfg.squeezeFleePercent;
    if (fled) {
      await prisma.donRacket.update({
        where: { id: racketId },
        data: {
          ownerPlayerId: null,
          squeezeUntil: null,
          tributeToCrew: false,
          claimedAt: null,
          lastCollectAt: null,
          contestUntil: null,
          contestPlayerId: null,
        },
      });
      void worldEventService.createEvent(
        'don.racket_fled',
        { racketId, businessKey: racket.businessKey, countryCode: racket.countryCode },
        playerId
      );
      return { fled: true };
    }
    const until = new Date(Date.now() + cfg.squeezeDurationSeconds * 1000);
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { squeezeUntil: until },
    });
    return { fled: false, squeezeUntil: until.toISOString() };
  },

  async setTributeDestination(playerId: number, racketId: number, tributeToCrew: boolean) {
    const { player } = await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.ownerPlayerId !== playerId) throw new Error('DON_NOT_OWNER');
    const member = await membership(playerId);
    if (tributeToCrew && !canSendTributeToCrew(member, racket.countryCode)) {
      throw new Error('DON_NO_CREW_BANK_PERM');
    }
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { tributeToCrew },
    });
    return { tributeToCrew, country: player.currentCountry };
  },

  async contestRacket(playerId: number, racketId: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.countryCode !== player.currentCountry) throw new Error('WRONG_COUNTRY');
    if (!racket.ownerPlayerId) throw new Error('DON_RACKET_FREE');
    if (racket.ownerPlayerId === playerId) throw new Error('DON_ALREADY_OWNER');
    const def = businessDef(racket.businessKey);
    await requireIntimidation(playerId, def.minIntimidation);
    const now = new Date();
    if (racket.contestUntil && racket.contestUntil > now) {
      throw new Error('DON_CONTEST_ACTIVE');
    }
    const until = new Date(now.getTime() + cfg.contestSeconds * 1000);
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { contestPlayerId: playerId, contestUntil: until },
    });
    void worldEventService.createEvent(
      'don.racket_contested',
      { racketId, businessKey: racket.businessKey, countryCode: racket.countryCode },
      playerId
    );
    return { contestUntil: until.toISOString() };
  },

  async holdRacket(playerId: number, racketId: number) {
    await requireEnabled(playerId);
    const racket = await prisma.donRacket.findUnique({ where: { id: racketId } });
    if (!racket) throw new Error('DON_RACKET_NOT_FOUND');
    if (racket.ownerPlayerId !== playerId) throw new Error('DON_NOT_OWNER');
    if (!racket.contestPlayerId) throw new Error('DON_NO_CONTEST');
    const def = businessDef(racket.businessKey);
    await requireIntimidation(playerId, def.minIntimidation);
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { contestPlayerId: null, contestUntil: null },
    });
    return { held: true };
  },

  async placeNpcLoan(playerId: number, npcKey: string, principal: number) {
    const { cfg, player } = await requireEnabled(playerId);
    const npc = NPCS.find((entry) => entry.key === npcKey);
    if (!npc) throw new Error('DON_NPC_NOT_FOUND');
    const amount = Math.floor(principal);
    if (amount < cfg.loanMinPrincipal || amount > cfg.loanMaxPrincipal) {
      throw new Error(`DON_LOAN_AMOUNT:${cfg.loanMinPrincipal}:${cfg.loanMaxPrincipal}`);
    }
    const active = await prisma.donLoan.count({
      where: { lenderId: playerId, status: { in: ['offered', 'active'] } },
    });
    if (active >= cfg.loanMaxActive) throw new Error('DON_LOAN_CAP');
    if (player.money < amount) throw new Error('INSUFFICIENT_FUNDS');
    const dueAt = new Date(Date.now() + cfg.loanDurationSeconds * 1000);
    const [loan] = await prisma.$transaction([
      prisma.donLoan.create({
        data: {
          lenderId: playerId,
          npcKey,
          principal: amount,
          interestBps: npc.interestBps,
          dueAt,
          status: 'active',
        },
      }),
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: amount } },
      }),
    ]);
    return { loanId: loan.id, dueAt: dueAt.toISOString(), dueAmount: dueAmount(amount, npc.interestBps) };
  },

  async offerPlayerLoan(playerId: number, borrowerId: number, principal: number) {
    const { cfg, player } = await requireEnabled(playerId);
    if (borrowerId === playerId) throw new Error('DON_LOAN_SELF');
    const amount = Math.floor(principal);
    if (amount < cfg.loanMinPrincipal || amount > cfg.loanMaxPrincipal) {
      throw new Error(`DON_LOAN_AMOUNT:${cfg.loanMinPrincipal}:${cfg.loanMaxPrincipal}`);
    }
    const borrower = await prisma.player.findUnique({ where: { id: borrowerId }, select: { id: true } });
    if (!borrower) throw new Error('PLAYER_NOT_FOUND');
    const active = await prisma.donLoan.count({
      where: { lenderId: playerId, status: { in: ['offered', 'active'] } },
    });
    if (active >= cfg.loanMaxActive) throw new Error('DON_LOAN_CAP');
    if (player.money < amount) throw new Error('INSUFFICIENT_FUNDS');
    const dueAt = new Date(Date.now() + cfg.loanDurationSeconds * 1000);
    const [loan] = await prisma.$transaction([
      prisma.donLoan.create({
        data: {
          lenderId: playerId,
          borrowerPlayerId: borrowerId,
          principal: amount,
          interestBps: 3000,
          dueAt,
          status: 'offered',
        },
      }),
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: amount } },
      }),
    ]);
    return { loanId: loan.id, dueAt: dueAt.toISOString() };
  },

  async acceptLoan(playerId: number, loanId: number) {
    await requireEnabled(playerId);
    const loan = await prisma.donLoan.findUnique({ where: { id: loanId } });
    if (!loan || loan.borrowerPlayerId !== playerId || loan.status !== 'offered') {
      throw new Error('DON_LOAN_NOT_FOUND');
    }
    const updated = await prisma.$transaction(async (tx) => {
      await tx.donLoan.update({ where: { id: loanId }, data: { status: 'active' } });
      return tx.player.update({
        where: { id: playerId },
        data: { money: { increment: loan.principal } },
        select: { money: true },
      });
    });
    return { newMoney: updated.money };
  },

  async repayLoan(playerId: number, loanId: number) {
    await requireEnabled(playerId);
    const loan = await prisma.donLoan.findUnique({ where: { id: loanId } });
    if (!loan || loan.status !== 'active' || loan.borrowerPlayerId !== playerId) {
      throw new Error('DON_LOAN_NOT_FOUND');
    }
    const amount = dueAmount(loan.principal, loan.interestBps);
    const payer = await prisma.player.findUnique({ where: { id: playerId }, select: { money: true } });
    if (!payer || payer.money < amount) throw new Error('INSUFFICIENT_FUNDS');
    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: amount } },
      });
      await tx.player.update({
        where: { id: loan.lenderId },
        data: { money: { increment: amount } },
      });
      await tx.donLoan.update({ where: { id: loanId }, data: { status: 'repaid' } });
    });
    return { repaid: amount };
  },

  async collectDefaultedLoan(playerId: number, loanId: number) {
    const { cfg } = await requireEnabled(playerId);
    const loan = await prisma.donLoan.findUnique({ where: { id: loanId } });
    if (!loan || loan.lenderId !== playerId) throw new Error('DON_LOAN_NOT_FOUND');
    if (loan.status !== 'defaulted' && !(loan.status === 'active' && loan.dueAt.getTime() <= Date.now())) {
      throw new Error('DON_LOAN_NOT_DUE');
    }
    const amountDue = dueAmount(loan.principal, loan.interestBps);
    const take = Math.round(amountDue * (cfg.loanCollectPercent / 100));
    if (loan.npcKey) {
      await prisma.$transaction([
        prisma.player.update({
          where: { id: playerId },
          data: { money: { increment: take } },
        }),
        prisma.donLoan.update({ where: { id: loanId }, data: { status: 'collected' } }),
      ]);
      await policeService.increaseWantedLevel(playerId, 6);
      return { collected: take, fromNpc: true };
    }
    if (!loan.borrowerPlayerId) throw new Error('DON_LOAN_NOT_FOUND');
    const borrower = await prisma.player.findUnique({
      where: { id: loan.borrowerPlayerId },
      select: { money: true },
    });
    const seized = Math.min(borrower?.money ?? 0, take);
    await prisma.$transaction(async (tx) => {
      if (seized > 0) {
        await tx.player.update({
          where: { id: loan.borrowerPlayerId! },
          data: { money: { decrement: seized } },
        });
        await tx.player.update({
          where: { id: playerId },
          data: { money: { increment: seized } },
        });
      }
      await tx.donLoan.update({ where: { id: loanId }, data: { status: 'collected' } });
    });
    await policeService.increaseWantedLevel(loan.borrowerPlayerId, 8);
    return { collected: seized, fromNpc: false };
  },

  async bribeOfficial(playerId: number, office: string) {
    const { cfg, player } = await requireEnabled(playerId);
    const def = OFFICES.find((entry) => entry.key === office);
    if (!def) throw new Error('DON_OFFICE_NOT_FOUND');
    await ensureCountryOfficials(player.currentCountry);
    const row = await prisma.donOfficial.findUnique({
      where: { countryCode_office: { countryCode: player.currentCountry, office } },
    });
    if (!row) throw new Error('DON_OFFICE_NOT_FOUND');
    const now = new Date();
    const active = !!(row.paidUntil && row.paidUntil > now);
    const cost = Math.max(def.baseCost, Math.round((row.bidAmount || 0) * 1.15) || def.baseCost);
    if (player.money < cost) throw new Error('INSUFFICIENT_FUNDS');
    const paidUntil = new Date(now.getTime() + cfg.officialHours * 3600 * 1000);
    await prisma.$transaction([
      prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: cost } },
      }),
      prisma.donOfficial.update({
        where: { id: row.id },
        data: {
          patronPlayerId: playerId,
          paidUntil,
          bidAmount: cost,
        },
      }),
    ]);
    void worldEventService.createEvent(
      'don.official_bribed',
      { office, countryCode: player.currentCountry, cost, replaced: active && row.patronPlayerId !== playerId },
      playerId
    );
    return { office, cost, paidUntil: paidUntil.toISOString() };
  },

  async bidContract(playerId: number, contractId: number, opts: { fromCrew: boolean; greedy: boolean }) {
    const { cfg, player } = await requireEnabled(playerId);
    const contract = await prisma.donContract.findUnique({ where: { id: contractId } });
    if (!contract || contract.status !== 'open') throw new Error('DON_CONTRACT_NOT_FOUND');
    if (contract.countryCode !== player.currentCountry) throw new Error('WRONG_COUNTRY');
    const def = CONTRACTS.find((entry) => entry.key === contract.contractKey);
    if (!def) throw new Error('DON_CONTRACT_NOT_FOUND');
    const engineering =
      (await educationService.getPlayerEducationProfile(playerId)).tracks.engineering?.level ?? 0;
    if (engineering < def.minEngineering) {
      throw new Error(`DON_ENGINEERING:${def.minEngineering}`);
    }
    if (def.requiresAlderman) {
      const alderman = await prisma.donOfficial.findUnique({
        where: { countryCode_office: { countryCode: player.currentCountry, office: 'alderman' } },
      });
      const now = new Date();
      if (!alderman?.patronPlayerId || alderman.patronPlayerId !== playerId || !alderman.paidUntil || alderman.paidUntil <= now) {
        throw new Error('DON_ALDERMAN_REQUIRED');
      }
    }
    const member = await membership(playerId);
    let crewId: number | null = null;
    const bidCost = Math.round(def.payout * 0.2);
    if (opts.fromCrew) {
      if (!member || !canSendTributeToCrew(member, player.currentCountry)) {
        throw new Error('DON_NO_CREW_BANK_PERM');
      }
      crewId = member.crewId;
      const paid = await debitCrewBank(crewId, bidCost);
      if (!paid) throw new Error('INSUFFICIENT_FUNDS');
    } else {
      if (player.money < bidCost) throw new Error('INSUFFICIENT_FUNDS');
      await prisma.player.update({
        where: { id: playerId },
        data: { money: { decrement: bidCost } },
      });
    }
    if (opts.greedy) {
      await policeService.increaseWantedLevel(playerId, 3);
    }
    const now = new Date();
    const endsAt = new Date(now.getTime() + def.durationHours * 3600 * 1000);
    let payout = def.payout;
    const aldermanMine = await this.getActiveOfficial(playerId, player.currentCountry, 'alderman');
    if (aldermanMine) {
      payout = Math.round(payout * (1 + cfg.aldermanPayoutBonusPercent / 100));
    }
    if (opts.greedy) {
      payout = Math.round(payout * 1.25);
    }
    await prisma.donContract.update({
      where: { id: contractId },
      data: {
        bidderPlayerId: playerId,
        crewId,
        startsAt: now,
        endsAt,
        payout,
        status: 'active',
        greedy: opts.greedy,
      },
    });
    return { endsAt: endsAt.toISOString(), payout, bidCost };
  },

  async getActiveOfficial(playerId: number, countryCode: string, office: string) {
    const row = await prisma.donOfficial.findUnique({
      where: { countryCode_office: { countryCode, office } },
    });
    const now = new Date();
    if (!row?.patronPlayerId || row.patronPlayerId !== playerId || !row.paidUntil || row.paidUntil <= now) {
      return null;
    }
    return row;
  },

  async getJudgeAppealBonusPercent(playerId: number): Promise<number> {
    const cfg = await getDonRuntimeConfig();
    if (!cfg.enabled) return 0;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player) return 0;
    const row = await this.getActiveOfficial(playerId, player.currentCountry, 'judge');
    return row ? cfg.judgeAppealBonusPercent : 0;
  },

  async getCommissionerWantedMultiplier(playerId: number): Promise<number> {
    const cfg = await getDonRuntimeConfig();
    if (!cfg.enabled) return 1;
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player) return 1;
    const row = await this.getActiveOfficial(playerId, player.currentCountry, 'commissioner');
    return row ? cfg.commissionerWantedMult / 100 : 1;
  },

  async processTick(): Promise<{ abandoned: number; contests: number; loans: number; contracts: number }> {
    const cfg = await getDonRuntimeConfig();
    if (!cfg.enabled) {
      return { abandoned: 0, contests: 0, loans: 0, contracts: 0 };
    }
    const now = new Date();
    const abandoned = await abandonStaleRackets(now, cfg.abandonSeconds * 1000);
    const contests = await resolveExpiredContests(now);

    const dueNpc = await prisma.donLoan.findMany({
      where: { status: 'active', npcKey: { not: null }, dueAt: { lte: now } },
    });
    let loans = 0;
    for (const loan of dueNpc) {
      const defaults = Math.random() * 100 < cfg.loanNpcDefaultPercent;
      if (defaults) {
        await prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'defaulted' } });
      } else {
        const amount = dueAmount(loan.principal, loan.interestBps);
        await prisma.$transaction([
          prisma.player.update({
            where: { id: loan.lenderId },
            data: { money: { increment: amount } },
          }),
          prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'repaid' } }),
        ]);
      }
      loans += 1;
    }

    const staleOffers = await prisma.donLoan.findMany({
      where: { status: 'offered', createdAt: { lte: new Date(now.getTime() - 24 * 3600 * 1000) } },
    });
    for (const loan of staleOffers) {
      await prisma.$transaction([
        prisma.player.update({
          where: { id: loan.lenderId },
          data: { money: { increment: loan.principal } },
        }),
        prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'expired' } }),
      ]);
      loans += 1;
    }

    const dueP2p = await prisma.donLoan.findMany({
      where: { status: 'active', npcKey: null, dueAt: { lte: now } },
    });
    for (const loan of dueP2p) {
      await prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'defaulted' } });
      loans += 1;
    }

    const finished = await prisma.donContract.findMany({
      where: { status: 'active', endsAt: { lte: now } },
    });
    let contracts = 0;
    for (const row of finished) {
      if (!row.bidderPlayerId) {
        await prisma.donContract.update({ where: { id: row.id }, data: { status: 'failed' } });
        contracts += 1;
        continue;
      }
      let payout = row.payout;
      const racketCount = await prisma.donRacket.count({
        where: { ownerPlayerId: row.bidderPlayerId, countryCode: row.countryCode },
      });
      if (racketCount > 0) {
        payout += Math.round(row.payout * (cfg.contractOffbooksPercent / 100) * Math.min(3, racketCount));
      }
      if (row.greedy) {
        await policeService.increaseWantedLevel(row.bidderPlayerId, 7);
      }
      if (row.crewId) {
        const ok = await creditCrewBank(row.crewId, payout);
        if (!ok) {
          await prisma.player.update({
            where: { id: row.bidderPlayerId },
            data: { money: { increment: payout } },
          });
        }
      } else {
        await prisma.player.update({
          where: { id: row.bidderPlayerId },
          data: { money: { increment: payout } },
        });
      }
      await prisma.donContract.update({ where: { id: row.id }, data: { status: 'completed' } });
      contracts += 1;
    }

    for (const countryCode of COUNTRY_IDS.slice(0, 8)) {
      await ensureCountryContracts(countryCode);
    }

    return { abandoned, contests, loans, contracts };
  },
};
