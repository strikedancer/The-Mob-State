# Black Market Protocol

## Scope
Unified **illegal / grey economy hub**: contraband **handelswaren** (first tab), vehicle marketplace, my listings, backpacks, raw materials, weapons market and ammo.

## Primary Frontend Entry
- `client/lib/screens/black_market_screen.dart` — outer `TabBar` / `TabBarView` (voertuigen-aanbod: tabtekst `AppLocalizations.marketplace`, o.a. NL *Marktplaats*)
- `client/lib/screens/trade_goods_tab.dart` — eerste zwarte-markt-tab: contrabandmarkt + inventaris in **één scroll** (`/trade/*` APIs; geen aparte sub-tabs meer). Koop/verkoop als compacte rijen (naam, risico-pills, prijs, aantal, actie); lange flavor-tekst zit in tooltip. Hub-tabs zijn één regel (icoon + label).
- Zelfde compacte rij-patroon (`client/lib/widgets/market_compact.dart`) op **Wapenmarkt**, **Munitiemarkt**, **Materialen** en **Rugzakken**: thumbnail, naam + info-pills, prijs, compacte actie; beschrijving in tooltip. Koop/verkoop-API’s, rank/VIP-gates en dialogen ongewijzigd.
- Legacy route `TradeScreen` redirects to this screen with `initialTabIndex: 0`

## Marktplaats (P2P)
Speler-tegen-speler verkoop op de **Marktplaats**-tab: **voertuigen** (auto/motor/boot als voertuigtype, bestaande `VehicleInventory`-flow) plus **niet-voertuig**-advertenties via `PlayerMarketListing`. Volledige API-contract, foutcodes, migratie/deploy-checklist en roadmap (drugs/crypto/event-items): **`player-marketplace.md`**. De client gebruikt **`GET /market/unified`** (`listings` + `itemListings`); legacy **`GET /market/vehicles`** blijft alleen voertuigen leveren.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
