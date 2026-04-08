/**
 * Test Phase 12.4: Black Market & Transport
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
  const result = await apiRequest('/auth/login', 'POST', TEST_USER);

  if (result.response.ok && result.data.token) {
    authToken = result.data.token;
    playerId = result.data.player?.id;
    console.log('✅ Login successful');
    console.log(`Player ID: ${playerId}`);
    return result; // Return full result
  } else {
    console.error('❌ Login failed');
    process.exit(1);
  }
}

async function getPlayerInfo() {
  console.log('\n👤 === PLAYER INFO ===');
  const { data } = await apiRequest('/player/profile');

  if (data.player) {
    console.log(`Name: ${data.player.username}`);
    console.log(`Money: €${data.player.money}`);
    console.log(`Country: ${data.player.currentCountry}`);
    return data.player;
  }

  return null;
}

async function stealVehicle(vehicleId) {
  console.log(`\n🚨 === STEALING ${vehicleId.toUpperCase()} ===`);
  const { data } = await apiRequest(`/vehicles/steal/${vehicleId}`, 'POST');

  if (data.event === 'vehicles.stolen') {
    console.log('✅ Successfully stolen!');
    return data.vehicle;
  } else {
    console.log('❌ Steal failed');
    return null;
  }
}

async function getInventory() {
  console.log('\n📦 === VEHICLE INVENTORY ===');
  const { data } = await apiRequest('/vehicles/inventory');

  if (data.inventory) {
    console.log(`\nYou have ${data.inventory.length} stolen vehicles`);
    data.inventory.forEach((v, i) => {
      console.log(`${i + 1}. ${v.definition?.name} (ID: ${v.id}) - ${v.currentLocation}`);
    });
    return data.inventory;
  }

  return [];
}

async function listVehicleOnMarket(inventoryId, askingPrice) {
  console.log(`\n💰 === LISTING VEHICLE ON MARKET ===`);
  console.log(`Inventory ID: ${inventoryId}, Price: €${askingPrice}`);
  
  const { data } = await apiRequest(`/market/list/${inventoryId}`, 'POST', {
    askingPrice,
  });

  if (data.event === 'market.listed') {
    console.log('✅ Vehicle listed on market!');
    console.log(`Message: ${data.params.message}`);
  } else {
    console.log('❌ Listing failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function getMarketListings(country) {
  console.log(`\n🏪 === MARKET LISTINGS (${country || 'ALL'}) ===`);
  
  const endpoint = country ? `/market/vehicles?country=${country}` : '/market/vehicles';
  const { data } = await apiRequest(endpoint);

  if (data.listings) {
    console.log(`\nFound ${data.listings.length} vehicles for sale:`);
    data.listings.forEach((listing, i) => {
      console.log(`\n${i + 1}. ${listing.definition?.name} (ID: ${listing.id})`);
      console.log(`   Seller: ${listing.player.username}`);
      console.log(`   Price: €${listing.askingPrice}`);
      console.log(`   Condition: ${listing.condition}%`);
      console.log(`   Location: ${listing.currentLocation}`);
    });
    return data.listings;
  }

  return [];
}

async function getMyListings() {
  console.log('\n📋 === MY MARKET LISTINGS ===');
  
  const { data } = await apiRequest('/market/my-listings');

  if (data.listings) {
    console.log(`\nYou have ${data.listings.length} vehicles listed:`);
    data.listings.forEach((listing, i) => {
      console.log(`\n${i + 1}. ${listing.definition?.name} (ID: ${listing.id})`);
      console.log(`   Asking Price: €${listing.askingPrice}`);
      console.log(`   Recommended Price: €${listing.pricing?.recommendedPrice}`);
      console.log(`   Market Demand: ${listing.pricing?.marketDemand}`);
      console.log(`   Condition: ${listing.condition}%`);
    });
    return data.listings;
  }

  return [];
}

async function buyVehicle(inventoryId) {
  console.log(`\n🛒 === BUYING VEHICLE (ID: ${inventoryId}) ===`);
  
  const { data } = await apiRequest(`/market/buy/${inventoryId}`, 'POST');

  if (data.event === 'market.purchased') {
    console.log('✅ Vehicle purchased!');
    console.log(`Purchase Price: €${data.params.purchasePrice}`);
    console.log(`New Money: €${data.player.money}`);
  } else {
    console.log('❌ Purchase failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function flyVehicle(inventoryId, destination) {
  console.log(`\n✈️ === FLYING VEHICLE TO ${destination.toUpperCase()} ===`);
  
  const { data } = await apiRequest(`/transport/fly/${inventoryId}`, 'POST', {
    destinationCountry: destination,
  });

  if (data.event === 'transport.flown') {
    console.log('✅ Vehicle flown successfully!');
    console.log(`Transport Cost: €${data.params.transportCost}`);
    console.log(`New Money: €${data.player.money}`);
  } else {
    console.log('❌ Transport failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function shipVehicle(inventoryId, destination) {
  console.log(`\n🚢 === SHIPPING VEHICLE TO ${destination.toUpperCase()} ===`);
  
  const { data } = await apiRequest(`/transport/ship/${inventoryId}`, 'POST', {
    destinationCountry: destination,
  });

  if (data.event === 'transport.shipped') {
    console.log('✅ Vehicle shipped successfully!');
    console.log(`Transport Cost: €${data.params.transportCost}`);
    console.log(`Arrival Time: ${data.params.arrivalTime}`);
    console.log(`New Money: €${data.player.money}`);
  } else {
    console.log('❌ Transport failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

async function driveVehicle(inventoryId, destination) {
  console.log(`\n🚗 === DRIVING VEHICLE TO ${destination.toUpperCase()} ===`);
  
  const { data } = await apiRequest(`/transport/drive/${inventoryId}`, 'POST', {
    destinationCountry: destination,
  });

  if (data.event === 'transport.driven') {
    console.log('✅ Vehicle driven successfully!');
    console.log(`Fuel Used: ${data.params.fuelUsed}%`);
    console.log(`New Fuel Level: ${data.params.newFuelLevel}%`);
    console.log(`Police Encounter: ${data.params.policeEncounter ? 'YES' : 'NO'}`);
    console.log(`Message: ${data.params.message}`);
  } else {
    console.log('❌ Transport failed');
    console.log(`Reason: ${data.params?.reason}`);
  }
}

// Main test flow
async function runTests() {
  try {
    const loginData = await login();
    let player = loginData.data.player; // Get player from login response

    console.log('\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('   PHASE 12.4: BLACK MARKET & TRANSPORT TEST');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    // Test 1: Steal some vehicles
    console.log('\n=== TEST 1: STEAL VEHICLES ===');
    console.log(`Current country: ${player.currentCountry}`);
    
    // Check available vehicles in current country
    const { data: availData } = await apiRequest(`/vehicles/available/${player.currentCountry}`);
    if (availData.vehicles && availData.vehicles.length > 0) {
      console.log(`\nAvailable vehicles in ${player.currentCountry}:`);
      availData.vehicles.forEach((v) => {
        console.log(`- ${v.name} (${v.id}) - Required Rank: ${v.requiredRank}`);
      });
      
      // Steal first 3 available vehicles
      for (let i = 0; i < Math.min(3, availData.vehicles.length); i++) {
        await stealVehicle(availData.vehicles[i].id);
      }
    } else {
      console.log(`\n⚠️ No vehicles available in ${player.currentCountry}`);
    }

    // Test 2: Get inventory
    const inventory = await getInventory();

    if (inventory.length === 0) {
      console.log('\n⚠️ No vehicles in inventory, skipping market tests');
      return;
    }

    // Test 3: List a vehicle on the market
    console.log('\n=== TEST 3: LIST VEHICLE ON MARKET ===');
    const vehicleToList = inventory[0];
    const askingPrice = vehicleToList.definition?.baseValue || 10000;
    await listVehicleOnMarket(vehicleToList.id, askingPrice);

    // Test 4: View my listings
    await getMyListings();

    // Test 5: View all market listings
    await getMarketListings(player.currentCountry);

    // Test 6: Transport tests (if we have cars/boats)
    const car = inventory.find((v) => v.vehicleType === 'car');
    const boat = inventory.find((v) => v.vehicleType === 'boat');

    if (car && player.money >= 15000) {
      console.log('\n=== TEST 6: FLY CAR TO GERMANY ===');
      await flyVehicle(car.id, 'germany');
    }

    if (boat && player.money >= 5000) {
      console.log('\n=== TEST 7: SHIP BOAT TO BELGIUM ===');
      await shipVehicle(boat.id, 'belgium');
    }

    if (inventory.length > 1) {
      console.log('\n=== TEST 8: DRIVE VEHICLE TO FRANCE ===');
      const vehicleToDrive = inventory.find((v) => !v.marketListing);
      if (vehicleToDrive) {
        await driveVehicle(vehicleToDrive.id, 'france');
      }
    }

    // Final status
    await getInventory();
    await getPlayerInfo();

    console.log('\n\n✅ All Phase 12.4 tests completed!');
  } catch (error) {
    console.error('\n❌ Test error:', error);
  }
}

// Run tests
runTests();
