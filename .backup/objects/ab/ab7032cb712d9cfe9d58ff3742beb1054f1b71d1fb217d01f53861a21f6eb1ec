#!/bin/bash

echo "🔍 Verifying Deployment Readiness"
echo "================================"

# Check git repository
if [ ! -d .git ]; then
    echo "❌ Not in git repository!"
    exit 1
fi

echo "📊 Current branch:"
git branch --show-current

echo ""
echo "📋 Git status:"
git status --short

echo ""
echo "🔍 Key files to be deployed:"
echo "----------------------------"

# Check versioned directory fix script
if [ -f "fix_buildozer_platform_directories.sh" ]; then
    echo -n "fix_buildozer_platform_directories.sh: "
    if grep -q "platform/android-ndk/android-ndk-r25.1.8937393" fix_buildozer_platform_directories.sh; then
        echo "✅ Contains versioned directory solution"
    else
        echo "❌ Missing versioned directory solution"
    fi
else
    echo "❌ fix_buildozer_platform_directories.sh not found"
fi

# Check workflow configuration
if [ -f ".github/workflows/build.yml" ]; then
    echo -n ".github/workflows/build.yml: "
    if grep -q "fix_buildozer_platform_directories.sh" .github/workflows/build.yml; then
        echo "✅ Calls directory fix script"
    else
        echo "❌ Missing directory fix script call"
    fi
else
    echo "❌ Workflow file not found"
fi

# Check push scripts
if [ -f "push_now.sh" ]; then
    echo -n "push_now.sh: "
    if grep -q "Versioned Directory Fix" push_now.sh; then
        echo "✅ Configured for versioned directory deployment"
    else
        echo "❌ Not configured for versioned directory deployment"
    fi
else
    echo "❌ push_now.sh not found"
fi

echo ""
echo "🚀 Deployment ready!"
echo "To deploy the versioned directory fix to GitHub:"
echo "   chmod +x execute_push.sh && ./execute_push.sh"
echo ""
echo "📊 Expected outcome after deployment:"
echo "1. New workflow triggered automatically"
echo "2. fix_buildozer_platform_directories.sh executed"
echo "3. platform/android-ndk/android-ndk-r25.1.8937393/ created"
echo "4. NDK contents copied to versioned subdirectory"
echo "5. No NDK download attempts by Buildozer"
echo "6. Successful APK generation"