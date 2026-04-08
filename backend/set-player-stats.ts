import prisma from './src/lib/prisma';

async function setPlayerStats() {
  console.log('🔧 Setting player stats for death test...\n');

  try {
    await prisma.player.update({
      where: { id: 5 },
      data: {
        hunger: 10,
        thirst: 10,
      },
    });

    console.log('✅ Player stats updated: hunger=10, thirst=10');
    console.log('   Run test-tick.ts twice to test death\n');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

setPlayerStats();
