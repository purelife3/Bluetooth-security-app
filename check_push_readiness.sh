#!/bin/bash

echo "🔍 PUSH READINESS CHECK FOR BUILD TOOLS 37 LICENSE FIX"
echo "======================================================"

# Check git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "✅ Git repository found"

# Check current branch
echo ""
echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Git status:"
git status --short

echo ""
echo "🔍 Checking Buildozer SDK/NDK directory fix in workflow:"
echo "--------------------------------------------------------"

# Check for the critical fixes
if grep -q "--sdk-dir=\"\$ANDROID_HOME\"" .github/workflows/build.yml; then
    echo "✅ --sdk-dir argument found in workflow"
else
    echo "❌ --sdk-dir argument NOT found!"
fi

if grep -q "--ndk-dir=\"\$ANDROID_NDK_HOME\"" .github/workflows/build.yml; then
    echo "✅ --ndk-dir argument found in workflow"
else
    echo "❌ --ndk-dir argument NOT found!"
fi

echo ""
echo "🔍 Checking environment variables:"
echo "---------------------------------"

if grep -q "ANDROID_HOME=\$HOME/.buildozer/android/platform/android-sdk" .github/workflows/build.yml; then
    echo "✅ ANDROID_HOME environment variable set"
else
    echo "❌ ANDROID_HOME NOT found!"
fi

if grep -q "ANDROID_NDK_HOME=\$HOME/.buildozer/android/platform/android-sdk/ndk/25.1.8937393" .github/workflows/build.yml; then
    echo "✅ ANDROID_NDK_HOME environment variable set"
else
    echo "❌ ANDROID_NDK_HOME NOT found!"
fi

echo ""
echo "📝 Files to be committed:"
echo "------------------------"
git diff --name-only --cached

echo ""
echo "📝 Files with uncommitted changes:"
echo "---------------------------------"
git diff --name-only

echo ""
echo "🚀 READY FOR PUSH:"
echo "-----------------"
echo "If all checks show ✅, run:"
echo "  ./execute_final_push.sh"
echo ""
echo "This will execute:"
echo "  1. ./push_buildozer_directory_fix.sh"
echo "  2. Commit with detailed message about Buildozer SDK/NDK directory fix"
echo "  3. Push to GitHub main branch"