/**
 * Aviation System Tests - Phase 10.1
 * 
 * Tests for aviation licensing and aircraft purchases.
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
    console.log(`   Current rank: ${responsePlayer.rank}`);
    return true;
  } else {
    console.log('❌ Login failed:', data);
    return false;
  }
}

async function testGetAllAircraft() {
  console.log('\n=== TEST 2: Get all aircraft types ===');
  const { status, data } = await apiRequest('GET', '/aviation/aircraft');

  if (status === 200 && data.success) {
    console.log(`✅ Retrieved ${data.aircraft.length} aircraft types`);
    console.log(`   Aircraft: ${data.aircraft.map(a => a.name).join(', ')}`);
    return true;
  } else {
    console.log('❌ Failed to get aircraft:', data);
    return false;
  }
}

async function testGetLicensePricing() {
  console.log('\n=== TEST 3: Get license pricing ===');
  const { status, data } = await apiRequest('GET', '/aviation/licenses');

  if (status === 200 && data.success) {
    console.log(`✅ Retrieved ${data.licenses.length} license types`);
    data.licenses.forEach(lic => {
      console.log(`   ${lic.licenseType}: €${lic.price.toLocaleString()} (min rank ${lic.minRank})`);
    });
    return true;
  } else {
    console.log('❌ Failed to get licenses:', data);
    return false;
  }
}

async function testCheckLicenseBeforePurchase() {
  console.log('\n=== TEST 4: Check license status (should have none) ===');
  const { status, data } = await apiRequest('GET', '/aviation/my-license');

  if (status === 200 && data.success && !data.hasLicense) {
    console.log('✅ Player has no license yet');
    return true;
  } else {
    console.log('❌ Unexpected license status:', data);
    return false;
  }
}

async function testBuyLicenseWithoutMoney() {
  console.log('\n=== TEST 5: Try buying license without enough money ===');
  
  // First check if player has enough money
  const playerInfo = await apiRequest('GET', '/player/me');
  const currentMoney = playerInfo.data.params?.player?.money || playerInfo.data.player?.money;
  
  if (currentMoney >= 100000) {
    console.log('⚠️ Player has enough money, skipping this test');
    return true;
  }

  const { status, data } = await apiRequest('POST', '/aviation/buy-license', {
    licenseType: 'basic',
  });

  if (status === 400 && data.error === 'INSUFFICIENT_MONEY') {
    console.log('✅ Correctly rejected: Insufficient money');
    return true;
  } else {
    console.log('❌ Should have rejected insufficient money');
    return false;
  }
}

async function testBuyBasicLicense() {
  console.log('\n=== TEST 6: Buy basic aviation license ===');
  
  const { status, data } = await apiRequest('POST', '/aviation/buy-license', {
    licenseType: 'basic',
  });

  if (status === 200 && data.success) {
    console.log(`✅ Purchased ${data.licenseType} license`);
    console.log(`   Cost: €${data.cost.toLocaleString()}`);
    console.log(`   Remaining money: €${data.remainingMoney.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Failed to buy license:', data);
    return false;
  }
}

async function testCheckLicenseAfterPurchase() {
  console.log('\n=== TEST 7: Verify license was purchased ===');
  const { status, data } = await apiRequest('GET', '/aviation/my-license');

  if (status === 200 && data.success && data.hasLicense) {
    console.log('✅ License verified');
    console.log(`   Type: ${data.license.licenseType}`);
    console.log(`   Purchase price: €${data.license.purchasePrice.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ License not found after purchase:', data);
    return false;
  }
}

async function testBuyDuplicateLicense() {
  console.log('\n=== TEST 8: Try buying license again ===');
  
  const { status, data } = await apiRequest('POST', '/aviation/buy-license', {
    licenseType: 'basic',
  });

  if (status === 400 && data.error === 'ALREADY_HAS_LICENSE') {
    console.log('✅ Correctly rejected: Already has license');
    return true;
  } else {
    console.log('❌ Should have rejected duplicate license');
    return false;
  }
}

async function testBuyAircraftWithoutLicense() {
  console.log('\n=== TEST 9: Try buying aircraft without license (hypothetical) ===');
  console.log('⏭️ Skipped: Player already has license from previous test');
  return true;
}

async function testBuyAircraft() {
  console.log('\n=== TEST 10: Buy Cessna 172 aircraft ===');
  
  const { status, data } = await apiRequest('POST', '/aviation/buy-aircraft', {
    aircraftType: 'cessna_172',
  });

  if (status === 200 && data.success) {
    console.log(`✅ Purchased ${data.aircraftName}`);
    console.log(`   Aircraft ID: ${data.aircraftId}`);
    console.log(`   Cost: €${data.cost.toLocaleString()}`);
    console.log(`   Remaining money: €${data.remainingMoney.toLocaleString()}`);
    return true;
  } else {
    console.log('❌ Failed to buy aircraft:', data);
    return false;
  }
}

async function testGetMyAircraft() {
  console.log('\n=== TEST 11: Get my aircraft ===');
  const { status, data } = await apiRequest('GET', '/aviation/my-aircraft');

  if (status === 200 && data.success) {
    console.log(`✅ Retrieved ${data.aircraft.length} aircraft`);
    data.aircraft.forEach(ac => {
      console.log(`   ${ac.name}: ${ac.fuel}/${ac.maxFuel} fuel, ${ac.totalFlights} flights`);
    });
    return true;
  } else {
    console.log('❌ Failed to get aircraft:', data);
    return false;
  }
}

async function testBuyInvalidAircraft() {
  console.log('\n=== TEST 12: Try buying invalid aircraft ===');
  
  const { status, data } = await apiRequest('POST', '/aviation/buy-aircraft', {
    aircraftType: 'spaceship',
  });

  if (status === 400 && data.error === 'INVALID_AIRCRAFT_TYPE') {
    console.log('✅ Correctly rejected: Invalid aircraft type');
    return true;
  } else {
    console.log('❌ Should have rejected invalid aircraft');
    return false;
  }
}

async function testBuyExpensiveAircraft() {
  console.log('\n=== TEST 13: Try buying aircraft above rank ===');
  
  const { status, data } = await apiRequest('POST', '/aviation/buy-aircraft', {
    aircraftType: 'antonov_an_225', // Requires rank 50
  });

  if (status === 400 && (data.error === 'RANK_TOO_LOW' || data.error === 'INSUFFICIENT_MONEY')) {
    console.log(`✅ Correctly rejected: ${data.error}`);
    return true;
  } else {
    console.log('❌ Should have rejected (rank or money)');
    return false;
  }
}

async function runAllTests() {
  console.log('🧪 AVIATION SYSTEM TEST SUITE\n');
  console.log('=' .repeat(50));

  const results = [];

  try {
    results.push({ name: 'Login', passed: await testLogin() });
    results.push({ name: 'Get all aircraft', passed: await testGetAllAircraft() });
    results.push({ name: 'Get license pricing', passed: await testGetLicensePricing() });
    results.push({ name: 'Check no license initially', passed: await testCheckLicenseBeforePurchase() });
    results.push({ name: 'Insufficient money (optional)', passed: await testBuyLicenseWithoutMoney() });
    results.push({ name: 'Buy basic license', passed: await testBuyBasicLicense() });
    results.push({ name: 'Verify license purchased', passed: await testCheckLicenseAfterPurchase() });
    results.push({ name: 'Duplicate license rejected', passed: await testBuyDuplicateLicense() });
    results.push({ name: 'No license check (skipped)', passed: await testBuyAircraftWithoutLicense() });
    results.push({ name: 'Buy Cessna 172', passed: await testBuyAircraft() });
    results.push({ name: 'Get my aircraft', passed: await testGetMyAircraft() });
    results.push({ name: 'Invalid aircraft rejected', passed: await testBuyInvalidAircraft() });
    results.push({ name: 'Expensive aircraft rejected', passed: await testBuyExpensiveAircraft() });
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
