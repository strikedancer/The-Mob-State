#!/usr/bin/env python3

import time
from io import BytesIO
from pathlib import Path

import requests
from PIL import Image

LEONARDO_API_KEY = "a7132d07-0987-45df-8372-1e6c7985803a"
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
MODEL_NAME = "nano-banana-2"
OUTPUT_DIR = Path(__file__).parent / "client" / "assets" / "images" / "backgrounds"

IMAGES = [
    {
        "filename": "drug_production_bg.png",
        "width": 1792,
        "height": 1024,
        "prompt": (
            "Create a premium cinematic game background for a drug production screen, showing a shadowy narco production floor "
            "with greenhouse grow lights, drying racks, chemical workstations, organized ingredient crates, and subtle industrial haze. "
            "The composition should leave clean negative space for UI cards and lists, with green, gold, and blue lighting accents, "
            "realistic digital art, ultra-detailed, no characters, no text, no logos."
        ),
    },
    {
        "filename": "drug_facility_bg.png",
        "width": 1792,
        "height": 1024,
        "prompt": (
            "Create a premium cinematic game background for a drug facilities management screen, showing a luxury underground operations hub "
            "with visible greenhouse sectors, high-end laboratory rooms, industrial control panels, steel walkways, and hidden criminal infrastructure. "
            "Wide composition with elegant lighting and open negative space for interface panels, realistic digital art, no characters, no text, no logos."
        ),
    },
    {
        "filename": "drug_inventory_bg.png",
        "width": 1792,
        "height": 1024,
        "prompt": (
            "Create a premium cinematic game background for a drug inventory and distribution screen, featuring contraband storage shelves, sealed packages, "
            "quality-labeled containers, travel route maps, subtle money-counting desk light, and a moody distribution warehouse atmosphere. "
            "Wide composition with clear UI-safe areas, realistic digital art, high detail, no characters, no text, no logos."
        ),
    },
]


def generate_image(prompt: str, output_path: Path, width: int, height: int) -> bool:
    headers = {
        "authorization": f"Bearer {LEONARDO_API_KEY}",
        "content-type": "application/json",
        "accept": "application/json",
    }
    payload = {
        "model": MODEL_NAME,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    if isinstance(data, list):
        print(f"[FAIL] Leonardo validation error for {output_path.name}: {data}")
        return False
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
            image = Image.open(BytesIO(image_response.content)).convert("RGB")
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
    print("== Drug Subscreen Background Generation ==")
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for image in IMAGES:
        generate_image(
            image["prompt"],
            OUTPUT_DIR / image["filename"],
            image["width"],
            image["height"],
        )


if __name__ == "__main__":
    main()