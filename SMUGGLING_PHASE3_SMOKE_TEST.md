# Smuggling Phase 3 Smoke Test

This validates the current Phase 3 behavior:
- catalog personal/crew
- overview
- quote (fee/eta/risk + recommendation)
- optional cooldown enforcement on send

## Quick Run (Safe, Non-Destructive)

```powershell
python tools/smuggling_phase3_smoke_test.py --base-url http://localhost:3000 --username YOUR_USER --password YOUR_PASS
```

or with token:

```powershell
python tools/smuggling_phase3_smoke_test.py --base-url http://localhost:3000 --token YOUR_JWT
```

## Cooldown Validation (Destructive)

This does two quick sends and expects the second one to fail on cooldown.

```powershell
python tools/smuggling_phase3_smoke_test.py --base-url http://localhost:3000 --username YOUR_USER --password YOUR_PASS --run-send-test
```

## Expected Results

- `Catalog personal`: PASS
- `Catalog crew`: PASS (or account not in crew, still valid response)
- `Overview`: PASS
- `Quote personal`: PASS
- `Quote crew`: PASS or SKIPPED (no crew item / no crew membership)
- with `--run-send-test`:
  - `Send #1`: PASS
  - `Send #2 cooldown`: PASS (blocked with message containing `Wacht`)

## Notes

- Send test consumes inventory and cash.
- Vehicle send tests are intentionally excluded from automatic smoke to avoid high-impact changes.
- If no suitable inventory exists, quote/send tests fail with a clear message.
