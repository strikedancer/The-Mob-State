#!/usr/bin/env python3
"""Fix opaque/fake-transparent vehicle images with local background removal.

- Scans all base vehicle variants (new/dirty/damaged)
- Detects whether image has real alpha transparency
- Applies local rembg when image is effectively opaque
- Writes a report under backend/reports/vehicle_background_fix.json
"""

from __future__ import annotations

import json
import argparse
from io import BytesIO
from pathlib import Path
from typing import Dict, List, Set

from PIL import Image

try:
    from rembg import remove as rembg_remove
except Exception as exc:  # noqa: BLE001
    raise SystemExit(
        "rembg is not installed. Run: pip install rembg onnxruntime"
    ) from exc

ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"
ASSET_DIR = ROOT / "client" / "assets" / "images" / "vehicles"
REPORT_JSON = ROOT / "backend" / "reports" / "vehicle_background_fix.json"

ALPHA_MIN_TRANSPARENT_PIXELS = 50


def collect_base_names(data: dict) -> Set[str]:
    names: Set[str] = set()
    for key in ("cars", "boats", "motorcycles"):
        for item in data.get(key, []):
            for field in ("imageNew", "imageDirty", "imageDamaged"):
                name = item.get(field)
                if isinstance(name, str) and name.strip():
                    names.add(name.strip())
    return names


def transparent_pixels(path: Path) -> int:
    with Image.open(path) as im:
        rgba = im.convert("RGBA")
        alpha = rgba.getchannel("A")
        hist = alpha.histogram()
        return int(sum(hist[:255]))


def fix_one(path: Path, force_recut: bool = False) -> Dict[str, object]:
    before = transparent_pixels(path)
    if before >= ALPHA_MIN_TRANSPARENT_PIXELS and not force_recut:
        return {"status": "ok", "before": before, "after": before}

    raw = path.read_bytes()
    processed = rembg_remove(raw)
    with Image.open(BytesIO(processed)) as out:
        out.convert("RGBA").save(path, format="PNG")

    after = transparent_pixels(path)
    if after >= ALPHA_MIN_TRANSPARENT_PIXELS:
        return {"status": "fixed", "before": before, "after": after}

    return {"status": "failed", "before": before, "after": after}


def main() -> None:
    parser = argparse.ArgumentParser(description="Fix fake-transparent vehicle images")
    parser.add_argument(
        "--force-recut",
        action="store_true",
        help="Run local background removal on all base images, even if alpha looks OK",
    )
    args = parser.parse_args()

    data = json.loads(VEHICLES_JSON.read_text(encoding="utf-8"))
    names = sorted(collect_base_names(data))

    results: List[Dict[str, object]] = []
    ok = 0
    fixed = 0
    failed = 0
    missing = 0

    for name in names:
        path = ASSET_DIR / name
        if not path.exists():
            missing += 1
            results.append({"file": str(path), "status": "missing"})
            continue

        res = fix_one(path, force_recut=args.force_recut)
        results.append({"file": str(path), **res})
        if res["status"] == "ok":
            ok += 1
        elif res["status"] == "fixed":
            fixed += 1
        else:
            failed += 1

    REPORT_JSON.parent.mkdir(parents=True, exist_ok=True)
    report = {
        "filesChecked": len(names),
        "forceRecut": bool(args.force_recut),
        "ok": ok,
        "fixed": fixed,
        "failed": failed,
        "missing": missing,
        "results": results,
    }
    REPORT_JSON.write_text(json.dumps(report, indent=2), encoding="utf-8")

    print("--- Vehicle Background Fix ---")
    print(f"checked: {len(names)}")
    print(f"ok: {ok}")
    print(f"fixed: {fixed}")
    print(f"failed: {failed}")
    print(f"missing: {missing}")
    print(f"report: {REPORT_JSON}")


if __name__ == "__main__":
    main()
