# Leonardo Image Generation Protocol (Reusable Attachment)

Use this protocol for all future image-generation requests in this repository.

This file is the single source of truth for:
- achievement badges
- UI icons/emblems
- item/asset renders
- full-screen backgrounds
- vehicle renders (cars, boats, motorcycles)
- TuneShop UI backgrounds and emblem assets

Any new image request must follow this protocol first.

## 1) Scope

This runbook is the canonical workflow for generating:
- responsive backgrounds (mobile/tablet/desktop)
- responsive UI emblems/icons (mobile/tablet/desktop)
- responsive achievement badges (mobile/tablet/desktop)
- transparent item/coin icons
- vehicle renders (cars, boats, motorcycles) with new/dirty/damaged variants

Model default:
- `gpt-image-1.5`

## 1.1) Mandatory Consistency Rule

All generated images must align with the same visual world.
No image is treated as standalone art.

This means every prompt should preserve:
- mafia noir atmosphere
- premium crime empire tone
- consistent material language (metal, neon accents, cinematic contrast)
- consistent color family (see theme palette below)

If an image looks generic, cartoonish, or from a different game universe, reject and regenerate.

## 1.2) Achievement Badge Authority

This protocol is also the authority for achievement badge generation.

Rules for all achievement badges:
- same badge silhouette style family
- same lighting philosophy (rim light + depth)
- same material quality (polished metal + subtle texture)
- same saturation range (no random outlier palettes)
- no text in badge art
- no watermark or logo

If a badge violates the shared style family, regenerate.

## 1.3) Vehicle Rendering Rules (Cars, Boats, Motorcycles)

Vehicle image assets must follow these requirements:
- Realistic look only (no cartoon/anime/toy styling).
- Each vehicle needs 3 condition states:
  - new
  - dirty
  - damaged
- Each state requires responsive derivatives:
  - mobile
  - tablet
  - desktop
- Keep naming stable from `backend/content/vehicles.json` fields:
  - `image`
  - `imageNew`
  - `imageDirty`
  - `imageDamaged`

Project scripts for this pipeline:
- `backend/scripts/generate_vehicle_images_leonardo.py`
- `backend/scripts/build_vehicle_responsive_variants.py`
- `backend/scripts/prepare_vehicle_image_placeholders.py`
- `backend/scripts/fix_vehicle_backgrounds.py`
- `backend/scripts/audit_vehicle_images.py`

Recommended workflow:
1. Expand catalog first.
2. Fill missing placeholders for immediate runtime stability.
3. Generate real Leonardo images in controlled batches.
4. Build responsive derivatives.
5. Validate files exist for every catalog entry.
6. If alpha looks fake, run the free local recut before responsive rebuild.

Vehicle command examples:

```powershell
Set-Location C:\xampp\htdocs\mafia_game
$env:LEONARDO_API_KEY="<your-key>"
python .\backend\scripts\expand_vehicle_catalog.py
python .\backend\scripts\prepare_vehicle_image_placeholders.py
python .\backend\scripts\generate_vehicle_images_leonardo.py --estimate-only --category motorcycle --states new,dirty,damaged --limit 20
python .\backend\scripts\generate_vehicle_images_leonardo.py --category car --states new,dirty,damaged --limit 20 --attempts 1
python .\backend\scripts\generate_vehicle_images_leonardo.py --category boat --states new,dirty,damaged --limit 10 --attempts 1
python .\backend\scripts\generate_vehicle_images_leonardo.py --category motorcycle --states new,dirty,damaged --limit 20 --attempts 1
python .\backend\scripts\fix_vehicle_backgrounds.py --force-recut
python .\backend\scripts\build_vehicle_responsive_variants.py
python .\backend\scripts\audit_vehicle_images.py
```

Safety rules for vehicle runs:
- Always run `--estimate-only` first.
- Never use `--category all --force` unless you intentionally want a full paid rerender.
- Prefer `--attempts 1` for first-pass budget control.
- Use small chunks with `--limit` before scaling up.
- The generator now blocks broad expensive runs unless `--confirm-batch YES` is explicitly passed.

For large full-catalog refreshes, run one category at a time and resume in chunks:

```powershell
Set-Location C:\xampp\htdocs\mafia_game
$env:LEONARDO_API_KEY="<your-key>"
# cars
python .\backend\scripts\generate_vehicle_images_leonardo.py --estimate-only --category car --states new,dirty,damaged --start-index 0 --limit 40
python .\backend\scripts\generate_vehicle_images_leonardo.py --category car --states new,dirty,damaged --start-index 0 --limit 40 --attempts 1 --sleep 1 --force --confirm-batch YES
python .\backend\scripts\generate_vehicle_images_leonardo.py --category car --states new,dirty,damaged --start-index 40 --limit 40 --attempts 1 --sleep 1 --force --confirm-batch YES
# boats
python .\backend\scripts\generate_vehicle_images_leonardo.py --estimate-only --category boat --states new,dirty,damaged
python .\backend\scripts\generate_vehicle_images_leonardo.py --category boat --states new,dirty,damaged --attempts 1 --sleep 1 --force --confirm-batch YES
# motorcycles
python .\backend\scripts\generate_vehicle_images_leonardo.py --estimate-only --category motorcycle --states new,dirty,damaged
python .\backend\scripts\generate_vehicle_images_leonardo.py --category motorcycle --states new,dirty,damaged --attempts 1 --sleep 1 --force --confirm-batch YES
python .\backend\scripts\fix_vehicle_backgrounds.py --force-recut
python .\backend\scripts\build_vehicle_responsive_variants.py
python .\backend\scripts\audit_vehicle_images.py
```

## 2) API Key Configuration

Provided key for this project:
- `LEONARDO_API_KEY=540963ec-4946-49df-8f00-d86ac41e2c74`

PowerShell session setup:

```powershell
Set-Location C:\xampp\htdocs\mafia_game
$env:LEONARDO_API_KEY="540963ec-4946-49df-8f00-d86ac41e2c74"
```

Validation command:

```powershell
python -c "import os; print('KEY_OK', bool(os.getenv('LEONARDO_API_KEY')))"
```

## 2.1) Security Note

This file currently includes a key because you explicitly requested that setup.
For long-term safety, prefer storing keys in environment variables or secret managers, and rotate keys periodically.

## 3) Confirmed API Behavior (March 31, 2026)

1. Working transparency generation endpoint:
   - `https://cloud.leonardo.ai/api/rest/v1/generations`
2. Working generation status endpoint:
   - `https://cloud.leonardo.ai/api/rest/v1/generations/{generationId}`
3. Successful transparency generationId path:
   - `response.sdGenerationJob.generationId`
4. Generation status payload path:
   - `response.generations_by_pk.status`
   - first image URL at `response.generations_by_pk.generated_images[0].url`
   - first image ID at `response.generations_by_pk.generated_images[0].id`
5. Working no-background creation endpoint:
   - `https://cloud.leonardo.ai/api/rest/v1/variations/nobg`
6. Successful no-background job ID path:
   - `response.sdNobgJob.id`
7. Working no-background status endpoint:
   - `https://cloud.leonardo.ai/api/rest/v1/variations/{variationId}`
8. Variation result payload path:
   - `response.generated_image_variation_generic[0].status`
   - final image URL at `response.generated_image_variation_generic[0].url`
9. Leonardo can return `.jpg` image URLs even when PNG/alpha is requested.

## 3.1) Official Leonardo References (Must Reuse)

Primary docs entry:
- https://docs.leonardo.ai/docs/getting-started

High-value references for this project:
- Transparency guide: https://docs.leonardo.ai/docs/generate-images-using-transparency
- Queue/rate limits: https://docs.leonardo.ai/docs/guide-to-concurrency-queue-and-rate-limit
- API error messages: https://docs.leonardo.ai/docs/api-error-messages
- API reference: https://docs.leonardo.ai/reference
- No background variation endpoint: https://docs.leonardo.ai/reference/createvariationnobg
- Common model list: https://docs.leonardo.ai/docs/list-of-models

When failures repeat, always cross-check these pages first before changing prompts/scripts.

## 3.2) Endpoint Compatibility Note (Important)

Leonardo documentation includes both v1 and v2 examples.

Project default for transparent badges/icons (current working flow):
- submit jobs via `v1` transparency endpoint
- poll generation via `v1` endpoint
- if alpha is dirty, run `variations/nobg`
- poll variation via `v1` variation endpoint

Crypto shield script behavior:
- `generate_crypto_badges_leonardo.py` uses Leonardo `v2` generate payload when model is a name (for example `gpt-image-1.5`)
- it keeps `v1` status polling + `variations/nobg` cleanup for transparency enforcement
- when model is a UUID, it uses the legacy `v1` generate payload with `modelId`

Do not mix payload schemas between versions.
If switching endpoint version, update payload structure and response parsing together.

## 4) Proven Request Shape (v2)

```json
{
   "model": "gpt-image-1.5",
  "parameters": {
    "width": 1024,
    "height": 1024,
    "prompt": "<your prompt>",
    "quantity": 1,
    "prompt_enhance": "OFF"
  },
  "public": false
}
```

Headers:
- `Authorization: Bearer <LEONARDO_API_KEY>`
- `Content-Type: application/json`

## 5) Polling + Retry Rules

- Poll interval: 2-3 seconds.
- Max poll window per image: 6-10 minutes.
- Stop when status is `COMPLETE` or `FAILED`.
- On `FAILED`: log final JSON payload for diagnostics.
- Retry budget per file: up to 3 full attempts.

If queue is unstable:
- generate one file at a time
- wait 5-10 seconds between files
- prioritize critical assets first

## 6) Batch Order (Most Stable)

1. Desktop background
2. Mobile background
3. Tablet background
4. UI emblem
5. Badges (one by one)
6. Small icons (one by one)

Do not launch large parallel batches.

## 6.1) Retry Strategy for Queue Instability

If Leonardo queue is unstable:
1. Run single-file generation only.
2. Retry same file up to 3 attempts.
3. Wait 10-20 seconds between attempts.
4. Move to next file only after success or max retries.
5. Re-run failed list later in a clean pass.

## 6.2) Fast Preview Workflow (Recommended)

If generation feels too slow, do not start a full batch first.

Use this order:
1. Generate one single asset as preview.
2. Validate style/alpha/format.
3. Only then generate the remaining set.

For badges specifically, prefer a quick preview mode first:

```powershell
Set-Location C:\xampp\htdocs\mafia_game
$env:LEONARDO_API_KEY="540963ec-4946-49df-8f00-d86ac41e2c74"
python .\generate_crypto_badges_leonardo.py --single crypto_first_trade.png --quick --model gpt-image-1.5
```
For the full set run (all 6 crypto achievement shields) via Leonardo API:

```powershell
Set-Location C:\xampp\htdocs\mafia_game
$env:LEONARDO_API_KEY="540963ec-4946-49df-8f00-d86ac41e2c74"
python .\generate_crypto_badges_leonardo.py --model gpt-image-1.5 --attempts 3
```

Quick mode should be fail-fast:
- one file only
- one attempt only
- if result is JPEG or non-transparent, stop immediately and adjust prompt/workflow

Why this helps:
- faster feedback loop
- less waiting on full batches
- easier debugging when a prompt or queue issue occurs

## 7) No-Background Assets (Badges/Icons) - Strict Rules

For every asset that must have no background, prompt MUST include this style block:

`CRITICAL: True RGBA PNG with functional alpha channel. Every pixel outside the subject silhouette must be fully transparent (alpha 0). No background plate, no gradient, no vignette, no fog, no glow cloud, no fake transparency.`

### Acceptance Criteria (mandatory)

For badges/icons with no background:
1. File has alpha channel (`RGBA`), not plain `RGB`.
2. Corner pixels have alpha `0`.
3. No soft glow haze outside silhouette.
4. No checkerboard baked into the image.
5. If response URL is `.jpg`, result is rejected and regenerated.

### Rejection Rules

Reject and regenerate if any of these occur:
- `.jpg` output for transparency-required asset
- opaque background
- semi-opaque fog/vignette outside subject
- subject cropped or clipped

## 7.1) Transparency QA Script Guidance

For transparency-required outputs, always verify:
- mode is RGBA
- alpha exists and is functional
- corners are fully transparent (`alpha=0`)
- no hidden matte edges around silhouette

If needed, run a post-check with Pillow and reject files that fail QA.

## 7.2) Remove Background Fallback (Recommended for Badges/Icons)

Yes, Leonardo can also be used for background removal as a fallback path.

Preferred order for no-background assets:
1. Try direct transparency generation first.
2. Validate alpha quality.
3. If corners are not alpha 0, or if the cutout is semi-transparent/dirty, use Leonardo's official `Create no background` workflow as a second pass.

Use this especially for:
- achievement badges
- UI icons
- emblems
- item renders

When to trigger fallback:
- output is RGBA but corners are not truly transparent
- subject has a dark haze around it
- background is partially removed but still visible

Rule:
- A badge/icon is not accepted until either direct transparency generation or no-background fallback produces a clean alpha cutout.

### Proven nobg request shape

```json
{
   "id": "<generated image id>",
   "isVariation": false
}
```

Operational rule:
- first generate image
- inspect alpha
- if corners/edge samples are not alpha 0, call `variations/nobg`
- poll until `generated_image_variation_generic[0].status == COMPLETE`
- download `generated_image_variation_generic[0].url`
- reject if fallback output is still JPEG or still has dirty alpha

## 8) Opaque Background Assets Rules

For full-screen backgrounds (desktop/mobile/tablet):
- background is expected (not transparent)
- no text/watermark/logo
- composition must match target aspect usage

## 8.1) Background Composition Rules

Backgrounds should support UI readability:
- center-left or center-right detail clustering, not visual noise everywhere
- avoid pure white hotspots behind likely text/card zones
- keep depth layers so UI overlays remain legible
- no hard text/logo elements in scene

## 9) Recommended Dimensions

- Mobile background: `1024x1365`
- Tablet background: `1365x1024`
- Desktop background: `1536x1024`
- Badge/Icon: `1024x1024`

These dimensions are validated with the current Leonardo `gpt-image-1.5` workflow.

Reason for these values:
- Leonardo `gpt-image-1.5` requires a minimum dimension of `1024` on both sides.
- Legacy sizes like `768x1024` and `1024x768` can fail validation on this model.

## 9.1) Style DNA (Game Theme)

Core theme keywords:
- mafia noir
- organized crime luxury
- cinematic, high-contrast, premium UI
- urban night atmosphere

Preferred art direction:
- realistic-stylized (not flat cartoon)
- dramatic but clean silhouette readability
- premium game UI iconography

Avoid:
- childish/cartoon rendering
- pastel playful palettes
- low-contrast muddy outputs
- over-busy clutter that fights UI

## 9.2) Canonical Color System

Use these as anchor tones across prompts:

Primary neutrals:
- Obsidian: `#0B0F14`
- Gunmetal: `#1A232D`
- Steel: `#5B6673`

Core accents:
- Emerald (success/profit): `#00C98D`
- Amber (wealth/elite): `#D9A441`
- Crimson (danger/heat): `#C63B3B`
- Electric Cyan (tech market accents): `#33C7FF`

Glow restraint:
- glow must support silhouette, never wash out subject
- no huge bloom clouds around object boundaries

## 9.3) Category-to-Color Mapping

Use stable color accents by image type:
- Crypto: emerald + cyan + gunmetal
- Drugs: toxic green + amber + dark steel
- Nightclub: teal + magenta accents over deep navy/black
- Weapons/Combat: steel + crimson accents
- Travel/Utility: cyan + steel neutral
- Achievement legendary tiers: amber/gold highlights (controlled)

Do not randomly change category palette between batches.

## 9.4) Prompt Scaffolds (Copy/Paste)

### A) Transparent badge scaffold

`Premium mafia game achievement badge, [subject], polished metallic emblem, cinematic rim lighting, high contrast, centered composition, no text, no watermark. CRITICAL: True RGBA PNG with functional alpha channel. Every pixel outside subject silhouette must be fully transparent (alpha 0). No background plate, no vignette, no fog, no glow cloud, no fake transparency.`

### B) Transparent icon scaffold

`Game UI icon for [subject], premium stylized-realistic render, clean silhouette, centered, no text, no watermark. CRITICAL: True RGBA PNG with full transparent background alpha 0 outside icon.`

### C) Opaque background scaffold

`Cinematic mafia noir environment for game UI background, [location], premium lighting, layered depth, no text, no logo, composition optimized for [mobile/tablet/desktop], readable UI zones.`

## 10) Quick Diagnostics

### 401 Unauthorized
- API key missing/invalid in environment.

### 400 Bad Request
- wrong payload shape or unsupported fields.

### Endless `PENDING` then `FAILED`
- Leonardo queue-side issue; retry sequentially with delay.

### `COMPLETE` but wrong format (jpg/no alpha)
- generation succeeded but violates asset requirements; reject and regenerate.

### Works once, then repeated pending/failed
- Usually queue or concurrency pressure; run strict sequential single-job mode.
- Re-check queue/rate-limit guide before increasing parallelism.

## 11) Minimal Run Checklist

Before run:
- Set API key in active terminal session.
- Confirm output paths exist or can be created.

After run:
- Verify files exist at expected paths.
- Verify dimensions match target class.
- Verify alpha for no-background assets.
- Regenerate failed/rejected files only.

## 11.1) Cross-Batch Consistency Checklist

Before accepting a batch, compare against previous approved assets:
- same contrast level
- same material finish style
- same category palette intent
- same subject scale and framing behavior
- same transparency quality (if required)

If visual drift is detected, regenerate outliers.

## 11.2) Crypto Shield Acceptance Checklist (Leonardo API)

Approve the 6 crypto achievement shields only if all items below pass:

1. Silhouette family match:
- shield outline language is consistent across all 6 files
- no coin-only, token-only, or loose object compositions

2. Material and depth match:
- metallic rim readability remains strong at 1x UI scale
- center icon has clear depth separation from shield body

3. Color-system compliance:
- crypto accents stay in emerald/cyan/gunmetal range
- no random hue drift that breaks category identity

4. Transparency integrity:
- PNG is RGBA
- border sample points are alpha 0
- no haze, matte fringe, or dirty edge glow

5. Production readiness:
- exported filenames exactly match required 6 target files
- no text/watermark/logo artifacts
- no clipping/cropping of shield silhouette

Scoring suggestion:
- pass if at least 5/6 files meet all criteria
- regenerate only failing outliers to keep style consistency

## 12) Required Input Template for Future Requests

When asking for image generation, include:
- filename
- destination path
- target size
- asset type: `background` or `transparent`
- style summary
- model (`gpt-image-1.5` unless changed)

Example line:
- `crypto_hub_emblem.png | client/assets/images/ui/crypto_hub_emblem.png | 1024x1024 | transparent | metallic blockchain emblem`

## 12.1) Mandatory Request Add-ons

Every future request should also include:
- category (crypto/drugs/nightclub/weapons/etc.)
- target palette from section 9.2/9.3
- style scaffold type (badge/icon/background)
- transparency requirement (`strict-alpha` or `opaque-bg`)

---

This document is the standard attachment to include whenever new Leonardo image generation is requested in this project.
