import { Prisma } from '@prisma/client';

const DEFAULT_ATTEMPTS = 3;
const DEFAULT_DELAY_MS = 25;

export function isRetryablePrismaWriteConflict(error: unknown): boolean {
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    return error.code === 'P2034' || error.code === 'P2028';
  }

  const message = error instanceof Error ? error.message : String(error);
  return (
    message.includes('1020') ||
    message.includes('Record has changed since last read') ||
    message.includes('Deadlock found')
  );
}

export async function withPrismaWriteRetry<T>(
  fn: () => Promise<T>,
  options?: { attempts?: number; delayMs?: number }
): Promise<T> {
  const attempts = options?.attempts ?? DEFAULT_ATTEMPTS;
  const delayMs = options?.delayMs ?? DEFAULT_DELAY_MS;
  let lastError: unknown;

  for (let attempt = 0; attempt < attempts; attempt += 1) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      if (!isRetryablePrismaWriteConflict(error) || attempt === attempts - 1) {
        throw error;
      }
      await new Promise((resolve) => setTimeout(resolve, delayMs * (attempt + 1)));
    }
  }

  throw lastError;
}
