#!/usr/bin/env python3
"""Generate motorcycle achievement badges via Leonardo API.

Creates:
- client/assets/images/achievements/badges/vehicles/two_wheel_bandit.png
- client/assets/images/achievements/badges/vehicles/bike_cartel.png

Design constraints (mobile/tablet/desktop):
- 1024x1024 source for crisp downscaling
- high-contrast emblem in center safe-zone
- transparent background with alpha channel
"""

from __future__ import annotations

import argparse
import os
import time
from io import BytesIO
from pathlib import Path
from typing import Dict, Tuple

import requests
from PIL import Image

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

BASE_PROMPT = (
    "Premium mafia mobile-game achievement badge, exact shield silhouette style, "
    "polished enamel and brushed metal, centered icon, ultra-clear readability at small size, "
    "isolated object, transparent background alpha channel, no text"
)

NEGATIVE_PROMPT = (
    "background, gradient background, scene, city, people, text, letters, watermark, "
    "card frame, vignette, floor shadow, blurry, noisy details"
)

ASSETS = [
    {
        "name": "two_wheel_bandit",
        "out": ROOT / "client" / "assets" / "images" / "achievements" / "badges" / "vehicles" / "two_wheel_bandit.png",
        "prompt": (
            f"{BASE_PROMPT}, centered emblem: aggressive street motorcycle front silhouette with speed arcs, "
            "palette: graphite, fiery orange, antique gold accents, beginner-elite theft vibe"
        ),
    },
    {
        "name": "bike_cartel",
        "out": ROOT / "client" / "assets" / "images" / "achievements" / "badges" / "vehicles" / "bike_cartel.png",
        "prompt": (
            f"{BASE_PROMPT}, centered emblem: twin high-performance motorcycles with cartel crest and laurel, "
            "palette: obsidian, crimson, champagne gold, high-tier syndicate prestige"
        ),
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


def _generate_one(prompt: str, model: str) -> str:
    payload = {
        "model": model,
        "parameters": {
            "width": 1024,
            "height": 1024,
            "prompt": prompt,
            "negative_prompt": NEGATIVE_PROMPT,
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
    response = requests.get(url, timeout=90)
    response.raise_for_status()
    out_path.write_bytes(response.content)


def _count_transparent_pixels(path: Path) -> int:
    with Image.open(path) as image:
        alpha = image.convert("RGBA").getchannel("A")
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
    parser = argparse.ArgumentParser(description="Generate motorcycle achievement badges via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    print(f"Planned generations: {len(ASSETS)}")
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
                image_url = _generate_one(item["prompt"], args.model)
                _save_image(image_url, out_path)
                if not _ensure_transparency(out_path):
                    raise RuntimeError("Output has no true transparency")
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
    print(f"Success: {success}")
    print(f"Skipped: {skipped}")
    print(f"Failed: {failed}")


if __name__ == "__main__":
    main()
