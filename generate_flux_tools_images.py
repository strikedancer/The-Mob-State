#!/usr/bin/env python3
import json
import os
import sys
import time

OUTPUT_DIR = 'client/images/tools'
TOOLS_FILE = 'backend/data/tools.json'
API_TOKEN = os.environ.get('REPLICATE_API_TOKEN', '')
FLUX_VERSION = "609793a667ed94b210242837d3c3c9fc9a64ae93685f15d75002ba0ed9a97f2b"

os.makedirs(OUTPUT_DIR, exist_ok=True)

TOOL_PROMPTS = {
    "bolt_cutter": "stylized cinematic key art for dark mafia game, heavy duty bolt cutter tool with red handles on dark industrial workbench, dramatic overhead lighting, gritty crime atmosphere, semi realistic digital painting, metal texture detail, no text no logo no watermark",
    
    "burglary_kit": "stylized cinematic key art for dark mafia game, professional burglary toolkit with lockpicks crowbar and tools laid out on black fabric, dramatic spotlight from above, gritty criminal mood, semi realistic digital painting, high detail, no text no logo no watermark",
    
    "car_theft_tools": "stylized cinematic key art for dark mafia game, car theft tools including slim jim and electronic key programmer on car dashboard at night, neon city lights reflected, gritty urban crime mood, semi realistic digital painting, no text no logo no watermark",
    
    "jerry_can": "stylized cinematic key art for dark mafia game, red metal jerry can fuel canister on dark concrete floor, dramatic side lighting casting long shadow, gritty industrial atmosphere, semi realistic digital painting, high detail metal texture, no text no logo no watermark",
    
    "spray_paint": "stylized cinematic key art for dark mafia game, spray paint can with neon paint dripping down side, graffiti wall background blurred, dramatic urban night lighting, gritty street crime mood, semi realistic digital painting, no text no logo no watermark",
    
    "crowbar": "stylized cinematic key art for dark mafia game, heavy steel crowbar leaning against brick wall in dark alley, dramatic streetlamp lighting from above, gritty urban crime atmosphere, semi realistic digital painting, metal detail, no text no logo no watermark",
    
    "glass_cutter": "stylized cinematic key art for dark mafia game, professional glass cutting tool with diamond blade on black surface, luxury jewelry store window reflected in background, dramatic lighting, sophisticated heist mood, semi realistic digital painting, no text no logo no watermark",
    
    "hacking_laptop": "stylized cinematic key art for dark mafia game, open laptop with green terminal code on screen in dark room, multiple cable connections visible, neon blue keyboard backlight, gritty hacker atmosphere, semi realistic digital painting, no text no logo no watermark",
    
    "counterfeiting_kit": "stylized cinematic key art for dark mafia game, counterfeiting equipment with printing plates and currency paper on workshop table, dramatic overhead lamp lighting, gritty criminal operation mood, semi realistic digital painting, high detail, no text no logo no watermark",
    
    "toolbox": "stylized cinematic key art for dark mafia game, red metal toolbox opened revealing various mechanic tools inside, industrial garage background, dramatic work light from above, gritty working atmosphere, semi realistic digital painting, no text no logo no watermark",
    
    "rope": "stylized cinematic key art for dark mafia game, coiled thick nylon rope on dark concrete floor, dramatic side lighting creating strong shadows, tense kidnapping atmosphere, gritty crime mood, semi realistic digital painting, texture detail, no text no logo no watermark",
    
    "silencer": "stylized cinematic key art for dark mafia game, gun silencer suppressor on dark velvet cloth, weapon parts visible in background out of focus, dramatic spotlight from above, dangerous professional mood, semi realistic digital painting, metal detail, no text no logo no watermark",
    
    "fake_documents": "stylized cinematic key art for dark mafia game, stack of forged passports and identity documents spread on desk with official stamps visible, dramatic desk lamp lighting, sophisticated crime atmosphere, semi realistic digital painting, no text no logo no watermark",
    
    "night_vision": "stylized cinematic key art for dark mafia game, military style night vision goggles on tactical gear, green night vision display glow visible, dark tactical environment, dramatic lighting, professional heist mood, semi realistic digital painting, no text no logo no watermark",
    
    "burner_phone": "stylized cinematic key art for dark mafia game, disposable burner phone on dark surface with sim cards scattered around, dramatic overhead lighting, untraceable communication mood, gritty crime atmosphere, semi realistic digital painting, no text no logo no watermark",
    
    "gps_jammer": "stylized cinematic key art for dark mafia game, electronic GPS jamming device with antenna and blinking LED lights, technical equipment on black surface, dramatic side lighting, high tech crime mood, semi realistic digital painting, electronic detail, no text no logo no watermark",
    
    "thermal_drill": "stylized cinematic key art for dark mafia game, industrial thermal cutting drill with glowing heated tip on heavy duty stand, vault door metal texture visible in background, dramatic orange heat glow lighting, sparks flying, professional heist atmosphere, semi realistic digital painting, high detail metalwork, no text no logo no watermark",
}

def generate_with_replicate():
    import requests
    
    with open(TOOLS_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
        tools = data['tools']
    
    successful = 0
    failed = 0
    
    headers = {
        "Authorization": f"Token {API_TOKEN}",
        "Content-Type": "application/json"
    }
    
    for idx, tool in enumerate(tools, 1):
        tool_id = tool['id']
        tool_name = tool['name']
        
        output_file = f"{OUTPUT_DIR}/{tool_id}_tool.png"
        
        if os.path.exists(output_file):
            print(f"[{idx}/{len(tools)}] Already exists: {tool_name}")
            successful += 1
            continue
        
        prompt = TOOL_PROMPTS.get(tool_id, f"{tool_name} crime tool, dark atmospheric lighting")
        
        print(f"[{idx}/{len(tools)}] Generating: {tool_name}...")
        
        try:
            # Create prediction
            payload = {
                "version": FLUX_VERSION,
                "input": {
                    "prompt": prompt,
                    "aspect_ratio": "1:1",
                    "output_format": "png",
                    "num_outputs": 1,
                }
            }
            
            print(f"  Submitting prediction...")
            response = requests.post(
                "https://api.replicate.com/v1/predictions",
                json=payload,
                headers=headers,
                timeout=30
            )
            
            if response.status_code == 429:
                print(f"  Rate limited. Waiting 120 seconds...")
                time.sleep(120)
                print(f"  Retrying prediction...")
                response = requests.post(
                    "https://api.replicate.com/v1/predictions",
                    json=payload,
                    headers=headers,
                    timeout=30
                )
                
                if response.status_code != 201:
                    print(f"  Failed after retry: {response.status_code}")
                    failed += 1
                    continue
            
            if response.status_code != 201:
                print(f"  Failed: {response.status_code}")
                failed += 1
                continue
            
            prediction_resp = response.json()
            prediction_id = prediction_resp.get('id')
            
            if not prediction_id:
                print(f"  Failed: No prediction ID")
                failed += 1
                continue
            
            print(f"  Waiting for prediction {prediction_id[:8]}...")
            
            # Poll for completion
            max_polls = 300
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
                    print(f"  Poll failed: {check_resp.status_code}")
                    failed += 1
                    break
                
                check_data = check_resp.json()
                status = check_data.get('status')
                
                if status == 'succeeded':
                    output_urls = check_data.get('output', [])
                    
                    if output_urls:
                        # Handle different output formats
                        image_url = None
                        if isinstance(output_urls, list) and len(output_urls) > 0:
                            image_url = output_urls[0]
                        elif isinstance(output_urls, str):
                            image_url = output_urls
                        else:
                            image_url = str(output_urls)
                        
                        if image_url and isinstance(image_url, str) and len(image_url) > 0:
                            if image_url.startswith('http'):
                                try:
                                    print(f"  Downloading image...")
                                    import urllib.request
                                    urllib.request.urlretrieve(image_url, output_file)
                                    print(f"  SUCCESS: {output_file}")
                                    successful += 1
                                except Exception as dl_error:
                                    print(f"  Download failed: {str(dl_error)}")
                                    failed += 1
                            else:
                                print(f"  Invalid URL format")
                                failed += 1
                        else:
                            print(f"  No valid URL found")
                            failed += 1
                    else:
                        print(f"  No output in response")
                        failed += 1
                    break
                    
                elif status == 'failed':
                    print(f"  Prediction failed")
                    failed += 1
                    break
                    
                else:
                    if poll_count % 20 == 0:
                        print(f"    Still {status}... ({poll_count}s)")
            
            if poll_count >= max_polls:
                print(f"  Timeout waiting for prediction")
                failed += 1
            
            # Wait between tools to avoid rate limiting
            if idx < len(tools):
                time.sleep(5)
                
        except Exception as e:
            print(f"  Error: {str(e)}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"Generation complete!")
    print(f"Successful: {successful}/{len(tools)}")
    print(f"Failed: {failed}/{len(tools)}")
    if os.path.exists(OUTPUT_DIR):
        count = len([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.png')])
        print(f"PNG files in {OUTPUT_DIR}: {count}")

if __name__ == "__main__":
    if not API_TOKEN:
        print("ERROR: REPLICATE_API_TOKEN not set")
        sys.exit(1)
    
    generate_with_replicate()
