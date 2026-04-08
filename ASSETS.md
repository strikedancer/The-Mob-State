# Assets Plan

This document defines all visual assets needed for the Mafia Game.

---

## Asset Categories

1. **Base Images** - Static background images
2. **Overlays** - Transparent PNGs layered on base images
3. **Icons** - UI elements, buttons, status indicators
4. **Avatars** - Player profile images
5. **Vehicles** - Car, boat, plane illustrations
6. **Properties** - Buildings and locations

---

## Naming Convention

### Format

```
{category}_{type}_{variant}_{state}.png
```

### Examples

```
property_house_modern_base.png
property_house_modern_damaged.png
vehicle_sedan_red_base.png
vehicle_sedan_red_broken.png
icon_health_full.png
icon_health_low.png
overlay_fire.png
overlay_police_tape.png
```

---

## Recommended Sizes & Formats

| Asset Type | Size (px) | Format | Notes |
|------------|-----------|--------|-------|
| Property Base | 512x512 | PNG | Square, centered |
| Property Overlay | 512x512 | PNG | Transparent, same size as base |
| Vehicle Base | 256x128 | PNG | Landscape orientation |
| Vehicle Overlay | 256x128 | PNG | Transparent |
| Icon Small | 32x32 | PNG | UI elements |
| Icon Medium | 64x64 | PNG | Buttons |
| Icon Large | 128x128 | PNG | Featured items |
| Avatar | 128x128 | PNG/JPG | Circular crop |
| Background | 1920x1080 | JPG | City skyline, etc. |

---

## 1. Property Assets

### Base Images

All properties have a base image showing the building in normal condition.

**Required Base Images:**

```
property_house_base.png
property_apartment_base.png
property_warehouse_base.png
property_casino_base.png
property_nightclub_base.png
property_office_base.png
property_factory_base.png
property_garage_base.png
property_yacht_marina_base.png
property_airport_hangar_base.png
```

### Overlays

Overlays are composited on top of base images to show state changes.

**Damage/Condition:**
```
overlay_damaged_light.png      # Minor damage (broken window)
overlay_damaged_heavy.png      # Major damage (fire, collapsed wall)
overlay_fire.png               # Building on fire
overlay_police_tape.png        # Crime scene
overlay_construction.png       # Under construction/renovation
```

**Upgrades:**
```
overlay_upgraded_lvl1.png      # Basic upgrade (new paint)
overlay_upgraded_lvl2.png      # Medium upgrade (expanded)
overlay_upgraded_lvl3.png      # Max upgrade (luxury)
overlay_security_camera.png    # Security installed
overlay_neon_sign.png          # Neon sign (nightclub)
```

**Protection/Status:**
```
overlay_protected.png          # Protected from raids
overlay_locked.png             # Locked (player in jail)
overlay_raided.png             # Recently raided
overlay_guarded.png            # Guards on duty
```

### Usage Example

```json
// API response
{
  "propertyId": "123",
  "type": "casino",
  "baseImage": "property_casino_base.png",
  "overlayKeys": ["overlay_upgraded_lvl2", "overlay_security_camera"]
}
```

Client renders:
1. Load `property_casino_base.png`
2. Layer `overlay_upgraded_lvl2.png` on top
3. Layer `overlay_security_camera.png` on top

---

## 2. Vehicle Assets

### Base Images

**Cars:**
```
vehicle_sedan_base.png
vehicle_sports_car_base.png
vehicle_suv_base.png
vehicle_van_base.png
vehicle_truck_base.png
vehicle_limousine_base.png
vehicle_armored_car_base.png
```

**Motorcycles:**
```
vehicle_motorcycle_base.png
vehicle_chopper_base.png
```

**Boats:**
```
vehicle_speedboat_base.png
vehicle_yacht_base.png
vehicle_cargo_ship_base.png
```

**Aircraft:**
```
vehicle_helicopter_base.png
vehicle_private_jet_base.png
vehicle_cargo_plane_base.png
```

### Overlays

**Condition:**
```
overlay_vehicle_broken.png       # Engine smoking, flat tire
overlay_vehicle_damaged.png      # Dents, scratches
overlay_vehicle_pristine.png     # Shiny, clean
```

**Status:**
```
overlay_vehicle_out_of_fuel.png  # Gas can icon
overlay_vehicle_police.png       # Police lights (if stolen)
overlay_vehicle_custom.png       # Custom paint job
```

---

## 3. Location/Country Assets

### City Backgrounds

Each country has a skyline/landmark background.

```
bg_usa_new_york.jpg
bg_netherlands_amsterdam.jpg
bg_france_paris.jpg
bg_italy_rome.jpg
bg_japan_tokyo.jpg
bg_russia_moscow.jpg
bg_brazil_rio.jpg
bg_uae_dubai.jpg
```

**Size:** 1920x1080 (or 1280x720 for mobile)

### Location Icons

Small icons for map view.

```
icon_location_usa.png
icon_location_netherlands.png
icon_location_france.png
icon_location_italy.png
icon_location_japan.png
icon_location_russia.png
icon_location_brazil.png
icon_location_uae.png
```

**Size:** 64x64

---

## 4. UI Icons

### Status Icons

```
icon_health_full.png         # 100% health
icon_health_high.png         # 75% health
icon_health_medium.png       # 50% health
icon_health_low.png          # 25% health
icon_health_critical.png     # <10% health

icon_hunger_full.png
icon_hunger_empty.png

icon_thirst_full.png
icon_thirst_empty.png

icon_money.png
icon_rank.png
icon_xp.png
icon_level.png
```

**Size:** 32x32 or 64x64

### Action Icons

```
icon_crime.png               # Crime menu
icon_job.png                 # Job menu
icon_travel.png              # Travel menu
icon_hospital.png            # Hospital
icon_bank.png                # Bank
icon_crew.png                # Crew management
icon_vehicle.png             # Vehicle garage
icon_property.png            # Property management
icon_trade.png               # Trading
icon_aviation.png            # Aviation
```

**Size:** 64x64

### Button Icons

```
icon_play.png
icon_pause.png
icon_settings.png
icon_logout.png
icon_profile.png
icon_leaderboard.png
icon_notifications.png
icon_close.png
icon_back.png
icon_forward.png
```

**Size:** 32x32

---

## 5. Crime/Job Icons

Each crime and job type has an icon.

### Crime Icons

```
icon_crime_pickpocket.png
icon_crime_burglary.png
icon_crime_robbery.png
icon_crime_carjacking.png
icon_crime_assault.png
icon_crime_murder.png
icon_crime_arson.png
icon_crime_kidnapping.png
icon_crime_extortion.png
icon_crime_fraud.png
icon_crime_hacking.png
icon_crime_smuggling.png
icon_crime_bank_heist.png
icon_crime_jewelry_heist.png
icon_crime_art_theft.png
```

**Size:** 64x64

### Job Icons

```
icon_job_taxi_driver.png
icon_job_delivery.png
icon_job_security_guard.png
icon_job_waiter.png
icon_job_bartender.png
icon_job_mechanic.png
icon_job_construction.png
icon_job_janitor.png
icon_job_clerk.png
icon_job_salesman.png
```

**Size:** 64x64

---

## 6. Item/Inventory Icons

For tradable goods and consumables.

### Tradable Goods

```
icon_item_contraband_a.png   # Abstract contraband (boxes)
icon_item_contraband_b.png   # Abstract contraband (crates)
icon_item_alcohol.png        # Bottles/barrels
icon_item_luxury_goods.png   # Jewelry, watches
icon_item_electronics.png    # Phones, laptops
```

**Size:** 64x64

### Consumables

```
icon_item_medkit.png
icon_item_food.png
icon_item_water.png
icon_item_weapon.png         # Generic weapon
icon_item_armor.png          # Body armor
```

**Size:** 64x64

---

## 7. Avatar/Profile Images

### Default Avatars

Provide 10-20 default avatars for new players.

```
avatar_default_001.png
avatar_default_002.png
...
avatar_default_020.png
```

**Size:** 128x128, circular crop

**Style:** Silhouettes or simple illustrations (no faces to avoid moderation issues)

---

## 8. Crew/Gang Emblems

### Crew Icons

```
emblem_crew_skull.png
emblem_crew_crown.png
emblem_crew_fist.png
emblem_crew_gun.png
emblem_crew_money.png
emblem_crew_diamond.png
emblem_crew_eagle.png
emblem_crew_lion.png
emblem_crew_wolf.png
emblem_crew_dragon.png
```

**Size:** 128x128

---

## 9. Law Enforcement Assets

### Police/FBI Icons

```
icon_police.png
icon_fbi.png
icon_judge.png
icon_handcuffs.png
icon_wanted.png
icon_jail.png
icon_bail.png
```

**Size:** 64x64

### Wanted Level Indicators

```
icon_wanted_level_1.png      # 1 star
icon_wanted_level_2.png      # 2 stars
icon_wanted_level_3.png      # 3 stars
icon_wanted_level_4.png      # 4 stars
icon_wanted_level_5.png      # 5 stars
```

**Size:** 32x32 (per star)

---

## 10. Notification/Event Icons

For world events feed.

```
icon_event_crime.png
icon_event_death.png
icon_event_arrest.png
icon_event_heist.png
icon_event_crew.png
icon_event_bank_robbery.png
icon_event_flight.png
icon_event_liquidation.png
icon_event_assassination.png
```

**Size:** 48x48

---

## Asset Creation Guidelines

### Style

- **Consistent art style** across all assets (realistic, pixel art, or flat design)
- **Color palette** should be cohesive (e.g., dark noir theme)
- **No copyrighted material** - create original or use royalty-free

### Technical

- **PNG** for transparency (overlays, icons)
- **JPG** for large backgrounds (smaller file size)
- **WebP** for optimized web delivery (optional)
- **Export at 2x resolution** for high-DPI displays (scale down in code)

### Optimization

- Compress PNGs with tools like TinyPNG or ImageOptim
- Keep icon file sizes under 10KB each
- Keep property/vehicle images under 100KB each

---

## Asset Organization

### Directory Structure

```
client/
  assets/
    images/
      properties/
        base/
          property_house_base.png
          property_casino_base.png
          ...
        overlays/
          overlay_damaged_light.png
          overlay_fire.png
          ...
      vehicles/
        base/
          vehicle_sedan_base.png
          vehicle_yacht_base.png
          ...
        overlays/
          overlay_vehicle_broken.png
          ...
      backgrounds/
        bg_usa_new_york.jpg
        bg_netherlands_amsterdam.jpg
        ...
      icons/
        ui/
          icon_health_full.png
          icon_money.png
          ...
        actions/
          icon_crime.png
          icon_job.png
          ...
        items/
          icon_item_contraband_a.png
          ...
      avatars/
        avatar_default_001.png
        ...
      emblems/
        emblem_crew_skull.png
        ...
```

### Flutter Asset Declaration

`client/pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/properties/base/
    - assets/images/properties/overlays/
    - assets/images/vehicles/base/
    - assets/images/vehicles/overlays/
    - assets/images/backgrounds/
    - assets/images/icons/ui/
    - assets/images/icons/actions/
    - assets/images/icons/items/
    - assets/images/avatars/
    - assets/images/emblems/
```

---

## Placeholder Assets (For Development)

During development, use placeholder images:

- **Solid colors** with text labels
- **Simple shapes** (squares, circles) in different colors
- **Free asset packs** from itch.io, OpenGameArt.org

### Example Placeholder

Create a simple colored square with text in GIMP/Photoshop:
- 512x512 px
- Solid color background
- Text: "HOUSE"
- Export as `property_house_base.png`

---

## Asset Loading in Flutter

### Basic Image

```dart
Image.asset('assets/images/properties/base/property_house_base.png')
```

### Overlay Composition

```dart
Stack(
  children: [
    Image.asset('assets/images/properties/base/property_casino_base.png'),
    Image.asset('assets/images/properties/overlays/overlay_upgraded_lvl2.png'),
    Image.asset('assets/images/properties/overlays/overlay_security_camera.png'),
  ],
)
```

### Cached Network Images (If Assets on CDN)

```dart
CachedNetworkImage(
  imageUrl: 'https://cdn.yourdomain.com/properties/property_casino_base.png',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

## Asset Sources (Royalty-Free)

### Free/Open Source

- **OpenGameArt.org** - CC0/CC-BY licensed game assets
- **Kenney.nl** - Free game assets (icons, UI, vehicles)
- **Flaticon.com** - Free icons (attribution required)
- **Unsplash.com** - Free photos for backgrounds

### Paid

- **Unity Asset Store** - 2D/3D game assets
- **Envato Elements** - Subscription-based graphics
- **GraphicRiver** - Individual asset purchases

### Custom Creation

- **Hire artist** on Fiverr, Upwork, ArtStation
- **Create yourself** with GIMP (free), Photoshop, Illustrator

---

## Asset Checklist

### Phase 1: Core UI (Minimum Viable Product)

- [ ] 10 property base images
- [ ] 5 basic overlays (damaged, upgraded, protected)
- [ ] 8 country background images
- [ ] 20 UI icons (health, money, actions)
- [ ] 10 vehicle base images
- [ ] 5 crime icons
- [ ] 5 job icons
- [ ] 5 default avatars

### Phase 2: Full Content

- [ ] 30 crime icons
- [ ] 24 job icons
- [ ] 20 overlay variations
- [ ] 20 vehicle images
- [ ] 10 item icons
- [ ] 10 crew emblems
- [ ] 10 notification icons

### Phase 3: Polish

- [ ] High-res 2x assets
- [ ] Animated overlays (fire, smoke)
- [ ] Sound effects (not images, but related)
- [ ] Loading screen images
- [ ] Tutorial/onboarding graphics

---

## Performance Tips

### Mobile Optimization

- Use **appropriate resolutions** (don't use 4K images on mobile)
- **Compress images** before bundling
- **Lazy load** images not visible on screen
- Use **asset variants** for different screen densities

### Caching

```dart
precacheImage(AssetImage('assets/images/bg_usa_new_york.jpg'), context);
```

Pre-cache critical images on app start to avoid loading delays.

---

## Summary

✅ Base images for all properties, vehicles, locations  
✅ Transparent overlays for state changes (damage, upgrades)  
✅ Icons for all UI elements, actions, items  
✅ Consistent naming convention  
✅ Organized directory structure  
✅ Optimized sizes and formats  

This asset plan provides a complete visual foundation for the game. Start with placeholders, then replace with final art as development progresses.
