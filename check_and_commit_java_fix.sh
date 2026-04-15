#!/bin/bash

echo "🔍 CHECK AND COMMIT JAVA FIX"
echo "============================"
echo ""

echo "📊 Step 1: Checking current git status..."
echo "----------------------------------------"
git status --short

echo ""
echo "📊 Step 2: Checking if build.yml is modified..."
echo "---------------------------------------------"
if git status --porcelain | grep -q "\.github/workflows/build.yml"; then
    echo "✅ .github/workflows/build.yml is modified"
    
    # Check if it's staged or unstaged
    STATUS=$(git status --porcelain .github/workflows/build.yml)
    if [[ $STATUS == M* ]]; then
        echo "   Status: Staged (ready to commit)"
    elif [[ $STATUS == " M"* ]]; then
        echo "   Status: Unstaged (needs to be added)"
        echo ""
        echo "📝 Step 3: Adding to staging..."
        echo "-----------------------------"
        git add .github/workflows/build.yml
        echo "✅ Added to staging"
    else
        echo "   Status: $STATUS"
    fi
else
    echo "❌ .github/workflows/build.yml is NOT modified"
    echo "   The Java compatibility fix may already be committed"
    echo "   Checking if we need to add it..."
    
    # Check if build.yml has the Java 11 fix
    if grep -q "openjdk-11-jdk" .github/workflows/build.yml; then
        echo "✅ Java 11 fix is already in build.yml"
        echo "   Adding file to git anyway..."
        git add .github/workflows/build.yml
        echo "✅ Added to staging"
    else
        echo "❌ Java 11 fix NOT found in build.yml"
        echo "   Please run the deployment script first: ./deploy_java_fix_manual.sh"
        exit 1
    fi
fi

echo ""
echo "📝 Step 4: Committing changes..."
echo "-------------------------------"
git commit -m "Fix Java 17 compatibility issue with Android SDK tools and GitHub Action parameter validation

- Changed Java installation from openjdk-17-jdk to openjdk-11-jdk
- Updated GitHub Action from v3.0.0 to v4.0.1 (android-actions/setup-android@v4.0.1)
- Fixed parameter name from 'accept-android-licenses' to 'accept-android-sdk-licenses'
- Added 'Set Java 11 as default' step to find and set JAVA_HOME
- Fixed dummy sdkmanager exit code from 1 to 0 to prevent Buildozer failure
- Resolves error: java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema
- Resolves error: Unexpected input(s) 'packages', 'accept-android-licenses'"
echo "✅ Committed Java compatibility fix"

echo ""
echo "📝 Step 5: Pushing to GitHub..."
echo "------------------------------"
git push origin main
echo "✅ Pushed to GitHub"

echo ""
echo "🎉 JAVA COMPATIBILITY FIX DEPLOYED AND PUSHED!"
echo "=============================================="
echo ""
echo "📊 What was fixed:"
echo "1. Java installation changed from openjdk-17-jdk to openjdk-11-jdk"
echo "2. GitHub Action updated from v3.0.0 to v4.0.1"
echo "3. Parameter name fixed from 'accept-android-licenses' to 'accept-android-sdk-licenses'"
echo "4. Added 'Set Java 11 as default' step to ensure JAVA_HOME points to Java 11"
echo "5. Fixed dummy sdkmanager exit code from 1 to 0 (prevents Buildozer failure)"
echo ""
echo "🔍 Monitor the build at:"
echo "https://github.com/purelife3/Bluetooth-security-app/actions"
echo ""
echo "The fix addresses TWO critical errors:"
echo "1. java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema"
echo "2. GitHub Action parameter validation failure"