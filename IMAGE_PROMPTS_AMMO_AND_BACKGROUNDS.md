# Image Prompts voor ChatGPT - Ammo & Backgrounds

## 📦 AMMO AFBEELDINGEN
**Locatie:** `client/assets/ammo/`
**Stijl:** Realistisch, top-down view, heldere achtergrond, object centraal gepositioneerd
**Formaat:** PNG met transparante achtergrond, 512x512px

---

### 1. 9mm Patronen
**Bestand:** `9mm.png`

```
Create a top-down view image of a box of 9mm ammunition. Show a cardboard ammunition box partially open with brass 9mm cartridges visible inside, arranged in neat rows. The cartridges should have copper-colored brass casings with visible hollow-point bullets. Include "9mm" text on the box. Realistic style, clean background, good lighting showing metallic shine on the bullets. PNG format with transparent background, 512x512 pixels.
```

---

### 2. .45 ACP Patronen
**Bestand:** `45acp.png`

```
Create a top-down view image of .45 ACP ammunition. Show a robust cardboard ammo box with larger .45 caliber cartridges visible. The bullets should be noticeably thicker than 9mm, with brass casings and lead round-nose bullets. Include ".45 ACP" text on the box. Realistic military-style packaging. PNG format with transparent background, 512x512 pixels.
```

---

### 3. 12 Gauge Shotgun Shells
**Bestand:** `12gauge.png`

```
Create a top-down view image of 12 gauge shotgun shells in a box. Show red plastic shotgun shells with brass bases, arranged in a cardboard or plastic tray. The shells should be chunky and distinctive with visible "12 GA" markings on the red plastic hulls. Show multiple shells standing upright in organized rows. Realistic hunting/tactical style. PNG format with transparent background, 512x512 pixels.
```

---

### 4. 5.56mm Patronen
**Bestand:** `556mm.png`

```
Create a top-down view image of 5.56mm NATO ammunition. Show a military-style green ammunition can or cardboard box with 5.56mm rifle cartridges. The bullets should be smaller rifle rounds with pointed full metal jacket bullets and brass casings. Include "5.56mm NATO" or "5.56x45" text. Military tactical style packaging. PNG format with transparent background, 512x512 pixels.
```

---

### 5. 7.62mm Patronen
**Bestand:** `762mm.png`

```
Create a top-down view image of 7.62mm rifle ammunition. Show a surplus military-style ammo can or crate with larger 7.62mm cartridges (7.62x39 or 7.62x51). The bullets should be longer and more robust than 5.56mm, with steel or brass casings visible. Show ammunition arranged in neat rows or on stripper clips. Include "7.62mm" markings. Military surplus aesthetic. PNG format with transparent background, 512x512 pixels.
```

---

### 6. .308 Winchester
**Bestand:** `308.png`

```
Create a top-down view image of .308 Winchester sniper ammunition. Show a premium ammunition box with high-quality .308 Win cartridges. These should be precision rifle rounds with boat-tail hollow-point or match-grade bullets, brass casings with visible shine. The packaging should look more premium/professional than military surplus. Include ".308 Win" or ".308 Winchester" text. PNG format with transparent background, 512x512 pixels.
```

---

## 🏪 WEAPON SHOP ACHTERGROND
**Locatie:** `client/images/backgrounds/`
**Bestand:** `weapon_shop_bg.png`
**Formaat:** 1920x1080px (landscape)

```
Create a dark, atmospheric background image for an underground black market weapon shop interface. Show a dimly lit industrial warehouse or basement with concrete walls and metal shelving in the background (blurred/out of focus). Include mood lighting with dramatic shadows, perhaps some neon accent lights (red/orange glow). The atmosphere should be gritty and urban, like an illegal arms dealer's hideout. Add subtle details like weapon silhouettes on wall racks, ammo crates in corners, but keep them blurred so they don't interfere with UI elements. Dark tones: blacks, grays, with warm accent lighting. Make sure the center area is relatively clear for UI overlays. 1920x1080 pixels, PNG format.
```

---

## 🏭 AMMO FACTORY ACHTERGROND
**Locatie:** `client/images/backgrounds/`
**Bestand:** `ammo_factory_bg.png`
**Formaat:** 1920x1080px (landscape)

```
Create a background image for an ammunition manufacturing facility interface. Show an industrial factory floor with heavy machinery for bullet manufacturing - metal presses, conveyor belts, and ammunition sorting equipment. The scene should have industrial/mechanical atmosphere with metal textures, steel machinery parts, and perhaps some sparks from metalworking. Use darker industrial color palette: steel grays, dark blues, with orange/yellow accent lighting from machinery and work lights. Include stacks of ammo crates and metal containers in the background (blurred). Keep the composition balanced with clear space in center for UI elements. Industrial, mechanical, professional manufacturing vibe. 1920x1080 pixels, PNG format.
```

---

## 🎯 SHOOTING RANGE ACHTERGROND (BONUS)
**Locatie:** `client/images/backgrounds/`
**Bestand:** `shooting_range_bg.png`
**Formaat:** 1920x1080px (landscape)

```
Create a background image for an indoor shooting range training facility. Show a professional shooting range with concrete walls, target lanes extending into the distance, and overhead fluorescent lighting creating dramatic shadows. Include shooting booth dividers and distant paper/steel targets (blurred). The atmosphere should be clean but intense - professional firearms training facility. Color palette: concrete grays, black lane dividers, with bright overhead lighting. Add subtle details like brass shell casings on the floor, ear protection hanging on hooks, but keep background elements soft focus so UI elements remain clear. Center area should be clear for overlays. 1920x1080 pixels, PNG format.
```

---

## 📝 IMPLEMENTATIE NOTES

### Ammo Images in Code:
De ammo afbeeldingen kunnen gebruikt worden in:
- `client/lib/screens/ammo_market_screen.dart` (market tab)
- `client/lib/screens/ammo_factory_screen.dart` (production display)

Voorbeeld gebruik:
```dart
Image.asset(
  'assets/ammo/${ammoType}.png',
  width: 64,
  height: 64,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.circle, size: 64, color: Colors.amber);
  },
)
```

### Background Images in Code:
Achtergronden kunnen toegevoegd worden als decoration in Scaffold of Container:

```dart
Scaffold(
  body: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/backgrounds/weapon_shop_bg.png'),
        fit: BoxFit.cover,
        opacity: 0.3, // Maak donkerder voor betere UI leesbaarheid
      ),
    ),
    child: YourContent(),
  ),
)
```

---

## 🎨 ALTERNATIEVE STIJL OPTIES

Als je een meer **stylized/game-art** stijl wilt in plaats van realistisch, voeg dit toe aan elke prompt:
```
Style: digital game art, slightly stylized but recognizable, vibrant colors, cel-shaded look similar to Borderlands or modern mobile games.
```

Voor een **pixel-art retro** stijl:
```
Style: 32x32 or 64x64 pixel art, retro 16-bit game aesthetic, limited color palette, clean pixel work.
```

---

**Totaal benodigde afbeeldingen:**
- ✅ 6 ammo iconen
- ✅ 3 achtergrond images (weapon shop, ammo factory, shooting range)

**Na genereren:** Plaats de files in de juiste folders en test in de Flutter app!
