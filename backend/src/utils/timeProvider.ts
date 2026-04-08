/**
 * TimeProvider interface for dependency injection
 * Allows deterministic testing by injecting a mock time provider
 */
export interface ITimeProvider {
  now(): Date;
  timestamp(): number;
}

/**
 * Real time provider using system time
 */
export class RealTimeProvider implements ITimeProvider {
  now(): Date {
    return new Date();
  }

  timestamp(): number {
    return Date.now();
  }
}

/**
 * Mock time provider for testing
 * Allows setting a fixed time
 */
export class MockTimeProvider implements ITimeProvider {
  private currentTime: Date;

  constructor(initialTime?: Date) {
    this.currentTime = initialTime || new Date();
  }

  now(): Date {
    return new Date(this.currentTime);
  }

  timestamp(): number {
    return this.currentTime.getTime();
  }

  setTime(time: Date): void {
    this.currentTime = time;
  }

  advanceTime(milliseconds: number): void {
    this.currentTime = new Date(this.currentTime.getTime() + milliseconds);
  }
}

// Export singleton instance for production use
export const timeProvider: ITimeProvider = new RealTimeProvider();
