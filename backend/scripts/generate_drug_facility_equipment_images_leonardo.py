#!/usr/bin/env python3
"""Generate drug facility equipment images via Leonardo API into external runtime storage.

Creates 15 files in runtime/client-images/facilities/equipment:
- greenhouse_lighting.png
- greenhouse_substrate.png
- greenhouse_climate_control.png
- mushroom_farm_humidity_control.png
- mushroom_farm_substrate_mix.png
- mushroom_farm_temperature_control.png
- drug_lab_extraction_equipment.png
- drug_lab_pill_press.png
- drug_lab_lab_chemistry.png
- crack_kitchen_reactor_control.png
- crack_kitchen_batch_tanks.png
- crack_kitchen_cookline_automation.png
- darkweb_storefront_opsec_stack.png
- darkweb_storefront_order_router.png
- darkweb_storefront_crypto_settlement.png
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
    equipment_dir = output_root / "equipment"

    return [
        {
            "name": "greenhouse_lighting",
            "out": equipment_dir / "greenhouse_lighting.png",
            "prompt": (
                "Top-down cinematic icon-style render of premium greenhouse grow lights, LED bars and reflective hoods, "
                "industrial cultivation mood, centered composition, dark realistic background"
            ),
        },
        {
            "name": "greenhouse_substrate",
            "out": equipment_dir / "greenhouse_substrate.png",
            "prompt": (
                "Top-down cinematic icon-style render of enriched greenhouse substrate trays, soil and nutrient medium setup, "
                "clean controlled cultivation look, centered, realistic"
            ),
        },
        {
            "name": "greenhouse_climate_control",
            "out": equipment_dir / "greenhouse_climate_control.png",
            "prompt": (
                "Top-down cinematic icon-style render of greenhouse climate control unit with ducts and sensors, "
                "temperature and airflow theme, centered, realistic industrial detail"
            ),
        },
        {
            "name": "mushroom_farm_humidity_control",
            "out": equipment_dir / "mushroom_farm_humidity_control.png",
            "prompt": (
                "Top-down cinematic icon-style render of mushroom farm humidity control rig with mist nozzles and gauges, "
                "moody cultivation atmosphere, centered composition"
            ),
        },
        {
            "name": "mushroom_farm_substrate_mix",
            "out": equipment_dir / "mushroom_farm_substrate_mix.png",
            "prompt": (
                "Top-down cinematic icon-style render of mushroom substrate mixing bins, compost blend and sterile trays, "
                "realistic detail, centered"
            ),
        },
        {
            "name": "mushroom_farm_temperature_control",
            "out": equipment_dir / "mushroom_farm_temperature_control.png",
            "prompt": (
                "Top-down cinematic icon-style render of compact temperature regulation unit for mushroom grow room, "
                "digital thermostat and airflow controls, centered"
            ),
        },
        {
            "name": "drug_lab_extraction_equipment",
            "out": equipment_dir / "drug_lab_extraction_equipment.png",
            "prompt": (
                "Top-down cinematic icon-style render of clandestine lab extraction apparatus, glass columns and steel vessel, "
                "high detail, centered, realistic chemistry setup"
            ),
        },
        {
            "name": "drug_lab_pill_press",
            "out": equipment_dir / "drug_lab_pill_press.png",
            "prompt": (
                "Top-down cinematic icon-style render of industrial pill press machine with clean metallic housing, "
                "dark lab backdrop, centered, realistic"
            ),
        },
        {
            "name": "drug_lab_lab_chemistry",
            "out": equipment_dir / "drug_lab_lab_chemistry.png",
            "prompt": (
                "Top-down cinematic icon-style render of precursor chemistry station with sealed containers, lab glass and control panel, "
                "centered, realistic"
            ),
        },
        {
            "name": "crack_kitchen_reactor_control",
            "out": equipment_dir / "crack_kitchen_reactor_control.png",
            "prompt": (
                "Top-down cinematic icon-style render of heavy reactor control core with valves and reinforced housing, "
                "dark industrial kitchen lab mood, centered"
            ),
        },
        {
            "name": "crack_kitchen_batch_tanks",
            "out": equipment_dir / "crack_kitchen_batch_tanks.png",
            "prompt": (
                "Top-down cinematic icon-style render of dual batch tanks with pressure gauges and pipelines, "
                "industrial realistic equipment, centered"
            ),
        },
        {
            "name": "crack_kitchen_cookline_automation",
            "out": equipment_dir / "crack_kitchen_cookline_automation.png",
            "prompt": (
                "Top-down cinematic icon-style render of automated cookline control module with screens and process wiring, "
                "high-tech industrial look, centered"
            ),
        },
        {
            "name": "darkweb_storefront_opsec_stack",
            "out": equipment_dir / "darkweb_storefront_opsec_stack.png",
            "prompt": (
                "Top-down cinematic icon-style render of cyber opsec stack, secure server blades and encryption hardware, "
                "dark realistic tech environment, centered"
            ),
        },
        {
            "name": "darkweb_storefront_order_router",
            "out": equipment_dir / "darkweb_storefront_order_router.png",
            "prompt": (
                "Top-down cinematic icon-style render of order routing hardware node with network lines and control lights, "
                "realistic dark tech style, centered"
            ),
        },
        {
            "name": "darkweb_storefront_crypto_settlement",
            "out": equipment_dir / "darkweb_storefront_crypto_settlement.png",
            "prompt": (
                "Top-down cinematic icon-style render of crypto settlement terminal with hardware wallet dock and secure payment nodes, "
                "realistic cyber-finance look, centered"
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
                "width": 1024,
                "height": 1024,
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
    parser = argparse.ArgumentParser(description="Generate drug facility equipment images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "facilities"),
        help="Root folder containing equipment/",
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
                print(f"Failed {item['name']} attempt {attempt}: {exc}")
                if attempt < args.attempts:
                    time.sleep(args.sleep)

        if not generated:
            failed += 1

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")


if __name__ == "__main__":
    main()
