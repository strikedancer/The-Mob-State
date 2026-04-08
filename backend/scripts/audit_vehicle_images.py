import json
from pathlib import Path
from typing import Dict, List, Tuple

ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"
ASSET_DIR = ROOT / "client" / "assets" / "images" / "vehicles"
RESPONSIVE_SUFFIXES = ("mobile", "tablet", "desktop")
REPORT_DIR = ROOT / "backend" / "reports"
REPORT_JSON = REPORT_DIR / "vehicle_image_audit.json"
REPORT_MD = REPORT_DIR / "vehicle_image_audit.md"

KEY_TO_CATEGORY = {
    "cars": "car",
    "boats": "boat",
    "motorcycles": "motorcycle",
}

STATE_TO_FIELD = {
    "new": "imageNew",
    "dirty": "imageDirty",
    "damaged": "imageDamaged",
}


def _responsive_from_base(filename: str, suffix: str) -> str:
    p = Path(filename)
    return f"{p.stem}_{suffix}{p.suffix}"


def _init_totals() -> Dict[str, object]:
    return {
        "vehicles": 0,
        "variants": 0,
        "missing_base": 0,
        "missing_responsive": 0,
        "fully_ok_vehicles": 0,
        "categories": {},
    }


def _init_category_bucket(summary: Dict[str, object], category: str) -> Dict[str, int]:
    return summary["categories"].setdefault(
        category,
        {
            "vehicles": 0,
            "variants": 0,
            "missing_base": 0,
            "missing_responsive": 0,
            "fully_ok_vehicles": 0,
        },
    )


def _category_groups(raw: Dict[str, object]) -> List[Tuple[str, List[Dict[str, object]]]]:
    groups: List[Tuple[str, List[Dict[str, object]]]] = []
    for key, category in KEY_TO_CATEGORY.items():
        items = raw.get(key, [])
        if isinstance(items, list):
            groups.append((category, items))
    return groups


def audit() -> Dict[str, object]:
    with VEHICLES_JSON.open("r", encoding="utf-8") as f:
        raw = json.load(f)

    summary = _init_totals()
    vehicles_report: List[Dict[str, object]] = []

    for category, vehicles in _category_groups(raw):
        cat_bucket = _init_category_bucket(summary, category)

        for vehicle in vehicles:
            if not isinstance(vehicle, dict):
                continue

            vehicle_id = vehicle.get("id", "unknown")
            summary["vehicles"] += 1
            cat_bucket["vehicles"] += 1

            vehicle_ok = True
            variant_rows: List[Dict[str, object]] = []

            for state, field in STATE_TO_FIELD.items():
                summary["variants"] += 1
                cat_bucket["variants"] += 1

                base_name = vehicle.get(field)
                missing_files: List[str] = []

                if not isinstance(base_name, str) or not base_name.endswith(".png"):
                    base_ok = False
                    responsive_ok = False
                    missing_files.append(f"invalid-field:{field}")
                    summary["missing_base"] += 1
                    summary["missing_responsive"] += 1
                    cat_bucket["missing_base"] += 1
                    cat_bucket["missing_responsive"] += 1
                    vehicle_ok = False
                else:
                    base_path = ASSET_DIR / base_name
                    base_ok = base_path.exists()
                    if not base_ok:
                        missing_files.append(str(base_path.relative_to(ROOT)).replace("\\", "/"))
                        summary["missing_base"] += 1
                        cat_bucket["missing_base"] += 1
                        vehicle_ok = False

                    responsive_missing = []
                    for suffix in RESPONSIVE_SUFFIXES:
                        responsive_name = _responsive_from_base(base_name, suffix)
                        responsive_path = ASSET_DIR / responsive_name
                        if not responsive_path.exists():
                            responsive_missing.append(str(responsive_path.relative_to(ROOT)).replace("\\", "/"))

                    responsive_ok = len(responsive_missing) == 0
                    if not responsive_ok:
                        missing_files.extend(responsive_missing)
                        summary["missing_responsive"] += 1
                        cat_bucket["missing_responsive"] += 1
                        vehicle_ok = False

                variant_rows.append(
                    {
                        "state": state,
                        "base_ok": base_ok,
                        "responsive_ok": responsive_ok,
                        "missing_files": missing_files,
                    }
                )

            if vehicle_ok:
                summary["fully_ok_vehicles"] += 1
                cat_bucket["fully_ok_vehicles"] += 1

            vehicles_report.append(
                {
                    "id": vehicle_id,
                    "category": category,
                    "variants": variant_rows,
                }
            )

    return {"summary": summary, "vehicles": vehicles_report}


def write_reports(report: Dict[str, object]) -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)

    with REPORT_JSON.open("w", encoding="utf-8") as f:
        json.dump(report, f, indent=2)

    summary = report["summary"]
    lines = [
        "# Vehicle Image Audit",
        "",
        f"Vehicles checked: {summary['vehicles']}",
        f"Variants checked: {summary['variants']}",
        f"Missing base variants: {summary['missing_base']}",
        f"Missing responsive variants: {summary['missing_responsive']}",
        f"Fully OK vehicles: {summary['fully_ok_vehicles']}",
        "",
        "## By Category",
        "",
        "| Category | Vehicles | Variants | Missing Base | Missing Responsive | Fully OK |",
        "|---|---:|---:|---:|---:|---:|",
    ]

    for category, cat in summary["categories"].items():
        lines.append(
            f"| {category} | {cat['vehicles']} | {cat['variants']} | {cat['missing_base']} | {cat['missing_responsive']} | {cat['fully_ok_vehicles']} |"
        )

    lines.append("")
    lines.append("Detailed per-vehicle data is available in vehicle_image_audit.json.")

    with REPORT_MD.open("w", encoding="utf-8") as f:
        f.write("\n".join(lines))


if __name__ == "__main__":
    data = audit()
    write_reports(data)
    s = data["summary"]
    print("Vehicle image audit completed")
    print(f"Vehicles: {s['vehicles']}")
    print(f"Variants: {s['variants']}")
    print(f"Missing base: {s['missing_base']}")
    print(f"Missing responsive: {s['missing_responsive']}")
    print(f"Fully OK vehicles: {s['fully_ok_vehicles']}")
