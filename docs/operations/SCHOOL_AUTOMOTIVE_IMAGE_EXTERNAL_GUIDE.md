# School Automotive + Expanded Gates Images

Eenmalige Leonardo-run voor Automotive-track en nieuwe schoolgates.

## Generate

```bash
python backend/scripts/generate_school_automotive_images_leonardo.py --confirm-batch YES --mirror-client-assets
```

Outputs:
- `runtime/client-images/school/tracks/automotive_track.png`
- `runtime/client-images/school/gates/asset_drug_facility_purchase_gate.png`
- `runtime/client-images/school/gates/asset_nightclub_purchase_gate.png`
- `runtime/client-images/school/gates/asset_rld_purchase_gate.png`
- `runtime/client-images/school/gates/asset_rld_expansion_advanced_gate.png`
- `runtime/client-images/school/gates/asset_stock_trade_buy_gate.png`
- `runtime/client-images/school/gates/asset_crypto_trade_buy_gate.png`
- `runtime/client-images/school/gates/asset_hitlist_place_hit_gate.png`
- `runtime/client-images/school/gates/asset_vehicle_tune_advanced_gate.png`
- `runtime/client-images/school/gates/asset_chop_contract_claim_gate.png`

`--mirror-client-assets` kopieert dezelfde PNGs naar `client/assets/images/school/...` (fallback).

Web serveert via `SCHOOL_IMAGE_BASE_URL` / `${origin}/game-assets/school`.
`vps_pull_and_build.ps1` sync’t client school assets naar `runtime/client-images/school`.
