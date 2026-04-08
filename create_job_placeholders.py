#!/usr/bin/env python3
"""Create placeholder job card images"""

from PIL import Image, ImageDraw
import os

os.makedirs('client/assets/images/jobs', exist_ok=True)

jobs = [
    "newspaper_delivery", "car_wash", "grocery_bagger", "dishwasher",
    "street_sweeper", "pizza_delivery", "taxi_driver", "warehouse_worker",
    "construction_worker", "bartender", "security_guard", "truck_driver",
    "mechanic", "electrician", "plumber", "chef",
    "paramedic", "programmer", "accountant", "lawyer",
    "real_estate_agent", "stockbroker", "doctor", "airline_pilot"
]

for job_id in jobs:
    filename = f'client/assets/images/jobs/{job_id}_job.png'
    
    # Create a 512x512 gradient placeholder image
    img = Image.new('RGB', (512, 512), color=(40, 44, 52))
    draw = ImageDraw.Draw(img)
    
    # Add a gradient overlay
    for y in range(512):
        r = int(40 + (50 * y / 512))
        g = int(44 + (60 * y / 512))
        b = int(52 + (70 * y / 512))
        draw.line([(0, y), (512, y)], fill=(r, g, b))
    
    img.save(filename)
    print(f"✓ {job_id}_job.png")

print(f"\n✅ Created {len(jobs)} job placeholder images")
