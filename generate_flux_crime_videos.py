#!/usr/bin/env python3
import json
import os
import sys
import time
import requests

OUTPUT_DIR = 'client/assets/videos/crimes'
API_TOKEN = os.environ.get('REPLICATE_API_TOKEN', '')
# Using Stable Video Diffusion for video generation (more reliable than Flux video)
FLUX_VERSION = "stability-ai/stable-video-diffusion"

os.makedirs(OUTPUT_DIR, exist_ok=True)

CRIME_VIDEOS = {
    "pickpocket": {
        "name": "Zakkenrollen",
        "prompt": "stylized cinematic video for dark mafia game, skilled pickpocket smoothly stealing wallet from unsuspecting person at busy train station, quick hands, smooth motion, dramatic lighting, film noir aesthetic, high quality, no watermark, no text",
        "duration": 10,
    },
}

def generate_video(crime_id: str, crime_data: dict):
    """Generate a crime video using Flux"""
    
    output_file = f"{OUTPUT_DIR}/{crime_id}_crime.mp4"
    
    if os.path.exists(output_file):
        print(f"✅ Already exists: {crime_data['name']} ({output_file})")
        return True
    
    print(f"\n📹 Generating video: {crime_data['name']}...")
    
    try:
        headers = {
            "Authorization": f"Token {API_TOKEN}",
            "Content-Type": "application/json"
        }
        
        # Try using the model path format with Replicate API
        payload = {
            "model": FLUX_VERSION,  # Changed from "version" to "model" for model path
            "input": {
                "prompt": crime_data['prompt'],
                "duration": crime_data['duration'],  # 10 seconds
                "output_format": "mp4",
            }
        }
        
        print(f"  📤 Submitting prediction...")
        # Use the model path directly in the URL
        response = requests.post(
            f"https://api.replicate.com/v1/predictions",
            json=payload,
            headers=headers,
            timeout=30
        )
        
        if response.status_code != 201:
            print(f"  ❌ Failed: {response.status_code}")
            print(f"     Response: {response.text}")
            return False
        
        prediction_resp = response.json()
        prediction_id = prediction_resp.get('id')
        
        if not prediction_id:
            print(f"  ❌ No prediction ID returned")
            return False
        
        print(f"  ⏳ Waiting for prediction {prediction_id[:8]}...")
        
        # Poll for completion
        max_polls = 600  # 20 minutes for video generation
        poll_count = 0
        
        while poll_count < max_polls:
            poll_count += 1
            time.sleep(2)
            
            check_resp = requests.get(
                f"https://api.replicate.com/v1/predictions/{prediction_id}",
                headers=headers,
                timeout=30
            )
            
            if check_resp.status_code != 200:
                print(f"  ❌ Poll failed: {check_resp.status_code}")
                return False
            
            check_data = check_resp.json()
            status = check_data.get('status')
            
            if status == 'succeeded':
                output = check_data.get('output')
                
                if isinstance(output, list) and len(output) > 0:
                    video_url = output[0]
                elif isinstance(output, str):
                    video_url = output
                else:
                    video_url = None
                
                if video_url and video_url.startswith('http'):
                    print(f"  📥 Downloading video...")
                    try:
                        import urllib.request
                        urllib.request.urlretrieve(video_url, output_file)
                        print(f"  ✅ SUCCESS: {output_file}")
                        print(f"     Size: {os.path.getsize(output_file) / 1024 / 1024:.1f} MB")
                        return True
                    except Exception as e:
                        print(f"  ❌ Download failed: {e}")
                        return False
                else:
                    print(f"  ❌ Invalid video URL")
                    return False
                    
            elif status == 'failed':
                error = check_data.get('error')
                print(f"  ❌ Prediction failed: {error}")
                return False
            else:
                if poll_count % 30 == 0:
                    print(f"    ⏳ Still {status}... ({poll_count*2}s)")
        
        print(f"  ❌ Timeout waiting for video generation")
        return False
        
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return False

def main():
    if not API_TOKEN:
        print("❌ ERROR: REPLICATE_API_TOKEN not set")
        sys.exit(1)
    
    print("🎬 Flux Crime Video Generator")
    print("=" * 60)
    
    successful = 0
    failed = 0
    
    for crime_id, crime_data in CRIME_VIDEOS.items():
        if generate_video(crime_id, crime_data):
            successful += 1
        else:
            failed += 1
        
        # Wait between videos to avoid rate limiting
        if crime_id != list(CRIME_VIDEOS.keys())[-1]:
            print("  💤 Waiting 30s before next video...")
            time.sleep(30)
    
    print("\n" + "=" * 60)
    print(f"✅ Generation complete!")
    print(f"   Successful: {successful}/{len(CRIME_VIDEOS)}")
    print(f"   Failed: {failed}/{len(CRIME_VIDEOS)}")
    
    if os.path.exists(OUTPUT_DIR):
        count = len([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.mp4')])
        print(f"   MP4 files in {OUTPUT_DIR}: {count}")

if __name__ == "__main__":
    main()
