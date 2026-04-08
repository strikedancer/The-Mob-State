#!/usr/bin/env python3
"""
Generate realistic crime scene images using Flux AI model via Replicate
"""

import replicate
import os
import time
from pathlib import Path

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Crime prompts for realistic AI generation
CRIME_PROMPTS = {
    "pickpocket": "professional photograph of a thief stealing a wallet from a person's pocket in a crowded street, cinematic, gritty",
    "shoplift": "professional photograph of shoplifting in a supermarket, security cameras, dramatic lighting",
    "steal_bike": "professional photograph of a person stealing a bicycle, urban setting, night time",
    "car_theft": "professional photograph of a car being stolen, urban street, breaking into vehicle",
    "burglary": "professional photograph of a home burglary, breaking into a house window, night",
    "rob_store": "professional photograph of a store robbery, person with weapon, dramatic lighting",
    "mug_person": "professional photograph of street mugging, urban alley, nighttime crime",
    "steal_car_parts": "professional photograph of stealing car parts in a garage, dismantled vehicle",
    "hijack_truck": "professional photograph of truck hijacking, highway, cargo theft, action scene",
    "atm_theft": "professional photograph of ATM robbery, person robbing cash machine, urban street",
    "jewelry_heist": "professional photograph of jewelry heist in luxury store, heist scene",
    "vandalism": "professional photograph of street vandalism, graffiti destruction, urban",
    "graffiti": "professional photograph of illegal graffiti artist spray painting wall, street art",
    "drug_deal_small": "professional photograph of street drug dealing, dark alley, urban crime",
    "drug_deal_large": "professional photograph of large drug trafficking operation, warehouse",
    "extortion": "professional photograph of extortion crime, threatening scene, dramatic",
    "kidnapping": "professional photograph of kidnapping crime scene, dramatic dark lighting",
    "arson": "professional photograph of arson fire crime, burning building, firefighters",
    "smuggling": "professional photograph of smuggling operation, cargo warehouse, contraband",
    "assassination": "professional photograph of assassination attempt, dramatic action scene",
    "eliminate_witness": "professional photograph of crime scene elimination, dark noir style",
    "diamond_heist": "professional photograph of diamond heist robbery, luxury jewelry case",
    "evidence_room_heist": "professional photograph of police evidence room heist, security system",
    "hack_account": "professional photograph of hacker at computer, cyber crime, neon lighting",
    "counterfeit_money": "professional photograph of counterfeit money operation, printing bills",
    "identity_theft": "professional photograph of identity theft crime, hacking passwords",
    "rob_armored_truck": "professional photograph of armored truck robbery, heist action scene",
    "art_theft": "professional photograph of art theft, stealing from museum, valuable painting",
    "protection_racket": "professional photograph of protection racket extortion, threatening",
    "casino_heist": "professional photograph of casino robbery heist, night operation",
    "bank_robbery": "professional photograph of bank robbery heist, vault theft, action",
    "museum_heist": "professional photograph of museum heist stealing artifacts, security",
    "boss_assassination": "professional photograph of assassination of crime boss, dramatic scene",
    "steal_yacht": "professional photograph of yacht theft, luxury boat robbery, ocean",
    "corrupt_official": "professional photograph of government corruption, bribery scene",
}

# Flux model to use (flux-dev is faster and cheaper than flux-pro)
FLUX_MODEL = "black-forest-labs/flux-pro"

def generate_with_flux(prompt, filename):
    """Generate image using Flux AI model via Replicate"""
    try:
        print(f"🎨 {filename}...", end=" ", flush=True)
        
        # Call Flux API
        output = replicate.run(
            FLUX_MODEL,
            input={
                "prompt": prompt,
                "aspect_ratio": "16:9",
                "output_format": "png",
                "num_outputs": 1,
            },
            timeout=120
        )
        
        if output and len(output) > 0:
            # Download and save the image
            image_url = output[0]
            import requests
            response = requests.get(image_url, timeout=30)
            
            if response.status_code == 200:
                filepath = OUTPUT_DIR / filename
                with open(filepath, 'wb') as f:
                    f.write(response.content)
                print(f"✅")
                return True
            else:
                print(f"❌ Download failed")
                return False
        else:
            print(f"❌ No output")
            return False
            
    except Exception as e:
        print(f"❌ {str(e)[:40]}")
        return False

# Check for API key
api_key = os.getenv("REPLICATE_API_TOKEN")
if not api_key:
    print("❌ ERROR: REPLICATE_API_TOKEN environment variable not set")
    print("\n📝 Setup required:")
    print("1. Get API key from: https://replicate.com/account/api-tokens")
    print("2. Set environment variable:")
    print("   Windows: setx REPLICATE_API_TOKEN your_key_here")
    print("   PowerShell: $env:REPLICATE_API_TOKEN='your_key_here'")
    print("3. Restart terminal and try again")
    exit(1)

print("🤖 Generating Realistic Crime Images with Flux AI")
print(f"📁 Output: {OUTPUT_DIR.absolute()}")
print(f"🖼️  Total: {len(CRIME_PROMPTS)} images")
print(f"🔑 Using: {FLUX_MODEL}")
print("=" * 60)

success_count = 0
failed_crimes = []

for crime_id, prompt in CRIME_PROMPTS.items():
    filename = f"{crime_id}_crime.png"
    
    if generate_with_flux(prompt, filename):
        success_count += 1
    else:
        failed_crimes.append(crime_id)
    
    # Rate limiting - avoid hitting API limits
    time.sleep(1)

print("=" * 60)
print(f"✅ Successfully generated: {success_count}/{len(CRIME_PROMPTS)}")
print(f"📁 Saved to: {OUTPUT_DIR.absolute()}")

if failed_crimes:
    print(f"\n⚠️  Failed crimes: {', '.join(failed_crimes)}")

print("\n✨ Next: Hard refresh browser (Ctrl+Shift+R)")





