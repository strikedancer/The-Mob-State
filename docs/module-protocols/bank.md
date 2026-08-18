# Bank Protocol

## Scope
Deposits, withdrawals, transfers, transaction history and money safety.

## Interest
Bank interest is **intentionally disabled** (`bankService.applyInterest` / `applyInterestToAll` return 0). Player help and GAMEPLAY copy must not promise passive tick interest until it is re-enabled.

## Related: Money Laundering
Covert cash→bank wash (fee + delay + heat seize risk) leeft in [money-laundering.md](money-laundering.md) en UI op het bankscherm. Directe storting blijft gratis/instant tot een dagelijkse cap (`BANK_FREE_DEPOSIT_DAILY_*`); daarboven is laundering de enige cash→bank path. Directe storting krijgt nooit fee/delay/seize.

## Daily free deposit cap
- UTC-dag. Formula: `base + perRank × rank` (defaults €10.000 + €5.000 × rank).
- Opnames en transfers blijven gratis/onbeperkt.
- Overschrijding wordt geweigerd (geen auto-split); restant moet witgewassen of tot de volgende UTC-dag bewaard.
- Runtime: `BANK_FREE_DEPOSIT_DAILY_ENABLED` (0 = oude onbeperkte gratis storting), `BANK_FREE_DEPOSIT_DAILY_BASE`, `BANK_FREE_DEPOSIT_DAILY_PER_RANK`.

## Primary Frontend Entry
- client/lib/screens/bank_screen.dart

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
- Transaction history and transaction summary counters must reflect the same underlying deposit, withdrawal, sent-transfer and received-transfer data; withdrawals may not be omitted from the visible transaction summary.
- Daily free-deposit remaining on the bank screen must match server quota (`GET /bank/account`); over-cap deposits must fail without auto-split. Show a Fill remaining control for leftover quota and a live countdown to 00:00 UTC when the cap is used up.
- Transaction history must preserve transfer counterpart identity and any optional player-entered description for deposits, withdrawals and transfers; received transfers must show the sender's description symmetrically when one was provided.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- Bij bankoverschrijvingen krijgt de ontvanger altijd een pushmelding via de bestaande notification pipeline; dit blijft fire-and-forget en mag transfers niet blokkeren.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify daily free-deposit remaining, over-cap rejection, Fill remaining, UTC reset countdown, and that withdraw still works when remaining is 0.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
