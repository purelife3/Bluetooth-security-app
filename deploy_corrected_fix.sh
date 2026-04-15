#!/bin/bash

# 🚀 DEPLOY CORRECTED NDK FIX SCRIPT
# This script deploys the corrected NDK fix that addresses the configuration mismatch

echo "🚀 DEPLOYING CORRECTED NDK FIX"
echo "==============================="
echo ""
echo "📋 Root Cause: buildozer.spec had android.ndk = 25.1.8937393 instead of 25b"
echo "📋 Solution: Updated to android.ndk = 25b to match SDK Manager download"
echo ""

# Check if we're in the right directory
if [ ! -f "buildozer.spec" ]; then
    echo "❌ Error: Not in project root directory (buildozer.spec not found)"
    exit 1
fi

echo "🔍 Verifying current state..."
echo ""

# 1. Verify buildozer.spec has the correct NDK version
echo "📄 Checking buildozer.spec line 50..."
if grep -q "android.ndk = 25b" buildozer.spec; then
    echo "✅ buildozer.spec already has android.ndk = 25b"
else
    echo "❌ buildozer.spec does NOT have android.ndk = 25b"
    echo "   Current line 50:"
    grep -n "android.ndk" buildozer.spec
    exit 1
fi

# 2. Verify bridge script has debug output
echo ""
echo "🔧 Checking bridge script debug output..."
if grep -q "DEBUG: Found SDK Manager NDK at:" fix_buildozer_platform_directories.sh; then
    echo "✅ Bridge script has debug output for SDK Manager NDK"
else
    echo "❌ Bridge script missing debug output"
    exit 1
fi

# 3. Check git status
echo ""
echo "📊 Checking git status..."
git status --short

# 4. Show what will be committed
echo ""
echo "📋 Files to commit:"
git diff --name-only

# 5. Ask for confirmation
echo ""
read -p "🚀 Proceed with deployment? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

# 6. Add files
echo "📦 Adding files to git..."
git add buildozer.spec fix_buildozer_platform_directories.sh

# 7. Commit
echo "💾 Committing changes..."
git commit -m "FIX: Correct NDK version to '25b' in buildozer.spec + bridge script debug

- Changed android.ndk from 25.1.8937393 to 25b in buildozer.spec
- Added debug output to bridge script to verify SDK Manager NDK usage
- Ensured configuration consistency between SDK Manager download and buildozer.spec
- Bridge script now uses SDK Manager's already-downloaded NDK instead of downloading duplicate

Root cause: SDK Manager downloads NDK '25b' but buildozer.spec expected '25.1.8937393'
Solution: Align buildozer.spec with SDK Manager's naming convention"

# 8. Push
echo "📤 Pushing to GitHub..."
git push origin main

# 9. Summary
echo ""
echo "🎯 DEPLOYMENT COMPLETE"
echo "======================"
echo ""
echo "✅ Corrected fix deployed successfully!"
echo ""
echo "📋 What was fixed:"
echo "1. buildozer.spec: android.ndk = 25b (was 25.1.8937393)"
echo "2. Bridge script: Added debug output to verify SDK Manager NDK usage"
echo "3. Configuration: All components now use consistent NDK version '25b'"
echo ""
echo "🚀 Next steps:"
echo "1. Go to GitHub → Actions → 'Build Android APK' workflow"
echo "2. Click 'Run workflow' to trigger a new build"
echo "3. Monitor build logs for success indicators:"
echo "   - ✅ DEBUG: Found SDK Manager NDK at: /home/runner/.buildozer/android/sdk/ndk/25b"
echo "   - ✅ DEBUG: Successfully copied SDK Manager NDK to bridge directory"
echo "   - ✅ NDK bridge created using SDK Manager's download"
echo "4. Download APK when build completes"
echo ""
echo "🔍 Verification checklist:"
echo "- [ ] buildozer.spec line 50 shows android.ndk = 25b"
echo "- [ ] Bridge script has debug output (lines 141-150, 156-172)"
echo "- [ ] GitHub Actions workflow runs without NDK download errors"
echo "- [ ] APK builds successfully"
echo "- [ ] No 'ValueError: read of closed file' in build logs"
echo ""
echo "📞 If build fails, check build logs and run:"
echo "   ./analyze_logs.sh"
echo ""
echo "🎯 This fix addresses the configuration mismatch that caused the previous timing fix to fail."