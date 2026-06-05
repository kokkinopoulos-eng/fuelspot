# FUELSPOT - Handoff Prompt v1.0

## Ποιος είμαι
Ο χρήστης είναι ο Κοκκινόπουλος Χαράλαμπος (BabKok), multi-domain IT professional και Flutter developer. 
Επικοινωνεί στα **ελληνικά**. Είναι έμπειρος — μην εξηγείς τα αυτονόητα.

## Κανόνες επικοινωνίας
- **Ένα βήμα τη φορά** — δίνεις ΜΟΝΟ την επόμενη εντολή, περιμένεις αποτέλεσμα, μετά συνεχίζεις
- **Πάντα `flutter analyze` πριν `flutter run`** — φιλτράρεις με `Select-String "error|warning"`
- **Scripts σε αρχεία** (`Set-Content -Path "C:\dev\fixN.py"`) — ΟΧΙ inline Python με `-c`
- **PowerShell heredoc** για Dart αρχεία (`Set-Content ... @'...'@`)
- **Backup πριν μεγάλες αλλαγές**: `git add -A && git commit -m "..."`
- Αν κάτι δεν πιάσει (Found: False), δες πρώτα το αρχείο πριν ξαναπροσπαθήσεις

## Το Project: FuelSpot
**Flutter app** — Δωρεάν Android app εύρεσης πρατηρίων καυσίμων για την Ελλάδα

### Paths
- **Dev**: `C:\dev\fuelspot`
- **Backup**: `G:\My Drive\AI\FuelSpot`
- **GitHub**: `kokkinopoulos-eng/fuelspot` (private)
- **Package**: `gr.webdevelopment.fuelspot`
- **Test device**: Samsung S25 Ultra

### Stack
- Flutter 3.44.0, Dart 3.12.0
- Provider + Dio + Hive + Geolocator + flutter_map + url_launcher
- AGP 8.11.1, Kotlin 2.2.20, Java 21

### Αρχιτεκτονική
```
lib/
├── core/
│   ├── api/
│   │   ├── fuel_api_client.dart   — OSM Overpass API + mock fallback
│   │   └── location_service.dart  — GPS
│   ├── data/
│   │   └── nomos_prices.dart      — Μέσες τιμές 51 νομών (PDF ΥΠΑΝ 02/06/2026)
│   ├── models/station.dart        — Station model (operator, phone, openingHours)
│   └── repositories/fuel_repository.dart — Haversine + sorting
├── features/
│   ├── list/list_screen.dart      — Κύρια λίστα πρατηρίων
│   ├── detail/station_detail_screen.dart — Καρτέλα + flutter_map + brand colors
│   ├── prices/prices_screen.dart  — Μέσες τιμές νομών + φθηνότερος/ακριβότερος
│   └── map/map_screen.dart        — Χάρτης (stub)
└── shared/
    ├── theme/
    │   ├── app_theme.dart
    │   └── brand_colors.dart      — BrandTheme για EKO/BP/Shell/ΕΤΕΚΑ κλπ
    └── widgets/
        ├── widgets.dart           — StationCard, PriceBadge, FuelTypeSelector, LocationBar
        ├── brand_logo.dart        — Brand logos
        ├── nomos_panel.dart       — Collapsible panel μέσης τιμής νομού
        └── bg_scaffold.dart       — BgScaffold με background image
```

### Δεδομένα (Layer System)
- **Layer 1 (LIVE)**: OpenStreetMap Overpass API → κοντινά πρατήρια + μέση τιμή νομού από hardcoded PDF data
- **Layer 2 (HIDDEN)**: `_realApiEnabled = false` — θα ενεργοποιηθεί όταν έρθει απάντηση από ΥΠΑΝ
- **Overpass servers**: overpass-api.de → lz4 → z → kumi.systems (fallback chain)
- **Sorting**: by απόσταση (όταν prices == {})
- **Fallback**: mock 3 stations αν όλοι οι servers πέσουν

### Navigation
- **Bottom nav** 3 tabs: Πρατήρια / Τιμές / Χάρτης
- **Splash screen**: Custom Flutter (2.5s) με icon + "FuelSpot" (Spot κίτρινο) + progress indicator

### Assets
- `assets/icon/icon.png` — App icon (μπλε, τρέχον)
- `assets/bg.png` — Background screens (πράσινο)
- Flutter launcher icons + native splash configured

### Pending tasks
1. ✅ OSM stations με διευθύνσεις
2. ✅ Brand colors στην καρτέλα
3. ✅ Πλησιέστερο πρώτο
4. ✅ Μέσες τιμές νομού panel + tab
5. ✅ flutter_map στην καρτέλα πρατηρίου
6. ⏳ bg.png να εμφανίζεται στα screens (BgScaffold έτοιμο, να εφαρμοστεί)
7. ⏳ App icon cache issue — uninstall+reinstall λύνει
8. ⏳ Όροι χρήσης (first-launch dialog)
9. ⏳ AI insights panel redesign
10. ⏳ Closed testing (12 άτομα) στο Play Console
11. ⏳ ΥΠΑΝ email απάντηση (fuelprices@mindev.gov.gr) για πραγματικές τιμές

### Επικοινωνία με ΥΠΑΝ
Εστάλη email για επίσημη πρόσβαση στα δεδομένα ανά πρατήριο — αναμένεται απάντηση.

### Σημαντικές αποφάσεις
- ΟΧΙ scraping (reCAPTCHA/Cloudflare παντού)
- ΟΧΙ δικό μας token/server — αναμονή ΥΠΑΝ
- Τιμές στις κάρτες: ΚΡΥΦΕΣ (Layer 2) — φαίνεται μόνο απόσταση
- ΕΤΕΚΑ = δικό brand (ΟΧΙ Shell)
