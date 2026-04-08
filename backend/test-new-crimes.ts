import { readFileSync } from 'fs';
import { join } from 'path';

async function testNewCrimes() {
  console.log('=== Testing New Crime Rank Requirements ===\n');
  
  // Load crimes data
  const crimesData = JSON.parse(readFileSync(join(process.cwd(), 'content', 'crimes.json'), 'utf-8'));
  
  // Find new crimes
  const newCrimeIds = [
    'eliminate_witness',
    'diamond_heist',
    'evidence_room_heist',
    'museum_heist',
    'boss_assassination'
  ];
  
  // Check if assassination was moved to rank 19
  const assassination = crimesData.crimes.find((c: any) => c.id === 'assassination');
  console.log('✅ Assassination Crime:');
  console.log(`   - Rank: ${assassination?.minLevel} (should be 19)`);
  console.log(`   - Reward: €${assassination?.minReward}-${assassination?.maxReward}`);
  console.log(`   - XP: ${assassination?.xpReward}`);
  console.log(`   - Federal: ${assassination?.isFederal || false}`);
  console.log('');
  
  // Check all new crimes
  console.log('✅ New Crimes Added:\n');
  
  for (const crimeId of newCrimeIds) {
    const crime = crimesData.crimes.find((c: any) => c.id === crimeId);
    if (crime) {
      console.log(`📌 ${crime.name} (${crime.id})`);
      console.log(`   - Rank Required: ${crime.minLevel}`);
      console.log(`   - Success Rate: ${(crime.baseSuccessChance * 100).toFixed(0)}%`);
      console.log(`   - Reward: €${crime.minReward.toLocaleString()}-€${crime.maxReward.toLocaleString()}`);
      console.log(`   - XP: ${crime.xpReward}`);
      console.log(`   - Jail Time: ${crime.jailTime} min`);
      console.log(`   - Federal: ${crime.isFederal ? 'YES' : 'No'}`);
      console.log(`   - Requires Weapon: ${crime.requiredWeapon ? 'YES' : 'No'}`);
      if (crime.requiredWeapon) {
        console.log(`   - Weapon Types: ${crime.suitableWeaponTypes.join(', ')}`);
      }
      console.log('');
    } else {
      console.log(`❌ Crime ${crimeId} NOT FOUND!`);
    }
  }
  
  // Rank distribution analysis
  console.log('=== Rank Distribution Analysis ===\n');
  
  const rankDistribution: Record<number, string[]> = {};
  for (const crime of crimesData.crimes) {
    const rank = crime.minLevel;
    if (!rankDistribution[rank]) {
      rankDistribution[rank] = [];
    }
    rankDistribution[rank].push(crime.name);
  }
  
  // Show ranks 15-25
  console.log('High Rank Crimes (15-25):');
  for (let rank = 15; rank <= 25; rank++) {
    const crimes = rankDistribution[rank] || [];
    if (crimes.length > 0) {
      console.log(`   Rank ${rank}: ${crimes.length} crime(s) - ${crimes.join(', ')}`);
    } else {
      console.log(`   Rank ${rank}: ❌ NO CRIMES`);
    }
  }
  console.log('');
  
  // Check gaps
  console.log('=== Gaps Check ===');
  const gaps = [];
  for (let rank = 1; rank <= 25; rank++) {
    if (!rankDistribution[rank] || rankDistribution[rank].length === 0) {
      gaps.push(rank);
    }
  }
  
  if (gaps.length === 0) {
    console.log('✅ NO GAPS! All ranks 1-25 have crimes available');
  } else {
    console.log(`❌ Gaps found at ranks: ${gaps.join(', ')}`);
  }
  console.log('');
  
  // Test NPC access
  console.log('=== Testing NPC Access ===\n');
  
  const testRanks = [19, 20, 21, 23, 24];
  
  for (const testRank of testRanks) {
    const availableCrimes = crimesData.crimes.filter((c: any) => c.minLevel <= testRank);
    const rankCrimes = crimesData.crimes.filter((c: any) => c.minLevel === testRank);
    
    console.log(`Rank ${testRank} player:`);
    console.log(`   - Total crimes available: ${availableCrimes.length}`);
    console.log(`   - New at this rank: ${rankCrimes.length} - ${rankCrimes.map((c: any) => c.name).join(', ')}`);
    
    // Show highest paying crime available
    const highestPaying = availableCrimes.sort((a: any, b: any) => b.maxReward - a.maxReward)[0];
    console.log(`   - Highest paying: ${highestPaying.name} (€${highestPaying.maxReward.toLocaleString()})`);
    console.log('');
  }
  
  console.log('=== Test Complete ===');
}

testNewCrimes().catch(console.error);
