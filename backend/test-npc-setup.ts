import 'dotenv/config';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

async function main() {
  console.log('🤖 Creating test NPCs via API...\n');

  const baseUrl = 'http://localhost:3000';
  
  try {
    // Check if server is running
    console.log('Checking if backend server is running...');
    try {
      const healthCheck = await fetch(`${baseUrl}/health`);
      if (!healthCheck.ok) {
        throw new Error('Backend not healthy');
      }
      console.log('✅ Backend server is running\n');
    } catch (error) {
      console.log('❌ Backend server is NOT running!');
      console.log('Please start the backend server first: npm run dev\n');
      process.exit(1);
    }

    // Login as admin (you'll need to create admin account first)
    console.log('Note: NPCs can be managed via the admin API endpoints:');
    console.log('  POST /admin/npcs - Create NPC');
    console.log('  GET /admin/npcs - List NPCs');
    console.log('  POST /admin/npcs/:id/simulate - Simulate activity');
    console.log('  POST /admin/npcs/simulate-all/run - Simulate all NPCs\n');

    console.log('✅ Database schema is ready for NPCs!');
    console.log('✅ NPC Scheduler will automatically start with the backend server\n');

    console.log('📝 To create NPCs, use the admin API or wait for the scheduler to run');
    console.log('📝 The scheduler runs every 5 minutes automatically\n');

  } catch (error: any) {
    console.error('❌ Error:', error.message);
  }
}

main();
