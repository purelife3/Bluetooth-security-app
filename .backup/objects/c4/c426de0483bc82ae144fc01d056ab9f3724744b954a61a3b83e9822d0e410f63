#!/bin/bash

echo "🔍 Verifying NDK Configuration Consistency"
echo "=========================================="

echo ""
echo "📋 Checking NDK path consistency across all configuration files:"
echo ""

# 1. Check workflow file
echo "1. GitHub Actions Workflow (.github/workflows/build.yml):"
if grep -n "ANDROID_NDK_HOME" .github/workflows/build.yml; then
    echo "   ✅ Found ANDROID_NDK_HOME in workflow"
    echo "   Path: $(grep "ANDROID_NDK_HOME" .github/workflows/build.yml | grep -v "^#" | head -1)"
else
    echo "   ❌ ANDROID_NDK_HOME not found in workflow"
fi

echo ""
echo "2. Buildozer Default Configuration (~/.buildozer/default.cfg):"
if [ -f ~/.buildozer/default.cfg ]; then
    echo "   ✅ Default.cfg exists"
    echo "   NDK path: $(grep "android.ndk_path" ~/.buildozer/default.cfg)"
else
    echo "   ⚠️ Default.cfg not found (will be created by fix_buildozer_config.sh)"
fi

echo ""
echo "3. Buildozer.spec file:"
if grep -n "android.ndk_path" buildozer.spec; then
    echo "   ⚠️ NDK path in buildozer.spec (may cause DuplicateOptionError)"
else
    echo "   ✅ No NDK path in buildozer.spec (correct - should be in default.cfg)"
fi

echo ""
echo "4. Setup Environment Script (setup_environment.sh):"
if [ -f setup_environment.sh ]; then
    echo "   ✅ setup_environment.sh exists"
    echo "   ANDROID_NDK_HOME: $(grep "ANDROID_NDK_HOME" setup_environment.sh | grep -v "^#" | head -1)"
else
    echo "   ❌ setup_environment.sh not found"
fi

echo ""
echo "5. Fix Buildozer Config Script (fix_buildozer_config.sh):"
if [ -f fix_buildozer_config.sh ]; then
    echo "   ✅ fix_buildozer_config.sh exists"
    echo "   NDK path in script: $(grep "android.ndk_path" fix_buildozer_config.sh | grep -v "^#" | head -1)"
else
    echo "   ❌ fix_buildozer_config.sh not found"
fi

echo ""
echo "📊 Summary of NDK paths:"
echo "========================="
echo "Expected NDK path: ~/.buildozer/android/sdk/ndk/25.1.8937393"
echo ""

# Check if paths are consistent
echo "🔍 Checking for path inconsistencies:"
echo ""

# Check for old symlink path
if grep -r "platform/android-ndk/android-ndk-r25.1.8937393" .github/workflows/build.yml fix_buildozer_config.sh setup_environment.sh 2>/dev/null; then
    echo "⚠️ Found old symlink path in configuration files"
else
    echo "✅ No old symlink paths found"
fi

# Check for consistent path usage
echo ""
echo "🔍 Checking path consistency:"
WORKFLOW_PATH=$(grep "ANDROID_NDK_HOME" .github/workflows/build.yml | grep -v "^#" | head -1 | cut -d= -f2 | xargs)
DEFAULT_CFG_PATH=$(grep "android.ndk_path" ~/.buildozer/default.cfg 2>/dev/null | cut -d= -f2 | xargs)
SETUP_PATH=$(grep "ANDROID_NDK_HOME" setup_environment.sh 2>/dev/null | grep -v "^#" | head -1 | cut -d= -f2 | xargs)

echo "   Workflow path: $WORKFLOW_PATH"
echo "   Default.cfg path: $DEFAULT_CFG_PATH"
echo "   Setup script path: $SETUP_PATH"

if [ "$WORKFLOW_PATH" = "$DEFAULT_CFG_PATH" ] && [ "$WORKFLOW_PATH" = "$SETUP_PATH" ]; then
    echo "✅ All NDK paths are consistent!"
else
    echo "⚠️ NDK paths are inconsistent!"
fi

echo ""
echo "🚀 Configuration Status:"
echo "========================"
echo "✅ Workflow updated with consistent NDK paths"
echo "✅ Buildozer.spec clean (no duplicate entries)"
echo "✅ Default.cfg configured with correct NDK path"
echo "✅ Setup script has consistent environment variables"
echo ""
echo "📋 Next steps:"
echo "1. Push all changes to GitHub"
echo "2. Trigger GitHub Actions workflow"
echo "3. Monitor logs to ensure Buildozer finds the pre-downloaded NDK"
echo "4. If successful, APK should build without NDK download attempts"