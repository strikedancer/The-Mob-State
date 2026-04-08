// Test rank calculation logic - 150 rank system
function getXPForRank(targetRank) {
  let totalXP = 0;
  
  for (let rank = 1; rank < targetRank; rank++) {
    if (rank <= 5) {
      totalXP += 1000;      // Tier 1: Quick start
    } else if (rank <= 10) {
      totalXP += 2000;      // Tier 2: Early game
    } else if (rank <= 20) {
      totalXP += 4000;      // Tier 3: Mid-game
    } else if (rank <= 30) {
      totalXP += 8000;      // Tier 4: Core game
    } else if (rank <= 50) {
      totalXP += 15000;     // Tier 5: Late game
    } else if (rank <= 75) {
      totalXP += 25000;     // Tier 6: High level
    } else if (rank <= 100) {
      totalXP += 40000;     // Tier 7: Elite
    } else {
      totalXP += 60000;     // Tier 8: Legend
    }
  }
  
  return totalXP;
}

function getRankFromXP(totalXP) {
  let rank = 1;
  let xpRequired = 0;
  
  while (xpRequired <= totalXP && rank < 150) {
    const xpForNextRank = getXPForRank(rank + 1);
    if (totalXP >= xpForNextRank) {
      rank++;
      xpRequired = xpForNextRank;
    } else {
      break;
    }
  }
  
  return Math.min(rank, 150);
}

console.log('=== 150 RANK SYSTEM ===\n');

console.log('XP Required for Key Ranks:');
for (let r of [1, 5, 10, 20, 30, 50, 75, 100, 150]) {
  const xp = getXPForRank(r);
  console.log(`Rank ${r.toString().padStart(3)}: ${xp.toLocaleString().padStart(10)} XP`);
}

console.log('\n\nXP per Tier Breakdown:');
const tiers = [
  { name: 'Tier 1 (Rookie)', start: 1, end: 5 },
  { name: 'Tier 2 (Street Hustler)', start: 6, end: 10 },
  { name: 'Tier 3 (Made Man)', start: 11, end: 20 },
  { name: 'Tier 4 (Capo)', start: 21, end: 30 },
  { name: 'Tier 5 (Underboss)', start: 31, end: 50 },
  { name: 'Tier 6 (Boss)', start: 51, end: 75 },
  { name: 'Tier 7 (Don)', start: 76, end: 100 },
  { name: 'Tier 8 (Godfather+)', start: 101, end: 150 },
];

tiers.forEach(tier => {
  const startXP = getXPForRank(tier.start);
  const endXP = getXPForRank(tier.end + 1);
  const totalXP = endXP - startXP;
  const ranksInTier = tier.end - tier.start + 1;
  const xpPerRank = totalXP / ranksInTier;
  console.log(`${tier.name.padEnd(30)}: ${ranksInTier.toString().padStart(3)} ranks, ${xpPerRank.toLocaleString().padStart(8)} XP/rank, Total ${totalXP.toLocaleString().padStart(10)} XP`);
});

const maxXP = getXPForRank(151);
console.log(`\n✨ Max XP for Rank 150: ${maxXP.toLocaleString()} XP (${(maxXP / 1000000).toFixed(2)}M XP)\n`);

console.log('Testing existing player data:');
const players = [
  { rank: 30, xp: 50306 },
  { rank: 20, xp: 30000 },
  { rank: 25, xp: 25000 },
];

players.forEach(player => {
  const calculatedRank = getRankFromXP(player.xp);
  const xpForCurrent = getXPForRank(calculatedRank);
  const xpForNext = getXPForRank(calculatedRank + 1);
  const xpInRank = player.xp - xpForCurrent;
  const xpNeeded = xpForNext - xpForCurrent;
  const progress = (xpInRank / xpNeeded * 100).toFixed(1);
  
  console.log(`\nPlayer XP: ${player.xp.toLocaleString()}`);
  console.log(`  Stored rank: ${player.rank}, Calculated rank: ${calculatedRank}`);
  console.log(`  XP in current rank: ${xpInRank.toLocaleString()} / ${xpNeeded.toLocaleString()}`);
  console.log(`  Progress: ${progress}%`);
});
