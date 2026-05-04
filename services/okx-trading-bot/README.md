# OKX trading bot (standalone)

Paper-first bot that reads **live OKX market data** (ticker + candles), computes simple technical signals, and simulates orders in **SQLite** (`TRADING_MODE=paper`). Live signed orders are **not** implemented in this MVP.

## Quick start

```bash
cd services/okx-trading-bot
cp .env.example .env
# Edit .env — set BOT_ADMIN_TOKEN
npm install
npm run dev
```

- Health: `GET http://127.0.0.1:3847/health`
- Dashboard: `http://127.0.0.1:3847/dashboard` (paste admin token in UI, or open `/dashboard?token=YOUR_TOKEN` once)

API (requires `Authorization: Bearer <BOT_ADMIN_TOKEN>`):

- `GET /api/status` — snapshot + log tail
- `GET /api/orders` — recent paper orders

## Production

Use `npm run build && npm start`. Set `OKX_BOT_DATA_DIR` if you want the SQLite file outside the working directory.

See `docs/operations/OKX_TRADING_BOT.md` in the repo root for deployment and admin link.
