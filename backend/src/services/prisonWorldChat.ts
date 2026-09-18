import prisma from '../lib/prisma';
import { globalChatService } from './globalChatService';
import { isNpcPlayerId } from './npcLookup';

const SYSTEM_NAME = 'Gevangenis';
const JAIL_ANNOUNCE_DEDUPE_MS = 60_000;
const lastJailAnnounceAt = new Map<number, number>();

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

export function formatJailDurationNl(minutesRaw: number): string {
  const minutes = Math.max(1, Math.round(Number(minutesRaw) || 0));
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;
  if (hours <= 0) {
    return minutes === 1 ? '1 minuut' : `${minutes} minuten`;
  }
  const hourPart = hours === 1 ? '1 uur' : `${hours} uur`;
  if (rest === 0) return hourPart;
  const minPart = rest === 1 ? '1 minuut' : `${rest} minuten`;
  return `${hourPart} en ${minPart}`;
}

export function buildJailAnnouncement(
  username: string,
  authority?: string,
  jailTimeMinutes?: number,
): string {
  const name = safeName(username);
  const duration =
    jailTimeMinutes != null && jailTimeMinutes > 0
      ? ` voor ${formatJailDurationNl(jailTimeMinutes)}`
      : '';
  const key = (authority ?? '').toLowerCase();
  if (key.includes('black_money') || key.includes('zwart')) {
    return `${name} is opgepakt wegens zwart geld${duration}.`;
  }
  return `${name} is opgepakt door ${authorityPhrase(authority)}${duration}.`;
}

async function post(message: string): Promise<void> {
  try {
    await globalChatService.sendSystemAnnouncement(SYSTEM_NAME, message);
  } catch (error) {
    console.error('[PrisonWorldChat] failed to post:', error);
  }
}

function claimJailAnnounceSlot(playerId: number): boolean {
  const now = Date.now();
  const previous = lastJailAnnounceAt.get(playerId) ?? 0;
  if (now - previous < JAIL_ANNOUNCE_DEDUPE_MS) {
    return false;
  }
  lastJailAnnounceAt.set(playerId, now);
  return true;
}

export async function announcePlayerJailed(
  playerId: number,
  authority?: string,
  jailTimeMinutes?: number,
): Promise<void> {
  if (!claimJailAnnounceSlot(playerId)) {
    return;
  }
  if (await isNpcPlayerId(playerId)) {
    return;
  }
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { username: true, jailRelease: true },
  });
  if (!player?.username) {
    return;
  }
  let minutes = Number(jailTimeMinutes);
  if (!Number.isFinite(minutes) || minutes <= 0) {
    const until = player.jailRelease?.getTime() ?? 0;
    if (until > Date.now()) {
      minutes = Math.max(1, Math.round((until - Date.now()) / 60000));
    }
  }
  if (!Number.isFinite(minutes) || minutes <= 0) {
    const latest = await prisma.crimeAttempt.findFirst({
      where: { playerId, jailed: true, jailTime: { gt: 0 } },
      orderBy: { createdAt: 'desc' },
      select: { jailTime: true },
    });
    if (latest?.jailTime) {
      minutes = latest.jailTime;
    }
  }
  await post(
    buildJailAnnouncement(
      player.username,
      authority,
      Number.isFinite(minutes) && minutes > 0 ? minutes : undefined,
    ),
  );
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
