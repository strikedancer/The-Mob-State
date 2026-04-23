# Premium Tiles Images - External Hosting Guide

Dit document borgt de vaste image-workflow voor het Premium & Credits scherm.

## Doel
- Premium/Credits tiles visueel in game-stijl houden.
- Per aankooptype duidelijke beeldtaal (VIP, credits, bescherming, repairs, boosts).
- Externe hosting blijven gebruiken zodat client build klein blijft.

## Pad en naming (verplicht)

Doelmap:
- `runtime/client-images/premium_tiles/`

Bestandsnamen:
1. `player_vip.png`
2. `crew_vip.png`
3. `credits_250.png`
4. `credits_500.png`
5. `credits_1000.png`
6. `credits_2500.png`
7. `shop_cash_bundle.png`
8. `shop_hit_protection.png`
9. `shop_vehicle_repair.png`
10. `shop_tune_reset.png`
11. `shop_cooldown_reset.png`
12. `shop_event_boost.png`

Deze namen zijn gekoppeld aan de client mapping in `client/lib/screens/premium_screen.dart`.

## Generator script

Script:
- `backend/scripts/generate_premium_tiles_leonardo.py`

Estimate-only:

```bash
python backend/scripts/generate_premium_tiles_leonardo.py --estimate-only
```

Echte run:

```bash
python backend/scripts/generate_premium_tiles_leonardo.py --confirm-batch YES --force
```

Optioneel mirroren naar client assets:

```bash
python backend/scripts/generate_premium_tiles_leonardo.py --confirm-batch YES --force --mirror-client-assets
```

## VPS one-shot runbook (PuTTY)

```bash
cd /var/www/vhosts/themobstate.com/apps/mafia_game
git pull origin main
set -a
. ./.env.plesk
set +a
python3 backend/scripts/generate_premium_tiles_leonardo.py --confirm-batch YES --force
docker compose --env-file .env.plesk -f docker-compose.plesk.yml config
docker compose --env-file .env.plesk -f docker-compose.plesk.yml up -d --build --no-deps client
docker compose --env-file .env.plesk -f docker-compose.plesk.yml logs --tail=120 client
```

## Verificatie

Check minimaal:
1. `https://<host>/images/premium_tiles/player_vip.png`
2. `https://<host>/images/premium_tiles/crew_vip.png`
3. `https://<host>/images/premium_tiles/credits_250.png`
4. `https://<host>/images/premium_tiles/credits_500.png`
5. `https://<host>/images/premium_tiles/credits_1000.png`
6. `https://<host>/images/premium_tiles/credits_2500.png`
7. `https://<host>/images/premium_tiles/shop_hit_protection.png`

Als deze `200` teruggeven, pakt Premium & Credits de afbeeldingen automatisch.

## Stijl-richtlijn voor prompts

- Visuele taal: donker, cinematic, georganiseerde crime-game sfeer.
- Geen tekst in de afbeelding.
- Geen logo/watermark.
- Per tile moet het aankooptype direct herkenbaar zijn:
  - `player_vip` = individuele elite status
  - `crew_vip` = team/syndicaat/crew power
  - `credits_*` = premium currency bundels (250 / 500 / 1000 / 2500)
  - `shop_hit_protection` = bescherming/security
  - `shop_vehicle_repair` = garage/repair
  - `shop_tune_reset` = tuning reset
  - `shop_cooldown_reset` = tijd/cooldown reset
  - `shop_event_boost` = event-activiteit/boost
