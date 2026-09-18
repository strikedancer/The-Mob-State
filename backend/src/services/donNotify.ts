import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { worldEventService } from './worldEventService';

const BUSINESS: Record<string, { nl: string; en: string }> = {
  cafe: { nl: 'café', en: 'café' },
  garage: { nl: 'garage', en: 'garage' },
  warehouse: { nl: 'loods', en: 'warehouse' },
  night_shop: { nl: 'nachtwinkel', en: 'night shop' },
  port_office: { nl: 'havenkantoor', en: 'port office' },
  laundry: { nl: 'wasserette', en: 'laundry' },
};

const OFFICE: Record<string, { nl: string; en: string }> = {
  judge: { nl: 'rechter', en: 'judge' },
  commissioner: { nl: 'commissaris', en: 'commissioner' },
  alderman: { nl: 'wethouder', en: 'alderman' },
};

export function donBusinessLabel(key: string, nl: boolean): string {
  const row = BUSINESS[key];
  if (!row) return key;
  return nl ? row.nl : row.en;
}

export function donOfficeLabel(key: string, nl: boolean): string {
  const row = OFFICE[key];
  if (!row) return key;
  return nl ? row.nl : row.en;
}

export function formatDonCash(amount: number, nl: boolean): string {
  const locale = nl ? 'nl-NL' : 'en-US';
  return `€${amount.toLocaleString(locale)}`;
}

async function playerLang(playerId: number): Promise<{ nl: boolean; language: string }> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  const language = player?.preferredLanguage || 'en';
  return { nl: language.toLowerCase().startsWith('nl'), language };
}

export async function notifyDon(
  playerId: number | null | undefined,
  copy: { nl: string; en: string },
  options?: { push?: boolean; eventKey?: string; params?: Record<string, unknown> }
): Promise<void> {
  if (!playerId) return;
  try {
    const { nl } = await playerLang(playerId);
    const body = nl ? copy.nl : copy.en;
    await directMessageService.sendSystemMessage(playerId, `Don\n${body}`, {
      sendPush: options?.push ?? true,
      senderName: nl ? 'Don Bureau' : 'Don Desk',
    });
    if (options?.eventKey) {
      await worldEventService.createEvent(options.eventKey, options.params ?? {}, playerId);
    }
  } catch (error) {
    console.error('[Don] Failed to notify player', playerId, error);
  }
}
