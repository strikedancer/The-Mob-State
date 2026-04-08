import { NPCService } from './src/services/npcService';

async function testNPCBoatTheft() {
  console.log('🧪 Testing NPC boat theft capability...\n');
  
  try {
    // Simulate NPC #2 for 24 hours
    const result = await NPCService.simulateActivity(2, 24);
    
    console.log('📊 Simulation Results:');
    console.log(JSON.stringify(result, null, 2));
    
    // Check what was stolen
    console.log('\n🔍 Checking vehicle inventory...');
    const { default: prisma } = await import('./src/lib/prisma');
    
    const vehicles = await prisma.vehicleInventory.findMany({
      where: { playerId: 23 },
      orderBy: { id: 'desc' },
      take: 10,
    });
    
    console.log('\n🚗 Vehicle Inventory:');
    vehicles.forEach(v => {
      const icon = v.vehicleType === 'boat' ? '⛵' : '🚗';
      console.log(`${icon} ${v.vehicleType.toUpperCase()}: ${v.vehicleId} (${v.condition}% condition, ${v.fuelLevel}% fuel)`);
    });
    
    const boatCount = vehicles.filter(v => v.vehicleType === 'boat').length;
    const carCount = vehicles.filter(v => v.vehicleType === 'car').length;
    
    console.log(`\n📈 Summary: ${carCount} cars, ${boatCount} boats`);
    
    if (boatCount > 0) {
      console.log('✅ SUCCESS! NPCs can steal boats!');
    } else {
      console.log('ℹ️  No boats stolen in this simulation (10% chance per crime)');
    }
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

testNPCBoatTheft();
