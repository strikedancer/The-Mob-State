import { randomBytes } from 'crypto';

// Test RNG 20 times
for (let i = 0; i < 20; i++) {
  const bytes = randomBytes(4);
  const value = bytes.readUInt32BE(0);
  const result = value % 6;
  console.log(`[RNG TEST] iteration=${i}, value=${value}, result=${result}`);
}
