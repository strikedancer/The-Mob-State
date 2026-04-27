#!/usr/bin/env python3
"""Generate a responsive vault banner image via Leonardo API.

Outputs:
  client/assets/images/vault/vault_banner.png

Requires LEONARDO_API_KEY (env or .env files per project convention).
"""

from __future__ import annotations

import argparse
import os
import time
from pathlib import Path
from typing import Dict, Tuple

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
DEFAULT_HEIGHT = 1024  # Leonardo preset-safe; UI crops responsively

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, blurry, low detail, "
    "cartoon, anime, oversaturated neon, frame, border, collage"
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
    ]

    generation_id = None
    last_payload = None
    last_error: Exception | None = None

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
    resp = requests.get(url, timeout=90)
    resp.raise_for_status()
    out_path.write_bytes(resp.content)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate a vault banner via Leonardo API")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--width", type=int, default=DEFAULT_WIDTH)
    parser.add_argument("--height", type=int, default=DEFAULT_HEIGHT)
    parser.add_argument("--attempts", type=int, default=2)
    parser.add_argument("--sleep", type=float, default=2.0)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--estimate-only", action="store_true")
    parser.add_argument("--confirm-batch", default="")
    parser.add_argument(
        "--out",
        default=str(ROOT / "client" / "assets" / "images" / "vault" / "vault_banner.png"),
        help="Output path for vault banner PNG",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    out_path = Path(args.out)

    print("Planned generation: 1")
    print(f"Output: {out_path}")
    print(f"Size: {args.width}x{args.height}")

    if args.estimate_only:
        print("estimate-only: no images will be generated")
        return

    if not API_KEY:
        raise RuntimeError("LEONARDO_API_KEY is not set")
    if args.confirm_batch != "YES":
        raise RuntimeError("Safety stop: add --confirm-batch YES to run generation")

    if out_path.exists() and not args.force:
        print(f"skip (exists): {out_path} (use --force to overwrite)")
        return

    prompt = (
        "Cinematic dark-mafia game UI banner, heavy steel vault door close-up on the left, "
        "subtle scratches and brushed metal, gold accents, warm amber rim light, smoky noir atmosphere. "
        "On the right, a modern numeric keypad embedded in the wall (no readable digits, no text), "
        "soft gold glow, premium polished style, high detail, semi-realistic digital art, no logos."
    )

    last_exc: Exception | None = None
    for attempt in range(1, args.attempts + 1):
        try:
            print(f"Generating vault banner ({attempt}/{args.attempts})")
            url = _generate_one(prompt, args.model, args.width, args.height)
            _save_image(url, out_path)
            print(f"saved: {out_path}")
            return
        except Exception as exc:  # noqa: BLE001
            last_exc = exc
            print(f"Failed attempt {attempt}: {exc}")
            if attempt < args.attempts:
                time.sleep(args.sleep)

    raise RuntimeError(f"Vault banner generation failed after {args.attempts} attempts: {last_exc}")


if __name__ == "__main__":
    main()

