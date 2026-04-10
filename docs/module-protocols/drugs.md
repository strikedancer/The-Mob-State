# Drugs Protocol

## Scope
Drug empire hub with facilities, production, inventory, heat and progression.

## Primary Frontend Entry
- client/lib/screens/drug_environment_screen.dart

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
- Visibility of current productions in both Production flow and Facility context when players expect that summary.
- Collect UX should not force a full-screen reload; after successful collect, remove only the relevant production card and sync dependent counters in background.

## Backend Contract Guardrails (Drugs)
- If drugs services use Prisma nested `include` (example: production -> facility -> upgrades), relation fields must exist in `schema.prisma`.
- Do not query non-existent model fields (example: filtering inventory by a field not present in `DrugInventory`).
- After relation/query changes: regenerate Prisma client and verify `/drugs/productions`, `/drug-facilities`, and `/drugs/inventory` all return success.

## Frontend Loading Guardrails (Drugs)
- Drug dashboards often load multiple endpoints in parallel. One failure may hide all cards if not guarded.
- Ensure failures in optional sections do not hide active productions or owned facilities.
- Prefer partial rendering with fallbacks over full-screen empty states when some API calls succeed.

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
- Verify active productions remain visible after starting a batch and navigating back to facilities.
- Verify owned facilities remain visible and upgrade options stay available after travel or refresh.
- Verify no Prisma validation errors appear in backend logs while loading drugs screens.
- Verify collect action removes only the collected production card without showing global loading spinner or reloading unrelated content blocks.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
