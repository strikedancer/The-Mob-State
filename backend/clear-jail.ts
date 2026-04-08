/**
 * Clear all jail records for test players by setting old release times
 */
import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';

const adapter = new PrismaMariaDb(process.env.DATABASE_URL!);
const prisma = new PrismaClient({ adapter });

async function clearJail() {
  const testPlayerIds = [16, 17, 18];

  // Set all jail attempts to have release time in the past (1 hour ago)
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);

  const result = await prisma.crimeAttempt.updateMany({
    where: {
      playerId: { in: testPlayerIds },
      jailed: true,
    },
    data: {
      createdAt: oneHourAgo,
      jailTime: 1, // 1 minute jail time, but created 1 hour ago = already released
    },
  });

  console.log(`✅ Updated ${result.count} jail records for test players`);
  console.log(`   All jail times set to expired (1 hour ago + 1 min)`);
  await prisma.$disconnect();
}

clearJail();
