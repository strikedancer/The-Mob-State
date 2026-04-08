/**
 * Phase 12 Complete Integration Test
 * Tests all vehicle features: stealing, garage, marina, market, transport
 */

const BASE_URL = 'http://localhost:3000';

async function apiCall(endpoint, options = {}) {
  const response = await fetch(`${BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
  });
  const data = await response.json();
  return { status: response.status, data };
}

async function runPhase12Tests() {
  console.log('🧪 Phase 12: Vehicle System Integration Tests\n');
  console.log('=' .repeat(50));
  
  let token;
  let playerId;
  let vehicleId;
  let marinaBoatId;

  // Test 1: Authentication
  console.log('\n📋 Test 1: Authentication');
  try {
    const { status, data } = await apiCall('/auth/login', {
      method: 'POST',
      body: JSON.stringify({
        username: 'testplayer',
        password: 'test123',
      }),
    });

    if (status === 200 && data.token) {
      token = data.token;
      playerId = data.player.id;
      console.log('✅ Login successful');
      console.log(`   Player: ${data.player.username}`);
      console.log(`   Money: €${data.player.money}`);
      console.log(`   Country: ${data.player.currentCountry}`);
    } else {
      console.log('❌ Login failed');
      return;
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
    return;
  }

  const authHeaders = { Authorization: `Bearer ${token}` };

  // Test 2: View Available Vehicles
  console.log('\n📋 Test 2: View Available Vehicles');
  try {
    const { status, data } = await apiCall('/vehicles/available/netherlands', {
      headers: authHeaders,
    });

    if (status === 200) {
      console.log(`✅ Found ${data.vehicles.length} vehicles available`);
      data.vehicles.slice(0, 3).forEach((v) => {
        console.log(`   - ${v.name} (${v.type}) - €${v.baseValue}`);
      });
    } else {
      console.log('❌ Failed to fetch vehicles');
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 3: Steal a Car
  console.log('\n📋 Test 3: Steal a Car');
  try {
    const { status, data } = await apiCall('/vehicles/steal/toyota_corolla', {
      method: 'POST',
      headers: authHeaders,
    });

    if (status === 200 && data.event === 'vehicles.stolen') {
      vehicleId = data.params.vehicle.id;
      console.log('✅ Vehicle stolen successfully');
      console.log(`   Vehicle: ${data.params.vehicle.vehicleName}`);
      console.log(`   Condition: ${data.params.vehicle.condition}%`);
      console.log(`   Fuel: ${data.params.vehicle.fuelLevel}%`);
    } else {
      console.log(`❌ Steal failed: ${data.params?.reason || 'Unknown'}`);
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 4: View Garage Status
  console.log('\n📋 Test 4: View Garage Status');
  try {
    const { status, data } = await apiCall('/garage/status/netherlands', {
      headers: authHeaders,
    });

    if (status === 200) {
      console.log('✅ Garage status retrieved');
      console.log(`   Capacity: ${data.status.capacity}/${data.status.totalCapacity}`);
      console.log(`   Upgrade Level: ${data.status.upgradeLevel}`);
      console.log(`   Stored Vehicles: ${data.status.storedVehicles.length}`);
    } else {
      console.log('❌ Failed to get garage status');
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 5: Steal a Boat
  console.log('\n📋 Test 5: Steal a Boat');
  try {
    const { status, data } = await apiCall('/vehicles/steal/speedboat', {
      method: 'POST',
      headers: authHeaders,
    });

    if (status === 200 && data.event === 'vehicles.stolen') {
      marinaBoatId = data.params.vehicle.id;
      console.log('✅ Boat stolen successfully');
      console.log(`   Boat: ${data.params.vehicle.vehicleName}`);
      console.log(`   Condition: ${data.params.vehicle.condition}%`);
    } else {
      console.log(`❌ Steal failed: ${data.params?.reason || 'Unknown'}`);
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 6: View Marina Status
  console.log('\n📋 Test 6: View Marina Status');
  try {
    const { status, data } = await apiCall('/garage/marina/status/netherlands', {
      headers: authHeaders,
    });

    if (status === 200) {
      console.log('✅ Marina status retrieved');
      console.log(`   Capacity: ${data.status.capacity}/${data.status.totalCapacity}`);
      console.log(`   Upgrade Level: ${data.status.upgradeLevel}`);
      console.log(`   Stored Boats: ${data.status.storedBoats.length}`);
    } else {
      console.log('❌ Failed to get marina status');
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 7: List Vehicle on Market
  console.log('\n📋 Test 7: List Vehicle on Market');
  if (vehicleId) {
    try {
      const { status, data } = await apiCall(`/market/list/${vehicleId}`, {
        method: 'POST',
        headers: authHeaders,
        body: JSON.stringify({ askingPrice: 18000 }),
      });

      if (status === 200 && data.event === 'market.listed') {
        console.log('✅ Vehicle listed on market');
        console.log(`   Asking Price: €${data.params.askingPrice}`);
      } else {
        console.log(`❌ Listing failed: ${data.params?.reason || 'Unknown'}`);
      }
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
    }
  } else {
    console.log('⏭️  Skipped (no vehicle stolen)');
  }

  // Test 8: View Market Listings
  console.log('\n📋 Test 8: View Market Listings');
  try {
    const { status, data } = await apiCall('/market/vehicles', {
      headers: authHeaders,
    });

    if (status === 200) {
      console.log(`✅ Found ${data.listings.length} market listings`);
      data.listings.slice(0, 3).forEach((listing) => {
        console.log(`   - ${listing.vehicleName} - €${listing.askingPrice} (${listing.location})`);
      });
    } else {
      console.log('❌ Failed to fetch market listings');
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 9: Transport Vehicle (Fly)
  console.log('\n📋 Test 9: Transport Vehicle (Fly)');
  if (vehicleId) {
    try {
      // First delist
      await apiCall(`/market/delist/${vehicleId}`, {
        method: 'POST',
        headers: authHeaders,
      });

      const { status, data } = await apiCall(`/transport/fly/${vehicleId}`, {
        method: 'POST',
        headers: authHeaders,
        body: JSON.stringify({ destinationCountry: 'france' }),
      });

      if (status === 200 && data.event === 'transport.flown') {
        console.log('✅ Vehicle transported by air');
        console.log(`   Destination: ${data.params.destination}`);
        console.log(`   Cost: €${data.params.cost}`);
      } else {
        console.log(`❌ Transport failed: ${data.params?.reason || 'Unknown'}`);
      }
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
    }
  } else {
    console.log('⏭️  Skipped (no vehicle stolen)');
  }

  // Test 10: Transport Boat (Ship)
  console.log('\n📋 Test 10: Transport Boat (Ship)');
  if (marinaBoatId) {
    try {
      const { status, data } = await apiCall(`/transport/ship/${marinaBoatId}`, {
        method: 'POST',
        headers: authHeaders,
        body: JSON.stringify({ destinationCountry: 'belgium' }),
      });

      if (status === 200 && data.event === 'transport.shipped') {
        console.log('✅ Boat transported by sea');
        console.log(`   Destination: ${data.params.destination}`);
        console.log(`   Cost: €${data.params.cost}`);
        console.log(`   Arrival: ${data.params.arrivalTime}`);
      } else {
        console.log(`❌ Transport failed: ${data.params?.reason || 'Unknown'}`);
      }
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
    }
  } else {
    console.log('⏭️  Skipped (no boat stolen)');
  }

  // Test 11: View Vehicle Inventory
  console.log('\n📋 Test 11: View Vehicle Inventory');
  try {
    const { status, data } = await apiCall('/vehicles/inventory', {
      headers: authHeaders,
    });

    if (status === 200) {
      console.log(`✅ Inventory retrieved: ${data.inventory.length} vehicles`);
      data.inventory.forEach((v) => {
        console.log(`   - ${v.vehicleName} in ${v.location} (${v.condition}% condition)`);
      });
    } else {
      console.log('❌ Failed to get inventory');
    }
  } catch (error) {
    console.log(`❌ Error: ${error.message}`);
  }

  // Test 12: Arbitrage Calculator
  console.log('\n📋 Test 12: Arbitrage Calculator');
  if (vehicleId) {
    try {
      const { status, data } = await apiCall(
        `/transport/calculate-arbitrage/${vehicleId}?toCountry=switzerland&transportMethod=fly`,
        {
          headers: authHeaders,
        }
      );

      if (status === 200) {
        console.log('✅ Arbitrage calculation complete');
        console.log(`   Current Value: €${data.calculation.currentValue}`);
        console.log(`   Destination Value: €${data.calculation.destinationValue}`);
        console.log(`   Transport Cost: €${data.calculation.transportCost}`);
        console.log(`   Expected Profit: €${data.calculation.profit}`);
        console.log(`   Profit Margin: ${data.calculation.profitMargin}%`);
      } else {
        console.log('❌ Failed to calculate arbitrage');
      }
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
    }
  } else {
    console.log('⏭️  Skipped (no vehicle stolen)');
  }

  console.log('\n' + '='.repeat(50));
  console.log('✅ Phase 12 Integration Tests Complete!\n');
}

// Run tests
runPhase12Tests().catch(console.error);
