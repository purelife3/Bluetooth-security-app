#!/bin/bash

echo "🔍 Verifying Path Consistency in GitHub Actions Workflow"
echo "=========================================================="

WORKFLOW_FILE=".github/workflows/build.yml"

echo "📋 Checking workflow file: $WORKFLOW_FILE"
echo ""

# Count tilde references
echo "1. Checking for tilde (~) references (should be 0):"
TILDE_COUNT=$(grep -n "~/" "$WORKFLOW_FILE" | wc -l)
if [ "$TILDE_COUNT" -eq 0 ]; then
    echo "   ✅ No tilde references found"
else
    echo "   ❌ Found $TILDE_COUNT tilde references:"
    grep -n "~/" "$WORKFLOW_FILE"
fi
echo ""

# Count $HOME references
echo "2. Checking for \$HOME references (should be many):"
HOME_COUNT=$(grep -n "\$HOME" "$WORKFLOW_FILE" | wc -l)
echo "   ✅ Found $HOME_COUNT \$HOME references"
echo ""

# Check temporary variable definitions
echo "3. Verifying temporary variable definitions (lines 124-129):"
echo "   Checking ANDROID_HOME_TEMP..."
grep -n "ANDROID_HOME_TEMP=\$HOME" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_SDK_ROOT_TEMP..."
grep -n "ANDROID_SDK_ROOT_TEMP=\$HOME" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_NDK_HOME_TEMP..."
grep -n "ANDROID_NDK_HOME_TEMP=\$HOME" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_NDK_ROOT_TEMP..."
grep -n "ANDROID_NDK_ROOT_TEMP=\$HOME" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking PATH_TEMP..."
grep -n "PATH_TEMP=\$PATH:\$HOME" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"
echo ""

# Check platform directory variables
echo "4. Verifying platform directory variables (lines 257-260, 271-275):"
echo "   Checking ANDROID_HOME (platform)..."
grep -n "ANDROID_HOME=\$HOME/.buildozer/android/platform/android-sdk" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_SDK_ROOT (platform)..."
grep -n "ANDROID_SDK_ROOT=\$HOME/.buildozer/android/platform/android-sdk" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_NDK_HOME (platform)..."
grep -n "ANDROID_NDK_HOME=\$HOME/.buildozer/android/platform/android-ndk/android-ndk-r25.1.8937393" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking ANDROID_NDK_ROOT (platform)..."
grep -n "ANDROID_NDK_ROOT=\$HOME/.buildozer/android/platform/android-ndk/android-ndk-r25.1.8937393" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"
echo ""

# Check SDK installation commands
echo "5. Verifying SDK installation commands use \$HOME:"
echo "   Checking SDK license acceptance (line 133)..."
grep -n "yes | \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager --licenses" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking SDK package installation (line 141)..."
grep -n "\$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager" "$WORKFLOW_FILE" | head -1 && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking NDK directory creation (line 156)..."
grep -n "mkdir -p \$HOME/.buildozer/android/sdk/ndk/25.1.8937393" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking sdkmanager availability check (line 167)..."
grep -n "if \[ ! -f \$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager \]" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"

echo "   Checking NDK download command (line 176)..."
grep -n "\$HOME/.buildozer/android/sdk/cmdline-tools/latest/bin/sdkmanager \"ndk;25.1.8937393\"" "$WORKFLOW_FILE" && echo "   ✅ Correct" || echo "   ❌ Missing or incorrect"
echo ""

# Check for mixed references
echo "6. Checking for mixed path reference styles:"
MIXED_COUNT=$(grep -n -E "(~/\$HOME|\$HOME/~)" "$WORKFLOW_FILE" | wc -l)
if [ "$MIXED_COUNT" -eq 0 ]; then
    echo "   ✅ No mixed path reference styles found"
else
    echo "   ❌ Found $MIXED_COUNT mixed path references:"
    grep -n -E "(~/\$HOME|\$HOME/~)" "$WORKFLOW_FILE"
fi
echo ""

# Summary
echo "📊 SUMMARY"
echo "=========="
echo "Total tilde (~) references: $TILDE_COUNT (should be 0)"
echo "Total \$HOME references: $HOME_COUNT (should be many)"
echo "Mixed reference styles: $MIXED_COUNT (should be 0)"
echo ""

if [ "$TILDE_COUNT" -eq 0 ] && [ "$MIXED_COUNT" -eq 0 ] && [ "$HOME_COUNT" -gt 0 ]; then
    echo "🎉 PATH CONSISTENCY VERIFICATION PASSED!"
    echo "✅ All path references use \$HOME consistently"
    echo "✅ No tilde expansion issues"
    echo "✅ No mixed reference styles"
    echo "✅ Ready for GitHub Actions execution"
else
    echo "⚠️ PATH CONSISTENCY ISSUES DETECTED!"
    echo "❌ Please review the issues above"
    exit 1
fi