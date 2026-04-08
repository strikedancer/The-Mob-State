#!/usr/bin/env python3
"""
Generate jail cooldown image via Replicate: gangster cooling off after heist (NOT in jail)
"""
import requests
import json
import time
import os
from urllib.request import urlretrieve

# Try Replicate's Flux API instead
replicate_api_key = 'r8_rgyW3OxGBxEa4rjYwt2sY5e7D1L6mPSFTcVL2'
url = 'https://api.replicate.com/v1/predictions'

prompt = 'Tough male mobster character in dark noir style, sitting relaxed in luxury apartment or car interior, cooling off after successful heist escape, satisfied confident expression, no prison bars, no jail, game art style, detailed, dramatic moody lighting'

headers = {
    'Authorization': f'Token {replicate_api_key}',
    'Content-Type': 'application/json'
}

data = {
    'version': '0bea51b3b1b65b82914130993f7aeb1cb3ef2384e99de3e5b8237aeaf75c28ab',  # Flux pro 1.1
    'input': {
        'prompt': prompt,
        'num_outputs': 1,
        'aspect_ratio': '1:1.5',
        'output_format': 'png',
    }
}

print(f'Generating jail cooldown via Replicate...')
print(f'Prompt: {prompt[:70]}...')

response = requests.post(url, json=data, headers=headers)
print(f'Status: {response.status_code}')

if response.status_code == 201:
    result = response.json()
    pred_id = result['id']
    print(f'✓ Prediction ID: {pred_id}')
    
    # Poll for completion
    for attempt in range(120):
        check_url = f'https://api.replicate.com/v1/predictions/{pred_id}'
        check_response = requests.get(check_url, headers=headers)
        check_result = check_response.json()
        
        status = check_result.get('status', 'unknown')
        print(f'  Attempt {attempt+1}: {status}')
        
        if status == 'succeeded':
            if check_result.get('output'):
                img_url = check_result['output'][0]
                print(f'✓ Image URL: {img_url}')
                
                # Download image
                urlretrieve(img_url, 'client/assets/images/cooldown_jail.png')
                print(f'✅ Saved cooldown_jail.png (post-heist cool-down scene)')
                break
            else:
                print(f'❌ No output in response')
                break
        elif status == 'failed':
            print(f'❌ Prediction failed: {check_result.get("error")}')
            break
        
        time.sleep(2)
else:
    print(f'❌ Error {response.status_code}')
    print(response.text[:200])
