/**
 * Test script for Flutter auth flow
 * Tests registration and login endpoints
 */

const http = require('http');

function makeRequest(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      },
    };

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          body: body ? JSON.parse(body) : null,
        });
      });
    });

    req.on('error', reject);

    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

async function testAuthFlow() {
  console.log('🧪 Testing Flutter Auth Flow\n');

  try {
    // Test 1: Register new user
    console.log('1️⃣  Testing Registration...');
    const username = `fluttertest_${Date.now()}`;
    const password = 'test123456';

    const registerResponse = await makeRequest('POST', '/auth/register', {
      username,
      password,
    });

    console.log(`   Status: ${registerResponse.statusCode}`);
    console.log(`   Response:`, registerResponse.body);

    if (registerResponse.statusCode === 201 && registerResponse.body.token) {
      console.log('   ✅ Registration successful!');
      console.log(`   Token: ${registerResponse.body.token.substring(0, 20)}...`);
      console.log(`   Player ID: ${registerResponse.body.player.id}`);
    } else {
      console.log('   ❌ Registration failed!');
      return;
    }

    // Test 2: Login with same user
    console.log('\n2️⃣  Testing Login...');
    const loginResponse = await makeRequest('POST', '/auth/login', {
      username,
      password,
    });

    console.log(`   Status: ${loginResponse.statusCode}`);
    console.log(`   Response:`, loginResponse.body);

    if (loginResponse.statusCode === 200 && loginResponse.body.token) {
      console.log('   ✅ Login successful!');
      console.log(`   Token: ${loginResponse.body.token.substring(0, 20)}...`);
      console.log(`   Player: ${loginResponse.body.player.username}`);
      console.log(`   Money: €${loginResponse.body.player.money.toLocaleString()}`);
      console.log(`   Health: ${loginResponse.body.player.health}%`);
      console.log(`   Rank: ${loginResponse.body.player.rank}`);
    } else {
      console.log('   ❌ Login failed!');
      return;
    }

    // Test 3: Get current player with token
    console.log('\n3️⃣  Testing /player/me with token...');
    const token = loginResponse.body.token;

    const meResponse = await new Promise((resolve, reject) => {
      const options = {
        hostname: 'localhost',
        port: 3000,
        path: '/player/me',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
      };

      const req = http.request(options, (res) => {
        let body = '';
        res.on('data', (chunk) => {
          body += chunk;
        });
        res.on('end', () => {
          resolve({
            statusCode: res.statusCode,
            body: body ? JSON.parse(body) : null,
          });
        });
      });

      req.on('error', reject);
      req.end();
    });

    console.log(`   Status: ${meResponse.statusCode}`);
    console.log(`   Response:`, meResponse.body);

    if (meResponse.statusCode === 200 && meResponse.body.id) {
      console.log('   ✅ Token authentication successful!');
      console.log(`   Player: ${meResponse.body.username}`);
    } else {
      console.log('   ❌ Token authentication failed!');
      return;
    }

    console.log('\n✅ All tests passed!');
    console.log('\n📱 You can now test in Flutter with:');
    console.log(`   Username: ${username}`);
    console.log(`   Password: ${password}`);
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

testAuthFlow();
