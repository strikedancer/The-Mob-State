# Balance & Economy Protocol

## Scope
Cross-cutting balansregels voor progression, economy pacing, cooldowns, premium sinks en non-pay-to-win monetization.

Dit protocol is verplicht voor alle wijzigingen die invloed hebben op:
- payout, rewards, multipliers, drop rates, loot shares
- cooldowns en reset/skip-mechanieken
- progression snelheid (XP, rank-up tempo, unlock tempo)
- premium credits, redemptions, event boosts en in-app power-effecten
- anti-abuse/diminishing gedrag en economy telemetry

## Documented static modifiers (vehicle theft → boats)
- **Boat theft ease:** in `vehicleService.stealVehicle`, after heat / dynamic police pattern / ops-rep, **+0.06** success chance for `vehicleType === 'boat'` (max 0.95). **Port lockdown** window uses boat risk multiplier **1.10** (not 1.18). Rationale: boat `baseValue` bands in content skew harder than starter cars; see `steel_voertuig.md`.

## Documented static modifiers (training → crimes)
- **Combo-readiness:** when the player has **at least one gym train (any track; `gymLastTrainedAt` = latest of strength/speed/stamina `lastTrainedAt`) and one shooting-range train** on the **same UTC calendar day**, `crimeService` adds **`TRAINING_COMBO_READINESS_BONUS`** (**+0.5%** success chance as a fraction, see `backend/src/lib/trainingComboReadiness.ts`) on top of existing gym aggregate + shooting-range training bonuses. Still clamped with all other modifiers to **5–95%** final success chance. Exposed for UI as `trainingComboReadiness` on **`GET /training/status`**.

## Documented static modifiers (ammo factory)
- **Claim interval:** `PRODUCTION_INTERVAL_MINUTES = 20` in `ammoFactoryService.ts` (was 10 after Apr 2026; originally 5).
- **Base output:** `BASE_ROUNDS_PER_TICK = 3` rounds per ammo type at level 1 (was 5). Level curve unchanged (`1 + (level-1)*2.46`). Session backlog still 8 hours. UI copy + `ammo_factory_screen.dart` estimate constants must match. See `ammo-factory.md`.
- **Pacing rule:** wijzig claim-interval of base output **alleen** na economy telemetry (`GET /api/admin/economy/balance-telemetry`); geen curve-tweaks “op gevoel”.

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
- Player VIP timeout-voordelen moeten side-grade blijven: vaste reductie op actie-timeouts (geen jail-time reductie) en geen bypass van risk loops.
- Periodieke VIP-credit grants (bijv. wekelijks) moeten beperkt, voorspelbaar en ledger-traceerbaar blijven zodat monetization geen pay-to-win escalatie veroorzaakt.
- Alle economy-aanpassingen moeten traceerbaar zijn via telemetry en runtime settings.
- Voor Territory geldt: gebruik `TERRITORY_ACTION_DAILY_CAP=0` als default om de cap uit te zetten; begrenzing loopt daar via cooldown + anti-farm.
- Territory Fase C: actief `safehouse_network`-project verhoogt passief regio-inkomen met `TERRITORY_PROJECT_SAFEHOUSE_INCOME_BONUS_PERCENT` (default 10%; damaged = helft). Sabotage/supply contest-acties wijzigen project-HP/voortgang via runtime keys `TERRITORY_PROJECT_*`.
- Territory garnizoen: crew-bank sink (`TERRITORY_GARRISON_CASH_COST`, default €350.000) voor een tijdelijk defense-effect (default 8u, +4 defense-punten, +12 capture-drempel tot cap 85). Max. 2 actief per crew, min. HQ 2. Geen immuniteit en geen credit-paywall; het gebied blijft aanvalbaar.
- Territory omsluiting: geen extra cash-sink; wel een structurele hold-bonus. Een binnengebied (alle buren eigen, min. 3) is niet startbaar als contest. Dat maakt aaneengesloten blokken waardevoller dan losse eilanden, zonder pay-to-win.
- Territory Fase D: seizoen-awards gebruiken `TERRITORY_REWARD_CASH_MULTIPLIER_PERCENT` op crew-bank (storage-cap); region events kunnen passief inkomen verlagen via `TERRITORY_REGION_EVENT_INCOME_PENALTY_PERCENT`.
- VIP prestige (P6) is **display-only** (lifetime days / bronze-silver-gold). No combat, payout or cooldown power from prestige tiers.
- Deep economy P5:
  - **Laundering:** cash sink (fee) + delayed bank credit + heat seize risk; success lightly reduces FBI heat. Direct bank deposit blijft gratis/instant tot een dagelijkse cap (`BANK_FREE_DEPOSIT_DAILY_*`); daarboven moet cash via laundering.
  - **Stock market:** bank-funded buy/sell, slow synthetic ticks, position cap; los van crypto.
  - **Property development:** bank sink voor permanente income-boost per eigendom (`PROPERTY_DEVELOP_*`).
- Voor travel geldt 60 minuten cooldown per etappe als baseline en Premium `ACTION_COOLDOWN_RESET` voor `actionType=travel` moet beschikbaar zijn wanneer de cooldown actief is.
- **Player portraits (selfie → gangster):** elke succesvol gegenereerd custom portret kost **100 premium credits** (`PORTRAIT_SELFIE_CREDIT_COST`); mislukte generatie kost niets. Wisselen tussen bestaande portretten of presets kost geen credits. Zie [player-portraits.md](player-portraits.md).
- **Drug production speedup:** premium credits kunnen een lopende batch vroegtijdig klaarzetten (`finishesAt = now`). Prijs = `ceil(remainingMinutes * 2)`, clamp **8–150** credits. Geen bypass van materialen/slots/heat/collect. Ledger `reasonKey=drug_production_speedup`. Zie [drugs.md](drugs.md).
- Garage **auto**- en **motor**-opslag: aparte upgrade-progressie per speler per land (eigen levels, eigen euro-kostencurve voor auto-track; motor-track gebruikt dezelfde prijsstappen als auto met +3 slots per motor-level t.o.v. basis motorplaatsen). Wijzigingen hieraan zijn economy-impact: check telemetry op storage-full en steal-fail door capaciteit.

## Runtime Keys (Leidend)

Economy / progression keys blijven leidend in Admin `runtime_config`. Extra module:

### Country police pressure (`COUNTRY_POLICE_*`)
- `COUNTRY_POLICE_PRESSURE_ENABLED` (0/1, default 0)
- Baseline / decay / crime+theft+drug gains / success & arrest max pp / hourly player cap
- Territory gain mult + extra decay; crackdown mult when a live `crime` event is active
- Disrupt: enable, min rank, require crew, cooldown seconds, cool minutes, success chance
- Service defaults: `backend/src/services/countryPoliceService.ts`

See also `country-police.md`.
- `BANK_FREE_DEPOSIT_DAILY_ENABLED` / `BANK_FREE_DEPOSIT_DAILY_BASE` / `BANK_FREE_DEPOSIT_DAILY_PER_RANK`
- `LAUNDER_ENABLED` / `LAUNDER_FEE_PERCENT` / `LAUNDER_MIN_AMOUNT` / `LAUNDER_MAX_AMOUNT` / `LAUNDER_DURATION_MINUTES` / `LAUNDER_COOLDOWN_SECONDS` / `LAUNDER_SEIZE_CHANCE_PER_HEAT` / `LAUNDER_HEAT_REDUCTION_ON_SUCCESS`
- `STOCK_MARKET_ENABLED` / `STOCK_MARKET_TICK_SECONDS` / `STOCK_MARKET_MAX_POSITIONS`
- `PROPERTY_DEVELOP_ENABLED` / `PROPERTY_DEVELOP_MAX_LEVEL` / `PROPERTY_DEVELOP_COST_PERCENT_OF_PURCHASE` / `PROPERTY_DEVELOP_INCOME_BONUS_PERCENT_PER_LEVEL` / `PROPERTY_DEVELOP_COOLDOWN_SECONDS`
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
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_PATROL`
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_INTEL_SCAN`
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SABOTAGE`
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SUPPLY_RUN`
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_RAID`
- `TERRITORY_ACTION_UNLOCK_HQ_LEVEL_DEFENSE`
- `COUNTRY_POLICE_PRESSURE_ENABLED` (0/1, default 0) — shared per-country police pressure; see `country-police.md` / `countryPoliceService.ts` for full `COUNTRY_POLICE_*` set (gains, decay, success/arrest pp caps, territory dampening, disrupt)

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
- Drugs heat/raid/darkweb/nightclub keys (defaults): `DRUG_HEAT_CASH_COOL_COST_PER_POINT` (5000), `DRUG_HEAT_CASH_COOL_POINTS` (25), `DRUG_HEAT_LOW_PROFILE_HOURS` (4), `DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS` (8), `DRUG_RAID_DOWNTIME_HOURS` (4), `DRUG_RAID_CASH_FINE_PERCENT` (35), `DRUG_DARKWEB_AUTOSALE_FEE_PERCENT` (12), `DRUG_DARKWEB_AUTOSALE_HEAT` (4), `DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT` (10), `DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT` (8).

## QA Checklist
1. `GET /api/admin/economy/balance-telemetry?hours=24` geeft geldige data.
2. Runtime tuning save/apply werkt in admin zonder deploy.
3. Diminishing context wordt toegepast in crimes/jobs/vehicle theft.
4. Premium cooldown-reset en boost effecten blijven binnen balansregels.
5. Geen regressie op core gameplay loops (crime/job/vehicle/hitlist).
6. `Help & Uitleg` en roadmap zijn bijgewerkt als gedrag wijzigt.

## Dagdoelen (Retention, cash + XP)
- Dagdoelen zijn toegestaan als retention-loop zolang:
  - er **geen hard cap** op kernloops ontstaat (dagdoelen zijn bonus, geen blokkade)
  - rewards klein blijven (cash + XP) en niet structureel premium credits injecteren
  - claim idempotent is (1x per speler per dag per goal) en abuse-bestendig
  - tuning later server-side kan (bijv. via runtime keys/admin), niet hardcoded in de client

## Weekdoelen (Mid-term motivatie)
- Weekdoelen zijn toegestaan als mid-term retention-loop zolang:
  - rewards beperkt blijven (cash + XP) en niet pay-to-win aanvoelen
  - week-window duidelijk en consistent is (start maandag UTC in deze implementatie)
  - claim idempotent is (1x per speler per week per goal) en abuse-bestendig

## i18n / Help
- Als player-perceptie verandert (tempo, reward-gevoel, premium-waarde), update `docs/game-systems/GAMEPLAY.md`.
- Geen economyfeature is done zonder NL/EN consistente player copy waar van toepassing.

## When To Update This File
Bij elke nieuwe economy-loop, monetization-mechaniek, cooldown-reset type, boost type, of tuningmethodiek.
