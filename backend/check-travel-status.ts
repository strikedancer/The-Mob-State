import prisma from './src/lib/prisma';

async function checkTravelStatus() {
  try {
    // Find the player (assuming testuser2 is the current test user)
    const player = await prisma.player.findFirst({
      where: {
        username: 'testuser2',
      },
      select: {
        id: true,
        username: true,
        currentCountry: true,
        travelingTo: true,
        travelRoute: true,
        currentTravelLeg: true,
        travelStartedAt: true,
      },
    });

    if (!player) {
      console.log('❌ Player not found');
      return;
    }

    console.log('✅ Travel status for', player.username);
    console.log('Current country:', player.currentCountry);
    console.log('Traveling to:', player.travelingTo);
    console.log('Travel route:', player.travelRoute);
    console.log('Current leg:', player.currentTravelLeg);
    console.log('Travel started:', player.travelStartedAt);

    if (player.travelRoute) {
      try {
        const route = JSON.parse(JSON.stringify(player.travelRoute));
        console.log('\nRoute details:');
        console.log('  Total stops:', route.length);
        route.forEach((stop: string, index: number) => {
          const marker = index === player.currentTravelLeg ? '👉' : '  ';
          console.log(`  ${marker} [${index}] ${stop}`);
        });
      } catch (e) {
        console.log('Error parsing route:', e);
      }
    }
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

checkTravelStatus();
