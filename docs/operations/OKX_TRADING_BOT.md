# OKX trading bot (standalone)

De OKX-handelsbot staat in [`services/okx-trading-bot/`](../../services/okx-trading-bot/) en is **niet** gekoppeld aan spelers of `backend/src/services/cryptoService.ts`. Standaard draait hij in **`TRADING_MODE=paper`**: echte orders worden niet geplaatst; er is een **SQLite**-ledger onder `OKX_BOT_DATA_DIR` (default: `.data/paper.sqlite` relatief t.o.v. de working directory).

## Wat het doet (MVP)

- Publieke OKX REST: **ticker** + **candles** (`OKX_INST_ID`, `OKX_BAR`).
- Periodieke **tick** (`TICK_INTERVAL_MS`): signalen (SMA-kruis + RSI-bias) en paper koop/verkoop tegen **last price**.
- HTTP: `/health` (open), `/dashboard` (statische UI), `/api/*` met **`Authorization: Bearer <BOT_ADMIN_TOKEN>`**.

## Lokale start

```bash
cd services/okx-trading-bot
cp .env.example .env
# Vul BOT_ADMIN_TOKEN in
npm install
npm run dev
```

- Dashboard: `http://127.0.0.1:3847/dashboard` — plak hetzelfde token als in `.env`, of open eenmalig `.../dashboard?token=...` (alleen in vertrouwde omgeving).

## Productie

1. `npm run build && npm start` (Node 20+ aanbevolen).
2. Procesbeheer: **systemd** of **Docker** naast de game-stack; eigen poort (default **3847**).
3. **Reverse proxy** (nginx/caddy) met TLS naar `http://127.0.0.1:3847` als je het dashboard publiek wilt; beperk IP of VPN waar mogelijk.
4. Zet `CORS_ORIGINS` op je admin-origins (comma-gescheiden) i.p.v. `*` zodra je weet welke host de admin gebruikt.

### Secrets

- `BOT_ADMIN_TOKEN`: lang en random; roteer bij lek.
- Live-handel op OKX (toekomst): API key, secret, **passphrase** — nooit in git; alleen server-env.

## Admin-panel (ingebouwd in deze repo)

De React-admin heeft een tab **OKX bot** die een **iframe** laadt.

Bouw de admin met een absolute dashboard-URL:

```text
VITE_OKX_BOT_URL=https://jouw-bot-host/dashboard
```

Voor lokaal (standaard fallback in code): `http://127.0.0.1:3847/dashboard`.

**Let op:** het bot-dashboard vraagt **handmatig** om hetzelfde token als `BOT_ADMIN_TOKEN` (of via `?token=`). De admin-login van het spel vervangt dat niet automatisch.

## Live trading

De huidige codebase is **paper-first**. `TRADING_MODE=live` **plaatst nog geen** orders — alleen logging dat live routing niet in deze build zit. Voeg OKX trade API + signing pas toe na risk limits en tests.

## Troubleshooting

- **401 op /api/**: verkeerde of ontbrekende `Authorization: Bearer`.
- **Geen candles**: check `OKX_INST_ID` (bv. `BTC-USDT`) en netwerk/firewall naar `www.okx.com`.
- **native module**: `better-sqlite3` bouwt met node-gyp; op Linux build tools installeren als build faalt.
