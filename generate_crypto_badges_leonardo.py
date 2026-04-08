"""Generate crypto achievement badges via Leonardo.ai.

Reads prompts from CRYPTO_BADGES_LEONARDO_PROMPTS.md and writes PNG files to:
client/assets/images/achievements/badges/trade/
"""

import argparse
import io
import os
import re
import time
from pathlib import Path

import requests
from PIL import Image

API_KEY = os.getenv("LEONARDO_API_KEY", "")
GENERATE_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
NOBG_URL = "https://cloud.leonardo.ai/api/rest/v1/variations/nobg"
VARIATION_URL = "https://cloud.leonardo.ai/api/rest/v1/variations"
DEFAULT_MODEL = "gpt-image-1.5"
TRANSPARENCY_ELEMENT_UUID = "5f3e58d8-7af3-4d5b-92e3-a3d04b9a3414"
SHIELD_STYLE_PREFIX = (
    "Achievement badge style lock: classic heraldic SHIELD silhouette only, "
    "beveled metallic shield rim, center icon embedded inside the shield body, "
    "same visual family as premium game shield badges, realistic metallic rendering, no cartoon style, "
    "no standalone object mark. "
)
NEGATIVE_PROMPT = (
    "round coin icon only, circular token only, loose object render, portrait scene, "
    "rectangle card, square tile, banner, text label, watermark, cartoon, anime, mascot style"
)

ROOT = Path(__file__).parent
PROMPTS_MD = ROOT / "CRYPTO_BADGES_LEONARDO_PROMPTS.md"
OUTPUT_DIR = ROOT / "client" / "assets" / "images" / "achievements" / "badges" / "trade"


def parse_prompts(md_path: Path):
    text = md_path.read_text(encoding="utf-8")
    pattern_crypto = re.compile(
        r"##\s+\d+\)\s+([^\n]+)\nPrompt:\n(.*?)(?=\n##\s+\d+\)|\Z)",
        re.DOTALL,
    )
    entries = []
    for filename, prompt in pattern_crypto.findall(text):
        entries.append(
            {
                "filename": filename.strip(),
                "prompt": " ".join(line.strip() for line in prompt.strip().splitlines()),
            }
        )

    # Supports blocks like:
    # ### `file.png`
    # Prompt: ...
    if not entries:
        pattern_generic = re.compile(
            r"###\s+`([^`]+)`\s*\nPrompt:\s*(.*?)(?=\n###\s+`|\n---|\Z)",
            re.DOTALL,
        )
        for filename, prompt in pattern_generic.findall(text):
            entries.append(
                {
                    "filename": filename.strip(),
                    "prompt": " ".join(line.strip() for line in prompt.strip().splitlines()),
                }
            )

    # Supports blocks like:
    # name_key
    # Prompt: ...
    # Output: trade/file.png
    if not entries:
        pattern_nightclub = re.compile(
            r"^[ \t]*[a-z0-9_]+\s*\nPrompt:\s*(.*?)\nOutput:\s*trade/([^\s]+)\s*$",
            re.DOTALL | re.MULTILINE,
        )
        for prompt, filename in pattern_nightclub.findall(text):
            entries.append(
                {
                    "filename": filename.strip(),
                    "prompt": " ".join(line.strip() for line in prompt.strip().splitlines()),
                }
            )

    return entries


def is_uuid_model(model_name: str):
    return bool(re.fullmatch(r"[0-9a-fA-F-]{36}", model_name or ""))


def extract_generation_id(payload):
    if isinstance(payload, list):
        return None
    if "sdGenerationJob" in payload and payload["sdGenerationJob"].get("generationId"):
        return payload["sdGenerationJob"]["generationId"]
    if "generationId" in payload:
        return payload["generationId"]
    generate = payload.get("generate", {}) if isinstance(payload, dict) else {}
    if isinstance(generate, dict) and generate.get("generationId"):
        return generate.get("generationId")
    nested = payload.get("data", {}) if isinstance(payload, dict) else {}
    return nested.get("generationId")


def extract_api_error(payload):
    if isinstance(payload, list) and payload:
        first = payload[0] if isinstance(payload[0], dict) else {}
        details = first.get("extensions", {}).get("details", {}) if isinstance(first, dict) else {}
        message = details.get("message") or first.get("message")
        if message:
            return message
    if isinstance(payload, dict):
        details = payload.get("extensions", {}).get("details", {})
        message = details.get("message") or payload.get("message")
        if message:
            return message
    return None


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


def get_headers():
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "accept": "application/json",
    }


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


def create_nobg_variation(image_id: str):
    headers = get_headers()
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


def poll_nobg_variation(variation_id: str, max_polls: int, poll_interval: float):
    headers = get_headers()

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


def generate_single(prompt: str, width: int, height: int, max_polls: int, poll_interval: float, model: str):
    headers = get_headers()
    full_prompt = f"{SHIELD_STYLE_PREFIX}{prompt}".strip()
    use_v2 = not is_uuid_model(model)

    if use_v2:
        payload = {
            "model": model,
            "parameters": {
                "width": width,
                "height": height,
                "prompt": full_prompt,
                "negative_prompt": NEGATIVE_PROMPT,
                "quantity": 1,
                "prompt_enhance": "OFF",
            },
            "public": False,
        }
        resp = requests.post(GENERATE_URL_V2, headers=headers, json=payload, timeout=90)
    else:
        payload = {
            "alchemy": False,
            "prompt": full_prompt,
            "negative_prompt": NEGATIVE_PROMPT,
            "width": width,
            "height": height,
            "num_images": 1,
            "modelId": model,
            "transparency": "foreground_only",
            "elements": [
                {
                    "akUUID": TRANSPARENCY_ELEMENT_UUID,
                    "weight": 0.5,
                }
            ],
        }
        resp = requests.post(GENERATE_URL, headers=headers, json=payload, timeout=90)

    resp.raise_for_status()
    response_payload = resp.json()
    generation_id = extract_generation_id(response_payload)
    if not generation_id:
        api_error = extract_api_error(response_payload)
        if api_error:
            raise RuntimeError(f"Leonardo generate validation failed: {api_error}")
        raise RuntimeError(f"No generation ID returned by Leonardo (response: {response_payload})")

    for _ in range(max_polls):
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
                    raise RuntimeError("Badge requires transparent PNG but Leonardo returned JPEG without image ID for fallback.")
                raise RuntimeError("Badge alpha is not clean and Leonardo did not return an image ID for no-background fallback.")

            variation_id = create_nobg_variation(image_id)
            variation_url = poll_nobg_variation(variation_id, max_polls, poll_interval)
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
        time.sleep(poll_interval)

    raise TimeoutError("Timed out while waiting for Leonardo image generation")


def main():
    parser = argparse.ArgumentParser(description="Generate crypto achievement badges via Leonardo.ai")
    parser.add_argument("--single", dest="single", default="", help="Generate only one filename from the prompts file")
    parser.add_argument(
        "--include",
        dest="include",
        default="",
        help="Comma-separated filenames to include from the prompts file",
    )
    parser.add_argument("--quick", action="store_true", help="Use faster preview settings for single-badge generation")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Leonardo model ID/name to use (default: {DEFAULT_MODEL})")
    parser.add_argument(
        "--prompts-file",
        default=str(PROMPTS_MD),
        help=f"Path to prompts markdown (default: {PROMPTS_MD.name})",
    )
    parser.add_argument(
        "--output-dir",
        default=str(OUTPUT_DIR),
        help=f"Output directory (default: {OUTPUT_DIR})",
    )
    parser.add_argument("--width", type=int, default=None, help="Override generation width")
    parser.add_argument("--height", type=int, default=None, help="Override generation height")
    parser.add_argument("--max-polls", type=int, default=None, help="Override maximum poll attempts")
    parser.add_argument("--poll-interval", type=float, default=None, help="Override poll interval in seconds")
    parser.add_argument("--attempts", type=int, default=None, help="Override retry attempts per file")
    args = parser.parse_args()

    if not API_KEY:
        print("ERROR: LEONARDO_API_KEY missing")
        return

    prompts_path = Path(args.prompts_file)
    output_dir = Path(args.output_dir)

    output_dir.mkdir(parents=True, exist_ok=True)
    prompts = parse_prompts(prompts_path)

    if not prompts:
        print("ERROR: No prompts found")
        return

    if args.single:
        prompts = [entry for entry in prompts if entry["filename"] == args.single]
        if not prompts:
            print(f"ERROR: Prompt file not found in prompts list: {args.single}")
            return

    include_names = [item.strip() for item in args.include.split(",") if item.strip()]
    if include_names:
        include_set = set(include_names)
        prompts = [entry for entry in prompts if entry["filename"] in include_set]
        if not prompts:
            print("ERROR: None of the --include filenames were found in the prompts file")
            return

    quick_mode = args.quick
    max_polls = args.max_polls or (40 if quick_mode else 120)
    poll_interval = args.poll_interval or (2.0 if quick_mode else 3.0)
    attempts = args.attempts or (1 if quick_mode else 3)
    model = args.model
    is_gpt_image = model.lower().startswith("gpt-image")
    if is_gpt_image:
        width = args.width or 1024
        height = args.height or 1024
        if width < 1024 or height < 1024:
            print("ERROR: gpt-image models require at least 1024x1024 on Leonardo v2")
            return
    else:
        width = args.width or (768 if quick_mode else 1024)
        height = args.height or (768 if quick_mode else 1024)
    request_mode = "v2-model" if not is_uuid_model(model) else "v1-modelId"

    ok = 0
    failed = []

    print(
        f"Mode: {'quick' if quick_mode else 'standard'} | api_mode={request_mode} | model={model} | size={width}x{height} | max_polls={max_polls} | poll_interval={poll_interval}s | attempts={attempts}"
    )

    for idx, entry in enumerate(prompts, 1):
        filename = entry["filename"]
        prompt = entry["prompt"]
        print(f"[{idx}/{len(prompts)}] {filename}")
        out_path = output_dir / filename
        success = False
        for attempt in range(1, attempts + 1):
            try:
                data = generate_single(prompt, width, height, max_polls, poll_interval, model)
                out_path.write_bytes(data)
                ok += 1
                success = True
                print(f"  OK (attempt {attempt}) -> {out_path}")
                break
            except Exception as exc:
                print(f"  FAIL (attempt {attempt}) -> {exc}")
                if attempt < attempts:
                    time.sleep(8)

        if not success:
            failed.append(filename)
        time.sleep(2)

    print(f"Done: {ok}/{len(prompts)} generated")
    if failed:
        print("Failed files:")
        for item in failed:
            print(f"- {item}")


if __name__ == "__main__":
    main()
