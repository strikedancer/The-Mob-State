import { PrismaClient } from '@prisma/client';
import prismaConfig from './prisma.config';

const prisma = new PrismaClient(prismaConfig);

async function main() {
  const player = await prisma.player.findFirst({
    where: { username: 'testuser2' },
  });

  if (!player) {
    console.log('❌ testuser2 not found');
    return;
  }

  // Check current vehicles
  const existing = await prisma.vehicleInventory.findMany({
    where: { playerId: player.id },
  });

  console.log(`Player: ${player.username} (ID: ${player.id})`);
  console.log(`Current vehicles: ${existing.length}`);
  existing.forEach((v) => {
    console.log(`  - ${v.vehicleId} in ${v.currentLocation}`);
  });

  // Add Ferrari
  await prisma.vehicleInventory.create({
    data: {
      playerId: player.id,
      vehicleType: 'car',
      vehicleId: 'ferrari-f40',
      stolenInCountry: 'netherlands',
      currentLocation: 'netherlands',
      condition: 100,
      fuelLevel: 100,
      stolenAt: new Date(),
    },
  });

  console.log('✅ Ferrari F40 added to garage');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
