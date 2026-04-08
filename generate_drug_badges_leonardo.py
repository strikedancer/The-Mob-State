#!/usr/bin/env python3
"""
Leonardo.ai Batch Generation Script for Drug Achievement Badges
Model: Nano Banana 2
Generates 35 PNG badges with true RGBA transparency
"""

import os
import re
import time
import requests
import json
from pathlib import Path

# Configuration
LEONARDO_API_KEY = os.getenv("LEONARDO_API_KEY", "a7132d07-0987-45df-8372-1e6c7985803a")
LEONARDO_API_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
LEONARDO_GET_URL = "https://cloud.leonardo.ai/api/rest/v1/generations"
MODEL_ID = "7b592283-e8a7-4c5a-9ba6-d18c31f258b9"  # FLUX.1 model (universal)
OUTPUT_DIR = Path(__file__).parent / "client" / "assets" / "images" / "achievements" / "badges" / "drugs"
PROMPTS_FILE = Path(__file__).parent / "DRUG_BADGES_LEONARDO_PROMPTS.md"

# Ensure output directory exists
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

def parse_prompts_from_markdown(file_path):
    """Parse all badge prompts from markdown file."""
    badges = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all badge sections - more flexible regex pattern
    pattern = r'### [\d]+\. (.+?)\n\*\*File:\*\* (.+?\.png)\n\n\*\*Prompt:\*\*\n(.+?)\n\n(?:CRITICAL:|Negative:)'
    matches = re.finditer(pattern, content, re.DOTALL)
    
    for match in matches:
        badge_name = match.group(1)
        filename = match.group(2)
        prompt = match.group(3).strip()
        
        # Extract clean prompt text
        prompt_lines = [line.strip() for line in prompt.split('\n') if line.strip()]
        prompt_text = ' '.join(prompt_lines)
        
        badges.append({
            'name': badge_name,
            'filename': filename,
            'prompt': prompt_text
        })
    
    return badges

def generate_image_leonardo(prompt, filename):
    """Generate image using Leonardo.ai API."""
    try:
        headers = {
            "Authorization": f"Bearer {LEONARDO_API_KEY}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "prompt": prompt,
            "modelId": MODEL_ID,
            "width": 256,
            "height": 256,
            "num_images": 1,
            "alchemy": False,
            "photoReal": False
        }
        
        print(f"⏳ Generating {filename}...", end=" ", flush=True)
        
        response = requests.post(LEONARDO_API_URL, json=payload, headers=headers, timeout=60)
        response.raise_for_status()
        
        data = response.json()
        print(f"\n  DEBUG Response: {data}")
        
        if "generationId" not in data:
            print(f"  Response keys: {data.keys()}")
            print(f"❌ Failed: No generation ID in response")
            return False
        
        generation_id = data["generationId"]
        print(f"Generated ID: {generation_id}")
        
        # Poll for completion (max 5 minutes)
        max_polls = 60
        poll_count = 0
        
        while poll_count < max_polls:
            time.sleep(2)  # Wait 2 seconds before polling
            
            poll_headers = {
                "Authorization": f"Bearer {LEONARDO_API_KEY}"
            }
            
            poll_response = requests.get(
                f"https://cloud.leonardo.ai/api/rest/v1/generations/{generation_id}",
                headers=poll_headers,
                timeout=30
            )
            poll_response.raise_for_status()
            
            poll_data = poll_response.json()
            status = poll_data.get("status", "UNKNOWN")
            
            if status == "COMPLETE":
                assets = poll_data.get("assets", [])
                if assets and len(assets) > 0:
                    image_url = assets[0].get("url")
                    if image_url:
                        # Download image
                        img_response = requests.get(image_url, timeout=30)
                        img_response.raise_for_status()
                        
                        output_path = OUTPUT_DIR / filename
                        with open(output_path, 'wb') as f:
                            f.write(img_response.content)
                        
                        print(f"✅ Saved to {output_path}")
                        return True
                else:
                    print(f"❌ No assets in response")
                    return False
            elif status == "FAILED":
                print(f"❌ Generation failed")
                return False
            
            poll_count += 1
            if poll_count % 10 == 0:
                print(f"  ⏳ Still processing... ({poll_count * 2}s)")
        
        print(f"❌ Timeout after {max_polls * 2} seconds")
        return False
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Network error: {e}")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    """Main batch generation function."""
    
    if LEONARDO_API_KEY == "YOUR_API_KEY_HERE":
        print("❌ ERROR: LEONARDO_API_KEY environment variable not set!")
        print("   Set it with: export LEONARDO_API_KEY='your_key_here'")
        return
    
    print(f"🎨 Leonardo.ai Badge Generator - Nano Banana 2 Model")
    print(f"📁 Output directory: {OUTPUT_DIR}")
    print(f"📄 Reading prompts from: {PROMPTS_FILE}\n")
    
    # Parse prompts
    badges = parse_prompts_from_markdown(PROMPTS_FILE)
    print(f"📋 Found {len(badges)} badges to generate\n")
    
    if not badges:
        print("❌ No badges found in prompts file")
        return
    
    # Generate each badge
    success_count = 0
    failed_badges = []
    
    for i, badge in enumerate(badges, 1):
        print(f"[{i}/{len(badges)}] {badge['name']}")
        
        if generate_image_leonardo(badge['prompt'], badge['filename']):
            success_count += 1
        else:
            failed_badges.append(badge['filename'])
        
        # Rate limiting (Leonardo recommends delay between requests)
        if i < len(badges):
            time.sleep(1)
    
    # Summary
    print(f"\n" + "="*60)
    print(f"✅ Summary:")
    print(f"   ✓ Generated: {success_count}/{len(badges)}")
    
    if failed_badges:
        print(f"   ✗ Failed: {len(failed_badges)}")
        for badge in failed_badges:
            print(f"     - {badge}")
    else:
        print(f"   ✓ All badges generated successfully!")
    
    print(f"="*60)

if __name__ == "__main__":
    main()
