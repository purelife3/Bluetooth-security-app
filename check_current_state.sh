#!/bin/bash

echo "🔍 CHECKING CURRENT GIT STATE AFTER CONTINUE_NDK_FIX_PUSH.SH"
echo "============================================================"
echo ""

echo "📊 1. Git Status:"
echo "----------------"
git status
echo ""

echo "📋 2. Git Log (last 3 commits):"
echo "-------------------------------"
git log --oneline -3
echo ""

echo "🔗 3. Git Remote Status:"
echo "------------------------"
git remote -v
echo ""

echo "📁 4. Checking for conflict markers:"
echo "------------------------------------"
if grep -q "<<<<<<<" fix_buildozer_platform_directories.sh; then
    echo "❌ Conflict markers still present!"
    grep -n "<<<<<<<" fix_buildozer_platform_directories.sh
else
    echo "✅ No conflict markers found"
fi
echo ""

echo "🔧 5. Checking NDK bridge fix integrity:"
echo "----------------------------------------"
if grep -q "CRITICAL FIX: SDK manager installs \"25b\" but Buildozer expects \"25.1.8937393\"" fix_buildozer_platform_directories.sh; then
    echo "✅ NDK bridge fix is intact"
    echo "   Line numbers:"
    grep -n "CRITICAL FIX: SDK manager" fix_buildozer_platform_directories.sh
else
    echo "❌ NDK bridge fix NOT found!"
fi
echo ""

echo "📦 6. Checking stash status:"
echo "----------------------------"
git stash list
echo ""

echo "🚀 7. Ready for push? Checking uncommitted changes:"
echo "---------------------------------------------------"
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ No uncommitted changes - ready to push!"
else
    echo "❌ There are uncommitted changes:"
    git status --porcelain
fi
echo ""

echo "📤 8. Push readiness summary:"
echo "-----------------------------"
echo "If all checks pass, you can push with:"
echo "  git push origin main"
echo ""
echo "If push fails, try:"
echo "  git push origin main --force-with-lease"
echo ""
echo "Then monitor GitHub Actions at:"
echo "  https://github.com/purelife3/Bluetooth-security-app/actions"