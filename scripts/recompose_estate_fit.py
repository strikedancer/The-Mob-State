#!/usr/bin/env python3
"""Recompose estate lot with fence stretched to exact lot perimeter."""
from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image

LOT = Path(__file__).resolve().parents[1] / "client/assets/images/homes/estate_lot"
CHROMA = Path(r"C:\Users\strik\.cursor\projects\c-xampp-htdocs-mafia-game\assets")
SIZE = 1024
THR = 90
CR, CG, CB = 0, 255, 0


def key(im: Image.Image) -> Image.Image:
    im = im.convert("RGBA")
    px = im.load()
    w, h = im.size
    thr2 = THR * THR
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if (r - CR) ** 2 + (g - CG) ** 2 + (b - CB) ** 2 <= thr2 or (
                g > 170 and g >= r + 35 and g >= b + 35
            ):
                px[x, y] = (0, 0, 0, 0)
    return im


def lot_bbox(base: Image.Image) -> tuple[int, int, int, int]:
    arr = np.array(base)
    r, g, b, a = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2], arr[:, :, 3]
    bg = (
        (np.abs(r.astype(int) - 158) < 28)
        & (np.abs(g.astype(int) - 158) < 28)
        & (np.abs(b.astype(int) - 158) < 28)
    )
    mask = (a > 200) & (~bg)
    ys, xs = np.where(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()), int(ys.max())


def place_building(src_path: Path, zone: tuple[int, int, int, int], fill: float) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key(Image.open(src_path))
    box = keyed.split()[-1].getbbox()
    if not box:
        return canvas
    cropped = keyed.crop(box)
    zl, zt, zr, zb = zone
    zw, zh = zr - zl, zb - zt
    cw, ch = cropped.size
    scale = min(zw / cw, zh / ch) * fill
    nw, nh = max(1, int(cw * scale)), max(1, int(ch * scale))
    resized = cropped.resize((nw, nh), Image.Resampling.LANCZOS)
    x = zl + (zw - nw) // 2
    y = zt + int((zh - nh) * 0.82)
    canvas.paste(resized, (x, y), resized)
    return canvas


def place_fence_stretch(src_path: Path, lx: int, ly: int, lw: int, lh: int) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key(Image.open(src_path))
    box = keyed.split()[-1].getbbox()
    if not box:
        return canvas
    cropped = keyed.crop(box)
    tw, th = lw + 12, lh + 16
    resized = cropped.resize((tw, th), Image.Resampling.LANCZOS)
    canvas.paste(resized, (lx - 6, ly - 10), resized)
    return canvas


def compose(base: Image.Image, levels: dict[str, int], name: str) -> None:
    out = base.copy()
    for track in ("fence", "shed", "house", "parking"):
        layer = Image.open(LOT / track / f"{track}_{levels[track]:02d}.png").convert("RGBA")
        out = Image.alpha_composite(out, layer)
    out.save(LOT / name)
    print("PREVIEW", name)


def main() -> None:
    large = CHROMA / "estate_base_grass_large.png"
    if large.is_file():
        Image.open(large).convert("RGBA").resize((SIZE, SIZE)).save(LOT / "base_grass.png")

    base = Image.open(LOT / "base_grass.png").convert("RGBA").resize((SIZE, SIZE))
    lx, ly, rx, ry = lot_bbox(base)
    lw, lh = rx - lx, ry - ly
    print("lot", lx, ly, rx, ry)

    w, h = lw, lh
    ix0, iy0 = lx + int(w * 0.18), ly + int(h * 0.16)
    ix1, iy1 = rx - int(w * 0.18), ry - int(h * 0.20)
    mx, my = (ix0 + ix1) // 2, (iy0 + iy1) // 2
    zones = {
        "house": (ix0, iy0, mx - 10, my + 30),
        "shed": (mx + 10, iy0, ix1, my + 20),
        "parking": (ix0 + 50, my, ix1 - 50, iy1),
    }
    fills = {"house": 0.72, "shed": 0.62, "parking": 0.68}

    for track in ("house", "shed", "parking"):
        for level in range(1, 11):
            src = CHROMA / f"estate_chroma_{track}_{level:02d}.png"
            if not src.exists():
                print("missing", src)
                continue
            place_building(src, zones[track], fills[track]).save(
                LOT / track / f"{track}_{level:02d}.png"
            )
        print("done", track)

    for level in range(1, 11):
        src = CHROMA / f"estate_chroma_fence_{level:02d}.png"
        if not src.exists():
            print("missing", src)
            continue
        place_fence_stretch(src, lx, ly, lw, lh).save(LOT / "fence" / f"fence_{level:02d}.png")
    print("done fence")

    compose(base, {"house": 1, "parking": 1, "shed": 1, "fence": 1}, "preview_composite_all_l1.png")
    compose(base, {"house": 10, "parking": 10, "shed": 10, "fence": 10}, "preview_composite_all_l10.png")
    compose(base, {"house": 10, "parking": 9, "shed": 3, "fence": 6}, "preview_h10_s3_p9_f6.png")
    compose(base, {"house": 7, "parking": 5, "shed": 3, "fence": 9}, "preview_composite_mixed.png")


if __name__ == "__main__":
    main()
