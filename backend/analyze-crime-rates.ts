import { readFileSync } from 'fs';
import { join } from 'path';

const crimesData = JSON.parse(readFileSync(join(process.cwd(), 'content', 'crimes.json'), 'utf-8'));

console.log('=== 🚔 CRIME SUCCESS/ARREST RATES ===\n');
console.log('Crime ID                  | Rank | Success | Arrest');
console.log('--------------------------|------|---------|--------');

crimesData.crimes.forEach((crime: any) => {
  const crimeId = crime.id.padEnd(25);
  const rank = String(crime.minLevel).padStart(2);
  const success = `${(crime.baseSuccessChance * 100).toFixed(0)}%`.padStart(4);
  const arrest = `${(100 - crime.baseSuccessChance * 100).toFixed(0)}%`.padStart(4);
  
  console.log(`${crimeId} | ${rank}   | ${success}    | ${arrest}`);
});

console.log('\n=== ⚠️ PROBLEEM ANALYSE ===\n');
console.log('❌ GEEN rank advantage:');
console.log('   - Rank 1 doet pickpocket (rank 1): 70% success');
console.log('   - Rank 25 doet pickpocket (rank 1): 70% success (GEEN BONUS!)');
console.log('');
console.log('❌ GEEN crime mastery:');
console.log('   - Rank 25 doet casino heist (1e keer): 15% success');
console.log('   - Rank 25 doet casino heist (100e keer): 15% success (GEEN LERN!)');
console.log('');
console.log('❌ Hoge pak kans bij moeilijke crimes:');
console.log('   - Casino overval (rank 25): 85% ARREST kans');
console.log('   - Politicus liquidatie (rank 25): 85% ARREST kans');
console.log('   - Moord op rivaal (rank 15): 79% ARREST kans');
console.log('');

console.log('=== ✅ VOORGESTELDE OPLOSSING ===\n');
console.log('1️⃣ RANK ADVANTAGE SYSTEEM:');
console.log('   - Elke rank geeft +0.5% success bonus (max +12.5% bij rank 25)');
console.log('   - Maar alleen voor crimes <= jouw rank');
console.log('   - Formule: successChance + (playerRank * 0.005)');
console.log('');
console.log('   Voorbeelden:');
console.log('   - Rank 1 doet pickpocket: 70% success (base)');
console.log('   - Rank 25 doet pickpocket: 82.5% success (+12.5% rank bonus)');
console.log('   - Rank 25 doet casino heist (rank 25 crime): 15% success (nog geen mastery)');
console.log('');
console.log('2️⃣ CRIME MASTERY SYSTEEM:');
console.log('   - Track hoeveel keer je elke crime gedaan hebt');
console.log('   - +1% success per 5 pogingen (max +10% bij 50 pogingen)');
console.log('   - Formule: successChance + (attempts / 5) * 0.01 (max +0.10)');
console.log('');
console.log('   Voorbeelden:');
console.log('   - Rank 25 doet casino heist (1e keer): 27.5% success (15% base + 12.5% rank)');
console.log('   - Rank 25 doet casino heist (25e keer): 32.5% success (+5% mastery)');
console.log('   - Rank 25 doet casino heist (50e keer): 37.5% success (+10% mastery MAX)');
console.log('');
console.log('3️⃣ EINDRESULTAAT:');
console.log('   Easy crimes (rank 1-5): 80-90% success met rank + mastery');
console.log('   Medium crimes (rank 10-15): 60-75% success met rank + mastery');
console.log('   Hard crimes (rank 20-25): 30-40% success met rank + mastery');
console.log('   → Nog steeds uitdaging, maar niet onmogelijk!');
console.log('');
console.log('4️⃣ DATABASE AANPASSING NODIG:');
console.log('   - CrimeAttempt table bestaat al!');
console.log('   - Track: playerId, crimeId, attempts, successes, lastAttempt');
console.log('   - Query mastery bij elke crime attempt');
