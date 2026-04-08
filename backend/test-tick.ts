import prisma from './src/lib/prisma';
import { playerService } from './src/services/playerService';
import config from './src/config';

async function testTick() {
  console.log('🧪 Testing hunger/thirst tick system...\n');

  try {
    // Find a test player
    const player = await prisma.player.findFirst({
      where: { username: 'testplayer' },
    });

    if (!player) {
      console.log('❌ No test player found. Register first with /auth/register');
      return;
    }

    console.log('📊 Initial stats:');
    console.log(`   Hunger: ${player.hunger}`);
    console.log(`   Thirst: ${player.thirst}`);
    console.log(`   Health: ${player.health}`);
    console.log(`   Last tick: ${player.lastTickAt}\n`);

    // Apply tick
    console.log(
      `⏰ Applying tick (hunger -${config.hungerTickAmount}, thirst -${config.thirstTickAmount})...\n`
    );

    const result = await playerService.applyHungerThirstTick(
      player.id,
      config.hungerTickAmount,
      config.thirstTickAmount
    );

    console.log('📊 After tick:');
    console.log(`   Hunger: ${result.newHunger}`);
    console.log(`   Thirst: ${result.newThirst}`);
    console.log(`   Died: ${result.died}\n`);

    if (result.died) {
      console.log('💀 Player died from starvation/dehydration!');
    } else if (result.newHunger < 20 || result.newThirst < 20) {
      console.log('⚠️  Warning: Player in danger!');
    } else {
      console.log('✅ Player is healthy');
    }

    console.log('\n✅ Tick test complete!');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

testTick();
