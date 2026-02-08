#!/bin/bash
# IceBath Store Build Script
# Creates a Connect IQ Application Package (.iq) for uploading to the store

set -e  # Exit on error

echo "📦 IceBath Store Build Script (.iq)"
echo "=================================="
echo ""

# Configuration
PROJECT_DIR="/Users/onurkapucu/Documents/IceBath"
DEVELOPER_KEY="$PROJECT_DIR/GARMINKEY/developer_key"
OUTPUT_DIR="$PROJECT_DIR/bin"
OUTPUT_FILE="$OUTPUT_DIR/icebath-new.iq"

# SDK Configuration - Use SDK 8.4.0 (Same as release script)
SDK_PATH="/Users/onurkapucu/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.0-2025-12-03-5122605dc"
MONKEYC="$SDK_PATH/bin/monkeyc"

# Check if developer key exists
if [ ! -f "$DEVELOPER_KEY" ]; then
    echo "❌ Error: Developer key not found at $DEVELOPER_KEY"
    exit 1
fi

echo "✅ Developer key found"
echo "✅ Using SDK 8.4.0"
echo ""

# Check manifest for supported products (just an echo, not logic)
echo "ℹ️  Building for devices defined in manifest.xml..."
grep "<iq:product" "$PROJECT_DIR/manifest.xml" | sed 's/^[ \t]*//'
echo ""

# Build command for IQ Package
# -e / --package-app : Create an application package
# -w / --warn : Show warnings
# -r / --release : Release build (optimizations)
echo "🚀 Building IceBath.iq package..."

"$MONKEYC" \
    --package-app \
    --output "$OUTPUT_FILE" \
    --jungles "$PROJECT_DIR/monkey.jungle" \
    --private-key "$DEVELOPER_KEY" \
    --warn \
    --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "📦 Output file: $OUTPUT_FILE"
    echo "📊 File size: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"
    echo ""
    echo "📋 Next steps:"
    echo "1. Go to developer.garmin.com/connect-iq/dashboard/"
    echo "2. Click 'Upload App'"
    echo "3. Select the file: $OUTPUT_FILE"
    echo "4. Fill in the store listing details and publish!"
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
