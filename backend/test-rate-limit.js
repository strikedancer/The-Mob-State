/**
 * Phase 13.2: Redis Rate Limiting Test
 * Tests rate limiter functionality
 */

const BASE_URL = 'http://localhost:3000';

async function testRateLimit() {
  console.log('🧪 Testing Rate Limiting (Phase 13.2)\n');
  console.log('=' .repeat(50));

  // Test 1: Normal requests should work
  console.log('\n📋 Test 1: Normal Requests');
  try {
    const response = await fetch(`${BASE_URL}/health`);
    const data = await response.json();
    console.log('✅ Normal request succeeded');
    console.log(`   Status: ${response.status}`);
    console.log(`   Rate Limit: ${response.headers.get('X-RateLimit-Limit')}`);
    console.log(`   Remaining: ${response.headers.get('X-RateLimit-Remaining')}`);
  } catch (error) {
    console.log(`❌ Normal request failed: ${error.message}`);
  }

  // Test 2: Rapid requests should trigger rate limit
  console.log('\n📋 Test 2: Rapid Fire Requests (Testing Rate Limit)');
  const promises = [];
  const maxRequests = 105; // More than the global limit (100)

  console.log(`   Sending ${maxRequests} requests rapidly...`);
  
  for (let i = 0; i < maxRequests; i++) {
    promises.push(
      fetch(`${BASE_URL}/health`)
        .then(async (res) => ({
          status: res.status,
          remaining: res.headers.get('X-RateLimit-Remaining'),
          limit: res.headers.get('X-RateLimit-Limit'),
          requestNum: i + 1,
        }))
        .catch((err) => ({
          status: 'ERROR',
          error: err.message,
          requestNum: i + 1,
        }))
    );
  }

  const results = await Promise.all(promises);
  
  const successCount = results.filter((r) => r.status === 200).length;
  const rateLimitedCount = results.filter((r) => r.status === 429).length;
  const errorCount = results.filter((r) => r.status === 'ERROR').length;

  console.log(`   ✅ Successful requests: ${successCount}`);
  console.log(`   🚫 Rate limited (429): ${rateLimitedCount}`);
  console.log(`   ❌ Errors: ${errorCount}`);

  // Show first rate limited response
  const firstRateLimited = results.find((r) => r.status === 429);
  if (firstRateLimited) {
    console.log(`   📊 Rate limited starting at request #${firstRateLimited.requestNum}`);
    console.log(`   📊 Limit: ${firstRateLimited.limit} requests/minute`);
  }

  // Test 3: Wait and retry should work again
  console.log('\n📋 Test 3: Wait for Rate Limit Reset');
  console.log('   ⏳ Waiting 5 seconds...');
  await new Promise((resolve) => setTimeout(resolve, 5000));

  try {
    const response = await fetch(`${BASE_URL}/health`);
    const remaining = response.headers.get('X-RateLimit-Remaining');
    console.log(`✅ Request succeeded after wait`);
    console.log(`   Remaining: ${remaining}`);
    
    if (parseInt(remaining || '0', 10) > 90) {
      console.log('   ✅ Rate limit counter was reset (or near reset)');
    }
  } catch (error) {
    console.log(`❌ Request after wait failed: ${error.message}`);
  }

  console.log('\n' + '='.repeat(50));
  console.log('✅ Rate Limiting Tests Complete!\n');
  
  // Print summary
  console.log('📊 Summary:');
  console.log(`   - Redis-backed rate limiting ${rateLimitedCount > 0 ? 'WORKING' : 'NOT DETECTED'}`);
  console.log(`   - Rate limit: 100 requests/minute (global)`);
  console.log(`   - Headers present: ${firstRateLimited?.limit ? 'YES' : 'NO'}`);
  
  if (rateLimitedCount === 0) {
    console.log('\n⚠️  Note: If Redis is not running, rate limiting is disabled (graceful fallback)');
    console.log('   To enable: Install and start Redis server');
  }
}

// Run tests
testRateLimit().catch((error) => {
  console.error('❌ Test failed:', error);
  process.exit(1);
});
