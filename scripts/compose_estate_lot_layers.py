#!/usr/bin/env python3
"""Build aligned transparent estate-lot layers from chroma-green source art.

Each source object is keyed, scaled into a fixed zone on the shared lot canvas,
and saved as a full-frame RGBA PNG so Flutter can Stack them on base_grass.
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LOT = ROOT / "client" / "assets" / "images" / "homes" / "estate_lot"
CHROMA_SRC = Path(r"C:\Users\strik\.cursor\projects\c-xampp-htdocs-mafia-game\assets")
SIZE = 1024
CHROMA = (0, 255, 0)
THRESHOLD = 90

# Destination rectangles on the 1024 canvas (left, top, right, bottom)
ZONES = {
    "house": (90, 180, 520, 720),
    "shed": (520, 160, 900, 620),
    "parking": (280, 520, 780, 900),
    "fence": (40, 80, 980, 960),
}


def key_to_rgba(im: Image.Image) -> Image.Image:
    im = im.convert("RGBA")
    pixels = im.load()
    w, h = im.size
    cr, cg, cb = CHROMA
    thr2 = THRESHOLD * THRESHOLD
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            dr, dg, db = r - cr, g - cg, b - cb
            if dr * dr + dg * dg + db * db <= thr2:
                pixels[x, y] = (0, 0, 0, 0)
            elif g > 170 and g >= r + 35 and g >= b + 35:
                pixels[x, y] = (0, 0, 0, 0)
    return im


def bbox_nonzero(im: Image.Image):
    alpha = im.split()[-1]
    return alpha.getbbox()


def place_in_zone(src: Image.Image, zone: tuple[int, int, int, int]) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key_to_rgba(src)
    box = bbox_nonzero(keyed)
    if not box:
        return canvas
    cropped = keyed.crop(box)
    zl, zt, zr, zb = zone
    zw, zh = zr - zl, zb - zt
    cw, ch = cropped.size
    scale = min(zw / cw, zh / ch)
    nw, nh = max(1, int(cw * scale)), max(1, int(ch * scale))
    resized = cropped.resize((nw, nh), Image.Resampling.LANCZOS)
    x = zl + (zw - nw) // 2
    y = zt + (zh - nh) // 2
    canvas.paste(resized, (x, y), resized)
    return canvas


def find_source(track: str, level: int) -> Path | None:
    n = f"{level:02d}"
    candidates = [
        CHROMA_SRC / f"estate_chroma_{track}_{n}.png",
        LOT / "_chroma" / track / f"{track}_{n}.png",
        LOT / track / f"{track}_{n}.png",
    ]
    for p in candidates:
        if p.is_file():
            return p
    return None


def main() -> None:
    for track, zone in ZONES.items():
        out_dir = LOT / track
        out_dir.mkdir(parents=True, exist_ok=True)
        for level in range(1, 11):
            src = find_source(track, level)
            if src is None:
                print(f"MISSING {track} {level}", file=sys.stderr)
                continue
            im = Image.open(src)
            placed = place_in_zone(im, zone)
            out = out_dir / f"{track}_{level:02d}.png"
            placed.save(out)
            print(f"OK {out.name} from {src.name}")

    # Preview composites
    base = Image.open(LOT / "base_grass.png").convert("RGBA").resize((SIZE, SIZE))

    def compose(levels: dict[str, int], name: str) -> None:
        out = base.copy()
        order = ["shed", "house", "parking", "fence"]
        for track in order:
            layer = Image.open(LOT / track / f"{track}_{levels[track]:02d}.png").convert("RGBA")
            out = Image.alpha_composite(out, layer)
        out.save(LOT / name)
        print(f"PREVIEW {name}")

    compose({"house": 1, "parking": 1, "shed": 1, "fence": 1}, "preview_composite_all_l1.png")
    compose({"house": 10, "parking": 10, "shed": 10, "fence": 10}, "preview_composite_all_l10.png")
    compose({"house": 7, "parking": 5, "shed": 3, "fence": 9}, "preview_composite_mixed.png")


if __name__ == "__main__":
    main()
