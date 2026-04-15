#!/bin/bash

echo "🔍 Verifying build_fixed.yml structure and critical fixes..."
echo "=========================================================="

# Check file exists
if [ ! -f ".github/workflows/build_fixed.yml" ]; then
    echo "❌ ERROR: build_fixed.yml not found!"
    exit 1
fi

echo "✅ build_fixed.yml exists"

# Check critical sections
echo ""
echo "📋 Checking critical sections..."

# 1. Check Android setup action
echo "1. Android Setup Action Configuration:"
if grep -q "ndk;25.1.8937393" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ NDK version: ndk;25.1.8937393 (correct)"
else
    echo "   ❌ NDK version incorrect or missing"
fi

if grep -q "accept-android-licenses: true" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ License parameter: accept-android-licenses: true (correct)"
else
    echo "   ❌ License parameter incorrect"
fi

if grep -q "cmdline-tools;latest" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ Includes cmdline-tools;latest"
else
    echo "   ❌ Missing cmdline-tools;latest"
fi

if grep -q "build-tools;37.0.0" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ Includes build-tools;37.0.0"
else
    echo "   ❌ Missing build-tools;37.0.0"
fi

# 2. Check sdkmanager symlink section
echo ""
echo "2. sdkmanager Symlink Creation:"
if grep -q "Create sdkmanager symlink for Buildozer" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ sdkmanager symlink section present"
else
    echo "   ❌ sdkmanager symlink section missing"
fi

# 3. Check comprehensive license automation
echo ""
echo "3. Comprehensive License Automation:"
if grep -q "Accept Android SDK licenses comprehensively" ".github/workflows/build_fixed.yml"; then
    echo "   ✅ Comprehensive license section present"
    
    # Count 'y' inputs in the heredoc
    y_count=$(grep -A 50 "cat > /tmp/build_tools_37_license_input.txt" ".github/workflows/build_fixed.yml" | grep -c "^y$" || echo "0")
    echo "   ✅ Found $y_count 'y' inputs in license automation"
else
    echo "   ❌ Comprehensive license section missing"
fi

# 4. Check for remaining ndk;25b references
echo ""
echo "4. Checking for remaining ndk;25b references:"
ndk25b_count=$(grep -c "ndk;25b" ".github/workflows/build_fixed.yml" || echo "0")
if [ "$ndk25b_count" -eq 0 ]; then
    echo "   ✅ No remaining ndk;25b references"
else
    echo "   ⚠️ Found $ndk25b_count ndk;25b references that need fixing"
    grep -n "ndk;25b" ".github/workflows/build_fixed.yml"
fi

# 5. Check Python version
echo ""
echo "5. Python Version Configuration:"
python_version=$(grep -A 2 "python-version:" ".github/workflows/build_fixed.yml" | grep -o "'[0-9.]*'" | tr -d "'" || echo "not found")
echo "   Python version: $python_version"
if [ "$python_version" = "3.12" ]; then
    echo "   ✅ Matches build logs (Python 3.12.13)"
else
    echo "   ⚠️ Python version mismatch with build logs"
fi

echo ""
echo "=========================================================="
echo "📊 Summary:"
echo "The corrected build_fixed.yml should resolve:"
echo "1. NDK download failures (using ndk;25.1.8937393)"
echo "2. License acceptance failures (comprehensive automation)"
echo "3. sdkmanager path errors (symlink creation)"
echo "4. Build-Tools 37 installation (pre-installed via actions/setup-android)"
echo ""
echo "🚀 Next step: Commit and push to trigger GitHub Actions build"