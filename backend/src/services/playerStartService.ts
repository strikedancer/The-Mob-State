import crypto from 'crypto';
import bcrypt from 'bcrypt';
import prisma from '../lib/prisma';
import { createCrew } from './crewService';
import { directMessageService } from './directMessageService';

const DEFAULT_STARTER_CASH = 2000;
export const STARTER_CREW_NAME = 'The Rookies';
const STARTER_LEADER_USERNAME = 'StreetBureau';

async function runtimeInt(key: string, fallback: number): Promise<number> {
  try {
    const rows = await prisma.$queryRawUnsafe<Array<{ configValue: string }>>(
      `SELECT configValue FROM runtime_config WHERE configKey = ? LIMIT 1`,
      key,
    );
    const parsed = Number.parseInt(String(rows[0]?.configValue ?? ''), 10);
    return Number.isFinite(parsed) && parsed >= 0 ? parsed : fallback;
  } catch {
    return fallback;
  }
}

function formatCash(amount: number, language: string): string {
  const locale = language.toLowerCase().startsWith('nl') ? 'nl-NL' : 'en-US';
  return `€${amount.toLocaleString(locale)}`;
}

export const playerStartService = {
  async starterCashAmount(): Promise<number> {
    return runtimeInt('PLAYER_STARTER_CASH', DEFAULT_STARTER_CASH);
  },

  async grantStarterBundle(playerId: number): Promise<void> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, preferredLanguage: true, money: true },
    });
    if (!player) return;

    const starterCash = await this.starterCashAmount();
    if (starterCash > 0 && player.money < starterCash) {
      await prisma.player.update({
        where: { id: playerId },
        data: { money: { increment: starterCash - player.money } },
      });
    }

    const lang = player.preferredLanguage || 'en';
    const cash = formatCash(starterCash, lang);
    const message = lang.toLowerCase().startsWith('nl')
      ? `Welkom\nJe start met ${cash}. Doe een straatmisdaad, pak je dagdoel en join The Rookies. Morgen staan nieuwe dagdoelen klaar; je crew krijgt een seintje als je vastzit. VIP koopt geen winst — alleen kortere wachttijden.`
      : `Welcome\nYou start with ${cash}. Do a street crime, claim your daily goal, and join The Rookies. New daily goals land tomorrow; your crew gets a ping if you are jailed. VIP does not buy wins — only shorter waits.`;
    await directMessageService.sendSystemMessage(playerId, message, { sendPush: false });
  },

  async ensureStarterCrew(): Promise<void> {
    const existingOpen = await prisma.crew.findFirst({
      where: { recruitingOpen: true, autoAccept: true },
      select: { id: true },
    });
    if (existingOpen) {
      return;
    }

    let crew = await prisma.crew.findUnique({
      where: { name: STARTER_CREW_NAME },
      select: { id: true },
    });
    if (crew) {
      await prisma.crew.update({
        where: { id: crew.id },
        data: { recruitingOpen: true, autoAccept: true },
      });
      return;
    }

    let leader = await prisma.player.findUnique({
      where: { username: STARTER_LEADER_USERNAME },
      select: { id: true },
    });
    if (!leader) {
      const passwordHash = await bcrypt.hash(crypto.randomBytes(24).toString('hex'), 10);
      leader = await prisma.player.create({
        data: {
          username: STARTER_LEADER_USERNAME,
          passwordHash,
          preferredLanguage: 'en',
          currentCountry: 'netherlands',
          gender: 'male',
          avatar: 'default_1',
        },
        select: { id: true },
      });
    }

    const membership = await prisma.crewMember.findFirst({
      where: { playerId: leader.id },
      select: { crewId: true },
    });
    if (membership) {
      await prisma.crew.update({
        where: { id: membership.crewId },
        data: { recruitingOpen: true, autoAccept: true },
      });
      return;
    }

    const created = await createCrew({
      name: STARTER_CREW_NAME,
      leaderId: leader.id,
    });
    await prisma.crew.update({
      where: { id: created.id },
      data: { recruitingOpen: true, autoAccept: true },
    });
  },
};
