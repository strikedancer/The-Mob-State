# Crew Mission: Clearing House Vault Run (World Bank–thema)

**Versie:** 2026-04-26  
**Status:** mission live in `MISSION_SEEDS` als `clearing_house_vault_run`; zie [CREW_MISSIONS_EXPANSION_2026-04-26.md](CREW_MISSIONS_EXPANSION_2026-04-26.md) voor generatie-runbook.  
**Module-protocollen:** `docs/module-protocols/crew-missions.md`, `docs/module-protocols/balance-economy.md`, `docs/module-protocols/bank.md`, `docs/module-protocols/notifications.md`, `docs/module-protocols/dashboard.md`  
**Orchestrator:** `docs/module-protocols/PROTOCOL_MASTER.md` (cross-module + NL/EN + Help & Uitleg + telemetry)

## 1. Ontwerpprincipe (niet onderhandelbaar)

- **Thema:** infiltratie van een **institutionele clearing / settlement-laag** (“wereldbank”-fantasy: kluizen, SWIFT-achtige messaging, reconciliatie-mainframes).
- **Rewardbron:** payouts zijn **server-side mint** uit hetzelfde economische kader als andere crew missions (crew cash pool), **niet** een aftrek op **andere spelers hun banksaldo**.
- **Geen globale player tax:** geen `%` van `bankBalance` van willekeurige spelers; dat zou `bank.md` + `balance-economy.md` + spelvertrouwen breken.
- **Wel toegestaan later (aparte feature):** cosmetische **wereld-nieuwsfeed**, korte **rentebuff/debuff** met harde cap en aankondiging — alleen als aparte spec + runtime keys; **niet** onderdeel van deze missie v1.

## 2. Waarom Tier 3 (apex)

- Past na **Casino Ledger Raid** en **Federal Convoy Break** in moeilijkheid en beloning.
- Zelfde **tier-3 unlocks** als bestaande Tier 3 (`crew HQ global level >= 9`, minimaal **3 online crewleden**) — zie Phase 1 doc.
- **Optionele stricter gate (Phase 2):** runtime `CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL` (default **0** = uit). Op `3` zetten vereist telemetry-go; zie §10.

## 3. Missieblok (implementeerbaar naast Phase 1)

### Clearing House Vault Run

| Veld | Waarde |
|------|--------|
| **key** | `clearing_house_vault_run` |
| **tier** | `3` |
| **titleNl** | Clearing House Kluisrun |
| **titleEn** | Clearing House Vault Run |
| **descriptionNl** | Infiltreer een afgesloten settlement-rail: HSM-sessies saboteren, cold-storage exfiltreren en onder druk ontsnappen. Geen rooftocht op spaarders—wel een institutionele zwakte. |
| **descriptionEn** | Infiltrate a sealed settlement rail: sabotage HSM sessions, exfil cold storage, and escape under pressure. You are not robbing players’ savings—you are exploiting an institutional weak point. |
| **basisduur** | `36m` → `durationSeconds: 36 * 60` |
| **cooldown na missie** | `38m` → `cooldownSeconds: 38 * 60` |
| **basis success chance** | `44%` (iets onder Federal Convoy; apex-risico) |
| **fail penalty** | `-26%` crew cash reward equivalent (`failPenaltyPct: 0.26`) |
| **reward bij succes (crew cash)** | `€320,000` – `€480,000` |
| **crew xp** | `285` |
| **personal contribution xp** | `142` |
| **sortOrder** | `70` (na `federal_convoy_break` @ 60) |
| **imageCardPath** | `images/crew_missions/cards/clearing_house_vault_run.png` |
| **imageScenePath** | `images/crew_missions/scenes/clearing_house_vault_run.png` |

### Partial / fail (gelijk trekken met Phase 1)

- **Partial threshold:** `>= 60%` objective progress (zelfde engine-regels als Phase 1).
- **Partial payout:** `65%` cash, `70%` crew xp, `100%` contribution xp voor actieve deelnemers.
- **Fail:** bestaande fail-penalty op crew-cash reward equivalent; geen extra jail/world-tax.

### Role model (ongewijzigd t.o.v. Phase 1)

- Rollen: `planner`, `enforcer`, `logistics`, `tech`.
- **Narratieve invulling voor deze missie:**
  - **Planner:** redundante routes / failover-rails kiezen.
  - **Tech:** HSM/session pinning en log spoofing.
  - **Logistics:** cold-storage drag + egress-timing.
  - **Enforcer:** response team neutraliseren / afleiden.

Zelfde numerieke role-bonus als Phase 1 (+3% success / −2% duration per unieke rol, caps +12% / −8% duration).

## 4. Balansrationale (balance-economy.md)

- **Payout per minute** licht onder of gelijk aan **Federal Convoy Break** na normalisatie (langere duur, iets lagere success).
- Ruwe vergelijking (succes, mid-cash):
  - Federal: ~34 min, mid cash ~360k → ~10.6k/min.
  - Clearing: 36 min, mid cash ~400k → ~11.1k/min — **iets hoger per minuut** gecompenseerd door **44% vs 48%** success en **hogere failPenaltyPct** (26% vs 24%).
- Alle getallen **tunebaar** via bestaande `crew_mission_templates` + admin copy; overweeg na live telemetry kleine stapjes (balance protocol: geen grote curve-shifts tegelijk).

## 5. Bank- en copy-integriteit (bank.md + i18n)

- In **Help & Uitleg** (crew / crew missions topic): één duidelijke zin dat rewards **niet** uit andere spelers hun bank komen.
- **NL-voorbeeld:** “Beloningen komen uit de crew-missie economie; er wordt geen geld van andere spelers rechtstreeks uit de bank gehaald.”
- **EN-voorbeeld:** “Rewards come from the crew mission economy; no money is taken directly from other players’ bank accounts.”

## 6. Beelden (image pipeline, crew-missions.md)

Bestandsnamen (conventie):

- `crew_mission_clearing_house_vault_run_card_v1.png`
- `crew_mission_clearing_house_vault_run_scene_v1.png`

Deploy-paden:

- `runtime/client-images/crew_missions/cards/clearing_house_vault_run.png`
- `runtime/client-images/crew_missions/scenes/clearing_house_vault_run.png`

### Promptrichting (Leonardo / Codex / ChatGPT)

- **Card:** nachtelijk financieel district, brutalist vault-deuren, holografische settlement streams, klein crew-silhouet, noir kleuren (diep blauw, goud accent), geen echte banklogo’s.
- **Scene:** serverruim met tape robots + glazen kluis, rood alarm, rook, spanning; leesbaar op mobiel (weinig kleine tekst).

## 7. i18n / keys

- **Titel en beschrijving** komen uit **database templates** (`titleNl` / `titleEn` / `descriptionNl` / `descriptionEn`) zoals andere missies; geen nieuwe Flutter-keys nodig tenzij je aparte flavor-teksten in cards wilt.
- Nieuwe **help**-strings: toevoegen in `client/lib/data/help_content.dart` (NL + EN synchroon).

## 8. Admin & telemetry (crew-missions.md)

- Telemetry groepeert al op `missionKey`; na implementatie controleren:
  - start/completion rate voor `clearing_house_vault_run`
  - success / partial / fail
  - reward per minute vs `federal_convoy_break`
  - credit speedup usage Tier 3

## 9. Implementatie-checklist (engine)

1. **`backend/src/services/crewMissionService.ts`:** voeg seed toe aan `MISSION_SEEDS[]` met exacte velden uit §3.
2. **Backend restart / seed upsert:** bestaande upsert-loop pakt nieuwe rij op.
3. **Assets:** plaats card + scene PNG’s op bovenstaande paden.
4. **`client/lib/data/help_content.dart`:** korte FAQ regel over rewardbron (NL + EN).
5. **`docs/module-protocols/crew-missions.md`:** onder *Tier 3 - High-Stakes* een bullet met mission key + één zin lore (optioneel).
6. **QA (PROTOCOL_MASTER checklist):** happy path + fail + partial + cooldown + mobile layout + push/inbox indien van toepassing.

## 10. Phase 2 gate (runtime, default off)

- **Per-mission unlock:** `CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL` in runtime config.
  - **`0` (default):** alleen bestaande Tier-3 HQ/leden-gates.
  - **`3`:** ook `crew.missionLevel >= 3` vereist voor `clearing_house_vault_run` (overview `lockedReason` + start reject).
- **Prod-besluit 2026-08-02:** houdt default **0** — all-time telemetry heeft 0 T2/T3/Blackout runs; gates aanzetten zou blind zijn. Zie `crew-missions.md` telemetry baseline.
- **Seizoens “institutional crisis”:** globale cosmetische modifier met eigen runtime keys — aparte spec + balance-economy review (nog niet gebouwd).

---

**Samenvatting:** één **Tier 3 apex** crew mission met wereldbank-**thema**, strikt **PvE / server-mint rewards**, geen **cross-player bank drain**. Phase-2 mission-level gate is **geïmplementeerd maar uit** tot telemetry dat rechtvaardigt.
