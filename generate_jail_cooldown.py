#!/usr/bin/env python3
"""
Generate jail cooldown image: gangster cooling off after successful heist escape
"""
import requests
import os
from PIL import Image
from io import BytesIO
import time

api_key = 'b00d9055-7145-4ef2-84a7-6f32835e2ac2'
url = 'https://api.leonardo.ai/v1/generations'

prompt = '''Noir gangster scene: tough male mobster character in dark 1950s noir style sitting relaxed in safehouse apartment or luxury car interior, cooling off after successful heist/crime escape, satisfied confident expression, moody dramatic lighting, crime noir game art style, detailed character'''

headers = {
    'Authorization': f'Bearer {api_key}',
    'Content-Type': 'application/json'
}

data = {
    'prompt': prompt,
    'width': 512,
    'height': 512,
    'num_images': 1
}

print(f'Generating jail cooldown image...')
print(f'Prompt: {prompt[:80]}...')

response = requests.post(url, json=data, headers=headers)

if response.status_code == 200:
    result = response.json()
    if 'generations' in result and result['generations']:
        gen_id = result['generations'][0]['id']
        print(f'✓ Generation ID: {gen_id}')
        
        # Poll for completion
        for attempt in range(60):
            status_url = f'https://api.leonardo.ai/v1/generations/{gen_id}'
            status_response = requests.get(status_url, headers=headers)
            status = status_response.json()
            
            current_status = status.get('generationsByPk', {}).get('status', 'unknown')
            print(f'  Attempt {attempt+1}: {current_status}')
            
            if current_status == 'COMPLETE':
                if status['generationsByPk'].get('generated_images'):
                    img_url = status['generationsByPk']['generated_images'][0]['url']
                    print(f'✓ Image URL: {img_url[:50]}...')
                    
                    img_response = requests.get(img_url)
                    img = Image.open(BytesIO(img_response.content))
                    
                    img.save('client/assets/images/cooldown_jail.png')
                    print(f'✅ Saved cooldown_jail.png ({img.size})')
                    break
            
            time.sleep(2)
    else:
        print(f'❌ No generations in response: {result}')
else:
    print(f'❌ Error: {response.status_code} - {response.text}')
