#!/bin/bash

echo "🔍 JAVA COMPATIBILITY FIX GIT STATUS CHECK"
echo "=========================================="

# Check git status
echo ""
echo "📊 Git Status:"
git status

echo ""
echo "📝 Checking workflow files:"
echo "--------------------------"

# Check if build_fixed.yml exists and is tracked
if [ -f ".github/workflows/build_fixed.yml" ]; then
    echo "✅ build_fixed.yml exists"
    
    # Check if it's tracked
    if git ls-files .github/workflows/build_fixed.yml >/dev/null 2>&1; then
        echo "✅ build_fixed.yml is tracked by git"
    else
        echo "⚠️ build_fixed.yml is NOT tracked by git (new file)"
    fi
    
    # Check if it's modified
    if git diff --quiet .github/workflows/build_fixed.yml 2>/dev/null; then
        echo "✅ build_fixed.yml has no uncommitted changes"
    else
        echo "📝 build_fixed.yml has uncommitted changes"
        echo "   Changes:"
        git diff --stat .github/workflows/build_fixed.yml
    fi
else
    echo "❌ build_fixed.yml not found"
fi

echo ""
echo "📝 Checking main workflow file:"
if [ -f ".github/workflows/build.yml" ]; then
    echo "✅ build.yml exists"
    
    # Check if it's modified
    if git diff --quiet .github/workflows/build.yml 2>/dev/null; then
        echo "✅ build.yml has no uncommitted changes"
    else
        echo "📝 build.yml has uncommitted changes"
        echo "   Changes:"
        git diff --stat .github/workflows/build.yml
    fi
fi

echo ""
echo "📋 All modified files:"
git status --porcelain

echo ""
echo "🚀 ACTION REQUIRED:"
echo "------------------"
echo "To deploy Java compatibility fix:"
echo ""
echo "OPTION 1: Replace build.yml with build_fixed.yml"
echo "  1. cp .github/workflows/build_fixed.yml .github/workflows/build.yml"
echo "  2. git add .github/workflows/build.yml"
echo "  3. git commit -m 'Fix Java 17 compatibility issue with Android SDK tools'"
echo "  4. git push origin main"
echo ""
echo "OPTION 2: Keep both files and rename build_fixed.yml to build.yml"
echo "  1. git add .github/workflows/build_fixed.yml"
echo "  2. git mv .github/workflows/build_fixed.yml .github/workflows/build.yml"
echo "  3. git commit -m 'Fix Java 17 compatibility issue with Android SDK tools'"
echo "  4. git push origin main"
echo ""
echo "OPTION 3: Use build_fixed.yml as the active workflow"
echo "  1. git add .github/workflows/build_fixed.yml"
echo "  2. git commit -m 'Fix Java 17 compatibility issue with Android SDK tools'"
echo "  3. git push origin main"
echo "  4. Rename build.yml to build_backup.yml"
echo "  5. Rename build_fixed.yml to build.yml in GitHub UI"