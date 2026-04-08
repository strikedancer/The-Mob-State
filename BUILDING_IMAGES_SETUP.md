# Crew Building Images Setup Guide

## Overview
The crew building system now supports 15 levels per building type with images for each level. These images are referenced by the frontend and displayed in the crew building tabs.

## Directory Structure

All building images should be placed in:
```
client/assets/images/crew_buildings/
```

## Image File Naming Convention

Images follow this naming pattern:
```
{building_type}_{hq_style}_lvl{level}.png
```

### Building Types
- `car_storage` - Car Storage
- `boat_storage` - Boat Storage  
- `weapon_storage` - Weapon Storage
- `ammo_storage` - Ammo Storage
- `drug_storage` - Drug Storage
- `cash_storage` - Cash Storage

### HQ Styles
- `camping` - Camping HQ (Base level)
- `rural` - Rural HQ
- `city` - City HQ
- `villa` - Villa HQ
- `vip` - VIP HQ (VIP-exclusive)

### Levels
- `0-9` - Standard levels (accessible to all crews)
- `10-14` - VIP-exclusive levels (requires crew VIP status)

## Example Paths

```
client/assets/images/crew_buildings/car_storage_camping_lvl0.png
client/assets/images/crew_buildings/car_storage_camping_lvl5.png
client/assets/images/crew_buildings/car_storage_rural_lvl8.png
client/assets/images/crew_buildings/weapon_storage_villa_lvl14.png
client/assets/images/crew_buildings/cash_storage_vip_lvl10.png
```

## Image Specifications

- **Format**: PNG with transparency support
- **Recommended Size**: 400x200 to 600x300 pixels
- **Quality**: High-quality (HQ) images to represent building upgrades
- **Style**: Should reflect the progression from base camping to luxury VIP buildings

## Total Images Needed

### Per Building Type
- 6 HQ styles × 10 standard levels = 60 images (or less if shared across styles)
- Plus 5 VIP-exclusive levels per style = 30 additional images

### Minimum Set (If Sharing Across Styles)
- 6 building types × 10 levels = 60 images (one set, reused for all styles)
- Plus 6 building types × 5 VIP levels = 30 additional VIP images
- **Total Minimum: 90 images**

### Maximum Set (Full Variation)
- 6 building types × 6 HQ styles × 15 levels = 540 images
- **Total Maximum: 540 images**

## Current Fallback Behavior

If no image is found, the system displays:
- A gradient background (dark gray)
- Building icon (based on building type)
- Building type label with level indicator
- Example: "CAR_STORAGE L5"

This fallback is functional and allows the app to work without images, but images significantly improve the UI/UX.

## Frontend Code Reference

Images are loaded in `crew_screen.dart`:
```dart
final imagePath = _getCrewBuildingImagePath(type, hqStyle, level);
// Returns: images/crew_buildings/{type}_{style}_lvl{level}.png

// In pubspec.yaml, ensure assets are declared:
assets:
  - assets/images/crew_buildings/
```

## Migration Path

1. **Phase 1 (MVP)**: Use fallback gradient + icon for all levels
2. **Phase 2 (Enhancement)**: Add 10 generic building images (one per level, reused across styles)
3. **Phase 3 (Premium)**: Add style-specific variants (60 images)
4. **Phase 4 (Full)**: Add all VIP variants (90-540 images depending on approach)

## Database Considerations

- Images are not stored in database
- Image paths are generated dynamically from: building type + HQ style + level
- No database migration needed for image support
- System gracefully handles missing images with fallback display

## Tools for Image Generation

- **AI Image Generators**: Stability AI Flux, DALL-E, Midjourney
- **Image Editing**: Photoshop, GIMP, Affinity Photo
- **Batch Processing**: ImageMagick, FFmpeg for resizing if needed
