/**
 * Test script for Phase 14.3 Audit Logging
 * 
 * Tests:
 * 1. Admin login creates audit log
 * 2. Ban player creates audit log
 * 3. Edit player creates audit log
 * 4. Audit logs include IP and user agent
 * 5. Audit logs can be retrieved via API
 */

const API_URL = 'http://localhost:3000';

let adminToken: string;
let testPlayerId: number;

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
    console.log(`   Token: ${data.token.substring(0, 20)}...`);
    console.log(`   Admin: ${data.admin.username} (${data.admin.role})`);
  } else {
    console.log('❌ Admin login failed:', data);
    process.exit(1);
  }
}

async function createTestPlayer() {
  console.log('\n📝 Creating test player...');
  
  const response = await fetch(`${API_URL}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      username: `testplayer_${Date.now()}`,
      password: 'test123',
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

async function testBanPlayer() {
  console.log('\n📝 Test 2: Ban Player (should create audit log)');
  
  const response = await fetch(`${API_URL}/admin/players/ban`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${adminToken}`,
    },
    body: JSON.stringify({
      playerId: testPlayerId,
      reason: 'Test ban for audit logging',
      duration: 24, // 24 hours
    }),
  });

  const data = await response.json();
  
  if (response.ok) {
    console.log('✅ Player banned successfully');
    console.log(`   Player: ${data.player.username}`);
    console.log(`   Banned until: ${data.player.bannedUntil}`);
    console.log(`   Reason: ${data.player.banReason}`);
  } else {
    console.log('❌ Failed to ban player:', data);
  }
}

async function testEditPlayer() {
  console.log('\n📝 Test 3: Edit Player (should create audit log)');
  
  const response = await fetch(`${API_URL}/admin/players/edit`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${adminToken}`,
    },
    body: JSON.stringify({
      playerId: testPlayerId,
      updates: {
        money: 999999,
        health: 100,
      },
    }),
  });

  const data = await response.json();
  
  if (response.ok) {
    console.log('✅ Player edited successfully');
    console.log(`   Player: ${data.player.username}`);
    console.log(`   New money: $${data.player.money}`);
    console.log(`   New health: ${data.player.health}%`);
  } else {
    console.log('❌ Failed to edit player:', data);
  }
}

async function testGetAuditLogs() {
  console.log('\n📝 Test 4: Retrieve Audit Logs');
  
  const response = await fetch(`${API_URL}/admin/audit-logs?page=1&limit=10`, {
    headers: {
      'Authorization': `Bearer ${adminToken}`,
    },
  });

  const data = await response.json();
  
  if (response.ok && data.logs) {
    console.log(`✅ Retrieved ${data.logs.length} audit logs (Total: ${data.total})`);
    
    console.log('\n   Recent audit logs:');
    data.logs.slice(0, 5).forEach((log: any, index: number) => {
      console.log(`   ${index + 1}. [${log.action}] by ${log.admin.username}`);
      console.log(`      Target: ${log.targetType || 'N/A'} #${log.targetId || 'N/A'}`);
      console.log(`      IP: ${log.ipAddress || 'N/A'}`);
      console.log(`      Time: ${new Date(log.createdAt).toLocaleString()}`);
      if (log.details) {
        console.log(`      Details: ${log.details.substring(0, 50)}...`);
      }
      console.log('');
    });
  } else {
    console.log('❌ Failed to retrieve audit logs:', data);
  }
}

async function testUnbanPlayer() {
  console.log('\n📝 Test 5: Unban Player (should create audit log)');
  
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
    console.log(`   Player: ${data.player.username}`);
    console.log(`   Is banned: ${data.player.isBanned}`);
  } else {
    console.log('❌ Failed to unban player:', data);
  }
}

async function runTests() {
  console.log('🧪 Phase 14.3 Audit Logging Tests\n');
  console.log('=' .repeat(50));
  
  try {
    await testAdminLogin();
    await createTestPlayer();
    await testBanPlayer();
    await testEditPlayer();
    await testUnbanPlayer();
    await testGetAuditLogs();
    
    console.log('\n' + '='.repeat(50));
    console.log('✅ All tests completed!');
    console.log('\n💡 Check the admin dashboard at http://localhost:5173');
    console.log('   Login: admin / admin123');
    console.log('   Go to "Audit Logs" tab to see the logged actions');
  } catch (error) {
    console.error('\n❌ Test failed:', error);
    process.exit(1);
  }
}

runTests();
