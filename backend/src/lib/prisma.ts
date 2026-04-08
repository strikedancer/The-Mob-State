import { PrismaClient } from '@prisma/client';

// Create the Prisma Client
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

// Track initialization state
let isInitialized = false;
let initializationPromise: Promise<void> | null = null;

// Initialize connection
async function initializePrisma() {
  if (initializationPromise) {
    return initializationPromise;
  }

  initializationPromise = (async () => {
    try {
      await prisma.$connect();
      isInitialized = true;
      console.log('[Prisma] Database connection established');
    } catch (error) {
      console.error('[Prisma] Failed to connect to database:', error);
      throw error;
    }
  })();

  return initializationPromise;
}

// Start initialization immediately
initializePrisma();

// Export function to wait for initialization
export async function waitForPrisma() {
  if (isInitialized) return;
  await initializationPromise;
}

// Graceful shutdown
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

export default prisma;
