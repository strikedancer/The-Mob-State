# Messages Protocol

## Scope
Direct messages, system inbox messages, unread state and chat entry points.

## Primary Frontend Entry
- client/lib/screens/direct_messages_screen.dart

## Related APIs
- `GET /messages/unread` is a cheap unread count (badge / “nieuwe berichten”).
- `GET /messages/conversations` must stay a **single grouped query** over `direct_messages` (last message + unread per thread, max 80). Never N+1 per friend. The inbox lists **existing threads** (player DMs + The Mob State system inbox), not only current accepted friends.
- A load failure on mobile must show retry — never the empty “no messages” state while unread badges are still green.

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
- Timestamps uit API of SSE moeten altijd expliciet naar lokale tijd worden geconverteerd vóór rendering.

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
- Open inbox on mobile after an unread/push badge: existing system and player threads must appear. A timeout must show retry, not “Nog geen berichten”.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
