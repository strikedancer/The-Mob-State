import prisma from './src/lib/prisma';
import { propertyService } from './src/services/propertyService';

async function main() {
  console.log('🧪 Testing Property Overlay Keys\n');

  try {
    // Find test player
    let testPlayer = await prisma.player.findFirst({
      where: { username: 'testuser2' }
    });

    if (!testPlayer) {
      console.log('Creating test player...');
      testPlayer = await prisma.player.create({
        data: {
          username: 'overlay_test_' + Date.now(),
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

    console.log(`✅ Test player: ${testPlayer.username} (ID: ${testPlayer.id})\n`);

    // Clean up existing properties
    await prisma.property.deleteMany({
      where: { playerId: testPlayer.id }
    });

    // TEST 1: New property (should have 'new' overlay)
    console.log('TEST 1: New property (< 1 hour old)');
    console.log('='.repeat(60));
    
    const newProperty = await prisma.property.create({
      data: {
        playerId: testPlayer.id,
        propertyId: 'warehouse_1_NL',
        countryId: 'NL',
        propertyType: 'warehouse',
        purchasePrice: 100000,
        upgradeLevel: 1,
        purchasedAt: new Date(), // Just now
        lastIncomeAt: new Date()
      }
    });

    let ownedProperties = await propertyService.getOwnedProperties(testPlayer.id);
    console.log(`Property: ${ownedProperties[0].name}`);
    console.log(`Overlays: ${JSON.stringify(ownedProperties[0].overlayKeys)}`);
    console.log(`Expected: ["new"]`);
    
    if (ownedProperties[0].overlayKeys.includes('new')) {
      console.log('✅ TEST 1 PASSED\n');
    } else {
      console.log('❌ TEST 1 FAILED\n');
    }

    // TEST 2: Upgraded property (should have 'upgraded_lvl3' overlay)
    console.log('TEST 2: Upgraded property (level 3)');
    console.log('='.repeat(60));
    
    await prisma.property.update({
      where: { id: newProperty.id },
      data: { 
        upgradeLevel: 3,
        purchasedAt: new Date(Date.now() - 2 * 60 * 60 * 1000) // 2 hours ago
      }
    });

    ownedProperties = await propertyService.getOwnedProperties(testPlayer.id);
    console.log(`Property: ${ownedProperties[0].name}`);
    console.log(`Overlays: ${JSON.stringify(ownedProperties[0].overlayKeys)}`);
    console.log(`Expected: ["upgraded_lvl3"]`);
    
    if (ownedProperties[0].overlayKeys.includes('upgraded_lvl3') && 
        !ownedProperties[0].overlayKeys.includes('new')) {
      console.log('✅ TEST 2 PASSED\n');
    } else {
      console.log('❌ TEST 2 FAILED\n');
    }

    // TEST 3: Income ready (lastIncomeAt > incomeInterval)
    console.log('TEST 3: Income ready for collection');
    console.log('='.repeat(60));
    
    // Set lastIncomeAt to 2 hours ago (warehouse income interval is 60 minutes)
    await prisma.property.update({
      where: { id: newProperty.id },
      data: { 
        lastIncomeAt: new Date(Date.now() - 120 * 60 * 1000), // 120 minutes ago
        upgradeLevel: 1 // Reset to level 1
      }
    });

    ownedProperties = await propertyService.getOwnedProperties(testPlayer.id);
    console.log(`Property: ${ownedProperties[0].name}`);
    console.log(`Overlays: ${JSON.stringify(ownedProperties[0].overlayKeys)}`);
    console.log(`Expected: ["income_ready"]`);
    
    if (ownedProperties[0].overlayKeys.includes('income_ready')) {
      console.log('✅ TEST 3 PASSED\n');
    } else {
      console.log('❌ TEST 3 FAILED\n');
    }

    // TEST 4: Multiple overlays (upgraded + income ready)
    console.log('TEST 4: Multiple overlays (upgraded + income ready)');
    console.log('='.repeat(60));
    
    await prisma.property.update({
      where: { id: newProperty.id },
      data: { 
        upgradeLevel: 2,
        lastIncomeAt: new Date(Date.now() - 120 * 60 * 1000), // 120 minutes ago
        purchasedAt: new Date(Date.now() - 5 * 60 * 60 * 1000) // 5 hours ago
      }
    });

    ownedProperties = await propertyService.getOwnedProperties(testPlayer.id);
    console.log(`Property: ${ownedProperties[0].name}`);
    console.log(`Overlays: ${JSON.stringify(ownedProperties[0].overlayKeys)}`);
    console.log(`Expected: ["upgraded_lvl2", "income_ready"]`);
    
    if (ownedProperties[0].overlayKeys.includes('upgraded_lvl2') &&
        ownedProperties[0].overlayKeys.includes('income_ready') &&
        !ownedProperties[0].overlayKeys.includes('new')) {
      console.log('✅ TEST 4 PASSED\n');
    } else {
      console.log('❌ TEST 4 FAILED\n');
    }

    // TEST 5: No overlays (recent income, level 1, old property)
    console.log('TEST 5: No overlays');
    console.log('='.repeat(60));
    
    await prisma.property.update({
      where: { id: newProperty.id },
      data: { 
        upgradeLevel: 1,
        lastIncomeAt: new Date(), // Just collected
        purchasedAt: new Date(Date.now() - 24 * 60 * 60 * 1000) // 24 hours ago
      }
    });

    ownedProperties = await propertyService.getOwnedProperties(testPlayer.id);
    console.log(`Property: ${ownedProperties[0].name}`);
    console.log(`Overlays: ${JSON.stringify(ownedProperties[0].overlayKeys)}`);
    console.log(`Expected: []`);
    
    if (ownedProperties[0].overlayKeys.length === 0) {
      console.log('✅ TEST 5 PASSED\n');
    } else {
      console.log('❌ TEST 5 FAILED\n');
    }

    // Clean up
    await prisma.property.deleteMany({
      where: { playerId: testPlayer.id }
    });

    console.log('═'.repeat(60));
    console.log('✅ ALL OVERLAY TESTS COMPLETED!');
    console.log('═'.repeat(60));

  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
