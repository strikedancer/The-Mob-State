# Balance & Economy Protocol

## Scope
Cross-cutting balansregels voor progression, economy pacing, cooldowns, premium sinks en non-pay-to-win monetization.

Dit protocol is verplicht voor alle wijzigingen die invloed hebben op:
- payout, rewards, multipliers, drop rates, loot shares
- cooldowns en reset/skip-mechanieken
- progression snelheid (XP, rank-up tempo, unlock tempo)
- premium credits, redemptions, event boosts en in-app power-effecten
- anti-abuse/diminishing gedrag en economy telemetry

## Primary Systems
- `backend/src/services/economyBalanceService.ts`
- `backend/src/services/cooldownService.ts`
- `backend/src/services/premiumCreditsService.ts`
- `backend/src/services/crimeService.ts`
- `backend/src/services/hitlistService.ts`
- `backend/src/services/gameEventService.ts`
- `backend/src/routes/admin.ts` (economy telemetry + runtime tuning)
- `admin/src/App.tsx` (economy tuning UI)

## Hard Rules
- Geen hard daily caps op kernactie-loops.
- Balans via risico, payout, cooldown en soft diminishing.
- Geen pay-to-win escalatie:
  - premium-effecten zijn side-grade/utility
  - event rewards blijven top-end progression
  - tijdelijke boosts blijven capped
- Cooldown reset-items mogen geen credits verbranden zonder actieve cooldown.
- Alle economy-aanpassingen moeten traceerbaar zijn via telemetry en runtime settings.
- Voor Territory geldt: gebruik `TERRITORY_ACTION_DAILY_CAP=0` als default om de cap uit te zetten; begrenzing loopt daar via cooldown + anti-farm.

## Runtime Keys (Leidend)
- `ECON_SESSION_WINDOW_MINUTES`
- `ECON_DIMINISH_1_MIN_ATTEMPTS` / `ECON_DIMINISH_1_MULTIPLIER`
- `ECON_DIMINISH_2_MIN_ATTEMPTS` / `ECON_DIMINISH_2_MULTIPLIER`
- `ECON_DIMINISH_3_MIN_ATTEMPTS` / `ECON_DIMINISH_3_MULTIPLIER`
- `ECON_DIMINISH_4_MIN_ATTEMPTS` / `ECON_DIMINISH_4_MULTIPLIER`
- `CREW_MISSION_CREW_LEVEL_BASE_XP`
- `CREW_MISSION_CREW_LEVEL_STEP_XP`
- `CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT`
- `CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT`
- `TERRITORY_HQ_REGION_CAP_PER_LEVEL`
- `TERRITORY_HQ_REGION_CAP_BONUS_CAP`
- `TERRITORY_HQ_CONTEST_CAP_PER_LEVEL`
- `TERRITORY_HQ_CONTEST_CAP_BONUS_CAP`
- `TERRITORY_HQ_ACTION_POINT_BONUS_PER_LEVEL`
- `TERRITORY_HQ_ACTION_POINT_BONUS_CAP`
- `TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_PER_LEVEL`
- `TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_CAP`
- `TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL`
- `TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL`
- `TERRITORY_CAR_STORAGE_RAID_BONUS_PER_LEVEL`
- `TERRITORY_BOAT_STORAGE_SUPPLY_BONUS_PER_LEVEL`
- `TERRITORY_DRUG_STORAGE_SABOTAGE_BONUS_PER_LEVEL`
- `TERRITORY_BUILDING_ACTION_BONUS_CAP`

## Balance Change Workflow (Verplicht)
1. Haal live telemetry op (minimaal 24 uur).
2. Vergelijk loops:
   - crimes
   - jobs
   - vehicle theft
3. Beoordeel:
   - payout per minute
   - success/fail/jail ratio
   - cooldown skip usage
4. Pas alleen gecontroleerd aan:
   - kleine stapgrootte per wijziging
   - geen meerdere grote curve-shifts tegelijk
5. Verifieer na wijziging:
   - runtime keys opgeslagen
   - backend draait zonder errors
   - telemetry endpoint blijft data leveren

## Recommended Guardrails
- Wijzig multipliers stapsgewijs (typisch max 0.02 per stap).
- Verplaats thresholds stapsgewijs (typisch max 4-8 attempts per stap).
- Houd curves monotonic:
  - hogere attempts mogen geen hogere multiplier krijgen.
- Houd economy tuning server-side (runtime_config), niet hardcoded in client.

## QA Checklist
1. `GET /api/admin/economy/balance-telemetry?hours=24` geeft geldige data.
2. Runtime tuning save/apply werkt in admin zonder deploy.
3. Diminishing context wordt toegepast in crimes/jobs/vehicle theft.
4. Premium cooldown-reset en boost effecten blijven binnen balansregels.
5. Geen regressie op core gameplay loops (crime/job/vehicle/hitlist).
6. `Help & Uitleg` en roadmap zijn bijgewerkt als gedrag wijzigt.

## i18n / Help
- Als player-perceptie verandert (tempo, reward-gevoel, premium-waarde), update `docs/game-systems/GAMEPLAY.md`.
- Geen economyfeature is done zonder NL/EN consistente player copy waar van toepassing.

## When To Update This File
Bij elke nieuwe economy-loop, monetization-mechaniek, cooldown-reset type, boost type, of tuningmethodiek.
