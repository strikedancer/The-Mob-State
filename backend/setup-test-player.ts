import prisma from './src/lib/prisma';

async function setupPropertyTestUser() {
  console.log('🔧 Setting up property test user...\n');

  try {
    // Find user
    const user = await prisma.player.findUnique({
      where: { username: 'propertytest' },
    });

    if (!user) {
      console.log('❌ User not found. Run setup-property-test.js first');
      return;
    }

    // Give player money and rank
    await prisma.player.update({
      where: { id: user.id },
      data: {
        money: 500000, // €500k for testing
        rank: 20, // Level 20 to unlock most properties
      },
    });

    console.log('✅ Player updated:');
    console.log(`   Money: €500,000`);
    console.log(`   Rank: 20`);
    console.log('\n✅ Ready to test properties!\n');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

setupPropertyTestUser();
