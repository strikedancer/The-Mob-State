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
import { donBusinessLabel, donOfficeLabel, formatDonCash, notifyDon } from './donNotify';

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

function secondsUntil(target: Date | null | undefined, now: Date): number {
  if (!target) return 0;
  return Math.max(0, Math.ceil((target.getTime() - now.getTime()) / 1000));
}

function collectReadyAt(lastCollectAt: Date | null | undefined, cooldownSeconds: number): Date | null {
  if (!lastCollectAt) return null;
  return new Date(lastCollectAt.getTime() + cooldownSeconds * 1000);
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
    const previousOwnerId = racket.ownerPlayerId;
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
    if (previousOwnerId) {
      const shop = racket.businessKey;
      void notifyDon(previousOwnerId, {
        nl: `Je ${donBusinessLabel(shop, true)} in ${racket.countryCode} is vervallen. Innen op tijd, anders raak je de zaak kwijt.`,
        en: `Your ${donBusinessLabel(shop, false)} in ${racket.countryCode} was abandoned. Collect on time or you lose the shop.`,
      });
    }
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
    const previousOwnerId = racket.ownerPlayerId;
    const shop = racket.businessKey;
    if (racket.contestPlayerId) {
      void worldEventService.createEvent(
        'don.racket_seized',
        { racketId: racket.id, countryCode: racket.countryCode, businessKey: shop },
        racket.contestPlayerId
      );
      void notifyDon(racket.contestPlayerId, {
        nl: `Je hebt de ${donBusinessLabel(shop, true)} in ${racket.countryCode} overgenomen. De contest is afgelopen.`,
        en: `You took the ${donBusinessLabel(shop, false)} in ${racket.countryCode}. The contest is over.`,
      });
    }
    if (previousOwnerId && previousOwnerId !== racket.contestPlayerId) {
      void notifyDon(previousOwnerId, {
        nl: `Je ${donBusinessLabel(shop, true)} in ${racket.countryCode} is overgenomen. Je hebt de contest niet gehouden.`,
        en: `Your ${donBusinessLabel(shop, false)} in ${racket.countryCode} was taken. You did not hold the contest.`,
      });
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
        const readyAt = collectReadyAt(row.lastCollectAt, cfg.collectCooldownSeconds);
        const collectRemainingSeconds = secondsUntil(readyAt, now);
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
          squeezeRemainingSeconds: secondsUntil(row.squeezeUntil, now),
          squeezed,
          lastCollectAt: row.lastCollectAt?.toISOString() ?? null,
          collectReadyAt: readyAt?.toISOString() ?? null,
          collectRemainingSeconds,
          collectReady: collectRemainingSeconds <= 0,
          tributeToCrew: row.tributeToCrew,
          contestUntil: row.contestUntil?.toISOString() ?? null,
          contestRemainingSeconds: secondsUntil(row.contestUntil, now),
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
          paidRemainingSeconds: active ? secondsUntil(row.paidUntil, now) : 0,
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
        dueRemainingSeconds: secondsUntil(row.dueAt, now),
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
          endsRemainingSeconds: secondsUntil(row.endsAt, now),
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
    void notifyDon(
      playerId,
      {
        nl: `Je hebt de ${donBusinessLabel(updated.businessKey, true)} geclaimd.`,
        en: `You claimed the ${donBusinessLabel(updated.businessKey, false)}.`,
      },
      { push: false }
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
    void notifyDon(
      playerId,
      {
        nl: `Tribute ${formatDonCash(amount, true)} geïnd van je ${donBusinessLabel(racket.businessKey, true)} (${paid.paidTo === 'crew' ? 'crew-bank' : 'cash'}).`,
        en: `Collected ${formatDonCash(amount, false)} tribute from your ${donBusinessLabel(racket.businessKey, false)} (${paid.paidTo === 'crew' ? 'crew bank' : 'cash'}).`,
      },
      { push: false }
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
      void notifyDon(playerId, {
        nl: `De ${donBusinessLabel(racket.businessKey, true)} is gevlucht na je squeeze.`,
        en: `The ${donBusinessLabel(racket.businessKey, false)} fled after your squeeze.`,
      });
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
    const attacker = await prisma.player.findUnique({
      where: { id: playerId },
      select: { username: true },
    });
    const attackerName = attacker?.username || '???';
    void notifyDon(
      playerId,
      {
        nl: `Contest gestart op de ${donBusinessLabel(racket.businessKey, true)}. De eigenaar kan nog houden.`,
        en: `Contest started on the ${donBusinessLabel(racket.businessKey, false)}. The owner can still hold.`,
      },
      { push: false }
    );
    if (racket.ownerPlayerId) {
      void notifyDon(racket.ownerPlayerId, {
        nl: `${attackerName} betwist je ${donBusinessLabel(racket.businessKey, true)}. Houd de zaak op Don voordat de tijd om is.`,
        en: `${attackerName} is contesting your ${donBusinessLabel(racket.businessKey, false)}. Hold it on Don before time runs out.`,
      });
    }
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
    const challengerId = racket.contestPlayerId;
    await prisma.donRacket.update({
      where: { id: racketId },
      data: { contestPlayerId: null, contestUntil: null },
    });
    void notifyDon(
      playerId,
      {
        nl: `Je hebt je ${donBusinessLabel(racket.businessKey, true)} gehouden.`,
        en: `You held your ${donBusinessLabel(racket.businessKey, false)}.`,
      },
      { push: false }
    );
    if (challengerId) {
      void notifyDon(challengerId, {
        nl: `De eigenaar hield de ${donBusinessLabel(racket.businessKey, true)}. Je contest is afgewezen.`,
        en: `The owner held the ${donBusinessLabel(racket.businessKey, false)}. Your contest failed.`,
      });
    }
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
    void notifyDon(
      playerId,
      {
        nl: `Je leende ${formatDonCash(amount, true)} aan een NPC. Opeisbaar ${formatDonCash(dueAmount(amount, npc.interestBps), true)}.`,
        en: `You lent ${formatDonCash(amount, false)} to an NPC. Due ${formatDonCash(dueAmount(amount, npc.interestBps), false)}.`,
      },
      { push: false }
    );
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
    const lender = await prisma.player.findUnique({
      where: { id: playerId },
      select: { username: true },
    });
    void notifyDon(
      playerId,
      {
        nl: `Lening van ${formatDonCash(amount, true)} aangeboden.`,
        en: `Loan offer of ${formatDonCash(amount, false)} sent.`,
      },
      { push: false }
    );
    void notifyDon(borrowerId, {
      nl: `${lender?.username || 'Iemand'} biedt je een Don-lening van ${formatDonCash(amount, true)}. Accepteer of laat verlopen op Don.`,
      en: `${lender?.username || 'Someone'} offered you a Don loan of ${formatDonCash(amount, false)}. Accept or let it expire on Don.`,
    });
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
    void notifyDon(
      playerId,
      {
        nl: `Je accepteerde een Don-lening van ${formatDonCash(loan.principal, true)}.`,
        en: `You accepted a Don loan of ${formatDonCash(loan.principal, false)}.`,
      },
      { push: false }
    );
    void notifyDon(loan.lenderId, {
      nl: `Je Don-lening van ${formatDonCash(loan.principal, true)} is geaccepteerd.`,
      en: `Your Don loan of ${formatDonCash(loan.principal, false)} was accepted.`,
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
    void notifyDon(
      playerId,
      {
        nl: `Je loste ${formatDonCash(amount, true)} af op een Don-lening.`,
        en: `You repaid ${formatDonCash(amount, false)} on a Don loan.`,
      },
      { push: false }
    );
    void notifyDon(loan.lenderId, {
      nl: `Een lener betaalde ${formatDonCash(amount, true)} terug op je Don-lening.`,
      en: `A borrower repaid ${formatDonCash(amount, false)} on your Don loan.`,
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
      void notifyDon(
        playerId,
        {
          nl: `Je inde ${formatDonCash(take, true)} op een NPC-default.`,
          en: `You collected ${formatDonCash(take, false)} on an NPC default.`,
        },
        { push: false }
      );
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
    void notifyDon(
      playerId,
      {
        nl: `Je inde ${formatDonCash(seized, true)} op een wanbetaling.`,
        en: `You collected ${formatDonCash(seized, false)} on a default.`,
      },
      { push: false }
    );
    void notifyDon(loan.borrowerPlayerId, {
      nl: `De shark inde ${formatDonCash(seized, true)} op je Don-lening. Wanted ging omhoog.`,
      en: `The shark collected ${formatDonCash(seized, false)} on your Don loan. Wanted went up.`,
    });
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
    const replaced = active && row.patronPlayerId && row.patronPlayerId !== playerId;
    void worldEventService.createEvent(
      'don.official_bribed',
      { office, countryCode: player.currentCountry, cost, replaced: Boolean(replaced) },
      playerId
    );
    void notifyDon(
      playerId,
      {
        nl: `Je kocht de ${donOfficeLabel(office, true)} voor ${formatDonCash(cost, true)}.`,
        en: `You bought the ${donOfficeLabel(office, false)} for ${formatDonCash(cost, false)}.`,
      },
      { push: false }
    );
    if (replaced) {
      void notifyDon(row.patronPlayerId, {
        nl: `Iemand overbood je als ${donOfficeLabel(office, true)} in ${player.currentCountry}.`,
        en: `Someone outbid you as ${donOfficeLabel(office, false)} in ${player.currentCountry}.`,
      });
    }
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
    void notifyDon(
      playerId,
      {
        nl: `Contract aangenomen. Inzet ${formatDonCash(bidCost, true)}, payout ${formatDonCash(payout, true)}.`,
        en: `Contract bid accepted. Stake ${formatDonCash(bidCost, false)}, payout ${formatDonCash(payout, false)}.`,
      },
      { push: false }
    );
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
        void notifyDon(loan.lenderId, {
          nl: 'Een NPC-lening is in default. Innen op Don.',
          en: 'An NPC loan defaulted. Collect it on Don.',
        });
      } else {
        const amount = dueAmount(loan.principal, loan.interestBps);
        await prisma.$transaction([
          prisma.player.update({
            where: { id: loan.lenderId },
            data: { money: { increment: amount } },
          }),
          prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'repaid' } }),
        ]);
        void notifyDon(loan.lenderId, {
          nl: `Een NPC betaalde ${formatDonCash(amount, true)} terug op je Don-lening.`,
          en: `An NPC repaid ${formatDonCash(amount, false)} on your Don loan.`,
        });
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
      void notifyDon(loan.lenderId, {
        nl: `Je Don-leningaanbod verliep. ${formatDonCash(loan.principal, true)} is terug op je cash.`,
        en: `Your Don loan offer expired. ${formatDonCash(loan.principal, false)} is back in your cash.`,
      });
      if (loan.borrowerPlayerId) {
        void notifyDon(loan.borrowerPlayerId, {
          nl: 'Een Don-leningaanbod aan jou is verlopen.',
          en: 'A Don loan offer to you expired.',
        });
      }
      loans += 1;
    }

    const dueP2p = await prisma.donLoan.findMany({
      where: { status: 'active', npcKey: null, dueAt: { lte: now } },
    });
    for (const loan of dueP2p) {
      await prisma.donLoan.update({ where: { id: loan.id }, data: { status: 'defaulted' } });
      void notifyDon(loan.lenderId, {
        nl: 'Een spelerlening is in default. Innen op Don.',
        en: 'A player loan defaulted. Collect it on Don.',
      });
      if (loan.borrowerPlayerId) {
        void notifyDon(loan.borrowerPlayerId, {
          nl: 'Je Don-lening is in default. De shark kan innen.',
          en: 'Your Don loan defaulted. The shark can collect.',
        });
      }
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
      void notifyDon(row.bidderPlayerId, {
        nl: `Je stadscontract is klaar. Payout ${formatDonCash(payout, true)} staat op ${row.crewId ? 'de crew-bank of je cash' : 'je cash'}.`,
        en: `Your city contract finished. Payout ${formatDonCash(payout, false)} went to ${row.crewId ? 'the crew bank or your cash' : 'your cash'}.`,
      });
      contracts += 1;
    }

    const readyFrom = new Date(now.getTime() - (cfg.collectCooldownSeconds + 12 * 60) * 1000);
    const readyUntil = new Date(now.getTime() - cfg.collectCooldownSeconds * 1000);
    const readyRackets = await prisma.donRacket.findMany({
      where: {
        ownerPlayerId: { not: null },
        lastCollectAt: { gte: readyFrom, lte: readyUntil },
      },
      select: { id: true, ownerPlayerId: true, businessKey: true, lastCollectAt: true },
    });
    for (const racket of readyRackets) {
      if (!racket.ownerPlayerId || !racket.lastCollectAt) continue;
      const already = await prisma.worldEvent.findFirst({
        where: {
          playerId: racket.ownerPlayerId,
          eventKey: 'don.collect_ready',
          createdAt: { gte: racket.lastCollectAt },
        },
        select: { id: true },
      });
      if (already) continue;
      void notifyDon(
        racket.ownerPlayerId,
        {
          nl: `Je ${donBusinessLabel(racket.businessKey, true)} is klaar om te innen.`,
          en: `Your ${donBusinessLabel(racket.businessKey, false)} is ready to collect.`,
        },
        {
          eventKey: 'don.collect_ready',
          params: { racketId: racket.id, businessKey: racket.businessKey },
        }
      );
    }

    for (const countryCode of COUNTRY_IDS.slice(0, 8)) {
      await ensureCountryContracts(countryCode);
    }

    return { abandoned, contests, loans, contracts };
  },
};
