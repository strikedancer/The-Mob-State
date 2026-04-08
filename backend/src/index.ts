import app from './app';
import config from './config';
import { tickService } from './services/tickService';
import { initRedis, closeRedis } from './services/redisClient';
import { queueService } from './queues/queueService';
import { notificationService } from './services/notificationService';
import { npcScheduler } from './lib/npcScheduler';
import { initializeCronJobs } from './services/cronService';
import { waitForPrisma } from './lib/prisma';
import { systemLogService } from './services/systemLogService';
import path from 'path';
import fs from 'fs';

const PORT = config.port;

// Initialize services
async function startServer() {
  // Initialize Redis (optional - will log warning if fails)
  await initRedis();

  // Initialize Firebase Admin for push notifications
  const serviceAccountPath =
    process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
    path.join(process.cwd(), 'firebase-service-account.json');

  const resolvedPath = path.isAbsolute(serviceAccountPath)
    ? serviceAccountPath
    : path.resolve(process.cwd(), serviceAccountPath);

  await notificationService.initialize(
    fs.existsSync(resolvedPath) ? resolvedPath : undefined
  );

  // Initialize queue service (depends on Redis)
  await queueService.init();

  // Wait for Prisma to initialize
  await waitForPrisma();

  // Capture runtime errors into persistent system logs for admin monitoring
  systemLogService.installConsoleErrorCapture();
  systemLogService.installProcessErrorCapture();

  const server = app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📍 Environment: ${config.nodeEnv}`);
    console.log(`🏥 Health check: http://localhost:${PORT}/health`);

    // Start tick service (will use queue if Redis available)
    tickService.start();
    
    // Start NPC activity scheduler
    npcScheduler.start();
    
    // Initialize cron jobs for automated tasks
    initializeCronJobs();
  });

  // Graceful shutdown
  const shutdown = async () => {
    console.log('Shutting down gracefully...');
    tickService.stop();
    npcScheduler.stop();
    await queueService.shutdown();
    await closeRedis();
    server.close(() => {
      console.log('Server closed');
      process.exit(0);
    });
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}

startServer().catch((error) => {
  console.error('Failed to start server:', error);
  process.exit(1);
});
