/**
 * Unit checks for unified storage packing (tiles).
 * Run: npx ts-node --transpile-only backend/src/utils/propertyStash.packing.test.ts
 */
import assert from 'assert';
import {
  ammoSlotsForRounds,
  drugSlotsForGrams,
  tradeSlotsForLots,
  tradeSlotsForQuantity,
  tradeUnitsPerTile,
  unitsPerTileFromWeight,
} from './propertyStash';

assert.strictEqual(unitsPerTileFromWeight(1), 10);
assert.strictEqual(unitsPerTileFromWeight(2), 5);
assert.strictEqual(unitsPerTileFromWeight(3), 3);
assert.strictEqual(unitsPerTileFromWeight(4), 2);
assert.strictEqual(unitsPerTileFromWeight(5), 2);

assert.strictEqual(tradeUnitsPerTile('contraband_coffee'), 5);
assert.strictEqual(tradeUnitsPerTile('contraband_diamonds'), 10);
assert.strictEqual(tradeUnitsPerTile('contraband_gold'), 10);
assert.strictEqual(tradeUnitsPerTile('contraband_art'), 2);
assert.strictEqual(tradeUnitsPerTile('contraband_weapons'), 2);
assert.strictEqual(tradeUnitsPerTile('contraband_spirits'), 3);

assert.strictEqual(tradeSlotsForQuantity('contraband_coffee', 5), 1);
assert.strictEqual(tradeSlotsForQuantity('contraband_coffee', 6), 2);
assert.strictEqual(tradeSlotsForQuantity('contraband_diamonds', 10), 1);
assert.strictEqual(tradeSlotsForQuantity('contraband_diamonds', 11), 2);
assert.strictEqual(tradeSlotsForQuantity('contraband_coffee', 0), 0);

assert.strictEqual(
  tradeSlotsForLots([
    { goodType: 'contraband_coffee', quantity: 5 },
    { goodType: 'contraband_diamonds', quantity: 10 },
  ]),
  2,
);
assert.strictEqual(
  tradeSlotsForLots([
    { goodType: 'contraband_coffee', quantity: 3 },
    { goodType: 'contraband_coffee', quantity: 2 },
  ]),
  1,
);

assert.strictEqual(drugSlotsForGrams(100), 1);
assert.strictEqual(drugSlotsForGrams(101), 2);
assert.strictEqual(ammoSlotsForRounds(50), 1);
assert.strictEqual(ammoSlotsForRounds(51), 2);

console.log('propertyStash packing tests OK');
