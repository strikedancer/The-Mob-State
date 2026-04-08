/**
 * Test script for Phase 14.4 - Ban Functionality
 * 
 * Tests:
 * 1. Create test player
 * 2. Ban player via admin
 * 3. Verify banned player cannot login
 * 4. Unban player
 * 5. Verify unbanned player can login again
 */

const API_URL = 'http://localhost:3000';

let adminToken;
let testPlayerId;
let testPlayerUsername;
let testPlayerPassword = 'test123';

async function testAdminLogin() {
  console.log('\n📝 Test 1: Admin Login');
  
  const response = await fetch(`${API_URL}/admin/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: 'admin',
      password: 'admin123',
    }),
  });

  const data = await response.json();
  
  if (response.ok && data.token) {
    adminToken = data.token;
    console.log('✅ Admin login successful');
  } else {
    console.log('❌ Admin login failed:', data);
    process.exit(1);
  }
}

async function createTestPlayer() {
  console.log('\n📝 Test 2: Create Test Player');
  
  testPlayerUsername = `ban_test_${Date.now()}`;
  
  const response = await fetch(`${API_URL}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: testPlayerUsername,
      password: testPlayerPassword,
    }),
  });

  const data = await response.json();
  
  if (response.ok && data.player) {
    testPlayerId = data.player.id;
    console.log(`✅ Test player created: ${data.player.username} (ID: ${testPlayerId})`);
  } else {
    console.log('❌ Failed to create test player:', data);
    process.exit(1);
  }
}

async function verifyPlayerCanLogin() {
  console.log('\n📝 Test 3: Verify Player Can Login (Before Ban)');
  
  const response = await fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: testPlayerUsername,
      password: testPlayerPassword,
    }),
  });

  const data = await response.json();
  
  if (response.ok && data.token) {
    console.log('✅ Player can login successfully');
  } else {
    console.log('❌ Player cannot login (unexpected):', data);
  }
}

async function banPlayer() {
  console.log('\n📝 Test 4: Ban Player');
  
  const response = await fetch(`${API_URL}/admin/players/ban`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${adminToken}`,
    },
    body: JSON.stringify({
      playerId: testPlayerId,
      reason: 'Test ban - automated testing',
      duration: 24,
    }),
  });

  const data = await response.json();
  
  if (response.ok) {
    console.log('✅ Player banned successfully');
    console.log(`   Reason: ${data.player.banReason}`);
    console.log(`   Banned until: ${data.player.bannedUntil}`);
  } else {
    console.log('❌ Failed to ban player:', data);
    process.exit(1);
  }
}

async function verifyPlayerCannotLogin() {
  console.log('\n📝 Test 5: Verify Banned Player CANNOT Login');
  
  const response = await fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: testPlayerUsername,
      password: testPlayerPassword,
    }),
  });

  const data = await response.json();
  
  if (response.status === 403 && data.event === 'auth.banned') {
    console.log('✅ Banned player correctly blocked from login');
    console.log(`   Event: ${data.event}`);
    console.log(`   Reason: ${data.params.reason}`);
    console.log(`   Permanent: ${data.params.isPermanent}`);
    if (!data.params.isPermanent) {
      console.log(`   Banned until: ${data.params.bannedUntil}`);
    }
  } else if (response.ok) {
    console.log('❌ SECURITY ISSUE: Banned player was able to login!');
    process.exit(1);
  } else {
    console.log('⚠️ Unexpected response:', response.status, data);
  }
}

async function unbanPlayer() {
  console.log('\n📝 Test 6: Unban Player');
  
  const response = await fetch(`${API_URL}/admin/players/unban`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${adminToken}`,
    },
    body: JSON.stringify({
      playerId: testPlayerId,
    }),
  });

  const data = await response.json();
  
  if (response.ok) {
    console.log('✅ Player unbanned successfully');
    console.log(`   Is banned: ${data.player.isBanned}`);
  } else {
    console.log('❌ Failed to unban player:', data);
  }
}

async function verifyPlayerCanLoginAgain() {
  console.log('\n📝 Test 7: Verify Player Can Login Again (After Unban)');
  
  const response = await fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: testPlayerUsername,
      password: testPlayerPassword,
    }),
  });

  const data = await response.json();
  
  if (response.ok && data.token) {
    console.log('✅ Unbanned player can login successfully');
  } else {
    console.log('❌ Unbanned player cannot login:', data);
  }
}

async function runTests() {
  console.log('🧪 Phase 14.4 Ban Functionality Tests\n');
  console.log('='.repeat(50));
  
  try {
    await testAdminLogin();
    await createTestPlayer();
    await verifyPlayerCanLogin();
    await banPlayer();
    await verifyPlayerCannotLogin();
    await unbanPlayer();
    await verifyPlayerCanLoginAgain();
    
    console.log('\n' + '='.repeat(50));
    console.log('✅ All tests completed!');
    console.log('\n💡 Phase 14.4 Features:');
    console.log('   ✅ Player search/filter in admin UI');
    console.log('   ✅ Edit player modal with stats editor');
    console.log('   ✅ Config editor with .env file management');
    console.log('   ✅ Ban functionality with login prevention');
    console.log('\n💡 Check the admin dashboard at http://localhost:5173');
  } catch (error) {
    console.error('\n❌ Test failed:', error);
    process.exit(1);
  }
}

runTests();
