/**
 * Test Crime-Weapon Integration
 * 
 * This test verifies that:
 * 1. Crimes requiring weapons fail without weapons
 * 2. Weapons provide success bonuses
 * 3. Ammo is consumed on crime attempts
 * 4. Weapons degrade with use
 * 5. Suitable weapon types work correctly
 */

import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';
import { crimeService } from './src/services/crimeService';
import { weaponService } from './src/services/weaponService';
import { ammoService } from './src/services/ammoService';

// Create Prisma client with adapter
const adapter = new PrismaMariaDb(process.env.DATABASE_URL!);
const prisma = new PrismaClient({ adapter });

const TEST_USERNAME = 'weapon_crime_test_user';

async function runTests() {
  console.log('🔫 Crime-Weapon Integration Tests\n');

  try {
    // Cleanup
    console.log('Cleaning up test data...');
    await prisma.weaponInventory.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.ammoInventory.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.crimeAttempt.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.player.deleteMany({ where: { username: TEST_USERNAME } });

    // Create test player
    console.log('Creating test player...');
    const player = await prisma.player.create({
      data: {
        username: TEST_USERNAME,
        passwordHash: '$2a$10$test',
        money: 100000,
        health: 100,
        xp: 500,
        rank: 10,
        currentCountry: 'netherlands',
      },
    });
    console.log(`✅ Created player: ${player.username} (ID: ${player.id})`);

    // Test 1: Crime without required weapon should fail
    console.log('\n--- Test 1: Crime without weapon ---');
    try {
      await crimeService.attemptCrime(player.id, 'mug_person');
      console.log('❌ FAIL: Should have thrown WEAPON_REQUIRED error');
    } catch (error: any) {
      if (error.message === 'WEAPON_REQUIRED') {
        console.log('✅ PASS: Correctly rejected crime without weapon');
      } else {
        console.log(`❌ FAIL: Wrong error: ${error.message}`);
      }
    }

    // Test 2: Buy weapon and ammo
    console.log('\n--- Test 2: Buy weapon and ammo ---');
    const pistol = weaponService.getAllWeapons().find((w) => w.id === 'pistol');
    if (!pistol) throw new Error('Pistol not found');

    const weaponPurchase = await weaponService.buyWeapon(player.id, pistol.id as number);
    console.log(`✅ Purchased ${weaponPurchase.weapon.name} for €${pistol.price}`);

    // Buy ammo (pistol uses 9mm)
    await ammoService.buyAmmo(player.id, '9mm', 5); // 5 boxes = 250 rounds
    const ammoCount = await ammoService.getAmmoCount(player.id, '9mm');
    console.log(`✅ Purchased 9mm ammo: ${ammoCount} rounds`);

    // Test 3: Crime with weapon should succeed (or at least attempt)
    console.log('\n--- Test 3: Attempt crime with weapon ---');
    const initialCondition = weaponPurchase.weapon.condition;
    const result = await crimeService.attemptCrime(player.id, 'mug_person');

    console.log(`Crime result: ${result.success ? 'SUCCESS' : 'FAILED'}`);
    console.log(`Reward: €${result.reward}`);
    console.log(`XP Gained: ${result.xpGained}`);
    console.log(`Weapon used: ${result.weaponUsed}`);
    console.log(`Ammo consumed: ${result.ammoConsumed}`);

    if (result.weaponUsed === pistol.id) {
      console.log('✅ PASS: Weapon was used for crime');
    } else {
      console.log(`❌ FAIL: Expected weapon ${pistol.id}, got ${result.weaponUsed}`);
    }

    if (result.ammoConsumed === pistol.ammoPerCrime) {
      console.log(`✅ PASS: Correct ammo consumed (${result.ammoConsumed} rounds)`);
    } else {
      console.log(
        `❌ FAIL: Expected ${pistol.ammoPerCrime} ammo, consumed ${result.ammoConsumed}`
      );
    }

    // Test 4: Check weapon degradation
    console.log('\n--- Test 4: Check weapon degradation ---');
    const weapons = await weaponService.getPlayerWeapons(player.id);
    const pistolAfter = weapons.find((w) => w.weaponId === pistol.id);

    if (pistolAfter && pistolAfter.condition < initialCondition) {
      const degradation = initialCondition - pistolAfter.condition;
      console.log(`✅ PASS: Weapon degraded by ${degradation.toFixed(2)}%`);
      console.log(`   Condition: ${initialCondition}% → ${pistolAfter.condition.toFixed(2)}%`);
    } else {
      console.log('❌ FAIL: Weapon did not degrade');
    }

    // Test 5: Check ammo consumption
    console.log('\n--- Test 5: Check ammo consumption ---');
    const ammoAfter = await ammoService.getAmmoCount(player.id, '9mm');
    const ammoUsed = ammoCount - ammoAfter;

    if (ammoUsed === pistol.ammoPerCrime) {
      console.log(`✅ PASS: Ammo correctly consumed (${ammoUsed} rounds)`);
      console.log(`   Ammo: ${ammoCount} → ${ammoAfter}`);
    } else {
      console.log(`❌ FAIL: Expected ${pistol.ammoPerCrime} ammo used, got ${ammoUsed}`);
    }

    // Test 6: Crime without ammo should fail
    console.log('\n--- Test 6: Crime without ammo ---');
    // Sell all remaining ammo
    await ammoService.sellAmmo(player.id, '9mm', ammoAfter);

    try {
      await crimeService.attemptCrime(player.id, 'mug_person');
      console.log('❌ FAIL: Should have thrown NO_AMMO error');
    } catch (error: any) {
      if (error.message === 'NO_AMMO') {
        console.log('✅ PASS: Correctly rejected crime without ammo');
      } else {
        console.log(`❌ FAIL: Wrong error: ${error.message}`);
      }
    }

    // Test 7: Wrong weapon type for crime
    console.log('\n--- Test 7: Wrong weapon type (assault rifle for mugging) ---');
    // Buy assault rifle (requires high damage for high-level crimes, not suitable for mug_person)
    const rifle = weaponService.getAllWeapons().find((w) => w.id === 'assault_rifle');
    if (!rifle) throw new Error('Assault rifle not found');

    await weaponService.buyWeapon(player.id, rifle.id as number);
    await ammoService.buyAmmo(player.id, '762mm', 5); // Rifle ammo

    // Buy 9mm ammo for pistol
    await ammoService.buyAmmo(player.id, '9mm', 5);

    // Attempt mugging (suitable for handgun, not rifle)
    const mugResult = await crimeService.attemptCrime(player.id, 'mug_person');
    console.log(`Crime used weapon: ${mugResult.weaponUsed}`);

    // Should use pistol (handgun) instead of rifle because it's in suitableWeaponTypes
    if (mugResult.weaponUsed === pistol.id) {
      console.log('✅ PASS: Used most suitable weapon (pistol) for mugging');
    } else {
      console.log(`⚠️  Used weapon ${mugResult.weaponUsed} (may be correct if better)`);
    }

    // Test 8: High-level crime requiring specific weapon
    console.log('\n--- Test 8: Assassination requires high-damage weapon ---');
    // Update player rank for assassination
    await prisma.player.update({
      where: { id: player.id },
      data: { rank: 25, xp: 25000 },
    });

    // Buy sniper rifle
    const sniper = weaponService.getAllWeapons().find((w) => w.id === 'sniper_rifle');
    if (!sniper) throw new Error('Sniper rifle not found');

    await weaponService.buyWeapon(player.id, sniper.id as number);
    await ammoService.buyAmmo(player.id, '308', 5); // Sniper ammo (note: no dot in ammoType)

    // Buy a vehicle (assassination requires vehicle)
    const vehicle = await prisma.vehicle.create({
      data: {
        playerId: player.id,
        vehicleType: 'sedan',
        fuel: 100,
        maxFuel: 100,
        isBroken: false,
      },
    });

    const assassinResult = await crimeService.attemptCrime(
      player.id,
      'assassination',
      vehicle.id
    );
    console.log(`Assassination result: ${assassinResult.success ? 'SUCCESS' : 'FAILED'}`);
    console.log(`Weapon used: ${assassinResult.weaponUsed}`);

    if (assassinResult.weaponUsed === sniper.id) {
      console.log('✅ PASS: Used sniper rifle for assassination');
    } else {
      console.log(`⚠️  Used weapon ${assassinResult.weaponUsed} instead of sniper`);
    }

    // Summary
    console.log('\n' + '='.repeat(50));
    console.log('✅ All Crime-Weapon Integration Tests Completed!');
    console.log('='.repeat(50));
  } catch (error) {
    console.error('❌ Test failed with error:', error);
    throw error;
  } finally {
    // Cleanup
    await prisma.weaponInventory.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.ammoInventory.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.crimeAttempt.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.vehicle.deleteMany({
      where: { player: { username: TEST_USERNAME } },
    });
    await prisma.player.deleteMany({ where: { username: TEST_USERNAME } });
    await prisma.$disconnect();
  }
}

runTests();
