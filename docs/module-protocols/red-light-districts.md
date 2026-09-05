# Red Light Districts Protocol

## Scope
District ownership, country-level expansion and prostitution territory progression.

## Primary Frontend Entry
- client/lib/screens/red_light_districts_screen.dart (also embedded as Empire hub tab RLD)
- District detail: `client/lib/screens/red_light_district_detail_screen.dart`

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- List load failure must show retry (`MobileLoadError`); TabBar is scrollable on narrow widths.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Help mag geen PvP-districtovername beloven. Politieraids lopen via de tick (`checkAndExecuteRaid`) bij FBI-heat ≥ 50.
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- District data integrity: country districts must always exist (idempotent seed/repair on read paths) so RLD purchase flow cannot dead-end after an empty DB state.
- Upgrade and raid UI use existing APIs only: `getUpgradeInfo` / `upgradeTier` / `upgradeSecurity` / `getRaidStats` — no new raid mechanics from the client.

## District detail UI
- Header: country, rooms occupied/empty, tier, security level.
- Upgrade panels with confirm dialogs (cost + effect from upgrade-info).
- Room grid: occupied vs empty with assign CTA.
- Raid risk panel: FBI heat, raid chance %, max security, district count, busted workers.

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
- Verify `/red-light-districts/country/{currentCountry}` returns a district after fresh/empty database startup (no persistent 404 due to missing seed rows).
- Verify tier/security upgrade confirm → success/failure snackbar → refreshed levels.
- Verify raid stats panel loads when player owns districts (or shows zeros safely).

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
