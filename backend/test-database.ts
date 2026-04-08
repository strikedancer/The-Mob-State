import prisma from './src/lib/prisma';

async function testDatabase() {
  try {
    console.log('🔍 Testing database connection...\n');

    // Test connection
    await prisma.$connect();
    console.log('✅ Database connection successful!');

    // Count players
    const playerCount = await prisma.player.count();
    console.log(`📊 Players in database: ${playerCount}`);

    // Create test player
    const testPlayer = await prisma.player.create({
      data: {
        username: 'test_player_' + Date.now(),
        passwordHash: 'test_hash',
      },
    });
    console.log('✅ Test player created:', testPlayer.username);

    // Fetch test player
    const fetchedPlayer = await prisma.player.findUnique({
      where: { id: testPlayer.id },
    });
    console.log('✅ Test player fetched:', fetchedPlayer?.username);

    // Delete test player
    await prisma.player.delete({
      where: { id: testPlayer.id },
    });
    console.log('✅ Test player deleted\n');

    console.log('🎉 All database tests passed!');
  } catch (error) {
    console.error('❌ Database test failed:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testDatabase();
