#!/usr/bin/env python3
"""
Generate realistic crime scene images using Flux Pro via Replicate
With robust error handling and detailed logging
"""

import requests
import os
import time
import json
from pathlib import Path
from datetime import datetime

OUTPUT_DIR = Path("client/assets/images/crimes")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Professional cinema-style prompts for each crime
CRIME_PROMPTS = {
    "pickpocket": "photorealistic scene of a pickpocket stealing a wallet from someone's jacket pocket in a crowded city street market, cinematic lighting",
    "shoplift": "photorealistic scene of shoplifting in a busy supermarket, person concealing items, security cameras in background, cinematic",
    "steal_bike": "photorealistic scene of a person stealing a bicycle from a bike rack on a dark urban street at night",
    "car_theft": "photorealistic scene of a professional thief breaking into a parked vehicle on a city street",
    "burglary": "photorealistic scene of a home burglary in progress, person climbing through a window at night",
    "rob_store": "photorealistic scene of an armed store robbery, person with weapon at counter, cinematic dramatic lighting",
    "mug_person": "photorealistic scene of a street mugging in a dark urban alley at night",
    "steal_car_parts": "photorealistic scene of stealing car engine parts in a garage workshop",
    "hijack_truck": "photorealistic scene of a truck being hijacked on a highway at night on the road",
    "atm_theft": "photorealistic scene of a person breaking into an ATM on a city street at night",
    "jewelry_heist": "photorealistic scene of a jewelry store heist, breaking glass display case in luxury store",
    "vandalism": "photorealistic scene of street vandalism and graffiti destruction in an urban area",
    "graffiti": "photorealistic scene of illegal graffiti artist spray painting a large wall at night",
    "drug_deal_small": "photorealistic scene of street-level drug dealing in a dark urban alley",
    "drug_deal_large": "photorealistic scene of large drug trafficking operation in a warehouse with contraband",
    "extortion": "photorealistic scene of an extortion confrontation in a dark alley, threatening mood",
    "kidnapping": "photorealistic dark crime scene photograph, noir style dramatic lighting",
    "arson": "photorealistic scene of arson attack with building fire, flames and smoke, firefighters",
    "smuggling": "photorealistic scene of smuggling operation in warehouse with cargo containers",
    "assassination": "photorealistic dark noir crime assassination scene with dramatic shadows",
    "eliminate_witness": "photorealistic dark crime scene photograph, noir detective style lighting",
    "diamond_heist": "photorealistic scene of diamond heist in luxury jewelry facility with vaults",
    "evidence_room_heist": "photorealistic scene of police evidence room being broken into with security systems",
    "hack_account": "photorealistic scene of hacker at computer with multiple monitors in dark room",
    "counterfeit_money": "photorealistic scene of counterfeit money printing operation with press equipment",
    "identity_theft": "photorealistic scene of cybercrime operation with computers and stolen documents",
    "rob_armored_truck": "photorealistic action scene of an armored truck robbery on city street",
    "art_theft": "photorealistic scene of museum heist stealing valuable painting from gallery",
    "protection_racket": "photorealistic scene of protection racket intimidation in dark alley",
    "casino_heist": "photorealistic scene of luxurious casino heist at night with gaming equipment",
    "bank_robbery": "photorealistic scene of bank vault heist with security systems",
    "museum_heist": "photorealistic scene of museum robbery stealing artifacts from display case",
    "boss_assassination": "photorealistic dark noir assassination scene of crime boss, dramatic lighting",
    "steal_yacht": "photorealistic scene of luxury yacht theft robbery from marina at night",
    "corrupt_official": "photorealistic scene of government corruption bribery exchange in office",
}

REPLICATE_API = "https://api.replicate.com/v1/predictions"
FLUX_VERSION = "830e867f2f7f7d4911eaf11ce9da3be6af32619e10ae59b8bd5f32f108416fd13"

log_file = Path("flux_generation.log")

def log_message(msg):
    """Log to both console and file"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    full_msg = f"[{timestamp}] {msg}"
    print(full_msg)
    with open(log_file, "a", encoding='utf-8') as f:
        f.write(full_msg + "\n")

def generate_image(prompt, filename):
    """Generate single image with detailed logging"""
    try:
        api_token = os.getenv("REPLICATE_API_TOKEN")
        if not api_token:
            log_message(f" {filename}: No API token")
            return False
        
        headers = {
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "version": FLUX_VERSION,
            "input": {
                "prompt": prompt,
                "aspect_ratio": "16:9",
                "output_format": "png",
                "num_outputs": 1,
            }
        }
        
        # Create prediction
        log_message(f" {filename}: Creating prediction...")
        response = requests.post(REPLICATE_API, json=payload, headers=headers, timeout=30)
        
        if response.status_code == 429:
            log_message(f"⏳ {filename}: Rate limited (429)")
            return None
        
        if response.status_code == 422:
            log_message(f" {filename}: Invalid input (422)")
            return False
        
        if response.status_code not in [201, 200]:
            log_message(f" {filename}: API error {response.status_code}")
            return False
        
        prediction = response.json()
        prediction_id = prediction.get("id")
        
        if not prediction_id:
            log_message(f" {filename}: No prediction ID")
            return False
        
        log_message(f"   Prediction ID: {prediction_id}")
        
        # Poll for completion
        max_polls = 600  # 20 minutes with 2-second intervals
        for poll_count in range(max_polls):
            time.sleep(2)
            
            status_response = requests.get(
                f"{REPLICATE_API}/{prediction_id}",
                headers=headers,
                timeout=30
            )
            
            if status_response.status_code != 200:
                log_message(f" {filename}: Poll failed at {poll_count}")
                return False
            
            status = status_response.json()
            current_status = status.get("status")
            
            if current_status == "succeeded":
                output = status.get("output", [])
                if output and len(output) > 0:
                    image_url = output[0]
                    log_message(f"   Status: succeeded, downloading from {image_url[:50]}...")
                    
                    # Download with verification
                    img_response = requests.get(image_url, timeout=60)
                    
                    if img_response.status_code == 200:
                        content_size = len(img_response.content)
                        
                        # Verify PNG signature
                        if img_response.content[:4] == b'\x89PNG':
                            filepath = OUTPUT_DIR / filename
                            with open(filepath, 'wb') as f:
                                f.write(img_response.content)
                            
                            log_message(f" {filename}: Success! ({content_size // 1024}KB)")
                            return True
                        else:
                            log_message(f" {filename}: Not a valid PNG ({img_response.content[:4]})")
                            return False
                    else:
                        log_message(f" {filename}: Download failed ({img_response.status_code})")
                        return False
                else:
                    log_message(f" {filename}: No output in response")
                    return False
            
            elif current_status == "failed":
                error = status.get("error", "Unknown error")
                log_message(f" {filename}: Generation failed - {error}")
                return False
            
            elif current_status == "processing":
                if poll_count % 30 == 0:  # Log every 60 seconds
                    log_message(f"   Processing... ({poll_count*2}s elapsed)")
        
        log_message(f" {filename}: Timeout after 20 minutes")
        return False
        
    except Exception as e:
        log_message(f" {filename}: Exception - {str(e)}")
        return False

# Main
api_key = os.getenv("REPLICATE_API_TOKEN")
if not api_key:
    log_message("ERROR: REPLICATE_API_TOKEN not set")
    log_message("Set with: $env:REPLICATE_API_TOKEN = 'your-token'")
    exit(1)

log_message("=" * 70)
log_message("FLUX AI CRIME IMAGE GENERATION")
log_message(f"Output directory: {OUTPUT_DIR.absolute()}")
log_message(f"Total crimes: {len(CRIME_PROMPTS)}")
log_message(f"API Token: {api_key[:10]}...{api_key[-5:]}")
log_message("=" * 70)

success_count = 0
failed_crimes = []
retry_queue = []

# First pass
log_message("\n FIRST PASS: Generating images")
log_message("-" * 70)

for i, (crime_id, prompt) in enumerate(CRIME_PROMPTS.items(), 1):
    filename = f"{crime_id}_crime.png"
    filepath = OUTPUT_DIR / filename
    
    # Skip if already exists
    if filepath.exists():
        log_message(f"[{i:2d}]  {filename} - already exists")
        success_count += 1
        continue
    
    log_message(f"\n[{i:2d}] Starting generation: {filename}")
    result = generate_image(prompt, filename)
    
    if result is True:
        success_count += 1
    elif result is None:  # Rate limited
        retry_queue.append((crime_id, filename, prompt))
    else:
        failed_crimes.append(crime_id)
    
    # Very conservative rate limiting
    time.sleep(10)  # 10 seconds between requests

# Retry rate-limited
if retry_queue:
    log_message("\n" + "=" * 70)
    log_message(f"⏳ RETRY PASS: {len(retry_queue)} rate-limited images")
    log_message("Waiting 120 seconds before retry...")
    log_message("=" * 70)
    time.sleep(120)
    
    for crime_id, filename, prompt in retry_queue:
        log_message(f"\n Retrying: {filename}")
        result = generate_image(prompt, filename)
        
        if result:
            success_count += 1
        else:
            failed_crimes.append(crime_id)
        
        time.sleep(10)

# Summary
log_message("\n" + "=" * 70)
log_message("GENERATION COMPLETE")
log_message("=" * 70)
log_message(f" Successful: {success_count}/{len(CRIME_PROMPTS)}")
log_message(f" Failed: {len(failed_crimes)}")
if failed_crimes:
    log_message(f"   Failed crimes: {', '.join(failed_crimes[:10])}")
log_message(f"\n Images saved to: {OUTPUT_DIR.absolute()}")
log_message(f" Log file: {log_file.absolute()}")
log_message("\n Reload browser: Ctrl+Shift+R")
