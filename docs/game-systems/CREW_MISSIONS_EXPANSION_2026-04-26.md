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
- **Upload script (Windows):** `scripts/upload_crew_mission_images_to_vps.ps1` (Pageant + `pscp`/`plink`, zie onder *Upload naar VPS*).

### Run (lokaal of op VPS waar `LEONARDO_API_KEY` staat)

```bash
cd backend
python scripts/generate_crew_missions_images_leonardo.py --confirm-batch YES
```

Optioneel: `--force` om bestaande PNG’s te overschrijven, `--mirror-client-assets` om client-assets te vullen.

### Upload naar VPS (externe image map, PROTOCOL_MASTER)

`docker-compose.plesk.yml` mount standaard:

`CLIENT_EXTERNAL_IMAGES_PATH` → **`/var/www/vhosts/themobstate.com/apps/mafia_game/runtime/client-images`** → in de container **`/client/images`**.

Crew mission PNG’s horen daar onder:

- `.../runtime/client-images/crew_missions/cards/<missionKey>.png`
- `.../runtime/client-images/crew_missions/scenes/<missionKey>.png`

**Windows (Pageant + PuTTY):** na generatie lokaal, upload met:

```powershell
cd C:\xampp\htdocs\mafia_game
.\scripts\upload_crew_mission_images_to_vps.ps1 -PuttySession "server vps"
```

- Gebruik **exact** de opgeslagen sessienaam uit PuTTY (in veel setups heet die **`server vps`**, niet per se `vps server`).
- Pageant moet je private key geladen hebben; de sessie bevat proxy/poort/key zoals in PuTTY opgeslagen.
- Als de registry geen host vindt voor je sessienaam: `-SshHost "jouw.ip.of.hostnaam"`.
- Eerste connectie: host key accepteren kan nodig zijn (één keer interactief via PuTTY GUI met dezelfde sessie), daarna werkt `-batch` op `plink`/`pscp`.

Als `CLIENT_EXTERNAL_IMAGES_PATH` op de server **afwijkt**, pas `-RemoteBase` aan op het pad dat compose echt mount.

Zie ook: [CREW_MISSION_CLEARING_HOUSE_VAULT_2026-04-26.md](CREW_MISSION_CLEARING_HOUSE_VAULT_2026-04-26.md) (thema- en flavor-notities clearing house).

### VPS: `git pull` + Docker build (PROTOCOL_MASTER)

Volledige flow (backup, pull, `docker compose config`, rebuild **backend** + **client**, logs) kun je lokaal draaien met Pageant + PuTTY **`plink`**:

```powershell
cd C:\xampp\htdocs\mafia_game
.\scripts\vps_pull_and_build.ps1 -PuttySession "server vps"
```

Draai dit in een **normaal PowerShell-venster** (Pageant aan). Het script gebruikt **geen** `plink -batch`, zodat eventuele **proxy- of PuTTY-prompts** beantwoord kunnen worden; vanuit niet-interactieve omgegingen (zoals sommige IDE-terminals) kan `plink` daardoor vastlopen.

Pas `-ProjectDir` aan als je clone op de VPS een ander pad heeft. Zie `docs/module-protocols/PROTOCOL_MASTER.md` (PuTTY / Plesk Update Runbook) voor de achterliggende eisen.

## QA (minimaal)

- Start/resolve/claim per nieuwe `missionKey` (minstens één Tier 1 en één Tier 3).
- Ontbrekende image: client valt terug op bestaande fallback-keten; na generatie controleren of kaarten laden.
- NL/EN help bijgewerkt (`help_content.dart`).
