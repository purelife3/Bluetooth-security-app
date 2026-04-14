#!/bin/bash

echo "🔧 Setting up Buildozer environment..."

# Set environment variables
export ANDROID_HOME="$HOME/.buildozer/android/sdk"
export ANDROID_SDK_ROOT="$HOME/.buildozer/android/sdk"
export ANDROID_NDK_HOME="$HOME/.buildozer/android/sdk/ndk/25.1.8937393"
export ANDROID_NDK_ROOT="$HOME/.buildozer/android/sdk/ndk/25.1.8937393"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_NDK_HOME"

# Create Buildozer directories
mkdir -p "$HOME/.buildozer/android/sdk"
mkdir -p "$HOME/.buildozer/android/sdk/ndk/25.1.8937393"
mkdir -p "$HOME/.buildozer/android/platform/apache-ant-1.9.4"

# Verify environment
echo "✅ Environment variables set:"
echo "   ANDROID_HOME: $ANDROID_HOME"
echo "   ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "   ANDROID_NDK_HOME: $ANDROID_NDK_HOME"
echo "   PATH updated with Android tools"

# Check if directories exist
echo "📁 Checking directories:"
if [ -d "$ANDROID_HOME" ]; then
    echo "   ✅ ANDROID_HOME exists"
else
    echo "   ⚠️ ANDROID_HOME does not exist (will be created by workflow)"
fi

if [ -d "$ANDROID_NDK_HOME" ]; then
    echo "   ✅ ANDROID_NDK_HOME exists"
else
    echo "   ⚠️ ANDROID_NDK_HOME does not exist (will be created by workflow)"
fi