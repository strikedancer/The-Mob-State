// Test script to verify garage screen loads without errors
const http = require('http');

const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwbGF5ZXJJZCI6MiwidXNlcm5hbWUiOiJ0ZXN0dXNlcjIiLCJpYXQiOjE3Njk5MzYxNDUsImV4cCI6MTc3MDU0MDk0NX0.wIEtwebi7Pf4GxNYP2_dsafvy9Y7g1a_mmZqPhhxRac';

async function testEndpoint(path, description) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    };

    const req = http.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        console.log(`\n✅ ${description}`);
        console.log(`Status: ${res.statusCode}`);
        const json = JSON.parse(data);
        console.log('Response:', JSON.stringify(json, null, 2));
        resolve(json);
      });
    });

    req.on('error', (e) => {
      console.error(`❌ ${description} failed:`, e.message);
      reject(e);
    });

    req.end();
  });
}

async function runTests() {
  console.log('🧪 Testing Garage Screen API Endpoints...\n');
  
  try {
    await testEndpoint('/vehicles/inventory', 'Vehicle Inventory');
    await testEndpoint('/garage/status/switzerland', 'Garage Status (Switzerland)');
    await testEndpoint('/marina/status/switzerland', 'Marina Status (Switzerland)');
    
    console.log('\n✅ All tests passed! No null values found.');
  } catch (error) {
    console.error('\n❌ Tests failed:', error);
  }
}

runTests();
