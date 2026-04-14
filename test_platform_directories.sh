#!/bin/bash

echo "🔍 Testing Buildozer Platform Directories"
echo "========================================="

# Check if platform directories exist as directories (not symlinks)
echo "📁 Checking platform/android-sdk:"
if [ -d ~/.buildozer/android/platform/android-sdk ]; then
    echo "✅ platform/android-sdk is a directory"
    if [ -L ~/.buildozer/android/platform/android-sdk ]; then
        echo "⚠️ platform/android-sdk is a symlink (not what we want)"
    else
        echo "✅ platform/android-sdk is NOT a symlink (good!)"
    fi
    
    # Check contents
    echo "📊 Contents of platform/android-sdk:"
    ls -la ~/.buildozer/android/platform/android-sdk/ 2>/dev/null | head -3
else
    echo "❌ platform/android-sdk is not a directory"
fi

echo ""
echo "📁 Checking platform/android-ndk:"
if [ -d ~/.buildozer/android/platform/android-ndk ]; then
    echo "✅ platform/android-ndk is a directory"
    if [ -L ~/.buildozer/android/platform/android-ndk ]; then
        echo "⚠️ platform/android-ndk is a symlink (not what we want)"
    else
        echo "✅ platform/android-ndk is NOT a symlink (good!)"
    fi
    
    # Check contents
    echo "📊 Contents of platform/android-ndk:"
    ls -la ~/.buildozer/android/platform/android-ndk/ 2>/dev/null | head -3
else
    echo "❌ platform/android-ndk is not a directory"
fi

echo ""
echo "📁 Checking original SDK/NDK locations:"
if [ -d ~/.buildozer/android/sdk ]; then
    echo "✅ Original SDK directory exists: ~/.buildozer/android/sdk"
else
    echo "⚠️ Original SDK directory not found"
fi

if [ -d ~/.buildozer/android/sdk/ndk/25b ]; then
    echo "✅ Original NDK directory exists: ~/.buildozer/android/sdk/ndk/25b"
else
    echo "⚠️ Original NDK directory not found"
fi

echo ""
echo "📋 Summary:"
echo "1. Buildozer expects platform/android-sdk and platform/android-ndk to be directories"
echo "2. Symlinks don't work because Buildozer checks with os.path.isdir()"
echo "3. Solution: Copy SDK/NDK contents to platform directories"
echo "4. This prevents Buildozer from attempting to download SDK/NDK"
