/**
 * Test Phase 12: Vehicle Stealing & Garage System
 */

const API_URL = 'http://localhost:3000';
const TEST_USER = {
  username: 'testuser2',
  password: 'test123',
};

let authToken = '';
let playerId = null;

// Helper function for API requests
async function apiRequest(endpoint, method = 'GET', body = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
  };

  if (authToken) {
    options.headers['Authorization'] = `Bearer ${authToken}`;
  }

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(`${API_URL}${endpoint}`, options);
  const data = await response.json();

  console.log(`\n📡 ${method} ${endpoint}`);
  console.log(`Status: ${response.status}`);
  console.log('Response:', JSON.stringify(data, null, 2));

  return { response, data };
}

// Test functions
async function login() {
  console.log('\n🔐 === LOGGING IN ===');
  const { response, data } = await apiRequest('/auth/login', 'POST', TEST_USER);

  if (response.ok && data.token) {
    authToken = data.token;
    playerId = data.player?.id;
    console.log('✅ Login successful');
    console.log(`Player ID: ${playerId}`);
    console.log(`Token: ${authToken.substring(0, 20)}...`);
  } else {
    console.error('❌ Login failed');
    process.exit(1);
  }
}

async function getPlayerInfo() {
  console.log('\n👤 === PLAYER INFO ===');
  const { data } = await apiRequest('/player');

  if (data.player) {
    console.log(`Name: ${data.player.username}`);
    console.log(`Money: €${data.player.money}`);
    console.log(`Rank: ${data.player.rank}`);
    console.log(`Country: ${data.player.currentCountry}`);
    console.log(`Wanted Level: ${data.player.wantedLevel || 0}`);
  }
}

async function getAvailableVehicles() {
  console.log('\n🚗 === AVAILABLE VEHICLES ===');
  const { data } = await apiRequest('/vehicles/available/netherlands');

  if (data.vehicles) {
    console.log(`\n${data.vehicles.length} vehicles available in Netherlands:`);
    data.vehicles.forEach((v) => {
      console.log(`\n- ${v.name} (${v.id})`);
      console.log(`  Type: ${v.type}`);
      console.log(`  Stats: Speed ${v.stats.speed} | Armor ${v.stats.armor} | Cargo ${v.stats.cargo} | Stealth ${v.stats.stealth}`);
      console.log(`  Value: €${v.baseValue}`);
      console.log(`  Required Rank: ${v.requiredRank}`);
    });
  }
}

async function stealVehicle(vehicleId) {
  console.log(`\n🚨 === STEALING ${vehicleId.toUpperCase()} ===`);
  const { data } = await apiRequest(`/vehicles/steal/${vehicleId}`, 'POST');

  if (data.event === 'vehicles.stolen') {
    console.log('✅ Successfully stolen!');
    console.log(`Message: ${data.params.message}`);
    if (data.vehicle) {
      console.log(`Condition: ${data.vehicle.condition}%`);
      console.log(`Fuel: ${data.vehicle.fuelLevel}%`);
      console.log(`Location: ${data.vehicle.currentLocation}`);
    }
  } else {
    console.log('❌ Steal failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function getInventory() {
  console.log('\n📦 === VEHICLE INVENTORY ===');
  const { data } = await apiRequest('/vehicles/inventory');

  if (data.inventory) {
    console.log(`\nYou have ${data.inventory.length} stolen vehicles:`);
    data.inventory.forEach((v, i) => {
      console.log(`\n${i + 1}. ${v.definition?.name} (ID: ${v.id})`);
      console.log(`   Type: ${v.vehicleType}`);
      console.log(`   Condition: ${v.condition}%`);
      console.log(`   Fuel: ${v.fuelLevel}%`);
      console.log(`   Location: ${v.currentLocation}`);
      console.log(`   Stolen in: ${v.stolenInCountry}`);
    });

    return data.inventory;
  }

  return [];
}

async function getGarageStatus(location) {
  console.log(`\n🏠 === GARAGE STATUS (${location}) ===`);
  const { data } = await apiRequest(`/garage/status/${location}`);

  if (data.status) {
    console.log(`Total Capacity: ${data.status.totalCapacity}`);
    console.log(`Current Level: ${data.status.currentUpgradeLevel}`);
    console.log(`Vehicles Stored: ${data.status.storedCount}`);

    if (data.status.storedVehicles?.length > 0) {
      console.log('\nStored vehicles:');
      data.status.storedVehicles.forEach((v) => {
        console.log(`- ${v.vehicleId} (Condition: ${v.condition}%)`);
      });
    }
  }
}

async function upgradeGarage(location) {
  console.log(`\n⬆️ === UPGRADING GARAGE (${location}) ===`);
  const { data } = await apiRequest('/garage/upgrade', 'POST', { location });

  if (data.event === 'garage.upgraded') {
    console.log('✅ Garage upgraded!');
    console.log(`New Level: ${data.params.newLevel}`);
    console.log(`Capacity Bonus: +${data.params.capacityBonus}`);
    console.log(`Cost: €${data.params.upgradeCost}`);
    console.log(`New Money: €${data.player.money}`);
  } else {
    console.log('❌ Upgrade failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function sellVehicle(inventoryId) {
  console.log(`\n💰 === SELLING VEHICLE (ID: ${inventoryId}) ===`);
  const { data } = await apiRequest(`/vehicles/sell-stolen/${inventoryId}`, 'POST');

  if (data.event === 'vehicles.stolen_sold') {
    console.log('✅ Vehicle sold!');
    console.log(`Sell Price: €${data.params.sellPrice}`);
    console.log(`New Money: €${data.player.money}`);
  } else {
    console.log('❌ Sale failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function getMarinaStatus(location) {
  console.log(`\n⚓ === MARINA STATUS (${location}) ===`);
  const { data } = await apiRequest(`/garage/marina/status/${location}`);

  if (data.status) {
    console.log(`Total Capacity: ${data.status.totalCapacity}`);
    console.log(`Current Level: ${data.status.currentUpgradeLevel}`);
    console.log(`Boats Stored: ${data.status.storedCount}`);
  }
}

// Main test flow
async function runTests() {
  try {
    await login();
    await getPlayerInfo();

    console.log('\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('   PHASE 12: VEHICLE STEALING TEST');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    // Test 1: Get available vehicles
    await getAvailableVehicles();

    // Test 2: Steal a cheap car (old_sedan)
    await stealVehicle('old_sedan');

    // Test 3: Try to steal an expensive car (sports_car)
    await stealVehicle('sports_car');

    // Test 4: Get inventory
    const inventory = await getInventory();

    // Test 5: Get garage status
    await getGarageStatus('netherlands');

    // Test 6: Try to upgrade garage
    await upgradeGarage('netherlands');

    // Test 7: Get marina status
    await getMarinaStatus('netherlands');

    // Test 8: Sell a vehicle if we have any
    if (inventory.length > 0) {
      await sellVehicle(inventory[0].id);
    }

    // Final inventory check
    await getInventory();
    await getPlayerInfo();

    console.log('\n\n✅ All tests completed!');
  } catch (error) {
    console.error('\n❌ Test error:', error);
  }
}

// Run tests
runTests();
