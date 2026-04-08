#!/usr/bin/env python3
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VEHICLES_JSON = ROOT / "backend" / "content" / "vehicles.json"
ASSET_DIR = ROOT / "client" / "assets" / "images" / "vehicles"

FALLBACKS = {
    "car": {
        "common": ("toyota_corolla_new.png", "toyota_corolla_dirty.png", "toyota_corolla_damaged.png"),
        "uncommon": ("muscle_car_new.png", "muscle_car_dirty.png", "muscle_car_damaged.png"),
        "rare": ("luxury_sedan_new.png", "luxury_sedan_dirty.png", "luxury_sedan_damaged.png"),
        "epic": ("ferrari_f8_new.png", "ferrari_f8_dirty.png", "ferrari_f8_damaged.png"),
        "legendary": ("bugatti_chiron_new.png", "bugatti_chiron_dirty.png", "bugatti_chiron_damaged.png"),
    },
    "boat": {
        "common": ("fishing_boat_new.png", "fishing_boat_dirty.png", "fishing_boat_damaged.png"),
        "uncommon": ("speedboat_new.png", "speedboat_dirty.png", "speedboat_damaged.png"),
        "rare": ("sport_fishing_boat_new.png", "sport_fishing_boat_dirty.png", "sport_fishing_boat_damaged.png"),
        "epic": ("sport_yacht_50ft_new.png", "sport_yacht_50ft_dirty.png", "sport_yacht_50ft_damaged.png"),
        "legendary": ("superyacht_200ft_new.png", "superyacht_200ft_dirty.png", "superyacht_200ft_damaged.png"),
    },
    "motorcycle": {
        "common": ("toyota_corolla_new.png", "toyota_corolla_dirty.png", "toyota_corolla_damaged.png"),
        "uncommon": ("muscle_car_new.png", "muscle_car_dirty.png", "muscle_car_damaged.png"),
        "rare": ("audi_r8_v10_new.png", "audi_r8_v10_dirty.png", "audi_r8_v10_damaged.png"),
        "epic": ("mclaren_720s_new.png", "mclaren_720s_dirty.png", "mclaren_720s_damaged.png"),
        "legendary": ("bugatti_chiron_new.png", "bugatti_chiron_dirty.png", "bugatti_chiron_damaged.png"),
    },
}


def ensure_file(dst: Path, src_name: str):
    src = ASSET_DIR / src_name
    if not src.exists():
        return False
    if dst.exists():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(src, dst)
    return True


def apply_collection(items, category):
    created = 0
    for v in items:
        rarity = v.get("rarity", "common")
        fallback = FALLBACKS[category].get(rarity, FALLBACKS[category]["common"])

        targets = [
            v.get("imageNew") or f"{v['id']}_new.png",
            v.get("imageDirty") or f"{v['id']}_dirty.png",
            v.get("imageDamaged") or f"{v['id']}_damaged.png",
        ]

        for idx, target in enumerate(targets):
            dst = ASSET_DIR / target
            created += 1 if ensure_file(dst, fallback[idx]) else 0

        # default image points to new variant when missing
        image_name = v.get("image") or f"{v['id']}.png"
        created += 1 if ensure_file(ASSET_DIR / image_name, targets[0]) else 0
    return created


def main():
    data = json.loads(VEHICLES_JSON.read_text(encoding="utf-8"))
    created = 0
    created += apply_collection(data.get("cars", []), "car")
    created += apply_collection(data.get("boats", []), "boat")
    created += apply_collection(data.get("motorcycles", []), "motorcycle")
    print(f"Placeholder images created: {created}")


if __name__ == "__main__":
    main()
