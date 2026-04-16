# Crew Protocol

## Scope
Crew membership, HQ progression, storage, requests and crew coordination.

## Primary Frontend Entry
- client/lib/screens/crew_screen.dart

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
- Fresh crews must start with Crew HQ and all crew storage buildings at level 1 so bank deposits, shared storage and upgrade flows work immediately without a manual bootstrap purchase.
- Crew HQ and storage cards must show purchase and upgrade costs directly in the UI; price information may not be hidden behind failed actions.
- Crew/HQ images must use the shared platform-safe loading path with icon fallback so externally mounted web assets do not disappear silently.
- Top-level crew navigation should stay grouped by management intent instead of exposing every storage type as a separate main tab.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## Notification Guardrails
- Crew-gerelateerde arrestatie-alerts moeten alle overige crewleden bereiken wanneer een lid vast komt te zitten.
- Pushdispatch voor deze alerts blijft fire-and-forget en mag heists, crimes of andere arrestflows niet blokkeren.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify a freshly created crew immediately has HQ level 1 plus all storage buildings on level 1, including cash storage, and can deposit into the crew bank without a separate unlock step.
- Verify purchase and upgrade buttons/dialogs show the correct euro amounts for HQ and every storage building.
- Verify HQ/storage images still load on web when assets are served through external mounts or nginx alias fallbacks.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
