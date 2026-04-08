/**
 * Queue Service - Manages BullMQ job queues
 * 
 * Provides centralized queue management for background job processing.
 * Supports graceful fallback when Redis is unavailable.
 */

import { Queue, Worker, QueueEvents, Job } from 'bullmq';
import { getRedisConnectionOptions, isRedisConnected } from '../services/redisClient';

interface QueueConfig {
  name: string;
  defaultJobOptions?: {
    attempts?: number;
    backoff?: {
      type: 'exponential' | 'fixed';
      delay: number;
    };
    removeOnComplete?: boolean | number;
    removeOnFail?: boolean | number;
  };
}

class QueueService {
  private queues: Map<string, Queue> = new Map();
  private workers: Map<string, Worker> = new Map();
  private queueEvents: Map<string, QueueEvents> = new Map();
  private redisAvailable = false;

  /**
   * Initialize queue service
   */
  async init(): Promise<void> {
    this.redisAvailable = isRedisConnected();

    if (!this.redisAvailable) {
      console.warn('⚠️  Queue service running without Redis (background jobs disabled)');
    } else {
      console.log('✅ Queue service initialized with Redis');
    }
  }

  /**
   * Create or get a queue
   */
  getQueue<T = unknown>(config: QueueConfig): Queue<T> | null {
    if (!this.redisAvailable) {
      console.warn(`⚠️  Cannot create queue "${config.name}" - Redis not available`);
      return null;
    }

    const existing = this.queues.get(config.name);
    if (existing) {
      return existing as Queue<T>;
    }

    const connection = getRedisConnectionOptions();
    if (!connection) {
      console.warn(`⚠️  Cannot create queue "${config.name}" - Redis client unavailable`);
      return null;
    }

    const queue = new Queue(config.name, {
      connection,
      defaultJobOptions: {
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 2000,
        },
        removeOnComplete: 100, // Keep last 100 completed jobs
        removeOnFail: 500,    // Keep last 500 failed jobs
        ...config.defaultJobOptions,
      },
    });

    this.queues.set(config.name, queue);
    console.log(`📋 Queue "${config.name}" created`);

    return queue as Queue<T>;
  }

  /**
   * Register a worker for a queue
   */
  registerWorker<T = unknown>(
    queueName: string,
    processor: (job: Job<T>) => Promise<void>,
    concurrency = 1
  ): Worker<T> | null {
    if (!this.redisAvailable) {
      console.warn(`⚠️  Cannot register worker for "${queueName}" - Redis not available`);
      return null;
    }

    const connection = getRedisConnectionOptions();
    if (!connection) {
      console.warn(`⚠️  Cannot register worker for "${queueName}" - Redis client unavailable`);
      return null;
    }

    const worker = new Worker(
      queueName,
      async (job: Job<T>) => {
        console.log(`🔄 Processing job ${job.id} from queue "${queueName}"`);
        try {
          await processor(job);
          console.log(`✅ Job ${job.id} completed successfully`);
        } catch (error) {
          console.error(`❌ Job ${job.id} failed:`, error);
          throw error; // Re-throw to trigger retry
        }
      },
      {
        connection,
        concurrency,
      }
    );

    // Listen to worker events
    worker.on('completed', (job) => {
      console.log(`✅ Worker completed job ${job.id}`);
    });

    worker.on('failed', (job, error) => {
      console.error(`❌ Worker failed job ${job?.id}:`, error.message);
    });

    worker.on('error', (error) => {
      console.error(`❌ Worker error for queue "${queueName}":`, error);
    });

    this.workers.set(queueName, worker);
    console.log(`👷 Worker registered for queue "${queueName}" (concurrency: ${concurrency})`);

    return worker;
  }

  /**
   * Register queue events listener
   */
  registerQueueEvents(queueName: string): QueueEvents | null {
    if (!this.redisAvailable) {
      return null;
    }

    const connection = getRedisConnectionOptions();
    if (!connection) {
      return null;
    }

    const queueEvents = new QueueEvents(queueName, {
      connection,
    });

    queueEvents.on('waiting', ({ jobId }) => {
      console.log(`⏳ Job ${jobId} is waiting in queue "${queueName}"`);
    });

    queueEvents.on('active', ({ jobId }) => {
      console.log(`▶️  Job ${jobId} is active in queue "${queueName}"`);
    });

    queueEvents.on('completed', ({ jobId }) => {
      console.log(`✅ Job ${jobId} completed in queue "${queueName}"`);
    });

    queueEvents.on('failed', ({ jobId, failedReason }) => {
      console.error(`❌ Job ${jobId} failed in queue "${queueName}": ${failedReason}`);
    });

    this.queueEvents.set(queueName, queueEvents);
    return queueEvents;
  }

  /**
   * Add a job to a queue
   */
  async addJob<T = unknown>(
    queueName: string,
    data: T,
    jobOptions?: {
      delay?: number;
      priority?: number;
      jobId?: string;
    }
  ): Promise<Job<T> | null> {
    const queue = this.queues.get(queueName) as Queue<T>;
    
    if (!queue) {
      console.warn(`⚠️  Cannot add job to queue "${queueName}" - queue not found or Redis unavailable`);
      return null;
    }

    try {
      // @ts-expect-error - BullMQ type complexity with name parameter
      const job = await queue.add(queueName, data, jobOptions);
      console.log(`📝 Job ${job.id} added to queue "${queueName}"`);
      return job as Job<T>;
    } catch (error) {
      console.error(`❌ Failed to add job to queue "${queueName}":`, error);
      return null;
    }
  }

  /**
   * Schedule a recurring job (cron-like)
   */
  async addRecurringJob<T = unknown>(
    queueName: string,
    jobId: string,
    data: T,
    repeatOptions: {
      pattern?: string; // Cron pattern
      every?: number;   // Milliseconds
    }
  ): Promise<Job<T> | null> {
    const queue = this.queues.get(queueName) as Queue<T>;
    
    if (!queue) {
      console.warn(`⚠️  Cannot add recurring job to queue "${queueName}" - queue not found`);
      return null;
    }

    try {
      // @ts-expect-error - BullMQ type complexity with name parameter
      const job = await queue.add(queueName, data, {
        jobId,
        repeat: repeatOptions,
      });
      console.log(`🔁 Recurring job "${jobId}" added to queue "${queueName}"`);
      return job as Job<T>;
    } catch (error) {
      console.error(`❌ Failed to add recurring job to queue "${queueName}":`, error);
      return null;
    }
  }

  /**
   * Get queue stats
   */
  async getQueueStats(queueName: string): Promise<{
    waiting: number;
    active: number;
    completed: number;
    failed: number;
    delayed: number;
  } | null> {
    const queue = this.queues.get(queueName);
    
    if (!queue) {
      return null;
    }

    try {
      const [waiting, active, completed, failed, delayed] = await Promise.all([
        queue.getWaitingCount(),
        queue.getActiveCount(),
        queue.getCompletedCount(),
        queue.getFailedCount(),
        queue.getDelayedCount(),
      ]);

      return { waiting, active, completed, failed, delayed };
    } catch (error) {
      console.error(`❌ Failed to get stats for queue "${queueName}":`, error);
      return null;
    }
  }

  /**
   * Clean up old jobs
   */
  async cleanQueue(
    queueName: string,
    grace: number = 3600000, // 1 hour
    limit: number = 1000
  ): Promise<void> {
    const queue = this.queues.get(queueName);
    
    if (!queue) {
      return;
    }

    try {
      await queue.clean(grace, limit, 'completed');
      await queue.clean(grace, limit, 'failed');
      console.log(`🧹 Cleaned old jobs from queue "${queueName}"`);
    } catch (error) {
      console.error(`❌ Failed to clean queue "${queueName}":`, error);
    }
  }

  /**
   * Pause a queue
   */
  async pauseQueue(queueName: string): Promise<void> {
    const queue = this.queues.get(queueName);
    
    if (!queue) {
      return;
    }

    try {
      await queue.pause();
      console.log(`⏸️  Queue "${queueName}" paused`);
    } catch (error) {
      console.error(`❌ Failed to pause queue "${queueName}":`, error);
    }
  }

  /**
   * Resume a queue
   */
  async resumeQueue(queueName: string): Promise<void> {
    const queue = this.queues.get(queueName);
    
    if (!queue) {
      return;
    }

    try {
      await queue.resume();
      console.log(`▶️  Queue "${queueName}" resumed`);
    } catch (error) {
      console.error(`❌ Failed to resume queue "${queueName}":`, error);
    }
  }

  /**
   * Shutdown all queues and workers gracefully
   */
  async shutdown(): Promise<void> {
    console.log('🛑 Shutting down queue service...');

    // Close all workers
    const workerPromises = Array.from(this.workers.values()).map(worker => 
      worker.close()
    );
    await Promise.all(workerPromises);
    console.log('✅ All workers closed');

    // Close all queue events
    const queueEventsPromises = Array.from(this.queueEvents.values()).map(qe => 
      qe.close()
    );
    await Promise.all(queueEventsPromises);
    console.log('✅ All queue events closed');

    // Close all queues
    const queuePromises = Array.from(this.queues.values()).map(queue => 
      queue.close()
    );
    await Promise.all(queuePromises);
    console.log('✅ All queues closed');

    this.queues.clear();
    this.workers.clear();
    this.queueEvents.clear();
  }

  /**
   * Check if queues are available
   */
  isAvailable(): boolean {
    return this.redisAvailable;
  }
}

// Singleton instance
export const queueService = new QueueService();
