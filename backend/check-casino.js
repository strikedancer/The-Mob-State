const mariadb = require('mariadb');

async function checkCasinos() {
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
    
    console.log('🔍 Checking casino properties...\n');
    
    const casinos = await conn.query("SELECT * FROM properties WHERE propertyType = 'casino'");
    console.log(`Found ${casinos.length} casino properties:`);
    casinos.forEach(c => {
      console.log(`  - propertyId: ${c.propertyId}, countryId: ${c.countryId}, playerId: ${c.playerId}`);
    });
    
    console.log('\n🔍 Checking casino_belgium specifically...\n');
    const belgiumCasino = await conn.query("SELECT * FROM properties WHERE propertyId = 'casino_belgium'");
    if (belgiumCasino.length > 0) {
      console.log('✅ casino_belgium found:');
      console.log(belgiumCasino[0]);
    } else {
      console.log('❌ casino_belgium NOT found!');
    }
    
  } catch (err) {
    console.error('❌ Error:', err);
  } finally {
    if (conn) conn.release();
    await pool.end();
  }
}

checkCasinos();
