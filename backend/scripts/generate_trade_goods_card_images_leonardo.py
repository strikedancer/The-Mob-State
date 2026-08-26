#!/usr/bin/env python3
"""Generate Trade screen good-card thumbnails (5 PNGs) via Leonardo API.

Writes to:
  runtime/client-images/trade_goods/cards/<good_id>.png

Optional mirror:
  client/assets/images/trade_goods/cards/

Requires LEONARDO_API_KEY (env or backend/.env.local per PROTOCOL_MASTER).
"""

from __future__ import annotations

import argparse
import os
import shutil
import time
from pathlib import Path
from typing import Dict, List, Tuple

import requests

ROOT = Path(__file__).resolve().parents[2]
ENV_CANDIDATES = [
    ROOT / "backend" / ".env.local",
    ROOT / ".env",
    ROOT / "backend" / ".env",
    ROOT / ".env.docker",
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
DEFAULT_WIDTH = 1024
DEFAULT_HEIGHT = 1024

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, blurry, low detail, "
    "cartoon, anime, oversaturated neon, frame, border, collage, real bank trademarks"
)


def _headers() -> Dict[str, str]:
    return {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "accept": "application/json",
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
    if payload.get("id"):
        return str(payload["id"])
    if payload.get("generation_id"):
        return str(payload["generation_id"])
    if payload.get("jobId"):
        return str(payload["jobId"])
    generate = payload.get("generate", {})
    if isinstance(generate, dict) and generate.get("generationId"):
        return generate["generationId"]
    data = payload.get("data", {})
    if isinstance(data, dict) and data.get("generationId"):
        return data["generationId"]
    if isinstance(data, dict) and data.get("id"):
        return str(data["id"])
    return None


def _extract_status_and_url(payload) -> Tuple[str | None, str | None]:
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


def _generate_one(prompt: str, model: str) -> str:
    payload_variants = [
        {
            "model": model,
            "parameters": {
                "width": DEFAULT_WIDTH,
                "height": DEFAULT_HEIGHT,
                "prompt": prompt,
                "negative_prompt": NEGATIVE_PROMPT,
                "quantity": 1,
                "prompt_enhance": "OFF",
            },
            "public": False,
        },
        {
            "model": model,
            "parameters": {
                "width": DEFAULT_WIDTH,
                "height": DEFAULT_HEIGHT,
                "prompt": prompt,
                "negative_prompt": NEGATIVE_PROMPT,
                "quantity": 1,
            },
            "public": False,
        },
    ]

    last_payload = None
    last_error: Exception | None = None
    generation_id = None

    for variant in payload_variants:
        try:
            create_resp = requests.post(
                GENERATE_URL_V2,
                headers=_headers(),
                json=variant,
                timeout=90,
            )
            create_resp.raise_for_status()
            create_payload = create_resp.json()
            generation_id = _extract_generation_id(create_payload)
            if generation_id:
                break
            last_payload = create_payload
            last_error = RuntimeError("No generation ID returned")
        except Exception as exc:  # noqa: BLE001
            last_error = exc

    if not generation_id:
        snippet = str(last_payload if last_payload is not None else last_error)
        if len(snippet) > 1600:
            snippet = snippet[:1600] + "..."
        raise RuntimeError(f"No generation ID returned. API payload: {snippet}")

    for _ in range(240):
        poll_resp = requests.get(
            f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60
        )
        poll_resp.raise_for_status()
        status, image_url = _extract_status_and_url(poll_resp.json())
        if status == "FAILED":
            raise RuntimeError(f"Generation failed ({generation_id})")
        if status == "COMPLETE" and image_url:
            return image_url
        time.sleep(2)

    raise TimeoutError(f"Timed out waiting for generation {generation_id}")


def _save_image(url: str, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    response = requests.get(url, timeout=90)
    response.raise_for_status()
    out_path.write_bytes(response.content)


def _good_prompts() -> List[dict]:
    """Square card art; filenames must match TradableGood.id."""
    return [
        {
            "id": "contraband_flowers",
            "prompt": (
                "Cinematic dark-mafia mobile game item icon, luxury flower crate with tulips and roses, "
                "warehouse dock light, shallow depth of field, compact centered, noir mood, no text"
            ),
        },
        {
            "id": "contraband_electronics",
            "prompt": (
                "Cinematic dark-mafia game item icon, sealed cartons of high-end electronics and laptops, "
                "cool blue rim light, compact composition, no logos, no text"
            ),
        },
        {
            "id": "contraband_diamonds",
            "prompt": (
                "Cinematic dark-mafia game item icon, velvet tray with rough diamonds catching cold light, "
                "teal and gold reflections, compact centered, no text"
            ),
        },
        {
            "id": "contraband_weapons",
            "prompt": (
                "Cinematic noir game item icon, black cases with discreet firearm silhouettes, "
                "red alarm rim light, gritty metal texture, no readable markings, no text"
            ),
        },
        {
            "id": "contraband_pharmaceuticals",
            "prompt": (
                "Cinematic dark-mafia game item icon, sealed medical crates and amber pill bottles, "
                "clinical green accent, sterile warehouse, no brand names, no text"
            ),
        },
        {
            "id": "contraband_spirits",
            "prompt": (
                "Cinematic dark-mafia game item icon, wooden crate with premium whisky and cognac bottles, "
                "warm amber rim light, noir bar backroom mood, no labels, no text"
            ),
        },
        {
            "id": "contraband_tobacco",
            "prompt": (
                "Cinematic noir game item icon, shrink-wrapped cartons of untaxed cigarettes and tobacco, "
                "brown warehouse tones, compact centered, no brand names, no text"
            ),
        },
        {
            "id": "contraband_art",
            "prompt": (
                "Cinematic dark-mafia game item icon, wrapped antique painting and small bronze statue, "
                "gold and teal reflections, museum heist mood, no text"
            ),
        },
        {
            "id": "contraband_spices",
            "prompt": (
                "Cinematic noir game item icon, burlap sacks of colorful exotic spices and chili peppers, "
                "warm warehouse light, compact centered, no text"
            ),
        },
        {
            "id": "contraband_coffee",
            "prompt": (
                "Cinematic dark-mafia game item icon, burlap coffee sacks and roasted beans, "
                "rich brown tones, steam hint, compact centered, no text"
            ),
        },
        {
            "id": "contraband_fur_leather",
            "prompt": (
                "Cinematic noir game item icon, rolled exotic fur pelts and leather hides on a crate, "
                "cold blue rim light, gritty texture, no text"
            ),
        },
        {
            "id": "contraband_perfume",
            "prompt": (
                "Cinematic dark-mafia game item icon, luxury perfume bottles in a padded crate, "
                "gold and glass reflections, compact centered, no brand names, no text"
            ),
        },
        {
            "id": "contraband_counterfeit_cash",
            "prompt": (
                "Cinematic noir game item icon, shrink-wrapped bricks of banknotes in a duffel bag, "
                "green accent light, clandestine mood, no readable currency text"
            ),
        },
        {
            "id": "contraband_rare_wine",
            "prompt": (
                "Cinematic dark-mafia game item icon, wooden case of vintage wine bottles with wax seals, "
                "cellar mood, purple and amber light, no labels, no text"
            ),
        },
        {
            "id": "contraband_luxury_watches",
            "prompt": (
                "Cinematic noir game item icon, velvet tray with luxury wristwatches catching cold light, "
                "teal and gold reflections, compact centered, no logos, no text"
            ),
        },
        {
            "id": "contraband_gold",
            "prompt": (
                "Cinematic dark-mafia game item icon, stacked unmarked gold bars on black velvet, "
                "heavy gold gleam, vault mood, compact centered, no text"
            ),
        },
    ]


def _mirror_client_assets(generated_paths: List[Path]) -> None:
    for src in generated_paths:
        rel = src.relative_to(ROOT / "runtime" / "client-images" / "trade_goods")
        dst = ROOT / "client" / "assets" / "images" / "trade_goods" / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Generate trade goods card images via Leonardo")
    p.add_argument("--model", default=DEFAULT_MODEL)
    p.add_argument("--sleep", type=float, default=2.0)
    p.add_argument("--force", action="store_true")
    p.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "trade_goods"),
    )
    p.add_argument(
        "--mirror-client-assets",
        action="store_true",
        help="Copy PNGs to client/assets/images/trade_goods/",
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()
    if not API_KEY:
        raise SystemExit("LEONARDO_API_KEY missing (env or backend/.env.local)")

    root = Path(args.output_root)
    cards_dir = root / "cards"
    jobs = [{"id": item["id"], "out": cards_dir / f"{item['id']}.png", "prompt": item["prompt"]} for item in _good_prompts()]

    print(f"Planned: {len(jobs)} images -> {cards_dir}")
    done: List[Path] = []
    for job in jobs:
        out = job["out"]
        if out.exists() and not args.force:
            print(f"skip exists: {out.name}")
            continue
        print(f"generate: {job['id']} ...")
        url = _generate_one(job["prompt"], args.model)
        _save_image(url, out)
        done.append(out)
        time.sleep(args.sleep)

    if args.mirror_client_assets and done:
        _mirror_client_assets(done)
        print("mirrored to client/assets/images/trade_goods/")

    print("done")


if __name__ == "__main__":
    main()
