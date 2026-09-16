import prisma from '../lib/prisma';
import { globalChatService } from './globalChatService';
import { isNpcPlayerId } from './npcLookup';

const SYSTEM_NAME = 'Gevangenis';

function safeName(raw: string | null | undefined): string {
  const cleaned = (raw ?? '').replace(/[\r\n\t]+/g, ' ').trim();
  return cleaned.slice(0, 32) || 'Speler';
}

function authorityPhrase(authority?: string): string {
  const key = (authority ?? '').toLowerCase();
  if (key.includes('fbi')) return 'de FBI';
  if (key.includes('border') || key.includes('grens')) return 'de grenspolitie';
  if (key.includes('black_money') || key.includes('zwart')) return 'de politie wegens zwart geld';
  return 'de politie';
}

async function post(message: string): Promise<void> {
  try {
    await globalChatService.sendSystemAnnouncement(SYSTEM_NAME, message);
  } catch (error) {
    console.error('[PrisonWorldChat] failed to post:', error);
  }
}

export async function announcePlayerJailed(
  playerId: number,
  authority?: string,
): Promise<void> {
  if (await isNpcPlayerId(playerId)) {
    return;
  }
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { username: true },
  });
  if (!player?.username) {
    return;
  }
  const key = (authority ?? '').toLowerCase();
  if (key.includes('black_money') || key.includes('zwart')) {
    await post(`${safeName(player.username)} is opgepakt wegens zwart geld.`);
    return;
  }
  await post(`${safeName(player.username)} is opgepakt door ${authorityPhrase(authority)}.`);
}

export async function announcePlayerFreedBy(
  actorId: number,
  targetId: number,
  kind: 'buyout' | 'jailbreak',
): Promise<void> {
  if ((await isNpcPlayerId(actorId)) || (await isNpcPlayerId(targetId))) {
    return;
  }
  const [actor, target] = await Promise.all([
    prisma.player.findUnique({
      where: { id: actorId },
      select: { username: true },
    }),
    prisma.player.findUnique({
      where: { id: targetId },
      select: { username: true },
    }),
  ]);
  if (!actor?.username || !target?.username) {
    return;
  }
  const actorName = safeName(actor.username);
  const targetName = safeName(target.username);
  if (kind === 'buyout') {
    await post(`${actorName} heeft ${targetName} uit de gevangenis gekocht.`);
    return;
  }
  await post(`${actorName} heeft ${targetName} uit de gevangenis gehaald.`);
}
