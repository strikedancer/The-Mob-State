import prisma from './src/lib/prisma';

async function fixBrokenTransport() {
  try {
    console.log('Searching for broken transport records...');
    
    // Find vehicles with NULL transportDestination but other transport fields set
    const brokenRecords = await prisma.vehicleInventory.findMany({
      where: {
        transportDestination: null,
        OR: [
          { transportStatus: { not: null } },
          { transportArrivalTime: { not: null } }
        ]
      },
      select: {
        id: true,
        vehicleId: true,
        transportStatus: true,
        transportArrivalTime: true
      }
    });

    console.log(`Found ${brokenRecords.length} broken transport records:`, brokenRecords);

    if (brokenRecords.length > 0) {
      // Clear all transport fields for these records
      const result = await prisma.vehicleInventory.updateMany({
        where: {
          transportDestination: null,
          OR: [
            { transportStatus: { not: null } },
            { transportArrivalTime: { not: null } }
          ]
        },
        data: {
          transportStatus: null,
          transportArrivalTime: null
        }
      });

      console.log(`✅ Fixed ${result.count} broken transport records!`);
    } else {
      console.log('✅ No broken records found!');
    }

  } catch (error) {
    console.error('❌ Error fixing transport records:', error);
  } finally {
    await prisma.$disconnect();
  }
}

fixBrokenTransport();
