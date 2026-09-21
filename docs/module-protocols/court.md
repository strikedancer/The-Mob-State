# Court Protocol

## Scope
Judicial recovery, sentence handling and legal consequence flows.

## Primary Frontend Entry
- client/lib/screens/court_screen.dart

## Active Backend Endpoints
- GET `/trial/current-sentence`
- GET `/trial/record`
- GET `/trial/expunge-quote`
- POST `/trial/appeal`
- POST `/trial/bribe`
- POST `/trial/expunge-petition`
- Admin `GET/PUT /admin/trial/runtime-config` — live Rechtbank knobs (expunge petition + appeal odds/cost + shared `DON_JUDGE_APPEAL_BONUS_PERCENT`)
- Admin `POST /admin/trial/court-record-amnesty` `{ confirm: "WIPE_ALL_RECORDS" }` (SUPER_ADMIN only)
- Admin UI: **Rechtbank** tab (`admin/src/components/CourtAdminPanel.tsx`) — runtime console + amnesty confirm phrase, wipe + world-chat promo image

## Current System Contract
- Court screen must load sentence and criminal record independently and remain usable when one part is empty.
- Active sentence state must show: crime, total sentence, remaining time, judge profile and action buttons.
- Appeal can be submitted once per crime attempt and follows appeal cooldown rules.
- Bribe always deducts offered money and can either release player immediately or fail without release.
- A successful judge bribe must clear the physical jail lock the same way as bail/escape: all active `jailed = true` rows for that player plus `jailRelease = null`. `checkIfJailed` must not reconstruct a sentence from an older leftover row when the newest `jailTime > 0` attempt is already `jailed = false`.
- Criminal record must remain visible both while jailed and while free.
- Criminal record must be based on the player's conviction history, not only rows that are currently `jailed = true`.
- Record entries must preserve sentence changes and trial outcomes such as appeal granted, appeal denied and failed bribe attempts.
- A successful judge bribe must clear only the linked active conviction from the criminal record, not wipe unrelated convictions.
- If the player uses an external crime flow to wipe their full record, the court record must hide only convictions older than that expungement point and show new convictions normally afterward.
- An official **amnesty** writes the same `trial.record_expunged` marker per player (`source: amnesty`) without SSE spam. After that wipe, new convictions show again. Super-admin trigger: Admin → **Rechtbank** (confirm `WIPE_ALL_RECORDS`), or `POST /admin/trial/court-record-amnesty` with `{ confirm: "WIPE_ALL_RECORDS" }`, or `node dist/scripts/runCourtRecordAmnesty.js`. That also posts the world-chat promo still.
- Players can also file a paid **expunge petition** on Court (`GET /trial/expunge-quote`, `POST /trial/expunge-petition`) while free or jailed, as long as a visible record remains. Live cost/odds/cooldown/fresh-arrest window come from `courtRuntimeConfig` (`COURT_EXPUNGE_*`; code defaults match the previous hardcodes: cost `100_000 + max(0, n-1)*1_000`, clamp 8–70%, fresh-arrest −15% for the first hour, 12h cooldown). Success chance still uses `computeExpungePetitionOdds` (record length, hours since last arrest, reputation, Don judge/commissioner/alderman). Failure deducts cash only. Success writes `trial.record_expunged` and does **not** release the player. The late-game `criminal_record_wipe` crime stays.
- **Law education bonus**: the player's `law` track level (0–5) grants `COURT_APPEAL_LAW_BONUS_PER_LEVEL_PERCENT` per level (default +5%, cap `COURT_APPEAL_LAW_BONUS_CAP_PERCENT` default +25%). Base appeal chance is `COURT_APPEAL_BASE_PERCENT` (default 35%) before prior-convictions/wanted/FBI adjustments. Hard clamp is `COURT_APPEAL_MIN_PERCENT`–`COURT_APPEAL_MAX_PERCENT` (default 10–85%). Appeal cash cost is `jailMinutes * COURT_APPEAL_COST_PER_MINUTE` clamped to min/max.
  - Optional Don judge patronage in the current country adds up to `DON_JUDGE_APPEAL_BONUS_PERCENT` (default +8%) before the same clamp. It does **not** replace per-case `POST /trial/bribe`. See [don.md](don.md).
  - Cross-dependency: `educationService.getPlayerEducationProfile` is called in parallel inside `judgeService.appealSentence` and `getCurrentSentence`.
  - `GET /trial/current-sentence` returns `appealOdds` (law level/bonus, prior-conviction modifier, wanted, FBI heat, estimated percent). The court screen shows this breakdown; odds are computed in `computeAppealOdds` so UI and roll stay aligned.
  - Wanted above `COURT_APPEAL_WANTED_THRESHOLD` (default 20) subtracts `COURT_APPEAL_WANTED_PENALTY_PERCENT`. FBI heat above `COURT_APPEAL_FBI_THRESHOLD` (default 10) subtracts `COURT_APPEAL_FBI_PENALTY_PERCENT`. These modifiers do **not** change bribe chance (judge corruptibility + offer only). The bribe dialog still shows current Wanted/FBI so the player sees why appeal looks worse.
- **Localized names**: judge payload uses family name + `specialtyKey` (`violence` | `financial` | `drugs` | `white_collar` | `organized`). Client localizes the judge title and specialty. Crime titles use `crimeId` via `CrimeLocalization.nameFromId` (English `crime` / `crimeName` is fallback only).

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Prefer runtime_config (`COURT_*` / shared Don key) over code deploys for balance knobs; keep code defaults identical to the previous hardcodes so unset keys do not change live odds.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Web dashboard Court hides the inner AppBar title; keep the shared status bar. On large screens the panels fill the dashboard content column (no 860px cap). The screen uses a noir hero (case status + conviction count + remaining time) plus sentence and record panels. Remaining time ticks locally every 30s and refreshes when the sentence ends.
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
- Background styling must not reduce readability of critical sentence, action and balance information.
- If orientation-specific backgrounds are used, include a safe fallback image path to avoid blank renders.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- On web dashboard Court, verify there is no extra “Rechtbank” AppBar title, the hero chips match sentence/record state, and appeal/bribe dialogs stay readable on the dark panel.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.
- Verify `/trial/current-sentence` and `/trial/record` both return stable payloads and client handles `sentence: null`.
- Verify `POST /trial/appeal` returns cooldown block on rapid retry and updates remaining sentence on success.
- Verify `POST /trial/bribe` deducts balance in both success and failure paths.
- Verify Court shows the wipe-record panel while free, with live cost/odds, disabled state for empty record / low cash / 12h cooldown, and that a failed petition leaves the record unchanged.
- Verify a successful bribe leaves `GET /trial/current-sentence` at `sentence: null` and `GET /player/jail-status` at 0 remaining seconds, even when the crime also wrote a duplicate `police_arrest` / `federal_arrest` row.
- Verify portrait/landscape switch keeps the courtroom background visible and text/cards readable.
- **Law bonus QA**: player with law level 5 must have measurably higher appeal success rate than player with level 0; confirm `educationService` call does not break appeal for players with no education records (defaults to 0).
- Switch UI language and confirm crime names, judge title/specialty and odds copy follow the locale. Confirm Wanted >20 and FBI heat >10 turn the appeal lines red and lower `successPercent`. Confirm an already-appealed case disables the appeal button.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
