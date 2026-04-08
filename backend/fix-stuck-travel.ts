import prisma from './src/lib/prisma';

async function fixStuckTravel() {
  try {
    const result = await prisma.player.update({
      where: { username: 'testuser2' },
      data: {
        travelingTo: null,
        travelRoute: null,
        currentTravelLeg: 0,
        travelStartedAt: null,
      },
    });

    console.log('✅ Travel state fixed for testuser2');
    console.log('Current country:', result.currentCountry);
    console.log('Traveling to:', result.travelingTo);
    console.log('Current leg:', result.currentTravelLeg);
  } catch (error) {
    console.error('❌ Error fixing travel state:', error);
  } finally {
    await prisma.$disconnect();
  }
}

fixStuckTravel();
