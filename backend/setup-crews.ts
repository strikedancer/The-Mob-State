import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function setupCrewTables() {
  console.log('🔧 Setting up Crew tables...\n');

  try {
    // Execute raw SQL to create tables
    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS \`crews\` (
        \`id\` INTEGER NOT NULL AUTO_INCREMENT,
        \`name\` VARCHAR(50) NOT NULL,
        \`bankBalance\` INTEGER NOT NULL DEFAULT 0,
        \`createdAt\` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
        UNIQUE INDEX \`crews_name_key\`(\`name\`),
        INDEX \`crews_name_idx\`(\`name\`),
        PRIMARY KEY (\`id\`)
      ) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
    `);

    console.log('✅ Created crews table');

    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS \`crew_members\` (
        \`id\` INTEGER NOT NULL AUTO_INCREMENT,
        \`crewId\` INTEGER NOT NULL,
        \`playerId\` INTEGER NOT NULL,
        \`role\` VARCHAR(20) NOT NULL,
        \`joinedAt\` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
        INDEX \`crew_members_playerId_idx\`(\`playerId\`),
        INDEX \`crew_members_crewId_idx\`(\`crewId\`),
        UNIQUE INDEX \`crew_members_crewId_playerId_key\`(\`crewId\`, \`playerId\`),
        PRIMARY KEY (\`id\`)
      ) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
    `);

    console.log('✅ Created crew_members table');

    // Add foreign key if not exists
    try {
      await prisma.$executeRawUnsafe(`
        ALTER TABLE \`crew_members\` 
        ADD CONSTRAINT \`crew_members_crewId_fkey\` 
        FOREIGN KEY (\`crewId\`) REFERENCES \`crews\`(\`id\`) 
        ON DELETE CASCADE ON UPDATE CASCADE
      `);
      console.log('✅ Added foreign key constraint');
    } catch (e: any) {
      if (e.message.includes('Duplicate')) {
        console.log('⚠️  Foreign key already exists');
      } else {
        throw e;
      }
    }

    console.log('\n✅ Crew tables setup complete!');
    console.log('\n📝 Regenerating Prisma Client...');
    
  } catch (error: any) {
    console.error('❌ Error:', error.message);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

setupCrewTables();
