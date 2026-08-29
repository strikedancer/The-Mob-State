#!/usr/bin/env python3
"""Generate circular-friendly result overlay badges (fail + success) via Leonardo.

Writes to:
  runtime/client-images/ui/result_badge_fail.png
  runtime/client-images/ui/result_badge_success.png

Optional mirror into client assets (--mirror-client-assets).

Requires LEONARDO_API_KEY (env or backend/.env.local per PROTOCOL_MASTER).
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
    "text, logo, watermark, letters, numbers, UI chrome, frame border, collage, "
    "blurry, low detail, cartoon, anime, cute mascot, photoreal face close-up"
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
        poll_resp = requests.get(
            f"{STATUS_URL_V1}/{generation_id}", headers=_headers(), timeout=60
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


def _badges() -> List[dict]:
    return [
        {
            "id": "result_badge_fail",
            "prompt": (
                "Square game UI badge icon for a failed crime, dark noir mafia style, "
                "centered broken padlock and red warning flare, cold steel and crimson rim light, "
                "gritty cinematic, solid dark background, compact centered subject for circular crop, "
                "no text, no letters, no watermark"
            ),
        },
        {
            "id": "result_badge_success",
            "prompt": (
                "Square game UI badge icon for a successful heist, dark noir mafia style, "
                "centered golden trophy cup with subtle cash stack silhouette, warm gold rim light, "
                "cinematic premium look, solid dark background, compact centered for circular crop, "
                "no text, no letters, no watermark"
            ),
        },
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--mirror-client-assets", action="store_true")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--only", default="", help="Comma ids, e.g. result_badge_fail")
    args = parser.parse_args()

    badges = _badges()
    if args.only.strip():
        wanted = {x.strip() for x in args.only.split(",") if x.strip()}
        badges = [b for b in badges if b["id"] in wanted]

    out_dir = ROOT / "runtime" / "client-images" / "ui"
    mirror_dir = ROOT / "client" / "assets" / "images" / "ui"

    print(f"Badges: {len(badges)}")
    print(f"Out: {out_dir}")
    if args.estimate_only:
        return 0

    if not API_KEY:
        raise SystemExit("LEONARDO_API_KEY missing")

    if args.confirm_batch != "YES":
        raise SystemExit('Pass --confirm-batch YES to spend Leonardo credits')

    for badge in badges:
        out_path = out_dir / f"{badge['id']}.png"
        if out_path.exists() and not args.force:
            print(f"SKIP {out_path.name} (exists)")
            continue
        print(f"GEN {badge['id']} ...")
        url = _generate_one(badge["prompt"], args.model)
        _save_image(url, out_path)
        print(f"OK  {out_path}")
        if args.mirror_client_assets:
            mirror_dir.mkdir(parents=True, exist_ok=True)
            shutil.copy2(out_path, mirror_dir / out_path.name)
            print(f"MIR {mirror_dir / out_path.name}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
