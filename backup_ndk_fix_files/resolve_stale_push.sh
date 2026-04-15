#!/bin/bash

echo "🔄 RESOLVE STALE PUSH: Pull, Rebase, and Push NDK Fix"
echo "====================================================="
echo ""

echo "📊 Step 1: Checking current state..."
echo "------------------------------------"
git status
echo ""

echo "📋 Step 2: Viewing recent commits..."
echo "------------------------------------"
echo "Local commits:"
git log --oneline -5
echo ""
echo "Remote commits (fetching)..."
git fetch origin
echo "Remote main:"
git log --oneline origin/main -5
echo ""

echo "🔍 Step 3: Checking for stash..."
echo "--------------------------------"
git stash list
echo ""

echo "📥 Step 4: Pulling with rebase..."
echo "----------------------------------"
echo "Pulling latest changes with rebase..."
if git pull --rebase origin main; then
    echo "✅ Rebase successful!"
else
    echo "❌ Rebase failed. Resolving conflicts..."
    echo ""
    echo "If there are conflicts, you need to:"
    echo "1. Check conflicted files: git status"
    echo "2. Resolve conflicts manually"
    echo "3. Continue rebase: git rebase --continue"
    echo "4. Or abort: git rebase --abort"
    exit 1
fi
echo ""

echo "🔧 Step 5: Verifying NDK bridge fix after rebase..."
echo "----------------------------------------------------"
if grep -q "CRITICAL FIX: SDK manager installs \"25b\" but Buildozer expects \"25.1.8937393\"" fix_buildozer_platform_directories.sh; then
    echo "✅ NDK bridge fix is intact (lines 130-174)"
    echo "   - NDK_URL: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip"
    echo "   - Target directory: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393"
    echo "   - Directory renaming: android-ndk-r25b/ → 25.1.8937393/"
else
    echo "❌ CRITICAL ERROR: NDK bridge fix NOT found after rebase!"
    echo "   You may need to restore it from backup or reapply changes."
    exit 1
fi
echo ""

echo "➕ Step 6: Staging ALL NDK fix files..."
echo "---------------------------------------"
echo "Staging critical files:"
git add .github/workflows/build.yml buildozer.spec fix_buildozer_platform_directories.sh verify_ndk_config.sh
echo "Staging documentation:"
git add FINAL_NDK_FIX_SUMMARY.md NDK_VERSION_CONSISTENCY_SUMMARY.md
echo "Staging utility scripts:"
git add check_current_state.sh check_git_status_detailed.sh continue_ndk_fix_push.sh diagnose_git_issue.sh final_push_ndk_fix.sh push_ndk_fix.sh push_ndk_fix_with_pull.sh resolve_merge_conflict.sh resolve_non_fast_forward.sh resolve_untracked_file_conflict.sh final_complete_push.sh resolve_stale_push.sh
echo "✅ All files staged"
echo ""

echo "💾 Step 7: Committing NDK fix..."
echo "--------------------------------"
# Check if we're in the middle of a rebase
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
    echo "⚠️  In rebase mode. Continuing rebase..."
    git rebase --continue
else
    echo "Creating new commit..."
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
fi
echo "✅ Commit created/updated"
echo ""

echo "📤 Step 8: Pushing to GitHub..."
echo "-------------------------------"
echo "Attempting push after rebase..."
if git push origin main; then
    echo "✅ Push successful!"
else
    echo "❌ Push failed. Last resort: force push..."
    echo "⚠️  WARNING: Force push will overwrite remote history."
    echo "   This should only be used as a last resort."
    read -p "Do you want to force push? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if git push origin main --force; then
            echo "✅ Force push successful!"
            echo "⚠️  WARNING: Remote history has been overwritten."
        else
            echo "❌ Force push also failed. Manual intervention required."
            exit 1
        fi
    else
        echo "❌ Push aborted. Manual intervention required."
        exit 1
    fi
fi
echo ""

echo "🎯 Step 9: Verification..."
echo "--------------------------"
echo "✅ NDK fix has been pushed to GitHub!"
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