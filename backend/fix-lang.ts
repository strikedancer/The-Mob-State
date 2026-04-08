import prisma from './src/lib/prisma';

async function fix() {
  console.log('Updating all players to Dutch...');
  const result = await prisma.$executeRaw`UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en'`;
  console.log(`Updated ${result} players`);
  
  const all = await prisma.player.findMany({ select: { id: true, username: true, preferredLanguage: true } });
  console.table(all);
  
  await prisma.$disconnect();
}

fix();
