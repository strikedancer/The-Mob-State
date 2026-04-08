#!/usr/bin/env python3
"""
Generate 3 consistent boat variants via Replicate Seedream 4:
- new (clean)
- dirty (marine growth, rust, weathering)
- damaged (structural, water damage, corrosion)

Usage:
  python generate_seedream_boats.py --boat-id speedboat --boat-name "Miami Speedboot"
  REPLICATE_API_TOKEN=... python generate_seedream_boats.py --boat-id speedboat --boat-name "Miami Speedboot"
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path
from typing import Any, Dict, List

import requests

API_BASE = "https://api.replicate.com/v1"
PREDICTIONS_URL = f"{API_BASE}/predictions"
MODEL_SLUG = "bytedance/seedream-4"
OUTPUT_DIR = Path("client/assets/images/vehicles")
MIN_CREATE_INTERVAL_SECONDS = 11
MAX_429_RETRIES = 30

_LAST_CREATE_AT = 0.0


def build_headers(token: str) -> Dict[str, str]:
    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }


def get_latest_version(token: str) -> str:
    headers = build_headers(token)
    response = requests.get(f"{API_BASE}/models/{MODEL_SLUG}", headers=headers, timeout=60)
    response.raise_for_status()
    data = response.json()
    version_id = data.get("latest_version", {}).get("id")
    if not version_id:
        raise RuntimeError("Could not resolve latest version for bytedance/seedream-4")
    return version_id


def create_prediction(token: str, version: str, input_payload: Dict[str, Any]) -> str:
    global _LAST_CREATE_AT

    headers = build_headers(token)
    payload = {
        "version": version,
        "input": input_payload,
    }

    retries = 0
    while True:
        elapsed = time.time() - _LAST_CREATE_AT
        if elapsed < MIN_CREATE_INTERVAL_SECONDS:
            time.sleep(MIN_CREATE_INTERVAL_SECONDS - elapsed)

        response = requests.post(PREDICTIONS_URL, headers=headers, json=payload, timeout=60)
        _LAST_CREATE_AT = time.time()

        if response.status_code in (200, 201):
            prediction = response.json()
            prediction_id = prediction.get("id")
            if not prediction_id:
                raise RuntimeError("Prediction created but no id returned")
            return prediction_id

        if response.status_code == 429 and retries < MAX_429_RETRIES:
            retries += 1
            retry_after = 5
            try:
                body = response.json()
                retry_after = int(body.get("retry_after", retry_after))
            except Exception:
                pass
            wait_seconds = max(retry_after, MIN_CREATE_INTERVAL_SECONDS)
            print(f"[WARN] 429 throttled, retry {retries}/{MAX_429_RETRIES} after {wait_seconds}s")
            time.sleep(wait_seconds)
            continue

        raise RuntimeError(f"Create prediction failed ({response.status_code}): {response.text[:600]}")


def poll_prediction(token: str, prediction_id: str, timeout_seconds: int = 900) -> Dict[str, Any]:
    headers = build_headers(token)
    started = time.time()
    poll_count = 0

    while True:
        if time.time() - started > timeout_seconds:
            raise TimeoutError(f"Prediction timeout: {prediction_id}")

        response = requests.get(f"{PREDICTIONS_URL}/{prediction_id}", headers=headers, timeout=60)
        response.raise_for_status()
        pred = response.json()

        status = pred.get("status")
        poll_count += 1
        if status == "succeeded":
            print(f"[POLL] Succeeded after {poll_count} polls")
            return pred
        if status == "failed":
            error = pred.get("error")
            logs = pred.get("logs")
            raise RuntimeError(f"Prediction failed: {error} | logs: {str(logs)[:500]}")
        if status == "canceled":
            raise RuntimeError("Prediction canceled")

        time.sleep(2)


def extract_first_output_url(prediction: Dict[str, Any]) -> str:
    output = prediction.get("output")

    if isinstance(output, list) and output:
        first = output[0]
        if isinstance(first, str) and first.startswith("http"):
            return first
        if isinstance(first, dict):
            for key in ("url", "uri", "image_url"):
                value = first.get(key)
                if isinstance(value, str) and value.startswith("http"):
                    return value

    if isinstance(output, str) and output.startswith("http"):
        return output

    raise RuntimeError(f"No downloadable output URL found. Output: {json.dumps(output)[:1000]}")


def download_image(url: str, output_path: Path) -> None:
    response = requests.get(url, timeout=180)
    response.raise_for_status()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(response.content)


def base_input(prompt: str) -> Dict[str, Any]:
    return {
        "prompt": prompt,
        "size": "custom",
        "width": 1280,
        "height": 768,
        "enhance_prompt": False,
        "sequential_image_generation": "disabled",
        "max_images": 1,
    }


def prompt_new(boat_name: str) -> str:
    return (
        f"Create a photorealistic image of a {boat_name}. "
        "Condition must be factory-new and pristine: clean hull, shiny finish, clean windows, "
        "no algae, no rust, no barnacles, no weathering damage, no rust stains. "
        "Show the boat on calm water with good depth and realistic lighting. "
        "Do not mirror text or geometry, do not blur, keep image tack-sharp and photorealistic."
    )


def prompt_dirty(boat_name: str) -> str:
    return (
        f"Edit this exact same {boat_name} from the reference image. "
        "Keep identical boat model, hull shape, exact same paint color hue, camera angle, framing, lens perspective and exact same water backdrop. "
        "Add realistic marine weathering: light green algae streaks on the waterline, light surface corrosion and rust spots on metal fittings, "
        "subtle barnacle patches, mild paint discoloration and salt stains, water marks on windows. "
        "Do not change the boat identity. Do not flip, mirror or rotate. Do not blur. Keep image crisp."
    )


def prompt_damaged(boat_name: str) -> str:
    return (
        f"Edit this exact same {boat_name} from the reference image. "
        "Keep identical boat model, exact same paint color hue, camera angle, framing and exact same water backdrop. "
        "Set condition to heavily damaged and neglected: visible hull cracks and seams, heavy rust patches on metal, extensive barnacle clusters, "
        "peeling and faded paint, cracked windows or Portholes, corroded railings and fittings, water stains and mineral deposits. "
        "Show weathering from long-term saltwater exposure and lack of maintenance. "
        "Do not mirror, do not change viewpoint, do not blur. Keep sharp details."
    )


def run_one_boat(token: str, boat_id: str, boat_name: str) -> List[Path]:
    version = get_latest_version(token)
    print(f"[INFO] Model: {MODEL_SLUG}")
    print(f"[INFO] Version: {version}")

    new_file = OUTPUT_DIR / f"{boat_id}_new.png"
    dirty_file = OUTPUT_DIR / f"{boat_id}_dirty.png"
    damaged_file = OUTPUT_DIR / f"{boat_id}_damaged.png"

    print("[STEP 1/3] Generating NEW variant (no reference)")
    new_input = base_input(prompt_new(boat_name))
    pred_new = poll_prediction(
        token,
        create_prediction(token, version, new_input),
    )
    url_new = extract_first_output_url(pred_new)
    download_image(url_new, new_file)
    print(f"[OK] {new_file}")

    print("[STEP 2/3] Generating DIRTY variant (from NEW)")
    dirty_input = base_input(prompt_dirty(boat_name))
    dirty_input["image_input"] = [url_new]
    pred_dirty = poll_prediction(
        token,
        create_prediction(token, version, dirty_input),
    )
    url_dirty = extract_first_output_url(pred_dirty)
    download_image(url_dirty, dirty_file)
    print(f"[OK] {dirty_file}")

    print("[STEP 3/3] Generating DAMAGED variant (from NEW + DIRTY)")
    damaged_input = base_input(prompt_damaged(boat_name))
    damaged_input["image_input"] = [url_new, url_dirty]
    pred_damaged = poll_prediction(
        token,
        create_prediction(token, version, damaged_input),
    )
    url_damaged = extract_first_output_url(pred_damaged)
    download_image(url_damaged, damaged_file)
    print(f"[OK] {damaged_file}")

    return [new_file, dirty_file, damaged_file]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate Seedream boat condition images")
    parser.add_argument("--boat-id", required=True, help="File-safe boat id (e.g. speedboat)")
    parser.add_argument("--boat-name", required=True, help="Human-readable boat name")
    parser.add_argument("--api-token", help="Replicate token (optional; else REPLICATE_API_TOKEN env var)")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    token = (args.api_token or os.getenv("REPLICATE_API_TOKEN", "")).strip()

    if not token:
        print("[ERROR] Missing API token. Set REPLICATE_API_TOKEN or pass --api-token.")
        return 1

    try:
        files = run_one_boat(token, args.boat_id, args.boat_name)
        print("\n[SUCCESS] Generated files:")
        for path in files:
            print(f"- {path}")
        return 0
    except Exception as exc:
        print(f"[ERROR] {exc}")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
