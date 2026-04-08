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

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
