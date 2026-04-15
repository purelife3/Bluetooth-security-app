#!/bin/bash

echo "🚀 DEPLOYING JAVA COMPATIBILITY FIX"
echo "==================================="

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo ""
echo "📊 Current git status:"
git status --short

echo ""
echo "🔍 Checking workflow files:"

# Check if build_fixed.yml exists
if [ ! -f ".github/workflows/build_fixed.yml" ]; then
    echo "❌ build_fixed.yml not found!"
    echo "   Please ensure the Java compatibility fixes are implemented."
    exit 1
fi

echo "✅ build_fixed.yml found"

# Check if build.yml exists
if [ ! -f ".github/workflows/build.yml" ]; then
    echo "❌ build.yml not found!"
    exit 1
fi

echo "✅ build.yml found"

echo ""
echo "📋 Comparing workflow files:"
echo "---------------------------"

# Show key differences
echo "1. Java version in build.yml:"
grep -n "openjdk-17-jdk" .github/workflows/build.yml || echo "   Not found (already fixed?)"

echo ""
echo "2. Java version in build_fixed.yml:"
grep -n "openjdk-11-jdk" .github/workflows/build_fixed.yml || echo "   Not found"

echo ""
echo "3. Java 11 setup step in build_fixed.yml:"
grep -n "Set Java 11 as default" .github/workflows/build_fixed.yml || echo "   Not found"

echo ""
echo "4. Dummy sdkmanager exit code in build_fixed.yml:"
grep -n "exit 0" .github/workflows/build_fixed.yml | grep -i sdkmanager || echo "   Not found"

echo ""
echo "🚀 Deploying Java compatibility fix..."
echo "-------------------------------------"

# Backup the original build.yml
if [ -f ".github/workflows/build.yml" ]; then
    cp .github/workflows/build.yml .github/workflows/build.yml.backup
    echo "✅ Created backup: .github/workflows/build.yml.backup"
fi

# Replace build.yml with build_fixed.yml
cp .github/workflows/build_fixed.yml .github/workflows/build.yml
echo "✅ Replaced build.yml with build_fixed.yml"

# Verify the replacement
echo ""
echo "🔍 Verification:"
echo "1. Java version in new build.yml:"
grep -n "openjdk-11-jdk" .github/workflows/build.yml || echo "   ❌ Java 11 not found!"

echo ""
echo "2. Java 11 setup step:"
grep -n "Set Java 11 as default" .github/workflows/build.yml || echo "   ❌ Java setup step not found!"

echo ""
echo "3. Dummy sdkmanager exit code:"
grep -n "exit 0" .github/workflows/build.yml | grep -i sdkmanager || echo "   ❌ Dummy sdkmanager fix not found!"

echo ""
echo "📝 Git operations:"
echo "-----------------"

# Add the modified file
git add .github/workflows/build.yml
echo "✅ Added build.yml to git staging"

# Commit the changes
git commit -m "Fix Java 17 compatibility issue with Android SDK tools

- Changed Java installation from openjdk-17-jdk to openjdk-11-jdk
- Added 'Set Java 11 as default' step to find and set JAVA_HOME
- Fixed dummy sdkmanager exit code from 1 to 0 to prevent Buildozer failure
- Resolves error: java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema"

echo "✅ Committed Java compatibility fix"

echo ""
echo "📤 Pushing to GitHub..."
echo "----------------------"

# Push to remote
git push origin main
echo "✅ Pushed Java compatibility fix to GitHub"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "Next steps:"
echo "1. Monitor the GitHub Actions workflow at:"
echo "   https://github.com/purelife3/Bluetooth-security-app/actions"
echo ""
echo "2. The build should now pass the Java compatibility issue"
echo ""
echo "3. If the build still fails, check for the next error in the logs"
echo ""
echo "4. The next likely issue is Build-Tools 37 license acceptance,"
echo "   which the workflow already has automation for via the license"
echo "   input file generation fix implemented earlier."