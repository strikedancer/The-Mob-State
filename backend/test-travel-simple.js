/**
 * Simple Travel System Tests - Phase 9.1
 */

const BASE_URL = 'http://localhost:3000';

let token = '';
let playerId = 0;

// Helper function for API requests
async function apiRequest(method, endpoint, body = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
    },
  };

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(`${BASE_URL}${endpoint}`, options);
  const data = await response.json();
  return { status: response.status, data };
}

async function testLogin() {
  console.log('\n=== TEST 1: Login ===');
  const { status, data } = await apiRequest('POST', '/auth/login', {
    username: 'testplayer',
    password: 'test123',
  });

  const responseToken = data.token || data.params?.token;
  const responsePlayer = data.player || data.params?.player;

  if (status === 200 && responseToken) {
    token = responseToken;
    playerId = responsePlayer.id;
    console.log('✅ Login successful');
    console.log(`   Player ID: ${playerId}`);
    return true;
  } else {
    console.log('❌ Login failed:', data);
    return false;
  }
}

async function testGetAllCountries() {
  console.log('\n=== TEST 2: Get all countries ===');
  const { status, data } = await apiRequest('GET', '/travel/countries');

  if (status === 200 && data.success) {
    console.log(`✅ Retrieved ${data.countries.length} countries`);
    console.log(`   Countries: ${data.countries.map(c => c.name).join(', ')}`);
    return true;
  } else {
    console.log('❌ Failed to get countries:', data);
    return false;
  }
}

async function testGetCurrentCountry() {
  console.log('\n=== TEST 3: Get current country ===');
  const { status, data } = await apiRequest('GET', '/travel/current');

  if (status === 200 && data.success) {
    console.log(`✅ Current country: ${data.country.name} (${data.country.id})`);
    console.log(`   Travel cost: €${data.country.travelCost}`);
    return true;
  } else {
    console.log('❌ Failed to get current country:', data);
    return false;
  }
}

async function testTravelToBelgium() {
  console.log('\n=== TEST 4: Travel to Belgium ===');
  
  // First, get player info to check money
  const playerInfo = await apiRequest('GET', '/player/me');
  const currentMoney = playerInfo.data.params?.player?.money || playerInfo.data.player?.money;
  console.log(`   Current money: €${currentMoney}`);

  const { status, data } = await apiRequest('POST', '/travel/belgium', {});

  if (status === 200 && data.success) {
    console.log(`✅ Traveled to ${data.newLocation}`);
    console.log(`   Travel cost: €${data.travelCost}`);
    console.log(`   Remaining money: €${data.remainingMoney}`);
    return true;
  } else {
    console.log('❌ Failed to travel:', data);
    return false;
  }
}

async function testAlreadyInCountry() {
  console.log('\n=== TEST 5: Try traveling to same country ===');
  const { status, data } = await apiRequest('POST', '/travel/belgium', {});

  if (status === 400 && data.error === 'ALREADY_IN_COUNTRY') {
    console.log('✅ Correctly rejected: Already in this country');
    return true;
  } else {
    console.log('❌ Should have rejected same country travel');
    return false;
  }
}

async function testTravelToGermany() {
  console.log('\n=== TEST 6: Travel to Germany ===');
  const { status, data } = await apiRequest('POST', '/travel/germany', {});

  if (status === 200 && data.success) {
    console.log(`✅ Traveled to ${data.newLocation}`);
    console.log(`   Travel cost: €${data.travelCost}`);
    console.log(`   Remaining money: €${data.remainingMoney}`);
    return true;
  } else {
    console.log('❌ Failed to travel:', data);
    return false;
  }
}

async function testInvalidCountry() {
  console.log('\n=== TEST 7: Try traveling to invalid country ===');
  const { status, data } = await apiRequest('POST', '/travel/atlantis', {});

  if (status === 400 && data.error === 'INVALID_COUNTRY') {
    console.log('✅ Correctly rejected: Invalid country');
    return true;
  } else {
    console.log('❌ Should have rejected invalid country');
    return false;
  }
}

async function testVerifyCurrentCountry() {
  console.log('\n=== TEST 8: Verify current country after travels ===');
  const { status, data } = await apiRequest('GET', '/travel/current');

  if (status === 200 && data.success) {
    console.log(`✅ Current country: ${data.country.name} (${data.country.id})`);
    
    if (data.country.id === 'germany') {
      console.log('   Location correctly updated');
      return true;
    } else {
      console.log(`   ❌ Expected Germany, got ${data.country.id}`);
      return false;
    }
  } else {
    console.log('❌ Failed to get current country:', data);
    return false;
  }
}

async function runAllTests() {
  console.log('🧪 TRAVEL SYSTEM TEST SUITE\n');
  console.log('=' .repeat(50));

  const results = [];

  try {
    results.push({ name: 'Login', passed: await testLogin() });
    results.push({ name: 'Get all countries', passed: await testGetAllCountries() });
    results.push({ name: 'Get current country', passed: await testGetCurrentCountry() });
    results.push({ name: 'Travel to Belgium', passed: await testTravelToBelgium() });
    results.push({ name: 'Already in country', passed: await testAlreadyInCountry() });
    results.push({ name: 'Travel to Germany', passed: await testTravelToGermany() });
    results.push({ name: 'Invalid country', passed: await testInvalidCountry() });
    results.push({ name: 'Verify current country', passed: await testVerifyCurrentCountry() });
  } catch (error) {
    console.error('\n💥 Test suite crashed:', error.message);
    process.exit(1);
  }

  // Summary
  console.log('\n' + '='.repeat(50));
  console.log('📊 TEST SUMMARY\n');
  
  const passed = results.filter(r => r.passed).length;
  const total = results.length;

  results.forEach((result, index) => {
    const icon = result.passed ? '✅' : '❌';
    console.log(`${icon} Test ${index + 1}: ${result.name}`);
  });

  console.log(`\n🎯 Result: ${passed}/${total} tests passed`);
  
  if (passed === total) {
    console.log('🎉 All tests passed!\n');
    process.exit(0);
  } else {
    console.log(`⚠️ ${total - passed} test(s) failed\n`);
    process.exit(1);
  }
}

runAllTests();
