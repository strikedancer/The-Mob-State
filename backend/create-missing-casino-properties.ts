import prisma from './src/lib/prisma';

/**
 * Create missing casino properties for owned casinos
 * This ensures backward compatibility for casinos purchased before the upsert was added
 */
async function createMissingCasinoProperties() {
  try {
    console.log('🎰 Creating missing casino properties...');
    
    // Get all casino ownerships
    const ownerships = await prisma.casinoOwnership.findMany({
      select: {
        casinoId: true
      }
    });

    console.log(`Found ${ownerships.length} casino ownerships`);

    for (const ownership of ownerships) {
      const casinoId = ownership.casinoId;
      // Extract country from casinoId (e.g., "casino_belgium" -> "belgium")
      const countryId = casinoId.replace('casino_', '');
      
      // Check if property exists
      const existingProperty = await prisma.property.findUnique({
        where: { propertyId: casinoId }
      });

      if (!existingProperty) {
        // Create the property
        await prisma.property.create({
          data: {
            propertyId: casinoId,
            propertyType: 'casino',
            countryId: countryId,
            name: `Casino ${countryId.charAt(0).toUpperCase() + countryId.slice(1)}`,
            price: 0, // Price already paid
            income: 0
          }
        });
        console.log(`✅ Created casino property: ${casinoId}`);
      } else {
        console.log(`⏭️  Casino property already exists: ${casinoId}`);
      }
    }

    console.log('✅ All missing casino properties created');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error creating casino properties:', error);
    process.exit(1);
  }
}

createMissingCasinoProperties();
