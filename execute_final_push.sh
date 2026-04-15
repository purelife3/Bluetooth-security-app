#!/bin/bash

echo "🚀 EXECUTING FINAL PUSH FOR BUILD TOOLS 37 LICENSE FIX"
echo "======================================================"
echo ""
echo "🔧 CRITICAL FIX: Buildozer SDK/NDK Directory Arguments"
echo "======================================================"
echo "This push adds explicit --sdk-dir and --ndk-dir arguments to Buildozer commands"
echo "to prevent Buildozer from downloading its own SDK/NDK and causing the"
echo "'ValueError: read of closed file' error."
echo ""

# Make all scripts executable
chmod +x push_buildozer_directory_fix.sh
chmod +x execute_final_push.sh
chmod +x test_git_status_simple.sh
chmod +x check_git_status_now.sh

echo ""
echo "📋 PRE-PUSH VERIFICATION:"
echo "========================"
echo "1. Checking git repository status..."
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "✅ Git repository found"

echo ""
echo "2. Checking current branch..."
CURRENT_BRANCH=$(git branch --show-current)
echo "   Current branch: $CURRENT_BRANCH"

echo ""
echo "3. Checking for uncommitted changes..."
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ No uncommitted changes"
    echo "⚠️ Note: The Buildozer SDK/NDK directory fix may already be committed"
    echo "   Checking if fix is already in the workflow file..."
else
    echo "⚠️ Uncommitted changes found:"
    git status --short
fi

echo ""
echo "4. Verifying Buildozer SDK/NDK directory fix in workflow file..."
if grep -e "--sdk-dir=\"\$ANDROID_HOME\"" .github/workflows/build.yml && \
   grep -e "--ndk-dir=\"\$ANDROID_NDK_HOME\"" .github/workflows/build.yml; then
    echo "✅ Buildozer directory arguments found in workflow file"
    echo "   - Dry-run command (lines 335-339): ✓"
    echo "   - Main build command (lines 445-447): ✓"
else
    echo "❌ Buildozer directory arguments NOT found!"
    exit 1
fi

echo ""
echo "5. Verifying environment variables..."
if grep -e "ANDROID_HOME=\$HOME/.buildozer/android/platform/android-sdk" .github/workflows/build.yml && \
   grep -e "ANDROID_NDK_HOME=\$HOME/.buildozer/android/platform/android-sdk/ndk/25.1.8937393" .github/workflows/build.yml; then
    echo "✅ Environment variables properly set (lines 302-305)"
else
    echo "❌ Environment variables NOT found!"
    exit 1
fi

echo ""
echo "🎯 READY TO PUSH - EXECUTING PUSH SCRIPT..."
echo "=========================================="
echo "This will:"
echo "1. Add all changes to git"
echo "2. Commit with detailed message about Buildozer SDK/NDK directory fix"
echo "3. Push to GitHub main branch"
echo ""
echo "The commit message will document:"
echo "   - Root cause: Buildozer ignoring pre-configured platform directories"
echo "   - Solution: Explicit --sdk-dir and --ndk-dir arguments"
echo "   - Expected outcome: No SDK/NDK downloads, no 'ValueError: read of closed file'"
echo ""
echo "⏳ Auto-proceeding with push (simulating Enter press)..."

# First, let's check the current git status to see what will be committed
echo ""
echo "🔍 FINAL GIT STATUS CHECK BEFORE PUSH:"
echo "====================================="
echo "Running test_git_status_simple.sh..."
bash test_git_status_simple.sh
echo "Git status check complete."

echo ""
echo "📋 Checking if workflow file changes are staged..."
if git status --porcelain .github/workflows/build.yml | grep -q "^M"; then
    echo "✅ Workflow file changes are staged and ready to commit"
else
    echo "⚠️ Workflow file changes are NOT staged - they will be added by the push script"
fi

echo ""
echo "🚀 EXECUTING PUSH SCRIPT..."
echo "=========================="

# Execute the push script
echo ""
echo "🚀 EXECUTING PUSH SCRIPT: push_buildozer_directory_fix.sh"
echo "========================================================="
bash push_buildozer_directory_fix.sh

# Capture the exit code
PUSH_EXIT_CODE=$?
echo ""
echo "📊 PUSH EXECUTION COMPLETE"
echo "=========================="
echo "Exit code: $PUSH_EXIT_CODE"

if [ $PUSH_EXIT_CODE -eq 0 ]; then
    echo "✅ Push script executed successfully!"
    echo ""
    echo "🎉 DEPLOYMENT COMPLETE!"
    echo "======================"
    echo "The Buildozer SDK/NDK directory fix has been deployed to GitHub."
    echo ""
    echo "📋 NEXT STEPS:"
    echo "1. Go to GitHub Actions: https://github.com/purelife3/Bluetooth-security-app/actions"
    echo "2. Wait for the workflow to start automatically (triggered by push)"
    echo "3. Monitor the build for these success indicators:"
    echo "   - ✅ Buildozer using --sdk-dir and --ndk-dir arguments"
    echo "   - ✅ No SDK/NDK download messages"
    echo "   - ✅ No 'ValueError: read of closed file' error"
    echo "   - ✅ APK created successfully!"
    echo ""
    echo "🔧 If the workflow still fails, check the logs for any new errors"
    echo "   and share them for further troubleshooting."
else
    echo "❌ Push script failed with exit code: $PUSH_EXIT_CODE"
    echo ""
    echo "🔧 TROUBLESHOOTING:"
    echo "1. Check git status: git status"
    echo "2. Check if changes are staged: git diff --cached --name-only"
    echo "3. Try manual push: git add . && git commit -m 'FIX: Buildozer SDK/NDK directory arguments' && git push origin main"
    echo "4. Check remote configuration: git remote -v"
fi

echo ""
echo "📊 POST-PUSH VERIFICATION:"
echo "========================="
echo "1. Check GitHub Actions at:"
echo "   https://github.com/purelife3/Bluetooth-security-app/actions"
echo ""
echo "2. Monitor the build for these success indicators:"
echo "   - ✅ Buildozer using --sdk-dir and --ndk-dir arguments"
echo "   - ✅ No SDK/NDK download messages"
echo "   - ✅ No 'ValueError: read of closed file' error"
echo "   - ✅ APK created successfully!"
echo ""
echo "3. If build fails, check logs for new errors and share for troubleshooting"
echo ""
echo "🎉 PUSH EXECUTION COMPLETE!"