#!/bin/bash

echo "🔄 Resolving Untracked File Conflict"
echo "====================================="
echo ""
echo "Issue: NDK_VERSION_CONSISTENCY_SUMMARY.md exists remotely but isn't tracked locally."
echo ""

# Step 1: Backup the local file
echo "📦 Step 1: Backing up local NDK_VERSION_CONSISTENCY_SUMMARY.md..."
if [ -f "NDK_VERSION_CONSISTENCY_SUMMARY.md" ]; then
    cp NDK_VERSION_CONSISTENCY_SUMMARY.md NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup
    echo "✅ Local file backed up as NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup"
else
    echo "⚠️  Local file doesn't exist"
fi
echo ""

# Step 2: Remove the untracked file
echo "🗑️  Step 2: Removing untracked NDK_VERSION_CONSISTENCY_SUMMARY.md..."
rm -f NDK_VERSION_CONSISTENCY_SUMMARY.md
echo "✅ File removed"
echo ""

# Step 3: Pull remote changes
echo "📥 Step 3: Pulling remote changes..."
git pull origin main --rebase

if [ $? -eq 0 ]; then
    echo "✅ Successfully pulled remote changes"
    echo ""
    
    # Step 4: Compare local backup with remote version
    echo "🔍 Step 4: Comparing local backup with remote version..."
    if [ -f "NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup" ] && [ -f "NDK_VERSION_CONSISTENCY_SUMMARY.md" ]; then
        echo "Both files exist. Checking for differences..."
        if diff -q NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup NDK_VERSION_CONSISTENCY_SUMMARY.md > /dev/null; then
            echo "✅ Files are identical. No merge needed."
            rm NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup
        else
            echo "⚠️  Files differ. You may need to merge manually."
            echo ""
            echo "To compare:"
            echo "  diff NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup NDK_VERSION_CONSISTENCY_SUMMARY.md"
            echo ""
            echo "To keep remote version:"
            echo "  rm NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup"
            echo ""
            echo "To keep local version:"
            echo "  cp NDK_VERSION_CONSISTENCY_SUMMARY.md.local_backup NDK_VERSION_CONSISTENCY_SUMMARY.md"
            echo "  git add NDK_VERSION_CONSISTENCY_SUMMARY.md"
        fi
    elif [ -f "NDK_VERSION_CONSISTENCY_SUMMARY.md" ]; then
        echo "✅ Remote file pulled successfully"
    fi
else
    echo "❌ Pull failed. There may be other conflicts."
    echo ""
    echo "Checking git status..."
    git status
    exit 1
fi
echo ""

# Step 5: Add all NDK fix files
echo "➕ Step 5: Adding all NDK fix files..."
git add .
echo "✅ Files added"
echo ""

# Step 6: Check if we need to commit
echo "💾 Step 6: Checking if commit is needed..."
if ! git diff --cached --quiet; then
    echo "Committing NDK fix..."
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
    echo "✅ NDK fix committed"
else
    echo "⚠️  No changes to commit (files already committed)"
fi
echo ""

# Step 7: Push to GitHub
echo "📤 Step 7: Pushing to GitHub..."
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
    echo "You may need to force push (use with caution):"
    echo "  git push origin main --force"
fi