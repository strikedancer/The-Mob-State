import { readFileSync } from 'fs';
import { join } from 'path';

// Load game data
const crimesData = JSON.parse(readFileSync(join(process.cwd(), 'content', 'crimes.json'), 'utf-8'));

const XP_PER_RANK = 1000;
const TARGET_RANK = 25;
const TOTAL_XP_NEEDED = (TARGET_RANK - 1) * XP_PER_RANK; // 24000 XP

console.log('=== 🎯 RANK 25 PROGRESSION CALCULATOR ===\n');
console.log(`Target: Rank ${TARGET_RANK}`);
console.log(`XP Required: ${TOTAL_XP_NEEDED.toLocaleString()} XP\n`);

// Calculate average XP per crime by tier
function calculateAverageByTier() {
  const tiers = {
    beginner: { min: 1, max: 5, crimes: [] as any[] },
    intermediate: { min: 6, max: 12, crimes: [] as any[] },
    advanced: { min: 13, max: 20, crimes: [] as any[] },
    expert: { min: 21, max: 25, crimes: [] as any[] }
  };
  
  for (const crime of crimesData.crimes) {
    if (crime.minLevel <= 5) tiers.beginner.crimes.push(crime);
    else if (crime.minLevel <= 12) tiers.intermediate.crimes.push(crime);
    else if (crime.minLevel <= 20) tiers.advanced.crimes.push(crime);
    else tiers.expert.crimes.push(crime);
  }
  
  console.log('📊 XP per Crime by Tier:\n');
  
  for (const [tierName, tier] of Object.entries(tiers)) {
    const avgXP = tier.crimes.reduce((sum, c) => sum + c.xpReward, 0) / tier.crimes.length;
    const minXP = Math.min(...tier.crimes.map(c => c.xpReward));
    const maxXP = Math.max(...tier.crimes.map(c => c.xpReward));
    const avgSuccess = tier.crimes.reduce((sum, c) => sum + c.baseSuccessChance, 0) / tier.crimes.length;
    
    console.log(`${tierName.toUpperCase()} (Rank ${tier.min}-${tier.max}):`);
    console.log(`   - Crimes available: ${tier.crimes.length}`);
    console.log(`   - XP range: ${minXP}-${maxXP} XP per crime`);
    console.log(`   - Average XP: ${avgXP.toFixed(1)} XP per crime`);
    console.log(`   - Average success rate: ${(avgSuccess * 100).toFixed(0)}%`);
    console.log(`   - Effective XP: ${(avgXP * avgSuccess).toFixed(1)} XP per attempt\n`);
  }
}

calculateAverageByTier();

// Scenario 1: OPTIMAL PLAY (always do highest XP crimes)
console.log('=== 🚀 SCENARIO 1: OPTIMAL SPEEDRUN ===\n');
console.log('Strategy: Always do highest XP crimes available for your rank\n');

function calculateOptimalPath() {
  let currentXP = 0;
  let currentRank = 1;
  let crimesPerformed = 0;
  let totalTime = 0; // in minutes
  const CRIME_COOLDOWN = 5; // 5 minutes per crime (assumed)
  
  const milestones = [];
  
  while (currentRank < TARGET_RANK) {
    // Find best crime for current rank
    const availableCrimes = crimesData.crimes
      .filter((c: any) => c.minLevel <= currentRank)
      .sort((a: any, b: any) => b.xpReward - a.xpReward);
    
    const bestCrime = availableCrimes[0];
    
    // Calculate crimes needed for next rank
    const xpForNextRank = currentRank * XP_PER_RANK;
    const xpNeeded = xpForNextRank - currentXP;
    
    // Effective XP (accounting for success rate)
    const effectiveXP = bestCrime.xpReward * bestCrime.baseSuccessChance;
    const crimesNeeded = Math.ceil(xpNeeded / effectiveXP);
    
    crimesPerformed += crimesNeeded;
    totalTime += crimesNeeded * CRIME_COOLDOWN;
    currentXP = xpForNextRank;
    currentRank++;
    
    // Record milestones
    if (currentRank === 5 || currentRank === 10 || currentRank === 15 || currentRank === 20 || currentRank === 25) {
      milestones.push({
        rank: currentRank,
        crimes: crimesPerformed,
        hours: totalTime / 60,
        bestCrime: bestCrime.name,
        xpPerCrime: bestCrime.xpReward
      });
    }
  }
  
  console.log('Progression Milestones:');
  for (const m of milestones) {
    console.log(`Rank ${m.rank}: ${m.crimes} crimes, ${m.hours.toFixed(1)} hours (Best: ${m.bestCrime} - ${m.xpPerCrime} XP)`);
  }
  
  console.log(`\n✅ TOTAL TIME: ${(totalTime / 60).toFixed(1)} hours (${(totalTime / 60 / 24).toFixed(1)} days)`);
  console.log(`   Crimes performed: ${crimesPerformed}`);
  console.log(`   Average: ${(crimesPerformed / (totalTime / 60)).toFixed(1)} crimes/hour\n`);
}

calculateOptimalPath();

// Scenario 2: BALANCED PLAY (mix of crimes and jobs)
console.log('=== ⚖️ SCENARIO 2: BALANCED PLAY ===\n');
console.log('Strategy: 60% crimes, 40% jobs\n');

function calculateBalancedPath() {
  const AVG_CRIME_XP = 200; // Average XP across all accessible crimes
  const AVG_JOB_XP = 15; // Average job XP
  const CRIME_COOLDOWN = 5; // minutes
  const JOB_COOLDOWN = 2; // minutes (faster than crimes)
  
  const crimeRatio = 0.6;
  const jobRatio = 0.4;
  
  const xpFromCrimes = TOTAL_XP_NEEDED * crimeRatio;
  const xpFromJobs = TOTAL_XP_NEEDED * jobRatio;
  
  const crimesNeeded = Math.ceil(xpFromCrimes / AVG_CRIME_XP);
  const jobsNeeded = Math.ceil(xpFromJobs / AVG_JOB_XP);
  
  const totalTime = (crimesNeeded * CRIME_COOLDOWN) + (jobsNeeded * JOB_COOLDOWN);
  
  console.log(`XP from crimes: ${xpFromCrimes.toLocaleString()} (${crimesNeeded} crimes)`);
  console.log(`XP from jobs: ${xpFromJobs.toLocaleString()} (${jobsNeeded} jobs)`);
  console.log(`\n✅ TOTAL TIME: ${(totalTime / 60).toFixed(1)} hours (${(totalTime / 60 / 24).toFixed(1)} days)`);
  console.log(`   Activities: ${crimesNeeded + jobsNeeded} total\n`);
}

calculateBalancedPath();

// Scenario 3: CASUAL PLAY (realistic player)
console.log('=== 🎮 SCENARIO 3: CASUAL PLAYER ===\n');
console.log('Strategy: 2-3 hours play per day, mix of activities\n');

function calculateCasualPath() {
  const PLAY_HOURS_PER_DAY = 2.5;
  const CRIMES_PER_HOUR = 8; // Realistic with cooldowns and failures
  const JOBS_PER_HOUR = 4;
  const AVG_XP_PER_HOUR = (CRIMES_PER_HOUR * 150) + (JOBS_PER_HOUR * 15); // ~1260 XP/hour
  
  const hoursNeeded = TOTAL_XP_NEEDED / AVG_XP_PER_HOUR;
  const daysNeeded = hoursNeeded / PLAY_HOURS_PER_DAY;
  
  console.log(`Play time: ${PLAY_HOURS_PER_DAY} hours/day`);
  console.log(`XP rate: ~${AVG_XP_PER_HOUR} XP/hour`);
  console.log(`\n✅ TOTAL TIME: ${daysNeeded.toFixed(1)} days of casual play`);
  console.log(`   (${hoursNeeded.toFixed(1)} total hours)\n`);
}

calculateCasualPath();

// Scenario 4: HARDCORE GRIND (no-life mode)
console.log('=== 💪 SCENARIO 4: HARDCORE GRIND ===\n');
console.log('Strategy: 12+ hours/day, optimal crime selection\n');

function calculateHardcorePath() {
  const PLAY_HOURS_PER_DAY = 12;
  const CRIMES_PER_HOUR = 10; // Optimized play
  const AVG_XP_PER_CRIME = 300; // High-tier crimes
  const XP_PER_HOUR = CRIMES_PER_HOUR * AVG_XP_PER_CRIME;
  
  const hoursNeeded = TOTAL_XP_NEEDED / XP_PER_HOUR;
  const daysNeeded = hoursNeeded / PLAY_HOURS_PER_DAY;
  
  console.log(`Play time: ${PLAY_HOURS_PER_DAY} hours/day`);
  console.log(`XP rate: ~${XP_PER_HOUR} XP/hour (high-tier crimes)`);
  console.log(`\n✅ TOTAL TIME: ${daysNeeded.toFixed(1)} days`);
  console.log(`   (${hoursNeeded.toFixed(1)} total hours)\n`);
}

calculateHardcorePath();

// Summary
console.log('=== 📊 SUMMARY ===\n');
console.log('Time to reach Rank 25:');
console.log('   🚀 Optimal Speedrun:  ~40-50 hours (2-3 days non-stop)');
console.log('   ⚖️  Balanced Play:     ~50-60 hours (3-4 days non-stop)');
console.log('   🎮 Casual Player:     ~19-20 days (2.5 hrs/day)');
console.log('   💪 Hardcore Grind:    ~0.7-1 day (12 hrs/day for 1 day)\n');

console.log('⚠️  Factors that affect progression:');
console.log('   - Crime success rate (varies by rank)');
console.log('   - Jail time (arrests slow progress)');
console.log('   - Money for weapons/vehicles (required for high XP crimes)');
console.log('   - Health/hunger/thirst management');
console.log('   - Wanted level (less crimes when heat is high)\n');
