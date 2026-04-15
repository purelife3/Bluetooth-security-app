#!/bin/bash

echo "🧪 TESTING BUILD-TOOLS 37 LICENSE ACCEPTANCE"
echo "============================================"

# Test 1: Check if Build-Tools 37 is installed
echo ""
echo "🔍 Test 1: Checking Build-Tools 37 installation..."
if [ -d "$HOME/.buildozer/android/sdk/build-tools/37.0.0" ]; then
    echo "✅ Build-Tools 37 is installed"
    echo "   Location: $HOME/.buildozer/android/sdk/build-tools/37.0.0"
    
    # Check for aidl
    if [ -f "$HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl" ]; then
        echo "✅ AIDL found: $HOME/.buildozer/android/sdk/build-tools/37.0.0/aidl"
    else
        echo "⚠️ AIDL not found in Build-Tools 37"
        echo "   Searching for aidl in other locations..."
        find "$HOME/.buildozer/android/sdk/build-tools" -name "aidl" 2>/dev/null
    fi
else
    echo "❌ Build-Tools 37 is NOT installed"
fi

# Test 2: Check license files
echo ""
echo "🔍 Test 2: Checking license files..."
for license_dir in "$HOME/.android/licenses" "$HOME/.buildozer/android/sdk/licenses"; do
    if [ -d "$license_dir" ]; then
        echo "📁 License directory: $license_dir"
        ls -la "$license_dir/" 2>/dev/null | head -5
    else
        echo "⚠️ License directory not found: $license_dir"
    fi
done

# Test 3: Test sdkmanager license acceptance
echo ""
echo "🔍 Test 3: Testing sdkmanager license acceptance..."
echo "📋 Running: sdkmanager --licenses --sdk_root=\$HOME/.buildozer/android/sdk"
echo "y" | $HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$HOME/.buildozer/android/sdk 2>&1 | tail -5

echo ""
echo "🧪 TEST COMPLETE"
echo ""
echo "If Build-Tools 37 is not installed, the license acceptance may have failed."
echo "Check the GitHub Actions logs for 'Skipping following packages as the license is not accepted'"
