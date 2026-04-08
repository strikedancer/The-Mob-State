"""Generate TuneShop UI images via Leonardo.ai (gpt-image-1.5).

Generates:
  - tuneshop_bg_desktop.jpg   (1024x1024 -> resized 1920x1080)
  - tuneshop_bg_tablet.jpg    (1024x1024 -> resized 1024x768)
  - tuneshop_bg_mobile.jpg    (1024x1024 -> resized 390x844)
  - tuneshop_emblem.png       (1024x1024 transparent)

Output: client/assets/images/tuneshop/
"""

import io
import os
import time
from pathlib import Path

import requests
from PIL import Image

API_KEY = os.getenv("LEONARDO_API_KEY", "540963ec-4946-49df-8f00-d86ac41e2c74")
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
NOBG_URL = "https://cloud.leonardo.ai/api/rest/v1/variations/nobg"
VARIATION_URL = "https://cloud.leonardo.ai/api/rest/v1/variations"
MODEL = "gpt-image-1.5"

ROOT = Path(__file__).parent
OUTPUT_DIR = ROOT / "client" / "assets" / "images" / "tuneshop"

BG_PROMPT = (
    "Dark cinematic underground tuning garage, luxury crime empire aesthetic, "
    "dramatic neon lighting in deep blue and amber, high-end sports cars on hydraulic lifts, "
    "chrome tools and engine parts on workbenches, moody shadows, photorealistic, "
    "mafia noir atmosphere, cinematic depth of field, no people, no text, no watermark"
)

EMBLEM_PROMPT = (
    "Premium metallic wrench and gear emblem, chrome finish, mafia crime empire style, "
    "cinematic rim lighting, deep metallic texture, isolated icon on transparent background, "
    "no text, no watermark, no background, centered composition, game UI badge style"
)

NEGATIVE_PROMPT = (
    "cartoon, anime, text, watermark, logo, bright flat colors, "
    "daytime outdoor scene, people, faces, low quality, blurry"
)

ASSETS = [
    {
        "key": "bg",
        "filename": "tuneshop_bg_desktop.jpg",
        "prompt": BG_PROMPT,
        "width": 1024,
        "height": 1024,
        "transparent": False,
        "resize": (1920, 1080),
    },
    {
        "key": "bg_tablet",
        "filename": "tuneshop_bg_tablet.jpg",
        "prompt": BG_PROMPT,
        "width": 1024,
        "height": 1024,
        "transparent": False,
        "resize": (1024, 768),
    },
    {
        "key": "bg_mobile",
        "filename": "tuneshop_bg_mobile.jpg",
        "prompt": BG_PROMPT,
        "width": 1024,
        "height": 1024,
        "transparent": False,
        "resize": (390, 844),
    },
    {
        "key": "emblem",
        "filename": "tuneshop_emblem.png",
        "prompt": EMBLEM_PROMPT,
        "width": 1024,
        "height": 1024,
        "transparent": True,
        "resize": None,
    },
]


def get_headers():
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "accept": "application/json",
    }


def extract_generation_id(payload):
    if isinstance(payload, list):
        return None
    # v2 response: {"generate": {"generationId": "..."}}
    if "generate" in payload and isinstance(payload["generate"], dict):
        gen_id = payload["generate"].get("generationId")
        if gen_id:
            return gen_id
    # v1 response: {"sdGenerationJob": {"generationId": "..."}}
    if "sdGenerationJob" in payload:
        return payload["sdGenerationJob"].get("generationId")
    return payload.get("generationId")


def extract_status(payload):
    gen = payload.get("generations_by_pk") or payload.get("generation_by_pk") or {}
    return gen.get("status")


def extract_image_url(payload):
    gen = payload.get("generations_by_pk") or payload.get("generation_by_pk") or {}
    images = gen.get("generated_images") or []
    if not images:
        return None, None
    first = images[0]
    return first.get("url"), first.get("id")


def has_clean_transparency(image_bytes):
    with Image.open(io.BytesIO(image_bytes)) as img:
        rgba = img.convert("RGBA")
        w, h = rgba.size
        alpha = rgba.getchannel("A")
        corners = [(0, 0), (w-1, 0), (0, h-1), (w-1, h-1)]
        return all(alpha.getpixel(p) == 0 for p in corners)


def create_nobg_variation(image_id):
    resp = requests.post(
        NOBG_URL,
        headers=get_headers(),
        json={"id": image_id, "isVariation": False},
        timeout=90,
    )
    resp.raise_for_status()
    job = resp.json().get("sdNobgJob") or {}
    variation_id = job.get("id")
    if not variation_id:
        raise RuntimeError("No variation ID returned by nobg endpoint")
    return variation_id


def poll_nobg(variation_id, max_polls=120, interval=3.0):
    for _ in range(max_polls):
        resp = requests.get(f"{VARIATION_URL}/{variation_id}", headers=get_headers(), timeout=60)
        resp.raise_for_status()
        variations = resp.json().get("generated_image_variation_generic") or []
        if variations:
            v = variations[0]
            if v.get("status") == "COMPLETE" and v.get("url"):
                return v["url"]
            if v.get("status") == "FAILED":
                raise RuntimeError("nobg variation failed")
        time.sleep(interval)
    raise TimeoutError("Timed out waiting for nobg variation")


def generate_image(asset, max_polls=120, poll_interval=3.0):
    print(f"  Submitting: {asset['filename']} ...", flush=True)

    payload = {
        "model": MODEL,
        "parameters": {
            "width": asset["width"],
            "height": asset["height"],
            "prompt": asset["prompt"],
            "negative_prompt": NEGATIVE_PROMPT,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    resp = requests.post(GENERATE_URL_V2, headers=get_headers(), json=payload, timeout=90)

    if not resp.ok:
        print(f"  ERROR HTTP {resp.status_code}: {resp.text[:300]}", flush=True)
        resp.raise_for_status()

    response_json = resp.json()
    gen_id = extract_generation_id(response_json)

    if not gen_id:
        raise RuntimeError(f"No generation ID returned: {response_json}")

    print(f"  Polling generationId={gen_id} ...", flush=True)

    for poll_num in range(max_polls):
        time.sleep(poll_interval)
        poll = requests.get(f"{STATUS_URL}/{gen_id}", headers=get_headers(), timeout=60)
        poll.raise_for_status()
        poll_json = poll.json()
        status = extract_status(poll_json)
        image_url, image_id = extract_image_url(poll_json)

        print(f"  Poll {poll_num+1}: status={status}", flush=True)

        if status == "FAILED":
            raise RuntimeError(f"Generation failed (generationId={gen_id})")

        if image_url:
            print(f"  Downloading from {image_url[:60]}...", flush=True)
            img_resp = requests.get(image_url, timeout=60)
            img_resp.raise_for_status()
            image_bytes = img_resp.content
            content_type = (img_resp.headers.get("Content-Type") or "").lower()
            is_jpeg = "jpeg" in content_type or image_url.lower().endswith((".jpg", ".jpeg"))

            if asset["transparent"]:
                # Need clean transparency
                if not is_jpeg and has_clean_transparency(image_bytes):
                    return image_bytes

                # Try nobg variation
                if not image_id:
                    raise RuntimeError("Need nobg fallback but no image ID returned")

                print(f"  Alpha not clean, requesting nobg variation ...", flush=True)
                variation_id = create_nobg_variation(image_id)
                variation_url = poll_nobg(variation_id)
                cleaned = requests.get(variation_url, timeout=60)
                cleaned.raise_for_status()
                cleaned_bytes = cleaned.content
                if not has_clean_transparency(cleaned_bytes):
                    raise RuntimeError("nobg variation still has dirty alpha")
                return cleaned_bytes
            else:
                return image_bytes

    raise TimeoutError(f"Timed out waiting for {asset['filename']}")


def save_image(asset, image_bytes, output_dir):
    out_path = output_dir / asset["filename"]

    if asset["transparent"]:
        with Image.open(io.BytesIO(image_bytes)) as img:
            img.convert("RGBA").save(out_path, format="PNG")
    else:
        with Image.open(io.BytesIO(image_bytes)) as img:
            if asset["resize"]:
                img = img.resize(asset["resize"], Image.LANCZOS)
            rgb = img.convert("RGB")
            rgb.save(out_path, format="JPEG", quality=92)

    print(f"  Saved: {out_path.name} ({out_path.stat().st_size // 1024} KB)", flush=True)


def main():
    if not API_KEY:
        print("ERROR: LEONARDO_API_KEY not set")
        return

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Output dir: {OUTPUT_DIR}", flush=True)
    print(f"Model: {MODEL}", flush=True)
    print(f"Generating {len(ASSETS)} TuneShop assets...\n", flush=True)

    success = 0
    failed = 0

    for asset in ASSETS:
        print(f"[{asset['key']}] {asset['filename']}", flush=True)
        attempts = 3
        for attempt in range(1, attempts + 1):
            try:
                image_bytes = generate_image(asset)
                save_image(asset, image_bytes, OUTPUT_DIR)
                success += 1
                print(f"  OK (attempt {attempt})\n", flush=True)
                break
            except Exception as exc:
                print(f"  Attempt {attempt}/{attempts} failed: {exc}", flush=True)
                if attempt < attempts:
                    print(f"  Retrying in 10s...", flush=True)
                    time.sleep(10)
                else:
                    print(f"  FAILED after {attempts} attempts\n", flush=True)
                    failed += 1

    print(f"\nDone: {success} generated, {failed} failed")


if __name__ == "__main__":
    main()
