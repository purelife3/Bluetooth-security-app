#!/bin/bash

echo "Testing grep fix for patterns starting with '--'"
echo "================================================"

# Test 1: Using grep -e (should work)
echo ""
echo "Test 1: grep -e '--sdk-dir=\"\$ANDROID_HOME\"'"
if grep -e "--sdk-dir=\"\$ANDROID_HOME\"" .github/workflows/build.yml; then
    echo "✅ Test 1 PASSED: grep -e works"
else
    echo "❌ Test 1 FAILED"
fi

# Test 2: Using grep with escaped pattern (alternative)
echo ""
echo "Test 2: grep '--sdk-dir=\"\$ANDROID_HOME\"' (no flag)"
if grep "--sdk-dir=\"\$ANDROID_HOME\"" .github/workflows/build.yml; then
    echo "✅ Test 2 PASSED: plain grep works"
else
    echo "❌ Test 2 FAILED"
fi

# Test 3: Check if the pattern exists in the file
echo ""
echo "Test 3: Checking actual content in workflow file..."
echo "Looking for Buildozer commands with directory arguments:"
grep -n "sdk-dir\|ndk-dir" .github/workflows/build.yml

echo ""
echo "Test 4: Checking environment variables..."
grep -n "ANDROID_HOME=\|ANDROID_NDK_HOME=" .github/workflows/build.yml

echo ""
echo "✅ All grep tests completed"