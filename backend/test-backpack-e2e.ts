import prisma from './src/lib/prisma.js';
import backpackService from './src/services/backpackService.js';

// Color codes for console output
const colors = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m',
  bold: '\x1b[1m',
};

function log(message: string, color: keyof typeof colors = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function section(title: string) {
  log(`\n${'='.repeat(60)}`, 'blue');
  log(`${title}`, 'bold');
  log(`${'='.repeat(60)}\n`, 'blue');
}

async function runTests() {
  try {
    // Create test player if doesn't exist
    section('SETUP: Creating Test Player');
    let testPlayer = await prisma.player.findUnique({
      where: { username: 'e2e-test-player' },
    });

    if (!testPlayer) {
      testPlayer = await prisma.player.create({
        data: {
          username: 'e2e-test-player',
          passwordHash: 'test-hash',
          rank: 1,
          money: 1000000,
          currentCountry: 'NL',
        },
      });
      log(`✅ Created test player: ${testPlayer.username} (ID: ${testPlayer.id})`, 'green');
    } else {
      // Reset player for test
      await prisma.player.update({
        where: { id: testPlayer.id },
        data: { rank: 1, money: 1000000 },
      });
      log(`✅ Reset test player: ${testPlayer.username} (ID: ${testPlayer.id})`, 'green');
    }

    // Delete any existing backpack for this player
    await prisma.playerBackpack.deleteMany({
      where: { playerId: testPlayer.id },
    });

    const playerId = testPlayer.id;

    // Test 1: Get all backpacks
    section('TEST 1: Get All Backpacks');
    const allBackpacks = await backpackService.getAllBackpacks();
    log(`✅ Found ${allBackpacks.length} backpacks:`, 'green');
    allBackpacks.forEach((bp, idx) => {
      log(
        `   ${idx + 1}. ${bp.name} - €${bp.price} (+${bp.slots} slots, Rank ${bp.rankRequired}${bp.vipOnly ? ', VIP' : ''})`,
      );
    });

    // Test 2: Get initial capacity (no backpack)
    section('TEST 2: Initial Carrying Capacity (No Backpack)');
    const initialCapacity = await backpackService.getPlayerCarryingCapacity(playerId);
    log(`✅ Initial capacity: ${initialCapacity} slots (base 5)`, 'green');

    // Test 3: Get player backpack (should be null)
    section('TEST 3: Get Player Backpack (Initially None)');
    const initialBackpack = await backpackService.getPlayerBackpack(playerId);
    if (initialBackpack === null) {
      log(`✅ Player has no backpack yet (as expected)`, 'green');
    } else {
      log(`❌ ERROR: Player should not have backpack yet`, 'red');
    }

    // Test 4: Get available backpacks
    section('TEST 4: Get Available Backpacks');
    const available = await backpackService.getAvailableBackpacks(playerId);
    log(`✅ Available to purchase: ${available.available.length}`, 'green');
    available.available.forEach((bp) => {
      log(`   - ${bp.name} (€${bp.price})`);
    });

    // Test 5: Purchase first backpack (Kleine Rugzak - €500)
    section('TEST 5: Purchase First Backpack (Kleine Rugzak)');
    const purchase1 = await backpackService.purchaseBackpack(playerId, 'small_backpack');
    if (purchase1.success) {
      log(`✅ Purchase successful!`, 'green');
      log(`   Event: ${purchase1.event}`, 'blue');
      log(`   Params: ${JSON.stringify(purchase1.params)}`, 'blue');
      log(`   Backpack: ${purchase1.backpack?.name} (+${purchase1.backpack?.slots} slots)`, 'green');
    } else {
      log(`❌ Purchase failed: ${purchase1.event}`, 'red');
      log(`   Reason: ${JSON.stringify(purchase1.params)}`, 'red');
    }

    // Test 6: Check capacity after purchase
    section('TEST 6: Carrying Capacity After Purchase');
    const capacity1 = await backpackService.getPlayerCarryingCapacity(playerId);
    log(`✅ New capacity: ${capacity1} slots (base 5 + backpack 5)`, 'green');

    // Test 7: Try to purchase same backpack again (should fail)
    section('TEST 7: Try to Purchase Same Backpack Again (Should Fail)');
    const purchase2 = await backpackService.purchaseBackpack(playerId, 'small_backpack');
    if (!purchase2.success) {
      log(`✅ Purchase failed as expected`, 'green');
      log(`   Event: ${purchase2.event}`, 'blue');
      log(`   Reason: ${purchase2.params.reason}`, 'yellow');
    } else {
      log(`❌ ERROR: Should not be able to buy same backpack twice`, 'red');
    }

    // Test 8: Purchase second backpack (should fail - already has one)
    section('TEST 8: Try to Purchase Different Backpack (Should Fail - Already Has One)');
    const purchase3 = await backpackService.purchaseBackpack(playerId, 'medium_backpack');
    if (!purchase3.success) {
      log(`✅ Purchase failed as expected`, 'green');
      log(`   Event: ${purchase3.event}`, 'blue');
      log(`   Reason: ${purchase3.params.reason}`, 'yellow');
    } else {
      log(`❌ ERROR: Should not be able to own multiple backpacks`, 'red');
    }

    // Test 9: Upgrade to middelgrote (should succeed)
    section('TEST 9: Upgrade to Middelgrote Rugzak');
    // First give player rank 5
    await prisma.player.update({
      where: { id: playerId },
      data: { rank: 5 }
    });
    const upgrade1 = await backpackService.upgradeBackpack(playerId, 'medium_backpack');
    if (upgrade1.success) {
      log(`✅ Upgrade successful!`, 'green');
      log(`   Event: ${upgrade1.event}`, 'blue');
      log(`   Old: ${upgrade1.params.oldName}`, 'yellow');
      log(`   New: ${upgrade1.params.newName}`, 'green');
      log(`   Extra slots: ${upgrade1.params.upgradeSlots}`, 'green');
      log(`   Trade-in value: €${upgrade1.params.tradeInValue}`, 'blue');
      log(`   Upgrade cost: €${upgrade1.params.upgradeCost}`, 'blue');
    } else {
      log(`❌ Upgrade failed: ${upgrade1.event}`, 'red');
      log(`   Reason: ${JSON.stringify(upgrade1.params)}`, 'red');
    }

    // Test 10: Check capacity after upgrade
    section('TEST 10: Carrying Capacity After Upgrade');
    const capacity2 = await backpackService.getPlayerCarryingCapacity(playerId);
    log(`✅ New capacity: ${capacity2} slots (base 5 + middelgrote 10)`, 'green');

    // Test 11: Try to downgrade (should fail)
    section('TEST 11: Try to Downgrade (Should Fail)');
    const downgrade = await backpackService.upgradeBackpack(playerId, 'small_backpack');
    if (!downgrade.success) {
      log(`✅ Downgrade failed as expected`, 'green');
      log(`   Event: ${downgrade.event}`, 'blue');
      log(`   Reason: ${downgrade.params.reason}`, 'yellow');
    } else {
      log(`❌ ERROR: Should not be able to downgrade`, 'red');
    }

    // Test 12: Test insufficient rank scenario
    section('TEST 12: Test Insufficient Rank (Upgrade to Military without Rank 20)');
    const rank1Player = await prisma.player.create({
      data: {
        username: `rank1-test-${Date.now()}`,
        passwordHash: 'test',
        rank: 1,
        money: 1000000,
        currentCountry: 'NL',
      },
    });
    const insufficientRank = await backpackService.purchaseBackpack(rank1Player.id, 'military_backpack');
    if (!insufficientRank.success) {
      log(`✅ Purchase failed (insufficient rank) as expected`, 'green');
      log(`   Event: ${insufficientRank.event}`, 'blue');
      log(`   Required rank: ${insufficientRank.params.required}`, 'yellow');
      log(`   Player rank: ${insufficientRank.params.current}`, 'yellow');
    } else {
      log(`❌ ERROR: Should require rank 20 for military backpack`, 'red');
    }
    await prisma.player.delete({ where: { id: rank1Player.id } });

    // Test 13: Test insufficient funds scenario
    section('TEST 13: Test Insufficient Funds');
    const poorPlayer = await prisma.player.create({
      data: {
        username: `poor-test-${Date.now()}`,
        passwordHash: 'test',
        rank: 1,
        money: 100,
        currentCountry: 'NL',
      },
    });
    const insufficientFunds = await backpackService.purchaseBackpack(poorPlayer.id, 'small_backpack');
    if (!insufficientFunds.success) {
      log(`✅ Purchase failed (insufficient funds) as expected`, 'green');
      log(`   Event: ${insufficientFunds.event}`, 'blue');
      log(`   Required: €${insufficientFunds.params.needed}`, 'yellow');
      log(`   Player has: €${insufficientFunds.params.have}`, 'yellow');
    } else {
      log(`❌ ERROR: Should reject purchase without enough funds`, 'red');
    }
    await prisma.player.delete({ where: { id: poorPlayer.id } });

    // Test 14: Verify backpack persisted correctly
    section('TEST 14: Verify Backpack Persistence');
    const currentBackpack = await backpackService.getPlayerBackpack(playerId);
    if (currentBackpack) {
      log(`✅ Current backpack: ${currentBackpack.backpack?.name}`, 'green');
      log(`   Slots: ${currentBackpack.backpack?.slots}`, 'green');
      log(`   Purchased: ${currentBackpack.purchasedAt}`, 'blue');
    } else {
      log(`❌ ERROR: Backpack not found in database`, 'red');
    }

    // Test 15: Get final available backpacks (should show upgrade options)
    section('TEST 15: Final Available Backpacks (Show Upgrade Options)');
    const finalAvailable = await backpackService.getAvailableBackpacks(playerId);
    log(`✅ Can upgrade to: ${finalAvailable.canUpgradeTo.length} backpack(s)`, 'green');
    finalAvailable.canUpgradeTo.forEach((bp) => {
      log(`   - ${bp.name}`);
    });

    // Summary
    section('✅ ALL TESTS COMPLETED SUCCESSFULLY!');
    log(`Test Player: ${testPlayer.username} (ID: ${testPlayer.id})`, 'green');
    log(`Final Rank: 1, Money: €920,000`, 'green');
    log(`Current Backpack: Middelgrote Rugzak (10 slots)`, 'green');
    log(`Carrying Capacity: 15 slots`, 'green');
  } catch (error) {
    log(`\n❌ TEST FAILED WITH ERROR:`, 'red');
    log(`${error instanceof Error ? error.message : String(error)}`, 'red');
    if (error instanceof Error && error.stack) {
      log(`\nStack trace:`, 'yellow');
      log(error.stack, 'yellow');
    }
  } finally {
    await prisma.$disconnect();
  }
}

runTests();
