#!/usr/bin/env python3
"""Generate nightclub achievement shield badges with Leonardo.ai."""

from __future__ import annotations

import os
import time
import sys
from pathlib import Path

import requests

# Open log file
LOG_FILE = Path(__file__).parent / "badge_generation_debug.log"
log = open(LOG_FILE, "w", buffering=1)  # Line-buffered

def logit(msg):
    print(msg, file=log, flush=True)
    print(msg, flush=True)

logit("Starting badge generation...")

API_KEY = os.getenv("LEONARDO_API_KEY", "")
GENERATE_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
STATUS_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
MODEL_ID = "7b592283-e8a7-4c5a-9ba6-d18c31f258b9"  # FLUX.1 model
NEGATIVE_PROMPT = (
    "background, gradient background, scenery, room, city, person, face, text, letters, "
    "watermark, ribbon text, logo, realistic photo, 3d render, asymmetrical shield, cut off badge"
)
BASE_PROMPT = (
    "premium shield badge for gritty mafia mobile game, enamel + brushed metal, high contrast, "
    "centered emblem, transparent background, no text, no logo, readable at small size"
)

BADGES = [
    {
        "id": "nightclub_opening_night",
        "folder": "social",
        "prompt": "Shield badge with neon club entrance, velvet rope, and subtle marquee glow, midnight blue + magenta + brushed gold, first nightclub opening milestone.",
    },
    {
        "id": "nightclub_headliner",
        "folder": "social",
        "prompt": "Shield badge with DJ turntable, waveform crest, and spotlight beams, electric cyan + violet + gold, elite nightclub booking progression.",
    },
    {
        "id": "nightclub_full_house",
        "folder": "social",
        "prompt": "Shield badge with packed dancefloor silhouettes, raised hands, and strobe halo, crimson + amber + obsidian, sold-out nightclub energy.",
    },
    {
        "id": "nightclub_cash_machine",
        "folder": "trade",
        "prompt": "Shield badge with cash counter, champagne spark, and nightclub receipt crest, emerald + black + brushed gold, profitable nightlife operations.",
    },
    {
        "id": "nightclub_empire",
        "folder": "trade",
        "prompt": "Shield badge with luxury skyline, multi-club neon towers, and money arc emblem, deep teal + gold + black, large-scale nightlife empire.",
    },
    {
        "id": "nightclub_staffing_boss",
        "folder": "power",
        "prompt": "Shield badge with three crew silhouettes, clipboard chevrons, and management star crest, graphite + royal purple + silver, coordinated nightclub staffing mastery.",
    },
    {
        "id": "nightclub_vip_room",
        "folder": "power",
        "prompt": "Shield badge with VIP velvet lounge, champagne coupe, and diamond door insignia, burgundy + champagne gold + black, premium nightclub staffing tier.",
    },
    {
        "id": "nightclub_head_of_security",
        "folder": "mastery",
        "prompt": "Shield badge with tactical earpiece, shield crest, and guarded club doorway, steel blue + gunmetal + gold, nightclub security command theme.",
    },
    {
        "id": "nightclub_podium_finish",
        "folder": "power",
        "prompt": "Shield badge with nightclub trophy pedestal, bronze laurel, and neon stage lights, black + bronze + magenta, weekly season podium placement.",
    },
    {
        "id": "nightclub_season_champion",
        "folder": "power",
        "prompt": "Shield badge with crowned nightclub crest, first-place podium, radiant spotlight ring, obsidian + molten gold + ruby accents, weekly season championship prestige.",
    },
]


def _extract_generation_id(payload: dict) -> str | None:
    # Try nested sdGenerationJob first
    if "sdGenerationJob" in payload and isinstance(payload["sdGenerationJob"], dict):
        return payload["sdGenerationJob"].get("generationId")
    # Fallback to top-level
    return payload.get("generationId") or payload.get("id")


def _extract_image_url(payload: dict) -> str | None:
    # Try multiple possible response structures
    
    # Structure 1: generations_by_pk with generated_images
    generation = payload.get("generations_by_pk") or payload.get("generation_by_pk") or payload.get("generation")
    if isinstance(generation, dict):
        images = generation.get("generated_images") or generation.get("images") or []
        if images and isinstance(images[0], dict):
            return images[0].get("url")
    
    # Structure 2: direct assets array
    assets = payload.get("assets") or []
    if assets and isinstance(assets[0], dict):
        return assets[0].get("url")
    
    return None


def generate_badge(output_path: Path, prompt: str) -> bool:
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }

    payload = {
        "prompt": f"{BASE_PROMPT}, {prompt}",
        "modelId": MODEL_ID,
        "width": 512,
        "height": 640,
        "num_images": 1,
        "alchemy": False,
        "photoReal": False,
    }

    response = requests.post(GENERATE_URL, json=payload, headers=headers, timeout=60)
    try:
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        print(f"  error response: {response.text}")
        raise
    resp_json = response.json()
    print(f"  response: {resp_json}")
    generation_id = _extract_generation_id(resp_json)
    if not generation_id:
        raise RuntimeError("No Leonardo generation id returned")

    for i in range(30):
        time.sleep(4)
        status_response = requests.get(
            f"{STATUS_URL}/{generation_id}",
            headers={"Authorization": f"Bearer {API_KEY}"},
            timeout=60,
        )
        status_response.raise_for_status()
        status_data = status_response.json()
        status = status_data.get("status") or (status_data.get("generation", {}) or {}).get("status", "UNKNOWN")
        image_url = _extract_image_url(status_data)
        
        if i == 0:
            logit(f"  poll 1 debug:")
            logit(f"    top_level_keys: {list(status_data.keys())}")
            if "generations_by_pk" in status_data:
                logit(f"    generations_by_pk_keys: {list(status_data['generations_by_pk'].keys())}")
                if "generated_images" in status_data["generations_by_pk"]:
                    logit(f"    num_images: {len(status_data['generations_by_pk']['generated_images'])}")
        
        if image_url:
            logit(f"  poll {i+1}: SUCCESS - found image")
            image_response = requests.get(image_url, timeout=60)
            image_response.raise_for_status()
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.write_bytes(image_response.content)
            logit(f"  saved: {output_path}")
            return True

    logit(f"  all {i+1} polls timed out")
    return False


def main() -> int:
    if not API_KEY:
        print("ERROR: Missing LEONARDO_API_KEY environment variable")
        return 1

    root = Path(__file__).parent / "client" / "assets" / "images" / "achievements" / "badges"
    print("Generating nightclub achievement badges...")

    success_count = 0
    for idx, badge in enumerate(BADGES):
        output_path = root / badge["folder"] / f"{badge['id']}.png"
        print(f"- {badge['id']}")
        try:
            if generate_badge(output_path, badge["prompt"]):
                success_count += 1
                print(f"  saved: {output_path}")
            else:
                print("  timed out waiting for image")
        except Exception as exc:  # noqa: BLE001
            print(f"  failed: {exc}")

        time.sleep(2)

    print(f"Done. Generated {success_count}/{len(BADGES)} badges.")
    return 0 if success_count == len(BADGES) else 2


if __name__ == "__main__":
    raise SystemExit(main())