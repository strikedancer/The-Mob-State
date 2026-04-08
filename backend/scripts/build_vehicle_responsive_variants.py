#!/usr/bin/env python3
"""Create responsive mobile/tablet/desktop derivatives for vehicle images.

Input images live in client/assets/images/vehicles.
Output files are written in the same folder with suffixes:
- _mobile
- _tablet
- _desktop
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Iterable, Set

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"
ASSET_DIR = ROOT / "client" / "assets" / "images" / "vehicles"

SIZES = {
    "mobile": (640, 400),
    "tablet": (1024, 640),
    "desktop": (1600, 1000),
}


def collect_image_names(data: dict) -> Set[str]:
    names: Set[str] = set()
    for key in ("cars", "boats", "motorcycles"):
        for v in data.get(key, []):
            for field in ("image", "imageNew", "imageDirty", "imageDamaged"):
                name = v.get(field)
                if isinstance(name, str) and name.strip():
                    names.add(name.strip())
    return names


def fit_to_canvas(src: Image.Image, size: tuple[int, int]) -> Image.Image:
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    resized = src.copy()
    resized.thumbnail(size, Image.Resampling.LANCZOS)
    x = (size[0] - resized.width) // 2
    y = (size[1] - resized.height) // 2
    canvas.paste(resized, (x, y), resized)
    return canvas


def out_name(base_name: str, suffix: str) -> str:
    p = Path(base_name)
    return f"{p.stem}_{suffix}{p.suffix}"


def build_variants(names: Iterable[str], force: bool = False) -> tuple[int, int]:
    created = 0
    skipped = 0

    for name in names:
        src_path = ASSET_DIR / name
        if not src_path.exists():
            skipped += len(SIZES)
            continue

        with Image.open(src_path) as src:
            src_rgba = src.convert("RGBA")
            for suffix, size in SIZES.items():
                dst = ASSET_DIR / out_name(name, suffix)
                if dst.exists() and not force:
                    skipped += 1
                    continue
                image = fit_to_canvas(src_rgba, size)
                dst.parent.mkdir(parents=True, exist_ok=True)
                image.save(dst, format="PNG")
                created += 1

    return created, skipped


def main() -> None:
    parser = argparse.ArgumentParser(description="Build responsive vehicle variants")
    parser.add_argument("--force", action="store_true", help="Overwrite existing responsive variants")
    args = parser.parse_args()

    data = json.loads(VEHICLES_JSON.read_text(encoding="utf-8"))
    names = sorted(collect_image_names(data))
    created, skipped = build_variants(names, force=args.force)
    print(f"Responsive variants created: {created}")
    print(f"Responsive variants skipped: {skipped}")


if __name__ == "__main__":
    main()
