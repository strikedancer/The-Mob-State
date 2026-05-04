# Player marketplace (Zwarte Markt — Marktplaats)

## Scope
Player-to-player listings on **Zwarte Markt → Marktplaats** (`black_market_screen.dart`). **Voertuigen** (auto, motor, boot als `vehicleType`) blijven op `VehicleInventory.marketListing` + `blackMarketService`. **Overige spelersitems** gebruiken `PlayerMarketListing` (`player_market_listings`, `kind` + `refId`).

## Wat is “compleet” in deze build
| Onderdeel | Status |
|-----------|--------|
| Voertuigen P2P | ✅ Bestaand (`/market/vehicles`, nu ook in `/market/unified` → `listings`) |
| Gereedschap (carried tools) P2P | ✅ `kind: player_tool` |
| Drugs / crypto / handelswaren-stacks / event-items P2P | ❌ Niet geïmplementeerd — vereist eigen transferregels per domein; zie [Planned](#planned-roadmap) |

## Current implementation (v1)
| Kind | Meaning | Notes |
|------|---------|--------|
| `player_tool` | `refId` = `player_tools.id` | Alleen **carried** (`location === 'carried'`); prijs ~10%–800% van tool `basePrice`; koop contant; `inventory_slots_used` herberekend na koop. |

## Planned roadmap
| Kind (voorstel) | Domein | Vereist o.a. |
|-----------------|--------|----------------|
| `drug_lot` | `DrugInventory` | Grammen, land, confiscatie-regels |
| `crypto_lot` | crypto holdings | Coin, hoeveelheid, wallet-limieten |
| `trade_good_lot` | contraband inventory | Zelfde risico’s als `/trade` |
| `event_item` | event rewards | Item-id schema, bind/cooldown |

Geen UI beloven voor deze types tot de bijbehorende `buy`-/`list`-paden in `playerMarketplaceService` (of aparte service) staan.

## HTTP API (`backend/src/routes/market.ts`)
| Method | Path | Response / notes |
|--------|------|-------------------|
| GET | `/market/unified?country=` | `event: market.unified_listings` — `listings` (vehicles), `itemListings` (tools) |
| GET | `/market/vehicles` | Alleen voertuigen (legacy) |
| GET | `/market/my-listings` | `listings` (eigen voertuigen te koop), `itemListings` (eigen tool-ads) |
| POST | `/market/list/:inventoryId` | Voertuig te koop zetten (bestaand) |
| POST | `/market/list-tool` | Body `{ playerToolId, price }` |
| POST | `/market/delist-item/:listingId` | Item-advertentie annuleren |
| POST | `/market/buy-item/:listingId` | `player.money`, `params.purchasePrice` |

## Foutcodes (client ↔ API)
Veel endpoints gebruiken `params.reason`: `NOT_FOR_SALE`, `CANNOT_BUY_OWN`, `INSUFFICIENT_FUNDS`, `INVENTORY_FULL`, `LISTING_STALE`, `TOOL_NOT_CARRIED`, `ALREADY_LISTED`, `NOT_OWNER`, `LISTING_NOT_FOUND`, `INVALID_PRICE`, enz. Client: `VehicleProvider._getErrorMessage`.

## Database & deploy
- Migratie: `backend/prisma/migrations/20260516120000_player_market_listings/`.
- Productie: `scripts/vps_pull_and_build.ps1` draait onder andere `npx prisma migrate deploy` (backend-container). Zonder deze stap bestaat `player_market_listings` niet.

## Services
- `playerMarketplaceService.ts` — niet-voertuig listings.
- `blackMarketService.ts` — alleen voertuigen.

## Client (bronbestanden)
| Bestand | Rol |
|---------|-----|
| `client/lib/screens/black_market_screen.dart` | Marktplaats-tab, filters, voertuig- + toolkaarten, FAB Verkoop item |
| `client/lib/providers/vehicle_provider.dart` | `fetchMarketListings` → unified, tool buy/list/delist |
| `client/lib/models/player_tool_market_listing.dart` | JSON-model `itemListings` |

## i18n
Keys cluster `bmHub*` + help `helpTopicBlackMarket*` — zie PROTOCOL_MASTER (i18n-workflow).

## QA (minimaal)
1. Verkoop gedragen tool → zichtbaar in unified feed (landfilter).
2. Tweede account koopt → geld en eigendom kloppen; slots bijgewerkt.
3. Delist → advertentie weg; eigen listing niet kopen.
4. Refresh na actie.

## Zie ook
- [black-market.md](black-market.md) — hub UI
- [trade.md](trade.md) — contraband API (geen P2P stacks in deze build)
- [PROTOCOL_MASTER.md](PROTOCOL_MASTER.md) — centrale workflow
