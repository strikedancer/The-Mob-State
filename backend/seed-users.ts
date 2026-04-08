import prisma from './src/lib/prisma';

async function seedUsers() {
  try {
    console.log('🌱 Starting to seed test users...');

    // Password hash for "test123"
    const hashedPassword = '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC';

    // Delete existing test users
    await prisma.player.deleteMany({
      where: {
        username: {
          in: ['testuser1', 'testuser2', 'testplayer'],
        },
      },
    });
    console.log('✅ Deleted existing test users');

    // Create testuser2
    const user2 = await prisma.player.create({
      data: {
        username: 'testuser2',
        passwordHash: hashedPassword,
        money: 1000000,
        health: 100,
        hunger: 100,
        thirst: 100,
        rank: 30,
        xp: 50000,
        wantedLevel: 0,
        fbiHeat: 0,
        currentCountry: 'netherlands',
        preferredLanguage: 'nl',
      },
    });
    console.log('✅ Created testuser2:', user2.username);

    // Create testuser1
    const user1 = await prisma.player.create({
      data: {
        username: 'testuser1',
        passwordHash: hashedPassword,
        money: 500000,
        health: 100,
        hunger: 100,
        thirst: 100,
        rank: 20,
        xp: 30000,
        wantedLevel: 0,
        fbiHeat: 0,
        currentCountry: 'netherlands',
        preferredLanguage: 'nl',
      },
    });
    console.log('✅ Created testuser1:', user1.username);

    // Create testplayer
    const player = await prisma.player.create({
      data: {
        username: 'testplayer',
        passwordHash: hashedPassword,
        money: 500000,
        health: 100,
        hunger: 100,
        thirst: 100,
        rank: 25,
        xp: 25000,
        wantedLevel: 50,
        fbiHeat: 15,
        currentCountry: 'netherlands',
        preferredLanguage: 'nl',
      },
    });
    console.log('✅ Created testplayer:', player.username);

    console.log('\n🎉 Seed completed! All test users are ready.');
    console.log('\nTest Credentials:');
    console.log('  testuser1 / test123');
    console.log('  testuser2 / test123');
    console.log('  testplayer / test123');

    process.exit(0);
  } catch (error) {
    console.error('❌ Seed failed:', error);
    process.exit(1);
  }
}

seedUsers();
