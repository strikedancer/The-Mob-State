import prisma from './src/lib/prisma';
import { NPCService } from './src/services/npcService';

async function testNPCRankAdvancement() {
  console.log('\n=== NPC Rank Advancement Test ===\n');

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

    // Set NPC with low rank and XP close to level up
    const targetXP = 900; // Close to 1000 XP (rank 2)
    const targetRank = 1;
    
    await prisma.player.update({
      where: { id: npc.playerId },
      data: {
        xp: targetXP,
        rank: targetRank,
        jailRelease: null, // Make sure not in jail
      },
    });

    console.log('\n--- Initial State ---');
    const initialPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });
    
    console.log('Rank:', initialPlayer?.rank);
    console.log('XP:', initialPlayer?.xp, '/ 1000 for next rank');
    console.log('Money:', `€${initialPlayer?.money}`);

    // Simulate 24 hours of activity
    console.log('\n--- Simulating 24 Hours (NPC should rank up) ---');
    const results = await NPCService.simulateActivity(npc.id, 24);

    console.log('\n--- Results ---');
    console.log('Activities Performed:', results.activitiesPerformed);
    console.log('Money Earned:', `€${results.moneyEarned}`);
    console.log('XP Earned:', results.xpEarned);
    console.log('Arrests:', results.arrests);

    // Get final state
    const finalPlayer = await prisma.player.findUnique({
      where: { id: npc.playerId },
    });

    console.log('\n--- Final State ---');
    console.log('Rank:', finalPlayer?.rank, `(was ${initialPlayer?.rank})`);
    console.log('XP:', finalPlayer?.xp, `(was ${initialPlayer?.xp})`);
    console.log('XP Gained:', finalPlayer!.xp - initialPlayer!.xp);
    console.log('Money:', `€${finalPlayer?.money}`, `(was €${initialPlayer?.money})`);

    // Calculate expected rank
    const expectedRank = Math.floor(finalPlayer!.xp / 1000) + 1;
    console.log('\n--- Rank Analysis ---');
    console.log('Expected Rank (based on XP):', expectedRank);
    console.log('Actual Rank:', finalPlayer?.rank);
    console.log('XP needed for next rank:', (expectedRank * 1000) - finalPlayer!.xp);

    // Test result
    console.log('\n=== Test Result ===');
    if (finalPlayer?.rank && finalPlayer.rank > initialPlayer!.rank) {
      console.log(`✅ SUCCESS! NPC ranked up from ${initialPlayer!.rank} to ${finalPlayer.rank}`);
      console.log(`   - XP increased from ${initialPlayer!.xp} to ${finalPlayer.xp} (+${finalPlayer.xp - initialPlayer!.xp})`);
      console.log(`   - Earned €${results.moneyEarned} across ${results.activitiesPerformed} activities`);
    } else if (finalPlayer?.rank === expectedRank) {
      console.log('✅ SUCCESS! Rank matches expected rank based on XP');
    } else {
      console.log('⚠️  No rank advancement (might need more XP or got arrested)');
      console.log(`   Current XP: ${finalPlayer?.xp}, Current Rank: ${finalPlayer?.rank}`);
    }

  } catch (error) {
    console.error('Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testNPCRankAdvancement();
