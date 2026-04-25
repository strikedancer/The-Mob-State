# Nightclub Protocol

## Scope
Venue management, staff, revenue, leaderboard and seasonal progression.

## Primary Frontend Entry
- client/lib/screens/nightclub_screen.dart

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- For dense management screens, prefer tab-based information architecture over long stacked cards.
- Use image-backed selectors for staff, drugs, DJs and security where assets exist; always provide icon fallbacks if an image is missing.
- Avoid fixed panel heights without breakpoints; use responsive/clamped heights so tabs remain usable on both mobile and desktop.

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
- Stable dropdown behavior after async refreshes (no duplicate values, no invalid selected value).
- Resilient screen load: one slow/failing API call may not block the whole nightclub screen.
- Live staffing selectors must never depend on manual seed steps alone; DJ/security availability data needs a production-safe bootstrap or fallback so empty staff tables do not leave selectors blank.
- Drug storage controls must keep grams visible on mobile (selected item + available grams), so players can make quantity decisions without hidden or truncated unit info.
- DJ status must reflect real active shift state; expired contracts must be cleaned up server-side so hire actions are not blocked by stale `currentDJId`.
- If Nightclub overview is rendered as a single intelligence panel (without tabs), all former Overview/Revenue/Risk essentials must remain present in that one panel with clear section headers and mobile-safe spacing.
- Rival-targeting UX in nightclub must be name-first (search by player username), never forcing players to input or know numeric player IDs.
- Ops/management additions (resident DJ, events, upgrades, incident response, rival actions, alerts) must expose clear per-action cost/impact in NL+EN before confirmation.
- Upgrade tree entries in Ops Lab must be actionable (select + purchase), not read-only status chips; players need an explicit upgrade action path per upgrade type.
- Expanded Ops Lab must support the 11-system management set (heat/raids, suppliers, promoters, dynamic events, VIP clientele, staff traits, smuggling routes, bar/kitchen, reputation, rival counter-intel, timeline) with readable mobile controls.
- Smuggling, supplier and promoter actions must remain side-grade choices (risk/reliability/price trade-off), not flat guaranteed power spikes.
- Smuggling routes must enforce a visible backend cooldown window (no infinite repeat spam), with remaining lock time exposed in stats payload for UI feedback.
- Bar & Kitchen management (drinks/food stock + menu pricing) must show stock state, spoilage risk and pricing impact in NL+EN before confirmation.

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
- Verify tab switching does not reset valid selections unexpectedly.
- Verify image selectors render with correct fallback icon when image reference is missing or invalid.
- Simulate one failing/sluggish nightclub endpoint and verify the screen still opens with partial data.
- Verify a live environment with empty DJ/security tables still shows hireable staff because backend bootstrap/fallback repopulates the availability lists.
- Verify mobile drug-storage selector keeps gram counts readable (no clipped labels) and quantity shortcuts respect available stock.
- Verify expired DJ contracts clear automatically and a new DJ can be hired immediately after shift end.
- Verify rival actions can be triggered by searching/selecting player name and never require playerId entry.
- Verify Operations Timeline shows mixed event types (sales, thefts, staffing, events) with clear severity labels.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
