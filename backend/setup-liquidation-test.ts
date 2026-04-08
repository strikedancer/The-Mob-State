/**
 * Setup test environment for successful liquidation
 */
import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaMariaDb } from '@prisma/adapter-mariadb';

const adapter = new PrismaMariaDb(process.env.DATABASE_URL!);
const prisma = new PrismaClient({ adapter });

async function setup() {
  try {
    // Set weak_leader to rank 1
    await prisma.player.updateMany({
      where: { username: 'weak_leader' },
      data: { rank: 1 },
    });
    console.log('✅ Set weak_leader to rank 1');

    // Set strong_attacker to rank 10
    await prisma.player.updateMany({
      where: { username: 'strong_attacker' },
      data: { rank: 10 },
    });
    console.log('✅ Set strong_attacker to rank 10');

    // Add money to crew bank (find crew with weak_leader as leader)
    const weakLeader = await prisma.player.findFirst({
      where: { username: 'weak_leader' },
    });

    if (weakLeader) {
      const crewMembership = await prisma.crewMember.findFirst({
        where: { playerId: weakLeader.id, role: 'leader' },
      });

      if (crewMembership) {
        await prisma.crew.update({
          where: { id: crewMembership.crewId },
          data: { bankBalance: 50000 },
        });
        console.log(`✅ Set crew ${crewMembership.crewId} bank to €50,000`);
      } else {
        console.log('⚠️  weak_leader is not a leader of any crew');
      }
    }

    console.log('\n✅ Setup complete! Run test-liquidations.js now');
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

setup();
