#!/bin/bash
# Script to build iOS IPA for Liberator Stock Trading App

set -e  # Exit on error

echo "🍎 Building iOS IPA..."
echo "================================"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: iOS builds require macOS"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Install iOS pods
echo "📦 Installing iOS pods..."
cd ios
pod install
cd ..

# Build IPA
echo "🔨 Building release IPA..."
flutter build ipa --release

# Check if build was successful
if [ -f "build/ios/ipa/lib_light_ai.ipa" ]; then
    echo ""
    echo "✅ Build successful!"
    echo "================================"
    echo "📱 IPA location:"
    echo "   build/ios/ipa/lib_light_ai.ipa"
    echo ""
    echo "📊 IPA size:"
    ls -lh build/ios/ipa/lib_light_ai.ipa | awk '{print "   " $5}'
    echo ""
    echo "🚀 Next steps:"
    echo "   - Test on iOS device/simulator"
    echo "   - Distribute via Firebase App Distribution"
    echo "   - Upload to TestFlight (requires Apple Developer account)"
    echo "================================"
else
    echo "❌ Build failed!"
    echo ""
    echo "⚠️  Common issues:"
    echo "   - Missing Apple Developer account setup"
    echo "   - Code signing certificates not configured"
    echo "   - iOS deployment target too low (requires iOS 15.0+)"
    echo ""
    echo "💡 Tip: For testing, use 'flutter run -d <device>' instead"
    exit 1
fi

