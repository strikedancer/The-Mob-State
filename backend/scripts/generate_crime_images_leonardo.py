#!/usr/bin/env python3
"""Generate crime catalog stills, wiki hub tile and crimes background via Leonardo.

Outputs:
  runtime/client-images/crimes/<id>_crime.png
  runtime/client-images/wiki/hubs/crimes.png
  runtime/client-images/backgrounds/crime_background.png

Optional --mirror-client-assets copies into client/assets/images/...

Requires LEONARDO_API_KEY and --confirm-batch YES.
Use --force to overwrite the old neon/sci-fi stills.
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
CARD_WIDTH = 1280
CARD_HEIGHT = 1024
BG_WIDTH = 1920
BG_HEIGHT = 1080

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, captions, title, signage, "
    "readable store names, neon kanji, blurry, low detail, cartoon, anime, "
    "oversaturated neon, cyberpunk vault, sci-fi, sterile white office, IKEA, "
    "frame, border, collage, gore, blood splatter, corpses, group portrait"
)

STYLE = (
    "Cinematic dark-mafia game still, photoreal, noir amber rim light, "
    "rich gold and deep shadow, wet asphalt, centered composition, no text "
)

CRIMES: List[Tuple[str, str]] = [
    (
        "pickpocket",
        "crowded European night street, hooded figure brushing past a tourist, "
        "leather wallet slipping into a coat pocket, rain, amber shop-window glow",
    ),
    (
        "shoplift",
        "dim boutique stockroom at night, open jewelry drawer, gloved hand taking a watch, "
        "security camera red LED, mahogany and gold",
    ),
    (
        "steal_bike",
        "wet cobblestone alley, bicycle locked to an iron rack, bolt cutters glinting, "
        "streetlamp amber, empty midnight street",
    ),
    (
        "car_theft",
        "luxury sedan on a rain-slick side street, slim jim at the door, "
        "interior dome light amber, chrome reflections, no readable plates",
    ),
    (
        "burglary",
        "townhouse rear garden at night, jimmied French window, flashlight beam on a jewelry box, "
        "ivy, gold curtains, quiet break-in mood",
    ),
    (
        "rob_store",
        "small corner shop at night, cash register open, duffel on the counter, "
        "shattered glass sparkle, amber interior, no readable shop name",
    ),
    (
        "mug_person",
        "underpass at night, two silhouettes in coats, dropped briefcase, "
        "sodium lamps, tense street robbery, no gore",
    ),
    (
        "steal_car_parts",
        "dark parking garage, luxury car on jack stands, catalytic converter and alloy wheel aside, "
        "work lamp amber, grease and chrome",
    ),
    (
        "hijack_truck",
        "rural highway overpass at dusk, cargo truck blocked, crew in coats, "
        "headlights in fog, gold rim light, no logos",
    ),
    (
        "atm_theft",
        "foggy city ATM alcove, machine casing pried, cash cassettes half pulled, "
        "amber street light, rain, no bank trademarks",
    ),
    (
        "jewelry_heist",
        "jeweler display window smashed, gold necklaces and diamonds on velvet, "
        "getaway sedan door open, wet night street, no readable letters",
    ),
    (
        "vandalism",
        "smashed luxury storefront at night, overturned planter, spray-painted iron shutter, "
        "amber reflections, aftermath not a riot",
    ),
    (
        "graffiti",
        "brick alley wall, figure in a coat spraying a gold-black mural, "
        "wet pavement, single bare bulb, no readable letters",
    ),
    (
        "drug_deal_small",
        "parked car in a rainy alley, cash and a small wrapped package on the seat, "
        "amber dash light, tense exchange, no product close-up",
    ),
    (
        "drug_deal_large",
        "warehouse table with brick-shaped wrapped parcels and a money counter, "
        "single work lamp, duffel bags, noir still life, no trademarks",
    ),
    (
        "extortion",
        "family restaurant back office, envelope of cash on a ledger, "
        "heavy figure in a coat opposite the owner, green banker's lamp",
    ),
    (
        "kidnapping",
        "black van in a foggy street, open side door, discarded phone on wet asphalt, "
        "amber headlights, tense abduction mood, no victim close-up",
    ),
    (
        "arson",
        "abandoned warehouse at night, fire licking a doorway, petrol can in foreground, "
        "orange gold glow, dramatic smoke, empty lot",
    ),
    (
        "smuggling",
        "border checkpoint at night seen from a hidden dirt track, crates in a truck bed, "
        "fog, amber fog lamps, no flags with readable text",
    ),
    (
        "assassination",
        "hotel corridor at night, silenced pistol on a service tray, door ajar, "
        "gold wallpaper, noir contract-killer mood, no gore",
    ),
    (
        "eliminate_witness",
        "courthouse steps at dusk in rain, lone figure watching from a black car, "
        "amber lamps, intimidation not violence, no gore",
    ),
    (
        "diamond_heist",
        "armored courier van doors open on a wet street, raw diamonds in a steel case, "
        "gold sparkle, crew silhouettes, no logos",
    ),
    (
        "evidence_room_heist",
        "federal evidence cage at night, labeled boxes in shadow, flashlight on a duffel, "
        "cold steel and amber emergency light, no readable labels",
    ),
    (
        "hack_account",
        "dark penthouse desk, multiple monitors with abstract hex glow, "
        "whiskey glass, leather chair, noir cyber-crime den, not a bright office",
    ),
    (
        "counterfeit_money",
        "basement print shop, stacks of unfinished bills, ink rollers and UV lamp, "
        "amber work light, dust, no readable denominations",
    ),
    (
        "identity_theft",
        "hotel desk with passports, stolen IDs and a laptop, gold desk lamp, "
        "noir fraud still life, no readable names",
    ),
    (
        "rob_armored_truck",
        "armored truck stopped under a bridge, smoke, crew with duffels, "
        "gold headlights, wet concrete, no logos",
    ),
    (
        "art_theft",
        "museum gallery at night, empty ornate frame, painting being slid into a tube, "
        "moonlight and amber security beam, no readable plaques",
    ),
    (
        "protection_racket",
        "barbershop after hours, cash envelope on the counter, heavy coats, "
        "checkered floor, gold window sign glow without letters",
    ),
    (
        "casino_heist",
        "casino counting room, chip trays and cash bricks, velvet and steel, "
        "green lamp and gold, alarm wash, no real casino brands",
    ),
    (
        "bank_robbery",
        "classic marble bank lobby at night, circular vault door ajar, duffels, "
        "amber chandelier, photoreal heist, not sci-fi",
    ),
    (
        "museum_heist",
        "museum hall at night, glass case open, ancient gold artifact lifted, "
        "moonbeams and dust, noir, no plaques",
    ),
    (
        "boss_assassination",
        "mansion study at night, leather chair empty, whiskey and a cigar still smoking, "
        "open balcony doors, gold lamp, aftermath without gore",
    ),
    (
        "steal_yacht",
        "luxury yacht at a dark marina, figure untying the line, gold cabin lights, "
        "black water reflections, quiet theft",
    ),
    (
        "corrupt_official",
        "city-hall office at night, briefcase of cash on a mahogany desk, "
        "gold nameplate blank, whiskey, handshake shadow",
    ),
    (
        "criminal_record_wipe",
        "archive vault of court files, folders burning in a metal drum, "
        "hacking laptop glow, amber and smoke, no readable case names",
    ),
]

HUB_PROMPT = (
    f"{STYLE}"
    "cinematic street crime tableau: shattered jewelry-store glass, getaway sedan, dropped cash, "
    "police lights in the distance, noir heist atmosphere, 16:9 wiki hub tile, no gore"
)

BACKGROUND_PROMPT = (
    "Ultra-wide cinematic dark-mafia game background, empty rainy city avenue at night, "
    "amber street lamps, wet asphalt reflections, distant police lights bokeh, "
    "deep vignette and dark center so UI can sit on top, photoreal noir, "
    "no people close-up, no text, no logos, no gore"
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


def _generate_one(prompt: str, model: str, width: int, height: int) -> str:
    payload_variants = [
        {
            "model": model,
            "parameters": {
                "width": width,
                "height": height,
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
                "width": width,
                "height": height,
                "prompt": prompt,
                "negative_prompt": NEGATIVE_PROMPT,
                "quantity": 1,
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
            last_payload = getattr(exc, "response", None)

    if not generation_id:
        snippet = str(last_payload if last_payload is not None else last_error)
        if len(snippet) > 1600:
            snippet = snippet[:1600] + "..."
        raise RuntimeError(f"No generation ID returned. API payload: {snippet}")

    for _ in range(240):
        poll_resp = requests.get(
            f"{STATUS_URL_V1}/{generation_id}",
            headers=_headers(),
            timeout=60,
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


def _jobs(output_root: Path) -> List[dict]:
    crimes_dir = output_root / "crimes"
    jobs = [
        {
            "name": crime_id,
            "kind": "crime",
            "out": crimes_dir / f"{crime_id}_crime.png",
            "prompt": f"{STYLE}{scene}",
            "width": CARD_WIDTH,
            "height": CARD_HEIGHT,
        }
        for crime_id, scene in CRIMES
    ]
    jobs.append(
        {
            "name": "hub_crimes",
            "kind": "hub",
            "out": output_root / "wiki" / "hubs" / "crimes.png",
            "prompt": HUB_PROMPT,
            "width": CARD_WIDTH,
            "height": CARD_HEIGHT,
        }
    )
    jobs.append(
        {
            "name": "crime_background",
            "kind": "background",
            "out": output_root / "backgrounds" / "crime_background.png",
            "prompt": BACKGROUND_PROMPT,
            "width": BG_WIDTH,
            "height": BG_HEIGHT,
        }
    )
    return jobs


def _mirror_client_assets(generated_paths: List[Path], output_root: Path) -> None:
    for src in generated_paths:
        rel = src.relative_to(output_root)
        dst = ROOT / "client" / "assets" / "images" / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate crime catalog images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument("--only", default="", help="Comma-separated job names")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images"),
    )
    parser.add_argument("--mirror-client-assets", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    jobs = _jobs(output_root)
    if args.only:
        wanted = {k.strip() for k in args.only.split(",") if k.strip()}
        jobs = [job for job in jobs if job["name"] in wanted]

    print(f"Planned generations: {len(jobs)}")
    print(f"Output root: {output_root}")
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
            generated_paths.append(out_path)
            continue

        generated = False
        for attempt in range(1, args.attempts + 1):
            try:
                print(f"Generating {item['name']} ({attempt}/{args.attempts})")
                image_url = _generate_one(
                    item["prompt"],
                    args.model,
                    item["width"],
                    item["height"],
                )
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
        _mirror_client_assets(generated_paths, output_root)
        print("Mirrored generated files to client/assets/images/")

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
