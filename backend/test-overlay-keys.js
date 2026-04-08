const axios = require('axios');

const API_URL = 'http://localhost:3000';

async function testOverlayKeys() {
  console.log('=== Phase 5.3: Overlay Keys Test ===\n');

  try {
    // Login
    const loginRes = await axios.post(`${API_URL}/auth/login`, {
      username: 'propertytest',
      password: 'test123',
    });
    const token = loginRes.data.token;
    const config = { headers: { Authorization: `Bearer ${token}` } };

    // Get owned properties
    console.log('Testing GET /properties/mine...');
    const ownedRes = await axios.get(`${API_URL}/properties/mine`, config);
    const properties = ownedRes.data.params.properties;

    if (properties.length === 0) {
      console.log('  ℹ️  No properties owned yet. Buying one...');
      
      // Buy a property first
      await axios.post(`${API_URL}/properties/buy`, { propertyType: 'small_house' }, config);
      
      // Get properties again
      const retryRes = await axios.get(`${API_URL}/properties/mine`, config);
      const retryProps = retryRes.data.params.properties;
      
      if (retryProps.length > 0) {
        console.log(`  ✅ Property purchased: ${retryProps[0].name}`);
        console.log(`     Overlay Keys: ${JSON.stringify(retryProps[0].overlayKeys)}`);
        
        if (retryProps[0].overlayKeys && Array.isArray(retryProps[0].overlayKeys)) {
          console.log('  ✅ overlayKeys is an array');
          
          // Check expected keys
          const hasIncomeReady = retryProps[0].overlayKeys.includes('income_ready');
          console.log(`     - income_ready: ${hasIncomeReady ? '✅' : '❌'}`);
        } else {
          console.log('  ❌ overlayKeys is not an array');
        }
      }
    } else {
      console.log(`  ✅ Found ${properties.length} property/properties`);
      
      properties.forEach((prop, index) => {
        console.log(`\n  Property ${index + 1}: ${prop.name}`);
        console.log(`    - Type: ${prop.propertyType}`);
        console.log(`    - Upgrade Level: ${prop.upgradeLevel}`);
        console.log(`    - Total Income: €${prop.totalIncome}`);
        console.log(`    - Overlay Keys: ${JSON.stringify(prop.overlayKeys)}`);
        
        if (prop.overlayKeys && Array.isArray(prop.overlayKeys)) {
          console.log('    ✅ overlayKeys is an array');
          
          // Verify expected overlays
          if (prop.upgradeLevel > 0) {
            const hasUpgraded = prop.overlayKeys.includes(`upgraded_lvl${prop.upgradeLevel}`);
            console.log(`    - upgraded_lvl${prop.upgradeLevel}: ${hasUpgraded ? '✅' : '❌'}`);
          }
          
          if (!prop.canUpgrade) {
            const hasMaxLevel = prop.overlayKeys.includes('max_level');
            console.log(`    - max_level: ${hasMaxLevel ? '✅' : '❌'}`);
          }
          
          const hasIncomeReady = prop.overlayKeys.includes('income_ready');
          console.log(`    - income_ready: ${hasIncomeReady ? '✅' : '⏳ (not ready yet)'}`);
        } else {
          console.log('    ❌ overlayKeys is missing or not an array');
        }
      });
    }

    console.log('\n=== Overlay Keys Test Complete ===');
  } catch (error) {
    console.error('Test failed:', error.message);
    if (error.response) {
      console.error('Response:', error.response.data);
    }
  }
}

testOverlayKeys();
