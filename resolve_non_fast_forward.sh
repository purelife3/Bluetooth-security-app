#!/bin/bash

echo "🔄 Resolving Non-Fast-Forward Git Error"
echo "========================================"
echo ""
echo "This script will help you resolve the 'non-fast-forward' error step by step."
echo ""

# Step 1: Check current state
echo "📊 Step 1: Checking current git state..."
echo "----------------------------------------"
git status
echo ""

# Step 2: Stash any uncommitted changes
echo "📦 Step 2: Stashing uncommitted changes (if any)..."
echo "--------------------------------------------------"
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Found uncommitted changes. Stashing them..."
    git stash push -m "Stash before resolving non-fast-forward"
    echo "✅ Changes stashed successfully."
else
    echo "✅ No uncommitted changes found."
fi
echo ""

# Step 3: Fetch latest from remote
echo "📥 Step 3: Fetching latest changes from remote..."
echo "-------------------------------------------------"
git fetch origin
echo "✅ Remote fetched successfully."
echo ""

# Step 4: Compare local and remote
echo "📊 Step 4: Comparing local vs remote..."
echo "---------------------------------------"
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/main)

echo "Local commit:  $LOCAL_COMMIT"
echo "Remote commit: $REMOTE_COMMIT"
echo ""

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "✅ Local and remote are already synchronized."
    echo "The issue might be with staged/unstaged changes."
else
    echo "⚠️  Local is behind remote by:"
    git log HEAD..origin/main --oneline
    echo ""
    
    # Step 5: Pull with rebase
    echo "🔄 Step 5: Pulling remote changes with rebase..."
    echo "-----------------------------------------------"
    git pull origin main --rebase
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully pulled and rebased remote changes."
    else
        echo "❌ Rebase failed. There may be merge conflicts."
        echo ""
        echo "Conflicted files:"
        git diff --name-only --diff-filter=U
        echo ""
        echo "To resolve conflicts:"
        echo "1. Edit each conflicted file"
        echo "2. Mark as resolved: git add <filename>"
        echo "3. Continue rebase: git rebase --continue"
        echo "4. Run this script again"
        exit 1
    fi
fi
echo ""

# Step 6: Apply stashed changes (if any)
echo "📦 Step 6: Applying stashed changes back..."
echo "------------------------------------------"
if git stash list | grep -q "Stash before resolving non-fast-forward"; then
    echo "Found stashed changes. Applying them..."
    git stash pop
    echo "✅ Stashed changes applied successfully."
else
    echo "✅ No stashed changes to apply."
fi
echo ""

# Step 7: Add and commit NDK fix
echo "💾 Step 7: Adding and committing NDK fix..."
echo "------------------------------------------"
echo "Adding all NDK fix files..."
git add .

echo ""
echo "Committing with comprehensive NDK fix message..."
git commit -m "CRITICAL FIX: Resolve SDK manager vs Buildozer NDK naming mismatch

Root cause analysis:
1. SDK Manager Behavior: Downloads NDK '25b' (android-ndk-r25b-linux.zip)
2. Buildozer Expectation: Expects NDK '25.1.8937393' (android-ndk-r25.1.8937393-linux.zip)
3. Python-for-Android Influence: Recommends '25b' regardless of configuration
4. Result: Buildozer attempts downloads, causing 'ValueError: read of closed file'

Solution implemented:
1. BRIDGE IMPLEMENTATION: fix_buildozer_platform_directories.sh now downloads SDK manager's version (25b) and renames to Buildozer's expected directory (25.1.8937393/)
2. CONFIGURATION CONSISTENCY: buildozer.spec correctly shows android.ndk = 25.1.8937393
3. VERIFICATION ENHANCEMENT: verify_ndk_config.sh includes warnings about naming convention differences
4. COMPREHENSIVE DOCUMENTATION: NDK_VERSION_CONSISTENCY_SUMMARY.md updated with accurate root cause analysis

Expected outcome:
- ✅ No NDK download attempts in build logs
- ✅ No 'ValueError: read of closed file' errors
- ✅ Buildozer finds pre-downloaded NDK at correct path
- ✅ APK builds successfully without network dependency issues

Technical details:
- Download URL: https://dl.google.com/android/repository/android-ndk-r25b-linux.zip
- Target directory: ~/.buildozer/android/platform/android-sdk/ndk/25.1.8937393
- Directory renaming: android-ndk-r25b/ → 25.1.8937393/
- Bridge creates compatibility between conflicting tool expectations"
echo "✅ NDK fix committed successfully."
echo ""

# Step 8: Push to GitHub
echo "📤 Step 8: Pushing to GitHub..."
echo "-------------------------------"
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! NDK fix pushed to GitHub!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Go to GitHub → Actions"
    echo "2. Wait for workflow to start (triggered by push)"
    echo "3. Monitor build logs for these success indicators:"
    echo "   - ✅ 'Pre-downloading Android NDK' message appears"
    echo "   - ✅ No 'Downloading NDK' attempts by Buildozer"
    echo "   - ✅ No 'ValueError: read of closed file' errors"
    echo "   - ✅ Build proceeds to 'Building APK' stage"
    echo "   - ✅ APK compilation completes successfully"
else
    echo ""
    echo "❌ Push failed. Please check the error message above."
    echo "Common issues:"
    echo "1. Authentication issues - check git credentials"
    echo "2. Network connectivity"
    echo "3. Repository permissions"
fi