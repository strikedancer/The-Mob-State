# Drug Item Images + Facility — Leonardo.ai Prompts

**Model:** Leonardo Phoenix 1.0  
**Format:** PNG, transparent background (RGBA)  
**Size:** 512x512px (in-game display: 40–80px, maar hoge res voor kwaliteit)  
**Output directory drugs:** `client/assets/images/drugs/`  
**Output directory facilities:** `client/assets/images/facilities/`

Bestaande referentie-stijl: `client/assets/images/drugs/cocaine.png`, `white_widow.png`  
— Realistische fotografie-stijl, donkere achtergrond of transparant, hoge contrast, game-UI geschikt.

---

## 1. HASH — `hash.png`

**Bestandsnaam:** `hash.png`

**Prompt:**
A dark golden-brown compressed hashish brick, slightly textured surface with natural resin marks and pressed patterns. Soft warm studio lighting from above, isolated on pure black background. Photorealistic, high detail macro photography style, no packaging, no labels. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Drug object only, centered, no shadow outside object silhouette.

**Negative:** white background, packaging, label, text, people, hands, table surface, shadow outside object

---

## 2. MAGIC MUSHROOMS — `magic_mushrooms.png`

**Bestandsnaam:** `magic_mushrooms.png`

**Prompt:**
A cluster of dried psilocybin mushrooms (Psilocybe cubensis), earthy golden-brown caps with pale stems, slight iridescent shimmer suggesting psychedelic potency. Macro photography style, isolated on pure black background, photorealistic, high detail, natural textures. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Mushroom cluster only, centered, no table or surface shown.

**Negative:** white background, packaging, label, text, people, table, grass, soil visible

---

## 3. LSD — `lsd.png`

**Bestandsnaam:** `lsd.png`

**Prompt:**
A small blotter paper sheet with subtle geometric psychedelic print patterns in blue and purple tones, showing perforated tabs on a small square. Slightly iridescent surface. Macro photography, photorealistic, isolated on pure black background. Hint of blue glow suggesting chemical potency. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Blotter paper only, centered.

**Negative:** white background, people, hands, syringes, pill bottle, table, shadow extending outward

---

## 4. CRYSTAL METH — `crystal_meth.png`

**Bestandsnaam:** `crystal_meth.png`

**Prompt:**
A small pile of blue-white crystalline methamphetamine shards, sharp angular facets catching light with an icy blue shimmer. Macro photography style, photorealistic, extremely high detail, isolated on pure black background. Cold clinical aesthetic. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Crystal pile only, centered, no surface or reflection outside object.

**Negative:** white background, packaging, people, hands, text, table surface, warm tones

---

## 5. FENTANYL — `fentanyl.png`

**Bestandsnaam:** `fentanyl.png`

**Prompt:**
A small precise heap of ultra-fine white pharmaceutical powder, slightly luminescent, almost glowing under clinical studio light. Pure white dusty texture with subtle crystalline shimmer. Photorealistic macro, extremely clean and clinical aesthetic, isolated on pure black background. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Powder heap only, centered.

**Negative:** white background, packaging, pills, syringes, people, hands, table, warm tones

---

## 6. MUSHROOM FARM FACILITY — `facility_mushroom_farm.png`

**Bestandsnaam:** `facility_mushroom_farm.png`

**Prompt:**
A dark moody underground mushroom cultivation room, rows of wooden substrate shelves with glowing bioluminescent mushrooms in purple and blue hues, hanging drip tubes, misty humidity in the air, dimly lit grow lamps above. Isometric game-icon style, ultra-detailed, cinematic lighting, dark criminal underworld atmosphere. 512x512.

CRITICAL: True RGBA PNG. Background = fully transparent (alpha 0). Scene contained within a clear boundary, no fade or vignette edges.

**Negative:** white background, vignette, gradient background, outdoor, daylight

---

## Inlaadinstructies na generatie

1. Exporteer als **PNG met echte transparantie** (geen witte achtergrond!)
2. Gebruik Leonardo's **Remove Background** tool indien nodig
3. Hernoem exact naar de bestandsnaam hierboven
4. Sla op in de juiste map (`drugs/` of `facilities/`)
5. De app gebruikt automatisch de fallback-icon als het bestand ontbreekt, dus je kunt per drug individueel uploaden

**Aanbevolen volgorde:** hash → magic_mushrooms → lsd → crystal_meth → fentanyl → facility_mushroom_farm
