# Crew Missions — Uitbreiding bank-lijn + clearing house (2026-04-26)

**Status:** geïmplementeerd in `backend/src/services/crewMissionService.ts` (`MISSION_SEEDS`).  
**Protocollen toegepast:** `PROTOCOL_MASTER.md` → `crew-missions.md`, `balance-economy.md`, `bank.md`, `notifications.md`, `dashboard.md` (geen dashboard-schema gewijzigd).

## Ontwerpkeuzes

- **Volledige set van 6 nieuwe missies**, geen dubbele thema’s met bestaande seeds.
- **Geen tweede casino-crew-missie:** *Casino Ledger Raid* blijft de enige casino-gerichte crew mission.
- **Bank-thema’s:** Tier 1–3 oplopend (nachtstorting → skim → pantserwagen → dochterbank → reservekluis → clearing house).
- **Rewards:** zelfde model als Phase 1 (crew cash / crew mission XP / personal XP); payouts zijn **server-side mission economy**, **niet** een aftrek op andere spelers hun banksaldo.

## Missietabel (bron van waarheid = seeds)

| missionKey | Tier | Duur | Cooldown | Success | Fail penalty % | Crew cash (min–max) | Crew XP | Personal XP |
|------------|------|------|----------|---------|----------------|----------------------|---------|---------------|
| `night_deposit_grab` | 1 | 7m | 9m | 72% | 9% | €48.000–€76.000 | 50 | 25 |
| `skim_network_rollout` | 1 | 10m | 12m | 71% | 9.5% | €46.000–€74.000 | 56 | 28 |
| `armored_pivot_route` | 2 | 17m | 19m | 59% | 15% | €105.000–€158.000 | 108 | 54 |
| `subsidiary_vault_window` | 2 | 19m | 21m | 57% | 17.5% | €120.000–€182.000 | 116 | 58 |
| `reserve_vault_breach` | 3 | 38m | 36m | 46% | 25% | €305.000–€455.000 | 275 | 138 |
| `clearing_house_vault_run` | 3 | 36m | 38m | 44% | 26% | €320.000–€480.000 | 285 | 142 |

Partial/fail/split/regels blijven gelijk aan [CREW_MISSIONS_PHASE1_2026-04-23.md](CREW_MISSIONS_PHASE1_2026-04-23.md). Tier-unlocks ongewijzigd (Phase 1).

## Afbeeldingen (Leonardo)

- **Script:** `backend/scripts/generate_crew_missions_images_leonardo.py`
- **Output (standaard):** `runtime/client-images/crew_missions/cards/<missionKey>.png` en `.../scenes/<missionKey>.png`
- **Optioneel:** `--mirror-client-assets` kopieert naar `client/assets/images/crew_missions/{cards,scenes}/` (handig voor gebundelde builds).

### Run (lokaal of op VPS waar `LEONARDO_API_KEY` staat)

```bash
cd backend
python scripts/generate_crew_missions_images_leonardo.py --confirm-batch YES
```

Optioneel: `--force` om bestaande PNG’s te overschrijven, `--mirror-client-assets` om client-assets te vullen.

Zie ook: [CREW_MISSION_CLEARING_HOUSE_VAULT_2026-04-26.md](CREW_MISSION_CLEARING_HOUSE_VAULT_2026-04-26.md) (thema- en flavor-notities clearing house).

## QA (minimaal)

- Start/resolve/claim per nieuwe `missionKey` (minstens één Tier 1 en één Tier 3).
- Ontbrekende image: client valt terug op bestaande fallback-keten; na generatie controleren of kaarten laden.
- NL/EN help bijgewerkt (`help_content.dart`).
