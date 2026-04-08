# Garage Protocol

Overkoepelende regels staan in [Steel Voertuig Protocol](steel_voertuig.md).

## Scope
Vehicle inventory, steal flow, sorting, condition, fuel, timed repairs, country availability catalog, car and motorcycle progression, and world-cap rotation rules.

## Primary Frontend Entry
- client/lib/screens/vehicle_heist_screen.dart (tab: Auto)
- client/lib/screens/garage_screen.dart (embedded tab content)

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.

## Event Rules
- Rank-gate voor event-politieauto's in deze flow is rank 15.
- Police vehicle events are global vehicle events: when active, event-only police cars and police motorcycles are both stealable during the same window.
- Event-only vehicle caps are intentionally higher than 1 (rotation-friendly), so multiple players can obtain them per active event window.
- Outside active event windows, event-only police vehicles must not be stealable.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- Direct vehicle transport does not belong here anymore. Cross-country movement must route through the Smuggling Hub flow.
- Theft outcome videos are legacy and should not be reintroduced without a deliberate design decision.
- Repairs must use a timed flow, not instant click-pay-complete behavior.
- Concurrent repair slots are VIP-gated: non-VIP max 1 active repair, VIP max 5 active repairs.
- Available car and motorcycle catalog entries must expose country availability, value, rarity and world-cap information.
- World-cap rotation must remain correct: when a vehicle is sold or scrapped, one slot reopens for theft.
- Scrap system: players can scrap owned vehicles to get salvage value (35% of base value, scaled by condition and garage upgrade level). Scrapping must not be instant; it must trigger immediately but show clear feedback. Scrap price must respect garage upgrade multipliers (up to 20% bonus at max level).
- Scrapping in this flow also yields category parts for TuneShop upgrades (car/motorcycle parts).
- Keep event-only police vehicles disabled outside explicit event windows.
- Target catalog scale for this module: at least 200 cars and a broad motorcycle set, spread from common to ultra-rare tiers.
- Event-only police vehicles can only appear during active rotation windows and must never leak into normal availability outside those windows.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?
- Is the source of truth for vehicle movement in this change actually the Smuggling module instead of Garage?
- Does this change alter world availability caps, rarity tiers or repair duration balance?
- Does this change keep police event windows and category rotation intact (car vs motorcycle windows)?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Car cards must clearly show when a vehicle is in repair and when it becomes available again.
- Catalog and owned inventory views must stay visually distinct so players do not confuse available street cars with owned cars.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## Asset Rules
- Car and motorcycle images must follow the shared Leonardo workflow in [LEONARDO_IMAGE_GENERATION_PROTOCOL.md](c:/xampp/htdocs/mafia_game/LEONARDO_IMAGE_GENERATION_PROTOCOL.md).
- Every vehicle requires at least 3 state variants: new, dirty and damaged.
- Generate responsive derivatives for each variant: mobile, tablet and desktop.
- Realistic rendering is required; avoid arcade/cartoon outputs.
- Reference scripts:
  - backend/scripts/generate_vehicle_images_leonardo.py
  - backend/scripts/build_vehicle_responsive_variants.py
  - backend/scripts/prepare_vehicle_image_placeholders.py

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify the available-cars catalog matches the player country and hides capped-out vehicles.
- Start a repair and verify the vehicle becomes temporarily unavailable until the timer completes.
- Verify repair concurrency cap: non-VIP can start only 1 active repair, VIP can start up to 5.
- Confirm transport actions are no longer offered from Garage and that players are pointed to Smuggling when relevant.
- Verify event-only police cars/motorcycles only appear during active event windows.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.

