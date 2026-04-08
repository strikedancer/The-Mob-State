import prisma from './src/lib/prisma';
import { worldEventService } from './src/services/worldEventService';

async function seedEvents() {
  console.log('🌱 Seeding test events...');

  await worldEventService.createEvent('player.registered', { username: 'testuser' }, 1);

  await worldEventService.createEvent(
    'player.death',
    { username: 'deadplayer', cause: 'hunger' },
    2
  );

  await worldEventService.createEvent(
    'hospital.healed',
    { username: 'hospitaltest', healthRestored: 50 },
    6
  );

  console.log('✅ Test events created!');

  await prisma.$disconnect();
}

seedEvents().catch((error) => {
  console.error('❌ Error seeding events:', error);
  process.exit(1);
});
