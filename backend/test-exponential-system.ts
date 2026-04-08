/**
 * Test script for exponential XP system + rank advantage + crime mastery
 */

import { getXPForRank, getRankFromXP } from './src/config';
import prisma from './src/lib/prisma';
import { crimeService } from './src/services/crimeService';

async function main() {
  console.log('=== 🧪 TESTING EXPONENTIAL XP SYSTEM ===\n');

  // Test 1: XP Requirements
  console.log('1️⃣ XP Requirements per Rank:');
  console.log('-'.repeat(50));
  [1, 5, 10, 15, 20, 25].forEach((rank) => {
    const totalXP = getXPForRank(rank);
    const nextRankXP = getXPForRank(rank + 1);
    const xpNeeded = nextRankXP - totalXP;
    console.log(
      `Rank ${rank.toString().padStart(2)}: ${totalXP.toLocaleString().padStart(8)} XP | Next rank needs: ${xpNeeded.toLocaleString().padStart(6)} XP`
    );
  });

  // Test 2: Rank from XP
  console.log('\n2️⃣ Rank Calculation from XP:');
  console.log('-'.repeat(50));
  [0, 5000, 15000, 35000, 75000, 150000].forEach((xp) => {
    const rank = getRankFromXP(xp);
    console.log(`${xp.toLocaleString().padStart(8)} XP → Rank ${rank}`);
  });

  // Test 3: Crime Success with Rank Advantage & Mastery
  console.log('\n3️⃣ Crime Success Rates (with rank + mastery bonuses):');
  console.log('-'.repeat(80));
  
  const testCrime = crimeService.getCrimeDefinition('casino_heist');
  if (testCrime) {
    console.log(`Crime: ${testCrime.name} (base success: ${(testCrime.baseSuccessChance * 100).toFixed(0)}%)`);
    console.log('');
    
    // Simulate different scenarios
    const scenarios = [
      { rank: 1, attempts: 0, label: 'Rank 1, first attempt' },
      { rank: 25, attempts: 0, label: 'Rank 25, first attempt' },
      { rank: 25, attempts: 25, label: 'Rank 25, 25 attempts' },
      { rank: 25, attempts: 50, label: 'Rank 25, 50+ attempts (mastery max)' },
    ];
    
    scenarios.forEach((scenario) => {
      const rankBonus = scenario.rank * 0.005;
      const masteryBonus = Math.min((scenario.attempts / 5) * 0.01, 0.10);
      const totalSuccess = Math.min(
        testCrime.baseSuccessChance + rankBonus + masteryBonus,
        0.95
      );
      
      console.log(`${scenario.label.padEnd(40)} → ${(totalSuccess * 100).toFixed(1)}% success`);
      console.log(
        `  (base: ${(testCrime.baseSuccessChance * 100).toFixed(0)}% + rank: ${(rankBonus * 100).toFixed(1)}% + mastery: ${(masteryBonus * 100).toFixed(1)}%)`
      );
    });
  }

  // Test 4: Check database schema
  console.log('\n4️⃣ Database Schema Check:');
  console.log('-'.repeat(50));
  
  const playerCount = await prisma.player.count();
  const crimeAttemptCount = await prisma.crimeAttempt.count();
  
  console.log(`Players in database: ${playerCount}`);
  console.log(`Crime attempts tracked: ${crimeAttemptCount}`);
  
  if (playerCount > 0) {
    const topPlayer = await prisma.player.findFirst({
      orderBy: { xp: 'desc' },
      select: { id: true, username: true, xp: true, rank: true },
    });
    
    if (topPlayer) {
      const correctRank = getRankFromXP(topPlayer.xp);
      console.log(`\nTop player: ${topPlayer.username}`);
      console.log(`  Current XP: ${topPlayer.xp.toLocaleString()}`);
      console.log(`  Current rank: ${topPlayer.rank}`);
      console.log(`  Correct rank (exponential): ${correctRank}`);
      
      if (topPlayer.rank !== correctRank) {
        console.log(`  ⚠️ WARNING: Rank mismatch! Need to run migration.`);
      } else {
        console.log(`  ✅ Rank is correct!`);
      }
    }
  }

  // Test 5: Crime mastery example
  console.log('\n5️⃣ Crime Mastery System Example:');
  console.log('-'.repeat(50));
  
  if (crimeAttemptCount > 0) {
    const playerWithMostAttempts = await prisma.crimeAttempt.groupBy({
      by: ['playerId', 'crimeId'],
      _count: { id: true },
      orderBy: { _count: { id: 'desc' } },
      take: 5,
    });
    
    console.log('Top 5 crime expertise:');
    for (const attempt of playerWithMostAttempts) {
      const player = await prisma.player.findUnique({
        where: { id: attempt.playerId },
        select: { username: true },
      });
      const crime = crimeService.getCrimeDefinition(attempt.crimeId);
      const masteryBonus = Math.min((attempt._count.id / 5) * 0.01, 0.10);
      
      console.log(
        `  ${player?.username} - ${crime?.name}: ${attempt._count.id}x attempts (${(masteryBonus * 100).toFixed(1)}% mastery bonus)`
      );
    }
  } else {
    console.log('No crime attempts yet. Play the game to build mastery!');
  }

  console.log('\n=== ✅ TESTS COMPLETE ===\n');

  await prisma.$disconnect();
}

main().catch(console.error);
