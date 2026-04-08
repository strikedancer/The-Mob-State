import { NPCService } from './src/services/npcService';

async function testNPCSurvival() {
  console.log('🧪 Testing NPC survival needs management...\n');
  
  try {
    const { default: prisma } = await import('./src/lib/prisma');
    
    // Set NPC #2 with low health, hunger, and thirst
    await prisma.player.update({
      where: { id: 23 },
      data: {
        health: 25,
        hunger: 20,
        thirst: 15,
        money: 5000,
        jailRelease: null,
        lastHospitalVisit: null, // Clear cooldown
      },
    });
    
    console.log('📊 Initial State:');
    console.log('  Health: 25 (critical!)');
    console.log('  Hunger: 20 (very hungry!)');
    console.log('  Thirst: 15 (very thirsty!)');
    console.log('  Money: €5000\n');
    
    console.log('⏳ Simulating 24 hours...\n');
    
    // Simulate NPC #2 for 24 hours
    const result = await NPCService.simulateActivity(2, 24);
    
    console.log('📊 Simulation Results:');
    console.log(JSON.stringify(result, null, 2));
    
    // Check final state
    const finalPlayer = await prisma.player.findUnique({
      where: { id: 23 },
      select: {
        health: true,
        hunger: true,
        thirst: true,
        money: true,
      },
    });
    
    console.log('\n🔍 Final State:');
    console.log(`  Health: ${finalPlayer?.health} (${finalPlayer && finalPlayer.health > 25 ? '✅ improved' : '❌ not improved'})`);
    console.log(`  Hunger: ${finalPlayer?.hunger} (${finalPlayer && finalPlayer.hunger > 20 ? '✅ improved' : '❌ not improved'})`);
    console.log(`  Thirst: ${finalPlayer?.thirst} (${finalPlayer && finalPlayer.thirst > 15 ? '✅ improved' : '❌ not improved'})`);
    console.log(`  Money: €${finalPlayer?.money}\n`);
    
    // Check activity logs
    const survivalLogs = await prisma.nPCActivityLog.findMany({
      where: {
        npcId: 2,
        activityType: 'SURVIVAL',
      },
      orderBy: { timestamp: 'desc' },
      take: 10,
    });
    
    console.log('📝 Survival Activities:');
    survivalLogs.forEach(log => {
      const details = log.details as any;
      if (details.action === 'hospital') {
        console.log(`  🏥 Hospital visit (health was ${details.healthBefore})`);
      } else if (details.action === 'buy_food') {
        console.log(`  🍔 Bought ${details.item} (+${details.hungerRestored} hunger)`);
      } else if (details.action === 'buy_drink') {
        console.log(`  🥤 Bought ${details.item} (+${details.thirstRestored} thirst)`);
      }
    });
    
    if (result.survival) {
      console.log('\n✅ SUCCESS! NPCs manage their survival needs:');
      console.log(`   - Hospital visits: ${result.survival.hospitalVisits || 0}`);
      console.log(`   - Food bought: ${result.survival.foodBought || 0}`);
      console.log(`   - Drinks bought: ${result.survival.drinksBought || 0}`);
    } else {
      console.log('\n⚠️  No survival actions taken (might be OK if needs were met)');
    }
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

testNPCSurvival();
