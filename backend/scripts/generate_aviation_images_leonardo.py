#!/usr/bin/env python3
"""Generate aviation images via Leonardo API into external runtime storage.

Creates aircraft images and aviation background images directly in:
  runtime/client-images/

This keeps client Docker builds small because images are served from
the external mount (/mnt/external-images) via nginx aliases.
"""

from __future__ import annotations

import argparse
import os
import time
from io import BytesIO
from pathlib import Path
from typing import Dict, List, Tuple

import requests
try:
    from PIL import Image
    from PIL import ImageOps
except Exception:  # noqa: BLE001
    Image = None
    ImageOps = None

try:
    from rembg import remove as rembg_remove
except Exception:  # noqa: BLE001
    rembg_remove = None


ROOT = Path(__file__).resolve().parents[2]
LOCAL_ENV_PATH = ROOT / "backend" / ".env.local"


def _load_local_env_value(key: str) -> str:
    if not LOCAL_ENV_PATH.exists():
        return ""
    for raw_line in LOCAL_ENV_PATH.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        name, value = line.split("=", 1)
        if name.strip() != key:
            continue
        return value.strip().strip('"').strip("'")
    return ""


API_KEY = os.getenv("LEONARDO_API_KEY", "") or _load_local_env_value("LEONARDO_API_KEY")
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL_V1 = "https://cloud.leonardo.ai/api/rest/v1/generations"
DEFAULT_MODEL = "gpt-image-1.5"

NEGATIVE_BG = "people, characters, logos, watermark, text, blurry, low quality"
NEGATIVE_CUTOUT = (
    "background scene, runway scene, people, text, logo watermark, frame,"
    " vignette, fake transparency, blur, low quality"
)


def _aviation_assets(output_root: Path) -> List[dict]:
    return [
        {
            "name": "aviation_bg_desktop",
            "out": output_root / "backgrounds" / "aviation_bg_desktop.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1792,
            "target_height": 1024,
            "transparent": False,
            "prompt": (
                "Ultra-realistic cinematic private airport hangar at night, premium aviation atmosphere, "
                "subtle amber and cool steel-blue lighting, runway reflections after light rain, "
                "tooling area and cargo pallets in distance, open center composition for UI readability, "
                "no people, no text, no logos"
            ),
            "negative": NEGATIVE_BG,
        },
        {
            "name": "aviation_bg_tablet",
            "out": output_root / "backgrounds" / "aviation_bg_tablet.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1536,
            "target_height": 1024,
            "transparent": False,
            "prompt": (
                "Ultra-realistic private terminal apron view, luxury business aviation mood, "
                "dramatic but clean lighting, realistic tarmac details, UI-safe negative space in center, "
                "no people, no text, no logos"
            ),
            "negative": NEGATIVE_BG,
        },
        {
            "name": "aviation_bg_mobile",
            "out": output_root / "backgrounds" / "aviation_bg_mobile.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1024,
            "target_height": 1536,
            "transparent": False,
            "prompt": (
                "Ultra-realistic vertical composition of an airport runway edge and hangar entrance at dusk, "
                "premium crime-game atmosphere, readable center space for mobile UI overlays, "
                "no people, no text, no logos"
            ),
            "negative": NEGATIVE_BG,
        },
        {
            "name": "aircraft_cessna",
            "out": output_root / "aircraft" / "cessna.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1024,
            "target_height": 1024,
            "transparent": True,
            "prompt": (
                "Ultra-realistic isolated aircraft render of Cessna 172 light propeller plane, "
                "clean metal body, detailed landing gear, centered full aircraft, "
                "CRITICAL: true RGBA PNG with real transparent alpha background only"
            ),
            "negative": NEGATIVE_CUTOUT,
        },
        {
            "name": "aircraft_king_air",
            "out": output_root / "aircraft" / "king_air.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1024,
            "target_height": 1024,
            "transparent": True,
            "prompt": (
                "Ultra-realistic isolated aircraft render of Beechcraft King Air twin-turboprop aircraft, "
                "high detail fuselage and propellers, centered full aircraft, "
                "CRITICAL: true RGBA PNG with real transparent alpha background only"
            ),
            "negative": NEGATIVE_CUTOUT,
        },
        {
            "name": "aircraft_gulfstream",
            "out": output_root / "aircraft" / "gulfstream.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1024,
            "target_height": 1024,
            "transparent": True,
            "prompt": (
                "Ultra-realistic isolated aircraft render of Gulfstream G200 business jet, "
                "luxury jet details, swept wings, centered full aircraft, "
                "CRITICAL: true RGBA PNG with real transparent alpha background only"
            ),
            "negative": NEGATIVE_CUTOUT,
        },
        {
            "name": "aircraft_cargo_737",
            "out": output_root / "aircraft" / "cargo_737.png",
            "width": 1024,
            "height": 1024,
            "target_width": 1024,
            "target_height": 1024,
            "transparent": True,
            "prompt": (
                "Ultra-realistic isolated aircraft render of Boeing 737 cargo plane, "
                "freighter variant, robust cargo aircraft silhouette, centered full aircraft, "
                "CRITICAL: true RGBA PNG with real transparent alpha background only"
            ),
            "negative": NEGATIVE_CUTOUT,
        },
    ]


def _headers() -> Dict[str, str]:
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "accept": "application/json",
    }


def _extract_generation_id(payload) -> str | None:
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None
    if payload.get("sdGenerationJob", {}).get("generationId"):
        return payload["sdGenerationJob"]["generationId"]
    if payload.get("generationId"):
        return payload["generationId"]
    generate = payload.get("generate", {})
    if isinstance(generate, dict) and generate.get("generationId"):
        return generate["generationId"]
    data = payload.get("data", {})
    if isinstance(data, dict) and data.get("generationId"):
        return data["generationId"]
    return None


def _extract_status_and_url(payload) -> Tuple[str | None, str | None]:
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None, None
    gen = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not gen:
        gen = payload.get("generation") or payload.get("data", {}).get("generation")
    if not gen:
        return None, None
    if isinstance(gen, list):
        gen = gen[0] if gen else {}
    if not isinstance(gen, dict):
        return None, None
    status = gen.get("status")
    images = gen.get("generated_images") or gen.get("images") or []
    if not images:
        return status, None
    first = images[0] if isinstance(images[0], dict) else {}
    return status, first.get("url") or first.get("imageUrl")


def _generate_one(prompt: str, negative: str, model: str, width: int, height: int) -> str:
    payload = {
        "model": model,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "negative_prompt": negative,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    create_resp = requests.post(GENERATE_URL_V2, headers=_headers(), json=payload, timeout=90)
    create_resp.raise_for_status()
    generation_id = _extract_generation_id(create_resp.json())
    if not generation_id:
        raise RuntimeError("No generation ID returned")

    for _ in range(240):
        poll_resp = requests.get(f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60)
        poll_resp.raise_for_status()
        status, image_url = _extract_status_and_url(poll_resp.json())
        if status == "FAILED":
            raise RuntimeError(f"Generation failed ({generation_id})")
        if status == "COMPLETE" and image_url:
            return image_url
        time.sleep(2)

    raise TimeoutError(f"Timed out waiting for {generation_id}")


def _save_image(url: str, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    img = requests.get(url, timeout=90)
    img.raise_for_status()
    out_path.write_bytes(img.content)


def _reshape_to_target(path: Path, target_width: int, target_height: int) -> None:
    if Image is None or ImageOps is None:
        # Pillow is optional on VPS. If missing, keep original generated size.
        return
    with Image.open(path) as im:
        fitted = ImageOps.fit(im.convert("RGBA"), (target_width, target_height), method=Image.Resampling.LANCZOS)
        fitted.save(path, format="PNG")


def _count_transparent_pixels(path: Path) -> int:
    if Image is None:
        return 0
    with Image.open(path) as im:
        rgba = im.convert("RGBA")
        alpha = rgba.getchannel("A")
        hist = alpha.histogram()
        return int(sum(hist[:255]))


def _ensure_transparency(path: Path) -> bool:
    if Image is None:
        return False
    if _count_transparent_pixels(path) >= 50:
        return True
    if rembg_remove is None:
        return False
    raw = path.read_bytes()
    out = rembg_remove(raw)
    with Image.open(BytesIO(out)) as removed:
        removed.convert("RGBA").save(path, format="PNG")
    return _count_transparent_pixels(path) >= 50


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate aviation images via Leonardo")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images"),
        help="External image root; defaults to runtime/client-images",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    assets = _aviation_assets(output_root)

    print(f"Output root: {output_root}")
    print(f"Planned generations: {len(assets)}")
    print("Targets:")
    for item in assets:
        print(f"- {item['name']} -> {item['out']}")

    if args.estimate_only:
        print("estimate-only: no images will be generated")
        return

    if not API_KEY:
        raise RuntimeError("LEONARDO_API_KEY is not set")

    if Image is None:
        print("warning: Pillow (PIL) is not installed. Skipping local resize/alpha validation checks.")

    if args.confirm_batch != "YES":
        raise RuntimeError("Safety stop: add --confirm-batch YES to run generation")

    for item in assets:
        out_path: Path = item["out"]

        if out_path.exists() and not args.force:
            print(f"skip (exists): {out_path}")
            continue

        last_error: Exception | None = None
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"generate [{item['name']}] attempt {attempt}/{args.attempts}")
                url = _generate_one(
                    prompt=item["prompt"],
                    negative=item["negative"],
                    model=args.model,
                    width=item["width"],
                    height=item["height"],
                )
                _save_image(url, out_path)

                target_width = int(item.get("target_width", item["width"]))
                target_height = int(item.get("target_height", item["height"]))
                _reshape_to_target(out_path, target_width, target_height)

                if item.get("transparent"):
                    ok = _ensure_transparency(out_path)
                    if not ok:
                        print("warning: transparency check failed (install rembg for auto-fix)")

                print(f"saved: {out_path}")
                last_error = None
                break
            except Exception as exc:  # noqa: BLE001
                last_error = exc
                print(f"error [{item['name']}] attempt {attempt}: {exc}")
                time.sleep(args.sleep)

        if last_error:
            raise last_error

    print("done")
    print("Next step: verify files via /images/backgrounds/* and /images/aircraft/* on the deployed domain.")


if __name__ == "__main__":
    main()
