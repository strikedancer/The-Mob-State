#!/usr/bin/env python3
"""Build zero-cost TuneShop fallback assets from existing backgrounds."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter, ImageOps

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "client" / "assets" / "images" / "backgrounds" / "garage_background.png"
OUT_DESKTOP = ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_desktop.png"
OUT_TABLET = ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_tablet.png"
OUT_MOBILE = ROOT / "client" / "assets" / "images" / "backgrounds" / "tuneshop_bg_mobile.png"
OUT_EMBLEM = ROOT / "client" / "assets" / "images" / "ui" / "tuneshop_emblem.png"


def _grade(base: Image.Image) -> Image.Image:
    img = base.convert("RGBA")
    img = ImageEnhance.Color(img).enhance(0.8)
    img = ImageEnhance.Contrast(img).enhance(1.12)
    img = ImageEnhance.Brightness(img).enhance(0.72)

    # Neon amber/steel-blue split tone overlay for TuneShop identity.
    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    w, h = img.size
    draw.rectangle([0, 0, int(w * 0.45), h], fill=(255, 152, 0, 32))
    draw.rectangle([int(w * 0.45), 0, w, h], fill=(66, 165, 245, 36))

    # Subtle center vignette to keep text readable.
    vignette = Image.new("L", img.size, 0)
    vdraw = ImageDraw.Draw(vignette)
    margin = int(min(w, h) * 0.08)
    vdraw.rectangle([margin, margin, w - margin, h - margin], fill=160)
    vignette = vignette.filter(ImageFilter.GaussianBlur(radius=min(w, h) * 0.14))

    shaded = Image.composite(img, Image.new("RGBA", img.size, (0, 0, 0, 220)), ImageOps.invert(vignette))
    mixed = Image.alpha_composite(shaded, overlay)
    return mixed


def _fit(img: Image.Image, size: tuple[int, int]) -> Image.Image:
    return ImageOps.fit(img, size, method=Image.Resampling.LANCZOS)


def _build_emblem(path: Path) -> None:
    size = 1024
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Outer ring.
    d.ellipse((120, 120, 904, 904), outline=(255, 193, 7, 255), width=34)
    d.ellipse((180, 180, 844, 844), outline=(120, 190, 255, 255), width=18)

    # Crossed tools (stylized).
    d.rounded_rectangle((290, 460, 760, 560), radius=22, fill=(210, 210, 210, 255))
    d.rounded_rectangle((420, 300, 520, 760), radius=22, fill=(235, 235, 235, 255))

    # Center bolt.
    d.ellipse((448, 448, 576, 576), fill=(255, 152, 0, 255), outline=(255, 230, 180, 255), width=6)

    # Soft glow.
    glow = img.filter(ImageFilter.GaussianBlur(8))
    img = Image.alpha_composite(glow, img)

    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, format="PNG")


def main() -> None:
    if not SRC.exists():
        raise FileNotFoundError(f"Missing source image: {SRC}")

    base = Image.open(SRC)
    graded = _grade(base)

    OUT_DESKTOP.parent.mkdir(parents=True, exist_ok=True)
    _fit(graded, (1792, 1024)).save(OUT_DESKTOP, format="PNG")
    _fit(graded, (1536, 1024)).save(OUT_TABLET, format="PNG")
    _fit(graded, (1024, 1536)).save(OUT_MOBILE, format="PNG")

    _build_emblem(OUT_EMBLEM)

    print("TuneShop fallback assets built:")
    print(f"- {OUT_DESKTOP}")
    print(f"- {OUT_TABLET}")
    print(f"- {OUT_MOBILE}")
    print(f"- {OUT_EMBLEM}")


if __name__ == "__main__":
    main()
