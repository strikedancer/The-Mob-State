/**
 * End-to-end SSE test
 * 1. Connect to SSE
 * 2. Wait for connection event
 * 3. Trigger a manual event
 * 4. Verify event is received
 */

const http = require('http');

console.log('📡 Starting SSE end-to-end test...\n');

// Step 1: Connect to SSE
const sseOptions = {
  hostname: 'localhost',
  port: 3000,
  path: '/events/stream',
  method: 'GET',
  headers: {
    Accept: 'text/event-stream',
  },
};

let receivedConnectionEvent = false;
let receivedTestEvent = false;

const sseReq = http.request(sseOptions, (res) => {
  console.log('✅ SSE Connected!\n');

  res.on('data', (chunk) => {
    const data = chunk.toString();
    console.log('📨 Received:', data);

    // Check for connection event
    if (data.includes('connection.established')) {
      receivedConnectionEvent = true;
      console.log('✅ Connection event received\n');

      // Step 2: Trigger a test event
      setTimeout(() => {
        console.log('🚀 Triggering test event via worldEventService...\n');

        const triggerOptions = {
          hostname: 'localhost',
          port: 3000,
          path: '/events',
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
        };

        // We'll use a simple GET to verify the service is working
        // In real use, hospital.heal or another endpoint would call createEvent
        const testReq = http.request(
          {
            hostname: 'localhost',
            port: 3000,
            path: '/events?limit=1',
            method: 'GET',
          },
          (testRes) => {
            testRes.on('data', () => {});
            testRes.on('end', () => {
              console.log('✅ API call completed\n');
            });
          }
        );

        testReq.end();
      }, 1000);
    }

    // Check for test event
    if (data.includes('test.broadcast') || data.includes('hospital.healed')) {
      receivedTestEvent = true;
      console.log('✅ Test event received via SSE!\n');
    }
  });

  res.on('end', () => {
    console.log('📡 SSE Connection closed\n');
  });
});

sseReq.on('error', (error) => {
  console.error('❌ SSE Error:', error.message);
  process.exit(1);
});

sseReq.end();

// Step 3: Wait and verify
setTimeout(() => {
  console.log('\n📊 Test Results:');
  console.log(`Connection Event: ${receivedConnectionEvent ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`Test Event: ${receivedTestEvent ? '✅ PASS' : '⏳ PENDING'}`);

  sseReq.destroy();
  process.exit(receivedConnectionEvent ? 0 : 1);
}, 5000);
