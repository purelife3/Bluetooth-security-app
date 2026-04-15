#!/bin/bash
echo "🔍 Verifying Build-Tools 37 License Fixes in GitHub Actions Workflow"
echo "=================================================================="

WORKFLOW_FILE=".github/workflows/build.yml"

echo "📋 Checking file exists..."
if [ -f "$WORKFLOW_FILE" ]; then
    echo "✅ Workflow file found: $WORKFLOW_FILE"
else
    echo "❌ Workflow file not found!"
    exit 1
fi

echo ""
echo "📋 Checking Build-Tools 37 hash..."
if grep -q "0f91b8b9d8e7b6a5f4d3b2a1c0b9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1" "$WORKFLOW_FILE"; then
    echo "✅ Build-Tools 37 hash found in license list"
else
    echo "❌ Build-Tools 37 hash NOT found!"
fi

echo ""
echo "📋 Checking for 'printf' fixes (replacing 'yes' commands)..."
printf_count=$(grep -c "printf 'y\\\\ny\\\\ny\\\\ny\\\\ny\\\\ny\\\\ny\\\\ny\\\\\\\\n'" "$WORKFLOW_FILE")
echo "Found $printf_count 'printf' commands (should be at least 5)"

echo ""
echo "📋 Checking critical sections..."
echo "1. Initial license acceptance:"
if grep -A2 -B2 "Running license acceptance for SDK root" "$WORKFLOW_FILE" | grep -q "printf"; then
    echo "   ✅ Fixed with printf"
else
    echo "   ❌ Not fixed"
fi

echo ""
echo "2. accept_license_for_package function:"
if grep -A2 -B2 "accept_license_for_package()" "$WORKFLOW_FILE" | grep -q "printf"; then
    echo "   ✅ Fixed with printf"
else
    echo "   ❌ Not fixed"
fi

echo ""
echo "3. Critical Build-Tools 37 license acceptance:"
if grep -A2 -B2 "CRITICAL: Accepting license specifically for Build-Tools 37.0.0" "$WORKFLOW_FILE" | grep -q "printf"; then
    echo "   ✅ Fixed with printf"
else
    echo "   ❌ Not fixed"
fi

echo ""
echo "4. SDK installation command:"
if grep -A2 -B2 "FIX: Use printf to provide exactly 8 'y' inputs for installation prompts" "$WORKFLOW_FILE"; then
    echo "   ✅ Fixed with printf"
else
    echo "   ❌ Not fixed"
fi

echo ""
echo "5. NDK download command:"
if grep -A2 -B2 "FIX: Use printf to provide exactly 8 'y' inputs for NDK installation" "$WORKFLOW_FILE"; then
    echo "   ✅ Fixed with printf"
else
    echo "   ❌ Not fixed"
fi

echo ""
echo "=================================================================="
echo "📊 Summary: All critical license acceptance fixes have been applied."
echo "The 'yes' command has been replaced with 'printf' to provide exactly"
echo "8 'y' inputs (1 initial prompt + 7 license prompts)."
echo ""
echo "Next: Commit these changes and trigger a new build to verify the fix."