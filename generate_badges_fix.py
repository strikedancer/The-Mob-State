#!/usr/bin/env python3
"""
Targeted fix script:
1. Generate missing drug_heroin_200.png
2. Regenerate drug_amnesia_haze_500.png (had wrong text in image)
3. Replace chemist_apprentice.png (new Leonardo badge)
4. Replace narco_chemist.png (new Leonardo badge)
"""

import time
import requests
import json
from pathlib import Path
from io import BytesIO

from PIL import Image

try:
    from rembg import remove
    REMBG_AVAILABLE = True
except Exception:
    REMBG_AVAILABLE = False

LEONARDO_API_KEY = "a7132d07-0987-45df-8372-1e6c7985803a"
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
MODEL_NAME = "nano-banana-2"
DRUGS_DIR = Path(__file__).parent / "client" / "assets" / "images" / "achievements" / "badges" / "drugs"
BADGES_DIR = Path(__file__).parent / "client" / "assets" / "images" / "achievements" / "badges"

BADGES_TO_FIX = [
    {
        "filename": "drug_heroin_200.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "Create a premium game achievement shield emblem, centered, featuring a refined poppy flower "
            "with detailed seed pod texture in deep burgundy, crimson, and dark rose tones, symbolizing "
            "controlled extraction. Add advanced processing symbols inside shield: precision extraction "
            "apparatus, temperature-control heating vessel, filtering cloth, botanical processing guide, "
            "chemical solutions. Steel metallic outer trim, rich burgundy enamel inner with subtle papery "
            "texture pattern, ribbon text OPERATOR. Isometric icon, ultra-detailed, metallic steel shine, "
            "high contrast, 256x256. "
            "CRITICAL: True RGBA PNG with alpha channel. Every pixel outside emblem = completely "
            "transparent (alpha 0). NO background plate, NO gradient, NO bloom. Emblem only, tightly centered. "
            "Negative: background, gradient, vignette, fog, bloom, shadow outside, fake transparency, scene"
        ),
    },
    {
        "filename": "drug_amnesia_haze_500.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "Create a premium game achievement shield emblem, centered, featuring a majestic amnesia haze "
            "storm-vortex in layered violet, indigo, and electric cyan mist with luminous spiral trails "
            "symbolizing large-scale refined production. Add empire symbols inside shield: gold-trimmed "
            "grow modules, precision refinery glassware, export crates, wealth motifs. Lustrous gold outer "
            "trim with ornate filigree, deep amethyst enamel inner with soft radiant gradient, ribbon text "
            "KINGPIN. Isometric game-icon, premium emblem, ultra-detailed, gold metallic shine, high "
            "contrast for mobile, 256x256. "
            "CRITICAL: True RGBA PNG. Background outside emblem = 100% transparent (alpha 0). NO background "
            "plate, NO gradient backdrop, NO vignette, NO fog. Emblem cutout only. "
            "Negative: background, gradient, vignette, fog, bloom, fake transparency, scene, text 100"
        ),
    },
    {
        "filename": "chemist_apprentice.png",
        "output_dir": BADGES_DIR,
        "prompt": (
            "Create a premium game achievement shield emblem, centered, for a beginner drug chemist. "
            "Feature a round-bottom flask with colorful liquid and small bubbles, chemistry beakers, "
            "mortar and pestle, simple lab bench inside shield. Bronze metallic outer trim with ornate "
            "corners, pale emerald-green enamel inner, ribbon text CHEMIST APPRENTICE. "
            "Isometric game-icon, ultra-detailed, crisp bold edges, high contrast, clean icon 256x256. "
            "CRITICAL: True RGBA PNG with alpha channel. Every pixel outside emblem = fully transparent "
            "(alpha 0). NO background plate, NO gradient, NO vignette. Emblem cutout only, centered. "
            "Negative: background, gradient, vignette, fog, fake transparency, scene, wall"
        ),
    },
    {
        "filename": "narco_chemist.png",
        "output_dir": BADGES_DIR,
        "prompt": (
            "Create a premium game achievement shield emblem, centered, for an expert narco chemist. "
            "Feature an intricate distillation apparatus with multiple connected flasks, chemical "
            "molecular structures, precision lab equipment, golden chemistry symbols inside shield. "
            "Polished gold outer trim with ornate filigree, deep forest-green enamel inner with subtle "
            "radiant glow, ribbon text NARCO CHEMIST. Isometric game-icon, premium emblem, ultra-detailed, "
            "gold metallic shine, imposing expert feeling, 256x256. "
            "CRITICAL: True RGBA PNG. Background outside emblem = 100% transparent (alpha 0). NO background "
            "plate, NO gradient, NO vignette, NO fog. Emblem cutout only, tightly centered. "
            "Negative: background, gradient, vignette, fog, bloom, fake transparency, scene"
        ),
    },
]


def generate_and_save(badge):
    filename = badge["filename"]
    output_dir = badge["output_dir"]
    prompt = badge["prompt"]
    output_path = output_dir / filename

    if output_path.exists():
        output_path.unlink()
        print(f"[*] Removed existing {filename}")

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

    print(f"[*] Generating {filename}...", end=" ", flush=True)
    response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    print(f"OK")

    gen_id = data.get("generationId") or data.get("generate", {}).get("generationId")
    if not gen_id:
        print(f"  [ERROR] No generation ID: {data}")
        return False

    print(f"  Gen ID: {gen_id}")

    for attempt in range(240):
        time.sleep(5)
        poll_resp = requests.get(
            f"https://cloud.leonardo.ai/api/rest/v1/generations/{gen_id}",
            headers={"authorization": f"Bearer {LEONARDO_API_KEY}"},
            timeout=30,
        )
        poll_resp.raise_for_status()
        generation = poll_resp.json().get("generations_by_pk", {})
        status = generation.get("status")
        images = generation.get("generated_images", [])

        if status == "COMPLETE":
            if not images:
                print(f"  [FAIL] Complete but no images")
                return False
            url = images[0].get("url")
            if not url:
                print(f"  [FAIL] No URL in images")
                return False

            img_resp = requests.get(url, timeout=60)
            img_resp.raise_for_status()

            if REMBG_AVAILABLE:
                rgba_bytes = remove(img_resp.content)
                image = Image.open(BytesIO(rgba_bytes)).convert("RGBA")
            else:
                image = Image.open(BytesIO(img_resp.content)).convert("RGBA")

            image.save(output_path, format="PNG")
            print(f"  [OK] Saved -> {output_path.name}")
            return True

        elif status == "FAILED":
            print(f"  [FAIL] Generation failed")
            return False

        if attempt % 6 == 0:
            print(f"  [*] Polling {attempt * 5}s... status={status}")

    print(f"  [TIMEOUT]")
    return False


def main():
    print("\n== Badge Fix Script")
    print(f"Rembg enabled: {REMBG_AVAILABLE}\n")

    success = 0
    failed = []

    for i, badge in enumerate(BADGES_TO_FIX, 1):
        print(f"\n[{i}/{len(BADGES_TO_FIX)}] {badge['filename']}")
        if generate_and_save(badge):
            success += 1
        else:
            failed.append(badge["filename"])
        if i < len(BADGES_TO_FIX):
            time.sleep(2)

    print(f"\n== Done: {success}/{len(BADGES_TO_FIX)} succeeded")
    if failed:
        print(f"Failed:")
        for f in failed:
            print(f"  - {f}")


if __name__ == "__main__":
    main()
