#!/bin/bash

echo "🔍 Diagnosing Android SDK Download Issues"
echo "=========================================="

# Check network connectivity to Google
echo "1. Testing network connectivity to Google..."
ping -c 3 dl.google.com

# Check if wget is available
echo ""
echo "2. Checking wget availability..."
if command -v wget &> /dev/null; then
    echo "   ✅ wget is installed"
    wget --version | head -1
else
    echo "   ❌ wget is NOT installed"
fi

# Test download with different options
echo ""
echo "3. Testing small download from Google..."
echo "   Testing with wget --tries=3 --timeout=30..."
if wget --tries=3 --timeout=30 -O ./test-download.txt https://www.google.com/robots.txt; then
    echo "   ✅ Small download successful"
    echo "   File size: $(wc -l ./test-download.txt 2>/dev/null | cut -d' ' -f1 || echo "0") lines"
    rm -f ./test-download.txt
else
    echo "   ❌ Small download failed"
fi

# Check disk space
echo ""
echo "4. Checking disk space..."
df -h /tmp

# Check for existing Android SDK
echo ""
echo "5. Checking existing Android SDK..."
if [ -d "$HOME/.buildozer" ]; then
    echo "   ✅ .buildozer directory exists"
    echo "   Size: $(du -sh $HOME/.buildozer 2>/dev/null || echo "unknown")"
    if [ -d "$HOME/.buildozer/android/sdk" ]; then
        echo "   ✅ Android SDK directory exists"
        echo "   SDK size: $(du -sh $HOME/.buildozer/android/sdk 2>/dev/null || echo "unknown")"
    else
        echo "   ❌ Android SDK directory missing"
    fi
else
    echo "   ❌ .buildozer directory missing"
fi

# Test the exact download URL
echo ""
echo "6. Testing exact Android SDK download URL..."
echo "   URL: https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
echo "   Testing with curl to get headers..."
curl -I https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip 2>&1 | head -10

echo ""
echo "📋 Recommendations:"
echo "1. The error 'ValueError: read of closed file' suggests network interruption"
echo "2. The new workflow includes retry logic (3 attempts)"
echo "3. Consider using GitHub Actions cache for Android SDK"
echo "4. Check GitHub Actions network connectivity in workflow logs"
echo ""
echo "🚀 To test the fix:"
echo "   bash push_fixes.sh"
echo "   Then trigger the workflow manually in GitHub Actions"