# Frontend Platform Protocol

## Scope
Gedeelde Flutter web/mobile/PWA shellregels, asset routing, embedded scrollgedrag, image loading, cache/service worker gedrag en platformgevoelige UI-patronen.

## Primary Frontend Entry
- client/lib/screens/dashboard_screen.dart
- client/lib/utils/web_asset_helper.dart
- client/lib/widgets/overlay_image.dart
- client/lib/screens/help_screen.dart
- client/lib/screens/storage_tab.dart

## Primary Platform/Infra Entry
- client/docker/nginx.conf
- client/web/firebase-messaging-sw.js

## Change Rules
- Houd web, mobiel, tablet en embedded dashboard-shells functioneel gelijk tenzij een verschil expliciet bedoeld is.
- Gebruik gedeelde helpers voor assets, image fallbacks en embedded scrollgedrag; vermijd losse one-off workarounds per scherm.
- Platform-specifieke cache-, service-worker- en asset-routes mogen bestaande deployments niet breken.

## Cross-Module Dependencies
- Dashboard -> Frontend Platform (shell, remount, embedded content)
- Help/Inventory/Storage -> Frontend Platform (scroll- en layoutgedrag)
- Gameplay screens met dynamische afbeeldingen -> Frontend Platform (asset routing en fallbacks)
- Web/PWA deployments -> Frontend Platform (cache, service worker, nginx aliases)

## Must Preserve
- Assets laden robuust op web en mobile zonder stille regressies.
- Embedded screens blijven scrollbaar op touch en pointer devices.
- Service worker en cache gedrag mogen releases niet verbergen.
- Achtergrondafbeeldingen, card-afbeeldingen en dynamische images gebruiken consistente fallbackketens.

## Platform Guardrails
- Voor runtime `Image.asset(...)` in Flutter web gebruik standaard keys onder `assets/images/...`.
- Let op web output-pad: assets onder `assets/images/...` landen fysiek onder `assets/assets/images/...`; URL-fallbacks moeten dit canonical pad ondersteunen.
- Gebruik voor brede gameplay image-loading op web een centrale helper of route (`WebAssetHelper.image(...)` of equivalent), niet losse ad-hoc `Image.asset(...)` patterns.
- Voor achtergrondafbeeldingen in kritieke screens: gebruik `Stack + Positioned.fill + helper` in plaats van `DecorationImage(AssetImage(...))` als network fallback nodig is.
- Voor web image helpers met network fallback: probeer meerdere compatibele routes (`images/...` -> `assets/assets/images/...` -> `assets/images/...`) en normaliseer runtime image strings vooraf.
- Productie-nginx moet compatibele alias-routes kunnen bieden voor legacy imagepaden en external image mounts.
- Bij Docker builds waar `assets/images/` is uitgesloten, moeten gedeclareerde assetdirectories vooraf aangemaakt worden.
- Images kunnen runtime extern gemount zijn; deploy-flow moet image sync (`rsync` of equivalent) borgen vóór rebuild.
- Premium/Credits tegelafbeeldingen die regelmatig wijzigen moeten onder externe runtime-opslag blijven (`runtime/client-images/premium_tiles/`) en in de client via `images/premium_tiles/...` worden aangesproken.
- Voor Premium/Credits tegelafbeeldingen op web: gebruik een network fallback-keten met root-candidates (`/images/...`, `/assets/assets/images/...`, `/assets/images/...`) en cache-bust query zodat oudere 404-responses sneller herstellen na image-sync.
- Voor Premium/Credits tegelafbeeldingen op web: geef directe network-load (`Image.network`) de voorkeur boven `Image.asset` fallback om ruis door `assets/assets/...` 404's te voorkomen wanneer images bewust extern gehost worden.
- Bij elke Premium tile refresh moet de client cache-bust versie (`_premiumTilesCacheVersion` in `premium_screen.dart`) worden verhoogd, anders kan browser/PWA nog de vorige set tonen.
- Voor Premium/Credits image-first tiles met weinig overlay-ruimte: toon alleen kernlabels/CTA op de tegel en verplaats uitgebreide uitleg naar een meertalige info-popup (`i`-icoon) met `SafeArea`, clamped afmetingen en scrollfallback.
- Gebruik versie-bestandsnamen of expliciete cache-invalidering bij runtime image updates.
- Voor iOS homescreen/PWA updates: serve `index.html`, `manifest.json`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `firebase-messaging-sw.js` en `main.dart.js` met no-cache/must-revalidate gedrag.
- Post-deploy cache-eis: hard refresh en indien nodig service worker unregister bij visuele regressies.
- Custom service workers vallen nooit onder generieke immutable JS caching; geef FCM/service-worker bestanden altijd een expliciete, strengere cache-policy dan normale bundles.
- De web app-shell mag een nieuwe build actief detecteren via een stabiele build-fingerprint en daarna precies één gecontroleerde runtime reset doen: service workers unregisteren, `CacheStorage` legen en hard reloaden. Doe dit alleen bij echte buildwissels, nooit blind op elke load.

## Embedded Scroll & Layout Guardrails
- In embedded dashboard-views moet klik op dezelfde sectie een expliciete remount/refresh triggeren als de UX dat verwacht.
- Gebruik bij mobiele schermen met filters + contentlijsten bij voorkeur één doorlopende verticale scrollcontainer.
- Op mobiel/web-smal mag een sticky player-header bovenaan blijven staan, maar de rest van de pagina moet in één primaire scrollcontainer renderen; embed geen volledige schermen in kleine innerlijke viewport-vensters met aparte scrollbars.
- In `Expanded` contexten heeft `ListView` de voorkeur boven `SingleChildScrollView`.
- Bij `TabBar + TabBarView` schermen: laat elke tabcontent zelf scrollen en voorkom nested scroll conflicts.
- Voeg geen extra `ScrollConfiguration` toe aan child-content als parent embedded gedrag al afhandelt.
- Nieuwe en aangepaste overlays/dialogs/modals moeten `SafeArea`, clamped breedte/hoogte en een scrollfallback voor kleine viewports hebben; kritieke CTA's mogen op mobiel of embedded layouts niet buiten beeld vallen.
- Geef gedeelde overlay- en dialogcomponenten de voorkeur boven scherm-specifieke fixed-width `AlertDialog` implementaties wanneer hetzelfde patroon op meerdere screens terugkomt.

## QA Checklist
1. Controleer web, mobiel en embedded dashboard-weergave.
2. Controleer asset loading met helper fallback en errorBuilder gedrag.
3. Verifieer dat service worker/cache een nieuwe release niet maskeert, inclusief `firebase-messaging-sw.js` naast `flutter_service_worker.js`.
4. Verifieer dat een open mobiele/PWA sessie een nieuwe build detecteert, caches precies één keer reset en daarna op de nieuwe shell uitkomt zonder reload-loop.
5. Verifieer scrollgedrag in minimaal één embedded en één standalone screen.
6. Verifieer dat kritieke achtergrond- en catalogusafbeeldingen blijven laden op web.

## When To Update This File
Update bij nieuwe gedeelde web/mobile/PWA regels, asset loading changes, embedded shellpatronen of cache/service worker risico's.
