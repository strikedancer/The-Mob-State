#!/usr/bin/env python3
"""Generate black-market material icons via Leonardo + rembg alpha.

Writes:
- client/assets/images/materials/<id>.png  (Flutter bundle)
- client/images/materials/<id>.png         (nginx alias copy)

Filenames must match MaterialDefinition.id in backend/content/drugs.json.
"""

from __future__ import annotations

import argparse
import os
import shutil
import time
from io import BytesIO
from pathlib import Path

import requests
from PIL import Image
from PIL import ImageOps

try:
    from rembg import remove as rembg_remove
except Exception:  # noqa: BLE001
    rembg_remove = None

ROOT = Path(__file__).resolve().parents[2]
ASSET_DIR = ROOT / "client" / "assets" / "images" / "materials"
MIRROR_DIR = ROOT / "client" / "images" / "materials"
RUNTIME_DIR = ROOT / "runtime" / "client-images" / "materials"
ENV_CANDIDATES = [
    ROOT / "backend" / ".env.local",
    ROOT / ".env",
    ROOT / "backend" / ".env",
]


def _load_local_env_value(key: str) -> str:
    for env_path in ENV_CANDIDATES:
        if not env_path.exists():
            continue
        for raw_line in env_path.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            name, value = line.split("=", 1)
            if name.strip() != key:
                continue
            return value.strip().strip('"').strip("'")
    return ""


API_KEY = os.getenv("LEONARDO_API_KEY", "") or _load_local_env_value("LEONARDO_API_KEY")
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL_V1 = "https://cloud.leonardo.ai/api/rest/v1/generations"
DEFAULT_MODEL = "gpt-image-1.5"

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, white background, grey background, "
    "checkerboard, photo studio plate, frame, border, blurry, low detail, cartoon, anime"
)

ICON_STYLE = (
    "Stylized mobile game item icon, isolated centered subject, clean dark outlines, "
    "vibrant readable colors at small size, true transparent PNG alpha background, "
    "no white plate, no checkerboard, no text, no watermark"
)

ASSETS = [
    {
        "name": "hash_press",
        "prompt": (
            f"{ICON_STYLE}, compact hydraulic workshop press with two heavy steel plates "
            "and a hand wheel, dark metal, amber rim light, hash-making equipment"
        ),
    },
    {
        "name": "mushroom_spores",
        "prompt": (
            f"{ICON_STYLE}, glass spore syringe and a small sealed jar of brown mushroom "
            "spores, mycological cultivation mood, teal and earth tones"
        ),
    },
    {
        "name": "lab_filter",
        "prompt": (
            f"{ICON_STYLE}, laboratory Buchner funnel with filter paper over a glass flask, "
            "stainless clamp, cool clinical lighting"
        ),
    },
    {
        "name": "lsd_precursor",
        "prompt": (
            f"{ICON_STYLE}, amber reagent bottle with dropper and a sealed glass vial of "
            "pale crystalline powder, underground chemistry mood, purple accent"
        ),
    },
    {
        "name": "fentanyl_precursor",
        "prompt": (
            f"{ICON_STYLE}, sealed pharmaceutical amber vial with crimp cap and a small "
            "medical ampoule, sterile but illicit chemistry mood, cold blue accent"
        ),
    },
    {
        "name": "mdma_precursor",
        "prompt": (
            f"{ICON_STYLE}, compact yellow-and-black hazard chemical drum with skull "
            "warning triangle, metallic rims, no readable text"
        ),
    },
    {
        "name": "lab_chemicals",
        "prompt": (
            f"{ICON_STYLE}, cluster of colored reagent bottles and a round flask with "
            "glowing green liquid, underground lab chemistry"
        ),
    },
    {
        "name": "ephedrine",
        "prompt": (
            f"{ICON_STYLE}, translucent orange pill bottle with white cap, a few beige "
            "tablets visible inside, no loose white powder pile, high contrast"
        ),
    },
]


def _headers() -> dict:
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "Accept": "application/json",
    }


def _extract_generation_id(payload) -> str | None:
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None
    if payload.get("sdGenerationJob", {}).get("generationId"):
        return payload["sdGenerationJob"]["generationId"]
    if payload.get("generationId"):
        return payload["generationId"]
    generate = payload.get("generate", {})
    if isinstance(generate, dict) and generate.get("generationId"):
        return generate["generationId"]
    data = payload.get("data", {})
    if isinstance(data, dict) and data.get("generationId"):
        return data["generationId"]
    if isinstance(data, dict) and data.get("id"):
        return str(data["id"])
    return None


def _extract_status_and_url(payload) -> tuple[str | None, str | None]:
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None, None
    gen = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not gen:
        gen = payload.get("generation") or payload.get("data", {}).get("generation")
    if not gen:
        return None, None
    if isinstance(gen, list):
        gen = gen[0] if gen else {}
    if not isinstance(gen, dict):
        return None, None
    status = gen.get("status")
    images = gen.get("generated_images") or gen.get("images") or []
    if not images:
        return status, None
    first = images[0] if isinstance(images[0], dict) else {}
    return status, first.get("url") or first.get("imageUrl")


def _generate_one(prompt: str, negative: str, model: str, width: int, height: int) -> str:
    payload = {
        "model": model,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "negative_prompt": negative,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }
    create_resp = requests.post(GENERATE_URL_V2, headers=_headers(), json=payload, timeout=90)
    create_resp.raise_for_status()
    generation_id = _extract_generation_id(create_resp.json())
    if not generation_id:
        raise RuntimeError("No generation ID returned")

    for _ in range(240):
        poll_resp = requests.get(f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60)
        poll_resp.raise_for_status()
        status, image_url = _extract_status_and_url(poll_resp.json())
        if status == "FAILED":
            raise RuntimeError(f"Generation failed ({generation_id})")
        if status == "COMPLETE" and image_url:
            return image_url
        time.sleep(2)
    raise TimeoutError(f"Timed out waiting for {generation_id}")


def _save_image(url: str, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    img = requests.get(url, timeout=90)
    img.raise_for_status()
    out_path.write_bytes(img.content)


def _reshape_to_target(path: Path, target: int) -> None:
    with Image.open(path) as im:
        fitted = ImageOps.fit(im.convert("RGBA"), (target, target), method=Image.Resampling.LANCZOS)
        fitted.save(path, format="PNG")


def _count_transparent_pixels(path: Path) -> int:
    with Image.open(path) as im:
        alpha = im.convert("RGBA").getchannel("A")
        return int(sum(alpha.histogram()[:255]))


def _ensure_transparency(path: Path) -> bool:
    if _count_transparent_pixels(path) >= 50:
        return True
    if rembg_remove is None:
        return False
    raw = path.read_bytes()
    out = rembg_remove(raw)
    with Image.open(BytesIO(out)) as removed:
        removed.convert("RGBA").save(path, format="PNG")
    return _count_transparent_pixels(path) >= 50


def _mirror(path: Path) -> None:
    for dest_dir in (MIRROR_DIR, RUNTIME_DIR):
        dest = dest_dir / path.name
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, dest)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate material shop icons via Leonardo")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--only", default="", help="Comma-separated material ids")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument("--size", type=int, default=1024)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    wanted = {part.strip() for part in args.only.split(",") if part.strip()}
    items = [item for item in ASSETS if not wanted or item["name"] in wanted]

    print(f"Planned generations: {len(items)}")
    for item in items:
        print(f"- {item['name']} -> {ASSET_DIR / (item['name'] + '.png')}")

    if not API_KEY:
        raise RuntimeError("LEONARDO_API_KEY is not set")
    if args.confirm_batch != "YES":
        raise RuntimeError("Safety stop: add --confirm-batch YES to run generation")

    success = 0
    skipped = 0
    failed = 0

    for item in items:
        out_path = ASSET_DIR / f"{item['name']}.png"
        if out_path.exists() and not args.force:
            skipped += 1
            print(f"skip (exists): {out_path}")
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                url = _generate_one(item["prompt"], NEGATIVE_PROMPT, args.model, args.size, args.size)
                _save_image(url, out_path)
                _reshape_to_target(out_path, args.size)
                if not _ensure_transparency(out_path):
                    raise RuntimeError("Output has no true transparency (install rembg)")
                _mirror(out_path)
                print(f"saved: {out_path}")
                generated = True
                success += 1
                break
            except Exception as exc:  # noqa: BLE001
                print(f"  attempt failed: {exc}")
                if attempt < args.attempts:
                    time.sleep(args.sleep)

        if not generated:
            failed += 1
        time.sleep(args.sleep)

    print("--- Done ---")
    print(f"generated: {success}")
    print(f"skipped: {skipped}")
    print(f"failed: {failed}")


if __name__ == "__main__":
    main()
