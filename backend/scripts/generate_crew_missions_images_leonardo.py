#!/usr/bin/env python3
"""Generate Crew Mission card + scene images via Leonardo API.

Outputs to:
  runtime/client-images/crew_missions/cards/<mission_key>.png
  runtime/client-images/crew_missions/scenes/<mission_key>.png
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


def _mission_prompts() -> List[dict]:
    """Card = compact selection-tile; scene = widescreen moment."""
    return [
        {
            "key": "night_deposit_grab",
            "card": (
                "Cinematic dark-mafia mobile game card art, small urban bank rear alley at night, "
                "steel night deposit drawer half open, duffel silhouette, rain and amber street light, "
                "compact centered composition, noir mood, no text"
            ),
            "scene": (
                "Cinematic noir wide shot, crew shadows at bank loading dock, armored glass deposit slot, "
                "red alarm reflection, tension, smoke, dramatic side lighting, no text, no logos"
            ),
        },
        {
            "key": "skim_network_rollout",
            "card": (
                "Cinematic dark-mafia game card art, row of outdoor ATMs in foggy city, tiny skimming device glint, "
                "cool blue-teal palette, suspenseful, compact composition, no text"
            ),
            "scene": (
                "Wide cinematic street, technician figure crouched at ATM internals, spark micro-glint, "
                "police lights far in bokeh, rain, moody shadows, no text"
            ),
        },
        {
            "key": "armored_pivot_route",
            "card": (
                "Cinematic dark-mafia game card art, armored truck turning tight corner under bridge, "
                "motion blur, gold-amber headlights, gritty urban texture, compact composition, no text"
            ),
            "scene": (
                "Wide action shot, armored convoy intercept, smoke grenade, crew in tactical coats, "
                "urban interchange at dusk, cinematic contrast, no text"
            ),
        },
        {
            "key": "subsidiary_vault_window",
            "card": (
                "Cinematic dark-mafia game card art, regional bank lobby vault door ajar, stacks silhouette, "
                "cold fluorescent and warm vault light mix, compact composition, no text"
            ),
            "scene": (
                "Vault room interior, timed drill sparks, clock pressure feeling, marble and steel, "
                "guards fallen out of frame, noir suspense, no text"
            ),
        },
        {
            "key": "reserve_vault_breach",
            "card": (
                "Cinematic dark-mafia game card art, massive circular bank vault door, heavy locking wheel, "
                "orange emergency light, dust particles, epic scale, compact composition, no text"
            ),
            "scene": (
                "Ultra-wide vault hall, breach smoke, crew silhouettes with duffels, towering safe columns, "
                "high stakes heist atmosphere, no text"
            ),
        },
        {
            "key": "safehouse_supply_run",
            "card": (
                "Cinematic dark-mafia mobile game card art, hidden basement safehouse, crates of trade goods, "
                "single bare bulb, duffel bags, compact centered composition, noir mood, no text"
            ),
            "scene": (
                "Wide cinematic cellar, crew packing crates, steel door ajar, rain outside, "
                "amber practical light, tense logistics mood, no text"
            ),
        },
        {
            "key": "street_intel_sweep",
            "card": (
                "Cinematic dark-mafia game card art, rainy alley laptop glow, informant silhouette, "
                "neon reflection on wet asphalt, compact composition, no text"
            ),
            "scene": (
                "Wide street intel sweep, rooftop watcher, police scanner lights far away, "
                "fog, cool teal and amber, no text"
            ),
        },
        {
            "key": "armory_smuggle_chain",
            "card": (
                "Cinematic dark-mafia game card art, wooden crate cracked open showing rifles silhouette, "
                "warehouse dust, warm worklamp, compact composition, no text"
            ),
            "scene": (
                "Wide warehouse chain, forklift shadows, stamped crates, night rain at open dock, "
                "gritty arms-smuggle mood, no text, no logos"
            ),
        },
        {
            "key": "port_hijack_window",
            "card": (
                "Cinematic dark-mafia game card art, harbor crane and cargo container at night, "
                "gold fog lights, compact composition, no text"
            ),
            "scene": (
                "Wide port hijack, crew on container stack, ship horn atmosphere, "
                "dramatic side light, no text"
            ),
        },
        {
            "key": "casino_ledger_raid",
            "card": (
                "Cinematic dark-mafia game card art, back-office casino ledger desk, chips and cash tray, "
                "green lamp, compact composition, no text"
            ),
            "scene": (
                "Wide casino counting room raid, velvet and steel, scattered chips, "
                "alarm red wash, no real-world logos, no text"
            ),
        },
        {
            "key": "federal_convoy_break",
            "card": (
                "Cinematic dark-mafia game card art, rural highway overpass, federal convoy headlights, "
                "smoke, compact composition, no text"
            ),
            "scene": (
                "Wide convoy intercept, blocked road, crew silhouettes, dusk sky, "
                "cinematic contrast, no text"
            ),
        },
        {
            "key": "courier_intercept",
            "card": (
                "Cinematic dark-mafia game card art, motorcycle courier bag snatched in tunnel, "
                "headlight streaks, compact composition, no text"
            ),
            "scene": (
                "Wide tunnel intercept, two bikes, courier satchel in air, sodium lights, no text"
            ),
        },
        {
            "key": "city_vault_prep",
            "card": (
                "Cinematic dark-mafia game card art, city bank blueprint on table, tools and gloves, "
                "low lamp, compact composition, no text"
            ),
            "scene": (
                "Wide prep room, maps and radios, night city through blinds, noir suspense, no text"
            ),
        },
        {
            "key": "port_contraband_manifest",
            "card": (
                "Cinematic dark-mafia game card art, stamped shipping manifest and sealed crate, "
                "harbor night, compact composition, no text"
            ),
            "scene": (
                "Wide customs shed, falsified papers, flashlight beam on crate stencil, no text"
            ),
        },
        {
            "key": "warehouse_luxury_offload",
            "card": (
                "Cinematic dark-mafia game card art, luxury watches and bottles in open crate, "
                "warehouse plastic wrap, compact composition, no text"
            ),
            "scene": (
                "Wide luxury offload, black vans, gold goods gleam, night warehouse, no logos, no text"
            ),
        },
        {
            "key": "territory_blackout_push",
            "card": (
                "Cinematic dark-mafia game card art, city district blackout, one street still lit, "
                "crew walking the dark block, compact composition, no text"
            ),
            "scene": (
                "Wide blackout neighborhood, power substation sparks, crew claiming the street, no text"
            ),
        },
        {
            "key": "clearing_house_vault_run",
            "card": (
                "Cinematic dark-mafia game card art, brutalist financial tower at night, holographic settlement lines, "
                "glass vault core glow, gold and deep blue palette, compact composition, no text"
            ),
            "scene": (
                "Server cathedral interior, tape robots, glass secure core, red alarm wash, "
                "institutional settlement heist vibe, no real-world logos, no text"
            ),
        },
        {
            "key": "chop_shop_handoff",
            "card": (
                "Cinematic dark-mafia game card art, night chop shop garage, sedan on a lift, "
                "sparks and oil drums, compact composition, no text"
            ),
            "scene": (
                "Wide chop shop alley, crew handing over a dark sedan, chain hoist, amber worklamps, no text"
            ),
        },
        {
            "key": "lockbox_crowbar_shift",
            "card": (
                "Cinematic dark-mafia game card art, steel street lockbox pried with a crowbar, "
                "wet cobbles, compact composition, no text"
            ),
            "scene": (
                "Wide night sidewalk, crew levering a bolted lockbox, distant tram lights, noir, no text"
            ),
        },
        {
            "key": "alley_tag_run",
            "card": (
                "Cinematic dark-mafia game card art, spray can mist on a brick alley wall, "
                "gold crew mark silhouette, compact composition, no text"
            ),
            "scene": (
                "Wide tagged alley, running silhouette, wet brick, sodium vapor glow, no readable letters, no text"
            ),
        },
        {
            "key": "bike_drop_off",
            "card": (
                "Cinematic dark-mafia game card art, black motorcycle under a tarp in a side street, "
                "headlight slash, compact composition, no text"
            ),
            "scene": (
                "Wide canal-side drop, motorcycle parked for pickup, fog, cool teal lights, no text"
            ),
        },
        {
            "key": "dock_rowboat_nudge",
            "card": (
                "Cinematic dark-mafia game card art, small boat bumping a wooden dock at night, "
                "rope and crates, compact composition, no text"
            ),
            "scene": (
                "Wide harbor slip, crew nudging a skiff, cranes in fog, gold reflections, no text"
            ),
        },
        {
            "key": "street_stash_move",
            "card": (
                "Cinematic dark-mafia game card art, wrapped drug packages in a duffel in a stairwell, "
                "bare bulb, compact composition, no logos, no text"
            ),
            "scene": (
                "Wide tenement corridor stash move, two silhouettes, peeling paint, tense, no text"
            ),
        },
        {
            "key": "pistol_night_run",
            "card": (
                "Cinematic dark-mafia game card art, compact pistol and spare mag on a rooftop ledge, "
                "city night, compact composition, no text"
            ),
            "scene": (
                "Wide rooftop escort run, handgun silhouette, rain, distant sirens glow, no text"
            ),
        },
        {
            "key": "shotgun_door_kick",
            "card": (
                "Cinematic dark-mafia game card art, pump shotgun aimed at a warehouse door, "
                "splinters, compact composition, no text"
            ),
            "scene": (
                "Wide warehouse breach, kicked door, shotgun crew, dust in worklight, no text"
            ),
        },
        {
            "key": "harbor_skiff_lift",
            "card": (
                "Cinematic dark-mafia game card art, quiet skiff lifting a crate from black water, "
                "fog, compact composition, no text"
            ),
            "scene": (
                "Wide misty harbor lift, cargo net, stealth boat, gold dock lamps, no text"
            ),
        },
        {
            "key": "courier_bike_cut",
            "card": (
                "Cinematic dark-mafia game card art, motorcycle cutting off a courier in a tunnel, "
                "headlight streaks, compact composition, no text"
            ),
            "scene": (
                "Wide tunnel intercept, two bikes, satchel in air, sodium lights, no text"
            ),
        },
        {
            "key": "burglary_kit_window",
            "card": (
                "Cinematic dark-mafia game card art, burglary kit tools on a window ledge, "
                "office glass at night, compact composition, no text"
            ),
            "scene": (
                "Wide office facade, opened window, gloved crew, city reflections, no text"
            ),
        },
        {
            "key": "bolt_cutter_fence",
            "card": (
                "Cinematic dark-mafia game card art, bolt cutters snapping harbor fence chain, "
                "sparks, compact composition, no text"
            ),
            "scene": (
                "Wide fenced dockyard, cut gap, crew slipping through, floodlights, no text"
            ),
        },
        {
            "key": "weed_van_run",
            "card": (
                "Cinematic dark-mafia game card art, unmarked van with wrapped cannabis bricks in the cargo bay, "
                "night industrial park, compact composition, no logos, no text"
            ),
            "scene": (
                "Wide van rolling out a loading bay, green-tinted packages, wet asphalt, no text"
            ),
        },
        {
            "key": "ammo_cache_shuffle",
            "card": (
                "Cinematic dark-mafia game card art, open ammo crate of 9mm in a basement cache, "
                "warm lamp, compact composition, no text"
            ),
            "scene": (
                "Wide ammo shuffle, crates passed hand to hand, concrete bunker, no text"
            ),
        },
        {
            "key": "armored_payroll_escort",
            "card": (
                "Cinematic dark-mafia game card art, armored sedan and rifle case for a payroll run, "
                "rainy overpass, compact composition, no text"
            ),
            "scene": (
                "Wide payroll escort, armored car on wet highway, rifle silhouette, dusk, no text"
            ),
        },
        {
            "key": "lab_grade_swap",
            "card": (
                "Cinematic dark-mafia game card art, cocaine bricks quality tagged beside a laptop and glass cutter, "
                "lab neon, compact composition, no logos, no text"
            ),
            "scene": (
                "Wide lab-grade swap table, white powder bags, tools, cold light, no text"
            ),
        },
        {
            "key": "yacht_glass_cut",
            "card": (
                "Cinematic dark-mafia game card art, glass cutter on a yacht display case, marina night, "
                "compact composition, no text"
            ),
            "scene": (
                "Wide luxury yacht deck, glass cut circle, quiet boat alongside, gold cabin light, no text"
            ),
        },
        {
            "key": "hotwire_convoy_cut",
            "card": (
                "Cinematic dark-mafia game card art, fast sedan and car-theft tools at a convoy overpass, "
                "compact composition, no text"
            ),
            "scene": (
                "Wide convoy cut, speeding car, wires and tools, highway night, no text"
            ),
        },
        {
            "key": "smg_warehouse_push",
            "card": (
                "Cinematic dark-mafia game card art, compact SMG and spent casings in a warehouse aisle, "
                "compact composition, no text"
            ),
            "scene": (
                "Wide warehouse push, automatic weapon crew, crates, hanging lamps, no text"
            ),
        },
        {
            "key": "precursor_boat_run",
            "card": (
                "Cinematic dark-mafia game card art, cargo boat with sealed high-grade drug drums, "
                "night river, compact composition, no logos, no text"
            ),
            "scene": (
                "Wide precursor boat on black water, heavy cargo, fog horn mood, no text"
            ),
        },
    ]


def _build_jobs(cards_dir: Path, scenes_dir: Path) -> List[dict]:
    jobs: List[dict] = []
    for item in _mission_prompts():
        key = item["key"]
        jobs.append({"name": f"{key}_card", "out": cards_dir / f"{key}.png", "prompt": item["card"]})
        jobs.append({"name": f"{key}_scene", "out": scenes_dir / f"{key}.png", "prompt": item["scene"]})
    return jobs


def _mirror_client_assets(generated_paths: List[Path]) -> None:
    for src in generated_paths:
        rel = src.relative_to(ROOT / "runtime" / "client-images" / "crew_missions")
        dst = ROOT / "client" / "assets" / "images" / "crew_missions" / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate crew mission images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "crew_missions"),
        help="Root folder containing cards/ and scenes/ subfolders",
    )
    parser.add_argument(
        "--mirror-client-assets",
        action="store_true",
        help="Copy generated PNGs to client/assets/images/crew_missions/",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    root = Path(args.output_root)
    cards_dir = root / "cards"
    scenes_dir = root / "scenes"
    jobs = _build_jobs(cards_dir, scenes_dir)

    print(f"Planned generations: {len(jobs)}")
    print(f"Output root: {root}")
    for item in jobs:
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

    for item in jobs:
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
        _mirror_client_assets(generated_paths)
        print("Mirrored generated files to client/assets/images/crew_missions/")

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")
    if failed > 0 and success == 0:
        print(
            "Hint: 401 Unauthorized usually means LEONARDO_API_KEY is missing, expired, or wrong for v2 API. "
            "Set a valid key in process env or backend/.env.local, then re-run."
        )
        raise SystemExit(1)


if __name__ == "__main__":
    main()
