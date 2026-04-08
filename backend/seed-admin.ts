import prisma from './src/lib/prisma';
import bcrypt from 'bcryptjs';

async function seedAdmin() {
  try {
    const passwordHash = await bcrypt.hash('admin123', 10);

    const admin = await prisma.admin.upsert({
      where: { username: 'admin' },
      update: {},
      create: {
        username: 'admin',
        passwordHash,
        role: 'SUPER_ADMIN',
        isActive: true,
      },
    });

    console.log('✅ Admin user created:');
    console.log('   Username: admin');
    console.log('   Password: admin123');
    console.log('   Role:', admin.role);
  } catch (error) {
    console.error('❌ Error seeding admin:', error);
  } finally {
    await prisma.$disconnect();
  }
}

seedAdmin();
