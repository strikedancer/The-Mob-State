#!/usr/bin/env python3
"""Convert chroma-green estate lot layer PNGs to transparent PNGs."""
from __future__ import annotations

import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow required: pip install Pillow", file=sys.stderr)
    raise

# Pure green used in generation prompts
CHROMA = (0, 255, 0)
# Distance threshold (0-441ish for RGB euclidean); tune if fringe remains
THRESHOLD = 85


def key_file(src: Path, dst: Path) -> None:
    im = Image.open(src).convert("RGBA")
    pixels = im.load()
    w, h = im.size
    cr, cg, cb = CHROMA
    thr2 = THRESHOLD * THRESHOLD
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            dr, dg, db = r - cr, g - cg, b - cb
            if dr * dr + dg * dg + db * db <= thr2:
                pixels[x, y] = (r, g, b, 0)
            elif g > 180 and g > r + 40 and g > b + 40:
                # soft fringe: mostly green
                pixels[x, y] = (r, g, b, 0)
    dst.parent.mkdir(parents=True, exist_ok=True)
    im.save(dst)
    print(f"OK {dst}")


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    src_root = root / "client" / "assets" / "images" / "homes" / "estate_lot" / "_chroma"
    dst_root = root / "client" / "assets" / "images" / "homes" / "estate_lot"
    if not src_root.is_dir():
        print(f"Missing {src_root}", file=sys.stderr)
        sys.exit(1)
    for path in sorted(src_root.rglob("*.png")):
        rel = path.relative_to(src_root)
        key_file(path, dst_root / rel)


if __name__ == "__main__":
    main()
