#!/bin/bash

echo "🔍 Testing SDK Tools Structure for Buildozer Compatibility"
echo "=========================================================="
echo ""

echo "📊 Checking Buildozer SDK verification path:"
EXPECTED_PATH="$HOME/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager"
echo "Expected path: $EXPECTED_PATH"

if [ -f "$EXPECTED_PATH" ]; then
    echo "✅ sdkmanager found at expected path!"
    echo "   File type: $(file "$EXPECTED_PATH")"
    echo "   Is symlink: $([ -L "$EXPECTED_PATH" ] && echo "Yes" || echo "No")"
    if [ -L "$EXPECTED_PATH" ]; then
        echo "   Symlink target: $(readlink -f "$EXPECTED_PATH")"
    fi
else
    echo "❌ sdkmanager NOT found at expected path"
    
    echo ""
    echo "🔍 Searching for sdkmanager in platform/android-sdk..."
    find "$HOME/.buildozer/android/platform/android-sdk" -name "sdkmanager" -type f 2>/dev/null | while read -r path; do
        echo "   Found: $path"
    done
    
    echo ""
    echo "🔍 Checking cmdline-tools structure..."
    if [ -d "$HOME/.buildozer/android/platform/android-sdk/cmdline-tools" ]; then
        echo "✅ cmdline-tools directory exists"
        find "$HOME/.buildozer/android/platform/android-sdk/cmdline-tools" -name "sdkmanager" -type f 2>/dev/null | while read -r path; do
            echo "   Found in cmdline-tools: $path"
        done
    else
        echo "❌ cmdline-tools directory not found"
    fi
fi

echo ""
echo "📊 Checking platform/android-sdk directory structure:"
if [ -d "$HOME/.buildozer/android/platform/android-sdk" ]; then
    echo "✅ platform/android-sdk directory exists"
    echo "   Contents:"
    ls -la "$HOME/.buildozer/android/platform/android-sdk/" | head -10
    
    echo ""
    echo "📊 Checking for tools/bin directory:"
    if [ -d "$HOME/.buildozer/android/platform/android-sdk/tools/bin" ]; then
        echo "✅ tools/bin directory exists"
        echo "   Contents:"
        ls -la "$HOME/.buildozer/android/platform/android-sdk/tools/bin/"
    else
        echo "❌ tools/bin directory not found"
        echo "   Creating it now..."
        mkdir -p "$HOME/.buildozer/android/platform/android-sdk/tools/bin"
    fi
else
    echo "❌ platform/android-sdk directory not found"
fi

echo ""
echo "📋 Summary:"
echo "1. Buildozer expects: platform/android-sdk/tools/bin/sdkmanager"
echo "2. Modern Android SDK installs: cmdline-tools/latest/bin/sdkmanager"
echo "3. Solution: Create symlink from cmdline-tools/latest/bin/sdkmanager to tools/bin/sdkmanager"
echo "4. This ensures Buildozer can find sdkmanager during SDK verification"