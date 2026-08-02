import prisma from '../lib/prisma';
import crypto from 'crypto';

type StakeTier = 1 | 3 | 5;

type VaultStatus = {
  seasonKey: string;
  startsAt: Date;
  endsAt: Date;
  tiers: Array<{
    stake: StakeTier;
    rewardCredits: number;
    vipRewardPossible: boolean;
  }>;
  player: {
    premiumCredits: number;
    attemptsThisSeason: number;
    wrongGuesses: string[];
    lastAttemptAt: Date | null;
  };
};

type VaultI18n = {
  messageNl: string;
  messageEn: string;
  messageEs: string;
  messageDe: string;
  messageFr: string;
  messageIt: string;
  messagePl: string;
  messagePt: string;
};

function vaultMessages(s: {
  nl: string;
  en: string;
  es: string;
  de: string;
  fr: string;
  it: string;
  pl: string;
  pt: string;
}): VaultI18n {
  return {
    messageNl: s.nl,
    messageEn: s.en,
    messageEs: s.es,
    messageDe: s.de,
    messageFr: s.fr,
    messageIt: s.it,
    messagePl: s.pl,
    messagePt: s.pt,
  };
}

type AttemptResult = {
  success: boolean;
  correct: boolean;
  seasonKey: string;
  balance: number;
} & VaultI18n & {
  prize?: {
    type: 'CREDITS' | 'VIP_30D';
    credits?: number;
  };
  wrongGuesses: string[];
};

const STAKE_TIERS: Array<{ stake: StakeTier; rewardCredits: number; vipChancePct: number }> = [
  { stake: 1, rewardCredits: 500, vipChancePct: 0 },
  { stake: 3, rewardCredits: 1500, vipChancePct: 0 },
  // Tier 5 can (rarely) pay VIP when the player isn't VIP; otherwise credits.
  { stake: 5, rewardCredits: 2500, vipChancePct: 10 },
];

const VAULT_CODE_SECRET = (process.env.VAULT_CODE_SECRET || process.env.JWT_SECRET || 'vault_secret')
  .toString()
  .trim();

function getSeasonKey(now: Date) {
  const y = now.getFullYear();
  const m = String(now.getMonth() + 1).padStart(2, '0');
  return `${y}-${m}`;
}

function getMonthWindow(now: Date) {
  const startsAt = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0, 0);
  const endsAt = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
  return { startsAt, endsAt };
}

function normalizeGuess(guess: string) {
  const trimmed = String(guess || '').trim();
  const digitsOnly = trimmed.replace(/[^\d]/g, '');
  if (digitsOnly.length !== 4) return null;
  return digitsOnly;
}

function hashSeasonCode(seasonKey: string, code4: string) {
  return crypto
    .createHash('sha256')
    .update(`${seasonKey}:${code4}:${VAULT_CODE_SECRET}`)
    .digest('hex');
}

function randomPin4() {
  const n = crypto.randomInt(0, 10000);
  return String(n).padStart(4, '0');
}

function pickTier(stakeTier: number): { stake: StakeTier; rewardCredits: number; vipChancePct: number } | null {
  const found = STAKE_TIERS.find((t) => t.stake === stakeTier);
  return found ?? null;
}

async function ensureActiveSeason(now = new Date()) {
  const seasonKey = getSeasonKey(now);
  const { startsAt, endsAt } = getMonthWindow(now);

  const existing = await (prisma as any).vaultSeason.findUnique({
    where: { seasonKey },
  });
  if (existing) {
    return existing as {
      id: number;
      seasonKey: string;
      startsAt: Date;
      endsAt: Date;
      codeHash: string;
    };
  }

  const pin = randomPin4();
  const codeHash = hashSeasonCode(seasonKey, pin);
  const created = await (prisma as any).vaultSeason.create({
    data: {
      seasonKey,
      startsAt,
      endsAt,
      codeHash,
    },
  });
  return created as {
    id: number;
    seasonKey: string;
    startsAt: Date;
    endsAt: Date;
    codeHash: string;
  };
}

async function getWrongGuesses(playerId: number, seasonId: number, limit = 25) {
  const rows = await (prisma as any).vaultAttempt.findMany({
    where: {
      playerId,
      seasonId,
      isCorrect: false,
      guess: { not: null },
    },
    orderBy: { createdAt: 'desc' },
    take: Math.max(1, Math.min(50, limit * 3)),
    select: { guess: true },
  });

  const unique: string[] = [];
  for (const row of rows) {
    const g = String(row.guess || '').trim();
    if (!g) continue;
    if (unique.includes(g)) continue;
    unique.push(g);
    if (unique.length >= limit) break;
  }
  return unique;
}

async function updateCreditsBalance(
  tx: any,
  playerId: number,
  delta: number,
  reasonType: 'PURCHASE' | 'REDEEM' | 'REFUND' | 'ADMIN_ADJUSTMENT',
  reasonKey: string,
  metadata: Record<string, unknown>,
) {
  const player = await tx.player.findUnique({
    where: { id: playerId },
    select: { premiumCredits: true },
  });
  if (!player) throw new Error('PLAYER_NOT_FOUND');

  const nextBalance = player.premiumCredits + delta;
  if (nextBalance < 0) throw new Error('INSUFFICIENT_CREDITS');

  await tx.player.update({
    where: { id: playerId },
    data: { premiumCredits: nextBalance },
  });
  await tx.playerCreditTransaction.create({
    data: {
      playerId,
      delta,
      balanceAfter: nextBalance,
      reasonType,
      reasonKey,
      metadataJson: JSON.stringify(metadata),
    },
  });

  return nextBalance;
}

function isVipActive(player: { isVip: boolean; vipExpiresAt: Date | null }) {
  return Boolean(player.isVip) && (!player.vipExpiresAt || player.vipExpiresAt > new Date());
}

export const vaultService = {
  async getStatus(playerId: number): Promise<VaultStatus> {
    const season = await ensureActiveSeason();

    const [player, attemptsCount, lastAttempt] = await Promise.all([
      prisma.player.findUnique({
        where: { id: playerId },
        select: { premiumCredits: true },
      }),
      (prisma as any).vaultAttempt.count({
        where: { playerId, seasonId: season.id },
      }),
      (prisma as any).vaultAttempt.findFirst({
        where: { playerId, seasonId: season.id },
        orderBy: { createdAt: 'desc' },
        select: { createdAt: true },
      }),
    ]);

    const wrongGuesses = await getWrongGuesses(playerId, season.id, 25);

    return {
      seasonKey: season.seasonKey,
      startsAt: season.startsAt,
      endsAt: season.endsAt,
      tiers: STAKE_TIERS.map((t) => ({
        stake: t.stake,
        rewardCredits: t.rewardCredits,
        vipRewardPossible: t.vipChancePct > 0,
      })),
      player: {
        premiumCredits: player?.premiumCredits ?? 0,
        attemptsThisSeason: attemptsCount ?? 0,
        wrongGuesses,
        lastAttemptAt: lastAttempt?.createdAt ?? null,
      },
    };
  },

  async attempt(playerId: number, guessRaw: string, stakeTierRaw: number): Promise<AttemptResult> {
    const normalized = normalizeGuess(guessRaw);
    if (!normalized) {
      return {
        success: false,
        correct: false,
        seasonKey: getSeasonKey(new Date()),
        balance: 0,
        ...vaultMessages({
          nl: 'Voer een 4-cijferige code in.',
          en: 'Enter a 4-digit code.',
          es: 'Introduce un código de 4 dígitos.',
          de: 'Geben Sie einen 4-stelligen Code ein.',
          fr: 'Entrez un code à 4 chiffres.',
          it: 'Inserisci un codice di 4 cifre.',
          pl: 'Wprowadź 4-cyfrowy kod.',
          pt: 'Insira um código de 4 dígitos.',
        }),
        wrongGuesses: [],
      };
    }

    const tier = pickTier(stakeTierRaw);
    if (!tier) {
      return {
        success: false,
        correct: false,
        seasonKey: getSeasonKey(new Date()),
        balance: 0,
        messageNl: 'Ongeldige inzet.',
        messageEn: 'Invalid stake.',
        messageEs: 'Apuesta no válida.',
        wrongGuesses: [],
      };
    }

    const season = await ensureActiveSeason();
    const now = new Date();
    if (now < season.startsAt || now > season.endsAt) {
      const status = await this.getStatus(playerId);
      return {
        success: false,
        correct: false,
        seasonKey: status.seasonKey,
        balance: status.player.premiumCredits,
        ...vaultMessages({
          nl: 'Kraak de Kluis is nu niet actief.',
          en: 'Crack the Vault is not active right now.',
          es: 'La bóveda no está activa en este momento.',
          de: 'Knacke den Tresor ist gerade nicht aktiv.',
          fr: 'Le coffre-fort n’est pas disponible pour le moment.',
          it: 'Scassina il caveau non è attivo al momento.',
          pl: 'Złam skarbiec nie jest teraz aktywny.',
          pt: 'Quebrar o cofre não está ativo no momento.',
        }),
        wrongGuesses: status.player.wrongGuesses,
      };
    }

    const correct = hashSeasonCode(season.seasonKey, normalized) === season.codeHash;

    const result = await prisma.$transaction(async (tx) => {
      // Read VIP state once in tx if needed.
      const vipState = await tx.player.findUnique({
        where: { id: playerId },
        select: { isVip: true, vipExpiresAt: true, premiumCredits: true },
      });
      if (!vipState) throw new Error('PLAYER_NOT_FOUND');

      // Spend stake credits.
      const afterSpend = await updateCreditsBalance(
        tx,
        playerId,
        -tier.stake,
        'REDEEM',
        'vault_attempt',
        { seasonKey: season.seasonKey, stakeTier: tier.stake, guess: normalized },
      );

      // Record attempt.
      await (tx as any).vaultAttempt.create({
        data: {
          seasonId: season.id,
          playerId,
          stakeTier: tier.stake,
          guess: correct ? null : normalized,
          isCorrect: correct,
        },
      });

      let prize: AttemptResult['prize'] | undefined;
      let balance = afterSpend;

      if (correct) {
        const vipEligible = tier.vipChancePct > 0 && !isVipActive(vipState);
        const roll = crypto.randomInt(0, 100);
        const winVip = vipEligible && roll < tier.vipChancePct;

        if (winVip) {
          // Grant VIP 30 days for non-VIP.
          const base = vipState.vipExpiresAt && vipState.vipExpiresAt > now ? vipState.vipExpiresAt : now;
          const nextVip = new Date(base.getTime() + 30 * 24 * 60 * 60 * 1000);
          await tx.player.update({
            where: { id: playerId },
            data: {
              isVip: true,
              vipExpiresAt: nextVip,
              vipLifetimeDays: { increment: 30 },
            },
          });
          prize = { type: 'VIP_30D' };
        } else {
          // Always credits; if player is already VIP and VIP would have been possible, we convert to credits too.
          balance = await updateCreditsBalance(
            tx,
            playerId,
            tier.rewardCredits,
            'REFUND',
            'vault_prize',
            { seasonKey: season.seasonKey, stakeTier: tier.stake, prize: 'credits', credits: tier.rewardCredits },
          );
          prize = { type: 'CREDITS', credits: tier.rewardCredits };
        }
      }

      return { balance, prize };
    });

    const wrongGuesses = await getWrongGuesses(playerId, season.id, 25);

    if (correct) {
      const prize = result.prize;
      if (prize?.type === 'VIP_30D') {
        return {
          success: true,
          correct: true,
          seasonKey: season.seasonKey,
          balance: result.balance,
          ...vaultMessages({
            nl: 'Code gekraakt! Je hebt 1 maand VIP gewonnen.',
            en: 'Vault cracked! You won 1 month of VIP.',
            es: '¡Código acertado! Has ganado 1 mes de VIP.',
            de: 'Code geknackt! Du hast 1 Monat VIP gewonnen.',
            fr: 'Code trouvé ! Vous avez gagné 1 mois de VIP.',
            it: 'Codice forzato! Hai vinto 1 mese di VIP.',
            pl: 'Kod złamany! Otrzymujesz 1 miesiąc VIP.',
            pt: 'Código acertado! Ganhou 1 mês de VIP.',
          }),
          prize,
          wrongGuesses,
        };
      }
      return {
        success: true,
        correct: true,
        seasonKey: season.seasonKey,
        balance: result.balance,
        messageNl: `Code gekraakt! +${tier.rewardCredits} credits.`,
        messageEn: `Vault cracked! +${tier.rewardCredits} credits.`,
        messageEs: `¡Código forzado! +${tier.rewardCredits} créditos.`,
        prize: result.prize,
        wrongGuesses,
      };
    }

    return {
      success: true,
      correct: false,
      seasonKey: season.seasonKey,
      balance: result.balance,
      ...vaultMessages({
        nl: 'Fout! Deze code staat nu in je lijst.',
        en: 'Wrong! This code has been added to your list.',
        es: '¡Incorrecto! Este código se ha añadido a tu lista.',
        de: 'Falsch! Dieser Code wurde deiner Liste hinzugefügt.',
        fr: 'Raté ! Ce code a été ajouté à votre liste.',
        it: 'Sbagliato! Questo codice è stato aggiunto alla lista.',
        pl: 'Źle! Ten kod został dodany do listy.',
        pt: 'Errado! Este código foi adicionado à sua lista.',
      }),
      wrongGuesses,
    };
  },
};

