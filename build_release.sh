#!/bin/bash
# IceBath Release Build Script
# Creates a properly signed .prg file for Garmin devices

set -e  # Exit on error

echo "🏗️  IceBath Release Build Script"
echo "================================"
echo ""

# Configuration
PROJECT_DIR="/Users/onurkapucu/Documents/IceBath"
DEVELOPER_KEY="$PROJECT_DIR/GARMINKEY/developer_key"
OUTPUT_DIR="$PROJECT_DIR/bin"
OUTPUT_FILE="$OUTPUT_DIR/IceBath.prg"

# SDK Configuration - Use SDK 8.4.0
SDK_PATH="/Users/onurkapucu/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.0-2025-12-03-5122605dc"
MONKEYC="$SDK_PATH/bin/monkeyc"
API_DB="$SDK_PATH/bin/api.db"
API_MIR="$SDK_PATH/bin/api.mir"

# Check if developer key exists
if [ ! -f "$DEVELOPER_KEY" ]; then
    echo "❌ Error: Developer key not found at $DEVELOPER_KEY"
    exit 1
fi

echo "✅ Developer key found"
echo "✅ Using SDK 8.4.0"
echo ""

# Build for SDK 5.2.0 compatible devices
echo "🔨 Building for SDK 5.2.0+ compatible Garmin devices..."
echo "   Target: All devices (70+ models including FR970, FR965, Fenix 7)"
echo ""

"$MONKEYC" \
    --output "$OUTPUT_FILE" \
    --jungles "$PROJECT_DIR/monkey.jungle" \
    --apidb "$API_DB" \
    --apimir "$API_MIR" \
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
    echo "1. Connect your Garmin watch via USB"
    echo "2. Copy the file to: /Volumes/GARMIN/GARMIN/APPS/IceBath.prg"
    echo "3. Safely eject the device"
    echo "4. Restart your watch"
    echo ""
    echo "Or use this command:"
    echo "cp $OUTPUT_FILE /Volumes/GARMIN/GARMIN/APPS/IceBath.prg"
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
