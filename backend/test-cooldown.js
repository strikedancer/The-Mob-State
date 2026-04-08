/**
 * Test cooldown system by attempting multiple crimes rapidly
 */

const API_URL = 'http://localhost:3000';
const username = 'testplayer';
const password = 'test123';

async function testCooldown() {
  console.log('🧪 Testing Cooldown System\n');

  // Login first
  console.log('1. Logging in...');
  const loginRes = await fetch(`${API_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  });

  if (!loginRes.ok) {
    console.error('❌ Login failed:', await loginRes.text());
    return;
  }

  const loginData = await loginRes.json();
  const token = loginData.token;
  
  if (!token) {
    console.error('❌ No token received. Response:', loginData);
    return;
  }
  
  console.log('✅ Logged in successfully');

  // Get first crime ID
  console.log('2. Getting available crimes...');
  const crimesRes = await fetch(`${API_URL}/crimes`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const crimesData = await crimesRes.json();
  const firstCrime = crimesData.crimes[0];
  console.log(`✅ Found crime: ${firstCrime.name} (${firstCrime.id})\n`);

  // Attempt 1: Should succeed (no cooldown)
  console.log('3. Attempt #1 - Should succeed (no cooldown)');
  const attempt1 = await fetch(`${API_URL}/crimes/${firstCrime.id}/attempt`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  });

  const attempt1Data = await attempt1.json();
  console.log(`Status: ${attempt1.status}`);
  console.log(`Event: ${attempt1Data.event}`);
  if (attempt1Data.params) {
    console.log(`Params:`, attempt1Data.params);
  }
  console.log('');

  // Attempt 2: Should fail (cooldown active)
  console.log('4. Attempt #2 - Should fail with cooldown (immediately after)');
  const attempt2 = await fetch(`${API_URL}/crimes/${firstCrime.id}/attempt`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  });

  const attempt2Data = await attempt2.json();
  console.log(`Status: ${attempt2.status}`);
  console.log(`Event: ${attempt2Data.event}`);
  if (attempt2Data.params) {
    console.log(`Params:`, attempt2Data.params);
  }

  if (attempt2.status === 429 && attempt2Data.event === 'error.cooldown') {
    console.log('✅ Cooldown working correctly!\n');
  } else {
    console.log('❌ Cooldown NOT working - expected 429 error.cooldown\n');
  }

  // Wait and try again
  const waitTime = attempt2Data.params?.remainingSeconds || 5;
  console.log(`5. Waiting ${waitTime + 1} seconds for cooldown to expire...`);
  await new Promise((resolve) => setTimeout(resolve, (waitTime + 1) * 1000));

  // Attempt 3: Should succeed (cooldown expired)
  console.log('\n6. Attempt #3 - Should succeed (after cooldown)');
  const attempt3 = await fetch(`${API_URL}/crimes/${firstCrime.id}/attempt`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  });

  const attempt3Data = await attempt3.json();
  console.log(`Status: ${attempt3.status}`);
  console.log(`Event: ${attempt3Data.event}`);

  if (attempt3.status === 200 || attempt3.status === 201) {
    console.log('✅ Crime attempt allowed after cooldown expired!\n');
  } else {
    console.log('❌ Crime still blocked after cooldown\n');
  }

  console.log('\n🎉 Cooldown test complete!');
}

testCooldown().catch(console.error);
