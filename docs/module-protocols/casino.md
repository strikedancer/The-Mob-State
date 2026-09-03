# Casino Protocol

## Scope
Casino hub, minigames, betting flow and casino ownership or management data.
House loop (Casino 2.0): one casino per country, floors (public/VIP/private), visible rake, one hire per staff role (dealer/security/promoter), salaries from bankroll on the game tick, and `casino_ledger_raid` bankroll drain in the run start country.

## Primary Frontend Entry
- client/lib/screens/casino_screen.dart
- client/lib/screens/casino_management_screen.dart (`embeddedInDialog: true` when opened from the casino hub — modal dialog, not a pushed full-route)
- client/lib/screens/games/baccarat_screen.dart
- client/lib/screens/games/video_poker_screen.dart
- client/assets/images/casino/baccarat.png
- client/assets/images/casino/video_poker.png

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

## House loop
- Floors 1–3 set `maxBet` and base rake (`CASINO_FLOOR_MAX_BET_*`, `CASINO_RAKE_BPS_*`). Upgrade costs come from player cash (`CASINO_FLOOR_UPGRADE_2/3`).
- Dealer raises rake and can trim payouts; promoter raises max bet and FBI heat; security lowers ledger-raid drain. Max one active hire per role.
- Staff salary is paid from `CasinoOwnership.bankroll` on the existing game tick. Too low → fire cheapest hire and run the low-balance path.
- Successful `casino_ledger_raid` drains `%` of bankroll in the run `startCountry` (starter `currentCountry` at start; starter country at resolve as fallback). Skip if the casino owner is in the raiding crew. Crew cash reward is unchanged.
- Admin → Casino tab edits runtime keys. Do not flip Clearing House gate defaults here.
- Bankruptcy must clear `Property.playerId` as well as the ownership row.

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Casino open en closed states moeten op mobiel/tablet/desktop altijd 1 primaire verticale scrollflow hebben; content mag niet vastlopen door fixed-height of center-only layouts.
- Casino minigames zelf moeten op mobiel/tablet/desktop in één viewport bruikbaar blijven: kernactie, inzet en status moeten zonder verplichte verticale scroll direct zichtbaar zijn (fit-to-screen canvas met schaalfallback).
- Purchase-flow mag nooit een permanente loading-state achterlaten; ook bij onverwachte backend-events of partial failures moet de UI fallbacken naar een bruikbare foutmelding en `_isLoading` vrijgeven.
- Casino aankoop moet altijd een valide `Property` record kunnen schrijven met actuele Prisma velden (inclusief verplichte `purchasePrice`); legacy velden die niet meer in schema staan mogen niet in create/upsert payloads blijven.
- Casino minigames moeten vanuit het casino-overzicht in dezelfde dashboard/content-shell openen (embedded route), niet als los fullpage scherm buiten de game-content.
- Nieuwe casino game-types (zoals `baccarat` en `video_poker`) moeten dezelfde backend bankroll- en transactielogica gebruiken als bestaande games; resultaten in `casinoTransaction.result` altijd als JSON-string opslaan.

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

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
