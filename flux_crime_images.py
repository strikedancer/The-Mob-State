#!/usr/bin/env python3
"""
Generate realistic crime scene images using Flux via Replicate
Simplified approach with better error handling
"""

import requests
import os
import time
import json
from pathlib import Path
from datetime import datetime

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Simplified, safer prompts that Flux will accept
CRIME_PROMPTS = {
    "pickpocket": "A person stealing a wallet in a crowded marketplace, photorealistic, professional photography",
    "shoplift": "A person grabbing products in a supermarket, photorealistic cinema style",
    "steal_bike": "A thief stealing a bicycle from the street at night, urban crime scene",
    "car_theft": "Breaking into a car on a dark city street, cinematic crime scene",
    "burglary": "A person breaking into a window on a house at night, professional photography",
    "rob_store": "A person threatening store clerk at counter with weapon, intense dramatic lighting",
    "mug_person": "A mugging in progress on a dark city alley, street crime scene",
    "steal_car_parts": "Stealing engine parts from a car in garage, mechanic workshop criminal scene",
    "hijack_truck": "A truck robbery scene on a highway at night, action crime photography",
    "atm_theft": "Breaking into ATM machine on city street at night, professional crime scene",
    "jewelry_heist": "Smashing jewelry store display case, heist action scene",
    "vandalism": "Spray painting and destroying property on urban wall, graffiti damage",
    "graffiti": "Illegal graffiti artist spray painting a wall at night, street art crime",
    "drug_deal_small": "Street level drug dealing in dark alley, urban crime scene",
    "drug_deal_large": "Large drug trafficking operation in warehouse, criminal enterprise",
    "extortion": "Criminal confrontation in dark alley, threatening intimidation scene",
    "kidnapping": "Person being forcibly taken, crime scene photography style",
    "arson": "Building on fire from arson attack, flames and destruction",
    "smuggling": "Smuggling operation in warehouse with cargo boxes, criminal activity",
    "assassination": "Dark noir scene with dramatic shadows, crime scene photography",
    "eliminate_witness": "Dark noir photography style, dramatic crime scene lighting",
    "diamond_heist": "Diamond heist in luxury jewelry vault, heist action scene",
    "evidence_room_heist": "Breaking into police evidence room, heist action scene",
    "hack_account": "Hacker at computer with multiple monitors in dark room, cybercrime",
    "counterfeit_money": "Money printing operation with printing press, criminal enterprise",
    "identity_theft": "Cybercrime operation with computer and stolen documents, crime scene",
    "rob_armored_truck": "Armored truck robbery action scene on city street, heist",
    "art_theft": "Stealing valuable painting from museum gallery, heist action",
    "protection_racket": "Criminal intimidation in dark alley, protection racket scene",
    "casino_heist": "Luxurious casino robbery at night, heist action scene",
    "bank_robbery": "Bank vault heist with security systems, action crime scene",
    "museum_heist": "Museum robbery stealing artifacts, heist action scene",
    "boss_assassination": "Dark noir assassination scene of crime boss, dramatic lighting",
    "steal_yacht": "Luxury yacht theft robbery from marina at night, heist action",
    "corrupt_official": "Government corruption bribery exchange in office, crime scene",
}

# Replicate API config - Latest Flux Pro version
REPLICATE_API = "https://api.replicate.com/v1/predictions"
FLUX_PRO_VERSION = "d83b5fef5f1f50d65e3a13fd0dd0297f49f3cedf0e6b34d40dc4dd4b108ad375"

log_file = Path("flux_generation.log")

def log_message(msg):
    """Log to both console and file"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    full_msg = f"[{timestamp}] {msg}"
    print(full_msg)
    with open(log_file, "a", encoding='utf-8') as f:
        f.write(full_msg + "\n")

def generate_image(prompt, filename, attempt=1):
    """Generate single image with detailed logging"""
    try:
        api_token = os.getenv("REPLICATE_API_TOKEN")
        if not api_token:
            log_message(f"[SKIP] {filename}: No API token provided")
            return False
        
        headers = {
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        }
        
        # Simpler payload with version
        payload = {
            "version": FLUX_PRO_VERSION,
            "input": {
                "prompt": prompt,
                "aspect_ratio": "16:9",
                "output_format": "png",
            }
        }
        
        log_message(f"[{attempt:2d}] {filename}: Sending to Flux Pro...")
        response = requests.post(f"{REPLICATE_API}", json=payload, headers=headers, timeout=30)
        
        if response.status_code == 429:
            log_message(f"[RATE] {filename}: Rate limited (429)")
            return None
        
        if response.status_code == 422:
            try:
                error_detail = response.json().get('detail', 'Unknown')
                log_message(f"[ERR] {filename}: Invalid input - {error_detail}")
            except:
                log_message(f"[ERR] {filename}: Invalid input (422)")
            return False
        
        if response.status_code not in [201, 200]:
            log_message(f"[ERR] {filename}: API error {response.status_code} - {response.text[:100]}")
            return False
        
        prediction = response.json()
        prediction_id = prediction.get("id")
        
        if not prediction_id:
            log_message(f"[ERR] {filename}: No prediction ID in response")
            return False
        
        log_message(f"      Prediction: {prediction_id}")
        
        # Poll for completion
        poll_count = 0
        max_polls = 600  # 20 minutes with 2-second intervals
        
        while poll_count < max_polls:
            time.sleep(2)
            poll_count += 1
            
            try:
                status_response = requests.get(
                    f"{REPLICATE_API}/{prediction_id}",
                    headers=headers,
                    timeout=30
                )
                
                if status_response.status_code != 200:
                    log_message(f"[ERR] {filename}: Status check failed {status_response.status_code}")
                    return False
                
                status = status_response.json()
                current_status = status.get("status")
                
                if current_status == "succeeded":
                    output = status.get("output", [])
                    if output and len(output) > 0:
                        image_url = output[0]
                        log_message(f"      Downloading image...")
                        
                        # Download with verification
                        img_response = requests.get(image_url, timeout=60)
                        
                        if img_response.status_code == 200:
                            content_size = len(img_response.content)
                            
                            # Verify PNG signature
                            if img_response.content[:4] == b'\x89PNG':
                                filepath = OUTPUT_DIR / filename
                                with open(filepath, 'wb') as f:
                                    f.write(img_response.content)
                                
                                log_message(f"[OK] {filename}: Success! ({content_size // 1024}KB)")
                                return True
                            else:
                                log_message(f"[ERR] {filename}: Invalid PNG header")
                                return False
                        else:
                            log_message(f"[ERR] {filename}: Download failed {img_response.status_code}")
                            return False
                    else:
                        log_message(f"[ERR] {filename}: No output in response")
                        return False
                
                elif current_status == "failed":
                    error = status.get("error", "Unknown error")
                    log_message(f"[ERR] {filename}: Generation failed - {error}")
                    return False
                
                elif current_status == "processing":
                    if poll_count % 30 == 0:
                        log_message(f"      Still processing... ({poll_count*2}s / 1200s)")
            
            except requests.exceptions.Timeout:
                log_message(f"[ERR] {filename}: Request timeout during polling")
                return False
            except Exception as e:
                log_message(f"[ERR] {filename}: Polling exception - {str(e)}")
                return False
        
        log_message(f"[ERR] {filename}: Timeout after 20 minutes")
        return False
        
    except Exception as e:
        log_message(f"[ERR] {filename}: Exception - {str(e)}")
        return False

# Main execution
def main():
    api_key = os.getenv("REPLICATE_API_TOKEN")
    if not api_key:
        log_message("ERROR: REPLICATE_API_TOKEN not set")
        log_message("Set with: $env:REPLICATE_API_TOKEN = 'your-token'")
        exit(1)
    
    log_message("=" * 80)
    log_message("FLUX PRO CRIME IMAGE GENERATION")
    log_message("=" * 80)
    log_message(f"Output: {OUTPUT_DIR.absolute()}")
    log_message(f"Model: Flux Pro")
    log_message(f"Crimes: {len(CRIME_PROMPTS)}")
    log_message(f"API Token: {api_key[:8]}...{api_key[-5:]}")
    log_message("=" * 80)
    
    success_count = 0
    failed_crimes = []
    rate_limited = []
    
    # Generate all images
    for i, (crime_id, prompt) in enumerate(CRIME_PROMPTS.items(), 1):
        filename = f"{crime_id}_crime.png"
        filepath = OUTPUT_DIR / filename
        
        # Skip if already exists
        if filepath.exists():
            log_message(f"[{i:2d}] SKIP: {filename} already exists")
            success_count += 1
            continue
        
        log_message(f"\n[{i:2d}] {filename}")
        result = generate_image(prompt, filename)
        
        if result is True:
            success_count += 1
        elif result is None:
            rate_limited.append(crime_id)
        else:
            failed_crimes.append(crime_id)
        
        # Rate limiting between requests
        time.sleep(5)
    
    # Retry rate-limited if any
    if rate_limited:
        log_message("\n" + "=" * 80)
        log_message(f"RETRYING {len(rate_limited)} RATE-LIMITED IMAGES AFTER 60s")
        log_message("=" * 80)
        time.sleep(60)
        
        for crime_id in rate_limited:
            filename = f"{crime_id}_crime.png"
            filepath = OUTPUT_DIR / filename
            
            if filepath.exists():
                log_message(f"SKIP: {filename} already exists")
                success_count += 1
                continue
            
            log_message(f"\nRETRY: {filename}")
            prompt = CRIME_PROMPTS[crime_id]
            result = generate_image(prompt, filename, attempt=2)
            
            if result:
                success_count += 1
            else:
                failed_crimes.append(crime_id)
            
            time.sleep(5)
    
    # Summary
    log_message("\n" + "=" * 80)
    log_message("GENERATION COMPLETE")
    log_message("=" * 80)
    log_message(f"Success: {success_count}/{len(CRIME_PROMPTS)}")
    log_message(f"Failed: {len(failed_crimes)}")
    
    if failed_crimes:
        log_message(f"Failed crimes: {', '.join(failed_crimes)}")
    
    log_message(f"\nImages: {OUTPUT_DIR.absolute()}")
    log_message(f"Log: {log_file.absolute()}")
    log_message("\nDone! Hard refresh browser: Ctrl+Shift+R")

if __name__ == "__main__":
    main()
