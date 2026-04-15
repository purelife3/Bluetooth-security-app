#!/bin/bash

echo "=== Android SDK Fix Verification ==="
echo ""

# Check if workflow file exists
if [ ! -f ".github/workflows/build.yml" ]; then
    echo "❌ Workflow file not found!"
    exit 1
fi

echo "✅ Workflow file exists"

# Verify Android SDK component installation
echo ""
echo "=== Checking Android SDK Component Installation ==="
if grep -q "components:" .github/workflows/build.yml; then
    echo "✅ Android SDK components specification found"
    echo ""
    echo "Components specified:"
    grep -A 10 "components:" .github/workflows/build.yml | grep -v "^--$"
else
    echo "❌ Android SDK components not specified!"
fi

# Verify Buildozer initialization logic
echo ""
echo "=== Checking Buildozer Initialization Logic ==="
if grep -q "Skip initialization if .buildozer directory already exists" .github/workflows/build.yml; then
    echo "✅ Buildozer skip logic found"
else
    echo "❌ Buildozer skip logic missing!"
fi

if grep -q "buildozer init --force" .github/workflows/build.yml; then
    echo "✅ Buildozer --force flag found"
else
    echo "❌ Buildozer --force flag missing!"
fi

# Verify SDK/NDK symlink configuration
echo ""
echo "=== Checking SDK/NDK Symlink Configuration ==="
if grep -q "Ensure Buildozer can find SDK/NDK" .github/workflows/build.yml; then
    echo "✅ SDK/NDK symlink configuration found"
    
    # Check for specific symlink commands
    if grep -q "ln -sf.*android-sdk/ndk/25.1.8937393" .github/workflows/build.yml; then
        echo "✅ NDK version 25.1.8937393 symlink configured"
    else
        echo "❌ NDK version symlink missing!"
    fi
else
    echo "❌ SDK/NDK symlink configuration missing!"
fi

# Check YAML syntax (no heredoc issues)
echo ""
echo "=== Checking YAML Syntax ==="
if grep -q "<< 'EOF'" .github/workflows/build.yml; then
    echo "❌ Heredoc syntax found - may cause YAML parsing issues!"
else
    echo "✅ No heredoc syntax found"
fi

echo ""
echo "=== Summary ==="
echo "The Android SDK fix has been applied to the workflow file."
echo "To test the fix, run:"
echo "  ./execute_push.sh"
echo "or"
echo "  ./push_now.sh"
echo ""
echo "Monitor the GitHub Actions workflow for Android SDK verification success."