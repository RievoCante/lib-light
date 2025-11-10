# Liberator Stock Trading App

A modern Flutter-based stock trading application designed for the Thai market, featuring an intuitive interface for monitoring market data, executing trades, tracking portfolios, and staying informed about market news.

## Features

### 🏠 Home (Calendar)

- Interactive calendar with corporate action events
- Orange dot indicators for dividend payment dates
- Today's events list with XD badges for stocks
- Real-time SET index display

### 💰 Buy & Sell

- Beginner-friendly interface inspired by Binance Lite
- Three market tabs (Thai Stock, US Stock, Mutual Fund)
- Clean stock list view with symbol, full name, short name
- Real-time price display with percentage change indicators
- Stock search functionality
- Simplified stock detail page with:
  - Large price display and 24h change
  - Simple price chart visualization
  - Current holdings information
  - Expandable "About" section with More/Less toggle
  - Quick Buy/Sell action buttons
  - Resource links (website, whitepaper)

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
- Register button (opens webview for account registration)
- Contact us
- Privacy & Policy
- Sign out with confirmation

### 🔔 Notifications

- Bell icon in header with unread count badge
- Notification list with icons and timestamps
- Unread/read status indicators
- Notification detail page with full message content
- Time-based formatting (Today, Yesterday, Date)

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod 2.6.1
- **Navigation:** GoRouter 12.1.3
- **Storage:**
  - SharedPreferences 2.5.3 (preferences)
  - FlutterSecureStorage 9.2.4 (credentials)
- **Calendar:** TableCalendar 3.2.0
- **Localization:** flutter_localizations, intl 0.20.2
- **Webview:** webview_flutter 4.10.0
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
- Login credentials: ID `2525314`, Password `Welcome00`
- Market data: SET index with realistic values
- Stock quotes: Thai stock symbols (PTT, KBANK, AOT, CPALL, etc.)
- Stock list: 10 Thai stocks with real symbols and mock prices
- Calendar events: October 2025 with dividend dates
- News articles: Thai financial news with timestamps
- Notifications: 5 sample notifications (stock changes, market updates, alerts)

## Localization

The app supports two languages:

- **English (en)** - Default
- **Thai (th)** - ภาษาไทย

Switch languages in Settings → Language

## Theme

- **Light Theme** (Default): White background with dark text for optimal readability
- **Dark Theme**: Dark navy background with blue accents

Toggle between themes in Settings → Dark Theme

## Authentication

Mock authentication is currently enabled:

- Login page with username/password form
- Demo credentials: ID `2525314`, Password `Welcome00`
- "Remember Me" functionality
- Stored credentials in secure storage
- Input validation and error messages
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
- `notificationProvider` - Notification list and unread count

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

### Quick Build (Recommended)

Use the provided build scripts in the `scripts/` folder:

```bash
# Build Android APK
./scripts/build-android.sh

# Build iOS IPA (macOS only)
./scripts/build-ios.sh

# Distribute Android via Firebase
./scripts/distribute-android.sh
```

See [scripts/README.md](scripts/README.md) for detailed documentation.

### Manual Build

#### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

## Known Limitations (Phase 1)

- Mock data only (no real API integration)
- Portrait orientation only
- No order execution functionality
- No real-time data updates
- No push notifications (in-app notifications only)
- US Stock and Mutual Fund tabs use same mock data as Thai Stock

## License

[Add license information]

---

**Last Updated:** 4 November 2025
