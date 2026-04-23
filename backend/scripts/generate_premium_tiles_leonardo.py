#!/usr/bin/env python3
"""Generate Premium & Credits tile images via Leonardo API.

Outputs 12 themed 1024x1024 PNG files to:
  runtime/client-images/premium_tiles/

Optional mirror target:
  client/assets/images/premium_tiles/

File names are fixed because the Premium screen maps directly to these keys.
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
    "cartoon, anime, oversaturated neon, frame, border, collage"
)


def _premium_assets(output_root: Path) -> List[dict]:
    return [
        {
            "name": "player_vip",
            "out": output_root / "player_vip.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, close-up of an elite lone gangster in tailored suit, "
                "gold chain and subtle luxury details, moody amber rim light, smoky underground club vibe, "
                "premium status atmosphere, centered composition, no text"
            ),
        },
        {
            "name": "crew_vip",
            "out": output_root / "crew_vip.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, organized crew around a strategic table with city map and cash, "
                "team hierarchy and syndicate power feeling, blue-indigo and amber light contrast, "
                "underground headquarters mood, centered composition, no text"
            ),
        },
        {
            "name": "credits_250",
            "out": output_root / "credits_250.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, compact envelope with a small stack of marked cash and metal tokens on a backroom table, "
                "starter premium currency package theme, warm amber rim light, centered composition, no text"
            ),
        },
        {
            "name": "credits_500",
            "out": output_root / "credits_500.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, medium stash tray with cash stacks, casino chips and glowing credit tokens, "
                "mid-tier premium currency package theme, dramatic teal-amber lighting, centered composition, no text"
            ),
        },
        {
            "name": "credits_1000",
            "out": output_root / "credits_1000.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, open steel vault overflowing with cash, chips and premium coins, "
                "high-value top deal bundle, rich gold and emerald reflections, centered composition, no text"
            ),
        },
        {
            "name": "credits_2500",
            "out": output_root / "credits_2500.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, elite vault room filled with stacked cash crates, premium tokens and guarded ledgers, "
                "ultra-value premium currency package, powerful orange-gold cinematic lighting, centered composition, no text"
            ),
        },
        {
            "name": "shop_cash_bundle",
            "out": output_root / "shop_cash_bundle.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, duffel bag bursting with cash and marked bundles on desk, "
                "instant money boost purchase theme, gritty noir style, centered composition, no text"
            ),
        },
        {
            "name": "shop_hit_protection",
            "out": output_root / "shop_hit_protection.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, armored bodyguard silhouette and bulletproof shield in nightclub alley, "
                "contract protection against hitmen theme, blue tactical lighting, centered composition, no text"
            ),
        },
        {
            "name": "shop_vehicle_repair",
            "out": output_root / "shop_vehicle_repair.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, damaged luxury car in underground garage with sparks and tools, "
                "fast repair purchase theme, mechanic workbench ambiance, centered composition, no text"
            ),
        },
        {
            "name": "shop_tune_reset",
            "out": output_root / "shop_tune_reset.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, high-performance car on tuning platform with diagnostic screens and reset gauge, "
                "vehicle tune reset purchase theme, neon-accent workshop lighting, centered composition, no text"
            ),
        },
        {
            "name": "shop_cooldown_reset",
            "out": output_root / "shop_cooldown_reset.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, cracked stopwatch and rotating mechanical timer dial, "
                "time acceleration and cooldown reset purchase theme, dramatic shadow lighting, centered composition, no text"
            ),
        },
        {
            "name": "shop_event_boost",
            "out": output_root / "shop_event_boost.png",
            "prompt": (
                "Cinematic dark-mafia game tile art, city event board with glowing markers, crowd silhouettes and spotlight beams, "
                "temporary event boost purchase theme, dynamic high-energy atmosphere, centered composition, no text"
            ),
        },
    ]


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
        poll_resp = requests.get(f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60)
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


def _mirror_to_client_assets(generated_paths: List[Path]) -> None:
    mirror_dir = ROOT / "client" / "assets" / "images" / "premium_tiles"
    mirror_dir.mkdir(parents=True, exist_ok=True)
    for src in generated_paths:
        dst = mirror_dir / src.name
        shutil.copy2(src, dst)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate premium tile images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "premium_tiles"),
        help="Target folder for premium tile PNG files",
    )
    parser.add_argument(
        "--mirror-client-assets",
        action="store_true",
        help="Also copy generated files to client/assets/images/premium_tiles",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    assets = _premium_assets(output_root)

    print(f"Planned generations: {len(assets)}")
    print(f"Output root: {output_root}")
    for item in assets:
        print(f"- {item['name']} -> {item['out']}")

    if args.estimate_only:
        print("estimate-only: no images will be generated")
        return

    if not API_KEY:
        raise RuntimeError("LEONARDO_API_KEY is not set")

    if args.confirm_batch != "YES":
        raise RuntimeError("Safety stop: add --confirm-batch YES to run generation")

    success = 0
    skipped = 0
    failed = 0
    generated_paths: List[Path] = []

    for item in assets:
        out_path: Path = item["out"]

        if out_path.exists() and not args.force:
            skipped += 1
            print(f"skip (exists): {out_path}")
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                image_url = _generate_one(item["prompt"], args.model)
                _save_image(image_url, out_path)
                generated = True
                success += 1
                generated_paths.append(out_path)
                print(f"saved: {out_path}")
                break
            except Exception as exc:  # noqa: BLE001
                print(f"Failed {item['name']} attempt {attempt}: {exc}")
                if attempt < args.attempts:
                    time.sleep(args.sleep)

        if not generated:
            failed += 1

    if args.mirror_client_assets and generated_paths:
        _mirror_to_client_assets(generated_paths)
        print("Mirrored generated files to client/assets/images/premium_tiles")

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")


if __name__ == "__main__":
    main()
