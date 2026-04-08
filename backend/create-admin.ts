import 'dotenv/config';
import prisma from './src/lib/prisma';
import bcrypt from 'bcrypt';
import readline from 'readline';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function question(prompt: string): Promise<string> {
  return new Promise((resolve) => {
    rl.question(prompt, (answer) => {
      resolve(answer);
    });
  });
}

async function createAdmin() {
  console.log('\n=== Admin Account Aanmaken ===\n');

  try {
    // Ask for username
    const username = await question('Admin username: ');
    if (!username || username.trim().length === 0) {
      console.error('❌ Username is verplicht!');
      process.exit(1);
    }

    // Check if admin already exists
    const existingAdmin = await prisma.admin.findUnique({
      where: { username: username.trim() },
    });

    if (existingAdmin) {
      console.error(`❌ Admin '${username}' bestaat al!`);
      process.exit(1);
    }

    // Ask for password
    const password = await question('Admin password: ');
    if (!password || password.trim().length < 6) {
      console.error('❌ Password moet minimaal 6 tekens zijn!');
      process.exit(1);
    }

    // Ask for role
    console.log('\nRoles:');
    console.log('1. SUPER_ADMIN (volledige toegang)');
    console.log('2. MODERATOR (beperkte toegang)');
    console.log('3. VIEWER (alleen lezen)');
    const roleChoice = await question('Kies role (1-3): ');

    let role: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER';
    switch (roleChoice) {
      case '1':
        role = 'SUPER_ADMIN';
        break;
      case '2':
        role = 'MODERATOR';
        break;
      case '3':
        role = 'VIEWER';
        break;
      default:
        console.error('❌ Ongeldige keuze! Gebruik SUPER_ADMIN als default.');
        role = 'SUPER_ADMIN';
    }

    // Hash password
    console.log('\n⏳ Bezig met wachtwoord hashen...');
    const passwordHash = await bcrypt.hash(password, 10);

    // Create admin
    console.log('⏳ Bezig met admin account aanmaken...');
    const admin = await prisma.admin.create({
      data: {
        username: username.trim(),
        passwordHash,
        role,
        isActive: true,
      },
    });

    console.log('\n✅ Admin account succesvol aangemaakt!');
    console.log(`\nGegevens:`);
    console.log(`  Username: ${admin.username}`);
    console.log(`  Role: ${admin.role}`);
    console.log(`  Active: ${admin.isActive}`);
    console.log(`\nJe kunt nu inloggen via POST /admin/auth/login`);

  } catch (error) {
    console.error('\n❌ Fout bij aanmaken admin account:', error);
    process.exit(1);
  } finally {
    rl.close();
    await prisma.$disconnect();
  }
}

createAdmin();
