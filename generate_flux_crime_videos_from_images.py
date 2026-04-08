#!/usr/bin/env python3
"""
Generate crime videos using Minimax Video (text-to-video)
This generates actual action videos in cinematic style
"""
import os
import sys
import time
import requests

CRIMES_OUTPUT_DIR = 'client/assets/videos/crimes'
GARAGE_OUTPUT_DIR = 'client/assets/videos/garage'
MARINA_OUTPUT_DIR = 'client/assets/videos/marina'
API_TOKEN = os.environ.get('REPLICATE_API_TOKEN', '')

os.makedirs(CRIMES_OUTPUT_DIR, exist_ok=True)
os.makedirs(GARAGE_OUTPUT_DIR, exist_ok=True)
os.makedirs(MARINA_OUTPUT_DIR, exist_ok=True)

# Crime videos to generate with their prompts
CRIME_VIDEOS = {
    "pickpocket": {
        "name": "Zakkenrollen",
        "prompt": "Cinematic video of a skilled pickpocket smoothly stealing a wallet from an unsuspecting person at a busy train station, quick hands in motion, smooth pickpocketing action, dramatic noir lighting, stylized dark mafia game aesthetic, film noir style, professional thief, 4-5 seconds, high quality",
    },
    "shoplift": {
        "name": "Winkeldiefstal",
        "prompt": "Cinematic POV video: thief's hands quickly grabbing expensive products from store shelf and hiding them under jacket in electronics store, fast sneaky motion, looking around nervously, dramatic noir lighting, security camera perspective, dark stylized mafia game aesthetic, film grain, 16:9, 5 seconds",
    },
    # Add more crimes as needed
}

def generate_video_from_prompt(crime_id: str, crime_data: dict):
    """Generate a video from a text prompt using Luma Dream Machine"""
    
    output_file = f"{CRIMES_OUTPUT_DIR}/{crime_id}_crime.mp4"
    prompt = crime_data['prompt']
    
    if os.path.exists(output_file):
        print(f"✅ Already exists: {crime_data['name']} ({output_file})")
        return True
    
    print(f"\n📹 Generating video: {crime_data['name']}...")
    print(f"   Prompt: {prompt[:80]}...")
    
    try:
        headers = {
            "Authorization": f"Token {API_TOKEN}",
            "Content-Type": "application/json"
        }
        
        # Minimax Video (text-to-video)
        payload = {
            "version": "4b3a7dd0f88befda43166d2b6e5bc3bb78e2d2f97cf1b4c4d96ec5f3f3c3e8d1",
            "input": {
                "prompt": prompt,
                "prompt_optimizer": True,
            }
        }
        
        print(f"  📤 Submitting prediction...")
        response = requests.post(
            "https://api.replicate.com/v1/predictions",
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
            print(f"  ❌ Failed: No prediction ID")
            return False
        
        print(f"  ⏳ Waiting for prediction {prediction_id[:8]}...")
        
        # Poll for completion (video generation takes 2-5 minutes)
        max_polls = 600  # 20 minutes max
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
                output_url = check_data.get('output')
                
                if output_url:
                    print(f"  📥 Downloading video...")
                    
                    if isinstance(output_url, list) and len(output_url) > 0:
                        output_url = output_url[0]
                    
                    if isinstance(output_url, str) and output_url.startswith('http'):
                        try:
                            import urllib.request
                            urllib.request.urlretrieve(output_url, output_file)
                            
                            filesize = os.path.getsize(output_file) / (1024 * 1024)
                            print(f"  ✅ SUCCESS: {output_file} ({filesize:.2f} MB)")
                            return True
                        except Exception as dl_error:
                            print(f"  ❌ Download failed: {str(dl_error)}")
                            return False
                    else:
                        print(f"  ❌ Invalid URL: {output_url}")
                        return False
                else:
                    print(f"  ❌ No output in response")
                    return False
                    
            elif status == 'failed':
                error = check_data.get('error', 'Unknown error')
                print(f"  ❌ Prediction failed: {error}")
                return False
                
            else:
                if poll_count % 30 == 0:
                    print(f"    Still {status}... ({poll_count * 2}s)")
        
        print(f"  ❌ Timeout waiting for prediction")
        return False
        
    except Exception as e:
        print(f"  ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("\n" + "="*60)
    print("🎬 Crime Video Generator (Minimax Video)")
    print("   Generates action videos from text prompts")
    print("="*60)
    
    if not API_TOKEN:
        print("❌ ERROR: REPLICATE_API_TOKEN not set")
        sys.exit(1)
    
    successful = 0
    failed = 0
    
    for crime_id, crime_data in CRIME_VIDEOS.items():
        if generate_video_from_prompt(crime_id, crime_data):
            successful += 1
        else:
            failed += 1
        
        # Wait between videos to avoid rate limiting
        if crime_id != list(CRIME_VIDEOS.keys())[-1]:
            print(f"  💤 Waiting 30s before next video...")
            time.sleep(30)
    
    print("\n" + "="*60)
    print(f"✅ Generation complete!")
    print(f"   Successful: {successful}/{len(CRIME_VIDEOS)}")
    print(f"   Failed: {failed}/{len(CRIME_VIDEOS)}")
    
    crimes_mp4_count = len(
        [f for f in os.listdir(CRIMES_OUTPUT_DIR) if f.endswith('.mp4')]
    )
    garage_mp4_count = len(
        [f for f in os.listdir(GARAGE_OUTPUT_DIR) if f.endswith('.mp4')]
    )
    marina_mp4_count = len(
        [f for f in os.listdir(MARINA_OUTPUT_DIR) if f.endswith('.mp4')]
    )
    print(f"   MP4 files in {CRIMES_OUTPUT_DIR}: {crimes_mp4_count}")
    print(f"   MP4 files in {GARAGE_OUTPUT_DIR}: {garage_mp4_count}")
    print(f"   MP4 files in {MARINA_OUTPUT_DIR}: {marina_mp4_count}")
    print("="*60)

if __name__ == "__main__":
    main()
