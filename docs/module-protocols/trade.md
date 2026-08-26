# Trade (contraband) — technical note

## Status
Player-facing **handelswaren** UI is merged into the **Zwarte markt** hub: first tab in `client/lib/screens/black_market_screen.dart` implemented by `client/lib/screens/trade_goods_tab.dart`. There is no separate dashboard entry anymore.

## Scope (unchanged backend)
- REST: `/trade/goods`, `/trade/prices`, `/trade/inventory`, `/trade/buy`, `/trade/sell` (`backend/src/routes/trade.ts`, `tradeService`).
- **16 contraband lines** in `backend/content/tradableGoods.json`; each has `availableInCountries` (buy only in source countries; sell anywhere with country multiplier), `category` (starter|bulk|luxury|dangerous) and `tier` (1–4).
- Country multipliers (`countries.json` → `tradeBonuses`), spoilage, volatility, weight and travel risk fields stay server-driven.
- Smokkel van handelswaren (`smugglingService`) moet `purchasePrice`/`condition` meenemen; claim mag die niet op 0 zetten (anders is UI-winst = verkoopbedrag).
- Verkoop (`/trade/sell`) geeft **kleine XP** (volume + winst, max 30) via `playerService.gainXP`.
- Tijdens actief **`contraband_rush`** event (category `trade`): verkoop en claim van trade-smuggle shipments scoren eventpunten via `gameEventTradeContribution.ts` → `gameEventService.recordContribution(..., 'trade', ...)`. Zie `events.md`.

## When to read instead
- UX, tabs, filters, vehicles and other black-market flows: **`docs/module-protocols/black-market.md`**.
- Image pipeline for good thumbnails: **PROTOCOL_MASTER** (Leonardo + `runtime/client-images/trade_goods/`).

## QA
- Verify contraband tab + vehicles + listings still refresh after actions; partial `/trade` load errors still show the orange banner inside the first tab.
- Risk guide expansion uses theme `onSurface` colors (readable on noir/gold cards).
