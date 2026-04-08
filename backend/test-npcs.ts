import 'dotenv/config';
import { NPCService } from './src/services/npcService';
import prisma from './src/lib/prisma';

async function main() {
  console.log('🤖 Creating test NPCs...\n');

  try {
    // Create 3 NPCs - one of each type
    const npcs = [
      { username: 'NPC_Matig_Johan', npcType: 'MATIG' as const },
      { username: 'NPC_Gemiddeld_Peter', npcType: 'GEMIDDELD' as const },
      { username: 'NPC_Continu_Alex', npcType: 'CONTINU' as const },
    ];

    for (const npcData of npcs) {
      console.log(`Creating ${npcData.username}...`);
      
      const result = await NPCService.createNPC(npcData);
      
      console.log(`✅ Created ${npcData.npcType} NPC:`);
      console.log(`   - ID: ${result.npc.id}`);
      console.log(`   - Player ID: ${result.player.id}`);
      console.log(`   - Username: ${result.player.username}`);
      console.log(`   - Starting Money: €${result.player.money}`);
      console.log(`   - Starting Rank: ${result.player.rank}`);
      console.log(`   - Starting XP: ${result.player.xp}\n`);
    }

    console.log('✅ All NPCs created successfully!\n');

    // Get all NPCs
    const allNPCs = await NPCService.getAllNPCs();
    console.log(`📊 Total NPCs in database: ${allNPCs.length}\n`);

    // Simulate activity for each NPC
    console.log('🎮 Simulating 1 hour of activity for each NPC...\n');

    for (const npcData of allNPCs) {
      console.log(`Simulating ${npcData.player?.username}...`);
      
      const result = await NPCService.simulateActivity(npcData.npc.id, 1);
      
      console.log(`✅ Simulation complete:`);
      console.log(`   - Activities: ${result.activitiesPerformed}`);
      console.log(`   - Money Earned: €${result.moneyEarned}`);
      console.log(`   - XP Earned: ${result.xpEarned}`);
      console.log(`   - Arrests: ${result.arrests}\n`);
    }

    // Show stats for each NPC
    console.log('📈 NPC Statistics:\n');

    for (const npcData of allNPCs) {
      const stats = await NPCService.getNPCStats(npcData.npc.id);
      
      console.log(`${stats.player?.username} (${stats.npc.npcType}):`);
      console.log(`   - Total Crimes: ${stats.stats.totalCrimes}`);
      console.log(`   - Total Jobs: ${stats.stats.totalJobs}`);
      console.log(`   - Money Earned: €${stats.stats.totalMoneyEarned}`);
      console.log(`   - XP Earned: ${stats.stats.totalXpEarned}`);
      console.log(`   - Arrests: ${stats.stats.totalArrests}`);
      console.log(`   - Crimes/Hour: ${stats.stats.crimesPerHour.toFixed(2)}`);
      console.log(`   - Jobs/Hour: ${stats.stats.jobsPerHour.toFixed(2)}`);
      console.log(`   - Success Rate: ${stats.stats.successRate.toFixed(1)}%`);
      console.log(`   - Current Money: €${stats.player?.money}`);
      console.log(`   - Current Rank: ${stats.player?.rank}`);
      console.log(`   - Current XP: ${stats.player?.xp}\n`);
    }

    console.log('✅ Test complete!');

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
