"""Generate transparent crypto coin icons for all tradeable assets via Leonardo.ai."""

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
OUTPUT_DIR = ROOT / "client" / "assets" / "images" / "crypto" / "icons"

ASSETS = [
    ("btc", "Bitcoin"),
    ("eth", "Ethereum"),
    ("sol", "Solana"),
    ("xrp", "XRP"),
    ("ada", "Cardano"),
    ("doge", "Dogecoin"),
    ("avax", "Avalanche"),
    ("dot", "Polkadot"),
    ("matic", "Polygon"),
    ("ltc", "Litecoin"),
    ("link", "Chainlink"),
    ("atom", "Cosmos"),
    ("uni", "Uniswap"),
    ("aave", "Aave"),
    ("fil", "Filecoin"),
    ("arb", "Arbitrum"),
    ("op", "Optimism"),
    ("near", "NEAR Protocol"),
    ("inj", "Injective"),
    ("apt", "Aptos"),
    ("sui", "Sui"),
    ("theta", "Theta Network"),
    ("algo", "Algorand"),
    ("vet", "VeChain"),
    ("trx", "TRON"),
    ("xlm", "Stellar"),
    ("eos", "EOS"),
    ("kas", "Kaspa"),
    ("sei", "Sei"),
    ("pepe", "Pepe"),
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


def generate_icon(name: str):
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }

    prompt = (
        f"Premium crypto coin icon for {name}, metallic engraved token, game UI style, centered object, no text, no watermark. "
        "CRITICAL: True RGBA PNG with fully transparent background alpha 0 outside coin silhouette"
    )

    payload = {
        "model": MODEL,
        "parameters": {
            "width": 1024,
            "height": 1024,
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

            if not is_jpeg and has_clean_transparency(image_bytes):
                return image_bytes

            if not image_id:
                if is_jpeg:
                    raise RuntimeError("Icon requires transparent PNG but Leonardo returned JPEG without image ID for fallback.")
                raise RuntimeError("Icon alpha is not clean and Leonardo did not return an image ID for no-background fallback.")

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

    raise TimeoutError("Timed out while waiting for icon generation")


def main():
    if not API_KEY:
        print("ERROR: LEONARDO_API_KEY missing")
        return

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    success = 0
    failed = []

    for idx, (slug, name) in enumerate(ASSETS, 1):
        print(f"[{idx}/{len(ASSETS)}] {slug}.png")
        out_path = OUTPUT_DIR / f"{slug}.png"
        saved = False
        for attempt in range(1, 4):
            try:
                image_data = generate_icon(name)
                out_path.write_bytes(image_data)
                success += 1
                saved = True
                print(f"  OK (attempt {attempt}) -> {out_path}")
                break
            except Exception as exc:
                print(f"  FAIL (attempt {attempt}) -> {exc}")
                time.sleep(8)

        if not saved:
            failed.append(f"{slug}.png")

        time.sleep(2)

    print(f"Done: {success}/{len(ASSETS)} generated")
    if failed:
        print("Failed files:")
        for item in failed:
            print(f"- {item}")


if __name__ == "__main__":
    main()
