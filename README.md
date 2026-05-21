# Mungoum — Calendrier Nguemba

A Flutter app implementing the **Nguemba traditional 8-day cycle calendar** from Bamougoum village, West Region of Cameroon (Bamiléké territory).

---

## Features

- **Today's Nguemba day** — displayed on the home screen with market badge
- **Monthly calendar** — full grid with the Nguemba cycle for every day
- **Day detail** — name, aliases, market status, cultural content
- **The 8 days** — complete cycle reference (Fessâ · Fessap · Scheidâ · Nduchu · Djola'a · Mumetè · Mametè · Kuétsit)
- **FR / EN** — automatic language detection, English fallback
- **Dark mode** — follows system setting
- **100 % offline** — no backend, no API, no data collection

---

## Stack

| | |
|---|---|
| Flutter | 3.27.1 |
| Dart | 3.6.0 |
| Android | AGP 8.3.2 · Gradle 8.7 · Java 17 · Kotlin 1.9.25 |
| Min SDK | Android 5.0 (API 21) |

### Key packages

| Package | Purpose |
|---|---|
| `go_router ^14.6.2` | Navigation — 6 flat routes |
| `google_mobile_ads ^5.1.0` | AdMob banners (Home + Calendar) |
| `flutter_localizations` + `intl ^0.19.0` | FR / EN localization |
| `google_fonts ^6.2.1` | Playfair Display (titles) + Inter (UI) |
| `url_launcher ^6.3.1` | Donation link (About screen) |
| `package_info_plus ^8.0.0` | App version from pubspec |

---

## Calendar Algorithm

Anchor verified against the official Nguemba calendar PDF:

- **2025-01-01 = Fessâ** (index 0)
- Formula: `idx = ((delta % 8) + 8) % 8` where `delta = (date − anchor).inDays`
- The `+8` handles Dart's negative modulo for dates before 2025
- Dates are normalized to UTC midnight before computing delta

### The 8 days

| # | Name | Market |
|---|---|---|
| 1 | Fessâ | — |
| 2 | Fessap | — |
| 3 | Scheidâ (Cheidâ) | Grand Marché |
| 4 | Nduchu | — |
| 5 | Djola'a (Djedjuku'u) | — |
| 6 | Mumetè | — |
| 7 | Mametè | Petit Marché |
| 8 | Kuétsit | — |

---

## Project Structure

```
lib/
  core/
    config/       # AdConfig — test/prod AdMob IDs via kDebugMode
    theme/        # AppColors + buildLightTheme() / buildDarkTheme()
    l10n/         # app_fr.arb, app_en.arb + generated files
    router/       # GoRouter — 6 routes
  data/
    models/       # NguembaDay (const, immutable)
    datasources/  # nguemba_data.dart — 8 days hardcoded
  logic/
    calendar_service.dart   # getDayFor() + getDaysForMonth()
  features/
    splash/       # 3s pulse animation on indigo background
    home/         # Today's day + date + market badge
    calendar/     # Monthly grid — 7-column table, month navigation
    day_detail/   # Day detail (from Calendar or 8 days)
    eight_days/   # The 8-day cycle list
    about/        # App info, donation, credits
  shared/
    widgets/      # AppScaffold, AdBannerWidget, MarketBadgeWidget,
                  # CalendarDayCell
```

---

## Getting Started

```bash
# Working directory: mungoum/mungoum/

# Run on connected device
flutter run

# Run tests (27 tests)
flutter test

# Static analysis
flutter analyze

# Regenerate localization files
flutter gen-l10n

# Build release APKs (split per ABI)
flutter build apk --release --split-per-abi

# Build AAB for Play Store
flutter build appbundle --release
```

### APK sizes (release, split-per-abi)

| ABI | Size |
|---|---|
| arm64-v8a | 11.4 MB |
| armeabi-v7a | 10.9 MB |
| x86_64 | 11.5 MB |

---

## Tests

27 tests, all passing:

| File | Tests |
|---|---|
| `test/logic/calendar_service_test.dart` | 20 — algorithm, cycle, badges, aliases, `getDaysForMonth` |
| `test/widgets/market_badge_test.dart` | 7 — badge display, market exclusivity |

```bash
flutter test
```

---

## AdMob

`AdBannerWidget` manages the `BannerAd` lifecycle (load / dispose). Silent failure if offline.

`AdConfig` selects test or production IDs via `kDebugMode`:

```dart
// Replace before Play Store release:
// android/app/src/main/AndroidManifest.xml — APPLICATION_ID
// lib/core/config/ad_config.dart — bannerAdUnitIdAndroid / bannerAdUnitIdIos
```

Test IDs (development only — never ship these):

```
Android App ID:    ca-app-pub-3940256099942544~3347511713
Android Banner:    ca-app-pub-3940256099942544/6300978111
iOS App ID:        ca-app-pub-3940256099942544~1458002511
iOS Banner:        ca-app-pub-3940256099942544/2934735716
```

---

## Design System

### Palette

| Role | Light | Dark |
|---|---|---|
| Background | `#F8F3E6` cream | `#0D1A3E` deep indigo |
| Surface | `#FFFFFF` white | `#1A2F6E` night indigo |
| Primary | `#1A2F6E` | `#2E4DA0` |
| Accent | `#C4922A` amber gold | `#C4922A` |
| Text | `#1C1C1E` anthracite | `#F8F3E6` cream |

All colors are constants in `AppColors` (`core/theme/app_theme.dart`).

### Typography

- **Titles / app name**: Playfair Display
- **UI / body**: Inter
- **Nguemba day names**: never translated — they are proper nouns

---

## Roadmap

| Phase | Status |
|---|---|
| Phase 1 — Flutter app Android/iOS | Complete (F0–F9 delivered) |
| Phase 2 — Nguemba dictionary (with linguists) | Upcoming |
| Phase 3 — Nguemba language LMS (web + mobile) | Upcoming |

See `F10_PLAY_STORE_GUIDE.md` for Play Store submission steps.

---

## Credits

Developed by **Brightwill LLC**

Calendar source: *Calendrier officiel en langue nguemba* — Bamougoum village, Région de l'Ouest Cameroun.
