import os
import time
from pathlib import Path

import requests

API_KEY = os.getenv("LEONARDO_API_KEY", "a7132d07-0987-45df-8372-1e6c7985803a")
GENERATE_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
MODEL_NAME = "nano-banana-2"

ROOT = Path(__file__).parent
OUT_BG = ROOT / "client" / "assets" / "images" / "backgrounds"
OUT_UI = ROOT / "client" / "assets" / "images" / "ui"
OUT_BG.mkdir(parents=True, exist_ok=True)
OUT_UI.mkdir(parents=True, exist_ok=True)

ASSETS = [
    {
        "name": "smuggling_hub_bg.png",
        "out": OUT_BG,
        "width": 1792,
        "height": 1024,
        "prompt": (
            "Cinematic clandestine smuggling operations room, atlas maps, shipping manifests, "
            "cargo containers and harbor lights at night, moody teal and amber lighting, "
            "high detail, game UI background, no text, no logos, no watermark"
        ),
    },
    {
        "name": "smuggling_hub_emblem.png",
        "out": OUT_UI,
        "width": 1024,
        "height": 1024,
        "prompt": (
            "Stylized smuggling syndicate emblem, cargo crate and route lines motif, "
            "metallic badge icon, game UI icon style, centered composition, no text, no watermark"
        ),
    },
    {
        "name": "smuggling_crate.png",
        "out": OUT_UI,
        "width": 1024,
        "height": 1024,
        "prompt": (
            "Game UI icon of a contraband crate with sealed tape and customs stickers, "
            "clean edges, slight isometric angle, high readability, no text, no watermark"
        ),
    },
]


def generate(prompt: str, width: int, height: int) -> str:
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {API_KEY}",
    }

    payload = {
        "model": MODEL_NAME,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF",
        },
        "public": False,
    }

    response = requests.post(GENERATE_URL, json=payload, headers=headers, timeout=90)
    response.raise_for_status()
    data = response.json()

    generation_id = data.get("generationId") or data.get("generate", {}).get("generationId")

    if not generation_id:
        raise RuntimeError(f"Could not parse generation ID from response: {data}")

    return generation_id


def wait_and_get_image_url(generation_id: str) -> str:
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {API_KEY}",
    }

    for _ in range(120):
        r = requests.get(f"{STATUS_URL}/{generation_id}", headers=headers, timeout=60)
        r.raise_for_status()
        data = r.json()

        generation = data.get("generations_by_pk", {})
        status = generation.get("status")
        generated = generation.get("generated_images") or []
        if status == "COMPLETE" and generated:
            url = generated[0].get("url")
            if url:
                return url
        if status == "FAILED":
            raise RuntimeError(f"Generation failed for {generation_id}")

        time.sleep(3)

    raise TimeoutError(f"Timed out waiting for generation {generation_id}")


def download(url: str, out_file: Path) -> None:
    r = requests.get(url, timeout=120)
    r.raise_for_status()
    out_file.write_bytes(r.content)


if __name__ == "__main__":
    print("Generating smuggling assets with Leonardo...")

    for asset in ASSETS:
        out_file = asset["out"] / asset["name"]
        print(f"- Generating {out_file.name}")
        gen_id = generate(asset["prompt"], asset["width"], asset["height"])
        image_url = wait_and_get_image_url(gen_id)
        download(image_url, out_file)
        print(f"  Saved: {out_file}")

    print("Done")
