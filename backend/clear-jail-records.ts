import prisma from './src/lib/prisma';

async function clearJailRecords() {
  try {
    console.log('Clearing all jail records...');
    
    const result = await prisma.crimeAttempt.updateMany({
      where: {
        jailed: true,
      },
      data: {
        jailed: false,
      },
    });
    
    console.log(`✅ Updated ${result.count} jail records to jailed: false`);
  } catch (error) {
    console.error('❌ Error clearing jail records:', error);
  } finally {
    await prisma.$disconnect();
  }
}

clearJailRecords();
