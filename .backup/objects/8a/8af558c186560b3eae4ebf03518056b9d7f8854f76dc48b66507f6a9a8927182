#!/bin/bash

echo "🔍 Quick Git Status Check"
echo "========================"

# Check if we're in git repo
if [ ! -d .git ]; then
    echo "❌ Not in git repository!"
    echo "Please run this from your Bluetooth-security-app directory."
    exit 1
fi

echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Git status (short):"
git status --short

echo ""
echo "🔍 Checking key files:"
echo "---------------------"

# Check workflow file
if [ -f ".github/workflows/build.yml" ]; then
    echo -n "Workflow file: "
    if grep -q "CRITICAL: Create symlinks" .github/workflows/build.yml; then
        echo "✅ Contains symlink fix"
    else
        echo "❌ Missing symlink fix"
    fi
else
    echo "❌ Workflow file not found"
fi

# Check fix_buildozer_config.sh
if [ -f "fix_buildozer_config.sh" ]; then
    echo -n "Fix script: "
    if grep -q "Create symbolic links" fix_buildozer_config.sh; then
        echo "✅ Contains symlink logic"
    else
        echo "❌ Missing symlink logic"
    fi
else
    echo "❌ Fix script not found"
fi

echo ""
echo "🚀 To push changes:"
echo "   chmod +x push_now.sh && ./push_now.sh"