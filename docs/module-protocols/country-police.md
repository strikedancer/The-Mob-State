# Country Police Presence Protocol

## Scope
Shared **per-country police pressure** (world state) that soft-modifies crime success and arrest chance. Distinct from personal `wantedLevel` / `fbiHeat`. Phase 2: flavor floors, territory dampening, crime-event crackdown mult. Phase 3: rare disrupt ops (`corruption` / `distract` / `raid`).

## Status
**Implemented** behind runtime flag `COUNTRY_POLICE_PRESSURE_ENABLED` (default **`0` / off**).  
Design: `docs/game-systems/COUNTRY_POLICE_PRESENCE_DESIGN_2026-08-29.md`  
Service: `backend/src/services/countryPoliceService.ts`  
Routes: `GET /police/status`, `GET /police/countries`, `POST /police/disrupt`  
Client: crimes strip + travel badges + disrupt sheet (`country_police_ui.dart`)

## Enable (production)
Admin → runtime config: set `COUNTRY_POLICE_PRESSURE_ENABLED` to `1`. Do not flip the code default without a balance pass.

## Primary Frontend Entry
- Crimes strip + disrupt: `client/lib/screens/crime_screen.dart` + `client/lib/widgets/country_police_ui.dart`
- Travel badges: `client/lib/screens/travel_screen.dart`
- Dashboard: `stats.risk.countryPolice` on `GET /player/dashboard-stats` (optional UI)

## Related systems
- `crimes.md` — success chance (UI + outcome engine) after personal bonuses
- `policeService` / jail — arrest chance after wanted formula
- `travel.md` — destination pressure display
- `dashboard.md` — risk payload
- `balance-economy.md` — runtime keys
- `territory.md` / `crew.md` — dampening / disrupt crew gate
- `steel_voertuig.md` / `drugs.md` — optional pressure gain sources

## Change Rules
- Flag off → crime/arrest math identical to pre-feature.
- Preserve personal wanted/FBI as the primary arrest story; country pressure is a nudge.
- No pay-to-clear world pressure.
- Phase 3 disrupt must not become a cash/XP farm (cooldown, fail hurts, coolUntil diminishing returns).
- Keep Dutch and English copy in sync (`countryPolice*` prefix).

## Check Before Editing
- Is the feature flag still the source of truth for on/off?
- Do success/arrest modifiers use **server-derived** pp values?
- Does dashboard + Help & Uitleg coverage ship with behavior changes?
- Are hourly contribution caps and success floors intact?

## Must Preserve
- With flag off: crime/arrest math identical to pre-feature.
- Absolute crime success floor (~5%) must still apply.
- Travel never blocked solely by pressure.
- Arrest still scales primarily with personal wanted + `policeRatio`.

## QA Checklist
- [ ] Flag off: parity with current crimes/arrests
- [ ] Flag on: pressure gain (crime/theft/collect) + tick decay
- [ ] Territory ownership dampens gain / adds decay
- [ ] Active live `crime` event applies crackdown mult
- [ ] UI bands match server pressure; disrupt sheet works
- [ ] Player hourly gain cap enforced
- [ ] NL + EN strings
- [ ] Telemetry logs (`[CountryPolice]`) visible

## Runtime keys
See `COUNTRY_POLICE_*` in `countryPoliceService` / Admin config / `balance-economy.md`.
