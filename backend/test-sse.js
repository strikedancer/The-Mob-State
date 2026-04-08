/**
 * Test SSE endpoint
 * This script connects to the SSE endpoint and listens for events
 */

const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/events/stream',
  method: 'GET',
  headers: {
    Accept: 'text/event-stream',
  },
};

console.log('📡 Connecting to SSE endpoint...\n');

const req = http.request(options, (res) => {
  console.log(`Status: ${res.statusCode}`);
  console.log(`Headers: ${JSON.stringify(res.headers, null, 2)}\n`);

  res.on('data', (chunk) => {
    const data = chunk.toString();
    console.log('Received:', data);
  });

  res.on('end', () => {
    console.log('\n📡 Connection closed');
  });
});

req.on('error', (error) => {
  console.error('❌ Error:', error.message);
  process.exit(1);
});

req.end();

// Keep script running for 10 seconds to receive events
setTimeout(() => {
  console.log('\n⏱️  Test timeout - closing connection');
  req.destroy();
  process.exit(0);
}, 10000);
