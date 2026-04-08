const axios = require('axios');

const API_URL = 'http://localhost:3000';
let authToken = '';
let propertyId = 0;

async function testPropertySystem() {
  console.log('=== Property System Test ===\n');

  try {
    // 1. Login
    console.log('1. Login...');
    const loginRes = await axios.post(`${API_URL}/auth/login`, {
      username: 'propertytest',
      password: 'test123',
    });
    authToken = loginRes.data.token;
    console.log('✅ Login successful\n');

    const config = {
      headers: { Authorization: `Bearer ${authToken}` },
    };

    // 2. Get player info
    console.log('2. Getting player info...');
    const playerRes = await axios.get(`${API_URL}/player/me`, config);
    const player = playerRes.data.player;
    console.log(`✅ Player: ${player.username} | Money: €${player.money} | Level: ${player.rank}\n`);

    // 3. Get all properties
    console.log('3. Getting available properties...');
    const propsRes = await axios.get(`${API_URL}/properties`, config);
    const properties = propsRes.data.params.properties;
    console.log(`✅ Found ${properties.length} property types:`);
    properties.slice(0, 3).forEach((p) => {
      console.log(
        `   - ${p.name}: €${p.cost} | Income: €${p.baseIncome}/${p.incomeInterval}min | Min Level: ${p.minLevel} | Available: ${p.available}`
      );
    });
    console.log('');

    // 4. Buy a small property (Klein Huis)
    console.log('4. Buying Klein Huis...');
    try {
      const buyRes = await axios.post(
        `${API_URL}/properties/buy`,
        { propertyType: 'small_house' },
        config
      );
      propertyId = buyRes.data.params.property.id;
      console.log(`✅ Purchased! Property ID: ${propertyId}`);
      console.log(`   Money after purchase: €${buyRes.data.params.playerMoney}\n`);
    } catch (err) {
      console.log(`❌ Purchase failed: ${err.response.data.event}\n`);
    }

    // 5. Get owned properties
    console.log('5. Getting owned properties...');
    const ownedRes = await axios.get(`${API_URL}/properties/mine`, config);
    const owned = ownedRes.data.params.properties;
    console.log(`✅ Owned properties: ${owned.length}`);
    owned.forEach((p) => {
      console.log(
        `   - ${p.name} | Total Income: €${p.totalIncome} | Can Upgrade: ${p.canUpgrade}`
      );
    });
    console.log('');

    // 6. Try to collect income (should fail - not ready)
    console.log('6. Trying to collect income (should fail - too soon)...');
    try {
      await axios.post(`${API_URL}/properties/${propertyId}/collect`, {}, config);
      console.log('✅ Income collected (unexpected)\n');
    } catch (err) {
      if (err.response.data.event === 'error.income_not_ready') {
        console.log(
          `✅ Correctly blocked: ${err.response.data.params.minutesRemaining} minutes remaining\n`
        );
      } else {
        console.log(`❌ Unexpected error: ${err.response.data.event}\n`);
      }
    }

    // 7. Try to upgrade property
    console.log('7. Trying to upgrade property...');
    try {
      const upgradeRes = await axios.post(
        `${API_URL}/properties/${propertyId}/upgrade`,
        {},
        config
      );
      console.log(`✅ Upgraded to level ${upgradeRes.data.params.property.upgradeLevel}`);
      console.log(`   Money after upgrade: €${upgradeRes.data.params.playerMoney}\n`);
    } catch (err) {
      console.log(`❌ Upgrade failed: ${err.response.data.event}\n`);
    }

    // 8. Try to buy same property again (should fail - max ownership)
    console.log('8. Trying to buy Klein Huis again (should fail - max ownership)...');
    try {
      await axios.post(`${API_URL}/properties/buy`, { propertyType: 'small_house' }, config);
      console.log('❌ Second purchase succeeded (unexpected)\n');
    } catch (err) {
      if (err.response.data.event === 'error.max_ownership_reached') {
        console.log('✅ Correctly blocked: max ownership reached\n');
      } else {
        console.log(`❌ Unexpected error: ${err.response.data.event}\n`);
      }
    }

    // 9. Try to buy expensive property (should fail - insufficient funds or level)
    console.log('9. Trying to buy expensive property (Casino)...');
    try {
      await axios.post(`${API_URL}/properties/buy`, { propertyType: 'casino' }, config);
      console.log('✅ Purchased expensive property\n');
    } catch (err) {
      const errorType = err.response.data.event;
      if (errorType === 'error.insufficient_funds') {
        console.log('✅ Correctly blocked: insufficient funds\n');
      } else if (errorType === 'error.level_too_low') {
        console.log('✅ Correctly blocked: level too low\n');
      } else {
        console.log(`❌ Unexpected error: ${errorType}\n`);
      }
    }

    console.log('=== Property System Test Complete ===');
  } catch (error) {
    console.error('Test failed:', error.message);
    if (error.response) {
      console.error('Response:', error.response.data);
    }
  }
}

testPropertySystem();
