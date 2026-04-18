# School Protocol

## Scope
Education tracks, certifications, gates, cooldowns and unlock dependencies.

## Primary Frontend Entry
- client/lib/screens/school_screen.dart

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

## Cross-Module Effects
- **Law track → Court appeals**: each law level adds +5% appeal success chance in `judgeService.appealSentence` (max +25% at level 5). Players who invest in the law track get a tangible advantage when contesting a jail sentence.
  - Dependency file: `backend/src/services/judgeService.ts`
  - If the law track or its level field is ever renamed/restructured, update `judgeService.ts` accordingly.
- **Aviation track → Aircraft purchase (Aviation module)**: het aankopen van privévliegtuigen is vergrendeld achter aviation track levels (Cessna = level 2 + `flight_basic`, King Air = level 3, Gulfstream = level 4 + `flight_commercial`, Boeing 737 = level 5). Gates worden afgedwongen via `educationService.checkGate` in de aviation-route.
  - Bij het herstructureren van de aviation track of certifications: update `educationService.ts → EDUCATION_GATES` en `aviation.md`.
- **Aviation track → Airline pilot job**: de bestaande gate `gate_job_airline_pilot` vereist aviation level 4 + `flight_commercial`. Dit geldt naast de aircraft-aankoopgates.
- **Narcotics track → Drugs facility upgrades**: drugsfaciliteit-upgrades zijn nu stapsgewijs gekoppeld aan de school track `narcotics`. Slot-upgrades en equipment-upgrades vereisen oplopende levels/certificaten (`hydroponic_specialist`, `process_electrics_specialist`, `clandestine_chemist`, `narco_grid_architect`) via asset-gates `drug_facility_upgrade_slots_tier_*` en `drug_facility_upgrade_equipment_tier_*`.
  - Dependency files: `backend/src/services/educationService.ts`, `backend/src/services/drugFacilityService.ts`, `backend/src/routes/drugFacilities.ts`
  - Als track-id, certificaat-id of gate-targets wijzigen: update ook `school_screen.dart`, `education_requirements_dialog.dart` en de drugs-helptekst.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
