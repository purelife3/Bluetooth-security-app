#!/bin/bash

echo "🚀 EXECUTING JAVA COMPATIBILITY FIX DEPLOYMENT"
echo "=============================================="
echo ""

# Make the deployment script executable
chmod +x commit_java_fix_now.sh

echo "🔍 Verifying current state before deployment..."
echo "----------------------------------------------"

# Check current build.yml Java version
echo "📄 Current build.yml Java version:"
if grep -q "openjdk-17-jdk" .github/workflows/build.yml; then
    echo "❌ build.yml still has Java 17 (needs replacement)"
else
    echo "✅ build.yml already has Java fix applied"
fi

echo ""
echo "📄 Corrected build_fixed.yml verification:"
if [ -f ".github/workflows/build_fixed.yml" ]; then
    echo "✅ build_fixed.yml exists"
    
    # Check Java version
    if grep -q "openjdk-11-jdk" .github/workflows/build_fixed.yml; then
        echo "✅ Java 11 configured in build_fixed.yml"
    else
        echo "❌ Java 11 NOT found in build_fixed.yml"
        exit 1
    fi
    
    # Check GitHub Action version
    if grep -q "android-actions/setup-android@v4.0.1" .github/workflows/build_fixed.yml; then
        echo "✅ GitHub Action v4.0.1 configured (fixes parameter validation)"
    else
        echo "❌ GitHub Action v4.0.1 NOT found"
        exit 1
    fi
    
    # Check parameter name
    if grep -q "accept-android-sdk-licenses: true" .github/workflows/build_fixed.yml; then
        echo "✅ Correct parameter name 'accept-android-sdk-licenses' (not 'accept-android-licenses')"
    else
        echo "❌ Incorrect parameter name"
        exit 1
    fi
else
    echo "❌ build_fixed.yml not found"
    exit 1
fi

echo ""
echo "📊 Git status before deployment:"
echo "-------------------------------"
git status --short

echo ""
echo "🚀 Starting deployment..."
echo "========================"
echo ""
echo "The deployment will:"
echo "1. Replace build.yml (Java 17) with build_fixed.yml (Java 11 + GitHub Action fix)"
echo "2. Commit the changes"
echo "3. Push to GitHub"
echo ""
echo "This fixes TWO critical issues simultaneously:"
echo "  • Java 17 compatibility error (javax/xml/bind/annotation/XmlSchema)"
echo "  • GitHub Action parameter validation failure"
echo ""

# Execute the deployment
bash commit_java_fix_now.sh

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "Monitor the build at: https://github.com/purelife3/Bluetooth-security-app/actions"
echo ""
echo "Expected improvements:"
echo "1. ✅ Java compatibility error resolved"
echo "2. ✅ GitHub Action parameter validation fixed"
echo "3. ✅ Build progresses to SDK installation"
echo "4. ✅ Next likely issue: Build-Tools 37 license acceptance (already has automation)"
echo ""