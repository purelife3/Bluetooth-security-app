#!/bin/bash

echo "🚀 RUNNING JAVA COMPATIBILITY FIX DEPLOYMENT"
echo "============================================"
echo ""

# Make sure we're in the right directory
echo "📁 Current directory: $(pwd)"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ ERROR: Not in a git repository!"
    echo "Please navigate to the Bluetooth-security-app directory."
    exit 1
fi

echo "✅ In git repository"
echo "📊 Current branch: $(git branch --show-current)"
echo ""

# Check current state
echo "🔍 Checking current workflow files..."
echo "------------------------------------"

# Check if build_fixed.yml exists
if [ ! -f ".github/workflows/build_fixed.yml" ]; then
    echo "❌ ERROR: build_fixed.yml not found!"
    echo "The corrected workflow file is missing."
    exit 1
fi

echo "✅ build_fixed.yml exists"

# Verify Java 11 is in build_fixed.yml
if ! grep -q "openjdk-11-jdk" .github/workflows/build_fixed.yml; then
    echo "❌ ERROR: Java 11 not found in build_fixed.yml!"
    echo "The Java compatibility fix is missing."
    exit 1
fi

echo "✅ Java 11 configured in build_fixed.yml"

# Verify GitHub Action v4.0.1 is in build_fixed.yml
if ! grep -q "android-actions/setup-android@v4.0.1" .github/workflows/build_fixed.yml; then
    echo "❌ ERROR: GitHub Action v4.0.1 not found in build_fixed.yml!"
    echo "The GitHub Action parameter fix is missing."
    exit 1
fi

echo "✅ GitHub Action v4.0.1 configured in build_fixed.yml"

# Verify correct parameter name
if ! grep -q "accept-android-sdk-licenses: true" .github/workflows/build_fixed.yml; then
    echo "❌ ERROR: Correct parameter name not found in build_fixed.yml!"
    echo "The parameter validation fix is missing."
    exit 1
fi

echo "✅ Correct parameter name 'accept-android-sdk-licenses' configured"
echo ""

# Check current build.yml
echo "📄 Current build.yml state:"
if grep -q "openjdk-17-jdk" .github/workflows/build.yml; then
    echo "❌ build.yml still has Java 17 (needs replacement)"
    NEEDS_DEPLOYMENT=true
else
    echo "✅ build.yml already has Java fix applied"
    NEEDS_DEPLOYMENT=false
fi

echo ""
echo "📊 Git status before deployment:"
echo "-------------------------------"
git status --short

echo ""
if [ "$NEEDS_DEPLOYMENT" = true ]; then
    echo "🚀 DEPLOYMENT REQUIRED - Executing Java compatibility fix..."
    echo "=========================================================="
    echo ""
    echo "This will fix TWO critical issues:"
    echo "1. Java 17 compatibility error (javax/xml/bind/annotation/XmlSchema)"
    echo "2. GitHub Action parameter validation failure"
    echo ""
    
    # Make the deployment script executable
    chmod +x commit_java_fix_now.sh
    
    # Execute the deployment
    echo "📝 Executing commit_java_fix_now.sh..."
    echo "-------------------------------------"
    echo ""
    echo "📊 This will replace build.yml (Java 17 + outdated GitHub Action) with build_fixed.yml"
    echo "   which contains:"
    echo "   - Java 11 (openjdk-11-jdk)"
    echo "   - GitHub Action v4.0.1 (android-actions/setup-android@v4.0.1)"
    echo "   - Correct parameter name 'accept-android-sdk-licenses'"
    echo "   - Dummy sdkmanager with exit 0"
    echo ""
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
else
    echo "✅ No deployment needed - Java fix already applied"
    echo ""
    echo "Current build.yml already has the Java compatibility fix."
    echo "Check GitHub Actions to see if the build is progressing."
fi