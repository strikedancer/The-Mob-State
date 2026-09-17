import prisma from '../lib/prisma';
import { extendVipExpiryDate } from './vipBenefitsService';
import { NotificationService } from './notificationService';

const MIN_DONATE_CENTS = 100;
const PRESET_DONATE_CENTS = [100, 250, 500];

export function euroValueToCents(value: string | number | null | undefined): number {
  const n = typeof value === 'number' ? value : Number.parseFloat(String(value ?? ''));
  if (!Number.isFinite(n) || n <= 0) return 0;
  return Math.round(n * 100);
}

export function centsToEuroValue(cents: number): string {
  return (Math.max(0, Math.round(cents)) / 100).toFixed(2);
}

export async function getCrewVipPriceCents(): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{ configValue: string }>>(
    `SELECT configValue FROM runtime_config WHERE configKey = 'PREMIUM_CREW_VIP_PRICE_EUR' LIMIT 1`
  );
  const fromRuntime = euroValueToCents(rows[0]?.configValue);
  if (fromRuntime >= MIN_DONATE_CENTS) return fromRuntime;
  const fallback = euroValueToCents(process.env.MOLLIE_CREW_VIP_PRICE_EUR || '9.99');
  return Math.max(MIN_DONATE_CENTS, fallback);
}

export function listSuggestedDonateCents(priceCents: number, fundCents: number): number[] {
  const remaining = Math.max(0, priceCents - Math.max(0, fundCents));
  const unique = new Set<number>();
  for (const preset of PRESET_DONATE_CENTS) {
    if (preset >= MIN_DONATE_CENTS && preset <= priceCents) unique.add(preset);
  }
  unique.add(priceCents);
  if (remaining >= MIN_DONATE_CENTS) unique.add(remaining);
  return [...unique].sort((a, b) => a - b);
}

export function isAllowedDonateAmount(
  amountCents: number,
  priceCents: number,
  fundCents: number
): boolean {
  if (!Number.isInteger(amountCents) || amountCents < MIN_DONATE_CENTS || amountCents > priceCents) {
    return false;
  }
  return listSuggestedDonateCents(priceCents, fundCents).includes(amountCents);
}

export type CrewVipFundStatus = {
  crewId: number;
  fundCents: number;
  priceCents: number;
  remainingCents: number;
  monthlyPriceEur: string;
  autoRenewActive: boolean;
  isVip: boolean;
  expiresAt: Date | null;
  suggestedAmountsEur: string[];
  donations: Array<{
    username: string;
    amountEur: string;
    monthsGranted: number;
    createdAt: string;
  }>;
};

export async function getCrewVipFundStatus(crewId: number): Promise<CrewVipFundStatus> {
  const [crew, fundRows, priceCents, donationRows] = await Promise.all([
    prisma.crew.findUnique({
      where: { id: crewId },
      select: {
        id: true,
        isVip: true,
        vipExpiresAt: true,
        mollieSubscriptionId: true,
      },
    }),
    prisma.$queryRawUnsafe<Array<{ vipFundCents: number | bigint }>>(
      `SELECT vipFundCents FROM crews WHERE id = ? LIMIT 1`,
      crewId
    ),
    getCrewVipPriceCents(),
    prisma.$queryRawUnsafe<Array<{
      username: string;
      amountCents: number | bigint;
      monthsGranted: number | bigint;
      createdAt: Date;
    }>>(
      `
      SELECT p.username, d.amountCents, d.monthsGranted, d.createdAt
      FROM crew_vip_donations d
      JOIN players p ON p.id = d.playerId
      WHERE d.crewId = ?
      ORDER BY d.id DESC
      LIMIT 8
      `,
      crewId
    ),
  ]);

  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  const fundCents = Math.max(0, Number(fundRows[0]?.vipFundCents || 0));
  const remainingCents = Math.max(0, priceCents - fundCents);
  return {
    crewId,
    fundCents,
    priceCents,
    remainingCents,
    monthlyPriceEur: centsToEuroValue(priceCents),
    autoRenewActive: Boolean(crew.mollieSubscriptionId),
    isVip: Boolean(crew.isVip) && (!crew.vipExpiresAt || crew.vipExpiresAt.getTime() > Date.now()),
    expiresAt: crew.vipExpiresAt,
    suggestedAmountsEur: listSuggestedDonateCents(priceCents, fundCents).map(centsToEuroValue),
    donations: donationRows.map((row) => ({
      username: row.username,
      amountEur: centsToEuroValue(Number(row.amountCents)),
      monthsGranted: Number(row.monthsGranted || 0),
      createdAt: new Date(row.createdAt).toISOString(),
    })),
  };
}

export async function applyCrewVipDonation(params: {
  crewId: number;
  playerId: number;
  amountCents: number;
  molliePaymentId: string;
}): Promise<{ fundCents: number; monthsGranted: number; alreadyApplied: boolean }> {
  const amountCents = Math.round(params.amountCents);
  if (!Number.isFinite(amountCents) || amountCents < MIN_DONATE_CENTS) {
    throw new Error('INVALID_DONATE_AMOUNT');
  }

  const priceCents = await getCrewVipPriceCents();
  let monthsGranted = 0;
  let leftoverCents = 0;
  let alreadyApplied = false;

  await prisma.$transaction(async (tx) => {
    const inserted = await tx.$executeRawUnsafe(
      `
      INSERT IGNORE INTO crew_vip_donations (crewId, playerId, amountCents, monthsGranted, molliePaymentId)
      VALUES (?, ?, ?, 0, ?)
      `,
      params.crewId,
      params.playerId,
      amountCents,
      params.molliePaymentId
    );

    if (Number(inserted) === 0) {
      alreadyApplied = true;
      const existing = await tx.$queryRawUnsafe<Array<{ monthsGranted: number | bigint }>>(
        `SELECT monthsGranted FROM crew_vip_donations WHERE molliePaymentId = ? LIMIT 1`,
        params.molliePaymentId
      );
      const leftover = await tx.$queryRawUnsafe<Array<{ vipFundCents: number | bigint }>>(
        `SELECT vipFundCents FROM crews WHERE id = ? LIMIT 1`,
        params.crewId
      );
      leftoverCents = Number(leftover[0]?.vipFundCents || 0);
      monthsGranted = Number(existing[0]?.monthsGranted || 0);
      return;
    }

    await tx.$executeRawUnsafe(
      `UPDATE crews SET vipFundCents = vipFundCents + ? WHERE id = ?`,
      amountCents,
      params.crewId
    );

    const rows = await tx.$queryRawUnsafe<Array<{
      vipFundCents: number | bigint;
      vipExpiresAt: Date | null;
    }>>(
      `SELECT vipFundCents, vipExpiresAt FROM crews WHERE id = ? FOR UPDATE`,
      params.crewId
    );
    let fund = Number(rows[0]?.vipFundCents || 0);
    while (fund >= priceCents) {
      fund -= priceCents;
      monthsGranted += 1;
    }
    leftoverCents = fund;
    const lifetimeBump = monthsGranted * 30;
    if (monthsGranted > 0) {
      const nextExpiry = extendVipExpiryDate(rows[0]?.vipExpiresAt ?? null, lifetimeBump);
      await tx.$executeRawUnsafe(
        `
        UPDATE crews
        SET vipFundCents = ?,
            isVip = 1,
            vipExpiresAt = ?,
            vipLifetimeDays = vipLifetimeDays + ?
        WHERE id = ?
        `,
        fund,
        nextExpiry,
        lifetimeBump,
        params.crewId
      );
    } else {
      await tx.$executeRawUnsafe(
        `UPDATE crews SET vipFundCents = ? WHERE id = ?`,
        fund,
        params.crewId
      );
    }
    await tx.$executeRawUnsafe(
      `UPDATE crew_vip_donations SET monthsGranted = ? WHERE molliePaymentId = ?`,
      monthsGranted,
      params.molliePaymentId
    );
  });

  if (!alreadyApplied && monthsGranted > 0) {
    void notifyCrewVipFundUnlocked(params.crewId, monthsGranted).catch((error) => {
      console.warn('[CrewVipFund] notify failed', error);
    });
  }

  return {
    fundCents: leftoverCents,
    monthsGranted,
    alreadyApplied,
  };
}

const FUND_UNLOCK_COPY: Record<string, { title: string; body: (months: number) => string }> = {
  nl: {
    title: 'Crew VIP uit de pot',
    body: (months) =>
      months === 1
        ? 'De donatiepot van je crew heeft 30 dagen Crew VIP gekocht.'
        : `De donatiepot van je crew heeft ${months * 30} dagen Crew VIP gekocht.`,
  },
  en: {
    title: 'Crew VIP from the pot',
    body: (months) =>
      months === 1
        ? 'Your crew donation pot bought 30 days of Crew VIP.'
        : `Your crew donation pot bought ${months * 30} days of Crew VIP.`,
  },
};

async function notifyCrewVipFundUnlocked(crewId: number, monthsGranted: number): Promise<void> {
  const members = await prisma.crewMember.findMany({
    where: { crewId },
    select: {
      playerId: true,
      player: { select: { preferredLanguage: true } },
    },
  });
  const notifications = NotificationService.getInstance();
  await Promise.all(
    members.map(async (member) => {
      const lang = String(member.player?.preferredLanguage || 'en').slice(0, 2).toLowerCase();
      const copy = FUND_UNLOCK_COPY[lang] || FUND_UNLOCK_COPY.en;
      await notifications.sendToPlayer(
        member.playerId,
        copy.title,
        copy.body(monthsGranted),
        {
          type: 'crew_vip_fund',
          crewId: String(crewId),
          months: String(monthsGranted),
        }
      );
    })
  );
}
