#!/usr/bin/env python3

import time
from io import BytesIO
from pathlib import Path

import requests
from PIL import Image

try:
    from rembg import remove
    REMBG_AVAILABLE = True
except Exception:
    REMBG_AVAILABLE = False

LEONARDO_API_KEY = "a7132d07-0987-45df-8372-1e6c7985803a"
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
MODEL_NAME = "nano-banana-2"
OUTPUT_DIR = Path(__file__).parent / "client" / "assets" / "images" / "facilities"

IMAGES = [
    {
        "filename": "facility_greenhouse.png",
        "prompt": (
            "Create a premium mobile game facility icon, centered, featuring a criminal cannabis greenhouse "
            "with reinforced glass structure, rows of mature plants, warm grow lights, metal irrigation lines, "
            "climate control fans, and subtle mafia-management luxury details. Isometric, ultra-detailed, crisp "
            "mobile readability, strong silhouette, dramatic green and amber lighting, 512x512. "
            "CRITICAL: True RGBA PNG. Background outside the facility must be fully transparent alpha 0. "
            "No background scene, no floor plate, no vignette, icon cutout only. "
            "Negative: background, room, wall, vignette, border frame, text, watermark"
        ),
    },
    {
        "filename": "facility_drug_lab.png",
        "prompt": (
            "Create a premium mobile game facility icon, centered, featuring a clandestine high-end drug lab with "
            "stainless steel workbenches, pill press, chemistry glassware, extraction equipment, sealed containers, "
            "cool blue task lighting and dangerous industrial precision. Isometric, ultra-detailed, sharp silhouette, "
            "high contrast for mobile game UI, 512x512. CRITICAL: True RGBA PNG with full transparency outside the "
            "facility. No background scene, no wall, no floor plate, no text, icon cutout only. "
            "Negative: background, room, vignette, text, watermark, border frame"
        ),
    },
]


def generate_image(prompt: str, output_path: Path) -> bool:
    headers = {
        "authorization": f"Bearer {LEONARDO_API_KEY}",
        "content-type": "application/json",
        "accept": "application/json",
    }
    payload = {
        "model": MODEL_NAME,
        "parameters": {
            "width": 1024,
            "height": 1024,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    generation_id = data.get("generationId") or data.get("generate", {}).get("generationId")
    if not generation_id:
        print(f"[FAIL] No generationId returned for {output_path.name}")
        return False

    print(f"[*] {output_path.name}: generation {generation_id}")

    for attempt in range(240):
        time.sleep(5)
        poll = requests.get(
            f"https://cloud.leonardo.ai/api/rest/v1/generations/{generation_id}",
            headers={"authorization": f"Bearer {LEONARDO_API_KEY}"},
            timeout=30,
        )
        poll.raise_for_status()
        generation = poll.json().get("generations_by_pk", {})
        status = generation.get("status")
        images = generation.get("generated_images", [])

        if status == "COMPLETE":
            if not images or not images[0].get("url"):
                print(f"[FAIL] No image URL for {output_path.name}")
                return False
            image_response = requests.get(images[0]["url"], timeout=60)
            image_response.raise_for_status()
            if REMBG_AVAILABLE:
                rgba = remove(image_response.content)
                image = Image.open(BytesIO(rgba)).convert("RGBA")
            else:
                image = Image.open(BytesIO(image_response.content)).convert("RGBA")
            image.save(output_path, format="PNG")
            print(f"[OK] Saved {output_path}")
            return True

        if status == "FAILED":
            print(f"[FAIL] Generation failed for {output_path.name}")
            return False

        if attempt % 6 == 0:
            print(f"    polling {attempt * 5}s status={status}")

    print(f"[FAIL] Timeout for {output_path.name}")
    return False


def main() -> None:
    print("== Drug Facility Image Generation ==")
    print(f"Rembg enabled: {REMBG_AVAILABLE}")
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for image in IMAGES:
        output_path = OUTPUT_DIR / image["filename"]
        generate_image(image["prompt"], output_path)


if __name__ == "__main__":
    main()