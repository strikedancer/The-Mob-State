const assert = require('node:assert/strict');

const BATCH_MS = 10 * 60 * 1000;

function shouldDelay(nowMs, earliestReadyAtMs, upcomingReadyAtMs, batchMs = BATCH_MS) {
  const windowEnd = earliestReadyAtMs + batchMs;
  if (nowMs >= windowEnd) return false;
  return upcomingReadyAtMs.some((readyAt) => readyAt > nowMs && readyAt <= windowEnd);
}

function parseIds(params) {
  let data = params;
  if (typeof params === 'string') {
    try {
      data = JSON.parse(params);
    } catch {
      return [];
    }
  }
  if (!data || typeof data !== 'object') return [];
  const ids = [];
  const pushId = (value) => {
    const n = Number(value);
    if (Number.isInteger(n) && n > 0 && !ids.includes(n)) ids.push(n);
  };
  if (Array.isArray(data.racketIds)) {
    for (const id of data.racketIds) pushId(id);
  }
  pushId(data.racketId);
  return ids;
}

const t0 = 1_000_000;
assert.equal(shouldDelay(t0, t0, []), false, 'single shop notifies immediately');
assert.equal(shouldDelay(t0, t0, [t0 + 4 * 60 * 1000]), true, 'wait for shop 4 min later');
assert.equal(shouldDelay(t0 + 4 * 60 * 1000, t0, []), false, 'after sibling ready, send');
assert.equal(shouldDelay(t0, t0, [t0 + 12 * 60 * 1000]), false, '12 min later is outside window');
assert.equal(shouldDelay(t0 + BATCH_MS, t0, [t0 + 9 * 60 * 1000]), false, 'window elapsed sends anyway');
assert.deepEqual(parseIds({ racketId: 7 }), [7]);
assert.deepEqual(parseIds({ racketIds: [7, 8], racketId: 7 }), [7, 8]);
assert.deepEqual(parseIds('{"racketIds":[3],"racketId":3,"username":"x"}'), [3]);
console.log('don collect-ready batch checks ok');
