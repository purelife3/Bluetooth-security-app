#!/bin/bash

echo "🔍 Diagnosing Buildozer APK Build Issues"
echo "========================================"

# Check if buildozer is installed
echo "1. Checking Buildozer installation..."
if command -v buildozer &> /dev/null; then
    echo "   ✅ Buildozer is installed"
    buildozer --version
else
    echo "   ❌ Buildozer is NOT installed"
    echo "   Installing buildozer..."
    pip install buildozer cython==0.29.36
fi

# Check Python version
echo ""
echo "2. Checking Python environment..."
python3 --version
pip --version

# Check buildozer.spec
echo ""
echo "3. Checking buildozer.spec..."
if [ -f "buildozer.spec" ]; then
    echo "   ✅ buildozer.spec exists"
    echo "   Checking key settings:"
    grep -E "(title|package.name|requirements|android.arch|android.minapi|android.targetapi)" buildozer.spec
else
    echo "   ❌ buildozer.spec NOT found"
fi

# Check main.py entry point
echo ""
echo "4. Checking main.py..."
if [ -f "main.py" ]; then
    echo "   ✅ main.py exists"
    echo "   First 3 lines:"
    head -3 main.py
else
    echo "   ❌ main.py NOT found"
fi

# Check requirements.txt
echo ""
echo "5. Checking requirements.txt..."
if [ -f "requirements.txt" ]; then
    echo "   ✅ requirements.txt exists"
    cat requirements.txt
else
    echo "   ❌ requirements.txt NOT found"
fi

# Try a simple buildozer command
echo ""
echo "6. Testing Buildozer commands..."
echo "   Running: buildozer android clean"
buildozer android clean 2>&1 | tail -5

echo ""
echo "7. Checking for bin directory..."
if [ -d "bin" ]; then
    echo "   ✅ bin directory exists"
    echo "   Contents:"
    ls -la bin/
else
    echo "   ⚠️  bin directory does not exist (will be created during build)"
fi

echo ""
echo "8. Checking Android SDK/NDK setup..."
if [ -d "$HOME/.buildozer" ]; then
    echo "   ✅ .buildozer directory exists"
    echo "   Android SDK path: $HOME/.buildozer/android/sdk"
    if [ -d "$HOME/.buildozer/android/sdk" ]; then
        echo "   ✅ Android SDK directory exists"
    else
        echo "   ❌ Android SDK directory missing"
    fi
else
    echo "   ❌ .buildozer directory missing"
fi

echo ""
echo "📋 Summary of issues to check:"
echo "1. Buildozer timeout (30 minutes might not be enough for first build)"
echo "2. Missing Android SDK/NDK components"
echo "3. Python dependencies issues"
echo "4. Buildozer configuration problems"
echo ""
echo "🚀 To test build locally (if you have Android SDK setup):"
echo "   buildozer -v android debug"
echo ""
echo "💡 For GitHub Actions, consider:"
echo "   - Increasing timeout to 45-60 minutes"
echo "   - Adding more detailed logging"
echo "   - Checking build logs in .buildozer directory"