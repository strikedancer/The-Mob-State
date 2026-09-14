import { NPCType } from '@prisma/client';
import bcrypt from 'bcrypt';
import crypto from 'crypto';
import { readFileSync } from 'fs';
import { join } from 'path';
import { getXPForRank } from '../config';
import prisma from '../lib/prisma';
import { getCasinoPrice } from './casinoOwnershipService';
import { invalidateNpcPlayerIdCache } from './npcLookup';

type OperatorDef = {
  username: string;
  gender: 'male' | 'female';
};

type CountryOperators = {
  casino: OperatorDef;
  factory: OperatorDef;
};

const OPERATOR_RANK = 5;
const FACTORY_SEED_MONEY = 250000;
const CASINO_MIN_BANKROLL = 10000;
const ENSURE_COOLDOWN_MS = 60_000;

let lastEnsureAt = 0;
let ensureInFlight: Promise<void> | null = null;
let operatorsByCountry: Record<string, CountryOperators> | null = null;

function loadOperators(): Record<string, CountryOperators> {
  if (operatorsByCountry) {
    return operatorsByCountry;
  }

  const path = join(__dirname, '../../content/venueNpcOperators.json');
  operatorsByCountry = JSON.parse(readFileSync(path, 'utf-8')) as Record<
    string,
    CountryOperators
  >;
  return operatorsByCountry;
}

function fallbackUsername(role: 'casino' | 'factory', countryId: string): string {
  const compact = `House${role === 'casino' ? 'Casino' : 'Ammo'}_${countryId}`
    .replace(/[^a-zA-Z0-9_]/g, '')
    .slice(0, 50);
  return compact || `House_${role}`;
}

async function ensureOperatorPlayer(
  preferred: OperatorDef,
  role: 'casino' | 'factory',
  countryId: string
): Promise<number> {
  const candidates = [
    preferred.username,
    `${preferred.username}Npc`.slice(0, 50),
    fallbackUsername(role, countryId),
  ];

  for (const username of candidates) {
    const existing = await prisma.player.findUnique({
      where: { username },
      select: { id: true },
    });
    if (!existing) {
      const passwordHash = await bcrypt.hash(crypto.randomBytes(24).toString('hex'), 10);
      const gender = preferred.gender === 'female' ? 'female' : 'male';
      const player = await prisma.player.create({
        data: {
          username,
          passwordHash,
          email: `${username.toLowerCase()}@npc.local`,
          emailVerified: true,
          gender,
          avatar: gender === 'female' ? 'default_2' : 'default_1',
          money: FACTORY_SEED_MONEY,
          rank: OPERATOR_RANK,
          xp: getXPForRank(OPERATOR_RANK),
          currentCountry: countryId,
          preferredLanguage: 'en',
        },
        select: { id: true },
      });
      await prisma.nPCPlayer.create({
        data: {
          playerId: player.id,
          npcType: NPCType.MATIG,
          isActive: false,
        },
      });
      invalidateNpcPlayerIdCache();
      return player.id;
    }

    const npc = await prisma.nPCPlayer.findUnique({
      where: { playerId: existing.id },
      select: { id: true },
    });
    if (npc) {
      return existing.id;
    }
  }

  throw new Error(`VENUE_NPC_USERNAME_TAKEN:${countryId}:${role}`);
}

async function seedVacantCasino(countryId: string): Promise<void> {
  const operators = loadOperators();
  const spec = operators[countryId]?.casino;
  if (!spec) {
    return;
  }

  const casinoId = `casino_${countryId}`;
  const existing = await prisma.casinoOwnership.findUnique({
    where: { casinoId },
    select: { ownerId: true, bankroll: true },
  });
  if (existing) {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { playerId: existing.ownerId },
      select: { id: true },
    });
    if (npc && existing.bankroll < CASINO_MIN_BANKROLL * 3) {
      const price = getCasinoPrice(countryId);
      const seedBankroll = Math.max(
        CASINO_MIN_BANKROLL * 5,
        Math.floor(price * 0.2)
      );
      await prisma.casinoOwnership.update({
        where: { casinoId },
        data: { bankroll: seedBankroll },
      });
    }
    return;
  }

  const ownerId = await ensureOperatorPlayer(spec, 'casino', countryId);
  const price = getCasinoPrice(countryId);
  const bankroll = Math.max(CASINO_MIN_BANKROLL * 5, Math.floor(price * 0.2));

  await prisma.property.upsert({
    where: { propertyId: casinoId },
    create: {
      playerId: ownerId,
      propertyId: casinoId,
      propertyType: 'casino',
      countryId,
      purchasePrice: price,
    },
    update: {
      playerId: ownerId,
      countryId,
      purchasePrice: price,
    },
  });

  await prisma.casinoOwnership.create({
    data: {
      casinoId,
      ownerId,
      purchasePrice: price,
      bankroll,
      totalReceived: 0,
      totalPaidOut: 0,
    },
  });
}

async function seedVacantFactory(countryId: string): Promise<void> {
  const operators = loadOperators();
  const spec = operators[countryId]?.factory;
  if (!spec) {
    return;
  }

  const factory = await prisma.ammoFactory.findUnique({
    where: { countryId },
    select: { id: true, ownerId: true },
  });
  if (!factory) {
    return;
  }

  if (factory.ownerId) {
    const npc = await prisma.nPCPlayer.findUnique({
      where: { playerId: factory.ownerId },
      select: { id: true },
    });
    if (npc) {
      await prisma.ammoFactory.update({
        where: { id: factory.id },
        data: { lastActiveAt: new Date() },
      });
    }
    return;
  }

  const ownerId = await ensureOperatorPlayer(spec, 'factory', countryId);
  const now = new Date();
  await prisma.ammoFactory.update({
    where: { id: factory.id },
    data: {
      ownerId,
      lastActiveAt: now,
      lastProducedAt: now,
    },
  });
}

async function runEnsure(): Promise<void> {
  const operators = loadOperators();
  const countryIds = Object.keys(operators);

  for (const countryId of countryIds) {
    try {
      await seedVacantCasino(countryId);
    } catch (error) {
      console.error(`[VenueNPC] Failed to seed casino ${countryId}:`, error);
    }
    try {
      await seedVacantFactory(countryId);
    } catch (error) {
      console.error(`[VenueNPC] Failed to seed factory ${countryId}:`, error);
    }
  }
}

export async function reclaimVacantCasino(countryId: string): Promise<void> {
  await seedVacantCasino(countryId.toLowerCase());
}

export async function reclaimVacantFactory(countryId: string): Promise<void> {
  await seedVacantFactory(countryId.toLowerCase());
}

export function countryIdFromCasinoId(casinoId: string): string {
  return casinoId.replace(/^casino_/, '').toLowerCase();
}

export async function ensureVenueNpcOccupancy(force = false): Promise<void> {
  if (!force && Date.now() - lastEnsureAt < ENSURE_COOLDOWN_MS) {
    return;
  }
  if (ensureInFlight) {
    await ensureInFlight;
    return;
  }

  ensureInFlight = runEnsure()
    .then(() => {
      lastEnsureAt = Date.now();
    })
    .finally(() => {
      ensureInFlight = null;
    });

  await ensureInFlight;
}
