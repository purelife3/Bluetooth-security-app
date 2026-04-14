#!/bin/bash

echo "🚀 Pushing Platform Directory Fix to GitHub"
echo "=========================================="
echo ""
echo "This script will push the refined solution for Buildozer's platform directory issue."
echo "The fix replaces symlinks with actual directories containing SDK/NDK contents."
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not a git repository"
    exit 1
fi

# Check git status
echo "📋 Checking git status..."
git status

# Add the new files
echo "📁 Adding new files..."
git add fix_buildozer_platform_directories.sh
git add .github/workflows/build.yml
git add push_platform_directory_fix.sh

# Also add any other modified files
git add -u

# Check what's being committed
echo "📋 Files to commit:"
git status --porcelain

# Create commit message
COMMIT_MESSAGE="Fix: Replace symlinks with actual platform directories for Buildozer

Root cause analysis:
- Buildozer checks platform/android-sdk as a directory (not symlink)
- Symlinks don't work because Buildozer uses os.path.isdir() checks
- When Buildozer finds missing directories, it creates them and attempts downloads
- This triggers the 'ValueError: read of closed file' error during NDK download

Solution implemented:
1. Created fix_buildozer_platform_directories.sh script
   - Creates platform/android-sdk as actual directory with SDK contents
   - Creates platform/android-ndk as actual directory with NDK contents
   - Removes existing symlinks and directories first
   - Verifies directory creation and contents

2. Updated GitHub Actions workflow
   - Added call to fix_buildozer_platform_directories.sh (lines 238-241)
   - Removed duplicate inline directory creation logic (28 lines)
   - Maintains existing configuration fixes (fix_buildozer_config.sh, test_buildozer_config.sh)

3. Directory-based approach addresses root cause
   - Buildozer sees platform/android-sdk and platform/android-ndk as directories
   - No SDK/NDK download attempts by Buildozer
   - Eliminates 'ValueError: read of closed file' errors

Expected outcome:
- Buildozer will find platform/android-sdk and platform/android-ndk as directories
- No SDK/NDK download attempts by Buildozer
- No 'ValueError: read of closed file' errors
- Successful APK generation in GitHub Actions"

echo ""
echo "📝 Commit message:"
echo "=================="
echo "$COMMIT_MESSAGE"
echo "=================="
echo ""

# Ask for confirmation
read -p "Continue with commit and push? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled"
    exit 1
fi

# Commit changes
echo "💾 Committing changes..."
git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo "❌ Commit failed"
    exit 1
fi

echo "✅ Changes committed"

# Push to GitHub
echo "📤 Pushing to GitHub..."
git push origin main

if [ $? -ne 0 ]; then
    echo "❌ Push failed"
    echo "⚠️ Trying alternative branch name..."
    git push origin master
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Successfully pushed platform directory fix to GitHub!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Go to GitHub repository: https://github.com/[your-username]/[your-repo]"
    echo "2. Check the Actions tab"
    echo "3. The workflow should run automatically"
    echo "4. Monitor for successful APK generation"
    echo ""
    echo "🔍 Expected improvements:"
    echo "   - No 'Android SDK is missing, downloading' messages"
    echo "   - No 'ValueError: read of closed file' errors"
    echo "   - Longer build time (30-45 minutes for first build)"
    echo "   - APK file generated in bin/ directory"
    echo ""
    echo "⚠️ Important: This is phase 23 of troubleshooting"
    echo "   Previous symlink solution didn't work due to Buildozer's directory checking"
    echo "   This directory-based approach addresses the root cause"
else
    echo "❌ Push failed completely"
    echo "⚠️ Check your git remote configuration and permissions"
fi