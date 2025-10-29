# Liberator Stock Trading App

A modern Flutter-based stock trading application designed for the Thai market, featuring an intuitive interface for monitoring market data, executing trades, tracking portfolios, and staying informed about market news.

## Features

### 🏠 Home (Calendar)

- Interactive calendar with corporate action events
- Orange dot indicators for dividend payment dates
- Today's events list with XD badges for stocks
- Real-time SET index display

### 💰 Buy & Sell

- Market toggle (Thai Stock, US Stock, Mutual Fund)
- Buy/Sell trading panel with order entry form
- Stock search with autocomplete
- Real-time stock price display with High/Low/Ceiling/Floor
- 5-level and 10-level order book display
- Bid/Ask visualization with color-coded prices

### 📊 Portfolio

- Holdings table with sortable columns (Symbol, In Port, Avg, Market, %U.P.L)
- Real-time profit/loss calculation
- Portfolio tabs (Portfolio, Order, Summary)
- Share functionality
- Empty state for new users

### 📰 Content

- News feed with Thai articles
- Three content tabs (Popular, Breaking, Research)
- Time-ago timestamps
- Pull-to-refresh functionality
- Search capability

### ⚙️ Settings (You)

- Language switcher (English/Thai)
- Dark theme toggle
- Order entry settings
- E-Service access
- Contact us
- Privacy & Policy
- Sign out with confirmation

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod 2.6.1
- **Navigation:** GoRouter 12.1.3
- **Storage:**
  - SharedPreferences 2.5.3 (preferences)
  - FlutterSecureStorage 9.2.4 (credentials)
- **Calendar:** TableCalendar 3.2.0
- **Localization:** flutter_localizations, intl 0.20.2
- **UI/UX:**
  - FlutterAnimate 4.5.2
  - CachedNetworkImage 3.4.1
  - FlutterSvg 2.2.1

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget with routing
├── core/
│   ├── constants/           # Colors, text styles, dimensions
│   ├── theme/              # Dark/light theme configuration
│   └── utils/              # Formatters, validators
├── data/
│   ├── models/             # User, Stock, Portfolio, etc.
│   ├── repositories/       # Mock data repository
│   └── services/           # Storage service
├── presentation/
│   ├── screens/            # All app pages
│   ├── widgets/            # Reusable widgets
│   └── providers/          # Riverpod state providers
└── localization/           # English & Thai translations
```

## Setup & Installation

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.x
- Xcode (for iOS)
- Android Studio (for Android)

### Installation Steps

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd lib_light_ai
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # For iOS
   flutter run -d ios

   # For Android
   flutter run -d android

   # For Chrome (web)
   flutter run -d chrome
   ```

## Mock Data

The app currently uses mock data for all features:

- User session: Account `70426672(C)`
- Market data: SET index with realistic values
- Stock quotes: Thai stock symbols (A, NVDR, PTT, KBANK, etc.)
- Order book: 5-10 levels of bid/ask data
- Calendar events: October 2025 with dividend dates
- News articles: Thai financial news with timestamps

## Localization

The app supports two languages:

- **English (en)** - Default
- **Thai (th)** - ภาษาไทย

Switch languages in Settings → Language

## Theme

- **Dark Theme** (Default): Dark navy background with blue accents
- **Light Theme**: Used for Settings page, white background

Toggle dark theme in Settings → Dark Theme

## Authentication

Mock authentication is currently enabled:

- Auto-login after splash screen
- "Remember Me" functionality
- Stored credentials in secure storage
- Logout clears all stored data

## State Management

The app uses Riverpod for state management with the following providers:

- `authProvider` - User authentication state
- `settingsProvider` - Language and theme preferences
- `marketDataProvider` - SET index and market status
- `stockProvider` - Selected stock and order book
- `portfolioProvider` - Portfolio holdings
- `calendarProvider` - Calendar events
- `newsProvider` - News articles

## Key Features Implementation

### Navigation

- Bottom navigation bar with 5 tabs
- GoRouter for declarative routing
- Tab state preservation
- Deep linking support

### Data Persistence

- Secure credential storage
- Language preference storage
- Theme preference storage
- Last viewed tab storage

### Animations

- Page transitions: 300ms ease-in-out
- Button interactions: Scale animation
- List staggered fade-in
- Pull-to-refresh indicator

## Testing

Run tests with:

```bash
flutter test
```

Run analysis:

```bash
flutter analyze
```

## Building for Production

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Known Limitations (Phase 1)

- Mock data only (no real API integration)
- Portrait orientation only
- Light theme only (except Settings page uses light theme even in dark mode)
- No order execution functionality
- No real-time data updates
- No push notifications

## Future Enhancements (Phase 2+)

- [ ] REST API integration
- [ ] Real-time WebSocket data updates
- [ ] Actual order execution
- [ ] Biometric authentication
- [ ] Push notifications
- [ ] Charts and technical indicators
- [ ] Watchlists
- [ ] Stock alerts
- [ ] Social features

## License

[Add license information]

## Contact

[Add contact information]

---

**Version:** 1.0.0+1
**Last Updated:** October 2025
