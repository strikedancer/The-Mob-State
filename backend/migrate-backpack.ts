// Temporary migration script - run once
import prisma from './src/lib/prisma.js';

async function runMigration() {
  console.log('Running backpack system migration...');
  
  try {
    // Create player_backpacks table
    await prisma.$executeRaw`
      CREATE TABLE IF NOT EXISTS player_backpacks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        player_id INT NOT NULL UNIQUE,
        backpack_id VARCHAR(50) NOT NULL,
        purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_player_backpack (player_id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;
    
    console.log('✅ Created player_backpacks table');
    console.log('✅ Backpack system migration completed successfully!');
    console.log('');
    console.log('Note: Base carrying capacity is hardcoded to 5 slots.');
    console.log('The backpack slots are added dynamically via the backpackService.');
    
    await prisma.$disconnect();
    process.exit(0);
  } catch (error) {
    console.error('❌ Migration failed:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

runMigration();
