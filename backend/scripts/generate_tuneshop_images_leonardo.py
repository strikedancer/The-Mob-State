#!/usr/bin/env python3
"""Generate TuneShop images via Leonardo API.

Creates:
- client/assets/images/backgrounds/tuneshop_bg_desktop.png
- client/assets/images/backgrounds/tuneshop_bg_tablet.png
- client/assets/images/backgrounds/tuneshop_bg_mobile.png
- client/assets/images/ui/tuneshop_emblem.png
"""

from __future__ import annotations

import argparse
import os
import time
from io import BytesIO
from pathlib import Path
from typing import Dict, List, Tuple

import requests
from PIL import Image
from PIL import ImageOps

try:
    from rembg import remove as rembg_remove
except Exception:  # noqa: BLE001
    rembg_remove = None

ROOT = Path(__file__).resolve().parents[2]
API_KEY = os.getenv("LEONARDO_API_KEY", "")
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL_V1 = "https://cloud.leonardo.ai/api/rest/v1/generations"
DEFAULT_MODEL = "gpt-image-1.5"

ASSETS = [
    {
        "name": "tuneshop_bg_desktop",
        "out": ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_desktop.png",
        "width": 1024,
        "height": 1024,
        "target_width": 1792,
        "target_height": 1024,
        "transparent": False,
        "prompt": (
            "Ultra-realistic cinematic underground tuning garage interior at night, "
            "high-end performance workshop, neon amber and steel-blue accents, "
            "hydraulic lifts, tool walls, ECU tuning stations, performance parts racks, "
            "clean composition with open center area for UI readability, no people, no text, no logos"
        ),
        "negative": "people, characters, logos, watermark, text, blurry, low quality",
    },
    {
        "name": "tuneshop_bg_tablet",
        "out": ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_tablet.png",
        "width": 1024,
        "height": 1024,
        "target_width": 1536,
        "target_height": 1024,
        "transparent": False,
        "prompt": (
            "Ultra-realistic tuning garage control bay, dramatic lighting, "
            "organized performance parts, balancing dark premium atmosphere and UI-safe empty space, "
            "no people, no text, no logos"
        ),
        "negative": "people, characters, logos, watermark, text, blurry, low quality",
    },
    {
        "name": "tuneshop_bg_mobile",
        "out": ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_mobile.png",
        "width": 1024,
        "height": 1024,
        "target_width": 1024,
        "target_height": 1536,
        "transparent": False,
        "prompt": (
            "Ultra-realistic vertical framing of premium tuning workshop, "
            "deep perspective, industrial details, moody amber-blue lighting, "
            "UI-friendly center zone, no people, no text, no logos"
        ),
        "negative": "people, characters, logos, watermark, text, blurry, low quality",
    },
    {
        "name": "tuneshop_emblem",
        "out": ROOT / "client" / "assets" / "images" / "ui" / "tuneshop_emblem.png",
        "width": 1024,
        "height": 1024,
        "transparent": True,
        "prompt": (
            "Premium metallic tuning emblem icon, crossed wrench and turbo silhouette, "
            "high-detail chrome and brushed steel, centered, isolated object, "
            "CRITICAL: True RGBA PNG with functional alpha channel. Every pixel outside the subject silhouette "
            "must be fully transparent (alpha 0). No background plate, no gradient, no vignette, "
            "no glow cloud, no fake transparency."
        ),
        "negative": "background, frame, vignette, gradient plate, people, text, logo watermark",
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
    with Image.open(path) as im:
        fitted = ImageOps.fit(im.convert("RGBA"), (target_width, target_height), method=Image.Resampling.LANCZOS)
        fitted.save(path, format="PNG")


def _count_transparent_pixels(path: Path) -> int:
    with Image.open(path) as im:
        rgba = im.convert("RGBA")
        alpha = rgba.getchannel("A")
        hist = alpha.histogram()
        return int(sum(hist[:255]))


def _ensure_transparency(path: Path) -> bool:
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
    parser = argparse.ArgumentParser(description="Generate TuneShop images via Leonardo")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    planned = len(ASSETS)
    print(f"Planned generations: {planned}")
    print("Targets:")
    for item in ASSETS:
        print(f"- {item['name']} -> {item['out']}")

    if args.estimate_only:
        print("estimate-only: no images will be generated")
        return

    if not API_KEY:
        raise RuntimeError("LEONARDO_API_KEY is not set")

    if args.confirm_batch != "YES":
        raise RuntimeError("Safety stop: add --confirm-batch YES to run generation")

    success = 0
    skipped = 0
    failed = 0

    for item in ASSETS:
        out_path: Path = item["out"]
        if out_path.exists() and not args.force:
            skipped += 1
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                url = _generate_one(item["prompt"], item["negative"], args.model, item["width"], item["height"])
                _save_image(url, out_path)
                target_w = int(item.get("target_width", item["width"]))
                target_h = int(item.get("target_height", item["height"]))
                if target_w != item["width"] or target_h != item["height"]:
                    _reshape_to_target(out_path, target_w, target_h)
                if item.get("transparent", False):
                    if not _ensure_transparency(out_path):
                        raise RuntimeError("Emblem output has no true transparency")
                generated = True
                success += 1
                break
            except Exception as exc:  # noqa: BLE001
                print(f"  attempt failed: {exc}")
                if attempt < args.attempts:
                    time.sleep(args.sleep)

        if not generated:
            failed += 1

        time.sleep(args.sleep)

    print("--- Done ---")
    print(f"generated: {success}")
    print(f"skipped: {skipped}")
    print(f"failed: {failed}")


if __name__ == "__main__":
    main()
