# Balance Workbook 2026 — Year-long retention audit

**Status:** Fase 1 audit only (geen live catalog/runtime tweaks in dit document).  
**Datum:** 2026-10-01  
**Lens:** spelers blijven ~1 jaar uitgedaagd via risk + payout + cooldown + soft diminish — geen harde daily caps op core loops.  
**Baseline docs:** [`BALANCE_PHASE_ROADMAP.md`](BALANCE_PHASE_ROADMAP.md), [`balance-economy.md`](../module-protocols/balance-economy.md).

### Retentie-filosofie (vastgelegd)

| Fase | Doel |
|------|------|
| Week 1–2 | Onboarding + early ranks belonend (early XP-mercy mag blijven) |
| Maand 1–3 | Midgame loops spannend; sinks + risk houden cash onder controle |
| Maand 3–12 | Groei uit empire / collectie / territory / crew — niet oneindig snellere €/uur op dezelfde farm |
| Na 1 jaar | Schaarste (legendary, late ranks, showroom, territory prestige) + soft diminish |

---

## 0. Inventory — balance levers (bronnen)

### Catalogs (`backend/content/`)

| Bron | Rol |
|------|-----|
| `crimes.json` (36) | success, reward band, XP, jailTime, tools, federal flags |
| `jobs.json` (24) | earnings band, XP, minLevel |
| `drugs.json` (12 drugs + materials) | batch time, yield, materials, countryPricing |
| `vehicles.json` (201 cars / 61 motos / 31 boats) | baseValue, rarity, marketValue |
| `properties.json` (9) | basePrice, baseIncome, incomeInterval |
| `countries.json` | travelCost per land |

### Code curves

| Bron | Rol |
|------|-----|
| `config/index.ts` → `getXPForRank` | XP_BASE 1000; growth 7% ≤R60, 5% ≤R150, 3.5% daarna |
| `cooldownService.ts` | crime CD op maxReward; job CD op maxEarnings; theft CD auto 5m / moto 4m / boat 10m; travel 60m |
| `economyBalanceService.ts` | `ECON_*` session diminish op crime/job/theft progression rewards |
| `vehicleService.ts` | `priceBandSuccessChance`, `streetTheftRarityWeights` (rare@7, epic@13, legendary@22) |
| `drugService.ts` + `drugRuntimeConfig.ts` | heat (+5/start), raid tiers, cash-cool, wholesale |
| `showroomCatalog.ts` / `showroomService.ts` | Cat papers cost; seize ~40% alleen in showroom-land, skip als catted |
| `educationService.ts` | `SCHOOL_TUITION_BY_LEVEL` = 2k/4k/8k/15k/28k |
| `gymService.ts` / shooting-range | train €500 / €750 default |
| `launderService.ts` | fee ~12%, seize per heat, delay |
| `rldConfig.ts` | room gross/rent tiers, expansion/security sinks |

### Runtime / telemetry (live, Admin)

| Key-set | Notes |
|---------|-------|
| `ECON_SESSION_WINDOW_MINUTES`, `ECON_DIMINISH_1..4_*` | Code defaults (60m / 8→0.96 … 40→0.78) ≠ roadmap live snapshot (90m / 12→0.98 … 52→0.86) — **runtime is truth** |
| `DRUG_*` heat/raid/wholesale/nightclub supply | Zie `drugRuntimeConfig.ts` |
| `LAUNDER_*`, `BANK_FREE_DEPOSIT_DAILY_*`, `PROPERTY_DEVELOP_*` | Deep economy sinks |
| `GET /api/admin/economy/balance-telemetry?hours=24` | attempts, success, jail, payout/min |

### Methode (EV-aannames in dit workbook)

- Crime/job **€/h** en **XP/h** = `avgReward × baseSuccess × (3600 / cooldownSec)` — catalog success, zonder HP/police/mastery/VIP.
- Jobs success aangenomen **0.90** (catalog heeft geen fail-chance veld).
- Diminish: “peak” = multiplier 1.0; “deep session” ≈ tier-4 multiplier (code default **0.78**, live vaak **0.86**).
- Drugs: materialen tegen catalogus-`price`; street sell op `countryPricing`; net = revenue − materials; geen smokkelkosten in basisrij.
- Theft €/h is **bovengrens** bij vaste prijsband + 5m auto-CD; garage-capaciteit, jail, rarity en land-pool knippen dit hard.

---

## 1. Progressie — XP-curve

`getXPForRank(target)` cumulatief (totaal XP om die rank te *zijn*):

| Rank | Cumulatief XP | XP voor volgende rank | Notitie retention |
|------|---------------|------------------------|-------------------|
| 5 | 4 441 | 1 312 | Early mercy zone |
| 10 | 11 991 | 1 843 | Street → mid crimes |
| 15 | 22 598 | 2 589 | |
| 25 | 58 397 | 5 100 | Eerste “serieus” milstone |
| 40 | 186 600 | 14 080 | Mid empire unlocks |
| 60 | 763 968 | 54 506 | Groei-rate schakelt naar 5% |
| 100 | 7 473 461 | 391 090 | Late grind |
| 150 | 89 348 867 | 4 484 884 | Groei → 3.5%; prestige |
| 200 | 685 310 072 | 25 410 825 | Ultra-late |

**Ruwe speeltijd (alleen crime/job XP, geen events/crew):**

| Doel | Aanname XP/h effectief | Uren | Dagen @ 4u/dag |
|------|------------------------|------|----------------|
| R1→R25 | 700 (early street farm) | ~83 | ~21 |
| R1→R25 | 400 (gemengd / diminish) | ~146 | ~37 |
| R1→R60 | 250 | ~3 056 | ~764 (~2+ jaar @ 4u) |
| R1→R150 | 200 | ~447 000 | niet realistisch via solo farm |

**Retention-lezing:** R25 in ~3–5 weken casual is gezond voor maand 1. R60+ vereist breed XP (crew missions, events, daily/weekly goals) — dat past bij “maand 3–12 = empire/crew”, niet pure street farm. Pure late-rank XP uit catalog crimes (~150 XP/h top-tier) is bewust traag.

---

## 2. Crimes — €/h en XP/h (catalog EV)

Cooldown = `calculateCrimeCooldown(maxReward)`: ≤500→90s, ≤2k→5m, ≤10k→15m, ≤30k→30m, else 60m.

### Early (minLevel 1–5) — top per XP/h

| Crime | Rank | Success | Avg € | CD | €/h | XP/h |
|-------|------|---------|-------|-----|-----|------|
| shoplift | 1 | 65% | 200 | 90s | 5 200 | **910** |
| pickpocket | 1 | 70% | 125 | 90s | 3 500 | 700 |
| steal_bike | 1 | 60% | 115 | 90s | 2 760 | 672 |
| vandalism | 1 | 75% | 65 | 90s | 1 950 | 540 |
| graffiti | 1 | 80% | 50 | 90s | 1 600 | 384 |
| car_theft | 3 | 50% | 1 250 | 5m | 7 500 | 390 |
| drug_deal_small | 3 | 60% | 550 | 5m | 3 960 | 360 |
| burglary | 5 | 45% | 1 900 | 15m | 3 420 | 144 |

### Mid (10–15)

| Crime | Rank | Success | Avg € | CD | €/h | XP/h |
|-------|------|---------|-------|-----|-----|------|
| arson | 10 | 35% | 6 750 | 15m | 9 450 | 350 |
| smuggling | 9 | 40% | 5 650 | 15m | 9 040 | 352 |
| kidnapping | 15 | 25% | 20 000 | 30m | **10 000** | 250 |
| jewelry_heist | 12 | 30% | 10 000 | 30m | 6 000 | 180 |

### Late (20–25)

| Crime | Rank | Success | Avg € | CD | €/h | XP/h |
|-------|------|---------|-------|-----|-----|------|
| bank_robbery | 22 | 18% | 47 500 | 60m | 8 550 | 162 |
| casino_heist | 25 | 15% | 55 000 | 60m | 8 250 | 150 |
| museum_heist | 23 | 16% | 51 500 | 60m | 8 240 | 152 |
| **criminal_record_wipe** | 21 | 18% | **0** | **3600s** (catalog override) | 0 | **~153** |

### Met soft diminish (illustratief)

Op peak XP/h van shoplift (910): na deep session ×0.86 (live) ≈ **783**; ×0.78 (code default) ≈ **710**. Diminish raakt progression reward, niet de cooldown — early street blijft de snelste XP-loop tot mid ranks.

**Fixed (2026-10-01):** `criminal_record_wipe` had `maxReward: 0` → 90s CD → ~6 120 XP/h. Nu `cooldownSeconds: 3600` via `resolveCrimeCooldownSeconds` → ~153 XP/h @ 18% success (aligned with late federal heists). Utility wipe, geen rank-farm.

---

## 3. Jobs — €/h en XP/h

Job CD = `calculateJobCooldown(maxEarnings)`. Success aangenomen 90%.

| Job | Rank | Avg € | CD | €/h | XP/h |
|-----|------|-------|-----|-----|------|
| grocery_bagger | 1 | 150 | 3m | 2 700 | 180 |
| construction_worker | 3 | 350 | 5m | 3 780 | 270 |
| security_guard | 5 | 400 | 5m | 4 320 | 324 |
| paramedic | 10 | 800 | 8m | 5 400 | 405 |
| lawyer | 15 | 1 500 | 12m | 6 750 | 450 |
| doctor | 20 | 3 000 | 17m | 9 529 | 635 |
| airline_pilot | 25 | 4 500 | 22m | **11 045** | **736** |

**Vergelijking mid-rank:** jobs leveren vaak **meer XP/h** dan mid/late crimes (lawyer 450 vs jewelry 180), crimes leveren meer risk/flavor en soms hogere piek-€ (kidnapping 10k €/h). Airline pilot is top legale €/h — dicht bij top crimes zonder jail.

---

## 4. Cash sinks

| Sink | Orde van grootte | Rol |
|------|------------------|-----|
| Gym train | €500 / sessie | Early combo readiness |
| Shooting range | €750 / sessie | Idem |
| School tuition | €2k → €28k per level | Tijd is hoofdlimiter; cash modest |
| Travel | €250–€5 000 / etappe + 60m CD | Smokkel/arbitrage friction |
| Launder | ~12% fee + delay + seize∝heat | Forced boven free bank deposit cap |
| Drug heat cash-cool | €5 000 × 25 pts = **€125 000** / cool | Zware mid/late sink |
| Cat papers (showroom) | floor €2.5k–€200k of 3–8% baseValue | Legendary bescherming duur |
| Property buy | €75k–€5M | Warehouse/shop snelle ROI; showroom/casino prestige |
| Property develop | `%` van purchase (runtime) | Permanent income bump |
| RLD expansion | €40k→€500k (8 stappen) | Rooms + security €25k→€130k |
| RLD tier up | €50k / €150k / €350k / €750k | Income tier climb |
| Garage storage up | per land / track | Cap op theft farm |
| Bail / jail time | crime `jailTime` + wanted/FBI | Risk cost (tijd > cash early) |
| Court expunge | €100k + €1k×(convictions−1), 12h CD | Record sink |
| Ammo factory claim | 20m interval, 3 rounds base | Soft ammo economy |

**Property passive ROI (catalog, geen develop/events):**

| Property | Price | €/h (base) | ~ROI dagen 24/7 |
|----------|-------|------------|-----------------|
| warehouse | 150 000 | ~300 (450/90m) | **~21** (was ~5; retuned 2026-10-01) |
| shop | 120 000 | ~240 (320/80m) | **~21** (was ~6; retuned 2026-10-01) |
| casino | 5 000 000 | 8 000 | ~26 |
| car_showroom | 2 500 000 | 2 133 | ~49 |
| nightclub | 3 000 000 | 1 800 | ~69 |

Warehouse/shop zijn midgame sinks + storage utility; showroom/casino blijven prestige (aparte empire-stack pass).

---

## 5. Drugs — batch EV

Heat: +5 (+incident) bij start; sell +2 per 100g; decay −1 / 6u. Raid kans: 0 / 5 / 10 / 20 / 35% bij heat bands. Raid fine default 35% van batchwaarde + downtime 4u. Cash-cool €5k/pt ×25.

Wholesale: min 250g, spread +15% bps default, extra FBI/drug heat — bedoeld voor volume-export, niet retail-NL.

### Street EV (materials @ shop price, avg yield)

| Drug | Rank | Time | g avg | Mat € | Net @ NL | €/h @ NL | Net @ max land | €/h @ max |
|------|------|------|-------|-------|----------|----------|----------------|-----------|
| white_widow | 5 | 2h | 75 | 450 | +300 | 150 | +2 175 | **1 088** |
| hash | 3 | 1h | 45 | 910 | −550 | −550 | +350 | 350 |
| magic_mushrooms | 8 | 2.5h | 60 | 750 | +750 | 300 | +3 450 | **1 380** |
| amnesia_haze | 10 | 3h | 115 | 685 | +1 040 | 347 | +5 065 | **1 688** |
| xtc | 12 | 3h | 150 | 1 900 | −1 150 | −383 | +350 | 117 |
| og_kush | 15 | 4h | 150 | 1 025 | +1 975 | 494 | +8 725 | **2 181** |
| speed | 15 | 4h | 30 | 2 000 | −500 | −125 | +1 000 | 250 |
| cocaine | 20 | 5h | 17.5 | 3 000 | −1 250 | −250 | +500 | 100 |
| lsd | 22 | 5h | 350 | 24 900 | −17 900 | −3 580 | −7 400 | −1 480 |
| heroin | 25 | 6h | 10 | 3 500 | −2 000 | −333 | −1 000 | −167 |
| crystal_meth | 30 | 7h | 25 | 5 650 | −2 650 | −379 | +1 350 | 193 |
| fentanyl | 40 | 8h | 12.5 | 34 900 | −31 150 | −3 894 | −27 400 | −3 425 |

**g/uur (avg yield / hours):** weed strains ~38 g/h; mushrooms ~24; xtc ~50; hard chems vaak ≤8 g/h.

**Lezing:** weed/mushrooms + land-arbitrage zijn de echte cash engines (~1–2k €/h max land, onder top theft maar boven mid crimes na mat-cost). Late synthetics (LSD/fentanyl) zijn **negatief** bij retail materials — ofwel intentional prestige/sink, ofwel broken ladder (speler moet smokkel/crew/cheaper mats begrijpen). Hash/XTC NL-negatief duwt naar export.

Nightclub player-supply: **55%** van street price (runtime) = bewuste lagere payout, lokaal, geen extra heat.

---

## 6. Vehicles — theft, rarity, showroom

### Price-band success (mid van band, `priceBandSuccessChance`)

| baseValue | Success ~mid | EV sell @80% cond × succ | €/h @ 5m CD (bovengrens) |
|-----------|--------------|---------------------------|---------------------------|
| 5 000 | 80% | 3 200 | ~38k |
| 50 000 | 52.5% | 21 000 | ~252k |
| 200 000 | 25% | 40 000 | ~480k |
| 600 000 | 7.5% | 36 000 | ~432k |
| 1 500 000 | 2.75% | 33 000 | ~396k |
| 3 000 000+ | ~0.8% | ~19 000 | ~230k |

Street theft €/h **domineert** crimes/jobs op papier; echte limieten: garage slots, jail/wanted, land availability, boat +6% ease, diminish op progression XP (niet op voertuigwaarde).

### Rarity weights (`streetTheftRarityWeights`)

| Rank | common | uncommon | rare | epic | legendary |
|------|--------|----------|------|------|-----------|
| &lt;7 | 72 | 28 | — | — | — |
| 7–9 | 70 | 28 | 2 | — | — |
| 10–12 | 55 | 32 | 13 | — | — |
| 13–21 | 48 | 30 | 16 | 6 | — |
| **22+** | 42 | 28 | 18 | 9 | **3** |

P(legendary | success) @22+ = **3%** (~1 op 33 successes). Bij ~25% success en 5m CD ≈ **~11 uur actief stelen per legendary roll** (niet per unieke catalog-entry — pool deelt rarity).

### Catalog rarity counts (field of aanwezig, anders showroom inferentie op value)

Cars/boats/motos combined approx: common/uncommon/rare/epic/legendary mix zwaar naar rare+ (catalog count ≠ drop rate — weights sturen).

### Showroom

- Seize chance **40%** bij arrest **alleen in showroom-land**; andere landen zoeken de vitrine niet.
- Cat papers: `max(floor[rarity], baseValue × pct)` — legendary floor **€200 000** of 8%.
- Prestige/ROI: showroom passive income + collectie; Cat papers is de juiste late sink voor “safe legendary flex”.

---

## 7. Risk

| Mechanisme | Gedrag | Balance-rol |
|------------|--------|-------------|
| Crime fail → jail | Early street: 28% jail mercy (rank≤5, minLevel≤1); anders normaal | Week 1–2 vriendelijk |
| `CRIME_JAIL_CHANCE` | Config default 0.5 op relevante paden | |
| Wanted / FBI heat | Crimes, wholesale, occupancy 100% RLD, etc. | Soft escalate |
| Drug raid | Heat bands → 5–35% op collect | Batch EV haircut |
| Showroom seize | 40% uncatted, country-scoped | Collectie-risk |
| Launder seize | ∝ heat × `LAUNDER_SEIZE_CHANCE_PER_HEAT` | Bank path risk |
| Vehicle theft jail | Telemetry baseline ~5% jail op attempts (sample klein) | |

Zonder jail/heat voelen mid loops te veilig → cash explodeert (zie warehouse ROI).

---

## 8. Empire / late (high-level)

| Loop | Orde € / prestige | Notes |
|------|-------------------|-------|
| RLD / prostitution | Net ~€55–€140 /uur/kamer (gross−rent); ×10–100 kamers = mid→late passive | Occupancy↑ = rent↑ maar raid/steal/FBI; 8u shifts lumpsum apart |
| Nightclub | Property €3M + drug supply 55% B2B + own-prod bonus 8% | Empire glue met drugs |
| Casino property | €8k/h passive catalog | Sterke cash; monitor stacking |
| Territory | Cooldown + anti-farm; garrison €350k crew-bank; seizoen prestige | Geen daily action cap (default 0) |
| Crew missions | XP + crew level cash bonus % (runtime) | Nodig om R60+ speelbaar te houden |
| Don / contracts | Tribute hundreds–low thousands / 4h | Onder jobs/drugs bewust |
| Ammo factory | 3 rounds / 20m @ L1 | Craft sink, geen cash printer |

Late retention moet uit **collectie (legendary + showroom), territory hold, crew level, RLD schaal** komen — niet uit nog snellere street €/h.

---

## 9. Loop vergelijking (mid vs late snapshot)

| Loop | Mid-rank (~10–15) €/h | Mid XP/h | Late (~22–25) €/h | Late XP/h | Risk |
|------|----------------------|----------|-------------------|-----------|------|
| Best street crime | ~5–9k | ~300–900 | ~8k | ~150 | Jail |
| Best job | ~5k | ~400 | ~11k | ~736 | Laag |
| Weed batch @ max land | ~1–2k | (tijd-gated) | og_kush ~2k | — | Heat/raid |
| Auto theft mid band | 100k+ paper | low XP | high paper | low XP | Jail + garage |
| RLD 10 basic rooms | ~550 | — | 100 prestige ~11k | — | Raid/steal/FBI |
| Wipe crime | — | — | 0 € | **6k+** | Federal/jail |

---

## 10. Scorecard (groen / oranje / rood)

Criteria: **te snel / te traag / te veilig / te zwak sink** t.o.v. year-long retention.

| # | Onderdeel | Score | Waarom |
|---|-----------|-------|--------|
| 1 | Early street XP (R1–5) | **Groen** | ~20–40 dagen naar R25 @ 4u; mercy + 60% floor voelt belonend |
| 2 | XP curve R25→R60 | **Oranje** | Solo crime/job te traag zonder crew/events; OK als empire XP meedoet — verifiëren met telemetry |
| 3 | XP curve R100+ | **Groen** | Bewust prestige-traag; past “na 1 jaar nog ranks” |
| 4 | `criminal_record_wipe` XP/CD | **Groen** (fixed 2026-10-01) | Was rood: maxReward 0 → 90s CD. Nu catalog `cooldownSeconds: 3600` → ~153 XP/h @ 18% success |
| 5 | Job vs crime XP mid/late | **Oranje** | Jobs winnen XP-race; crimes moeten risk/reward blijven of XP-bijtrekken |
| 6 | Soft diminish ECON_* | **Groen** | Geen hard caps; live curve milder dan code defaults — documenteer drift |
| 7 | Warehouse/shop ROI | **Groen** (fixed 2026-10-01) | Was ~5–6 dagen; nu ~21 dagen L1 ROI + scaled upgrade bonuses |
| 8 | School/gym sinks | **Groen** | Modest; time-gated school correct |
| 9 | Launder + bank cap | **Groen** | Forceert fee/risk boven free deposit |
| 10 | Drug weed arbitrage | **Oranje** | Max-land ~2k €/h gezond; monitor stacking met theft |
| 11 | Drug late synthetics EV | **Rood** | LSD/fentanyl/heroin retail-negatief; ladder voelt broken of ongedocumenteerd |
| 12 | Hash/XTC @ NL | **Oranje** | Duwt export — OK als intentional, slecht als Newbie-trap |
| 13 | Drug heat cash-cool | **Groen** | €125k cool = serieuze sink |
| 14 | Vehicle theft €/h | **Oranje** | Paper EV extreem; garage/jail moeten hard knippen — telemetry op storage-full + sell volume |
| 15 | Legendary weight 3% @22 | **Groen** | ~11u per roll houdt collectie year-long spannend |
| 16 | Epic unlock @13 | **Groen** | Midgame carrot |
| 17 | Showroom seize + Cat papers | **Groen** | Country-scope + €200k legendary floor = juiste prestige sink |
| 18 | Early crime jail mercy | **Groen** | Week 1–2 vriendelijk zonder midgame te safe te maken |
| 19 | Casino passive €8k/h | **Oranje** | Sterk t.o.v. active loops; check multi-property stacking |
| 20 | RLD scale to 1000 rooms | **Oranje** | Cap hoog; security/FBI moeten meeschalen (monitor occupancy heat) |
| 21 | Travel CD 60m + cost | **Groen** | Friction op arbitrage |
| 22 | Territory / crew late goals | **Groen** | Juiste late pillars als XP/cash farm soft is |
| 23 | Credit→cash vs cashpacks | **Groen** | Protocol: credits niet cash-arbitrage |
| 24 | Ammo factory pacing | **Groen** | 20m / 3 rounds — recent getuned |
| 25 | Live telemetry sample size | **Oranje** | Roadmap 24h sample klein (18 crimes); fase-2 pas na ≥72h |

---

## 11. Fase-2 voorstellen (niet live — wacht op akkoord)

Prioriteit op rood/oranje met grootste impact op “nog 1 jaar willen spelen”:

1. **~~Fix `criminal_record_wipe` pacing~~ (done 2026-10-01)**  
   - Catalog `cooldownSeconds: 3600` + `resolveCrimeCooldownSeconds`. Expected XP/h ~153 @ 18% success.

2. **~~Property income / ROI~~ (done 2026-10-01)**  
   - Warehouse 450/90m, shop 320/80m (~21d L1 ROI); upgrade bonuses scaled.

3. **Drug late ladder (rood)**  
   - Of materials/yield/price herschalen zodat cocaine→fentanyl positieve export-EV heeft met oplopende heat; of Help/Almanac expliciet “alleen smokkel/crew mats”.  
   - Verwacht: late drug unlocks voelen als progressie, niet als geldverbranding.

4. **Theft garage pressure (oranje)**  
   - Telemetry: sell €/h, storage-full rate. Zo nodig slot-kosten omhoog of jail op fail iets omhoog in high bands — **niet** rarity legendary onder 3% duwen zonder data.

5. **Job/crime XP parity mid (oranje)**  
   - Lichte XP-bump op 15m/30m crimes of job XP trim — behoud risk fantasy.

6. **Casino / RLD stacking (oranje)**  
   - Cap of diminish op multi-property passive; bevestig FBI tick bij 100% occupancy.

7. **ECON defaults vs live documenteren**  
   - Geen blinde sync; kies één source of truth in Admin na 72h telemetry.

8. **Niet doen in fase 2 zonder aparte beslissing**  
   - Legendary weight verlagen, hard daily caps, early mercy verwijderen, Clearing House gate wijzigen.

### Verwachte retention-impact (kwalitatief)

| Fix | Week 1–2 | Maand 1–3 | Maand 3–12 |
|-----|----------|-----------|------------|
| Wipe CD/XP | — | — | Voorkomt rank skip |
| Property ROI | — | Minder cash flood | Empire keuzes blijven tellen |
| Drug ladder | — | Duidelijke mid path | Late batches zinvol |
| Theft pressure | — | Garage als doel | Collectie > pure sell farm |

---

## 12. Volgende meetstap (voor fase-2 go)

1. Admin `balance-telemetry?hours=72` — crimes/jobs/theft payout/min, jail%.  
2. Spot-check: wipe attempt rate @ rank≥21; warehouse owners’ cash velocity; drug batch collect + negative-EV drugs.  
3. Akkoord scorecard → gerichte content/runtime PRs met vóór/na telemetry + Discord player update waar nodig.

---

*Einde fase-1 workbook. Geen catalog- of runtime-wijzigingen in deze oplevering.*
