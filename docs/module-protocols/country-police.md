# Country Police Presence Protocol

## Scope
Shared **per-country police pressure** (world state) that soft-modifies crime success and arrest chance. Distinct from personal `wantedLevel` / `fbiHeat`.

## Status
**Design only — not implemented / not live.**  
Master design: `docs/game-systems/COUNTRY_POLICE_PRESENCE_DESIGN_2026-08-29.md`  
Feature flag (when built): `COUNTRY_POLICE_PRESSURE_ENABLED` default **off** (`0`).

## Primary Frontend Entry (planned)
- Crimes strip: `client/lib/screens/crime_screen.dart`
- Travel badges: travel UI
- Dashboard chip: dashboard risk / country row
- Help topic under crimes / travel / police

## Related systems
- `crimes.md` — success chance after personal bonuses
- `policeService` / jail — arrest chance after wanted formula
- `travel.md` — destination pressure display
- `dashboard.md` — chip + help coverage
- `balance-economy.md` — runtime keys + soft caps (mandatory when implementing)
- Later: `territory.md`, `crew.md` (dampen / disruption ops)

## Change Rules
- Do not enable the flag in production without a balance pass and telemetry review.
- Preserve personal wanted/FBI as the primary arrest story; country pressure is a nudge.
- No pay-to-clear world pressure.
- Phase 3 “attack/disrupt police” ops must not become a cash/XP farm (long cooldown, fail hurts, diminishing returns).
- Keep Dutch and English copy in sync for any player-visible strings (`countryPolice*` prefix).

## Check Before Editing
- Is the feature flag still the source of truth for on/off?
- Do success/arrest modifiers use **server-derived** pp values (no client-only guesses)?
- Does dashboard + Help & Uitleg coverage ship in the same change?
- Are hourly contribution caps and success floors intact?

## Must Preserve
- With flag off: crime/arrest math identical to pre-feature.
- Absolute crime success floor must still apply.
- Travel never blocked solely by pressure.
- Arrest still scales primarily with personal wanted + `policeRatio`.

## QA Checklist (when implementing)
- [ ] Flag off: parity with current crimes/arrests
- [ ] Flag on: pressure gain + tick decay
- [ ] UI bands match server pressure
- [ ] Player hourly gain cap enforced
- [ ] NL + EN strings + help topic
- [ ] Telemetry for pressure / success / arrest by country bucket
- [ ] `balance-economy.md` updated with keys and numeric defaults

## Out of scope until Phase 3 design sign-off
- Player/crew “raid police HQ” as a repeatable loop
- Premium item that zeros country pressure
