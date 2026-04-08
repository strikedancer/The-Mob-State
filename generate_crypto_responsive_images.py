"""Generate responsive crypto screen images via Leonardo.ai.

Outputs:
- client/assets/images/backgrounds/crypto_market_bg_mobile.png
- client/assets/images/backgrounds/crypto_market_bg_tablet.png
- client/assets/images/backgrounds/crypto_market_bg_desktop.png
- client/assets/images/ui/crypto_hub_emblem.png
"""

import io
import os
import time
from pathlib import Path

import requests
from PIL import Image

API_KEY = os.getenv("LEONARDO_API_KEY", "")
GENERATE_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
NOBG_URL = "https://cloud.leonardo.ai/api/rest/v1/variations/nobg"
VARIATION_URL = "https://cloud.leonardo.ai/api/rest/v1/variations"
MODEL = "gpt-image-1.5"

ROOT = Path(__file__).parent

TASKS = [
    {
        "path": ROOT / "client" / "assets" / "images" / "backgrounds" / "crypto_market_bg_mobile.png",
        "width": 1024,
        "height": 1365,
        "prompt": (
            "Vertical cyber-finance city at night for a mafia strategy game UI background, "
            "neon ticker lines, subtle candlestick overlays, dark blue and emerald palette, "
            "dramatic depth, no characters, no text, no logos, optimized for mobile portrait composition"
        ),
    },
    {
        "path": ROOT / "client" / "assets" / "images" / "backgrounds" / "crypto_market_bg_tablet.png",
        "width": 1365,
        "height": 1024,
        "prompt": (
            "Wide digital trading floor environment with holographic market boards and city skyline glow, "
            "cinematic atmosphere, dark cool palette with green highlights, no text or logos, optimized for tablet landscape"
        ),
    },
    {
        "path": ROOT / "client" / "assets" / "images" / "backgrounds" / "crypto_market_bg_desktop.png",
        "width": 1536,
        "height": 1024,
        "prompt": (
            "Premium panoramic crypto exchange hall with layered transparent hologram charts, luxurious noir-tech mood, "
            "high detail, dark navy with emerald accents, no text, no logos, optimized for desktop ultra-wide UI background"
        ),
    },
    {
        "path": ROOT / "client" / "assets" / "images" / "ui" / "crypto_hub_emblem.png",
        "width": 1024,
        "height": 1024,
        "transparent_required": True,
        "prompt": (
            "Futuristic coin-and-blockchain emblem for game HUD, metallic ring with digital glyph fragments, centered icon, no text. "
            "CRITICAL: Must be true RGBA PNG with fully transparent background alpha 0 outside emblem"
        ),
    },
]


def extract_generation_id(payload):
    if "sdGenerationJob" in payload and payload["sdGenerationJob"].get("generationId"):
        return payload["sdGenerationJob"]["generationId"]
    if "generationId" in payload:
        return payload["generationId"]
    generate = payload.get("generate", {}) if isinstance(payload, dict) else {}
    if isinstance(generate, dict) and generate.get("generationId"):
        return generate.get("generationId")
    nested = payload.get("data", {}) if isinstance(payload, dict) else {}
    return nested.get("generationId")


def extract_image_url(payload):
    generations = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not generations:
        generations = payload.get("generation") or payload.get("data", {}).get("generation")
    if not generations:
        return None

    images = generations.get("generated_images") or generations.get("images") or []
    if not images:
        return None

    first = images[0]
    return first.get("url") or first.get("imageUrl")


def extract_image_id(payload):
    generations = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not generations:
        generations = payload.get("generation") or payload.get("data", {}).get("generation")
    if not generations:
        return None

    images = generations.get("generated_images") or generations.get("images") or []
    if not images:
        return None

    first = images[0]
    return first.get("id") or first.get("imageId")


def extract_status(payload):
    generations = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not generations:
        generations = payload.get("generation") or payload.get("data", {}).get("generation")
    if not generations:
        return None
    return generations.get("status")


def extract_variation(payload):
    variations = payload.get("generated_image_variation_generic") or []
    if not variations:
        return None
    return variations[0]


def download_image(url: str):
    img = requests.get(url, timeout=60)
    img.raise_for_status()
    content_type = (img.headers.get("Content-Type") or "").lower()
    return img.content, content_type


def has_clean_transparency(image_bytes: bytes):
    with Image.open(io.BytesIO(image_bytes)) as image:
        rgba = image.convert("RGBA")
        width, height = rgba.size
        alpha = rgba.getchannel("A")

        sample_points = {
            (0, 0),
            (width - 1, 0),
            (0, height - 1),
            (width - 1, height - 1),
            (width // 2, 0),
            (width // 2, height - 1),
            (0, height // 2),
            (width - 1, height // 2),
        }

        return all(alpha.getpixel(point) == 0 for point in sample_points)


def create_nobg_variation(headers, image_id: str):
    payload = {
        "id": image_id,
        "isVariation": False,
    }
    resp = requests.post(NOBG_URL, headers=headers, json=payload, timeout=90)
    resp.raise_for_status()
    job = resp.json().get("sdNobgJob") or {}
    variation_id = job.get("id")
    if not variation_id:
        raise RuntimeError("Leonardo no-background fallback did not return a variation ID")
    return variation_id


def poll_nobg_variation(headers, variation_id: str, max_polls: int = 120, poll_interval: float = 3.0):
    for _ in range(max_polls):
        poll = requests.get(f"{VARIATION_URL}/{variation_id}", headers=headers, timeout=60)
        poll.raise_for_status()

        variation = extract_variation(poll.json())
        if variation:
            status = variation.get("status")
            url = variation.get("url") or variation.get("imageUrl")

            if status == "FAILED":
                raise RuntimeError(f"Leonardo no-background job failed (variationId={variation_id})")
            if status == "COMPLETE" and url:
                return url

        time.sleep(poll_interval)

    raise TimeoutError("Timed out while waiting for Leonardo no-background variation")


def generate_single(prompt: str, width: int, height: int, transparent_required: bool = False):
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }

    payload = {
        "model": MODEL,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    resp = requests.post(GENERATE_URL, headers=headers, json=payload, timeout=90)
    resp.raise_for_status()
    generation_id = extract_generation_id(resp.json())
    if not generation_id:
        raise RuntimeError("No generation ID returned by Leonardo")

    for _ in range(120):
        poll = requests.get(f"{STATUS_URL}/{generation_id}", headers=headers, timeout=60)
        poll.raise_for_status()
        poll_json = poll.json()
        status = extract_status(poll_json)

        if status == "FAILED":
            raise RuntimeError(f"Leonardo job failed (generationId={generation_id})")

        image_url = extract_image_url(poll_json)
        if image_url:
            image_id = extract_image_id(poll_json)
            image_bytes, content_type = download_image(image_url)
            is_jpeg = "jpeg" in content_type or image_url.lower().endswith(".jpg") or image_url.lower().endswith(".jpeg")

            if not transparent_required:
                return image_bytes

            if not is_jpeg and has_clean_transparency(image_bytes):
                return image_bytes

            if not image_id:
                if is_jpeg:
                    raise RuntimeError("Transparent asset returned JPEG and no image ID for no-background fallback.")
                raise RuntimeError("Transparent asset alpha is not clean and no image ID returned for fallback.")

            variation_id = create_nobg_variation(headers, image_id)
            variation_url = poll_nobg_variation(headers, variation_id)
            cleaned_bytes, cleaned_content_type = download_image(variation_url)
            cleaned_is_jpeg = (
                "jpeg" in cleaned_content_type
                or variation_url.lower().endswith(".jpg")
                or variation_url.lower().endswith(".jpeg")
            )
            if cleaned_is_jpeg:
                raise RuntimeError("Leonardo no-background fallback returned JPEG instead of transparent PNG.")
            if not has_clean_transparency(cleaned_bytes):
                raise RuntimeError("Leonardo no-background fallback completed but alpha is still not clean.")

            return cleaned_bytes
        time.sleep(3)

    raise TimeoutError("Timed out while waiting for Leonardo image generation")


def main():
    if not API_KEY:
        print("ERROR: LEONARDO_API_KEY missing")
        return

    success = 0
    failures = []

    for idx, task in enumerate(TASKS, 1):
        out_path = task["path"]
        out_path.parent.mkdir(parents=True, exist_ok=True)

        print(f"[{idx}/{len(TASKS)}] {out_path.name}")
        attempt_ok = False
        for attempt in range(1, 4):
            try:
                data = generate_single(
                    task["prompt"],
                    task["width"],
                    task["height"],
                    bool(task.get("transparent_required", False)),
                )
                out_path.write_bytes(data)
                success += 1
                attempt_ok = True
                print(f"  OK (attempt {attempt}) -> {out_path}")
                break
            except Exception as exc:
                print(f"  FAIL (attempt {attempt}) -> {exc}")
                time.sleep(8)

        if not attempt_ok:
            failures.append(out_path.name)

        time.sleep(2)

    print(f"Done: {success}/{len(TASKS)} generated")
    if failures:
        print("Failed files:")
        for item in failures:
            print(f"- {item}")


if __name__ == "__main__":
    main()
