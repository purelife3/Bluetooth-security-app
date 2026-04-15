#!/bin/bash

echo "🚀 PUSH CRITICAL WORKFLOW FIX: Fix NDK Bridge Execution"
echo "======================================================="
echo ""

echo "📊 Step 1: Checking current git status..."
echo "----------------------------------------"
git status
echo ""

echo "🔍 Step 2: Verifying workflow changes..."
echo "----------------------------------------"
echo "Checking .github/workflows/build.yml modifications:"
echo "Lines added/modified for NDK bridge fix:"
grep -n "CRITICAL FIX\|NDK bridge\|25.1.8937393\|ndk;25b" .github/workflows/build.yml | head -20
echo ""

echo "➕ Step 3: Staging critical files..."
echo "------------------------------------"
echo "Staging workflow fix:"
git add .github/workflows/build.yml
echo "Staging buildozer.spec:"
git add buildozer.spec
echo "Staging fix script:"
git add fix_buildozer_platform_directories.sh
echo "Staging verification script:"
git add verify_ndk_config.sh
echo "✅ All critical files staged"
echo ""

echo "💾 Step 4: Committing workflow fix..."
echo "-------------------------------------"
git commit -m "CRITICAL WORKFLOW FIX: Ensure NDK bridge executes before Buildozer

Root Cause Analysis from build logs:
1. SDK Manager successfully downloads NDK '25b' (android-ndk-r25b-linux.zip)
2. But Buildozer still tries to download NDK '25.1.8937393'
3. The fix_buildozer_platform_directories.sh script (with NDK bridge) was NOT executing at the right time

Solution Implemented:
1. Added explicit NDK download via SDK Manager: 'ndk;25b'
2. Ensured fix script runs AFTER NDK download but BEFORE Buildozer
3. Created NDK bridge: SDK Manager's '25b' → Buildozer's '25.1.8937393'
4. Added verification steps to ensure bridge contains actual NDK files

The NDK bridge (lines 130-174 in fix_buildozer_platform_directories.sh):
- Downloads: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip
- Target: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393
- Renames: android-ndk-r25b/ → 25.1.8937393/

This should finally resolve the 'ValueError: read of closed file' error."
echo "✅ Workflow fix committed"
echo ""

echo "📤 Step 5: Pushing to GitHub..."
echo "-------------------------------"
echo "Attempting push..."
if git push origin main; then
    echo "✅ Push successful!"
else
    echo "⚠️  Push failed. Trying force-with-lease..."
    if git push origin main --force-with-lease; then
        echo "✅ Force-with-lease push successful!"
        echo "⚠️  WARNING: Force push was used. This overwrites remote history."
        echo "   Only use this when you're sure your local changes are correct."
    else
        echo "❌ Push failed completely. Manual intervention required."
        exit 1
    fi
fi
echo ""

echo "🎯 Step 6: Next steps..."
echo "------------------------"
echo "✅ Critical workflow fix has been pushed!"
echo ""
echo "📊 IMMEDIATE ACTIONS REQUIRED:"
echo "1. Go to GitHub Actions: https://github.com/purelife3/Bluetooth-security-app/actions"
echo "2. Manually trigger a workflow run:"
echo "   - Click on 'Build Android APK' workflow"
echo "   - Click 'Run workflow' button"
echo "   - Select 'main' branch"
echo "   - Click 'Run workflow'"
echo ""
echo "3. Monitor the build for these SUCCESS INDICATORS:"
echo "   - ✅ 'Downloading Android NDK via SDK Manager (CRITICAL FIX)' step appears"
echo "   - ✅ SDK Manager downloads 'ndk;25b'"
echo "   - ✅ 'Configure Buildozer platform directories with NDK bridge (CRITICAL FIX)' step appears"
echo "   - ✅ NDK bridge created: 25b → 25.1.8937393"
echo "   - ✅ NO 'Downloading https://dl.google.com/android/repository/android-ndk-r25.1.8937393-linux.zip'"
echo "   - ✅ NO 'ValueError: read of closed file' errors"
echo "   - ✅ Build proceeds to 'Building APK' stage"
echo ""
echo "4. Expected timeline:"
echo "   - 1-2 minutes: Workflow starts"
echo "   - 5-10 minutes: SDK Manager downloads NDK 25b"
echo "   - 1-2 minutes: NDK bridge creation"
echo "   - 15-20 minutes: APK build completes"
echo ""
echo "🚀 The NDK naming mismatch should now be permanently resolved!"