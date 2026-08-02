# Player marketplace (Zwarte Markt — Marktplaats)

## Scope
Player-to-player listings on **Zwarte Markt → Marktplaats** (`black_market_screen.dart`). **Voertuigen** blijven op `VehicleInventory.marketListing` + `blackMarketService`. **Overige spelersitems** gebruiken `PlayerMarketListing` (`player_market_listings`, `kind` + `refId` + `quantity` + `meta` escrow JSON).

## Wat is “compleet” in deze build
| Onderdeel | Status |
|-----------|--------|
| Voertuigen P2P | ✅ |
| Gereedschap (carried tools) P2P | ✅ `kind: player_tool` |
| Drugs stacks P2P | ✅ `kind: drug_lot` (gram + quality, escrow) |
| Crypto holdings P2P | ✅ `kind: crypto_lot` (decimal qty in meta) |
| Handelswaren stacks P2P | ✅ `kind: trade_good_lot` |
| Event items P2P | ✅ `kind: event_item` (transferable chips/badges from `player_event_items`) |

## Listing fields
- `quantity`: stack size (tools = 1; crypto uses scaled int + decimal in `meta`)
- `meta`: JSON escrow payload (`drugType`/`quality`, `assetSymbol`/`quantity`/`avgBuyPrice`, `goodType`/`condition`, `itemKey`/names for event items)

## HTTP API (`backend/src/routes/market.ts`)
| Method | Path | Notes |
|--------|------|--------|
| GET | `/market/unified` | vehicles + all item kinds |
| POST | `/market/list-tool` | `{ playerToolId, price }` |
| POST | `/market/list-drug` | `{ drugInventoryId, quantity, price }` |
| POST | `/market/list-crypto` | `{ assetSymbol, quantity, price }` |
| POST | `/market/list-trade-good` | `{ inventoryId, quantity, price }` |
| POST | `/market/list-event-item` | `{ eventItemId, quantity, price }` |
| POST | `/market/delist-item/:id` | restores escrow for stack kinds |
| POST | `/market/buy-item/:id` | cash + transfer / merge |

Inventory for event items: `GET /game-events/my-items`. Grants via event reward `items[]` and `POST /admin/game-events/event-items/grant`. Bound catalog keys (`event_badge_rival`) are not listable.

## Services
- `playerMarketplaceService.ts` — tools + drug/crypto/trade/event lots
- `eventItemService.ts` — catalog + inventory credit/debit
- `blackMarketService.ts` — vehicles

## Client
- Sell FAB → kind picker (tool/drug/crypto/trade/event)
- Polymorphic `PlayerToolMarketListing` model

## QA
1. List partial drug grams → escrow lowers inventory; delist restores; buy merges quality stack.
2. Crypto list/buy preserves avg_buy_price weighting.
3. Trade list respects `maxInventory` on buyer.
4. Event item: grant transferable chip → list/buy/delist; bound badge rejects list.
5. Unified feed shows mixed kinds; own listings delist works.

## Zie ook
- [black-market.md](black-market.md)
- [trade.md](trade.md)
- [events.md](events.md)
- [PROTOCOL_MASTER.md](PROTOCOL_MASTER.md)
