# Stock Market Protocol

## Scope
Bank-funded slow-moving stock trading, separate from crypto.

Niet in scope:
- Crypto coins/orders/regimes
- Cash-funded trades
- Leveraged / short selling (v1)

## Primary Frontend Entry
- `client/lib/screens/stock_market_screen.dart`
- Dashboard web-sectie `_WebSection.stockMarket`
- `client/lib/services/stock_market_service.dart`

## Primary Backend Entry
- Routes: `backend/src/routes/stockMarket.ts` (`GET /stock/market`, `POST /stock/trade`)
- Service: `backend/src/services/stockMarketService.ts`
- Schema bootstrap: `ensureDeepEconomySchema.ts` (`stock_assets`, `stock_holdings`, `stock_trades`)
- Cron: `tickStockPrices` elke minuut

## Change Rules
- Stocks blijven een apart asset-systeem van crypto (eigen tabellen, UI, runtime keys).
- Trades debiteren/crediteren alleen bank.
- Price tick blijft bounded + mean-reverting; geen externe live feed in v1.
- Position count begrensd door `STOCK_MARKET_MAX_POSITIONS`.

## Cross-Module Dependencies
- Stock Market -> Bank (funding)
- Stock Market -> Dashboard (nav + economy strip `stockPortfolioValue` + quick actions / mobile menu)
- Stock Market -> Balance & Economy (sink/source pacing)
- Stock Market -> Crypto (expliciet gescheiden; geen gedeelde orders)

## Dashboard Contract
- `/player/dashboard-stats` `economy.stockPortfolioValue` = som `stock_holdings.quantity * stock_assets.currentPrice` (enabled assets); telt mee in `netWorth`.

## Must Preserve
- Buy faalt bij te weinig banksaldo.
- Sell faalt bij te weinig holdings.
- Nieuwe ticker-positie faalt boven max positions.
- Market load blijft bruikbaar als tick faalt voor één asset.

## Runtime Keys
- `STOCK_MARKET_ENABLED`
- `STOCK_MARKET_TICK_SECONDS` (default 60)
- `STOCK_MARKET_MAX_POSITIONS` (default 10)

## Seed tickers (v1)
TMS, NRD, GLC, HBR, VIP — seeded in `ensureDeepEconomySchema`.

## QA Checklist
1. Market load toont assets + bank + portfolio.
2. Buy verlaagt bank, verhoogt holding.
3. Sell verhoogt bank, verlaagt holding.
4. Position-limit en disabled foutpaden.
5. Help-topic stock-market aanwezig; crypto-help claimt geen aandelen.
6. Load-fout toont retry; lege tickerlijst toont empty-state; summary toont bank/portfolio/open posities.

## When To Update This File
Update bij nieuwe order types, externe price feeds, shorting of shared portfolio met crypto.
