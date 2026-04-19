# Crypto Protocol

## Scope
Coin market, portfolio, orders, charts, missions, rewards and notifications.

## Primary Frontend Entry
- client/lib/screens/crypto_screen.dart

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
- Direct sell flows should offer a clear full-position shortcut when the player already owns the coin, and open-order inputs must not silently depend on an ambiguous quantity field from another section.
- If live market prices are used, keep the game loop hybrid: external anchor prices may guide the market, but regime/news modifiers, sane bounds, cache/fallback behavior and order safety must remain under backend control so the module does not hard-fail on provider outages.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- Marktnieuws en regime-notificaties worden alleen verstuurd naar spelers met een actieve crypto-positie; stuur deze signalen nooit platformbreed naar alle spelers.
- Crypto push/inbox copy moet per ontvanger op `preferredLanguage` worden opgebouwd; gebruik nooit één gedeelde Engelse headline/body voor zowel NL als EN ontvangers.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify scheduled price updates keep `current_price` within sane asset bounds and backend logs stay free of overflow/`Out of range` errors.
- Verify the external price provider can fail without breaking market loads, order processing or chart history; stale-cache fallback must continue serving prices until the synthetic fallback takes over.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
