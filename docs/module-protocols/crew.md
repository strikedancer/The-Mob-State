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
- Crew overview on mobile must show the HQ still as an image (not a squeezed ListTile of HQ label + style + level). Member counts use singular/plural (`1 lid` / `2 leden`).
- Crew chat uses the same `MessageInput` as DMs: Enter sends, Shift+Enter is a new line. The dashboard live-event rail stays hidden on Crew so it cannot cover the send button.
- Fresh crews must start with Crew HQ and all crew storage buildings at level 1 so bank deposits, shared storage and upgrade flows work immediately without a manual bootstrap purchase. Concurrent crew/storage GETs must upsert those starter rows (unique `crewId`) instead of racing `create`, so two members opening the same new crew do not 500. Starter set includes **Tool Storage** (`tool_storage` / Gereedschapopslag): deposit carried tools only; no personal withdraw.
- Crew-bank cash buttons on Overview are bank verbs, never jail-bail or military-retreat wording. Dutch: **Storten** / **Opnemen** (`crewUiLabelDeposit` / `crewUiLabelWithdraw`). English stays Deposit / Withdraw. Dialog titles (`crewUiTr84` / `crewUiTr85`) must match that meaning.
- Cash-storage upgrades are paid from the crew bank, which is capped by the current cash-storage capacity. The next cash-storage upgrade cost must stay below that capacity so a crew can always pay it from the vault (level 1 holds €1.000.000; the step to level 2 costs €450.000).
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
- Crew recruiting uses `recruitingOpen` (default true) and `autoAccept` (default false). Open + auto-accept joins instantly via `joinCrew()`; open without auto-accept still uses a pending request. Closed crews stay off `GET /crews/recruiting`.
- Startup ensures an open auto-accept starter crew when none exists: **The Rookies** (leader `StreetBureau`). Do not steal a real player crew of that name if another open auto-accept crew is already live. The empty crew state leads with **Browse open crews**, not create. Do not put a second Open-crews FAB on the Crews list; that tab already is the list.
- Recruiting list rows must distinguish **open/instant** (green badge + Join now) from **application required** (orange badge + Apply). Do not label both as a generic Join.
- Applicants must see pending state and be able to cancel (`POST /crews/:id/join/cancel`). Leaders toggle recruiting on the Members tab.
- Each ISO week has one missable crew weekly goal (`crew_week_mission_1`, fallback `crew_week_crimes_15`). Unclaimed rewards expire at the end of the UTC week. No invite API in this flow.
- Extra roles besides `leader` / `co_leader` / `member`: `consigliere` (Don crew overview, no bank withdraw) and `capo` with optional `capoCountry` (crew-bank tribute only in that country). Leader sets roles via `POST /crews/:id/members/:playerId/role`. See [don.md](don.md).
- Shared crew storage is crew inventory, not a personal garage. Cars/motorcycles/boats/weapons/ammo/trade deposit into crew and are consumed by crew smuggling, missions, deals or enemy raids; they cannot be withdrawn for personal crimes. Drugs can be withdrawn or wholesaled. Weapons and ammo also feed Territory (HQ reserve plus frontline arms-cache); building level stays the cap. Crew Wars raids still steal the same HQ stacks.
- Leader and `co_leader` can buy a jailed crewmate out from Prison using the crew bank (`POST /player/prison/buyout/:targetId` with `payFrom: crew_bank`). Personal cash buyout stays available to everyone. Crew-bank payment has a dirty-money arrest risk on the payer (target is still freed). Members, consigliere and capo cannot pay from the vault.
- Crew VIP is real-money. Every member can donate into a shared pot (`/subscriptions/checkout/crew-vip-donate`) or one member can start the monthly subscription (`/subscriptions/checkout/crew-vip`). In-game crew-bank cash never buys Crew VIP. When the pot reaches the monthly price the crew gets 30 days. Gift Crew VIP by name stays a one-time 30-day gift.
- Crew storage deals are officer-only escrow with another crew. Goods leave storage immediately; both crews confirm or the whole deal rolls back. Do not steal from your own crew or from personal inventories.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## Backend Guardrails
- Heist resolve (`startHeist` fail/success) must not run per-member Prisma writes inside an interactive `$transaction`. Jail rows go through `crimeAttempt.createMany`; payouts/XP use `updateMany` or a short array transaction. Nested `playerService.loseXP` inside `$transaction` expires the default 5s timeout and 500s the whole heist (`Transaction already closed`).
- Failed heists must still jail every crew member and apply the XP loss (clamped at 0). Do not drop those penalties to make the write faster.
- Failed heists must also set `player.jailRelease` so `/player/jail-status`, the dashboard HUD and other screens see the sentence immediately. The Crew UI must show the result popup plus `JailOverlay`, not only a snackbar.

## Notification Guardrails
- Crew-gerelateerde arrestatie-alerts moeten alle overige crewleden bereiken wanneer een lid vast komt te zitten.
- Pushdispatch voor deze alerts blijft fire-and-forget en mag heists, crimes of andere arrestflows niet blokkeren.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify the Overview HQ block shows the villa/camping/etc still on a narrow phone width, with `1 lid` (not `1 leden`) for a solo crew.
- Verify a freshly created crew immediately has HQ level 1 plus all storage buildings on level 1, including cash storage, and can deposit into the crew bank without a separate unlock step.
- Verify Overview crew-bank buttons say **Storten** / **Opnemen** in Dutch (and equivalent bank verbs in other UI languages), not Borg or Terugtrekken.
- Verify Crew Overview and Premium show the Crew VIP pot with donate chips for every member, and that one member can still start the monthly subscription. In-game cash must not buy Crew VIP.
- Verify cash-storage level 1 can hold more than the level-2 upgrade price, so the crew can pay that upgrade from the crew bank.
- Verify the Crew HQ level overview shows a continuous member-cap curve across all HQ styles and reaches 150 members at the top end instead of restarting from the base caps.
- Verify car storage accepts both cars and motorcycles, while boat storage still only accepts boats.
- Verify targeted Crew War actions show a selectable enemy player list and still submit the correct target player to the backend.
- Verify purchase and upgrade buttons/dialogs show the correct euro amounts for HQ and every storage building.
- Verify HQ/storage images still load on web when assets are served through external mounts or nginx alias fallbacks.
- Verify an open auto-accept crew joins in one click and an open request-only crew shows pending + cancel.
- Verify a fresh world without open auto-accept crews creates **The Rookies**, and that the empty Overview tab shows Browse first.
- Verify the Crews list has no extra Open-crews FAB; open rows use a green instant-join badge + Join now, request-only rows use an orange application badge + Apply.
- Verify leaders can close recruiting and that closed crews disappear from the recruiting list.
- Verify the weekly crew goal is visible on the crew overview and dashboard, and that an unclaimed goal is gone after the UTC week rolls.
- Verify Storage shows crew deals, officers can lock an offer, and cancel returns the goods.
- Verify a war raid asks which storage type to hit and refuses when attacker storage is full. Tool storage can be raided the same way as other instance stacks.
- Verify Help / the gold `i` on Crew explains that stored cars, boats, weapons, tools and trade goods are crew cargo (not a personal garage) and that only leader/co-leader can buy a crewmate out with the crew bank.
- Verify a failed heist still jails the whole crew and applies XP loss without a 500, including crews larger than a handful of members.
- Verify a failed heist on Crew shows the result popup (jail time + XP loss) and then the jail overlay, not only a toast.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
