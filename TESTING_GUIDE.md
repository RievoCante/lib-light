# Testing Guide - Liberator App

## ✅ I've Fixed the Blue Screen Issue

**What was wrong:** The `MarketHeader` widget had unbounded width constraints causing layout errors.

**What I fixed:**

- Removed the Container wrapper causing constraint issues
- Added `mainAxisSize: MainAxisSize.min` to inner Rows
- This should fix all pages (Home, Buy Sell, Portfolio, Content)

**To apply the fix:**

1. Go to your terminal where `flutter run` is running
2. Press `r` key to **hot reload** the app
3. The pages should now display correctly!

---

## 📱 How to Test on iPhone

### Option 1: iPhone Simulator (Recommended for Development)

**Step 1: Open Xcode and set up simulator**

```bash
# Open Xcode
open -a Xcode

# Or use Simulator app directly
open -a Simulator
```

**Step 2: Once Simulator is running, check devices**

```bash
flutter devices
```

You should see something like:

```
iPhone 15 Pro (mobile) • <id> • ios • iOS 17.x (simulator)
```

**Step 3: Run the app on iPhone simulator**

```bash
cd /Users/rievo/Liberator/lib_light_ai
flutter run -d iPhone
```

Or select from available devices:

```bash
flutter run
# Then choose the iPhone option from the list
```

### Option 2: Physical iPhone (For Real Device Testing)

**Step 1: Connect iPhone to Mac via USB**

**Step 2: Trust the computer on your iPhone**

- Unlock your iPhone
- Tap "Trust" when prompted

**Step 3: Check if device is detected**

```bash
flutter devices
```

You should see your iPhone listed.

**Step 4: Run on physical iPhone**

```bash
flutter run -d <your-iphone-id>
```

**Note:** First time running on physical iPhone requires:

- Apple Developer account (free account works)
- Code signing setup in Xcode
- Open `ios/Runner.xcworkspace` in Xcode and configure signing

### Option 3: iPhone View on Mac (Current Setup)

The macOS app window can be **resized to iPhone dimensions** for quick testing:

**Resize window to iPhone 15 Pro size:**

- Width: 393 points
- Height: 852 points

**Or use this Flutter command:**

```bash
flutter run -d macos --window-size=393,852
```

This gives you iPhone-like dimensions but with macOS rendering.

---

## 🔄 Hot Reload vs Hot Restart

While the app is running:

| Key | Action      | When to Use                                   |
| --- | ----------- | --------------------------------------------- |
| `r` | Hot Reload  | After code changes (UI, logic)                |
| `R` | Hot Restart | After adding dependencies, changing providers |
| `q` | Quit        | Stop the app                                  |

---

## 📊 Current Test Status

### ✅ Working Pages:

- Settings (You) - Light theme ✓

### 🔧 Should Work After Hot Reload:

- Home (Calendar) - After fix
- Buy & Sell - After fix
- Portfolio - After fix
- Content - After fix

---

## 🎯 Quick Test Checklist

After hot reload (`r` key), verify:

- [ ] Home page shows calendar with orange dots
- [ ] Buy & Sell page shows trading form
- [ ] Portfolio page shows empty state or holdings table
- [ ] Content page shows Thai news articles
- [ ] Settings page still works (light theme)
- [ ] Bottom navigation switches between all pages
- [ ] Dark theme is applied (except Settings)
- [ ] No rendering errors in terminal

---

## 🐛 If Issues Persist

**1. Hot Restart** (Press `R` in terminal)

**2. Full Rebuild:**

```bash
# Stop the app (press 'q')
flutter clean
flutter pub get
flutter run -d macos
```

**3. Check for errors:**

```bash
flutter analyze
```

---

## 📱 Recommended Testing Devices

For best mobile testing experience:

1. **iPhone 15 Pro Simulator** - Latest iOS features
2. **iPhone SE (3rd gen) Simulator** - Smaller screen testing
3. **Physical iPhone** - Real performance testing

---

## 🚀 Next Steps

1. Press `r` in your terminal to hot reload
2. Check if all pages now display correctly
3. If still blue, press `R` for hot restart
4. Open iPhone Simulator from Xcode for mobile testing
5. Test navigation and features

---

**Quick Command Reference:**

```bash
# List available devices
flutter devices

# List emulators
flutter emulators

# Launch iPhone 15 Pro simulator
open -a Simulator

# Run on specific device
flutter run -d <device-id>

# Run on iPhone simulator (once launched)
flutter run -d iPhone

# Clean build
flutter clean && flutter pub get
```

---

**Need Help?**

- Check terminal output for specific errors
- Run `flutter doctor` to check setup
- Ensure Xcode is installed for iOS development
