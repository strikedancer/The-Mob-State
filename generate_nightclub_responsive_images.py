#!/usr/bin/env python3
"""Generate responsive nightclub assets for mobile/tablet/desktop via Leonardo API."""

from __future__ import annotations

import argparse
import os
import time
from io import BytesIO
from pathlib import Path

import requests
from PIL import Image

MODEL_ID = "nano-banana-2"
API_ENDPOINT = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_ENDPOINT = "https://cloud.leonardo.ai/api/rest/v1/generations"

BACKGROUNDS_DIR = Path("client/assets/images/backgrounds")
UI_DIR = Path("client/assets/images/ui")

IMAGE_SPECS = [
    (
        "nightclub_hub_bg_mobile.png",
        480,
        800,
        768,
        1024,
        "Cinematic underground nightclub interior, moody teal and amber neon lights, packed dance floor silhouette, DJ booth in background, smoke and lasers, no text, no logo, portrait mobile game background",
    ),
    (
        "nightclub_hub_bg_tablet.png",
        1024,
        768,
        1024,
        768,
        "Stylized crime empire nightclub management scene, neon bar, dance floor, VIP balcony, DJ booth centered depth, cinematic lighting, no text, no logo, tablet game background",
    ),
    (
        "nightclub_hub_bg_desktop.png",
        1920,
        1280,
        1536,
        1024,
        "Premium cinematic nightclub headquarters environment for management game, huge club hall with lighting rigs, fog, crowd silhouettes, VIP section, DJ booth focal point, no text, no watermark, desktop widescreen",
    ),
    (
        "nightclub_hub_emblem_mobile.png",
        512,
        512,
        768,
        768,
        "Centered nightclub syndicate emblem icon, metallic crest with vinyl + crown motif, readable at small size, dark backdrop, no text, no watermark",
    ),
    (
        "nightclub_hub_emblem_tablet.png",
        768,
        768,
        768,
        768,
        "Nightclub management emblem for tablet game UI, polished metal insignia, DJ record and shield motif, centered icon, no text, no watermark",
    ),
    (
        "nightclub_hub_emblem_desktop.png",
        1024,
        1024,
        1024,
        1024,
        "High-detail premium nightclub empire emblem, metallic engraved crest with neon reflections, centered composition, no text, no watermark",
    ),
]


def extract_generation_id(data: dict) -> str | None:
    if isinstance(data, list):
        data = data[0] if data else {}
    return (
        data.get("generationId")
        or data.get("sdGenerationJob", {}).get("generationId")
        or data.get("generate", {}).get("generationId")
        or data.get("data", {}).get("generationId")
    )


def extract_generated_images(status_data: dict):
    if isinstance(status_data, list):
        status_data = status_data[0] if status_data else {}

    generation = (
        status_data.get("generations_by_pk")
        or status_data.get("generation")
        or status_data.get("data", {}).get("generation")
        or {}
    )

    if isinstance(generation, list):
        generation = generation[0] if generation else {}

    status = generation.get("status") or status_data.get("status")
    images = (
        generation.get("generated_images")
        or generation.get("images")
        or status_data.get("generated_images")
        or status_data.get("images")
        or []
    )

    return status, images


def request_generation_id(width: int, height: int, prompt: str, headers: dict) -> tuple[str | None, dict]:
    payload = {
        "model": MODEL_ID,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    response = requests.post(API_ENDPOINT, json=payload, headers=headers, timeout=30)
    response.raise_for_status()
    data = response.json()
    return extract_generation_id(data), data


def generate_image(api_key: str, spec: tuple) -> bool:
    filename, target_w, target_h, pref_w, pref_h, prompt = spec
    print(f"\nGenerating {filename} ({target_w}x{target_h})")

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    candidates = [(pref_w, pref_h), (1024, 1024), (1024, 768), (768, 1024)]
    gen_id = None

    for gen_w, gen_h in candidates:
        try:
            candidate_id, _raw = request_generation_id(gen_w, gen_h, prompt, headers)
            if candidate_id:
                gen_id = candidate_id
                break
        except Exception as e:
            print(f"  candidate {gen_w}x{gen_h} failed: {e}")

    if not gen_id:
        print("  could not start generation")
        return False

    for _ in range(120):
        time.sleep(2)
        status_response = requests.get(
            f"{STATUS_ENDPOINT}/{gen_id}",
            headers={"Authorization": f"Bearer {api_key}"},
            timeout=20,
        )
        if status_response.status_code != 200:
            continue

        task_status, images = extract_generated_images(status_response.json())

        if task_status == "COMPLETE":
            if not images:
                print("  generation complete without images")
                return False

            image_url = images[0].get("url") or images[0].get("imageUrl")
            if not image_url:
                print("  missing image url")
                return False

            img_response = requests.get(image_url, timeout=30)
            img_response.raise_for_status()

            output_dir = BACKGROUNDS_DIR if "_bg_" in filename else UI_DIR
            output_dir.mkdir(parents=True, exist_ok=True)
            output_path = output_dir / filename

            with Image.open(BytesIO(img_response.content)) as img:
                resized = img.convert("RGB").resize((target_w, target_h), Image.Resampling.LANCZOS)
                resized.save(output_path, format="PNG", optimize=True)

            print(f"  saved -> {output_path}")
            return True

        if task_status == "FAILED":
            print("  generation failed")
            return False

    print("  timeout")
    return False


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate responsive nightclub images with Leonardo")
    parser.add_argument("--api-key", dest="api_key", default=os.getenv("LEONARDO_API_KEY", ""))
    args = parser.parse_args()

    if not args.api_key:
        print("ERROR: Missing LEONARDO_API_KEY (env or --api-key)")
        return 1

    ok = 0
    fail = 0

    for spec in IMAGE_SPECS:
        if generate_image(args.api_key, spec):
            ok += 1
        else:
            fail += 1

    print(f"\nDone: {ok} success, {fail} failed")
    return 0 if fail == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
