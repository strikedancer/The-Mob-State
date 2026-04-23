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
- Crew HQ member-cap progression must stay continuous across all HQ styles and levels; the cap overview may not reset per style and must scale through to the intended max of 150 members.
- Crew HQ upgrade costs must stay continuous across all HQ styles and levels; upgrade prices may not reset per style tier and must keep increasing per next global level.
- HQ progression CTA copy in `HQ & Upgrades` must stay level-based (upgrade to next level) instead of style-unlock wording.
- Crew land-vehicle storage must accept both cars and motorcycles through the same crew storage path, while boats remain separate in boat storage.
- Crew War actions that target an opponent player must offer a selectable list of enemy crew members in the War Room; players may not be forced to know or manually type raw player IDs.
- Crew HQ and storage cards must show purchase and upgrade costs directly in the UI; price information may not be hidden behind failed actions.
- Zodra een HQ-stijl zijn max-level bereikt, moet de UI direct een actie tonen om de volgende HQ-stijl te ontgrendelen (als die bestaat), in plaats van stil op "max level" te blijven hangen.
- Crew/HQ images must use the shared platform-safe loading path with icon fallback so externally mounted web assets do not disappear silently.
- Side-building image style selection must follow the side-building level tier (L1-2 camping, L3-4 rural, L5-7 city, L8-10 villa, L11-15 vip) and may not be derived from current HQ style.
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
- Verify the Crew HQ level overview shows a continuous member-cap curve across all HQ styles and reaches 150 members at the top end instead of restarting from the base caps.
- Verify car storage accepts both cars and motorcycles, while boat storage still only accepts boats.
- Verify targeted Crew War actions show a selectable enemy player list and still submit the correct target player to the backend.
- Verify purchase and upgrade buttons/dialogs show the correct euro amounts for HQ and every storage building.
- Verify HQ/storage images still load on web when assets are served through external mounts or nginx alias fallbacks.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
