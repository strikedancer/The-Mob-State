#!/usr/bin/env python3
"""
Generate prostitution image assets from PROSTITUTION_IMAGE_PROMPTS.md via Seedream (fal queue API).

Features:
- Parses prompt blocks from markdown (filename, location, resolution, prompt text)
- Generates all assets in one run
- Uses strict consistency defaults discovered for Seedream:
  - enhance_prompt = false
  - sequential_image_generation = false
  - max_images = 1
  - fixed width/height from markdown resolution
- Special handling for VIP success frame:
  - recruitment_anim_frame5_success_vip.png is generated as image edit from
    recruitment_anim_frame5_success.png to preserve composition.

Environment variables:
- FAL_KEY (required)
- SEEDREAM_GENERATE_MODEL (optional, default: fal-ai/bytedance/seedream/v4)
- SEEDREAM_EDIT_MODEL (optional, default: fal-ai/bytedance/seedream/v4/edit)
- PROMPTS_MD (optional, default: PROSTITUTION_IMAGE_PROMPTS.md)
- REGENERATE_EXISTING (optional: 1/true to overwrite existing files)
"""

from __future__ import annotations

import json
import os
import re
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import requests

BASE_QUEUE_URL = "https://queue.fal.run"
GENERATE_MODEL = os.getenv("SEEDREAM_GENERATE_MODEL", "fal-ai/bytedance/seedream/v4")
EDIT_MODEL = os.getenv("SEEDREAM_EDIT_MODEL", "fal-ai/bytedance/seedream/v4/edit")
PROMPTS_MD = Path(os.getenv("PROMPTS_MD", "PROSTITUTION_IMAGE_PROMPTS.md"))
REGENERATE_EXISTING = os.getenv("REGENERATE_EXISTING", "").strip().lower() in {"1", "true", "yes", "y"}


@dataclass
class PromptAsset:
    filename: str
    location: Path
    width: int
    height: int
    prompt: str
    heading: str

    @property
    def output_path(self) -> Path:
        return self.location / self.filename


def parse_resolution(value: str) -> Tuple[int, int]:
    match = re.search(r"(\d+)\s*x\s*(\d+)", value, flags=re.IGNORECASE)
    if not match:
        raise ValueError(f"Could not parse resolution: {value}")
    return int(match.group(1)), int(match.group(2))


def parse_markdown_assets(markdown_path: Path) -> List[PromptAsset]:
    if not markdown_path.exists():
        raise FileNotFoundError(f"Markdown file not found: {markdown_path}")

    content = markdown_path.read_text(encoding="utf-8")

    block_pattern = re.compile(
        r"^###\s+(?P<heading>.+?)\s*$"
        r"(?P<body>.*?)"
        r"```\s*\n(?P<prompt>.*?)\n```",
        flags=re.MULTILINE | re.DOTALL,
    )

    assets: List[PromptAsset] = []

    for match in block_pattern.finditer(content):
        heading = match.group("heading").strip()
        body = match.group("body")
        prompt = match.group("prompt").strip()

        filename_match = re.search(r"\*\*Bestandsnaam:\*\*\s*`([^`]+)`", body)
        location_match = re.search(r"\*\*Locatie:\*\*\s*`([^`]+)`", body)
        resolution_match = re.search(r"\*\*Resolutie:\*\*\s*([^\n]+)", body)

        if not filename_match or not location_match or not resolution_match:
            continue

        filename = filename_match.group(1).strip()
        location = Path(location_match.group(1).strip())
        width, height = parse_resolution(resolution_match.group(1).strip())

        assets.append(
            PromptAsset(
                filename=filename,
                location=location,
                width=width,
                height=height,
                prompt=prompt,
                heading=heading,
            )
        )

    return assets


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def fal_headers() -> Dict[str, str]:
    fal_key = os.getenv("FAL_KEY", "").strip()
    if not fal_key:
        print("[ERROR] FAL_KEY ontbreekt. Zet eerst: $env:FAL_KEY = 'jouw-key'")
        sys.exit(1)
    return {
        "Authorization": f"Key {fal_key}",
        "Content-Type": "application/json",
    }


def submit_fal_job(model: str, payload: Dict[str, Any], headers: Dict[str, str]) -> Dict[str, Any]:
    submit_url = f"{BASE_QUEUE_URL}/{model}"
    response = requests.post(submit_url, headers=headers, json=payload, timeout=60)
    response.raise_for_status()
    data = response.json()
    if not isinstance(data, dict):
        raise RuntimeError("Invalid submit response")
    return data


def wait_for_result(submit_response: Dict[str, Any], headers: Dict[str, str], timeout_s: int = 360) -> Dict[str, Any]:
    response_url = submit_response.get("response_url")
    status_url = submit_response.get("status_url")

    if not response_url:
        request_id = submit_response.get("request_id")
        if request_id:
            response_url = f"{BASE_QUEUE_URL}/{request_id}"
            status_url = f"{BASE_QUEUE_URL}/{request_id}/status"

    if not response_url:
        raise RuntimeError(f"No response URL in submit response: {submit_response}")

    start = time.time()
    while True:
        if time.time() - start > timeout_s:
            raise TimeoutError("Timed out waiting for fal job")

        if status_url:
            status_resp = requests.get(status_url, headers=headers, timeout=30)
            if status_resp.status_code == 200:
                status_data = status_resp.json()
                status = status_data.get("status")
                if status in {"FAILED", "CANCELLED"}:
                    raise RuntimeError(f"fal job failed: {json.dumps(status_data)}")
                if status == "COMPLETED":
                    result_resp = requests.get(response_url, headers=headers, timeout=30)
                    result_resp.raise_for_status()
                    return result_resp.json()

        result_resp = requests.get(response_url, headers=headers, timeout=30)
        if result_resp.status_code == 200:
            result_data = result_resp.json()
            if isinstance(result_data, dict):
                status = str(result_data.get("status", "")).upper()
                if status in {"FAILED", "CANCELLED"}:
                    raise RuntimeError(f"fal job failed: {json.dumps(result_data)}")
                if status in {"IN_QUEUE", "IN_PROGRESS", "PENDING", ""}:
                    pass
                else:
                    return result_data
            else:
                return {"data": result_data}

        time.sleep(2)


def extract_image_url(result: Dict[str, Any]) -> str:
    candidates: List[Any] = []

    for key in ("images", "output", "data"):
        if key in result:
            candidates.append(result[key])

    candidates.append(result)

    def walk(node: Any) -> Optional[str]:
        if isinstance(node, str) and node.startswith("http"):
            return node
        if isinstance(node, dict):
            for key in ("url", "image", "image_url"):
                value = node.get(key)
                if isinstance(value, str) and value.startswith("http"):
                    return value
            for value in node.values():
                found = walk(value)
                if found:
                    return found
        if isinstance(node, list):
            for item in node:
                found = walk(item)
                if found:
                    return found
        return None

    for candidate in candidates:
        found = walk(candidate)
        if found:
            return found

    raise RuntimeError(f"No image URL found in result: {json.dumps(result)[:1200]}")


def download_file(url: str, destination: Path) -> None:
    response = requests.get(url, timeout=120)
    response.raise_for_status()
    destination.write_bytes(response.content)


def build_generate_payload(asset: PromptAsset) -> Dict[str, Any]:
    return {
        "prompt": asset.prompt,
        "size": "custom",
        "width": asset.width,
        "height": asset.height,
        "enhance_prompt": False,
        "sequential_image_generation": False,
        "max_images": 1,
    }


def build_edit_payload(asset: PromptAsset, input_image_url: str) -> Dict[str, Any]:
    return {
        "prompt": asset.prompt,
        "image_input": [input_image_url],
        "size": "custom",
        "width": asset.width,
        "height": asset.height,
        "enhance_prompt": False,
        "sequential_image_generation": False,
        "max_images": 1,
        "match_input_image": True,
    }


def generate_asset(
    asset: PromptAsset,
    headers: Dict[str, str],
    prior_output_url: Optional[str] = None,
) -> str:
    ensure_dir(asset.location)

    if asset.output_path.exists() and not REGENERATE_EXISTING:
        print(f"[SKIP] {asset.output_path} (bestaat al)")
        return ""

    if prior_output_url:
        model = EDIT_MODEL
        payload = build_edit_payload(asset, prior_output_url)
        mode = "edit"
    else:
        model = GENERATE_MODEL
        payload = build_generate_payload(asset)
        mode = "generate"

    print(f"[RUN] {asset.filename} [{mode}] {asset.width}x{asset.height}")
    submit = submit_fal_job(model, payload, headers)
    result = wait_for_result(submit, headers)
    image_url = extract_image_url(result)
    download_file(image_url, asset.output_path)
    print(f"[OK]  {asset.output_path}")
    return image_url


def main() -> int:
    headers = fal_headers()

    assets = parse_markdown_assets(PROMPTS_MD)
    if not assets:
        print(f"[ERROR] Geen prompt assets gevonden in {PROMPTS_MD}")
        return 1

    print(f"[INFO] Gevonden assets: {len(assets)}")
    print(f"[INFO] Generate model: {GENERATE_MODEL}")
    print(f"[INFO] Edit model: {EDIT_MODEL}")
    print(f"[INFO] Regenerate existing: {REGENERATE_EXISTING}")

    assets_by_name = {asset.filename: asset for asset in assets}
    previous_urls: Dict[str, str] = {}
    failures: List[str] = []

    for asset in assets:
        try:
            ref_url: Optional[str] = None
            if asset.filename == "recruitment_anim_frame5_success_vip.png":
                ref_url = previous_urls.get("recruitment_anim_frame5_success.png")
                if ref_url is None:
                    base_asset = assets_by_name.get("recruitment_anim_frame5_success.png")
                    if base_asset:
                        generated_url = generate_asset(base_asset, headers)
                        if generated_url:
                            previous_urls[base_asset.filename] = generated_url
                            ref_url = generated_url
                        else:
                            if base_asset.output_path.exists():
                                print("[WARN] Base success frame bestond al; VIP fallback op text2img")
                            else:
                                raise RuntimeError("Kon base success frame niet als referentie genereren")

            generated_url = generate_asset(asset, headers, prior_output_url=ref_url)
            if generated_url:
                previous_urls[asset.filename] = generated_url
        except Exception as exc:
            failures.append(asset.filename)
            print(f"[ERR] {asset.filename}: {exc}")

    print("\n================ SUMMARY ================")
    success_count = len(assets) - len(failures)
    print(f"Success: {success_count}/{len(assets)}")
    if failures:
        print("Failed:")
        for filename in failures:
            print(f"- {filename}")
        return 2

    print("All prostitution assets generated.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
