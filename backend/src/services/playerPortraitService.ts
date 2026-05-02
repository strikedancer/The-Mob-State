import fs from 'fs/promises';
import path from 'path';
import { randomUUID } from 'crypto';
import prisma from '../lib/prisma';
import {
  MAX_PLAYER_PORTRAITS,
  PORTRAIT_SELFIE_CREDIT_COST,
  SELFIE_MAX_BYTES,
} from '../constants/playerPortrait';
import { generateGangsterPortraitFromSelfie } from './playerPortraitLeonardo';
import { activePortraitPathFromRow } from '../utils/avatarDisplay';

/** Project-root `runtime/client-images` (served as `/images/...` on nginx). */
export function getRuntimeClientImagesRoot(): string {
  return path.join(__dirname, '../../../runtime/client-images');
}

export function absolutePathForPortraitImage(relativeUnderImages: string): string {
  const normalized = relativeUnderImages.replace(/^[/\\]+/, '').replace(/\\/g, '/');
  return path.join(getRuntimeClientImagesRoot(), ...normalized.split('/'));
}

export async function listPortraits(playerId: number) {
  return prisma.playerPortrait.findMany({
    where: { playerId },
    orderBy: { createdAt: 'desc' },
    select: { id: true, imagePath: true, createdAt: true },
  });
}

export async function createPortraitFromSelfie(
  playerId: number,
  selfieBuffer: Buffer,
  mimeType: string
): Promise<{
  portrait: { id: number; imagePath: string; createdAt: Date };
  premiumCredits: number;
  activePortraitId: number | null;
}> {
  if (selfieBuffer.length > SELFIE_MAX_BYTES) {
    const err = new Error('SELFIE_TOO_LARGE') as Error & { code?: string };
    err.code = 'SELFIE_TOO_LARGE';
    throw err;
  }

  const count = await prisma.playerPortrait.count({ where: { playerId } });
  if (count >= MAX_PLAYER_PORTRAITS) {
    const err = new Error('PORTRAIT_LIMIT') as Error & { code?: string };
    err.code = 'PORTRAIT_LIMIT';
    throw err;
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { premiumCredits: true },
  });
  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }
  if (player.premiumCredits < PORTRAIT_SELFIE_CREDIT_COST) {
    const err = new Error('INSUFFICIENT_CREDITS') as Error & {
      code?: string;
      available?: number;
      required?: number;
    };
    err.code = 'INSUFFICIENT_CREDITS';
    err.available = player.premiumCredits;
    err.required = PORTRAIT_SELFIE_CREDIT_COST;
    throw err;
  }

  const pngBuffer = await generateGangsterPortraitFromSelfie(selfieBuffer, mimeType);

  const fileId = randomUUID();
  const relativePath = `player_avatars/${playerId}/${fileId}.png`;
  const absFile = absolutePathForPortraitImage(relativePath);

  await fs.mkdir(path.dirname(absFile), { recursive: true });
  await fs.writeFile(absFile, pngBuffer);

  try {
    const result = await prisma.$transaction(async (tx) => {
      const portrait = await tx.playerPortrait.create({
        data: {
          playerId,
          imagePath: relativePath,
        },
      });

      const updated = await tx.player.update({
        where: { id: playerId },
        data: {
          premiumCredits: { decrement: PORTRAIT_SELFIE_CREDIT_COST },
          activePortraitId: portrait.id,
        },
        select: {
          premiumCredits: true,
          activePortraitId: true,
        },
      });

      return { portrait, updated };
    });

    return {
      portrait: {
        id: result.portrait.id,
        imagePath: result.portrait.imagePath,
        createdAt: result.portrait.createdAt,
      },
      premiumCredits: result.updated.premiumCredits,
      activePortraitId: result.updated.activePortraitId,
    };
  } catch (e) {
    try {
      await fs.unlink(absFile);
    } catch {
      /* ignore */
    }
    throw e;
  }
}

export async function selectPortrait(playerId: number, portraitId: number | null) {
  if (portraitId === null) {
    await prisma.player.update({
      where: { id: playerId },
      data: { activePortraitId: null },
    });
    return;
  }

  const row = await prisma.playerPortrait.findFirst({
    where: { id: portraitId, playerId },
  });
  if (!row) {
    const err = new Error('PORTRAIT_NOT_FOUND') as Error & { code?: string };
    err.code = 'PORTRAIT_NOT_FOUND';
    throw err;
  }

  await prisma.player.update({
    where: { id: playerId },
    data: { activePortraitId: portraitId },
  });
}

export async function deletePortrait(playerId: number, portraitId: number) {
  const row = await prisma.playerPortrait.findFirst({
    where: { id: portraitId, playerId },
  });
  if (!row) {
    const err = new Error('PORTRAIT_NOT_FOUND') as Error & { code?: string };
    err.code = 'PORTRAIT_NOT_FOUND';
    throw err;
  }

  const abs = absolutePathForPortraitImage(row.imagePath);

  await prisma.$transaction(async (tx) => {
    await tx.player.updateMany({
      where: { id: playerId, activePortraitId: portraitId },
      data: { activePortraitId: null },
    });
    await tx.playerPortrait.delete({ where: { id: portraitId } });
  });

  try {
    await fs.unlink(abs);
  } catch {
    /* file may already be missing */
  }
}

export function serializePlayerAvatarFields(p: {
  avatar: string | null;
  activePortraitId: number | null;
  activePortrait: { imagePath: string } | null | undefined;
  premiumCredits?: number;
}) {
  return {
    avatar: p.avatar,
    activePortraitId: p.activePortraitId,
    activePortraitPath: activePortraitPathFromRow(p.activePortrait?.imagePath ?? null),
    ...(p.premiumCredits !== undefined ? { premiumCredits: p.premiumCredits } : {}),
  };
}
