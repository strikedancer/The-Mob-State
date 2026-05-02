# Frontend Platform Protocol

## Scope
Gedeelde Flutter web/mobile/PWA shellregels, asset routing, embedded scrollgedrag, image loading, cache/service worker gedrag en platformgevoelige UI-patronen.

## Primary Frontend Entry
- client/lib/config/app_config.dart (`apiBaseUrl`: web gebruikt `WEB_API_BASE_URL` uit dart-define wanneer gezet; zonder override mappen apex `themobstate.com` / `www.themobstate.com` → `https://api.themobstate.com`, anders `${scheme}://${host}:3000` voor lokale dev)
- client/lib/config/supported_languages.dart (centrale player-UI-taalcodes; synchroon met `backend/src/config/supportedLanguages.ts` en `client/lib/l10n/app_*.arb`)
- client/lib/screens/landing_screen.dart (marketing home voor niet-ingelogde gebruikers; `GET /public/home`)
- client/lib/screens/legal_privacy_screen.dart, `legal_terms_screen.dart` en `legal_digital_goods_screen.dart` (juridische teksten volledig uit ARB)
- client/lib/screens/dashboard_screen.dart
- client/lib/utils/web_asset_helper.dart
- client/lib/widgets/overlay_image.dart
- client/lib/screens/help_screen.dart
- client/lib/screens/storage_tab.dart

## Marketing web routes en taal (gast vs ingelogd)
- **Paden (Flutter web):** `/` toont via `AuthWrapper` de `LandingScreen` zolang er geen sessie is; `/login` en `/register` (zelfde scherm met `initialRegister`) blijven beschikbaar voor deep links; op de **landing** openen **Inloggen / Account** een **dialog** met `LoginScreen` (`embeddedModal: true`) i.p.v. alleen te navigeren. Juridisch: `/privacy`, `/terms`, `/digital-goods` (named routes + `_resolveHome` op basis van `Uri.base.path`).
- **Gast-UI-taal:** eerste bezoek: opgeslagen `guest_ui_language_code`, anders browser-/platformtaal gemapt via `SupportedLanguages.resolveFromDeviceLanguage` (fallback `en`); zie `LocaleProvider.initGuestLocale`. Footer-taalwissel op de landing: `persistGuestLocale` (geen servercall).
- **Ingelogde speler:** `LocaleProvider.loadLocale()` na auth (`GET /settings` → `preferredLanguage`); `MaterialApp`-locale volgt `LocaleProvider`.
- Zie ook `marketing-web.md` voor API + SPA-fallback op de backend.

## i18n / meertaligheid (praktisch)
- Player UI gebruikt `client/lib/l10n/app_*.arb` (key-pariteit afdwingen via `node scripts/verify_arb_parity.mjs`).
- Voor initiële, niet-handmatige vertalingen van `app_de/fr/es/it/pl/pt.arb`: gebruik `scripts/translate_app_arb_from_en.mjs` (placeholder-safe).
- Admin dashboard UI-vertalingen worden gegenereerd naar `admin/src/i18n/` via `scripts/build_admin_i18n.mjs`.
- Voor consistente terminologie (bijv. `Crew`, `Nightclub`, `VIP`): pas de conservatieve regels in `scripts/terminology.mjs` toe (wordt door beide scripts gebruikt).
- Dashboard navigatie/quick-actions labels moeten via **AppLocalizations** lopen (dus ARB keys), niet via hardcoded NL/EN strings of `_isNl`/`_tr`-helpers; anders vallen extra talen terug op Engels.
- Voor kleine dialog-buttons/CTA’s in dashboard (bv. `Close`, `View offer`): voeg ook ARB keys toe i.p.v. inline tekst.
- Bij `showDialog(builder: (ctx) => ...)` hoort l10n uit `ctx` te komen (dus `AppLocalizations.of(ctx)`), anders kan de build breken.
- Ook de **dashboard center cards** (stats/economy/ops/notifications panels) moeten volledig via ARB keys; vermijd NL/EN literals zoals “Statistieken”, “Ops Overview”, “Gross income”, enz.
- **Trade / zwarte markt / rugzak-shop / munitiefabriek:** zichtbare tablabels, foutteksten (bijv. niet-ingelogd + token-opslaghint) en shop-UI moeten via ARB lopen (`trade_screen.dart`, `black_market_screen.dart`, `backpack_shop_screen.dart`, `ammo_factory_screen.dart`).
- **Login / registratie (`login_screen.dart`):** op brede schermen staat het formulier **rechts** uitgelijnd (`Alignment` ~0.80–0.94) zodat het niet op de linker artwork valt; de **sticky legal footer** (privacy, **algemene voorwaarden**, digitale goederen, gasttaal, copyright) is dezelfde als op de landing via `GuestLegalFooter` in `Scaffold.bottomNavigationBar`. De **drie policy-links** in die footer openen een **scrollbare dialog** (`showGuestLegalDocumentModal` + gedeelde ARB-body in `legal_marketing_document_body.dart`), geen full-page navigatie. **Registratie** vereist een **vinkje** akkoord met de voorwaarden (`registerTerms*`-ARB); de link opent dezelfde **terms-modal**. Op het **registratieformulier** staat geen terugknop naar inloggen (wel **Account aanmaken** vanaf het inlogscherm); deep link `/login` of sluiten van de landing-modal blijft beschikbaar. Deep links `/privacy`, `/terms`, `/digital-goods` blijven **volledige pagina’s** voor bookmarks/SEO. **Modalmodus** (`embeddedModal`): compacte kaart met sluitknop; na succes roept `onEmbeddedAuthSuccess` de host aan (landing: dialog sluiten + `pushReplacementNamed('/dashboard')`). De **taal-dropdown bij registratie** moet `LocaleProvider.persistGuestLocale` aanroepen zodat `MaterialApp.locale` en alle ARB-teksten (inclusief formulier) **direct** meeschakelen — geen aparte lokale `_selectedLanguage`-status naast de provider.
- Voor dynamische templates (zoals `daily-goals` uit backend): geef voorkeur aan **client-side mapping op goal keys** (`crime_3`, `weekly_job_10`, …) naar ARB-strings, zodat alle EU-locales consistente vertalingen krijgen zonder server-side `titleNl/titleEn` leakage.
- Vehicle Ops labels/chips (Heat/Rep/Hotspot/Crew/Blacklist etc.) horen ook via ARB keys zodat dashboard geen Engels lekt in EU-locales.
- Instellingen (`settings_screen.dart`) bevat veel platform/permission tekst (push status, crypto push/in-app toggles). Ook die moet via ARB keys om EU-locales volledig te ondersteunen.

## Primary Platform/Infra Entry
- client/docker/nginx.conf
- client/web/firebase-messaging-sw.js

## Change Rules
- Houd web, mobiel, tablet en embedded dashboard-shells functioneel gelijk tenzij een verschil expliciet bedoeld is.
- Gebruik gedeelde helpers voor assets, image fallbacks en embedded scrollgedrag; vermijd losse one-off workarounds per scherm.
- Platform-specifieke cache-, service-worker- en asset-routes mogen bestaande deployments niet breken.

## Cross-Module Dependencies
- Garage upgrade API: `POST /garage/upgrade` met `location` en optioneel `garageTrack`: `car` (default) of `motorcycle` — aparte capaciteitslijnen; client toont geen upgrade-knop meer bij max level (5) per track. Backend startup voegt zo nodig `garage_upgrades.track` + index toe en backfillt motor-track zodat deploys zonder handmatige migrate toch veilig opstarten.
- Vehicle Heist / embedded Garage & Marina: theft-cooldown op stelen-CTA’s komt server-side mee via vehicle-ops intelligence (`laneTheftCooldowns`); na een `steal` response moet `params.cooldownRemainingSeconds` worden meegenomen wanneer de server de theft-cooldown zet, zodat de UI de lane-knop onmiddellijk blokkert. Versnellen van de **theft-cooldown met credits** gebeurt via een **bliksem-icoon binnen dezelfde omlijnde stelen-control** naast de timer (`theft_cooldown_steal_control.dart`; lane cards + embedded garage/marina), niet via een full-screen `CooldownOverlay` en niet als losse knop naast een `OutlinedButton` met `onPressed: null` (web). Bevestiging (`AlertDialog` + optioneel “niet meer tonen”) zit in `theft_cooldown_credit_flow.dart` en toont **kosten + creditsaldo**; bij geblokkeerde redeem blijft de dialog zichtbaar met uitleg en uitgeschakelde bevestiging. Voorkeur “dialog overslaan” is `SharedPreferences` + **Instellingen**-schakelaar (titel: stelen-cooldown credits). Redeem-API: zelfde `POST /subscriptions/credits/redeem` met `actionType` `vehicle_theft` / `motorcycle_theft` / `boat_theft` als in de credit shop. Voertuig-Heist toasts voor deze flow gebruiken `showTopRightFromSnackBar` (niet de floating SnackBar onderaan). Na `stealVehicle` mag geen directe `fetchInventory` / succesvolle ops-intel fetch `provider.error` leegmaken vóór de UI de fouttekst toont; gebruik een snapshot of vermijd `_error = null` op intel-success responses die tussen steal en toast lopen. `JailOverlay(embedded: true)` moet bovenaan de zichtbare content blijven (geen `Center` met volledig-schermhoogte in een smalle tab); parent `Positioned.fill` geeft zinvolle `LayoutBuilder`-constraints. In de **dashboard Vehicle Heist**-shell hoort cel-overlay op **`VehicleHeistScreen`** te zitten (`Stack` boven de `NestedScrollView`), niet alleen in embedded garage/marina als body van die scroll: anders eindigt de kaart visueel **onder** het ops-intel-paneel. Embedded `GarageScreen`/`MarinaScreen` zetten `suppressJailOverlay` zodat de parent de overlay toont.
- Blacklist UX: wanneer `GET /vehicles/available/:country` leeg is door een actieve regionale blacklist (zoals havenblokkade), moet de client de **reden + resterende tijd** tonen (geen generieke “geen boten beschikbaar” melding). Endpoint levert daarom `regionalBlacklistByType` mee.
- Dashboard -> Frontend Platform (shell, remount, embedded content)
- Help/Inventory/Storage -> Frontend Platform (scroll- en layoutgedrag)
- Gameplay screens met dynamische afbeeldingen -> Frontend Platform (asset routing en fallbacks)
- Web/PWA deployments -> Frontend Platform (cache, service worker, nginx aliases)

## Must Preserve
- Assets laden robuust op web en mobile zonder stille regressies.
- Embedded screens blijven scrollbaar op touch en pointer devices.
- Service worker en cache gedrag mogen releases niet verbergen.
- Achtergrondafbeeldingen, card-afbeeldingen en dynamische images gebruiken consistente fallbackketens.
- SEO/crawl basisbestanden (robots/sitemap) blijven direct bereikbaar (geen SPA fallback) en SEO landings blijven echte HTML.
- Meertalige SEO: NL/EN landings staan op vaste paden (`/text-based-mafia-game` vs `/en/text-based-mafia-game`, idem `mafia-game`, plus `/en/`) en hebben expliciete nginx routes + hreflang; wijzig dit alleen bewust en update `sitemap.xml` mee.

## Platform Guardrails
- Voor runtime `Image.asset(...)` in Flutter web gebruik standaard keys onder `assets/images/...`.
- Let op web output-pad: assets onder `assets/images/...` landen fysiek onder `assets/assets/images/...`; URL-fallbacks moeten dit canonical pad ondersteunen.
- Gebruik voor brede gameplay image-loading op web een centrale helper of route (`WebAssetHelper.image(...)` of equivalent), niet losse ad-hoc `Image.asset(...)` patterns.
- Voor achtergrondafbeeldingen in kritieke screens: gebruik `Stack + Positioned.fill + helper` in plaats van `DecorationImage(AssetImage(...))` als network fallback nodig is.
- Voor web image helpers met network fallback: probeer meerdere compatibele routes (`images/...` -> `assets/assets/images/...` -> `assets/images/...`) en normaliseer runtime image strings vooraf.
- Productie-nginx moet compatibele alias-routes kunnen bieden voor legacy imagepaden en external image mounts.
- Bij Docker builds waar `assets/images/` is uitgesloten, moeten gedeclareerde assetdirectories vooraf aangemaakt worden.
- Images kunnen runtime extern gemount zijn; deploy-flow moet image sync (`rsync` of equivalent) borgen vóór rebuild.
- Voor hero-banners die ook als externe runtime image bestaan: probeer eerst de externe URL (bijv. `/client/images/...`) en val dan pas terug op de gebundelde asset (`WebAssetHelper.image(...)`), zodat PWA/web caching en nginx image mounts geen lege hero veroorzaken.
- Voor touch-first UI waar typen onhandig is, kun je een on-screen keypad overwegen voor korte codes. Als dat visueel of interactioneel instabiel wordt op web, kies dan voor een standaard invoerveld om regressies te voorkomen.
- Premium/Credits tegelafbeeldingen die regelmatig wijzigen moeten onder externe runtime-opslag blijven (`runtime/client-images/premium_tiles/`) en in de client via `images/premium_tiles/...` worden aangesproken.
- Voor Premium/Credits tegelafbeeldingen op web: gebruik een network fallback-keten met root-candidates (`/images/...`, `/assets/assets/images/...`, `/assets/images/...`) en cache-bust query zodat oudere 404-responses sneller herstellen na image-sync.
- Voor Premium/Credits tegelafbeeldingen op web: geef directe network-load (`Image.network`) de voorkeur boven `Image.asset` fallback om ruis door `assets/assets/...` 404's te voorkomen wanneer images bewust extern gehost worden.
- Bij elke Premium tile refresh moet de client cache-bust versie (`_premiumTilesCacheVersion` in `premium_screen.dart`) worden verhoogd, anders kan browser/PWA nog de vorige set tonen.
- Voor Premium/Credits image-first tiles met weinig overlay-ruimte: toon alleen kernlabels/CTA op de tegel en verplaats uitgebreide uitleg naar een meertalige info-popup (`i`-icoon) met `SafeArea`, clamped afmetingen en scrollfallback.
- Gebruik versie-bestandsnamen of expliciete cache-invalidering bij runtime image updates.
- Voor iOS homescreen/PWA updates: serve `index.html`, `manifest.json`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `firebase-messaging-sw.js` en `main.dart.js` met no-cache/must-revalidate gedrag.
- SEO files (web-root): `robots.txt` + `sitemap.xml` moeten expliciete nginx routes hebben zodat ze niet door `try_files … /index.html` als Flutter shell terugvallen.
- Voor competitieve zoektermen (bv. “mafia game”, “text based mafia game”) is een SPA-only app-shell vaak onvoldoende: gebruik 1–2 statische HTML landings (bijv. `/text-based-mafia-game`, `/mafia-game`) die **niet** naar Flutter shell terugvallen.
- Post-deploy cache-eis: hard refresh en indien nodig service worker unregister bij visuele regressies.
- Custom service workers vallen nooit onder generieke immutable JS caching; geef FCM/service-worker bestanden altijd een expliciete, strengere cache-policy dan normale bundles.
- De web app-shell mag een nieuwe build actief detecteren via een stabiele build-fingerprint en daarna precies één gecontroleerde runtime reset doen: service workers unregisteren, `CacheStorage` legen en hard reloaden. Doe dit alleen bij echte buildwissels, nooit blind op elke load.

## Embedded Scroll & Layout Guardrails
- In embedded dashboard-views moet klik op dezelfde sectie een expliciete remount/refresh triggeren als de UX dat verwacht.
- Gebruik bij mobiele schermen met filters + contentlijsten bij voorkeur één doorlopende verticale scrollcontainer.
- Op mobiel/web-smal mag een sticky player-header bovenaan blijven staan, maar de rest van de pagina moet in één primaire scrollcontainer renderen; embed geen volledige schermen in kleine innerlijke viewport-vensters met aparte scrollbars.
- In `Expanded` contexten heeft `ListView` de voorkeur boven `SingleChildScrollView`.
- Bij `TabBar + TabBarView` schermen: laat elke tabcontent zelf scrollen en voorkom nested scroll conflicts.
- Mobile scroll ergonomie: lange “info panels” (zoals Vehicle Ops Intelligence) mogen op smalle schermen standaard ingeklapt zijn (dropdown) zodat primaire acties en content sneller in beeld komen; behoud wel een compacte samenvatting in de header.
- Snackbars/toasts voor gameplay-acties gebruiken bij voorkeur de top-right overlay helper (`showTopRightFromSnackBar`) zodat feedback niet onderin de layout verdwijnt op web/embedded shells.
- For touch-first UI where typing is awkward, consider an on-screen numeric keypad for short codes (e.g. vault PIN entry). Keep it responsive: docked on wide screens and stacked on narrow screens.
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
