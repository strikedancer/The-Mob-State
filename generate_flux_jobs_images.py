#!/usr/bin/env python3
import json
import os
import sys
import time
import uuid

OUTPUT_DIR = 'client/images/jobs'
JOBS_FILE = 'backend/content/jobs.json'
API_TOKEN = os.environ.get('REPLICATE_API_TOKEN', '')
FLUX_VERSION = "609793a667ed94b210242837d3c3c9fc9a64ae93685f15d75002ba0ed9a97f2b"

os.makedirs(OUTPUT_DIR, exist_ok=True)

JOB_PROMPTS = {
    "newspaper_delivery": "stylized cinematic key art for dark mafia game, young courier on scooter navigating empty amsterdam canal streets at dawn, golden morning light through fog, gritty european city mood, dramatic shadows, semi realistic digital painting, high detail, clear focal subject, no text no logo no watermark",
    
    "car_wash": "stylized cinematic key art for dark mafia game, worker with spray gun cleaning luxury car at outdoor washrette, neon sign reflected in soapy surface, gritty european city mood, dramatic lighting, semi realistic digital painting, high detail environment, no text no logo no watermark",
    
    "grocery_bagger": "stylized cinematic key art for dark mafia game, stock worker stacking products on supermarket shelf in fluorescent light, concrete industrial interior, gritty working class mood, dramatic shadows, semi realistic digital painting, no text no logo no watermark",
    
    "dishwasher": "stylized cinematic key art for dark mafia game, kitchen worker washing stacks of plates in steamy restaurant kitchen, industrial stainless steel surfaces, warm overhead amber lighting, gritty mood, semi realistic digital painting, high detail, no text no logo no watermark",
    
    "street_sweeper": "stylized cinematic key art for dark mafia game, street sweeper cleaning wet cobblestone alley at night, neon streetlamp glow overhead, moody european urban scene, dramatic lighting, semi realistic digital painting, gritty atmosphere, no text no logo no watermark",
    
    "pizza_delivery": "stylized cinematic key art for dark mafia game, pizza delivery rider on motor scooter weaving through neon-lit city streets at night, italian neighborhood buildings, warm red neon signage, dramatic shadows, semi realistic digital painting, no text no logo no watermark",
    
    "taxi_driver": "stylized cinematic key art for dark mafia game, taxi driver inside yellow cab at night, city lights and rain streaks on windshield, other cars and neon storefronts visible through windows, moody european city mood, semi realistic digital painting, no text no logo no watermark",
    
    "warehouse_worker": "stylized cinematic key art for dark mafia game, muscular worker moving heavy wooden crates in industrial warehouse with high ceilings, strong overhead lighting casting dramatic shadows, concrete floor, stacked pallets, gritty working mood, semi realistic digital painting, no text no logo no watermark",
    
    "construction_worker": "stylized cinematic key art for dark mafia game, construction worker with safety vest on city building site, metal scaffolding and cranes visible, dramatic morning light, dusty gritty mood, semi realistic digital painting, european urban setting, no text no logo no watermark",
    
    "bartender": "stylized cinematic key art for dark mafia game, bartender mixing cocktail behind neon-lit bar counter, liquor bottles reflecting colored lights, crowded club background blurred, dramatic neon and shadow mood, semi realistic digital painting, no text no logo no watermark",
    
    "security_guard": "stylized cinematic key art for dark mafia game, uniformed security guard standing watch outside building entrance at night, earpiece visible, professional vigilant pose, neon signage and dramatic shadows, gritty urban mood, semi realistic digital painting, no text no logo no watermark",
    
    "truck_driver": "stylized cinematic key art for dark mafia game, truck driver inside cab of large cargo truck on dark highway at night, dashboard lights and road ahead visible through windshield, moody dramatic lighting, semi realistic digital painting, no text no logo no watermark",
    
    "mechanic": "stylized cinematic key art for dark mafia game, mechanic working on car engine in industrial garage workshop, overhead work lights and greasy tools visible, dramatic shadows across workbench, gritty working atmosphere, semi realistic digital painting, no text no logo no watermark",
    
    "electrician": "stylized cinematic key art for dark mafia game, electrician installing wiring and electrical systems in dark construction site, yellow safety helmet and power tools, dramatic work lighting, gritty industrial mood, semi realistic digital painting, no text no logo no watermark",
    
    "plumber": "stylized cinematic key art for dark mafia game, plumber working on bathroom pipe installation, wrench and tools visible, industrial bathroom interior, dramatic overhead lighting, gritty working mood, semi realistic digital painting, no text no logo no watermark",
    
    "chef": "stylized cinematic key art for dark mafia game, professional chef cooking at hot stove in upscale restaurant kitchen, flames and heat visible, professional kitchen environment, warm dramatic lighting, semi realistic digital painting, no text no logo no watermark",
    
    "paramedic": "stylized cinematic key art for dark mafia game, paramedic attending to patient in ambulance interior, medical equipment visible, emergency interior lighting, tense dramatic mood, semi realistic digital painting, no text no logo no watermark",
    
    "programmer": "stylized cinematic key art for dark mafia game, programmer at desk with multiple monitors displaying code and network diagrams, neon blue screen glow on face, dark office interior, dramatic tech mood, semi realistic digital painting, no text no logo no watermark",
    
    "accountant": "stylized cinematic key art for dark mafia game, accountant at office desk with financial documents and computer, professional corporate interior, desk lamp overhead lighting, dramatic shadows, sophisticated mood, semi realistic digital painting, no text no logo no watermark",
    
    "lawyer": "stylized cinematic key art for dark mafia game, lawyer in suit at desk with law books and contract documents, professional law office with wooden furniture, overhead lamp lighting, serious professional mood, semi realistic digital painting, no text no logo no watermark",
    
    "real_estate_agent": "stylized cinematic key art for dark mafia game, real estate agent showing luxury penthouse apartment to clients, modern interior with city skyline view through floor-to-ceiling windows, professional sophisticated mood, semi realistic digital painting, no text no logo no watermark",
    
    "stockbroker": "stylized cinematic key art for dark mafia game, stockbroker at trading desk with multiple financial market screens showing data and charts, neon green terminal glow, fast-paced trading floor atmosphere, dramatic lighting, semi realistic digital painting, no text no logo no watermark",
    
    "doctor": "stylized cinematic key art for dark mafia game, doctor in white coat examining patient in modern hospital room, medical monitors and equipment visible, clinical professional lighting, healthcare mood, semi realistic digital painting, no text no logo no watermark",
    
    "airline_pilot": "stylized cinematic key art for dark mafia game, airline pilot in cockpit of commercial airplane at altitude, controls and instruments visible, dramatic sky and clouds visible through cockpit windows, professional dramatic mood, semi realistic digital painting, no text no logo no watermark",
}

def generate_with_replicate():
    import requests
    
    with open(JOBS_FILE, 'r', encoding='utf-8') as f:
        jobs = json.load(f)
    
    successful = 0
    failed = 0
    
    headers = {
        "Authorization": f"Token {API_TOKEN}",
        "Content-Type": "application/json"
    }
    
    for idx, job in enumerate(jobs, 1):
        job_id = job['id']
        job_name = job['name']
        
        output_file = f"{OUTPUT_DIR}/{job_id}_job.png"
        
        if os.path.exists(output_file):
            print(f"[{idx}/{len(jobs)}] Already exists: {job_name}")
            successful += 1
            continue
        
        prompt = JOB_PROMPTS.get(job_id, f"{job_name} in action at work, realistic scene")
        
        print(f"[{idx}/{len(jobs)}] Generating: {job_name}...")
        
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
                    print(f"    Output type: {type(output_urls)}, content: {str(output_urls)[:100]}")
                    
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
                            print(f"    Image URL: {image_url[:50]}...")
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
                                print(f"  Invalid URL format: {image_url[:100]}")
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
            
            # Wait between jobs to avoid rate limiting
            if idx < len(jobs):
                time.sleep(5)
                
        except Exception as e:
            print(f"  Error: {str(e)}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"Generation complete!")
    print(f"Successful: {successful}/{len(jobs)}")
    print(f"Failed: {failed}/{len(jobs)}")
    if os.path.exists(OUTPUT_DIR):
        count = len([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.png')])
        print(f"PNG files in {OUTPUT_DIR}: {count}")

if __name__ == "__main__":
    if not API_TOKEN:
        print("ERROR: REPLICATE_API_TOKEN not set")
        sys.exit(1)
    
    generate_with_replicate()

