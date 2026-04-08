import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function checkLanguages() {
  const players = await prisma.player.findMany({
    select: {
      id: true,
      username: true,
      preferredLanguage: true,
    },
  });

  console.log('Players and their preferred languages:');
  console.table(players);

  await prisma.$disconnect();
}

checkLanguages().catch(console.error);
