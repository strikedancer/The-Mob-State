#!/usr/bin/env python3
"""
Generate realistic crime scene images using Flux AI via Replicate Python client
"""

import replicate
import os
from pathlib import Path

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Crime prompts - detailed for Flux
CRIME_PROMPTS = {
    "pickpocket": "cinematic screenshot of a skillful pickpocket stealing wallet from busy crowd in city market, detailed realistic scene, 16:9,professional photography",
    "shoplift": "cinematic supermarket interior with shoplifting in progress, realistic lighting, professional photo, 16:9 aspect ratio",
    "steal_bike": "nighttime urban alley, bicycle theft in progress, dark moody lighting, photorealistic, 16:9 aspect ratio",
    "car_theft": "car theft at night, criminals breaking into vehicle, dramatic lighting, photorealistic scene, 16:9 aspect ratio",
    "burglary": "nighttime home burglary, breaking and entering, dramatic shadows, realistic crime scene, 16:9 aspect ratio",
    "rob_store": "store robbery action scene, indoor retail environment, dramatic professional lighting, 16:9 aspect ratio",
    "mug_person": "urban street mugging scene at night, dark alley, photorealistic, 16:9 aspect ratio",
    "steal_car_parts": "garage interior with car parts theft, workshop setting, professional lighting, 16:9 aspect ratio",
    "hijack_truck": "highway scene with truck hijacking, vehicles, action sequence, 16:9 aspect ratio",
    "atm_theft": "street ATM location, robbery scene, urban nighttime, photorealistic, 16:9 aspect ratio",
    "jewelry_heist": "luxury jewelry store interior, theft in progress, elegant setting, 16:9 aspect ratio",
    "vandalism": "urban street wall with graffiti and vandalism, destruction scene, daytime, 16:9 aspect ratio",
    "graffiti": "street artist spray painting wall at night, graffiti creation, action shot, 16:9 aspect ratio",
    "drug_deal_small": "dark alley midnight drug deal scene, noir style, photorealistic, 16:9 aspect ratio",
    "drug_deal_large": "industrial warehouse drug deal, large scale operation, night scene, 16:9 aspect ratio",
    "extortion": "dark alley confrontation, threatening scene, noir atmosphere, 16:9 aspect ratio",
    "kidnapping": "noir dark crime scene, dramatic shadows, tense atmosphere, 16:9 aspect ratio",
    "arson": "burning building at night, intense flames and smoke, dramatic fire scene, 16:9 aspect ratio",
    "smuggling": "warehouse interior with cargo containers, smuggling operation, industrial, 16:9 aspect ratio",
    "assassination": "dark dramatic noir scene, shadows and tension, thriller atmosphere, 16:9 aspect ratio",
    "eliminate_witness": "noir inspired dark crime scene, dramatic shadows, thriller mood, 16:9 aspect ratio",
    "diamond_heist": "luxury jewelry museum display, theft scene, elegant interior, 16:9 aspect ratio",
    "evidence_room_heist": "police evidence room, theft in progress, security systems visible, 16:9 aspect ratio",
    "hack_account": "computer hacking scene, dark room with glowing screens, cyberpunk, 16:9 aspect ratio",
    "counterfeit_money": "industrial printing operation, money printing, factory setting, 16:9 aspect ratio",
    "identity_theft": "cybercrime scene, computer screens, hacking setup, digital thriller, 16:9 aspect ratio",
    "rob_armored_truck": "armored vehicle robbery on highway, action scene, dramatic lighting, 16:9 aspect ratio",
    "art_theft": "museum gallery art theft, stealing valuable painting, security, 16:9 aspect ratio",
    "protection_racket": "street confrontation, threatening scene, dark noir style, 16:9 aspect ratio",
    "casino_heist": "luxury casino interior, robbery heist scene, elegant setting night, 16:9 aspect ratio",
    "bank_robbery": "bank interior with vault doors, heist action scene dramatic, 16:9 aspect ratio",
    "museum_heist": "museum interior, artifact theft, security systems, professional lighting, 16:9 aspect ratio",
    "boss_assassination": "dark noir assassination scene, targeted action, thriller mood, 16:9 aspect ratio",
    "steal_yacht": "luxury yacht on ocean at night, yacht theft scene, dramatic, 16:9 aspect ratio",
    "corrupt_official": "dark office interior, corruption scene noir style, professional, 16:9 aspect ratio",
}

def generate_image(crime_id, prompt):
    """Generate single image using Replicate client"""
    try:
        filename = f"{crime_id}_crime.png"
        filepath = OUTPUT_DIR / filename
        
        # Skip if exists
        if filepath.exists():
            print(f"[OK] {filename}")
            return True
        
        print(f"[GENERATING] {filename}...", end=" ", flush=True)
        
        output = replicate.run(
            "black-forest-labs/flux-1.1-pro",
            input={
                "prompt": prompt,
                "aspect_ratio": "16:9",
                "output_format": "png",
                "num_outputs": 1,
            }
        )
        
        if output and len(output) > 0:
            image_url = output[0]
            
            # Download image
            import requests
            response = requests.get(image_url, timeout=60)
            
            if response.status_code == 200:
                with open(filepath, 'wb') as f:
                    f.write(response.content)
                print(f"[SUCCESS] ({len(response.content)//1024}KB)")
                return True
            else:
                print(f"[ERROR] Download failed")
                return False
        else:
            print(f"[ERROR] No output")
            return False
            
    except Exception as e:
        print(f"[ERROR] {str(e)[:40]}")
        return False

# Check API key
api_key = os.getenv("REPLICATE_API_TOKEN")
if not api_key:
    print("[ERROR] REPLICATE_API_TOKEN not set")
    print("\nSet token in PowerShell:")
    print('$env:REPLICATE_API_TOKEN = "your-token"')
    exit(1)

print("[INFO] Flux 1.1 Pro Image Generation")
print(f"[INFO] Output: {OUTPUT_DIR.absolute()}")
print(f"[INFO] Total: {len(CRIME_PROMPTS)} images")
print("=" * 60)

success = 0
failed = []

# Generate all images
for crime_id, prompt in CRIME_PROMPTS.items():
    if generate_image(crime_id, prompt):
        success += 1
    else:
        failed.append(crime_id)

print("\n" + "=" * 60)
print(f"[RESULT] Generated: {success}/{len(CRIME_PROMPTS)}")
print(f"[INFO] Location: {OUTPUT_DIR.absolute()}")

if failed:
    print(f"\n[WARNING] Failed: {len(failed)}")
    for crime in failed[:5]:
        print(f"  - {crime}")
else:
    print(f"\n[SUCCESS] All images generated!")

print("\n[INFO] Reload browser: Ctrl+Shift+R")
