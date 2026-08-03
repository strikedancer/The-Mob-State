#!/usr/bin/env python3
"""Compose estate lot on a fixed 12x12 grass grid.

Grid (Excel-style): columns A-L (0-11), rows 1-12 (0-11).
Outer ring (A, L, row1, row12) reserved for fence.
Buildings:
  house   C3:F6   (cols C-F, rows 3-6)  4x4
  shed    C7:F10  (cols C-F, rows 7-10) 4x4
  parking H3:K6   (cols H-K, rows 3-6)  4x4
  (H7:K10 kept clear as buffer / future slot)
"""
from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
LOT = ROOT / "client/assets/images/homes/estate_lot"
CHROMA = Path(r"C:\Users\strik\.cursor\projects\c-xampp-htdocs-mafia-game\assets")
SIZE = 1024
GRID = 12
THR = 90
CR, CG, CB = 0, 255, 0

# Column letters A..L -> 0..11
COL = {chr(ord("A") + i): i for i in range(12)}


def cell_rect(
    lot: tuple[int, int, int, int],
    col0: str,
    row0: int,
    col1: str,
    row1: int,
) -> tuple[int, int, int, int]:
    """Inclusive Excel-style range -> pixel rect inside lot bbox."""
    lx, ly, rx, ry = lot
    cw = (rx - lx) / GRID
    ch = (ry - ly) / GRID
    c0, c1 = COL[col0.upper()], COL[col1.upper()]
    r0, r1 = row0 - 1, row1 - 1  # 1-based -> 0-based
    left = int(lx + c0 * cw)
    top = int(ly + r0 * ch)
    right = int(lx + (c1 + 1) * cw)
    bottom = int(ly + (r1 + 1) * ch)
    return left, top, right, bottom


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


def place_in_cells(
    src: Path,
    lot: tuple[int, int, int, int],
    col0: str,
    row0: int,
    col1: str,
    row1: int,
    fill: float = 0.92,
) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key(Image.open(src))
    box = keyed.split()[-1].getbbox()
    if not box:
        return canvas
    cropped = keyed.crop(box)
    zl, zt, zr, zb = cell_rect(lot, col0, row0, col1, row1)
    # small inset so buildings don't touch cell edges
    pad = 4
    zl, zt, zr, zb = zl + pad, zt + pad, zr - pad, zb - pad
    zw, zh = max(1, zr - zl), max(1, zb - zt)
    cw, ch = cropped.size
    scale = min(zw / cw, zh / ch) * fill
    nw, nh = max(1, int(cw * scale)), max(1, int(ch * scale))
    resized = cropped.resize((nw, nh), Image.Resampling.LANCZOS)
    x = zl + (zw - nw) // 2
    y = zt + (zh - nh) // 2
    canvas.paste(resized, (x, y), resized)
    return canvas


def place_fence_perimeter(src: Path, lot: tuple[int, int, int, int]) -> Image.Image:
    """Scale fence ring to the full 12x12 lot outer edge."""
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    keyed = key(Image.open(src))
    box = keyed.split()[-1].getbbox()
    if not box:
        return canvas
    cropped = keyed.crop(box)
    lx, ly, rx, ry = lot
    # Fence uses full outer ring = entire lot bbox
    tw, th = (rx - lx) + 8, (ry - ly) + 8
    resized = cropped.resize((tw, th), Image.Resampling.LANCZOS)
    canvas.paste(resized, (lx - 4, ly - 4), resized)
    return canvas


def draw_debug_grid(base: Image.Image, lot: tuple[int, int, int, int]) -> Image.Image:
    img = base.copy()
    draw = ImageDraw.Draw(img)
    lx, ly, rx, ry = lot
    cw = (rx - lx) / GRID
    ch = (ry - ly) / GRID
    for i in range(GRID + 1):
        x = int(lx + i * cw)
        y = int(ly + i * ch)
        draw.line([(x, ly), (x, ry)], fill=(255, 255, 0, 90), width=1)
        draw.line([(lx, y), (rx, y)], fill=(255, 255, 0, 90), width=1)
    # highlight zones
    zones = [
        ("C", 3, "F", 6, (0, 200, 255, 60)),    # house
        ("C", 7, "F", 10, (255, 160, 0, 60)),   # shed
        ("H", 3, "K", 6, (0, 255, 120, 60)),    # parking
        ("H", 7, "K", 10, (180, 180, 180, 40)), # reserved
    ]
    for c0, r0, c1, r1, color in zones:
        rect = cell_rect(lot, c0, r0, c1, r1)
        draw.rectangle(rect, outline=color[:3] + (200,), width=2)
    # labels
    for label, c0, r0, c1, r1 in (
        ("HOUSE", "C", 3, "F", 6),
        ("SHED", "C", 7, "F", 10),
        ("GARAGE", "H", 3, "K", 6),
        ("FREE", "H", 7, "K", 10),
    ):
        l, t, r, b = cell_rect(lot, c0, r0, c1, r1)
        draw.text((l + 6, t + 6), label, fill=(255, 255, 255, 220))
    # column letters / row numbers
    for i, letter in enumerate("ABCDEFGHIJKL"):
        x = int(lx + (i + 0.35) * cw)
        draw.text((x, ly - 14), letter, fill=(255, 255, 0, 200))
    for i in range(12):
        y = int(ly + (i + 0.3) * ch)
        draw.text((lx - 16, y), str(i + 1), fill=(255, 255, 0, 200))
    return img


def find_src(track: str, level: int) -> Path | None:
    p = CHROMA / f"estate_chroma_{track}_{level:02d}.png"
    return p if p.is_file() else None


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
    lot = lot_bbox(base)
    print("lot bbox", lot)

    # Debug grid overlay (for design check)
    draw_debug_grid(base, lot).save(LOT / "preview_grid_12x12.png")
    print("Wrote preview_grid_12x12.png")

    placements = {
        "house": ("C", 3, "F", 6, 0.90),
        "shed": ("C", 7, "F", 10, 0.90),
        "parking": ("H", 3, "K", 6, 0.90),
    }

    for track, (c0, r0, c1, r1, fill) in placements.items():
        (LOT / track).mkdir(parents=True, exist_ok=True)
        for level in range(1, 11):
            src = find_src(track, level)
            if src is None:
                print("MISSING", track, level)
                continue
            place_in_cells(src, lot, c0, r0, c1, r1, fill).save(
                LOT / track / f"{track}_{level:02d}.png"
            )
        print("done", track, f"{c0}{r0}:{c1}{r1}")

    (LOT / "fence").mkdir(parents=True, exist_ok=True)
    for level in range(1, 11):
        src = find_src("fence", level)
        if src is None:
            print("MISSING fence", level)
            continue
        place_fence_perimeter(src, lot).save(LOT / "fence" / f"fence_{level:02d}.png")
    print("done fence 12x12 perimeter")

    compose(base, {"house": 1, "parking": 1, "shed": 1, "fence": 1}, "preview_composite_all_l1.png")
    compose(base, {"house": 10, "parking": 10, "shed": 10, "fence": 10}, "preview_composite_all_l10.png")
    compose(base, {"house": 10, "parking": 9, "shed": 3, "fence": 6}, "preview_h10_s3_p9_f6.png")
    compose(base, {"house": 7, "parking": 5, "shed": 3, "fence": 9}, "preview_composite_mixed.png")

    # Grid + example combo
    example = Image.open(LOT / "preview_h10_s3_p9_f6.png").convert("RGBA")
    grid = draw_debug_grid(base, lot)
    # blend light grid on example
    blended = Image.alpha_composite(example, Image.blend(
        Image.new("RGBA", example.size, (0, 0, 0, 0)),
        grid.convert("RGBA"),
        0.35,
    ))
    # simpler: just save grid separately and a labeled composite
    example.save(LOT / "preview_h10_s3_p9_f6.png")
    Image.alpha_composite(example, Image.new("RGBA", example.size, (0, 0, 0, 0)))
    # Overlay only zone outlines on the example for clarity
    overlay = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)
    for c0, r0, c1, r1, color in (
        ("C", 3, "F", 6, (0, 200, 255, 180)),
        ("C", 7, "F", 10, (255, 160, 0, 180)),
        ("H", 3, "K", 6, (0, 255, 120, 180)),
    ):
        d.rectangle(cell_rect(lot, c0, r0, c1, r1), outline=color, width=3)
    Image.alpha_composite(example, overlay).save(LOT / "preview_h10_s3_p9_f6_zones.png")
    print("Wrote preview_h10_s3_p9_f6_zones.png")


if __name__ == "__main__":
    main()
