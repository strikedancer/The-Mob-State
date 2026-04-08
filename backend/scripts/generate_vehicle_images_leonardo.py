#!/usr/bin/env python3
"""Generate realistic vehicle images through Leonardo API.

This script reads backend/content/vehicles.json and generates image variants
for each vehicle:
- new
- dirty
- damaged

By default it writes into client/assets/images/vehicles and skips files that
already exist. Use --force to overwrite.
"""

from __future__ import annotations

import argparse
import json
import os
import time
from io import BytesIO
from pathlib import Path
from typing import Dict, List, Tuple

import requests
from PIL import Image

try:
    from rembg import remove as rembg_remove
except Exception:  # noqa: BLE001
    rembg_remove = None

ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"
ASSET_DIR = ROOT / "client" / "assets" / "images" / "vehicles"

API_KEY = os.getenv("LEONARDO_API_KEY", "")
GENERATE_URL_V2 = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL_V1 = "https://cloud.leonardo.ai/api/rest/v1/generations"
DEFAULT_MODEL = "gpt-image-1.5"

STATE_PROMPTS = {
    "new": "factory-clean condition, polished paint, no dents, no rust, showroom realism",
    "dirty": "lightly dirty condition, road dust, subtle grime on lower panels, still fully functional",
    "damaged": "visibly damaged condition, dents, scratched paint, cracked lights, realistic wear and tear",
}

# Category-specific base prompts ensure the correct vehicle type is generated
CATEGORY_PROMPTS: dict = {
    "car": (
        "Ultra-realistic studio render of a four-wheeled automobile car: {name}. "
        "Four wheels, enclosed cabin, car body, automobile. "
        "Rarity tier: {rarity}. {state}. "
        "Single vehicle centered, no people, transparent background PNG with real alpha channel."
    ),
    "motorcycle": (
        "Ultra-realistic studio render of a two-wheeled motorcycle motorbike: {name}. "
        "Exactly two wheels, handlebars, saddle seat, exposed engine, no car body, no enclosed cabin. "
        "This is a motorcycle, not a car, not a truck, not a van. "
        "Rarity tier: {rarity}. {state}. "
        "Single motorcycle centered, no people, transparent background PNG with real alpha channel."
    ),
    "boat": (
        "Ultra-realistic studio render of a watercraft boat vessel: {name}. "
        "Floating boat hull, propeller or outboard motor, water vessel. "
        "Not a car, not a motorcycle. Rarity tier: {rarity}. {state}. "
        "Single boat centered, no people, transparent background PNG with real alpha channel."
    ),
}

NEGATIVE_PROMPT_BASE = (
    "cartoon, anime, low poly, watermark, logo, text label, poster frame, people, characters, scene background"
)

NEGATIVE_PROMPT_CAR = NEGATIVE_PROMPT_BASE + ", motorcycle, bike, two wheels, boat, ship"
NEGATIVE_PROMPT_MOTORCYCLE = NEGATIVE_PROMPT_BASE + ", car, automobile, sedan, SUV, truck, van, pickup, four wheels, enclosed cabin, boat, ship"
NEGATIVE_PROMPT_BOAT = NEGATIVE_PROMPT_BASE + ", car, motorcycle, bike, road vehicle, wheels"

# Keep backward-compat name used elsewhere
NEGATIVE_PROMPT = NEGATIVE_PROMPT_CAR

ALPHA_MIN_TRANSPARENT_PIXELS = 50


def _headers() -> Dict[str, str]:
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "accept": "application/json",
    }


def _extract_generation_id(payload) -> str | None:
    # API soms geeft een lijst terug ipv dict
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
    return None


def _extract_status_and_url(payload) -> Tuple[str | None, str | None]:
    # API soms geeft een lijst terug ipv dict
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None, None
    gen = payload.get("generations_by_pk") or payload.get("generation_by_pk")
    if not gen:
        gen = payload.get("generation") or payload.get("data", {}).get("generation")
    if not gen:
        return None, None
    # gen kan ook een lijst zijn
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


def load_vehicles() -> List[dict]:
    data = json.loads(VEHICLES_JSON.read_text(encoding="utf-8"))
    items: List[dict] = []
    for key, category in (("cars", "car"), ("boats", "boat"), ("motorcycles", "motorcycle")):
        for v in data.get(key, []):
            v = dict(v)
            v["vehicleCategory"] = category
            items.append(v)
    return items


def build_prompt(vehicle: dict, state: str) -> str:
    category = vehicle.get("vehicleCategory", "car")
    name = vehicle.get("name", "Unknown Vehicle")
    rarity = vehicle.get("rarity", "common")
    state_block = STATE_PROMPTS[state]

    template = CATEGORY_PROMPTS.get(category, CATEGORY_PROMPTS["car"])
    return template.format(name=name, rarity=rarity, state=state_block)


def negative_prompt_for_category(vehicle: dict) -> str:
    category = vehicle.get("vehicleCategory", "car")
    if category == "motorcycle":
        return NEGATIVE_PROMPT_MOTORCYCLE
    if category == "boat":
        return NEGATIVE_PROMPT_BOAT
    return NEGATIVE_PROMPT_CAR


def generate_one(prompt: str, model: str, width: int, height: int, negative_prompt: str = NEGATIVE_PROMPT) -> str:
    payload = {
        "model": model,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "negative_prompt": negative_prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    create_resp = requests.post(GENERATE_URL_V2, headers=_headers(), json=payload, timeout=90)
    create_resp.raise_for_status()
    generation_id = _extract_generation_id(create_resp.json())
    if not generation_id:
        raise RuntimeError("No generation ID returned by Leonardo API")

    for _ in range(240):
        poll_resp = requests.get(f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60)
        poll_resp.raise_for_status()
        status, image_url = _extract_status_and_url(poll_resp.json())
        if status == "FAILED":
            raise RuntimeError(f"Leonardo generation failed (id={generation_id})")
        if status == "COMPLETE" and image_url:
            return image_url
        time.sleep(2)

    raise TimeoutError(f"Timed out waiting for generation {generation_id}")


def save_image(url: str, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    img = requests.get(url, timeout=90)
    img.raise_for_status()
    out_path.write_bytes(img.content)


def _count_transparent_pixels(path: Path) -> int:
    with Image.open(path) as im:
        rgba = im.convert("RGBA")
        alpha = rgba.getchannel("A")
        hist = alpha.histogram()
        return int(sum(hist[:255]))


def _ensure_true_transparency(path: Path) -> bool:
    """Return True when output contains a real alpha cutout.

    If image is fully opaque and rembg is available, perform local background
    removal and overwrite the file.
    """
    transparent_pixels = _count_transparent_pixels(path)
    if transparent_pixels >= ALPHA_MIN_TRANSPARENT_PIXELS:
        return True

    if rembg_remove is None:
        return False

    raw = path.read_bytes()
    out = rembg_remove(raw)
    with Image.open(BytesIO(out)) as removed:
        removed.convert("RGBA").save(path, format="PNG")

    return _count_transparent_pixels(path) >= ALPHA_MIN_TRANSPARENT_PIXELS


def image_name_for_state(vehicle: dict, state: str) -> str:
    if state == "new":
        return vehicle.get("imageNew") or f"{vehicle['id']}_new.png"
    if state == "dirty":
        return vehicle.get("imageDirty") or f"{vehicle['id']}_dirty.png"
    return vehicle.get("imageDamaged") or f"{vehicle['id']}_damaged.png"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate vehicle images using Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--category", choices=["all", "car", "boat", "motorcycle"], default="all")
    parser.add_argument("--states", default="new,dirty,damaged", help="Comma-separated states")
    parser.add_argument("--start-index", type=int, default=0)
    parser.add_argument("--limit", type=int, default=0, help="0 means no limit")
    parser.add_argument("--width", type=int, default=1024)
    parser.add_argument("--height", type=int, default=1024)
    parser.add_argument("--attempts", type=int, default=3)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--estimate-only", action="store_true", help="Print the planned generation count and exit")
    parser.add_argument(
        "--confirm-batch",
        default="",
        help="Required safety token for dangerous runs. Use --confirm-batch YES to allow large or force-all runs.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if not API_KEY and not args.dry_run:
        raise RuntimeError("LEONARDO_API_KEY is not set")

    wanted_states = [s.strip() for s in args.states.split(",") if s.strip() in STATE_PROMPTS]
    if not wanted_states:
        raise RuntimeError("No valid states selected. Use new,dirty,damaged")

    vehicles = load_vehicles()
    if args.category != "all":
        vehicles = [v for v in vehicles if v.get("vehicleCategory") == args.category]

    vehicles = vehicles[args.start_index :]
    if args.limit > 0:
        vehicles = vehicles[: args.limit]

    planned_generations = len(vehicles) * len(wanted_states)

    print(f"Selected vehicles: {len(vehicles)}")
    print(f"States: {wanted_states}")
    print(f"Planned generations: {planned_generations}")

    dangerous_run = False
    danger_reasons: List[str] = []
    if args.category == "all":
        dangerous_run = True
        danger_reasons.append("category=all")
    if args.force:
        dangerous_run = True
        danger_reasons.append("--force")
    if planned_generations > 30:
        dangerous_run = True
        danger_reasons.append(f"planned_generations={planned_generations}")

    if args.estimate_only:
        print("estimate-only: no images will be generated")
        return

    if dangerous_run and args.confirm_batch != "YES":
        reasons = ", ".join(danger_reasons)
        raise RuntimeError(
            "Safety stop: refusing broad or expensive batch run without confirmation. "
            f"Reasons: {reasons}. Re-run with --confirm-batch YES if this is intentional, "
            "or use a smaller command such as --category motorcycle --limit 3 --attempts 1."
        )

    success = 0
    skipped = 0
    failed = 0

    for index, vehicle in enumerate(vehicles, start=1):
        name = vehicle.get("name", vehicle.get("id", "vehicle"))
        for state in wanted_states:
            target_name = image_name_for_state(vehicle, state)
            out_path = ASSET_DIR / target_name

            if out_path.exists() and not args.force:
                skipped += 1
                continue

            prompt = build_prompt(vehicle, state)
            print(f"[{index}/{len(vehicles)}] {name} - {state} -> {target_name}")

            if args.dry_run:
                print("  dry-run: skipped generation")
                continue

            neg_prompt = negative_prompt_for_category(vehicle)
            generated = False
            for attempt in range(1, args.attempts + 1):
                try:
                    url = generate_one(prompt, args.model, args.width, args.height, neg_prompt)
                    save_image(url, out_path)
                    if not _ensure_true_transparency(out_path):
                        raise RuntimeError(
                            "Image has no true transparency and local background removal "
                            "is unavailable or failed. Install rembg to auto-fix."
                        )
                    generated = True
                    success += 1
                    break
                except Exception as exc:  # noqa: BLE001
                    print(f"  attempt {attempt}/{args.attempts} failed: {exc}")
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
