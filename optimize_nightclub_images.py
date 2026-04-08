from pathlib import Path
from PIL import Image

FILES = [
    (Path('client/assets/images/backgrounds/nightclub_hub_bg_mobile.png'), 192),
    (Path('client/assets/images/backgrounds/nightclub_hub_bg_tablet.png'), 224),
    (Path('client/assets/images/backgrounds/nightclub_hub_bg_desktop.png'), 256),
    (Path('client/assets/images/ui/nightclub_hub_emblem_mobile.png'), 160),
    (Path('client/assets/images/ui/nightclub_hub_emblem_tablet.png'), 192),
    (Path('client/assets/images/ui/nightclub_hub_emblem_desktop.png'), 224),
]

for path, colors in FILES:
    if not path.exists():
        print(f'skip missing: {path}')
        continue

    before_kb = path.stat().st_size / 1024
    with Image.open(path) as img:
        rgb = img.convert('RGB')
        quant = rgb.quantize(colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.FLOYDSTEINBERG)
        quant.save(path, format='PNG', optimize=True)

    after_kb = path.stat().st_size / 1024
    print(f'{path}: {before_kb:.1f}KB -> {after_kb:.1f}KB (colors={colors})')
