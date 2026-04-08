import { PrismaClient } from '@prisma/client';
import { execSync } from 'child_process';

const prisma = new PrismaClient();

async function updateDatabase() {
  try {
    console.log('📦 Pushing schema to database...');
    execSync('npx prisma db push --skip-generate', { 
      cwd: 'C:\\xampp\\htdocs\\mafia_game\\backend',
      stdio: 'inherit' 
    });
    
    console.log('\n🔄 Updating all existing players to Dutch...');
    const result = await prisma.$executeRaw`UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en'`;
    console.log(`✅ Updated ${result} players to Dutch`);
    
    console.log('\n📋 Current player languages:');
    const players = await prisma.player.findMany({
      select: { id: true, username: true, preferredLanguage: true }
    });
    
    console.table(players);
    
    await prisma.$disconnect();
    console.log('\n✅ All done!');
  } catch (error) {
    console.error('❌ Error:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

updateDatabase();
