#!/usr/bin/env python3
"""
Leonardo.ai generation script for new drug item images + mushroom facility.
Generates 6 PNG images with transparent backgrounds.

Output:
  client/assets/images/drugs/hash.png
  client/assets/images/drugs/magic_mushrooms.png
  client/assets/images/drugs/lsd.png
  client/assets/images/drugs/crystal_meth.png
  client/assets/images/drugs/fentanyl.png
  client/assets/images/facilities/facility_mushroom_farm.png
"""

import time
import requests
from pathlib import Path
from io import BytesIO

from PIL import Image

try:
    from rembg import remove
    REMBG_AVAILABLE = True
except Exception:
    REMBG_AVAILABLE = False

LEONARDO_API_KEY = "a7132d07-0987-45df-8372-1e6c7985803a"
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
# Nano Banana 2 model ID (same as used in generate_drug_badges_leonardo.py)
MODEL_ID = "7b592283-e8a7-4c5a-9ba6-d18c31f258b9"

DRUGS_DIR = Path(__file__).parent / "client" / "assets" / "images" / "drugs"
FACILITIES_DIR = Path(__file__).parent / "client" / "assets" / "images" / "facilities"

DRUGS_DIR.mkdir(parents=True, exist_ok=True)
FACILITIES_DIR.mkdir(parents=True, exist_ok=True)

IMAGES = [
    {
        "filename": "hash.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "A dark golden-brown compressed hashish brick, slightly textured surface with natural resin "
            "marks and pressed patterns. Soft warm studio lighting from above, isolated on pure black "
            "background. Photorealistic, high detail macro photography style, no packaging, no labels. "
            "512x512. "
            "CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Drug object only, "
            "centered, no shadow outside object silhouette. "
            "Negative: white background, packaging, label, text, people, hands, table surface, shadow outside object"
        ),
    },
    {
        "filename": "magic_mushrooms.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "A cluster of dried psilocybin mushrooms (Psilocybe cubensis), earthy golden-brown caps "
            "with pale stems, slight iridescent shimmer suggesting psychedelic potency. Macro photography "
            "style, isolated on pure black background, photorealistic, high detail, natural textures. "
            "512x512. "
            "CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Mushroom cluster only, "
            "centered, no table or surface shown. "
            "Negative: white background, packaging, label, text, people, table, grass, soil visible"
        ),
    },
    {
        "filename": "lsd.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "A small blotter paper sheet with subtle geometric psychedelic print patterns in blue and "
            "purple tones, showing perforated tabs on a small square. Slightly iridescent surface. "
            "Macro photography, photorealistic, isolated on pure black background. Hint of blue glow "
            "suggesting chemical potency. 512x512. "
            "CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Blotter paper only, centered. "
            "Negative: white background, people, hands, syringes, pill bottle, table, shadow extending outward"
        ),
    },
    {
        "filename": "crystal_meth.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "A small pile of blue-white crystalline methamphetamine shards, sharp angular facets catching "
            "light with an icy blue shimmer. Macro photography style, photorealistic, extremely high "
            "detail, isolated on pure black background. Cold clinical aesthetic. 512x512. "
            "CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Crystal pile only, "
            "centered, no surface or reflection outside object. "
            "Negative: white background, packaging, people, hands, text, table surface, warm tones"
        ),
    },
    {
        "filename": "fentanyl.png",
        "output_dir": DRUGS_DIR,
        "prompt": (
            "A small precise heap of ultra-fine white pharmaceutical powder, slightly luminescent, "
            "almost glowing under clinical studio light. Pure white dusty texture with subtle crystalline "
            "shimmer. Photorealistic macro, extremely clean and clinical aesthetic, isolated on pure "
            "black background. 512x512. "
            "CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Powder heap only, centered. "
            "Negative: white background, packaging, pills, syringes, people, hands, table, warm tones"
        ),
    },
    {
        "filename": "facility_mushroom_farm.png",
        "output_dir": FACILITIES_DIR,
        "prompt": (
            "A clear isometric underground mushroom grow room icon for a crime management game, bright enough "
            "to read at small size. Visible rows of wooden shelves filled with clustered mushrooms, blue and "
            "purple grow lamps, humid pipes, plastic grow trays, compact indoor cultivation setup, centered "
            "composition, crisp edges, high contrast, dark room but clearly visible details, game-building icon, "
            "512x512. "
            "CRITICAL: Transparent PNG with a clean cutout silhouette around the full room icon. Keep the entire "
            "facility clearly visible. No black background baked into the image. "
            "Negative: photoreal dark photo, barely visible scene, foggy darkness, vignette, outdoor, daylight, text"
        ),
    },
    {
        "filename": "facility_crack_kitchen.png",
        "output_dir": FACILITIES_DIR,
        "prompt": (
            "A clear isometric crack kitchen icon for a crime management game, centered and readable at small size. "
            "Stainless steel counters, industrial heating plates, glass reactor flasks, sealed chemical containers, "
            "hazard lights, compact clandestine lab setup with orange-red accent lighting, crisp edges, high contrast, "
            "game-building icon, 512x512. "
            "CRITICAL: Transparent PNG with clean cutout silhouette around the complete facility icon. Keep all key "
            "equipment visible. No black background baked into the image. "
            "Negative: dark unreadable photo, heavy fog, vignette, people, text, outdoor scene"
        ),
    },
    {
        "filename": "facility_darkweb_storefront.png",
        "output_dir": FACILITIES_DIR,
        "prompt": (
            "A clear isometric darkweb storefront icon for a crime management game, centered and readable at small size. "
            "Underground cyber operations room with server racks, encrypted terminals, multiple monitors, secure package "
            "sorting table, neon blue-purple glow, stealth atmosphere, crisp edges, high contrast, game-building icon, "
            "512x512. "
            "CRITICAL: Transparent PNG with clean cutout silhouette around the full room icon. Keep servers and screens "
            "clearly visible. No black background baked into the image. "
            "Negative: blurry scene, overly dark image, vignette, text, people, outdoor daylight"
        ),
    },
]


def generate_and_save(image_def):
    filename = image_def["filename"]
    output_dir = image_def["output_dir"]
    prompt = image_def["prompt"]
    output_path = output_dir / filename

    if output_path.exists():
        output_path.unlink()
        print(f"  [*] Removed existing {filename}")

    headers = {
        "authorization": f"Bearer {LEONARDO_API_KEY}",
        "content-type": "application/json",
        "accept": "application/json",
    }

    payload = {
        "prompt": prompt,
        "modelId": MODEL_ID,
        "width": 512,
        "height": 512,
        "num_images": 1,
        "alchemy": False,
        "photoReal": False,
    }

    print(f"  [*] Sending request...", end=" ", flush=True)
    response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    print("OK")

    # Handle both list and dict responses
    if isinstance(data, list):
        data = data[0] if data else {}
    gen_id = data.get("generationId") or data.get("sdGenerationJob", {}).get("generationId")
    if not gen_id:
        print(f"  [ERROR] No generation ID in response: {data}")
        return False

    print(f"  [*] Gen ID: {gen_id}")

    for attempt in range(240):
        time.sleep(5)
        poll_resp = requests.get(
            f"https://cloud.leonardo.ai/api/rest/v1/generations/{gen_id}",
            headers={"authorization": f"Bearer {LEONARDO_API_KEY}"},
            timeout=30,
        )
        poll_resp.raise_for_status()
        generation = poll_resp.json()
        status = generation.get("status")
        images = generation.get("assets", [])

        if status == "COMPLETE":
            if not images:
                # fallback: check generations_by_pk structure
                gen_data = generation.get("generations_by_pk", {})
                status = gen_data.get("status", status)
                images = gen_data.get("generated_images", [])
                if images:
                    url = images[0].get("url")
                else:
                    print("  [FAIL] Complete but no images in response")
                    return False
            else:
                url = images[0].get("url") if images else None

            if not url:
                print("  [FAIL] No URL in generated images")
                return False

            img_resp = requests.get(url, timeout=60)
            img_resp.raise_for_status()

            if REMBG_AVAILABLE:
                print("  [*] Removing background with rembg...")
                rgba_bytes = remove(img_resp.content)
                image = Image.open(BytesIO(rgba_bytes)).convert("RGBA")
            else:
                image = Image.open(BytesIO(img_resp.content)).convert("RGBA")

            image.save(output_path, format="PNG")
def generate_and_save(image_def):
    filename = image_def["filename"]
    output_dir = image_def["output_dir"]
    prompt = image_def["prompt"]
    output_path = output_dir / filename

    if output_path.exists():
        output_path.unlink()
        print(f"  [*] Removed existing {filename}")

    headers = {
        "Authorization": f"Bearer {LEONARDO_API_KEY}",
        "Content-Type": "application/json",
    }
    payload = {
        "prompt": prompt,
        "modelId": MODEL_ID,
        "width": 512,
        "height": 512,
        "num_images": 1,
        "alchemy": False,
        "photoReal": False,
    }

    print(f"  [*] Sending request...", end=" ", flush=True)
    response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    print("OK")

    # POST response: {"sdGenerationJob": {"generationId": "..."}}
    gen_id = data.get("sdGenerationJob", {}).get("generationId")
    if not gen_id:
        print(f"  [ERROR] No generation ID: {data}")
        return False
    print(f"  [*] Gen ID: {gen_id}")

    # Poll until COMPLETE (max 4 min)
    for attempt in range(48):
        time.sleep(5)
        poll = requests.get(
            f"https://cloud.leonardo.ai/api/rest/v1/generations/{gen_id}",
            headers={"Authorization": f"Bearer {LEONARDO_API_KEY}"},
            timeout=30,
        )
        poll.raise_for_status()
        gen = poll.json().get("generations_by_pk", {})
        status = gen.get("status")

        if status == "COMPLETE":
            images = gen.get("generated_images", [])
            if not images:
                print("  [FAIL] No images in response")
                return False
            url = images[0]["url"]
            img_resp = requests.get(url, timeout=60)
            img_resp.raise_for_status()
            should_remove_background = REMBG_AVAILABLE and not filename.startswith("facility_")
            if should_remove_background:
                print("  [*] Removing background...")
                img_bytes = remove(img_resp.content)
            else:
                img_bytes = img_resp.content
            image = Image.open(BytesIO(img_bytes)).convert("RGBA")
            image.save(output_path, format="PNG")
            print(f"  [OK] Saved -> {output_path}")
            return True

        elif status == "FAILED":
            print("  [FAIL] Generation failed")
            return False

        if attempt % 6 == 0 and attempt > 0:
            print(f"  [*] Still polling... {attempt * 5}s, status={status}")

    print("  [TIMEOUT]")
    return False


def main():
    print("== Drug Item Images + Mushroom Facility Generator")
    print(f"   Model   : {MODEL_ID}")
    print(f"   Rembg   : {'enabled' if REMBG_AVAILABLE else 'disabled (pip install rembg to enable)'}")
    print(f"   Images  : {len(IMAGES)}\n")

    success = 0
    failed = []

    for i, img in enumerate(IMAGES, 1):
        print(f"[{i}/{len(IMAGES)}] {img['filename']}")
        if generate_and_save(img):
            success += 1
        else:
            failed.append(img["filename"])
        if i < len(IMAGES):
            time.sleep(3)

    print(f"\n== Done: {success}/{len(IMAGES)} succeeded")
    if failed:
        print("Failed:")
        for f in failed:
            print(f"  - {f}")
    else:
        print("All images generated successfully!")


if __name__ == "__main__":
    main()
