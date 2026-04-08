import prisma from './src/lib/prisma.js';
import backpackService from './src/services/backpackService.js';

async function runTests() {
  console.log('🧪 Testing Backpack System\n');
  
  try {
    // Test 1: Load all backpacks
    console.log('📦 Test 1: Getting all backpacks...');
    const allBackpacks = backpackService.getAllBackpacks();
    console.log(`✅ Found ${allBackpacks.length} backpacks`);
    allBackpacks.forEach(bp => {
      console.log(`   - ${bp.name} (${bp.id}): €${bp.price}, +${bp.slots} slots, Rank ${bp.requiredRank}`);
    });

    // Test 2: Get a test player
    console.log('\n👥 Test 2: Finding test player...');
    const players = await prisma.player.findMany({ take: 1 });
    if (players.length > 0) {
      const player = players[0];
      console.log(`✅ Found player: ${player.username} (ID: ${player.id})`);
      console.log(`   Rank: ${player.rank}, Money: €${player.money}`);

      // Test 3: Check player backpack
      console.log('\n🎒 Test 3: Checking player backpack...');
      const playerBackpack = await backpackService.getPlayerBackpack(player.id);
      if (playerBackpack) {
        console.log(`✅ Player has: ${playerBackpack.backpack?.name}`);
      } else {
        console.log('ℹ️  Player has no backpack yet');
      }

      // Test 4: Check carrying capacity
      console.log('\n📊 Test 4: Checking carrying capacity...');
      const capacity = await backpackService.getPlayerCarryingCapacity(player.id);
      console.log(`✅ Carrying capacity: ${capacity} slots`);

      // Test 5: Get available backpacks for player
      console.log('\n🛍️ Test 5: Getting available backpacks for player...');
      const available = await backpackService.getAvailableBackpacks(player.id);
      console.log(`✅ Results:`);
      console.log(`   Owned: ${available.owned ? available.owned.name : 'None'}`);
      console.log(`   Available: ${available.available.length} backpacks`);
      console.log(`   Can upgrade: ${available.canUpgradeTo.length} backpacks`);
    } else {
      console.log('❌ No players found in database');
    }

    console.log('\n✅ All tests completed!');
  } catch (error) {
    console.error('❌ Test error:', error);
  } finally {
    await prisma.$disconnect();
    process.exit(0);
  }
}

runTests();
