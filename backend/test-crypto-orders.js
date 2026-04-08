/**
 * Crypto Orders API smoke/edge test
 *
 * Usage (PowerShell):
 * $env:CRYPTO_TEST_TOKEN="<jwt>"
 * node .\test-crypto-orders.js
 */

const BASE_URL = process.env.CRYPTO_TEST_BASE_URL || 'http://localhost:3000';
const TOKEN = process.env.CRYPTO_TEST_TOKEN || '';
const TEST_SYMBOL = (process.env.CRYPTO_TEST_SYMBOL || 'BTC').toUpperCase();

if (!TOKEN) {
  console.error('Missing CRYPTO_TEST_TOKEN.');
  process.exit(1);
}

async function api(method, endpoint, body) {
  const response = await fetch(`${BASE_URL}${endpoint}`, {
    method,
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${TOKEN}`,
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  let data = null;
  try {
    data = await response.json();
  } catch (_e) {
    data = null;
  }

  return { status: response.status, data };
}

function assert(cond, message) {
  if (!cond) {
    throw new Error(message);
  }
}

async function getMarketPrice(symbol) {
  const market = await api('GET', '/crypto/market');
  assert(market.status === 200 && market.data?.success, 'Failed to load /crypto/market');
  const found = (market.data.market || []).find((m) => m.symbol === symbol);
  assert(found, `Symbol ${symbol} not found in market`);
  return Number(found.currentPrice);
}

async function run() {
  console.log('=== Crypto Orders API Test ===');

  const price = await getMarketPrice(TEST_SYMBOL);
  const lowTarget = Number((price * 0.2).toFixed(8));

  console.log(`Using ${TEST_SYMBOL} current=${price} target=${lowTarget}`);

  // 1) Place a small BUY LIMIT order far below market (should remain OPEN)
  const firstOrder = await api('POST', '/crypto/orders', {
    symbol: TEST_SYMBOL,
    orderType: 'LIMIT',
    side: 'BUY',
    quantity: 0.001,
    targetPrice: lowTarget,
  });

  assert(firstOrder.status === 200 && firstOrder.data?.success, 'First order placement failed');
  assert(firstOrder.data.status === 'OPEN', 'Expected first order to remain OPEN');
  const firstOrderId = firstOrder.data.id;
  console.log(`OK first order open id=${firstOrderId}`);

  // 2) Try massive BUY order to validate reservation-protected insufficient funds
  const overReserve = await api('POST', '/crypto/orders', {
    symbol: TEST_SYMBOL,
    orderType: 'LIMIT',
    side: 'BUY',
    quantity: 1000000,
    targetPrice: price,
  });

  assert(overReserve.status === 400, `Expected 400 for over-reserve, got ${overReserve.status}`);
  console.log('OK over-reserve rejected with 400');

  // 3) Cancel first order and ensure endpoint succeeds
  const cancel = await api('POST', `/crypto/orders/${firstOrderId}/cancel`);
  assert(cancel.status === 200 && cancel.data?.success, 'Cancel order failed');
  console.log(`OK cancelled order id=${firstOrderId}`);

  // 4) Ensure order status appears as CANCELLED in list
  const listed = await api('GET', '/crypto/orders');
  assert(listed.status === 200 && listed.data?.success, 'List orders failed');
  const found = (listed.data.orders || []).find((o) => o.id === firstOrderId);
  assert(found, 'Cancelled order not found in list');
  assert(found.status === 'CANCELLED', `Expected CANCELLED, got ${found.status}`);
  console.log('OK list reflects CANCELLED status');

  console.log('=== Crypto Orders API Test PASSED ===');
}

run().catch((error) => {
  console.error('Crypto orders API test failed:', error.message || error);
  process.exit(1);
});
