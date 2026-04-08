/**
 * Test live SSE broadcasting
 * This script connects to SSE and waits for events
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
  console.log(`✅ Connected! Status: ${res.statusCode}\n`);
  console.log('Waiting for events (press Ctrl+C to exit)...\n');

  res.on('data', (chunk) => {
    const data = chunk.toString();
    console.log('📨 Event received:');
    console.log(data);
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

// Handle Ctrl+C gracefully
process.on('SIGINT', () => {
  console.log('\n\n👋 Closing connection...');
  req.destroy();
  process.exit(0);
});
