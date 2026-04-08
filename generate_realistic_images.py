#!/usr/bin/env python3
"""
Generate realistic-looking crime scene images using advanced PIL techniques
"""

from PIL import Image, ImageDraw, ImageFilter, ImageOps
import random
import math
from pathlib import Path

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Crime definitions with cinematic styles
CRIMES = {
    "pickpocket": {"colors": ["#2d1b3d", "#7d3c7d", "#c94c4c"], "style": "dark_urban"},
    "shoplift": {"colors": ["#d4621f", "#3d2317", "#8b4513"], "style": "retail"},
    "steal_bike": {"colors": ["#1a1a3d", "#4c4c8b", "#7d3d5c"], "style": "street_night"},
    "car_theft": {"colors": ["#8b0000", "#1a1a1a", "#4c3d3d"], "style": "dark_street"},
    "burglary": {"colors": ["#000033", "#2d2d5c", "#5c3d7d"], "style": "night"},
    "rob_store": {"colors": ["#cc0000", "#331a00", "#660000"], "style": "tense"},
    "mug_person": {"colors": ["#333333", "#8b3d3d", "#1a1a1a"], "style": "dark"},
    "steal_car_parts": {"colors": ["#4c4c4c", "#8b6f47", "#333333"], "style": "industrial"},
    "hijack_truck": {"colors": ["#001a4c", "#1a3d5c", "#ffff00"], "style": "highway"},
    "atm_theft": {"colors": ["#003d8b", "#1a5c8b", "#666666"], "style": "urban_night"},
    "jewelry_heist": {"colors": ["#8b1a7d", "#d4af37", "#1a1a1a"], "style": "luxury"},
    "vandalism": {"colors": ["#ff3333", "#ffff00", "#000000"], "style": "spray"},
    "graffiti": {"colors": ["#ff3333", "#00cc00", "#0000ff"], "style": "colorful"},
    "drug_deal_small": {"colors": ["#009900", "#1a1a1a", "#666666"], "style": "alley"},
    "drug_deal_large": {"colors": ["#8b6f47", "#1a1a1a", "#333333"], "style": "warehouse"},
    "extortion": {"colors": ["#990000", "#1a1a1a", "#4c4c4c"], "style": "threatening"},
    "kidnapping": {"colors": ["#000000", "#1a0000", "#333333"], "style": "dark"},
    "arson": {"colors": ["#ff6600", "#ff0000", "#000000"], "style": "fire"},
    "smuggling": {"colors": ["#8b6f47", "#4c4c4c", "#1a1a1a"], "style": "industrial"},
    "assassination": {"colors": ["#000000", "#990000", "#cccccc"], "style": "noir"},
    "eliminate_witness": {"colors": ["#1a0000", "#330000", "#1a1a1a"], "style": "dark"},
    "diamond_heist": {"colors": ["#0066cc", "#d4af37", "#ffffff"], "style": "luxury"},
    "evidence_room_heist": {"colors": ["#003d7d", "#666666", "#1a1a1a"], "style": "covert"},
    "hack_account": {"colors": ["#00cc00", "#000000", "#0099ff"], "style": "cyber"},
    "counterfeit_money": {"colors": ["#009900", "#4c4c4c", "#000000"], "style": "print"},
    "identity_theft": {"colors": ["#0066cc", "#8b1a7d", "#000000"], "style": "cyber"},
    "rob_armored_truck": {"colors": ["#000000", "#ffff00", "#4c4c4c"], "style": "action"},
    "art_theft": {"colors": ["#8b1a7d", "#d4af37", "#1a1a1a"], "style": "luxury"},
    "protection_racket": {"colors": ["#000000", "#cc0000", "#4c4c4c"], "style": "dark"},
    "casino_heist": {"colors": ["#d4af37", "#cc0000", "#000000"], "style": "luxury"},
    "bank_robbery": {"colors": ["#0066cc", "#000000", "#d4af37"], "style": "tense"},
    "museum_heist": {"colors": ["#8b1a7d", "#d4af37", "#8b6f47"], "style": "artistic"},
    "boss_assassination": {"colors": ["#000000", "#cc0000", "#d4af37"], "style": "dark"},
    "steal_yacht": {"colors": ["#0066cc", "#d4af37", "#ffffff"], "style": "ocean"},
    "corrupt_official": {"colors": ["#003d7d", "#4c4c4c", "#000000"], "style": "office"},
}

def hex_to_rgb(hex_color):
    """Convert hex color to RGB"""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def add_noise(image, amount=30):
    """Add realistic noise to image"""
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            if random.random() < 0.05:
                r, g, b = pixels[x, y][:3]
                noise = random.randint(-amount, amount)
                pixels[x, y] = (
                    max(0, min(255, r + noise)),
                    max(0, min(255, g + noise)),
                    max(0, min(255, b + noise))
                )
    return image

def create_gradient_background(width, height, color1, color2):
    """Create smooth gradient background"""
    img = Image.new("RGB", (width, height))
    pixels = img.load()
    
    r1, g1, b1 = color1
    r2, g2, b2 = color2
    
    for y in range(height):
        ratio = y / height
        r = int(r1 + (r2 - r1) * ratio)
        g = int(g1 + (g2 - g1) * ratio)
        b = int(b1 + (b2 - b1) * ratio)
        
        for x in range(width):
            pixels[x, y] = (r, g, b)
    
    return img

def create_crime_image(crime_id, colors, style):
    """Generate realistic-looking crime scene image"""
    
    width, height = 800, 450
    
    # Parse colors
    c1 = hex_to_rgb(colors[0])
    c2 = hex_to_rgb(colors[1])
    c3 = hex_to_rgb(colors[2])
    
    # Create base gradient
    img = create_gradient_background(width, height, c1, c2)
    draw = ImageDraw.Draw(img, 'RGBA')
    
    # Add overlays with different angles
    for angle in [0, 45, 90, 135]:
        rad = math.radians(angle)
        for i in range(0, max(width, height), 40):
            opacity = random.randint(10, 30)
            x1 = int(width/2 + i * math.cos(rad))
            y1 = int(height/2 + i * math.sin(rad))
            x2 = int(width/2 - i * math.cos(rad))
            y2 = int(height/2 - i * math.sin(rad))
            draw.line([(x1, y1), (x2, y2)], fill=(*c3, opacity), width=2)
    
    # Add bokeh-like circles for depth
    for _ in range(8):
        x = random.randint(0, width)
        y = random.randint(0, height)
        r = random.randint(40, 150)
        opacity = random.randint(5, 25)
        draw.ellipse([x-r, y-r, x+r, y+r], outline=(*c3, opacity), width=3)
    
    # Add atmospheric rectangles
    for _ in range(6):
        x = random.randint(0, width-100)
        y = random.randint(0, height-100)
        w = random.randint(50, 200)
        h = random.randint(50, 200)
        opacity = random.randint(8, 20)
        draw.rectangle([x, y, x+w, y+h], outline=(*c3, opacity), width=2)
    
    # Apply filters for photorealistic effect
    img = img.filter(ImageFilter.GaussianBlur(radius=3))
    img = add_noise(img, amount=20)
    img = img.filter(ImageFilter.SMOOTH_MORE)
    
    # Add subtle vignette effect
    vignette = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    vignette_draw = ImageDraw.Draw(vignette)
    for i in range(width):
        for j in range(height):
            dist = math.sqrt((i - width/2)**2 + (j - height/2)**2)
            max_dist = math.sqrt((width/2)**2 + (height/2)**2)
            opacity = int(50 * (dist / max_dist))
            vignette_draw.point((i, j), fill=(0, 0, 0, opacity))
    
    img = Image.alpha_composite(img.convert("RGBA"), vignette).convert("RGB")
    
    return img

print("Creating Realistic Crime Scene Images...")
print(f"Output: {OUTPUT_DIR.absolute()}")
print(f"Total: {len(CRIMES)} images")
print("=" * 60)

success_count = 0
for crime_id, props in CRIMES.items():
    try:
        filename = f"{crime_id}_crime.png"
        print(f"Creating {filename}...", end=" ", flush=True)
        
        img = create_crime_image(crime_id, props["colors"], props["style"])
        img.save(OUTPUT_DIR / filename, "PNG", quality=95)
        
        print(f"✅")
        success_count += 1
    except Exception as e:
        print(f"❌ {str(e)[:30]}")

print("=" * 60)
print(f"✅ Created: {success_count}/{len(CRIMES)}")
print(f"📁 Location: {OUTPUT_DIR.absolute()}")
print("\n✨ Reload browser: Ctrl+Shift+R")
