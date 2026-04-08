#!/usr/bin/env python3
"""
Leonardo.ai Batch Generation Script - Simplified Version
"""

import re
import time
import requests
import json
from pathlib import Path
from io import BytesIO

from PIL import Image

try:
    from rembg import remove
    REMBG_AVAILABLE = True
except Exception:
    REMBG_AVAILABLE = False

LEONARDO_API_KEY = "a7132d07-0987-45df-8372-1e6c7985803a"
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v2/generations"
OUTPUT_DIR = Path(__file__).parent / "client" / "assets" / "images" / "achievements" / "badges" / "drugs"
PROMPTS_FILE = Path(__file__).parent / "DRUG_BADGES_LEONARDO_PROMPTS.md"
MODEL_NAME = "nano-banana-2"
FORCE_REGENERATE = True

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

def parse_prompts(file_path):
    """Parse prompts from markdown."""
    badges = []
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    pattern = r'### [\d]+\. (.+?)\n\*\*File:\*\* (.+?\.png)\n\n\*\*Prompt:\*\*\n(.+?)\n\n(?:CRITICAL:|Negative:)'
    matches = re.finditer(pattern, content, re.DOTALL)
    
    for match in matches:
        badge_name = match.group(1)
        filename = match.group(2)
        prompt = match.group(3).strip()
        
        prompt_lines = [line.strip() for line in prompt.split('\n') if line.strip()]
        prompt_text = ' '.join(prompt_lines)
        
        badges.append({'name': badge_name, 'filename': filename, 'prompt': prompt_text})
    
    return badges

def generate_image(prompt, filename):
    """Call Leonardo API to generate image."""
    try:
        output_path = OUTPUT_DIR / filename
        if output_path.exists() and not FORCE_REGENERATE:
            print(f"[*] Skipping {filename} (already exists)")
            return True
        if output_path.exists() and FORCE_REGENERATE:
            output_path.unlink()
            print(f"[*] Replacing existing {filename}")

        headers = {
            "authorization": f"Bearer {LEONARDO_API_KEY}",
            "content-type": "application/json",
            "accept": "application/json"
        }
        
        payload = {
            "model": MODEL_NAME,
            "parameters": {
                "width": 1024,
                "height": 1024,
                "prompt": prompt,
                "quantity": 1,
                "prompt_enhance": "OFF"
            },
            "public": False
        }
        
        print(f"[*] Generating {filename}...", end=" ", flush=True)
        
        response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
        response.raise_for_status()
        
        data = response.json()
        print(f"Response: {json.dumps(data)[:200]}")
        
        if "generate" not in data and "generationId" not in data:
            print(f"    ERROR: Response missing generation info: {data.keys()}")
            return False
        
        gen_id = data.get("generationId") or data.get("generate", {}).get("generationId")
        if not gen_id:
            print(f"    ERROR: Could not extract generation ID")
            return False
        
        print(f"    Generation ID: {gen_id}")
        
        # Poll for completion using v1 details endpoint
        for poll_attempt in range(240):  # max 20 minutes
            time.sleep(5)
            
            poll_headers = {"authorization": f"Bearer {LEONARDO_API_KEY}"}
            poll_response = requests.get(
                f"https://cloud.leonardo.ai/api/rest/v1/generations/{gen_id}",
                headers=poll_headers,
                timeout=30
            )
            poll_response.raise_for_status()
            
            poll_data = poll_response.json()
            generation = poll_data.get("generations_by_pk", {})
            status = generation.get("status")
            images = generation.get("generated_images", [])
            
            if status == "COMPLETE":
                if not images:
                    print("    [FAIL] COMPLETE without generated images")
                    return False

                image_url = images[0].get("url")
                if not image_url:
                    print("    [FAIL] Missing image URL")
                    return False

                img_resp = requests.get(image_url, timeout=60)
                img_resp.raise_for_status()

                if REMBG_AVAILABLE:
                    rgba_bytes = remove(img_resp.content)
                    image = Image.open(BytesIO(rgba_bytes)).convert("RGBA")
                    image.save(output_path, format="PNG")
                    print(f"    [OK] Saved transparent PNG to {filename}")
                else:
                    image = Image.open(BytesIO(img_resp.content)).convert("RGBA")
                    image.save(output_path, format="PNG")
                    print(f"    [WARN] rembg not available, saved PNG without forced bg removal: {filename}")

                return True
            elif status == "FAILED":
                print(f"    [FAIL] Generation failed")
                return False
            
            if poll_attempt % 6 == 0:
                print(f"    [*] Polling... ({poll_attempt * 5}s) status={status}")
        
        print(f"    [TIMEOUT] After 1200 seconds")
        return False
        
    except Exception as e:
        print(f"    [ERROR] {e}")
        return False

def main():
    print("\n== Leonardo.ai Badge Generator")
    print(f"Output: {OUTPUT_DIR}")
    print(f"Prompts: {PROMPTS_FILE}\n")
    print(f"Model: {MODEL_NAME}")
    print(f"Rembg enabled: {REMBG_AVAILABLE}\n")
    
    badges = parse_prompts(PROMPTS_FILE)
    print(f"Found {len(badges)} badges\n")
    
    success = 0
    failed = []
    
    for i, badge in enumerate(badges, 1):
        print(f"[{i}/{len(badges)}] {badge['name']}")
        
        if generate_image(badge['prompt'], badge['filename']):
            success += 1
        else:
            failed.append(badge['filename'])
        
        if i < len(badges):
            time.sleep(1)
    
    print(f"\n== Summary:")
    print(f"Success: {success}/{len(badges)}")
    if failed:
        print(f"Failed: {len(failed)}")
        for f in failed[:5]:
            print(f"  - {f}")

if __name__ == "__main__":
    main()
