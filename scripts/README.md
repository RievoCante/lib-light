# Build Scripts - Quick Reference

## First Time Setup

```bash
# Make scripts executable
chmod +x scripts/*.sh
```

## Build Commands

### 🤖 Android APK

```bash
./scripts/build-android.sh
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 🍎 iOS IPA (macOS only)

```bash
./scripts/build-ios.sh
```

Output: `build/ios/ipa/lib_light_ai.ipa`

### 🚀 Distribute to Firebase

```bash
export FIREBASE_APP_ID="your-firebase-app-id"
./scripts/distribute-android.sh
```

## Common Issues

**Android: "No SDK found"**

- Install Android Studio
- Install "Android SDK Command-line Tools" via SDK Manager
- Add to `~/.zshrc`:
  ```bash
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
  ```

**iOS: "Code signing error"**

- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner → Signing & Capabilities → Choose team

**Firebase: "CLI not found"**

```bash
npm install -g firebase-tools
firebase login
```

---

💡 For development with hot reload: `flutter run -d <device>`
