/**
 * Test script for Phase 6.4: Crew Liquidations
 */

const BASE_URL = 'http://localhost:3000';

// Test users
const testUsers = [
  // Weak crew
  { username: 'weak_leader', password: 'test123', token: null, id: null },
  { username: 'weak_member1', password: 'test123', token: null, id: null },
  
  // Strong attacker
  { username: 'strong_attacker', password: 'test123', token: null, id: null },
  
  // Same level user (should fail)
  { username: 'same_level', password: 'test123', token: null, id: null },
];

let weakCrewId = null;

async function request(method, path, body = null, token = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  if (token) {
    options.headers['Authorization'] = `Bearer ${token}`;
  }

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(`${BASE_URL}${path}`, options);
  const data = await response.json();
  return { status: response.status, data };
}

async function registerUser(user) {
  const { data } = await request('POST', '/auth/register', {
    username: user.username,
    password: user.password,
  });

  if (data.token) {
    user.token = data.token;
    user.id = data.player.id;
  } else {
    // Already exists, login
    const loginRes = await request('POST', '/auth/login', {
      username: user.username,
      password: user.password,
    });
    user.token = loginRes.data.token;
    user.id = loginRes.data.player.id;
  }
}

async function setPlayerRank(userId, rank, token) {
  // Direct update via database would be needed, for now we'll just note this
  console.log(`  📝 Note: Manually set player ${userId} to rank ${rank}`);
}

async function setupTestEnvironment() {
  console.log('🔧 Setup: Creating test environment...');

  // Register all users
  for (const user of testUsers) {
    await registerUser(user);
    console.log(`  ✅ ${user.username} registered (ID: ${user.id})`);
  }

  // Check if weak leader already has a crew
  const existingCrewRes = await request('GET', '/crews/mine', null, testUsers[0].token);
  
  if (existingCrewRes.status === 200 && existingCrewRes.data.params.crew) {
    // Use existing crew
    weakCrewId = existingCrewRes.data.params.crew.id;
    console.log(`  ✅ Using existing crew: ID ${weakCrewId}`);
  } else {
    // Create new crew
    const createRes = await request(
      'POST',
      '/crews/create',
      { name: 'Weak Crew Test' },
      testUsers[0].token,
    );

    if (createRes.status === 201) {
      weakCrewId = createRes.data.params.crew.id;
      console.log(`  ✅ New crew created: ID ${weakCrewId}`);
    } else {
      console.log('  ❌ Failed to create crew:', createRes.data);
      return;
    }
  }

  // Add member to crew (might already be in crew)
  const joinRes = await request('POST', `/crews/${weakCrewId}/join`, {}, testUsers[1].token);
  if (joinRes.status === 200) {
    console.log(`  ✅ Member joined weak crew`);
  } else if (joinRes.data.event === 'error.already_in_crew') {
    console.log(`  ⚠️  Member already in crew`);
  }

  // Add some money to crew bank (via heist would be ideal, but we'll simulate)
  console.log(`  📝 Note: Crew bank would need to be populated via heists or manual DB update`);

  console.log();
}

async function testLiquidateInsufficientPower() {
  console.log('🚫 Test: Liquidate with insufficient power...');

  // Same level user tries to liquidate (should fail)
  const { status, data } = await request(
    'POST',
    `/crews/${weakCrewId}/liquidate`,
    {},
    testUsers[3].token,
  );

  if (status === 403 && data.event === 'error.insufficient_power') {
    console.log('  ✅ Insufficient power correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 403 insufficient_power, got:`, data);
  }
}

async function testLiquidateOwnCrew() {
  console.log('\n🚫 Test: Try to liquidate own crew...');

  const { status, data } = await request(
    'POST',
    `/crews/${weakCrewId}/liquidate`,
    {},
    testUsers[0].token, // Weak leader trying to liquidate own crew
  );

  if (status === 400 && data.event === 'error.cannot_liquidate_own_crew') {
    console.log('  ✅ Cannot liquidate own crew correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 400 cannot_liquidate_own_crew, got:`, data);
  }
}

async function testLiquidateNonExistentCrew() {
  console.log('\n🚫 Test: Liquidate non-existent crew...');

  const { status, data } = await request(
    'POST',
    `/crews/99999/liquidate`,
    {},
    testUsers[2].token,
  );

  if (status === 404 && data.event === 'error.crew_not_found') {
    console.log('  ✅ Non-existent crew correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 404 crew_not_found, got:`, data);
  }
}

async function testSuccessfulLiquidation() {
  console.log('\n💥 Test: Successful crew liquidation...');
  console.log('  ⚠️  NOTE: This requires strong_attacker to be 5+ levels higher than weak_leader');
  console.log('  ⚠️  In a real test, you would need to:');
  console.log('     1. Set weak_leader rank to 1');
  console.log('     2. Set strong_attacker rank to 6+ (difference >= 5)');
  console.log('     3. Add money to crew bank via heists or DB update');
  console.log();
  console.log('  Attempting liquidation anyway (will likely fail with insufficient_power)...');

  const { status, data } = await request(
    'POST',
    `/crews/${weakCrewId}/liquidate`,
    {},
    testUsers[2].token, // Strong attacker
  );

  if (status === 200 && data.event === 'crew.liquidated') {
    console.log('  ✅ Crew successfully liquidated!');
    console.log(`     Crew name: ${data.params.crewName}`);
    console.log(`     Assets seized: €${data.params.assetsSeized}`);
    console.log(`     Members disbanded: ${data.params.memberCount}`);
    console.log(`     Former leader: ${data.params.leaderName}`);
  } else if (status === 403 && data.event === 'error.insufficient_power') {
    console.log('  ⚠️  Liquidation blocked: Insufficient power');
    console.log('     (This is expected if rank difference < 5)');
  } else {
    console.log(`  ❌ Unexpected result: Status ${status}`, data);
  }
}

async function testWorldEventCreated() {
  console.log('\n📡 Test: Check world events feed...');

  const { status, data } = await request('GET', '/events');

  if (status === 200 && data.params && data.params.events) {
    const liquidationEvents = data.params.events.filter(
      (e) => e.eventKey === 'crew.liquidated',
    );
    if (liquidationEvents.length > 0) {
      console.log(`  ✅ Found ${liquidationEvents.length} liquidation event(s) in feed`);
      const latest = liquidationEvents[0];
      console.log(`     Latest: ${latest.params.attackerName} liquidated ${latest.params.crewName}`);
    } else {
      console.log('  ⚠️  No liquidation events found (crew may not have been liquidated yet)');
    }
  } else {
    console.log(`  ⚠️  Events feed check skipped or empty`);
  }
}

async function runTests() {
  console.log('🎮 CREW LIQUIDATIONS TEST SUITE\n');
  console.log('='.repeat(50));

  try {
    await setupTestEnvironment();
    await testLiquidateOwnCrew();
    await testLiquidateInsufficientPower();
    await testLiquidateNonExistentCrew();
    await testSuccessfulLiquidation();
    await testWorldEventCreated();

    console.log('\n' + '='.repeat(50));
    console.log('✅ ALLE LIQUIDATION TESTS VOLTOOID');
    console.log('\n📝 MANUAL TESTING REQUIRED:');
    console.log('   To fully test successful liquidation:');
    console.log('   1. Update player ranks in database:');
    console.log('      UPDATE players SET rank = 1 WHERE username = "weak_leader";');
    console.log('      UPDATE players SET rank = 10 WHERE username = "strong_attacker";');
    console.log('   2. Add money to crew bank:');
    console.log(`      UPDATE crews SET bankBalance = 50000 WHERE id = ${weakCrewId};`);
    console.log('   3. Re-run the successful liquidation test');
  } catch (error) {
    console.error('\n❌ TEST FOUT:', error.message);
    process.exit(1);
  }
}

// Run tests
runTests();
