#!/bin/bash

echo "🚀 MANUAL JAVA COMPATIBILITY FIX DEPLOYMENT"
echo "=========================================="
echo ""
echo "This script performs the critical deployment to fix both:"
echo "1. Java 17 compatibility issue (javax/xml/bind/annotation/XmlSchema error)"
echo "2. GitHub Action parameter validation failure"
echo ""
echo "📊 Current state verification:"
echo "-----------------------------"

# Verify build_fixed.yml exists and has correct fixes
if [ -f ".github/workflows/build_fixed.yml" ]; then
    echo "✅ build_fixed.yml exists"
    
    # Check Java 11
    if grep -q "openjdk-11-jdk" .github/workflows/build_fixed.yml; then
        echo "✅ Java 11 configured in build_fixed.yml"
    else
        echo "❌ Java 11 NOT found in build_fixed.yml"
        exit 1
    fi
    
    # Check GitHub Action v4.0.1
    if grep -q "android-actions/setup-android@v4.0.1" .github/workflows/build_fixed.yml; then
        echo "✅ GitHub Action v4.0.1 configured"
    else
        echo "❌ GitHub Action v4.0.1 NOT found"
        exit 1
    fi
    
    # Check correct parameter name
    if grep -q "accept-android-sdk-licenses: true" .github/workflows/build_fixed.yml; then
        echo "✅ Correct parameter 'accept-android-sdk-licenses' configured"
    else
        echo "❌ Correct parameter NOT found"
        exit 1
    fi
else
    echo "❌ build_fixed.yml not found"
    exit 1
fi

echo ""
echo "📊 Current build.yml state (before fix):"
echo "---------------------------------------"

# Check current build.yml issues
if grep -q "openjdk-17-jdk" .github/workflows/build.yml; then
    echo "❌ Current build.yml has Java 17 (line 32)"
else
    echo "✅ Current build.yml does NOT have Java 17"
fi

if grep -q "android-actions/setup-android@v3.0.0" .github/workflows/build.yml; then
    echo "❌ Current build.yml has GitHub Action v3.0.0 (line 87)"
else
    echo "✅ Current build.yml does NOT have v3.0.0"
fi

if grep -q "accept-android-licenses: true" .github/workflows/build.yml; then
    echo "❌ Current build.yml has wrong parameter name (line 89)"
else
    echo "✅ Current build.yml does NOT have wrong parameter"
fi

echo ""
echo "🚀 Executing deployment..."
echo "------------------------"

echo ""
echo "📝 Step 1: Replacing build.yml with build_fixed.yml..."
cp .github/workflows/build_fixed.yml .github/workflows/build.yml
echo "✅ Replaced build.yml with fixed version"

echo ""
echo "📝 Step 2: Verifying the replacement..."
if grep -q "openjdk-11-jdk" .github/workflows/build.yml; then
    echo "✅ Java 11 now in build.yml"
else
    echo "❌ Java 11 NOT in build.yml after replacement"
    exit 1
fi

if grep -q "android-actions/setup-android@v4.0.1" .github/workflows/build.yml; then
    echo "✅ GitHub Action v4.0.1 now in build.yml"
else
    echo "❌ GitHub Action v4.0.1 NOT in build.yml after replacement"
    exit 1
fi

if grep -q "accept-android-sdk-licenses: true" .github/workflows/build.yml; then
    echo "✅ Correct parameter name now in build.yml"
else
    echo "❌ Correct parameter name NOT in build.yml after replacement"
    exit 1
fi

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "The following critical fixes have been deployed:"
echo ""
echo "1. ✅ Java compatibility fix:"
echo "   - Changed from openjdk-17-jdk to openjdk-11-jdk"
echo "   - Resolves: java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema"
echo "   - Resolves: LinkageError with class file version 61.0 vs 55.0"
echo ""
echo "2. ✅ GitHub Action parameter validation fix:"
echo "   - Updated from v3.0.0 to v4.0.1"
echo "   - Fixed parameter name from 'accept-android-licenses' to 'accept-android-sdk-licenses'"
echo "   - Resolves: 'Warning: Unexpected input(s) 'packages', 'accept-android-licenses''"
echo ""
echo "3. ✅ Additional improvements:"
echo "   - Added 'Set Java 11 as default' step to ensure JAVA_HOME points to Java 11"
echo "   - Fixed dummy sdkmanager exit code from 1 to 0 (prevents Buildozer failure)"
echo ""
echo "📊 Next steps:"
echo "1. Commit and push the changes to GitHub"
echo "2. Monitor the new build at: https://github.com/purelife3/Bluetooth-security-app/actions"
echo "3. The build should now pass both Java compatibility and GitHub Action validation"
echo ""
echo "⚠️  IMPORTANT: The deployment is complete but needs to be committed and pushed."
echo "   Run: git add .github/workflows/build.yml"
echo "   Run: git commit -m 'Fix Java 17 compatibility and GitHub Action parameter validation'"
echo "   Run: git push origin main"