# Liberator Stock Trading App

A modern Flutter-based stock trading application designed for the Thai market, featuring Firebase authentication, real-time chat support, and an intuitive interface for monitoring market data, executing trades, tracking portfolios, and staying informed about market news.

## Features

### 🔐 Authentication

- **Email/Password:** Sign up and login with email
- **Google Sign-In:** One-tap Gmail authentication
- **Phone Authentication:** SMS verification for phone number login
- **Password Reset:** Email-based password recovery
- **Remember Me:** Session persistence option

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
- Simplified stock detail page with price charts, holdings, and order entry

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

### 💬 Support Chat

- Real-time messaging via Firebase Firestore
- FAQ questions (sends question as message)
- Recent Orders button
- Auto-scroll on new messages
- Admin can reply via Firebase Console or admin panel

### ⚙️ Settings (You)

- Language switcher (English/Thai)
- Dark theme toggle
- Order entry settings
- E-Service access
- Register button (opens webview for account registration)
- Contact Us (navigates to support chat)
- Privacy & Policy (markdown-based, language-specific)
- Sign out with confirmation

### 🔔 Notifications

- Bell icon in header with unread count badge
- Notification list with icons and timestamps
- Unread/read status indicators
- Notification detail page with full message content
- Time-based formatting (Today, Yesterday, Date)

## Tech Stack

- **Framework:** Flutter 3.9.2+
- **State Management:** Riverpod 2.4.0
- **Navigation:** GoRouter 12.0.0
- **Backend:**
  - Firebase Core 4.2.0
  - Firebase Auth 6.1.1 (Email, Google, Phone)
  - Cloud Firestore 6.0.3 (Real-time database)
  - Google Sign-In 6.2.1
- **Storage:**
  - SharedPreferences 2.2.0 (app preferences)
  - FlutterSecureStorage 9.0.0 (optional)
- **Calendar:** TableCalendar 3.0.9
- **Localization:** flutter_localizations, intl 0.20.2
- **WebView:** webview_flutter 4.4.2, webview_flutter_android 3.0.0
- **Media:** image_picker 1.0.0
- **Markdown:** flutter_markdown 0.6.18
- **UI/UX:**
  - FlutterAnimate 4.5.0
  - CachedNetworkImage 3.3.0
  - FlutterSvg 2.0.0

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── app.dart                  # Main app widget with routing
├── core/
│   ├── constants/           # Colors, text styles, dimensions
│   ├── theme/              # Dark/light theme configuration
│   ├── utils/              # Formatters, validators
│   └── exceptions/         # Custom exceptions (auth_exceptions.dart)
├── data/
│   ├── models/             # User, Stock, Portfolio, SupportMessage, etc.
│   ├── repositories/       # FirebaseAuthRepository, FirestoreUserRepository,
│   │                        # FirestoreChatRepository, MockDataRepository
│   └── services/           # StorageService (app preferences only)
├── presentation/
│   ├── screens/            # All app pages (login, home, support chat, etc.)
│   ├── widgets/            # Reusable widgets (chat, common, navigation)
│   └── providers/          # Riverpod state providers (auth, chat, etc.)
└── localization/           # English & Thai translations
```

## Setup & Installation

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.x
- Xcode (for iOS)
- Android Studio (for Android)
- Firebase project configured
- Google Sign-In configured (for Gmail login)
- Phone Authentication enabled (for phone login)

### Firebase Configuration

1. **Create Firebase Project:**

   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing `lib-light` project

2. **Add Android App:**

   - Add Android app with package name: `com.example.lib_light_ai`
   - Download `google-services.json` to `android/app/`
   - Add SHA-1 fingerprint (for Google Sign-In and Phone Auth)

3. **Add iOS App:**

   - Add iOS app with bundle ID: `com.example.libLightAi`
   - Download `GoogleService-Info.plist` to `ios/Runner/`

4. **Enable Authentication Methods:**

   - Enable Email/Password authentication
   - Enable Google Sign-In (configure OAuth consent screen)
   - Enable Phone authentication

5. **Configure Firestore:**
   - Create Firestore database
   - Set up security rules (see Firebase Structure section)
   - Create collections: `users`, `chats`, `chats/{chatId}/messages`

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

3. **Configure Firebase**

   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
   - Firebase options are auto-generated in `lib/firebase_options.dart`

4. **Run the app**

   ```bash
   # For iOS
   flutter run -d ios

   # For Android
   flutter run -d android

   # For macOS
   flutter run -d macos
   ```

## Firebase Structure

### Collections

- **`users/{uid}`** - User profiles

  - `accountNumber`: Trading account number
  - `email`, `displayName`, `photoUrl`, `phoneNumber`
  - `authProvider`: 'email', 'google', or 'phone'
  - `createdAt`, `updatedAt`

- **`chats/{chatId}`** - Chat documents (chatId = userId)

  - `userId`: User's Firebase UID
  - `createdAt`, `updatedAt`

- **`chats/{chatId}/messages/{messageId}`** - Chat messages
  - `content`: Message text
  - `isFromUser`: Boolean (true for user, false for admin/system)
  - `timestamp`: Server timestamp
  - `type`: 'text' or 'faq'
  - `userId`, `chatId`

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /chats/{chatId} {
      allow read, write: if request.auth != null && request.auth.uid == chatId;
      match /messages/{messageId} {
        allow read, write: if request.auth != null && request.auth.uid == chatId;
      }
    }
  }
}
```

## Authentication

The app uses Firebase Authentication with three methods:

- **Email/Password:** Standard email registration and login
- **Google Sign-In:** OAuth-based Gmail authentication
- **Phone:** SMS verification code authentication

User profiles are automatically created in Firestore on first login. The `accountNumber` is auto-generated from the user's UID.

## State Management

The app uses Riverpod for state management with the following providers:

- `authProvider` - Firebase authentication state (listens to auth state changes)
- `chatIdProvider` - Chat ID for current user
- `chatMessagesProvider` - Real-time chat messages stream
- `settingsProvider` - Language and theme preferences
- `marketDataProvider` - SET index and market status
- `stockProvider` - Selected stock and order book
- `portfolioProvider` - Portfolio holdings
- `calendarProvider` - Calendar events
- `newsProvider` - News articles
- `notificationProvider` - Notification list and unread count

## Localization

The app supports two languages:

- **English (en)** - Default
- **Thai (th)** - ภาษาไทย

Switch languages in Settings → Language. Privacy & Policy pages have separate markdown files for each language.

## Theme

- **Light Theme** (Default): White background with dark text
- **Dark Theme**: Dark navy background with blue accents

Toggle between themes in Settings → Dark Theme

## Building for Production

### Quick Build (Recommended)

Use the provided build scripts in the `scripts/` folder:

```bash
# Build Android APK
./scripts/build-android.sh

# Build iOS IPA (macOS only)
./scripts/build-ios.sh
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

## Testing

Run tests with:

```bash
flutter test
```

Run analysis:

```bash
flutter analyze
```

## Known Limitations

- Mock data for stocks, portfolio, and news (no real trading API)
- Portrait orientation only
- No order execution functionality
- US Stock and Mutual Fund tabs use same mock data as Thai Stock
- Phone authentication has daily SMS quota limit (10/day for new projects)

## License

[Add license information]

---

**Last Updated:** 18 Nov 2025
