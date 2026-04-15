#!/bin/bash

echo "=== Testing SDK Manager Fix ==="
echo "This script simulates the Buildozer SDK structure fix"

# Simulate environment variables
export ANDROID_HOME="/usr/local/lib/android/sdk"
export HOME="/home/runner"

echo "ANDROID_HOME: $ANDROID_HOME"
echo "HOME: $HOME"

# Create Buildozer's expected directory structure
echo "Creating Buildozer directory structure..."
mkdir -p "$HOME/.buildozer/android/platform/android-sdk/tools/bin"

# Check if sdkmanager exists in cmdline-tools
SDKMANAGER_PATH="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
if [ -f "$SDKMANAGER_PATH" ]; then
    echo "Found sdkmanager at: $SDKMANAGER_PATH"
    
    # Create symlink
    ln -sf "$SDKMANAGER_PATH" "$HOME/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager"
    echo "Created symlink at: $HOME/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager"
    
    # Verify the symlink
    if [ -f "$HOME/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager" ]; then
        echo "✅ SUCCESS: sdkmanager is accessible at Buildozer's expected path"
        echo "Symlink target: $(readlink -f "$HOME/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager")"
    else
        echo "❌ FAILED: sdkmanager symlink not created properly"
    fi
else
    echo "⚠️  WARNING: sdkmanager not found at expected location"
    echo "Searching for sdkmanager in $ANDROID_HOME..."
    find "$ANDROID_HOME" -name "sdkmanager" -type f 2>/dev/null || true
fi

# Show directory structure
echo ""
echo "=== Directory Structure ==="
echo "Buildozer SDK directory:"
ls -la "$HOME/.buildozer/android/platform/android-sdk/" 2>/dev/null || echo "Directory not found"

echo ""
echo "=== Test Complete ==="
echo "If sdkmanager is accessible at tools/bin/sdkmanager, Buildozer should find it."