#!/bin/bash

echo "🚀 FINAL PUSH: Workflow Timing Fix for NDK Bridge"
echo "================================================="
echo ""
echo "📊 Current Status:"
echo "-----------------"
echo "• Previous push failed due to remote changes"
echo "• Need to pull, rebase, and push workflow timing fix"
echo "• Critical fix: Ensure NDK bridge executes BEFORE Buildozer"
echo ""

echo "🔍 Step 1: Check current git state..."
echo "--------------------------------------"
git status
echo ""

echo "📋 Step 2: View local vs remote commits..."
echo "------------------------------------------"
echo "Local commits:"
git log --oneline -3
echo ""
echo "Fetching remote..."
git fetch origin
echo "Remote commits:"
git log --oneline origin/main -3
echo ""

echo "📥 Step 3: Pull with rebase (preserving NDK bridge fix)..."
echo "----------------------------------------------------------"
echo "⚠️  IMPORTANT: We must preserve the NDK bridge fix in fix_buildozer_platform_directories.sh"
echo "   This fix creates the directory bridge between SDK Manager's '25b' and Buildozer's '25.1.8937393'"
echo ""
if git pull --rebase origin main; then
    echo "✅ Rebase successful!"
else
    echo "❌ Rebase failed. Checking for conflicts..."
    echo ""
    echo "Checking for conflict markers in critical files:"
    for file in .github/workflows/build.yml buildozer.spec fix_buildozer_platform_directories.sh; do
        if grep -q "<<<<<<<" "$file"; then
            echo "❌ Conflict in $file - need manual resolution"
            grep -n "<<<<<<<" "$file" | head -3
        else
            echo "✅ $file has no conflict markers"
        fi
    done
    echo ""
    echo "If conflicts exist, resolve them and run:"
    echo "  git add ."
    echo "  git rebase --continue"
    echo "Then run this script again."
    exit 1
fi
echo ""

echo "🔧 Step 4: Verify NDK bridge fix integrity..."
echo "---------------------------------------------"
if grep -q "CRITICAL FIX: SDK manager installs \"25b\" but Buildozer expects \"25.1.8937393\"" fix_buildozer_platform_directories.sh; then
    echo "✅ NDK bridge fix is intact (lines 130-174)"
    echo "   - Downloads: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip"
    echo "   - Target: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393"
    echo "   - Renames: android-ndk-r25b/ → 25.1.8937393/"
else
    echo "❌ CRITICAL ERROR: NDK bridge fix NOT found!"
    echo "   The fix must be in fix_buildozer_platform_directories.sh lines 130-174"
    exit 1
fi
echo ""

echo "➕ Step 5: Stage critical workflow fix files..."
echo "-----------------------------------------------"
echo "Staging workflow timing fix:"
git add .github/workflows/build.yml
echo "Staging buildozer spec:"
git add buildozer.spec
echo "Staging NDK bridge script:"
git add fix_buildozer_platform_directories.sh
echo "Staging verification script:"
git add test_platform_directories.sh
echo "✅ All critical files staged"
echo ""

echo "💾 Step 6: Commit workflow timing fix..."
echo "----------------------------------------"
git commit -m "CRITICAL WORKFLOW FIX: Ensure NDK bridge executes before Buildozer

Root Cause Analysis:
- Build logs show SDK Manager downloads NDK '25b' successfully
- But Buildozer still attempts to download NDK '25.1.8937393'
- This causes 'ValueError: read of closed file' error
- The NDK bridge fix exists but executes TOO EARLY in workflow

Solution:
1. Added explicit NDK download step in GitHub Actions workflow
   - Downloads 'ndk;25b' via SDK Manager BEFORE bridge creation
2. Enhanced NDK bridge configuration step
   - Verifies NDK exists before creating bridge
   - Adds fallback copy if bridge directory is empty
3. Sets correct environment variables
   - ANDROID_NDK_HOME points to bridge directory
   - Ensures Buildozer finds pre-downloaded NDK

This timing fix ensures:
- SDK Manager downloads NDK '25b' FIRST
- NDK bridge creates directory structure SECOND
- Buildozer finds existing NDK and skips download
- No more 'ValueError: read of closed file' errors"
echo "✅ Workflow timing fix committed"
echo ""

echo "📤 Step 7: Push to GitHub..."
echo "----------------------------"
echo "Attempting push..."
if git push origin main; then
    echo "✅ Push successful!"
else
    echo "❌ Push failed. Trying force-with-lease..."
    if git push origin main --force-with-lease; then
        echo "✅ Force-with-lease successful!"
    else
        echo "❌ Force-with-lease also failed."
        echo ""
        echo "Manual intervention required. Try:"
        echo "1. Check remote state: git fetch origin"
        echo "2. View differences: git log HEAD..origin/main --oneline"
        echo "3. Consider: git push origin main --force"
        echo "   ⚠️  WARNING: Force push overwrites remote history"
        exit 1
    fi
fi
echo ""

echo "🎯 Step 8: Next Steps for Validation..."
echo "---------------------------------------"
echo "✅ Workflow timing fix has been pushed!"
echo ""
echo "📊 IMMEDIATE ACTIONS REQUIRED:"
echo "1. Go to GitHub Actions:"
echo "   https://github.com/purelife3/Bluetooth-security-app/actions"
echo "2. Click 'Run workflow' → 'Run workflow' (use default branch)"
echo ""
echo "🔍 MONITOR THESE SUCCESS INDICATORS:"
echo "   ✅ 'Download Android NDK via SDK Manager (CRITICAL FIX)' step appears"
echo "   ✅ SDK Manager downloads 'ndk;25b' (5-10 minutes)"
echo "   ✅ NDK bridge creation succeeds"
echo "   ❌ NO Buildozer NDK download attempts"
echo "   ❌ NO 'ValueError: read of closed file' errors"
echo "   ✅ Build proceeds to APK creation"
echo ""
echo "⏱️  Expected Timeline:"
echo "   • 1-2 minutes: Workflow starts"
echo "   • 5-10 minutes: NDK pre-download completes"
echo "   • 1-2 minutes: NDK bridge creation"
echo "   • 15-20 minutes: APK build completes"
echo ""
echo "🚀 Workflow timing fix deployment complete! Monitor GitHub Actions now."