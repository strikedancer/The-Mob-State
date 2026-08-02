# Bank Protocol

## Scope
Deposits, withdrawals, transfers, transaction history and money safety.

## Interest
Bank interest is **intentionally disabled** (`bankService.applyInterest` / `applyInterestToAll` return 0). Player help and GAMEPLAY copy must not promise passive tick interest until it is re-enabled.

## Related: Money Laundering
Covert cash→bank wash (fee + delay + heat seize risk) leeft in [money-laundering.md](money-laundering.md) en UI op het bankscherm. Directe storting blijft gratis/instant; laundering is de riskante covert path.

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

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
