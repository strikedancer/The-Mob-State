#!/usr/bin/env python3
"""Generate action-timeout overlay stills via Leonardo.

Outputs:
  runtime/client-images/cooldown_crimes.png
  runtime/client-images/cooldown_jobs.png
  runtime/client-images/cooldown_airfield.png
  runtime/client-images/cooldown_school.png

Optional --mirror-client-assets copies into client/assets/images/...

Jail overlay still is generated separately:
  backend/scripts/generate_jail_image_leonardo.py

Requires LEONARDO_API_KEY and --confirm-batch YES.
Use --force to overwrite the old 3D/illustration overlays.
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

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, captions, title, signage, "
    "readable writing, neon letters, dollar bills wallpaper, fedora costume, "
    "blurry, low detail, cartoon, anime, 3D render, CGI character, plastic skin, "
    "oversaturated neon, cyberpunk, frame, border, collage, gore, group portrait"
)

STYLE = (
    "Cinematic dark-mafia game still, photoreal, noir amber rim light, "
    "rich gold and deep shadow, centered composition, no text. "
)

STILLS: List[Tuple[str, str]] = [
    (
        "cooldown_crimes",
        "After a night job: a lone man in a dark overcoat sits in a leather chair "
        "by rain-streaked windows, city lights below, blinds half drawn, empty whiskey glass, "
        "quiet cooling-off mood, no fedora, no cash pile",
    ),
    (
        "cooldown_jobs",
        "End of a long night shift: a tired man in a rumpled work shirt sits at a diner counter "
        "with a coffee cup, empty late-night diner, wet street through the window, amber interior, "
        "no fedora, no neon letters",
    ),
    (
        "cooldown_airfield",
        "Empty private-terminal lounge at night, a man in a dark coat waits on a bench, "
        "rain on the glass wall, distant aircraft lights on wet tarmac, gold rim light, "
        "no fedora, no airline logos",
    ),
    (
        "cooldown_school",
        "Dim university reading room at night, a man in a dark shirt studies at a wooden desk, "
        "open unmarked notebooks, brass desk lamp, oak shelves, no readable writing, no map labels",
    ),
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
        return str(generate["generationId"])
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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate cooldown overlay stills via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument("--only", default="", help="Comma-separated still names")
    parser.add_argument(
        "--output-root",
        default=str(ROOT / "runtime" / "client-images"),
    )
    parser.add_argument("--mirror-client-assets", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_root = Path(args.output_root)
    jobs = [
        {
            "name": name,
            "out": output_root / f"{name}.png",
            "prompt": f"{STYLE}{scene}",
        }
        for name, scene in STILLS
    ]
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
                    CARD_WIDTH,
                    CARD_HEIGHT,
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
        for src in generated_paths:
            dst = ROOT / "client" / "assets" / "images" / src.name
            shutil.copy2(src, dst)
            print(f"Mirrored to {dst}")

    print("Done")
    print(f"- success: {success}")
    print(f"- skipped: {skipped}")
    print(f"- failed: {failed}")
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
