#!/bin/bash
# Script to build Android APK for Liberator Stock Trading App

set -e  # Exit on error

echo "🤖 Building Android APK..."
echo "================================"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo "🔨 Building release APK..."
flutter build apk --release

# Check if build was successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo ""
    echo "✅ Build successful!"
    echo "================================"
    echo "📱 APK location:"
    echo "   build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📊 APK size:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print "   " $5}'
    echo ""
    echo "🚀 Next steps:"
    echo "   - Test on Android device/emulator"
    echo "   - Distribute via Firebase App Distribution"
    echo "================================"
else
    echo "❌ Build failed!"
    exit 1
fi

