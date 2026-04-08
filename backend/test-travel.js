/**
 * Travel System Tests - Phase 9.1
 * 
 * Tests for international travel between countries.
 */

const axios = require('axios');

const BASE_URL = 'http://localhost:3000';
let authToken = '';
let testPlayerId = null;

// Test player credentials
const TEST_USERNAME = 'travel_tester_' + Date.now();
const TEST_PASSWORD = 'Test1234!';

async function setup() {
  console.log('🔧 Setting up test player...\n');
  
  try {
    // Register test player
    const registerResponse = await axios.post(`${BASE_URL}/auth/register`, {
      username: TEST_USERNAME,
      password: TEST_PASSWORD,
    });

    authToken = registerResponse.data.token;
    testPlayerId = registerResponse.data.player.id;

    console.log(`✅ Test player created: ${TEST_USERNAME} (ID: ${testPlayerId})`);
    console.log(`💰 Will update money via direct database access\n`);
  } catch (error) {
    console.error('❌ Setup failed:', error.response?.data || error.message);
    throw error;
  }
}

async function updatePlayerMoney(playerId, money) {
  // Use direct database query
  const response = await axios.post(`${BASE_URL}/player/update-test-data`, {
    playerId,
    money,
  });
  return response.data;
}

async function updatePlayerLocation(playerId, currentCountry) {
  // Use direct database query
  const response = await axios.post(`${BASE_URL}/player/update-test-data`, {
    playerId,
    currentCountry,
  });
  return response.data;
}

async function cleanup() {
  console.log('\n🧹 Cleaning up...');
  
  try {
    await axios.delete(`${BASE_URL}/player/test/${testPlayerId}`);
    console.log('✅ Test player deleted');
  } catch (error) {
    console.error('⚠️ Cleanup warning:', error.message);
  }
}

async function testGetAllCountries() {
  console.log('📋 Test 1: Get all countries...');
  
  try {
    const response = await axios.get(`${BASE_URL}/travel/countries`);
    
    if (!response.data.success) {
      throw new Error('Response not successful');
    }

    const countries = response.data.countries;
    
    if (!Array.isArray(countries)) {
      throw new Error('Countries is not an array');
    }

    if (countries.length !== 8) {
      throw new Error(`Expected 8 countries, got ${countries.length}`);
    }

    // Check that Netherlands exists and is free
    const netherlands = countries.find(c => c.id === 'netherlands');
    if (!netherlands) {
      throw new Error('Netherlands not found');
    }

    if (netherlands.travelCost !== 0) {
      throw new Error('Netherlands should have 0 travel cost');
    }

    console.log(`✅ Retrieved ${countries.length} countries`);
    console.log(`   Countries: ${countries.map(c => c.name).join(', ')}`);
    return true;
  } catch (error) {
    console.error('❌ Failed:', error.response?.data || error.message);
    return false;
  }
}

async function testGetCurrentCountry() {
  console.log('\n📍 Test 2: Get current country...');
  
  try {
    const response = await axios.get(`${BASE_URL}/travel/current`, {
      headers: { Authorization: `Bearer ${authToken}` },
    });
    
    if (!response.data.success) {
      throw new Error('Response not successful');
    }

    const country = response.data.country;
    
    if (country.id !== 'netherlands') {
      throw new Error(`Expected current country to be 'netherlands', got '${country.id}'`);
    }

    console.log(`✅ Current country: ${country.name} (${country.id})`);
    return true;
  } catch (error) {
    console.error('❌ Failed:', error.response?.data || error.message);
    return false;
  }
}

async function testTravelToBelgium() {
  console.log('\n✈️ Test 3: Travel to Belgium...');
  
  try {
    const response = await axios.post(
      `${BASE_URL}/travel/belgium`,
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );
    
    if (!response.data.success) {
      throw new Error('Response not successful');
    }

    const result = response.data;
    
    if (result.newCountry !== 'belgium') {
      throw new Error(`Expected new country to be 'belgium', got '${result.newCountry}'`);
    }

    if (result.travelCost !== 500) {
      throw new Error(`Expected travel cost to be 500, got ${result.travelCost}`);
    }

    if (result.remainingMoney !== 9500) {
      throw new Error(`Expected remaining money to be 9500, got ${result.remainingMoney}`);
    }

    console.log(`✅ Traveled to ${result.newLocation}`);
    console.log(`   Cost: €${result.travelCost}`);
    console.log(`   Remaining: €${result.remainingMoney}`);
    return true;
  } catch (error) {
    console.error('❌ Failed:', error.response?.data || error.message);
    return false;
  }
}

async function testTravelToSwitzerland() {
  console.log('\n✈️ Test 4: Travel to Switzerland (expensive)...');
  
  try {
    const response = await axios.post(
      `${BASE_URL}/travel/switzerland`,
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );
    
    if (!response.data.success) {
      throw new Error('Response not successful');
    }

    const result = response.data;
    
    if (result.newCountry !== 'switzerland') {
      throw new Error(`Expected new country to be 'switzerland', got '${result.newCountry}'`);
    }

    if (result.travelCost !== 2000) {
      throw new Error(`Expected travel cost to be 2000, got ${result.travelCost}`);
    }

    if (result.remainingMoney !== 7500) {
      throw new Error(`Expected remaining money to be 7500, got ${result.remainingMoney}`);
    }

    console.log(`✅ Traveled to ${result.newLocation}`);
    console.log(`   Cost: €${result.travelCost}`);
    console.log(`   Remaining: €${result.remainingMoney}`);
    return true;
  } catch (error) {
    console.error('❌ Failed:', error.response?.data || error.message);
    return false;
  }
}

async function testAlreadyInCountry() {
  console.log('\n🚫 Test 5: Try traveling to same country...');
  
  try {
    const response = await axios.post(
      `${BASE_URL}/travel/switzerland`,
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );
    
    // Should not reach here
    console.error('❌ Failed: Should have rejected same country travel');
    return false;
  } catch (error) {
    if (error.response?.data?.error === 'ALREADY_IN_COUNTRY') {
      console.log('✅ Correctly rejected: Already in this country');
      return true;
    }
    
    console.error('❌ Failed with unexpected error:', error.response?.data || error.message);
    return false;
  }
}

async function testInvalidCountry() {
  console.log('\n🚫 Test 6: Try traveling to invalid country...');
  
  try {
    const response = await axios.post(
      `${BASE_URL}/travel/atlantis`,
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );
    
    // Should not reach here
    console.error('❌ Failed: Should have rejected invalid country');
    return false;
  } catch (error) {
    if (error.response?.data?.error === 'INVALID_COUNTRY') {
      console.log('✅ Correctly rejected: Invalid country');
      return true;
    }
    
    console.error('❌ Failed with unexpected error:', error.response?.data || error.message);
    return false;
  }
}

async function testInsufficientMoney() {
  console.log('\n🚫 Test 7: Try traveling without enough money...');
  
  try {
    // Set player money to very low amount
    const db = require('./src/lib/prisma').default;
    await db.player.update({
      where: { id: testPlayerId },
      data: { 
        money: 100, // Only €100
        currentCountry: 'netherlands', // Reset to Netherlands
      },
    });

    const response = await axios.post(
      `${BASE_URL}/travel/belgium`, // Costs €500
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );
    
    // Should not reach here
    console.error('❌ Failed: Should have rejected insufficient money');
    return false;
  } catch (error) {
    if (error.response?.data?.error === 'INSUFFICIENT_MONEY') {
      console.log('✅ Correctly rejected: Insufficient money');
      return true;
    }
    
    console.error('❌ Failed with unexpected error:', error.response?.data || error.message);
    return false;
  }
}

async function testVerifyCurrentCountryAfterTravel() {
  console.log('\n📍 Test 8: Verify current country after travel...');
  
  try {
    // Give player money and travel to Germany
    const db = require('./src/lib/prisma').default;
    await db.player.update({
      where: { id: testPlayerId },
      data: { money: 5000 },
    });

    await axios.post(
      `${BASE_URL}/travel/germany`,
      {},
      {
        headers: { Authorization: `Bearer ${authToken}` },
      }
    );

    // Check current country
    const response = await axios.get(`${BASE_URL}/travel/current`, {
      headers: { Authorization: `Bearer ${authToken}` },
    });
    
    if (response.data.country.id !== 'germany') {
      throw new Error(`Expected current country to be 'germany', got '${response.data.country.id}'`);
    }

    console.log(`✅ Current country correctly updated to: ${response.data.country.name}`);
    return true;
  } catch (error) {
    console.error('❌ Failed:', error.response?.data || error.message);
    return false;
  }
}

async function runAllTests() {
  console.log('🧪 TRAVEL SYSTEM TEST SUITE\n');
  console.log('=' .repeat(50) + '\n');

  const results = [];

  try {
    await setup();

    results.push({ name: 'Get all countries', passed: await testGetAllCountries() });
    results.push({ name: 'Get current country', passed: await testGetCurrentCountry() });
    results.push({ name: 'Travel to Belgium', passed: await testTravelToBelgium() });
    results.push({ name: 'Travel to Switzerland', passed: await testTravelToSwitzerland() });
    results.push({ name: 'Already in country', passed: await testAlreadyInCountry() });
    results.push({ name: 'Invalid country', passed: await testInvalidCountry() });
    results.push({ name: 'Insufficient money', passed: await testInsufficientMoney() });
    results.push({ name: 'Verify country after travel', passed: await testVerifyCurrentCountryAfterTravel() });

    await cleanup();
  } catch (error) {
    console.error('\n💥 Test suite crashed:', error.message);
    await cleanup();
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
