# Crimes Protocol

## Scope
Illegal action loop with rewards, failures, jail risk, cooldowns and supporting tools.

## Primary Frontend Entry
- client/lib/screens/crime_screen.dart

## Related APIs
- **`GET /crimes`** must stay a single batched player-context load (readiness + mastery counts + training + country-police). Never re-query `crime_attempts` or player tools **per crime** on the list — that timed out the mobile crimes screen (`errorLoadingCrimes` / connection retry). Success-chance math stays identical; only the load path is batched (`computePlayerSuccessChanceFromContext`).
- Crime success math uses gym strength and shooting-range accuracy bonuses from the server. The crime UI may call **`GET /training/status`** to show the same active bonus percentages the player has while committing crimes (transparent summary, not a second rules engine).
- **Combo-readiness:** same UTC calendar day with at least one gym session and one shooting-range session adds a small extra success chance (`trainingComboReadiness` in `/training/status`; constant in `backend/src/lib/trainingComboReadiness.ts`).
- **Country police pressure (flagged):** soft success/arrest modifiers from shared per-country pressure — see `country-police.md`. Flag `COUNTRY_POLICE_PRESSURE_ENABLED` default off.

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Web dashboard Crimes keeps the **shared dashboard status bar** above the content card, same as other sections. Inside the card, use **one** header panel: page title/counts + country-police strip (when the flag is on) + training bonus + worn-weapon slots. Do not restore a separate AppBar, hero, police, prep or weapon cards stacked as chrome blocks. The filter/sort row may stay as a slim toolbar above the grid.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.
- Each crime attempt still costs HP (base 5–15). A worn vest and hired bodyguards reduce that hit via `applyCrimeHealthMitigation` (cap 55%). They do not change success chance, wanted or jail.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Het crime-success overlay (`CrimeResultOverlay`) volgt de dashboard-identiteit (noir/gold, donker paneel, goud accent, expliciet wit/goud contrast). Geen lichte crème-kaarten of theme-inherited tekstkleur die op donkere UI onleesbaar wordt.
- No auto-playing video overlays in the crimes loop.
- Arrest feedback should be immediate message-first, optionally with a static image/icon indicator.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.
- Crime pacing is reward-tier based, not flat-rate; low-reward crimes stay fast while high-reward crimes must pick up meaningfully longer cooldowns.
- Soft balancing via sessie-gebaseerde diminishing returns is toegestaan zolang het geen harde daily/action cap wordt en transparant in telemetry zichtbaar blijft.
- Reward-tier cooldown changes must stay aligned between backend enforcement, player help copy and any cooldown-reset premium items that reference the crime loop.
- Tijdelijke premium boosts op crimes zijn toegestaan als side-grade, maar moeten hard capped blijven en mogen event-tier progression niet vervangen.
- Drug requirement thresholds must stay aligned with gram-based drug inventory quantities; do not surface legacy `x` units in requirement feedback.
- Requirement failures for vehicle, weapon selection, weapon suitability and ammo must surface the concrete reason instead of collapsing into a generic internal error.
- If a crime requires a weapon, the attempt looks at both worn weapon slots (crime slot and second slot) and automatically uses the best eligible weapon for that crime (type, min damage/intimidation, ammo, then highest combat stats/condition). A backpack-only gun does not count.
- The Crimes screen must show both worn slots and, per crime card, which weapon will be used. Changing worn weapons happens in Inventory.
- When a player is arrested after a weapon-based crime, the used crime weapon must be confiscated consistently with the arrest consequences shown to the player; if that was the last copy, the saved slot selection for that weapon must no longer remain active.
- A crime that ends in arrest may not still surface as a clean success result in the UI; if police/FBI catch the player after the attempt, the final response must resolve as an arrest outcome with consistent vehicle/weapon confiscation messaging.
- Crime-specific special effects must be explicit in player feedback; if a crime wipes or alters judicial history, the success message must state that effect clearly.
- Admin NPCs must call `crimeService.attemptCrime` (plus the same jail/ICU/cooldown/tool/weapon/vehicle guards) instead of writing crime payouts directly to the player row.
- Wanneer een crime eindigt in arrestatie moet de social notification pipeline voor vrienden/crew worden getriggerd zonder de crime-respons te blokkeren.
- Munitie mag pas worden verbruikt nadat alle harde startvoorwaarden van de crime geldig zijn; een preflight requirement failure mag geen kogels kosten.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in both Dutch and English.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update the player help entry for this module.
- Help topic **crimes** (`helpTopicCrimesHow` in `app_*.arb`): keep the training-bonus transparency line translated in **every** active player locale (not only EN/NL), aligned with hub terminology (`trainingHub*` strings).

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- On web dashboard Crimes, verify the shared status bar stays above the content card like other pages, and that page title, country-police, training bonus and worn weapons share one header inside the card.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify crime cooldown duration matches the configured reward tier after a successful attempt.
- Verify no text overflows or clipped buttons appear.
- Verify the success result overlay is readable on mobile and desktop (gold title, white crime name, cash/XP values, gold Continue) and matches the dashboard noir/gold shell.
- Verify weapon-required crimes pick the better of the two worn slots (for example a handgun crime uses the handgun, a rifle crime uses the rifle), block cleanly when neither slot is suitable, and stay synced with Inventory after refresh/navigation.
- Verify vehicle-required crimes only accept the selected crime vehicle when that vehicle is actually available in the player's current country and not in transit or market-listed.
- Verify an arrest during a weapon-based crime confiscates the used weapon, clears the saved selection when no copy remains, and tells the player about the confiscation in the crime result feedback.
- Opening Crimes on a slow/mobile connection must not sit on a full-page load error after one timeout; the client retries once and keeps a Retry button.
- After pull-to-refresh, the training bonus strip (if shown) matches hub training progress for strength and accuracy.
- When both gym and range were trained the same UTC day, the combo line appears and matches `trainingComboReadiness` from `/training/status`; crime success % from the server includes the small combo bonus.
- Verify a crime that initially succeeds but ends in a police/FBI arrest no longer shows a success state, actually puts the player in jail, and applies the matching confiscation consequences.
- Verify a failed start caused by missing vehicle, unsuitable weapon or missing ammo does not consume ammunition.
- If a crime has a court-side effect, verify the linked court record updates after cooldown refresh and only the intended convictions are affected.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
