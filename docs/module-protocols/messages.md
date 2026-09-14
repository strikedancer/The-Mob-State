# Messages Protocol

## Scope
Direct messages, system inbox messages, unread state and chat entry points.

## Primary Frontend Entry
- client/lib/screens/direct_messages_screen.dart

## Related APIs
- `GET /messages/unread` is a cheap unread count (badge / “nieuwe berichten”). Index: `(receiverId, read)` on `direct_messages`.
- `GET /messages/conversations` uses one grouped query for player DMs (max 40) plus one latest-system-notices query (max 50). Never N+1 per friend. Player threads stay grouped. **Each system notice is its own inbox row** (`friendId = -messageId`) so badges, payouts and orders do not share one long The Mob State chat. `friendId = 0` still loads the legacy combined system thread. The inbox lists existing threads (player DMs + system notices), not only current accepted friends.
- A load failure on mobile must show retry — never the empty “no messages” state while unread badges are still green.
- Chat thread (`chat_screen.dart`) follows the same rule: failed conversation load shows retry, not “no messages”.
- Composer (`MessageInput`): **Enter** sends, **Shift+Enter** inserts a new line. Same widget for player DMs, crew chat and world chat. The live-event rail is hidden on Messages, Crew and World chat so it cannot cover the send button.
- `POST /messages/mark-all-read` — mark every visible unread inbox message as read (badge + read receipts).
- `POST /messages/hide` — `{ friendIds: number[] }` or `{ all: true }`. Hides those threads for this player only (marks unread as read first).
- Hide only affects this player (`hiddenForSender` / `hiddenForReceiver`). A later message is not hidden, so the thread returns. Do not hard-delete the other player's copy. `DELETE /messages/conversation/:otherPlayerId` and `DELETE /messages/read` stay as hide-one / hide-read shortcuts.

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
- Open inbox on mobile after an unread/push badge: existing player threads and **separate** system notices must appear (one row per notice, not one combined The Mob State thread). A timeout must show retry, not “Nog geen berichten”.
- In a player or crew chat, Enter sends and Shift+Enter adds a new line. The live-event rail must not cover the send button.
- A inbox row can be removed (swipe / trash / select several / delete all). Mark all as read clears the badge without opening each thread. After hide, the other player's chat is still there.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
