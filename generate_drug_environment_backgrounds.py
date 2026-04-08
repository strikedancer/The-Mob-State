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
        "filename": "drug_environment_mobile.png",
        "width": 1024,
        "height": 1792,
        "output_width": 1024,
        "output_height": 1792,
        "prompt": (
            "Create a premium mobile game background for a criminal drug empire interface, portrait composition, "
            "showing a moody luxury underground narco compound with greenhouse glow, hidden chemistry lab lighting, "
            "stacks of supply crates, industrial metal walkways, distant city lights through dirty windows, cinematic "
            "depth, high contrast, sharp foreground readability zones for mobile UI cards, green and amber neon accents, "
            "realistic digital art, no characters, no text, no logos, optimized for mobile portrait game menu."
        ),
    },
    {
        "filename": "drug_environment_tablet.png",
        "width": 1024,
        "height": 1792,
        "output_width": 1024,
        "output_height": 1365,
        "prompt": (
            "Create a premium tablet game background for a drug empire control hub, portrait-oriented but wider composition, "
            "featuring a sophisticated criminal operations floor that blends greenhouse cultivation, chemistry lab equipment, "
            "organized storage, steel beams, moody ventilation haze, cinematic blue-green lighting, and clean open center space "
            "for UI overlays. Realistic digital art, high detail, no characters, no text, no logos, optimized for tablet game interface."
        ),
    },
    {
        "filename": "drug_environment_desktop.png",
        "width": 1792,
        "height": 1024,
        "output_width": 1792,
        "output_height": 1024,
        "prompt": (
            "Create a premium desktop game background for a drug empire headquarters screen, wide cinematic landscape composition, "
            "showing an expansive hidden narco command center with luxury office overview, glowing greenhouse sections, advanced drug lab, "
            "organized contraband storage, industrial catwalks, atmospheric city skyline beyond, dramatic shadows, rich green, blue, and amber "
            "lighting, clear negative space for UI panels. Realistic digital art, ultra-detailed, no characters, no text, no logos."
        ),
    },
]


def _crop_to_ratio(image: Image.Image, target_width: int, target_height: int) -> Image.Image:
    source_ratio = image.width / image.height
    target_ratio = target_width / target_height

    if source_ratio > target_ratio:
        new_width = int(image.height * target_ratio)
        left = (image.width - new_width) // 2
        image = image.crop((left, 0, left + new_width, image.height))
    elif source_ratio < target_ratio:
        new_height = int(image.width / target_ratio)
        top = (image.height - new_height) // 2
        image = image.crop((0, top, image.width, top + new_height))

    return image.resize((target_width, target_height), Image.LANCZOS)


def generate_image(
    prompt: str,
    output_path: Path,
    width: int,
    height: int,
    output_width: int,
    output_height: int,
) -> bool:
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
        print(f"[FAIL] Leonardo returned validation list for {output_path.name}: {data}")
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
            image = _crop_to_ratio(image, output_width, output_height)
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
    print("== Drug Environment Background Generation ==")
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for image in IMAGES:
        generate_image(
            image["prompt"],
            OUTPUT_DIR / image["filename"],
            image["width"],
            image["height"],
            image["output_width"],
            image["output_height"],
        )


if __name__ == "__main__":
    main()