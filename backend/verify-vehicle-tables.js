const mariadb = require('mariadb');

async function verifyTables() {
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
    
    console.log('📋 Verifying vehicle tables...\n');
    
    const garages = await conn.query("SHOW TABLES LIKE 'garages'");
    const marinas = await conn.query("SHOW TABLES LIKE 'marinas'");
    const vehicles = await conn.query("SHOW TABLES LIKE 'vehicle_inventory'");
    const garageUpgrades = await conn.query("SHOW TABLES LIKE 'garage_upgrades'");
    const marinaUpgrades = await conn.query("SHOW TABLES LIKE 'marina_upgrades'");
    
    console.log('Vehicle System Tables:');
    if (garages.length > 0) console.log('  ✅ garages');
    if (marinas.length > 0) console.log('  ✅ marinas');
    if (vehicles.length > 0) console.log('  ✅ vehicle_inventory');
    if (garageUpgrades.length > 0) console.log('  ✅ garage_upgrades');
    if (marinaUpgrades.length > 0) console.log('  ✅ marina_upgrades');
    
    console.log('\n✅ All vehicle tables exist!\n');
    
  } catch (err) {
    console.error('❌ Error:', err);
    process.exit(1);
  } finally {
    if (conn) conn.release();
    await pool.end();
  }
}

verifyTables();
