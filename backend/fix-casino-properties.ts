import prisma from './src/lib/prisma';

async function fixCasinoProperties() {
  console.log('🎰 Fixing casino properties...');
  
  // Use raw SQL to delete and insert
  await prisma.$executeRaw`DELETE FROM properties WHERE propertyType = 'casino'`;
  console.log('Deleted old casino properties');
  
  // Insert casino properties
  await prisma.$executeRaw`
    INSERT INTO properties (propertyId, propertyType, countryId) VALUES
    ('casino_netherlands', 'casino', 'netherlands'),
    ('casino_belgium', 'casino', 'belgium'),
    ('casino_germany', 'casino', 'germany'),
    ('casino_france', 'casino', 'france'),
    ('casino_spain', 'casino', 'spain'),
    ('casino_italy', 'casino', 'italy'),
    ('casino_united_kingdom', 'casino', 'united_kingdom'),
    ('casino_austria', 'casino', 'austria'),
    ('casino_switzerland', 'casino', 'switzerland'),
    ('casino_sweden', 'casino', 'sweden')
  `;
  console.log('✅ Inserted 10 casino properties');
  
  // Verify
  const casinos = await prisma.property.findMany({
    where: { propertyType: 'casino' },
  });
  
  console.log(`\n✅ Done! ${casinos.length} casino properties:`);
  casinos.forEach((c: { propertyId: string }) => console.log(`  - ${c.propertyId}`));
  
  await prisma.$disconnect();
}

fixCasinoProperties().catch((e) => {
  console.error('Error:', e);
  process.exit(1);
});
