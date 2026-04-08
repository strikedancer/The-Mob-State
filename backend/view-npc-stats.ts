import axios from 'axios';
import * as readline from 'readline';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function question(prompt: string): Promise<string> {
  return new Promise((resolve) => {
    rl.question(prompt, (answer) => {
      resolve(answer);
    });
  });
}

async function viewNPCStats() {
  const BASE_URL = 'http://localhost:3000';

  console.log('\n=== NPC Statistieken Bekijken ===\n');

  try {
    // Ask for admin credentials
    const username = await question('Admin username: ');
    const password = await question('Admin password: ');

    // Login
    console.log('\n⏳ Bezig met inloggen...');
    const loginResponse = await axios.post(`${BASE_URL}/admin/auth/login`, {
      username,
      password,
    });

    const token = loginResponse.data.token;
    console.log('✅ Ingelogd als:', loginResponse.data.admin.username);
    console.log('   Role:', loginResponse.data.admin.role);

    // Get all NPCs
    console.log('\n⏳ NPC statistieken ophalen...\n');
    const npcsResponse = await axios.get(`${BASE_URL}/admin/npcs`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    const npcs = npcsResponse.data.npcs;

    if (!npcs || npcs.length === 0) {
      console.log('⚠️  Geen NPCs gevonden.');
      console.log('\nRun eerst: npx ts-node test-npcs.ts');
      rl.close();
      return;
    }

    console.log(`📊 ${npcs.length} NPC(s) gevonden:\n`);
    console.log('='.repeat(100));

    for (const npc of npcs) {
      const player = npc.player;
      console.log(`\n👤 ${player.username} (${npc.npcType})`);
      console.log(`   ID: ${npc.id} | Active: ${npc.isActive ? '✅' : '❌'}`);
      console.log(`   Player ID: ${player.id} | Rank: ${player.rank} | Money: €${player.money.toLocaleString()}`);
      console.log(`\n   📈 Statistieken:`);
      console.log(`      Total Crimes: ${npc.totalCrimes}`);
      console.log(`      Total Jobs: ${npc.totalJobs}`);
      console.log(`      Money Earned: €${npc.totalMoneyEarned.toLocaleString()}`);
      console.log(`      XP Earned: ${npc.totalXpEarned.toLocaleString()}`);
      console.log(`      Total Arrests: ${npc.totalArrests}`);
      console.log(`      Total Jail Time: ${npc.totalJailTime} min`);
      console.log(`\n   ⏱️  Activiteit Per Uur:`);
      console.log(`      Crimes/hour: ${npc.crimesPerHour.toFixed(2)}`);
      console.log(`      Jobs/hour: ${npc.jobsPerHour.toFixed(2)}`);
      console.log(`      Simulated Hours: ${npc.simulatedOnlineHours.toFixed(2)}`);
      console.log(`\n   📅 Tijden:`);
      console.log(`      Created: ${new Date(npc.createdAt).toLocaleString()}`);
      console.log(`      Last Activity: ${npc.lastActivityAt ? new Date(npc.lastActivityAt).toLocaleString() : 'Never'}`);
      console.log('\n' + '-'.repeat(100));
    }

    console.log('\n✅ Klaar!\n');

    // Ask if user wants to see detailed stats for a specific NPC
    const viewDetails = await question('\nWil je gedetailleerde stats van een specifieke NPC zien? (y/n): ');
    if (viewDetails.toLowerCase() === 'y') {
      const npcId = await question('NPC ID: ');
      
      console.log(`\n⏳ Gedetailleerde stats ophalen voor NPC ${npcId}...\n`);
      const statsResponse = await axios.get(`${BASE_URL}/admin/npcs/${npcId}/stats`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      const stats = statsResponse.data.stats;
      console.log('📊 Gedetailleerde Statistieken:\n');
      console.log(JSON.stringify(stats, null, 2));
    }

  } catch (error: any) {
    if (error.response) {
      console.error('\n❌ API Error:', error.response.status);
      console.error('   Message:', error.response.data);
    } else {
      console.error('\n❌ Error:', error.message);
    }
  } finally {
    rl.close();
  }
}

viewNPCStats();
