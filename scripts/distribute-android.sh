#!/bin/bash
# Script to distribute Android APK via Firebase App Distribution

set -e  # Exit on error

echo "🚀 Distributing Android APK to Firebase..."
echo "================================"

# Check if APK exists
if [ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "❌ APK not found! Build the app first:"
    echo "   ./scripts/build-android.sh"
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found!"
    echo ""
    echo "Install with:"
    echo "   npm install -g firebase-tools"
    echo ""
    exit 1
fi

# Get Firebase App ID (you should replace this)
APP_ID="${FIREBASE_APP_ID:-YOUR_FIREBASE_APP_ID}"
TESTER_GROUPS="${FIREBASE_TESTER_GROUPS:-testers}"

echo "📱 APK: build/app/outputs/flutter-apk/app-release.apk"
echo "🔑 App ID: $APP_ID"
echo "👥 Tester Groups: $TESTER_GROUPS"
echo ""

# Distribute
firebase appdistribution:distribute \
    build/app/outputs/flutter-apk/app-release.apk \
    --app "$APP_ID" \
    --groups "$TESTER_GROUPS" \
    --release-notes "New build: $(date '+%Y-%m-%d %H:%M')"

echo ""
echo "✅ Distribution complete!"
echo "================================"
echo "📧 Testers will receive email notification"
echo "🔗 Or share the Firebase App Distribution link"

