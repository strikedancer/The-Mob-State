# Balance & Monetization Phase Roadmap

Doel: progression pacing verbeteren zonder hard daily caps, met duidelijke credit-value en zonder pay-to-win escalatie.

## Fase 1 - Cooldown ratio + credits basis (nu)
- Crimes: cooldown schaalt op reward-tier i.p.v. vaste 90s.
- Jobs: cooldown schaalt op max payout i.p.v. vaste globale timer.
- Vehicle theft: aparte motorcycle cooldown opgenomen in centrale cooldown-config.
- Premium credits: meerdere creditbundels beschikbaar maken (250/500/1000/2500) met game-themed visuals.
- Guardrail: geen harde dagcap op actie-loops; pacing via risico, payout en cooldown.

## Fase 2 - Economy telemetrie + soft balancing
- Add ratio dashboards: payout-per-minute, fail-rate, jail-rate, cooldown-skip gebruik.
- Add soft anti-abuse regels (diminishing returns per sessieblok) in plaats van hard action caps.
- Tune reward/cooldown curves op basis van live data.

Status (afgerond):
- Backend soft diminishing actief voor crimes, jobs en vehicle theft progression-reward.
- Runtime tuning keys toegevoegd via `runtime_config`:
  - `ECON_SESSION_WINDOW_MINUTES`
  - `ECON_DIMINISH_1..4_MIN_ATTEMPTS`
  - `ECON_DIMINISH_1..4_MULTIPLIER`
- Admin telemetry endpoint actief: `/api/admin/economy/balance-telemetry?hours=24`.
- Admin dashboard toont economy ratios + tuning controls (live save/apply zonder backend deploy).

## Fase 3 - Credit sink design + fairness
- Definieer credit sinks per loop (crime/job/vehicle/event) met duidelijke waarde per credit.
- Voeg veilige skip-cost curve toe (duurder naarmate action-value hoger is).
- Introduceer time-save bundels zonder mandatory paywall voor core progression.

Status (afgerond):
- Credit shop heeft nu loop-specifieke sinks voor `crime`, `job`, `vehicle_theft`, `motorcycle_theft` en `boat_theft`.
- `ACTION_COOLDOWN_RESET` gebruikt een dynamische skip-cost curve per actie op basis van resterende cooldown + action value weight.
- Cooldown-reset redemptions blokkeren wanneer er geen actieve cooldown is (`ACTION_COOLDOWN_NOT_ACTIVE`), zodat credits niet verspild worden.
- Premium overzicht levert dynamische itemvelden (`effectiveCreditCost`, `canRedeemNow`, `unavailableReason`, `cooldownState`) voor eerlijke UI-feedback.

## Fase 4 - In-app gear (non pay-to-win)
- Introduceer shop-gear tiers (weapon/armor) die boven baseline liggen, maar onder event-only reward tier blijven.
- Hard rule: event rewards blijven top-end progression.
- Gebruik side-grade/utility bonussen boven pure power-stacking.
- QA op PvP, crimes en hitlist balans voor regressies.

Status (afgerond):
- Nieuwe tijdelijke side-grade boosts toegevoegd als credit-items (`EVENT_BOOST`) i.p.v. permanente power creep.
- Event boost stacking is capped op "strongest active per stat" met harde maxima:
  - `crimeSuccessPct` max 5%
  - `crimeRewardPct` max 8%
  - `hitAttackPct` max 4%
  - `hitDefensePct` max 4%
  - `eventContributionPct` max 15%
- Boosts geïntegreerd in crimes (success/reward), hitlist combat (attack/defense) en live event contribution scoring.
- Designregel behouden: utility en tempo-voordeel, geen top-end event reward vervanging.
