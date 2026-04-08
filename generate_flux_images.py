#!/usr/bin/env python3
"""
Generate realistic crime scene images using Flux AI via Replicate REST API
"""

import requests
import os
import time
from pathlib import Path
from typing import Any, Optional

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Mafia game style prompt system: consistent look + crime-specific scene cues
BASE_STYLE = (
    "stylized cinematic key art for a dark mafia strategy game, semi realistic digital painting, "
    "gritty european city mood, dramatic neon and shadow lighting, high detail environment, "
    "clear focal subject, no text, no logo, no watermark, no blood, no gore"
)

SCENE_PROMPTS = {
    "pickpocket": "busy night market crowd, suspicious hand close to open handbag, tense stealth moment",
    "shoplift": "modern supermarket aisle, nervous figure hiding expensive items under jacket",
    "steal_bike": "rainy alley at night, masked figure cutting bike lock near streetlamp",
    "car_theft": "underground parking garage, sleek car door forced open with lock tools",
    "burglary": "suburban house at midnight, shadow entering through open window",
    "rob_store": "corner store interior after dark, masked crew controlling checkout area",
    "mug_person": "empty side street, intimidating confrontation under flickering neon sign",
    "steal_car_parts": "mechanic garage, expensive wheels and parts removed from sports car",
    "hijack_truck": "deserted highway checkpoint at night, cargo truck surrounded by black vans",
    "atm_theft": "city ATM kiosk, sparks from cutting tool on machine panel",
    "jewelry_heist": "luxury jewelry boutique, smashed display case with scattered gems",
    "vandalism": "city underpass wall covered with fresh destruction and broken signs",
    "graffiti": "rooftop wall with vivid spray tags, artist silhouette with paint can",
    "drug_deal_small": "narrow alley corner, secret exchange between two figures under streetlight",
    "drug_deal_large": "warehouse interior, large table with packages and guarded perimeter",
    "extortion": "back alley restaurant entrance, threatening collection scene with envelope handoff",
    "kidnapping": "dark parking lot, van with open sliding door and tense struggle silhouette",
    "arson": "abandoned building engulfed in flames, smoke columns lighting the street",
    "smuggling": "shipping dock at night, containers opened with hidden crates being moved",
    "assassination": "luxury hotel corridor, lone figure with silenced weapon in dramatic shadow",
    "eliminate_witness": "rainy rooftop chase scene, witness cornered at ledge with city skyline",
    "diamond_heist": "high security vault room, laser beams crossing over diamond pedestal",
    "evidence_room_heist": "police evidence archive, shelves ransacked and missing sealed boxes",
    "hack_account": "dark hacker den, multiple monitors with bank access screens and code",
    "counterfeit_money": "hidden print shop, stacks of fresh banknotes near heavy press machine",
    "identity_theft": "cyber workspace, passports and ID cards beside laptop data breach dashboard",
    "rob_armored_truck": "downtown intersection ambush, armored truck blocked by stolen vehicles",
    "art_theft": "museum gallery at night, framed painting removed leaving empty spotlight frame",
    "protection_racket": "small shop owner paying cash to gang enforcer in doorway",
    "casino_heist": "grand casino floor blackout, crew opening cash cage in emergency lights",
    "bank_robbery": "bank hall with vault gate open, masked group collecting cash bags",
    "museum_heist": "historic museum wing, artifact pedestal empty with alarm lights flashing",
    "boss_assassination": "private penthouse office, mafia boss silhouette targeted through doorway",
    "steal_yacht": "luxury marina at midnight, black speedboat approaching guarded mega yacht",
    "corrupt_official": "city hall office, secret cash briefcase exchange over official documents",
}

CRIME_PROMPTS = {
    crime_id: f"{BASE_STYLE}, {scene}, wide cinematic composition, 16:9"
    for crime_id, scene in SCENE_PROMPTS.items()
}

REPLICATE_API = "https://api.replicate.com/v1/predictions"
FLUX_VERSION = "609793a667ed94b210242837d3c3c9fc9a64ae93685f15d75002ba0ed9a97f2b"  # Flux 1.1 Pro


def extract_image_url(output: Any) -> Optional[str]:
    if isinstance(output, str):
        return output
    if isinstance(output, list) and output:
        first = output[0]
        if isinstance(first, str):
            return first
        if isinstance(first, dict):
            return first.get("url") or first.get("href")
    if isinstance(output, dict):
        return output.get("url") or output.get("href")
    return None

def generate_with_flux(prompt, filename):
    """Generate image using Flux via Replicate REST API"""
    try:
        print(f"[ART] {filename}...", end=" ", flush=True)
        
        api_token = os.getenv("REPLICATE_API_TOKEN")
        if not api_token:
            print(f"[ERROR] No token")
            return False
        
        headers = {
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "version": FLUX_VERSION,
            "input": {
                "prompt": prompt,
                "prompt_upsampling": True,
                "output_format": "png",
            }
        }
        
        # Create prediction
        response = requests.post(REPLICATE_API, json=payload, headers=headers, timeout=30)
        
        if response.status_code == 429:  # Rate limited
            print(f"[WAIT] Rate limit")
            return None
        
        if response.status_code == 422:  # Invalid input
            try:
                error_detail = response.json()
                print(f"[ERROR] Invalid - {error_detail.get('detail', 'Unknown')}")
            except:
                print(f"[ERROR] Invalid - {response.text[:100]}")
            return False
        
        if response.status_code not in [201, 200]:
            print(f"[ERROR] API{response.status_code} - {response.text[:120]}")
            return False
        
        prediction = response.json()
        prediction_id = prediction.get("id")
        
        if not prediction_id:
            print(f"[ERROR] No ID")
            return False
        
        # Poll for completion (max 10 minutes)
        for attempt in range(300):
            time.sleep(2)
            
            status_response = requests.get(
                f"{REPLICATE_API}/{prediction_id}",
                headers=headers,
                timeout=30
            )
            
            if status_response.status_code == 429:
                time.sleep(5)
                continue

            if status_response.status_code != 200:
                print(f"[ERROR] Poll {status_response.status_code}")
                return False
            
            status = status_response.json()
            
            if status.get("status") == "succeeded":
                output = status.get("output")
                image_url = extract_image_url(output)
                if image_url:
                    
                    # Download with verification
                    try:
                        img_response = requests.get(image_url, headers=headers, timeout=120, allow_redirects=True)
                        
                        if img_response.status_code == 200 and len(img_response.content) > 10000:
                            # Verify it's a real image (PNG files start with 89 50 4E 47)
                            if img_response.content[:4] == b'\x89PNG':
                                filepath = OUTPUT_DIR / filename
                                with open(filepath, 'wb') as f:
                                    f.write(img_response.content)
                                print(f"[OK] ({len(img_response.content)//1024}KB)")
                                return True
                            else:
                                print(f"[ERROR] Invalid PNG header ({img_response.headers.get('content-type', 'unknown')})")
                                return False
                        else:
                            print(f"[ERROR] Small/empty content ({img_response.status_code}, {len(img_response.content)} bytes)")
                            return False
                    except Exception as e:
                        print(f"[ERROR] Download error - {str(e)[:80]}")
                        return False
                else:
                    print(f"[ERROR] No output URL")
                    return False
            
            elif status.get("status") == "failed":
                error = status.get("error", "Failed")
                print(f"[ERROR] Failed - {str(error)[:120]}")
                return False
        
        print(f"[ERROR] Timeout")
        return False
        
    except Exception as e:
        print(f"[ERROR] {str(e)[:25]}")
        return False

# Check for API key
api_key = os.getenv("REPLICATE_API_TOKEN")
if not api_key:
    print("[ERROR] REPLICATE_API_TOKEN not set")
    print("\nSetup Instructions:")
    print("1. Get free API key: https://replicate.com/account/api-tokens")
    print("2. Set in PowerShell:")
    print('   $env:REPLICATE_API_TOKEN = "your-token-here"')
    print("3. Run script again")
    print("\nFlux generates high-quality, realistic images")
    exit(1)

print("[INFO] Flux AI Image Generation (Replicate)")
print(f"[INFO] Output: {OUTPUT_DIR.absolute()}")
print(f"[INFO] Total: {len(CRIME_PROMPTS)} images")
print("=" * 60)

success_count = 0
failed_crimes = []
retry_queue = []

# First pass - generate images
for crime_id, prompt in CRIME_PROMPTS.items():
    filename = f"{crime_id}_crime.png"
    
    # Skip if already exists
    if (OUTPUT_DIR / filename).exists():
        print(f"[OK] {filename}")
        success_count += 1
        continue
    
    result = generate_with_flux(prompt, filename)
    
    if result is True:
        success_count += 1
    elif result is None:  # Rate limited
        retry_queue.append((crime_id, filename, prompt))
    else:
        failed_crimes.append(crime_id)
    
    # Conservative rate limiting to avoid 429
    time.sleep(10)

# Retry rate-limited items after wait
if retry_queue:
    print(f"\n[WAIT] Retrying {len(retry_queue)} rate-limited images after 60s...")
    time.sleep(60)
    
    for crime_id, filename, prompt in retry_queue:
        print(f"[RETRY] {filename}...", end=" ", flush=True)
        result = generate_with_flux(prompt, filename)
        
        if result:
            success_count += 1
        else:
            failed_crimes.append(crime_id)
        
        time.sleep(10)

print("\n" + "=" * 60)
print(f"[SUCCESS] Generated: {success_count}/{len(CRIME_PROMPTS)}")
print(f"[INFO] Location: {OUTPUT_DIR.absolute()}")

if failed_crimes:
    print(f"\n[WARNING] Failed: {len(failed_crimes)} images")
else:
    print(f"\n[SUCCESS] All images generated successfully!")

print("\n[INFO] Reload browser: Ctrl+Shift+R")
