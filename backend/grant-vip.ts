/**
 * VIP Management Script
 * Grant or revoke VIP status for players
 * 
 * Usage:
 *   npx ts-node grant-vip.ts <username> [days]
 *   npx ts-node grant-vip.ts <username> revoke
 * 
 * Examples:
 *   npx ts-node grant-vip.ts testuser2 7
 *   npx ts-node grant-vip.ts testuser2 30
 *   npx ts-node grant-vip.ts testuser2 revoke
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('❌ Usage: npx ts-node grant-vip.ts <username> [days|revoke]');
    console.log('');
    console.log('Examples:');
    console.log('  npx ts-node grant-vip.ts testuser2 7      # Grant 7 days VIP');
    console.log('  npx ts-node grant-vip.ts testuser2 30     # Grant 30 days VIP');
    console.log('  npx ts-node grant-vip.ts testuser2 revoke # Revoke VIP');
    process.exit(1);
  }

  const username = args[0];
  const action = args[1] || '7';

  // Find player
  const player = await prisma.player.findUnique({
    where: { username },
    select: {
      id: true,
      username: true,
      isVip: true,
      vipExpiresAt: true,
    },
  });

  if (!player) {
    console.log(`❌ Player "${username}" not found`);
    process.exit(1);
  }

  // Check if revoking
  if (action === 'revoke') {
    await prisma.player.update({
      where: { id: player.id },
      data: {
        isVip: false,
        vipExpiresAt: null,
      },
    });

    console.log(`✅ VIP revoked from ${username}`);
    console.log(`   Player ID: ${player.id}`);
    process.exit(0);
  }

  // Grant VIP
  const days = parseInt(action);
  if (isNaN(days) || days <= 0 || days > 365) {
    console.log('❌ Invalid days value. Must be between 1 and 365');
    process.exit(1);
  }

  const vipExpiresAt = new Date(Date.now() + days * 24 * 60 * 60 * 1000);

  const updated = await prisma.player.update({
    where: { id: player.id },
    data: {
      isVip: true,
      vipExpiresAt,
    },
  });

  console.log(`✅ VIP granted to ${username} for ${days} days`);
  console.log(`   Player ID: ${updated.id}`);
  console.log(`   Expires: ${vipExpiresAt.toLocaleString()}`);
  console.log('');
  console.log('Benefits:');
  console.log('   • 40% chance to recruit VIP prostitutes (€60/h)');
  console.log('   • 50% earnings bonus on VIP prostitutes');
  console.log('   • Exclusive VIP features');
}

main()
  .catch((error) => {
    console.error('❌ Error:', error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
