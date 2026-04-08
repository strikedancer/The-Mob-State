import prisma from './src/lib/prisma';

/**
 * Check registered device tokens
 */

async function checkDevices() {
  console.log('=== Checking Registered Device Tokens ===\n');

  try {
    // Get all registered devices
    const devices = await prisma.playerDevice.findMany({
      include: {
        player: {
          select: {
            id: true,
            username: true,
          },
        },
      },
    });

    console.log(`Total registered devices: ${devices.length}\n`);

    // Group by device type
    const byType: any = {};
    devices.forEach((device: any) => {
      if (!byType[device.deviceType]) {
        byType[device.deviceType] = [];
      }
      byType[device.deviceType].push(device);
    });

    // Show per type
    Object.keys(byType).forEach((type) => {
      console.log(`\n${type.toUpperCase()} devices: ${byType[type].length}`);
      byType[type].forEach((device: any, idx: number) => {
        console.log(`  ${idx + 1}. ${device.player.username} (ID: ${device.player.id})`);
        console.log(`     Token: ${device.deviceToken.substring(0, 30)}...`);
        console.log(`     Created: ${device.createdAt}`);
      });
    });

    console.log('\n=== Summary ===');
    console.log(`Web devices: ${byType['web']?.length || 0}`);
    console.log(`Android devices: ${byType['android']?.length || 0}`);
    console.log(`iOS devices: ${byType['ios']?.length || 0}`);

  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

checkDevices();
