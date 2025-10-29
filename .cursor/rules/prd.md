### 1. Overview & Tech Stack

- **Product:** Mobile stock trading app for the Thai market (Phase 1: UI with mock data).
- **Framework:** Flutter (iOS & Android).
- **State Management:** Riverpod
- **Navigation:** `go_router`
- **Local Storage:** `shared_preferences` (for settings) and `flutter_secure_storage` (for credentials).
- **Design:** Light theme only. Portrait mode only.
- **Localization:** English (default) and Thai. String files in `lib/localization/en.json` and `lib/localization/th.json`.

### 2. Core Features (by Screen)

- **Authentication (Login Page):**

  - Username/email and password fields.
  - "Remember Me" checkbox (saves credentials to `flutter_secure_storage`).
  - On success, navigate to Home. App skips login on future launches if "Remember Me" is true.

- **Main Navigation (BottomNavBar):**
  - **1. Home (Calendar icon):** Shows SET index. Displays a `table_calendar` with dots on dates for dividend events. Below, a list of today's corporate actions (e.g., "ASML01 - XD").
  - **2. Buy Sell (Trading icon):** Tabs for "Thai Stock", "US Stock", "Mutual Fund". Buy/Sell toggle. Order entry form with fields: Volume, Price, PIN. Displays stock info (Price, Change, High/Low) and an order book (5Bids/10Bids tabs).
  - **3. Portfolio (Chart icon):** Tabs for "Portfolio", "Order", "Summary". Main view is a list of user's holdings with columns: Symbol, In Port, Avg, Market, %U.P.L.
  - **4. Content (News icon):** Tabs for "Popular", "Breaking", "Research". Displays a list of news article cards with titles in Thai and timestamps.
  - **5. You (Profile icon):** Settings list. Key items: Language (navigate to EN/TH selection), Dark Theme (toggle, disabled for Phase 1), Sign Out (clears secure storage, returns to Login).

### 3. Key Data Models (for Mock Data)

```dart
// lib/data/models/market_data.dart
{
  "index": "SET",
  "value": 1318.40,
  "change": -5.12,
  "marketCap": "29,204.97 M",
  "status": "open"
}

// lib/data/models/stock_quote.dart
{
  "symbol": "A",
  "currentPrice": 4.84,
  "change": 0.00,
  "ceiling": 6.25,
  "floor": 3.40
}

// lib/data/models/order_book.dart
{
  "bids": [{"volume": 200, "price": 4.82}, ...],
  "offers": [{"volume": 8200, "price": 4.84}, ...]
}

// lib/data/models/portfolio_position.dart
{
  "symbol": "AAPL",
  "quantity": 100,
  "averagePrice": 150.00,
  "currentPrice": 155.50,
  "unrealizedPLPercent": 3.67
}

// lib/data/models/news_article.dart
{
  "id": "article_001",
  "title": "5 Key Takeaways จาก LIB Talks Live วันนี้",
  "preview": "ตลาดหุ้นสหรัฐฯ เข้าสู่ภาวะ Risk On...",
  "timestamp": "2025-10-28T11:50:00Z",
  "icon": "📝"
}

// lib/data/models/calendar_event.dart
{
  "date": "2025-10-01",
  "type": "dividend",
  "stocks": ["ASML01", "INETREIT"]
}
```

### 4. Project Structure

```
lib/
├── main.dart                    // Entry point (like index.js in React)
├── app.dart                     // Root app widget (like App.jsx)
│
├── core/                        // 🎨 Design System & Utilities
│   ├── constants/
│   │   ├── app_colors.dart      // Color palette (like colors.ts)
│   │   ├── app_text_styles.dart // Typography system
│   │   └── app_dimensions.dart  // Spacing, radii, sizes
│   ├── theme/
│   │   └── app_theme.dart       // ThemeData (light/dark themes)
│   └── utils/
│       ├── formatters.dart      // Number/date formatters
│       └── validators.dart      // Input validation
│
├── data/                        // 📦 Data Layer (Models & Services)
│   ├── models/                  // TypeScript interfaces equivalent
│   │   ├── user.dart
│   │   ├── stock.dart
│   │   ├── stock_list_item.dart
│   │   ├── order_book.dart
│   │   ├── portfolio.dart
│   │   ├── calendar_event.dart
│   │   └── article.dart
│   ├── repositories/            // Data sources (like API services)
│   │   └── mock_data_repository.dart
│   └── services/                // Business logic services
│       └── storage_service.dart // localStorage wrapper
│
├── presentation/                // 🎭 UI Layer
│   ├── screens/                 // Pages (like routes in React)
│   │   ├── login/
│   │   │   └── login_page.dart
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── buy_sell/
│   │   │   ├── buy_sell_page.dart      // Main page with tabs
│   │   │   ├── stock_detail_page.dart  // Detail page (reusable!)
│   │   │   └── stock_search_page.dart
│   │   ├── portfolio/
│   │   │   └── portfolio_page.dart
│   │   ├── content/
│   │   │   └── content_page.dart
│   │   └── settings/
│   │       └── settings_page.dart
│   ├── widgets/                 // Reusable components
│   │   ├── common/              // Shared UI components
│   │   │   ├── market_header.dart
│   │   │   ├── profile_avatar.dart
│   │   │   ├── notification_bell.dart
│   │   │   ├── tab_toggle.dart
│   │   │   └── account_footer.dart
│   │   ├── navigation/
│   │   │   └── bottom_nav_bar.dart
│   │   ├── stock/               // Buy/Sell specific widgets
│   │   │   ├── stock_list_tile.dart
│   │   │   └── buy_sell_modal.dart
│   │   ├── calendar/
│   │   │   └── calendar_widget.dart
│   │   └── order_book/
│   │       └── order_book_widget.dart
│   └── providers/               // State management (Redux stores)
│       ├── auth_provider.dart
│       ├── settings_provider.dart
│       ├── market_data_provider.dart
│       ├── stock_provider.dart
│       ├── portfolio_provider.dart
│       ├── calendar_provider.dart
│       └── news_provider.dart
│
└── localization/                // 🌍 Internationalization
    ├── app_localizations.dart   // i18n loader
    ├── en.json                  // English strings
    └── th.json                  // Thai strings
```

### 5. Core Design System

- **Fonts:** San Francisco (iOS) / Roboto (Android).
- **Colors:**
  - `Primary Background`: #FFFFFF (White)
  - `Secondary Background`: #1A1D2E (Dark Navy)
  - `Primary Blue`: #3B82F6
  - `Red (loss)`: #EF4444
  - `Green (gain)`: #10B981
  - `Yellow/Gold`: #F59E0B
  - `Orange (events)`: #F97316

### 6. Key Packages

```yaml
# State Management
flutter_riverpod: ^2.5.1 # Or provider: ^6.0.0

# Navigation
go_router: ^12.0.0

# Local Storage
shared_preferences: ^2.2.0
flutter_secure_storage: ^9.0.0

# UI Components
table_calendar: ^3.0.9
flutter_svg: ^2.0.0

# Localization
intl: ^0.18.0
```
