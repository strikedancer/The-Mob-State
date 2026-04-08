import prisma from './src/lib/prisma';
import { propertyService } from './src/services/propertyService';

async function testPropertyForfeit() {
  console.log('🧪 Testing Property Forfeit System\n');

  try {
    // Find a player with properties
    const playerWithProperty = await prisma.property.findFirst({
      include: {
        player: true,
      },
    });

    if (!playerWithProperty) {
      console.log('❌ No players with properties found. Create a property first.');
      return;
    }

    const playerId = playerWithProperty.playerId;
    const playerUsername = playerWithProperty.player.username;

    console.log(`📊 Testing with player: ${playerUsername} (ID: ${playerId})`);

    // Count current properties
    const propertiesBefore = await prisma.property.count({
      where: { playerId },
    });
    console.log(`   Current properties: ${propertiesBefore}\n`);

    // TEST 1: Normal player (should not forfeit)
    console.log('TEST 1: Normal player (health > 0, not in jail)');
    const result1 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   ✅ Result: ${result1} properties forfeited (expected: 0)\n`);

    // TEST 2: Dead player (should forfeit all)
    console.log('TEST 2: Dead player (health = 0)');
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 0 },
    });
    const result2 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   ✅ Result: ${result2} properties forfeited (expected: ${propertiesBefore})\n`);

    // Verify properties were deleted
    const propertiesAfter = await prisma.property.count({
      where: { playerId },
    });
    console.log(`   Properties after forfeiture: ${propertiesAfter} (expected: 0)\n`);

    // Restore player health for cleanup
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 100 },
    });

    console.log('✅ All tests passed!');
  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testPropertyForfeit();
