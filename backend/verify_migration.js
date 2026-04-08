const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function verify() {
  try {
    const crews = await prisma.$queryRaw`
      SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_NAME='crews' AND TABLE_SCHEMA='mafia_game'
      ORDER BY ORDINAL_POSITION
    `;
    
    const players = await prisma.$queryRaw`
      SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_NAME='players' AND TABLE_SCHEMA='mafia_game'
      ORDER BY ORDINAL_POSITION
    `;
    
    console.log('✅ Crews table columns:');
    crews.forEach(r => console.log('  -', r.COLUMN_NAME));
    
    console.log('\n✅ Players table columns:');
    players.forEach(r => console.log('  -', r.COLUMN_NAME));
    
    // Verify the new columns specifically
    const hasCrewsMollieCol = crews.some(r => r.COLUMN_NAME === 'mollieSubscriptionId');
    const hasPlayersMollieCol = players.some(r => r.COLUMN_NAME === 'mollieCustomerId');
    
    console.log('\n✅ Mollie columns present:');
    console.log('  - crews.mollieSubscriptionId:', hasCrewsMollieCol ? 'YES' : 'NO');
    console.log('  - players.mollieCustomerId:', hasPlayersMollieCol ? 'YES' : 'NO');
    
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

verify();
