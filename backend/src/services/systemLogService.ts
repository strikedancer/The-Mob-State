import prisma from '../lib/prisma';

const MAX_MESSAGE_LENGTH = 2000;
const MAX_VALUE_LENGTH = 8000;

let consoleCaptureInstalled = false;
let processHandlersInstalled = false;
let originalConsoleError: typeof console.error | null = null;
let isPersistingFromConsole = false;

function safeStringify(value: unknown): string {
  try {
    if (typeof value === 'string') {
      return value;
    }

    return JSON.stringify(value);
  } catch {
    return String(value);
  }
}

function truncate(value: string, maxLength: number): string {
  if (value.length <= maxLength) {
    return value;
  }

  return `${value.slice(0, maxLength)}...(truncated)`;
}

function writeFallbackError(line: string) {
  try {
    process.stderr.write(`${line}\n`);
  } catch {
    // Ignore fallback logging failures
  }
}

async function persistSystemError(source: string, message: string, details?: unknown) {
  const normalizedMessage = truncate(message || 'Unknown system error', MAX_MESSAGE_LENGTH);
  const normalizedDetails = details === undefined
    ? null
    : truncate(safeStringify(details), MAX_VALUE_LENGTH);

  const paramsPayload = JSON.stringify({
    source,
    message: normalizedMessage,
    details: normalizedDetails,
    loggedAt: new Date().toISOString(),
  });

  await prisma.worldEvent.create({
    data: {
      eventKey: 'system.error',
      params: paramsPayload,
    },
  });
}

export const systemLogService = {
  async logError(source: string, message: string, details?: unknown) {
    try {
      await persistSystemError(source, message, details);
    } catch (error) {
      writeFallbackError(
        `[SystemLogService] Failed to persist system.error (${source}): ${safeStringify(error)}`
      );
    }
  },

  installConsoleErrorCapture() {
    if (consoleCaptureInstalled) {
      return;
    }

    originalConsoleError = console.error.bind(console);

    console.error = (...args: unknown[]) => {
      originalConsoleError?.(...args);

      if (isPersistingFromConsole) {
        return;
      }

      isPersistingFromConsole = true;
      const [firstArg, ...restArgs] = args;

      const message = truncate(
        typeof firstArg === 'string' ? firstArg : safeStringify(firstArg),
        MAX_MESSAGE_LENGTH
      );

      const details = restArgs.length > 0
        ? restArgs.map((entry) => truncate(safeStringify(entry), MAX_VALUE_LENGTH))
        : undefined;

      void this.logError('console.error', message, details).finally(() => {
        isPersistingFromConsole = false;
      });
    };

    consoleCaptureInstalled = true;
  },

  installProcessErrorCapture() {
    if (processHandlersInstalled) {
      return;
    }

    process.on('unhandledRejection', (reason) => {
      console.error('[UnhandledRejection]', reason);
    });

    process.on('uncaughtException', (error) => {
      console.error('[UncaughtException]', error);
    });

    processHandlersInstalled = true;
  },
};
