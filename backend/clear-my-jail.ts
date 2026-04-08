/**
 * Clear jail status for current player
 * Sets all jail attempts to expired (1 minute jail, created 1 hour ago)
 */

import prisma from './src/lib/prisma';

async function clearJail() {
  const username = 'testplayer'; // Change this to your username if different

  // Get player
  const player = await prisma.player.findUnique({
    where: { username },
    select: { id: true, username: true },
  });

  if (!player) {
    console.log('❌ Player not found');
    await prisma.$disconnect();
    return;
  }

  console.log(`🔓 Clearing jail for: ${player.username} (ID: ${player.id})`);

  // Set all jail attempts to expired (1 hour ago + 1 min = already released)
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);

  const result = await prisma.crimeAttempt.updateMany({
    where: {
      playerId: player.id,
      jailed: true,
    },
    data: {
      createdAt: oneHourAgo,
      jailTime: 1, // 1 minute, but created 1 hour ago = expired
    },
  });

  console.log(`✅ Cleared ${result.count} jail records`);
  console.log('   You are now free! 🎉');
  
  await prisma.$disconnect();
}

clearJail().catch(console.error);
