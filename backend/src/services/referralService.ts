import crypto from 'crypto';
import prisma from '../lib/prisma';
import config from '../config';
import { directMessageService } from './directMessageService';

const CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const DEFAULT_REFERRER_CASH = 5000;
const DEFAULT_RECRUIT_CASH = 2000;
const DEFAULT_DAILY_CAP = 5;

export function normalizeReferralCode(raw: unknown): string | null {
  const code = String(raw ?? '').trim().toUpperCase();
  if (code.length < 4 || code.length > 12) return null;
  if (!/^[A-Z0-9]+$/.test(code)) return null;
  return code;
}

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

async function rewardAmounts() {
  const [referrerCash, recruitCash, dailyCap] = await Promise.all([
    runtimeInt('REFERRAL_REFERRER_CASH', DEFAULT_REFERRER_CASH),
    runtimeInt('REFERRAL_RECRUIT_CASH', DEFAULT_RECRUIT_CASH),
    runtimeInt('REFERRAL_DAILY_CAP', DEFAULT_DAILY_CAP),
  ]);
  return { referrerCash, recruitCash, dailyCap };
}

function utcDayStart(now = new Date()): Date {
  return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function formatCash(amount: number, language: string): string {
  const locale = language.toLowerCase().startsWith('nl') ? 'nl-NL' : 'en-US';
  return `€${amount.toLocaleString(locale)}`;
}

function inviteUrl(code: string): string {
  const base = (config.appBaseUrl || 'https://themobstate.com').replace(/\/+$/, '');
  return `${base}/register?ref=${encodeURIComponent(code)}`;
}

function makeCode(): string {
  let code = '';
  for (let i = 0; i < 8; i += 1) {
    code += CODE_ALPHABET[crypto.randomInt(0, CODE_ALPHABET.length)];
  }
  return code;
}

async function ensureReferralCode(playerId: number): Promise<string> {
  const existing = await prisma.player.findUnique({
    where: { id: playerId },
    select: { referralCode: true },
  });
  if (existing?.referralCode) {
    return existing.referralCode;
  }

  for (let attempt = 0; attempt < 8; attempt += 1) {
    const referralCode = makeCode();
    try {
      await prisma.player.update({
        where: { id: playerId },
        data: { referralCode },
      });
      return referralCode;
    } catch {
      // Unique clash — try another code.
    }
  }
  throw new Error('REFERRAL_CODE_FAILED');
}

async function rewardedToday(referrerId: number): Promise<number> {
  return prisma.player.count({
    where: {
      referredById: referrerId,
      referralReferrerPaidAt: { gte: utcDayStart() },
    },
  });
}

async function linkFriends(referrerId: number, recruitId: number): Promise<void> {
  const existing = await prisma.friendship.findFirst({
    where: {
      OR: [
        { requesterId: referrerId, addresseeId: recruitId },
        { requesterId: recruitId, addresseeId: referrerId },
      ],
    },
  });
  if (existing) {
    if (existing.status !== 'accepted' && existing.status !== 'blocked') {
      await prisma.friendship.update({
        where: { id: existing.id },
        data: { status: 'accepted' },
      });
    }
    return;
  }
  await prisma.friendship.create({
    data: {
      requesterId: referrerId,
      addresseeId: recruitId,
      status: 'accepted',
    },
  });
}

async function payReferrer(recruit: {
  id: number;
  username: string;
  referredById: number | null;
  referralReferrerPaidAt: Date | null;
}) {
  if (!recruit.referredById || recruit.referralReferrerPaidAt) {
    return false;
  }
  const { referrerCash, dailyCap } = await rewardAmounts();
  if (referrerCash <= 0) {
    await prisma.player.update({
      where: { id: recruit.id },
      data: { referralReferrerPaidAt: new Date() },
    });
    return false;
  }
  if ((await rewardedToday(recruit.referredById)) >= dailyCap) {
    return false;
  }

  const referrer = await prisma.player.findUnique({
    where: { id: recruit.referredById },
    select: { id: true, preferredLanguage: true },
  });
  if (!referrer) {
    return false;
  }

  const paid = await prisma.player.updateMany({
    where: { id: recruit.id, referralReferrerPaidAt: null },
    data: { referralReferrerPaidAt: new Date() },
  });
  if (paid.count === 0) {
    return false;
  }

  await prisma.player.update({
    where: { id: referrer.id },
    data: { money: { increment: referrerCash } },
  });

  const lang = referrer.preferredLanguage || 'en';
  const cash = formatCash(referrerCash, lang);
  const message = lang.toLowerCase().startsWith('nl')
    ? `Deel-link\n${recruit.username} heeft meegedaan via jouw link. ${cash} is bijgeschreven.`
    : `Invite link\n${recruit.username} joined through your link. ${cash} has been added.`;
  await directMessageService.sendSystemMessage(referrer.id, message, { sendPush: true });
  return true;
}

async function flushPendingRewards(referrerId: number): Promise<void> {
  const pending = await prisma.player.findMany({
    where: {
      referredById: referrerId,
      referralQualifiedAt: { not: null },
      referralReferrerPaidAt: null,
    },
    select: {
      id: true,
      username: true,
      referredById: true,
      referralReferrerPaidAt: true,
    },
    orderBy: { referralQualifiedAt: 'asc' },
    take: 8,
  });
  for (const recruit of pending) {
    const paid = await payReferrer(recruit);
    if (!paid) {
      break;
    }
  }
}

export const referralService = {
  async getInvite(playerId: number) {
    await flushPendingRewards(playerId);
    const [code, amounts, rewardedTodayCount, qualifiedCount] = await Promise.all([
      ensureReferralCode(playerId),
      rewardAmounts(),
      rewardedToday(playerId),
      prisma.player.count({
        where: { referredById: playerId, referralQualifiedAt: { not: null } },
      }),
    ]);
    return {
      code,
      url: inviteUrl(code),
      referrerCash: amounts.referrerCash,
      recruitCash: amounts.recruitCash,
      dailyCap: amounts.dailyCap,
      rewardedToday: rewardedTodayCount,
      qualifiedCount,
    };
  },

  async attachOnRegister(playerId: number, rawCode: unknown): Promise<void> {
    const code = normalizeReferralCode(rawCode);
    if (!code) return;

    const recruit = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, username: true, referredById: true, preferredLanguage: true },
    });
    if (!recruit || recruit.referredById) return;

    const referrer = await prisma.player.findUnique({
      where: { referralCode: code },
      select: { id: true, username: true },
    });
    if (!referrer || referrer.id === playerId) return;

    const { recruitCash } = await rewardAmounts();
    await prisma.player.update({
      where: { id: playerId },
      data: {
        referredById: referrer.id,
        ...(recruitCash > 0 ? { money: { increment: recruitCash } } : {}),
      },
    });

    try {
      await linkFriends(referrer.id, playerId);
    } catch (error) {
      console.error('[Referral] Failed to auto-friend invite pair:', error);
    }

    if (recruitCash > 0) {
      const lang = recruit.preferredLanguage || 'en';
      const cash = formatCash(recruitCash, lang);
      const message = lang.toLowerCase().startsWith('nl')
        ? `Deel-link\nWelkom via ${referrer.username}. Je startbonus is ${cash}. Jullie staan al als vrienden.`
        : `Invite link\nWelcome via ${referrer.username}. Your starter bonus is ${cash}. You are already friends.`;
      await directMessageService.sendSystemMessage(playerId, message, { sendPush: false });
    }
  },

  async qualifyFromGameplay(playerId: number): Promise<void> {
    const recruit = await prisma.player.findUnique({
      where: { id: playerId },
      select: {
        id: true,
        username: true,
        referredById: true,
        referralQualifiedAt: true,
        referralReferrerPaidAt: true,
      },
    });
    if (!recruit?.referredById) return;

    if (!recruit.referralQualifiedAt) {
      await prisma.player.update({
        where: { id: playerId },
        data: { referralQualifiedAt: new Date() },
      });
    }

    await payReferrer({
      ...recruit,
      referralReferrerPaidAt: recruit.referralReferrerPaidAt,
    });
    await flushPendingRewards(recruit.referredById);
  },
};
