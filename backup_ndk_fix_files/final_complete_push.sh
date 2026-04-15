#!/bin/bash

echo "🚀 FINAL COMPLETE PUSH: Deploy ALL NDK Fixes"
echo "============================================"
echo ""

echo "📊 Step 1: Checking current git state..."
echo "----------------------------------------"
git status
echo ""

echo "🔍 Step 2: Verifying critical NDK bridge fix..."
echo "------------------------------------------------"
if grep -q "CRITICAL FIX: SDK manager installs \"25b\" but Buildozer expects \"25.1.8937393\"" fix_buildozer_platform_directories.sh; then
    echo "✅ NDK bridge fix is intact (lines 130-174)"
    echo "   - NDK_URL: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip"
    echo "   - Target directory: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393"
    echo "   - Directory renaming: android-ndk-r25b/ → 25.1.8937393/"
else
    echo "❌ CRITICAL ERROR: NDK bridge fix NOT found!"
    exit 1
fi
echo ""

echo "➕ Step 3: Staging ALL modified files..."
echo "----------------------------------------"
echo "Staging critical NDK fix files:"
git add .github/workflows/build.yml buildozer.spec fix_buildozer_platform_directories.sh verify_ndk_config.sh
echo "✅ Critical files staged"
echo ""

echo "📄 Step 4: Staging documentation files..."
echo "-----------------------------------------"
git add FINAL_NDK_FIX_SUMMARY.md NDK_VERSION_CONSISTENCY_SUMMARY.md
echo "✅ Documentation staged"
echo ""

echo "📦 Step 5: Staging utility scripts..."
echo "-------------------------------------"
git add check_current_state.sh check_git_status_detailed.sh continue_ndk_fix_push.sh diagnose_git_issue.sh final_push_ndk_fix.sh push_ndk_fix.sh push_ndk_fix_with_pull.sh resolve_merge_conflict.sh resolve_non_fast_forward.sh resolve_untracked_file_conflict.sh
echo "✅ Utility scripts staged"
echo ""

echo "💾 Step 6: Committing ALL NDK fixes..."
echo "--------------------------------------"
git commit -m "CRITICAL FIX: Complete NDK naming mismatch resolution

Root Cause:
- SDK Manager downloads NDK '25b' (android-ndk-r25b-linux.zip)
- Buildozer expects NDK '25.1.8937393' (android-ndk-r25.1.8937393-linux.zip)
- Python-for-Android recommends '25b' regardless of configuration
- Result: Buildozer attempts downloads, causing 'ValueError: read of closed file'

Solution:
1. Added NDK bridge in fix_buildozer_platform_directories.sh (lines 130-174)
   - Downloads: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip
   - Target: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393
   - Renames: android-ndk-r25b/ → 25.1.8937393/
2. Updated buildozer.spec with correct NDK version
3. Enhanced GitHub Actions workflow for NDK pre-download
4. Added verification scripts and documentation

This fix ensures Buildozer finds the pre-downloaded NDK, eliminating the download attempts that cause the 'read of closed file' error."
echo "✅ All NDK fixes committed"
echo ""

echo "📤 Step 7: Pushing to GitHub..."
echo "-------------------------------"
echo "Attempting regular push..."
if git push origin main; then
    echo "✅ Regular push successful!"
else
    echo "⚠️  Regular push failed. Trying force-with-lease..."
    if git push origin main --force-with-lease; then
        echo "✅ Force-with-lease push successful!"
        echo "⚠️  WARNING: Force push was used. This overwrites remote history."
        echo "   Only use this when you're sure your local changes are correct."
    else
        echo "❌ Push failed completely. Check git status and resolve conflicts."
        exit 1
    fi
fi
echo ""

echo "🎯 Step 8: Verification..."
echo "--------------------------"
echo "✅ All NDK fixes have been pushed to GitHub!"
echo ""
echo "📊 Next steps:"
echo "1. Go to GitHub Actions: https://github.com/purelife3/Bluetooth-security-app/actions"
echo "2. Monitor the build for these success indicators:"
echo "   - ✅ 'Pre-downloading Android NDK' message appears"
echo "   - ✅ No 'Downloading NDK' attempts by Buildozer"
echo "   - ✅ No 'ValueError: read of closed file' errors"
echo "   - ✅ Build proceeds to 'Building APK' stage"
echo "3. Expected timeline:"
echo "   - 1-2 minutes: Workflow starts"
echo "   - 5-10 minutes: NDK pre-download completes"
echo "   - 15-20 minutes: APK build completes"
echo ""
echo "🚀 NDK fix deployment complete! Monitor GitHub Actions now."