/**
 * Migration script: Update all player ranks to match exponential XP system
 * 
 * WARNING: This will recalculate ALL player ranks based on their current XP.
 * Some players may lose ranks if their XP doesn't meet the new requirements.
 */

import { getRankFromXP } from './src/config';
import prisma from './src/lib/prisma';

interface MigrationStats {
  totalPlayers: number;
  playersUpdated: number;
  ranksIncreased: number;
  ranksDecreased: number;
  ranksUnchanged: number;
  errors: number;
}

async function main() {
  console.log('=== 🔄 RANK MIGRATION: Linear → Exponential XP System ===\n');
  
  const stats: MigrationStats = {
    totalPlayers: 0,
    playersUpdated: 0,
    ranksIncreased: 0,
    ranksDecreased: 0,
    ranksUnchanged: 0,
    errors: 0,
  };

  try {
    // Get all players
    const players = await prisma.player.findMany({
      select: {
        id: true,
        username: true,
        xp: true,
        rank: true,
      },
      orderBy: { xp: 'desc' },
    });

    stats.totalPlayers = players.length;
    console.log(`Found ${stats.totalPlayers} players to process\n`);
    console.log('-'.repeat(80));

    // Process each player
    for (const player of players) {
      const oldRank = player.rank;
      const newRank = getRankFromXP(player.xp);

      if (oldRank !== newRank) {
        try {
          await prisma.player.update({
            where: { id: player.id },
            data: { rank: newRank },
          });

          stats.playersUpdated++;
          
          if (newRank > oldRank) {
            stats.ranksIncreased++;
            console.log(
              `✅ ${player.username.padEnd(20)} | XP: ${player.xp.toString().padStart(7)} | Rank ${oldRank} → ${newRank} (+${newRank - oldRank})`
            );
          } else {
            stats.ranksDecreased++;
            console.log(
              `⚠️  ${player.username.padEnd(20)} | XP: ${player.xp.toString().padStart(7)} | Rank ${oldRank} → ${newRank} (-${oldRank - newRank})`
            );
          }
        } catch (error) {
          stats.errors++;
          console.error(`❌ Error updating ${player.username}:`, error);
        }
      } else {
        stats.ranksUnchanged++;
        console.log(
          `⏭️  ${player.username.padEnd(20)} | XP: ${player.xp.toString().padStart(7)} | Rank ${oldRank} (unchanged)`
        );
      }
    }

    console.log('\n' + '-'.repeat(80));
    console.log('\n=== 📊 MIGRATION SUMMARY ===\n');
    console.log(`Total players:     ${stats.totalPlayers}`);
    console.log(`Players updated:   ${stats.playersUpdated}`);
    console.log(`  ↗️  Ranks increased:  ${stats.ranksIncreased}`);
    console.log(`  ↘️  Ranks decreased:  ${stats.ranksDecreased}`);
    console.log(`Ranks unchanged:   ${stats.ranksUnchanged}`);
    console.log(`Errors:            ${stats.errors}`);

    if (stats.ranksDecreased > 0) {
      console.log('\n⚠️  WARNING: Some players lost ranks!');
      console.log('This is expected because the exponential system requires more XP per rank.');
      console.log('Players will rank up again as they earn more XP.');
    }

    if (stats.errors > 0) {
      console.log('\n❌ Some errors occurred during migration. Check logs above.');
      process.exit(1);
    }

    console.log('\n✅ Migration completed successfully!\n');

  } catch (error) {
    console.error('\n❌ MIGRATION FAILED:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

// Safety check: Ask for confirmation
console.log('⚠️  WARNING: This will recalculate ALL player ranks!');
console.log('Some players may lose ranks if their XP is insufficient.\n');
console.log('Starting migration in 3 seconds... (Press CTRL+C to cancel)\n');

setTimeout(() => {
  main().catch(console.error);
}, 3000);
