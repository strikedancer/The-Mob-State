#!/usr/bin/env python3
"""Generate school/automotive + new education gate images via Leonardo API.

Creates these files under runtime/client-images/school (and optional client mirror):
- tracks/automotive_track.png
- gates/asset_drug_facility_purchase_gate.png
- gates/asset_nightclub_purchase_gate.png
- gates/asset_rld_purchase_gate.png
- gates/asset_rld_expansion_advanced_gate.png
- gates/asset_stock_trade_buy_gate.png
- gates/asset_crypto_trade_buy_gate.png
- gates/asset_hitlist_place_hit_gate.png
- gates/asset_vehicle_tune_advanced_gate.png
- gates/asset_chop_contract_claim_gate.png
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

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, blurry, low detail, cartoon, anime, "
    "oversaturated neon, distorted anatomy, frame, border"
)


def _assets(output_root: Path) -> List[dict]:
    track_dir = output_root / "tracks"
    gates_dir = output_root / "gates"

    return [
        {
            "name": "automotive_track",
            "out": track_dir / "automotive_track.png",
            "prompt": (
                "Cinematic underground chop-shop garage, automotive dismantling theme, "
                "partially stripped luxury car on lifts, sorted salvage parts trays, torque tools, "
                "oil stains and amber practical lighting, moody realistic textures, "
                "centered composition for game school card header, no characters in foreground"
            ),
        },
        {
            "name": "asset_drug_facility_purchase_gate",
            "out": gates_dir / "asset_drug_facility_purchase_gate.png",
            "prompt": (
                "Clandestine drug facility purchase gate visual, sealed warehouse entrance with "
                "hydroponic glow leaking through doorway, industrial security vibes, cinematic realistic, centered focal point"
            ),
        },
        {
            "name": "asset_nightclub_purchase_gate",
            "out": gates_dir / "asset_nightclub_purchase_gate.png",
            "prompt": (
                "Luxury underground nightclub purchase gate, velvet ropes and neon-lit VIP entrance, "
                "dark cinematic nightlife atmosphere, realistic textures, centered composition"
            ),
        },
        {
            "name": "asset_rld_purchase_gate",
            "out": gates_dir / "asset_rld_purchase_gate.png",
            "prompt": (
                "Noir red light district purchase gate, neon-lit alley facade of adult entertainment buildings, "
                "wet asphalt reflections, cinematic crime-economy atmosphere, no people in foreground"
            ),
        },
        {
            "name": "asset_rld_expansion_advanced_gate",
            "out": gates_dir / "asset_rld_expansion_advanced_gate.png",
            "prompt": (
                "Advanced red light district expansion gate, multi-level entertainment complex exterior, "
                "premium neon architecture, deeper noir cinematic lighting, centered composition"
            ),
        },
        {
            "name": "asset_stock_trade_buy_gate",
            "out": gates_dir / "asset_stock_trade_buy_gate.png",
            "prompt": (
                "Finance school stock trading gate, dark executive trading floor with large market screens, "
                "glass and steel desk, green and amber ticker glow, cinematic realistic, no readable text"
            ),
        },
        {
            "name": "asset_crypto_trade_buy_gate",
            "out": gates_dir / "asset_crypto_trade_buy_gate.png",
            "prompt": (
                "Crypto trading operations gate, dark high-tech desk with multiple monitors and server racks, "
                "blue cyan practical lighting, cyber-noir realism, centered composition, no readable symbols"
            ),
        },
        {
            "name": "asset_hitlist_place_hit_gate",
            "out": gates_dir / "asset_hitlist_place_hit_gate.png",
            "prompt": (
                "Hitlist bureau gate visual, shadowy contract desk with sealed dossier folders and desk lamp, "
                "noir crime atmosphere, cinematic realistic, centered focal point, no weapons in foreground hero shot"
            ),
        },
        {
            "name": "asset_vehicle_tune_advanced_gate",
            "out": gates_dir / "asset_vehicle_tune_advanced_gate.png",
            "prompt": (
                "Advanced vehicle tuning workshop gate, performance engine bay open, precision tooling, "
                "dyno glow and amber shop lights, cinematic automotive realism, centered composition"
            ),
        },
        {
            "name": "asset_chop_contract_claim_gate",
            "out": gates_dir / "asset_chop_contract_claim_gate.png",
            "prompt": (
                "Chop contract claim gate, clandestine scrap yard bay with dismantled car chassis and labeled parts crates, "
                "gritty cinematic lighting, realistic salvage atmosphere, centered composition"
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
                "width": 1536,
                "height": 864,
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
                "width": 1024,
                "height": 1024,
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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate school/automotive images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "school"),
        help="Root folder containing tracks/ and gates/",
    )
    parser.add_argument(
        "--mirror-client-assets",
        action="store_true",
        help="Also copy generated PNGs into client/assets/images/school/",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    assets = _assets(output_root)

    print(f"Planned generations: {len(assets)}")
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
    client_school = ROOT / "client" / "assets" / "images" / "school"

    for item in assets:
        out_path: Path = item["out"]

        if out_path.exists() and not args.force:
            skipped += 1
            if args.mirror_client_assets and out_path.exists():
                rel = out_path.relative_to(output_root)
                mirror = client_school / rel
                mirror.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(out_path, mirror)
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                image_url = _generate_one(item["prompt"], args.model)
                _save_image(image_url, out_path)
                if args.mirror_client_assets:
                    rel = out_path.relative_to(output_root)
                    mirror = client_school / rel
                    mirror.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(out_path, mirror)
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
    print(f"Success: {success}")
    print(f"Skipped: {skipped}")
    print(f"Failed: {failed}")


if __name__ == "__main__":
    main()
