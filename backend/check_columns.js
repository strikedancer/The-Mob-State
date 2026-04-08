const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function checkColumns() {
  try {
    const crews = await prisma.$queryRaw`
      SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
      WHERE TABLE_NAME='crews' AND TABLE_SCHEMA='mafia_game' 
      ORDER BY ORDINAL_POSITION
    `;
    console.log('Crews table columns:');
    crews.forEach(row => console.log('  -', row.COLUMN_NAME));
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

checkColumns();
