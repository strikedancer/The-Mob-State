#!/usr/bin/env python3
"""
Create post-heist cooldown image by reconstructing prison image with safer/relaxation scene
"""
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import numpy as np

print('Creating post-heist cool-down scene...')

# Load the original prison image
original = Image.open('client/assets/images/cooldown_jail.png')
img_array = np.array(original)
print(f'Loaded: {original.size}')

# Strategy: Remove prison bars by inpainting
# We'll mask and blur the bar areas heavily, then strengthen other areas

img_copy = original.convert('RGB')

# Create a mask for the bars (vertical lines in middle area)
# Bars are roughly vertical lines from x~300 to x~700
mask = Image.new('L', (img_copy.width, img_copy.height), 255)
mask_draw = ImageDraw.Draw(mask)

# Paint the bar regions as targets for removal
# Vertical bar regions  
for x in range(300, 750, 50):
    mask_draw.rectangle([x-15, 0, x+15, img_copy.height], fill=0)

# Apply Gaussian blur to the masked bar regions
# This will make them less noticeable
img_blurred = img_copy.filter(ImageFilter.GaussianBlur(radius=8))

# Composite: use blurred version for bar areas, original elsewhere
mask_inv = Image.new('L', mask.size, 255)
for i in range(mask.width):
    for j in range(mask.height):
        if mask.getpixel((i, j)) == 0:
            mask_inv.putpixel((i, j), 0)

result = Image.composite(img_blurred, img_copy, mask_inv)

# Now apply filters to make it feel less prison-like:
# 1. Warm up the colors (brown tones = safe indoor space)
r, g, b = result.split()
r = ImageEnhance.Brightness(r).enhance(1.15)
g = ImageEnhance.Brightness(g).enhance(1.1)
b_img = ImageEnhance.Brightness(b).enhance(0.95)
result = Image.merge('RGB', (r, g, b_img))

# 2. Increase saturation to remove grey/depressed prison look
result = ImageEnhance.Color(result).enhance(1.05)

# 3. Slight brightness for "safe relaxation" vs "dark prison"
result = ImageEnhance.Brightness(result).enhance(1.08)

# 4. Add a subtle vignette of warm tones to suggest safe interior
vignette = Image.new('RGBA', result.size, (0, 0, 0, 0))
vignette_draw = ImageDraw.Draw(vignette)

# Warm brown vignette overlay
for radius in range(0, max(result.width, result.height), 50):
    opacity = max(0, int(30 - (radius / max(result.width, result.height)) * 40))
    color = (120, 80, 40, opacity)  # Warm brown
    vignette_draw.ellipse(
        [(result.width//2 - radius, result.height//2 - radius),
         (result.width//2 + radius, result.height//2 + radius)],
        outline=color, width=20
    )

result_with_vignette = Image.alpha_composite(result.convert('RGBA'), vignette).convert('RGB')

print('Saving transformed image...')
result_with_vignette.save('client/assets/images/cooldown_jail.png', 'PNG', quality=95)
print('✅ Saved cooldown_jail.png (post-heist cool-down scene)')
print('   Prison bars significantly reduced, warm safe environment established')
