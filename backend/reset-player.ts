import prisma from './src/lib/prisma';

async function resetPlayer() {
  await prisma.player.update({
    where: { id: 5 },
    data: { hunger: 100, thirst: 100, health: 100 },
  });
  console.log('✅ Player reset to full stats');
  await prisma.$disconnect();
}

resetPlayer();
