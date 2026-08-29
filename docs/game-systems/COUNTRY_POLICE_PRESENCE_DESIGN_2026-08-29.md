# Country Police Presence — Design (2026-08-29)

**Status:** implemented behind `COUNTRY_POLICE_PRESSURE_ENABLED` (default **off**). Enable via Admin runtime config.  
**Module protocol:** `docs/module-protocols/country-police.md`  
**Depends on:** crimes, travel, wanted/FBI (`policeService`), dashboard, (later) territory / crew.

## Goal

A **shared live pressure per country** so the world feels different by location:

- Busy countries feel hotter for crimes and arrests.
- Travel becomes a real decision (“produce here, crime there”).
- Personal `wantedLevel` and `fbiHeat` stay; this is **world state**, not a second personal meter.

**Non-goal (for now):** daily “attack the police station” farming as a cash/XP loop.

---

## Player fantasy (one sentence)

*“The streets of this country are crawling with cops right now — crime is harder, getting caught is likelier, unless we cool it down or move.”*

---

## Core concept

| Layer | What it is | Scope |
|---|---|---|
| `wantedLevel` | How hot **you** are | Per player |
| `fbiHeat` | Federal attention on **you** | Per player |
| `policePressure` | How hot **this country** is | Shared per `countryCode` (0–100) |

Pressure modifies **crime success** and **arrest chance** for actions taken **while the player’s `currentCountry` equals that country**.

---

## Phased rollout

### Phase 1 — Live pressure (MVP, ship first)

1. Persist `policePressure` per country.
2. Raise pressure from local illegal activity (crimes, optionally vehicle theft / drug collect).
3. Decay over ticks.
4. Soft modifiers on crime success + arrest.
5. Read-only UI: crimes strip, travel badges, dashboard chip.
6. Runtime keys + telemetry (Admin can tune without redeploy).
7. Feature flag: `COUNTRY_POLICE_PRESSURE_ENABLED` default **`0` / false**.

### Phase 2 — Flavor + territory

- Mild base floors/ceilings per country (capital / high-pop feel hotter).
- Crew territory control in that country: small **dampening** (e.g. −5% pressure gain or −1 pressure/tick extra decay) — never a full immunity.
- Optional timed “crackdown” windows via live events.

### Phase 3 — Rare disruption ops (optional)

One expensive action family, **not** a farm:

- Examples: *Corruption payoff*, *Distract precinct*, *Crew raid on evidence lockup*.
- Crew-gated and/or high rank; long cooldown; cash sink; fail → personal wanted/FBI spike + local pressure **up**.
- Success → temporary pressure drop (e.g. −15 to −25) with a short “cooled” window where further drops are weaker (anti-spam).

Do **not** enable Phase 3 until Phase 1 has telemetry (gain/decay, crime fail rate by country, jail rate).

---

## Data model (proposed)

Table `country_police_state`:

| Column | Type | Notes |
|---|---|---|
| `countryCode` | VARCHAR PK | Same ids as travel (`netherlands`, `belgium`, …) |
| `pressure` | INT NOT NULL | 0–100 |
| `updatedAt` | DATETIME | Last mutation |
| `lastActivityAt` | DATETIME NULL | Last pressure **gain** |
| `coolUntil` | DATETIME NULL | Phase 3: reduced further drops while set |

Bootstrap: one row per known travel country at pressure `20` (calm baseline) or `0` — pick one and stick to it in balance docs.

**Hot path:** prefer Redis `country:police:{code}` with periodic DB flush, or DB-only if tick volume is low. Start DB-only for MVP.

---

## Runtime keys (Admin)

| Key | Default | Meaning |
|---|---|---|
| `COUNTRY_POLICE_PRESSURE_ENABLED` | `0` | Master switch |
| `COUNTRY_POLICE_BASELINE` | `15` | Floor after decay (optional soft floor) |
| `COUNTRY_POLICE_DECAY_PER_TICK` | `1` | Pressure lost per tick when above baseline |
| `COUNTRY_POLICE_GAIN_CRIME` | `1` | Base gain on crime **attempt** that resolves in-country |
| `COUNTRY_POLICE_GAIN_CRIME_HIGH_TIER` | `2` | Extra gain if crime max reward ≥ threshold |
| `COUNTRY_POLICE_HIGH_TIER_REWARD` | `5000` | Threshold for high-tier gain |
| `COUNTRY_POLICE_SUCCESS_PENALTY_MAX_PP` | `8` | Max success-chance percentage-points removed |
| `COUNTRY_POLICE_ARREST_BONUS_MAX_PP` | `12` | Max added arrest percentage-points |
| `COUNTRY_POLICE_PLAYER_GAIN_CAP_PER_HOUR` | `10` | Max pressure one player can add to a country per rolling hour |

All gains/effects must be readable in Admin → runtime / balance notes (`balance-economy.md` when implementing).

---

## Formulas (Phase 1)

Clamp pressure to `[0, 100]` always.

### Gain (on crime resolution in country C)

```
gain = GAIN_CRIME
if crime.maxReward >= HIGH_TIER_REWARD:
  gain += GAIN_CRIME_HIGH_TIER
gain = min(gain, remainingPlayerHourlyCap)
pressure[C] = min(100, pressure[C] + gain)
```

Same pattern later for vehicle theft / drug collect with smaller gains (config).

**Fail and success both can raise pressure** (cops respond to noise). Prefer **+gain on every attempt that hits the crime loop**, not only success — keeps farming from “fail safely.”

### Decay (global tick)

```
if pressure > BASELINE:
  pressure = max(BASELINE, pressure - DECAY_PER_TICK)
```

Optional: if `now - lastActivityAt > 2h`, decay `2×` (quiet countries cool faster).

### Crime success modifier

Personal bonuses (rank, gym, shooting, combo, tools) stay as today. Then apply world pressure:

```
penaltyPp = floor(pressure / 100 * SUCCESS_PENALTY_MAX_PP)
// e.g. pressure 50, max 8 → −4 percentage points
finalSuccessChance = max(minSuccessFloor, baseSuccessChance - penaltyPp)
```

Keep an existing absolute floor (whatever crimes already use, e.g. ~55% domain) — pressure must **not** push success to zero.

### Arrest modifier

Keep current:

```
baseArrestChance = min((wantedLevel / policeRatio) * 100, 90)
```

Then:

```
arrestBonusPp = floor(pressure / 100 * ARREST_BONUS_MAX_PP)
finalArrestChance = min(95, baseArrestChance + arrestBonusPp)
```

FBI path unchanged in Phase 1 (pressure is local cops, not federal).

### Example (felt difficulty)

| Pressure | Success penalty | Arrest bonus (wanted 10, ratio 10 → base 100% capped 90) |
|---|---|---|
| 0–15 | 0–1 pp | ~0–2 pp |
| 50 | ~4 pp | ~6 pp |
| 100 | 8 pp | 12 pp |

Solo mid-game still playable; organized chaos in one country hurts everyone there — intended.

---

## APIs (proposed)

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/police/countries` | `{ countries: [{ countryCode, pressure, labelKey, band }] }` public-ish or auth |
| `GET` | `/police/status` | Current country + pressure + derived `successPenaltyPp` / `arrestBonusPp` for UI |
| Include summary on | `GET /player/me` or dashboard-stats | Avoid extra round-trip on boot |

Bands for UI (not separate storage):

| Pressure | Band key |
|---|---|
| 0–24 | `calm` |
| 25–49 | `watchful` |
| 50–74 | `hot` |
| 75–100 | `lockdown` |

Phase 3 later: `POST /police/disrupt` with `{ actionType }` + crew checks.

---

## UI / UX

### Crimes screen
- Strip under prep/filters: **Politiedruk · {country} · {band} ({pressure})**
- One short line: e.g. “−4% slagingskans · +6% arrestkans” (from server-derived pp, not client-guessed).

### Travel
- Per destination: small badge by band color (calm → lockdown).
- Tooltip: “Misdaden daar zijn nu riskanter.”

### Dashboard
- Chip next to country / risk row for **current** country only.
- Optional: “Hottest countries” only if we already show world snippets (don’t clutter).

### Help & Uitleg
- Topic under police/crimes/travel: personal wanted vs country pressure; no Phase 3 text until live.

### i18n
- Keys prefix `countryPolice*` (NL + EN minimum, then merge/translate pipeline).
- Bands and effect lines must not be hardcoded Dutch in widgets.

---

## Telemetry (required before Phase 3)

Per country (hourly rollups ok):

- avg / max pressure
- gains by source (crime / theft / drugs)
- crime attempts, success rate, arrest rate vs pressure bucket
- player-hour gain-cap hits

Red flags: one country stuck at 100 for days; success rate collapse; disrupt (if any) used as EV+ cash loop.

---

## Anti-abuse & design guards

- Hourly per-player contribution cap.
- Soft success floor preserved.
- Arrest still primarily driven by **personal** wanted; pressure is a nudge.
- No “clear all pressure” premium button (pay-to-delete world state). VIP may shorten personal jail — not rewrite country heat.
- Phase 3 ops: hard cooldown, crew role checks, diminishing returns under `coolUntil`.

---

## Cross-module impact

| Module | Impact |
|---|---|
| `crimes` | Success + post-crime arrest use pressure |
| `travel` | Show badges; no block on travel |
| `police` / jail | Arrest chance formula extension |
| `dashboard` | Status chip + help |
| `drugs` / `steel_voertuig` | Optional Phase 1.1 gain sources |
| `territory` / `crew` | Phase 2–3 only |
| `balance-economy` | Runtime keys + soft caps |
| `events` | Optional crackdown multipliers later |

---

## Acceptance criteria (Phase 1)

1. Flag off → identical crime/arrest math to today.
2. Flag on → pressure moves with in-country crimes; decays on tick.
3. UI shows server-derived penalties for current country.
4. Travel shows bands without blocking movement.
5. NL + EN strings + help topic updated.
6. Telemetry counters exist and are queryable/logged.

---

## Open decisions (resolve at implement kickoff)

1. Baseline `0` vs `15` after decay.
2. Whether **failed** crimes raise pressure (recommended: yes).
3. Whether drug collect / vehicle theft gain in MVP or 1.1.
4. Redis vs DB-only for MVP.

Default recommendations: baseline **15**, gain on **all** crime resolutions, theft/drugs in **1.1**, **DB-only** MVP.
