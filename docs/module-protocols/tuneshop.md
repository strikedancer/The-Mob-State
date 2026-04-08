# TuneShop Protocol

Overkoepelende regels staan in [Steel Voertuig Protocol](steel_voertuig.md).

## Scope
Vehicle parts economy, tuning upgrades (speed/stealth/armor), upgrade costs, value scaling, and UI flow for the dedicated TuneShop screen.

## Primary Frontend Entry
- client/lib/screens/tune_shop_screen.dart
- client/lib/screens/dashboard_screen.dart (menu entry: TuneShop)

## Core Rules
- Parts are earned by scrapping vehicles only.
- Scrapping a vehicle must grant both money (salvage) and parts by vehicle category:
  - car parts
  - motorcycle parts
  - boat parts
- Parts are pooled per category and can be spent on any owned vehicle in that same category.
- Tuning upgrades consume parts + money.
- Higher tuning levels cost progressively more parts and money.
- Tuning money costs are category-based (car/motorcycle/boat), not tied directly to the individual vehicle base value.
- Tuning has a mandatory per-vehicle cooldown after each successful upgrade:
  - car: 180s
  - motorcycle: 120s
  - boat: 240s
- Concurrent tuning slots are VIP-gated: non-VIP max 1 active tuning cooldown across vehicles, VIP max 5.
- Tuning upgrades increase effective vehicle performance and resale/salvage value multipliers.
- Tuning must be blocked while a vehicle is in transport or repair.
- Tuning levels are per vehicle inventory item, not global per model.

## i18n Rules
- All player-facing labels, buttons, hints and error texts must remain NL/EN compatible.
- Do not add hardcoded single-language copy.

## Data/Backend Rules
- Keep player parts in a dedicated player-level storage table.
- Keep tuning levels in a dedicated per-inventory tuning table.
- Avoid destructive schema assumptions; use safe create-if-not-exists guards in service layer if needed.
- Selling or scrapping a tuned vehicle must remove its tuning record.

## UX Rules
- TuneShop must remain responsive on mobile/tablet/desktop.
- Show parts summary clearly at top.
- Show per-vehicle current tuning levels and next upgrade costs.
- Clearly indicate maxed stats.

## Asset Rules
- TuneShop backgrounds/icons follow [LEONARDO_IMAGE_GENERATION_PROTOCOL.md](../../LEONARDO_IMAGE_GENERATION_PROTOCOL.md).
- If a dedicated TuneShop background is generated, keep style aligned with vehicle heist/garage atmosphere.

## QA Checklist
- Scrapping vehicles increments correct parts bucket by category.
- Verify category pooling works: scrap one vehicle, spend those parts on a different vehicle in the same category.
- Upgrading speed/stealth/armor decreases money + parts correctly.
- Upgrade cost scales upward each level.
- Max level is enforced.
- Cooldown is enforced server-side after each upgrade and returns remaining seconds.
- Verify tuning concurrency cap: non-VIP can have only 1 active tuning cooldown vehicle, VIP can have up to 5.
- TuneShop UI shows cooldown lock state and remaining time for locked vehicles.
- Tuned vehicles return higher sell/scrap value than untuned equivalents.
- TuneShop layout remains usable on phone, tablet and desktop.

## When To Update This File
Update this protocol whenever the parts economy, tuning cost model, max levels, value multipliers, or TuneShop UI flow changes.
