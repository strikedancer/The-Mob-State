const mariadb = require('mariadb');
const fs = require('fs');

async function addVehicleTables() {
  const pool = mariadb.createPool({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'mafia_game',
    multipleStatements: true
  });

  let conn;
  try {
    conn = await pool.getConnection();
    
    console.log('🚗 Adding vehicle tables...\n');
    
    // Read SQL file
    const sql = fs.readFileSync('add-vehicle-tables.sql', 'utf8');
    
    // Execute SQL
    await conn.query(sql);
    console.log('✅ All tables created successfully!\n');
    
    // Verify
    const garages = await conn.query("SHOW TABLES LIKE 'garages'");
    const marinas = await conn.query("SHOW TABLES LIKE 'marinas'");
    const vehicles = await conn.query("SHOW TABLES LIKE 'vehicle_inventory'");
    const garageUpgrades = await conn.query("SHOW TABLES LIKE 'garage_upgrades'");
    const marinaUpgrades = await conn.query("SHOW TABLES LIKE 'marina_upgrades'");
    
    console.log('📋 Verified tables:');
    if (garages.length > 0) console.log('  ✅ garages');
    if (marinas.length > 0) console.log('  ✅ marinas');
    if (vehicles.length > 0) console.log('  ✅ vehicle_inventory');
    if (garageUpgrades.length > 0) console.log('  ✅ garage_upgrades');
    if (marinaUpgrades.length > 0) console.log('  ✅ marina_upgrades');
    
  } catch (err) {
    console.error('❌ Error:', err);
    process.exit(1);
  } finally {
    if (conn) conn.release();
    await pool.end();
  }
}

addVehicleTables();
