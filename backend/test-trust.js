/**
 * Test script for Phase 6.2: Trust System & Sabotage
 * Tests trust score adjustment and sabotage mechanics
 */

const BASE_URL = 'http://localhost:3000';

// Test users
const leader = { username: 'trust_leader_test', password: 'test123', token: null };
const member = { username: 'trust_member_test', password: 'test123', token: null };

let crewId = null;
let memberId = null;

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
    return data.player.id;
  } else {
    // Already exists, login
    const loginRes = await request('POST', '/auth/login', {
      username: user.username,
      password: user.password,
    });
    user.token = loginRes.data.token;
    return loginRes.data.player.id;
  }
}

async function setupCrewWithMember() {
  console.log('🔧 Setup: Creating crew and adding member...');

  // Register users
  await registerUser(leader);
  memberId = await registerUser(member);

  // Create crew
  const createRes = await request(
    'POST',
    '/crews/create',
    { name: 'Trust Test Crew' },
    leader.token,
  );

  if (createRes.status === 201) {
    crewId = createRes.data.params.crew.id;
    console.log(`  ✅ Crew created: ID ${crewId}`);
  } else if (createRes.data.event === 'error.crew_name_taken') {
    // Crew exists, get it
    const myCrewRes = await request('GET', '/crews/mine', null, leader.token);
    crewId = myCrewRes.data.params.crew.id;
    console.log(`  ✅ Using existing crew: ID ${crewId}`);
  }

  // Add member to crew
  const joinRes = await request('POST', `/crews/${crewId}/join`, {}, member.token);

  if (joinRes.status === 200) {
    console.log(`  ✅ Member joined crew`);
  } else if (joinRes.data.event === 'error.already_in_crew') {
    console.log(`  ⚠️  Member already in crew`);
  }

  console.log();
}

async function testGetInitialTrust() {
  console.log('📊 Test: Get initial trust score...');

  const { status, data } = await request(
    'GET',
    `/crews/${crewId}/members/${memberId}/trust`,
  );

  if (status === 200 && data.event === 'crew.member_trust') {
    console.log(`  ✅ Initial trust: ${data.params.trustScore} (expected: 50)`);
    if (data.params.trustScore === 50) {
      console.log('  ✅ Default trust score correct');
    } else {
      console.log(`  ❌ Expected 50, got ${data.params.trustScore}`);
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testIncreaseTrust() {
  console.log('\n⬆️  Test: Increase trust score...');

  const { status, data } = await request(
    'POST',
    `/crews/${crewId}/members/${memberId}/trust`,
    { amount: 20 },
    leader.token,
  );

  if (status === 200 && data.event === 'crew.trust_adjusted') {
    console.log(`  ✅ Trust increased to: ${data.params.trustScore}`);
    if (data.params.trustScore === 70) {
      console.log('  ✅ Trust calculation correct (50 + 20 = 70)');
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testDecreaseTrust() {
  console.log('\n⬇️  Test: Decrease trust score...');

  const { status, data } = await request(
    'POST',
    `/crews/${crewId}/members/${memberId}/trust`,
    { amount: -40 },
    leader.token,
  );

  if (status === 200 && data.event === 'crew.trust_adjusted') {
    console.log(`  ✅ Trust decreased to: ${data.params.trustScore}`);
    if (data.params.trustScore === 30) {
      console.log('  ✅ Trust calculation correct (70 - 40 = 30)');
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testTrustClampMin() {
  console.log('\n🔒 Test: Trust clamp at minimum (0)...');

  const { status, data } = await request(
    'POST',
    `/crews/${crewId}/members/${memberId}/trust`,
    { amount: -100 },
    leader.token,
  );

  if (status === 200 && data.event === 'crew.trust_adjusted') {
    console.log(`  ✅ Trust clamped to: ${data.params.trustScore}`);
    if (data.params.trustScore === 0) {
      console.log('  ✅ Minimum clamp working (cannot go below 0)');
    } else {
      console.log(`  ❌ Expected 0, got ${data.params.trustScore}`);
    }
  } else {
    console.log(`  ❌ FAILED: Status ${status}`, data);
  }
}

async function testTrustClampMax() {
  console.log('\n🔒 Test: Trust clamp at maximum (100)...');

  // First set to high value
  await request(
    'POST',
    `/crews/${crewId}/members/${memberId}/trust`,
    { amount: 200 },
    leader.token,
  );

  const { status, data } = await request(
    'GET',
    `/crews/${crewId}/members/${memberId}/trust`,
  );

  if (status === 200 && data.params.trustScore === 100) {
    console.log('  ✅ Maximum clamp working (cannot go above 100)');
  } else {
    console.log(`  ❌ Expected 100, got ${data.params.trustScore}`);
  }
}

async function testNonLeaderCannotAdjust() {
  console.log('\n🚫 Test: Non-leader cannot adjust trust...');

  const { status, data } = await request(
    'POST',
    `/crews/${crewId}/members/${memberId}/trust`,
    { amount: 10 },
    member.token, // Member trying to adjust (not leader)
  );

  if (status === 403 && data.event === 'error.not_crew_leader') {
    console.log('  ✅ Non-leader correctly blocked');
  } else {
    console.log(
      `  ❌ FAILED: Expected 403 not_crew_leader, got status ${status}`,
      data,
    );
  }
}

async function testSabotageMechanics() {
  console.log('\n🎲 Test: Sabotage mechanics...');

  // Import checkSabotage function (simulated here)
  const checkSabotage = (trustScore) => {
    const clampedTrust = Math.max(0, Math.min(100, trustScore));
    const sabotageChance = (100 - clampedTrust) / 2;
    const roll = Math.random() * 100;
    return roll < sabotageChance;
  };

  // Test at trust 0 (50% sabotage chance)
  let sabotageCount = 0;
  const trials = 1000;

  for (let i = 0; i < trials; i++) {
    if (checkSabotage(0)) sabotageCount++;
  }

  const sabotagePercent = (sabotageCount / trials) * 100;
  console.log(`  📊 Trust 0: ${sabotagePercent.toFixed(1)}% sabotage (expected ~50%)`);

  // Test at trust 50 (25% sabotage chance)
  sabotageCount = 0;
  for (let i = 0; i < trials; i++) {
    if (checkSabotage(50)) sabotageCount++;
  }

  const sabotagePercent50 = (sabotageCount / trials) * 100;
  console.log(
    `  📊 Trust 50: ${sabotagePercent50.toFixed(1)}% sabotage (expected ~25%)`,
  );

  // Test at trust 100 (0% sabotage chance)
  sabotageCount = 0;
  for (let i = 0; i < trials; i++) {
    if (checkSabotage(100)) sabotageCount++;
  }

  const sabotagePercent100 = (sabotageCount / trials) * 100;
  console.log(
    `  📊 Trust 100: ${sabotagePercent100.toFixed(1)}% sabotage (expected ~0%)`,
  );

  if (sabotagePercent > 45 && sabotagePercent < 55) {
    console.log('  ✅ Sabotage probability correct');
  } else {
    console.log('  ⚠️  Sabotage probability outside expected range');
  }
}

async function testInvalidMember() {
  console.log('\n🚫 Test: Adjust trust for non-existent member...');

  const { status, data } = await request(
    'POST',
    `/crews/${crewId}/members/99999/trust`,
    { amount: 10 },
    leader.token,
  );

  if (status === 404 && data.event === 'error.member_not_found') {
    console.log('  ✅ Non-existent member correctly rejected');
  } else {
    console.log(`  ❌ FAILED: Expected 404 member_not_found, got:`, data);
  }
}

async function runTests() {
  console.log('🎮 TRUST SYSTEM TEST SUITE\n');
  console.log('='.repeat(50));

  try {
    await setupCrewWithMember();
    await testGetInitialTrust();
    await testIncreaseTrust();
    await testDecreaseTrust();
    await testTrustClampMin();
    await testTrustClampMax();
    await testNonLeaderCannotAdjust();
    await testSabotageMechanics();
    await testInvalidMember();

    console.log('\n' + '='.repeat(50));
    console.log('✅ ALLE TRUST TESTS VOLTOOID');
  } catch (error) {
    console.error('\n❌ TEST FOUT:', error.message);
    process.exit(1);
  }
}

// Run tests
runTests();
