#!/usr/bin/env python3
"""
Generate arrest video using Minimax Video (text-to-video)
This generates the arrest animation shown when player gets caught
"""
import os
import sys
import time
import requests

OUTPUT_DIR = 'client/assets/videos'
API_TOKEN = os.environ.get('REPLICATE_API_TOKEN', '')

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Arrest video prompt
ARREST_VIDEO = {
    "name": "Police Arrest",
    "filename": "arrest.mp4",
    "prompt": "Cinematic video of police officers rushing towards camera and grabbing criminal by arms in dramatic arrest, handcuffs clicking, cop car lights flashing red and blue in background, dramatic noir lighting with high contrast, stylized dark mafia game aesthetic, film noir style, gritty urban atmosphere, professional cinematography, 4-5 seconds, high quality, 16:9",
}

# Alternative prompts (uncomment to use different version):
# ARREST_VIDEO["prompt"] = "Cinematic POV video: being arrested - cop hands grabbing your arms forcefully, handcuffs snapping on wrists, police badge close-up, flashing police lights in background, dramatic noir lighting, film grain, stylized dark mafia game aesthetic, caught red-handed perspective, 16:9, 5 seconds"

ARREST_VIDEO["prompt"] = "Animated cinematic video sequence: cartoon ADULT mafia criminal character in dark suit, fedora hat, and leather gloves, frantically running away through noir-lit alleyway, looking back nervously, tough hardened criminal expression, animated police officer in uniform chasing from behind shouting commands, officer catches up and tackles criminal to the ground in dramatic action scene, criminal struggling on ground, police officer standing over criminal with hand gestures commanding surrender, criminal hands raised in defeat, police car pulls up in background with red and blue flashing lights, loud police sirens wailing in audio, officer speaking 'You're under arrest!' in stern authoritative voice, second officer arrives from police car, criminal being escorted away, noir lighting and shadows throughout, stylized animated mafia game aesthetic, animated two-frame action poses, high contrast film noir animation style, intense dramatic arrest sequence with multiple action beats, 5-6 seconds total, animated illustration style, 16:9 widescreen, WITH POLICE SIRENS AUDIO wailing throughout"

def generate_arrest_video():
    """Generate arrest video from text prompt using Minimax Video"""
    
    output_file = f"{OUTPUT_DIR}/{ARREST_VIDEO['filename']}"
    prompt = ARREST_VIDEO['prompt']
    
    if os.path.exists(output_file):
        print(f"✅ Already exists: {ARREST_VIDEO['name']} ({output_file})")
        return True
    
    print(f"\n📹 Generating video: {ARREST_VIDEO['name']}...")
    print(f"   Prompt: {prompt}")
    print()
    
    try:
        headers = {
            "Authorization": f"Token {API_TOKEN}",
            "Content-Type": "application/json"
        }
        
        # Minimax Video (text-to-video) - same as crime videos
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
        print(f"     (This usually takes 2-5 minutes)")
        
        # Poll for completion
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
                            print()
                            print(f"  ✅ SUCCESS: {output_file} ({filesize:.2f} MB)")
                            print()
                            print(f"  📝 Next step: Update crime_screen.dart to use:")
                            print(f"     'assets/videos/arrest.mp4'")
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
                    print(f"    Still {status}... ({poll_count * 2}s elapsed)")
        
        print(f"  ❌ Timeout waiting for prediction")
        return False
        
    except Exception as e:
        print(f"  ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("\n" + "="*60)
    print("  ARREST VIDEO GENERATOR")
    print("="*60)
    
    if not API_TOKEN:
        print("\n❌ ERROR: REPLICATE_API_TOKEN environment variable not set")
        print("   Set it with: $env:REPLICATE_API_TOKEN='your-token-here'")
        sys.exit(1)
    
    print(f"\n🎬 Generating arrest video...")
    print(f"   Output: {OUTPUT_DIR}/{ARREST_VIDEO['filename']}")
    
    success = generate_arrest_video()
    
    print("\n" + "="*60)
    if success:
        print("  ✅ COMPLETE")
        print("="*60)
        print()
        print("Next steps:")
        print("1. Check the generated video")
        print("2. If you like it, it's ready to use!")
        print("3. If not, edit the prompt in this script and run again")
    else:
        print("  ❌ FAILED")
        print("="*60)
        print()
        print("Troubleshooting:")
        print("- Check your Replicate API token")
        print("- Check the error messages above")
        print("- Try running the script again")
    print()

if __name__ == '__main__':
    main()
