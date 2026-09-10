#!/usr/bin/env python3
"""Generate Almanac chapter-tile images via Leonardo API.

Outputs 16:9 cinematic tiles that match each wiki hub title:
  runtime/client-images/wiki/hubs/<key>.png
  client/assets/images/wiki/hubs/<key>.png (with --mirror-client-assets)

Requires LEONARDO_API_KEY and --confirm-batch YES.
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
DEFAULT_WIDTH = 1280
DEFAULT_HEIGHT = 800

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, captions, title, "
    "blurry, low detail, cartoon, anime, oversaturated neon, frame, border, collage, "
    "wrong subject, people posing for a group portrait"
)

STYLE = (
    "Cinematic dark-mafia game tile, photoreal, noir amber rim light, "
    "rich gold and shadow, centered composition, no text, 16:9 wide tile "
)

HUBS: List[Tuple[str, str]] = [
    (
        "countries",
        "antique world map spread on a mahogany table with brass compass, leather passport stack and destination pins, "
        "international travel atlas mood, city-glow through rain-streaked window, not a gang portrait",
    ),
    (
        "trade",
        "black-market crates of tulips, spice sacks, sealed electronics and luxury watches on a dock warehouse floor, "
        "contraband shipping catalog, forklift silhouette, humid sodium lamps",
    ),
    (
        "vehicles",
        "underground crime garage with a lineup of luxury cars, motorcycles and a speedboat on a trailer, "
        "wet concrete, gold reflections on chrome, mechanic lamps",
    ),
    (
        "weapons",
        "armory wall of pistols, shotgun, SMG and rifle on dark felt with ammo boxes, "
        "close-up weapon catalog still life, dramatic side light",
    ),
    (
        "drugs",
        "illegal drug product still life: cannabis buds in a glass jar, cocaine bricks wrapped in plastic, pills in a tray, "
        "dim backroom scale and banknotes, not a greenhouse",
    ),
    (
        "materials",
        "production materials still life: grow lamps, soil bags, fertilizer, glass lab flasks and precursor bottles on a steel table, "
        "supply catalog, not finished drugs",
    ),
    (
        "facilities",
        "night exterior of a hidden weed greenhouse attached to a clandestine basement lab, "
        "fogged glass, ventilation stacks, chain-link and amber security lights",
    ),
    (
        "properties",
        "row of crime-family properties at dusk: townhouse, warehouse and nightclub facade, "
        "gold-lit windows, wet street, real-estate catalog, not a crowded dance floor",
    ),
    (
        "aircraft",
        "private jet inside a luxury hangar, Citation-style business aircraft three-quarter view, "
        "polished floor reflections, hangar floodlights, full scene not a cutout",
    ),
    (
        "backpacks",
        "still life of tactical backpacks and a hard travel suitcase open on a hotel bed, "
        "gold zipper, leather and ballistic nylon, packing for a smuggling run",
    ),
    (
        "security",
        "body-armor catalog still life: stab vest, bulletproof vest and ceramic plate carrier on mannequins, "
        "kevlar texture, dim fitting-room light",
    ),
    (
        "ammo",
        "ammunition catalog still life: 9mm, shotgun shells and rifle magazines in open crates, "
        "brass cartridges catching amber light, factory table",
    ),
    (
        "travel",
        "airport night departure: private-jet stairs, passport and boarding envelope on a railing, "
        "runway lights bokeh, international travel mood, no readable letters",
    ),
    (
        "crimes",
        "cinematic street crime tableau: shattered jewelry-store glass, getaway sedan, dropped cash, "
        "police lights in the distance, noir heist atmosphere, no gore",
    ),
    (
        "jobs",
        "honest side jobs still life: stacked newspapers, car-wash bucket and sponge, supermarket crate, "
        "early-morning street, legal work catalog, not a gym",
    ),
    (
        "crew",
        "crew headquarters mansion compound at night with iron gates, luxury cars and a rooftop lookout, "
        "organized crime family HQ, gold window light",
    ),
    (
        "school",
        "underground crime-school lecture hall with chalkboard tactics diagrams, desks and a projector, "
        "education catalog, not a courtroom",
    ),
    (
        "guide",
        "open leather crime handbook and fountain pen on a mahogany desk beside a brass lamp, "
        "noir instruction manual still life, gold-edged pages, no readable letters",
    ),
    (
        "profile",
        "film-noir dressing table with a gangster portrait in a gilt frame, fedora and pocket watch, "
        "avatar customization mood, warm amber lamp, no readable letters",
    ),
]


def _hub_assets(output_root: Path) -> List[dict]:
    return [
        {
            "name": key,
            "out": output_root / f"{key}.png",
            "prompt": f"{STYLE}{prompt}",
        }
        for key, prompt in HUBS
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
    mirror_dir = ROOT / "client" / "assets" / "images" / "wiki" / "hubs"
    mirror_dir.mkdir(parents=True, exist_ok=True)
    for src in generated_paths:
        shutil.copy2(src, mirror_dir / src.name)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate wiki hub tile images via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument("--only", default="", help="Comma-separated hub keys to generate")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images" / "wiki" / "hubs"),
    )
    parser.add_argument("--mirror-client-assets", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    assets = _hub_assets(output_root)
    if args.only:
        wanted = {k.strip() for k in args.only.split(",") if k.strip()}
        assets = [a for a in assets if a["name"] in wanted]

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
            generated_paths.append(out_path)
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
        print("Mirrored generated files to client/assets/images/wiki/hubs")

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
