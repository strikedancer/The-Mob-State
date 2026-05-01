#!/usr/bin/env python3
"""Generate starter gangster portraits `default_1` (male) and `default_2` (female) via Leonardo API.

Writes PNGs to:
  client/assets/images/avatars/default_1.png
  client/assets/images/avatars/default_2.png
and mirrors to:
  client/images/avatars/

Requires LEONARDO_API_KEY (env or backend/.env.local, .env, etc. — same pattern as other Leonardo scripts).

Run from repo root or backend/:
  python backend/scripts/generate_default_avatars_leonardo.py
"""

from __future__ import annotations

import os
import shutil
import time
from pathlib import Path

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
SIZE = 1024

NEGATIVE_PROMPT = (
    "text, logo, watermark, letters, numbers, UI labels, blurry, low detail, "
    "anime, oversaturated neon, frame, border, collage, real bank trademarks, gore"
)

JOBS: list[tuple[str, str]] = [
    (
        "default_1",
        "Film noir portrait, male gangster in 1940s suit and fedora, stern expression, "
        "dark moody lighting, muted browns and deep shadows, semi-realistic game avatar style, "
        "bust shot, transparent or simple dark gradient background, no text",
    ),
    (
        "default_2",
        "Film noir portrait, female gangster in 1940s elegant coat or blazer and period hat, "
        "confident expression, dark moody lighting, muted browns and deep shadows, "
        "semi-realistic game avatar style, bust shot, simple dark gradient background, no text",
    ),
]


def _headers() -> dict[str, str]:
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
        return str(payload["generationId"])
    if payload.get("id"):
        return str(payload["id"])
    gen = payload.get("generate", {})
    if isinstance(gen, dict) and gen.get("generationId"):
        return str(gen["generationId"])
    data = payload.get("data", {})
    if isinstance(data, dict) and data.get("generationId"):
        return str(data["generationId"])
    return None


def _extract_image_url(payload) -> str | None:
    if isinstance(payload, list):
        payload = payload[0] if payload else {}
    if not isinstance(payload, dict):
        return None
    gens = payload.get("generations_by_pk") or payload.get("generations")
    if isinstance(gens, dict):
        images = gens.get("generated_images") or []
        if images and isinstance(images[0], dict):
            return images[0].get("url") or images[0].get("imageUrl")
    images = payload.get("generated_images") or []
    if images and isinstance(images[0], dict):
        return images[0].get("url") or images[0].get("imageUrl")
    return None


def _wait_for_image(generation_id: str, timeout_s: int = 300) -> str | None:
    deadline = time.time() + timeout_s
    while time.time() < deadline:
        r = requests.get(
            f"{STATUS_URL_V1}/{generation_id}",
            headers=_headers(),
            timeout=60,
        )
        r.raise_for_status()
        body = r.json()
        url = _extract_image_url(body)
        if url:
            return url
        time.sleep(3)
    return None


def _generate_one(filename: str, prompt: str) -> Path:
    out_assets = ROOT / "client" / "assets" / "images" / "avatars" / f"{filename}.png"
    out_assets.parent.mkdir(parents=True, exist_ok=True)

    payload = {
        "model": DEFAULT_MODEL,
        "width": SIZE,
        "height": SIZE,
        "prompt": prompt,
        "negativePrompt": NEGATIVE_PROMPT,
        "num_images": 1,
    }
    r = requests.post(GENERATE_URL_V2, headers=_headers(), json=payload, timeout=120)
    r.raise_for_status()
    gen_id = _extract_generation_id(r.json())
    if not gen_id:
        raise RuntimeError(f"No generation id in response: {r.text[:500]}")

    url = _wait_for_image(gen_id)
    if not url:
        raise TimeoutError(f"Leonardo did not finish in time: {filename}")

    img = requests.get(url, timeout=120)
    img.raise_for_status()
    out_assets.write_bytes(img.content)

    out_mirror = ROOT / "client" / "images" / "avatars" / f"{filename}.png"
    out_mirror.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(out_assets, out_mirror)
    print(f"OK: {out_assets}")
    return out_assets


def main() -> None:
    if not API_KEY:
        raise SystemExit("LEONARDO_API_KEY missing (env or .env file).")
    for name, prompt in JOBS:
        _generate_one(name, prompt)
    print("Done: default_1.png + default_2.png")


if __name__ == "__main__":
    main()
