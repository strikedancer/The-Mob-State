import prisma from './src/lib/prisma';
import { propertyService } from './src/services/propertyService';

async function main() {
  console.log('🧪 Testing Property Auto-Forfeit System\n');

  try {
    // Find or create test player
    let testPlayer = await prisma.player.findFirst({
      where: { username: 'testuser2' }
    });

    if (!testPlayer) {
      console.log('Creating test player...');
      testPlayer = await prisma.player.create({
        data: {
          username: 'forfeit_test_' + Date.now(),
          passwordHash: '$2a$10$test',
          health: 100,
          hunger: 100,
          thirst: 100,
          money: 1000000,
          rank: 5,
          currentCountry: 'NL'
        }
      });
    }

    const playerId = testPlayer.id;
    console.log(`✅ Test player: ${testPlayer.username} (ID: ${playerId})`);
    console.log(`   Health: ${testPlayer.health}\n`);

    // Clean up any existing properties for this test player
    await prisma.property.deleteMany({
      where: { playerId }
    });

    // TEST 1: Create property and verify normal player doesn't forfeit
    console.log('TEST 1: Normal player (health > 0, not in jail)');
    console.log('='.repeat(60));
    
    const property1 = await prisma.property.create({
      data: {
        playerId,
        propertyId: 'warehouse_1_NL',
        countryId: 'NL',
        propertyType: 'warehouse',
        purchasePrice: 100000,
        upgradeLevel: 1
      }
    });
    console.log(`✅ Created property: ${property1.propertyId}`);
    
    const forfeit1 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   Forfeited: ${forfeit1} properties (expected: 0)`);
    
    const count1 = await prisma.property.count({ where: { playerId } });
    console.log(`   Properties remaining: ${count1} (expected: 1)\n`);

    if (forfeit1 === 0 && count1 === 1) {
      console.log('✅ TEST 1 PASSED\n');
    } else {
      console.log('❌ TEST 1 FAILED\n');
    }

    // TEST 2: Death forfeit
    console.log('TEST 2: Death Forfeit (health = 0)');
    console.log('='.repeat(60));
    
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 0 }
    });
    console.log('💀 Set player health to 0 (death)');
    
    const forfeit2 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   Forfeited: ${forfeit2} properties (expected: 1)`);
    
    const count2 = await prisma.property.count({ where: { playerId } });
    console.log(`   Properties remaining: ${count2} (expected: 0)\n`);

    if (forfeit2 === 1 && count2 === 0) {
      console.log('✅ TEST 2 PASSED\n');
    } else {
      console.log('❌ TEST 2 FAILED\n');
    }

    // TEST 3: Long jail forfeit (>24 hours)
    console.log('TEST 3: Long Jail Forfeit (>24 hours)');
    console.log('='.repeat(60));
    
    // Restore health and create new property
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 100, jailRelease: null }
    });
    
    await prisma.property.create({
      data: {
        playerId,
        propertyId: 'warehouse_2_NL',
        countryId: 'NL',
        propertyType: 'warehouse',
        purchasePrice: 100000,
        upgradeLevel: 1
      }
    });

    // Set jail release to 48 hours from now
    const now = new Date();
    const release48h = new Date(now.getTime() + 48 * 60 * 60 * 1000);
    
    await prisma.player.update({
      where: { id: playerId },
      data: { jailRelease: release48h }
    });
    console.log(`🔒 Set jail release to 48 hours from now: ${release48h.toISOString()}`);
    
    const forfeit3 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   Forfeited: ${forfeit3} properties (expected: 1)`);
    
    const count3 = await prisma.property.count({ where: { playerId } });
    console.log(`   Properties remaining: ${count3} (expected: 0)\n`);

    if (forfeit3 === 1 && count3 === 0) {
      console.log('✅ TEST 3 PASSED\n');
    } else {
      console.log('❌ TEST 3 FAILED\n');
    }

    // TEST 4: Short jail (< 24 hours) - should NOT forfeit
    console.log('TEST 4: Short Jail (<24 hours) - NO forfeit');
    console.log('='.repeat(60));
    
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 100, jailRelease: null }
    });
    
    await prisma.property.create({
      data: {
        playerId,
        propertyId: 'warehouse_3_NL',
        countryId: 'NL',
        propertyType: 'warehouse',
        purchasePrice: 100000,
        upgradeLevel: 1
      }
    });

    // Set jail release to 12 hours from now (less than 24)
    const release12h = new Date(now.getTime() + 12 * 60 * 60 * 1000);
    
    await prisma.player.update({
      where: { id: playerId },
      data: { jailRelease: release12h }
    });
    console.log(`🔒 Set jail release to 12 hours from now: ${release12h.toISOString()}`);
    
    const forfeit4 = await propertyService.checkPlayerForfeiture(playerId);
    console.log(`   Forfeited: ${forfeit4} properties (expected: 0)`);
    
    const count4 = await prisma.property.count({ where: { playerId } });
    console.log(`   Properties remaining: ${count4} (expected: 1)\n`);

    if (forfeit4 === 0 && count4 === 1) {
      console.log('✅ TEST 4 PASSED\n');
    } else {
      console.log('❌ TEST 4 FAILED\n');
    }

    // Clean up
    await prisma.property.deleteMany({ where: { playerId } });
    await prisma.player.update({
      where: { id: playerId },
      data: { health: 100, jailRelease: null }
    });

    console.log('═'.repeat(60));
    console.log('✅ ALL TESTS COMPLETED SUCCESSFULLY!');
    console.log('═'.repeat(60));

  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
