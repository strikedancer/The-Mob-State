#!/usr/bin/env python3
"""Generate responsive smuggling assets for mobile/tablet/desktop using Leonardo."""

import requests
import time
import os
from io import BytesIO
from pathlib import Path
from PIL import Image

# Configuration
LEONARDO_API_KEY = os.getenv("LEONARDO_API_KEY", "a7132d07-0987-45df-8372-1e6c7985803a")
LEONARDO_MODEL_ID = "nano-banana-2"
API_ENDPOINT = "https://cloud.leonardo.ai/api/rest/v2/generations"
STATUS_ENDPOINT = "https://cloud.leonardo.ai/api/rest/v1/generations"

# Asset output dirs
BACKGROUNDS_DIR = Path("client/assets/images/backgrounds")
UI_DIR = Path("client/assets/images/ui")

# Image specifications
IMAGE_SPECS = [
    # Backgrounds - responsive: (filename, target_w, target_h, preferred_gen_w, preferred_gen_h, prompt)
    ("smuggling_hub_bg_mobile.png", 480, 800, 768, 1024,
     "Cinematic underground smuggling operation control room, neon harbor lights, dark atmosphere, "
     "modern tech setup, crates and containers, portrait orientation mobile gaming aesthetic"),
    
    ("smuggling_hub_bg_tablet.png", 1024, 768, 1024, 768,
     "Epic underground smuggling operation center, shipping containers, cargo docks, neon accent lighting, "
     "command center aesthetic, balanced landscape-portrait composition, tablet gaming theme"),
    
    ("smuggling_hub_bg_desktop.png", 1920, 1280, 1536, 1024,
     "Ultimate cinematic smuggling operations headquarters, sprawling harbor warehouse, shipping containers, "
     "neon purple and blue accent lighting, dark dramatic atmosphere, ultra-widescreen gaming aesthetic, "
     "intricate details, gritty industrial setting"),
    
    # Emblems - responsive
    ("smuggling_hub_emblem_mobile.png", 512, 512, 768, 768,
     "Smuggling syndicate emblem icon for mobile UI, centered metallic badge with cargo route motif, "
     "high readability at small size, dark backdrop, no text, no watermark"),

    ("smuggling_hub_emblem_tablet.png", 768, 768, 768, 768,
     "Smuggling syndicate emblem icon for tablet game UI, polished metallic insignia with crate and route lines, "
     "sharp silhouette, centered, no text, no watermark"),

    ("smuggling_hub_emblem_desktop.png", 1024, 1024, 1024, 1024,
     "Premium smuggling syndicate emblem for desktop game UI, cinematic metallic badge with cargo crate and route lines, "
     "high detail, centered composition, no text, no watermark"),

    # Crates - responsive
    ("smuggling_crate_mobile.png", 256, 256, 768, 768,
     "Compact contraband shipping crate icon, wooden with rope bindings, hazard tape strips, small-scale tile, "
     "game UI element, dark background, glowing accent"),

    ("smuggling_crate_tablet.png", 384, 384, 768, 768,
     "Contraband shipping crate icon for tablet game UI, rugged wood crate with warning tape and straps, "
     "clear silhouette, medium detail, dark atmospheric backdrop"),
    
    ("smuggling_crate_desktop.png", 512, 512, 1024, 1024,
     "High-detail contraband cargo crate, wooden construction with heavy rope bindings, hazard and warning tapes, "
     "3D perspective, premium game icon, glowing neon accent, dark atmospheric background"),
]


def extract_generation_id(data):
    """Handle multiple Leonardo response shapes."""
    if isinstance(data, list):
        data = data[0] if data else {}

    return (
        data.get("generationId")
        or data.get("sdGenerationJob", {}).get("generationId")
        or data.get("generate", {}).get("generationId")
        or data.get("data", {}).get("generationId")
    )


def extract_generated_images(status_data):
    """Handle multiple Leonardo status response shapes."""
    if isinstance(status_data, list):
        status_data = status_data[0] if status_data else {}

    generation = (
        status_data.get("generations_by_pk")
        or status_data.get("generation")
        or status_data.get("data", {}).get("generation")
        or {}
    )

    if isinstance(generation, list):
        generation = generation[0] if generation else {}

    status = generation.get("status") or status_data.get("status")
    images = (
        generation.get("generated_images")
        or generation.get("images")
        or status_data.get("generated_images")
        or status_data.get("images")
        or []
    )

    return status, images

def _request_generation_id(width, height, prompt, headers):
    payload = {
        "model": LEONARDO_MODEL_ID,
        "parameters": {
            "width": width,
            "height": height,
            "prompt": prompt,
            "quantity": 1,
            "prompt_enhance": "OFF"
        },
        "public": False
    }

    response = requests.post(API_ENDPOINT, json=payload, headers=headers, timeout=20)
    response.raise_for_status()
    gen_data = response.json()
    return extract_generation_id(gen_data), gen_data


def generate_image(filename, target_width, target_height, preferred_gen_width, preferred_gen_height, prompt):
    """Generate single image via Leonardo API"""
    print(f"\n🎨 Generating {filename} ({target_width}×{target_height})...")
    
    headers = {
        "Authorization": f"Bearer {LEONARDO_API_KEY}",
        "Content-Type": "application/json"
    }
    
    try:
        generation_candidates = [
            (preferred_gen_width, preferred_gen_height),
            (1024, 1024),
            (1024, 768),
            (768, 1024),
        ]

        seen = set()
        gen_id = None
        used_gen_size = None
        for gen_w, gen_h in generation_candidates:
            if (gen_w, gen_h) in seen:
                continue
            seen.add((gen_w, gen_h))
            candidate_id, raw = _request_generation_id(gen_w, gen_h, prompt, headers)
            if candidate_id:
                gen_id = candidate_id
                used_gen_size = (gen_w, gen_h)
                break
            print(f"   ⚠️ Generation rejected for {gen_w}x{gen_h}, trying fallback...")
            print(f"   API response: {raw}")

        if not gen_id:
            print("   ❌ Could not create generation for any fallback size")
            return False
        
        print(f"   Generation ID: {gen_id}")
        print(f"   Using generation size: {used_gen_size[0]}x{used_gen_size[1]}")
        print(f"   Polling for completion...")
        
        # Poll for completion
        max_polls = 120
        poll_interval = 2
        for poll_num in range(max_polls):
            time.sleep(poll_interval)
            
            status_response = requests.get(
                f"{STATUS_ENDPOINT}/{gen_id}",
                headers={"Authorization": f"Bearer {LEONARDO_API_KEY}"},
                timeout=10
            )
            
            if status_response.status_code != 200:
                print(f"   ⏳ Poll {poll_num + 1}: Status check failed, retrying...")
                continue
            
            status_data = status_response.json()
            task_status, images = extract_generated_images(status_data)
            
            if task_status == "COMPLETE":
                print(f"   ✅ Complete after {(poll_num + 1) * poll_interval}s")
                
                # Extract image URL
                if not images:
                    print(f"   ❌ No images in response")
                    return False
                
                image_url = images[0].get("url") or images[0].get("imageUrl")
                if not image_url:
                    print(f"   ❌ No URL in image data")
                    return False
                
                # Download image
                print(f"   Downloading from: {image_url}")
                img_response = requests.get(image_url, timeout=30)
                if img_response.status_code != 200:
                    print(f"   ❌ Download failed: {img_response.status_code}")
                    return False
                
                # Save to appropriate directory
                if "bg" in filename:
                    output_dir = BACKGROUNDS_DIR
                else:
                    output_dir = UI_DIR
                
                output_dir.mkdir(parents=True, exist_ok=True)
                output_path = output_dir / filename

                # Resize to exact responsive target so UI breakpoints get consistent assets.
                with Image.open(BytesIO(img_response.content)) as img:
                    resized = img.convert("RGB").resize((target_width, target_height), Image.Resampling.LANCZOS)
                    resized.save(output_path, format="PNG", optimize=True)
                
                file_size_kb = output_path.stat().st_size / 1024
                print(f"   ✅ SAVED: {output_path} ({file_size_kb:.1f} KB)")
                return True
            
            elif task_status == "FAILED":
                print(f"   ❌ Generation failed")
                return False
            
            else:
                print(f"   ⏳ Poll {poll_num + 1}: Status={task_status}, waiting...")
        
        print(f"   ❌ Timeout after {max_polls * poll_interval}s")
        return False
    
    except requests.exceptions.RequestException as e:
        print(f"   ❌ Request error: {e}")
        return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False

def main():
    print("=" * 60)
    print("LEONARDO RESPONSIVE IMAGE GENERATOR")
    print("=" * 60)
    
    if not LEONARDO_API_KEY:
        print("❌ ERROR: LEONARDO_API_KEY environment variable not set")
        return False
    
    print(f"\nGenerating {len(IMAGE_SPECS)} responsive image variants...")
    print(f"Backgrounds dir: {BACKGROUNDS_DIR}")
    print(f"UI dir: {UI_DIR}")
    
    successful = 0
    failed = 0
    
    for filename, target_width, target_height, gen_width, gen_height, prompt in IMAGE_SPECS:
        if generate_image(filename, target_width, target_height, gen_width, gen_height, prompt):
            successful += 1
        else:
            failed += 1
    
    print("\n" + "=" * 60)
    print(f"RESULTS: {successful} successful, {failed} failed")
    print("=" * 60)
    
    return failed == 0

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
