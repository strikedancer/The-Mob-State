/**
 * Test script for Phase 6.3: Crew Heists
 * Tests heist execution, reward splitting, and sabotage mechanics
 */

const BASE_URL = 'http://localhost:3000';

// Test users
const testUsers = [
  { username: 'heist_leader', password: 'test123', token: null, id: null },
  { username: 'heist_member1', password: 'test123', token: null, id: null },
  { username: 'heist_member2', password: 'test123', token: null, id: null },
];

let crewId = null;

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

async function setupCrewWithMembers() {
  console.log('🔧 Setup: Creating crew with members...');

  // Register all users
  for (const user of testUsers) {
    await registerUser(user);
    console.log(`  ✅ ${user.username} registered (ID: ${user.id})`);
  }

  // Clear jail status - delete all crime attempts for test users
  const userIds = testUsers.map((u) => u.id).filter((id) => id);
  if (userIds.length > 0) {
    // Direct database cleanup via API
    for (const user of testUsers) {
      await request('POST', `/hospital/${user.id}/release`, {}, user.token);
    }
  }
  console.log('  ✅ Cleared jail status');


  // Create crew
  const createRes = await request(
    'POST',
    '/crews/create',
    { name: 'Heist Test Crew' },
    testUsers[0].token,
  );

  if (createRes.status === 201) {
    crewId = createRes.data.params.crew.id;
    console.log(`  ✅ Crew created: ID ${crewId}`);
  } else if (createRes.data.event === 'error.crew_name_taken') {
    const myCrewRes = await request('GET', '/crews/mine', null, testUsers[0].token);
    crewId = myCrewRes.data.params.crew.id;
    console.log(`  ✅ Using existing crew: ID ${crewId}`);
  }

  // Add members to crew
  for (let i = 1; i < testUsers.length; i++) {
    const joinRes = await request(
      'POST',
      `/crews/${crewId}/join`,
      {},
      testUsers[i].token,
    );
    if (joinRes.status === 200) {
      console.log(`  ✅ ${testUsers[i].username} joined crew`);
    } else if (joinRes.data.event === 'error.already_in_crew') {
      console.log(`  ⚠️  ${testUsers[i].username} already in crew`);
    }
  }

  console.log();
}

async function testGetAllHeists() {
  console.log('📋 Test: Get all available heists...');

  const { status, data } = await request('GET', '/heists');

  if (status === 200 && data.event === 'heists.list') {
    console.log(`  ✅ Found ${data.params.heists.length} heists`);
    data.params.heists.slice(0, 3).forEach((h) => {
      console.log(
        `     - ${h.name} (${h.requiredMembers} members, €${h.basePayout})`,
      );
    });
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testGetHeistById() {
  console.log('\n🔍 Test: Get specific heist details...');

  const { status, data } = await request('GET', '/heists/corner_store_heist');

  if (status === 200 && data.event === 'heist.info') {
    console.log(`  ✅ Heist: ${data.params.heist.name}`);
    console.log(`     Required: ${data.params.heist.requiredMembers} members`);
    console.log(`     Payout: €${data.params.heist.basePayout}`);
    console.log(`     Success: ${data.params.heist.successRate}%`);
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testStartHeistNotInCrew() {
  console.log('\n🚫 Test: Start heist without crew...');

  // Register a user not in crew
  const loneWolf = {
    username: 'lone_wolf_test',
    password: 'test123',
    token: null,
    id: null,
  };
  await registerUser(loneWolf);

  const { status, data } = await request(
    'POST',
    '/heists/corner_store_heist/start',
    {},
    loneWolf.token,
  );

  if (status === 400 && data.event === 'error.not_in_crew') {
    console.log('  ✅ Not-in-crew correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 400 not_in_crew, got:`, data);
  }
}

async function testStartHeistNonLeader() {
  console.log('\n🚫 Test: Non-leader starts heist...');

  const { status, data } = await request(
    'POST',
    '/heists/corner_store_heist/start',
    {},
    testUsers[1].token, // Member, not leader
  );

  if (status === 403 && data.event === 'error.not_crew_leader') {
    console.log('  ✅ Non-leader correctly blocked');
  } else {
    console.log(`  ❌ FAILED: Expected 403 not_crew_leader, got:`, data);
  }
}

async function testSuccessfulHeist() {
  console.log('\n💰 Test: Execute successful heist...');

  // Start simple heist (high success rate: 80%)
  const { status, data } = await request(
    'POST',
    '/heists/corner_store_heist/start',
    {},
    testUsers[0].token,
  );

  if (status === 200) {
    if (data.event === 'heist.success' || data.event === 'heist.success_sabotaged') {
      console.log(`  ✅ Heist successful!`);
      console.log(`     Event: ${data.event}`);
      console.log(`     Payout per member: €${data.params.payout}`);
      console.log(`     XP gained: ${data.params.xpGained}`);
      if (data.params.sabotaged) {
        console.log(`     ⚠️  Sabotaged by player ${data.params.sabotagedBy}`);
      }
    } else if (data.event === 'heist.failure' || data.event === 'heist.failure_sabotaged') {
      console.log(`  ⚠️  Heist failed (RNG)`);
      console.log(`     Jail time: ${data.params.jailTime} minutes`);
      if (data.params.sabotaged) {
        console.log(`     Sabotaged by player ${data.params.sabotagedBy}`);
      }
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testInsufficientMembers() {
  console.log('\n🚫 Test: Heist with insufficient members...');

  // Try bank heist (requires 5 members, we only have 3)
  const { status, data } = await request(
    'POST',
    '/heists/bank_heist/start',
    {},
    testUsers[0].token,
  );

  if (status === 400 && data.event === 'error.insufficient_crew_members') {
    console.log('  ✅ Insufficient members correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 400 insufficient_crew_members, got:`, data);
  }
}

async function testInvalidHeist() {
  console.log('\n🚫 Test: Start non-existent heist...');

  const { status, data } = await request(
    'POST',
    '/heists/fake_heist_999/start',
    {},
    testUsers[0].token,
  );

  if (status === 404 && data.event === 'error.heist_not_found') {
    console.log('  ✅ Invalid heist correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 404 heist_not_found, got:`, data);
  }
}

async function testSabotageScenario() {
  console.log('\n🎲 Test: Sabotage mechanics...');

  // Set one member to very low trust (high sabotage chance)
  await request(
    'POST',
    `/crews/${crewId}/members/${testUsers[1].id}/trust`,
    { amount: -100 }, // Set to 0
    testUsers[0].token,
  );

  console.log('  ✅ Set member trust to 0 (50% sabotage chance)');
  console.log('  🎲 Running multiple heist attempts to test sabotage...');

  let sabotageCount = 0;
  let successCount = 0;
  let failureCount = 0;
  const attempts = 10;

  for (let i = 0; i < attempts; i++) {
    const { data } = await request(
      'POST',
      '/heists/corner_store_heist/start',
      {},
      testUsers[0].token,
    );

    if (data.params.sabotaged) {
      sabotageCount++;
    }

    if (data.event.includes('success')) {
      successCount++;
    } else {
      failureCount++;
    }

    // Small delay to avoid rate limiting
    await new Promise((resolve) => setTimeout(resolve, 100));
  }

  console.log(`  📊 Results from ${attempts} attempts:`);
  console.log(`     Sabotaged: ${sabotageCount} (${(sabotageCount / attempts) * 100}%)`);
  console.log(`     Success: ${successCount}`);
  console.log(`     Failure: ${failureCount}`);

  if (sabotageCount > 0) {
    console.log('  ✅ Sabotage mechanic working');
  } else {
    console.log('  ⚠️  No sabotage occurred (unlikely but possible)');
  }

  // Reset trust
  await request(
    'POST',
    `/crews/${crewId}/members/${testUsers[1].id}/trust`,
    { amount: 50 },
    testUsers[0].token,
  );
}

async function runTests() {
  console.log('🎮 CREW HEISTS TEST SUITE\n');
  console.log('='.repeat(50));

  try {
    await setupCrewWithMembers();
    await testGetAllHeists();
    await testGetHeistById();
    await testStartHeistNotInCrew();
    await testStartHeistNonLeader();
    await testInsufficientMembers();
    await testInvalidHeist();
    await testSuccessfulHeist();
    await testSabotageScenario();

    console.log('\n' + '='.repeat(50));
    console.log('✅ ALLE HEIST TESTS VOLTOOID');
  } catch (error) {
    console.error('\n❌ TEST FOUT:', error.message);
    process.exit(1);
  }
}

// Run tests
runTests();
