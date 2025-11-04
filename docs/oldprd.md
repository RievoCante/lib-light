# Product Requirements Document: Liberator Stock Trading App

## 1. Overview

### 1.1 Product Vision

Liberator is a mobile stock trading application designed for beginner investors and traders in the Thai stock market. The app provides an intuitive, modern interface for monitoring market data, executing trades, tracking portfolios, and staying informed about market news.

### 1.2 Project Scope

**Phase 1 (Current Scope):** Frontend UI implementation in Flutter with mock data and visual design following the reference screenshots.

**Future Phases:** REST API integration, real trading functionality, and backend connectivity.

### 1.3 Tech Stack

- **Framework:** Flutter (iOS & Android)
- **Design Theme:** Light theme (white/light colors)
- **Animation:** Smooth, modern animations throughout
- **State Management:** TBD (recommend Provider, Riverpod, or Bloc)
- **Local Storage:** For credential persistence

---

## 2. Target Users

### 2.1 Primary Persona

**Name:** New Investor Nattapong

**Profile:**

- Age: 25-35
- Experience: Beginner to intermediate investor
- Goals: Learn to trade stocks, track investments, stay updated on market news
- Pain Points: Complex trading interfaces, lack of Thai language support, overwhelming information

**Needs:**

- Simple, intuitive interface
- Thai language support
- Clear visualization of portfolio performance
- Easy-to-understand market data

---

## 3. Platform Requirements

### 3.1 Supported Platforms

- iOS (minimum version: iOS 12+)
- Android (minimum version: Android 6.0+)

### 3.2 Orientation

- Portrait mode only

### 3.3 Screen Sizes

- Support all standard mobile screen sizes (4.7" to 6.7")
- Responsive layouts that adapt to different screen dimensions

---

## 4. Design Requirements

### 4.1 Design System

**Color Palette:**

- Primary Background: White (#FFFFFF)
- Secondary Background: Dark Navy (#1A1D2E)
- Primary Blue: #3B82F6
- Accent Colors:
  - Red (negative/loss): #EF4444
  - Green (positive/gain): #10B981
  - Yellow/Gold: #F59E0B
  - Orange (events): #F97316

**Typography:**

- Primary Font: San Francisco (iOS) / Roboto (Android) or custom font
- Font Sizes:
  - Headers: 24-28px
  - Subheaders: 18-20px
  - Body: 14-16px
  - Small text: 12px

**Icons:**

- Use Material Icons or custom icon set
- Consistent icon style throughout

### 4.2 Animation Guidelines

- Page transitions: 300ms ease-in-out
- Button interactions: 150ms with subtle scale/opacity changes
- List item animations: Staggered fade-in
- Loading states: Smooth skeleton screens or custom loaders
- Pull-to-refresh: Custom animation matching brand

### 4.3 Design Principles

- Clean, uncluttered interface
- Clear visual hierarchy
- Consistent spacing (8px grid system)
- High contrast for readability
- Accessibility considerations (touch targets 44x44px minimum)

---

## 5. Functional Requirements

### 5.1 Authentication

#### 5.1.1 Login Page

**Elements:**

- Liberator logo and branding
- Username/email input field
- Password input field (obscured)
- "Remember Me" checkbox
- "Login" button
- Optional: "Forgot Password?" link (non-functional in Phase 1)

**Behavior:**

- Input validation (non-empty fields)
- Mock authentication (accept any credentials for Phase 1)
- Store credentials locally if "Remember Me" is checked
- Navigate to Home page on successful login
- Show loading state during login process
- Show error message for empty fields

**Persistence:**

- If "Remember Me" is checked, app should skip login on subsequent launches
- Provide logout functionality to clear stored credentials

---

### 5.2 Navigation Structure

#### 5.2.1 Bottom Navigation Bar

**5 Main Tabs:**

1. **Home** (Calendar icon)
2. **Buy Sell** (Trading icon)
3. **Portfolio** (Chart/portfolio icon)
4. **Content** (News/document icon)
5. **You** (Profile/settings icon)

**Behavior:**

- Always visible (except on Login page)
- Active tab highlighted with primary blue color
- Smooth transition between tabs
- Tab state preserved when switching

---

### 5.3 Page 1: Home (Calendar)

#### 5.3.1 Header Section

**Elements:**

- Liberator logo (top left)
- Page title: "Home"
- SET Index display with real-time value and change
  - Format: "SET 1,318.40 -5.12"
  - Red color for negative, green for positive
- Market cap: "29,204.97 M"
- Green dot indicator (market status)
- Bell icon (notifications)
- Profile avatar (top right)

#### 5.3.2 Calendar Section

**Elements:**

- Month and year display ("October 2025")
- Calendar grid showing current month
- Day labels (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
- Orange dots on specific dates (dividend payment dates)
- Current date highlighted with circle/different background
- Navigation arrows for previous/next month

**Dividend Events:**

- Orange dot indicators on dates with dividend payments
- Tappable dates to view dividend details (future functionality)

#### 5.3.3 Event List (Below Calendar)

**Elements:**

- "Today" label with date
- "Corporate Actions" section
- List of stocks with dividend events
  - Stock symbols (e.g., "ASML01", "INETREIT")
  - XD badge indicators
  - Tap to view details (future functionality)

**Mock Data:**

- Display 2-5 sample corporate actions
- Include various stock symbols
- Show XD (ex-dividend) badges

---

### 5.4 Page 2: Buy & Sell

#### 5.4.1 Market Toggle

**Elements:**

- Three tabs: "Thai Stock", "US Stock", "Mutual Fund"
- Active tab highlighted in blue
- Smooth animation when switching tabs

#### 5.4.2 Header Section

**Elements:**

- SET Index with value and change (same as Home page)
- Market cap display
- Status indicator

#### 5.4.3 Trading Panel

**Action Tabs:**

- "Buy" tab (default active, blue background)
- "Sell" tab (gray when inactive)

**Search/Symbol Section:**

- Search input field with icon
- Stock symbol chip/tag display (e.g., "NVDR")
- Autocomplete suggestions (mock list for Phase 1)

**Order Entry Form:**

- **Volume:** Input field with placeholder "Volume ..."
- **In Port:** Display field showing "0" (portfolio holdings)
- **Price:** Input field with placeholder "Price ..."
- **Order Type:** Dropdown - "Limit" / "Cond." (Conditional)
- **PIN:** Secure input field with lock icon
- **Action Buttons:**
  - Blue "Buy" button
  - Gray "Clear" button

#### 5.4.4 Stock Information Display

**Elements:**

- Stock symbol (e.g., "A")
- Current price in large text with currency
- Change amount and percentage (color-coded)
- High/Low/Open2/PClose values
- Ceiling/Floor prices (green/red)

#### 5.4.5 Order Book

**Two Tabs:**

- "5Bids" (default active)
- "10Bids"

**Display:**

- Volume, Bid, Offer columns
- Color-coded bid prices (red) and offer prices (green)
- Volume displayed in yellow
- 5 levels of depth shown (or 10 when selected)

**Mock Data:**

- Generate realistic bid/ask spread
- Display reasonable volumes
- Proper color formatting

#### 5.4.6 Footer Information

**Elements:**

- Trading A/C number
- Line Available: "0.00"
- Cash Balance: "0.00"

---

### 5.5 Page 3: Portfolio

#### 5.5.1 Header Section

**Elements:**

- SET Index display
- Market cap
- Status indicator
- Thai language notice/message banner

#### 5.5.2 View Toggle

**Three Tabs:**

- "Portfolio" (default active)
- "Order"
- "Summary"

#### 5.5.3 Portfolio View

**Filter:**

- "All Port" dropdown

**Table Headers:**

- Symbol (sortable)
- In Port (quantity, sortable)
- Avg (average price, sortable)
- Market (current price, sortable)
- %U.P.L (unrealized P&L percentage, sortable)

**Portfolio List:**

- Empty state initially
- Display mock holdings when data added:
  - Stock symbol
  - Quantity held
  - Average buy price
  - Current market price
  - Unrealized profit/loss (color-coded)

**Mock Data:**

- Create 3-5 sample positions
- Mix of gains and losses
- Realistic stock symbols

#### 5.5.4 Total Section

**Elements:**

- "Total" label with expandable icon
- "Share all" button
- Summary of total portfolio value (hidden/expandable)

#### 5.5.5 Footer Information

**Elements:**

- Trading A/C number
- Line Available: "0.00"
- Cash Balance: "0.00"

---

### 5.6 Page 4: Content

#### 5.6.1 Header Section

**Elements:**

- SET Index display
- Market cap
- Status indicator

#### 5.6.2 Search Bar

**Elements:**

- Search input with placeholder "Search"
- Search icon button

#### 5.6.3 Content Tabs

**Three Tabs:**

- "Popular"
- "Breaking" (default active, blue underline)
- "Research"

#### 5.6.4 News Feed

**Article Cards:**

- Emoji/icon indicator
- Article title in Thai
- Timestamp (e.g., "3 hours ago", "6 days ago")
- Brief preview text
- "อ่านเพิ่มเติม" (Read more) link
- Separator lines between articles

**Mock Content:**

- Display 5-10 sample articles
- Mix of timestamps
- Relevant Thai stock market content
- Include icons (📝, 💙, etc.)

**Article Types:**

- LIB Talks Live summaries
- Stock recommendations
- Market analysis
- Breaking news

**Interaction:**

- Tap to view full article (navigate to detail page)
- Pull to refresh
- Infinite scroll for more articles

---

### 5.7 Page 5: You (Settings)

#### 5.7.1 Header

**Elements:**

- "You" title
- Search icon (top right)
- Notification bell icon

#### 5.7.2 Setting Section

**Items:**

1. **Language**

   - Icon: Globe/translate icon
   - Label: "Language"
   - Current: "English"
   - Arrow: Navigate to language selection
   - Options: Thai / English

2. **Dark Theme**

   - Icon: Moon icon
   - Label: "Dark Theme"
   - Toggle switch (off by default for Phase 1)
   - Note: Phase 1 uses light theme only

3. **Order Entry**
   - Icon: Document icon
   - Label: "Order Entry"
   - Arrow: Navigate to order settings

#### 5.7.3 Others Section

**Items:**

1. **E-Service**

   - Icon: E-service icon
   - Arrow: Navigate to e-services

2. **Contact Us**

   - Icon: Headphones icon
   - Label: "Contact Us"
   - Arrow: Navigate to contact page

3. **Privacy & Policy**

   - Icon: Shield/checkmark icon
   - Label: "Privacy & Policy"
   - Arrow: Navigate to privacy policy

4. **Sign Out**
   - Icon: Logout icon
   - Label: "Sign Out"
   - Action: Clear credentials and return to login

**Behavior:**

- Items are tappable with visual feedback
- Sign Out shows confirmation dialog
- Language change updates UI immediately

---

## 6. Data Requirements

### 6.1 Mock Data Structure

#### 6.1.1 User Session

```dart
{
  "userId": "70426672",
  "accountNumber": "70426672(C)",
  "isLoggedIn": true,
  "rememberMe": true
}
```

#### 6.1.2 Market Data

```dart
{
  "index": "SET",
  "value": 1318.40,
  "change": -5.12,
  "percentChange": -0.39,
  "marketCap": "29,204.97 M",
  "status": "open"
}
```

#### 6.1.3 Stock Quote

```dart
{
  "symbol": "A",
  "currentPrice": 4.84,
  "currency": "THB",
  "change": 0.00,
  "percentChange": 0.00,
  "high": 0.00,
  "low": 0.00,
  "open": 0.00,
  "previousClose": 4.84,
  "ceiling": 6.25,
  "floor": 3.40
}
```

#### 6.1.4 Order Book

```dart
{
  "bids": [
    {"volume": 200, "price": 4.82},
    {"volume": 200, "price": 4.80},
    {"volume": 1000, "price": 4.70},
    {"volume": 2000, "price": 4.64},
    {"volume": 2000, "price": 4.60}
  ],
  "offers": [
    {"volume": 8200, "price": 4.84},
    {"volume": 20900, "price": 4.86},
    {"volume": 20000, "price": 4.88},
    {"volume": 500, "price": 4.90},
    {"volume": 1200, "price": 5.00}
  ]
}
```

#### 6.1.5 Portfolio Position

```dart
{
  "symbol": "AAPL",
  "quantity": 100,
  "averagePrice": 150.00,
  "currentPrice": 155.50,
  "unrealizedPL": 5.50,
  "unrealizedPLPercent": 3.67
}
```

#### 6.1.6 Calendar Event

```dart
{
  "date": "2025-10-01",
  "type": "dividend",
  "stocks": ["ASML01", "INETREIT"],
  "description": "Ex-Dividend Date"
}
```

#### 6.1.7 News Article

```dart
{
  "id": "article_001",
  "title": "5 Key Takeaways จาก LIB Talks Live วันนี้",
  "preview": "ตลาดหุ้นสหรัฐฯ เข้าสู่ภาวะ Risk On...",
  "timestamp": "2025-10-28T11:50:00Z",
  "icon": "📝",
  "content": "Full article content..."
}
```

### 6.2 Local Storage

**Store:**

- Login credentials (if Remember Me is checked)
- Language preference
- Theme preference (for future dark mode)
- Last viewed tab/page state

**Use:**

- SharedPreferences or Hive for key-value storage
- Secure storage for credentials

---

## 7. Technical Specifications

### 7.1 Flutter Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── dimensions.dart
│   ├── utils/
│   │   ├── formatters.dart
│   │   └── validators.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   ├── user.dart
│   │   ├── stock.dart
│   │   ├── order.dart
│   │   └── article.dart
│   ├── repositories/
│   │   └── mock_data_repository.dart
│   └── services/
│       └── storage_service.dart
├── presentation/
│   ├── screens/
│   │   ├── login/
│   │   ├── home/
│   │   ├── buy_sell/
│   │   ├── portfolio/
│   │   ├── content/
│   │   └── settings/
│   ├── widgets/
│   │   ├── common/
│   │   ├── calendar/
│   │   ├── order_book/
│   │   └── navigation/
│   └── providers/ (if using Provider)
└── localization/
    ├── app_localizations.dart
    ├── en.json
    └── th.json
```

### 7.2 State Management

**Recommended:** Provider or Riverpod

**Rationale:**

- Simple to implement
- Good for app of this size
- Easy to scale
- Good documentation

**Alternative:** Bloc (if team prefers more structure)

### 7.3 Key Packages

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.0.0

  # Navigation
  go_router: ^12.0.0

  # Local Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # UI Components
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

  # Date/Time
  table_calendar: ^3.0.9

  # Animations
  flutter_animate: ^4.5.0

  # Utils
  equatable: ^2.0.5
```

### 7.4 API Integration (Future)

**Endpoint Structure (Placeholder):**

- Authentication: `/api/v1/auth/login`
- Market Data: `/api/v1/market/quote/{symbol}`
- Order Book: `/api/v1/market/orderbook/{symbol}`
- Portfolio: `/api/v1/portfolio`
- Orders: `/api/v1/orders`
- News: `/api/v1/content/news`
- Calendar: `/api/v1/calendar/events`

**For Phase 1:**

- Create repository interfaces
- Implement mock repositories returning dummy data
- Easy to swap with real API later

---

## 8. Localization Requirements

### 8.1 Supported Languages

- English (default)
- Thai (ภาษาไทย)

### 8.2 Switchable Elements

**Text Content:**

- All UI labels and buttons
- Navigation menu items
- Form field labels and placeholders
- Error messages
- Setting items

**Non-Translatable:**

- Stock symbols
- Numeric values
- Currency codes
- Account numbers
- Dates (format only changes)

### 8.3 Thai Language Considerations

- Use proper Thai fonts (support for Thai characters)
- Right-to-left text is not required (Thai is LTR)
- Number formatting: use comma for thousands (1,234.56)
- Date format: DD/MM/YYYY for Thai, MM/DD/YYYY for English
- Currency: ฿ or THB

### 8.4 Language Persistence

- Store selected language in local storage
- Apply on app launch
- Immediate UI update when changed

---

## 9. Animation & Interaction Specifications

### 9.1 Page Transitions

**Tab Navigation:**

- Duration: 300ms
- Curve: easeInOut
- Type: Fade + subtle slide

**Navigation to Detail Pages:**

- Duration: 250ms
- Curve: easeOut
- Type: Slide from right (iOS) / Fade (Android)

### 9.2 List Animations

**News Feed / Portfolio List:**

- Staggered fade-in on initial load
- Delay: 50ms between items
- Total duration: ~400ms for 8 items

### 9.3 Interactive Elements

**Buttons:**

- Press: Scale down to 0.95, duration 100ms
- Release: Scale back to 1.0, duration 100ms
- Hover (web/desktop): Slight brightness change

**Input Fields:**

- Focus: Border color change with 200ms transition
- Keyboard appearance: Smooth with auto-scroll to field

**Toggle/Switch:**

- Smooth animation, duration 200ms
- Thumb slides with easeInOut curve

### 9.4 Pull-to-Refresh

- Custom indicator matching brand colors
- Rotation or fade animation
- Haptic feedback on trigger (iOS)

### 9.5 Loading States

**Skeleton Screens:**

- Use for list items and cards while loading
- Shimmer effect duration: 1500ms
- Gradient: Light gray to slightly lighter gray

**Spinners:**

- Use sparingly (login, data submission)
- Brand color: Primary blue
- Size: 24-32px

---

## 10. Error Handling & Edge Cases

### 10.1 Login Page

**Errors:**

- Empty username/password → Show error text below field
- Invalid credentials → Mock: accept any input for Phase 1
- Network error (future) → Show retry button

### 10.2 Form Validation

**Buy/Sell Page:**

- Empty symbol → "Please select a stock"
- Invalid volume → "Please enter valid volume"
- Invalid price → "Please enter valid price"
- Empty PIN → "Please enter PIN"

### 10.3 Empty States

**Portfolio:**

- No holdings → Show empty state with illustration and text:
  - "You don't have any stocks yet"
  - "Start trading" button

**Content:**

- No articles → "No news available"

**Calendar:**

- No events on date → Show "No corporate actions today"

### 10.4 Network Errors (Future)

- Show user-friendly error messages
- Provide retry options
- Cache last successful data when appropriate

---

## 11. Performance Requirements

### 11.1 Load Times

- App launch: < 3 seconds to login screen
- Page transition: < 300ms
- List rendering: < 500ms for 50 items

### 11.2 Memory Usage

- Keep memory usage under 200MB during normal operation
- Properly dispose of controllers and listeners
- Cache images efficiently

### 11.3 Frame Rate

- Maintain 60 FPS during animations
- Smooth scrolling in lists
- No jank during tab switches

### 11.4 Optimization Strategies

- Lazy loading for lists
- Image caching
- Debounce search inputs
- Minimize rebuilds using const widgets

---

## 12. Testing Requirements

### 12.1 Unit Tests

- Model classes
- Utility functions (formatters, validators)
- Repository mock data

### 12.2 Widget Tests

- Individual components
- Form validation
- Navigation flows

### 12.3 Integration Tests

- Login flow
- Tab navigation
- Buy/sell form submission
- Language switching

### 12.4 Manual Testing Checklist

- [ ] Login with Remember Me
- [ ] Login without Remember Me
- [ ] Tab navigation (all 5 tabs)
- [ ] Calendar date selection
- [ ] Stock search and selection
- [ ] Order form entry
- [ ] Portfolio view
- [ ] News article tap
- [ ] Language switching
- [ ] Sign out
- [ ] App restart with saved credentials
- [ ] iOS and Android builds
- [ ] Different screen sizes
- [ ] Rotation handling (if allowed)

---

## 13. Deliverables

### 13.1 Phase 1 Deliverables

1. **Flutter App Source Code**

   - Clean, commented code
   - Follows Flutter best practices
   - Proper project structure

2. **Mock Data Implementation**

   - JSON files or Dart constants
   - Realistic sample data

3. **Documentation**

   - README with setup instructions
   - Code documentation
   - Known issues/limitations

4. **Build Artifacts**
   - APK for Android testing
   - IPA for iOS testing (or TestFlight)

### 13.2 Asset Requirements

- App icon (iOS and Android)
- Splash screen
- Stock symbol icons (if needed)
- Custom illustrations (empty states)
- Font files (if using custom fonts)

---

## 14. Future Considerations

### 14.1 Phase 2 Features

- REST API integration
- Real-time data updates (WebSocket)
- Order execution functionality
- Push notifications
- Biometric authentication

### 14.2 Phase 3 Features

- Dark theme implementation
- Charts and technical indicators
- Watchlists
- Stock alerts
- Social features (if applicable)

### 14.3 Scalability

- Code structure should support:
  - Easy API integration
  - Additional markets (US, crypto)
  - New features without major refactoring

---

## 15. Success Criteria

### 15.1 Functional Success

- [ ] All 5 main pages implemented and navigable
- [ ] Login with persistence works correctly
- [ ] UI matches reference screenshots
- [ ] Smooth animations throughout
- [ ] Thai and English localization working
- [ ] Builds successfully on iOS and Android
- [ ] No critical bugs or crashes

### 15.2 Quality Metrics

- **Code Quality:** Clean, maintainable code following Flutter conventions
- **Performance:** Smooth 60 FPS, no lag during interactions
- **Design Consistency:** Matches reference design language
- **User Experience:** Intuitive navigation, clear feedback

---

## Dependencies & Constraints

### Dependencies

- Flutter SDK (latest stable)
- Xcode (for iOS builds)
- Android Studio (for Android builds)
- Design assets from design team

### Constraints

- No backend integration in Phase 1
- Light theme only (dark theme disabled)
- Portrait orientation only
- Mock data for all dynamic content

### Assumptions

- Design specifications match reference screenshots
- Color codes and exact spacing can be estimated from screenshots
- Mock data structure is acceptable for demo purposes
- API endpoints will be provided before Phase 2

**End of Document**
