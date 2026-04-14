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

# Check versioned directory fix script
if [ -f "fix_buildozer_platform_directories.sh" ]; then
    echo -n "Versioned directory fix script: "
    if grep -q "platform/android-ndk/android-ndk-r25.1.8937393" fix_buildozer_platform_directories.sh; then
        echo "✅ Contains versioned directory solution"
    else
        echo "❌ Missing versioned directory solution"
    fi
else
    echo "❌ Versioned directory fix script not found"
fi

# Check workflow file
if [ -f ".github/workflows/build.yml" ]; then
    echo -n "Workflow file: "
    if grep -q "fix_buildozer_platform_directories.sh" .github/workflows/build.yml; then
        echo "✅ Calls directory fix script"
    else
        echo "❌ Missing directory fix script call"
    fi
else
    echo "❌ Workflow file not found"
fi

echo ""
echo "🚀 To push versioned directory fix:"
echo "   chmod +x execute_push.sh && ./execute_push.sh"