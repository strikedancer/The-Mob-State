const assert = require('assert');

const PROMO_IMAGE_RE = /^promo\/[a-z0-9][a-z0-9._/-]{0,80}\.png$/i;

function sanitizeSystemImageUrl(raw) {
  const value = String(raw ?? '')
    .trim()
    .replace(/\\/g, '/')
    .replace(/^\/+/, '');
  const stripped = value.replace(/^(images\/|assets\/images\/)/, '');
  if (!PROMO_IMAGE_RE.test(stripped)) return null;
  return stripped;
}

assert.strictEqual(sanitizeSystemImageUrl('promo/court_record_wipe.png'), 'promo/court_record_wipe.png');
assert.strictEqual(sanitizeSystemImageUrl('/images/promo/court_record_wipe.png'), 'promo/court_record_wipe.png');
assert.strictEqual(sanitizeSystemImageUrl('https://evil.test/x.png'), null);
assert.strictEqual(sanitizeSystemImageUrl('promo/../secret.png'), null);
assert.strictEqual(sanitizeSystemImageUrl('avatars/1.png'), null);
console.log('test-global-chat-promo: ok');
