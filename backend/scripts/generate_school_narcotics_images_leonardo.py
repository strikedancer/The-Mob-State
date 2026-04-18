#!/usr/bin/env python3
"""Generate school/narcotics images via Leonardo API into external runtime storage.

Creates exactly these files:
- runtime/client-images/school/tracks/narcotics_track.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_slots_tier_1_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_slots_tier_2_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_slots_tier_3_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_slots_tier_4_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_equipment_tier_1_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_equipment_tier_2_gate.png
- runtime/client-images/school/gates/asset_drug_facility_upgrade_equipment_tier_3_gate.png
"""

from __future__ import annotations

import argparse
import os
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
            "name": "narcotics_track",
            "out": track_dir / "narcotics_track.png",
            "prompt": (
                "Cinematic narcotics operations control room, controlled cultivation and clandestine chemistry theme, "
                "hydroponic racks, process electric panels, glass reactors, stainless equipment, amber and cyan practical lighting, "
                "moody but readable, realistic textures, high detail, centered composition for game card header, no characters in foreground"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_slots_tier_1_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_slots_tier_1_gate.png",
            "prompt": (
                "Narcotics facility expansion tier 1, clean hydroponic starter bay, modular grow racks, beginner industrial setup, "
                "subtle blueprint overlays in environment lighting only, cinematic realistic, centered focal point"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_slots_tier_2_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_slots_tier_2_gate.png",
            "prompt": (
                "Narcotics facility expansion tier 2, larger controlled cultivation hall, advanced irrigation lines, denser infrastructure, "
                "realistic industrial environment, cinematic depth, centered composition"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_slots_tier_3_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_slots_tier_3_gate.png",
            "prompt": (
                "Narcotics facility expansion tier 3, high-capacity clandestine production floor, reinforced modular sections, advanced climate controls, "
                "premium industrial realism, dramatic controlled lighting"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_slots_tier_4_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_slots_tier_4_gate.png",
            "prompt": (
                "Narcotics facility expansion tier 4, elite full-scale narco grid architecture, massive synchronized production bays, "
                "top-tier secure infrastructure, cinematic realism, luxurious industrial detail"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_equipment_tier_1_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_equipment_tier_1_gate.png",
            "prompt": (
                "Drug facility equipment upgrade tier 1, entry-level process electrics and instrumentation, hydroponic monitoring devices, "
                "clean technical workbench, realistic lighting, centered focus"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_equipment_tier_2_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_equipment_tier_2_gate.png",
            "prompt": (
                "Drug facility equipment upgrade tier 2, improved electric control arrays, mid-tier laboratory instrumentation, "
                "organized cables and panels, cinematic industrial realism"
            ),
        },
        {
            "name": "asset_drug_facility_upgrade_equipment_tier_3_gate",
            "out": gates_dir / "asset_drug_facility_upgrade_equipment_tier_3_gate.png",
            "prompt": (
                "Drug facility equipment upgrade tier 3, clandestine chemist advanced lab, precision reactors, high-end control systems, "
                "secure pharmaceutical-grade environment, dark cinematic realism"
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
    payload = {
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
    }

    create_resp = requests.post(GENERATE_URL_V2, headers=_headers(), json=payload, timeout=90)
    create_resp.raise_for_status()
    create_payload = create_resp.json()
    generation_id = _extract_generation_id(create_payload)
    if not generation_id:
        snippet = str(create_payload)
        if len(snippet) > 1200:
            snippet = snippet[:1200] + "..."
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
    parser = argparse.ArgumentParser(description="Generate school/narcotics images via Leonardo API")
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

    for item in assets:
        out_path: Path = item["out"]

        if out_path.exists() and not args.force:
            skipped += 1
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                image_url = _generate_one(item["prompt"], args.model)
                _save_image(image_url, out_path)
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
