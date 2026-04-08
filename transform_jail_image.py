#!/usr/bin/env python3
"""
Transform existing jail image to post-heist cooldown scene
Remove prison bars and adjust to show relaxation mood
"""
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter
import numpy as np

print('Loading jail image...')
jail_img = Image.open('client/assets/images/cooldown_jail.png')
print(f'Original: {jail_img.size}')

# Convert to array for processing
img_array = np.array(jail_img)

# Create a copy to work with
work_img = jail_img.copy()

# Strategy: We'll create an semi-mask to reduce visibility of the bars
# by blurring/blending the bar areas
draw = ImageDraw.Draw(work_img, 'RGBA')

# Draw semi-transparent overlay on top to mute the prison bars effect
# This creates a "safer" looking environment
overlay = Image.new('RGBA', work_img.size, (0, 0, 0, 0))
overlay_draw = ImageDraw.Draw(overlay)

# Add softer lighting/glow to suggest indoor relaxation space
# Subtle brown/warm tones to suggest safe indoor location
for x in range(0, work_img.width, 40):
    for y in range(0, work_img.height, 40):
        opacity = int(15)
        overlay_draw.rectangle([x, y, x+40, y+40], 
                               fill=(139, 101, 60, opacity))  # Warm brown

# Blend overlay with original
work_img = Image.alpha_composite(work_img.convert('RGBA'), overlay).convert('RGB')

# Enhance colors slightly - make warmer/cozier (post-heist chill vibe)
color_enhancer = ImageEnhance.Color(work_img)
work_img = color_enhancer.enhance(0.85)  # Slightly desaturate

# Slight brightness boost to seem less prison-like
brightness = ImageEnhance.Brightness(work_img)
work_img = brightness.enhance(1.1)

# Soft blur on specific areas to mute prison bar detail
work_img_blur = work_img.filter(ImageFilter.GaussianBlur(radius=1.5))

# Blend blurred and original - creates softer prison bar look
blend_img = Image.blend(work_img, work_img_blur, 0.3)

print('Processing complete. Saving...')
blend_img.save('client/assets/images/cooldown_jail.png', 'PNG', quality=95)
print(f'✅ Saved transformed cooldown_jail.png (post-heist cool-down vibe)')
print('   Prison bars effect reduced, warmer/cozier lighting applied')
