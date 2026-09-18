# Prison Protocol

## Scope
Jail state, prisoner list, actions while jailed and release-related flow.

## Primary Frontend Entry
- client/lib/screens/prison_screen.dart

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
- Jail overlay still: `client/assets/images/cooldown_jail.png` served on web as `/images/cooldown_jail.png`. Leonardo: `backend/scripts/generate_jail_image_leonardo.py --force --confirm-batch YES --mirror-client-assets`. Deploy copies it onto the runtime mount. Client uses `WebAssetHelper` + `kCooldownArtCacheBust`. Do not keep a second copy under `client/images/`.

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- While jailed, self-service actions remain available from prison UI: paying your own bail and attempting your own escape may not disappear from the primary prison flow.
- While jailed the Black Market hub is closed (client jail overlay + server `requireNotJailed` on shop/market buy/sell/list). Training hub stays open for gym tracks (strength/speed/stamina); shooting-range train is blocked.
- Self-escape is capped at **2 attempts per jail stay** (`SELF_ESCAPE_MAX_ATTEMPTS`) with a **15 minute** cooldown (`SELF_ESCAPE_COOLDOWN_SECONDS`). Failed attempts still add 15 minutes. After the cap, bail / crew jailbreak / serving time remain available. Jail overlay and prison list must disable the button and show remaining attempts or cooldown.
- Na succesvolle borgbetaling moet de client opnieuw jail- en cooldown-state ophalen in plaats van alleen losse crimes-refreshes te doen.
- Borgbedragen moeten meeschalen met resterende celstraf, niet alleen met wanted level.
- Jail- en cooldown-overlays moeten op mobiel compacte header-typografie en zichtbare snackbar/toast feedback houden.
- `GET /player/prisoners` moet licht blijven: alleen spelers met `jailRelease > now` (max. 100), geen N+1 `checkIfJailed` over oude `crime_attempts`. Index `players.jailRelease` dekt die filter. Mobiel toont bij een laadfout een retry en pull-to-refresh.
- Arrestatieflows moeten vrienden en crewleden kunnen signaleren dat iemand op hulp wacht, zonder dat het vrijlaten, borg of sentence-state in de gevangenis breekt.
- A successful helper jailbreak (`POST /player/jailbreak/:targetId`) or buyout (`POST /player/prison/buyout/:targetId`) awards the helper `player_helped` reputation (+15). Self-escape and paying your own bail do not.
- Leader and co-leader can pay a **crewmate’s** bail from the crew bank (`payFrom: crew_bank`). That spend does not go to the payer’s pocket. About 20% of those payments arrest the payer for dirty money (30–45 min jail, wanted +8); the target is still freed. Payer must not be jailed. Members / consigliere / capo do not get this button. Personal-cash buyout of anyone is unchanged.
- Wereldchat krijgt één systeemregel wanneer een echte speler de cel in gaat, met strafduur, en wanneer een andere speler diegene uitkoopt of uitbreekt (beide namen). Eigen borg en eigen ontsnapping blijven stil. NPC-arrestaties niet in de lobby. Zwartgeld-arrest na crewbank-uitkoop meldt dat de betaler is opgepakt wegens zwart geld.
- Jail-clock `player.update` (checkIfJailed, setJailReleaseClock, jailPlayer) retries MariaDB 1020 write conflicts; backpack-seize slot refresh does the same so concurrent dashboard/arrest writes do not 500.
- Succesvolle rechteromkoping, borg en ontsnapping moeten dezelfde jail-lock wissen (`jailed=false` op alle actieve rijen + `jailRelease=null`). Crime-outcomes die al `jailed` op de poging zetten mogen geen tweede `police_arrest` / `federal_arrest` rij aanmaken.

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
- Verify a successful jailbreak or buyout awards the helper +15 reputation, and that self-escape / own bail does not.
- Verify only leader/co-leader see Crew vault on a jailed crewmate, that the confirm dialog warns about dirty-money arrest, that the crew bank drops by the bail, and that a personal buyout still uses the payer’s cash.
- Verify a dirty-money miss still frees the target, and a hit jails the payer (~30–45 min) with a world-chat black-money line that includes duration.
- Verify a crime catch posts exactly one world-chat jail line with remaining sentence time.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
