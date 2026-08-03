#!/usr/bin/env python3
"""Build aligned transparent estate-lot layers from chroma-green source art."""
from __future__ import annotations

import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LOT = ROOT / "client" / "assets" / "images" / "homes" / "estate_lot"
CHROMA_SRC = Path(r"C:\Users\strik\.cursor\projects\c-xampp-htdocs-mafia-game\assets")
SIZE = 1024
CHROMA = (0, 255, 0)
THRESHOLD = 90


def detect_lot_bbox(base: Image.Image) -> tuple[int, int, int, int]:
    arr = np.array(base.convert("RGBA"))
    r, g, b, a = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2], arr[:, :, 3]
    bg = (
        (np.abs(r.astype(int) - 158) < 28)
        & (np.abs(g.astype(int) - 158) < 28)
        & (np.abs(b.astype(int) - 158) < 28)
    )
    mask = (a > 200) & (~bg)
    ys, xs = np.where(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())


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
    return im.split()[-1].getbbox()


def place_in_zone(
    src: Image.Image,
    zone: tuple[int, int, int, int],
    max_fill: float,
    ground: bool = True,
) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key_to_rgba(src)
    box = bbox_nonzero(keyed)
    if not box:
        return canvas
    cropped = keyed.crop(box)
    zl, zt, zr, zb = zone
    zw, zh = max(1, zr - zl), max(1, zb - zt)
    cw, ch = cropped.size
    scale = min(zw / cw, zh / ch) * max_fill
    nw, nh = max(1, int(cw * scale)), max(1, int(ch * scale))
    resized = cropped.resize((nw, nh), Image.Resampling.LANCZOS)
    x = zl + (zw - nw) // 2
    if ground:
        y = zt + int((zh - nh) * 0.78)
    else:
        y = zt + (zh - nh) // 2
    canvas.paste(resized, (x, y), resized)
    return canvas


def find_source(track: str, level: int) -> Path | None:
    n = f"{level:02d}"
    for p in (
        CHROMA_SRC / f"estate_chroma_{track}_{n}.png",
        LOT / "_chroma" / track / f"{track}_{n}.png",
    ):
        if p.is_file():
            return p
    return None


def main() -> None:
    base_candidate = CHROMA_SRC / "estate_base_grass_large.png"
    if base_candidate.is_file():
        Image.open(base_candidate).convert("RGBA").resize((SIZE, SIZE)).save(
            LOT / "base_grass.png"
        )
        print("Updated base_grass.png from large lot")

    base = Image.open(LOT / "base_grass.png").convert("RGBA").resize((SIZE, SIZE))
    lx, ly, rx, ry = detect_lot_bbox(base)
    print(f"Lot bbox: {lx},{ly} -> {rx},{ry}")

    # Interior inset ~18% so buildings never touch fence/edge
    w, h = rx - lx, ry - ly
    ix0 = lx + int(w * 0.16)
    iy0 = ly + int(h * 0.14)
    ix1 = rx - int(w * 0.16)
    iy1 = ry - int(h * 0.18)
    mid_x = (ix0 + ix1) // 2
    mid_y = (iy0 + iy1) // 2

    # Compact non-overlapping building zones inside the lawn
    zones = {
        "house": ((ix0, iy0, mid_x - 8, mid_y + 20), 0.62),
        "shed": ((mid_x + 8, iy0, ix1, mid_y + 10), 0.55),
        "parking": ((ix0 + 40, mid_y - 10, ix1 - 40, iy1), 0.58),
        # Fence must cover the FULL lot outer edge
        "fence": ((lx - 4, ly - 8, rx + 4, ry + 8), 1.0),
    }

    for track, (zone, max_fill) in zones.items():
        out_dir = LOT / track
        out_dir.mkdir(parents=True, exist_ok=True)
        for level in range(1, 11):
            src = find_source(track, level)
            if src is None:
                print(f"MISSING chroma {track} {level}", file=sys.stderr)
                continue
            placed = place_in_zone(
                Image.open(src),
                zone,
                max_fill,
                ground=(track != "fence"),
            )
            out = out_dir / f"{track}_{level:02d}.png"
            placed.save(out)
            print(f"OK {out.name} zone={zone} fill={max_fill}")

    def compose(levels: dict[str, int], name: str) -> None:
        out = base.copy()
        # Fence under buildings so oversized fence art doesn't bury them;
        # front gate still readable at edges.
        for track in ("fence", "shed", "house", "parking"):
            path = LOT / track / f"{track}_{levels[track]:02d}.png"
            if not path.is_file():
                continue
            layer = Image.open(path).convert("RGBA").resize((SIZE, SIZE))
            out = Image.alpha_composite(out, layer)
        out.save(LOT / name)
        print(f"PREVIEW {name}")

    compose({"house": 1, "parking": 1, "shed": 1, "fence": 1}, "preview_composite_all_l1.png")
    compose({"house": 10, "parking": 10, "shed": 10, "fence": 10}, "preview_composite_all_l10.png")
    compose({"house": 7, "parking": 5, "shed": 3, "fence": 9}, "preview_composite_mixed.png")
    compose({"house": 10, "parking": 9, "shed": 3, "fence": 6}, "preview_h10_s3_p9_f6.png")


if __name__ == "__main__":
    main()
