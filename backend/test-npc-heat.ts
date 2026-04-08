import prisma from './src/lib/prisma';
import { NPCService } from './src/services/npcService';

async function testNPCHeatManagement() {
  console.log('\n=== NPC Heat Management Test ===\n');

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

    // Set high wanted level and give money for bail
    const highWantedLevel = 10;
    const bailCost = highWantedLevel * 1000; // €10,000
    
    await prisma.player.update({
      where: { id: npc.playerId },
      data: {
        wantedLevel: highWantedLevel,
        money: bailCost * 2, // Give 2x bail cost
        jailRelease: null, // Make sure not in jail
      },
    });

    console.log('\n--- Initial State ---');
    const initialPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    console.log('Wanted Level:', initialPlayer?.wantedLevel);
    console.log('Money:', `€${initialPlayer?.money}`);
    console.log('Bail Cost:', `€${bailCost}`);
    console.log('In Jail:', initialPlayer?.jailRelease !== null);

    // Simulate 24 hours of activity
    console.log('\n--- Simulating 24 Hours ---');
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

    if (results.purchases) {
      console.log('\n--- Purchases ---');
      console.log('Vehicles Stolen:', results.purchases.vehicles);
      console.log('Weapons Bought:', results.purchases.weapons);
      console.log('Properties Bought:', results.purchases.properties);
    }

    // Get final state
    const finalPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    console.log('\n--- Final State ---');
    console.log('Wanted Level:', finalPlayer?.wantedLevel, `(was ${initialPlayer?.wantedLevel})`);
    console.log('Money:', `€${finalPlayer?.money}`, `(was €${initialPlayer?.money})`);
    console.log('In Jail:', finalPlayer?.jailRelease !== null);

    // Check activity logs
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
    if (results.heatManagement && results.heatManagement.bailsPaid && results.heatManagement.bailsPaid > 0) {
      console.log('✅ SUCCESS! NPC paid bail and reduced wanted level');
    } else if (finalPlayer && finalPlayer.wantedLevel < initialPlayer!.wantedLevel) {
      console.log('✅ SUCCESS! Wanted level was reduced');
    } else {
      console.log('⚠️  No heat management actions taken (this might be expected if NPC was arrested early)');
    }

  } catch (error) {
    console.error('Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testNPCHeatManagement();
