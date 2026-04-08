/**
 * Custom application error class for handling known error cases
 */
export class AppError extends Error {
  public readonly code: string;

  constructor(code: string, message: string) {
    super(message);
    this.name = 'AppError';
    this.code = code;
    
    // Maintains proper stack trace for where our error was thrown (only available on V8)
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, AppError);
    }
  }
}

/**
 * Common error codes used throughout the application
 */
export const ErrorCodes = {
  INSUFFICIENT_FUNDS: 'INSUFFICIENT_FUNDS',
  ALREADY_OWNED: 'ALREADY_OWNED',
  INVALID_COUNTRY: 'INVALID_COUNTRY',
  UNAUTHORIZED: 'UNAUTHORIZED',
  NOT_FOUND: 'NOT_FOUND',
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  COOLDOWN_ACTIVE: 'COOLDOWN_ACTIVE',
} as const;
