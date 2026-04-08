import prisma from './src/lib/prisma';
import { weaponService } from './src/services/weaponService';
import { ammoService } from './src/services/ammoService';

async function main() {
  console.log('🧪 Testing Weapons & Ammunition System\n');

  try {
    // Find test player
    let testPlayer = await prisma.player.findFirst({
      where: { username: 'testuser2' }
    });

    if (!testPlayer) {
      console.log('Creating test player...');
      testPlayer = await prisma.player.create({
        data: {
          username: 'weapons_test_' + Date.now(),
          passwordHash: '$2a$10$test',
          health: 100,
          hunger: 100,
          thirst: 100,
          money: 100000,
          rank: 30,
          currentCountry: 'NL'
        }
      });
    }

    const playerId = testPlayer.id;
    console.log(`✅ Test player: ${testPlayer.username} (ID: ${playerId})`);
    console.log(`   Money: €${testPlayer.money.toLocaleString()}\n`);

    // Clean up
    await prisma.weaponInventory.deleteMany({ where: { playerId } });
    await prisma.ammoInventory.deleteMany({ where: { playerId } });

    // TEST 1: Buy a knife (no ammo required)
    console.log('TEST 1: Buy a knife');
    console.log('='.repeat(60));
    
    const knifeResult = await weaponService.buyWeapon(playerId, 'knife');
    console.log(`Buy result: ${knifeResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
    if (knifeResult.weapon) {
      console.log(`Weapon: ${knifeResult.weapon.name} (€${knifeResult.weapon.price})`);
      console.log(`Damage: ${knifeResult.weapon.damage}, Intimidation: ${knifeResult.weapon.intimidation}`);
    }
    console.log();

    // TEST 2: Buy a pistol
    console.log('TEST 2: Buy a pistol (requires ammo)');
    console.log('='.repeat(60));
    
    const pistolResult = await weaponService.buyWeapon(playerId, 'pistol');
    console.log(`Buy result: ${pistolResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
    if (pistolResult.weapon) {
      console.log(`Weapon: ${pistolResult.weapon.name} (€${pistolResult.weapon.price})`);
      console.log(`Ammo type: ${pistolResult.weapon.ammoType}, Per crime: ${pistolResult.weapon.ammoPerCrime}`);
    }
    console.log();

    // TEST 3: Buy 9mm ammo
    console.log('TEST 3: Buy 9mm ammo (5 boxes = 250 rounds)');
    console.log('='.repeat(60));
    
    const ammoResult = await ammoService.buyAmmo(playerId, '9mm', 5);
    console.log(`Buy result: ${ammoResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
    if (ammoResult.success) {
      console.log(`Rounds purchased: ${ammoResult.roundsPurchased}`);
      console.log(`Total cost: €${ammoResult.totalCost}`);
    }
    console.log();

    // TEST 4: Check inventory
    console.log('TEST 4: Check inventory');
    console.log('='.repeat(60));
    
    const weapons = await weaponService.getPlayerWeapons(playerId);
    console.log(`Weapons owned: ${weapons.length}`);
    weapons.forEach(w => {
      console.log(`  - ${w.name}: Condition ${w.condition}%, ${w.isBroken ? '🔧 BROKEN' : w.needsRepair ? '⚠️  NEEDS REPAIR' : '✅ GOOD'}`);
    });
    
    const ammo = await ammoService.getPlayerAmmo(playerId);
    console.log(`Ammo types: ${ammo.length}`);
    ammo.forEach(a => {
      console.log(`  - ${a.name}: ${a.quantity} rounds`);
    });
    console.log();

    // TEST 5: Degrade weapon
    console.log('TEST 5: Degrade pistol (simulate 10 uses)');
    console.log('='.repeat(60));
    
    for (let i = 0; i < 10; i++) {
      await weaponService.degradeWeapon(playerId, 'pistol');
    }
    
    const weaponsAfterUse = await weaponService.getPlayerWeapons(playerId);
    const pistol = weaponsAfterUse.find(w => w.weaponId === 'pistol');
    console.log(`Pistol condition after 10 uses: ${pistol?.condition}%`);
    console.log(`Needs repair: ${pistol?.needsRepair ? '⚠️  YES' : '✅ NO'}`);
    console.log();

    // TEST 6: Repair weapon
    console.log('TEST 6: Repair pistol');
    console.log('='.repeat(60));
    
    if (pistol && typeof pistol.id === 'number') {
      const repairResult = await weaponService.repairWeapon(playerId, pistol.id);
      console.log(`Repair result: ${repairResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
      if (repairResult.success) {
        console.log(`Repair cost: €${repairResult.repairCost}`);
      }
      
      const weaponsAfterRepair = await weaponService.getPlayerWeapons(playerId);
      const repairedPistol = weaponsAfterRepair.find(w => w.weaponId === 'pistol');
      console.log(`Pistol condition after repair: ${repairedPistol?.condition}%`);
    }
    console.log();

    // TEST 7: Consume ammo
    console.log('TEST 7: Consume ammo (simulate 5 crimes, 3 rounds each)');
    console.log('='.repeat(60));
    
    const ammoBefore = await ammoService.getAmmoCount(playerId, '9mm');
    console.log(`9mm ammo before: ${ammoBefore} rounds`);
    
    for (let i = 0; i < 5; i++) {
      await ammoService.consumeAmmo(playerId, '9mm', 3);
    }
    
    const ammoAfter = await ammoService.getAmmoCount(playerId, '9mm');
    console.log(`9mm ammo after: ${ammoAfter} rounds`);
    console.log(`Rounds consumed: ${ammoBefore - ammoAfter}`);
    console.log();

    // TEST 8: Sell weapon
    console.log('TEST 8: Sell knife');
    console.log('='.repeat(60));
    
    const weaponsBefore = await weaponService.getPlayerWeapons(playerId);
    const knife = weaponsBefore.find(w => w.weaponId === 'knife');
    
    if (knife && typeof knife.id === 'number') {
      const sellResult = await weaponService.sellWeapon(playerId, knife.id);
      console.log(`Sell result: ${sellResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
      if (sellResult.success) {
        console.log(`Sell price: €${sellResult.sellPrice}`);
      }
    }
    console.log();

    // TEST 9: Sell ammo
    console.log('TEST 9: Sell 100 rounds of 9mm');
    console.log('='.repeat(60));
    
    const sellAmmoResult = await ammoService.sellAmmo(playerId, '9mm', 100);
    console.log(`Sell result: ${sellAmmoResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
    if (sellAmmoResult.success) {
      console.log(`Sell price: €${sellAmmoResult.sellPrice}`);
    }
    
    const finalAmmo = await ammoService.getAmmoCount(playerId, '9mm');
    console.log(`9mm ammo remaining: ${finalAmmo} rounds`);
    console.log();

    // TEST 10: Try to buy weapon without enough rank
    console.log('TEST 10: Try to buy sniper rifle (requires rank 25)');
    console.log('='.repeat(60));
    
    // Lower rank temporarily
    await prisma.player.update({
      where: { id: playerId },
      data: { rank: 10 }
    });
    
    const sniperResult = await weaponService.buyWeapon(playerId, 'sniper_rifle');
    console.log(`Buy result: ${sniperResult.success ? '✅ SUCCESS' : '❌ FAILED'}`);
    console.log(`Error: ${sniperResult.error || 'None'}`);
    
    // Restore rank
    await prisma.player.update({
      where: { id: playerId },
      data: { rank: 30 }
    });
    console.log();

    console.log('═'.repeat(60));
    console.log('✅ ALL WEAPONS & AMMO TESTS COMPLETED!');
    console.log('═'.repeat(60));

  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
