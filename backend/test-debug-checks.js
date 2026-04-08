const axios = require('axios');

const API_URL = 'http://localhost:3000';

async function testAPIFormat() {
  console.log('=== API Response Format & Error Handling Tests ===\n');

  try {
    // Check 8: API Response Format
    console.log('Check 8: API Response Format');
    const username = `debugtest_${Date.now()}`;
    const registerRes = await axios.post(`${API_URL}/auth/register`, {
      username,
      password: 'test123',
    });

    if (registerRes.data.event && registerRes.data.params !== undefined) {
      console.log(`  ✅ Correct format: {event: "${registerRes.data.event}", params: {...}}`);
    } else {
      console.log('  ❌ Invalid format:', registerRes.data);
    }
    console.log('');

    // Login to test properties
    const loginRes = await axios.post(`${API_URL}/auth/login`, {
      username,
      password: 'test123',
    });
    const token = loginRes.data.token;
    const config = { headers: { Authorization: `Bearer ${token}` } };

    // Test properties endpoint format
    const propsRes = await axios.get(`${API_URL}/properties`, config);
    if (propsRes.data.event && propsRes.data.params) {
      console.log(`  ✅ Properties endpoint: {event: "${propsRes.data.event}", params: {...}}`);
    }
    console.log('');

    // Check 10: Error Handling
    console.log('Check 10: Error Handling');

    // Test invalid credentials
    try {
      await axios.post(`${API_URL}/auth/login`, {
        username: 'nonexistent',
        password: 'wrong',
      });
      console.log('  ❌ Should have returned error');
    } catch (err) {
      if (err.response.status === 401) {
        console.log(`  ✅ Invalid login returns 401`);
        console.log(`     Error event: ${err.response.data.event}`);
      }
    }

    // Test insufficient funds
    try {
      await axios.post(`${API_URL}/properties/buy`, { propertyType: 'casino' }, config);
      console.log('  ❌ Should have returned error (insufficient funds)');
    } catch (err) {
      if (err.response.data.event === 'error.insufficient_funds' || err.response.data.event === 'error.level_too_low') {
        console.log(`  ✅ Property purchase validation: ${err.response.data.event}`);
      }
    }

    console.log('\n=== All Checks Complete ===');
  } catch (error) {
    console.error('Test failed:', error.message);
  }
}

testAPIFormat();
