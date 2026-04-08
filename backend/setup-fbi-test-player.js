/**
 * Setup high-level test player for FBI testing
 */

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function setupHighLevelPlayer() {
  try {
    // Create or update FBI test player with high level
    const username = 'fbi_test_highlevel';
    const password = 'test123';
    const passwordHash = await bcrypt.hash(password, 10);
    
    // Delete existing player
    await prisma.player.deleteMany({
      where: { username },
    });
    
    // Create new high-level player
    const player = await prisma.player.create({
      data: {
        username,
        passwordHash,
        money: 1000000, // €1M for bail tests
        health: 100,
        hunger: 100,
        thirst: 100,
        rank: 30, // High rank to unlock all federal crimes
        xp: 30000,
        wantedLevel: 0,
        fbiHeat: 0,
      },
    });
    
    console.log('✅ High-level test player created:');
    console.log(`   Username: ${username}`);
    console.log(`   Password: ${password}`);
    console.log(`   ID: ${player.id}`);
    console.log(`   Rank: ${player.rank}`);
    console.log(`   Money: €${player.money}`);
    console.log(`   FBI Heat: ${player.fbiHeat}`);
    console.log('\n📝 Use these credentials to test FBI system:');
    console.log('   All federal crimes unlocked (bank_robbery, casino_heist, kidnapping, etc.)');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

setupHighLevelPlayer();
