# Player marketplace (Zwarte Markt — Marktplaats)

## Scope
Player-to-player listings shown on **Zwarte Markt → Marktplaats** (`black_market_screen.dart`). **Vehicles** stay on `VehicleInventory.marketListing` (existing black market service). **Other items** use `PlayerMarketListing` (`player_market_listings`).

## Current implementation (v1)
| Kind | Meaning | Notes |
|------|---------|--------|
| `player_tool` | `refId` = `player_tools.id` | Only **carried** tools can be listed; price bounds ~10%–800% of tool `basePrice`. |

## Planned (not in API yet)
Drugs stacks, crypto holdings, trade-good lots, event reward items — each needs transfer rules and validation; document here before implementation.

## HTTP API (backend `routes/market.ts`)
| Method | Path | Purpose |
|--------|------|---------|
| GET | `/market/unified?country=` | `{ listings: vehicles[], itemListings: serialized tool listings[] }` |
| GET | `/market/my-listings` | `{ listings: vehicles[], itemListings: seller’s active item listings }` |
| POST | `/market/list-tool` | Body `{ playerToolId, price }` |
| POST | `/market/delist-item/:listingId` | Cancel an item listing |
| POST | `/market/buy-item/:listingId` | Buy tool listing; response includes `player.money` |

Legacy: `GET /market/vehicles` unchanged (vehicles only).

## Service
- `backend/src/services/playerMarketplaceService.ts` — list / browse / delist / buy for `player_tool`.
- `backend/src/services/blackMarketService.ts` — vehicles only.

## Client
- `VehicleProvider`: `fetchMarketListings` → `/market/unified`; `toolMarketListings`, `myToolMarketListings`; `listPlayerToolOnMarket`, `delistPlayerToolListing`, `buyPlayerToolListing`.
- UI: combined vehicle + tool cards; FAB **Sell item** for carried tools.

## QA
- List carried tool, see it in unified feed (same country filter).
- Buy with second account: cash moves, tool transfers, slots update.
- Delist restores visibility rules; cannot buy own listing.
