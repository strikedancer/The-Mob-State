# Trade Goods Protocol

## Scope
Market prices, buy or sell flow, inventory linkage and country-aware trade logic.

## Image pipeline (optional)
- Leonardo one-shot script: `backend/scripts/generate_trade_goods_card_images_leonardo.py` (`LEONARDO_API_KEY` in `backend/.env.local`; see **PROTOCOL_MASTER** → *AI Keys & One-Shot Leonardo Workflow*).
- Default output: `runtime/client-images/trade_goods/cards/<good_id>.png` (same host tree as nginx `/images/` / backend `/client/images`).
- The client loads thumbnails via `WebAssetHelper.image('assets/images/trade_goods/cards/<good_id>.png')` with gradient+emoji fallback if the file is missing.
- Use `--mirror-client-assets` after generation if you want bundled copies under `client/assets/images/trade_goods/cards/` for local builds without the external mount.
- **Production / VPS:** from repo root (Pageant + PuTTY session per PROTOCOL_MASTER): `.\scripts\upload_trade_goods_images_to_vps.ps1 -PuttySession "server vps"` — copies local `runtime/client-images/trade_goods/cards/*.png` to `CLIENT_EXTERNAL_IMAGES_PATH` on the server (`trade_goods/cards/`).

## Resilience & copy
- Market data is loaded in segments (`/trade/goods`, `/trade/prices`, `/trade/inventory`). Partial failures show a banner; a fatal empty state only occurs when all three fail.
- New user-facing strings use `trade*` ARB keys; keep **verify_arb_parity** green after edits (`node scripts/verify_arb_parity.mjs`).

## Primary Frontend Entry
- client/lib/screens/trade_screen.dart

## Change Rules
- Preserve the core player loop and avoid hidden behavior changes.
- Keep Dutch and English copy in sync for any user-visible change.
- Keep layout usable on mobile, tablet and desktop if this module is reachable in the dashboard shell.
- Do not silently remove existing rewards, cooldowns or risk gates without updating help and release notes.

## Check Before Editing
- What is the player trying to achieve in this screen or loop?
- Which timers, locks, rank gates or country rules affect the flow?
- Does this module send notifications, inbox messages, rewards or achievements?
- Does this module depend on assets, videos, icons or generated media?

## Must Preserve
- Clear success and failure feedback for the player.
- Accurate state refresh after an action completes.
- Consistent formatting for money, timers, percentages and labels.
- Responsive usability without pushing critical actions off-screen.

## i18n and Messaging
- Any new labels, warnings, helper text or dialogs must exist in **app_en.arb** and every active locale ARB; run `node scripts/merge_arb_missing_all_from_en.mjs`, translate fallbacks where needed, then `flutter gen-l10n` and `node scripts/verify_arb_parity.mjs`.
- Curate **NL** (`app_nl.arb`) for game terminology; do not blindly overwrite good DE/FR/IT/PL/PT/ES strings when batch-translating.
- If this module emits notifications, push messages or inbox events, keep the wording aligned across all channels.
- If player behavior changes, update **scripts/_help_topics_extracted.json** (trade topic) and/or run `node scripts/apply_help_topics_l10n.mjs` so Help stays aligned with ARB.

## QA Checklist
- Open the module on mobile width, tablet width and desktop width.
- Run through the main success path and at least one failure or locked-state path.
- Verify the screen refreshes correctly after actions.
- Verify cooldowns, counters, balances or progress bars remain accurate.
- Verify no text overflows or clipped buttons appear.

## When To Update This File
Update this protocol when the module gains a new subflow, new dependency, new notification path, major UX change or new QA risk.
