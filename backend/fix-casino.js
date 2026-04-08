const mariadb = require('mariadb');

async function fixCasinos() {
  const pool = mariadb.createPool({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'mafia_game'
  });

  let conn;
  try {
    conn = await pool.getConnection();
    
    console.log('🎰 Fixing casino properties...');
    
    // First, get testuser2's playerId (casino owner)
    const [owner] = await conn.query("SELECT id FROM players WHERE username = 'testuser2'");
    if (!owner) {
      console.error('❌ testuser2 not found!');
      process.exit(1);
    }
    const ownerId = owner.id;
    console.log(`✅ Found casino owner: testuser2 (ID: ${ownerId})`);
    
    // Delete old casino properties
    await conn.query("DELETE FROM properties WHERE propertyType = 'casino'");
    console.log('✅ Deleted old casino properties');
    
    // Insert 10 casino properties with testuser2 as owner
    await conn.query(`
      INSERT INTO properties (propertyId, propertyType, countryId, playerId, purchasePrice) VALUES
      ('casino_netherlands', 'casino', 'netherlands', ${ownerId}, 500000),
      ('casino_belgium', 'casino', 'belgium', ${ownerId}, 500000),
      ('casino_germany', 'casino', 'germany', ${ownerId}, 500000),
      ('casino_france', 'casino', 'france', ${ownerId}, 500000),
      ('casino_spain', 'casino', 'spain', ${ownerId}, 500000),
      ('casino_italy', 'casino', 'italy', ${ownerId}, 500000),
      ('casino_united_kingdom', 'casino', 'united_kingdom', ${ownerId}, 500000),
      ('casino_austria', 'casino', 'austria', ${ownerId}, 500000),
      ('casino_switzerland', 'casino', 'switzerland', ${ownerId}, 500000),
      ('casino_sweden', 'casino', 'sweden', ${ownerId}, 500000)
    `);
    console.log('✅ Inserted 10 casino properties');
    
    // Verify
    const casinos = await conn.query("SELECT * FROM properties WHERE propertyType = 'casino'");
    console.log(`\n✅ Done! Found ${casinos.length} casino properties:`);
    casinos.forEach(c => console.log(`  - ${c.propertyId} (owner: ${c.playerId})`));
    
  } catch (err) {
    console.error('❌ Error:', err);
    process.exit(1);
  } finally {
    if (conn) conn.release();
    await pool.end();
  }
}

fixCasinos();
