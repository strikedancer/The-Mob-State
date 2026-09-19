import prisma from '../lib/prisma';
import { globalChatDiscordBridge } from '../services/globalChatDiscordBridge';
import { sanitizeSystemImageUrl } from '../services/globalChatService';

async function main(): Promise<void> {
  const rows = await prisma.globalChatMessage.findMany({
    where: {
      source: 'system',
      deletedAt: null,
      discordMessageId: null,
    },
    orderBy: { id: 'desc' },
    take: 20,
  });
  const results: Array<{ id: number; discordMessageId: string | null }> = [];
  for (const row of rows) {
    const imageUrl = sanitizeSystemImageUrl(row.imageUrl);
    const mirroredId = await globalChatDiscordBridge.mirrorGameMessage({
      id: row.id,
      playerId: row.playerId,
      displayName: row.displayName,
      source: 'system',
      message: row.message,
      stickerId: row.stickerId,
      stickerEmoji: null,
      imageUrl,
      createdAt: row.createdAt.toISOString(),
      staffRole: null,
      silent: false,
    });
    if (mirroredId) {
      await prisma.globalChatMessage.update({
        where: { id: row.id },
        data: { discordMessageId: mirroredId },
      });
    }
    results.push({ id: row.id, discordMessageId: mirroredId });
  }
  console.log(JSON.stringify({ remirrored: results }));
}

void main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
