const axios = require('axios');

const API_URL = 'http://localhost:3000';

async function setup() {
  try {
    // Create test user
    console.log('Creating test user...');
    await axios.post(`${API_URL}/auth/register`, {
      username: 'propertytest',
      password: 'test123',
    });
    console.log('✅ User created');

    // Login to get token
    const loginRes = await axios.post(`${API_URL}/auth/login`, {
      username: 'propertytest',
      password: 'test123',
    });
    const token = loginRes.data.token;

    // Give player money
    const config = { headers: { Authorization: `Bearer ${token}` } };
    
    // Get player ID first
    const playerRes = await axios.get(`${API_URL}/player/me`, config);
    console.log(`✅ Player created: ${playerRes.data.player.username}`);
    console.log(`   Initial money: €${playerRes.data.player.money}`);
    
  } catch (error) {
    if (error.response?.data?.event === 'auth.error') {
      console.log('✅ User already exists, ready for testing');
    } else {
      console.error('Setup failed:', error.message);
    }
  }
}

setup();
