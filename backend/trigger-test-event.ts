/**
 * Trigger a test event to verify SSE broadcasting
 */

import 'dotenv/config';
import { worldEventService } from './src/services/worldEventService';

async function triggerEvent() {
  console.log('🚀 Triggering test event...');

  await worldEventService.createEvent('test.broadcast', {
    message: 'This is a test event from the backend',
    timestamp: new Date().toISOString(),
  });

  console.log('✅ Event created and broadcasted!');
  process.exit(0);
}

triggerEvent().catch((error) => {
  console.error('❌ Error:', error);
  process.exit(1);
});
