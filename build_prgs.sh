#!/bin/bash
# Script to build PRG files for specific devices (side-load)
set -e

PROJECT_DIR="/Users/onurkapucu/Documents/IceBath"
SDK_PATH="/Users/onurkapucu/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.0-2025-12-03-5122605dc"
MONKEYC="$SDK_PATH/bin/monkeyc"
DEV_KEY="$PROJECT_DIR/GARMINKEY/developer_key"
OUTPUT_DIR="$PROJECT_DIR/bin"

echo "🔨 Building for FR965..."
"$MONKEYC" -o "$OUTPUT_DIR/IceBath_fr965.prg" \
           -f "$PROJECT_DIR/monkey.jungle" \
           -d fr965 \
           -y "$DEV_KEY" \
           -w

echo "✅ Created: $OUTPUT_DIR/IceBath_fr965.prg"

echo "🔨 Building for FR970..."
"$MONKEYC" -o "$OUTPUT_DIR/IceBath_fr970.prg" \
           -f "$PROJECT_DIR/monkey.jungle" \
           -d fr970 \
           -y "$DEV_KEY" \
           -w

echo "✅ Created: $OUTPUT_DIR/IceBath_fr970.prg"
