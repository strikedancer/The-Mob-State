"""Generate crypto achievement shield badges via OpenAI GPT Image models.

Reads prompts from CRYPTO_BADGES_LEONARDO_PROMPTS.md and writes PNG files to:
client/assets/images/achievements/badges/trade/
"""

import argparse
import base64
import io
import os
import re
import time
from pathlib import Path

import requests
from PIL import Image

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
OPENAI_IMAGE_URL = "https://api.openai.com/v1/images/generations"
DEFAULT_MODEL = "gpt-image-1.5"

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
    pattern = re.compile(
        r"##\s+\d+\)\s+([^\n]+)\nPrompt:\n(.*?)(?=\n##\s+\d+\)|\Z)",
        re.DOTALL,
    )
    entries = []
    for filename, prompt in pattern.findall(text):
        entries.append(
            {
                "filename": filename.strip(),
                "prompt": " ".join(line.strip() for line in prompt.strip().splitlines()),
            }
        )
    return entries


def get_headers():
    return {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "Content-Type": "application/json",
    }


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


def generate_single(prompt: str, width: int, height: int, model: str, quick_mode: bool):
    full_prompt = (
        f"{SHIELD_STYLE_PREFIX}{prompt} "
        f"Avoid these outputs: {NEGATIVE_PROMPT}."
    ).strip()

    payload = {
        "model": model,
        "prompt": full_prompt,
        "size": f"{width}x{height}",
        "background": "transparent",
        "output_format": "png",
        "quality": "low" if quick_mode else "high",
    }

    resp = requests.post(
        OPENAI_IMAGE_URL,
        headers=get_headers(),
        json=payload,
        timeout=180,
    )
    if not resp.ok:
        raise RuntimeError(f"OpenAI image generation failed: {resp.status_code} {resp.text}")

    data = resp.json().get("data") or []
    if not data:
        raise RuntimeError("OpenAI image generation returned no image data")

    first = data[0]
    b64_data = first.get("b64_json")
    if b64_data:
        return base64.b64decode(b64_data)

    image_url = first.get("url")
    if image_url:
        img = requests.get(image_url, timeout=120)
        img.raise_for_status()
        return img.content

    raise RuntimeError("OpenAI image response had neither b64_json nor url")


def main():
    parser = argparse.ArgumentParser(description="Generate crypto achievement badges via OpenAI GPT Image")
    parser.add_argument("--single", dest="single", default="", help="Generate only one filename from the prompts file")
    parser.add_argument("--quick", action="store_true", help="Use faster preview settings for single-badge generation")
    parser.add_argument("--width", type=int, default=None, help="Override generation width")
    parser.add_argument("--height", type=int, default=None, help="Override generation height")
    parser.add_argument("--attempts", type=int, default=None, help="Override retry attempts per file")
    parser.add_argument("--sleep", type=float, default=2.0, help="Sleep in seconds between files")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Image model to use (default: {DEFAULT_MODEL})")
    args = parser.parse_args()

    if not OPENAI_API_KEY:
        print("ERROR: OPENAI_API_KEY missing")
        return

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    prompts = parse_prompts(PROMPTS_MD)

    if not prompts:
        print("ERROR: No prompts found")
        return

    if args.single:
        prompts = [entry for entry in prompts if entry["filename"] == args.single]
        if not prompts:
            print(f"ERROR: Prompt file not found in prompts list: {args.single}")
            return

    quick_mode = args.quick
    width = args.width or (768 if quick_mode else 1024)
    height = args.height or (768 if quick_mode else 1024)
    attempts = args.attempts or (1 if quick_mode else 3)

    ok = 0
    failed = []

    print(
        f"Provider: openai | model={args.model} | mode={'quick' if quick_mode else 'standard'} | "
        f"size={width}x{height} | attempts={attempts}"
    )

    for idx, entry in enumerate(prompts, 1):
        filename = entry["filename"]
        prompt = entry["prompt"]
        print(f"[{idx}/{len(prompts)}] {filename}")
        out_path = OUTPUT_DIR / filename
        success = False
        for attempt in range(1, attempts + 1):
            try:
                data = generate_single(prompt, width, height, args.model, quick_mode)
                if not has_clean_transparency(data):
                    raise RuntimeError("Generated PNG does not have clean alpha in sampled border points")
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
        time.sleep(args.sleep)

    print(f"Done: {ok}/{len(prompts)} generated")
    if failed:
        print("Failed files:")
        for item in failed:
            print(f"- {item}")


if __name__ == "__main__":
    main()
