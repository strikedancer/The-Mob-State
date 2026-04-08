import prisma from './src/lib/prisma';
import { NPCService } from './src/services/npcService';

async function testNPCJailBail() {
  console.log('\n=== NPC Jail Bail Payment Test ===\n');

  try {
    // Find NPC #2
    const npc = await prisma.nPCPlayer.findUnique({
      where: { id: 2 },
    });

    if (!npc) {
      console.error('NPC #2 not found');
      return;
    }

    const player = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    console.log('Found NPC:', {
      id: npc.id,
      name: player?.username,
      type: npc.npcType,
    });

    // Put NPC in jail with wanted level and give money for bail
    const wantedLevel = 8;
    const jailRelease = new Date();
    jailRelease.setHours(jailRelease.getHours() + 2); // 2 hours in jail
    const bailCost = wantedLevel * 1000; // €8,000
    
    await prisma.player.update({
      where: { id: npc.playerId },
      data: {
        wantedLevel,
        jailRelease,
        money: bailCost * 3, // Give 3x bail cost
      },
    });

    console.log('\n--- Initial State (NPC in Jail) ---');
    const initialPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    console.log('Wanted Level:', initialPlayer?.wantedLevel);
    console.log('Money:', `€${initialPlayer?.money}`);
    console.log('Bail Cost:', `€${bailCost}`);
    console.log('In Jail Until:', initialPlayer?.jailRelease);
    console.log('Currently In Jail:', initialPlayer?.jailRelease && new Date(initialPlayer.jailRelease) > new Date() ? 'YES' : 'NO');

    // Simulate 24 hours of activity
    console.log('\n--- Simulating 24 Hours (NPC should pay bail and get out) ---');
    const results = await NPCService.simulateActivity(npc.id, 24);

    console.log('\n--- Results ---');
    console.log('Activities Performed:', results.activitiesPerformed);
    console.log('Money Earned:', `€${results.moneyEarned}`);
    console.log('XP Earned:', results.xpEarned);
    console.log('Arrests:', results.arrests);
    
    if (results.heatManagement) {
      console.log('\n--- Heat Management ---');
      console.log('Bails Paid:', results.heatManagement.bailsPaid);
      console.log('Wanted Level Reduced:', results.heatManagement.wantedLevelReduced);
    }

    // Get final state
    const finalPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    console.log('\n--- Final State ---');
    console.log('Wanted Level:', finalPlayer?.wantedLevel, `(was ${initialPlayer?.wantedLevel})`);
    console.log('Money:', `€${finalPlayer?.money}`, `(was €${initialPlayer?.money})`);
    console.log('In Jail:', finalPlayer?.jailRelease && new Date(finalPlayer.jailRelease) > new Date() ? 'YES' : 'NO');
    console.log('Jail Release Time:', finalPlayer?.jailRelease || 'null (not in jail)');

    // Check heat management logs
    const heatLogs = await prisma.nPCActivityLog.findMany({
      where: {
        npcId: npc.id,
        activityType: 'HEAT_MANAGEMENT',
      },
      orderBy: {
        timestamp: 'desc',
      },
      take: 5,
    });

    if (heatLogs.length > 0) {
      console.log('\n--- Heat Management Log ---');
      heatLogs.forEach((log, i) => {
        console.log(`${i + 1}. ${log.activityType}:`, log.details);
      });
    }

    // Test result
    console.log('\n=== Test Result ===');
    const gotOutOfJail = !finalPlayer?.jailRelease || new Date(finalPlayer.jailRelease) <= new Date();
    
    if (results.heatManagement && results.heatManagement.bailsPaid && results.heatManagement.bailsPaid > 0 && gotOutOfJail) {
      console.log('✅ SUCCESS! NPC paid bail and got out of jail');
      console.log(`   - Paid €${bailCost} bail`);
      console.log(`   - Reduced wanted level from ${initialPlayer?.wantedLevel} to ${finalPlayer?.wantedLevel}`);
      console.log(`   - Performed ${results.activitiesPerformed} activities after release`);
    } else if (!gotOutOfJail) {
      console.log('❌ FAILED! NPC is still in jail');
    } else {
      console.log('⚠️  No bail payment (this might indicate the NPC had no money or the test setup failed)');
    }

  } catch (error) {
    console.error('Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testNPCJailBail();
