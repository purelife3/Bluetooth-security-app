#!/bin/bash

echo "🔍 Verifying What Will Be Pushed"
echo "================================"

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Not in a git repository!"
    exit 1
fi

echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Files that will be committed:"
echo "================================"
git status --porcelain

echo ""
echo "🔍 Checking key files for symlink solution:"
echo "=========================================="

# Check workflow file for symlink lines
echo ""
echo "📄 .github/workflows/build.yml (symlink section):"
if grep -n "CRITICAL: Create symlinks" .github/workflows/build.yml; then
    echo "✅ Symlink section found in workflow"
    echo "   Lines 242-257 contain symlink creation logic"
else
    echo "❌ Symlink section NOT found in workflow"
fi

# Check fix_buildozer_config.sh for symlink logic
echo ""
echo "📄 fix_buildozer_config.sh (symlink logic):"
if grep -n "Create symlinks" fix_buildozer_config.sh; then
    echo "✅ Symlink logic found in fix_buildozer_config.sh"
    echo "   Lines 101-117 contain symlink creation"
else
    echo "❌ Symlink logic NOT found in fix_buildozer_config.sh"
fi

echo ""
echo "📊 Summary of changes to be pushed:"
echo "==================================="
echo "Total files: $(git status --porcelain | wc -l)"
echo "Modified: $(git status --porcelain | grep -E '^M' | wc -l)"
echo "Added: $(git status --porcelain | grep -E '^A' | wc -l)"
echo "Untracked: $(git status --porcelain | grep -E '^\?' | wc -l)"

echo ""
echo "💡 To push these changes, run:"
echo "   chmod +x push_now.sh && ./push_now.sh"
echo ""
echo "📋 Or manually:"
echo "   1. git add ."
echo "   2. git commit -m 'Fix: Symlink solution for Buildozer platform directory issue'"
echo "   3. git push origin main"